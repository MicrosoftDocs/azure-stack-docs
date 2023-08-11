---
title: System requirements for Azure Stack HCI
description: How to choose servers, storage, and networking components for Azure Stack HCI.
author: jasongerend
ms.author: jgerend
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.custom: references_regions
ms.date: 06/14/2023
---

# System requirements for Azure Stack HCI

[!INCLUDE [applies-to](../../includes/hci-applies-to-22h2-21h2.md)]

This article discusses the system requirements for servers, storage, and networking for Azure Stack HCI. Note that if you purchase Azure Stack HCI Integrated System solution hardware from the [Azure Stack HCI Catalog](https://aka.ms/AzureStackHCICatalog), you can skip to the [Networking requirements](#networking-requirements) since the hardware already adheres to server and storage requirements.

## Azure requirements

Here are the Azure requirements for your Azure Stack HCI cluster:

- **Azure subscription**: If you don't already have an Azure account, [create one](https://azure.microsoft.com/). You can use an existing subscription of any type:

   - Free account with Azure credits [for students](https://azure.microsoft.com/free/students/) or [Visual Studio subscribers](https://azure.microsoft.com/pricing/member-offers/credit-for-visual-studio-subscribers/).
   - [Pay-as-you-go](https://azure.microsoft.com/pricing/purchase-options/pay-as-you-go/) subscription with credit card.
   - Subscription obtained through an Enterprise Agreement (EA).
   - Subscription obtained through the Cloud Solution Provider (CSP) program.

- **Azure permissions**: Make sure that you're assigned the following roles in your Azure subscription: User Access Administrator and Contributor. For information on how to assign permissions, see [Assign Azure permissions for registration](../deploy/register-with-azure.md#assign-azure-permissions-for-registration).

- **Azure regions**

   The Azure Stack HCI service is used for registration, billing, and management. It is currently supported in the following regions:

   # [Azure public](#tab/azure-public)

   These public regions support geographic locations worldwide, for clusters deployed anywhere in the world:

   - East US
   - South Central US
   - Canada Central
   - West Europe
   - Southeast Asia
   - Central India
   - Japan East
   - Australia East

   # [Azure China](#tab/azure-china)

   Regions supported in the Azure China cloud:

   - China East 2
   - China North 3

   # [Azure Government](#tab/azure-government)

   Regions supported in the Azure Government cloud:

   - US Gov Virginia

   ---

   Regions supported for additional features of Azure Stack HCI:

   Currently, [Azure Arc VM management](../manage/azure-arc-vm-management-overview.md) supports only the following regions for Azure Stack HCI registration:

   - East US
   - West Europe

## Server requirements

A standard Azure Stack HCI cluster requires a minimum of one server and a maximum of 16 servers.

Keep the following in mind for various types of Azure Stack HCI deployments:

- It's required that all servers be the same manufacturer and model, using 64-bit Intel Nehalem grade, AMD EPYC grade or later compatible processors with second-level address translation (SLAT). A second-generation Intel Xeon Scalable processor is required to support Intel Optane DC persistent memory. Processors must be at least 1.4 GHz and compatible with the x64 instruction set.

- Make sure that the servers are equipped with at least 32 GB of RAM per node to accommodate the server operating system, VMs, and other apps or workloads. In addition, allow 4 GB of RAM per terabyte (TB) of cache drive capacity on each server for Storage Spaces Direct metadata.

- Verify that virtualization support is turned on in the BIOS or UEFI:
    - Hardware-assisted virtualization. This is available in processors that include a virtualization option, specifically processors with Intel Virtualization Technology (Intel VT) or AMD Virtualization (AMD-V) technology.
    - Hardware-enforced Data Execution Prevention (DEP) must be available and enabled. For Intel systems, this is the XD bit (execute disable bit). For AMD systems, this is the NX bit (no execute bit).

- Ensure all the servers are in the same time zone as your local domain controller.

- You can use any boot device supported by Windows Server, which [now includes SATADOM](https://cloudblogs.microsoft.com/windowsserver/2017/08/30/announcing-support-for-satadom-boot-drives-in-windows-server-2016/). RAID 1 mirror is **not** required but is supported for boot. A 200 GB minimum size is recommended.

- For additional feature-specific requirements for Hyper-V, see [System requirements for Hyper-V on Windows Server](/windows-server/virtualization/hyper-v/system-requirements-for-hyper-v-on-windows).

## Storage requirements

Azure Stack HCI works with direct-attached SATA, SAS, NVMe, or persistent memory drives that are physically attached to just one server each.

For best results, adhere to the following:

- Every server in the cluster should have the same types of drives and the same number of each type. It's also recommended (but not required) that the drives be the same size and model. Drives can be internal to the server or in an external enclosure that is connected to just one server. To learn more, see [Drive symmetry considerations](drive-symmetry-considerations.md).

- Each server in the cluster should have dedicated volumes for logs, with log storage at least as fast as data storage. Stretched clusters require at least two volumes: one for replicated data and one for log data.

- SCSI Enclosure Services (SES) is required for slot mapping and identification. Each external enclosure must present a unique identifier (Unique ID). 

   > [!IMPORTANT]
   > **NOT SUPPORTED:** RAID controller cards or SAN (Fibre Channel, iSCSI, FCoE) storage, shared SAS enclosures connected to multiple servers, or any form of multi-path IO (MPIO) where drives are accessible by multiple paths. Host-bus adapter (HBA) cards must implement simple pass-through mode for any storage devices used for Storage Spaces Direct.

## Networking requirements

An Azure Stack HCI cluster requires a reliable high-bandwidth, low-latency network connection between each server node.

- Verify at least one network adapter is available and dedicated for cluster management.
- Verify that physical switches in your network are configured to allow traffic on any VLANs you will use.

For physical networking considerations and requirements, see [Physical network requirements](physical-network-requirements.md).

For host networking considerations and requirements, see [Host network requirements](host-network-requirements.md).

Stretched clusters require servers be deployed at two separate sites. The sites can be in different countries/regions, different cities, different floors, or different rooms. For synchronous replication, you must have a network between servers with enough bandwidth to contain your IO write workload and an average of 5 ms round trip latency or lower. Asynchronous replication doesn't have a latency recommendation.

-	A stretched cluster requires a minimum of 4 servers (2 per site) and a maximum of 16 servers (8 per site). You can’t create a stretched cluster with two single servers.
-	Each site must have the same number of servers and drives.
-	SDN isn’t supported on stretched clusters.

For additional discussion of stretched cluster networking requirements, see [Host network requirements](../concepts/host-network-requirements.md#stretched-clusters).

### Software Defined Networking (SDN) requirements

When you create an Azure Stack HCI cluster using Windows Admin Center, you have the option to deploy Network Controller to enable Software Defined Networking (SDN). If you intend to use SDN on Azure Stack HCI:

- Make sure the host servers have at least 50-100 GB of free space to create the Network Controller VMs.

- You must download a virtual hard disk of the Azure Stack HCI operating system to use for the SDN infrastructure VMs (Network Controller, Software Load Balancer, Gateway). For download instructions, see [Download the VHDX file](../deploy/sdn-wizard.md#download-the-vhdx-file).

For more information about preparing for using SDN in Azure Stack HCI, see [Plan a Software Defined Network infrastructure](plan-software-defined-networking-infrastructure.md) and [Plan to deploy Network Controller](../concepts/network-controller.md).

   > [!NOTE]
   > SDN is not supported on stretched (multi-site) clusters.

### Active Directory Domain requirements

You must have an Active Directory Domain Services (AD DS) domain available for the Azure Stack HCI system to join. There are no special domain functional-level requirements. We do recommend turning on the Active Directory Recycle Bin feature as a general best practice, if you haven't already. To learn more, see [Active Directory Domain Services Overview](/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview).

## Windows Admin Center requirements

If you use Windows Admin Center to [create](../deploy/create-cluster.md) or [manage](../manage/cluster.md) your Azure Stack HCI cluster, make sure to complete the following requirements:

- Install the latest version of Windows Admin Center on a PC or server for management. See [Install Windows Admin Center](/windows-server/manage/windows-admin-center/deploy/install).

- Ensure that Windows Admin Center and your domain controller are not installed on the same instance. Also, ensure that the domain controller is not hosted on the Azure Stack HCI cluster or one of the nodes in the cluster.

- If you're running Windows Admin Center on a server (instead of a local PC), use an account that's a member of the Gateway Administrators group, or the local Administrators group on the Windows Admin Center server.

- Verify that your Windows Admin Center management computer is joined to the same Active Directory domain in which you'll create the cluster, or joined to a fully trusted domain. The servers that you'll cluster don't need to belong to the domain yet; they can be added to the domain during cluster creation.

## Maximum supported hardware specifications

Azure Stack HCI deployments that exceed the following specifications are not supported:

| Resource                     | Maximum |
| ---------------------------- | --------|
| Physical servers per cluster | 16      |
| VMs per host                 | 1,024   |
| Disks per VM (SCSI)          | 256     |
| Storage per cluster          | 4 PB    |
| Storage per server           | 400 TB  |
| Volumes per cluster          | 64      |
| Volume size                  | 64 TB
| Logical processors per host  | 512     |
| RAM per host                 | 24 TB   |
| RAM per VM                   | 12 TB (generation 2 VM) or 1 TB (generation 1)|
| Virtual processors per host  | 2,048   |
| Virtual processors per VM    | 240 (generation 2 VM) or 64 (generation 1)|

## Next steps

For related information, see also:

- [Choose drives](choose-drives.md)
- [Storage Spaces Direct hardware requirements](/windows-server/storage/storage-spaces/storage-spaces-direct-hardware-requirements)
