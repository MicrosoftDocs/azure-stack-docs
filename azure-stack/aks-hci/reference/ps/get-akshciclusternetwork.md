---
title: Get-AksHciClusterNetwork for AKS on Azure Stack HCI
author: mkostersitz
description: The Get-AksHciClusterNetwork PowerShell command retrieves virtual network settings.
ms.topic: reference
ms.date: 5/11/2021
ms.author: mikek
---

# Get-AksHciClusterNetwork

## Synopsis
Retrieve virtual network settings by name, cluster name, or a list of all vnet settings in the system.

## Syntax

```powershell
Get-AksHciClusterNetwork -name <String>
                         -clusterName <String>                    
```

## Description
Gets the VirtualNetwork object for a target cluster given either the vnet name or the cluster name. If no parameter is given, then all vnet's are returned.

## Examples

### Get the configuration of a vnet named "MyClusterVnet1"

```powershell
PS C:\> $clusterVNet = Get-AksHciClusterNetwork -name MyClusterVnet1
```

### Get the vnet associated with a cluster named "MyCluster"

```powershell
PS C:\> $clusterVNet = Get-AksHciClusterNetwork -clusterName MyCluster
```

### Get all vNet configurations in the system

```powershell
PS C:\> $allClusterVNets = Get-AksHciClusterNetwork
```

> [!NOTE]
> The values given in this example command will need to be customized for your environment.

> [!NOTE]
> The cmdlet will throw an exception if the mgmt cluster is not running or not installed.

## Parameters

### -name
The descriptive name of your vnet. To get a list of the names of your available vNets, run the command `Get-AksHciClusterNetwork` without a parameter.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -clusterName
The descriptive name of your cluster. To get a list of the names of your available clusters, run the command `Get-AksHciCluster` without a parameter.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```
## Next steps

[AksHci PowerShell Reference](index.md)