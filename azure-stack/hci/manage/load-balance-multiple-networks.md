---
title: Set up load balancing on multiple logical networks for Azure Stack HCI
description: Learn how to Load balance on multiple Software Defined Networking (SDN) logical networks for Azure Stack HCI.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.date: 04/04/2024
---

# Load balance SDN on multiple networks for Azure Stack HCI

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article provides guidance on how to set up load balancing across multiple Software Defined Networking (SDN) logical networks for Azure Stack HCI. By using multiple logical networks for load balancing gives you more control over isolating workloads from each other.

For information on how to create and manage logical networks, see [Manage tenant logical networks](./tenant-logical-networks.md).

## Prerequisites

Before you begin, make sure that the following prerequisites are completed:

- All software load balancing (SLB) multiplexer (MUX) virtual machines (VMs) have an extra interface dedicated to extra logical networks.

- On the physical network side, confirm connectivity between the logical networks and the Azure Stack HCI management network by ensuring the management network is trunked at your Top-of-Rack (TOR) switch. This step ensures VM access from the Hyper-V host.

## Set up load balancing across multiple logical networks

Follow these steps to set up multiple logical networks and add additional interfaces for SDN load balancing using PowerShell:

1. To establish communication between the SLB MUX and the correct logical network, create a new network adapter connected to the MUX. This adapter should have connectivity to the new logical network.

1. Define the VM and switch details:

    ```powershell
    $vm = Get-VM -Name'MUX_name'
    $switch = Get-VmSwitch -Name 'switch_name'
    ```

1. Stop the VM and add the adapter:

    ```powershell
    $vm | Stop-Vm
    $vnic = $vm | Add-VMNetworkAdapter -SwitchName $switch.Name -Name 'switch_name' -PassThru
    ```

1. Start the VM, which gives a dynamic MAC address:

    ```powershell
    $vm | Start-VM
    $FormattedMac = [regex]::matches($vnic.MacAddress.ToUpper().Replace(":","").Replace("-",""),'..').groups.value -join "-"
    ```

1. Stop the VM and configure the MAC address:

    ```powershell
    $vm | Stop-Vm
    $vnic | Set-VmNetworkAdapter -StaticMacAddress $FormattedMac
    ```

1. Set the port profile and VLAN information:

    ```powershell
    Set-SdnVMNetworkAdapterPortProfile -VMName $vm.Name -MacAddress $vnic.MacAddress -ProfileData2 -ProfileId $([Guid]::Empty)

    $vnic | Set-VMNetworkAdapterVLAN -Access -VLANID ####
    $vnic
    ```

1. Start the VM:

    ```powershell
    $vm | Start-Vm
    ```

1. Within the MUX, set the IP address. MAC addresses are formatted with dashes within the guest OS, so you need to find the correct MAC address that aligns with the output of step#4:

    ```powershell
    Get-NetAdapter

    $netAdapter = Get-NetAdapter | Where-Object {$_.MacAddress -eq 'MAC_address'}

    New-NetIPAddress -AddressFamilyIPv4 -InterfaceIndex $netAdapter.ifIndex -IPAddress 'IP_address' -PrefixLength 'prefix'
    ```

## Troubleshoot

If you encounter any issues during setup, collect logs for troubleshooting purposes. For more information, see [Collect logs for Software Defined Networking on Azure Stack HCI](./sdn-log-collection.md).

## Next steps

- Learn more about [SDN on YouTube](https://www.youtube.com/@microsoftsdn).
- [Plan an SDN infrastructure](../concepts/plan-software-defined-networking-infrastructure-23h2.md).