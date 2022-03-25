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

## Troubleshoot and debug

See the support topics for any errors and their remedial steps. If the error condition is not mentioned or you need additional help, contact Microsoft support.

Collect diagnostics information before contacting Microsoft support as they may ask for it.

Collect logs from the cluster using the `Get-ArcHCILogs` cmdlet. To run this cmdlet, you need the CloudServiceIP and the path containing HCI login configuration.

- The CloudServiceIP is the IP address of the cloud service agent that is running in the Arc Resource Bridge. This was provided at the time of provisioning Arc Resource Bridge.
- The login configuration file is located under the following path:

    $csv_path\workingDir\kvatoken.tok.

    Make sure that you provide the absolute file path name.

- Optionally, you may provide parameter `-logDir` to provide path to the directory where generated logs will be saved. If not provided, the location defaults to the current working directory.

## Limitations and known issues

- Resource name must be unique for an Azure Stack HCI cluster and must contain only lower case alphabets, numbers, and hyphens.
- Arc Resource Bridge provisioning through command line must be performed on a local HCI server PowerShell. It can't be done in a remote PowerShell window from a machine that isn't a host of the Azure Stack HCI cluster. To connect on each node of the Azure Stack HCI cluster, use Remote Desktop Protocol (RDP) connected with a domain user admin of the cluster.
- Azure Kubernetes and Arc-enabled Azure Stack HCI for VMs on the same Azure Stack HCI cluster must be enabled in the following deployment order:

    1. Deploy AKS management cluster
    1. Deploy Arc Resource Bridge for Arc-enabled VMs
      
    > [!NOTE]
    > If Arc Resource Bridge is already deployed, you should not deploy the AKS management cluster unless the Arc Resource Bridge is removed.

    While deploying Arc Resource bridge when AKS management cluster is available on the cluster, you don't need to perform the following steps:
    **new-MocNetworkSetting**, **set-MocConfig**, and **install-Moc**.

- You must uninstall these in the following order:
    
    1. Uninstall Arc Resource Bridge
    1. Uninstall the AKS management cluster
      
    > [!NOTE]
    > Uninstalling the AKS management cluster can impair Arc VM management capabilities. You can deploy a new Arc Resource Bridge again after cleanup, but it will not remember the VM entities that were created earlier.

- VMs provisioned from Windows Admin Center, PowerShell, or other Hyper-V management tools are not visible in the Azure portal for management.
- You must update Arc VMs on Azure Stack HCI only from the Azure management plane. Any modifications to these VMs from other management tools are not updated in the Azure portal.
- Arc VMs must be created in the same Azure subscription as the Custom location.
- An IT administrator can't view or manage VMs from cluster resource page in the Azure portal, if they are created in a subscription where the IT administrator does not have at least read-only access role.
- If the Arc for servers agents are installed on VMs provisioned through the Azure portal, there will be two projections of the VMs on the Azure portal.
- Arc VM management is currently not available for stretched cluster configurations on Azure Stack HCI.

## Next steps

[VM provisioning through Azure portal on Azure Stack HCI (preview)](azure-arc-enabled-virtual-machines.md)
[Azure Arc-enabled Azure Stack HCI FAQs](faqs-arc-enabled-vms.md)
