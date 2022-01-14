---
title: Remove-GraphApplication privileged endpoint for Azure Stack Hub
description: Reference for PowerShell Azure Stack privileged endpoint - Remove-GraphApplication
author: PatAltimore

ms.topic: reference
ms.date: 04/27/2020
ms.author: patricka
ms.reviewer: fiseraci
ms.lastreviewed: 04/27/2020
---

# Remove-GraphApplication

## Synopsis
Remove-GraphApplication is a wrapper function to call AD FS Graph cmdlets on AD FS.

## Syntax

```
Remove-GraphApplication [[-ApplicationIdentifier] <Object>] [-AsJob]
```

## Description
Invokes the Remove-GraphApplicationGroup on AD FS to remove the specified application on to AD FS machine.

## Examples

### Example 1
```
Remove-GraphApplication -ApplicationIdentifier "Application-Identifier-123456"
```

## Parameters

### -ApplicationIdentifier
Identifier of the application to be deleted

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
