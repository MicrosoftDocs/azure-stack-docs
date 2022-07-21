---
title: Nested virtualization in Azure Stack HCI
description: Run Azure Stack HCI on virtual machines for evaluation and testing.
author: jasongerend
ms.author: jgerend
ms.topic: conceptual
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 10/19/2021
---

# Nested virtualization in Azure Stack HCI

> Applies to: Azure Stack HCI, versions 21H2 and 20H2

Nested virtualization is a feature that lets you run Hyper-V inside a Hyper-V virtual machine (VM). This allows you to maximize your hardware investments and gain flexibility in evaluation and testing scenarios.

   > [!IMPORTANT]
   > Because Azure Stack HCI is intended as a virtualization host where you run all of your workloads in VMs, nested virtualization is not supported in production environments. For production use, Azure Stack HCI should be deployed on validated physical hardware.

Some scenarios in which nested virtualization can be useful are:

- Running applications or emulators in a nested VM
- Testing software releases on VMs
- Reducing deployment times for training environments

## Enable nested virtualization on a VM

To enable nested virtualization on a VM using Windows Admin Center:

1. Connect to your cluster, and then in the **Tools** pane, select **Virtual machines**.
2. Under **Inventory**, select the VM on which you want to enable nested virtualization.
3. Select **Settings**, then **Processors**, and check the box for **Enable nested virtualization**.

   :::image type="content" source="media/nested-virtualization/enable-nested-virtualization.png" alt-text="Check the box to enable nested virtualization on a VM" lightbox="media/nested-virtualization/enable-nested-virtualization.png":::

4. Select **Save processor settings**.

To configure nested virtualization on a VM using PowerShell, see [Run Hyper-V in a Virtual Machine with Nested Virtualization](/virtualization/hyper-v-on-windows/user-guide/nested-virtualization).

## Nested virtualization processor support

Azure Stack HCI, version 21H2 adds support for nested virtualization on AMD processors. Now you can run nested virtualization on first generation EPYC processors or newer generations (Naples, Rome, Milan).
 
Prerequisites:

- Azure Stack HCI, version 21H2
- VM configuration version 10.0 or greater
- An AMD EPYC processor with SVM enabled

## Next steps

For more information, see also:

- [Deploy cluster virtually with Azure Stack HCI sandbox guide](https://github.com/microsoft/AzStackHCISandbox/blob/main/README.md)
- [Tutorial: Create a private forest environment for Azure Stack HCI](../deploy/tutorial-private-forest.md)
- [Evaluate Azure Stack HCI 20H2 using Nested Virtualization](https://github.com/Azure/AzureStackHCI-EvalGuide/blob/main/archive/README.md)
- [Create nested Azure Stack HCI 20H2 cluster with Windows Admin Center](https://github.com/Azure/AzureStackHCI-EvalGuide/blob/main/archive/steps/4_AzSHCICluster.md)
