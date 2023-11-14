---
title:  Lifecycle Management for Azure Stack HCI, version 23H2 solution updates (preview).
description: This article describes how you can keep various pieces of your Azure Stack HCI, version 23H2 cluster up-to-date.
author: ronmiab
ms.author: robess
ms.topic: conceptual
ms.reviewer: thoroet
ms.lastreviewed: 06/14/2023
ms.date: 10/06/2023
---

# Lifecycle Manager for Azure Stack HCI solution updates (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-supplemental-package.md)]

This article describes how to keep various pieces of your Azure Stack HCI solution up to date. This article is applicable to software release 2310 for Azure Stack HCI,version 23H2.

[!INCLUDE [important](../../includes/hci-preview.md)]

## About update the solution

The Lifecycle Manager provides a flexible foundation to integrate and manage more of the solution content in one place. In this release, the Lifecycle Manager allows management of the OS, core agent and services, and the solution extension.

The next sections provide an overview of components, along with methods and links for updating your solution.  

## Lifecycle Manager for platform updates

Platform updates managed by the Lifecycle Manager contain new versions of the Azure Stack HCI operating system (OS), the Lifecycle Manager core agents and services, and the solution extension (depending on your cluster's hardware). Microsoft bundles these components into an update release and validates the combination of versions to ensure interoperability.

- **Operating System:** These updates help you stay productive and protected. They provide users and IT administrators with the security fixes they need and protect devices so that unpatched vulnerabilities can't be exploited.

- **Lifecycle Manager agents and services:** The Lifecycle Manager updates its own agents to ensure it has the recent fixes corresponding to the update. To achieve a successful update of its agents, the Lifecycle Manager:

  - Prepares and updates the servicing stack
  - Installs new agents and services
  - Updates the host OS. Cluster-Aware Updating is used to orchestrate reboots.

- **Solution extension:** Hardware vendors might choose to integrate with the Lifecycle Manager to enhance the update management experience for their customers.

  - If a hardware vendor has integrated with our update validation and release platform, the solution extension content includes the drivers and firmware, and the Lifecycle Manager orchestrates the necessary system reboots within the same maintenance window. You can spend less time searching for updates and experience fewer maintenance windows.

The Lifecycle Manager is the recommended way to update your Azure Stack HCI cluster. Here's a high-level process for platform updates with Lifecycle Manager:

- **Plan for the update**.
  - Discover the update, read the release notes, and determine a good time to update. For example, a time when production workloads aren't in use, or nonpeak hours.
  - Take backups of your deployment.
  - Download the update.
  - If your Solution Builder needs more content, acquire what's needed.

- **Review any precheck warnings or failures and remediate, as necessary**.
  - Execute the update.

- **Monitor the update as it proceeds**.
  - Review the update and system health after completion.
  - Confirm that your storage and workloads are healthy.

## User interfaces for updates

In addition to the Lifecycle Management method used to update your solution, there are two interfaces that can be used to apply your available updates. Here are the interfaces:

- PowerShell (Command line)
- Azure portal

### PowerShell

The PowerShell procedures apply to a single server and multi-server cluster that runs with the Lifecycle Manager installed. For more information, see [Update your Azure Stack HCI solution via PowerShell](update-via-powershell.md).

### Windows Admin Center

To install feature updates using Azure portal, see [Update your cluster via the Azure Update Manager](../manage/install-preview-version.md). 

## Workload updates

In addition to your cluster updates, there are workload updates that aren't integrated into the Lifecycle Manager that can be applied to your cluster. These workload updates include Azure Kubernetes Service (AKS) hybrid, Azure Arc Virtual Machines (VMs), and Infrastructure Virtual Machines (VMs).

The next sections provide information on these workloads and ways to apply updates.

### Azure Kubernetes Service (AKS) hybrid

Azure Kubernetes Service (AKS) hybrid runs via Virtual Machines (VM) on the Azure Stack HCI system. AKS hybrid tooling orchestrates the workload updates process, which involves bringing up new VMs and moving workloads over in a rolling fashion.

AKS hybrid has two types of updates that can be initiated through PowerShell or Windows Admin Center.

- Host updates

- Workload cluster updates

To update AKS hybrid using Windows Admin Center, see:

- [Upgrade the Azure Kubernetes Service host in AKS hybrid using Windows Admin Center](/azure/aks/hybrid/update-akshci-host-windows-admin-center).  

- [Upgrade the Kubernetes version of Azure Kubernetes Service (AKS) workload clusters with Windows Admin Center](/azure/aks/hybrid/upgrade-kubernetes).

To update AKS hybrid using PowerShell, see:

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

The Azure Stack HCI platform doesn't update customer workloads given the update processes depend on the type of workload. We recommend that you Arc-enable your VMs and keep the Azure Arc agent up to date. For more information, see:

- [Azure Arc-enabled servers](/azure/azure-arc/servers/overview).

- [Upgrade the agent](/azure/azure-arc/servers/manage-agent#upgrade-the-agent).

- [Use Update Management in Azure Automation to manage operating system updates for Azure Arc-enabled servers](/azure/cloud-adoption-framework/manage/hybrid/server/best-practices/arc-update-management).

## Next steps

Learn more about the [Phases of an Azure Stack HCI solution update](update-phases.md).
