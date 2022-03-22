---
title: Set-AksHciNodePool for AKS on Azure Stack HCI
author: mkostersitz
description: The Set-AksHciNodePool PowerShell command scales a node pool
ms.topic: reference
ms.date: 3/16/2022
ms.author: mikek
---

# Set-AksHciNodePool

## Synopsis
Scale a node pool within a Kubernetes cluster.

## Syntax
```powershell
Set-AksHciNodePool -clusterName <String>
                   -name <String>
                   -count <int>
                   [-autoScaler <boolean>]
```

## Description
Scale a node pool within a Kubernetes cluster.

## Configure the number of nodes in a node pool

```powershell
Set-AksHciNodePool -clusterName mycluster -name nodepool1 -count 3
```

## Enable horizontal node auto scaler for the node pool
> [!NOTE]  
>This will only work if the horizontal autoscaler is enabled for the cluster.

```powershell
Set-AksHciNodePool -clusterName mycluster -name nodepool1 -autoScaler $true
```

## Disable horizontal node auto scaler for the node pool
> [!NOTE]  
>This will only work if the horizontal autoscaler is enabled for the cluster.

```powershell
Set-AksHciNodePool -clusterName mycluster -name nodepool1 -autoScaler $false
```

### -clusterName
The name of the Kubernetes cluster.

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

### -name
The name of your node pool.

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

### -count
The number of nodes to scale to.

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

### -autoScaler
Toggle the horizontal auto scaler for a node pool

```yaml
Type: System.Boolean
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