---
title: System requirements for low capacity deployments of Azure Local (preview)
description: How to choose machines, storage, and networking components for low capacity deployments of Azure Local (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.custom: references_regions
ms.date: 05/07/2025
---

# System requirements for low capacity deployments of Azure Local (Preview)

::: moniker range=">=azloc-2411"

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes the requirements for machines, storage, and networking for building solutions of Azure Local that use lower capacity hardware. If you purchase lower capacity hardware from the [Azure Local Catalog](https://aka.ms/azurelocalcatalog), ensure that these requirements are met before you deploy the Azure Local solutions.

[!INCLUDE [important](../includes/hci-preview.md)]

## About the low capacity class

Azure Local supports a new class of devices with reduced hardware requirements. This new, low-cost hardware class called *low capacity* is suited for various edge scenarios across industry. To ensure compatibility, interoperability, security, and reliability, this class of hardware must meet Azure Local solution requirements.

## Device requirements

Microsoft Support may only be provided for Azure Local running on hardware listed in the [Azure Local catalog, or successor](https://aka.ms/azurelocalcatalog).

The following table lists the requirements for low capacity hardware:

| Component | Description |
|-----------|-------|
| Number of machines | One to three machines are supported. Each machine must be the same model, manufacturer, have the same network adapters, and have the same number and type of storage drives. |
| CPU | An Intel Xeon or AMD EPYC or later compatible processor with second-level address translation (SLAT). <br> Up to 14 physical cores |
| Memory | A minimum of 32 GB per machine and a maximum of 128 GB per machine with Error-Correcting Code (ECC). |
| Host network adapters | One network adapter that meets the [Azure Local host network requirements](./host-network-requirements.md)<br> Enabling RDMA on storage intent isn't required.<br> Minimum link speed must be 1 Gbps for single node deployment.<br>In two or three node deployments, a dedicated network port for storage with minimum 10 Gbps is required.   |
| BIOS | Intel VT or AMD-V must be turned on.|
| Boot drive | A minimum size of 200 GB.|
| Data drives | A minimum single disk of capacity 1 TB. <br> The drives must be all flash single drive type, either Nonvolatile Memory Express (NVME) or Solid-State Drive (SSD). <br> All the drives must be of the same type. <br> No caching. |
| Trusted Platform Module (TPM) | TPM version 2.0 hardware must be present and enabled. |
| Secure Boot | Secure Boot must be present and turned on. |
| Storage Controller | Pass-through. <br> RAID controller cards or SAN (Fibre Channel, iSCSI, FCoE) aren't supported. |
| GPU | Optional<br>Up to 192-GB GPU memory per machine. |

## Storage requirements

The storage subsystem for an Azure Local running the Azure Stack HCI OS is layered on top of Storage Spaces Direct. When building a solution using class *low capacity* hardware:

- A minimum of one data drive is required to create a storage pool.
- All drives in the pool must be of the same type, either NVMe or SSD.
- Mixing drive types used for caching (NVMe and SSD) isn't supported. It is supported for the boot drive however.  

The supported volume configuration for the system is:

- A single, 250 GB, fixed infrastructure volume.

### Supported sample storage configurations

| Nodes | Disks | Disk type | Volume resiliency level | Sustain faults |
|------------|------------|-----------|-------------------------|----------------|
| 1 | 1 | NVMe or SSD | Simple | None |
| 2 | 1 | NVMe or SSD | Two way mirror | Single fault (drive or node) |
| 3 | 1 | NVMe or SSD | Two way mirror | Single fault (drive or node) |
| 1 | 2 | NVMe or SSD | Two way mirror | Single fault (drive) |
| 2 | 2 | NVMe or SSD | Two way mirror | Two faults (drive and node) |
| 3 | 2 | NVMe or SSD | Three way mirror | Two faults |

## Networking requirements

Network adapters must meet the Azure Local host network requirements. This requirement ensures compatibility and reliability with Hyper-V and also controls how the adapter properties are exposed by the driver (VLAN ID, RSS, VMQ).

The minimum networking requirements are as follows:

- A network adapter that meets the [Azure Local host network requirements](host-network-requirements.md).
- A Layer 2 switch with VLAN support is required.
- Storage intent doesn't require RDMA to be enabled.

Removal of RDMA allows the use of a layer 2 network switch with VLAN support. This further simplifies the configuration management and reduces the overall solution cost.

### Minimum speed requirements

| Single node | Two or three nodes,<br>Switched storage | Two or three nodes,<br>Switchless storage |
| -- | -- | -- |
| 1 GbE linked to switch* | Dedicated network port for storage - 10 Gbps minimum.<br><br>Switch capable of 10 Gbps minimum (RDMA optional).<br><br>Management and compute network -1 Gpbs minimum. | Dedicated network adapter ports for storage - 10 Gbps minimum.<br><br>RDMA automatically enabled if supported by adapter.<br><br>Management and compute network via switch - 1 Gpbs minimum. |

> [!NOTE]
> You can't add nodes to the system without redeploying Azure Local. If you need more nodes, use a dedicated storage intent with a minimum of 10 Gbps.

(Optional) If you use a layer 3 switch with RDMA (10 Gpbs minimum), you can group all traffic (management, compute, and storage intent) together across one, two, and three node clusters.  

### Supported network traffic grouping by intent

| Intent grouping | Single node | Two or three nodes |
| -- | -- | -- |
| Management and compute (no storage) | yes | n/a |
| Management and compute (1 Gbps min),<br>And dedicated storage traffic (10 Gbps) | yes | yes|
| All traffic | RDMA capable switch, 10 Gbps minimum | RDMA capable switch, 10 Gbps minimum |

### Supported sample network configurations

| Link count | Intent | Switch type | Sustain faults |
|------------|--------|-------------|----------------|
| 2 | Single intent | Switch | Single fault |
| 2 | Two intents | Switch | None |
| 4 | Two intents | Switch | Single fault |
| 2 | Two intents | No switch for storage | None |
| 4 | Two intents | No switch for storage | Single fault |

## Considerations

The following are some workload considerations for building a solution using the low capacity hardware:

- Baseline workload Input Output operations per second (IOPS) require sizing storage configuration to see if the low capacity hardware is the right fit.
- vCPU requirements and target ratio due to lower total physical cores when using low capacity hardware.
- The total memory requirement for three servers using low capacity hardware should be calculated. It's important to ensure that there's enough capacity to keep one node free to handle updates and manage failures.
- Network bandwidth requirements.
- Virtual machine (VM) creation time is critical and is influenced by network bandwidth.

### Availability

- Spare part logistics to remediate failures timely.
- Part replacement and identification for non-hot swap components.


<!--## Azure requirements

Here are the Azure requirements for your Azure Local instance:

- **Azure subscription**: If you don't already have an Azure account, [create one](https://azure.microsoft.com/). You can use an existing subscription of any type:

   - Free account with Azure credits [for students](https://azure.microsoft.com/free/students/?cid=msft_learn) or [Visual Studio subscribers](https://azure.microsoft.com/pricing/member-offers/credit-for-visual-studio-subscribers/).
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

::: moniker-end

::: moniker range="<=azloc-2411"

This feature is available only in Azure Local 2411 or later.

::: moniker-end