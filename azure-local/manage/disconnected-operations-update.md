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
- Click 'Updates'
- Click the latest version
- Click download
- Wait for the download to complete
 
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

> [!NOTE]  
> Update can take several hours and might reboot the control plane appliance. If update fails , the system will attempt to rollback to the last known good state and boot back. 

## Get update history
On the seed node, in the same session as above, run the following to view update history

```powershell
Get-ApplianceUpdateHistory 
```

## Update Azure Local - disconnected 
During this preview release, please take a look at the following Powershell script that can be run to patch and update each Azure Local node in a disconnected environment.

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
    # note: order matters here - $true -eq $aldoSupport won't work because $aldoSupport is a string
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

# Re run "Check System Update readiness"
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

This feature is available only in Azure Local 2511 and newer
::: moniker-end

