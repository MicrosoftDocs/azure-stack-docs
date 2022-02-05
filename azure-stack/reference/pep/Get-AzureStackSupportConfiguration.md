---
title: Get-AzureStackSupportConfiguration privileged endpoint for Azure Stack Hub
description: Reference for PowerShell Azure Stack privileged endpoint - Get-AzureStackSupportConfiguration
author: PatAltimore

ms.topic: reference
ms.date: 04/27/2020
ms.author: patricka
ms.reviewer: fiseraci
ms.lastreviewed: 04/27/2020
---

# Get-AzureStackSupportConfiguration

## Synopsis
Gets support service configuration settings.

## Syntax

```
Get-AzureStackSupportConfiguration [-IncludeRegistrationObjectId] [-AsJob]
```

## Description
Support Service configuration settings.

## Examples

### Example 1
The example below gets registration details if stamp was registered or else null.

```
PS  C:\> Get-AzureStackSupportConfiguration
```

## Parameters

### -IncludeRegistrationObjectId
Optional.
Requires internet connectivity.
Retrieves registration identity object ID.

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

## Notes
Requires Support VM to have internet connectivity.

## Next steps

For information on how to access and use the privileged endpoint, see [Use the privileged endpoint in Azure Stack Hub](../../operator/azure-stack-privileged-endpoint.md).
