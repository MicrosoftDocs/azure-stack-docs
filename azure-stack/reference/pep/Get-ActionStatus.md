---
title: Get-ActionStatusprivileged endpoint for Azure Stack Hub
description: Reference for PowerShell Azure Stack privileged endpoint - Get-ActionStatus
author: sethmanheim

ms.topic: reference
ms.date: 04/27/2020
ms.author: sethm
ms.reviewer: fiseraci
ms.lastreviewed: 04/27/2020
---

# Get-ActionStatus

## Synopsis
Gets the status of the latest action for the operation with the specified function name.

## Syntax

```
Get-ActionStatus [[-ActionType] <Object>] [[-FunctionName] <Object>] [-AsJob]
```

## Description
Gets the status of the latest action for the operation with the specified function name.

## Examples

### Example 1
```
Get-ActionStatus -FunctionName "Start-SecretRotation"
```

## Parameters

### -FunctionName
The name of the function for which the status is being queried.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ActionType
Type name of the operation action.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
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
