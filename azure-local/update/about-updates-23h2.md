---
title: About updates for Azure Local, version 23H2
description: This article describes the updates feature for this release, benefits, and how to keep various pieces of your Azure Local, version 23H2 solution up to date.
author: ronmiab
ms.author: robess
ms.topic: overview
ms.reviewer: thoroet
ms.date: 08/13/2025
---

# About updates for Azure Local

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

[!INCLUDE [azure-local-banner-23h2](../includes/azure-local-banner-23h2.md)]

This article describes the new update feature for this release of Azure Local, the benefits of the feature, and how to keep various components of your solution up to date.

## About the updates

Staying up to date with recent security fixes and feature improvements is important for all pieces of the Azure Local solution. The latest release introduces new features and components in addition to the OS, including the orchestrator (Lifecycle Manager).

The approach in this release provides a flexible foundation to integrate and manage various aspects of the Azure Local solution in one place. The orchestrator for updates is first installed during deployment and enables the new deployment experience including the management of the Azure Stack HCI operating system (OS), core agents and services, and the solution extension.

Here's an example of a new system deployment using the updates in this release:

:::image type="content" source="media/about-updates/update-your-solution-23h2.png" alt-text="Screenshot of ways to deploy and update your solution." lightbox="media/about-updates/update-your-solution-23h2.png":::

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

[!INCLUDE [azure-local-banner-resource-bridge](../includes/azure-local-banner-resource-bridge.md)]

Azure Local follows the [Modern Lifecycle policy](/lifecycle/policies/modern), which defines products and services that are continuously serviced and supported. To remain compliant with this policy, you must stay within six months of the most recent release. For more information on support windows, see [Azure Local release information](../release-information-23h2.md).

Microsoft might release the following types of updates for Azure Local:

|Update Type |Typical Cadence  |Description |
|------------|-----------------|------------|
|Cumulative Updates | Monthly | Cumulative updates primarily include quality and reliability improvements. They might also include OS Latest Cumulative Updates ¹. Some updates require host system reboots, while others do not. |
|Feature Updates |Semi-annually|Feature updates introduce new features and improvements. They typically require host system reboots and might take longer to apply. |
|Hotfixes | As needed | Hotfixes address critical issues that could block regular monthly or semi-annual updates. These updates might be released sooner than the monthly cadence to resolve urgent security or functionality issues. |
|Solution Builder Extension | As needed | Solution Builder Extension² provides drivers, firmware, and other partner-specific content. These updates might require host system reboots. |

¹ Quality updates released based on packages that contain monthly updates. These updates supersede the previous month's updates and include both security and non-security changes.

² The Original Equipment Manufacturer determines the frequency of Solution Builder Extension updates. These updates often align with Azure Local feature releases, allowing customers to install a combined update.

Sometimes you might see updates to the latest patch level of your current feature. If a new feature is available, you might see the feature update itself or the latest patch level of the feature. Your system must stay within six months of the most recent feature to consider it supported. For more information and a visualization of supported releases, see [About Azure Local releases](../release-information-23h2.md#about-azure-local-releases).

The next sections provide an overview of components, along with methods and interfaces for updating your solution.

## What's in the update package?

Solution updates managed by this feature contain new versions of the Azure Stack HCI OS, core agents and services, and the solution extension (depending on your system's hardware). Microsoft bundles these components into an update release and validates the combination of versions to ensure interoperability.

- Operating System: These updates help you stay productive and protected. They provide users and IT administrators with the security fixes they need and protect devices so that unpatched vulnerabilities can't be exploited.

- Agents and services: The orchestrator updates its own agents to ensure it has the recent fixes corresponding to the update. Azure Connected Machine agent and Arc resource bridge and its dependencies, get updated automatically to the latest validated version when Azure Local is updated.

- Solution Builder Extension: Hardware vendors might choose to integrate with this feature to enhance the update management experience for their customers.

  - If a hardware vendor integrates with our update validation and release platform, the solution extension content includes the drivers and firmware, and the orchestrator manages the necessary system reboots within the same maintenance window. You can spend less time searching for updates and experience fewer maintenance windows.

This solution is the recommended way to update your Azure Local.

> [!NOTE]
>
> - Azure Local update includes updates for all components, including Azure CLI, PowerShell, and any extensions. Microsoft does not support out of band updates for individual components. The out of band updates could lead to incompatibility with Application Control for Windows.
> - Customer workloads aren't covered by this update solution.

## User interfaces for updates

There are two interfaces you can use to apply available updates.

- PowerShell (Command line)
- The Azure portal

### PowerShell

The PowerShell procedures apply to both single-node and multi-node systems that run with the orchestrator installed. For more information, see [Update Azure Local via PowerShell](update-via-powershell-23h2.md).

### The Azure portal

You can install Azure Local updates using the Azure Update Manager in the Azure portal. For more information, see [Use Azure Update Manager to update Azure Local](./azure-update-manager-23h2.md).

### Unsupported interfaces for updates

When you install updates for Azure Local, don't use the following interfaces:

- SConfig
- Windows Admin Center
- Azure Update Manager from the Machines pane in the Azure portal
- Updates pane from the machine (Machine-Azure Arc) resource page in the Azure portal
- Manual runs of Cluster-Aware Updating

Using these interfaces can install out-of-band updates, which aren't supported within the lifecycle and may cause various issues on the system. Additionally, billing for update operations like periodic assessment, checking for updates, using the scheduler, and installing updates on the machine resource (Machine-Azure Arc) may occur.

> [!IMPORTANT]
> Use of 3rd party tools to install updates is not supported.

## Next steps

Learn to [Understand update phases](./update-phases-23h2.md).

Learn how to [Troubleshoot updates](./update-troubleshooting-23h2.md).
