---
title: Update an Azure Local instance running on disconnected operations
description: Learn how to download and import solution update packages for an Azure Local instance running on disconnected operations.
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.reviewer: arduppal
ms.date: 11/12/2026
ms.subservice: hyperconverged
---

# Update an Azure Local instance running on disconnected operations

This article describes how to identify, download, import, and install an eligible solution update package for an Azure Local instance deployed with disconnected operations.

## Prerequisites

- Before you download an update package, choose an Azure Local solution version that your installed disconnected operations control-plane version supports. The two versions don't need to match. For more information, see [Recommended update sequence and version compatibility](./disconnected-operations-plan-updates.md#recommended-update-sequence-and-version-compatibility).
- Download the latest supported Azure Local update platform expansion pack(s) and install the platform expansion pack to make the Azure Local update available through the local control plane. 
- You can't apply an Azure Local update with a higher major (monthly) version than the control plane version. For example, if you're on Azure Local disconnected operations version 2610.*, you can only apply platform expansion packs for 2610.* for your Azure Local clusters.
- Before you apply your first solution update, run the following command in an elevated PowerShell session on each node of the target Azure Local instance to set the machine-level environment variable:

   ```powershell
   [System.Environment]::SetEnvironmentVariable("NUGET_CERT_REVOCATION_MODE", "offline", "Machine")
   ```

::: moniker range="<=azloc-2604"

## Update an Azure Local instance running on disconnected operations (versions 2602, 2603, and 2604)

> [!IMPORTANT]
> **Azure Local, version 2603 only.** If your Azure Local system is on version 2603, complete steps 1 through 3 before running the update script to exclude a test that requires internet connectivity. If you're on version 2604 or later, skip this section and continue with the script.
>
> **Update from Azure Local, version 2602 to version 2604.** To update your Azure Local system on version 2602 to version 2604, you must first:
> 1. Update disconnected operations from version 2602 to version 2604.
> 1. Then, update Azure Local from version 2602 to version 2603.
> 1. Then, update Azure Local from version 2603 to version 2604.

1. Identify the Azure Local node running the orchestrator service.

   1. Sign in to any Azure Local node and run the following command:

      ```PowerShell
      Get-ClusterGroup
      ```

   1. From the output, identify the node that owns the **Azure Stack HCI Orchestrator Service Cluster Group**.

1. Exclude the internet-dependent test.

   1. Sign in to the node identified in the previous step.
   1. Go to `C:\Program Files\WindowsPowerShell\Modules\AzStackHci.EnvironmentChecker`.
   1. Create a new file named `ExcludeTests.txt`.
   1. Add the following line to the file and save it: ` Test-ARBStackBandwidth`

1. After saving the file, proceed to trigger the update on Azure Local.

Use the following PowerShell script to patch and update each Azure Local node in a disconnected environment.

```powershell
$applianceFQDN = 'autonomous.cloud.private'
# Reboot the node for this to take effect
[System.Environment]::SetEnvironmentVariable("NUGET_CERT_REVOCATION_MODE", "offline", "Machine")

# Check latest "Check System Update readiness" daily runs
# Expect to see failed runs
$eceClient = Create-ECEClientSimple
$plans = $eceClient.GetActionPlanInstances().Result
$plans | Sort-Object -Property LastModifiedDateTime -Descending | ft InstanceID, ActionPlanName, ActionTypeName, Status, LastModifiedDateTime

# Host the OEM SBE manifest and overwrite location
$OEM = 'Replaceme'

$client = New-SolutionUpdateClient
$client.SetDynamicConfigurationValue("AutomaticOemUpdateUri", "https://edgeartifacts.blob.$($applianceFQDN)/clouddeployment/SBE_Discovery_$($OEM).xml").Wait()
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
$SolutionVersion = 'Replaceme' # Use prior output to find the latest supported version

# Run the update
Get-SolutionUpdate -Id "redmond/Solution$($solutionVersion)" | Start-SolutionUpdate

# Run these to monitor
$actionPlanInstanceId = 'ReplaceMe' # Copy output from previous step
Start-MonitoringActionplanInstanceToComplete -EceClient $eceClient -actionPlanInstanceID $actionPlanInstanceID
```

::: moniker-end

::: moniker range=">=azloc-2605"

## Download, import, and install an update package

> [!NOTE]
> Before downloading a solution update from the local control plane, check that you applied any newer Azure Local update Platform expansion packs that might have released after your control plane update. This check ensures that you have the latest Azure Local solution updates in the system before updating the Azure Local instances.   

Follow these steps to download, import, and install a solution update package for your Azure Local instance running on disconnected operations.

1. To update your Azure Local instance to the same version as your installed disconnected operations control plane, download the script for that version from the local disconnected operations endpoint:

   ```https
   https://edgeartifacts.blob.<FQDN>/clouddeployment/Download-SolutionUpdate_<YYMM>.ps1
   ```

   Replace `<FQDN>` with your disconnected operations fully qualified domain name, and `<YYMM>` with your installed disconnected operations control-plane version. For example, if your control-plane version is 2607 and you want to update your Azure Local version to 2607, use the following URL:

   ```https
   https://edgeartifacts.blob.autonomous.cloud.private/clouddeployment/Download-SolutionUpdate_2607.ps1
   ```

1. Run the script. It downloads the update bundle for Azure Local instance from disconnected operations storage.

1. Copy the downloaded solution update package to the cluster storage solution folder: `C:\ClusterStorage\Infrastructure_1\Shares\SU1_Infrastructure_1\import\Solution`.

1. Verify that the folder structure looks like this:

   ```text
   Solution/
   ├── SolutionUpdate.xml
   ├── SolutionUpdate.zip
   ├── Services/
   │   └── AS_Update.zip
   └── Platform/
       └── Platform.zip
   ```

1. Continue with the [import procedure](../update/import-discover-updates-offline-23h2.md#import-the-solution-update-bundle) at the step that runs `Add-SolutionUpdate`, and then verify that the update is discovered.

   For example, use the following PowerShell script to patch and update each Azure Local node in a disconnected environment.

   ```powershell
   $applianceFQDN = 'autonomous.cloud.private'
   # Reboot the node for this to take effect
   [System.Environment]::SetEnvironmentVariable("NUGET_CERT_REVOCATION_MODE", "offline", "Machine")

   # Check latest "Check System Update readiness" daily runs
   # Expect to see failed runs
   $eceClient = Create-ECEClientSimple
   $plans = $eceClient.GetActionPlanInstances().Result
   $plans | Sort-Object -Property LastModifiedDateTime -Descending | ft InstanceID, ActionPlanName, ActionTypeName, Status, LastModifiedDateTime

   # Host the OEM SBE manifest and overwrite location
   $OEM = 'Replaceme'

   $client = New-SolutionUpdateClient
   $client.SetDynamicConfigurationValue("AutomaticOemUpdateUri", "https://edgeartifacts.blob.$($applianceFQDN)/clouddeployment/SBE_Discovery_$($OEM).xml").Wait()
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
   $SolutionVersion = 'Replaceme' # Use prior output to find the latest supported version

   # Run the update
   Get-SolutionUpdate -Id "redmond/Solution$($solutionVersion)" | Start-SolutionUpdate

   # Run these to monitor
   $actionPlanInstanceId = 'ReplaceMe' # Copy output from previous step
   Start-MonitoringActionplanInstanceToComplete -EceClient $eceClient -actionPlanInstanceID $actionPlanInstanceID
   ```

::: moniker-end

## Related content

- [Plan updates for disconnected operations](./disconnected-operations-plan-updates.md)