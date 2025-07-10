---
title: Create MySQL databases in Azure Stack Hub 
description: Learn how to create and manage MySQL databases provisioned using the MySQL Adapter Resource Provider in Azure Stack Hub.
author: sethmanheim
ms.topic: how-to
ms.date: 1/17/2025
ms.author: sethm
ms.lastreviewed: 10/16/2019

# Intent: As an Azure Stack operator, I want to create and manage MySQL databases using the MySQL Adapter Resource Provider.
# Keyword: create mySQL database/s azure stack

---

# Create MySQL databases in Azure Stack Hub

[!INCLUDE [preview-banner](../includes/sql-mysql-rp-limit-access.md)]

An Azure Stack Hub user that's subscribed to an offer that includes the MySQL database service can create and manage self-service MySQL databases in the user portal.

## Create a MySQL database

1. Sign in to the Azure Stack Hub user portal.
1. Select **+ Create a resource** > **Data + Storage** > **MySQL Database** > **Add**.
1. Under **Create MySQL Database**, enter the Database Name, and configure the other settings as required for your environment.

   ![Create a test MySQL database](./media/azure-stack-mysql-rp-deploy/mysql-create-db-a.png)

1. Under **Create Database**, select **SKU**. Under **Select a MySQL SKU**, pick the SKU for your database.

   ![Select a MySQL SKU](./media/azure-stack-mysql-rp-deploy/mysql-select-sku.png)

   > [!NOTE]
   > As hosting servers are added to Azure Stack Hub, they're assigned a SKU. Databases are created in the pool of hosting servers in a SKU.

1. Under **Login**, select ***Configure required settings***.
1. Under **Select a Login**, you can choose an existing login or select **+ Create a new login** to set up a new login.  Enter a **Database login** name and **Password**, and then select **OK**.

   ![Create a new database login](./media/azure-stack-mysql-rp-deploy/create-new-login.png)

   > [!NOTE]
   > The length of the Database login name can't exceed 32 characters in MySQL 5.7. In earlier editions, it can't exceed 16 characters.

1. Select **Create** to finish setting up the database.

After the database is deployed, take note of the **Connection String** under **Essentials**. You can use this string in any application that needs to access the MySQL database.

![Get the connection string for the MySQL database](./media/azure-stack-mysql-rp-deploy/mysql-db-created-a.png)

## Update the administrative password

You can modify the password by changing it on the MySQL server instance.

1. Select **ADMINISTRATIVE RESOURCES** > **MySQL Hosting Servers**. Select the hosting server.
1. Under **Settings**, select **Password**.
1. Under **Password**, enter the new password and then select **Save**.

![Update the admin password](./media/azure-stack-mysql-rp-deploy/mysql-update-password.png)

## Next steps

Learn how to [offer highly available MySQL databases](azure-stack-tutorial-mysql.md).
