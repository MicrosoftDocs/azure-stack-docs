---
title: Troubleshoot solution updates for Azure Local, version 23H2
description: Learn how to troubleshoot solution updates applied to Azure Local, version 23H2.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.date: 11/25/2024
---

# Troubleshoot solution updates for Azure Local, version 23H2

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to troubleshoot solution updates that are applied to your Azure Local to keep it up-to-date.

## About troubleshooting updates

If your system was created via a new deployment of Azure Local, version 23H2, then an orchestrator was installed during the deployment. The orchestrator manages all of the updates for the platform - OS, drivers and firmware, agents and services.

The new update solution includes a retry and remediation logic. This logic attempts to fix update issues in a non-disruptive way, such as retrying a Cluster-Aware Update (CAU) run. If an update run can't be remediated automatically, it fails. When an update fails, Microsoft recommends inspecting the details for the failure message to determine the appropriate next action. You can attempt to resume the update, if appropriate, to determine if a retry will resolve the issue.

### Troubleshoot readiness checks

There are two scenarios in which the readiness checks are performed, and they are reported separately:

- System health checks run once every 24 hours.

- Update readiness checks run after the update content is downloaded and before it begins installing.

It is not uncommon for the results of the system health checks and update readiness checks to differ. This is because the validation for update readiness checks use the latest validation logic from the solution update to be installed. Conversely, the system health checks always use validation logic from the installed version.

Both system and pre-update readiness checks perform similar validation and categorize severity of failures as Critical, Warning, or Informational:

- **Critical** failures must be remediated before updates can be installed.

- **Warning** failures may impact updates and Microsoft recommends that they be remediated unless you are certain they are safe to ignore. If you wish to ignore the warnings and proceed with the update, you must initiate the update using PowerShell.  

- **Informational** failures will not block or even typically impact the updates. These health check results are provided for your awareness only. 

The troubleshooting steps differ depending on which scenario the readiness checks are from.

### Using Azure portal

**Scenario 1: System health checks**

This scenario occurs when preparing to install system updates in Azure Update Manager:

1. In the system list, view the **Critical state of Update** readiness.

    :::image type="content" source="./media/update-troubleshooting-23h2/.png" alt-text="Screenshot of system list." lightbox="./media/update-troubleshooting-23h2/.png":::

1. Select one or more systems from the list, then select **One-time Update**.  

1. On the **Check readiness** page, review the list of readiness checks and their results.

    - Select the **View details** links under **Affected systems**.

    - When the details box opens, you can view more details, individual system results, and the **Remediation** for failing health checks.

    :::image type="content" source="./media/update-troubleshooting-23h2/.png" alt-text="Screenshot of details box." lightbox="./media/update-troubleshooting-23h2/.png":::

Follow the remediation instructions to resolve the failures.

> [!NOTE]
> The system health checks run every 24 hours, so it may take up to 24 hours for the new results to sync to the Azure portal after remediating the failures.

To further troubleshoot, see the PowerShell troubleshooting section.

**Scenario 2: Update readiness checks**
 
This scenario occurs when installing and tracking system updates in Azure Update Manager:

1. In **History**, select the failed update run from the list.

1. On the **Check readiness** page, review the list of readiness checks and their results.

    - Select the **View details** links under **Affected systems**.

    - When the details box opens, you can view more details, individual system results, and the **Remediation** for failing health checks.

    :::image type="content" source="./media/update-troubleshooting-23h2/.png" alt-text="Screenshot of Check readiness page." lightbox="./media/update-troubleshooting-23h2/.png":::

Allow the remediation instructions to resolve the failures and then select the **Try again** button to retry the pre-update readiness checks and **Resume the update**.

To further troubleshoot, see the PowerShell troubleshooting section.

### Using PowerShell

**Scenario 1: System health checks**

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
 
    $result.HealthCheckResult | Where-Object {$_.Status -ne "SUCCESS"} | FL Title,Status,Severity,Description,Remediation
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

1. Review the `Remediation` field for the failed tests and take action as appropriate to resolve the failures.

1. After resolving the failures, invoke the system health checks again by running the following command:

    ```powershell
    Invoke-SolutionUpdatePrecheck -SystemHealth
    ```

1. Use `Get-SolutionUpdateEnvironment` to confirm the failing health check failures have been resolved.  It may take a few minutes for the system health checks to run.

    Here's a sample output:

    ```output
    PS C:\Users\lcmuser>  Get-SolutionUpdateEnvironment | FL HealthState, HealthCheckResult, HealthCheckDate 

    HealthState       : InProgress 
    HealthCheckResult : 
    HealthCheckDate   : 1/1/0001 12:00:00 AM 

    PS C:\Users\lcmuser>  Get-SolutionUpdateEnvironment | FL HealthState, HealthCheckResult, HealthCheckDate

    HealthState       : Success 

    HealthCheckResult : {Storage Pool Summary, Storage Subsystem Summary, Storage Services Summary, Storage Services 

                    Summary...} 

    HealthCheckDate   : 10/18/2024 11:56:49 PM 
    ```

**Scenario 2: Update readiness checks**

When update readiness checks fail, this causes the update to fail on the system. To troubleshoot update readiness checks via PowerShell:

1. To validate that the update readiness checks failed, run the following command on one of the machines in your system:

    ```powershell
   Get-SolutionUpdate|ft Version,State,HealthCheckResult
    ```

    Here's a sample output:

    ```output
    PS C:\Users\lcmuser> Get-SolutionUpdate|ft Version,State,HealthCheckResult 

    Version     State              HealthCheckResult 
    -------     -----              ----------------- 
    10.2405.2.7 HealthCheckFailed {Storage Subsystem Summary, Storage Pool Summary, Storage Services Physical Disks Summary, Stora...                       

    PS C:\Users\lcmuser>
    ```

1. Review the `State` for the update and view the `HealthCheckFailed` value.

1. To filter the `HealthCheckResult` property to identify failing tests, run the following command:

    ```powershell
    $result = Get-SolutionUpdate 
    $result.HealthCheckResult | Where-Object {$_.Status -ne "SUCCESS"} | FL Title,Status,Severity,Description,Remediation
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

1. Review the `Remediation` field for the failed tests and take action as appropriate to resolve the failures.

1. After resolving the failures, invoke the update readiness checks again by running the following command:

    ```powershell
    Get-SolutionUpdate -Id <some ID> | Start-SolutionUpdate -PrepareOnly
    ```

### Troubleshoot update failures

If there is an issue that causes an update to fail, reviewing the detailed step progress to identify where it failed is often the best way to determine if the issue is something that can be remediated through a simple repair (and resume) or a support engagement is required to resolve the issue. Key items to note for the failing step include:

- Failing step name and description.

- Which machine or server the step failed on (in case of a machine-specific issue).

- Failure message string (may pinpoint the issue to a specific known issue with documented remediation).

Microsoft recommends using the Azure portal to identify the failing step information as shown at [Troubleshoot updates](azure-update-manager-23h2.md#troubleshoot-updates).  Alternatively, see the next section for how view similar details in PowerShell using `Start-MonitoringActionplanInstanceToComplete`.

See the table below for a update failure scenarios and remediation guidelines.

| Steps | Type of issue | Remediation |
| --- | --- | --- |
| Any | Interruption to system during the update. | 1. Restore power.<br>2. Run a system health check.<br>3. Resume the update.  |
| CAU updates | Cluster Aware Update (CAU) update run fails with a `max retries exceeded` failure. | If there is an indication that multiple CAU attempts have been made and that they have all failed, it is often best to investigate the first failure.<br>Use the start and end time of the first failure to match up with the correct `Get-CauReport` output to further investigate the failure.  |
| Any | memory, power supply, boot driver, or similar critical failure on one or more machines. | See [Repair a machine](../manage/repair-server.md) for how to repair the failing machine.<br>Once the machine has been repaired the update can be resumed. |


## Collect update logs

You can also collect diagnostic logs to help Microsoft identify and fix the issues.

To collect logs for updates using the Azure portal, see [Use Azure Update Manager to update your Azure Local, version 23H2](../update/azure-update-manager-23h2.md#troubleshoot-updates).

To collect logs for the update failures see [Collect diagnostic logs for Azure Local, version 23H2](../manage/collect-logs?tabs=azureportal.md).

To view a detailed summary report using PowerShell, follow these steps on the client that you're using to access your system:

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

1. Identify the `ResourceID` for the Update.

    ```powershell
    $Failure
    ```

    Here's a sample output:

    ```output
    PS C:\Users\lcmuser> $Update = Get-SolutionUpdate| ? Version -eq "10.2303.1.7" -verbose
    PS C:\Users\lcmuser> $Failure = $Update|Get-SolutionUpdateRun
    PS C:\Users\lcmuser> $Failure
    
    ResourceId      : redmond/Solution10.2303.1.7/6bcc63af-b1df-4926-b2bc-26e06f460ab0
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
    notepad log.txt
    ```

    Here's sample output:

    ```output
    PS C:\Users\lcmuser> Start-MonitoringActionplanInstanceToComplete -actionPlanInstanceID 6bcc63af-b1df-4926-b2bc-26e06f460ab0
    ```

   :::image type="content" source="./media/update-troubleshooting-23h2/.png" alt-text="Screenshot of code output." lightbox="./media/update-troubleshooting-23h2/.png":::


## Resume an update

To resume a previously failed update run, you can retry the update run via the Azure portal or PowerShell.

### Azure portal

We highly recommend using the Azure portal, to browse to your failed update and select the **Try again** button. This functionality is available at the Download updates, Check readiness, and Install stages of an update run.

[![A screenshot of the retry a failed update button.](./media/troubleshoot-updates/try-again-update.png)](media/troubleshoot-updates/try-again-update.png#lightbox)

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
