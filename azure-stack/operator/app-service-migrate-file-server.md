---
title: Migrate File Server  
description: Migrate File Server.
author: apwestgarth
manager: stefsch

ms.topic: article
ms.date: 05/27/2022
ms.author: anwestg
ms.reviewer: 
ms.lastreviewed: 

# Intent: Notdone: As a < type of user >, I want < what? > so that < why? >
# Keyword: Notdone: keyword noun phrase

---
# Migrate File Share

This document provides instructions on how to migrate to new File Server infrastructure for hosting the Azure App Service on Azure Stack Hub Resource Provider content file share.

## Back up the existing App Service file share

App Service stores tenant app info in the file share. This file share must be backed up on a regular basis along with the App Service databases so that as little data as possible is lost if a restore or migration is required.

To back up the App Service file share content, use Azure Backup Server or another method to regularly copy the file share content to the location you've saved all previous recovery info.

For example, you can use these steps to use Robocopy from a Windows PowerShell (not PowerShell ISE) console session:

```powershell
$source = "<file share location>"
$destination = "<remote backup storage share location>"
net use $destination /user:<account to use to connect to the remote share in the format of domain\username> *
robocopy $source $destination
net use $destination /delete
```

## Restore the App Service file share content to a new File Server

After [preparing the new file server](azure-stack-app-service-before-you-get-started.md#prepare-the-file-server) to host the App Service file share, you need to restore the tenant file share content from backup. You can use whatever method you have available to copy the files into the newly created App Service file share location. Running this example on the file server will use PowerShell and robocopy to connect to a remote share and copy the files to the share:

```powershell
$source = "<remote backup storage share location>"
$destination = "<local file share location>"
net use $source /user:<account to use to connect to the remote share in the format of domain\username> *
robocopy /E $source $destination
net use $source /delete
```

In addition to copying the file share contents, you must also reset permissions on the file share itself. To reset permissions, open an admin command prompt on the file server computer and run the **ReACL.cmd** file. The **ReACL.cmd** file is located in the App Service installation files in the **BCDR** directory.

## Update connection details in the Azure App Service on Azure Stack Hub Resource Provider

Login to the SQL Server instance hosting the App Service databases and run the following SQL Script to update the database.  You must replace **<mynewfileserver.contoso.local>** with the name of the new file server.

```sql
SELECT * FROM [admin].[WebSystems]
      UPDATE [admin].[WebSystems]
      SET [FileShare] ='\\<mynewfileserver.contoso.local>\websites'
      Where id = 1
 
      SELECT * FROM [runtime].[HostingConfigurations]
      WHERE ConfigurationKey like 'ContentShare'
 
      UPDATE [runtime].[HostingConfigurations]
 
      SET ConfigurationValue = '<mynewfileserver.contoso.local>'
      WHERE ConfigurationKey like 'ContentShare'
```

## Update file server credentials

If the credentials have changed you must update the file share credentials to connect to the new file server (FileShareOwnerCredential and FileShareUserCredential).

1. In the Azure Stack Administration Portal navigate to the **ControllersNSG** Network Security Group
1. By default remote desktop access is disabled to all App Service infrastructure roles.  Modify the **Inbound_Rdp_3389** rule action to **Allow** access.
1. Navigate to the resource group containing the App Service Resource Provider Deployment, by default this is AppService.<region> and connect to **CN0-VM**.
1. Launch the **Web Cloud Management Console**
1. Check in the **Web Cloud Management Console -> Web Cloud**, verify that both **Controllers** are **Ready**
1. Select Credentials <insert screenshot here>.
1. Next select the credential you wish to update – in this case the FileShareOwnerCrdential or the FileShareUserCredential and select edit – either from the menu bar or from the right click context menu. <screenshot>
1. Enter the new credential details and then click OK.
1. Repeat for the FileShareUserCredential if that has changed also.
1. Once you have completed updating the credentials you must **restart CN0-VM**.
1. Wait for **CN0-VM** and verify the role is marked as **Ready** in the Admin Portal -> App Service -> Roles
1. Restart CN1-VM and verify the role is marked as **Ready**
1. Once both controllers are marked as Ready, Repair all other Role instances.  Recommend working through each role type i.e. Management, Front End etc methodically one set at a time.
1. In the Azure Stack Administration Portal navigate back to the **ControllersNSG** Network Security Group
1. Modify the **Inbound_Rdp_3389** rule to deny access.

