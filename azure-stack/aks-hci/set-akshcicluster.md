---
title: Set-AksHciCluster
author: jessicaguan
description: The Set-AksHciCluster PowerShell command scales the number of control plane nodes or worker nodes in a cluster.
ms.topic: reference
ms.date: 04/12/2021
ms.author: jeguan
---

# Set-AksHciCluster

## Synopsis
Scale the number of control plane nodes or worker nodes in a cluster.

## Syntax

### Scale control plane nodes
```powershell
Set-AksHciCluster -name <String>
                  -controlPlaneNodeCount <int> 
```

### Scale worker nodes
```powershell
Set-AksHciCluster -name <String>
                  -linuxNodeCount <int>
                  -windowsNodeCount <int>
```

## Description
Scale the number of control plane nodes or worker nodes in a cluster. The control plane nodes and the worker nodes must be scaled independently.

## Examples

### Scale control plane nodes
```powershell
PS C:\> Set-AksHciCluster -name myCluster -controlPlaneNodeCount 3
```

### Scale worker nodes
```powershell
PS C:\> Set-AksHciCluster -name myCluster -linuxNodeCount 2 -windowsNodeCount 2
```

## Parameters

### -name
The alphanumeric name of your Kubernetes cluster.

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

### -controlPlaneNodeCount
The number of nodes in your control plane. Default is 1.

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -linuxNodeCount
The number of Linux nodes in your Kubernetes cluster. Default is 1.

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -windowsNodeCount
The number of Windows nodes in your Kubernetes cluster. Default is 1.

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```
