---
title: Review phases of an Azure Stack HCI solution update (preview)
description: Understand the various phases of solution updates applied to Azure Stack HCI (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.date: 04/03/2023
---

# Phases of an Update

[!INCLUDE [applies-to](../../includes/hci-applies-to-supplemental-package.md)]

This article describes the various phases of solution updates that are applied to your Azure Stack HCI cluster to keep it up-to-date.

The procedure in this article applies to both a single node and a multi-node cluster that is running software versions with Lifecycle Manager installed. For more information, see [What is Lifecycle Manager?](../index.yml).

## About update phases

The Azure Stack HCI solution updates can consist of platform, service, and solution extension updates. For more information on each of these types of updates, see [What's in an Update](../index.yml).

The Lifecycle Manager automates the update process for agents, services, operating system content, and Solution Extension content, with the goal of maintaining availability by shifting workloads around throughout the update process when needed.

The updates can be of the following types:

- **Updates not requiring reboots** - The updates that can be applied to your Azure Stack HCI cluster without requiring any reboots for the servers in the cluster.

- **Updates that require reboots** - The updates may require a reboot of a server in your Azure Stack HCI cluster at a time. If an update requires rebooting the servers in the cluster, the Lifecycle Manager uses the Cluster-Aware Updating to reboot one server at a time. This ensures the availability of the cluster throughout the update process.

The updates consist of several phases: discovering the update, staging the content, deploying the update, and reviewing the installation. Each phase may not require your input but distinct actions occur in each phase.

You can apply these updates via PowerShell or via the Windows Admin Center UI. Regardless of the interface you choose, the subsequent sections summarize what happens within each phase of an update. The following diagram shows what actions you may need to perform during each phase of an update, and what actions the Azure Stack HCI takes throughout the update operation.

![A screenshot indicating the various phases of an update with actions you need to perform in each phase](../media/updates/updates-phases-actions.png)

## Phase 1: Discovery and acquisition

Before Microsoft releases a new update package, the package is validated as a collection of components. After the validation is complete, the content is released along with the release notes.

The release notes include the update contents, changes, known issues, and links to any external downloads that may be required (for example, drivers and firmware). For more information, see the [Latest release notes](../index.yml).

After Microsoft releases the update, your Azure Stack HCI update platform will automatically detect the update. Though you don't need to scan for updates, you must go to the **Updates** page in your management surface to see the new update’s details.

Depending on the hardware in your cluster and the scope of an update bundle, you may need to acquire and sideload extra content to proceed with an update. The **operating system** and **agents and services** content are provided by Microsoft, while depending on your specific solution and the OEM, the **Solution Extension** may require an extra download from the hardware OEM. If this is required, the installation flow prompts you for the content.

## Phase 2: Readiness checks and staging

Before installing a solution update, the Lifecycle Manager runs a series of checks to confirm that your Azure Stack HCI cluster is safe to update. This helps the update go more smoothly.

<!--Prechecks-->

A subset of these checks can be initiated outside the update process. Because new checks can be included in each update, these readiness checks are executed *after* the update content has been downloaded and *before* it begins installing.

Readiness checks can also result in blocking conditions or warnings.

- If the readiness checks detect a blocking condition, the issues must be remediated before the update can proceed.

- Readiness checks can also result in warnings that won’t block the updates but may introduce longer update times or impact the workloads. You may need to acknowledge the potential impact and bypass the warning before the update can proceed.

Typically the update platform tries to remediate the issues automatically but sometimes manual intervention is required. Once you remediate the issue, you need to rerun the checks to confirm the update readiness before proceeding.

> [!NOTE]
> In this release, you can only initiate immediate install of the updates. Scheduling of updates is not supported.

## Phase 3: Installation progress and monitoring

While the update installs, you can monitor the progress via your chosen interface. Steps within the update are shown within a hierarchy. This hierarchy corresponds to the actions the Lifecycle Manager takes throughout the workflow. Steps may be dynamically generated throughout the workflow, so the list of steps may change. For more information, see examples of [Monitoring progress via PowerShell](../update/update-via-powershell.md).

## Failures and diagnosis

The Lifecycle Manager includes retry and remediation logic. It attempts to fix issues in a non-disruptive way, such as retrying a CAU run. If an update run can't be remediated automatically, it fails. You can retry the update or visit the Azure Support Center to evaluate the next steps.

<!--## Common failure cases

THOMAS TO PROVIDE - list common failures we encounter in previews-->

## Collecting logs

If you encounter failures during the update process, collect diagnostic logs to help Microsoft identify and fix the issues. For more information, see how to [Collect diagnostic logs for Azure Stack HCI, version 22H2 (preview)](../manage/collect-logs.md).

## Next steps

Learn more about how to [Troubleshoot updates](../index.yml).
