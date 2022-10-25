---
title: Migrate SQL server  
description: Document listing how to migrate the Azure App Service on Azure Stack Hub resource provider SQL server.
author: apwestgarth
manager: stefsch

ms.topic: article
ms.date: 10/25/2022
ms.author: anwestg
ms.reviewer: 
ms.lastreviewed: 

# Intent: Notdone: As a < type of user >, I want < what? > so that < why? >
# Keyword: Notdone: keyword noun phrase

---

---

# Migrate SQL server

This article describes how to migrate to new SQL Server infrastructure for hosting the Azure App Service on Azure Stack Hub Resource Provider databases - appservice_hosting and appservice_metrics.


## Back up App Service secrets
When preparing to migrate, you must back up the App Service keys used by the initial deployment. 


Use the administration portal to back up app service secrets by following these steps: 

1. Sign in to the Azure Stack Hub administrator portal as the service admin.

2. Browse to **App Service** -> **Secrets**. 

3. Select **Download Secrets**.

   ![Screenshot that shows how to download secrets in Azure Stack Hub administrator portal.](./media/app-service-migrate-sql-server/download-secrets.png)

4. When secrets are ready for downloading, click **Save** and store the App Service secrets (**SystemSecrets.JSON**) file in a safe location. 

   ![Screenshot that shows how to save secrets in Azure Stack Hub administrator portal.](./media/app-service-migrate-sql-server/save-secrets.png)

## Back up the App Service databases from the current server


To restore App Service, you need the **Appservice_hosting** and **Appservice_metering** database backups. We recommend using SQL Server maintenance plans or Azure Backup Server to ensure these databases are backed up and saved securely regularly. However, any method of ensuring regular SQL database backups are created can be used.

To manually back up these databases while logged into the SQL Server, use the following PowerShell commands:

  ```powershell
  $s = "<SQL Server computer name>"
  $u = "<SQL Server login>" 
  $p = read-host "Provide the SQL admin password"
  sqlcmd -S $s -U $u -P $p -Q "BACKUP DATABASE appservice_hosting TO DISK = '<path>\hosting.bak'"
  sqlcmd -S $s -U $u -P $p -Q "BACKUP DATABASE appservice_metering TO DISK = '<path>\metering.bak'"
  ```

> [!NOTE]
> If you need to back up SQL AlwaysOn databases, follow [these instructions](/sql/database-engine/availability-groups/windows/configure-backup-on-availability-replicas-sql-server?view=sql-server-2017&preserve-view=true). 

After all databases have been successfully backed up, copy the .bak files to a safe location along with the App Service secrets info.

## Restore the App Service databases on a new production ready SQL Server instance

The App Service SQL Server databases should be restored on a production ready SQL Server instance. 

After [preparing the SQL Server instance](azure-stack-app-service-before-you-get-started.md#prepare-the-sql-server-instance) to host the App Service databases, use these steps to restore databases from backup:

1. Sign in to the SQL Server that will host the recovered App Service databases with admin permissions.
2. Use the following commands to restore the App Service databases from a command prompt running with admin permissions:
    ```dos
    sqlcmd -U <SQL admin login> -P <SQL admin password> -Q "RESTORE DATABASE appservice_hosting FROM DISK='<full path to backup>' WITH REPLACE"
    sqlcmd -U <SQL admin login> -P <SQL admin password> -Q "RESTORE DATABASE appservice_metering FROM DISK='<full path to backup>' WITH REPLACE"
    ```
3. Verify that both App Service databases have been successfully restored and exit SQL Server Management Studio.

## Migrate the SQL Server

1. In the Azure Stack Hub admin portal, navigate to **Network Security Groups** and view the **ControllersNSG** Network Security Group.

1. By default, remote desktop is disabled to all App Service infrastructure roles.  Modify the **Inbound_Rdp_2289** rule action to **Allow** access.
1. Navigate to the resource group containing the App Service Resource Provider Deployment, by default the resource group is named in with the format, AppService.\<region\> and connect to **CN0-VM**.
1. Open an Administrator PowerShell session and run **net stop webfarmservice**.

1. Repeat step 3 and 4 for all other controllers.
1. Return to **CN0-VM**'s RDP session and copy the secrets file to the controller.

1. In an Administrator PowerShell session run
      ```powershell
      Restore-AppServiceStamp -FilePath <local secrets file> -OverrideDatabaseServer <new database server> -CoreBackupFilePath <filepath>
      ```
   1. A prompt will appear to confirm the key values, press **Enter** to continue or close the PowerShell session to cancel.
1. Once the cmdlet completes, **all** worker instances from the custom worker tiers will be removed, and those instances will be added back by the next step
1. In the same PowerShell session or a new Administrative PowerShell session, run the following PowerShell script.  The script will inspect all the Virtual Machine Scale Sets associated and perform corresponding actions including adding back the instances of custom worker tiers:
   ```powershell
   Restore-AppServiceRoles
   ```
1. in the same, or a new, administrative PowerShell session, run **net start webfarmservice**
1. Repeat the previous step for all other controllers.
1. In the Azure Stack admin portal, navigate back to the **ControllersNSG** Network Security Group
1. Modify the **Inbound_Rdp_3389** rule to deny access.

## Next steps
[Backup App Service on Azure Stack Hub](app-service-back-up.md)
[Restore App Service on Azure Stack Hub](app-service-recover.md)