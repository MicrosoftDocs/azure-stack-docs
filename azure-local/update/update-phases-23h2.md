---
title: Understand Update Phases of Azure Local
description: Understand the various phases of solution updates applied to Azure Local.
author: dominicbetts
ms.author: dobett
ms.topic: concept-article
ms.date: 10/26/2026
ms.subservice: hyperconverged
---

# Understand update phases of Azure Local

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes the preparation and installation phases of the Azure Local update workflow, including how updates are downloaded, validated, health-checked, and installed. It also explains how update progress is reported at various stages.

For more detailed information on progress reporting, see [Use Azure Update Manager to update Azure Local](azure-update-manager-23h2.md) and [Update Azure Local via PowerShell](update-via-powershell-23h2.md).

## Overview

Azure Local updates follow a two-phase workflow:

1. **Preparation**: Download content, validate and extract packages, and run health checks to confirm the cluster is ready.
1. **Installation**: Apply the update across the cluster via an orchestrated action plan.

Each stage produces an `UpdateRun` resource that records step-by-step progress, timing, and any errors encountered. You can query the details of this run on the **Update Progress** page in Azure Update Manager or by using the `Get-SolutionUpdateRun` cmdlet in PowerShell.

:::image type="content" source="media/update-phases/update-phases-actions.png" alt-text="Diagram of update process with Preparation phase and Installation phase steps." lightbox="media/update-phases/update-phases-actions.png":::

## Preparation phase

1. Meet prerequisites

    Before preparation, the system can discover an update but show it in one of the following states that mean the update isn't yet eligible to enter preparation.

    | State | Meaning |
    | --- | --- |
    | `AdditionalContentRequired` | The update package requires hardware vendor content. This requirement applies to Solution Builder Extension (SBE) updates and combined Solution plus SBE updates. The installed SBE package from the hardware vendor doesn't support automatic download of that content.<br/><br/>If the update is in the `AdditionalContentRequired` state, you must import the content before you can begin preparation or installation. For more information, see [Solution Builder Extension updates for your Azure Local](./solution-builder-extension#the-additionalcontentrequired-update-state). |
    | `HasPrerequisite` | The update requires one or more updates to be installed prior to it. Review what is currently installed by using `Get-SolutionUpdate` and compare the installed `CurrentVersion` and `CurrentSBEVersion` to the values listed in the update's `Prerequisites` list. |
    | `Invalid` | The update doesn't match the hardware model for the cluster. This state is most often seen after you use `Add-SolutionUpdate` to locally import an update, such as a Solution Builder Extension (SBE), that doesn't match the hardware model or family. If you see this state, ensure you're adding updates for the proper SBE family that matches your server model. For more information, see [Solution Builder Extension updates for your Azure Local](./solution-builder-extension#identify-a-solution-builder-extension-update-for-your-hardware).<br/><br/>This update remains in the update list once added and should be ignored. |
    | `Obsolete` | There's already a higher version of this type of update installed. You can't install older versions.<br/><br/>No action is needed to clean up this update - it will be removed automatically after a grace period. |

1. Trigger update (optional)

    The preparation phase is triggered as part of starting every update; however, you have the option to independently run the preparation without also triggering the installation phase. For more information, see the [Installation phase](./update-phases-23h2.md#installation-phase).

    - To only perform the preparation phase, start the update by running `Start-SolutionUpdate -PrepareOnly`. This step downloads and validates update content and runs health checks without starting the installation. Use it to pre-stage updates or validate cluster readiness before a maintenance window.
    - To perform both the preparation phase and the [Installation phase](./update-phases-23h2.md#installation-phase), start the update by running `Start-SolutionUpdate`.

1. Complete preparation

    After the update is triggered, the preparation workflow runs several phases in sequence. The following section describes each phase.

### Run preparation phases

The preparation workflow moves through the following phases in order.

#### Download

The download phase retrieves the update package from the configured update source.

- **Standard download**: The Update Service downloads the main solution update package (NuGet bundles) directly from the update catalog.
- **Progress tracking**: The `ProgressPercentage` field on the `UpdateStateProperties` property on the Update reports download progress as a value from 0 to 100.

During this phase, the Update object transitions to the `Downloading` state. On failure, the state becomes `DownloadFailed`.

##### SBE download connector (if applicable)

Any update that includes an SBE update requires extra content from the hardware vendor. If the SBE provides a download connector, the Update Service uses it to handle part of the download:

- The Update Service checks whether the installed SBE supports a download connector.
- If supported, an Orchestrator action plan invokes the SBE download action to retrieve hardware vendor packages such as firmware and drivers.
- The hardware vendor typically includes a download connectivity health check that must pass before the download starts.

If download fails while using the SBE download connector, the update state becomes `DownloadFailed`. To see the detailed failure message, examine the preparation details in Azure Update Manager in the portal, or use the `UpdateRun` object from `Get-SolutionUpdateRun`.

#### Validate and extract

After all content is downloaded, the Update Service validates file integrity and extracts the update files.

If validation or extraction fails, the `UpdateRun` records the error and the Update state becomes `PreparationFailed`.

#### Health check

Before installation, the cluster runs pre-update health checks. These checks validate that the cluster is in a healthy state. They also identify any issues that could interfere with a successful installation.

Each health check has an assigned severity level:

| Severity | Effect |
| --- | --- |
| **Critical** | Blocks the update. You must fix these issues before installation can proceed. |
| **Warning** | Blocks the update by default. You can override these issues by using `Start-SolutionUpdate -IgnoreWarnings`. |
| **Informational** | Advisory only. Doesn't block installation. |

If you start the update in `-PrepareOnly` mode, the Update changes to the `ReadyToInstall` state when the health checks pass. If the health checks find critical or warning issues (and you don't specify `-IgnoreWarnings`), the status becomes `HealthCheckFailed`.

To inspect the health check results:

- For Azure Local release 2610 or newer, run:

    ```powershell
    Get-SolutionHealthSummary
    ```

    When a pre-update health check fails, the default `Get-SolutionHealthSummary` syntax shows the details of the blocking failures. For more information, see [Use the Get-SolutionHealthSummary PowerShell command](../manage/use-get-solution-health-summary-powershell-command.md).

- For previous releases of Azure Local, run:

    ```powershell
    (Get-SolutionUpdate).HealthCheckResult |
    Where-Object { ($_.Status -ne "Success") -and ($_.Severity -ne "Informational") } |
    Format-List Title, Status, Severity, Description, Remediation
    ```

By default, an update in the `ReadyToInstall` state transitions to a `HealthCheckExpired` state after three days. If an update installation is triggered in this state, the health check repeats before starting the installation action plan.

For help with troubleshooting updates, see [Troubleshoot updates](update-troubleshooting-23h2.md). For help with troubleshooting health check failures, see [Troubleshoot health check failures](../manage/troubleshoot-health-check-failures.md#preupdate-health-checks).

## Monitor the preparation phase

Use the `Get-SolutionUpdateRun` cmdlet to monitor the preparation phase.

Each time you run `Start-SolutionUpdate`, with or without `-PrepareOnly`, you create an `UpdateRun` resource. To retrieve the preparation step details, use:

```powershell
# Get the most recent update run for an update
Get-SolutionUpdate -Id <UpdateResourceId> | Get-SolutionUpdateRun | % Progress | % Steps
```

When a preparation run fails, the `UpdateRun` `State` property is set to `Failed`, and the Progress step tree contains error details at the step that encountered the problem.

## Installation phase

The update enters the installation phase when you run `Start-SolutionUpdate` without the `-PrepareOnly` parameter.

When you start the update this way, installation begins:

- **Immediately** - if you recently executed the preparation phase and the update is already in the `ReadyToInstall` state.
- **After preparation completes** - if the update isn't already prepared and is only in the `Ready` state.

### Start installation

To start a full update that includes both preparation and installation, use:

```powershell
# Start a full update (preparation + installation)
Get-SolutionUpdate -Id <UpdateResourceId> | Start-SolutionUpdate
```

When the installation begins, the **Update state** changes to **Installing**, and a new `UpdateRun` is created. This `UpdateRun` represents the progress of the installation and replaces the `UpdateRun` that previously represented preparation.

### Installation progress

During installation, the `UpdateRun` `Progress` property contains the full action plan execution tree. This property is a hierarchical structure of `Step` objects where each step represents a stage, role, or individual task in the update.

Each step in the progress tree exposes the following properties:

| Property | Type | Description |
| --- | --- | --- |
| Name | string | Name of the step or task |
| Description | string | Human-readable description |
| Status | string | `InProgress`, `Success`, or `Error` |
| StartTimeUtc | DateTime | When the step started executing |
| EndTimeUtc | DateTime | When the step completed or failed |
| ErrorMessage | string | Error details if the step failed |
| ExpectedExecutionTime | TimeSpan | Estimated duration for progress calculation |
| Steps | Step[] | Child steps forming the execution tree |

### Monitor installation progress

Because the `UpdateRun` object has a complex structure, monitor update installation status through the Azure portal.

:::image type="content" source="media/update-phases/update-run-structure.png" alt-text="Screenshot of the UpdateRun structure." lightbox="media/update-phases/update-run-structure.png":::

To monitor the update in PowerShell, monitor the state of the underlying action plan directly.

> [!NOTE]
> Use the `Start-MonitoringActionplanInstanceToComplete` cmdlet only after the system installs the 2503 update. Before 2503, using this cmdlet to monitor update progress can cause failures in the orchestration.

```powershell
# Get the action plan instance ID from the update run, then monitor
$run = Get-SolutionUpdate | where State -eq "Installing" | Get-SolutionUpdateRun | where State -eq "InProgress"
$id = ($run.ResourceId -split '/')[-1]
Start-MonitoringActionplanInstanceToComplete -actionPlanInstanceID $id
```

This command provides real-time console output that refreshes automatically. Press **Ctrl+C** to exit the monitor without stopping the update.

### Installation state changes

The update moves through these states during installation:

| State | Meaning |
| --- | --- |
| `Installing` | Installation is actively running. |
| `Installed` | The update finished installing successfully. |
| `InstallationFailed` | One or more steps failed. |

### Troubleshoot installation failures

When installation fails, review the failure details in the Azure portal or by using the `Get-SolutionUpdateRun` cmdlet. For troubleshooting guidance, see [Troubleshoot updates](update-troubleshooting-23h2.md).

After you review and mitigate the failure, or determine it's transient, resume the update from the Azure portal or by using the `Start-SolutionUpdate` cmdlet:

```powershell
Get-SolutionUpdate | where State -eq "InstallationFailed" | Start-SolutionUpdate
```

After you run this cmdlet, the update state changes from `InstallationFailed` to `Installing`.

## Next steps

Learn more about how to [Troubleshoot updates](./update-troubleshooting-23h2.md).
