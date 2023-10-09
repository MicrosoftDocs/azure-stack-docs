---
title:  What's the Lifecycle Manager (preview)?
description: This article describes the Lifecycle Manager and how to keep various pieces of your Azure Stack HCI solution up to date.
author: ronmiab
ms.author: robess
ms.topic: overview
ms.reviewer: thoroet
ms.date: 10/09/2023
---

# What's the Lifecycle Manager (preview)?

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes the Lifecycle Manager, benefits of the feature, and how to keep various pieces of your Azure Stack HCI solution up to date. This information is applicable to Azure Stack HCI, version 23H2 (preview).

[!INCLUDE [important](../../includes/hci-preview.md)]

## About the Lifecycle Manager

Staying up to date with recent security fixes and feature improvements is important for all pieces of the Azure Stack HCI solution. The latest release introduces new features and components in addition to the OS, including the Lifecycle Manager.

The Lifecycle Manager provides a flexible foundation to integrate and manage various aspects of the Azure Stack HCI solution in one place. It's installed as part of and enables the new deployment experience including the management of the OS, core agents and services, and the solution extension. The Lifecycle Manager supports different types of updates and sets the groundwork for substantial future enhancements.

Here's an example of a new cluster deployment using the Lifecycle Manager:

:::image type="content" source="media/lifecycle-manager/update-your-solution-23h2.png" alt-text="Screenshot of ways to deploy and update your solution." lightbox="media/lifecycle-manager/update-your-solution.png":::

In this solution the Azure Stack HCI OS, agents and services, drivers, and firmware are automatically updated.

Some new agents and services can't be updated outside the Lifecycle Manager and availability of those updates depends on the specific feature. You might need to follow different processes to apply updates depending on the services you use.

## Benefits of the Lifecycle Manager

Here are the benefits of using the Lifecycle Manager to update your Azure Stack HCI solution:

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
|Monthly Updates | Monthly |Monthly updates primarily contain quality and reliability improvements. They might include OS Latest Cumulative Updates ¹. Some updates require host system reboots, while others don't. |
|Baseline Updates |Quarterly |Baseline updates include new features and improvements. They typically require host system reboots and might take longer. |
|Hotfixes | As needed | Hotfixes address blocking issues that could prevent regular monthly or baseline updates. To fix critical or security issues, hotfixes might be released sooner than monthly.  |
|Solution Builder Extension | As needed | Solution Builder Extension² provides driver, firmware, and other partner content specific to the system solution used. They might require host system reboots. |

¹ Quality updates released based on packages that contain monthly updates. These updates supersede the previous month's updates and contain both security and non-security changes.

² The Original Equipment Manufacturer determines the frequency of Solution Builder Extension updates.

Sometimes you might see updates to the latest patch level of your current baseline. If a new baseline is available, you might see the baseline update itself or the latest patch level of the baseline. Your cluster must stay within six months of the most recent baseline to consider it supported.

The next sections provide an overview of components, along with methods and links for updating your solution.

## Lifecycle Manager solution updates

Solution updates managed by the Lifecycle Manager contain new versions of the Azure Stack HCI operating system (OS), the Lifecycle Manager core agents and services, and the solution extension (depending on your cluster's hardware). Microsoft bundles these components into an update release and validates the combination of versions to ensure interoperability.

- Operating System: These updates help you stay productive and protected. They provide users and IT administrators with the security fixes they need and protect devices so that unpatched vulnerabilities can't be exploited.

- Lifecycle Manager agents and services: The Lifecycle Manager updates its own agents to ensure it has the recent fixes corresponding to the update. To achieve a successful update of its agents, the Lifecycle Manager:

  - Prepares and updates the servicing stack
  - Installs new agents and services
  - Updates the host OS. Cluster-Aware Updating is used to orchestrate reboots.

- Solution Builder Extension: Hardware vendors might choose to integrate with the Lifecycle Manager to enhance the update management experience for their customers.

  - If a hardware vendor has integrated with our update validation and release platform, the solution extension content includes the drivers and firmware, and the Lifecycle Manager orchestrates the necessary system reboots within the same maintenance window. You can spend less time searching for updates and experience fewer maintenance windows.

- Azure Arc Extensions:

- Azure Resource Bridge:

- Azure Kubernetes Infrastructure:

The Lifecycle Manager is the recommended way to update your Azure Stack HCI cluster.

> [!NOTE]
> Customer workloads aren't covered by Lifecycle Manager.

## User interfaces for updates

In addition to the Lifecycle Management method used to update your solution, there are two interfaces you can use to apply your available updates.

- PowerShell (Command line)
- The Azure portal

### PowerShell

The PowerShell procedures apply to a single server and multi-server cluster that runs with the Lifecycle Manager installed. For more information, see [Update your Azure Stack HCI solution via PowerShell](update-via-powershell-md).

### The Azure portal

<!--Add content to tie in new Azure Update Manager article-->

## Next steps

Learn to [Understand update phases](update-phases.md).

Learn how to [Troubleshoot updates](../update/update-troubleshooting.md).
