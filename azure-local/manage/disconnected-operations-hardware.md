---
title: Hardware for Azure Local with disconnected operations (preview).
description: Learn about the hardware requirements for running Azure Local with disconnected operations, as well as the topologies used for validation and support.
ms.topic: concept-article
author: ronmiab
ms.author: robess
ms.date: 01/17/2025
---

# Hardware for Azure Local with disconnected operations (preview)  

[!INCLUDE [applies-to](../includes/release-2411-1-later.md)]

This article outlines the hardware requirements for running Azure Local with disconnected operations, as well as the topologies used for validation and support.

To run Azure Local with disconnected operations, it is essential to plan for extra capacity for the virtual appliance. The minimum hardware requirements to deploy and operate Azure Local in a disconnected environment are higher due to the need to host a local control plane. Proper planning is important to ensure smooth operations.

[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]

## Hardware requirements  

To run disconnected operations, you must meet the required system requirements for Azure Local. For more information, see [System requirements for Azure Local](../concepts/system-requirements-23h2.md). Additionally, we recommend you use Validated nodes or higher. For more information, see [Azure Local solutions](https://azurelocalsolutions.azure.microsoft.com/).

In addition to the Azure Local hardware requirements, each node must meet the following minimum hardware specifications to run the disconnected operations appliance:

| Specification | Minimum                   |
|---------------|---------------------------|
| Nodes         | 3 to 8                    |
| Memory        | 64 GB                     |
| Boot disk     | 480 GB SSD/NVMe           |
| Drives        | 2 TB SSD/NVMe drives only |
| Cores         | 24 physical cores         |

## Supported deployment topologies  

The following topologies are supported for Azure Local with disconnected operations:

| Topology  | Minimum                                       |
|-----------|-----------------------------------------------|
| Instance (cluster)   | 3 to 8 machines                    |
| Physical deployments | Only physical deployments          |

<!--## Unsupported topologies

The following topologies are not supported for Azure Local with disconnected operations:

- Virtual deployments used for POC or learning purposes.
- Deployments involving two machines.-->

## Next step

- [Set up Azure Local for disconnected operations](disconnected-operations-virtual-appliance.md).
