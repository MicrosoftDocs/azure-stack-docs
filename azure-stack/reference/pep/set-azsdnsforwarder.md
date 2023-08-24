---
title: Set-AzSDnsForwarder privileged endpoint for Azure Stack Hub
description: Reference for PowerShell Azure Stack privileged endpoint - Set-AzSDnsForwarder
author: neilbird
ms.topic: reference
ms.date: 08/16/2023
ms.author: nebird
---

# Set-AzSDnsForwarder

## Synopsis

Updates the DNS forwarder configuration.

## Syntax

```
Set-AzSDnsForwarder -IPAddress <System.Net.IPAddress>
```

## Description

Updates the DNS forwarder IP addresses used in Azure Stack Hub. You can view the current configuration by using the [Get-AzSDnsForwarder](get-azsdnsforwarder.md) cmdlet.

## Examples

### Example 1

```
Set-AzsDnsForwarder -IPAddress "IPAddress 1","IPAddress 2"
```

## Parameters

### -IPAddress

An array of IPv4 IP address(es) used by Azure Stack Hub for forwarding DNS queries.

```yaml
Type: System.Net.IPAddress
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## Next steps

For information about how to access and use the privileged endpoint, see [Use the privileged endpoint in Azure Stack Hub](../../operator/azure-stack-privileged-endpoint.md).
