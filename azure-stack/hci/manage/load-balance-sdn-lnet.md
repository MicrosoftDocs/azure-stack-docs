---
title: Load balance SDN on multiple networks for Azure Stack HCI
description: Learn how to Load balance SDN on multiple networks for Azure Stack HCI.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.date: 03/25/2024
---

# Load balance SDN on multiple networks for Azure Stack HCI

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

In this article, you will learn how to set up load balancing for SDN on multiple logical networks (LNETs) for Azure Stack HCI. By having multiple LNETs for load balancing, you have more control over isolating your workloads from each other.

For SDN, configuring LNETs is done in Windows Admin Center from the **Logical Network** service tab.

Before you start, make sure you have met the following requirements:

- All software load balancing (SLB) multiplexer (MUX) virtual machines (VMs) will need to have an additional interface for additional LNETs.

- On the physical network side, ensure there is connectivity between the LNETs and the HCI management network by verifying that the management network is trunked at your Top-of-Rack (TOR) switch.

> [!NOTE]
> This is to ensure access to the VM from the Hyper-V host.

Using PowerShell, follow these steps to set up multiple LNETs and add additional interfaces for SDN load balancing:

1. Create a new network adapter attached to the MUX that has connectivity to the new LNET. This is required for any LNET whose resources are used to ensure the MUX can communicate with the correct LNET.

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

1. Start the VM, which gives a dynamic MAC address. We can then hard code the MAC address:

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

1. Within the MUX, set the IP address. MAC addresses are formatted with dashes within the guest OS, so you need to find the correct MAC address that aligns with the applicable output:

    ```powershell
    Get-NetAdapter

    $netAdapter = Get-NetAdapter | Where-Object {$_.MacAddress -eq 'MAC_address'}

    New-NetIPAddress -AddressFamilyIPv4 -InterfaceIndex $netAdapter.ifIndex -IPAddress 'IP_address' -PrefixLength 'prefix'
    ```

> [!NOTE]
> If you encounter any problems during deployment, see [Install the SDN diagnostics PowerShell module on the client computer](sdn-log-collection.md#install-the-sdn-diagnostics-powershell-module-on-the-client-computer).


## Next steps

- Learn more about [Microsoft SDN on YouTube](https://www.youtube.com/@microsoftsdn).
- [Plan an SDN infrastructure](../concepts/plan-software-defined-networking-infrastructure.md).