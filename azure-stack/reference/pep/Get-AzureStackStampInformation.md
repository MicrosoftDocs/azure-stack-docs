---
title: Get-AzureStackStampInformation privileged endpoint for Azure Stack Hub
description: Reference for PowerShell Azure Stack privileged endpoint - Get-AzureStackStampInformation
author: sethmanheim

ms.topic: reference
ms.date: 04/27/2020
ms.author: sethm
ms.reviewer: fiseraci
ms.lastreviewed: 04/27/2020
---

# Get-AzureStackStampInformation

## Synopsis
Gets the stamp information.

## Syntax

```
Get-AzureStackStampInformation [-AsJob]
```

## Description
Imports the ECE client module and starts an action plan on the Cloud role on the ECE service.

## Examples

### Example 1
```
Get-AzureStackStampInformation
```

## Parameters

### -AsJob


```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```


## Next steps

For information on how to access and use the privileged endpoint, see [Use the privileged endpoint in Azure Stack Hub](../../operator/azure-stack-privileged-endpoint.md).
