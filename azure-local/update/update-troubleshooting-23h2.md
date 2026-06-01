---
title: Troubleshoot solution updates for Azure Local, version 23H2
description: Learn how to troubleshoot solution updates applied to Azure Local, version 23H2.
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.date: 06/01/2026
ms.custom: sfi-image-nochange
ms.subservice: hyperconverged
---

# Troubleshoot solution updates for Azure Local

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to troubleshoot solution updates that are applied to your Azure Local instance to keep it up-to-date.

## About troubleshooting updates

If you deployed your system by using a new Azure Local installation, the orchestrator was installed as part of that deployment. The orchestrator manages platform updates, including the OS, drivers and firmware, and agents and services.

The new update solution includes a retry and remediation logic. This logic attempts to fix update issues in a nondisruptive way, such as retrying a Cluster-Aware Update (CAU) run. If an update run can't be remediated automatically, it fails. When an update fails, Microsoft recommends inspecting the details for the failure message to determine the appropriate next action. You can attempt to resume the update, if appropriate, to determine if a retry resolves the issue.

## Troubleshoot readiness checks

[!INCLUDE [about-readiness-checks](../includes/about-readiness-checks.md)]

The troubleshooting steps vary depending on the readiness check scenario.

## Using Azure portal

### Using Azure portal, scenario 1: System health checks

This scenario occurs when preparing to install system updates in Azure Update Manager:

1. In the system list, select the **Update readiness** status. Systems that require attention show a **Critical** or **Warning** state.

    :::image type="content" source="media/troubleshoot-updates/update-manager.png" alt-text="Screenshot of Update Manager page." lightbox="media/troubleshoot-updates/update-manager.png":::


1. Review the list of readiness checks and their results.

    1. Select the links under **Details** to view more information.

    1. When the details box opens, you can view more details, individual system results, and the **Remediation** for failing health checks.

        :::image type="content" source="media/troubleshoot-updates/readiness-checks.png" alt-text="Screenshot of Readiness checks with multiple critical errors, highlighting a storage health check failure and its detailed error message with remediation guidance." lightbox="media/troubleshoot-updates/readiness-checks.png":::

    1. Follow the remediation steps provided to resolve any failures.

    1. After resolving the issues, select **Check again** to rerun the readiness checks.
    
        :::image type="content" source="media/troubleshoot-updates/readiness-check-again.png" alt-text="Screenshot of Readiness checks showing the Check again button." lightbox="media/troubleshoot-updates/readiness-check-again.png":::

### Using Azure portal, scenario 2: Update readiness checks

This scenario occurs when installing and tracking system updates in Azure Update Manager:

1. In **History**, select the failed update run from the list.

1. On the **Validate that the system is ready** tab, review the list of readiness checks and their results.

    1. Select the **View details** links under **Details**.

    1. When the details box opens, you can view more details, individual system results, and the **Remediation** for failing health checks.

    :::image type="content" source="media/troubleshoot-updates/update-progress.png" alt-text="Screenshot of Update progress page." lightbox="media/troubleshoot-updates/update-progress.png":::

    To resolve the failures, follow the remediation instructions, and then select the **Try again** button to retry the pre-update readiness checks and **Resume the update**.

    To further troubleshoot, see the [PowerShell](#using-powershell) section.

## Using PowerShell

### Using PowerShell, scenario 1: System health checks

To troubleshoot system health checks via PowerShell:

1. To validate that the system health checks failed, run the following command on one of the machines in your system:

    ```powershell
    Get-SolutionUpdateEnvironment
    ```

    Here's a sample output:

    ```output
    PS C:\Users\lcmuser> Get-SolutionUpdateEnvironment 
    ResourceId        : redmond  
    SbeFamily         : VirtualForTesting  
    HardwareModel     : Virtual Machine  
    LastChecked       : 9/12/2023 10:34:42 PM  
    PackageVersions   : {Solution: 10.2309.0.20, Services: 10.2309.0.20, Platform: 1.0.0.0, SBE: 4.0.0.0}  
    CurrentVersion    : 10.2309.0.20  
    CurrentSbeVersion : 4.0.0.0  
    LastUpdated       :  
    State             : AppliedSuccessfully  
    HealthState       : Failure 
    HealthCheckResult : {Storage Pool Summary, Storage Services Physical Disks Summary, Storage Services Physical Disks  

                    Summary, Storage Services Physical Disks Summary...}  

    HealthCheckDate   : 9/12/2023 7:03:32 AM  

    AdditionalData    : {[SBEAdditionalData, Solution Builder extension is partially installed. Please install the latest  

                    Solution Builder Extension provided by your hardware vendor.  

                    For more information, see https://aka.ms/SBE.]}  

    HealthState       : Success  
    HealthCheckResult : {}  
    HealthCheckDate   : 8/4/2022 9:10:36 PM 

    PS C:\Users\lcmuser>
    ```

1. Review the `HealthState` on your system and view the `Failure` or `Warning` value.

1. To filter the `HealthCheckResult` property to identify failing tests, run the following command:

    ```powershell
    $result = Get-SolutionUpdateEnvironment
 
    $result.HealthCheckResult | Where-Object {$_.Status -ne "SUCCESS"} | Format-List Title, Status, Severity, Description, Remediation
    ```

    Here's a sample output:

    ```output
    Title       : The machine proxy on each failover cluster node should be set to a local proxy server 
    Status      : FAILURE 
    Severity    : INFORMATIONAL 
    Description : Validating cluster setup for update. 
    Remediation : `https://learn.microsoft.com/en-us/windows-server/failover-clustering/cluster-aware-updating-requirements# 
              tests-for-cluster-updating-readiness`
 
    Title       : The CAU clustered role should be installed on the failover cluster to enable self-updating mode 
    Status      : FAILURE 
    Severity    : INFORMATIONAL 
    Description : Validating cluster setup for update. 
    Remediation : `https://learn.microsoft.com/en-us/windows-server/failover-clustering/cluster-aware-updating-requirements# 
              tests-for-cluster-updating-readiness`
    ```

1. Review the `Remediation` property for the failed tests and take action as appropriate to resolve the failures.

1. If you need more diagnostic information to determine why tests failed, examine the `AdditionalData` property by using the `-FullHealthCheckDetails` parameter:

    ```powershell
    $FullResults = Get-SolutionUpdateEnvironment -FullHealthCheckDetails

    $Failures = $FullResults.HealthCheckResult | Where-Object { $_.Status -ne "SUCCESS" -and $_.Severity -ne "INFORMATIONAL" }

    $Failures | Format-List *
    ```

1. If available, use the diagnostic information shown in `AdditionalData` property, such as 'FailedMachines', 'Source' and/or "ExceptionMessage" to determine which physical machines are causing the test failure. Then use the link in the `Remediation` property to resolve the failures.

1. After you resolve the failure, invoke the system health checks again by running the following command:

    ```powershell
    Invoke-SolutionUpdatePrecheck -SystemHealth
    ```

1. Use `Get-SolutionUpdateEnvironment` to confirm the failing health check failures are resolved. It might take a few minutes for the system health checks to run.

    Here's a sample output:

    ```output
    PS C:\Users\lcmuser>  Get-SolutionUpdateEnvironment | Format-List HealthState, HealthCheckResult, HealthCheckDate 

    HealthState       : InProgress 
    HealthCheckResult : 
    HealthCheckDate   : 1/1/0001 12:00:00 AM 

    PS C:\Users\lcmuser>  Get-SolutionUpdateEnvironment | Format-List HealthState, HealthCheckResult, HealthCheckDate

    HealthState       : Success 

    HealthCheckResult : {Storage Pool Summary, Storage Subsystem Summary, Storage Services Summary, Storage Services 

                    Summary...} 

    HealthCheckDate   : 10/18/2024 11:56:49 PM 
    ```

### Using PowerShell, scenario 2: Update readiness checks

When update readiness checks fail, the system update also fails. To troubleshoot update readiness checks via PowerShell:

1. To verify that update readiness checks failed, run the following command on one machine in your system to find the `ResourceId` of the update:

    ```powershell
   Get-SolutionUpdate | Format-Table ResourceId, State, Version
    ```

    Here's a sample output:

    ```output
    PS C:\Users\lcmuser> Get-SolutionUpdate | Format-Table ResourceId, State, Version

    ResourceId                     State                  Version 
    ----------                     -----                  -------
    redmond/Solution10.2405.2.7    HealthCheckFailed      10.2405.2.7

    ```

1. Using the update `ResourceId` from the previous command's output, run the following command and replace the `Id` parameter with that value:

    ```powershell
    Get-SolutionUpdate -Id <Resource ID> | Format-Table Version, State, HealthCheckResult
    ```

    Here's a sample output:

    ```output
    PS C:\Users\lcmuser> Get-SolutionUpdate -Id redmond/Solution10.2405.2.7 | Format-Table Version, State, HealthCheckResult 

    Version     State              HealthCheckResult 
    -------     -----              ----------------- 
    10.2405.2.7 HealthCheckFailed {Storage Subsystem Summary, Storage Pool Summary, Storage Services Physical Disks Summary, Stora...                       

    PS C:\Users\lcmuser>
    ```

1. Review the `State` for the update and view the `HealthCheckResult` value.

1. To filter the `HealthCheckResult` property and identify failed tests, run the following command. Replace the `Id` value with the update `ResourceId` from the previous command.

    ```powershell
    $result = Get-SolutionUpdate -Id <Resource ID>
    $result.HealthCheckResult | Where-Object {$_.Status -ne "SUCCESS"} | Format-List Title, Status, Severity, Description, Remediation
    ```

    Here's a sample output:

    ```output
    Title       : The machine proxy on each failover cluster node should be set to a local proxy server 
    Status      : FAILURE 
    Severity    : INFORMATIONAL 
    Description : Validating cluster setup for update. 
    Remediation : https://learn.microsoft.com/en-us/windows-server/failover-clustering/cluster-aware-updating-requirements# 
              tests-for-cluster-updating-readiness 
 
    Title       : The CAU clustered role should be installed on the failover cluster to enable self-updating mode 
    Status      : FAILURE 
    Severity    : INFORMATIONAL 
    Description : Validating cluster setup for update. 
    Remediation : https://learn.microsoft.com/en-us/windows-server/failover-clustering/cluster-aware-updating-requirements# 
              tests-for-cluster-updating-readiness
     ```

1. Use the link in the `Remediation` property for the failed test. Open the article on a device with a web browser, and follow the recommended steps to resolve the failures.

1. If you need more diagnostic information to determine why tests failed, examine the `AdditionalData` property by using the `-FullHealthCheckDetails` parameter:

    ```powershell
    $FullResults = Get-SolutionUpdate -Id <Resource ID> -FullHealthCheckDetails

    $Failures = $FullResults.HealthCheckResult | Where-Object { $_.Status -ne "SUCCESS" -and $_.Severity -ne "INFORMATIONAL" }

    $Failures | Format-List *
    ```

1. If available, use diagnostic details in the `AdditionalData` property, such as 'FailedMachines', 'Source', and "ExceptionMessage", to identify which physical machines caused the test failure. Then use the link in the `Remediation` property to resolve the failures.

1. After you resolve the failure, invoke the update readiness checks again by running the following command

    ```powershell
    Get-SolutionUpdate -Id <Resource ID> | Start-SolutionUpdate -PrepareOnly
    ```

## Troubleshoot update failures

When an update fails, review detailed step progress to identify the point of failure. This review helps you determine whether you can resolve the issue by repairing and resuming the update or whether you need to contact support.

- Failing step name and description.

- Which machine or server the step failed on (if there's a machine-specific issue).

- Failure message string (might pinpoint the issue to a specific known issue with documented remediation).

Microsoft recommends using the Azure portal to identify failing step details, as described in [Resume an update](#the-azure-portal). Alternatively, see the next section for similar details in PowerShell by using `Start-MonitoringActionplanInstanceToComplete`.

The following table lists update failure scenarios and remediation guidelines.

| Step names | Type of issue | Remediation |
| --- | --- | --- |
| Any | Power loss or other similar interruption to system during the update. | 1. Restore power.<br>2. Run a system health check.<br>3. Resume the update.  |
| CAU updates | Cluster Aware Update (CAU) update run fails with a `max retries exceeded` failure. | If multiple CAU attempts fail, investigate the first failure.<br><br>Use the start and end time of the first failure to match up with the correct `Get-CauReport` output to further investigate the failure.  |
| Any | Memory, power supply, boot driver, or similar critical failure on one or more nodes. | See [Repair a node on Azure Local](../manage/repair-server.md) for how to repair the failing node.<br>After the node is repaired, the update can be resumed. |

## Collect update logs

You can also collect diagnostic logs to help Microsoft identify and fix the issues.

To collect logs for updates using the Azure portal, see [Resume an update](#the-azure-portal).

To collect logs for the update failures see [Collect diagnostic logs for Azure Local](../manage/collect-logs.md?tabs=azureportal.md).

## View update summary report

To view a detailed update summary report using PowerShell, follow these steps on the client that you're using to access your system:

1. Establish a remote PowerShell session with the machine. Run PowerShell as administrator and run the following command:

    ```powershell
    Enter-PSSession -ComputerName <machine_IP_address> -Credential <username\password for the machine>
    ```

1. Get all the solutions updates and then filter the solution updates corresponding to a specific version. The version used corresponds to the version of solution update that failed to install.

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

To resume a previously failed update run, you can retry the update run via the Azure portal or PowerShell.

### The Azure portal

We highly recommend using the Azure portal, to browse to your failed update and select the **Try again** button. This functionality is available at the Download updates, Validate that the system is ready, and Install updates stages of an update run.

:::image type="content" source="media/troubleshoot-updates/try-again-update.png" alt-text="Screenshot of the retry failed update button." lightbox="media/troubleshoot-updates/try-again-update.png":::

If you're unable to successfully rerun a failed update or need to troubleshoot an error further, follow these steps:

1. Select the **View details** of an error.

2. When the details box opens, you can review the error details. For more information on collecting diagnostic logs, select the **How to collect logs** link near the **Open a support ticket** button.

    [:::image type="content" source="media/troubleshoot-updates/download-error-logs.png" alt-text="Screenshot to download error logs.":::](media/troubleshoot-updates/download-error-logs.png#lightbox)


    For more information on retrieving logs, see [Collect diagnostic logs for Azure Local](../manage/collect-logs.md).

3. Additionally, you can select the **Open a support ticket** button, fill in the appropriate information, and attach your logs so that they're available to Microsoft Support.

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

## Next steps

Learn more about how to [Run updates via PowerShell](./update-via-powershell-23h2.md).

Learn more about how to [Run updates via the Azure portal](./azure-update-manager-23h2.md).
