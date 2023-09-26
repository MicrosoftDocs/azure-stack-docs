---
title: Azure Stack HCI virtual deployment via Supplemental Package
description: Describes how to perform an Azure Stack HCI virtual deployment using the Supplemental Package.
author: alkohli
ms.author: alkohli
ms.reviewer: alkohli
ms.topic: how-to
ms.date: 07/11/2023
---

# Deploy a virtual Azure Stack HCI cluster (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-supplemental-package.md)]

[!INCLUDE [applies-to](../../includes/hci-preview.md)]

This article describes how to deploy a single-server or multi-node Azure Stack HCI, version 22H2, on a host system running Hyper-V on the Windows Server 2022, Windows 11, or later operating system (OS).  

You’ll need administrator privileges for the Azure Stack HCI virtual deployment and be familiar with the existing Azure Stack HCI solution. The deployment can take around 2.5 hours to complete.

> [!IMPORTANT]
> A virtual deployment of Azure Stack HCI, version 22H2 is intended for educational and demonstration purposes only. Microsoft Support doesn't support virtual deployments.

## Prerequisites

Here are the software, hardware, and networking prerequisites for the virtual deployment:

### Hardware requirements

Before you begin, make sure that:

- You have access to a host system running Hyper-V on Windows Server 2022, Windows 11, or later. This host would be used to provision a virtual Azure Stack HCI deployment.

- The physical hardware used for the virtual deployment meets the following requirements:
 
    | Component | Minimum |
    | ------------- | -------- |
    | Processor| Intel VT-x or AMD-V. Support for nested virtualization. For more information, see [Does My Processor Support Intel® virtualization technology?](https://www.intel.com/content/www/us/en/support/articles/000005486/processors.html).
    | Memory| A minimum of 32 GB RAM.|
    | Host network adapters| A single network adapter|
    | Storage| 1 TB Solid state drive (SSD)

### Software requirements

Before you begin, make sure that the host system can dedicate the following resources to provision your virtualized Azure Stack HCI. The host operating system must be running Hyper-V on Windows Server 2022, Windows 11, or later.

- A minimum of 4 vCPUs.

- At least 8 GB of RAM.

- At least two network adapters connected to the internal network with MAC, spoofing-enabled.

- At least one boot disk to [install the Azure Stack HCI operating system](deployment-tool-install-os.md).

- At least six hard disks with a maximum size of 1024 GB for Storage Spaces Direct.

- At least one data disk with 127 GB to store the deployment tool.

## Install the OS

Before you begin, make sure to [install the host operating system](deployment-tool-install-os.md) - Windows Server 2022, Windows 11, or later.

## Set up the virtual switch

First, create an internal virtual switch with Network Address Translation (NAT) enabled. The use of this switch ensures that the Azure Stack HCI deployment is isolated.

1. On your host computer, run PowerShell as Administrator.

1. Create an internal virtual switch and name the switch *InternalDemo*. Run the following command:

      ```PowerShell
         New-VMSwitch -SwitchName "InternalDemo" -SwitchType Internal
      ```

1. Find the interface index of the virtual switch you just created. Use the `Get-NetAdapter` cmdlet to find the interface index:

     ```PowerShell
         Get-NetAdapter    
     ```

    Here is a sample output of the `Get-NetAdapter` cmdlet.

    ```PowerShell
    PS C:\Users\Administrator> Get-NetAdapter

    Name  InterfaceDescription  ifIndex  MacAddress  LinkSpeed
    ----  --------------------  -------  ----------  ---------
    vEthernet (InternalDemo)   Hyper-V Virtual Ethernet…   20 Up   00-15-5D-E2-3E-00   10 Gbps
    vEthernet   (Intel(R) Ethernet Hyper-V Virtual Ethernet   9 Up   98-90-96-E0-69-2F   1 Gbps
    Ethernet   (Intel(R) Ethernet   5 Up   98-90-96-E0-69-2F   1 Gbps
    Ethernet 2   ASIX AX88772 USB2.0 to …   3 Up   00-50-B6-58-05-4A   100 Mbps
    ```

1. From the output of the `Get-NetAdapter` cmdlet, find the adapter that includes the virtual switch name you created in the earlier step. Make a note of the `ifIndex` corresponding to the virtual switch. In the above example, the `ifIndex` is 20.

1. Create the NAT gateway. Provide the NAT gateway IP address, NAT subnet prefix length, and the interface index you determined in the previous step:

      ```PowerShell
         New-NetIPAddress -IPAddress 192.168.0.1 -PrefixLength 24 -InterfaceIndex <ifIndex from previous step>
      ```

1. Configure the NAT gateway. Provide a name to describe the name of the NAT network and 192.168.0.0/24 as the NAT subnet prefix:

      ```PowerShell
         New-NetNat -Name <NAT network name> -InternalIPInterfaceAddressPrefix 192.168.0.0/24
      ```

## Create the virtual host

Create a virtual machine (VM) to serve as the virtual host with the following configuration:

| **Component**| **Requirement**|
| -------------| -------------- |
| Virtual machine type | Secure Boot and Trusted Platform Module (TPM) enabled. |
| vCPUs | 4 cores |
| Memory | A minimum of 8 GB |
| Networking |  Two network adapters connected to internal network. MAC spoofing must be enabled. |
| Boot disk | 1 disk to install the Azure Stack HCI operating system from ISO.|
| Hard disks for Storage Spaces Direct  |  6 dynamic expanding disks. Maximum disk size is 1024 GB. |
| Data disk | At least 127 GB. Stores the deployment tool. |
| Time synchronization in integration services | Disabled|

You can create this VM using one of the following methods:

- **Use Hyper-V Manager**. For more information, see [Create a virtual machine using Hyper-V Manager](/windows-server/virtualization/hyper-v/get-started/create-a-virtual-machine-in-hyper-v) to mirror your physical management network.

- **Use PowerShell cmdlets**. Use PowerShell cmdlets to create the VM. Make sure to adjust the VM configuration parameters listed above before you run these cmdlets. For an example output, see the  [Appendix](#appendix).

    Follow these steps to create a VM via PowerShell cmdlets:

   1. Create the VM:

       ```PowerShell
       new-VHD -Path -SizeBytes 127GB
       New-Vm -Name -MemoryStartupBytes 16GB -VHDPath -Generation 2 -Path
       ```

    1. Add a second network adapter:

       ```PowerShell
       Add-VmNetworkAdapter -VmName <VM name>
       ```

    1. Attach both adapters to the virtual switch:

       ```PowerShell
       Get-VmNetworkAdapter -VmName <VM Name>|Connect-VmNetworkAdapter -SwitchName <Internal virtual switch name>
       ```

    1. Enable MAC spoofing on both adapters:

       ```PowerShell
       Get-VmNetworkAdapter -VmName <VM name>|Set-VmNetworkAdapter -MacAddressSpoofing On
       ```

    1. Enable the trunk port (for multi-node deployments only):

       ```PowerShell
       Get-VmNetworkAdapter -VmName <VM name>|Set-VmNetworkAdapterVlan -Trunk -NativeVlanId 0 -AllowedVlanIdList 0-1000
       ```

    1. Enable Trusted Platform Module (TPM):

        ```PowerShell
        Enable-VmTpm -VmName <VM name>
        ```

        If the above step fails, you must enable TPM using Hyper-V Manager as follows:

        a. In Hyper-V Manager, select the VM, right-click, and from the context menu, select **Settings**.

        b. Go to **Hardware > Security** and then select the **Enable Trusted Platform Module** option:
 
        :::image type="content" source="media/virtual-deployment/trusted-platform-module.png" alt-text="Screenshot of Hardware Security window." lightbox="media/virtual-deployment/trusted-platform-module.png":::

    1. Change the number of virtual processors to `4`:

       ```PowerShell
       Set-VmProcessor -VmName <VM name> -Count 4
       ```

    1. Create additional drives to be used as the boot disk and hard disks for Storage Spaces Direct:

       ```PowerShell
       new-VHD -Path <Path to data.vhdx file> -SizeBytes 127GB
       new-VHD -Path <Path to s2d1.vhdx file> -SizeBytes 1024GB
       new-VHD -Path <Path to s2d2.vhdx file> -SizeBytes 1024GB
       new-VHD -Path <Path to s2d3.vhdx file> -SizeBytes 1024GB
       new-VHD -Path <Path to s2d4.vhdx file> -SizeBytes 1024GB
       new-VHD -Path <Path to s2d5.vhdx file> -SizeBytes 1024GB
       new-VHD -Path <Path to s2d6.vhdx file> -SizeBytes 1024GB
       ```

    1. Attach the drives:

        ```PowerShell
        Add-VMHardDiskDrive -VmName <VM Name> -Path <Path to data.vhdx file>
        Add-VMHardDiskDrive -VmName <VM Name> -Path <Path to s2d1.vhdx file>
        Add-VMHardDiskDrive -VmName <VM Name> -Path <Path to s2d2.vhdx file>
        Add-VMHardDiskDrive -VmName <VM Name> -Path <Path to s2d3.vhdx file>
        Add-VMHardDiskDrive -VmName <VM Name> -Path <Path to s2d4.vhdx file>
        Add-VMHardDiskDrive -VmName <VM Name> -Path <Path to s2d5.vhdx file>
        Add-VMHardDiskDrive -VmName <VM Name> -Path <Path to s2d6.vhdx file>
        ```

    1. Disable time synchronization:

        ```PowerShell
        Get-VMIntegrationService -VmName node1 |Where-Object {$_.name -like "T*"}|Disable-VMIntegrationService
        ```

## Enable nested virtualization

If the host processor supports nested virtualization, the Hyper-V role enabled by the Azure Stack HCI deployment will validate.

To enable nested virtualization, run the following command.

   ```PowerShell

      Set-VmProcessor -VmName node1 -ExposeVirtualizationExtensions $true
   ```

## Configure NAT inbound rules (optional)

The configuration in this section is optional.

To access the server from your Hyper-V host or any other computer in your network, Network Address Translation (NAT) inbound rules are required.

1. Create the following inbound rules:

    | **Protocol**| **Port** | **Description**|
    | ------------| ---------| ---------------|
    | Remote Desktop Protocol (RDP) | 3389| Access the server via Remote Desktop protocol |
    | Deployment tool UI | 443| Access to the web-based UI for the deployment tool |

1. Enable port mapping from port 53389 to 3389. Run the following command:

   ```PowerShell
      Add-NetNatStaticMapping -NatName MyNATnetwork -ExternalIPAddress 0.0.0.0 -InternalIPAddress 192.168.0.92 -Protocol TCP -ExternalPort 53389 -InternalPort 3389
   ```

1. Enable port mapping from port 5443 to 443. Run the following command:

   ```PowerShell
      Add-NetNatStaticMapping -NatName MyNATnetwork -ExternalIPAddress 0.0.0.0 -InternalIPAddress 192.168.0.92 -Protocol TCP -ExternalPort 5443 -InternalPort 443
   ```

    You may receive the following error: *Add-NetNatStaticMapping: The process cannot access the file because it is being used by another process*. To resolve this, change the external port as the one you are trying to use is already allocated.

## Start the deployment

1. Start the virtual host VM using Hyper-V Manager or PowerShell. The VM will take several minutes to boot up. Wait for the boot to complete.

   ```PowerShell
      Start-Vm <node1>
   ```

1. [Install the HCI operating system](deployment-tool-install-os.md).

1. Update the password since this is the first VM start up.

1. After the password is changed, `Sconfig` is automatically loaded. Select option `15` to exit to the command line and run the next steps from there.

1. Initialize the data disk to store the deployment tool. Ensure that the data disk is assigned the drive letter `D`. Run the following commands from the virtual server:

   ```PowerShell
      Set-disk 1 -isOffline $false
      Set-Disk 1 -isReadOnly $false
      Initialize-Disk 1 -PartitionStyle GPT
      New-Partition -DiskNumber 1 -UseMaximumSize
      Get-Partition -DiskNumber 1 -PartitionNumber 2 | Format-Volume -FileSystem NTFS
      Get-Partition -DiskNumber 1 -PartitionNumber 2 | Set-Partition -NewDriveLetter D
   ```

1. Connect to the Windows Server host from the VM and when prompted, provide the credentials:

    ```PowerShell
    net use \\<Windows Server host IP or FQDN>\C$
    ```

1. Copy the `Cloud` folder that contains the deployment tool from Windows Server to the VM:

   ```PowerShell
   copy \\<Network path to folder containing deployment tool on Windows Server> <Destination path on VM on D: drive> -r`
   ```

   Verify that the tool was copied over. Examine the contents of the `Cloud` folder.
    
    Here is a sample output:

    ```
        PS C:\Users\Administrator> net use \\WIN-29V48V6T1O8\C$

        Enter the user name for 'WIN-29V48V6T1O8': <Username>
        Enter the password for WIN-29V48V6T1O8:<Password>
        The command completed successfully.
        PS C:\Users\Administrator> copy \\WIN-29V48V6T1O8\C$\Users\Administrator\Cloud D:\deployment -r

        PS C:\Users\Administrator> cd D:\deployment
        PS D:\deployment> dir
        Directory: D:\deployment
        Mode       LastWriteTime      Length Name
        ----       -------------      ------ ----
        -a----     6/28/2022  12:10 AM   18465 BootstrapCloudDeploymentTool.ps1
        -a----     6/28/2022   2:44 PM   21709 CloudDeployment.Metadata.xml
        -a----     6/28/2022   2:41 PM   11420824813 
        CloudDeployment_10.2206.0.50.zip
        PS D:\deployment>   
    ```

1. Launch the Server Configuration Tool (`SConfig`). Run the following command:

    ```PowerShell
      SConfig
    ```

    For information on how to use `SConfig`, see [Configure a Server Core installation of Windows Server and Azure Stack HCI with the Server Configuration tool (SConfig](/windows-server/administration/server-core/server-core-sconfig).

1. Change hostname to `node1`. Use option `2` for **Computer name** in `SConfig`.

    The hostname change will result in a restart. When prompted for a restart, enter `Yes` and  wait for the restart to complete. `SConfig` is launched automatically.

1. Configure IP Address to `192.168.0.92`, subnet mask to `255.255.255.0`, and gateway to `192.168.0.1`. Configure a valid DNS server. Use option `8` for network settings in `SConfig`.

1. Use option `15` and exit to the command line.

1. Choose one of the following methods to deploy Azure Stack HCI:

    1. Deploy interactively:
        1. Switch to the `D:` drive and install the deployment tool as per the instructions in [Step 3A: Deploy Azure Stack HCI interactively](deployment-tool-new-file.md).
        1. Afterward, use the **deploy from file** option.
    1. Deploy a single-server cluster using PowerShell as per the instructions in [Step 3C: Deploy Azure Stack HCI using PowerShell](deployment-tool-powershell.md).

## Appendix

Here is an example output for VM creation:

   ```PowerShell
    PS C:\Users\Administrator> mkdir c:\users\administrator\vms1\node1
      Directory: C:\users\administrator\vms1

     Mode    LastWriteTime Length Name 
     ----    ------------- ------ ----
     d----- 7/15/2022  9:51 AM node1 
    PS C:\Users\Administrator> Copy-item c:\users\administrator\image c:\users\administrator\vms1\node1
    PS C:\Users\Administrator> cd c:\users\administrator\vms1\node1
    PS C:\users\administrator\vms1\node1> dir
      Directory: C:\users\administrator\vms1\node1
     Mode    LastWriteTime Length Name  
     ----    ------------- ------ ----
     d-----  7/15/2022   9:51 AM  image 
     d-----  7/15/2022  10:54 AM  myhcinode1
    PS C:\Users\Administrator> new-vm -Name myhcinode1 -MemoryStartupBytes 16GB -VHDPath 
    c:\users\administrator\vms1\node1\ServerHCI.vhdx -Generation 2 -Path c:\users\administrator\vms1\node1

     Name  State    CPUUsage(%)   MemoryAssigned (M)  Uptime  Status  Version 
     ----  -----    ------------  -------------- ----  ------  ------  ------- 
     myhcinode1  Off  0               0  00:00:00  Operating normally  9.0

    PS C:\Users\Administrator> add-vmnetworkadapter -VMName myhcinode1
    PS C:\Users\Administrator> Get-VMNetworkAdapter -VMName myhcinode1|Connect-VMNetworkAdapter -SwitchName "InternalDemo"
    PS C:\Users\Administrator> Get-VMNetworkAdapter -VMName myhcinode1 | Set-VMNetworkAdapter -MacAddressSpoofing On
    PS C:\Users\Administrator> Enable-VMTPM -VMName myhcinode1

   ```

## Next steps

- [Review deployment overview](deployment-tool-introduction.md).
