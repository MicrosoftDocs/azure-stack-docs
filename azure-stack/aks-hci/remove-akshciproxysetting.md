---
title: Remove-AksHciProxySetting
author: mkostersitz
description: The Remove-AksHciProxySetting PowerShell command removes a proxy configuration.
ms.topic: reference
ms.date: 4/16/2021
ms.author: mikek
---

# Remove-AksHciProxySetting

## Synopsis

Remove a proxy settings object.

## Syntax

```powershell
Remove-AksHciProxySetting -name <String>
```

## Description

Deletes the specified proxy settings object.
> [!Note]
> The proxy settings object can only be deleted once all workload clusters are removed.

## Examples

### Example

```powershell
PS C:\> Remove-AksHciMacPoolSetting -name myProxy
```

### -name

The alphanumeric name of your proxy settings object.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```
