---
title: New-AksHciNodePool for AKS on Azure Stack HCI
author: jessicaguan
description: The New-AksHciNodePool PowerShell command creates a new node pool to an existing cluster
ms.topic: reference
ms.date: 7/20/2021
ms.author: jeguan
---

# New-AksHciNodePool

## Synopsis
Create a new node pool to an existing cluster.

## Syntax
```powershell
New-AksHciNodePool -clusterName <String>
                   -name <String>
                  [-count <int>]
                  [-osType <String>]
                  [-vmSize <VmSize>]
```

## Description
Create a new node pool to an existing cluster.

## Example

```powershell
PS C:\> New-AksHciNodePool -clusterName mycluster -name nodepool1
```


### -clusterName
The name of the existing Kubernetes cluster.

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
The name of your node pool. The node pool name must not be the same as another existing node pool.

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
The node count of your node pool. Defaults to 1.

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -osType
The OS type of the nodes in your node pool. Defaults to Linux.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Linux
Accept pipeline input: False
Accept wildcard characters: False
```

### -vmSize
The VM size of the nodes in your node pool. Defaults to Standard_K8S3_v1.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Standard_K8S3_v1
Accept pipeline input: False
Accept wildcard characters: False
```

## Next steps

[AksHci PowerShell Reference](index.md)