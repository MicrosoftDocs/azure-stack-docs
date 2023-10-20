---
title: New-AzureBridgeServicePrincipal privileged endpoint for Azure Stack Hub
description: Reference for PowerShell Azure Stack privileged endpoint - New-AzureBridgeServicePrincipal
author: sethmanheim

ms.topic: reference
ms.date: 04/27/2020
ms.author: sethm
ms.reviewer: fiseraci
ms.lastreviewed: 04/27/2020
---

# New-AzureBridgeServicePrincipal

## Synopsis
Creates a new service principal in Microsoft Entra ID.

## Syntax

```
New-AzureBridgeServicePrincipal [[-TenantId] <Object>] [[-AzureEnvironment] <Object>]
 [[-TimeoutInSeconds] <Object>] [[-RefreshToken] <Object>] [-AsJob]
```

## Parameters

### -AzureEnvironment
 

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

### -TenantId
 

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

### -RefreshToken
 

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeoutInSeconds
 

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 420
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
