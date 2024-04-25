---
title: Get-AzSDnsServerSettings privileged endpoint for Azure Stack Hub
description: Reference for PowerShell Azure Stack privileged endpoint - Get-AzSDnsServerSettings
author: neilbird
ms.topic: reference
ms.date: 08/16/2023
ms.author: nebird
---

# Get-AzSDnsServerSettings

## Synopsis

Gets the DNS server settings.

> [!NOTE]
> This cmdlet is only available in Azure Stack Hub 1.2206.2.66 and later builds.

## Syntax

```
Get-AzSDnsServerSettings [<CommonParameters>]
```

## Description

Returns the current configuration of the `UseRootHint` setting of the DNS servers in Azure Stack Hub. You can update the configuration by using the [Set-AzSDnsServerSettings](set-azsdnsserversettings.md) cmdlet.

## Examples

### Example 1

```
Get-AzSDnsServerSettings
```

## Parameters

None.

## Next steps

For information about how to access and use the privileged endpoint, see [Use the privileged endpoint in Azure Stack Hub](../../operator/azure-stack-privileged-endpoint.md).
