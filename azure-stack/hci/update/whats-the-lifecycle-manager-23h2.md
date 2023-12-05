---
title: Update overview for Azure Stack HCI, version 23H2 (preview)
description: This article describes the updates feature for this release, benefits, and how to keep various pieces of your Azure Stack HCI, version 23H2 (preview) solution up to date.
author: ronmiab
ms.author: robess
ms.topic: overview
ms.reviewer: thoroet
ms.date: 11/28/2023
---

# Update overview for Azure Stack HCI, version 23H2 (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes the new update feature for this release, benefits of the feature, and how to keep various pieces of your Azure Stack HCI solution up to date.

[!INCLUDE [important](../../includes/hci-preview.md)]

## About the updates

Staying up to date with recent security fixes and feature improvements is important for all pieces of the Azure Stack HCI solution. The latest release introduces new features and components in addition to the OS, including the orchestrator (Lifecycle Manager).

The approach in this release provides a flexible foundation to integrate and manage various aspects of the Azure Stack HCI solution in one place. The orchestrator for updates is first installed during and enables the new deployment experience including the management of the OS, core agents and services, and the solution extension.

Here's an example of a new cluster deployment using the updates in this release:

:::image type="content" source="media/lifecycle-manager/update-your-solution-23h2.png" alt-text="Screenshot of ways to deploy and update your solution." lightbox="media/lifecycle-manager/update-your-solution-23h2.png":::

In this solution the Azure Stack HCI OS, agents and services, drivers, and firmware are automatically updated.

Some new agents and services can't be updated outside the orchestrator and availability of those updates depends on the specific feature. You might need to follow different processes to apply updates depending on the services you use.

## Benefits

This new approach:

- Simplifies update management by consolidating update workflows for various components into a single experience.

- Keeps the system in a well-tested and optimal configuration.

- Helps avoid downtime and effects on workloads with comprehensive health checks before and during an update.

- Improves reliability with automatic retry and the remediation of known issues.

- Whether managed locally or via the Azure portal, the common back-end drives a consistent experience.

## Lifecycle cadence

The Azure Stack HCI platform follows the [Modern Lifecycle policy](/lifecycle/policies/modern). The Modern Lifecycle policy defines the products and services that are continuously serviced and supported. To stay current with this policy, you must stay within six months of the most recent release. To learn more about the support windows, see [Azure Stack HCI release information](/azure-stack/hci/release-information).

Microsoft might release the following types of updates for the Azure Stack HCI platform:

|Update Type |Typical Cadence  |Description |
|------------|-----------------|------------|
|Monthly Updates | Monthly |Monthly updates primarily contain quality and reliability improvements. They might include OS Latest Cumulative Updates ¹. Some updates require host system reboots, while others don't. |
|Baseline Updates |Quarterly |Baseline updates include new features and improvements. They typically require host system reboots and might take longer. |
|Hotfixes | As needed | Hotfixes address blocking issues that could prevent regular monthly or baseline updates. To fix critical or security issues, hotfixes might be released sooner than monthly.  |
|Solution Builder Extension | As needed | Solution Builder Extension² provides driver, firmware, and other partner content specific to the system solution used. They might require host system reboots. |

¹ Quality updates released based on packages that contain monthly updates. These updates supersede the previous month's updates and contain both security and non-security changes.

² The Original Equipment Manufacturer determines the frequency of Solution Builder Extension updates.

Sometimes you might see updates to the latest patch level of your current baseline. If a new baseline is available, you might see the baseline update itself or the latest patch level of the baseline. Your cluster must stay within six months of the most recent baseline to consider it supported.

The next sections provide an overview of components, along with methods and interfaces for updating your solution.

## What's in the update package?

Solution updates managed by this feature contain new versions of the Azure Stack HCI operating system (OS), core agents and services, and the solution extension (depending on your cluster's hardware). Microsoft bundles these components into an update release and validates the combination of versions to ensure interoperability.

- Operating System: These updates help you stay productive and protected. They provide users and IT administrators with the security fixes they need and protect devices so that unpatched vulnerabilities can't be exploited.

- Agents and services: The orchestrator updates its own agents to ensure it has the recent fixes corresponding to the update. Azure Connected Machine agent and Arc Resource Bridge and its dependencies, get updated automatically to the latest validated version when Azure Stack HCI system is updated.

- Solution Builder Extension: Hardware vendors might choose to integrate with this feature to enhance the update management experience for their customers.

  - If a hardware vendor has integrated with our update validation and release platform, the solution extension content includes the drivers and firmware, and the orchestrator manages the necessary system reboots within the same maintenance window. You can spend less time searching for updates and experience fewer maintenance windows.

This solution is the recommended way to update your Azure Stack HCI cluster.

> [!NOTE]
> Customer workloads aren't covered by this update solution.

## User interfaces for updates

There are two interfaces you can use to apply available updates.

- PowerShell (Command line)
- The Azure portal

### PowerShell

The PowerShell procedures apply to a single server and multi-server cluster that runs with the orchestrator installed. For more information, see [Update your Azure Stack HCI solution via PowerShell](update-via-powershell-23h2.md).

### The Azure portal

You can install available Azure Stack HCI cluster updates via the Azure portal using the Azure Update Manager. For more information, see [What's the Azure Update Manager (preview)?](./azure-update-manager-23h2.md)

## Next step

Learn to [Understand update phases](./update-phases-23h2.md).

Learn how to [Troubleshoot updates](./update-troubleshooting-23h2.md).
