---
title: Enable, assign default network policies on Azure Stack HCI VMs
description: Learn how to enable and assign default network policies on VMs running on your Azure Stack HCI via the Windows Admin Center.
ms.author: alkohli
ms.reviewer: anpaul
ms.topic: article
author: alkohli
ms.date: 10/20/2022
---

# Use default network access policies on virtual machines on your Azure Stack HCI

> Applies to: Azure Stack HCI, version 22H2; Azure Stack HCI, version 22H1

Default network policies can be used to protect internal assets on your Azure Stack HCI from external unauthorized attacks. These policies block all inbound access to virtual machines on your Azure Stack HCI (except the specified management ports you want enabled) while allowing all outbound access.

This article describes how to enable these default network policies and assign these to VMs running on your Azure Stack HCI.

> [!NOTE]
> In this release, you can enable and assign default network policies through the Windows Admin Center.

## Enable default network access policies

To enable default network access policies, you need to install Network Controller (NC). Network Controller enforces the default network policies and is deployed in the virtual machines. For more information, see how to [Install Network Controller](../deploy/sdn-wizard.md).

## Assign default network policies to a VM

You can attach default policies to a VM in two ways:

- When creating a VM. You'll need to attach the VM to a logical network (traditional vLAN network) or a SDN virtual network.
- After the VM is created.

### Create and attach networks

Depending on the type of network you want to attach your VM to, steps may be different.

- **Attach VMs to a physical network**: Create one or more logical networks to represent those physical networks. A logical network is just a representation of the physical network(s) available to your Azure Stack HCI. For more information, see how to [Create a logical network](./tenant-logical-networks.md).

- **Attach VMs to a SDN virtual network**: Create a virtual network before you create the VM. For more information, see how to [Create a virtual network](./tenant-virtual-networks.md).

> [!NOTE]
> If you were using Azure Stack HCI 21H2 and were attaching your VMs to physical networks there, you will see a change in experience. In 21H2, you might have been attaching your VM directly to a VLAN through Windows Admin Center.

:::image type="content" source="(./media/manage-default-network-access-policies-virtual-machines/attach-vm-direct-vlan-1.png)" alt-text="Screenshot showing how to attach VM directly to VLAN." lightbox="(./media/manage-default-network-access-policies-virtual-machines/attach-vm-direct-vlan-1.png)":::

*Figure: Attach VM directly to a VLAN with Azure Stack HCI 21H2 release*

With 22H2, if you have Network Controller installed, that option is no longer available. Instead, you must create a logical network representing the VLAN, create a logical network subnet with the VLAN, and then attach the VM to the logical network subnet.

Example: Suppose you want to connect your VM to VLAN 5. To do this in 22H2 with Network Controller installed, you should do the following:

1. Create a logical network with any name. Ensure that Network Virtualization is disabled.

1. Add a logical subnet with any name. Provide the VLAN ID (5) when creating the subnet.

1. Apply the changes.

1. When creating a VM, attach it to the logical network and logical network subnet created above.

Instructions to create a logical network are provided [here](https://docs.microsoft.com/en-us/azure-stack/hci/manage/tenant-logical-networks).

:::image type="content" source="(./media/manage-default-network-access-policies-virtual-machines/attach-vm-logical-network-1.png)" alt-text="Screenshot showing how to attach VM directly to VLAN." lightbox="(./media/manage-default-network-access-policies-virtual-machines/attach-vm-logical-network-1.png)":::

*Figure: Attach VM to a Logical Network (representing the VLAN) with
Azure Stack HCI 22H2 release*

### Apply default network policies

When you create a VM through Windows Admin Center, you'll see a *Security Level* setting. 

:::image type="content" source="./media/manage-default-network-access-policies-virtual-machines/security-level-2.png" alt-text="Screenshot showing the three security level options for VMs in Windows Admin Center." lightbox="./media/manage-default-network-access-policies/security-level-1.png":::

You have three options:

- *No protection* - Choose this option if you don't want to enforce any network access policies to your VM. This is not recommended.

- *Open some ports* - Choose this option to go with default policies. The default policies block all inbound access and allow all outbound access. You can optionally enable inbound access to one or more well defined ports, for example, HTTP, HTTPS, SSH or RDP as per your requirements.

    :::image type="content" source="./media/manage-default-network-access-policies-virtual-machines/ports-to-open-1.png" alt-text="Screenshot showing the ports that can be opened on VMs in Windows Admin Center." lightbox="./media/manage-default-network-access-policies/security-level-1.png":::

- *Use existing NSG* - Choose this option to apply custom policies. You'll specify a Network Security Group (NSG) that you have already created.


## VMs created outside of Windows Admin Center

If you are using alternate mechanisms (for example, Hyper-V UI or New-VM PS cmdlet) to create VMs on your Azure Stack HCI, and you have enabled default network access policies, you will see two issues:

1. The VMs might not have network connectivity: This will happen since the VM is being managed by a Hyper-V switch extension called Virtual Filtering Platform (VFP) and by default, the Hyper-V port connected to the VM is in blocked state. To unblock the port, you must execute the below commands from an elevated Powershell prompt on the Hyper-V host where the VM is located:

    a.  *Install-Script -Name SetVMPortProfile*

        i.  Accept all prompts to install from Powershell Gallery

    b.  *SetVMPortProfile.ps1 -VMName \<Name of VM whose port has to be
        unblocked\> -VMNetworkAdapterName \<Name of the adapter in the
        VM\> -ProfileId "00000000-0000-0000-0000-000000000000"
        -ProfileData 2*

1. Since this VM was created outside Windows Admin Center, the default policies for the VM will not get applied and the Network Settings for the VM will not display correctly. To rectify this issue, you must do the following:

    a.  In Windows Admin Center, create a logical network. Create a
        subnet under the logical network and provide the VLAN ID that
        the VM is connected to.

    b.  Under **Tools**, scroll down to the **Networking** area, and
        select **Virtual machines**

    c.  Select the **Inventory** tab, select a VM, and then
        select **Settings**

    d.  On the **Settings** page, select **Networks**

    e.  For Isolation Mode, select Logical Network.

    f.  Select the Logical Network and Logical Subnet that you created
        above

    g.  For Security Level, you have two options:

        i.  No Protection: Choose this if you do not want any network
            access policies for your VMs

        ii. Use existing NSG: Choose this if you want to apply network
            access policies for your VMs. You can either create a new
            NSG and attach it to the VM or you can attach any existing
            NSG to the VM.


:::image type="content" source="(./media/manage-default-network-access-policies-virtual-machines/enable-policies-other-vms-1.png)" alt-text="Screenshot showing how to enable default network to VLAN." lightbox="(./media/manage-default-network-access-policies-virtual-machines/enable-policies-other-vms-1.png)":::

## Upgrade from 21H2

If you have upgraded from 21H2 version and do not have Network Controller installed on the 21H2 version, ignore this section.

If you had Network Controller installed on 21H2 and also had workload VMs on your HCI cluster, those VMs would be in one of the 4 isolation modes in VM Network Settings:

1. Default (None): Since this mode no longer exists after you move to 22H2, The Isolation Mode in the VM Network Settings page on WAC will be blank. Note that the VM will still continue to have same level of network connectivity as before upgrade to 22H2. To display the correct Network settings in WAC and apply default policies, you must do the following:

    a.  In Windows Admin Center, create a logical network. Create a subnet under the logical network and provide no VLAN ID or subnet prefix.

    b.  Under **Tools**, scroll down to the **Networking** area, and select **Virtual machines**

    c.  Select the **Inventory** tab, select the VM, and then select **Settings**

    d.  On the **Settings** page, select **Networks**

    e.  For Isolation Mode, select Logical Network.

    f.  Select the Logical Network and Logical Subnet that you created above

    g.  For Security Level, you have two options:

        i.  No Protection: Choose this if you do not want any network access policies for your VMs

        ii. Use existing NSG: Choose this if you want to apply network access policies for your VMs. You can either create a new NSG and attach it to the VM or you can attach any existing NSG to the VM


1. VLAN: Since this mode no longer exists after you move to 22H2, The Isolation Mode in the VM Network Settings page on WAC will be blank. Note that the VM will still continue to have same level of network connectivity as before upgrade to 22H2. To display the correct Network settings in WAC and apply default policies, you must do the following:

    a.  In Windows Admin Center, create a logical network. Create a subnet under the logical network and provide the VLAN ID that the VM is connected to.

    b.  Under **Tools**, scroll down to the **Networking** area, and select **Virtual machines**

    c.  Select the **Inventory** tab, select the VM, and then select **Settings**

    d.  On the **Settings** page, select **Networks**

    e.  For Isolation Mode, select Logical Network.

    f.  Select the Logical Network and Logical Subnet that you created above

    g.  For Security Level, you have two options:

        i.  No Protection: Choose this if you do not want any network access policies for your VMs

        ii. Use existing NSG: Choose this if you want to apply network access policies for your VMs. You can either create a new NSG and attach it to the VM or you can attach any existing NSG to the VM

1. Logical Network: The Network Settings page for the VM remains unchanged w.r.t 21H2.

1. Virtual Network: The Network Settings page for the VM remains unchanged w.r.t 21H2.

## Next steps

Learn more about:

- [Configure network security groups with tags](../concepts/datacenter-firewall-overview.md)