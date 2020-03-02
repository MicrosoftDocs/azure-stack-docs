---
title: Create highly available SQL databases
titleSuffix: Azure Stack Hub
description: Learn how to create a SQL Server resource provider host computer and highly available SQL AlwaysOn databases with Azure Stack Hub.
author: BryanLa

ms.topic: article
ms.date: 10/07/2019
ms.author: bryanla
ms.reviewer: xiaofmao
ms.lastreviewed: 10/23/2019

# Intent: As an Azure Stack operator, I want to learn how to create highly available SQL databases
# Keyword: create sql database azure stack hub

---


# Create highly available SQL databases with Azure Stack Hub

As an Azure Stack Hub Operator, you can configure server VMs to host SQL Server databases. After a SQL hosting server is created and managed by Azure Stack Hub, users who have subscribed to SQL services can easily create SQL databases.

This article shows how to use an Azure Stack Hub quickstart template to create a [SQL Server AlwaysOn availability group](https://docs.microsoft.com/sql/database-engine/availability-groups/windows/overview-of-always-on-availability-groups-sql-server?view=sql-server-2017), add it as an Azure Stack Hub SQL Hosting Server, and then create a highly available SQL database.

What you'll learn:

> [!div class="checklist"]
> * Create a SQL Server AlwaysOn availability group from a template.
> * Create an Azure Stack Hub SQL Hosting Server.
> * Create a highly available SQL database.

A two VM SQL Server AlwaysOn availability group will be created and configured using available Azure Stack Marketplace items.

Before starting, ensure that the [SQL Server resource provider](azure-stack-sql-resource-provider-deploy.md) has been successfully installed and the following items are available in Azure Stack Marketplace:

> [!IMPORTANT]
> All of the following are required for the Azure Stack Hub quickstart template to be used.

- [Windows Server 2016 Datacenter](https://azuremarketplace.microsoft.com/marketplace/apps/MicrosoftWindowsServer.WindowsServer) marketplace image.
- SQL Server 2016 SP1 or SP2 (Enterprise, Standard, or Developer) on Windows Server 2016 server image. This article uses the [SQL Server 2016 SP2 Enterprise on Windows Server 2016](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/microsoftsqlserver.sql2016sp2-ws2016) marketplace image.
- [SQL Server IaaS Extension](https://docs.microsoft.com/azure/virtual-machines/windows/sql/virtual-machines-windows-sql-server-agent-extension) version 1.2.30 or higher. The SQL IaaS Extension installs necessary components that are required by the Marketplace SQL Server items for all Windows versions. It enables SQL-specific settings to be configured on SQL virtual machines (VMs). If the extension isn't installed in the local marketplace, provisioning of SQL will fail.
- [Custom script extension for Windows](https://azuremarketplace.microsoft.com/marketplace/apps/Microsoft.CustomScriptExtension) version 1.9.1 or higher. Custom Script Extension is a tool that can be used to automatically launch post-deployment VM customization tasks.
- [PowerShell Desired State Configuration (DSC)](https://azuremarketplace.microsoft.com/marketplace/apps/Microsoft.DSC-arm) version 2.76.0.0 or higher. DSC is a management platform in Windows PowerShell that enables deploying and managing configuration data for software services. The platform also manages the environment in which these services run.

To learn more about adding items to Azure Stack Marketplace, see the [Azure Stack Hub Marketplace overview](azure-stack-marketplace.md).

## Create a SQL Server AlwaysOn availability group

Use the steps in this section to deploy the SQL Server AlwaysOn availability group by using the [sql-2016-alwayson Azure Stack Hub quickstart template](https://github.com/Azure/AzureStack-QuickStart-Templates/tree/master/sql-2016-alwayson). This template deploys two SQL Server Enterprise, Standard or Developer instances in an Always On Availability Group. It creates the following resources:

- A network security group.
- A virtual network.
- Four storage accounts (one for Active Directory (AD), one for SQL, one for file share witness, and one for VM diagnostics).
- Four public IP addresses (one for AD, two for each SQL VM, and one for public load balancer bound to SQL AlwaysOn listener).
- One external load balancer for SQL VMs with Public IP bound to the SQL AlwaysOn listener.
- One VM (Windows Server 2016) configured as Domain Controller for a new forest with a single domain.
- Two VMs (Windows Server 2016) configured with SQL Server 2016 SP1 or SP2 Enterprise, Standard, or Developer Edition and clustered. These must be marketplace images.
- One VM (Windows Server 2016) configured as the file share witness for the cluster.
- One availability set containing the SQL and file share witness VMs.

1. 
   [!INCLUDE [azs-admin-portal](../includes/azs-admin-portal.md)]

2. Select **\+** **Create a resource** > **Custom**, and then **Template deployment**.

   ![Custom template deployment in Azure Stack Hub administrator portal](media/azure-stack-tutorial-sqlrp/1.png)

3. On the **Custom deployment** blade, select **Edit template** > **Quickstart template** and then use the drop-down list of available custom templates to select the **sql-2016-alwayson** template. Select **OK**, then **Save**.

   [![Edit template in Azure Stack Hub administrator portal](media/azure-stack-tutorial-sqlrp/2-sm.PNG "Select quickstart template")](media/azure-stack-tutorial-sqlrp/2-lg.PNG#lightbox)

4. On the **Custom deployment** blade, select **Edit parameters** and review the default values. Modify the values as necessary to provide all required parameter information and then select **OK**.

    At a minimum:
    - Provide complex passwords for the ADMINPASSWORD, SQLSERVERSERVICEACCOUNTPASSWORD, and SQLAUTHPASSWORD parameters.
    - Enter the DNS Suffix for reverse lookup in all lowercase letters for the DNSSUFFIX parameter (**azurestack.external** for ASDK installations).
    
   [![Edit parameters in Azure Stack Hub administrator portal](media/azure-stack-tutorial-sqlrp/3-sm.PNG "Edit custom deployment parameters")](media/azure-stack-tutorial-sqlrp/3-lg.PNG#lightbox)

5. On the **Custom deployment** blade, choose the subscription to use and create a new resource group or select an existing resource group for the custom deployment.

    Next, select the resource group location (**local** for ASDK installations) and then click **Create**. The custom deployment settings will be validated and then the deployment will start.

    [![Choose subscription in Azure Stack Hub administrator portal](media/azure-stack-tutorial-sqlrp/4-sm.PNG "Create custom deployment")](media/azure-stack-tutorial-sqlrp/4-lg.PNG#lightbox)

6. In the administrator portal, select **Resource groups** and then the name of the resource group you created for the custom deployment (**resource-group** for this example). View the status of the deployment to ensure all deployments have completed successfully.
    
    Next, review the resource group items and select the **SQLPIPsql\<resource group name\>** public IP address item. Record the public IP address and full FQDN of the load balancer public IP. You'll need to provide this to an Azure Stack Hub operator so they can create a SQL hosting server leveraging this SQL AlwaysOn availability group.

   > [!NOTE]
   > The template deployment will take several hours to complete.

   ![Custom deployment complete in Azure Stack Hub administrator portal](./media/azure-stack-tutorial-sqlrp/5.png)

### Enable automatic seeding

After the template has successfully deployed and configured the SQL AlwaysON availability group, you must enable [automatic seeding](https://docs.microsoft.com/sql/database-engine/availability-groups/windows/automatically-initialize-always-on-availability-group) on each instance of SQL Server in the availability group.

When you create an availability group with automatic seeding, SQL Server automatically creates the secondary replicas for every database in the group without any other manual intervention necessary. This measure ensures high availability of AlwaysOn databases.

Use these SQL commands to configure automatic seeding for the AlwaysOn availability group. Replace `<InstanceName>` with the primary instance SQL Server name and `<availability_group_name>` with the AlwaysOn availability group name as necessary.

On the primary SQL instance:

  ```sql
  ALTER AVAILABILITY GROUP [<availability_group_name>]
      MODIFY REPLICA ON '<InstanceName>'
      WITH (SEEDING_MODE = AUTOMATIC)
  GO
  ```

![Primary SQL instance script](./media/azure-stack-tutorial-sqlrp/sql1.png)

On secondary SQL instances:

  ```sql
  ALTER AVAILABILITY GROUP [<availability_group_name>] GRANT CREATE ANY DATABASE
  GO
  ```

![Secondary SQL instance script](./media/azure-stack-tutorial-sqlrp/sql2.png)

### Configure contained database authentication

Before adding a contained database to an availability group, ensure that the contained database authentication server option is set to 1 on every server instance that hosts an availability replica for the availability group. For more information, see [contained database authentication](https://docs.microsoft.com/sql/database-engine/configure-windows/contained-database-authentication-server-configuration-option?view=sql-server-2017).

Use these commands to set the contained database authentication server option for each SQL Server instance in the availability group:

  ```sql
  EXEC sp_configure 'contained database authentication', 1
  GO
  RECONFIGURE
  GO
  ```

![Set contained database authentication](./media/azure-stack-tutorial-sqlrp/sql3.png)

## Create an Azure Stack Hub SQL Hosting Server

After the SQL Server AlwayOn availability group has been created and properly configured, an Azure Stack Hub operator has to create an Azure Stack Hub SQL Hosting Server. The SQL Hosting Server makes the additional capacity available for users to create databases.

Be sure to use the public IP or full FQDN for the public IP of the SQL load balancer recorded previously when the SQL AlwaysOn availability group's resource group was created (**SQLPIPsql\<resource group name\>**). In addition, you need to know the SQL Server authentication credentials used to access the SQL instances in the AlwaysOn availability group.

> [!NOTE]
> This step must be run from the Azure Stack Hub administrator portal by an Azure Stack Hub operator.

With the SQL AlwaysOn availability group's load balancer listener public IP and SQL authentication login information, an Azure Stack Hub operator can [create a SQL Hosting Server using the SQL AlwaysOn availability group](azure-stack-sql-resource-provider-hosting-servers.md#provide-high-availability-using-sql-always-on-availability-groups). 

Also ensure that you have created plans and offers to make SQL AlwaysOn database creation available for users. The operator will need to add the **Microsoft.SqlAdapter** service to a plan and create a new quota specifically for highly available databases. For more information about creating plans, see [Service, plan, offer, subscription overview](service-plan-offer-subscription-overview.md).

> [!TIP]
> The **Microsoft.SqlAdapter** service won't be available to add to plans until the [SQL Server resource provider has been deployed](azure-stack-sql-resource-provider-deploy.md).

## Create a highly available SQL database

After the SQL AlwaysOn availability group has been created, configured, and added as an Azure Stack Hub SQL Hosting Server by an Azure Stack Hub operator, a tenant user with a subscription including SQL Server database capabilities can create SQL databases supporting AlwaysOn functionality. They can create those databases by following the steps in this section.

> [!NOTE]
> Run these steps from the Azure Stack Hub user portal as a tenant user with a subscription providing SQL Server capabilities (Microsoft.SQLAdapter service).

1. 
   [!INCLUDE [azs-user-portal](../includes/azs-user-portal.md)]

2. Select **\+** **Create a resource** > **Data \+ Storage**, and then **SQL Database**.

    Provide the required database property information. This info includes name, collation, maximum size, and the subscription, resource group, and location to use for the deployment.

   ![Create SQL database in Azure Stack Hub user portal](./media/azure-stack-tutorial-sqlrp/createdb1.png)

3. Select **SKU** and then choose the appropriate SQL Hosting Server SKU to use. In this example, the Azure Stack Hub operator has created the **Enterprise-HA** SKU to support high availability for SQL AlwaysOn availability groups.

   ![Select SKU in Azure Stack Hub user portal](./media/azure-stack-tutorial-sqlrp/createdb2.png)

4. Select **Login** > **Create a new login** and then provide the SQL authentication credentials to be used for the new database. When finished, select **OK** and then **Create** to begin the database deployment process.

   ![Create login in Azure Stack Hub user portal](./media/azure-stack-tutorial-sqlrp/createdb3.png)

5. When the SQL database deployment completes successfully, review the database properties to discover the connection string to use for connecting to the new highly available database.

   ![View connection string in Azure Stack Hub user portal](./media/azure-stack-tutorial-sqlrp/createdb4.png)

## Next steps

[Update the SQL resource provider](azure-stack-sql-resource-provider-update.md)
