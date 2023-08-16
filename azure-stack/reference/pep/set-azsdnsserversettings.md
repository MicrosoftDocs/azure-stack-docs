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

Gets the DNS server settings.

## Syntax

```
Set-AzSDnsServerSettings [-UseRootHint]
```

## Description

Provides the ability to change the "UseRootHint" setting of the DNS servers in Azure Stack Hub. The current configuration can be viewed using the [Get-AzSDnsServerSettings](get-azsdnsserversettings.md) cmdlet.

## Examples

### Example 1

```
Set-AzSDnsServerSettings -UseRootHint $false
```

## Parameters

### -UseRootHint

Boolean value to control if the "UseRootHints" DNS server setting is enabled ($true) or disabled ($false).

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

For information on how to access and use the privileged endpoint, see [Use the privileged endpoint in Azure Stack Hub](../../operator/azure-stack-privileged-endpoint.md).
