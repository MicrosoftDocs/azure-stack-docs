---
title:  What's the Lifecycle Manager?
description: This article describes the Lifecycle Manager, the benefits it provides for an Azure Stack HCI cluster solution, and more.
author: ronmiab
ms.author: robess
ms.topic: overview
ms.reviewer: aaronfa
ms.lastreviewed: 04/05/2023
ms.date: 03/23/2023
---

# What's the Lifecycle Manager?

> Applies to: Azure Stack HCI, Supplemental Package.

This article describes the Lifecycle Manager and the benefits it provides for an Azure Stack HCI cluster solution.

## About the Lifecycle Manager

Azure Stack HCI solutions contain many individual features and components. Staying up to date with recent security fixes and feature improvements is important for all pieces of the Azure Stack HCI solution. Depending on which services you use, you might need to follow different processes to apply updates.

In past releases of Azure Stack HCI, like 20H2 and 21H2, the operating system (OS) was the primary component being updated. In 22H2, the Supplemental Package introduces new features and components in addition to the OS, including the Lifecycle Manager.

The Lifecycle Manager provides centralized orchestration capabilities for Azure Stack HCI solutions. It's installed as part of and enables the new deployment experience with the management of OS, core agents and services, and the solution extension. The Lifecycle Manager supports a broad range of updates and sets the foundation for substantial future improvements.

:::image type="content" source="media/lifecycle-manager/update-your-solution.png" alt-text="Screenshot of ways to deploy and update your solution." lightbox="media/lifecycle-manager/update-your-solution.png":::

Some new agents and services can't be updated outside the Lifecycle Manager. Availability of those updates depends on the specific feature.

## Benefits of the Lifecycle Manager

The Lifecycle Manager offers many benefits for updating your solution. Some of these benefits include:

- It simplifies update management by consolidating update workflows for various components into a single experience.

- It keeps the system in a well-tested and optimal configuration.

- It helps avoid downtime and effects on workloads with comprehensive health checks before and during an update.

- It improves reliability with automatic retry and the remediation of known issues.

- Whether managed locally or via the Azure portal, the common back-end drives a consistent experience.

## Lifecycle cadence

The Azure Stack HCI platform follows the [Modern Lifecycle policy](/lifecycle/policies/modern). To stay current within this policy, you must stay within six months of the most recent release. To learn more about the support windows, see [Azure Stack HCI release information](/azure-stack/hci/release-information).

Microsoft might release the following types of updates for the Azure Stack HCI platform:

|Update Type |Typical Cadence  |Description |
|------------|-----------------|------------|
|Patch Updates| Monthly |Patch updates primarily contain quality and reliability improvements. They might include OS LCUs or hotpatches. Some patches require host node reboots, while others don't. In some cases, hotfixes get released faster than monthly to fix critical or security issues.|
|Baseline Updates |Quarterly |Baseline updates include new features and improvements. They typically require host node reboots and might take longer.|
|Hotpatches | As needed |             |
|Solution Builder Extension (SBE)        | Bi-Annually |           |

Sometimes you might see updates to the latest patch level of your current baseline. Meaning, if a new baseline is available, you might see the baseline update itself or the latest patch level of the baseline.

Each baseline receives patch updates during the supported time frame. Your cluster must stay within six months of the most recent baseline to consider it supported.

## Platform updates management

Platform updates managed by the Lifecycle Manager contain new versions of the Azure Stack HCI operating system (OS), the Lifecycle Manager core agents and services, and the solution extension (depending on your cluster's hardware). Microsoft bundles these components into an update release and validates the combination of versions together to ensure interoperability.

- **Operating System:** What can we say here?

- **Lifecycle Manager agents and services:** What can we say here?

- **Solution extension:** Hardware vendors might choose to integrate with the Lifecycle Manager to enhance the update management experience for their customers.

  - If a hardware vendor has integrated with our update validation and release platform, the solution extension content includes the drivers and firmware, and the Lifecycle Manager orchestrates the necessary node reboots within the same maintenance window. You can spend less time searching for updates and experience fewer maintenance windows.

## Next steps

[Update the Azure Stack HCI solution](update-azure-stack-hci-solution.md).
