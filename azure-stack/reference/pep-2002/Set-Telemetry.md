---
title: Set-Telemetry
description: Reference for PowerShell Azure Stack privileged endpoint - Close-PrivilegedEndpoint
author: mattbriggs

ms.topic: reference
ms.date: 04/27/2020
ms.author: mabrigg
ms.reviewer: fiseraci
ms.lastreviewed: 04/27/2020
---

# Set-Telemetry

## Synopsis
Enables or disables the transfer of telemetry data to Microsoft.

## Syntax

```
Set-Telemetry [-Disable] [-Enable] [-AsJob]
```

## Description
The Set-Telemetry cmdlet lets you control whether or not
telemetry data is sent to Microsoft by changing the corresponding setting in the registry.

Specifically, this cmdlet configures the domain group policy to set the telemetry
registry value to 0 and stop the Windows UTC service from running on all infrastructure VMs and hosts.

## Examples

### Example 1
```
Set-Telemetry -Enable
```

### Example 2
```
Set-Telemetry -Disable
```

## Parameters

### -Enable
Enables the transfer of telemetry data to Microsoft.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Disable
Disables the transfer of telemetry data to Microsoft.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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
