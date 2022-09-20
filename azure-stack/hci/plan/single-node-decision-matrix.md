---
title: Review single-node storage reference pattern decision matrix for Azure Stack HCI
description: Review single-node storage reference pattern decision matrix for Azure Stack HCI
ms.topic: conceptual
author: dansisson
ms.author: v-dansisson
ms.reviewer: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 09/19/2022
---

# Review single-node storage reference pattern decision matrix for Azure Stack HCI

> Applies to: Azure Stack HCI, version 21H2, Azure Stack HCI, version 22H2 (preview)

Review the single-node storage reference pattern decision matrix to help decide which reference pattern is best suited based on your deployment needs:

|Feature|Storage switchless|Storage switched|
|--|--|--|
|Scalable pattern|unsuitable|suitable|
|HA solution|unsuitable|unsuitable|
|VLAN-based tenants|suitable|suitable|
|SDN L3 integration|neutral|suitable|
|Total cost of ownership (TCO)|suitable|neutral|
|Compacted/portable solution|suitable|neutral|
|RDMA Performance|neutral|neutral|
|Physical switch operational costs|suitable|neutral|
|Physical switch routing and ACLs|neutral|neutral|

## Next steps

- [Download Azure Stack HCI](https://azure.microsoft.com/products/azure-stack/hci/hci-download/)