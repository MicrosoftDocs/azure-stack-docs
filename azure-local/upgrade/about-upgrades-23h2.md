---
title: About Azure Local upgrades
description: This article provides an overview of upgrading your cluster to Azure Local.
author: alkohli
ms.topic: upgrade-and-migration-article
ms.date: 09/03/2025
ms.author: alkohli
ms.reviewer: alkohli
ms.service: azure-local
---

# About Azure Local upgrades

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2-22h2.md)]

[!INCLUDE [azure-local-banner-23h2](../includes/azure-local-banner-23h2.md)]

This article provides an overview of upgrading your cluster to Azure Local.

[!INCLUDE [end-of-service-22H2](../includes/end-of-service-22h2.md)]

## About Azure Local

Azure Local integrates the Azure Arc infrastructure that provisions and manages workloads like Azure Local virtual machines (VMs) enabled by Azure Arc, Azure Kubernetes Services, and Azure Virtual Desktop. For more information, see [What's new in Azure Local](../whats-new.md).

Starting with version 2311.2, Azure Local has evolved from a cloud-connected operating system (OS) to an Arc-enabled solution. The OS forms the base layer of this solution, with the Arc and the Orchestrator (also known as the Lifecycle Manager) components layered on top. These components are packaged together into a solution that follows an [Infrastructure as code (IaC)](/devops/deliver/what-is-infrastructure-as-code) model.

- This IaC model takes a set of input parameters that are specific to each customer and environment.
- The lifecycle manager then orchestrates the desired state across all the layers to meet the desired state and version.

The following diagram illustrates the components of the new version of Azure Local:

:::image type="content" source="./media/about-upgrades-23h2/azure-local-23h2-and-its-components.png" alt-text="Diagram that illustrates Azure Local and its components." lightbox="./media/about-upgrades-23h2/azure-local-23h2-and-its-components.png":::

## Azure Local upgrade versus update

An *upgrade* is a transformational process that converts a cluster into an Azure Local cluster, introducing significant changes and major improvements. An *update*, on the other hand is a maintenance process that applies a set of changes to an existing Azure Local system to improve its performance, security, or stability.

To transition from version 22H2 to Azure Local, you must *upgrade* your existing system. On the other hand, to ensure your current version of Azure Local includes the most recent features and security improvements, you should *update* your system. For more details on updating Azure Local, see [About updates for Azure Local](../update/about-updates-23h2.md).

## High-level steps for Azure Local upgrade

To upgrade Azure Local from an older version, follow these high-level steps:

1. Upgrade the *old* OS to the *new* OS [via PowerShell](./upgrade-22h2-to-23h2-powershell.md).

1. Perform post-OS upgrade tasks.

1. Validate the solution upgrade readiness.

1. Apply the solution upgrade.

The following diagram illustrates the Azure Local upgrade process:

:::image type="content" source="./media/about-upgrades-23h2/update-os-to-23h2-and-apply-the-solution-update.png" alt-text="Diagram that illustrates the two steps to upgrade the OS and then apply the solution update." lightbox="./media/about-upgrades-23h2/update-os-to-23h2-and-apply-the-solution-update.png":::

## Supported workloads and configurations

> [!IMPORTANT]
> - Consult your hardware OEM before you upgrade Azure Local. Validate that your OEM supports the version and the upgrade.
> - Upgrading your Azure Local from the *old* version is supported only for regions where Azure Local 2311.2 is available. For more information, see [Azure Local region availability](../concepts/system-requirements-23h2.md#azure-requirements).
> - Use of 3rd party tools to install upgrades isn't supported.

Azure Local upgrade supports the following services and workloads:

| Workload/Configuration | Currently supported |
|--|--|
| Azure Kubernetes (AKS) on Azure Local | See notes <br> Kubernetes versions are incompatible between the *old* and *new* Azure Local versions. <br> Before applying the solution upgrade, wait for the solution upgrade banner to appear on your Azure Local resource page. Then, remove AKS and all the settings from AKS enabled by Azure Arc. |
| Azure Local VMs enabled by Azure Arc | See notes <br> Preview versions of Azure Local VMs can't be upgraded. |
| Stretched clusters on Azure Local | Yes <br> You must upgrade to Azure Stack HCI OS, version 23H2 to maintain your cluster in a supported state. <br> The solution upgrade isn't applicable for stretched clusters. |
| System Center Virtual Machine Manager (SCVMM) | Yes <br> If your Azure Local instance running version 22H2 is managed by SCVMM 2025, the OS upgrade is supported. |
| Azure Local, version 22H2SP | No <br> This upgrade process isn't supported for upgrading from Azure Local, version 22H2 Supplemental Package clusters. |

## Next steps

- [Upgrade Azure Stack HCI OS via PowerShell](./upgrade-22h2-to-23h2-powershell.md).
