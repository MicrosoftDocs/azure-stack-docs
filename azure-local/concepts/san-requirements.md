---
title: Supported SAN solutions on Azure Local
description: Describes the supported SAN solutions for Azure Local.
author: troettinger
ms.author: thoroet
ms.reviewer: ronmiab
ms.topic: how-to
ms.date: 06/02/2026
ms.subservice: hyperconverged
---


# Supported SAN solutions on Azure Local
Azure Local supports using Fibre Channel (FC) storage area network (SAN) storage as an alternative to local storage (Storage Spaces Direct). This article details the supported SAN solutions from our storage partners.

## Supported SAN solutions

> [!IMPORTANT]
> - External SAN supports only block storage over Fibre Channel.
> - All cluster nodes must have identical HBA configuration and zoning.
> - You must present logical unit numbers (LUNs) to all cluster nodes (no partial presentation).
> - Only NT file system (NTFS) formatted volumes are supported for SAN-backed Cluster Shared Volumes (CSVs).
> - ReFS isn't supported for SAN-backed volumes in this preview.
> - Each SAN LUN must be dedicated to a single CSV (no sharing across clusters).
> - You must configure Multipath I/O (MPIO) consistently across all nodes before volume use.

Select one of the partners to view their support statements:

# [Dell](#tab/Dell-PowerStore-support)
The Dell PowerStore family (T and Q appliances) running OS 3.0 or later is supported as external storage for Azure Local.

# [Everpure](#tab/Everpure-support)

Azure Local supports Everpure FlashArray.

For more information, see [Azure Local with Everpure](https://support.purestorage.com/bundle/m_microsoft_platform_guide/page/Solutions/Microsoft_Platform_Guide/topics/concept/c_azure_local.html).

The following models qualify to integrate with Azure Local:

- FlashArray X
- FlashArray C
- FlashArray XL
- FlashArray E
- FlashArray RC20

# [Hitachi](#tab/Hitachi-Vantara-support)
Azure Local supports the Hitachi VSP One storage family. For more information, see the [Product Compatibility Guide](https://compatibility.hitachivantara.com/products/interop-matrix).


The following Hitachi storage models qualify to integrate with Azure Local (subject to program scope and the PCG for host/fabric specifics):

- Hitachi VSP One Block High End
- Hitachi VSP One Block 24
- Hitachi VSP One Block 26
- Hitachi VSP One Block 28
- Hitachi VSP 5100, 5200, 5500, 5600
- Hitachi VSP E1090, E590, E790, E990
- Hitachi VSP F350, F370, F700, F900
- Hitachi VSP G130, G350, G370, G700, G900


# [HPE](#tab/HPE-Alletra-support)
Azure Local supports HPE Alletra MP 10000 (Fibre Channel) storage.

# [Lenovo](#tab/Lenovo-support)
Azure Local supports the following Lenovo Storage systems:
- ThinkSystem DS Series
- ThinkSystem DM Series
- ThinkSystem DG Series

# [NetApp](#tab/Netapp-support)
NetApp supports ONTAP-based external SAN arrays, including NetApp AFF, NetApp ASA, and other ONTAP platforms configured for SAN. Azure Local supports these arrays for use as external storage when you deploy the solution as FC block storage presented to Azure Local nodes and consumed as CSVs.

The [NetApp Interoperability Matrix Tool (IMT)](https://www.netapp.com/company/interoperability/) lists the qualified configurations and governs the supported ONTAP versions. You get support when the NetApp IMT validates and lists the following end-to-end configuration components:

- Azure Local release
- Windows driver stack
- FC HBAs
- ONTAP version
- Multipathing and host utilities
- Switch and fabric components

---

## Next steps

Review firewall, physical network, and host network requirements:

- [Firewall requirements](./firewall-requirements.md).
- [Physical network requirements](./physical-network-requirements.md).
- [Host network requirements](./host-network-requirements.md).
