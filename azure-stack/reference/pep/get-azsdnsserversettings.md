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

## Syntax

```
Get-AzSDnsServerSettings [<CommonParameters>]
```

## Description

Returns the current configuration of the "UseRootHint" setting of the DNS servers in Azure Stack Hub. The configuration can be updated using the [Set-AzSDnsServerSettings](set-azsdnsserversettings.md) cmdlet.

## Examples

### Example 1

```
Get-AzSDnsServerSettings
```

## Parameters


## Next steps

For information on how to access and use the privileged endpoint, see [Use the privileged endpoint in Azure Stack Hub](../../operator/azure-stack-privileged-endpoint.md).
