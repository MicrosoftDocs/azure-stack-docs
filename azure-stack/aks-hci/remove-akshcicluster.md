---
title: Remove-AksHciCluster
description: The Remove-AksHciCluster PowerShell command deletes a managed Kubernetes cluster.
author: jessicaguan
ms.topic: reference
ms.date: 2/12/2021
ms.author: jeguan
---

# Remove-AksHciCluster

## Synopsis
Delete a managed Kubernetes cluster.

## Syntax

### Delete a managed Kubernetes cluster
```powershell
Remove-AksHciCluster -name 
                    [-force]   
```

## Description
Delete a managed Kubernetes cluster.

## Examples

### Delete an existing managed Kubernetes cluster
```powershell
PS C:\> Remove-AksHciCluster -name myCluster
```

## Parameters

### -name
The name of your Kubernetes cluster.

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
