---
title: Back up App Service on Azure Stack Hub 
description: Learn how to back up App Services on Azure Stack Hub.
author: sethmanheim
ms.topic: article
ms.date: 08/08/2024
ms.author: sethm
ms.reviewer: anwestg
ms.lastreviewed: 03/21/2019

# Intent: As an Azure Stack operator, I want to back up App Service on Azure Stack so I don't lose important data.
# Keyword: back up app service azure stack

---

# Back up App Service on Azure Stack Hub

This article provides instructions on how to back up App Service on Azure Stack Hub.

> [!IMPORTANT]
> App Service on Azure Stack Hub isn't backed up as part of [Azure Stack Hub infrastructure backup](azure-stack-backup-infrastructure-backup.md). As an Azure Stack Hub operator, you must take steps to ensure App Service can be successfully recovered if necessary.

Azure App Service on Azure Stack Hub has four main components to consider when planning for disaster recovery:

1. The resource provider infrastructure; server roles, worker tiers, and so on.
1. The App Service secrets.
1. The App Service SQL Server hosting and metering databases.
1. The App Service user workload content stored in the App Service file share.

## Back up App Service secrets

When you recover App Service from backup, you must provide the App Service keys used by the initial deployment. This information should be saved as soon as App Service is successfully deployed and stored in a safe location. The resource provider infrastructure configuration is recreated from backup during recovery using App Service recovery PowerShell cmdlets.

Use the administrator portal to back up App Service secrets by following these steps:

1. Sign in to the Azure Stack Hub administrator portal as the service admin.
1. Browse to **App Service** -> **Secrets**.
1. Select **Download Secrets**.

   ![Screenshot showing download secrets in Azure Stack Hub administrator portal.](./media/app-service-back-up/download-secrets.png)

1. When the secrets are ready for downloading, select **Save** and store the App Service secrets (**SystemSecrets.json**) file in a safe location.

   ![Screenshot showing save secrets in Azure Stack Hub administrator portal.](./media/app-service-back-up/save-secrets.png)

> [!NOTE]
> Repeat these steps every time the App Service secrets are rotated.

## Back up the App Service databases

To restore App Service, you need the **Appservice_hosting** and **Appservice_metering** database backups. We recommend using SQL Server maintenance plans or Azure Backup Server to ensure these databases are backed up and saved securely on a regular basis. However, you can use any method of ensuring regular SQL backups are created.

To manually back up these databases while logged into the SQL Server, use the following PowerShell commands:

  ```powershell
  $s = "<SQL Server computer name>"
  $u = "<SQL Server login>" 
  $p = read-host "Provide the SQL admin password"
  sqlcmd -S $s -U $u -P $p -Q "BACKUP DATABASE appservice_hosting TO DISK = '<path>\hosting.bak'"
  sqlcmd -S $s -U $u -P $p -Q "BACKUP DATABASE appservice_metering TO DISK = '<path>\metering.bak'"
  ```

> [!NOTE]
> If you need to back up SQL AlwaysOn databases, [follow these instructions](/sql/database-engine/availability-groups/windows/configure-backup-on-availability-replicas-sql-server?view=sql-server-2017&preserve-view=true).

After all databases have been successfully backed up, copy the .bak files to a safe location along with the App Service secrets info.

## Back up the App Service file share

App Service stores tenant app info in the file share. This file share must be backed up on a regular basis along with the App Service databases so that as little data as possible is lost if a restore is required.

To back up the App Service file share content, use Azure Backup Server or another method to regularly copy the file share content to the location you've saved all previous recovery info.

For example, you can run these commands to use Robocopy from a Windows PowerShell (not PowerShell ISE) console session:

```powershell
$source = "<file share location>"
$destination = "<remote backup storage share location>"
net use $destination /user:<account to use to connect to the remote share in the format of domain\username> *
robocopy $source $destination
net use $destination /delete
```

## Next steps

[Restore App Service on Azure Stack Hub](app-service-recover.md)
