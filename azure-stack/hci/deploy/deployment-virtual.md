---
title: Deploy a virtual Azure Stack HCI, version 23H2 system
description: Describes how to perform an Azure Stack HCI, version 23H2 virtualized deployment.
author: alkohli
ms.author: alkohli
ms.reviewer: alkohli
ms.topic: how-to
ms.date: 04/18/2024
---

# Deploy a virtual Azure Stack HCI, version 23H2 system

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes how to deploy a virtualized single server or a multi-node Azure Stack HCI, version 23H2, on a host system running Hyper-V on the Windows Server 2022, Windows 11, or later operating system (OS).  

You need administrator privileges for the Azure Stack HCI virtual deployment and should be familiar with the existing Azure Stack HCI solution. The deployment can take around 2.5 hours to complete.

> [!IMPORTANT]
> A virtual deployment of Azure Stack HCI, version 23H2 is intended for educational and demonstration purposes only. Microsoft Support doesn't support virtual deployments.

## Prerequisites

Here are the hardware, networking, and other prerequisites for the virtual deployment:

### Physical host requirements

The following are the minimum requirements to successfully deploy Azure Stack HCI, version 23H2.

Before you begin, make sure that:

- You have access to a physical host system that is running Hyper-V on Windows Server 2022, Windows 11, or later. This host is used to provision a virtual Azure Stack HCI deployment.

- You have enough capacity. More capacity is required for running actual workloads like virtual machines or containers.

- The physical hardware used for the virtual deployment meets the following requirements:

    | Component | Minimum |
    | ------------- | -------- |
    | Processor| Intel VT-x or AMD-V, with support for nested virtualization. For more information, see [Does My Processor Support Intel&reg; virtualization technology?](https://www.intel.com/content/www/us/en/support/articles/000005486/processors.html).
    | Memory| The physical host must have a minimum of 32 GB RAM for single virtual node deployments. The virtual host VM should have at least 24 GB RAM.<br><br>The physical host must have a minimum of 64 GB RAM for two virtual node deployments. Each virtual host VM should have at least 24 GB RAM.|
    | Host network adapters| A single network adapter.|
    | Storage| 1 TB Solid state drive (SSD). |

### Virtual host requirements

Before you begin, make sure that each virtual host system can dedicate the following resources to provision your virtualized Azure Stack HCI system:

| Component | Requirement |
| ----------| ------- |
| Virtual machine (VM) type | Secure Boot and Trusted Platform Module (TPM) enabled. |
| vCPUs | Four cores. |
| Memory | A minimum of 24 GB. |
| Networking | At least two network adapters connected to internal network. MAC spoofing must be enabled. |
| Boot disk | One disk to install the Azure Stack HCI operating system from ISO. |
| Hard disks for Storage Spaces Direct | Six dynamic expanding disks. Maximum disk size is 1024 GB. |
| Data disk | At least 127 GB. |
| Time synchronization in integration  | Disabled. |

> [!NOTE]
> These are the minimum requirements to successfully deploy Azure Stack HCI, version 23H2.  Increase the capacity like virtual cores and memory when running actual workloads like virtual machines or containers.

## Set up the virtual switch

When deploying Azure Stack HCI in a virtual environment, you can use your existing networks and use IP addresses from that network if they're available. In such a case, you just need to create an external switch and connect all the virtual network adapters to that virtual switch. Virtual hosts will have connectivity to your physical network without any extra configuration.

However, if your physical network where you're planning to deploy the Azure Stack HCI virtual environment is scarce on IPs, you can create an internal virtual switch with NAT enabled, to isolate the virtual hosts from your physical network while keeping outbound connectivity to the internet.

The following lists the steps for the two options:

### Deploy with external virtual switch

On your physical host computer, run the following PowerShell command to create an external virtual switch:

```PowerShell
New-VMSwitch -Name "external_switch_name" -SwitchType External -NetAdapterName "network_adapter_name" -AllowManagementOS $true
```

### Deploy with internal virtual switch and NAT enabled

On your physical host computer, run the following PowerShell command to create an internal virtual switch. The use of this switch ensures that the Azure Stack HCI deployment is isolated.

```PowerShell
New-VMSwitch -Name "internal_switch_name" -SwitchType Internal -NetAdapterName "network_adapter_name" 
```

Once the internal virtual switch is created, a new network adapter is created on the host. You must assign an IP address to this network adapter to become the default gateway of your virtual hosts once connected to this internal switch network. You also need to define the NAT network subnet where the virtual hosts are connected.

The following example script creates a NAT network `HCINAT` with prefix `192.168.44.0/24` and defines the `192.168.44.1` IP as the default gateway for the network using the interface on the host:

```PowerShell
#Check interface index of the new network adapter on the host connected to InternalSwitch:
Get-NetAdapter -Name "vEthernet (InternalSwitch)"

#Create the NAT default gateway IP on top of the InternalSwitch network adapter:
New-NetIPAddress -IPAddress 192.168.44.1 -PrefixLength 24 -InterfaceAlias "vEthernet (InternalSwitch)"

#Create the NAT network:
New-NetNat -Name "HCINAT"-InternalIPInterfaceAddressPrefix 192.168.44.0/24
```

## Create the virtual host

Create a VM to serve as the virtual host with the following configuration. You can create this VM using either Hyper-V Manager or PowerShell:

- **Hyper-V Manager**. For more information, see [Create a virtual machine using Hyper-V Manager](/windows-server/virtualization/hyper-v/get-started/create-a-virtual-machine-in-hyper-v) to mirror your physical management network.

- **PowerShell cmdlets**. Make sure to adjust the VM configuration parameters referenced in the [Virtual host requirements](#virtual-host-requirements) before you run the PowerShell cmdlets.

Follow these steps to create an example VM named `Node1` using PowerShell cmdlets:

1. Create the VM:

    ```PowerShell
    New-VHD -Path "your_VHDX_path" -SizeBytes 127GB
    New-VM -Name Node1 -MemoryStartupBytes 20GB -VHDPath "your_VHDX_path" -Generation 2 -Path "VM_config_files_path"
    ```

1. Disable dynamic memory:

    ```PowerShell
    Set-VMMemory -VMName "Node1" -DynamicMemoryEnabled $false
    ```

1. Disable VM checkpoints:

    ```PowerShell
    Set-VM -VMName "Node1" -CheckpointType Disabled
    ```

1. Remove the default network adapter created during VM creation in the previous step:

    ```PowerShell
    Get-VMNetworkAdapter -VMName "Node1" | Remove-VMNetworkAdapter
    ```

1. Add new network adapters to the VM using custom names. This example adds four NICs, but you can add just two if needed. Having four NICs allows you to test two network intents (`Mgmt_Compute` and `Storage` for example) with two NICs each:

    ```PowerShell
    Add-VmNetworkAdapter -VmName "Node1" -Name "NIC1"
    Add-VmNetworkAdapter -VmName "Node1" -Name "NIC2"
    Add-VmNetworkAdapter -VmName "Node1" -Name "NIC3"
    Add-VmNetworkAdapter -VmName "Node1" -Name "NIC4"
    ```

1. Attach all network adapters to the virtual switch. Specify the name of the virtual switch you created, whether it was external without NAT, or internal with NAT:

    ```PowerShell
    Get-VmNetworkAdapter -VmName "Node1" |Connect-VmNetworkAdapter -SwitchName "virtual_switch_name"
    ```

1. Enable MAC spoofing on all network adapters on VM `Node1`. MAC address spoofing is a technique that allows a network adapter to masquerade as another by changing its Media Access Control (MAC) address. This is required in scenarios where you're planning to use nested virtualization:

    ```PowerShell
    Get-VmNetworkAdapter -VmName "Node1" |Set-VmNetworkAdapter -MacAddressSpoofing On
    ```

1. Enable trunk port (for multi-node deployments only) for all network adapters on VM `Node1`. This script configures the network adapter of a specific VM to operate in trunk mode. This is typically used in multi-node deployments where you want to allow multiple Virtual Local Area Networks (VLANs) to communicate through a single network adapter:

    ```PowerShell
    Get-VmNetworkAdapter -VmName "Node1" |Set-VMNetworkAdapterVlan -Trunk -NativeVlanId 0 -AllowedVlanIdList 0-1000
    ```

1. Create a new key protector and assign it to `Node1`. This is typically done in the context of setting up a guarded fabric in Hyper-V, a security feature that protects VMs from unauthorized access or tampering.

    After the following script is executed, `Node1` will have a new key protector assigned to it. This key protector protects the VM's keys, helping to secure the VM against unauthorized access or tampering:

    ```PowerShell
    $owner = Get-HgsGuardian UntrustedGuardian
    $kp = New-HgsKeyProtector -Owner $owner -AllowUntrustedRoot
    Set-VMKeyProtector -VMName "Node1" -KeyProtector $kp.RawData
    ```

1. Enable the vTPM for `Node1`. By enabling vTPM on a VM, you can use BitLocker and other features that require TPM on the VM. After this command is executed, `Node1` will have a vTPM enabled, assuming the host machine's hardware and the VM's configuration support this feature.

    ```PowerShell
    Enable-VmTpm -VMName "Node1"
    ```

1. Change virtual processors to `8`:

   ```PowerShell
    Set-VmProcessor -VMName "Node1" -Count 8
    ```

1. Create extra drives to be used as the boot disk and hard disks for Storage Spaces Direct. After these commands are executed, six new VHDXs will be created in the `C:\vms\Node1` directory as shown in this example:

   ```PowerShell
    new-VHD -Path "C:\vms\Node1\s2d1.vhdx" -SizeBytes 1024GB
    new-VHD -Path "C:\vms\Node1\s2d2.vhdx" -SizeBytes 1024GB
    new-VHD -Path "C:\vms\Node1\s2d3.vhdx" -SizeBytes 1024GB
    new-VHD -Path "C:\vms\Node1\s2d4.vhdx" -SizeBytes 1024GB
    new-VHD -Path "C:\vms\Node1\s2d5.vhdx" -SizeBytes 1024GB
    new-VHD -Path "C:\vms\Node1\s2d6.vhdx" -SizeBytes 1024GB
    ```

1. Attach drives to the newly created VHDXs for the VM. In these commands, six VHDs located in the `C:\vms\Node1` directory and named `s2d1.vhdx` through `s2d6.vhdx` are added to `Node1`. Each `Add-VMHardDiskDrive` command adds one VHD to the VM, so the command is repeated six times with different `-Path` parameter values.

    Afterwards, the `Node1` VM has six VHDs attached to it. These VHDXs are used to enable Storage Spaces Direct on the VM, which are required for Azure Stack HCI deployments:

   ```PowerShell
    Add-VMHardDiskDrive -VMName "Node1" -Path "C:\vms\Node1\s2d1.vhdx"
    Add-VMHardDiskDrive -VMName "Node1" -Path "C:\vms\Node1\s2d2.vhdx"
    Add-VMHardDiskDrive -VMName "Node1" -Path "C:\vms\Node1\s2d3.vhdx"
    Add-VMHardDiskDrive -VMName "Node1" -Path "C:\vms\Node1\s2d4.vhdx"
    Add-VMHardDiskDrive -VMName "Node1" -Path "C:\vms\Node1\s2d5.vhdx"
    Add-VMHardDiskDrive -VMName "Node1" -Path "C:\vms\Node1\s2d6.vhdx"
    ```

1. Disable time synchronization:

    ```PowerShell
    Get-VMIntegrationService -VMName "Node1" |Where-Object {$_.name -like "T*"}|Disable-VMIntegrationService
    ```

1. Enable nested virtualization:

    ```PowerShell
    Set-VMProcessor -VMName "Node1" -ExposeVirtualizationExtensions $true
    ```

1. Start the VM:

    ```PowerShell
    Start-VM "Node1"
    ```

## Install the OS on the virtual host VMs

Complete the following steps to install and configure the Azure Stack HCI OS on the virtual host VMs:

1. [Download Azure Stack HCI 23H2 ISO](./download-azure-stack-hci-23h2-software.md) and [Install the Azure Stack HCI operating system](deployment-install-os.md).

1. Update the password since this is the first VM startup. Make sure the password meets the Azure complexity requirements. The password is at least 12 characters and includes 1 uppercase character, 1 lowercase character, 1 number, and 1 special character.

1. After the password is changed, the Server Configuration Tool (SConfig) is automatically loaded. Select option `15` to exit to the command line and run the next steps from there.

1. Launch SConfig by running the following command:

    ```PowerShell
      SConfig
    ```
    
    For information on how to use SConfig, see [Configure with the Server Configuration tool (SConfig)](/windows-server/administration/server-core/server-core-sconfig).

1. Change hostname to `Node1`. Use option `2` for `Computer name` in SConfig to do this.

    The hostname change results in a restart. When prompted for a restart, enter `Yes` and wait for the restart to complete. SConfig is launched again automatically.

1. From the physical host, run the `Get-VMNetworkAdapter` and `ForEach-Object` cmdlets to configure the four network adapter names for VM `Node1` by mapping the assigned MAC addresses to the corresponding network adapters on the guest OS.

     1. The `Get-VMNetworkAdapter` cmdlet is used to retrieve the network adapter object for each NIC on the VM, where the `-VMName` parameter specifies the name of the VM, and the `-Name` parameter specifies the name of the network adapter. The `MacAddress` property of the network adapter object is then accessed to get the MAC address:

    ```PowerShell
    Get-VMNetworkAdapter -VMName "Node1" -Name "NIC1"
    ```

    2. The MAC address is a string of hexadecimal numbers. The `ForEach-Object` cmdlet is used to format this string by inserting hyphens at specific intervals. Specifically, the `Insert` method of the string object is used to insert a hyphen at the 2nd, 5th, 8th, 11th, and 14th positions in the string. The `join` operator is then used to concatenate the resulting array of strings into a single string with spaces between each element.

    3. The commands are repeated for each of the four NICs on the VM, and the final formatted MAC address for each NIC is stored in a separate variable:

    ```PowerShell
    ($Node1finalmacNIC1, $Node1finalmacNIC2, $Node1finalmacNIC3, $Node1finalmacNIC4).
    ```

    4. The following script outputs the final formatted MAC address for each NIC:

    ```PowerShell
    $Node1macNIC1 = Get-VMNetworkAdapter -VMName "Node1" -Name "NIC1"
    $Node1macNIC1.MacAddress
    $Node1finalmacNIC1=$Node1macNIC1.MacAddress|ForEach-Object{($_.Insert(2,"-").Insert(5,"-").Insert(8,"-").Insert(11,"-").Insert(14,"-"))-join " "}
    $Node1finalmacNIC1

    $Node1macNIC2 = Get-VMNetworkAdapter -VMName "Node1" -Name "NIC2"
    $Node1macNIC2.MacAddress
    $Node1finalmacNIC2=$Node1macNIC2.MacAddress|ForEach-Object{($_.Insert(2,"-").Insert(5,"-").Insert(8,"-").Insert(11,"-").Insert(14,"-"))-join " "}
    $Node1finalmacNIC2

    $Node1macNIC3 = Get-VMNetworkAdapter -VMName "Node1" -Name "NIC3"
    $Node1macNIC3.MacAddress
    $Node1finalmacNIC3=$Node1macNIC3.MacAddress|ForEach-Object{($_.Insert(2,"-").Insert(5,"-").Insert(8,"-").Insert(11,"-").Insert(14,"-"))-join " "}
    $Node1finalmacNIC3

    $Node1macNIC4 = Get-VMNetworkAdapter -VMName "Node1" -Name "NIC4"
    $Node1macNIC4.MacAddress
    $Node1finalmacNIC4=$Node1macNIC4.MacAddress|ForEach-Object{($_.Insert(2,"-").Insert(5,"-").Insert(8,"-").Insert(11,"-").Insert(14,"-"))-join " "}
    $Node1finalmacNIC4

1. Obtain the `Node1` VM local admin credentials and then rename `Node1`:

    ```PowerShell
    $cred = get-credential
    ```

1. Rename and map the NICs on `Node1`. The renaming is based on the MAC addresses of the NICs assigned by Hyper-V when the VM is started the first time. These commands should be run directly from the host:

    Use the `Get-NetAdapter` command to retrieve the physical network adapters on the VM, filter them based on their MAC address, and then rename them to the matching adapter using the `Rename-NetAdapter` cmdlet.

    This is repeated for each of the four NICs on the VM, with the MAC address and new name of each NIC specified separately. This establishes a mapping between the name of the NICs in Hyper-V Manager and the name of the NICs in the VM OS:

    ```PowerShell
    Invoke-Command -VMName "Node1" -Credential $cred -ScriptBlock {param($Node1finalmacNIC1) Get-NetAdapter -Physical | Where-Object {$_.MacAddress -eq $Node1finalmacNIC1} | Rename-NetAdapter -NewName "NIC1"} -ArgumentList $Node1finalmacNIC1

    Invoke-Command -VMName "Node1" -Credential $cred -ScriptBlock {param($Node1finalmacNIC2) Get-NetAdapter -Physical | Where-Object {$_.MacAddress -eq $Node1finalmacNIC2} | Rename-NetAdapter -NewName "NIC2"} -ArgumentList $Node1finalmacNIC2

    Invoke-Command -VMName "Node1" -Credential $cred -ScriptBlock {param($Node1finalmacNIC3) Get-NetAdapter -Physical | Where-Object {$_.MacAddress -eq $Node1finalmacNIC3} | Rename-NetAdapter -NewName "NIC3"} -ArgumentList $Node1finalmacNIC3

    Invoke-Command -VMName "Node1" -Credential $cred -ScriptBlock {param($Node1finalmacNIC4) Get-NetAdapter -Physical | Where-Object {$_.MacAddress -eq $Node1finalmacNIC4} | Rename-NetAdapter -NewName "NIC4"} -ArgumentList $Node1finalmacNIC4
    ```

1. Disable the Dynamic Host Configuration Protocol (DHCP) on the four NICs for VM `Node1` by running the following commands.

    > [!NOTE]
    > The interfaces won't automatically obtain IP addresses from a DHCP server and instead need to have IP addresses manually assigned to them:

    ```PowerShell
    Invoke-Command -VMName "Node1" -Credential $cred -ScriptBlock {Set-NetIPInterface -InterfaceAlias "NIC1" -Dhcp Disabled}

    Invoke-Command -VMName "Node1" -Credential $cred -ScriptBlock {Set-NetIPInterface -InterfaceAlias "NIC2" -Dhcp Disabled}

    Invoke-Command -VMName "Node1" -Credential $cred -ScriptBlock {Set-NetIPInterface -InterfaceAlias "NIC3" -Dhcp Disabled}

    Invoke-Command -VMName "Node1" -Credential $cred -ScriptBlock {Set-NetIPInterface -InterfaceAlias "NIC4" -Dhcp Disabled}
    ```

1. Set management IP, gateway, and DNS. After the following commands are executed, `Node1` will have the `NIC1` network interface configured with the specified IP address, subnet mask, default gateway, and DNS server address. Ensure that the management IP address can resolve Active Directory and has outbound connectivity to the internet:

    ```PowerShell
    Invoke-Command -VMName "Node1" -Credential $cred -ScriptBlock {New-NetIPAddress -InterfaceAlias "NIC1" -IPAddress "192.168.44.201" -PrefixLength 24 -AddressFamily IPv4 -DefaultGateway "192.168.44.1"}

    Invoke-Command -VMName "Node1" -Credential $cred -ScriptBlock {Set-DnsClientServerAddress -InterfaceAlias "NIC1" -ServerAddresses "192.168.1.254"}
    ```

1. Enable the Hyper-V role. This command restarts the VM `Node1`:

    ```PowerShell
    Invoke-Command -VMName "Node1"
    -Credential $cred -ScriptBlock {Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All }
    ```

1. Once `Node1` is restarted and the Hyper-V role is installed, install the Hyper-V Management Tools:

    ```PowerShell
    Invoke-Command -VMName "Node1" -Credential $cred -ScriptBlock {Install-WindowsFeature -Name Hyper-V -IncludeManagementTools}
    ```

1. Once the virtual host server is ready, you must [register it and assign permissions](deployment-arc-register-server-permissions.md) in Azure as an Arc resource.

1. Once the server is registered in Azure as an Arc resource and all the mandatory extensions are installed, choose one of the following methods to deploy Azure Stack HCI from Azure.

    - [Deploy Azure Stack HCI using Azure portal](deploy-via-portal.md).

    - [Deploy Azure Stack HCI using an Azure Resource Manager template](deployment-azure-resource-manager-template.md).

Repeat the process above for extra nodes if you plan to test multi-node deployments. Ensure virtual host names and management IPs are unique and on the same subnet:

## Next steps

- [Register to Arc and assign permissions for deployment](deployment-arc-register-server-permissions.md)
