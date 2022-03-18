---
title: Send-AzureStackDiagnosticLog privileged endpoint for Azure Stack Hub
description: Reference for PowerShell Azure Stack privileged endpoint - Send-AzureStackDiagnosticLog
author: BryanLa

ms.topic: reference
ms.date: 04/27/2020
ms.author: bryanla
ms.reviewer: fiseraci
ms.lastreviewed: 04/27/2020
---

# Send-AzureStackDiagnosticLog

## Synopsis
Sends Azure Stack Hub diagnostic logs to Microsoft.

## Syntax

```
Send-AzureStackDiagnosticLog [[-FromDate] <Object>] [[-FilterByResourceProvider] <Object>]
 [[-FilterByRole] <Object>] [[-ToDate] <Object>] [-AsJob]
```

## Description
Makes a request to Support Bridge Service to upload diagnostic logs for stamp.

## Examples

### Example 1

The example below sends last 4 hour logs to Microsoft.

```
PS  C:\> Send-AzureStackDiagnosticLog
```

### Example 2
The example below sends last 4 hour Support Service and WAS logs to Microsoft.
```
PS  C:\> Send-AzureStackDiagnosticLog -FilterByRole SupportBridgeController,WAS
```

## Parameters

### -FilterByRole
Optional.
Filter by Infrastructure Role type.

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

### -FilterByResourceProvider
Optional.
Filter by Value-add resource provider type.

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

### -FromDate
Optional.
Start time to use for logs to collect.

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

### -ToDate
Optional.
End time to use for logs to collect.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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
