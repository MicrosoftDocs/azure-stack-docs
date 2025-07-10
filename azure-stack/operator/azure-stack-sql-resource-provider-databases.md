---
title: Create SQL databases in Azure Stack Hub
description: Learn how to create and manage SQL databases provisioned using the SQL resource provider adapter.
author: sethmanheim
ms.topic: how-to
ms.date: 1/17/2025
ms.author: sethm
ms.lastreviewed: 10/16/2019

# Intent: As an Azure Stack operator, I want to create and manage SQL databases provisiuoned using the SQL resource provider adapter.
# Keyword: create sql databases azure stack

---

# Create SQL databases in Azure Stack Hub

[!INCLUDE [preview-banner](../includes/sql-mysql-rp-limit-access.md)]

You can create and manage self-service databases in the user portal. An Azure Stack Hub user needs a subscription with an offer that includes the SQL database service.

1. Sign in to the [Azure Stack Hub](azure-stack-overview.md) user portal.
1. Select **+ New**, **Data + Storage**, **SQL Server Database**, then **Add**.
1. Under **Create Database**, enter the required information, such as **Database Name** and **Max Size in MB**.

   > [!NOTE]
   > The database size must be at least 64 MB, which can be increased after you deploy the database.

   Configure the other settings as required for your environment.

1. Under **Create Database**, select **SKU**. Under **Select a SKU**, select the SKU for your database.

   ![Create Database in Azure Stack Hub user portal.](./media/azure-stack-sql-rp-deploy/newsqldba.png)

   > [!NOTE]
   > As hosting servers are added to Azure Stack Hub, they're assigned a SKU. Databases are created in the pool of hosting servers in a SKU.

1. Select **Login**.
1. Under **Select a Login**, choose an existing login, or select **+ Create a new login**.
1. Under **New Login**, enter a name for **Database login** and a **Password**.

   > [!NOTE]
   > These settings are the SQL authentication credential that's created for your access to this database only. The login user name must be globally unique. You can reuse login settings for other databases that use the same SKU.

   ![Create a new database login in Azure Stack Hub user portal](./media/azure-stack-sql-rp-deploy/create-new-login-a.png)

1. Select **OK** to finish deploying the database.

Under **Essentials**, which is shown after the database is deployed, take note of the **Connection string**. You can use this string in any app that needs to access the SQL Server database.

![Retrieve the connection string for the SQL Server database](./media/azure-stack-sql-rp-deploy/sql-db-settings-a.png)

## SQL Always On databases

By design, Always On databases are handled differently than in a standalone server environment. For more information, see [Introducing SQL Server Always On availability groups on Azure virtual machines](/azure/azure-sql/virtual-machines/windows/availability-group-overview).

### Verify SQL Always On databases

The following screenshot shows how you can use SQL Server Management Studio to view database status in SQL Always On:

![AlwaysOn database status in SQL Server Management Studio](./media/azure-stack-sql-rp-deploy/verify-always-on.png)

Always On databases should show as **Synchronized** and available on all the SQL instances and appear in **Availability Groups**. In the previous screenshot, the database example is **newdb1** and its status is **newdb1 (Synchronized)**.

### Delete an Always On database

When you delete a SQL Always On database from the resource provider, SQL deletes the database from the primary replica and from the availability group.

SQL then puts the database into the **Restoring** state on the other replicas and doesn't drop the database unless triggered. If the database isn't dropped, the secondary replicas go into a **Not Synchronizing** state.

## Next steps

Learn how to [offer highly available SQL databases](azure-stack-tutorial-sql.md)
