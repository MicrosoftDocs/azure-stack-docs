---
title: Storage thin provisioning in Azure Stack HCI
description: How to use storage thin provisioning on Azure Stack HCI clusters by using Windows PowerShell.
author: khdownie
ms.author: v-kedow
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 05/20/2021
---

# Storage thin provisioning in Azure Stack HCI

> Applies to: Azure Stack HCI, version 21H2

Inefficient volume provisioning leads to wastage of your storage and requires significantly more maintenance and management down the road. Traditionally, volumes are fixed provisioned, meaning storage is allocated from the storage pool at the time of volume creation. Despite a volume being empty, a portion of the storage pool’s resources are depleted, and other volumes cannot make use of this storage. 

## Capacity management: thin vs. fixed provisioned volumes 

New in Azure Stack HCI, version 21H2, thin provisioning is recommended over the traditional fixed provisioning if you don't know exactly how much storage a volume will need and want more flexibility. With thin provisioning, space is allocated from the pool when needed and volumes can be over-provisioned (size larger than available capacity) to accommodate anticipated growth. 

Here is a comparison of the two provisioning types with empty volumes:  




## Next steps

For more information, see also:

- [Plan volumes](../concepts/plan-volumes.md)
- [Create volumes](create-volumes.md)