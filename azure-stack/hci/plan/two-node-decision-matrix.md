---
title: Review two-node storage reference pattern decision matrix for Azure Stack HCI
description: Review two-node storage reference pattern decision matrix for Azure Stack HCI
ms.topic: conceptual
author: dansisson
ms.author: v-dansisson
ms.reviewer: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 07/20/2023
---

# Review two-node storage reference pattern decision matrix for Azure Stack HCI

[!INCLUDE [includes](../../includes/hci-applies-to-22h2-21h2.md)]

Study the two-node storage reference pattern decision matrix to help decide which reference pattern is best suited for your deployment needs:

|Feature|Storage switchless|Storage switchless|Storage switched|Storage switched|
|--|--|--|--|--|
||**Single switch**|**Two switches**|**Non-converged**|**Fully-converged**|
|Scalable pattern|unsuitable|unsuitable|suitable|suitable|
|HA solution|unsuitable|suitable|suitable|suitable|
|VLAN-based tenants|suitable|suitable|suitable|suitable|
|SDN L3 integration|neutral|suitable|suitable|suitable|
|Total cost of ownership (TCO)|suitable|neutral|neutral|neutral|
|Compacted/portable solution|suitable|neutral|unsuitable|unsuitable|
|RDMA Performance|neutral|neutral|suitable|neutral|
|Physical switch operational costs|suitable|neutral|neutral|unsuitable|
|Physical switch routing and ACLs|neutral|neutral|neutral|neutral|

## Next steps

- [Download Azure Stack HCI](../deploy/download-azure-stack-hci-software.md)
