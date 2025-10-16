---
title: Enable nested virtualization in Azure Local
description: Learn how to enable nested virtualization in Azure Local.
ms.topic: article
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.date: 10/16/2025
---

# Enable nested virtualization in Azure Local

This article provides an overview of nested virtualization in Azure Local and how to enable it.

Nested virtualization lets you run Hyper-V inside a Hyper-V virtual machine (VM). This allows you to maximize your hardware investments and gain flexibility in evaluation and testing scenarios.

> [!IMPORTANT]
> Azure Local is intended as a virtualization host for running workloads in VMs. Nested virtualization isn't supported in production environments. For production use, Azure Local should be deployed on validated physical hardware.

## Prerequisites

- An Azure Local system with version 2411.3 or later.
- VM configuration version 10.0 or greater.
- An AMD EPYC processor with SVM enabled.

## Scenarios

Some scenarios in which nested virtualization can be useful are:

- Running applications or emulators in a nested VM.
- Testing software releases on VMs.
- Reducing deployment times for training environments.
- Creating VMs with nested virtualization enabled.

## Enable nested virtualization on a VM

To enable nested virtualization on a VM using Windows Admin Center:

1. Connect to your cluster, and then in the **Tools** pane, select **Virtual machines**.

1. Under **Inventory**, select the VM on which you want to enable nested virtualization.

1. Select **Settings**, then **Processors**, and check the box for **Enable nested virtualization**.

    :::image type="content" source="media/enable-nested-virtualization/enable-nested-virtualization.png" alt-text="Screenshot showing the Settings pane with the option to enable nested virtualization." lightbox="media/enable-nested-virtualization/enable-nested-virtualization.png":::

1. Select **Save processor settings**.

To configure nested virtualization on a VM using PowerShell, see [Run Hyper-V in a Virtual Machine with Nested Virtualization](/windows-server/virtualization/hyper-v/nested-virtualization).

## Nested virtualization processor support

<!--Need confirmation on the Azure Local version and processor models-->

Azure Local supports nested virtualization on AMD EPYC processors, including first-generation (Naples) and newer generations (Rome, Milan).

## Next steps

- [Manage VMs](./vm.md)