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
