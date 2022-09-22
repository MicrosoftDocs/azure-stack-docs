---
title: Migrate File Server  
description: Migrate File Server.
author: apwestgarth
manager: stefsch

ms.topic: article
ms.date: 09/18/2022
ms.author: anwestg
ms.reviewer: 
ms.lastreviewed: 

# Intent: Notdone: As a < type of user >, I want < what? > so that < why? >
# Keyword: Notdone: keyword noun phrase

---
# Migrate File Share

This article provides instructions on how to migrate to the new file server infrastructure for hosting the Azure App Service on Azure Stack Hub Resource Provider content file share.


## Back up App Service secrets
When recovering App Service from backup, you need to provide the App Service keys used by the initial deployment. This information should be saved as soon as App Service is successfully deployed and stored in a safe location. The resource provider infrastructure configuration is recreated from backup during recovery using App Service recovery PowerShell cmdlets.

Use the admin portal to back up App Service secrets by following these steps: 


1. Sign in to the Azure Stack Hub administrator portal as the service admin.

2. Browse to **App Service** -> **Secrets**. 

3. Select **Download Secrets**.

   ![Download secrets in Azure Stack Hub administrator portal](./media/app-service-back-up/download-secrets.png)

4. When secrets are ready for downloading, click **Save** and store the App Service secrets (**SystemSecrets.JSON**) file in a safe location. 

   ![Save secrets in Azure Stack Hub administrator portal](./media/app-service-back-up/save-secrets.png)

> [!NOTE]
> Repeat these steps every time the App Service secrets are rotated.

## Back up the existing App Service file share

App Service stores tenant app info in the file share. This file share must be backed up on a regular basis along with the App Service databases so that as little data as possible is lost if a restore or migration is required.

To back up the App Service file share content, use Azure Backup Server or another method to regularly copy the file share content to the location to which you've saved all previous recovery info.


For example, you can use these steps to use Robocopy from a Windows PowerShell (not PowerShell ISE) console session:

```powershell
$source = "<file share location>"
$destination = "<remote backup storage share location>"
net use $destination /user:<account to use to connect to the remote share in the format of domain\username> *
robocopy $source $destination
net use $destination /delete
```

## Restore the App Service file share content to a new File Server

After [preparing the new file server](azure-stack-app-service-before-you-get-started.md#prepare-the-file-server) to host the App Service file share, you need to restore the tenant file share content from backup. You can use whatever method you have available to copy the files into the newly created App Service file share location. Running this example on the file server will use PowerShell and Robocopy to connect to a remote share and copy the files to the share:


```powershell
$source = "<remote backup storage share location>"
$destination = "<local file share location>"
net use $source /user:<account to use to connect to the remote share in the format of domain\username> *
robocopy /E $source $destination
net use $source /delete
```

In addition to copying the file share contents, you must also reset permissions on the file share itself. To reset permissions, open an admin command prompt on the file server computer and run the **ReACL.cmd** file. The **ReACL.cmd** file is located in the App Service installation files in the **BCDR** directory.

## Migrate the file share

1. In the Azure Stack Hub Administration Portal, navigate to **Network Security Groups** and view the **ControllersNSG** Network Security Group.
1. By default, remote desktop is disabled to all App Service infrastructure roles. Modify the **Inbound_Rdp_2289** rule action to **Allow** access.

1. Navigate to the resource group containing the App Service Resource Provider deployment, by default this is **AppService.\<region\>** and connect to **CN0-VM**.
1. Open an Administrator PowerShell session and run **net stop webfarmservice**
1. Repeat step 3 and 4 for all other controllers.
1. Return to the **CN0-VM** remote desktop session.
1. Copy the App Service secrets file to the controller.
1. In an Administrator PowerShell session run
      ```powershell
      Restore-AppServiceStamp -FilePath <local secrets file> -OverrideContentShare <new file share location> -CoreBackupFilePath <filepath>
      ```
      1. A prompt will appear to confirm the key values, **verify** and **press ENTER** to continue, or close the PowerShell session to cancel.
1. Once the cmdlet has finished, all worker instances from custom worker tiers will be removed, and then added back via the next PowerSHell script
1. In the same administrative PowerShell session or a new Administrative PowerShell session, run:
      ```powershell
      Restore-AppServiceRoles
      ```
   This command will inspect the Virtual Machine Scale Sets associated and perform corresponding actions, including adding back the instances of the custom worker tiers

1. in the same, or a new, administrative PowerShell session run **net start webfarmservice**
1. Repeat the previous step for all other controllers.
1. In the Azure Stack Administration Portal navigate back to the **ControllersNSG** Network Security Group
1. Modify the **Inbound_Rdp_3389** rule to deny access.

## Update file server credentials

If the credentials have changed you must update the file share credentials to connect to the new file server (FileShareOwnerCredential and FileShareUserCredential).

1. In the Azure Stack Administration Portal, navigate to the **ControllersNSG** Network Security Group
1. By default remote desktop access is disabled to all App Service infrastructure roles.  Modify the **Inbound_Rdp_3389** rule action to **Allow** access.
1. Navigate to the resource group containing the App Service Resource Provider Deployment, by default this is AppService.\<region\> and connect to **CN0-VM**.
1. Launch the **Web Cloud Management Console**
1. Check in the **Web Cloud Management Console -> Web Cloud**, verify that both **Controllers** are **Ready**
1. Select Credentials \<insert screenshot here\>.
1. Next select the credential you wish to update – in this case the FileShareOwnerCrdential or the FileShareUserCredential and select edit – either from the menu bar or from the right click context menu. \<screenshot\>
1. Enter the new credential details and then click OK.
1. Repeat for the FileShareUserCredential if that has changed also.
1. Once you have completed updating the credentials you must **restart CN0-VM**.
1. Wait for **CN0-VM** and verify the role is marked as **Ready** in the Admin Portal -> App Service -> Roles
1. Restart CN1-VM and verify the role is marked as **Ready**
1. Once both controllers are marked as Ready, Repair all other Role instances.  Recommend working through each role type i.e. Management, Front End etc methodically one set at a time.
1. In the Azure Stack Administration Portal navigate back to the **ControllersNSG** Network Security Group
1. Modify the **Inbound_Rdp_3389** rule to deny access.

