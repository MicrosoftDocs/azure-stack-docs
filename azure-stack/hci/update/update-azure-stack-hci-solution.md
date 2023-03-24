---
title:  Update an Azure Stack HCI solution.
description: This article describes how you can keep various pieces of your Azure Stack HCI solution up to date.
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.reviewer: aaronfa
ms.lastreviewed: 03/17/2023
ms.date: 03/17/2023
---

# Update the Azure Stack HCI solution

> Applies to: Azure Stack HCI, Supplemental Package

This article describes how you can keep various pieces of your Azure Stack HCI solution up to date.

## About Update the solution

The Lifecycle Manager intends to provide a flexible foundation, such that over time, more of the solution content can be integrated and managed in one place.

In the 22H2 release, the Lifecycle Manager allows management of the OS, solution extension, core agent, and service content. The following section provides an overview of this content, along with methods and links for updating your solution outside of the Lifecycle Manager.  

## Azure Stack HCI Platform

The Azure Stack platform includes the Azure Stack HCI operating system (OS) that runs on the nodes within your cluster, system agents and services, and the drivers and firmware required by your host hardware.

To keep the platform up to date via the Lifecycle Manager, see [What's the Lifecycle Manager](whats-the-lifecycle-manager.md)?

## Cluster update methods

There are two methods for managing your Azure Stack HCI cluster updates:

- Lifecycle management.
- Manual management.

### Lifecycle management

The Lifecycle Manager is the recommended way to update your Azure Stack HCI cluster. When updating the platform, we recommend the following high-level process:

- Plan for the update.
  - Discover the update, read the release notes, and determine a good time to update. For example, a time when production workloads aren't in use, or nonpeak hours.
  - Take backups of your deployment.
  - Download the update.
  - If more content is required from your Solution Builder, acquire the content.

- Review any precheck warnings or failures and remediate as necessary.
  - Execute the update.

- Monitor the update as it proceeds.
  - Review the update and system health after completion.
  - Confirm that your storage and workloads are healthy.

As mentioned, you can choose to bypass this method and manage your cluster updates manually.

### Manual management

Depending on the availability of content from your Solution Builder, you can apply your clusters updates manually using these steps:

1. [Updates and upgrades](../concepts/updates.md).

2. [Update the cluster](../manage/update-cluster.md).

For more information, see [Update your Azure Stack HCI solution Manually](lifecycle-management-placeholder.md).

For more reference information, see [ClusterAwareUpdating PowerShell commands](/powershell/module/clusterawareupdating/?view=windowsserver2022-ps&preserve-view=true).

There might be some issues or limitations when manually managing OS updates. For more information, see [Known issues](lifecycle-management-placeholder.md).

## User interface for updates

In addition to the methods that can be used to update your solution, there are two interfaces that can be used to apply your available updates. These interfaces are PowerShell and Windows Admin Center.

### PowerShell

You can also use PowerShell to manage your solution updates. The PowerShell procedures apply to a single node and multi-node cluster that is running with the Lifecycle Manager installed.

For more information, see [Update your Azure Stack HCI solution via PowerShell](update-via-powershell.md).

> [!IMPORTANT]
> If your PowerShell modules were installed via Install-Module, run the [Update-Module](/powershell/module/powershellget/update-module?view=powershell-7.2#example-1--update-all-modules&preserve-view=true) command to update them.

### Windows Admin Center

You can use Windows Admin Center as another method to install your solution updates. To install updates using Windows Admin Center, follow these steps:

1. Navigate to Windows Admin Center **Settings** page.

2. Select **Update** to install the update.  

For more information, see [Update your Azure Stack solution via Windows Admin Center](lifecycle-management-placeholder.md).

> [!NOTE]
> Alternatively, you can download and install the latest MSI package from the Microsoft Evaluation Center. For more information, see [Windows Admin Center](/windows-server/manage/windows-admin-center/overview).  

### Windows Admin Center Extensions

To apply OS update and driver/firmware updates using Windows Admin Center extensions, see [Installing an extension](/windows-server/manage/windows-admin-center/configure/using-extensions).

## Workload updates

Along with updates for your cluster, there are workload updates that can be applied. These workloads include Azure Kubernetes Service (AKS) hybrid, Azure Arc, and Infrastructure Virtual Machines (VMs). The next sections will provide more detail on these workloads and ways to apply updates.

### Azure Kubernetes Service (AKS) hybrid

Azure Kubernetes Service (AKS) hybrid runs via Virtual Machines (VM) on the Azure Stack HCI system. Microsoft releases a new version of the VM images monthly and you must update your VMs within 60 days. AKS hybrid tooling, which involves bringing up new VMs and moving workloads over in a rolling fashion, orchestrates the process.

There are two types of updates for AKS hybrid that can be initiated through PowerShell or Windows Admin Center.

- Host updates.

- Workload cluster updates.

To update AKS hybrid via Windows Admin Center, use these instructions:

- [Upgrade the Azure Kubernetes Service host in AKS hybrid using Windows Admin Center](/azure/aks/hybrid/update-akshci-host-windows-admin-center).  

- [Upgrade the Kubernetes version of Azure Kubernetes Service (AKS) workload clusters with Windows Admin Center](/azure/aks/hybrid/upgrade-kubernetes).

To update AKS hybrid using PowerShell, use these instructions:

- [Upgrade the Azure Kubernetes Service host in AKS hybrid using PowerShell](/azure/aks/hybrid/update-akshci-host-powershell).

- [Upgrade Kubernetes version of Azure Kubernetes Service (AKS) workload clusters in AKS hybrid using PowerShell](/azure/aks/hybrid/upgrade).

### Azure Arc

Azure Arc is a bridge that extends the Azure platform to help you build applications and services with the flexibility to run across datacenters, at the edge, and in multi-cloud environments.

- To learn more about Azure Arc, see [Azure Arc resource bridge (preview) overview](/azure/azure-arc/resource-bridge/overview).

- To apply updates to your Azure Arc agent, see [Upgrade the Agent](/azure/azure-arc/servers/manage-agent#upgrade-the-agent).

### Infrastructure Virtual Machines (VMs)

Software-Defined Networking relies on several Virtual Machines. To update these virtual machines, see [Update SDN infrastructure for Azure Stack HCI](../manage/update-sdn.md) for instructions.

Other Microsoft services that rely on Azure Stack HCI VMs may have their own instructions for updates, such as individually connecting to VMs to upgrade them, or swapping a VM's virtual hard disk (VHD).

### Customer apps and workloads

The Azure Stack HCI platform doesn't update customer workloads. Update processes depend on the type of workload.

## Next steps

[What's the Lifecycle Manager](whats-the-lifecycle-manager.md)?
