---
title: Update disconnected operations on Azure Local (preview)
description:  Learn how to update disconnected operations on Azure Local (preview).
ms.topic: how-to
author: hafianba
ms.author: hafianba
ms.date: 12/22/2025
ai-usage: ai-assisted
---

# About update

::: moniker range=">=azloc-2511"

This article explains how to get updates for disconnected operations and how to apply an update for the disconnected operations appliance. . 

[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]

## Get updates
- From The Azure Portal, navigate to your disconnected operations appliance
- Hit 'Updates'
- Click the latest version
- Click download
- Observe the update file downloading and complete

Once update has been downloaded, copy the update file into the seed node in a staging folder e.g. C:\AzureLocalDisconnectedOperations 

## Load the Operationsmodule 
On the seed node, load the OperationsModule
```powershell 
$applianceConfigBasePath = 'C:\AzureLocalDisconnectedOperations'
# Import the OperationsModule
Import-Module "$applianceConfigBasePath\OperationsModule\Azure.Local.DisconnectedOperations.psd1" -Force    
```

## Upload update
On the seed node, in the same session as above, run the following
```powershell

# Specify the update package
$updatePath = "C:\AzureLocalDisconnectedOperations\aldo-2512.zip"
$updatePackageResult = Invoke-ApplianceUpdatePackageUpload -UpdatePackagePath $updatePath     
```

## Wait for update staging
On the seed node, in the same session as above, run the following
```powershell
Wait-AppliancePreUpdate -TargetVersion $updatePackageResult.UpdatePackageVersion 
```

## Store bitlocker keys (if you haven't)
If you have not exported your bitlocker keys - please run the following to export the keys and save them to a file. Please move and keep this file safe.
```powershell
Get-ApplianceBitlockerRecoveryKeys -DisconnectedOperationsClientContext $context|ConvertTo-Json|Set-Content RecoveryKeys.json
```
## Create appliance snapshot
In order to roll back quickly for worst case scenarios, we recommend creating a VM Snapshot
```powershell
Checkpoint-VM -Name "IRVM01" -SnapshotName "BeforeUpdate"
```
## Trigger update
On the seed node, in the same session as above, run the following

```powershell
Start-ApplianceUpdate -TargetVersion $updatePackageResult.UpdatePackageVersion -Wait
```
## Get update history
On the seed node, in the same session as above, run the following to view update history

```powershell
Get-ApplianceUpdateHistory 
```
::: moniker-end

::: moniker range="<=azloc-2510"

This feature is available only in Azure Local 2511 and newer
::: moniker-end

