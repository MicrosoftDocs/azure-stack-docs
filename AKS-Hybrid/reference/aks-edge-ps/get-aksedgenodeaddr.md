---
title: Get-AksEdgeNodeAddr for AKS Edge
author: rcheeran
description: The Get-AksEdgeNodeAddr PowerShell command gets the Linux VM's IP and MAC addresses
ms.topic: reference
ms.date: 10/04/2022
ms.author: rcheeran 
ms.lastreviewed: 10/04/2022
#ms.reviewer: jeguan

---

# Get-AksEdgeNodeAddr

## Synopsis
Gets the Linux VM's IP and MAC addresses

## Syntax

```powershell
Get-AksEdgeNodeAddr [<CommonParameters>]
```

## Description
The Get-AksEdgeNodeAddr cmdlet queries the node's primary interface for its current IP & Mac address, which can change over time.

## Examples
```powershell
Get-AksEdgeNodeAddr
```

## Parameters

### -NodeType

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## Next steps

[Aksedge PowerShell Reference](./index.md)
