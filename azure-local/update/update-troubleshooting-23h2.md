---
title: Troubleshoot solution updates for Azure Local, version 23H2
description: Learn how to troubleshoot solution updates applied to Azure Local, version 23H2.
author: dominicbetts
ms.author: dobett
ms.topic: how-to
ms.date: 10/19/2026
ms.custom: sfi-image-nochange
ms.subservice: hyperconverged
---

# Troubleshoot solution updates for Azure Local

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to troubleshoot solution updates that you apply to your Azure Local instance to keep it up-to-date.

## About troubleshooting updates

If you deploy your system by using a new Azure Local installation, you install the orchestrator as part of that deployment. The orchestrator manages platform updates, including the OS, drivers and firmware, and agents and services.

The new update solution includes retry and remediation logic. This logic attempts to fix update problems in a nondisruptive way, such as retrying a Cluster-Aware Update (CAU) run. If an update run can't be remediated automatically, it fails. When an update fails, inspect the details for the failure message to determine the appropriate next action. You can attempt to resume the update, if appropriate, to determine if a retry resolves the problem.

## Identify which step failed

When an update fails, review the detailed step progress to identify the point of failure. This review helps you determine whether you can resolve the issue by repairing and resuming the update or whether you need to contact support.

- Failing step name and description.

- The machine or server where the step failed (if there's a machine-specific issue).

- Failure message string (might pinpoint the issue to a specific known issue with documented remediation).

Use the Azure portal to identify failing step details, as described in [Resume an update](#the-azure-portal). Alternatively, see the next section for similar details in PowerShell by using `Start-MonitoringActionplanInstanceToComplete`.

The following table lists update failure scenarios and remediation guidelines.

| Step names | Type of issue | Remediation |
| --- | --- | --- |
| Any | Known issue | 1. Review [release notes with fixed and known issues](../known-issues.md) for the installed version of Azure Local and the version to which you're updating.<br>2. Search the [official technical support guides](https://github.com/Azure/AzureLocal-Supportability/tree/main/TSG) (see [Searching for known issues in Azure Local release notes](#searching-for-known-issues-in-azure-local-release-notes)).<br>3. If installing an SBE update, review the SBE known issues documented by your hardware vendor. |
| Any | Power loss or other similar interruption to system during the update. | 1. Restore power.<br>2. Run a system health check.<br>3. Resume the update. |
| CAU updates | Cluster Aware Update (CAU) update run fails with a `max retries exceeded` failure. | If multiple CAU attempts fail, investigate the first failure.<br><br>Use the start and end time of the first failure to match up with the correct `Get-CauReport -Detailed` output to further investigate the failure. |
| Any | Memory, power supply, boot driver, or similar critical failure on one or more nodes. | See [Repair a node on Azure Local](../manage/repair-server.md) for how to repair the failing node.<br>After the node is repaired, resume the update. |

## Searching for known issues in Azure Local release notes

The Azure Local release notes list known issues specific to each version of Azure Local. If you're troubleshooting an update issue, look at the release notes for the version of Azure Local to which you're updating (the newer "to" version for your update). If you're troubleshooting a daily system update readiness (system health check) failure, a preupdate health check failure, or a failure to start the update, review the release notes for the installed version of Azure Local (the "from" version for your update).

## Searching for known issues in GitHub

The [AzureLocal-Supportability/TSG](https://github.com/Azure/AzureLocal-Supportability/tree/main/TSG) GitHub repository is the official source of Technical Support Guide (TSG) articles that document known issues and their mitigations.

Based on the update step that's failing, you might be able to find the proper article by browsing the repository. For example, if you're having an issue with `Get-SolutionUpdate`, start by looking in the Update directory. Otherwise, search based on your specific exception message or the step that is failing.

If you have an error message like the following:

```powershell
Type 'AfterOSPlatformUpdate' of Role 'ComposedImageUpdate' raised an exception: Exception calling 'OnAfterOSSolutionUpdate' with '1' argument(s): 'Registry path 'SYSTEM\\CurrentControlSet\\Services\\VSR' not found.' at AfterOSPlatformUpdate.
```

Search for key words in the exception message (such as `OnAfterOSSolutionUpdate`) or the failing type (`AfterOSPlatformUpdate`) separately to increase your chance of finding the proper article. This search method works because different versions of Azure Local might have variations of the exception messages, whereas the `Type` values change less often.)

## Collect update logs

You can also collect diagnostic logs to help Microsoft identify and fix the issues.

To collect logs for updates by using the Azure portal, see [Resume an update](#the-azure-portal).

To collect logs for the update failures, see [Collect diagnostic logs for Azure Local](../manage/collect-logs.md?tabs=azureportal.md).

## View update summary report

To view a detailed update summary report by using PowerShell, follow these steps on the client that you're using to access your system:

1. Establish a remote PowerShell session with the machine. Run PowerShell as an administrator and run the following command:

    ```powershell
    Enter-PSSession -ComputerName <machine_IP_address> -Credential <username\password for the machine>
    ```

1. Get all the solutions updates, and then filter the solution updates that correspond to a specific version. The version you use corresponds to the version of solution update that failed to install.

    ```powershell
    $Update = Get-SolutionUpdate | ? Version -eq "<Version string>" -verbose
    ```

1. Identify the action plan for the failed solution update run.

    ```powershell
    $Failure = $update | Get-SolutionUpdateRun
    ```

1. Identify the `ResourceID` for the update.

    ```powershell
    $Failure
    ```

    Here's a sample output:

    ```output
    PS C:\Users\lcmuser> $Update = Get-SolutionUpdate | ? Version -eq "10.2303.1.7" -verbose
    PS C:\Users\lcmuser> $Failure = $Update | Get-SolutionUpdateRun
    PS C:\Users\lcmuser> $Failure

    ResourceId      : redmond/Solution10.2303.1.7/a0a0a0a0-bbbb-cccc-dddd-e1e1e1e1e1e1
    Progress        : Microsoft.AzureStack.Services.Update.ResourceProvider.UpdateService.Models.Step
    TimeStarted     : 4/21/2023 10:02:54 PM
    LastUpdatedTime : 4/21/2023 3:19:05 PM
    Duration        : 00:16:37.9688878
    State           : Failed
    ```

    Note the `ResourceID` GUID. This GUID corresponds to the `ActionPlanInstanceID`.

1. View the summary for the `ActionPlanInstanceID` that you noted earlier.

    ```powershell
    Start-MonitoringActionplanInstanceToComplete -actionPlanInstanceID <Action Plan Instance ID>
    ```

    Here's sample output:

    ```output
    PS C:\Users\lcmuser> Start-MonitoringActionplanInstanceToComplete -actionPlanInstanceID a0a0a0a0-bbbb-cccc-dddd-e1e1e1e1e1e1
    ```

   :::image type="content" source="./media/troubleshoot-updates/collect-logs-powershell.png" alt-text="Screenshot of PowerShell collect logs output." lightbox="./media/troubleshoot-updates/collect-logs-powershell.png":::

## Resume an update

To resume a previously failed update run, retry the update run through the Azure portal or PowerShell.

### The Azure portal

Use the Azure portal to browse to your failed update and select the **Try again** button. You can find this functionality at the Download updates, Validate that the system is ready, and Install updates stages of an update run.

:::image type="content" source="media/troubleshoot-updates/try-again-update.png" alt-text="Screenshot of the retry failed update button." lightbox="media/troubleshoot-updates/try-again-update.png":::

If you can't successfully rerun a failed update or need to troubleshoot an error further, follow these steps:

1. Select the **View details** of an error.

1. When the details box opens, review the error details. For more information on collecting diagnostic logs, select the **How to collect logs** link near the **Open a support ticket** button.

    [:::image type="content" source="media/troubleshoot-updates/download-error-logs.png" alt-text="Screenshot to download error logs.":::](media/troubleshoot-updates/download-error-logs.png#lightbox)


    For more information on retrieving logs, see [Collect diagnostic logs for Azure Local](../manage/collect-logs.md).

1. Select the **Open a support ticket** button. Fill in the appropriate information, and attach your logs so that they're available to Microsoft Support.

    [:::image type="content" source="media/troubleshoot-updates/open-support-ticket.png" alt-text="Screenshot to open a support ticket.":::](media/troubleshoot-updates/open-support-ticket.png#lightbox)


For more information on creating a support ticket, see [Create a support request](/azure/azure-portal/supportability/how-to-create-azure-support-request#create-a-support-request).

### PowerShell

If you're using PowerShell and need to resume a previously failed update run, use the following command:

```powershell
Get-SolutionUpdate | ? Version -eq "10.2302.0.31" | Start-SolutionUpdate
```

To resume a previously failed update due to update health checks in a **Warning** state, use the following command:

```powershell
Get-SolutionUpdate | ? Version -eq "10.2302.0.31" | Start-SolutionUpdate -IgnoreWarnings
```

## See also

- [Run updates via PowerShell](./update-via-powershell-23h2.md)
- [Run updates via the Azure portal](./azure-update-manager-23h2.md)
- [Use the `Get-SolutionHealthSummary` PowerShell command](../manage/use-get-solution-health-summary-powershell-command.md)
- [Troubleshoot health check failures](../manage/troubleshoot-health-check-failures.md)
