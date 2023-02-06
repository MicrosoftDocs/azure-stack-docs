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

The Get-AksEdgeNodeName queries the virtual machine's current hostname from wssdagent.

## Examples

```powershell
Get-AksEdgeNodeName
```

## Parameters

### -NodeType

This parameter indicates whether a 'Linux' node or a 'Windows' node should be added.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## Next steps

[AksEdge PowerShell Reference](./index.md)
