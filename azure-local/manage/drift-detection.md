---
title: Drift Detection Overview for Azure Local
description: Learn how Azure Local's Drift Detection framework ensures system reliability by continuously validating component states against a baseline.
author: ronmiab
ms.reviewer: pradwivedi
ms.date: 02/18/2026
ms.topic: overview
---

# Drift Detection Overview for Azure Local

::: moniker range=">=azloc-2602"

This release adds the Drift Detection framework, enabling Azure Local to perform continuous component level state validation against the baseline Validated Solution Recipe (VSR).

## Overview

The system detects version mismatches as part of every 24-hour update check and during pre-updates by evaluating installed component metadata against recommended baselines. It helps you identify when components in your environment deviate from the expected, validated configuration. By continuously comparing the current state of your system to a known-good baseline, drift detection improves reliability, simplifies troubleshooting, and reduces configuration-related issues.

Administrators can manually trigger validation by using the `Invoke-AzStackHciVSRDriftDetectionValidation` cmdlet to generate detailed drift reports for build components.

Azure Local uses a validated baseline (derived from the approved software bill of materials) as the source of truth and compares it against the component versions you installed.

Any deviation from this baseline is identified as **drift**.

## When Drift Detection Runs

Azure Local performs drift detection at multiple points in its lifecycle to ensure it detects issues as early as possible.

**Before the cluster is created**: Drift detection runs as part of OS image recipe validation

**After the cluster is running**: Drift detection runs continuously through the health checker framework. Validation runs at the start of an update.

## What Drift Detection Checks

Drift detection validates a prioritized set of components that are critical to Azure Local operations.

Currently, the system surfaces drift findings as **Informational alerts**, with some guidance on manual remediation recommendations for Azure Command-Line Interface (CLI) and PowerShell Modules.

| **Supported Components** | **Type of Drifts** | **Remediation** |
| ---- | ---- | ---- |
| Azure PowerShell modules | Informational | Manual remediation; recommendation provided |
| Azure Arc agent | Informational | Manual remediation; recommendation provided |
| Azure CLI extensions | Informational | Manual remediation; recommendation provided |
| Azure CLI | Informational | Manual remediation; recommendation provided |

> [!NOTE]
> Review drift findings before updates or node operations, and follow the recommended remediation guidance.

::: moniker-end

::: moniker range="<=azloc-2601"

::: moniker-end
