---
title: Set-AzSDnsServerSettings privileged endpoint for Azure Stack Hub
description: Reference for PowerShell Azure Stack privileged endpoint - Set-AzSDnsServerSettings
author: neilbird
ms.topic: reference
ms.date: 08/16/2023
ms.author: nebird
---

# Set-AzSDnsServerSettings

## Synopsis

Updates DNS server settings. This cmdlet is used to control the `-UseRootHint` setting for the internal DNS servers. The default value for `-UseRootHint` is enabled (`$true`).

> [!NOTE]
> This cmdlet is only available in Azure Stack Hub 1.2206.2.66 and later builds.

## Syntax

```
Set-AzSDnsServerSettings [-UseRootHint] <boolean>
```

## Description

Provides the ability to change the `-UseRootHint` setting for the internal DNS servers in Azure Stack Hub.

Setting the `-UseRootHint` parameter to `$true` enables DNS root hints on the internal DNS servers. Setting `-UseRootHint` to `$false` disables the DNS root hints functionality.

You can view the current configuration by using the [Get-AzSDnsServerSettings](get-azsdnsserversettings.md) cmdlet.

## Examples

### Example 1

```
Set-AzSDnsServerSettings -UseRootHint $false
```

### Example 2

```
Set-AzSDnsServerSettings -UseRootHint $true
```

## Parameters

### -UseRootHint

Boolean value to control whether the `-UseRootHint` DNS server setting is enabled (`$true`) or disabled (`$false`).

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## Next steps

For information about how to access and use the privileged endpoint, see [Use the privileged endpoint in Azure Stack Hub](../../operator/azure-stack-privileged-endpoint.md).
