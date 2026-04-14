---
title: Supported SAN solutions on Azure Local
description: Describes the supported SAN solutions for Azure Local.
author: troettinger
ms.author: thoroet
ms.reviewer: ronmiab
ms.topic: how-to
ms.date: 04/11/2026
ms.subservice: hyperconverged
---


# Overview
Azure Local supports using Fibre Channel (FC) storage area network (SAN) storage as an alternative to local storage (Storage Spaces Direct). This article details the supported SAN solutions from our storage partners.

## Supported SAN Solutions

> [!NOTE]
> - External SAN is supported for block storage over Fibre Channel only.
> - All cluster nodes must have identical HBA configuration and zoning.
> - Logical unit numbers (LUNs) must be presented to all cluster nodes (no partial presentation).
> - Only NT file system (NTFS) formatted volumes are supported for SAN-backed Cluster Shared Volumes (CSVs).
> - ReFS isn't supported for SAN-backed volumes in this preview.
> - Each SAN LUN must be dedicated to a single CSV (no sharing across clusters).
> - Multipath I/O (MPIO) must be configured consistently across all nodes before volume use.

Select one of the partners below to view their support statements:

# [Dell](#tab/Dell-PowerStore-support)
The Dell PowerStore family (T and Q appliances) running OS 3.0 or later is supported as external storage for Azure Local.

# [EverPure](#tab/EverPure-support)
Supported versions of Purity on FlashArray models (FA//X, FA//XL, FA//C, FA//E). Detailed instructions are available [here](https://support.purestorage.com/auth/login?redirect=%2Fbundle%2Fm_getting_started_with_flasharray%2Fpage%2FSolutions%2FVMware_Platform_Guide%2FTroubleshooting_for_VMware_Solutions%2FVMware-Related_KB_Articles%2Flibrary%2Fcommon_content%2Fc_introduction_46.html).

# [Hitachi](#tab/Hitachi-Vantara-support)
Hitachi VSP One storage family is supported for use with Azure Local.
Reference: https://compatibility.hitachivantara.com/products/interop-matrix
The following Hitachi storage models are qualified to integrate with Azure Local (subject to program scope and the PCG for host/fabric specifics):
- Hitachi VSP One Block High End
- Hitachi VSP One Block 24
- Hitachi VSP One Block 26
- Hitachi VSP One Block 28
- Hitachi VSP 5100, 5200, 5500, 5600
- Hitachi VSP E1090, E590, E790, E990
- Hitachi VSP F350, F370, F700, F900
- Hitachi VSP G130, G350, G370, G700, G900


# [HPE](#tab/HPE-Alletra-support)
The HPE Alletra MP 10000 (Fibre Channel) storage is supported for use with Azure Local.

# [Lenovo](#tab/Lenovo-support)
The following Lenovo Storage systems are supported for use with Azure Local:
- ThinkSystem DS Series
- ThinkSystem DM Series
- ThinkSystem DG Series

# [NetApp](#tab/Netapp-support)
NetApp supports ONTAP-based external SAN arrays, including NetApp AFF, NetApp ASA, and other ONTAP platforms configured for SAN. These arrays are supported for use with Azure Local external storage when the solution is deployed as FC block storage presented to Azure Local nodes and consumed as CSVs.

Supported ONTAP versions are governed by the [NetApp Interoperability Matrix Tool (IMT)](https://www.netapp.com/company/interoperability/), which lists the qualified configurations. Support is provided when the following end-to-end configuration components are validated and listed in the NetApp IMT:

- Azure Local release
- Windows driver stack
- FC HBAs
- ONTAP version
- Multipathing and host utilities
- Switch and fabric components 

## Next steps

Review firewall, physical network, and host network requirements:

- [Firewall requirements](./firewall-requirements.md).
- [Physical network requirements](./physical-network-requirements.md).
- [Host network requirements](./host-network-requirements.md).
