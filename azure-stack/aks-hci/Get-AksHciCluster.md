---
title: Get-AksHciCluster
author: jessicaguan
description: The Get-AksHciCluster PowerShell command lists Kubernetes managed clusters including the Azure Kubernetes Service host.
ms.topic: reference
ms.date: 2/12/2021
ms.author: jeguan
---

# Get-AksHciCluster

## Synopsis
List Kubernetes managed clusters including the Azure Kubernetes Service host.

## Syntax

```powershell
Get-AksHciCluster [-name <String>]
```

## Description
List Kubernetes managed clusters including the Azure Kubernete Service host.

## Examples

### List all Kubernetes clusters
```powershell
PS C:\> Get-AksHciCluster
```

## Parameters

### -name
The name of your cluster.

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