---
title: Storage requirements for Azure Stack HCI
description: How to choose and configure storage for Azure Stack HCI.
author: khdownie
ms.author: v-kedow
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 10/15/2020
---

# Storage requirements for Azure Stack HCI

> Applies to: Azure Stack HCI, version 20H2

Azure Stack HCI works with direct-attached SATA, SAS, NVMe, or persistent memory drives that are physically attached to just one server each.

## Considerations and recommendations

For best results, adhere to the following:

- Every server in the cluster should have the same types of drives and the same number of each type. It's also recommended (but not required) that the drives be the same size and model. Drives can be internal to the server, or in an external enclosure that is connected to just one server. To learn more, see [Drive symmetry considerations](../concepts/drive-symmetry-considerations.md).

- Each server in the cluster should have dedicated volumes for logs, with log storage at least as fast as data storage. Stretched clusters require at least two volumes: one for replicated data, and one for log data.

- SCSI Enclosure Services (SES) is required for slot mapping and identification. Each external enclosure must present a unique identifier (Unique ID). 

   > [!IMPORTANT]
   > **NOT SUPPORTED:** RAID controller cards or SAN (Fibre Channel, iSCSI, FCoE) storage, shared SAS enclosures connected to multiple servers, or any form of multi-path IO (MPIO) where drives are accessible by multiple paths. Host-bus adapter (HBA) cards must implement simple pass-through mode.

## Next steps

For related information, see also:

- [Choose drives](../concepts/choose-drives.md)
- [Plan volumes](../concepts/plan-volumes.md)
- [Storage Spaces Direct hardware requirements](/windows-server/storage/storage-spaces/storage-spaces-direct-hardware-requirements)
