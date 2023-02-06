---
title: Set-AksEdgeBillingPodState for AKS Edge
author: rcheeran
description: The Set-AksEdgeBillingPodState PowerShell command  allows AIDE front end to set Billing pod state after joining Arc through Azure CLI.
ms.topic: reference
ms.date: 02/02/2023
ms.author: rcheeran 
ms.lastreviewed: 02/02/2023
#ms.reviewer: jeguan

---

# Set-AksEdgeBillingPodState

The Set-AksEdgeBillingPodState PowerShell command allows the front end to set billing pod state after joining Arc using the Azure CLI.

## Syntax

```powershell
Set-AksEdgeBillingPodState
```

## Description

This function allows the front end to set billing pod state after joining Arc using the Azure CLI.


## Examples

```powershell
Set-AksEdgeBillingPodState -Connect
```

## Parameters

### -Connect

This parameter connects or disconnects.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```


### Common parameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## Next steps

[AksEdge PowerShell Reference](./index.md)
