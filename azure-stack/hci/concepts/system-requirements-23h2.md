---
title: System requirements for Azure Stack HCI, version 23H2
description: How to choose servers, storage, and networking components for Azure Stack HCI, version 23H2.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.custom: references_regions
ms.date: 01/26/2024
---

# System requirements for Azure Stack HCI, version 23H2

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article discusses the system requirements for servers, storage, and networking for Azure Stack HCI. Note that if you purchase Azure Stack HCI Integrated System solution hardware from the [Azure Stack HCI Catalog](https://aka.ms/AzureStackHCICatalog), you can skip to the [Networking requirements](#networking-requirements) since the hardware already adheres to server and storage requirements.

## Azure requirements

Here are the Azure requirements for your Azure Stack HCI cluster:

- **Azure subscription**: If you don't already have an Azure account, [create one](https://azure.microsoft.com/). You can use an existing subscription of any type:

   - Free account with Azure credits [for students](https://azure.microsoft.com/free/students/) or [Visual Studio subscribers](https://azure.microsoft.com/pricing/member-offers/credit-for-visual-studio-subscribers/).
   - [Pay-as-you-go](https://azure.microsoft.com/pricing/purchase-options/pay-as-you-go/) subscription with credit card.
   - Subscription obtained through an Enterprise Agreement (EA).
   - Subscription obtained through the Cloud Solution Provider (CSP) program.

- **Azure permissions**: Make sure that you're assigned the required roles and permissions for registration and deployment. For information on how to assign permissions, see [Assign Azure permissions for registration](../deploy/deployment-arc-register-server-permissions.md#assign-required-permissions-for-deployment).

- **Azure regions**: The Azure Stack HCI service and [Azure Arc VM management](../manage/azure-arc-vm-management-overview.md) are together supported for the following regions:

   - East US
   - West Europe

## Server and storage requirements

Before you begin, make sure that the physical server and storage hardware used to deploy an Azure Stack HCI cluster meets the following requirements:

|Component|Minimum|
|--|--|
|Number of servers| 1 to 16 servers are supported. <br> Each server must be the same model, manufacturer, have the same network adapters, and have the same number and type of storage drives.|
|CPU|A 64-bit Intel Nehalem grade or AMD EPYC or later compatible processor with second-level address translation (SLAT).|
|Memory|A minimum of 32 GB RAM per node.|
|Host network adapters|At least two network adapters listed in the Windows Server Catalog. Or dedicated network adapters per intent, which does require two separate adapters for storage intent. For more information, see [Windows Server Catalog](https://www.windowsservercatalog.com/).|
|BIOS|Intel VT or AMD-V must be turned on.|
|Boot drive|A minimum size of 200 GB size.|
|Data drives|At least 2 disks with a minimum capacity of 500 GB (SSD or HDD).|
|Trusted Platform Module (TPM)|TPM version 2.0 hardware must be present and turned on.|
|Secure boot|Secure Boot must be present and turned on.|

The servers should also meet the following additional requirements: 

- Each server should have dedicated volumes for logs, with log storage at least as fast as data storage. 

- Have direct-attached drives that are physically attached to one server each. RAID controller cards or SAN (Fibre Channel, iSCSI, FCoE) storage, shared SAS enclosures connected to multiple servers, or any form of multi-path IO (MPIO) where drives are accessible by multiple paths, are not supported.

    > [!NOTE]
    > Host-bus adapter (HBA) cards must implement simple pass-through mode for any storage devices used for Storage Spaces Direct.

- For additional feature-specific requirements for Hyper-V, see [System requirements for Hyper-V on Windows Server](/windows-server/virtualization/hyper-v/system-requirements-for-hyper-v-on-windows).


## Networking requirements

An Azure Stack HCI cluster requires a reliable high-bandwidth, low-latency network connection between each server node.

- Verify that physical switches in your network are configured to allow traffic on any VLANs you will use.

<!--## Maximum supported hardware specifications

Azure Stack HCI deployments that exceed the following specifications are not supported:

| Resource                     | Maximum |
| ---------------------------- | --------|
| Physical servers per cluster | 16      |
| VMs per host                 | 1,024   |
| Disks per VM (SCSI)          | 256     |
| Storage per cluster          | 4 PB    |
| Storage per server           | 400 TB  |
| Volumes per cluster          | 64      |
| Volume size                  | 64 TB   |
| Logical processors per host  | 512     |
| RAM per host                 | 24 TB   |
| RAM per VM                   | 12 TB (generation 2 VM) or 1 TB (generation 1)|
| Virtual processors per host  | 2,048   |
| Virtual processors per VM    | 240 (generation 2 VM) or 64 (generation 1)|-->

## Next steps

Review firewall, physical network, and host network requirements:

- [Firewall requirements](./firewall-requirements.md).
- [Physical network requirements](./physical-network-requirements.md).
- [Host network requirements](./host-network-requirements.md).

