---
title: Set-AksEdgeArcConnection for AKS Edge
author: rcheeran
description: The Set-AksEdgeArcConnection  PowerShell command connects or disconnects the AKS on Windows IoT cluster 
ms.topic: reference
ms.date: 10/04/2022
ms.author: rcheeran 
ms.lastreviewed: 10/04/2022
#ms.reviewer: jeguan

---


# Set-AksEdgeArcConnection

## Synopsis

Connects or disconnects the AksEdge cluster running on this machine to or from Azure Arc for
Kubernetes.

## Syntax

### fromJsonConfigFile (Default)

```powershell
Set-AksEdgeArcConnection [-Credential <PSCredential>] [-JsonConfigFilePath <String>] [<CommonParameters>]
```

### fromParameters

```powershell
Set-AksEdgeArcConnection [-ClusterName <String>] -TenantId <String> -SubscriptionId <String>
 -ResourceGroupName <String> -Location <String> [-Credential <PSCredential>] [-Connect <Boolean>]
 [<CommonParameters>]
```

### fromJsonConfigString

```powershell
Set-AksEdgeArcConnection [-Credential <PSCredential>] -JsonConfigString <String> [<CommonParameters>]
```

## Description

Connects or disconnects the AksEdge cluster running on this machine to or from Azure Arc for
Kubernetes.
Running this modules requires an up to date version of the Az.ConnectedKubernetes and Az.Accounts modules
as well as an up to date helm version in the binary path.

## Examples

### Example 1

```
Set-AksEdgeArcConnection -ResourceGroupName testResourceGroup -Location testLocation -Connect $true
```

### Example 2

```powershell
Set-AksEdgeArcConnection -ResourceGroupName testResourceGroup -Location testLocation -Connect $false
```

### Example 3

```powershell
-ResourceGroupName testResourceGroup -Location testLocation
```

### Example 4

```powershell
-ResourceGroupName testResourceGroup -Location testLocation -Credential <PSCredential>
```

## Parameters

### -ClusterName

Name of the cluster in the Azure Arc for Kubernetes cluster projection.
If no value is specified, the
local Linux node name will be used.

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

### -TenantId

Tenant ID for Azure.
This is a required parameter when authenticating with a service principal (either
through the service principal name parameter or via the credential object)

```yaml
Type: String
Parameter Sets: fromParameters
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SubscriptionId

Subscription ID for Azure

```yaml
Type: String
Parameter Sets: fromParameters
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceGroupName

Azure resource group for the connected cluster

```yaml
Type: String
Parameter Sets: fromParameters
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Location

Name of the Azure location where the resource group lives.

```yaml
Type: String
Parameter Sets: fromParameters
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential

Credential object for the Azure service principal to use for the connection.
When not provided, an interactive login prompt that allows AD authentication will appear.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Connect

This boolean toggles between connecting and disconnecting the cluster.
By default, the cluster will be connected.

```yaml
Type: Boolean
Parameter Sets: fromParameters
Aliases:

Required: False
Position: Named
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -JsonConfigString

Input parameters based on a JSON string.
No other parameters may be specified.

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

Input parameters based on a JSON file.
No other parameters may be specified.

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

## Next steps

[AksEdge PowerShell Reference](./index.md)
