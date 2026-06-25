---
title: System requirements for Azure Local
description: How to choose machines, storage, and networking components for Azure Local.
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.service: azure-local
ms.custom: references_regions
ms.date: 05/04/2026
ms.subservice: hyperconverged
---

# System requirements for Azure Local

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article discusses Azure, machine and storage, networking, and other requirements for hyperconvered deployments of Azure Local. If you purchased Integrated System solution hardware from the [Azure Local Catalog](https://aka.ms/AzureStackHCICatalog), you can skip to the [Networking requirements](#networking-requirements) since the hardware already adheres to machine and storage requirements.

## Azure requirements

Here are the Azure requirements for your Azure Local instance:

- **Azure subscription**: If you don't already have an Azure account, [create one](https://azure.microsoft.com/). You can use an existing subscription of any type:

   - Free account with Azure credits [for students](https://azure.microsoft.com/free/students/?cid=msft_learn) or [Visual Studio subscribers](https://azure.microsoft.com/pricing/member-offers/credit-for-visual-studio-subscribers/).
   - [Pay-as-you-go](https://azure.microsoft.com/pricing/purchase-options/pay-as-you-go/) subscription with credit card.
   - Subscription obtained through an Enterprise Agreement (EA).
   - Subscription obtained through the Cloud Solution Provider (CSP) program.
   
   For more information, see [Microsoft Product Terms > Online Services > Azure](https://www.microsoft.com/licensing/terms/productoffering/MicrosoftAzure/) and select your licensing program.

- **Azure permissions**: Verify that you have the required roles and permissions for registration and deployment. For information on how to assign permissions, see [Assign Azure permissions for registration](../deploy/deployment-arc-register-server-permissions.md).
- **Azure regions**: Azure Local is supported for the following regions:

  ### [Azure public](#tab/azure-public)

   These public regions support geographic locations worldwide, for clusters deployed anywhere in the world:

   - East US
   - West Europe
   - Australia East
   - Southeast Asia
   - India Central
   - Canada Central
   - Japan East
   - South Central US

  ### [Azure Government](#tab/azure-government)

   Regions supported in the Azure Government cloud:

   - US Gov Virginia

   ---

- **Azure Key Vault**: Make sure to enable public network access when you set up a key vault. This setting allows Azure Local instances to connect to the key vault without any access issues.

## Machine and storage requirements

Microsoft Support may only be provided for Azure Local running on hardware listed in the [Azure Local catalog](https://aka.ms/azurelocalcatalog).

Before you begin, make sure that the physical machine and storage hardware used to deploy disaggregated Azure Local meets the following requirements:

|Component|Minimum|
|--|--|
|Number of machines| 1 to 64 machines are supported. <br> Each machine must be the same model, manufacturer, have the same processor types, have the same network adapters, and have the same number and type of storage drives.|
|CPU|A 64-bit Intel Nehalem grade or AMD EPYC or later compatible processor with second-level address translation (SLAT). <br> All the Azure Local machines used to form an Azure Local instance must have the same processor types. |
|Memory|A minimum of 32-GB RAM per machine with Error-Correcting Code (ECC). <br> If you can't meet the memory and the ECC requirements, opt for a [Virtual deployment](../deploy/deployment-virtual.md).|
|Host network adapters|At least two network adapters listed in the Windows Server Catalog. Or dedicated network adapters per intent, which does require two separate adapters for storage intent. For more information, see [Windows Server Catalog](https://www.windowsservercatalog.com/).|
|BIOS|Intel VT or AMD-V must be turned on.|
|Boot drive|A minimum size of 200 GB.<br>400 GB or more recommended for large memory Azure Local instances for [support and diagnosability](#support-and-diagnosability).|
|Data drives|At least two disks per server with a minimum capacity of 500 GB.<br>Same number, type, capacity, performance, and firmware of drives across all servers at time of deployment. Flexibility provided for [Add](../manage/add-server.md) and [Repair](../manage/repair-server.md) scenarios, when drives at time of deployment are no longer available. |
|Trusted Platform Module (TPM)|TPM version 2.0 hardware must be present and turned on.|
|Secure boot|Secure Boot must be present and turned on.|
|SAN | At minimum one LUN with 250GB for infrastructure services and one with 20GB used for performance history data |
|GPU | Optional<br>Up to 192 GB GPU memory per machine. |

## Data drive requirements

The following drive requirements apply to Azure Local and supersede the requirements for Windows Server.


- For Storage Spaces Direct, drives must be direct‑attached and physically connected to a single machine.
- Host bus adapter (HBA) cards must support simple pass‑through mode for any storage devices used with Storage Spaces Direct.
- RAID controller cards, SAN storage (Fibre Channel, iSCSI, or FCoE), shared SAS enclosures connected to multiple machines, and any form of multipath I/O (MPIO) where drives are accessible through multiple paths are not supported.

Exceptions exist for SAN configurations using Fibre Channel. For more information, see [*Use of Azure Local with external SAN storage](#use-of-azure-local-with-external-san-storage).

| Category | Requirements |
|---------|--------------|
| **Drive Support** | - SATA, SAS, NVMe (M.2, U.2, add‑in card)<br>- Supported formats: 512n, 512e, 4K native |
| **Deployment Requirements** | **Single‑node:** One drive type (NVMe or SSD) with uniform performance.<br>**Multi‑node cluster:** Strongly recommended: all‑flash, single drive type (NVMe or SSD) with uniform performance. |
| **Hybrid Two‑Tier (HDD + Flash)** | - Supported only with HDD for capacity + flash (NVMe or SSD) for cache.<br>- Cache devices ≥ 32 GB.<br>- Cache‑to‑capacity ratio ≥ 15%.<br>- Cache endurance recommended: ≥ 3 DWPD or ≥ 4 TBW/day.<br>- Number of capacity drives should be a whole multiple of cache drives. |
| **NVMe Driver** | Uses Microsoft‑provided driver (`stornvme.sys`). The improved StorNVMe driver, available for Windows Server is not supported at this time. |
| **Flash Requirements** | Flash (NVMe or SSD) must include power‑loss protection. |

For more feature-specific requirements for Hyper-V, see [System requirements for Hyper-V on Windows Server](/windows-server/virtualization/hyper-v/system-requirements-for-hyper-v-on-windows).

### Use of Azure Local with external SAN storage

Azure Local supports the use of additional SAN storage via Fibre Channel (FC). For certified solutions, consult your Original Equipment Manufacturer (OEM). For more information, see [External Storage Support for Azure Local](../concepts/external-storage-support.md).

Storage Spaces Direct remains required, at a minimum, for the Azure Local infrastructure volume and for [cluster performance history](/windows-server/storage/storage-spaces/performance-history).

A minimum amount of available Storage Spaces Direct capacity is required, including at least two physical disks per node. All previously stated requirements for Storage Spaces Direct still apply, except where external SAN storage is used.

## Networking requirements

Azure Local requires connectivity to public endpoints in Azure, see [Firewall requirements](firewall-requirements.md) for details. Multi-machine deployments of Azure Local require a reliable high-bandwidth, low-latency network connection between each machine in the instance.

### Bandwidth requirements

For hyperconverged clusters, limited-bandwidth connections, like rural T1 lines or satellite/cellular connections, are adequate for Azure Local to sync. The minimum required connectivity is 10 Mbit. More services might require extra bandwidth, especially to replicate or back up whole VMs, download large software updates, or upload verbose logs for analysis and monitoring in the cloud.

## Maximum supported hardware specifications

Azure Local disaggregated deployments that exceed the following specifications are not supported:

| Resource | Maximum |
| --- | --- |
| Physical machines per system |64 |
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

## BIOS setting

Check with your OEM regarding the necessary generic BIOS settings for Azure Local. These settings may include hardware virtualization, TPM enabled, and secure core.

### BIOS resets

If the BIOS, Secure Boot, or TPM is reset, consult your OEM to ensure that the required optimized settings are applied.

Suboptimal configuration can negatively affect performance, for example, networking, SR-IOV, and Azure Local security features such as Secured-core and BitLocker. Incorrect settings can also cause instance deployments to fail.

## Manage drivers and firmware

> [!IMPORTANT]
> Check with your OEM regarding the necessary drivers that need to be installed for Azure Local. Additionally, your OEM can provide you with their preferred installation steps.

It is imperative to adhere to the recommended installation steps stipulated by the OEM.
For Integrated and Validated Solutions, verify the respective compatibility matrix of the SBE package matching the node, and the deployed or to be updated Azure Local solution version.
A driver and firmware compatibility matrix, when provided by the OEM, should be qualified for deployed or to be updated Azure Local solution version.

### Driver and firmware updates using Windows Admin Center extensions

> [!IMPORTANT]
> Starting with Azure Local 23H2, Windows Admin Center extensions are no longer supported for installing drivers and firmware. However, it is still safe to use these extensions on certified Azure Local nodes running Windows Server with Storage Spaces Direct.

### Initial deployment

- **Premier solutions and integrated systems:** These solutions are delivered preinstalled and preconfigured. Firmware and driver updates are applied automatically.
- **Validated nodes:** These nodes may come preinstalled. A driver and firmware check, or additional sideloading of update packages, may be required based on OEM recommendations.

### Instance or node redeployment

- **Premier solutions and integrated systems:** Some OEMs provide ready-to-use ISO images that match the preinstalled and preconfigured version.
- **Validated nodes:** These nodes may come preinstalled. A driver check using PowerShell or additional sideloading of update packages may be required, in accordance with OEM recommendations.

### Update existing firmware and drivers

- **Premier solutions:** Firmware and driver updates are applied automatically through Azure Update Manager as part of the automated update process.
- **Integrated systems and validated nodes:** These configurations require manual updates. It is recommended to update firmware and drivers before deployment. Use OEM‑provided Solution Builder Extensions (SBE) packages appropriate for your solution type, and consult your OEM documentation for additional guidance.

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

1. Identify the **DriverFileName**, **DriverVersion**, **DriverDate**, **DriverDescription**, and the **DriverProvider** using this command:

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

1. Search for your driver and the recommended installation steps.

1. Download your driver.

1. Install the driver identified in Step #2 by **DriverFileName** on all machines of the system. For more information, see [PnPUtil Examples - Windows Drivers](/windows-hardware/drivers/devtest/pnputil-examples#add-driver).

    Here's an example:

    ```powershell
    pnputil /add-driver mlx5.inf /install
    ```

1. Check to be sure the drivers are updated by reviewing **DriverVersion** and **DriverDate**.

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

## OEM information

This section contains OEM contact information and links to OEM Azure Local reference material.

OEMs can provide technical training, certification, and deployment guidance that complement the Microsoft deployment documentation. This guidance may include white papers or deployment guides.

| Azure Local Solution provider | Solution platform | How to configure BIOS settings | How to update firmware | How to update drivers | How to update the system after it's running |
|--|--|--|--|--|--|
| Bluechip | SERVERline R42203a *Certified for Azure Local* | [bluechip Service & Support](https://service.bluechip.de/) | [bluechip Service & Support](https://service.bluechip.de/) | [bluechip Service & Support](https://service.bluechip.de/) | [bluechip Service & Support](https://service.bluechip.de/) |
| DataON | AZS-XXXX | [AZS-XXXX BIOS link](https://www.dataonstorage.com/ir72) | [AZS-XXXX driver link](https://www.dataonstorage.com/469v) | [AZS-XXXX driver link](https://www.dataonstorage.com/469v) | [AZS-XXXX update link](https://www.dataonstorage.com/9kto) |
| primeLine | All models | [Contact primeLine service](https://www.primeline-solutions.com/de/kontakt-und-service/) | [Contact primeLine service](https://www.primeline-solutions.com/de/kontakt-und-service/) | [Contact primeLine service](https://www.primeline-solutions.com/de/kontakt-und-service/) |  |
| Supermicro | BigTwin 2U 2-Node | [Configure BIOS settings](https://www.supermicro.com/en/support/resources/downloadcenter/firmware/MBD-X11DPT-B/BIOS) | [Firmware update process](https://www.supermicro.com/en/support/resources/downloadcenter/firmware/MBD-X11DPT-B/BMC) | [Driver update process](https://www.supermicro.com/wdl/CDR_Images/CDR-X11/) |  |
| Thomas-krenn | All models | [Configure BIOS settings](https://thomas-krenn.com/azshci-bios) | [Firmware update process](https://thomas-krenn.com/azshci-driver) | [Driver update process](https://thomas-krenn.com/azshci-driver) |  |

For a comprehensive list of all OEM contact information, download the [Azure Local OEM Contact](https://github.com/Azure/AzureStack-Tools/raw/master/HCI/azure-stack-hci-oem-contact-and-material.xlsx) spreadsheet.

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