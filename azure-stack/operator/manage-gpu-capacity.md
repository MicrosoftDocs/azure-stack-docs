---
title: Manage GPU capacity in Azure Stack Hub
description: Learn how to add GPUs to an existing Azure Stack Hub system. 
author: sethmanheim
ms.author: sethm
ms.topic: how-to
ms.date: 05/10/2021
ms.custom: template-how-to
---

# Manage GPU capacity

Azure Stack Hub supports adding graphics processing units (GPUs) to an existing Azure Stack Hub system. You must consult with your hardware partner to verify that your system was validated and can support GPUs.

In Azure Stack Hub, the physical server is also referred to as a *scale unit node*. All scale unit nodes that are members of a single scale unit must have the same type and number of GPUs.

> [!NOTE]
> Before you continue, consult your hardware manufacturer's documentation to see if your manufacturer supports GPUs with your system, and how you can order. Your OEM hardware vendor support contract might require that the vendor performs the installation.

## Overview

The following flow shows the general process to add memory to each scale unit node:

:::image type="content" source="media/manage-gpu-capacity/add-memory-process.png" alt-text="Add GPU capacity flow":::

## Upgrade GPUs or add to an existing node

The following section provides a high-level overview of the process to add a GPU.

> [!WARNING]
> Do not follow these steps without referring to your OEM-provided documentation.

1. The entire scale unit must be shut down, as a rolling GPU upgrade isn't supported. Stop Azure Stack Hub using the steps documented in the [Start and stop Azure Stack Hub](azure-stack-start-and-stop.md) article.
2. Add or upgrade the memory on each physical computer using your hardware manufacturer's documentation.
3. Start Azure Stack Hub using the steps in [Start and stop Azure Stack Hub](azure-stack-start-and-stop.md).

## Next steps

- [Manage storage accounts in Azure Stack Hub](azure-stack-manage-storage-accounts.md).
- [Monitor and manage the storage capacity of your Azure Stack Hub deployment](azure-stack-manage-storage-shares.md).
