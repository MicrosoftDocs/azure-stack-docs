---
title: Test-AksIotNetworkParameters for AKS Lite
author: rcheeran
description: The Test-AksIotNetworkParameters PowerShell command validates AksIot network parameters,
ms.topic: reference
ms.date: 10/04/2022
ms.author: rcheeran 
ms.lastreviewed: 10/04/2022
#ms.reviewer: jeguan

---

# Test-AksIotNetworkParameters

## SYNOPSIS
Validates AksIot network parameters, useful as a pre-deployment step.

## SYNTAX

### fromJsonConfigFile (Default)
```
Test-AksIotNetworkParameters [-JsonConfigFilePath <String>] [<CommonParameters>]
```

### fromParameters
```
Test-AksIotNetworkParameters [-WorkloadType <WorkloadType>] [-LinuxVmIp4Address <String>]
 [-WindowsVmIp4Address <String>] [-ControlPlaneEndpointIp <String>] [-ServiceIPRangeStart <String>]
 [-ServiceIPRangeEnd <String>] [-Ip4PrefixLength <Int32>] [-Ip4GatewayAddress <String>]
 [-DnsServers <String[]>] [-SkipAddressFreeCheck] [<CommonParameters>]
```

### fromJsonConfigString
```
Test-AksIotNetworkParameters -JsonConfigString <String> [<CommonParameters>]
```

## DESCRIPTION
Validates AksIot network parameters, useful as a pre-deployment step.
For a documentation of the
parameters, see the New-AksIotDeployment commandlet.

## EXAMPLES

### Example 1
```powershell
Test-AksIotNetworkParameters -WorkloadType Linux
```

{{ Add example description here }}

## PARAMETERS

### -WorkloadType
{{ Fill WorkloadType Description }}

```yaml
Type: WorkloadType
Parameter Sets: fromParameters
Aliases:
Accepted values: Linux, Windows, LinuxAndWindows

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LinuxVmIp4Address
{{ Fill LinuxVmIp4Address Description }}

```yaml
Type: String
Parameter Sets: fromParameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WindowsVmIp4Address
{{ Fill WindowsVmIp4Address Description }}

```yaml
Type: String
Parameter Sets: fromParameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ControlPlaneEndpointIp
{{ Fill ControlPlaneEndpointIp Description }}

```yaml
Type: String
Parameter Sets: fromParameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServiceIPRangeStart
{{ Fill ServiceIPRangeStart Description }}

```yaml
Type: String
Parameter Sets: fromParameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServiceIPRangeEnd
{{ Fill ServiceIPRangeEnd Description }}

```yaml
Type: String
Parameter Sets: fromParameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Ip4PrefixLength
{{ Fill Ip4PrefixLength Description }}

```yaml
Type: Int32
Parameter Sets: fromParameters
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Ip4GatewayAddress
{{ Fill Ip4GatewayAddress Description }}

```yaml
Type: String
Parameter Sets: fromParameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DnsServers
{{ Fill DnsServers Description }}

```yaml
Type: String[]
Parameter Sets: fromParameters
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipAddressFreeCheck
{{ Fill SkipAddressFreeCheck Description }}

```yaml
Type: SwitchParameter
Parameter Sets: fromParameters
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -JsonConfigString
{{ Fill JsonConfigString Description }}

```yaml
Type: String
Parameter Sets: fromJsonConfigString
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -JsonConfigFilePath
{{ Fill JsonConfigFilePath Description }}

```yaml
Type: String
Parameter Sets: fromJsonConfigFile
Aliases:

Required: False
Position: Named
Default value: $(Get-DefaultJsonConfigFileLocation)
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
