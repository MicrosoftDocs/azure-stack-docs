---
title: Apply updates for Azure Local disconnected operations
description: Learn how to update disconnected operations for Azure Local.
ms.topic: how-to
author: ronmiab
ms.author: robess
ms.date: 10/07/2026
ms.reviewer: haraldfianbakken
ms.subservice: hyperconverged
ai-usage: ai-assisted
---

# Apply updates for Azure Local disconnected operations

::: moniker range=">=azloc-2602"

This article explains how to update disconnected operations for Azure Local. Learn how to apply updates to the appliance to ensure optimal performance and reliability in disconnected environments.

> [!NOTE]
> You must update Azure Local disconnected operations regularly to stay supported. Establish an update routine as part of your production planning.

## Get updates

Keep your disconnected operations appliance up to date. Follow these steps to download and apply the latest updates.

1. From the Azure portal, navigate to your disconnected operations appliance.
1. Select **Updates** and then select the latest version.
1. Select **Download** and wait for the download to complete in your browser. You can also use the script based download.
1. Verify that you have downloaded the following files: `Docker.wim`, `OS.wim`, `Package.zip`, `EFI.wim`, `Manifest.xml`, `OperationsModule.zip`, and `Notice.txt`.
1. Copy the files to a staging folder on the first machine (seed node), such as `C:\AzureLocalDisconnectedOperations\Update`.
1. Extract `OperationsModule.zip` on the first machine (seed node) to a folder, such as `C:\AzureLocalDisconnectedOperations\Update`.

## Load the OperationsModule

To prepare the seed node for managing disconnected operations, run the following command to load the updated OperationsModule.

```powershell
$applianceConfigBasePath = 'C:\AzureLocalDisconnectedOperations\Update'
# Import the OperationsModule
Import-Module "$applianceConfigBasePath\OperationsModule\Azure.Local.DisconnectedOperations.psd1" -Force    
$password = ConvertTo-SecureString 'RETRACTED' -AsPlainText -Force  
$managementIp = "169.254.53.25"
$context = Set-DisconnectedOperationsClientContext -ManagementEndpointClientCertificatePath "${env:localappdata}\AzureLocalOpModuleDev\certs\ManagementEndpoint\ManagementEndpointClientAuth.pfx" -ManagementEndpointClientCertificatePassword $password -ManagementEndpointIpAddress $managementIp 

# If you previously exported your bitlocker keys - you can skip the prompt asking you for this during update and enable full automation.
$env:BypassBitlockerRecoveryKeysPrompt = $true; 
```

## Upload the update

On the seed node, in the same session as the preceding section, run the following command to upload the update.

```powershell
# Specify the update package path
$updatePath = "C:\AzureLocalDisconnectedOperations\Update\"
$updatePackageResult = Invoke-ApplianceUpdatePackageUpload -UpdatePackagePath $updatePath     
```

## Wait for update staging

On the seed node, in the same session as the preceding section, run the following command to stage the update.

```powershell
Wait-AppliancePreUpdate -TargetVersion $updatePackageResult.UpdatePackageVersion 
```

## Store BitLocker keys

BitLocker keys are used to recover encrypted drives if there's a system failure. Exporting these keys ensures you can access your data if an update or rollback operation encounters issues.

If you didn't export your BitLocker keys, run the following command to export and save them to a file. Keep this file in a secure location.

```powershell
Get-ApplianceBitlockerRecoveryKeys -DisconnectedOperationsClientContext $context|ConvertTo-Json|Set-Content RecoveryKeys.json
```

> [!NOTE]
> Keep your BitLocker keys in a secure location.

## Trigger an update

> [!CAUTION]  
> Before you trigger the update, ensure that your Lightweight Directory Access Protocol (LDAP) credentials are valid and not expired. You can validate your LDAP configuration by using the `Test-ApplianceExternalIdentityConfigurationDeep` cmdlet from the OperationsModule.

On the seed node, in the same session as the preceding section, run the following command to trigger an update.

```powershell
Start-ApplianceUpdate -TargetVersion $updatePackageResult.UpdatePackageVersion -Wait
```

> [!NOTE]  
> Update can take several hours and might reboot the control plane appliance. If update fails, the system attempts to roll back to the last known good state and boot back.

## Get update history

On the seed node, in the same session as the preceding section, run the following command to view the update history.

```powershell
Get-ApplianceUpdateHistory 
```

## Related content

- [Backup for disconnected operations for Azure Local](./disconnected-operations-back-up-restore.md).
- [Update an Azure Local instance running on disconnected operations](./disconnected-operations-update-azure-local-instance.md).

::: moniker-end

::: moniker range="<=azloc-2601"

This feature is available only in Azure Local 2602 or later.

::: moniker-end
