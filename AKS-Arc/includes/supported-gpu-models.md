---
author: sethmanheim
ms.author: sethm
ms.topic: include
ms.date: 06/02/2025
ms.reviewer: abha
ms.lastreviewed: 06/02/2025

---

## Supported GPU models

The following GPU models are supported by AKS on Azure Local. Note that GPUs are only supported on Linux OS node pools. GPUs are not supported on Windows OS node pools.

| Manufacturer | GPU model | Supported version |
|--------------|-----------|-------------------|
| NVidia       | A2        | 2311.2            |
| NVidia       | A16       | 2402.0            |
| NVidia       | T4        | 2408.0            |

## Supported GPU VM sizes

The following VM sizes for each GPU model are supported by AKS on Azure Local.

### Nvidia T4 is supported by NK T4 SKUs

| VM size | GPUs | GPU Memory: GiB | vCPU | Memory: GiB |
|-----------------|---|----|-----|----|
| Standard_NK6    | 1 | 8  | 6   | 12 |
| Standard_NK12   | 2 | 16 | 12  | 24 |

### Nvidia A2 is supported by NC2 A2 SKUs

| VM size | GPUs | GPU Memory: GiB | vCPU | Memory: GiB |
|-------------------|---|----|----|----|
| Standard_NC4_A2   | 1 | 16 | 4  | 8  |
| Standard_NC8_A2   | 1 | 16 | 8  | 16 |
| Standard_NC16_A2  | 2 | 32 | 16 | 64 |
| Standard_NC32_A2  | 2 | 32 | 32 | 128 |

### Nvidia A16 is supported by NC2 A16 SKUs

| VM size | GPUs | GPU Memory: GiB | vCPU | Memory: GiB |
|--------------------|---|----|----|----|
| Standard_NC4_A16   | 1 | 16 | 4  | 8  |
| Standard_NC8_A16   | 1 | 16 | 8  | 16 |
| Standard_NC16_A16  | 2 | 32 | 16 | 64 |
| Standard_NC32_A16  | 2 | 32 | 32 | 128 |
