---
title: Assign a public IP address to a virtual machine
description: Learn how to assign a public IP address to a virtual machine in an SDN environment.
author: alkohli
ms.topic: how-to
ms.date: 08/02/2023
ms.author: alkohli
ms.reviewer: alkohli
---

# Assign a public IP to a virtual machine

> Applies to: Azure Stack HCI, versions 22H2 and 21H2; Windows Server 2022, Windows Server 2019, Windows Server 2016

This article describes how to use Windows Admin Center to assign a Software Defined Networking (SDN) public IP address to a virtual machine (VM) in Azure Stack HCI. By assigning a public IP address to a VM, you enable the VM to communicate with external networks, thereby enhancing its capabilities and extending its connectivity.

## About assigning a public IP address to a VM

Assigning a public IP address to a VM offers the following key benefits:

- **Enhanced accessibility from outside the Azure Stack HCI cluster.** Assigning a public IP address to a VM enables direct inbound and outbound accessibility from the VM network adapter.
- **Eliminate network address translation (NAT).** With a public IP address, the VM can communicate directly with external networks without the need for NAT.
- **Enable Internet Control Message Protocol (ICMP) access.** By assigning a public IP address to a VM, you can enable the use of ICMP.
- **Testing and validation.** Assigning a public IP address to a VM allows you to verify that your SDN deployment is working properly with the routing protocol, such as Border Gateway Protocol (BGP).

Take a few minutes to watch the video about how to assign a public IP address to a VM in Azure Stack HCI.
> [!VIDEO https://www.youtube.com/embed/H7SoxiAibm4]

## Prerequisites

Before you start assigning public IP address to a VM, make sure the following prerequisites are in place:

- An existing Azure Stack HCI system.

- Windows Admin Center [installed on a management computer](/windows-server/manage/windows-admin-center/deploy/install) and [registered with Azure](./register-windows-admin-center.md).

- [Software-Defined Networking (SDN) deployed](../deploy/sdn-wizard.md) in your Azure Stack HCI environment.

- [A public IP address](./load-balancers.md#create-a-public-ip-address-slb) that you can assign to your VM.

## Assign a public IP address to a VM

Follow these steps to assign a public IP address to a VM:

1. In Windows Admin Center, under **Tools**, scroll down and select **Virtual Machines**.
1. The **Inventory** tab on the right lists all VMs available on the current server or the cluster. Select the specific VM to which you want to assign a public IP address and then select **Settings**.
1. Under **Settings**, select **Networks** to manage network adapter settings, including adding, removing, or modifying them.
1. If the VM already has a network adapter and an IP address, you can skip to the next step. Otherwise, follow these steps to add a network adapter and an IP address:
    1. Select **Add network adapter**.
    1. Select the appropriate virtual switch from the dropdown list.
    1. Select the appropriate isolation mode, network, and subnet.
    1. Select **Add IP address** and enter an IP address in the **IP address** field.
1. From the **Public IP address** dropdown list, select your preconfigured public IP address.
1. Select **Save network settings** to apply the new configuration.

    :::image type="content" source="./media/assign-public-ip-address/assign-public-ip-address.png" alt-text="Screenshot of the Networks section of a VM." lightbox="./media/assign-public-ip-address/assign-public-ip-address.png":::

## Verify the public IP address assigned to a VM

After you assign a public IP address to a VM, the IP address doesn't show when you run `Ipconfig` on the VM.

Instead, follow these steps to verify the public IP address configuration:

1. In Windows Admin Center, under **Tools**, scroll down and select **Virtual Machines**.
1. On the **Inventory** tab, select the VM to which you assigned a public IP address, and then select **Settings**.
1. Under **Settings**, select **Networks**.
1. Look for the network adapter to which you assigned the public IP address. The assigned public IP address should now be displayed for that specific network adapter.

## Troubleshoot

If you encounter any issues while assigning the public IP address, check the following:

- Make sure the public IP address is not being used by another device in your network.

- Ensure that the virtual switch you selected during the network adapter setup is correctly configured.

- Verify that you have the necessary permissions to make changes in Azure Stack HCI and Windows Admin Center.

- Check your SDN configuration. If there are issues with your SDN, they may prevent you from assigning a public IP address.

## Next steps

- [Configure network security groups with Windows Admin Center](./use-datacenter-firewall-windows-admin-center.md)
- [Configure network security groups with PowerShell](./use-datacenter-firewall-powershell.md)
- [Configure network security groups with tags in Windows Admin Center](./configure-network-security-groups-with-tags.md)