---
title: Set-CloudAdminUserPassword privileged endpoint for Azure Stack Hub
description: Reference for PowerShell Azure Stack privileged endpoint - Set-CloudAdminUserPassword
author: BryanLa

ms.topic: reference
ms.date: 04/27/2020
ms.author: bryanla
ms.reviewer: fiseraci
ms.lastreviewed: 04/27/2020
---

# Set-CloudAdminUserPassword

## Syntax

```
Set-CloudAdminUserPassword [[-UserName] <Object>] [[-CurrentPassword] <Object>] [[-NewPassword] <Object>]
 [-AsJob]
```

## Parameters

### -CurrentPassword
 

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

### -NewPassword
 

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

### -UserName
 

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
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
