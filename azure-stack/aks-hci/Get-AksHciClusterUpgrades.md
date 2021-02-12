---
title: Get-AksHciClusterUpgrades
author: jessicaguan
description: The Get-AksHciClusterUpgrades PowerShell command gets the available Kubernetes upgrades for an Azure Kubernetes Service cluster.
ms.topic: reference
ms.date: 2/12/2021
ms.author: jeguan
---

# Get-AksHciClusterUpgrades

## Synopsis
Get the available Kubernetes upgrades for an Azure Kubernetes Service cluster.

## Syntax

```powershell
Get-AksHciClusterUpgrades -name <String>
                          
```

## Description
Get the available Kubernetes upgrades for an Azure Kubernetes Service cluster.

## Examples

```powershell
PS C:\> Get-AksHciClusterUpgrades -name mycluster
```

## Parameters

### -name
The alphanumeric name of your cluster.

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