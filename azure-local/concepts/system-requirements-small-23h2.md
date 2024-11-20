---
title: System requirements for small deployments of Azure Local, version 23H2 (preview)
description: How to choose machines, storage, and networking components for small deployments of Azure Local, version 23H2 (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack-hci
ms.custom: references_regions
ms.date: 11/19/2024
---

# System requirements for small form factor deployments of Azure Local, version 23H2 (preview)

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes the requirements for machines, storage, and networking for building solutions of Azure Local that use the small form factor hardware. If you purchase class *small* hardware from the [Azure Local Catalog](https://aka.ms/AzureStackHCICatalog), ensure that these requirements are met before you deploy the Azure Local solutions.

[!INCLUDE [important](../includes/hci-preview.md)]

## About the small hardware class

Azure Local supports a new class of devices with reduced hardware requirements. This new, low-cost hardware class referenced as *small* is suited for various edge scenarios across the industry horizontals. To ensure compatibility, interoperability, security, and reliability, this class of hardware must meet Azure Local solution requirements.

The certified devices are listed in the [Azure Local Catalog](https://aka.ms/AzureStackHCICatalog).

## Device requirements

The device must be listed in the [Azure Local Catalog](https://aka.ms/AzureStackHCICatalog) which indicates that the device has passed the Windows Server certification and the extra qualifications.

The following table lists the requirements for the small hardware:

| Component | Description |
|-----------|-------|
| Number of machines | 1 to 3 machines are supported. Each machine must be the same model, manufacturer, have the same network adapters, and have the same number and type of storage drives. |
| CPU | An Intel Xeon or AMD EPYC or later compatible processor with second-level address translation (SLAT). <br> Up to 14 physical cores |
| Memory | A minimum of 32 GB per machine and a maximum of 128 GB per machine with EEC. |
| Host network adapters | 1 network adapter that meets the [Azure Local host network requirements](./host-network-requirements.md)<br> Enabling RDMA on storage intend is not required.<br> Minimum link speed must be 1 Gbit/s. |
| BIOS | Intel VT or AMD-V must be turned on.|
| Boot drive | A minimum size of 200 GB.|
| Data drives | A minimum single disk of capacity 1 TB. <br> The drives must be all flash single drive type, either Nonvolatile Memory Express (NVME) or Solid-State Drive (SSD). <br> All the drives must be of the same type. <br> No caching. |
| Trusted Platform Module (TPM) | TPM version 2.0 hardware must be present and enabled. |
| Secure Boot | Secure Boot must be present and turned on. |
| Storage Controller | Pass-through. <br> RAID controller cards or SAN (Fibre Channel, iSCSI, FCoE) aren't supported. |
| GPU | Optional<br>Up to 192 GB GPU memory per machine. |

>[!IMPORTANT]
> For 2411 release, Update, `Add-server`, and `Repair-server` operations aren't supported for the small hardware class.

## Storage requirements

The storage subsystem for an Azure Local running Azure Stack HCI OS is layered on top of Storage Space Direct. When building a solution using class *small* hardware:

- A minimum of one data drive is required to create a storage pool.
- All drives in the pool must be of the same type, either NVMe or SSD.
- Remember that mixing drive types for caching (NVMe and SSD, or SSD and HDD) isn't supported.

The supported volume configuration for the system is:

- A single, 250 GB, fixed infrastructure volume.

### Supported sample storage configurations

| Node count | Disk count | Disk type | Volume resiliency level | Sustain faults |
|------------|------------|-----------|-------------------------|----------------|
| 1 | 1 | NVMe or SSD | Simple | None |
| 2 | 1 | NVMe or SSD | Two way mirror | Single fault (drive or node) |
| 3 | 1 | NVMe or SSD | Two way mirror | Single fault (drive or node) |
| 1 | 2 | NVMe or SSD | Two way mirror | Single fault (drive) |
| 2 | 2 | NVMe or SSD | Two way mirror | Two faults (drive and node) |
| 3 | 2 | NVMe or SSD | Three way mirror | Two faults |

## Networking requirements

Network adapters must meet the Azure Local host network requirements. This requirement ensures compatibility and reliability with Hyper-V and also controls how the adapter properties are exposed by the driver (VLAN ID, RSS, VMQ).

The reduced networking requirements are as follows:

- Storage intent doesn't require RDMA to be enabled.
- Single link is needed.
- Minimum link speed of 1 Gbit/s is required.
- A Layer 2 switch with VLAN support is required.

Removal of RDMA allows the use of a layer 2 network switch with VLAN support. This further simplifies the configuration management and reduces the overall solution cost.

### Supported sample network configurations

| Link count | Intent | Switch type | Sustain faults |
|------------|--------|-------------|----------------|
| 2 | Single intent | Switch | Single fault |
| 2 | Two intents | Switch | None |
| 4 | Two intents | Switch | Single fault |
| 3 | Three intents | Switch | None |
| 2 | Two intents | No switch for storage | None |
| 4 | Two intents | No switch for storage | Single fault |
| 6 | Three intents | No switch for storage | Single fault |

## Considerations

Following are some workload considerations for building a solution using the small hardware class:

- Baseline workload IOP requirements for sizing storage configuration to see if small hardware class is the right fit.
- vCPU requirements and target ratio due to lower total physical cores when using small hardware class.
- Total memory requirement with three servers using small hardware class. Keep capacity work one node free for update runs and failure scenarios.
- Network bandwidth requirements.
- The VM creation time is critical as it's influenced by network bandwidth.

### Availability

- Spare part logistics to remediate failures timely.
- Part replacement and identification for non-hot swap components.


<!--## Azure requirements

Here are the Azure requirements for your Azure Local instance:

- **Azure subscription**: If you don't already have an Azure account, [create one](https://azure.microsoft.com/). You can use an existing subscription of any type:

   - Free account with Azure credits [for students](https://azure.microsoft.com/free/students/) or [Visual Studio subscribers](https://azure.microsoft.com/pricing/member-offers/credit-for-visual-studio-subscribers/).
   - [Pay-as-you-go](https://azure.microsoft.com/pricing/purchase-options/pay-as-you-go/) subscription with credit card.
   - Subscription obtained through an Enterprise Agreement (EA).
   - Subscription obtained through the Cloud Solution Provider (CSP) program.

- **Azure permissions**: Make sure that you're assigned the required roles and permissions for registration and deployment. For information on how to assign permissions, see [Assign Azure permissions for registration](../deploy/deployment-arc-register-server-permissions.md#assign-required-permissions-for-deployment).

- **Azure regions**: Azure Local is supported for the following regions:

   - East US
   - West Europe
   - Australia East
   - Southeast Asia
   - India Central
   - Canada Central
   - Japan East
   - South Central US


    > [!NOTE]
    > Host-bus adapter (HBA) cards must implement simple pass-through mode for any storage devices used for Storage Spaces Direct.

For more feature-specific requirements for Hyper-V, see [System requirements for Hyper-V on Windows Server](/windows-server/virtualization/hyper-v/system-requirements-for-hyper-v-on-windows).

## Networking requirements

An Azure Local instance requires a reliable high-bandwidth, low-latency network connection between each machine.

Verify that physical switches in your network are configured to allow traffic on any VLANs you use. For more information, see [Physical network requirements for Azure Local](../concepts/physical-network-requirements.md). -->


## Next steps

Review firewall, physical network, and host network requirements:

- [Firewall requirements](./firewall-requirements.md).
- [Physical network requirements](./physical-network-requirements.md).
- [Host network requirements](./host-network-requirements.md).
