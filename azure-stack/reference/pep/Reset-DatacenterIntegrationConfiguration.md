---
title: Reset-DatacenterIntegrationConfiguration privileged endpoint for Azure Stack Hub
description: Reference for PowerShell Azure Stack privileged endpoint - Reset-DatacenterIntegrationConfiguration
author: mattbriggs

ms.topic: reference
ms.date: 04/27/2020
ms.author: mabrigg
ms.reviewer: fiseraci
ms.lastreviewed: 04/27/2020
---

# Reset-DatacenterIntegrationConfiguration

## Synopsis
Script to reset datacenter integration changes.

## Syntax

```
Reset-DatacenterIntegrationConfiguration [[-TimeoutInSecs] <Object>] [-AsJob]
```

## Description
Script to reset datacenter integration changes.

## Examples

### Example 1
```
Reset-DatacenterIntegrationConfiguration -TimeoutInSecs 2000
```

## Parameters

### -TimeoutInSecs
 

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 1000
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
