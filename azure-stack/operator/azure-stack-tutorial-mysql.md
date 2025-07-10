---
title: Create highly available MySQL databases
description: Learn how to create a MySQL Server resource provider host computer and highly available MySQL databases with Azure Stack Hub.
author: sethmanheim
ms.topic: how-to
ms.date: 01/16/2025
ms.author: sethm
ms.lastreviewed: 10/23/2019

# Intent: As an Azure Stack operator, I want to learn how to create highly available MySQL databases
# Keyword: create mysql database azure stack

---

# Create highly available MySQL databases

[!INCLUDE [preview-banner](../includes/sql-mysql-rp-limit-access.md)]

As an Azure Stack Hub operator, you can configure server virtual machines (VMs) to host MySQL Server databases. After a MySQL cluster is successfully created and managed by Azure Stack Hub, users who have subscribed to MySQL services can easily create highly available MySQL databases.

This article shows how to use Azure Stack Marketplace items to create a [MySQL with replication cluster](https://azuremarketplace.microsoft.com/marketplace/apps?search=mysql%20bitnami&page=1). This solution uses multiple VMs to replicate the databases from the control plane node to a configurable number of replicas. Once created, the cluster can then be added as an Azure Stack Hub MySQL Hosting Server, and then users can create highly available MySQL databases.

> [!IMPORTANT]
> The **MySQL with replication** Azure Stack Marketplace item might not be available for all Azure cloud subscription environments. Verify that the marketplace item is available in your subscription before attempting to follow the rest of this tutorial.

What you'll learn:

> [!div class="checklist"]
> - Create a MySQL Server cluster from marketplace items.
> - Configure the MySQL Server cluster as an Azure Stack Hub MySQL Hosting Server.
> - Create a highly available MySQL database.

A three-VM MySQL Server cluster is created and configured using available Azure Stack Marketplace items.

Before you begin, ensure that the [MySQL Server resource provider](azure-stack-mysql-resource-provider-deploy.md) was successfully installed and that the following items are available in the Azure Stack Marketplace. All of the following items are required to create the MySQL cluster:

- [MySQL with Replication](https://azuremarketplace.microsoft.com/marketplace/apps?search=mysql%20bitnami&page=1): This is the Bitnami solution template that's used for the MySQL cluster deployment.
- [Debian 8 "Jessie"](https://azuremarketplace.microsoft.com/marketplace/apps/cloud-infrastructure-services.debian-10?tab=overview): Debian 8 "Jessie" with backports kernel for Microsoft Azure provided by credativ. Debian GNU/Linux is one of the most popular Linux distributions.
- Custom script for linux 2.0: Custom Script Extension is a tool to execute your VM customization tasks post VM provision. When this Extension is added to a VM, it can download scripts from Azure storage and run them on the VM. Custom Script Extension tasks can also be automated using the Azure PowerShell cmdlets and Azure Cross-Platform Command-Line Interface (xPlat CLI).
- VM Access For Linux Extension 1.4.7: The VM Access extension enables you to reset the password, SSH key, or the SSH configurations so you can regain access to your VM. You can also add a new user with password or SSH key, or delete a user using this extension. This extension targets Linux VMs.

To learn more about adding items to Azure Stack Marketplace, see the [Azure Stack Marketplace overview](azure-stack-marketplace.md).

You also need an SSH client such as [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html) to log in to the Linux VMs after they're deployed.

## Create a MySQL Server cluster

Use the steps in this section to deploy the MySQL Server cluster using the [MySQL with Replication](https://azuremarketplace.microsoft.com/marketplace/apps?search=mysql%20bitnami&page=1) marketplace item. This template deploys three MySQL Server instances configured in a highly available MySQL cluster. By default, it creates the following resources:

- A virtual network
- A network security group
- A storage account
- An availability set
- Three network interfaces (one for each of the default VMs)
- A public IP address (for the primary MySQL cluster VM)
- Three Linux VMs to host the MySQL cluster

1. Sign in to the user portal: for an integrated system deployment, the portal address varies based on your solution's region and external domain name. It's in the format of `https://portal.<region>.<FQDN>`.

1. If no subscriptions were assigned yet, select **Get a Subscription** from the Dashboard. In the blade, type a name for the subscription, and then select an offer. It is recommended that you keep the MySQL cluster deployment in its own subscription to prevent accidental removal.

1. Select **\+** **Create a resource** > **Compute**, and then **MySQL with Replication**.

   ![Custom template deployment in Azure Stack Hub](media/azure-stack-tutorial-mysqlrp/img1.png)

1. Provide basic deployment information on the **Basics** page. Review the default values and change as needed and select **OK**.

    At a minimum, provide the following info:

   - Deployment name (default is mymysql).
   - Application root password. Provide a 12 character alphanumeric password with **no special characters**.
   - Application database name (default is bitnami).
   - Number of MySQL database replica VMs to create (default is 2).
   - Select the subscription to use.
   - Select the resource group to use or create a new one.
   - Select the location (default is local for ASDK before version 2107).

     ![Deployment basics -- Create MySQL with Replication](media/azure-stack-tutorial-mysqlrp/img2.png)

1. On the **Environment Configuration** page, provide the following information and then select **OK**:

   - Password or SSH public key to use for secure shell (SSH) authentication. If using a password, it must contain letters, numbers, and **can** contain special characters.
   - VM size (default is Standard D1 v2 VMs).
   - Data disk size in GB

   ![Environment configuration -- Create MySQL with Replication](media/azure-stack-tutorial-mysqlrp/img3.png)

1. Review the deployment **Summary**. Optionally, you can download the customized template and parameters and then select **OK**.

   ![Summary -- Create MySQL with Replication](media/azure-stack-tutorial-mysqlrp/img4.png)

1. Select **Create** on the **Buy** page to start the deployment.

   ![Buy page -- Create MySQL with Replication](media/azure-stack-tutorial-mysqlrp/img5.png)

   > [!NOTE]
   > The deployment takes about an hour. Ensure that the deployment finishes and the MySQL cluster is completely configured before continuing.

1. After all deployments complete successfully, review the resource group items and select the **mysqlip** public IP address item. Record the public IP address and full FQDN of the public IP for the cluster.

   You must provide this IP address to an Azure Stack Hub operator so they can create a MySQL hosting server leveraging this MySQL cluster.

### Create a network security group rule

By default, no public access is configured for MySQL into the host VM. For the Azure Stack Hub MySQL resource provider to connect and manage the MySQL cluster, an inbound network security group (NSG) rule needs to be created.

1. In the administrator portal, go to the resource group created when deploying the MySQL cluster and select the network security group (**default-subnet-sg**):

   ![Select network security group in Azure Stack Hub administrator portal](media/azure-stack-tutorial-mysqlrp/img6.png)

1. Select **Inbound security rules** and then select **Add**.

   Enter **3306** in the **Destination port range** and optionally provide a description in the **Name** and **Description** fields.

   ![open](media/azure-stack-tutorial-mysqlrp/img7.png)

1. Select **Add** to close the inbound security rule dialog.

### Configure external access to the MySQL cluster

Before the MySQL cluster can be added as an Azure Stack Hub MySQL Server host, external access must be enabled.

1. Using an SSH client (this example uses [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html)) log in to the primary MySQL machine from a computer that can access the public IP. The primary MySQL VM name usually ends with **0** and has a public IP assigned to it.

   Use the public IP and log in to the VM with the username of **bitnami** and the application password you created earlier without special characters.

   ![LinuxLogin](media/azure-stack-tutorial-mysqlrp/bitnami1.png)

1. In the SSH client window, use the following command to ensure the bitnami service is active and running. Provide the bitnami password again when prompted: `sudo service bitnami status`.

   ![Check bitnami service](media/azure-stack-tutorial-mysqlrp/bitnami2.png)

1. Create a remote access user account to be used by the Azure Stack Hub MySQL Hosting Server to connect to MySQL and then exit the SSH client.

   Run the following commands to log in to MySQL as root, using the root password created earlier. Create a new admin user and replace *\<username\>* and *\<password\>* as required for your environment. In this example, the created user is named **sqlsa** and a strong password is used:

   ```mysql
   mysql -u root -p
   create user <username>@'%' identified by '<password>';
   grant all privileges on *.* to <username>@'%' with grant option;
   flush privileges;
   ```

   ![Create admin user](media/azure-stack-tutorial-mysqlrp/bitnami3.png)

1. Record the new MySQL user information.

   You must provide this username and password, along with the public IP address or full FQDN of the public IP for the cluster, to an Azure Stack Hub operator so they can create a MySQL hosting server using this MySQL cluster.

## Configure an Azure Stack Hub MySQL Hosting Server

After the MySQL Server cluster is created and properly configured, an Azure Stack Hub operator must add it as an Azure Stack Hub MySQL Hosting Server.

Be sure to use the public IP or full FQDN for the public IP of the MySQL cluster primary VM recorded previously when the MySQL cluster's resource group was created (**mysqlip**). In addition, the operator needs to know the MySQL Server authentication credentials you created to remotely access the MySQL cluster database.

> [!NOTE]
> This step must be run from the Azure Stack Hub administrator portal by an Azure Stack Hub operator.

Using the MySQL cluster's Public IP and MySQL authentication login information, an Azure Stack Hub operator can now [create a MySQL Hosting Server using the new MySQL cluster](azure-stack-mysql-resource-provider-hosting-servers.md#connect-to-a-mysql-hosting-server).

Also ensure that you created plans and offers to make MySQL database creation available for users. An operator must add the **Microsoft.MySqlAdapter** service to a plan and create a new quota specifically for highly available databases. For more information about creating plans, see [Service, plan, offer, subscription overview](service-plan-offer-subscription-overview.md).

> [!TIP]
> The **Microsoft.MySqlAdapter** service isn't available to add to plans until the [MySQL Server resource provider has been deployed](azure-stack-mysql-resource-provider-deploy.md).

## Create a highly available MySQL database

After the MySQL cluster is created and configured, and added as an Azure Stack Hub MySQL Hosting Server by an Azure Stack Hub operator, a tenant user with a subscription including MySQL Server database capabilities can create highly available MySQL databases by following the steps in this section.

> [!NOTE]
> Run these steps from the Azure Stack Hub user portal as a tenant user with a subscription providing MySQL Server capabilities (Microsoft.MySQLAdapter service).

1. Sign in to the user portal: for an integrated system deployment, the portal address varies based on your solution's region and external domain name. It's in the format of `https://portal.<region>.<FQDN>`.

1. Select **\+** **Create a resource** > **Data \+ Storage**, and then **MySQL Database**.

   Provide the required database property information including name, collation, the subscription to use, and location to use for the deployment.

   ![Create MySQL database in Azure Stack Hub user portal](./media/azure-stack-tutorial-mysqlrp/createdb1.png)

1. Select **SKU** and then choose the appropriate MySQL Hosting Server SKU to use. In this example, the Azure Stack Hub operator has created the **MySQL-HA** SKU to support high availability for MySQL cluster databases.

   ![Select SKU in Azure Stack Hub user portal](./media/azure-stack-tutorial-mysqlrp/createdb2.png)

1. Select **Login** > **Create a new login** and then provide the MySQL authentication credentials to be used for the new database. When finished, select **OK** and then **Create** to begin the database deployment process.

   ![Add login in Azure Stack Hub user portal](./media/azure-stack-tutorial-mysqlrp/createdb3.png)

1. When the MySQL database deployment completes successfully, review the database properties to discover the connection string to use for connecting to the new highly available database.

   ![View connection string in Azure Stack Hub user portal](./media/azure-stack-tutorial-mysqlrp/createdb4.png)

## Next steps

[Update the MySQL resource provider](azure-stack-mysql-resource-provider-update.md)
