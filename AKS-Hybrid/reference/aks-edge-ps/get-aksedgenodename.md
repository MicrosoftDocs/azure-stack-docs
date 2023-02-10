---
title: Get-AksEdgeNodeName for AKS Edge
author: rcheeran
description: The Get-AksEdgeNodeName PowerShell command gets the  VM's hostname
ms.topic: reference
ms.date: 10/04/2022
ms.author: rcheeran 
ms.lastreviewed: 10/04/2022
#ms.reviewer: jeguan

---

# Get-AksEdgeNodeName

Gets the Linux or Windows VM's hostname based on the parameter passed.

## Syntax

```powershell
Get-AksEdgeNodeName [[-NodeType] <String>]
```

## Description

The Get-AksEdgeNodeName returns the virtual machine's current hostname.

## Examples

```powershell
Get-AksEdgeNodeName
```

## Parameters

### -NodeType
NodeType specifies whether to get the name of the Linux or Windows node.
Default is Linux.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Linux
Accept pipeline input: False
Accept wildcard characters: False
```

## Next steps

[AksEdge PowerShell Reference](./index.md)
