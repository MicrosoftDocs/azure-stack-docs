---
title:  What's the Lifecycle Manager (preview)?
description: This article describes the Lifecycle Manager, the benefits it provides for an Azure Stack HCI cluster solution, and more.
author: ronmiab
ms.author: robess
ms.topic: overview
ms.reviewer: thoroet
ms.lastreviewed: 06/14/2023
ms.date: 06/14/2023
---

# What's the Lifecycle Manager (preview)?

[!INCLUDE [applies-to](../../includes/hci-applies-to-supplemental-package.md)]

This article describes the Lifecycle Manager, a feature that helps keep your Azure Stack HCI cluster solution up to date and is applicable to version 2303 of the Supplemental Package and later.

[!INCLUDE [important](../../includes/hci-preview.md)]

## About the Lifecycle Manager

Azure Stack HCI solutions contain many individual features and components. Staying up to date with recent security fixes and feature improvements is important for all pieces of the Azure Stack HCI solution. To stay up to date, you might need to follow different processes to apply updates depending on the services you use.

In past releases of Azure Stack HCI, like 20H2 and 21H2, the operating system (OS) was the primary component being updated. In 22H2, the Supplemental Package introduces new features and components in addition to the OS, including the Lifecycle Manager.

The Lifecycle Manager provides centralized orchestration capabilities for Azure Stack HCI solutions. It's installed as part of and enables the new deployment experience with the management of the OS, core agents and services, and the solution extension. The Lifecycle Manager supports a broad range of updates and sets the foundation for substantial future improvements.

Here's an example of a new cluster deployment using the deployment tool with the Lifecycle Manager:

:::image type="content" source="media/lifecycle-manager/update-your-solution.png" alt-text="Screenshot of ways to deploy and update your solution." lightbox="media/lifecycle-manager/update-your-solution.png":::

In this solution the Azure Stack HCI OS, driver, firmware, and agents and services, are automatically updated. Note, some new agents and services can't be updated outside the Lifecycle Manager and availability of those updates depends on the specific feature.

## Benefits of the Lifecycle Manager

The Lifecycle Manager offers many benefits for updating your solution. Some of these benefits include:

- It simplifies update management by consolidating update workflows for various components into a single experience.

- It keeps the system in a well-tested and optimal configuration.

- It helps avoid downtime and effects on workloads with comprehensive health checks before and during an update.

- It improves reliability with automatic retry and the remediation of known issues.

- Whether managed locally or via the Azure portal, the common back-end drives a consistent experience.

## Lifecycle cadence

The Azure Stack HCI platform follows the [Modern Lifecycle policy](/lifecycle/policies/modern). The Modern Lifecycle policy defines the products and services that are continuously serviced and supported. To stay current with this policy, you must stay within six months of the most recent release. To learn more about the support windows, see [Azure Stack HCI release information](/azure-stack/hci/release-information).

Microsoft might release the following types of updates for the Azure Stack HCI platform:

|Update Type |Typical Cadence  |Description |
|------------|-----------------|------------|
|Patch Updates | Monthly |Patch updates primarily contain quality and reliability improvements. They might include OS LCUs or hotpatches. Some patches require host system reboots, while others don't. To fix critical or security issues, hotfixes might be released sooner than monthly. |
|Baseline Updates |Quarterly |Baseline updates include new features and improvements. They typically require host system reboots and might take longer. |
|Hotfixes | As needed | Hotfixes address blocking issues that could prevent regular patch or baseline updates.  |
|Solution Builder Extension (SBE)  | Bi-Annually | Solution Builder Extension provides driver, firmware, and other partner content specific to the system solution used. They might require host system reboots. |

Sometimes you might see updates to the latest patch level of your current baseline. If a new baseline is available, you might see the baseline update itself or the latest patch level of the baseline. Your cluster must stay within six months of the most recent baseline to consider it supported.

## Next steps

Learn more about how to [Use Lifecycle Manager for Azure Stack HCI solution updates](update-azure-stack-hci-solution.md).
