---
title: System requirements for Azure Local, version 23H2
description: How to choose machines, storage, and networking components for Azure Local, version 23H2.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.custom: references_regions
ms.date: 10/15/2025
---

# System requirements for Azure Local

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

[!INCLUDE [azure-local-banner-23h2](../includes/azure-local-banner-23h2.md)]

This article discusses Azure, machine and storage, networking, and other requirements for Azure Local. If you purchase Integrated System solution hardware from the [Azure Local Catalog](https://aka.ms/AzureStackHCICatalog), you can skip to the [Networking requirements](#networking-requirements) since the hardware already adheres to machine and storage requirements.

## Azure requirements

Here are the Azure requirements for your Azure Local instance:

- **Azure subscription**: If you don't already have an Azure account, [create one](https://azure.microsoft.com/). You can use an existing subscription of any type:

   - Free account with Azure credits [for students](https://azure.microsoft.com/free/students/?cid=msft_learn) or [Visual Studio subscribers](https://azure.microsoft.com/pricing/member-offers/credit-for-visual-studio-subscribers/).
   - [Pay-as-you-go](https://azure.microsoft.com/pricing/purchase-options/pay-as-you-go/) subscription with credit card.
   - Subscription obtained through an Enterprise Agreement (EA).
   - Subscription obtained through the Cloud Solution Provider (CSP) program.

- **Azure permissions**: Make sure that you're assigned the required roles and permissions for registration and deployment. For information on how to assign permissions, see [Assign Azure permissions for registration](../deploy/deployment-arc-register-server-permissions.md).
- **Azure regions**: Azure Local is supported for the following regions:

   # [Azure public](#tab/azure-public)

   These public regions support geographic locations worldwide, for clusters deployed anywhere in the world:

   - East US
   - West Europe
   - Australia East
   - Southeast Asia
   - India Central
   - Canada Central
   - Japan East
   - South Central US


   # [Azure Government](#tab/azure-government)

   Regions supported in the Azure Government cloud:

   - US Gov Virginia

   ---

- **Azure Key Vault**: Make sure to enable public network access when you set up a key vault. This setting allows Azure Local instances to connect to the key vault without any access issues.

## Machine and storage requirements

Microsoft Support may only be provided for Azure Local running on hardware listed in the [Azure Local catalog, or successor](https://aka.ms/azurelocalcatalog).

Before you begin, make sure that the physical machine and storage hardware used to deploy Azure Local meets the following requirements:

|Component|Minimum|
|--|--|
|Number of machines| 1 to 16 machines are supported. <br> Each machine must be the same model, manufacturer, have the same processor types, have the same network adapters, and have the same number and type of storage drives.|
|CPU|A 64-bit Intel Nehalem grade or AMD EPYC or later compatible processor with second-level address translation (SLAT). <br> All the Azure Local machines used to form an Azure Local instance must have the same processor types. |
|Memory|A minimum of 32-GB RAM per machine with Error-Correcting Code (ECC). <br> If you can't meet the memory and the ECC requirements, opt for a [Virtual deployment](../deploy/deployment-virtual.md).|
|Host network adapters|At least two network adapters listed in the Windows Server Catalog. Or dedicated network adapters per intent, which does require two separate adapters for storage intent. For more information, see [Windows Server Catalog](https://www.windowsservercatalog.com/).|
|BIOS|Intel VT or AMD-V must be turned on.|
|Boot drive|A minimum size of 200 GB.<br>400 GB or more recommended for large memory Azure Local instances for [support and diagnosability](#support-and-diagnosability).|
|Data drives|At least two disks per server with a minimum capacity of 500 GB.<br>Same number, type, capacity, performance, and firmware of drives across all servers at time of deployment. Flexibility provided for [Add](../manage/add-server.mdadd-server.md) and [Repair](../manage/repair-server.md) scenarios, when drives at time of deployment are no longer available. |
|Trusted Platform Module (TPM)|TPM version 2.0 hardware must be present and turned on.|
|Secure boot|Secure Boot must be present and turned on.|
|GPU | Optional<br>Up to 192 GB GPU memory per machine. |

The machines should also meet these extra requirements for drives:

- Have direct-attached drives that are physically attached to one machine each. RAID controller cards or SAN (Fibre Channel, iSCSI, FCoE) storage, shared SAS enclosures connected to multiple machines, or any form of multi-path IO (MPIO) where drives are accessible by multiple paths, aren't supported.

    > [!NOTE]
    > Host-bus adapter (HBA) cards must implement simple pass-through mode for any storage devices used for Storage Spaces Direct.

    **Drive Support**

- Supported drives: SATA, SAS, and NVMe (M.2, U.2, and add-in card).

- Supported formats: 512n, 512e, and 4K native.

- NVMe driver is the Microsoft-provided one included in Windows (driver filename is stornvme.sys).

- Flash (NVMe or SSD) must have power-loss protection.

    **Deployment-specific requirements**

- **Single-node**: Use one drive type (NVMe or SSD) with uniform performance characteristics across drives.

- **Multi-node cluster**: Strongly recommend all-flash, single drive type (NVMe or SSD) with uniform performance.

    **Hybrid two-tier requirements for HDD + flash**

- Hybrid two-tier is supported only when using HDD for capacity + flash (NVMe or SSD) for cache.

- Cache devices must be ≥ 32 GB.

For more feature-specific requirements for Hyper-V, see [System requirements for Hyper-V on Windows Server](/windows-server/virtualization/hyper-v/system-requirements-for-hyper-v-on-windows).

## Networking requirements

Azure Local requires connectivity to public endpoints in Azure, see [Firewall requirements](firewall-requirements.md) for details. Multi-machine deployments of Azure Local require a reliable high-bandwidth, low-latency network connection between each machine in the instance.

Verify that physical switches in your network are configured to allow traffic on any VLANs you use. For more information, see [Physical network requirements for Azure Local](../concepts/physical-network-requirements.md).

## Maximum supported hardware specifications

Azure Local deployments that exceed the following specifications are not supported:

| Resource | Maximum |
| --- | --- |
| Physical machines per system |16 |
| Storage per system | 4 PB |
| Storage per machine | 400 TB |
| Volumes per system | 64 |
| Volume size | 64 TB |
| Logical processors per host | 512 |
| RAM per host | 24 TB |
| Virtual processors per host | 2,048 |

## Support and diagnosability

To ensure adequate support and diagnosability for large memory Azure Local instances (those with more than 768 GB of physical memory per machine), we recommend that you install OS disks with a capacity of 400 GB or more. This additional disk capacity provides sufficient space to troubleshoot hardware, driver, or software issues should they require a kernel memory dump to be written to the OS volume.

## Hardware requirements

In addition to Microsoft Azure Local updates, many OEMs also release regular updates for your Azure Local hardware, such as driver and firmware updates. To ensure that OEM package update notifications, reach your organization check with your OEM about their specific notification process.

Before deploying Azure Local, ensure that your hardware is up to date by:

- Determining the current version of your Solution Builder Extension (SBE) package.
- Finding the best method to download, install, and update your SBE package.

### OEM information

This section contains OEM contact information and links to OEM Azure Local reference material.

| Azure Local Solution provider | Solution platform  | How to configure BIOS settings | How to update firmware | How to update drivers | How to update the system after it's running |
|-----------------------|--------------------|--------------------------------|------------------------|-----------------------|-----------------------------------------------|
| Bluechip              | SERVERline R42203a *Certified for Azure Local*   | [bluechip Service & Support](https://service.bluechip.de/)     | [bluechip Service & Support](https://service.bluechip.de/) | [bluechip Service & Support](https://service.bluechip.de/) | [bluechip Service & Support](https://service.bluechip.de/) |
| DataON                | AZS-XXXX    | [AZS-XXXX BIOS link](https://www.dataonstorage.com/ir72)     | [AZS-XXXX driver link](https://www.dataonstorage.com/469v) | [AZS-XXXX driver link](https://www.dataonstorage.com/469v)| [AZS-XXXX update link](https://www.dataonstorage.com/9kto) |
| primeLine             | All models  | [Contact primeLine service](https://www.primeline-solutions.com/de/kontakt-und-service/)   | [Contact primeLine service](https://www.primeline-solutions.com/de/kontakt-und-service/)  | [Contact primeLine service](https://www.primeline-solutions.com/de/kontakt-und-service/) |     |
| Supermicro            | BigTwin 2U 2-Node   | [Configure BIOS settings](https://www.supermicro.com/en/support/resources/downloadcenter/firmware/MBD-X11DPT-B/BIOS)   | [Firmware update process](https://www.supermicro.com/en/support/resources/downloadcenter/firmware/MBD-X11DPT-B/BMC)    | [Driver update process](https://www.supermicro.com/wdl/CDR_Images/CDR-X11/)     |     |
| Thomas-krenn          | All models    | [Configure BIOS settings](https://thomas-krenn.com/azshci-bios)   | [Firmware update process](https://thomas-krenn.com/azshci-driver)  | [Driver update process](https://thomas-krenn.com/azshci-driver)  |    |

For a comprehensive list of all OEM contact information, download the [Azure Local OEM Contact](https://github.com/Azure/AzureStack-Tools/raw/master/HCI/azure-stack-hci-oem-contact-and-material.xlsx) spreadsheet.

### BIOS setting

Check with your OEM regarding the necessary generic BIOS settings for Azure Local. These settings may include hardware virtualization, TPM enabled, and secure core.

## Driver

Check with your OEM regarding the necessary drivers that need to be installed for Azure Local. Additionally, your OEM can provide you with their preferred installation steps.

### Driver installation steps

You should always follow the OEM's recommended installation steps. If the OEM's guidance isn't available, see the following steps:

1. Identify the **Ethernet** using this command:

    ```powershell
    Get-NetAdapter
    ```

    Here's a sample output:

    ```console
    PS C:\Windows\system32>	get-netadapter
    
    Name	                      InterfaceDescription	                iflndex     Status	     MacAddress	            LinkSpeed
    vSMB(compute managemen…	      Hyper-V Virtual Ethernet Adapter #2	    20      Up	         00-15-5D-20-40-00	    25 Gbps
    vSMB(compute managemen…	      Hyper-V Virtual Ethernet Adapter #3	    24      Up	         00-15-5D-20-40-01	    25 Gbps
    ethernet	                  HPE Ethernet 10/25Gb 2-port 640FLR…#2	     7      Up	         B8-83-03-58-91-88	    25 Gbps
    ethernet 2	                  HPE Ethernet 10/25Gb 2-port 640FLR-S…	     5      Up	         B8 83-03-58-91-89	    25 Gbps
    vManagement(compute_ma…	      Hyper-V Virtual Ethernet Adapter	        14      Up	         B8-83-03-58-91-88	    25 Gbps
    ```

2. Identify the **DriverFileName**, **DriverVersion**, **DriverDate**, **DriverDescription**, and the **DriverProvider** using this command:

    ```powershell
    Get-NetAdapter -name ethernet | select *driver*
    ```

    Here's a sample output:

    ```console
    PS C:\Windows\system32> Get-NetAdapter -name ethernet | select *driver*

    DriverInformation		: Driver Date 2021-07-08 Version 2.70.24728.0 NDIS 6.85
    DriverFileName			: mlx5.sys
    DriverVersion			: 2.70.24728.0
    DriverDate			    : 2021-07-08
    DriverDateData			: 132701760000000000
    DriverDescription		: HPE Ethernet 10/25Gb 2-port 640FLR-SFP28 Adapter
    DriverMajorNdisVersion	: 6
    DriverMinorNdisVersion 	: 85
    DriverName			    : \SystemRoot\System32\drivers\mlx5.sys
    DriverProvider			: Mellanox Technologies Ltd.
    DriverVersionString		: 2.70.24728.0
    MajorDriverVersion		: 2
    MinorDriverVersion		: 0
    ```

3. Search for your driver and the recommended installation steps.

4. Download your driver.

5. Install the driver identified in Step #2 by **DriverFileName** on all machines of the system. For more information, see [PnPUtil Examples - Windows Drivers](/windows-hardware/drivers/devtest/pnputil-examples#add-driver).

    Here's an example:

    ```powershell
    pnputil /add-driver mlx5.inf /install
    ```

6. Check to be sure the drivers are updated by reviewing **DriverVersion** and **DriverDate**.

    ```powershell
    Get-NetAdapter -name ethernet | select *driver*
    ```

     Here's are some sample outputs:

    ```console
    PS C:\Windows\system32> Get-NetAdapter -name ethernet | select *driver*

    DriverInformation		: Driver Date 2023-05-03 Version 23.4.26054.0 NDIS 6.85
    DriverFileName			: mlx5.sys
    DriverVersion			: 23.4.26054.0
    DriverDate			    : 2023-05-03
    DriverDateData			: 133275456000000000
    DriverDescription		: HPE Ethernet 10/25Gb 2-port 640FLR-SFP28 Adapter
    DriverMajorNdisVersion	: 6
    DriverMinorNdisVersion 	: 85
    DriverName			    : \SystemRoot\System32\drivers\mlx5.sys
    DriverProvider			: Mellanox Technologies Ltd.
    DriverVersionString		: 23.4.26054.0
    MajorDriverVersion		: 2
    MinorDriverVersion		: 0
    ```

    ```console
    PS C:\Windows\system32> Get-NetAdapter "ethernet 2" | select *driver*

    DriverInformation		: Driver Date 2023-05-03 Version 23.4.26054.0 NDIS 6.85
    DriverFileName			: mlx5.sys
    DriverVersion			: 23.4.26054.0
    DriverDate			    : 2023-05-03
    DriverDateData			: 133275456000000000
    DriverDescription		: HPE Ethernet 10/25Gb 2-port 640FLR-SFP28 Adapter
    DriverMajorNdisVersion	: 6
    DriverMinorNdisVersion 	: 85
    DriverName			    : \SystemRoot\System32\drivers\mlx5.sys
    DriverProvider			: Mellanox Technologies Ltd.
    DriverVersionString		: 23.4.26054.0
    MajorDriverVersion		: 2
    MinorDriverVersion		: 0
    ```

## Firmware

Check with your OEM regarding the necessary firmware that needs to be installed for Azure Local. Additionally, your OEM can provide you with their preferred installation steps.

## Drivers and firmware via the Windows Admin Center extension

You should always follow the OEM's recommended installation steps. With Azure Local, Windows Admin Center plugins can be used to install drivers and firmware. For a comprehensive list of all OEM contact information, download the [Azure Local OEM Contact](https://github.com/Azure/AzureStack-Tools/raw/master/HCI/azure-stack-hci-oem-contact-and-material.xlsx) spreadsheet.

<!--|OEM    | Download link                                                    |
|-------|------------------------------------------------------------------|
|HPE    | [HPE Extensions for Microsoft Windows Admin Center](https://www.hpe.com/us/en/alliance/microsoft/ws-admin-center.html) |
|Dell   | [Dell OpenManage Integration with Microsoft Windows Admin Center](https://www.dell.com/support/kbdoc/en-us/000177828/support-for-dell-emc-openmanage-integration-with-microsoft-windows-admin-center)|
|Lenovo | [Lenovo XClarity Integrator for Microsoft Windows Admin Center](https://support.lenovo.com/us/en/solutions/ht507549-lenovo-xclarity-integrator-for-microsoft-windows-admin-center-v21) -->

## Next steps

Review firewall, physical network, and host network requirements:

- [Firewall requirements](./firewall-requirements.md).
- [Physical network requirements](./physical-network-requirements.md).
- [Host network requirements](./host-network-requirements.md).
