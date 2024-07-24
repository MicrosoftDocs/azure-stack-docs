---
title: Upgrade existing Azure Stack HCI version 22H2 to version 23H2 cluster
description: Learn about how to upgrade from Azure Stack HCI, version 22H2 cluster to Azure Stack HCI, version 23H2.
author: alkohli
ms.topic: how-to
ms.date: 07/08/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# About upgrades for Azure Stack HCI, version 23H2

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2-22h2.md)]

This article provides an overview of upgrades for an existing Azure Stack HCI, version 22H2 to Azure Stack HCI, version 23H2.

## About upgrades

The Azure Stack HCI, version 23H2 is the latest generally available software. This version of the solution has an exciting array of new capabilities including the Azure Arc infrastructure that enables you to provision and manage workloads on your Azure Stack HCI. Examples of these workloads include the Arc VMs, Azure Kubernetes Services, and Azure Virtual Desktop. For more information, see [What's new in Azure Stack HCI, version 23H2](../whats-new.md#2311-releases).

The Azure Stack HCI, version 23H2, has evolved from a cloud connected operating system (OS) to an Arc enabled solution. The operating system is the base layer for this solution. The Arc and the Orchestrator (also known as the Lifecycle Manager) components are layered on top of the OS. These are together packaged into a solution that follows an [Infrastructure as code (IaC)](/devops/deliver/what-is-infrastructure-as-code) model.

This IaC model takes a set of input parameters that are specific to each customer and the environment. The lifecycle manager then orchestrates the desired state across all the layers to meet the desired state and the version.

The following diagram illustrates the Azure Stack HCI, version 23H2 and its components:

:::image type="content" source="./media/about-upgrades-23h2/azure-stack-hci-23h2-and-its-components.png" alt-text="Diagram that illustrates Azure Stack HCI and its components." lightbox="./media/about-upgrades-23h2/azure-stack-hci-23h2-and-its-components.png":::

## Upgrade to Azure Stack HCI, version 23H2

To upgrade your Azure Stack HCI, version 22H2 to 23H2 software, you need to follow these high-level steps:

1. First, update version 22H2 OS to version 23H2 OS. For more information, see [Update the Azure Stack HCI, version 22H2 OS to Azure Stack HCI, version 23H2 OS](./upgrade-22h2-to-23h2-powershell.md).

1. Prepare to apply the solution update. For more information, see [Prepare to update your solution](./prepare-to-apply-23h2-solution-update.md).

1. Apply the solution update. For more information, see [Apply the solution update](../index.yml).

Here is a diagram that illustrates the steps to upgrade your cluster from version 22H2 to version 23H2:

   :::image type="content" source="./media/about-upgrades-23h2/update-os-to-23h2-and-apply-the-solution-update.png" alt-text="Diagram that illustrates the two steps to update the Azure Stack HCI OS and then apply the solution update." lightbox="./media/about-upgrades-23h2/update-os-to-23h2-and-apply-the-solution-update.png":::

## Next steps

- [Use PowerShell to upgrade the Azure Stack HCI, version 22H2 OS to Azure Stack HCI, version 23H2 OS](./upgrade-22h2-to-23h2-powershell.md).
- [Use other methods to upgrade the Azure Stack HCI, version 22H2 OS to Azure Stack HCI, version 23H2 OS](./upgrade-22h2-to-23h2-other-methods.md).