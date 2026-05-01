---
title: Supported Operations for Azure Local Multi-rack Virtual Machines (VMs) Enabled by Azure Arc
description: Learn about the supported virtual machine (VM) operations for Azure Local multi-rack VMs enabled by Azure Arc.
author: sipastak
ms.author: sipastak
ms.topic: concept-article
ms.service: azure-local
ms.date: 04/15/2026
ms.subservice: multi-rack
---

# Supported operations for Azure Local multi-rack VMs enabled by Azure Arc

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article discusses the most common operations for Azure Local multi-rack virtual machines (VMs) enabled by Azure Arc. The article identifies the operations that are supported on Azure Local multi-rack VMs, along with the operations that you need to avoid to prevent complications.

## Overview

Azure Local multi-rack deployments can host Azure Local VMs enabled by Azure Arc. These VMs provide a high level of management capabilities in the Azure portal.

Azure Local multi-rack VMs are designed to be managed exclusively through the Azure control plane. You can use the Azure portal or Azure CLI to create and manage your VMs. Local tools such as PowerShell, Hyper-V Manager, or Failover Cluster Manager aren't supported for VM management on multi-rack deployments.

## Supported VM operations

You can use the Azure portal or the Azure CLI to perform supported operations for VMs.

### Azure portal or Azure CLI

Perform the following VM operations via the Azure portal or the Azure CLI:

- Create a VM
- Start a VM
- Restart a VM
- Stop a VM
- Delete a VM
- Add a network interface
- Delete a network interface
- Add a data disk
- Delete a data disk
- Change CPU cores
- Change memory
- Add extensions
- Delete extensions
- Enable guest management
- Connect via Secure Shell (SSH)

### Azure CLI only

Perform the following VM operations only via the Azure CLI:

- Rename the computer name of your Azure Local VM.

    > [!NOTE]
    > This operation can only be performed when the VM is powered off.

- Expand a data disk

## Unsupported VM operations

The following VM operations aren't supported for Azure Local multi-rack VMs. Performing these operations can lead to Azure Local VMs becoming unmanageable from the Azure portal.

> [!IMPORTANT]
> You can't perform these operations by using the Azure portal or the Azure CLI.

- Change the type of disk (static, dynamic, VHD, or VHDX)
- Cloning or copying a VM. This can result in corruption, management errors, or failure to start.

If you need to change the IP address of a network interface, create a new network interface and delete the old one.

## Operations that return errors

The following VM operations aren't available for Azure Local multi-rack VMs. If you attempt these operations, you receive an error indicating the operation isn't supported.

- Pause a VM
- Save the VM state

## Related content

- [Create Azure Local VMs enabled by Azure Arc for multi-rack deployments](multi-rack-create-arc-virtual-machines.md)
- [Manage VM images for multi-rack deployments](multi-rack-virtual-machine-manage-image.md)
