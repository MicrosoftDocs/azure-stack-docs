---
title: Set-AksEdgeNodeConnectivityMode for AKS Edge
author: rcheeran
description: The Set-AksEdgeNodeConnectivityMode PowerShell command sets AksEdge Linux node connectivity mode.
ms.topic: reference
ms.date: 02/02/2023
ms.author: rcheeran 
ms.lastreviewed: 02/02/2023
#ms.reviewer: jeguan

---

# Set-AksEdgeNodeConnectivityMode

Sets the AKS Edge Essentials Linux node connectivity mode. (ssh access `On` or `Off`). Returns "OK" if successfully set, null otherwise.

## Syntax

```powershell
Set-AksEdgeNodeConnectivityMode [-mode] <String> [<CommonParameters>]
```

## Description

Sets the AKS Edge Essentials Linux node connectivity mode. (ssh access `On` or `Off`).


## Examples

### Turn off connectivity 

```powershell
Set-AksEdgeNodeConnectivityMode -mode "Off"
```


## Parameters

### -mode

This parameter specifies the connectivity mode. Expected values are 'on' or 'off'.

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


### Common parameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## Next steps

[AksEdge PowerShell Reference](./index.md)
