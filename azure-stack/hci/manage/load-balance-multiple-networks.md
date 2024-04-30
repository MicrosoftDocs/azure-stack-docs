---
title: Load balance multiple logical networks for Azure Stack HCI
description: Learn how to load balance multiple Software Defined Networking (SDN) logical networks for Azure Stack HCI.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.date: 04/30/2024
---

# Load balance multiple SDN logical networks for Azure Stack HCI

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article provides guidance on how to load balance multiple Software Defined Networking (SDN) logical networks for Azure Stack HCI. By using multiple logical networks for load balancing, you have more control over isolating workloads from each other.

For information about how to create and manage logical networks, see [Manage tenant logical networks](./tenant-logical-networks.md).

## Prerequisites

Before you begin, make sure that the following prerequisites are completed:

- Make sure to install the SDN diagnostics PowerShell module on the client computer and SDN resources. See [Install the SDN diagnostics PowerShell module on the client computer](./sdn-log-collection.md#install-the-sdn-diagnostics-powershell-module-on-the-client-computer) and [Install the SDN diagnostics PowerShell module on the SDN resources](./sdn-log-collection.md#install-the-sdn-diagnostics-powershell-module-on-the-sdn-resources).

- Make sure that all software load balancing (SLB) multiplexer (MUX) virtual machines (VMs) have an extra interface for additional logical networks.

- Make sure that there's connectivity between the logical networks and the Azure Stack HCI management network on the physical network side. Ensure the management network is trunked at your Top-of-Rack (TOR) switch to maintain access to the VM from the Hyper-V host.

## Set up load balancing across multiple logical networks

Follow these steps to set up multiple SDN logical networks and add extra interfaces for load balancing using PowerShell:

1. Create a new network adapter connected to the MUX to establish communication between the SLB MUX and the correct logical network. This adapter should have connectivity to the new logical network.

1. Run the following command to define the VM and switch details:

    ```powershell
    $vm = Get-VM -Name'MUX_name'
    $switch = Get-VmSwitch -Name 'switch_name'
    ```

1. Run the following command to stop the VM and add the adapter:

    ```powershell
    $vm | Stop-Vm
    $vnic = $vm | Add-VMNetworkAdapter -SwitchName $switch.Name -Name 'switch_name' -PassThru
    ```

1. Run the following command to start the VM, which gives a dynamic MAC address:

    ```powershell
    $vm | Start-VM
    $FormattedMac = [regex]::matches($vnic.MacAddress.ToUpper().Replace(":","").Replace("-",""),'..').groups.value -join "-"
    ```

1. Run the following command to stop the VM and configure the MAC address:

    ```powershell
    $vm | Stop-Vm
    $vnic | Set-VmNetworkAdapter -StaticMacAddress $FormattedMac
    ```

1. Run the following command to set the port profile and VLAN information:

    ```powershell
    Set-SdnVMNetworkAdapterPortProfile -VMName $vm.Name -MacAddress $vnic.MacAddress -ProfileData2 -ProfileId $([Guid]::Empty)

    $vnic | Set-VMNetworkAdapterVLAN -Access -VLANID ####
    $vnic
    ```

1. Run the following command to start the VM:

    ```powershell
    $vm | Start-Vm
    ```

1. Run the following command to set the IP address within the MUX. MAC addresses are formatted with dashes within the guest OS. Find the correct MAC address that aligns with the output of step #4:

    ```powershell
    Get-NetAdapter

    $netAdapter = Get-NetAdapter | Where-Object {$_.MacAddress -eq 'MAC_address'}

    New-NetIPAddress -AddressFamilyIPv4 -InterfaceIndex $netAdapter.ifIndex -IPAddress 'IP_address' -PrefixLength 'prefix'
    ```

## Troubleshoot

If you encounter any issues during setup, collect logs for troubleshooting purposes. For more information, see [Collect logs for Software Defined Networking on Azure Stack HCI](./sdn-log-collection.md).

## Next steps

- [Plan an SDN infrastructure](../concepts/plan-software-defined-networking-infrastructure-23h2.md).