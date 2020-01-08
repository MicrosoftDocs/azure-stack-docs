---
title: Offer highly available MySQL databases
titleSuffix: Azure Stack
description: Learn how to create a MySQL Server resource provider host computer and highly available MySQL databases with Azure Stack.
services: azure-stack
author: BryanLa
manager: femila
editor: ''

ms.service: azure-stack
ms.topic: article
ms.date: 10/07/2019
ms.author: bryanla
ms.reviewer: xiaofmao
ms.lastreviewed: 10/23/2018
---

# Offer highly available MySQL databases

As an Azure Stack operator, you can configure server virtual machines (VMs) to host MySQL Server databases. After a MySQL cluster is successfully created and managed by Azure Stack, users who have subscribed to MySQL services can easily create highly available MySQL databases.

This article shows how to use Azure Stack Marketplace items to create a [MySQL with replication cluster](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/bitnami.mysql-cluster). This solution uses multiple VMs to replicate the databases from the master node to a configurable number of replicas. Once created, the cluster can then be added as an Azure Stack MySQL Hosting Server, and then users can create a highly available MySQL databases.

> [!IMPORTANT]
> The **MySQL with replication** Azure Stack Marketplace item might not be available for all Azure cloud subscription environments. Verify that the marketplace item is available in your subscription before attempting to follow the rest of this tutorial.

What you'll learn:

> [!div class="checklist"]
> * Create a MySQL Server cluster from marketplace items.
> * Create an Azure Stack MySQL Hosting Server.
> * Create a highly available MySQL database.

A three-VM MySQL Server cluster will be created and configured using available Azure Stack Marketplace items.

Before starting, ensure that the [MySQL Server resource provider](azure-stack-mysql-resource-provider-deploy.md) has been successfully installed and that the following items are available in Azure Stack Marketplace:

> [!IMPORTANT]
> All of the following are required to create the MySQL cluster.

- [MySQL with Replication](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/bitnami.mysql-cluster): This is the Bitnami solution template that will be used for the MySQL cluster deployment.
- [Debian 8 "Jessie"](https://azuremarketplace.microsoft.com/marketplace/apps/credativ.Debian): Debian 8 "Jessie" with backports kernel for Microsoft Azure provided by credativ. Debian GNU/Linux is one of the most popular Linux distributions.
- [Custom script for linux 2.0](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/microsoft.custom-script-linux?tab=Overview): Custom Script Extension is a tool to execute your VM customization tasks post VM provision. When this Extension is added to a VM, it can download scripts from Azure storage and run them on the VM. Custom Script Extension tasks can also be automated using the Azure PowerShell cmdlets and Azure Cross-Platform Command-Line Interface (xPlat CLI).
- VM Access For Linux Extension 1.4.7: The VM Access extension enables you to reset the password, SSH key, or the SSH configurations so you can regain access to your VM. You can also add a new user with password or SSH key, or delete a user using this extension. This extension targets Linux VMs.

To learn more about adding items to Azure Stack Marketplace, see the [Azure Stack Marketplace overview](azure-stack-marketplace.md).

You'll also need an SSH client like [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html) to log in to the Linux VMs after they're deployed.

## Create a MySQL Server cluster

Use the steps in this section to deploy the MySQL Server cluster using the [MySQL with Replication](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/bitnami.mysql-cluster) marketplace item. This template deploys three MySQL Server instances configured in a highly available MySQL cluster. By default, it creates the following resources:

- A virtual network
- A network security group
- A storage account
- An availability set
- Three network interfaces (one for each of the default VMs)
- A public IP address (for the primary MySQL cluster VM)
- Three Linux VMs to host the MySQL cluster

1. 
   [!INCLUDE [azs-admin-portal](../includes/azs-admin-portal.md)]

2. Select **\+** **Create a resource** > **Compute**, and then **MySQL with Replication**.

   ![Custom template deployment in Azure Stack](media/azure-stack-tutorial-mysqlrp/1.png)

3. Provide basic deployment information on the **Basics** page. Review the default values and change as needed and select **OK**.<br><br>At a minimum, provide the following:

   - Deployment name (default is mymysql).
   - Application root password. Provide a 12 character alphanumeric password with **no special characters**.
   - Application database name (default is bitnami).
   - Number of MySQL database replica VMs to create (default is 2).
   - Select the subscription to use.
   - Select the resource group to use or create a new one.
   - Select the location (default is local for ASDK).

   [![](media/azure-stack-tutorial-mysqlrp/2-sm.PNG "Deployment basics — Create MySQL with Replication")](media/azure-stack-tutorial-mysqlrp/2-lg.PNG#lightbox)

4. On the **Environment Configuration** page, provide the following information and then select **OK**:

   - Password or SSH public key to use for secure shell (SSH) authentication. If using a password, it must contain letters, numbers, and **can** contain special characters.
   - VM size (default is Standard D1 v2 VMs).
   - Data disk size in GB

   [![](media/azure-stack-tutorial-mysqlrp/3-sm.PNG "Environment configuration — Create MySQL with Replication")](media/azure-stack-tutorial-mysqlrp/3-lg.PNG#lightbox)

5. Review the deployment **Summary**. Optionally, you can download the customized template and parameters and then select **OK**.

   [![](media/azure-stack-tutorial-mysqlrp/4-sm.PNG "Summary — Create MySQL with Replication")](media/azure-stack-tutorial-mysqlrp/4-lg.PNG#lightbox)

6. Select **Create** on the **Buy** page to start the deployment.

   ![Buy page — Create MySQL with Replication](media/azure-stack-tutorial-mysqlrp/5.png)

    > [!NOTE]
    > The deployment will take about an hour. Ensure that the deployment has finished and the MySQL cluster has been completely configured before continuing.

7. After all deployments have completed successfully, review the resource group items and select the **mysqlip** Public IP address item. Record the public IP address and full FQDN of the public IP for the cluster.

    You'll need to provide this to an Azure Stack Operator so they can create a MySQL hosting server leveraging this MySQL cluster.

### Create a network security group rule

By default, no public access is configured for MySQL into the host VM. For the Azure Stack MySQL resource provider to connect and manage the MySQL cluster, an inbound network security group (NSG) rule needs to be created.

1. In the administrator portal, navigate to the resource group created when deploying the MySQL cluster and select the network security group (**default-subnet-sg**):

   ![Select network security group in Azure Stack administrator portal](media/azure-stack-tutorial-mysqlrp/6.png)

2. Select **Inbound security rules** and then select **Add**.

    Enter **3306** in the **Destination port range** and optionally provide a description in the **Name** and **Description** fields.

   ![open](media/azure-stack-tutorial-mysqlrp/7.png)

3. Select **Add** to close the inbound security rule dialog.

### Configure external access to the MySQL cluster

Before the MySQL cluster can be added as an Azure Stack MySQL Server host, external access must be enabled.

1. Using an SSH client (this example uses [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html)) log in to the primary MySQL machine from a computer that can access the public IP. The primary MySQL VM name usually ends with **0** and has a public IP assigned to it.

    Use the public IP and log in to the VM with the username of **bitnami** and the application password you created earlier without special characters.

   ![LinuxLogin](media/azure-stack-tutorial-mysqlrp/bitnami1.png)

2. In the SSH client window, use the following command to ensure the bitnami service is active and running. Provide the bitnami password again when prompted:

   `sudo service bitnami status`

   ![Check bitnami service](media/azure-stack-tutorial-mysqlrp/bitnami2.png)

3. Create a remote access user account to be used by the Azure Stack MySQL Hosting Server to connect to MySQL and then exit the SSH client.

    Run the following commands to log in to MySQL as root, using the root password created earlier. Create a new admin user and replace *\<username\>* and *\<password\>* as required for your environment. In this example, the created user is named **sqlsa** and a strong password is used:

   ```mysql
   mysql -u root -p
   create user <username>@'%' identified by '<password>';
   grant all privileges on *.* to <username>@'%' with grant option;
   flush privileges;
   ```

   ![Create admin user](media/azure-stack-tutorial-mysqlrp/bitnami3.png)

4. Record the new MySQL user information.

    You'll need to provide this username and password, along with the public IP address or full FQDN of the public IP for the cluster, to an Azure Stack operator so they can create a MySQL hosting server using this MySQL cluster.

## Create an Azure Stack MySQL Hosting Server

After the MySQL Server cluster has been created, and properly configured, an Azure Stack Operator must create an Azure Stack MySQL Hosting Server to make the additional capacity available for users to create databases.

Be sure to use the public IP or full FQDN for the public IP of the MySQL cluster primary VM recorded previously when the MySQL cluster's resource group was created (**mysqlip**). In addition, the operator will need to know the MySQL Server authentication credentials you created to remotely access the MySQL cluster database.

> [!NOTE]
> This step must be run from the Azure Stack administration portal by an Azure Stack Operator.

Using the MySQL cluster's Public IP and MySQL authentication login information, an Azure Stack Operator can now [create a MySQL Hosting Server using the new MySQL cluster](azure-stack-mysql-resource-provider-hosting-servers.md#connect-to-a-mysql-hosting-server). 

Also ensure that you have created plans and offers to make MySQL database creation available for users. An operator will need to add the **Microsoft.MySqlAdapter** service to a plan and create a new quota specifically for highly available databases. For more information about creating plans, see [Service, plan, offer, subscription overview](service-plan-offer-subscription-overview.md).

> [!TIP]
> The **Microsoft.MySqlAdapter** service will not be available to add to plans until the [MySQL Server resource provider has been deployed](azure-stack-mysql-resource-provider-deploy.md).



## Create a highly available MySQL database
After the MySQL cluster has been created, configured, and added as an Azure Stack MySQL Hosting Server by an Azure Stack Operator, a tenant user with a subscription including MySQL Server database capabilities can create highly available MySQL databases by following the steps in this section. 

> [!NOTE]
> Run these steps from the Azure Stack user portal as a tenant user with a subscription providing MySQL Server capabilities (Microsoft.MySQLAdapter service).

1. 
   [!INCLUDE [azs-user-portal](../includes/azs-user-portal.md)]

2. Select **\+** **Create a resource** > **Data \+ Storage**, and then **MySQL Database**.<br><br>Provide the required database property information including name, collation, the subscription to use, and location to use for the deployment. 

   ![Create MySQL database](./media/azure-stack-tutorial-mysqlrp/createdb1.png)

3. Select **SKU** and then choose the appropriate MySQL Hosting Server SKU to use. In this example, the Azure Stack Operator has created the **MySQL-HA** SKU to support high availability for MySQL cluster databases.

   ![Select SKU](./media/azure-stack-tutorial-mysqlrp/createdb2.png)

4. Select **Login** > **Create a new login** and then provide the MySQL authentication credentials to be used for the new database. When finished, click **OK** and then **Create** to begin the database deployment process.

   ![Add login](./media/azure-stack-tutorial-mysqlrp/createdb3.png)

5. When the MySQL database deployment completes successfully, review the database properties to discover the connection string to use for connecting to the new highly available database. 

   ![View connection string](./media/azure-stack-tutorial-mysqlrp/createdb4.png)

## Next steps

[Update the MySQL resource provider](azure-stack-mysql-resource-provider-update.md)
