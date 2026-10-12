---
title: Drift detection for Azure Local
description: Learn how the Azure Local drift detection framework continuously validates component states against a baseline to help ensure system reliability.
author: ronmiab
ms.author: robess
ms.reviewer: pradwivedi
ms.subservice: hyperconverged
ms.date: 10/12/2026
ms.topic: overview
ai usage: ai-assisted
---

# Drift detection for Azure Local

::: moniker range=">=azloc-2602"

This article explains how the drift detection framework identifies configuration deviations, improves troubleshooting, and helps reduce configuration-related issues in your Azure Local environment.

## Overview

Drift detection ensures Azure Local component states align with the Validated Solution Recipe (VSR). It compares installed component metadata with supported versions during regular update checks to identify configuration or version mismatches by continuously monitoring the system’s current state against a known‑good configuration. This process helps improve reliability, simplifies troubleshooting, and reduces configuration‑related issues.

Azure Local uses a validated baseline (derived from the approved software bill of materials) as the source of truth and compares it against the component versions you installed on the system. The framework identifies any deviation from this baseline as **drift**, indicating that a component no longer aligns with the supported configuration.

Currently, administrators can [manually trigger validation](#manual-validation) by using the `Invoke-AzStackHciVSRDriftDetectionValidation` cmdlet to generate detailed drift reports for build components.

## When drift detection runs

Azure Local performs drift detection at multiple points in its lifecycle to ensure that it detects issues as early as possible.

- **Before the cluster is created**: Drift detection runs as part of operating system (OS) image recipe validation.

- **After the cluster is running**: Drift detection runs continuously through the health checker framework, and validation runs at the start of an update.

## What drift detection checks

Drift detection validates a prioritized set of components that are critical to Azure Local operations.

Starting with release 2604, the system surfaces drift findings as **Warning** alerts and provides manual remediation recommendations for Azure CLI and PowerShell modules. In releases 2602 and 2603, drift findings appeared as **Informational** alerts.

The following table lists the validated components and remediation options available in release 2604 and later:

| Supported components | Drift severity | Remediation |
| ---- | ---- | ---- |
| Azure PowerShell modules | Warning | Manual remediation: Run `Remediate-PSModules`. |
| Azure Arc agent | Warning | Manual remediation; recommendation provided. |
| Azure CLI extensions | Warning | Manual remediation; recommendation provided. |
| Azure CLI | Warning | Manual remediation: Run `Remediate-AzCli`. |

> [!NOTE]
> Review drift findings before updates or node operations, and follow the recommended remediation guidance.

## Drift remediation

Starting with the 2604 release, drift detection provides remediation actions for Azure CLI and PowerShell modules. When a drift warning occurs, run the applicable remediation command for the component reporting drift, as listed in the preceding table.

Run the remediation command on every node where drift is detected.

The following example shows drift findings for Azure CLI and Azure CLI extensions before remediation:

```powershell
Name               : AzStackHci_AzureCli_Version
DisplayName        : Test Azure-Cli Module Version
Tags               : {}
Title              : Test Azure-Cli Module Version
Status             : FAILURE
Severity           : INFORMATIONAL
Description        : Failed to discover installed version of AzCli on host [V-HOST1] Expected [2.81.0] but discovered
                     [N/A]. Is it installed; can you run (az version)?.
Remediation        : Run powershell command Remediate-AzCli on the node. If the issue persists, contact Microsoft
                     Support.
TargetResourceID   : V-HOST1
TargetResourceName : V-HOST1
TargetResourceType : DriftDetection
Timestamp          : 3/12/2026 6:16:20 PM
AdditionalData     : {[Detail, Failed to discover installed version of AzCli on host [V-HOST1] Expected [2.81.0] but
                     discovered [N/A]. Is it installed; can you run (az version)?.], [Status, FAILURE], [TimeStamp,
                     03/12/2026 18:16:20], [Resource, Validate Drift Detection]...}
HealthCheckSource  : Manual\Standard\Medium\VSRDriftDetection\2fe4cffb
Name               : AzStackHci_AzureCliExtension_arcappliance_Version
DisplayName        : Test Azure-Cli Extension arcappliance Version
Tags               : {}
Title              : Test Azure-Cli Extension arcappliance Version
Status             : FAILURE
Severity           : INFORMATIONAL
Description        : Failed to parse installed version of 'arcappliance' on host 'V-HOST1'. Got ''.
Remediation        : Contact Microsoft Support.
TargetResourceID   : V-HOST1
TargetResourceName : V-HOST1
TargetResourceType : DriftDetection
Timestamp          : 3/12/2026 6:16:20 PM
AdditionalData     : {[Detail, Failed to parse installed version of 'arcappliance' on host 'V-HOST1'. Got ''.],
                     [Status, FAILURE], [TimeStamp, 03/12/2026 18:16:20], [Resource, Validate Drift Detection]...}
HealthCheckSource  : Manual\Standard\Medium\VSRDriftDetection\2fe4cffb
Name               : AzStackHci_AzureCliExtension_k8s-extension_Version
DisplayName        : Test Azure-Cli Extension k8s-extension Version
Tags               : {}
Title              : Test Azure-Cli Extension k8s-extension Version
Status             : FAILURE
Severity           : INFORMATIONAL
Description        : Failed to parse installed version of 'k8s-extension' on host 'V-HOST1'. Got ''.
Remediation        : Contact Microsoft Support.
TargetResourceID   : V-HOST1
TargetResourceName : V-HOST1
TargetResourceType : DriftDetection
Timestamp          : 3/12/2026 6:16:20 PM
AdditionalData     : {[Detail, Failed to parse installed version of 'k8s-extension' on host 'V-HOST1'. Got ''.],
                     [Status, FAILURE], [TimeStamp, 03/12/2026 18:16:20], [Resource, Validate Drift Detection]...}
HealthCheckSource  : Manual\Standard\Medium\VSRDriftDetection\2fe4cffb
Name               : AzStackHci_PowerShellModule_Az.Attestation_Version
DisplayName        : Test PowerShell Module Az.Attestation Version
Tags               : {}
Title              : Test PowerShell Module Az.Attestation Version
```

The applicable remediation command removes the incorrect CLI or PowerShell version and installs the version required by the validated solution recipe.

The following example shows the results after you remediate Azure CLI drift and run drift validation again:

```powershell
[v-host1]: PS C:\Users\ExampleUser\Documents> Remediate-AzCli
[
  {
    "Severity": 3,
    "ExpectedValue": "",
    "SystemValue": "",
    "ErrorMessage": "",
    "RecommendedAction": "",
    "TestName": "AzStackHci_AzureCli_Version",
    "TestDisplayName": "Test Azure-Cli Module Version",
    "RemediationAttempted": true
  }
]
[v-host1]: PS C:\Users\ExampleUser\Documents> $result = Invoke-AzStackHciVSRDriftDetectionValidation -PassThru
[v-host1]: PS C:\Users\ExampleUser\Documents> $result
HealthCheckSource  : Manual\Standard\Medium\VSRDriftDetection\d38d7df1
Name               : AzStackHci_AzcmaAgent_Version
DisplayName        : Test Azure Connected Machine Agent Version
Tags               : {}
Title              : Test Azure Connected Machine Agent Version
Status             : SUCCESS
Severity           : INFORMATIONAL
Description        :
Remediation        :
TargetResourceID   : V-HOST1
TargetResourceName : V-HOST1
TargetResourceType : DriftDetection
Timestamp          : 3/12/2026 6:49:39 PM
AdditionalData     : {[Detail, ], [Status, SUCCESS], [TimeStamp, 03/12/2026 18:49:39], [Resource, Validate Drift
                     Detection]...}
```

## Manual validation

To manually validate drift and generate a detailed report of configuration deviations, use the `Invoke-AzStackHciVSRDriftDetectionValidation` cmdlet.

Here's an example output:

```powershell
[v-Host1]: PS C:\Users\ExampleUser\Documents> $result = Invoke-AzStackHciVSRDriftDetectionValidation -PassThru
[v-Host1]: PS C:\Users\ExampleUser\Documents> $result
HealthCheckSource  : Manual\Standard\Medium\VSRDriftDetection\7d42890e
Name               : AzStackHci_AzcmaAgent_Version
DisplayName        : Test Azure Connected Machine Agent Version
Tags               : {}
Title              : Test Azure Connected Machine Agent Version
Status             : SUCCESS
Severity           : INFORMATIONAL
Description        :
Remediation        :
TargetResourceID   : V-HOST1
TargetResourceName : V-HOST1
TargetResourceType : DriftDetection
Timestamp          : 12/10/2025 7:42:09 PM
AdditionalData     : {[Detail, ], [Status, SUCCESS], [TimeStamp, 12/10/2025 19:42:09], [Resource, Validate Drift
                     Detection]...}
HealthCheckSource  : Manual\Standard\Medium\VSRDriftDetection\7d42890e
Name               : AzStackHci_AzureCli_Version
DisplayName        : Test Azure-Cli Module Version
Tags               : {}
Title              : Test Azure-Cli Module Version
Status             : SUCCESS
Severity           : INFORMATIONAL
Description        :
Remediation        :
TargetResourceID   : V-HOST1
TargetResourceName : V-HOST1
TargetResourceType : DriftDetection
Timestamp          : 12/10/2025 7:42:09 PM
```

::: moniker-end

::: moniker range="<azloc-2602"

This feature is available only in Azure Local version 2602 and later.

::: moniker-end
