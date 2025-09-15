---
title: Enable and assign default network access policies on Azure Local, version 23H2 VMs
description: Learn how to enable and assign default network access policies on VMs running on Azure Local, version 23H2 via the Windows Admin Center.
ms.author: alkohli
ms.reviewer: anpaul
ms.topic: how-to
author: alkohli
ms.service: azure-local
zone_pivot_groups: windows-os
ms.date: 05/28/2025
---

# Use default network access policies on virtual machines on Azure Local

:::zone pivot="azure-local"

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

::: zone-end

:::zone pivot="windows-server"

>Applies to: Windows Server 2025

::: zone-end

This article describes how to enable default network access policies and assign them to virtual machines (VMs).

Default network policies can be used to protect virtual machines running from external unauthorized attacks. These policies block all inbound access to virtual machines (except the specified management ports you want enabled) while allowing all outbound access. Use these policies to ensure that your workload VMs have access to only required assets, making it difficult for the threats to spread laterally.

> [!NOTE]
> In this release, you can enable and assign default network policies through the Windows Admin Center.

## Prerequisites

Complete the following prerequisites to use network access policies:

:::zone pivot="azure-local"

- You have Azure Stack HCI operating system, version 23H2 or later installed on your system. For more information, see how to [Install the Azure Stack HCI operating system, version 23H2](../deploy/deployment-install-os.md).

- You have Network Controller installed. Network Controller enforces the default network policies. For more information, see how to [Install Network Controller](../deploy/sdn-wizard-23h2.md).

- You have a logical network or a virtual network to use. For more information, see how to [Create a logical network](./tenant-logical-networks.md) or [Create a virtual network](./tenant-virtual-networks.md).

- You have a VM to apply policies to. For more information, see how to [Manage VMs with Windows Admin Center](vm.md?context=/windows-server/context/windows-server-failover-clustering#create-a-new-vm).

- You have administrator permissions or equivalent to the system nodes and network controller.

::: zone-end

:::zone pivot="windows-server"

- You have Windows Server 2025 or later. For more information, see [Get started with Windows Server](/windows-server/get-started/get-started-with-windows-server).

- You have Network Controller installed. Network Controller enforces the default network policies. For more information, see how to [Install Network Controller](../deploy/sdn-wizard-23h2.md?context=/windows-server/context/windows-server-edge-networking).

- You have a logical network or a virtual network to use. For more information, see how to [Create a logical network](./tenant-logical-networks.md?context=/windows-server/context/windows-server-failover-clustering) or [Create a virtual network](./tenant-virtual-networks.md?context=/windows-server/context/windows-server-failover-clustering).

- You have a VM to apply policies to. For more information, see how to [Manage VMs with Windows Admin Center](vm.md?context=/windows-server/context/windows-server-failover-clustering#create-a-new-vm).

- You have administrator permissions or equivalent to the system nodes and network controller.

::: zone-end

## Assign default network policies to a VM

You can attach default policies to a VM in two ways:

- During VM creation. You need to attach the VM to a logical network (traditional VLAN network) or an SDN virtual network.
- Post VM creation.

### Create and attach networks

Depending on the type of network you want to attach your VM to, steps might be different.

- **Attach VMs to a physical network**: Create one or more logical networks to represent those physical networks. A logical network is just a representation of one or more physical networks available to Azure Local. For more information, see how to [Create a logical network](./tenant-logical-networks.md).

- **Attach VMs to a SDN virtual network**: Create a virtual network before you create the VM. For more information, see how to [Create a virtual network](./tenant-virtual-networks.md).

#### Attach VM to a logical network

After you have created a logical network in Windows Admin Center, you can create a VM in Windows Admin Center and attach it to the logical network. As part of VM creation, select the **Isolation Mode** as **Logical Network**, select the appropriate **Logical Subnet** under the Logical Network, and provide an IP address for the VM.

:::zone pivot="azure-local"

> [!NOTE]
> Unlike in Azure Local, version 22H2, you can no longer connect a VM directly to a VLAN using Windows Admin Center. Instead, you must create a logical network representing the VLAN, create a logical network subnet with the VLAN, and then attach the VM to the logical network subnet.

::: zone-end

:::zone pivot="windows-server"

> [!NOTE]
> You must create a logical network representing the VLAN, create a logical network subnet with the VLAN, and then attach the VM to the logical network subnet.

::: zone-end

Here's an example that explains how you can attach your VM directly to a VLAN when Network Controller is installed. In this example, we demonstrate how to connect your VM to VLAN 5:

1. Create a logical network with any name. Ensure that Network Virtualization is disabled.

1. Add a logical subnet with any name. Provide the VLAN ID (5) when creating the subnet.

1. Apply the changes.

1. When creating a VM, attach it to the logical network and logical network subnet created earlier. For more information, see how to [Create a logical network](./tenant-logical-networks.md).

    :::image type="content" source="./media/manage-default-network-access-policies-virtual-machines-23h2/attach-vm-logical-network-1.png" alt-text="Screenshot showing how to attach VM directly to VLAN." lightbox="./media/manage-default-network-access-policies-virtual-machines-23h2/attach-vm-logical-network-1.png":::

### Apply default network policies

When you create a VM through Windows Admin Center, you see a **Security level** setting.

:::image type="content" source="./media/manage-default-network-access-policies-virtual-machines-23h2/security-level-2.png" alt-text="Screenshot showing the three security level options for VMs in Windows Admin Center." lightbox="./media/manage-default-network-access-policies-virtual-machines-23h2/security-level-2.png":::

You have three options:

- **No protection** - Choose this option if you don't want to enforce any network access policies to your VM. When this option is selected, all ports on your VM are exposed to external networks posing a security risk. This option isn't recommended.

    :::image type="content" source="./media/manage-default-network-access-policies-virtual-machines-23h2/no-protection-1.png" alt-text="Screenshot showing the No protection option selected for VMs in Windows Admin Center." lightbox="./media/manage-default-network-access-policies-virtual-machines-23h2/no-protection-1.png":::

- **Open some ports** - Choose this option to go with default policies. The default policies block all inbound access and allow all outbound access. You can optionally enable inbound access to one or more well defined ports, for example, HTTP, HTTPS, SSH, or RDP as per your requirements.

    :::image type="content" source="./media/manage-default-network-access-policies-virtual-machines-23h2/ports-to-open-1.png" alt-text="Screenshot showing the ports that can be opened on VMs specified during VM creation in Windows Admin Center." lightbox="./media/manage-default-network-access-policies-virtual-machines-23h2/ports-to-open-1.png":::

- **Use existing NSG** - Choose this option to apply custom policies. You specify a Network Security Group (NSG) that you've already created.

    :::image type="content" source="./media/manage-default-network-access-policies-virtual-machines-23h2/use-existing-nsg-1.png" alt-text="Screenshot showing the existing network security group selected during VM creation in Windows Admin Center." lightbox="./media/manage-default-network-access-policies-virtual-machines-23h2/use-existing-nsg-1.png":::

## VMs created outside of Windows Admin Center

You might encounter issues when you create VMs outside of Windows Admin Center and you have enabled default network access policies. For example, you've enabled default network access policies and created VMs using Hyper-V UI or New-VM PowerShell cmdlet.

- The VMs might not have network connectivity. Since the VM is being managed by a Hyper-V switch extension called Virtual Filtering Platform (VFP) and by default, the Hyper-V port connected to the VM is in blocked state.

    To unblock the port, run the following commands from a PowerShell session on a Hyper-V host where the VM is located:

    1. Run PowerShell as an administrator.
    1. Download and install the [SdnDiagnostics](https://www.powershellgallery.com/packages/SdnDiagnostics) module. Run the following command:

        ```azurepowershell
        Install-Module -Name SdnDiagnostics
        ```

        Alternatively, if already installed then use the following command:

        ```azurepowershell
        Update-Module -Name SdnDiagnostics
        ```

        Accept all prompts to install from [PowerShell Gallery](https://www.powershellgallery.com/).

    1. Confirm if VFP port is applied to the VM

        ```azurepowershell
        Get-SdnVMNetworkAdapterPortProfile -VMName <VMName>
        ```

        Ensure that VFP port profile information is returned for the adapter. If not, then proceed with associating a port profile.

    1. Specify the ports to be unblocked on the VM.

        ```azurepowershell
        Set-SdnVMNetworkAdapterPortProfile -VMName <VMName> -MacAddress <MACAddress> -ProfileId ([guid]::Empty) -ProfileData 2
        ```

:::zone pivot="azure-local"

- The VM doesn't have default network policies applied. Since this VM was created outside Windows Admin Center, the default policies for the VM aren't applied, and the **Network Settings** for the VM doesn't display correctly. To rectify this issue, follow these steps:

    In Windows Admin Center, [Create a logical network](./tenant-logical-networks.md?context=/windows-server/context/windows-server-failover-clustering). Create a subnet under the logical network and provide no VLAN ID or subnet prefix. Then, attach a VM to the logical network using the following steps:

    [!INCLUDE [hci-display-correct-default-network-policies-windows](../includes/hci-display-correct-default-network-policies-windows.md)]

    :::image type="content" source="./media/manage-default-network-access-policies-virtual-machines-23h2/enable-policies-other-vms-1.png" alt-text="Screenshot showing how to enable default network to VLAN." lightbox="./media/manage-default-network-access-policies-virtual-machines-23h2/enable-policies-other-vms-1.png":::

::: zone-end

:::zone pivot="windows-server"

- The VM doesn't have default network policies applied. Since this VM was created outside Windows Admin Center, the default policies for the VM aren't applied, and the **Network Settings** for the VM doesn't display correctly. To rectify this issue, follow these steps:

    In Windows Admin Center, [Create a logical network](./tenant-logical-networks.md). Create a subnet under the logical network and provide no VLAN ID or subnet prefix. Then, attach a VM to the logical network using the following steps:

    [!INCLUDE [hci-display-correct-default-network-policies-windows](../includes/hci-display-correct-default-network-policies-windows.md)]

    :::image type="content" source="./media/manage-default-network-access-policies-virtual-machines-23h2/enable-policies-other-vms-1.png" alt-text="Screenshot showing how to enable default network to VLAN." lightbox="./media/manage-default-network-access-policies-virtual-machines-23h2/enable-policies-other-vms-1.png":::

::: zone-end

## Next steps

Learn more about:

:::zone pivot="azure-local"

- [Configure network security groups with tags](../concepts/datacenter-firewall-overview.md)

::: zone-end

:::zone pivot="windows-server"

- [Configure network security groups with tags](../concepts/datacenter-firewall-overview.md?context=/windows-server/context/windows-server-failover-clustering)

::: zone-end
