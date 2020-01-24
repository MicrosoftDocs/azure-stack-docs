---
title: Add MySQL hosting servers in Azure Stack Hub | Microsoft Docs
description: Learn how to add MySQL hosting servers for provisioning through the MySQL Adapter Resource Provider.
author: mattbriggs
ms.service: azure-stack
ms.topic: article
ms.date: 11/06/2019
ms.author: mabrigg
ms.reviewer: xiaofmao
ms.lastreviewed: 11/06/2019

---

# Add MySQL hosting servers in Azure Stack Hub

You can host a MySQL hosting server instance on a virtual machine (VM) in [Azure Stack Hub](azure-stack-overview.md), or on a VM outside your Azure Stack Hub environment, as long as the MySQL resource provider can connect to the instance.

> [!NOTE]
> The MySQL resource provider should be created in the default provider subscription while MySQL hosting servers should be created in billable, user subscriptions. The resource provider server shouldn't be used to host user databases.

MySQL versions 5.6, 5.7 and 8.0 may be used for your hosting servers. The MySQL RP doesn't support caching_sha2_password authentication; that will be added in the next release. MySQL 8.0 servers must be configured to use mysql_native_password. MariaDB is also supported.

## Connect to a MySQL hosting server

Make sure you have the credentials for an account with system admin privileges.

> [!NOTE]
> For MySQL 8.0 and above versions, the remote access isn't enabled by default. You need to create a new user account and grant the previledge of remote access to this user account before adding it as a hosting server.

To add a hosting server, follow these steps:

1. Sign in to the Azure Stack Hub administrator portal as a service admin.
2. Select **All services**.
3. Under the  **ADMINISTRATIVE RESOURCES** category, select **MySQL Hosting Servers** > **+Add**. The **Add a MySQL Hosting Server** dialog will open, shown in the following screen capture.

   ![Configure a MySQL hosting server](./media/azure-stack-mysql-rp-deploy/mysql-add-hosting-server-2.png)

4. Provide the connection details of your MySQL Server instance.

   * For **MySQL Hosting Server Name**, provide the fully qualified domain name (FQDN) or a valid IPv4 address. Don't use the short VM name.
   * The default admin **Username** for the Bitnami MySQL images available in Azure Stack Hub Marketplace is *root*.
   * If you don't know the root **Password**, see the [Bitnami documentation](https://docs.bitnami.com/azure/faq/#how-to-find-application-credentials) to learn how to get it.
   * A default MySQL instance isn't provided, so you have to specify the **Size of Hosting Server in GB**. Enter a size that's close to the capacity of the database server.
   * Keep the default setting for **Subscription**.
   * For **Resource group**, create a new one, or use an existing group.

   > [!NOTE]
   > If the MySQL instance can be accessed by the tenant and the admin Azure Resource Manager, you can put it under the control of the resource provider. But, the MySQL instance **must** be allocated exclusively to the resource provider.

5. Select **SKUs** to open the **Create SKU** dialog.

   ![Create a MySQL SKU](./media/azure-stack-mysql-rp-deploy/mysql-new-sku.png)

   The SKU **Name** should reflect the properties of the SKU so users can deploy their databases to the appropriate SKU.

6. Select **OK** to create the SKU.
   > [!NOTE]
   > SKUs can take up to an hour to be visible in the portal. You can't create a database until the SKU is deployed and running.

7. Under **Add a MySQL Hosting Server**, select **Create**.

As you add servers, assign them to a new or existing SKU to differentiate service offerings. For example, you can have a MySQL enterprise instance that provides increased database and automatic backups. You can reserve this high-performance server for different departments in your organization.

## Security considerations for MySQL

The following information applies to the RP and MySQL hosting servers:

* Ensure that all hosting servers are configured for communication using TLS 1.1. See [Configuring MySQL to Use Encrypted Connections](https://dev.mysql.com/doc/refman/5.7/en/using-encrypted-connections.html).
* Employ [Transparent Data Encryption](https://dev.mysql.com/doc/mysql-secure-deployment-guide/5.7/en/secure-deployment-data-encryption.html).
* The MySQL RP doesn't support caching_sha2_password authentication.

## Increase backend database capacity

You can increase backend database capacity by deploying more MySQL servers in the Azure Stack Hub portal. Add these servers to a new or existing SKU. If you add a server to an existing SKU, make sure the server characteristics are the same as the other servers in the SKU.

## SKU notes
Use a SKU name that describes the capabilities of the servers in the SKU, such as capacity and performance. The name serves as an aid to help users deploy their databases to the appropriate SKU. For example, you can use SKU names to differentiate service offerings by the following characteristics:
  
* high capacity
* high performance
* high availability

As a best practice, all the hosting servers in a SKU should have the same resource and performance characteristics.

SKUs can't be assigned to specific users or groups.

To edit a SKU, go to **All services** > **MySQL Adapter** > **SKUs**. Select the SKU to modify, make any necessary changes, and click **Save** to save changes. 

To delete a SKU that's no longer needed, go to **All services** > **MySQL Adapter** > **SKUs**. Right-click the SKU name and select **Delete** to delete it.

> [!IMPORTANT]
> It can take up to an hour for new SKUs to be available in the user portal.

## Make MySQL database servers available to your users

Create plans and offers to make MySQL database servers available to users. Add the Microsoft.MySqlAdapter service to the plan and create a new quota. MySQL doesn't allow limiting the size of databases.

> [!IMPORTANT]
> It can take up to two hours for new quotas to be available in the user portal or before a changed quota is enforced.

## Next steps

[Create a MySQL database](azure-stack-mysql-resource-provider-databases.md)
