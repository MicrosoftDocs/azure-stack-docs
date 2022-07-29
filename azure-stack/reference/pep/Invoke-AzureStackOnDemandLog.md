---
title: Invoke-AzureStackOnDemandLog endpoint for Azure Stack Hub
description: Reference for PowerShell Azure Stack privileged endpoint - Invoke-AzureStackOnDemandLog
author: sethmanheim

ms.topic: reference
ms.date: 04/27/2020
ms.author: sethm
ms.reviewer: fiseraci
ms.lastreviewed: 04/27/2020
---

# Invoke-AzureStackOnDemandLog

## Synopsis
Generates on demand logs from Azure Stack Hub roles where applicable.

## Syntax

```
Invoke-AzureStackOnDemandLog [-OutputPath <Object>] [-SlbTimeOutInMinutes <Object>] [-Generate]
 [-FilterByRole <Object>] [-TimeOutInMinutes <Object>] [-AsJob]
```

## Parameters

### -OutputPath

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterByRole
```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeOutInMinutes
```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 30
Accept pipeline input: False
Accept wildcard characters: False
```

### -SlbTimeOutInMinutes

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 20
Accept pipeline input: False
Accept wildcard characters: False
```

### -Generate

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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
