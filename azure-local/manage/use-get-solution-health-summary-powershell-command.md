---
title: Use the Get-SolutionHealthSummary PowerShell command
description: Learn how to use the Get-SolutionHealthSummary PowerShell command with Azure Local.
author: dominicbetts
ms.author: dobett
ms.topic: how-to
ms.date: 10/19/2026
ms.custom: sfi-image-nochange
ms.subservice: hyperconverged
---

# Use the Get-SolutionHealthSummary PowerShell command

Get a concise summary of the most recent solution health check results, highlighting critical and important health issues that you should immediately address.

> [!NOTE]
> `Get-SolutionHealthSummary` is only available in Azure Local release 2610 and later. For previous releases of Azure Local, use the `Get-SolutionUpdateEnvironment` or `Get-SolutionUpdate` commands. For help with troubleshooting updates, see [Troubleshoot updates](../update/update-troubleshooting-23h2.md). For help with troubleshooting health check failures, see [Troubleshoot health check failures](./troubleshoot-health-check-failures.md#preupdate-health-checks).

## Syntax

```
Get-SolutionHealthSummary [-CriticalFailures] [-WarningFailures] [-IncludeInformational] [-Detailed]
 [-LcmUpdateServiceClient <ILcmUpdateServiceClient>] [<CommonParameters>]
```

## Description
`Get-SolutionHealthSummary` returns a customer-friendly summary of the latest health check results for the Azure Local cluster. The most common way to run it is with no parameters: the default output lists the failing `Critical` and `Warning` checks with just the fields needed to act on them (Severity, DisplayName, Title, Description, and Remediation), followed by a status line and an aggregate statistics footer. The optional switches described in the following section let you adjust the view when needed.

The cmdlet automatically selects the most recent health check run results. When you schedule an update and a recent pre-update health check exists, the cmdlet uses the pre-update health check. Otherwise, the cmdlet uses the most recent daily system health check. The top-level `Info` block reports the selected source and its most recent health check time.

By default, the `Results` list includes only failing checks, while the footer statistics reflect every check (including those that passed). The switches adjust which severities are listed and how much detail is returned:

- By default, the cmdlet returns both `Critical` and `Warning` failing checks, because both warrant immediate review before updating.
- `-CriticalFailures` restricts the list to `Critical` failing checks only.
- `-WarningFailures` restricts the list to `Warning` failing checks only.
- `-CriticalFailures` and `-WarningFailures` are mutually exclusive. To list both severities, run the cmdlet with neither switch (the default).
- `-IncludeInformational` additionally includes `Informational` failing checks. You can combine it with the default view or with either `-CriticalFailures` or `-WarningFailures`.
- `-Detailed` returns the full set of fields for each returned result instead of the compact default.

`-CriticalFailures` and `-WarningFailures` narrow the view to a single severity, while `-IncludeInformational` and `-Detailed` widen or enrich it.

## Examples

### Example 1: Show the blocking failures (default view)

```powershell
PS C:\> Get-SolutionHealthSummary
```

```output
Status  : FAILED
Info    : {
              HealthCheckSource     : Daily system health check for 12.2606.1003.36
              HealthCheckDate       : 5/25/2026 12:08:55 PM
              Time since last check : 3.7h ago
              Statistics            : 334 total checks: 1 critical, 0 warning, 0 informational, 333 passed
              Action                : 1 critical issue(s) must be resolved before installation can proceed.
          }
Results : {
              Result       : Result 1
              Severity     : Critical
              DisplayName  : Test Network Intent
              Title        : Test Network intent on existing cluster nodes
              Description  : Checking if network intent is healthy on existing nodes
              Remediation  : https://aka.ms/hci-envch
          }

Most Recent Check Timestamp: 5/25/2026 12:08:55 UTC (3.7h ago)
FAILED
334 total checks: 1 critical, 0 warning, 0 informational, 333 passed

```

The default output requires no parameters and surfaces the important failures with enough information to remediate.

### Example 2: Show only the critical blocking failures

```powershell
PS C:\> Get-SolutionHealthSummary -CriticalFailures
```

This example restricts the listed results to `Critical` severity failures. Use `-WarningFailures` instead to list only `Warning` severity failures. `-CriticalFailures` and `-WarningFailures` are mutually exclusive, so to see both severities, run the cmdlet with neither switch (the default view).

### Example 3: Include informational results

```powershell
PS C:\> Get-SolutionHealthSummary -IncludeInformational
```

Adds `Informational` failing checks to the default `Critical` and `Warning` results, without needing a `Where-Object` filter.

### Example 4: Show all details of all failing health checks

This example combines two switches for a complete "show me everything" view: `-IncludeInformational` widens the list to include `Critical`, `Warning`, and `Informational` failing checks, while `-Detailed` returns the full set of fields for each result instead of the compact default. See the NOTES section for the full field list.

```powershell
PS C:\> Get-SolutionHealthSummary -Detailed -IncludeInformational
```

```output
Status  : FAILED
Info    : {
              HealthCheckSource     : Daily system health check for 12.2606.1003.36
              HealthCheckDate       : 5/25/2026 12:08:55 PM
              Time since last check : 3.7h ago
              Statistics            : 334 total checks: 1 critical, 0 warning, 1 informational, 332 passed
              Action                : 1 critical issue(s) must be resolved before installation can proceed.
          }
Results : {
              Result             : Result 1
              Severity           : Critical
              DisplayName        : Test Network Intent
              Title              : Test Network intent on existing cluster nodes
              Description        : Checking if network intent is healthy on existing nodes
              Remediation        : https://aka.ms/hci-envch
              Name               : AzStackHci_Network_Test_Intent
              Status             : Failed
              Tags               : {Group: Network}
              TargetResourceID   : Machine: AzLocalNode01, Class: NetIntent
              TargetResourceName : AzLocalNode01
              TargetResourceType : NetIntent
              Timestamp          : 5/25/2026 12:08:55 PM
              HealthCheckSource  : PreUpdate\Standard\Medium\Network\5564dd2a
              AdditionalData     : {Detail: Checking network intent on AzLocalNode01}

              Result             : Result 2
              Severity           : Informational
              DisplayName        : Test System Drive Free Space
              Title              : Test available free space on the system drive
              Description        : Checking that the system drive has sufficient free space
              Remediation        : https://aka.ms/hci-envch
              Name               : AzStackHci_System_Test_DriveSpace
              Status             : Failed
              Tags               : {Group: System}
              TargetResourceID   : Machine: AzLocalNode02, Class: SystemDrive
              TargetResourceName : AzLocalNode02
              TargetResourceType : SystemDrive
              Timestamp          : 5/25/2026 8:55 PM
              HealthCheckSource  : PreUpdate\Standard\Medium\Hardware\7788bc10
              AdditionalData     : {Detail: 12% free on volume C:}
          }

Most Recent Check Timestamp: 5/25/2026 12:08:55 UTC (3.7h ago)
FAILED
334 total checks: 1 critical, 0 warning, 1 informational, 332 passed
```

### Example 5: Capture the overall status programmatically

```powershell
PS C:\> (Get-SolutionHealthSummary).Status
```

```output
FAILED
```

The top-level `Status` property exposes the overall status word (`FAILED`, `WARNING`, or `SUCCESS`) so it can be captured directly in automation.

## Parameters

### -CriticalFailures

The `-CriticalFailures` parameter filters the results to show only failing checks with `Critical` severity. This parameter is mutually exclusive with `-WarningFailures`. To list both severities, run the cmdlet without either switch (the default view). Combine it with `-IncludeInformational` to also include `Informational` results.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Detailed

By default, each result includes a compact set of five fields: Severity, DisplayName, Title, Description, and Remediation. When you specify `-Detailed`, the cmdlet returns the full set of fields for each result, including Name, Status, the TargetResource properties, Timestamp, Tags, AdditionalData, and HealthCheckSource.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeInformational

The `-IncludeInformational` parameter adds `Informational` severity failing checks to the results. This switch is additive: by default, the cmdlet shows only `Critical` and `Warning` results, and `-IncludeInformational` adds `Informational` failures on top of the current selection.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LcmUpdateServiceClient

Use `-LcmUpdateServiceClient` to optionally specify an `ILcmUpdateServiceClient` object that the cmdlet uses to make REST calls to the update service. Create the client object by using the `New-SolutionUpdateClient` cmdlet.

You don't need to use this parameter in most cases, but you can use it to override some client-side timeouts.

```yaml
Type: ILcmUpdateServiceClient
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WarningFailures

The `-WarningFailures` parameter filters the results to show only failing checks with `Warning` severity. This parameter is mutually exclusive with `-CriticalFailures`. To list both severities, run the cmdlet without either switch (the default view). Combine it with `-IncludeInformational` to also include `Informational` results.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### Common parameters

`Get-SolutionHealthSummary` supports the common parameters: `-Debug`, `-ErrorAction`, `-ErrorVariable`, `-InformationAction`, `-InformationVariable`, `-OutVariable`, `-OutBuffer`, `-PipelineVariable`, `-Verbose`, `-WarningAction`, and `-WarningVariable`. For more information, see [about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## Inputs

None.

## Outputs

`System.Object`.

## Notes

The object that `Get-SolutionHealthSummary` returns has the following top-level properties.

| Name | Type | Example | Description |
|------|------|---------|-------------|
| Status | String | `FAILED` | The overall status word for the summary: `FAILED` when any Critical failures are present, `WARNING` when Warning failures are present but no Critical failures, otherwise `SUCCESS`. Exposed as a top-level property so you can capture it directly, for example `(Get-SolutionHealthSummary).Status`. |
| Info | HealthSummaryInfo | | Details about the most recent health check: where the results came from, when they were produced, aggregate counts, and guidance messages. See **Info properties** below. |
| Results | List\<HealthCheckResultProjection\> | | The individual failing health check results that matched the requested severities. By default each result contains the five compact fields; with `-Detailed`, all fourteen fields are populated. See the following table. |

**Info properties**

The `Info` object has the following properties.

| Name | Type | Example | Description |
|------|------|---------|-------------|
| HealthCheckSource | String | `Daily system health check for 12.2606.1003.36` | A human-readable label describing which health check the server selected (pre-update or daily) and the version it applies to. |
| HealthCheckDate | DateTime? | `2026-05-25T12:08:55Z` | The timestamp at which the underlying health check engine produced these results, or null when no health check is available. |
| LastHealthCheck | String | `3.7h ago` | The pre-formatted relative age of the most recent health check, rendered as the `Time since last check` line in the info block. The absolute time is carried separately on `HealthCheckDate`. |
| Statistics | String | `334 total checks: 2 critical, 7 warning, 0 informational, 325 passed` | A pre-formatted aggregate count line across all severities. |
| Messages | List\<String\> | `2 critical issue(s) must be resolved before installation can proceed.` | The ordered directive sentences the server surfaces. Each entry is rendered as its own line in the cmdlet footer. |
| TotalChecks | Int32 | `334` | The total number of health check results across all severities. |
| CriticalCount | Int32 | `2` | The number of failing results with Critical severity. |
| WarningCount | Int32 | `7` | The number of failing results with Warning severity. |
| InformationalCount | Int32 | `0` | The number of failing results with Informational severity. |
| PassedCount | Int32 | `325` | The number of results that passed. |

**Result properties**

Each item in `Results` has the following properties. By default, only the first five compact fields are populated. The remaining fields are populated when you specify `-Detailed`.

| Name | Type | Example | Description |
|------|------|---------|-------------|
| Severity | HealthCheckResultSeverity | `Critical` | The severity of the result. Possible values: Informational, Warning, Critical. (compact) |
| DisplayName | String | `Test System Drive Free Space` | The localized display name of the health check. (compact) |
| Title | String | `Test Network intent on existing cluster nodes` | A short, user-facing title describing the issue. (compact) |
| Description | String | `Checking if network intent is healthy on existing nodes` | A detailed description of the issue and its impact. (compact) |
| Remediation | String | `https://aka.ms/hci-envch` | The steps or link that you can use to resolve the issue. (compact) |
| Name | String | `AzStackHci_Network_Test_Intent` | The programmatic name of the health check. (-Detailed) |
| Status | HealthCheckResultStatus | `Failed` | The outcome of the health check. Possible values: Failed, Passed. By default, only Failed results are returned. (-Detailed) |
| Tags | Dictionary\<String, String\> | `{Group: Network}` | The key-value tags used to group and filter health checks. (-Detailed) |
| TargetResourceID | String | `Machine: AzLocalNode01, Class: NetIntent` | The unique identifier of the affected resource. (-Detailed) |
| TargetResourceName | String | `AzLocalNode01` | The name of the affected resource. (-Detailed) |
| TargetResourceType | String | `NetIntent` | The type of the affected resource. (-Detailed) |
| Timestamp | DateTime? | `2026-05-25T12:08:55Z` | The UTC timestamp at which the health check was executed. (-Detailed) |
| AdditionalData | Dictionary\<String, String\> | `{Detail: Checking network intent on AzLocalNode01}` | A property bag of supplementary key-value data. (-Detailed) |
| HealthCheckSource | String | `PreUpdate\Standard\Medium\Network\5564dd2a` | The name of the service that produced the health check. (-Detailed) |

**HealthCheckResultSeverity Values**

| Value | Description |
|-------|-------------|
| Informational | An informational result with no required action. |
| Warning | An initially blocking issue that you should review, but you can bypass and it doesn't prevent an update. |
| Critical | A blocking issue that you must resolve before proceeding with an update. |

**HealthCheckResultStatus Values**

| Value | Description |
|-------|-------------|
| Failed | The health check produced a failing result, or couldn't be executed. |
| Passed | The health check executed successfully and produced a passing result. |

By default, `Get-SolutionHealthSummary` lists only `Failed` results, while the statistics footer reflects all checks.

## See also

- [Troubleshooting updates](../update/update-troubleshooting-23h2.md)
- [Troubleshooting health check failures](./troubleshoot-health-check-failures.md)
- [Troubleshooting Azure Stack updates](https://aka.ms/TroubleshootAzureStackUpdates)
