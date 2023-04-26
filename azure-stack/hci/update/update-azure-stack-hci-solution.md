---
title:  Update the Azure Stack HCI solution (preview).
description: This article describes how you can keep various pieces of your Azure Stack HCI solution up to date.
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.reviewer: aaronfa
ms.lastreviewed: 04/06/2023
ms.date: 04/06/2023
---

# Update the Azure Stack HCI solution (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-supplemental-package.md)]

This article is applicable to version 2303 of the Supplemental Package and later. It describes how to keep various pieces of your Azure Stack HCI solution up to date.

[!INCLUDE [important](../../includes/hci-preview.md)]

## About update the solution

The Lifecycle Manager provides a flexible foundation to integrate and manage more of the solution content in one place.

In this release, the Lifecycle Manager allows management of the OS, core agent and services, and the solution extension. The following section provides an overview of components, along with methods and links for updating your solution.  

## Platform updates management

Platform updates managed by the Lifecycle Manager contain new versions of the Azure Stack HCI operating system (OS), the Lifecycle Manager core agents and services, and the solution extension (depending on your cluster's hardware). Microsoft bundles these components into an update release and validates the combination of versions to ensure interoperability.

- **Operating System:** What can we say here?

- **Lifecycle Manager agents and services:** The Lifecycle Manager updates its own agents to ensure it has the recent fixes corresponding to the update. To achieve a successful update of its agents, the Lifecycle Manager:

  - Prepares and updates the servicing stack
  - Installs new agents and services
  - Updates the host OS. Cluster-Aware Updating is used to orchestrate reboots.

- **Solution extension:** Hardware vendors might choose to integrate with the Lifecycle Manager to enhance the update management experience for their customers.

  - If a hardware vendor has integrated with our update validation and release platform, the solution extension content includes the drivers and firmware, and the Lifecycle Manager orchestrates the necessary system reboots within the same maintenance window. You can spend less time searching for updates and experience fewer maintenance windows.

### Lifecycle management

The Lifecycle Manager is the recommended way to update your Azure Stack HCI cluster. Here's a high-level process for platform updates with Lifecycle Manager:

- Plan for the update.
  - Discover the update, read the release notes, and determine a good time to update. For example, a time when production workloads aren't in use, or nonpeak hours.
  - Take backups of your deployment.
  - Download the update.
  - If your Solution Builder needs more content, acquire what's needed.

- Review any precheck warnings or failures and remediate, as necessary.
  - Execute the update.

- Monitor the update as it proceeds.
  - Review the update and system health after completion.
  - Confirm that your storage and workloads are healthy.

## User interfaces for updates

In addition to the Lifecycle Management method used to update your solution, there are two interfaces that can be used to apply your available updates. The interfaces are:

- PowerShell (Command line)
- Windows Admin Center

### PowerShell

The PowerShell procedures apply to a single server and multi-server cluster that runs with the Lifecycle Manager installed. For more information, see [Update your Azure Stack HCI solution via PowerShell](update-via-powershell.md).

### Windows Admin Center

Currently, the Lifecycle Manager isn't part of Windows Admin Center. To install updates using Windows Admin Center, see [Install feature updates](../manage/install-preview-version.md).

Alternatively, you can download and install the latest MSI package from the Microsoft Evaluation Center. For more information, see [Windows Admin Center](/windows-server/manage/windows-admin-center/overview).  

## Workload updates

Along with your cluster updates, there are workload updates not integrated into the Lifecycle Manager that can be applied.

The workload updates include Azure Kubernetes Service (AKS) hybrid, Azure Arc, and Infrastructure Virtual Machines (VMs). The next sections provide details on these workloads and ways to apply updates.

### Azure Kubernetes Service (AKS) hybrid

Azure Kubernetes Service (AKS) hybrid runs via Virtual Machines (VM) on the Azure Stack HCI system. The process is orchestrated via AKS hybrid tooling, which involves bringing up new VMs and moving workloads over in a rolling fashion. For more information, see [AKS lifecycle and Updates pages](lifecycle-management-placeholder.md).

AKS hybrid has two types of updates that can be initiated through PowerShell or Windows Admin Center.

- Host updates

- Workload cluster updates

To update AKS hybrid via Windows Admin Center, use these instructions:

- [Upgrade the Azure Kubernetes Service host in AKS hybrid using Windows Admin Center](/azure/aks/hybrid/update-akshci-host-windows-admin-center).  

- [Upgrade the Kubernetes version of Azure Kubernetes Service (AKS) workload clusters with Windows Admin Center](/azure/aks/hybrid/upgrade-kubernetes).

To update AKS hybrid using PowerShell, use these instructions:

- [Upgrade the Azure Kubernetes Service host in AKS hybrid using PowerShell](/azure/aks/hybrid/update-akshci-host-powershell).

- [Upgrade Kubernetes version of Azure Kubernetes Service (AKS) workload clusters in AKS hybrid using PowerShell](/azure/aks/hybrid/upgrade).

### Azure Arc

Azure Arc is a bridge that extends the Azure platform to help you build applications and services with the flexibility to run across datacenters, at the edge, and in multicloud environments. For more information about Azure Arc and applying updates to your Azure Arc agent, see:

- [Azure Arc resource bridge (preview) overview](/azure/azure-arc/resource-bridge/overview).

- [Upgrade the Agent](/azure/azure-arc/servers/manage-agent#upgrade-the-agent).

### Infrastructure Virtual Machines (VMs)

Software-Defined Networking relies on several Virtual Machines. To update these virtual machines, see [Update SDN infrastructure for Azure Stack HCI](../manage/update-sdn.md) for instructions.

Other Microsoft services that rely on Azure Stack HCI VMs may have their own instructions for updates. For example, individually connecting to VMs to upgrade them or swapping a VM's virtual hard disk (VHD).

### Customer apps and workloads

The Azure Stack HCI platform doesn't update customer workloads given the update processes depend on the type of workload. It's recommended to Arc-enable your VMs and use the upgrade the agent process. For more information, see:

- [Azure Arc-enabled servers](lifecycle-management-placeholder.md).

- [Upgrade the agent](/azure/azure-arc/servers/manage-agent#upgrade-the-agent).

- [Use Update Management in Azure Automation to manage operating system updates for Azure Arc-enabled servers](/azure/cloud-adoption-framework/manage/hybrid/server/best-practices/arc-update-management).

## Next steps

[What's the Lifecycle Manager](whats-the-lifecycle-manager.md)?
