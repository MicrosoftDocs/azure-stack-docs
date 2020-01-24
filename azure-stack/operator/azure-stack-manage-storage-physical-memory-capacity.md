---
title: Manage physical memory capacity in Azure Stack Hub | Microsoft Docs
description: Learn how to monitor and manage physical memory and capacity in Azure Stack Hub.
author: mattbriggs

ms.service: azure-stack
ms.topic: conceptual
ms.date: 1/22/2020
ms.author: mabrigg
ms.reviewer: thoroet
ms.lastreviewed: 01/14/2019

---

# Manage physical memory capacity in Azure Stack Hub

To increase the total available memory capacity in Azure Stack Hub, you can add more memory. In Azure Stack Hub, your physical server is also referred to as a *scale unit node*. All scale unit nodes that are members of a single scale unit must have the same amount of memory.

> [!note]  
> Before you continue, consult your hardware manufacturer's documentation to see if your manufacturer supports a physical memory upgrade. Your OEM hardware vendor support contract may require that the vendor perform the physical server rack placement and the device firmware update.

The following flow diagram shows the general process to add memory to each scale unit node.

![Process to add memory into each scale unit node](media/azure-stack-manage-storage-physical-capacity/process-to-add-memory-to-scale-unit.png)

## Add memory to an existing node
The following steps provide a high-level overview of the process to add memory.

> [!Warning]
> Don't follow these steps without referring to your OEM-provided documentation.
> 
> [!Warning]
> The entire scale unit must be shut down as a rolling memory upgrade isn't supported.

1. Stop Azure Stack Hub using the steps documented in the [Start and stop Azure Stack Hub](azure-stack-start-and-stop.md) article.
2. Upgrade the memory on each physical computer using your hardware manufacturer's documentation.
3. Start Azure Stack Hub using the steps in the [Start and stop Azure Stack Hub](azure-stack-start-and-stop.md) article.

## Next steps

 - To learn how to manage storage accounts in Azure Stack Hub, see [Manage storage accounts in Azure Stack Hub](azure-stack-manage-storage-accounts.md).
 - To learn how to monitor and manage the storage capacity of your Azure Stack Hub deployment, see [Manage storage capacity for Azure Stack Hub](azure-stack-manage-storage-shares.md).
