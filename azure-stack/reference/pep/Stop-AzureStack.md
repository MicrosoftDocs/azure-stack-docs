---
title: Stop-AzureStack privileged endpoint for Azure Stack Hub
description: Reference for PowerShell Azure Stack privileged endpoint - Stop-AzureStack
author: PatAltimore

ms.topic: reference
ms.date: 04/27/2020
ms.author: patricka
ms.reviewer: fiseraci
ms.lastreviewed: 04/27/2020
---

# Stop-AzureStack

## Synopsis
Stops all Azure Stack Hub services.

## Syntax

```
Stop-AzureStack [[-TimeoutInSecs] <Object>] [-AsJob]
```

## Description
Stops all Azure Stack services, and stops the physical computers on which Azure Stack Hub is running.

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
