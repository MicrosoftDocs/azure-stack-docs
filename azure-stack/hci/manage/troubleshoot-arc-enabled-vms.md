---
title: Troubleshoot Arc-enabled virtual machines
description: Learn how to troubleshoot Arc-enabled virtual machines
author: ManikaDhiman
ms.topic: how-to
ms.date: 03/24/2022
ms.author: v-mandhiman
ms.reviewer: JasonGerend
---

# Troubleshoot Arc-enabled virtual machines

> Applies to: Azure Stack HCI, version 21H2

This article provides guidance on how to debug issues that you might encounter when using Arc-enabled virtual machines (VMs). It also describes the limitations and known issues that currently exist.
 
> Applies to: Azure Stack HCI, version 21H2

## Troubleshoot and debug

See the support topics for any errors and their remedial steps. If the error condition is not mentioned or you need additional help, contact Microsoft support.

Collect diagnostics information before contacting Microsoft support as they may ask for it.

Collect logs from the cluster using the `Get-ArcHCILogs` cmdlet. It requires the CloudServiceIP and the path containing HCI login configuration.

- The CloudServiceIP is the IP address of the cloud service agent that is running in the Arc Resource Bridge. This was provided at the time of provisioning Arc Resource Bridge.
- The login configuration file is located under the following path:

  `$csv_path\workingDir\kvatoken.tok.`

    Make sure that you provide the absolute file path name.

- Optionally, you may provide parameter `-logDir` to provide path to the directory where generated logs will be saved. If not provided, the location defaults to the current working directory.

## Limitations and known issues

- Resource names must contain only lower case alphabets, numbers, and hypens. The resource names must be unique for an Azure Stack HCI cluster.
- Arc Resource Bridge provisioning through command line must be performed on a local HCI server PowerShell. It can't be done in a remote PowerShell window from a machine that isn't a host of the Azure Stack HCI cluster. To connect on each node of the Azure Stack HCI cluster, use Remote Desktop Protocol (RDP) connected with a domain user admin of the cluster.
- Azure Kubernetes and Arc-enabled Azure Stack HCI for VMs on the same Azure Stack HCI cluster must be enabled in the following deployment order:

    - AKS management cluster.
    - Arc Resource Bridge for Arc-enabled VMs.
      
      If Arc Resource Bridge is already deployed, you should not deploy the AKS management cluster unless the Arc Resource Bridge is removed.

While deploying Arc Resource bridge when AKS management cluster is available on the cluster, you don't need to perform the following steps:
**new-MocNetworkSetting**, **set-MocConfig** and **install-Moc**.

You must follow the following order to uninstall of these features should also be done in the following order:
      
      - Uninstall Arc Resource Bridge
       uninstall the AKS management cluster
      
Uninstalling the AKS management cluster can impair Arc VM management capabilities. You can deploy a new Arc Resource Bridge again after cleanup, but it will not remember the VM entities that were created earlier.

- VMs provisioned from Windows Admin Center, PowerShell or other HyperV management tools will not be visible in portal for management.
- Updating Arc VMs on Azure Stack HCI must be done from Azure management plane only. Any modifications to these VMs from other management tools will not be updated in Azure portal.
- Arc VMs must be created in the same Azure subscription as the Custom location.
- An IT administrator will not be able to view or manage VMs from cluster resource page in Azure portal, if they are created in a subscription where the IT administrator does not have at least read-only access role.
- If the Arc for servers agents are installed on VMs provisioned through Azure portal, there will be two projections of the VMs on Azure Portal.
- Arc VM Management is currently not available for stretched cluster configurations on Azure Stack HCI.

## Next steps

[VM provisioning through Azure portal on Azure Stack HCI (preview)](azure-arc-enabled-virtual-machines.md)
[Azure Arc-enabled Azure Stack HCI FAQs](faqs-arc-enabled-vms.md)
