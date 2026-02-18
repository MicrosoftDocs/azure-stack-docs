---
title: Drift Detection Overview for Azure Local
description: Learn how Azure Locals Drift Detection framework ensures system reliability by continuously validating component states against a baseline.
author: ronmiab
ms.author: robess
ms.reviewer: pradwivedi
ms.subservice: hyperconverged
ms.date: 02/18/2026
ms.topic: overview
---

# Drift detection overview for Azure Local

::: moniker range=">=azloc-2602"

This article explains how the drift detection framework identifies configuration deviations, improves troubleshooting, and helps reduce configuration-related issues in your Azure Local environment.

## Overview

Drift detection enables Azure Local to continuously validate component-level states against the baseline Validated Solution Recipe (VSR). It detects version mismatches during the 24-hour update check and before updates by comparing installed component metadata to the recommended baselines.

Drift detection helps you identify when components deviate from the expected, validated configuration. By continuously comparing your system's current state to a known-good baseline, it improves reliability, simplifies troubleshooting, and reduces configuration-related issues.

Azure Local uses a validated baseline (derived from the approved software bill of materials) as the source of truth and compares it against the component versions you installed. Any deviation from this baseline is identified as a **drift**.

Administrators can manually trigger validation by using the `Invoke-AzStackHciVSRDriftDetectionValidation` cmdlet to generate detailed drift reports for build components.

## When drift detection runs

Azure Local performs drift detection at multiple points in its lifecycle to ensure that it detects issues as early as possible.

- **Before the cluster is created**: Drift detection runs as part of operating system (OS) image recipe validation.

- **After the cluster is running**: Drift detection runs continuously through the health checker framework, and validation runs at the start of an update.

## What drift detection checks

Drift detection validates a prioritized set of components that are critical to Azure Local operations. Currently, the system surfaces drift findings as **Informational alerts** and provides manual remediation recommendations for Azure Command-Line Interface (CLI) and PowerShell modules.

The following table lists the components that drift detection validates and the available remediation options:

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
