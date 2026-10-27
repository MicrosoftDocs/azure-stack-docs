---
title: Troubleshoot health check failures for Azure Local
description: Learn how to troubleshoot health check failures for Azure Local.
author: dominicbetts
ms.author: dobett
ms.topic: how-to
ms.date: 10/19/2026
ms.custom: sfi-image-nochange
ms.subservice: hyperconverged
zone_pivot_groups: management-tool-portal-powershell
---

# Troubleshoot health check failures for Azure Local

Applies to: Hyperconverged deployments of Azure Local

This article describes how to troubleshoot and fix health check problems that your Azure Local instance reports.

## Health and readiness checks

Health and readiness checks are essential to ensure lifecycle operations such as deployment and update go smoothly. They also maintain correct system functionality and ensure high availability for your workloads. Many different scenarios perform and report health and readiness checks separately:

- **Before deployment**:

  - During planning, you can run a subset of the health checks. For more information, see [Assess environment readiness](./use-environment-checker.md).

  - The last step before deployment starts performs the predeployment health checks. For more information, see [Validate and deploy the system](../deploy/deploy-via-portal.md).

- **Scheduled daily checks**:

  - System health checks run once every 24 hours to provide regular updates on health issues. Address these issues to maintain correct system functionality and ensure high availability for your workloads.

- **Before update**:

  - Update readiness checks run as part of the update preparation phase. This phase runs after downloading the update content and before beginning the installation.

- **Before solution upgrade**:

  - Before starting a solution upgrade, [validate solution upgrade readiness](../upgrade/validate-solution-upgrade-readiness.md).

- **Before add or repair node**:

  - A health check of the new node is performed as one of the first steps of the [add node](./add-server.md#monitor-operation-progress) or [repair node](./repair-server.md#monitor-operation-progress) process. This check ensures the new node is healthy and a homogeneous match for the existing servers in the cluster. When you're monitoring add or repair progress, evaluate failures during the `EnvironmentValidatorScaleOut` steps similar to other health check failures discussed in this article.

The Azure Local health check framework runs various tests, sometimes referred to as validators or health checks. It runs tests that are appropriate for the lifecycle stage of your system. These checks confirm the system is healthy, has appropriate connectivity, and is ready to move on to the next step (for example, deploy, update, and add or repair node). The daily system health check confirms the system is healthy and ready for production workloads.

## Differences between preupdate and other health checks

The results of the daily system health checks and preupdate readiness checks might differ. Both system and preupdate readiness checks perform similar validations. However, preupdate checks use the latest version of the tests from the update that you’re preparing to install. Due to improvements in the new update, a health check that is currently failing in the daily system check might pass in the preupdate check. Because of this difference, run the update preparation before your planned update to ensure your system is ready for the update. For more information, see:

- [Understand update phases](../update/update-phases-23h2.md)
- [Recommendation to use Predownload and check update readiness](../update/update-via-powershell-23h2.md#step-4-recommended-predownload-and-check-update-readiness)

## Health check severity levels

Regardless of which type of health or readiness check you’re performing, Azure Local categorizes all validation results using the same severity levels: `Critical`, `Warning`, and `Informational`.

- `Critical` indicates a serious health concern and indicates a problem that you should address to avoid impacting the system health. If you’re attempting to perform a lifecycle operation such as deploy, update, add, repair, or upgrade, this severity indicates problems that you must resolve before proceeding.

- `Warning` indicates potential problems that you should evaluate. `Warning` severity failures might also prevent you from performing a lifecycle operation.

- `Informational` indicates health check results for your awareness and might not require immediate action. `Informational` severity health check failures don’t block lifecycle operations. This severity provides information about the system’s state and any potential problems that shouldn’t affect the operation of the system directly.

### Bypass warnings

1. The `Warning` status indicates potential problems that might not be severe, but that you should review to confirm they won't impact the update before you bypass them.

    :::image type="content" source="media/troubleshoot-health-check-failures/before-update-health-check-warning-summary.png" alt-text="Screenshot of Update Progress page showing warnings summary." lightbox="media/troubleshoot-health-check-failures/before-update-health-check-warning-summary.png":::

1. To investigate warnings, select **Validate that the system is ready**.

    :::image type="content" source="media/troubleshoot-health-check-failures/before-update-health-check-warning-expanded.png" alt-text="Screenshot of Update Progress page showing an expanded warning." lightbox="media/troubleshoot-health-check-failures/before-update-health-check-warning-expanded.png":::

1. Select **View details** for the warning in question.

    :::image type="content" source="media/troubleshoot-health-check-failures/before-update-health-check-warning-details.png" alt-text="Screenshot of Update Progress page showing warning details." lightbox="media/troubleshoot-health-check-failures/before-update-health-check-warning-details.png":::

1. If you determine the warning doesn't impact the update, you can bypass the warning, either by [using PowerShell](../update/update-via-powershell-23h2.md#step-7-resume-the-update-if-needed), or through the portal:

    :::image type="content" source="media/troubleshoot-health-check-failures/proceed-ignore-daily-check-error.png" alt-text="Screenshot of Proceed anyway prompt." lightbox="media/troubleshoot-health-check-failures/proceed-ignore-daily-check-error.png":::

## Viewing health check or readiness results

The method to view the health check results differs depending on which scenario the tests are running.

### Health checks when planning for deployment or upgrade

Use the `AzStackHci.EnvironmentChecker` module to [assess environment readiness](./use-environment-checker.md) when planning to deploy a new cluster or upgrade an existing cluster with Azure Local. This standalone module is regularly updated to perform many of the same health check validation tests that it regularly performs before and after Azure Local deployments.

This module uses a simple text interface to view the results prior to completion of the Azure Local deployment or upgrade. While the results format might look different from other (deploy and update) health checks, the result properties for each test match the equivalent health checks tests of the same name that are performed in later lifecycle stages. As a result, you can use the [Resources to troubleshoot failed results](#resources-to-troubleshoot-failed-results) in this article to identify a known issue. However, when you're evaluating readiness to upgrade, you should first see [Validate solution upgrade readiness](../upgrade/validate-solution-upgrade-readiness.md) for remediation guidance.

### Health checks just before deployment

The final step before deployment starts is to perform a validation as discussed in [Validate and deploy the system](../deploy/deploy-via-portal.md). This step performs validations on all systems that you selected for deployment. Compared to the earlier [assessment of environment readiness](./use-environment-checker.md), this step might uncover health check failures that didn't appear earlier, such as problems with the selected servers that don't match each other, or problems with the proposed Active Directory, networking, or Solution Builder Extension (SBE) configuration. This difference exists because the Azure Local health check framework knows more about your configuration at this stage.

You can view these predeployment validation results from the portal as described in [Validate and deploy the system](../deploy/deploy-via-portal.md). For more information about troubleshooting deployment validation issues, see [Troubleshoot deployment validation issues](./troubleshoot-deployment.md).

### Health checks after deployment

How you view health checks after deployment depends on whether you're using the Azure portal, Azure PowerShell with Azure Local release 2610 and later, or PowerShell with Azure Local release 2509 and earlier.

::: zone pivot="management-tool-portal"

#### Daily system health checks

You can view the most recent daily system health check result in Azure Update Manager:

1. In the system list, view the **Critical** state of **Update readiness**.

    :::image type="content" source="../update/media/troubleshoot-updates/update-manager.png" alt-text="Screenshot of Update Manager page." lightbox="../update/media/troubleshoot-updates/update-manager.png":::

1. Select one or more systems from the list, and then select **One-time Update**.

1. On the **Check readiness** page, review the list of readiness checks and their results.

    1. Select the **View details** links under **Affected systems**.

    1. When the details box opens, you can view more details, individual system results, and the **Remediation** for failing health checks.

    :::image type="content" source="../update/media/troubleshoot-updates/install-updates.png" alt-text="Screenshot of Install updates page." lightbox="../update/media/troubleshoot-updates/install-updates.png":::

    To resolve the failures, follow the remediation instructions.

    > [!NOTE]
    > The system health checks run every 24 hours, so it might take up to 24 hours for the new results to sync to the Azure portal after remediating the failures. To initiate a new system health check immediately or further troubleshoot, see the PowerShell pivot for this section.

You can also view daily system health check results by selecting multiple clusters in the Azure Update Manager and selecting **Install now**:

:::image type="content" source="media/troubleshoot-health-check-failures/multiple-clusters-install-now.png" alt-text="Screenshot of selecting multiple clusters in Azure Update Manager." lightbox="media/troubleshoot-health-check-failures/multiple-clusters-install-now.png":::

For example, suppose you update three clusters. For two clusters, the daily system health checks succeeded; for one cluster, they failed.

:::image type="content" source="media/troubleshoot-health-check-failures/portal-failure-details.png" alt-text="Screenshot of Install updates failure details pane." lightbox="media/troubleshoot-health-check-failures/portal-failure-details.png":::

System daily health check provide a daily snapshot of the health of your clusters, but are not required to be successful and should not deter you from attempting to prepare an update if you believe the issue reported has been recently addressed. As part of preparing to install the update or staring the update, the [preupdate health check](#preupdate-health-checks) will run the latest validation tests to determine if it is appropriate to install the update.

In the **Install updates** page, the **Next** button is enabled even if there are failed system daily health check results:

:::image type="content" source="media/troubleshoot-health-check-failures/portal-failure-summary.png" alt-text="Screenshot of Install updates page when there are daily system health check failures." lightbox="media/troubleshoot-health-check-failures/portal-failure-summary.png":::

If you select **Next**, you're prompted to continue without resolving the failed system daily health checks:

:::image type="content" source="media/troubleshoot-health-check-failures/proceed-ignore-daily-check-error.png" alt-text="Screenshot of Proceed anyway prompt." lightbox="media/troubleshoot-health-check-failures/proceed-ignore-daily-check-error.png":::

#### Preupdate health checks

To view preupdate health check results, view the **Check readiness** details when installing and tracking system updates in Azure Update Manager:

1. In **History**, select the failed update run from the list.

1. On the **Check readiness** page, review the list of readiness checks and their results.

    1. Select the **View details** links under **Affected systems**.

    1. When the details box opens, you can view more details, individual system results, and the **Remediation** for failing health checks.

    :::image type="content" source="../update/media/troubleshoot-updates/update-progress.png" alt-text="Screenshot of Update progress page." lightbox="../update/media/troubleshoot-updates/update-progress.png":::

    Follow the remediation instructions to resolve the failures. Then select **Try again** to retry the preupdate readiness checks and **Resume the update**.

    To further troubleshoot, see the Powershell pivot for this section.

::: zone-end

::: zone pivot="management-tool-powershell"

> [!NOTE]
> For Azure Local release 2610 and later, we recommend using the [`Get-SolutionHealthSummary`](./use-get-solution-health-summary-powershell-command.md) command to view system health check results. For [previous releases](#azure-local-release-2609-and-earlier), use the `Get-SolutionUpdateEnvironment` or `Get-SolutionUpdate` commands.

### Azure Local release 2610 and later

To view system or preupdate health check results through PowerShell, complete the following steps.

1. To validate that the health checks failed, run the following command on one of the machines in your system:

    ```powershell
    Get-SolutionHealthSummary
    ```

    Here's a sample output for a failed daily system health check:

    ```output
    Status  : FAILED
    Info    : {
                  HealthCheckSource     : Daily system health check for 12.2610.1004.37
                  HealthCheckDate       : 10/13/2026 02:11:43
                  Time since last check : 1.2h ago
                  Statistics            : 974 total checks: 3 critical, 1 warning, 4 informational, 966 passed
              }
    Results : {
                  Result       : Result 1
                  Severity     : Critical
                  DisplayName  : Storage Job Health Check
                  Title        : Storage Job Status Check
                  Description  : Check to verify the Storage Job Health[FAILURE] Storage job [UserStorage_3-Repair] is in
                                 [Suspended] state.
                  Remediation  : Troubleshoot Storage Spaces and Storage Spaces Direct health and operational states:
                  https://learn.microsoft.com/en-us/windows-server/storage/storage-spaces/storage-spaces-states.
                                 Troubleshoot Storage Spaces Direct:
                  https://learn.microsoft.com/en-us/windows-server/storage/storage-spaces/troubleshooting-storage-spaces
                  ...
              }
    
    Most Recent Check Timestamp: 10/13/2026 02:11:43 UTC (1.2h ago)
    FAILED
    974 total checks: 3 critical, 1 warning, 4 informational, 966 passed
    ```

1. Review the `Status` on your system and view the `FAILED` or `WARNING` value.

1. Review the `HealthCheckSource` field to see whether it contains `Daily system health check` or `Pre-update health check`. In either case, when a health check fails, the default `Get-SolutionHealthSummary` syntax shows the details of the blocking failures.

1. You can filter the results as follows.
    - To filter for critical failures, add the `-CriticalFailures` flag:
        ```powershell
        Get-SolutionHealthSummary -CriticalFailures
        ```
    - To filter for warnings, add the `-WarningFailures` flag:
        ```powershell
        Get-SolutionHealthSummary -WarningFailures
        ```
    - To filter for informational messages, add the `-IncludeInformational` flag:
        ```powershell
        Get-SolutionHealthSummary -IncludeInformational
        ```

1. Review the `Remediation` property for each of the failed tests and take action as appropriate to resolve the failures.

1. If you require more diagnostic information to determine the cause of the failed tests, add the `-Detailed` flag:

    ```powershell
    Get-SolutionHealthSummary -Detailed
    ```

    Here's a sample output for a failed daily system health check:

    ```output
    Status  : FAILED
    Info    : {
                  HealthCheckSource     : Daily system health check for 12.2610.1004.37
                  HealthCheckDate       : 10/13/2026 02:11:43
                  Time since last check : 1.3h ago
                  Statistics            : 974 total checks: 3 critical, 1 warning, 4 informational, 966 passed
              }
    Results : {
                  Result       : Result 1
                  Severity     : Critical
                  DisplayName  : Storage Services Physical Disks Health Check
                  Title        : Storage Services Physical Disks Check
                  Description  : Check to verify the Storage Services Physical Disk Health[FAILURE] The disk
                                 {1}\\example-cluster\root/Microsoft/Windows/Storage/Providers_v2\SPACES_PhysicalDisk.ObjectId=
                                 "{00000000-0000-0000-0000-000000000000}:PD:{00000000-0000-0000-0000-000000000000}"
                                 on node Node19 is in Unhealthy/Transient Error.
                  Remediation  : Troubleshoot Storage Spaces and Storage Spaces Direct health and operational states:
                  https://learn.microsoft.com/en-us/windows-server/storage/storage-spaces/storage-spaces-states.
                                 Troubleshoot Storage Spaces Direct:
                  https://learn.microsoft.com/en-us/windows-server/storage/storage-spaces/troubleshooting-storage-spaces
                  Name         : Storage Services Physical Disks Summary
                  Status       : Failed
                  TargetResourceID   : Cluster/example-cluster/Disk/eui.00000000000000000000000000000000
                  TargetResourceName : eui.00000000000000000000000000000000
                  TargetResourceType : Disk
                  Timestamp    : 10/13/2026 05:20:23
                  HealthCheckSource  : Test-EnvironmentReadiness
                  Tags         : {[Member: Physical Disks], [Group: StorageSvcsSummary]}
                  AdditionalData     : {
                      ScaleUnit: example-cluster,
                      CanPool: False,
                      SBLDiskState: 6,
                      PercentageSpaceUsed: 4.63065227232033,
                      BusType: NVMe,
                      Model: MO001600KXNZV,
                      WriteLatencyMax: ,
                      Firmware: HPS7,
                      CannotPoolReason: In a Pool,
                      Failures: The disk
                                {1}\\example-cluster\root/Microsoft/Windows/Storage/Providers_v2\SPACES_PhysicalDisk.ObjectId="
                                {00000000-0000-0000-0000-000000000000}:PD:{00000000-0000-0000-0000-000000000000}"
                                on node Node19 is in Unhealthy/Transient Error.,
                      OperationalStatus: Transient Error,
                      StorageEnclosure: ,
                      PhysicalLocation: PCI Slot 11 : Bus 71 : Device 0 : Function 0 : Adapter 2,
                      SerialNumber: 0000_0000_0000_0000_0000_0000_0000_0000.,
                      ReadErrorsCorrected: ,
                      SizeInGB: 1490.42,
                      ReadErrorsUncorrected: ,
                      FriendlyName: MO001600KXNZV,
                      WriteErrorsUncorrected: ,
                      MediaType: SSD,
                      Temperature: 23,
                      Usage: Auto-Select,
                      Host: Node19,
                      WriteErrorsCorrected: ,
                      HealthStatus: Unhealthy,
                      ObjectId: {1}\\example-cluster\root/Microsoft/Windows/Storage/Providers_v2\SPACES_PhysicalDisk.ObjectId="
                      {00000000-0000-0000-0000-000000000000}:PD:{00000000-0000-0000-0000-000000000000}",
                      UniqueId: eui.00000000000000000000000000000000,
                      ReadLatencyMax: 0,
                      SBLHealthCounters: ,
                      Manufacturer: ,
                      AllocatedSizeInGB: 69.02
              ...
              }
    
    Most Recent Check Timestamp: 10/13/2026 02:11:43 UTC (1.3h ago)
    FAILED
    974 total checks: 3 critical, 1 warning, 4 informational, 966 passed
    ```

1. If present, use the diagnostic information shown in `AdditionalData` property, such as `FailedMachines`, `Source`, and `ExceptionMessage` to determine which physical machines are causing the test failure, together with information provided in the link from the `Remediation` property to resolve the failures.

1. After resolving the failures, run the health checks again.

    - For system health checks, run the following command.
        ```powershell
        Invoke-SolutionUpdatePrecheck -SystemHealth
        ```

    - For preupdate health checks, run the following command.
        ```powershell
        Get-SolutionUpdate | ?{$_.Status -eq "HealthCheckFailed"} | Start-SolutionUpdate -PrepareOnly
        ```

1. Run `Get-SolutionHealthSummary` again to confirm the failing tests are resolved. It might take a few minutes for the health checks to run. To confirm whether you're seeing updated or previous results, look at the `Info` field of the output from `Get-SolutionHealthSummary`, and compare the value of `Time since last check` to the value from your previous run of `Get-SolutionHealthSummary`.

    ```output
    Info    : {
                  HealthCheckSource     : Daily system health check for 12.2610.1004.37
                  HealthCheckDate       : 10/13/2026 02:11:43
                  Time since last check : 1.3h ago
                  Statistics            : 974 total checks: 3 critical, 1 warning, 4 informational, 966 passed
              }
    ```

### Azure Local release 2609 and earlier

For Azure Local release 2509 and earlier, use different PowerShell commands to view daily system health checks and preupdate health checks.

> [!NOTE]
> For [Azure Local release 2610 and later](#azure-local-release-2610-and-later), we recommend using the `Get-SolutionHealthSummary` command to view system and preupdate health check results.

#### Daily system health checks

1. To check if the daily system health checks failed, run the following command on one of the machines in your system:

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
    HealthCheckResult : {Storage Pool Summary, Storage Services Physical Disks Summary, Storage Services Physical Disks Summary, Storage Services Physical Disks Summary...}
    HealthCheckDate   : 9/12/2023 7:03:32 AM
    AdditionalData    : {[SBEAdditionalData, Solution Builder extension is partially installed. Please install the latest Solution Builder Extension provided by your hardware vendor. For more information, see https://aka.ms/SBE.]}
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
    Remediation : `https://learn.microsoft.com/en-us/windows-server/failover-clustering/cluster-aware-updating-requirements#tests-for-cluster-updating-readiness`

    Title       : The CAU clustered role should be installed on the failover cluster to enable self-updating mode
    Status      : FAILURE
    Severity    : INFORMATIONAL
    Description : Validating cluster setup for update.
    Remediation : `https://learn.microsoft.com/en-us/windows-server/failover-clustering/cluster-aware-updating-requirements#tests-for-cluster-updating-readiness`
    ```

1. Review the `Remediation` property for the failed tests and take action as appropriate to resolve the failures.

1. If you require more diagnostic information to determine the cause of the failed tests, examine the `AdditionalData` property by using the `-FullHealthCheckDetails` parameter:

    ```powershell
    $FullResults = Get-SolutionUpdateEnvironment -FullHealthCheckDetails

    $Failures = $FullResults.HealthCheckResult | Where-Object { $_.Status -ne "SUCCESS" -and $_.Severity -ne "INFORMATIONAL" }

    $Failures | Format-List *
    ```

1. If present, use the diagnostic information shown in `AdditionalData` property, such as `FailedMachines`, `Source`, and `ExceptionMessage` to determine which physical machines are causing the test failure, together with information provided in the link from the `Remediation` property to resolve the failures.

1. After resolving the failures, invoke the system health checks again by running the following command:

    ```powershell
    Invoke-SolutionUpdatePrecheck -SystemHealth
    ```

1. Use `Get-SolutionUpdateEnvironment` to confirm the failing tests are resolved. It might take a few minutes for the system health checks to run.

    Here's a sample output:

    ```output
    PS C:\Users\lcmuser> Get-SolutionUpdateEnvironment | Format-List HealthState, HealthCheckResult, HealthCheckDate

    HealthState       : InProgress
    HealthCheckResult :
    HealthCheckDate   : 1/1/0001 12:00:00 AM

    PS C:\Users\lcmuser> Get-SolutionUpdateEnvironment | Format-List HealthState, HealthCheckResult, HealthCheckDate

    HealthState       : Success
    HealthCheckResult : {Storage Pool Summary, Storage Subsystem Summary, Storage Services Summary, Storage Services Summary...}
    HealthCheckDate   : 10/18/2024 11:56:49 PM
    ```

#### Preupdate health checks

To view preupdate health check results, use the `Get-SolutionUpdate` cmdlet. This cmdlet provides the results from the preupdate health checks that use the newer tests included in the update that you prepared or attempted to install. For a health check failure, `Get-SolutionUpdate` reports the update with a value of `HealthCheckFailed` in the status property.

To view the details of the failed preupdate health check via PowerShell:

1. To identify the `ResourceId` of the updates that you previously selected to prepare or install, run the following command.

    ```powershell
    Get-SolutionUpdate | ?{$_State -match "(Health)|(Prep)|(Download)|(ToInstall)|(Scheduled)" | Format-Table ResourceId, State, Version
    ```

    Here's a sample output:

    ```output
    PS C:\Users\lcmuser> Get-SolutionUpdate | Format-Table ResourceId, State, Version

    ResourceId                     State                  Version

    ----------                     -----                  -------

    redmond/Solution10.2405.2.7    HealthCheckFailed      10.2405.2.7
    ```

1. Look at the output from the previous step to identify which updates are in the `HealthCheckFailed` state. For a complete list of update phases, see [Azure Local update phases](../update/update-phases-23h2.md).

1. Using the `ResourceId` of the update you're attempting to install, run the following command. Replace the `Id` parameter with the `ResourceId` of your update, from the output of the previous command:

    ```powershell
    Get-SolutionUpdate -Id <RESOURCE_ID> | FL ResourceId, State, HealthState, HealthCheckResult HealthCheckDate
    ```

    Here's a sample output:

    ```output
    ResourceId            : example-domain/example-id
    State                 : HealthChecking
    HealthState           : Failed
    HealthCheckResult     : {Storage Services Physical Disks Summary, Storage Services Physical Disks Summary, Storage
                            Services Physical Disks Summary, Storage Services Physical Disks Summary...}
    HealthCheckDate       : 10/13/2026 6:46:58 AM
    ```

1. Review the `HealthState`, `HealthCheckDate`, and `HealthCheckResult` values.

    > [!NOTE]
    > If the `HealthCheckDate` value isn't recent, or the `HealthState` is `Unknown`, it might mean you didn't attempt to prepare or start the update. Before you investigate the `HealthCheckResults` fully, consider if you should first start a new health check. For more information, see [Understand update phases](../update/update-phases-23h2.md).

1. If there's a value in the `HealthCheckResults` property, filter the property to identify failing tests. Run the following command. Replace the `Id` value with the `ResourceId` of your update, identified from the earlier command:

    ```powershell
    $result = Get-SolutionUpdate -Id <RESOURCE_ID>

    $result.HealthCheckResult | Where-Object {$_.Status -ne "SUCCESS"} | Format-List Title, Status, Severity, Description, Remediation
    ```

    Here's a sample output:

    ```output
    Title       : The machine proxy on each failover cluster node should be set to a local proxy server

    Status      : FAILURE

    Severity    : INFORMATIONAL

    Description : Validating cluster setup for update.

    Remediation : https://learn.microsoft.com/en-us/windows-server/failover-clustering/cluster-aware-updating-requirements#tests-for-cluster-updating-readiness

    Title       : The CAU clustered role should be installed on the failover cluster to enable self-updating mode

    Status      : FAILURE

    Severity    : INFORMATIONAL

    Description : Validating cluster setup for update.

    Remediation : https://learn.microsoft.com/en-us/windows-server/failover-clustering/cluster-aware-updating-requirements#tests-for-cluster-updating-readiness
    ```

1. Using the link shown in the `Remediation` property of the failed test, review the article by using a device with a web browser to determine appropriate actions to resolve the failures.

1. If you need more diagnostic information to determine the cause of the failed tests, examine the `AdditionalData` property by using the `-FullHealthCheckDetails` parameter:

    ```powershell
    $FullResults = Get-SolutionUpdate -Id <RESOURCE_ID> -FullHealthCheckDetails

    $Failures = $FullResults.HealthCheckResult | Where-Object { $_.Status -ne "SUCCESS" -and $_.Severity -ne "INFORMATIONAL" }

    $Failures | Format-List *
    ```

    If present, use the diagnostic information shown in the `AdditionalData` property, such as `FailedMachines`, `Source`, and `ExceptionMessage` to determine which physical machines are causing the test failure, together with information provided in the link from the `Remediation` property, to resolve the failures.

1. After resolving the failures, invoke the update readiness checks again by running the following command:

    ```powershell
    Get-SolutionUpdate -Id <RESOURCE_ID> | Start-SolutionUpdate -PrepareOnly
    ```

::: zone-end

## Resources to troubleshoot failed results

If the health check results don't immediately offer insights into what the issue is or how to fix it, see the following resources:

- [Environment Validator TSG (Technical Support Guide) Articles](https://github.com/Azure/AzureLocal-Supportability/tree/main/TSG/EnvironmentValidator/README.md)

- [Resolving ‘Access Denied’ results](https://github.com/Azure/AzureLocal-Supportability/tree/main/TSG/LCM/access-denied-lcm-user.md)

- [Solution Builder Extension (SBE) health check known issues](https://github.com/Azure/AzureLocal-Supportability/tree/main/TSG/SolutionExtension/HealthCheck-known-issues) for generalized issues that can affect any hardware type. Your hardware vendor typically documents more known issues, as they provide SBE health checks as part of their SBE.

- This article helps you understand the detailed properties returned as part of [Connectivity check results](./use-environment-checker.md#connectivity-validator-attributes). The article highlights the predeployment "Environment Checker" user interface. However, you can apply the insights it offers, regarding the property values and how to troubleshoot connectivity failures, to any lifecycle stage (for example, preupdate Health Check failures).

- If the failure occurs during deployment health checks, see [Troubleshoot deployment validation issues](./troubleshoot-deployment.md).

- If the failure occurs during upgrade readiness validation, see [Validate solution upgrade readiness](../upgrade/validate-solution-upgrade-readiness.md).

- For more about troubleshooting updates, see [Troubleshooting solution updates](../update/update-troubleshooting-23h2.md).
