---
title: Upgrade existing Azure Stack HCI version 22H2 to version 23H2 cluster
description: Learn about how to upgrade from Azure Stack HCI, version 22H2 cluster to Azure Stack HCI, version 23H2.
author: alkohli
ms.topic: how-to
ms.date: 07/31/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# About upgrades for Azure Stack HCI, version 23H2

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2-22h2.md)]

This article provides an overview of upgrades for an existing Azure Stack HCI, version 22H2 to Azure Stack HCI, version 23H2.

Throughout this article, we'll refer Azure Stack HCI, version 23H2 as the *new* version and Azure Stack HCI, version 22H2 as the *old* version.

## About Azure Stack HCI, version 23H2

The Azure Stack HCI, version 23H2 is the latest generally available software that includes the Azure Arc infrastructure to enable you to provision and manage workloads such as Arc VMs, Azure Kubernetes Services, and Azure Virtual Desktop. For more information, see [What's new in Azure Stack HCI, version 23H2](../whats-new.md#features-and-improvements-in-2311).

The Azure Stack HCI, version 23H2, evolved from a cloud connected operating system (OS) to an Arc enabled solution. The operating system is the base layer for this solution. The Arc and the Orchestrator (also known as the Lifecycle Manager) components are layered on top of the OS. These are together packaged into a solution that follows an [Infrastructure as code (IaC)](/devops/deliver/what-is-infrastructure-as-code) model.

This IaC model takes a set of input parameters that are specific to each customer and the environment. The lifecycle manager then orchestrates the desired state across all the layers to meet the desired state and the version.

The following diagram illustrates the Azure Stack HCI, version 23H2 and its components:

:::image type="content" source="./media/about-upgrades-23h2/azure-stack-hci-23h2-and-its-components.png" alt-text="Diagram that illustrates Azure Stack HCI and its components." lightbox="./media/about-upgrades-23h2/azure-stack-hci-23h2-and-its-components.png":::

## Upgrade vs update

An upgrade is a whole new version of software that represents a significant change or major improvement. An update, on the other hand, is a process of applying a set of changes to the software to improve its performance, security, or stability.

The Azure Stack HCI, version 23H2, is a whole new version of the software with a multitude of new capabilities. To move from Azure Stack HCI, version 22H2 to version 23H2, you need to upgrade your existing cluster. On the other hand, to ensure that you have the most recent features and security improvements for your current version of Azure Stack HCI, you would need to update your existing cluster.

TO update your existing cluster:

- If you're running Azure Stack HCI, version 22H2, see [Update Azure Stack HCI, version 22H2](../manage/update-cluster.md).
- If you're running Azure Stack HCI, version 23H2, see [Update Azure Stack HCI, version 23H2](../update/azure-update-manager-23h2.md).

## Upgrade to Azure Stack HCI, version 23H2

To upgrade your Azure Stack HCI from an old version, follow these high-level steps:

1. First, update the old version of OS to version 23H2 OS. You can update the OS using one of the following methods:
    - [Via the PowerShell (recommended)](./upgrade-22h2-to-23h2-powershell.md).
    - [Via the Windows Admin Center](./upgrade-22h2-to-23h2-windows-admin-center.md).
    - [Via other manual methods](./upgrade-22h2-to-23h2-other-methods.md).

1. Prepare to apply the solution update.

1. Apply the solution update.

Here's a diagram that illustrates the steps to upgrade your cluster from version 22H2 to version 23H2:

:::image type="content" source="./media/about-upgrades-23h2/update-os-to-23h2-and-apply-the-solution-update.png" alt-text="Diagram that illustrates the two steps to update the Azure Stack HCI OS and then apply the solution update." lightbox="./media/about-upgrades-23h2/update-os-to-23h2-and-apply-the-solution-update.png":::

## Next steps

Choose one of the following options to upgrade your Azure Stack HCI, version 22H2 to Azure Stack HCI, version 23H2:
- [Use PowerShell to upgrade the Azure Stack HCI, version 22H2 OS to Azure Stack HCI, version 23H2 OS](./upgrade-22h2-to-23h2-powershell.md).
- [Use Windows Admin Center to upgrade the Azure Stack HCI, version 22H2 OS to Azure Stack HCI, version 23H2 OS](../index.yml).
- [Use other methods to upgrade the Azure Stack HCI, version 22H2 OS to Azure Stack HCI, version 23H2 OS](./upgrade-22h2-to-23h2-other-methods.md).