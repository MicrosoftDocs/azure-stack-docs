---
title: Enable nested virtualization in Azure Local
description: Learn how to enable nested virtualization in Azure Local.
ms.topic: article
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.date: 10/17/2025
---

# Enable nested virtualization in Azure Local

This article provides an overview of nested virtualization in Azure Local and how to enable it.

Nested virtualization lets you enable virtualization capabilities inside a Hyper-V virtual machine (VM). This allows you to maximize your hardware investments and gain flexibility in evaluation and testing scenarios. Other use cases include enabling security features, such as [Virtualization based security (VBS)](/windows-hardware/design/device-experiences/oem-vbs).

> [!IMPORTANT]
> Azure Local provides virtualization capabilities to run workloads in VMs. Running Azure Local inside a VM using nested virtualization isn't supported in production environments. For production use, Azure Local must be deployed on validated physical hardware.

## Prerequisites

- An Azure Local system running version 2411.3 or later.
- A VM with configuration version 10.0 or greater.
- An AMD processor with Secure Encrypted Virtualization (SEV) technology enabled.
- An Intel processor with Intel Virtualization Technology (VT-x) enabled.

## Scenarios

Some scenarios in which nested virtualization can be useful are:

- Running applications or emulators in a nested VM.
- Testing software releases on VMs.
- Reducing deployment times for training environments.
- Creating VMs with nested virtualization enabled.

## Enable nested virtualization on a VM

You can enable nested virtualization on a VM using PowerShell or Windows Admin Center.

### [PowerShell](#tab/powershell)

To enable nested virtualization via PowerShell, follow these steps:

1. Create a virtual machine. For required OS and VM configuration versions, see the [prerequisites](#prerequisites).

1. While the virtual machine is in the OFF state, run the following command on the physical Hyper-V host to enable nested virtualization for the virtual machine.

    ```powershell
    Set-VMProcessor -VMName <VMName> -ExposeVirtualizationExtensions $true
    ```

For more information, see [Run Hyper-V in a Virtual Machine with Nested Virtualization](/windows-server/virtualization/hyper-v/nested-virtualization).

### [Window Admin Center](#tab/windows-admin-center)

To enable nested virtualization on a VM using Windows Admin Center, follow these steps:

1. Connect to your cluster, and then in the **Tools** pane, select **Virtual machines**.

1. Under **Inventory**, select the VM on which you want to enable nested virtualization.

1. Select **Settings**, then **Processors**, and check the box for **Enable nested virtualization**.

    :::image type="content" source="media/enable-nested-virtualization/enable-nested-virtualization.png" alt-text="Screenshot showing the Settings pane with the option to enable nested virtualization." lightbox="media/enable-nested-virtualization/enable-nested-virtualization.png":::

1. Select **Save processor settings**.

---

## Next steps

- [Manage VMs](./vm.md)