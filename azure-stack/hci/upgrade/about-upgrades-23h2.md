---
title: About Azure Local upgrade to version 23H2
description: Learn how to upgrade from Azure Local, version 22H2 to Azure Local, version 23H2.
author: alkohli
ms.topic: conceptual
ms.date: 10/11/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.service: azure-stack-hci
---

# About Azure Local upgrades

[!INCLUDE [applies-to](../../hci/includes/hci-applies-to-23h2-22h2.md)]

This article provides an overview of upgrading your existing Azure Local system from version 22H2 to version 23H2.

Throughout this article, we refer to Azure Local, version 23H2 as the *new* version and Azure Local, version 22H2 as the *old* version.

## About Azure Local, version 23H2

Azure Local, version 23H2 is the latest version of Azure Local. This version integrates the Azure Arc infrastructure that provisions and manages the workloads such as Arc VMs, Azure Kubernetes Services, and Azure Virtual Desktop. For more information, see [What's new in Azure Local, version 23H2](../whats-new.md#features-and-improvements-in-2311).

With version 23H2, Azure Local evolved from a cloud-connected operating system (OS) to an Arc-enabled solution. The OS forms the base layer of this solution, with the Arc and the Orchestrator (also known as the Lifecycle Manager) components layered on top. These components are packaged together into a solution that follows an [Infrastructure as code (IaC)](/devops/deliver/what-is-infrastructure-as-code) model.

- This IaC model takes a set of input parameters that are specific to each customer and environment.
- The lifecycle manager then orchestrates the desired state across all the layers to meet the desired state and version.

The following diagram illustrates the components of an Azure Local, version 23H2 system:

:::image type="content" source="./media/about-upgrades-23h2/azure-stack-hci-23h2-and-its-components.png" alt-text="Diagram that illustrates Azure Local and its components." lightbox="./media/about-upgrades-23h2/azure-stack-hci-23h2-and-its-components.png":::

## Azure Local upgrade versus update

An upgrade is a whole new version of software that represents a significant change or major improvement. An update, on the other hand, is a process of applying a set of changes to the software to improve its performance, security, or stability.

Azure Local, version 23H2, is a new version of the solution with a multitude of new capabilities. To move from Azure Local, version 22H2 to version 23H2, you need to upgrade your existing system. On the other hand, to ensure that you have the most recent features and security improvements for your current version of Azure Local, you would need to update your existing system.

## High-level steps for Azure Local upgrade

To upgrade Azure Local from an older version, follow these high-level steps:

1. Upgrade the *old* OS to the *new* OS using one of the following methods:
    - [Via PowerShell (recommended)](./upgrade-22h2-to-23h2-powershell.md).
    - [Via Windows Admin Center](./upgrade-22h2-to-23h2-windows-admin-center.md).
    - [Via other manual methods](./upgrade-22h2-to-23h2-other-methods.md).

1. Perform post-OS upgrade tasks.

1. Validate the solution upgrade readiness.

1. Apply the solution upgrade.

The following diagram illustrates the Azure Local upgrade process:

:::image type="content" source="./media/about-upgrades-23h2/update-os-to-23h2-and-apply-the-solution-update.png" alt-text="Diagram that illustrates the two steps to upgrade the OS and then apply the solution update." lightbox="./media/about-upgrades-23h2/update-os-to-23h2-and-apply-the-solution-update.png":::

## Supported workloads and configurations

Azure Local upgrade supports the following services and workloads:


|Workload/Configuration  |Currently supported  |
|---------|---------|
| Azure Kubernetes (AKS) on Azure Local     | See notes <br> Kubernetes versions are incompatible between Azure Local, version 22H2, and version 23H2. <br> Remove AKS and all the settings from AKS enabled by Azure Arc before you apply the solution upgrade.        |
| Arc VMs on Azure Local     | See notes <br> Preview versions of Arc VMs can't be upgraded.        |
| Stretched clusters on Azure Local     | No <br> The OS upgrade to 23H2 and the solution upgrade are unavailable for stretched clusters.      |
| System Center Virtual Machine Manager (SCVMM)    | No <br> If your Azure Local, version 22H2 instance is managed by SCVMM, this upgrade process isn't currently supported. <br> For more information on System Center 2025 release and Azure Local, version 23H2 support, see the [announcement](https://techcommunity.microsoft.com/t5/system-center-blog/announcement-system-center-2025-is-here/ba-p/4138510).         |
| Azure Local, version 22H2SP    | No <br> This upgrade process isn't supported for upgrading from Azure Local, version 22H2 Supplemental Package clusters.        |


## Next steps

Choose one of the following options to upgrade your Azure Local, version 22H2 to Azure Local, version 23H2:
- [Use PowerShell](./upgrade-22h2-to-23h2-powershell.md).
- [Use Windows Admin Center](./upgrade-22h2-to-23h2-windows-admin-center.md).
- [Use other methods](./upgrade-22h2-to-23h2-other-methods.md).
