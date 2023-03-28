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

In the 22H2 release, the Lifecycle Manager allows management of the OS, solution extension, core agent, and service content. The following section provides an overview of these components, along with methods and links for updating your solution.  

## Azure Stack HCI Platform

The Azure Stack platform includes the Azure Stack HCI operating system (OS) that runs on the nodes within your cluster, system agents and services, and the drivers and firmware required by your host hardware.

To keep the platform up to date via the Lifecycle Manager, see [What's the Lifecycle Manager](whats-the-lifecycle-manager.md)?

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

## User interfaces for updates

In addition to the Lifecycle Management method used to update your solution, there are two interfaces that can be used to apply your available updates. These interfaces are PowerShell and Windows Admin Center.

### PowerShell

You can also use PowerShell to manage your solution updates. The PowerShell procedures apply to a single node and multi-node cluster that is running with the Lifecycle Manager installed.

For more information, see [Update your Azure Stack HCI solution via PowerShell](update-via-powershell.md).

> [!IMPORTANT]
> If your PowerShell modules were installed via Install-Module, run the [Update-Module](/powershell/module/powershellget/update-module?view=powershell-7.2#example-1--update-all-modules&preserve-view=true) command to update them.

### Windows Admin Center

You can use Windows Admin Center as another method to install your solution updates. To install updates using Windows Admin Center, see [Install operating system and hardware updates using Windows Admin Center](/azure-stack/hci/manage/update-cluster#install-operating-system-and-hardware-updates-using-windows-admin-center).

Alternatively, you can download and install the latest MSI package from the Microsoft Evaluation Center. For more information, see [Windows Admin Center](/windows-server/manage/windows-admin-center/overview).  

> [!NOTE]
> Integrated solutions require the OEM to provide an extension. For more information, see [Windows Admin Extensions](lifecycle-management-placeholder.md)

## Workload updates

Along with updates for your cluster, there are workload updates that can be applied that aren't integrated into the Lifecycle Manager. These workloads include Azure Kubernetes Service (AKS) hybrid, Azure Arc, and Infrastructure Virtual Machines (VMs). The next sections will provide more detail on these workloads and ways to apply updates.

### Azure Kubernetes Service (AKS) hybrid

Azure Kubernetes Service (AKS) hybrid runs via Virtual Machines (VM) on the Azure Stack HCI system. The process is orchestrated by the AKS hybrid tooling, which involves bringing up new VMs and moving workloads over in a rolling fashion. For more information, see [AKS lifecycle and Updates pages](lifecycle-management-placeholder.md).

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

Azure Arc is a bridge that extends the Azure platform to help you build applications and services with the flexibility to run across datacenters, at the edge, and in multicloud environments. For more information about Azure Arc and applying updates to your Azure Arc agent, see the following:

- [Azure Arc resource bridge (preview) overview](/azure/azure-arc/resource-bridge/overview).

- [Upgrade the Agent](/azure/azure-arc/servers/manage-agent#upgrade-the-agent).

### Infrastructure Virtual Machines (VMs)

Software-Defined Networking relies on several Virtual Machines. To update these virtual machines, see [Update SDN infrastructure for Azure Stack HCI](../manage/update-sdn.md) for instructions.

Other Microsoft services that rely on Azure Stack HCI VMs may have their own instructions for updates, such as individually connecting to VMs to upgrade them, or swapping a VM's virtual hard disk (VHD).

### Customer apps and workloads

The Azure Stack HCI platform doesn't update customer workloads given the update processes depend on the type of workload. It is recommended to Arc-enable your VMs and use the upgrade the agent process. For more information, see the following:

- [Azure Arc-enabled servers](lifecycle-management-placeholder.md).

- [Upgrade the agent](/azure/azure-arc/servers/manage-agent#upgrade-the-agent).

- [Use Update Management in Azure Automation to manage operating system updates for Azure Arc-enabled servers](/azure/cloud-adoption-framework/manage/hybrid/server/best-practices/arc-update-management).

## Next steps

[What's the Lifecycle Manager](whats-the-lifecycle-manager.md)?
