---
title: Start-AzureStack privileged endpoint for Azure Stack Hub
description: Reference for PowerShell Azure Stack privileged endpoint - Start-AzureStack
author: sethmanheim

ms.topic: reference
ms.date: 04/27/2020
ms.author: sethm
ms.reviewer: fiseraci
ms.lastreviewed: 04/27/2020
---

# Start-AzureStack

## Synopsis
Starts all Azure Stack Hub services.

## Syntax

```
Start-AzureStack [[-TimeoutInSecs] <Object>] [-AsJob]
```

## Description
Starts all Azure Stack Hub services.

## Examples

### Example 1
```powershell
PS C:\> 
```



## Parameters

### -TimeoutInSecs
Maximum amount of time after which the execution will be stopped.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 2400
Accept pipeline input: False
Accept wildcard characters: False
```

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
