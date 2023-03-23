---
title:  What's in an update?
description: This article describes what's in a solution update and what's new with the addition of the Lifecycle Manager.
author: ronmiab
ms.author: robess
ms.topic: conceptual
ms.reviewer: aaronfa
ms.lastreviewed: 03/17/2023
ms.date: 03/17/2023
---

# What's in an update?

> Applies to: Azure Stack HCI, Supplemental Package

This article describes what's in a solution update and what's new with the addition of the Lifecycle Manager.

## Lifecycle cadence

The Azure Stack HCI platform follows the [Modern Lifecycle policy](/lifecycle/policies/modern). To stay current within this policy, you must stay within six months of the most recent release. To learn more about the support windows, see [Azure Stack HCI release information](lifecycle-management-placeholder.md).

Microsoft might release the following types of updates for the Azure Stack HCI platform:

|Update Type |Typical Cadence |Description |
|------------|----------------|------------|
|Patch Updates| Monthly |Patch updates primarily contain quality & reliability improvements. They may include the OS LCUs or hotpatches. Some patches require host node reboots, while some may not. In some cases, hotfixes may be released faster than monthly to fix critical or security issues.|
|Baseline Updates |Quarterly |Baseline updates include new features and improvements. They typically require host node reboots and may take longer.|

At times, you might see updates to the latest patch level of your current baseline. If a new baseline is available, you might also see the baseline update itself or the latest patch level of the baseline.

Each baseline receives patch updates for as long as it's supported. Your cluster must stay within six months of the most recent baseline to be considered supported.

## Rollout and preview

What can I say about this area?

## Lifecycle Manager

Platform updates managed by the Lifecycle Manager contain new versions of the Azure Stack HCI operating system (OS), core agents, service content, and the solution extension (depending on your cluster's hardware).

### Operating System content

What can I say about this area?

- Alignment with OS versions.

- Find the active OS version.

### Agents and services

- What does this category include?

- What is involved in the update process for this content?

### Solution extension content

Hardware vendors might choose to integrate with the Lifecycle Manager to enhance the update management experience for their customers. If a hardware vendor has integrated with our update validation and release platform, the solution extension content includes the drivers and firmware, and the Lifecycle Manager orchestrates the necessary node reboots within the same maintenance window. Which means you can spend less time searching for updates and experience fewer maintenance windows!

> [!NOTE]
> Microsoft bundles these components into an update release and validates the combination of versions together to ensure interoperability.

## Next steps

[Update the Azure Stack HCI solution](lifecycle-management-placeholder.md).
