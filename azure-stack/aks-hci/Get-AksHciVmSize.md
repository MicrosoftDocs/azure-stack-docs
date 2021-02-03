---
external help file: 
Module Name: Aks.Hci
online version: 
schema: 
---

# Get-AksHciVmSize

## Synopsis
List supported VM sizes.

## Syntax

```powershell
Get-AksHciVmSize
```

## Description
List supported VM sizes.

## Examples

### Example
```powershell
PS C:\> Get-AksHciVmSize
```

**Output:**
```
VmSize  CPU MemoryGB
------  --- --------
Default 4   4
Standard_A2_v2 2 4
Standard_A4_v2 4 8
Standard_D2s_v3 2 8
Standard_D4s_v3 4 16
Standard_D8s_v3 8 32
Standard_D16s_v3 16 64
Standard_D32s_v3 32 128
Standard_DS2_v2 2 7
Standard_DS3_v2 2 14
Standard_DS4_v2 8 28
Standard_DS5_v2 16 56
Standard_DS13_v2 8 56
Standard_K8S_v1 4 2
Standard_K8S2_v1 2 2
Standard_K8S3_v1 4 6
``` 
