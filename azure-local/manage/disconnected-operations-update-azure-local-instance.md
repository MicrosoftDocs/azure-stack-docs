---
title: Update an Azure Local instance running on disconnected operations
description: Learn how to download and import solution update packages for an Azure Local instance running on disconnected operations.
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.reviewer: arduppal
ms.date: 10/30/2026
ms.subservice: hyperconverged
---

# Update an Azure Local instance running on disconnected operations

This article describes how to identify, download, import, and install an eligible solution update package for an Azure Local instance deployed with disconnected operations.

## Prerequisites

- Before you download an update package, choose an Azure Local solution version that your installed disconnected operations control-plane version supports. The two versions don't need to match. For more information, see [Recommended update sequence and version compatibility](./disconnected-operations-plan-updates.md#recommended-update-sequence-and-version-compatibility).

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

Use one of the following options to download an eligible update package.

### Option 1 (recommended): Download the update package by using a script

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

### Option 2: Download the update package from Microsoft Learn

Download the update package on an internet-connected machine. Then transfer it into the disconnected environment and copy it to the target Azure Local instance before following the import procedure.

1. Review the [recommended update sequence and version compatibility](./disconnected-operations-plan-updates.md#recommended-update-sequence-and-version-compatibility) for the Azure Local instance running on your disconnected operations version.
1. Review [Azure Local release information](../release-information-23h2.md#about-azure-local-releases) to determine the update path for your Azure Local instance.
1. After you identify an eligible version, [download the solution update bundle](../update/import-discover-updates-offline-23h2.md#solution-update-bundle).
1. [Import the solution update bundle](../update/import-discover-updates-offline-23h2.md#import-the-solution-update-bundle).

### Option 3: Download the update package from the Azure portal

Download the update package on an internet-connected machine. Then transfer it into the disconnected environment and copy it to the target Azure Local instance before following the import procedure.

If your Azure subscription has access to Azure Local disconnected operations, you can download an eligible update package from the Azure portal.

1. In the Azure portal, go to **Azure Arc** > **Azure Local** > **Azure Local Hyperconverged & Disaggregated (Get started)** > **Download and Install** > **Download Azure Local updates**.
1. On the **Download Azure Local update** page, select **Azure Local instance is in a disconnected environment**.
1. Select your current disconnected operations version and your current Azure Local solution version.
1. From the eligible updates, select the version you want, and then select **Download package**.

   :::image type="content" source="media/disconnected-operations-update-azure-local-instance/download-update.png" alt-text="Screenshot of the Download Azure Local update page in the Azure portal." lightbox="media/disconnected-operations-update-azure-local-instance/download-update.png":::

1. After downloading the package, follow the instructions to [Import the solution update bundle](../update/import-discover-updates-offline-23h2.md#import-the-solution-update-bundle).

::: moniker-end

## Related content

- [Plan updates for disconnected operations](./disconnected-operations-plan-updates.md)