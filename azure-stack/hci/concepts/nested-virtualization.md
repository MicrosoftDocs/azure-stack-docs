---
title: Nested virtualization in Azure Stack HCI
description: Run Azure Stack HCI on virtual machines for evaluation and testing.
author: khdownie
ms.author: v-kedow
ms.topic: conceptual
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 06/28/2021
---

# Nested virtualization in Azure Stack HCI

> Applies to: Azure Stack HCI, version 21H2 Preview; Azure Stack HCI, version 20H2

Nested virtualization is a feature that lets you run Hyper-V inside a Hyper-V virtual machine (VM). This allows you to maximize your hardware investments and gain flexibility in evaluation and testing scenarios.

   > [!IMPORTANT]
   > Because Azure Stack HCI is intended as a virtualization host where you run all of your workloads in VMs, nested virtualization is not supported in production environments. For production use, Azure Stack HCI should be deployed on validated physical hardware.

Some scenarios in which nested virtualization can be useful are:

- Running applications or emulators in a nested VM
- Testing software releases on VMs
- Reducing deployment times for training environments

To configure nested virtualization, see [Run Hyper-V in a Virtual Machine with Nested Virtualization](/virtualization/hyper-v-on-windows/user-guide/nested-virtualization).

## Nested virtualization processor support

Azure Stack HCI, version 21H2 Preview adds support for nested virtualization on AMD processors. Now you can run nested virtualization on first generation EPYC processors or newer generations (Naples, Rome, Milan).
 
Prerequisites:

- VM configuration version 10.0 or greater
- An AMD EPYC processor with SVM enabled
- [Join the preview channel](../manage/preview-channel.md)

## Next steps

For more information, see also:

- [Evaluate Azure Stack HCI 20H2 using Nested Virtualization](https://github.com/Azure/AzureStackHCI-EvalGuide/blob/main/nested/README.md)
- [Create nested Azure Stack HCI 20H2 cluster with Windows Admin Center](https://github.com/Azure/AzureStackHCI-EvalGuide/blob/main/nested/steps/4_AzSHCICluster.md)
