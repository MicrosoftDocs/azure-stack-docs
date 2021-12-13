---
title: VM sizes supported in Azure Stack Hub 
description: Reference for the supported VM sizes in Azure Stack Hub.
author: mattbriggs

ms.topic: reference
ms.date: 2/1/2021
ms.author: mabrigg
ms.reviewer: kivenkat
ms.lastreviewed: 03/23/2020

# Intent: As an Azure Stack user, I want to learn about virtual machine sizes available in Azure Stack.
# Keyword: virtual machine sizes

---


# VM sizes supported in Azure Stack Hub

This article lists the virtual machine (VM) sizes that are available in Azure Stack Hub. You can use this article to help you make your selection of a VM to support your Azure Stack Hub solution.

Disk IOPS (Input/Output Operations Per Second) on Azure Stack Hub is a function of VM size instead of the disk type. This means that for a Standard_Fs series VM, regardless of whether you choose SSD or HDD for the disk type, the IOPS limit for a single additional data disk is 2300 IOPS. The IOPS limits imposed is a cap (maximum possible) to prevent noisy neighbors. It isn't an assurance of IOPS that you'll get on a specific VM size.

VM vCPU depends on the number of cores per node. For example, systems with cores or logical processor of less than 64 will not support VM size Standard_F64s_v2.


## VM General Purpose

General-purpose VM sizes provide a balanced CPU-to-memory ratio. They're used for testing and development, small to medium databases, and low to medium traffic web servers. Each data disk is 2300 IOPS for the premium VM sizes, except for the Basic A series. For Basic A, the data disk size is 500 IOPS.

### Basic A

> [!NOTE]
> *Basic A* VM sizes are retired for [creating virtual machine scale sets](../operator/azure-stack-compute-add-scalesets.md) (VMSS) through the portal. To create a VMSS with this size, use PowerShell or a template.

|Size - Size\Name |vCPU     |Memory | Max temporary disk size | Max OS disk throughput: (IOPS) | Max temp storage throughput (IOPS) | Max data disk throughput (IOPS) | Max NICs |    
|-----------------|-----|---------|---------|-----|------|-----------|----|
|**A0\Basic_A0**  |1    |768 MB   | 20 GB   |300  | 300  |1 / 1x300  |2   |
|**A1\Basic_A1**  |1    |1.75 GB  | 40 GB   |300  | 300  |2 / 2x300  |2   |
|**A2\Basic_A2**  |2    |3.5 GB   | 60 GB   |300  | 300  |4 / 4x300  |2   |
|**A3\Basic_A3**  |4    |7 GB     | 120 GB  |300  | 300  |8 / 8x300  |2   |
|**A4\Basic_A4**  |8    |14 GB    | 240 GB  |300  | 300  |16 / 16X300 |2   |

### Standard A 
|Size     |vCPU     |Memory (GiB) | Temp storage (GiB)  | Max OS disk throughput (IOPS) | Max temp storage throughput (IOPS) | Max data disks / throughput (IOPS) | Max NICs |    
|----------------|--|------|----|----|----|-------|---------|
|**Standard_A0** |1 |0.768 |20  |500 |500 |1x500  |2 |
|**Standard_A1** |1 |1.75  |70  |500 |500 |2x500  |2 |
|**Standard_A2** |2 |3.5   |135 |500 |500 |4x500  |2 |
|**Standard_A3** |4 |7     |285 |500 |500 |8x500  |2 |
|**Standard_A4** |8 |14    |605 |500 |500 |16x500 |4 |
|**Standard_A5** |2 |14    |135 |500 |500 |4x500  |2 |
|**Standard_A6** |4 |28    |285 |500 |500 |8x500  |2 |
|**Standard_A7** |8 |56    |605 |500 |500 |16x500 |4 |

### Av2-series
*Requires Azure Stack Hub version 1804 or later*

|Size     |vCPU     |Memory (GiB) | Temp storage (GiB)  | Max OS disk throughput (IOPS) | Max temp storage throughput (IOPS) | Max data disks / throughput (IOPS) | Max NICs |
|-----------------|----|----|-----|-----|------|--------------|---------|
|**Standard_A1_v2**  |1   |2   |10   |500 |1000  |2 / 2x500   |2 |
|**Standard_A2_v2**  |2   |4   |20   |500 |2000  |4 / 4x500   |2 |
|**Standard_A4_v2**  |4   |8   |40   |500 |4000  |8 / 8x500   |4 |
|**Standard_A8_v2**  |8   |16  |80   |500 |8000  |16 / 16x500 |8 |
|**Standard_A2m_v2** |2   |16  |20   |500 |2000  |4 / 4x500   |2 |
|**Standard_A4m_v2** |4   |32  |40   |500 |4000  |8 / 8x500   |4 |
|**Standard_A8m_v2** |8   |64  |80   |500 |8000  |16 / 16x500 |8 |


## Compute Optimized
### F-series
*Requires Azure Stack Hub version 1804 or later*

|Size     |vCPU     |Memory (GiB) | Temp storage (GiB)  | Max OS disk throughput (IOPS) | Max temp storage throughput (IOPS) | Max data disks / throughput (IOPS) | Max NICs |
|-----------------|----|----|-----|----|------|------------|---------|
|**Standard_F1**  |1   |2   |16   |500 |3000  |4 / 4x500   |2 |
|**Standard_F2**  |2   |4   |32   |500 |6000  |8 / 8x500   |2 |
|**Standard_F4**  |4   |8   |64   |500 |12000 |16 / 16x500 |4 |
|**Standard_F8**  |8   |16  |128  |500 |24000 |32 / 32x500 |8 |
|**Standard_F16** |16  |32  |256  |500 |48000 |64 / 64x500 |8 |


### Fs-series
*Requires Azure Stack Hub version 1804 or later*  

|Size     |vCPU     |Memory (GiB) | Temp storage (GiB)  | Max OS disk throughput (IOPS) | Max temp storage throughput (IOPS) | Max data disks / throughput (IOPS) | Max NICs |
|------------------|----|----|----|-----|------|-------------|---------|
|**Standard_F1s**  |1   |2   |4   |1000 |4000  |4 / 4x2300   |2 |
|**Standard_F2s**  |2   |4   |8   |1000 |8000  |8 / 8x2300   |2 |
|**Standard_F4s**  |4   |8   |16  |1000 |16000 |16 / 16x2300 |4 |
|**Standard_F8s**  |8   |16  |32  |1000 |32000 |32 / 32x2300 |8 |
|**Standard_F16s** |16  |32  |64  |1000 |64000 |64 / 64x2300 |8 |


### Fsv2-series
*Requires Azure Stack Hub version 1804 or later* 

|Size     |vCPU     |Memory (GiB) | Temp storage (GiB)  | Max OS disk throughput (IOPS) | Max temp storage throughput (IOPS) | Max data disks / throughput (IOPS) | Max NICs |
|---------------------|----|----|-----|-----|-------|--------------|---------|
|**Standard_F2s_v2**  |2   |4   |16   |1000 |4000   |4 / 4x2300    |2 |
|**Standard_F4s_v2**  |4   |8   |32   |1000 |8000   |8 / 8x2300    |2 |
|**Standard_F8s_v2**  |8   |16  |64   |1000 |16000  |16 / 16x2300  |4 |
|**Standard_F16s_v2** |16  |32  |128  |1000 |32000  |32 / 32x2300  |4 |
|**Standard_F32s_v2** |32  |64  |256  |1000 |64000  |32 / 32x2300  |8 |
|**Standard_F64s_v2** |64  |128 |512  |1000 |128000 |32 / 32x2300  |8 |


## Memory Optimized

Memory optimized VM sizes provide a high memory-to-CPU ratio that is designed for relational database servers, medium to large caches, and in-memory analytics.

### <a name="mo-d"></a>D-series
|Size     |vCPU     |Memory (GiB) | Temp storage (GiB)  | Max OS disk throughput (IOPS) | Max temp storage throughput (IOPS) | Max data disks / throughput (IOPS) | Max NICs |
|------------------|---|----|----|--------|------|------------|---------|
|**Standard_D11**  |2  |14  |100 |500     |6000  |8 / 8x500   |2 |
|**Standard_D12**  |4  |28  |200 |500     |12000 |16 / 16x500 |4 |
|**Standard_D13**  |8  |56  |400 |500     |24000 |32 / 32x500 |8 |
|**Standard_D14**  |16 |112 |800 |500     |48000 |64 / 64x500 |8 |

### <a name="mo-ds"></a>DS-series
|Size     |vCPU     |Memory (GiB) | Temp storage (GiB)  | Max OS disk throughput (IOPS) | Max temp storage throughput (IOPS) | Max data disks / throughput (IOPS) | Max NICs |
|-------------------|---|----|----|--------|------|-------------|---------|
|**Standard_DS11**  |2  |14  |28  |1000    |8000  |8 / 8x2300   |2 |
|**Standard_DS12**  |4  |28  |56  |1000    |12000 |16 / 16x2300 |4 |
|**Standard_DS13**  |8  |56  |112 |1000    |32000 |32 / 32x2300 |8 |
|**Standard_DS14**  |16 |112 |224 |1000    |64000 |64 / 64x2300 |8 |

### <a name="mo-dv2"></a>Dv2-series
|Size     |vCPU     |Memory (GiB) | Temp storage (GiB)  | Max OS disk throughput (IOPS) | Max temp storage throughput (IOPS) | Max data disks / throughput (IOPS) | Max NICs |
|--------------------|----|----|-----|----|-------|-------------|---------|
|**Standard_D11_v2** |2   |14  |100  |500 |6000   |8 / 8x500    |2 |
|**Standard_D12_v2** |4   |28  |200  |500 |12000  |16 / 16x500  |4 |
|**Standard_D13_v2** |8   |56  |400  |500 |24000  |32 / 32x500  |8 |
|**Standard_D14_v2** |16  |112 |800  |500 |48000  |64 / 64x500  |8 |


### <a name="mo-dsv2"></a>DSv2-series
|Size     |vCPU     |Memory (GiB) | Temp storage (GiB)  | Max OS disk throughput (IOPS) | Max temp storage throughput (IOPS) | Max data disks / throughput (IOPS) | Max NICs |
|---------------------|----|----|-----|-----|-------|--------------|---------|
|**Standard_DS11_v2** |2   |14  |28   |1000 |8000   |8 / 8x2300    |2 |
|**Standard_DS12_v2** |4   |28  |56   |1000 |16000  |16 / 16x2300    |4 |
|**Standard_DS13_v2** |8   |56  |112  |1000 |32000  |32 / 32x2300  |8 |
|**Standard_DS14_v2** |16  |112 |224  |1000 |64000  |64 / 64x2300  |8 |

::: moniker range="azs-2102"
::: moniker range="azs-2108"
### <a name="mo-dv3"></a>Dv3-series

| Size | vCPU | Memory: GiB | Temp storage (SSD) GiB | Max data disks/throughput (IOPS) | Max NICs/Network bandwidth |
|---|---|---|---|---|---|
| **Standard_D2_v3**  | 2  | 8   | 50   | 4 / 4x500 | 2 |
| **Standard_D4_v3**  | 4  | 16  | 100  | 8 /8x500  | 2  |
| **Standard_D8_v3**  | 8  | 32  | 200  | 16 /16x500 | 4  |
| **Standard_D16_v3** | 16 | 64  | 400  | 32 /32x500 | 8 |
| **Standard_D32_v3** | 32 | 128 | 800  | 32 /32x500 | 8 |

### <a name="mo-dsn_v2"></a>DS-n_v2-series
| Size | vCPU | Memory: GiB | Temp storage (SSD) GiB | Max data disks /throughput (IOPS) | Max NICs |
|---|---|---|---|---|---|
| **Standard_DS11-1_v2**  | 1  | 14   | 28   | 8 / 8x2300 | 2 |
| **Standard_DS12-1_v2**  | 1  | 28  | 56  | 16 / 16x2300 | 2 |
| **Standard_DS12-2_v2**  | 2  | 28  | 56  | 16 / 16x2300 | 2 |
| **Standard_DS13-2_v2**  | 2  | 56  | 112  | 32 / 32x2300 | 4|
| **Standard_DS13-4_v2** | 4 | 56 | 112  | 32 / 32x2300 | 8  |
| **Standard_DS14-4_v2** | 4 | 112 | 224  | 64 /64x2300 | 8 |
| **Standard_DS14-8_v2** | 8 | 112 | 224  | 64 /64x2300 | 8|

### <a name="mo-dv3"></a>Ev3-series
| Size | vCPU | Memory: GiB | Temp storage (SSD) GiB | Max data disks /throughput (IOPS) | Max NICs  |
|---|---|---|---|---|---|
| **Standard_E2_v3**  | 2  | 16  | 50   | 4 /4x500 | 2 |
| **Standard_E4_v3**  | 4  | 32  | 100  | 8 /8x500 | 2 |
| **Standard_E8_v3**  | 8  | 64  | 200  | 16 /16x500| 4 |
| **Standard_E16_v3** | 16 | 128 | 400  | 32 /32x500| 8 |

::: moniker-end
::: moniker-end

## Next steps

[Azure Stack Hub VM features](azure-stack-vm-considerations.md)
