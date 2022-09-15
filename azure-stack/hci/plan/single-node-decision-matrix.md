---
title: Review single-node storage reference pattern decision matrix for Azure Stack HCI
description: Review single-node storage reference pattern decision matrix for Azure Stack HCI
ms.topic: conceptual
author: dansisson
ms.author: v-dansisson
ms.reviewer: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 09/15/2022
---

# Review single-node storage reference pattern decision matrix for Azure Stack HCI

> Applies to: Azure Stack HCI, version 21H2, Azure Stack HCI, version 22H2 (preview)

Study the single-node storage reference pattern decision matrix to help decide which reference pattern is best suited for your deployment needs:


|Feature|Storage switchless|Storage switched|
|--|--|--|
|Scalable pattern|unsuitable|suitable|
|HA solution|unsuitable|unsuitable|neutral|
|VLAN based Tenants|suitable|suitable|
|SDN L3 integration|neutral|suitable|
|TCO|suitable|neutral|
|Compacted/portable solution|suitable|neutral|
|RDMA Performance|neutral|neutral|
|Physical Switch Operational costs|suitable|neutral|
|Physical Switch routing and ACLs|neutral|neutral|


## Next steps

[Choose a reference pattern](test0.md).