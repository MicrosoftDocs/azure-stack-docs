---
title: Update Disconnected Operations on Azure Local (preview)
description: Learn how to update disconnected operations on Azure Local (preview).
ms.topic: how-to
author: ronmiab
ms.author: robess
ms.date: 01/05/2026
ms.reviewer: haraldfianbakken
ai-usage: ai-assisted
---

# About updates for disconnected operations (preview)

::: moniker range=">=azloc-2511"

This article explains how to get updates for disconnected operations and how to apply an update for the disconnected operations appliance.

[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]

## Get updates

To get updates for disconnected operations, follow these steps:

1. From The Azure portal, navigate to your disconnected operations appliance.
1. Select **Updates** and then select the latest version.
1. Select **Download** and wait for the download to complete.
1. Copy the update file to a staging folder on the first machine (seed node), such as `C:\AzureLocalDisconnectedOperations`.

## Load the OperationsModule

To load the OperationsModule on the seed node, run the following command.

```powershell
$applianceConfigBasePath = 'C:\AzureLocalDisconnectedOperations'
# Import the OperationsModule
Import-Module "$applianceConfigBasePath\OperationsModule\Azure.Local.DisconnectedOperations.psd1" -Force    
```

## Upload the update

On the seed node, in the same session as the preceding section, run the following command to upload the update.

```powershell
# Specify the update package
$updatePath = "C:\AzureLocalDisconnectedOperations\aldo-2512.zip"
$updatePackageResult = Invoke-ApplianceUpdatePackageUpload -UpdatePackagePath $updatePath     
```

## Wait for update staging

On the seed node, in the same session as the preceding section, run the following command to stage the update.

```powershell
Wait-AppliancePreUpdate -TargetVersion $updatePackageResult.UpdatePackageVersion 
```

## Store BitLocker keys

If you didn't export your BitLocker keys, run the following command to export and save them to a file. Keep this file in a secure location.

```powershell
Get-ApplianceBitlockerRecoveryKeys -DisconnectedOperationsClientContext $context|ConvertTo-Json|Set-Content RecoveryKeys.json
```

> [!NOTE]
> Keep your BitLocker keys in a secure location.

## Create appliance snapshot

To roll back quickly in worst case scenarios, we recommend you create a virtual machine (VM) snapshot.

```powershell
Checkpoint-VM -Name "IRVM01" -SnapshotName "BeforeUpdate"
```

## Trigger an update

On the seed node, in the same session as the preceding section, run the following command to trigger an update.

```powershell
Start-ApplianceUpdate -TargetVersion $updatePackageResult.UpdatePackageVersion -Wait
```

> [!NOTE]  
> Caution: Make sure your LDAP credentials are still valid and have not expired prior to triggering update. You can verify your LDAP settings with using the cmdlet Test-ApplianceExternalIdentityConfigurationDeep provided in the operations module. If the LDAP credentials have expired - update and rollback will fail and you will need to revert back to snapshot. 


> [!NOTE]  
> Update can take several hours and might reboot the control plane appliance. If update fails, the system attempts to roll back to the last known good state and boot back.

## Get update history

On the seed node, in the same session as the preceding section, run the following command to view update history.

```powershell
Get-ApplianceUpdateHistory 
```

## Update Azure Local (disconnected)

During this preview release, use the following PowerShell script to patch and update each Azure Local node in a disconnected environment.

```powershell
$applianceFQDN = 'autonomous.cloud.private'
# Reboot the node for this to take effect
[System.Environment]::SetEnvironmentVariable("NUGET_CERT_REVOCATION_MODE", "offline", "Machine")

# Check latest "Check System Update readiness" daily runs
# Expect to see failed runs
$eceClient = Create-ECEClientSimple
$plans = $eceClient.GetActionPlanInstances().Result
$plans | Sort-Object -Property LastModifiedDateTime -Descending | ft InstanceID, ActionPlanName, ActionTypeName, Status, LastModifiedDateTime

#
<# Patch the file c:\NugetStore\Microsoft.AzureStack.Role.SBE.10.2510.1001.2024\content\Helpers\SBESolutionExtensionHelper.psm1
 Insert the following lines on after line 349
 $aldoSupport = [System.Environment]::GetEnvironmentVariable("DISCONNECTED_OPS_SUPPORT", "Machine")
    #Note: order matters here - $true -eq $aldoSupport won't work because $aldoSupport is a string
    if ($null -ne $aldoSupport -and $aldoSupport -eq "True")
    {
        Trace-Execution "Disconnected Operations support is enabled. SBE download is not supported."
        return $false
    }
#>

# Host the OEM SBE manifest and overwrite location 
$OEM = 'HPE'
$SolutionVersion = '12.2512.1002.10'
$client = New-SolutionUpdateClient
$client.SetDynamicConfigurationValue("AutomaticOemUpdateUri", "https://edgeartifacts.blob.$($applianceFQDN)/clouddeployment/SBE_Discovery_$($OEM)$.xml").Wait()
$client.SetDynamicConfigurationValue("AutomaticUpdateUri", "https://fakehost").Wait()
$client.SetDynamicConfigurationValue("UpdateRingName", "Unknown").Wait()

# Re-run "Check System Update readiness"
Invoke-SolutionUpdatePrecheck
# Check "Check System Update readiness" health
Get-SolutionUpdateEnvironment

# Manually add solution update
Add-SolutionUpdate -SourceFolder C:\ClusterStorage\Infrastructure_1\Shares\SU1_Infrastructure_1\import\Solution
# Wait for this to return to make sure the update is ready
Get-SolutionUpdate
# Run the update
Get-SolutionUpdate -Id "redmond/Solution$($solutionVersion)" | Start-SolutionUpdate

Start-MonitoringActionplanInstanceToComplete -EceClient $eceClient -actionPlanInstanceID $actionPlanInstanceID
```

::: moniker-end

::: moniker range="<=azloc-2510"

This feature is available only in Azure Local 2511 and newer.
::: moniker-end

