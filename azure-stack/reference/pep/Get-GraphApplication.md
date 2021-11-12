---
title: Get-GraphApplication privileged endpoint for Azure Stack Hub
description: Reference for PowerShell Azure Stack privileged endpoint - Get-GraphApplication
author: mattbriggs

ms.topic: reference
ms.date: 04/27/2020
ms.author: mabrigg
ms.reviewer: fiseraci
ms.lastreviewed: 04/27/2020
---

# Get-GraphApplication

## Synopsis
Get-GraphApplication is a wrapper function to get the graph application information for the application name or identifier specified.

## Syntax

```
Get-GraphApplication [[-ApplicationIdentifier] <Object>] [-ApplicationName <Object>] [-AsJob]
```

## Description
Invokes the Get-GraphApplicationGroup on ADFS machine to get the graph application information.

## Examples

### Example 1
```
Get-GraphApplication -ApplicationName $ApplicationName
```

## Parameters

### -ApplicationIdentifier
Application Identifier of the application register in AD FS.

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

### -ApplicationName
Application Name of the application registered in ADFS.

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
