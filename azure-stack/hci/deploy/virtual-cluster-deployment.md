---
title: Deploy a virtual Azure Stack HCI 22H2 cluster (preview)
description: This article describes how to perform an Azure Stack HCI version 22H2 virtual deployment.
author: dansisson
ms.author: v-dansisson
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 1/13/2023
---

# Azure Stack HCI virtual deployment (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-supplemental-package.md)]

This document describes how to deploy a single or multi-node Azure Stack HCI, version 22H2, on a host system running Hyper-V on Windows Server 2022, Windows 11, or later.  A virtualized, single or multi-node server deployment of Azure Stack HCI, version 22H2 is intended for educational and demonstration purposes only. Microsoft Support doesn't support virtual deployments.

You’ll need administrator privileges for the Azure Stack HCI virtual deployment and be familiar with the existing Azure Stack HCI solution. The deployment can take around 2.5 hours to complete.

> [!IMPORTANT]
> Azure Stack HCI 22H2 is in preview. Please review the terms of use for the preview and sign up before you deploy this solution. For more details, see the [Preview Terms Of Use | Microsoft Azure ](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

## Process

The following steps are required to create a virtual Azure Stack HCI version 22H2 deployment.

Step 0: Satisfy the prerequisites

Step 1: [Set up the virtual switch](#step-1-set-up-the-virtual-switch)

Step 2: [Create the virtual host](#step-2-create-the-virtual-host)

Step 3: [Enable nested virtualization](#step-3-enable-nested-virtualization)

Step 4: [Configure NAT inbound rules](#step-4-configure-nat-inbound-rules)

Step 5: [Start the deployment](#step-5-start-the-deployment)

## Prerequisites

Here you will find the software, hardware, and networking prerequisites to deploy Azure Stack HCI 22H2:

### Hardware requirements

Before you begin, make sure that:

- You have access to a host system running Hyper-V on Windows Server 2022 or later. This host would be used to provision a virtual Azure Stack HCI deployment.

- The physical hardware used for the virtual deployment meets the following requirements:
 
| Component | Minimum |
| ------------- | ----------------------- |
| Processor| Intel VT-x or AMD-V.|
|              |    Support for nested virtualization. For more information, see [Does My Processor Support Intel® virtualization technology?](https://www.intel.com/content/www/us/en/support/articles/000005486/processors.html).
| Memory| A minimum of 32 GB RAM.|
| Host network adapters| A single network adapter|
| Storage| 1 TB Solid state drive (SSD)

### Software requirements

Before you begin, make sure that the host system can dedicate the following resources to provision your virtualized Azure Stack HCI:

- A minimum of 4 vCPUs.

- At least 16 GB of RAM.

- At least 2 network adapters connected to the internal network with MAC, spoofing-enabled.

- At least 1 boot disk that has the virtual hard disk image for the deployment.

- At least 6 hard disks with a maximum size of 1024 GB for Storage Spaces Direct.

- At least 1 data disk with 127 GB to store the deployment tool.

## Step 1: Set up the virtual switch

First, we will create an internal virtual switch with Network Address Translation (NAT) enabled. The use of this switch ensures that the Azure Stack HCI deployment is isolated.

1. On the Windows Server host computer, run PowerShell as Administrator.

1. Create an internal virtual switch and name the switch *InternalDemo*. Run the following command:

      ```PowerShell
         New-VMSwitch -SwitchName "InternalDemo" -SwitchType Internal
      ```

1. Find the interface index of the virtual switch you just created. Use the `Get-NetAdapter` cmdlet to find the interface index.

     ```PowerShell
         Get-NetAdapter    
     ```

    Here is a sample output of the `Get-NetAdapter` cmdlet.

    ```PowerShell
    PS C:\Users\Administrator> Get-netadapter

    | **Name**| **InterfaceDescription**| **ifIndex**| MacAddress|**LinkSpeed**|
    | ----------- | ------------------ |-----| --------| --------|
    | vEthernet (InternalDemo)| Hyper-V Virtual Ethernet… | 20  Up |  00-15-5D-E2-3E-00 | 10 Gbps |
    | vEthernet | (Intel(R) Ethernet Hyper-V Virtual Ethernet |  9  Up | 98-90-96-E0-69-2F | 1 Gbps |
    | Ethernet |  (Intel(R) Ethernet | 5  Up |  98-90-96-E0-69-2F | 1 Gbps |
    | Ethernet 2 | ASIX AX88772 USB2.0 to … | 3 Up |  00-50-B6-58-05-4A | 100 Mbps |
    ```

1. From the output of the `Get-NetAdapter` cmdlet, find the adapter that includes the virtual switch name you created in the earlier step. Make a note of the `ifIndex` corresponding to the virtual switch. In the above example, the `ifIndex` is 20.

1. Create the NAT gateway. Provide the NAT gateway IP address, NAT subnet prefix length, and the interface index you determined in the previous step.

      ```PowerShell
         New-NetIPAddress -IPAddress 192.168.0.1 -PrefixLength 24 -InterfaceIndex <ifIndex from previous step>
       ```

1. Configure the NAT gateway. Provide a name to describe the name of the NAT network and 192.168.0.0/24 as the NAT subnet prefix.

      ```PowerShell
         New-NetNat -Name <NAT network name> -InternalIPInterfaceAddressPrefix 192.168.0.0/24
      ```

## Step 2: Create the virtual host

You’ll now create a virtual machine (VM) to serve as the virtual host with the following configuration:

| **Component**| **Requirement**|
| -------------| -------------- |
| Virtual machine type | Secure boot enabled. TPM enabled |
| vCPUs | 4 cores |
| Memory | A minimum of 16 GB |
| Networking |  Two network adapters connected to internal network. MAC spoofing must be enabled. |
| Boot disk | 1 disk using `ServerHCI.vhdx`.|
| Hard disks for Storage Spaces Direct  |  6 dynamic expanding disks. Maximum disk size is 1024 GB. |
| Data disk | At least 127 GB. Stores the deployment tool. |
| Time synchronization in integration services | Disabled.|

You can create this VM using one of the following methods:

- Using Hyper-V Manager. For more information, see [Create a virtual machine using Hyper-V Manager](/windows-server/virtualization/hyper-v/get-started/create-a-virtual-machine-in-hyper-v) to mirror your physical management network.

- Using PowerShell cmdlets.

You can use the following series of PowerShell cmdlets to create the VM. Make sure to adjust the VM configuration parameters listed above before you run these cmdlets. For an example output, see  [Appendix II](#appendix-ii).

1. Create a folder and copy *ServerHCI.vhdx* to this folder.  Modify the source path accordingly.

   ```PowerShell
      Mkdir <Destination path for ServerHCI.vhdx file>
      Copy-item <Source path for ServerHCI.vhdx> <Destination path for ServerHCI.vhdx>
   ```

1. Create the VM:

   ```PowerShell
     New-Vm -Name <VM Name> -MemoryStartupBytes 16GB -VHDPath <Source path for ServerHCI.vhdx file> -Generation 2 -Path <Source path for folder containing ServerHCI.vhdx>
   ```

1. Add second network adapter:

   ```PowerShell
      Add-VmNetworkAdapter -VmName <VM Name>
   ```

1. Attach both adapters to virtual switch:

   ```PowerShell
      Get-VmNetworkAdapter -VmName <VM Name>|Connect-VmNetworkAdapter -SwitchName "<Internal virtual switch name>"
   ```

1. Enable MAC spoofing on both adapters:

   ```PowerShell
      Get-VmNetworkAdapter -VmName <VM Name>|Set-VmNetworkAdapter -MacAddressSpoofing On
   ```

1. Enable the trunk port (for multi-node deployments only):

   ```PowerShell
      Get-VmNetworkAdapter -VmName <VM Name>|Set-VMNetworkAdapterVlan -Trunk -NativeVlanId 0 -AllowedVlanIdList 0-1000
   ```

1. Enable Trusted Platform Module (TPM):

   ```PowerShell
      Enable-VmTpm -VMName <VM_name>
   ```

      If the above step fails, you must enable TPM using Hyper-V Manager as follows:

      a. In Hyper-V Manager, select the VM, right-click and from the context menu, select **Settings**.

      b. Go to **Hardware > Security** and then check the **Enable Trusted Platform Module** option:
 
      :::image type="content" source="media/virtual-deployment/trusted-platform-module.png" alt-text="Screenshot of Hardware Security window." lightbox="media/virtual-deployment/trusted-platform-module.png":::

   1. Change the number of virtual processors to `4`:

   ```PowerShell
      Set-VmProcessor -VMName <VM Name> -Count 4
   ```

1. Create additional drives to be used as boot disk and hard disks for Storage Spaces Direct:

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
     Add-VMHardDiskDrive -VMName <VM Name> -Path <Path to data.vhdx file>
     Add-VMHardDiskDrive -VMName <VM Name> -Path <Path to s2d1.vhdx file>
     Add-VMHardDiskDrive -VMName <VM Name> -Path <Path to s2d2.vhdx file>
     Add-VMHardDiskDrive -VMName <VM Name> -Path <Path to s2d3.vhdx file>
     Add-VMHardDiskDrive -VMName <VM Name> -Path <Path to s2d4.vhdx file>
     Add-VMHardDiskDrive -VMName <VM Name> -Path <Path to s2d5.vhdx file>
     Add-VMHardDiskDrive -VMName <VM Name> -Path <Path to s2d6.vhdx file>
   ```

1. Disable time synchronization

   ```PowerShell
     Get-VMIntegrationService -VMName node1 |Where-Object {$_.name -like "T*"}|Disable-VMIntegrationService
   ```

## Step 3: Enable nested virtualization

If the host processor supports nested virtualization, the Hyper-V role enabled by the Azure Stack HCI, version 22H2 deployment, will validate.

Before you start the newly created virtual machine, enable nested virtualization. Run the following command.

   ```PowerShell

      Set-VmProcessor -VmName node1 -ExposeVirtualizationExtensions $true
   ```

## Step 4: Configure NAT inbound rules

To access the server from your Hyper-V host or any other machine in your network, NAT inbound rules are required. 

1. Create the following inbound rules:

    | **Protocol**| **Port** | **Description**|
    | ------------| ---------| ---------------|
    | Remote Desktop Protocol (RDP) | 3389| Access the server via Remote Desktop protocol |
    | Deployment tool UI | 443| Access to the web-based UI for deployment tool |

1. Enable port mapping from 53389 to 3389. Run the following command:

   ```PowerShell
      Add-NetNatStaticMapping -NatName MyNATnetwork -ExternalIPAddress 0.0.0.0 -InternalIPAddress 192.168.0.92 -Protocol TCP -ExternalPort 53389 -InternalPort 3389
   ```

1. Enable port mapping from 5443 to 443. Run the following command:

   ```PowerShell
      Add-NetNatStaticMapping -NatName MyNATnetwork -ExternalIPAddress 0.0.0.0 -InternalIPAddress 192.168.0.92 -Protocol TCP -ExternalPort 5443 -InternalPort 443
   ```

    You may receive the following error: *Add-NetNatStaticMapping: The process cannot access the file because it is being used by another process*. To resolve this, change the external port as the one you are trying to use is already allocated.

## Step 5: Start the deployment

1. Start the virtual host VM using Hyper-V Manager or PowerShell. The VM will take several minutes to boot up. Wait for the boot to complete.

   ```PowerShell
      Start-Vm <node1>
   ```

1. Update the password since this is the first VM start up.

1. After the password is changed, `Sconfig` is automatically loaded. Select option `15` to exit to the command line and run the next steps from there.

1. Initialize the data disk to store the version 22H2 deployment tool. Ensure that the data disk is assigned the drive letter `D`. Run the following commands from the virtual server:

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

```PowerShell
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

1. Rename the network adapters, using the names from the previous step. Note that the new name must match what is in the `config.json` file used for the deployment. Run the following command:

    ```PowerShell
    Get-NetAdapter <VM>
    ```

    Verify the names of the network adapters. Here is a sample output:

    ```PowerShell
        PS C:\Users\Administrator> Get-NetAdapter

        Name     InterfaceDescription      ifIndex Status MacAddress   LinkSpeed
        ----    --------------------       ------- ------ ----------   ---------
        Ethernet Microsoft Hyper-V Network Adapter 8 Up 00-15-5D-E2-3E-03  10 Gbps 
        Ethernet 2 Microsoft Hyper-V Network Ada…  5 Up  00-15-5D-E2-3E-04   10 Gbps 

        PS C:\Users\Administrator> Rename-NetAdapter -Name "ethernet" -NewName Nic1
        PS C:\Users\Administrator> Rename-NetAdapter -Name "ethernet 2" -NewName Nic2
    ```

1. Launch the Server Configuration Tool (`SConfig`). Run the following command:

    ```PowerShell
      sconfig
    ```

    For information on how to use `sconfig`, see [Configure a Server Core installation of Windows Server and Azure Stack HCI with the Server Configuration tool (SConfig](/windows-server/administration/server-core/server-core-sconfig).

1. Change hostname to `node1`. Use option `2` for **Computer name** in `SConfig`.

    The hostname change will result in a restart. When prompted for a restart, enter `Yes` and  wait for the restart to complete. `SConfig` is launched automatically.

1. Configure IP Address to `192.168.0.92`, subnet mask to `255.255.255.0`, and gateway to `192.168.0.1`. Configure a valid DNS server. Use option 8 for network settings in `SConfig`.

1. Use option 15 and exit to the command line.

1. Choose one of the following methods to deploy Azure Stack HCI:

    1. Deploy using the UX-based deployment tool. 
        1. Switch to the `D` drive and install the deployment tool as per the instructions in **Step 2: Set up the deployment tool** in the *Azure Stack HCI, version 22H2 deployment guide.*
        1. Afterward, use the **deploy from file** option. 
    1. Deploy a single-server cluster using PowerShell as per the instructions in the *Azure Stack HCI, version 22H2 deployment guide* for physical hosts.

   > [!NOTE]
   > You must use the sample single node configuration file (see below) since the UX will not allow you to create a single-server configuration file with the current version 22H2 preview builds.

## Appendix I

Modify and use this sample file to deploy a single-server Azure Stack HCI solution using the UX-based deployment tool. If you used a different NAT network, make sure to update the server name in this sample file to match your hostname and your infrastructure subnet.

   ```PowerShell
    {
      {
    "Version": "2.0.0.0",
    "ScaleUnits": [
        {
            "DeploymentData": {
                "DomainFQDN": "contoso.com",
                "SecuritySettings": {
                    "SecurityModeSealed": true,
                    "WDACEnforced": true

                },
                "InternalDomainConfiguration": {
                    "InternalDomainName": "contoso.com",
                    "Timeserver": "40.119.148.38",
                    "DNSForwarder": "10.50.50.50"
                },
                "Observability": {
                    "StreamingDataClient": true,
                    "EULocation": false,
                    "EpisodicDataUpload": true
                },
                "Cluster": {
                    "Name": "s-cluster",
                    "StaticAddress": [
                        ""
                    ]
                },
                "Storage": {
                    "ConfigurationMode": "Express"
                },
                "TimeZone": "Pacific Standard Time",
                "DNSForwarder": [
                    "10.50.50.50"
                ],
                "TimeServer": "40.119.148.38",
                "InfrastructureNetwork": {
                    "VlanId": [
                        8
                    ],
                    "Subnet": [
                        "192.168.0.0/24"
                    ],
                    "Gateway": "192.168.0.1",
                    "StartingAddress": "",
                    "EndingAddress": ""
                },
                "PhysicalNodes": [
                    {
                        "Name": "Node1"
                    }
                ],
                "HostNetwork": {
                    "Intents": [
                        {
                            "Name": "Compute_Storage_Management",
                            "TrafficType": [
                                "Compute",
                                "Storage",
                                "Management"
                            ],
                            "Adapter": [
                                "NIC1",
                                "NIC2"
                            ],
                            "OverrideVirtualSwitchConfiguration": false,
                            "VirtualSwitchConfigurationOverrides": {
                                "EnableIov": "",
                                "LoadBalancingAlgorithm": ""
                            },
                            "OverrideQoSPolicy": false,
                            "QoSPolicyOverrides": {
                                "PriorityValue8021Action_Cluster": "",
                                "PriorityValue8021Action_SMB": "",
                                "BandwidthPercentage_SMB": "",
                                "BandwidthPercentage_Cluster": ""
                            },
                            "OverrideAdapterProperty": false,
                            "AdapterPropertyOverrides": {
                                "EncapOverhead": "",
                                "VlanID": "",
                                "JumboPacket": "",
                                "NetworkDirectTechnology": ""
                            }
                        }
                    ]
                },
                "SDNIntegration": {
                    "Enabled": true,
                    "NetworkControllerName": "nc",
                    "MacAddressPoolStart": "06-EC-00-00-00-01",
                    "MacAddressPoolStop": "06-EC-00-00-FF-FF"
                },
                "OptionalServices": {
                    "VirtualSwitchName": "vSwitch",
                    "CSVPath": "C:\\clusterStorage\\Volume1",
                    "ARBRegion": "eastus"
                },
                "CompanyName": "Microsoft",
                "RegionName": "Redmond",
                "ExternalDomainFQDN": "ext-contoso.com",
                "NamingPrefix": "iastack",
                "Storage1Network": {
                    "VlanId": [
                        108
                    ],
                    "Subnet": [
                        "100.73.16.0/25"
                    ]
                },
                "Storage2Network": {
                    "VlanId": [
                        208
                    ],
                    "Subnet": [
                        "100.73.21.0/25"
                    ]
                }
            }
        }
    ]
 }

 
   ```

## Appendix II

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