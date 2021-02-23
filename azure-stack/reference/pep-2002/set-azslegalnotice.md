---
title: Set-AzSLegalNotice privileged endpoint for Azure Stack Hub
description: Reference for PowerShell Azure Stack privileged endpoint - Set-AzSLegalNotice
author: BryanLa

ms.topic: reference
ms.date: 02/19/2021
ms.author: bryanla
ms.reviewer: fiseraci
ms.lastreviewed: 02/19/2021
---

# Set-AzSLegalNotice

## Synopsis
Sets the legal notice caption and text.

## Syntax

```
Set-AzSLegalNotice [-Caption <String>] [-Text <String>]
```

## Description
Sets the legal notice caption and text that is presented after sign-in using the `Enter-PSSession` cmdlet.

## Examples

### Example 1
```
Set-AzSLegalNotice -Caption "New caption" -Text "First line\nSecond line\n"
```

## Parameters

### -Caption
The legal notice caption.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Text
The legal notice text, which shows below the caption.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## Next steps

For information on how to access and use the privileged endpoint, see [Use the privileged endpoint in Azure Stack Hub](../../operator/azure-stack-privileged-endpoint.md).
