---
title: Set-AksHciClusterNodeCount
author: jessicaguan
description: The Set-AksHciClusterNodeCount PowerShell command scales the number of control plane nodes or worker nodes in a cluster.
ms.topic: reference
ms.date: 2/12/2021
ms.author: jeguan
---

# Set-AksHciClusterNodeCount

## Synopsis
Scale the number of control plane nodes or worker nodes in a cluster.

## Syntax

### Scale control plane nodes
```powershell
Set-AksHciClusterNodeCount -name <String>
                           -controlPlaneNodeCount <int> 
```

### Scale worker nodes
```powershell
Set-AksHciClusterNodeCount -name <String>
                           -linuxNodeCount <int>
                           -windowsNodeCount <int>
```

## Description
Scale the number of control plane nodes or worker nodes in a cluster. The control plane nodes and the worker nodes must be scaled independently.

## Examples

### Scale control plane nodes
```powershell
PS C:\> Set-AksHciClusterNodeCount -name myCluster -controlPlaneNodeCount 3
```

### Scale worker nodes
```powershell
PS C:\> Set-AksHciClusterNodeCount -name myCluster -linuxNodeCount 2 -windowsNodeCount 2
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
The number of nodes in your control plane. There is no default value.

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: none
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

### -proxyServerCertFile
The certificate used to authenticate to the proxy server.
 
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

### -windowsNodeCount
The number of Windows nodes in your Kubernetes cluster. Default is 1.

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
