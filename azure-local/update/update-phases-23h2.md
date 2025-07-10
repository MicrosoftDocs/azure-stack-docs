---
title: Review update phases of Azure Local, version 23H2
description: Understand the various phases of solution updates applied to Azure Local, version 23H2.
author: alkohli
ms.author: alkohl
ms.topic: article
ms.date: 02/25/2025
---

# Review update phases of Azure Local

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article explains the different phases of solution updates that you apply to Azure Local to keep it up to date.

The procedure in this article applies to both single node and multi-node systems that are running the latest version of Azure Local with the orchestrator installed.

## About update phases

The Azure Local solution updates can consist of OS, agents and service, and solution extension updates. For more information on these solution updates, see [About updates for Azure Local](about-updates-23h2.md).

The new update feature automates the update process for agents, services, operating system content, and Solution Extension content, with the goal of maintaining availability by shifting workloads around throughout the update process when needed.

The updates can be of the following types:

- **Updates not requiring reboots** - The updates that can be applied to your Azure Local without any reboots.

- **Updates that require reboots** - The updates that might need a reboot in your Azure Local. Cluster-Aware Updating is used to reboot machines in the system one by one, ensuring the availability of the system during the update process.

The updates consist of several phases: discovering the update, staging the content, deploying the update, and reviewing the installation. Each phase might not require your input but distinct actions occur in each phase.

You can apply these updates via PowerShell or the Azure portal. Regardless of the interface you choose, the subsequent sections summarize what happens within each phase of an update. The following diagram shows what actions you might need to take during each phase and what actions Azure Local takes through the update operation.

[![A screenshot indicating the various phases of an update with actions you need to perform in each phase.](./media/update-phases/updates-phases-actions-23h2.png)](./media/update-phases/updates-phases-actions-23h2.png#lightbox)

## Phase 1: Discovery and acquisition

Before Microsoft releases a new update package, the package is validated as a collection of components. After the validation is complete, the content is released along with the release notes.

The release notes include the update contents, changes, known issues, and links to any external downloads that might be required (for example, drivers and firmware). For more information, see the [Latest release notes](../known-issues.md).

After Microsoft releases the update, your Azure Local update platform will automatically detect the update. Though you don't need to scan for updates, you must go to the **Updates** page in your management surface to see the new update’s details.

Depending on the hardware in your system and the scope of an update bundle, you might need to acquire and sideload extra content to proceed with an update. The **operating system** and **agents and services** content are provided by Microsoft, while depending on your specific solution and the OEM, the **Solution Extension** might require an extra download from the hardware OEM. If more is required, the installation flow prompts you for the content.

## Phase 2: Readiness checks and staging

There are a series of prechecks before installing a solution update. The prechecks are related to the storage systems, failover cluster requirements, remote management of the system, and solution extensions. These prechecks help to confirm that your Azure Local is safe to update and ensures updates go more smoothly.

A subset of these checks can be initiated outside the update process. Because new checks can be included in each update, these readiness checks are executed *after* the update content is downloaded and *before* it begins installing.

Readiness checks can also result in blocking conditions or warnings.

- If the readiness checks detect a blocking condition, the issues must be remediated before the update can proceed.

- If the readiness checks result in warnings the updates, it could introduce longer update times or affect the workloads. You might need to acknowledge the potential impact and bypass the warning before the update can proceed.

> [!NOTE]
> In this release, you can only initiate immediate install of the updates. Scheduling of updates is not supported.

## Phase 3: Installation progress and monitoring

While the update installs, you can monitor the progress via your chosen interface. Steps within the update are shown within a hierarchy and correspond to the actions taken throughout the workflow. Steps might be dynamically generated throughout the workflow, so the list of steps could change. For more information, see examples of [Monitoring progress via PowerShell](../update/update-via-powershell-23h2.md).

 The new update solution includes retry and remediation logic. It attempts to fix update issues automatically and in a non-disruptive way, but sometimes manual intervention is required. For more information, see [Troubleshooting updates](update-troubleshooting-23h2.md).

> [!NOTE]
> Once you remediate the issue, you need to rerun the checks to confirm the update readiness before proceeding.

## Next step

Learn more about how to [Troubleshoot updates](./update-troubleshooting-23h2.md).
