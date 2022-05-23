---
title: Get-AksHciClusterUpdates for AKS on Azure Stack HCI and Windows Server
author: mattbriggs
description: The Get-AksHciClusterUpdates PowerShell command gets the available upgrades for an Azure Kubernetes Service cluster.
ms.topic: reference
ms.date: 04/12/2021
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan

---

# Get-AksHciClusterUpdates

## Synopsis
Get the available upgrades for an Azure Kubernetes Service cluster.

## Syntax

```powershell
Get-AksHciClusterUpdates -name <String>
                          
```

## Description
Get the available upgrades for an Azure Kubernetes Service cluster.

## Examples

```powershell
Get-AksHciClusterUpdates -name mycluster
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
## Next steps

[AksHci PowerShell Reference](index.md)