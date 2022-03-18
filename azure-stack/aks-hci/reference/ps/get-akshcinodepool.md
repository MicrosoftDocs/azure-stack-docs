---
title: Get-AksHciNodePool for AKS on Azure Stack HCI
author: mkostersitz
description: The Get-AksHciNodePool PowerShell command lists the node pools in a Kubernetes cluster.
ms.topic: reference
ms.date: 03/16/2022
ms.author: mikek 
ms.lastreviewed: 
ms.reviewer: jeguan

---

# Get-AksHciNodePool

## Synopsis
Lists the node pools in a Kubernetes cluster.

## Syntax

```powershell
Get-AksHciNodePool -clusterName <String>
                  [-name <String>]
```

## Description
Lists the node pools in a Kubernetes cluster.

## Examples

### List all node pools in a Kubernetes cluster
```powershell
PS C:\> Get-AksHCiNodePool -clusterName mycluster
```

### List a specific node pool in a Kubernetes cluster
```powershell
PS C:\> Get-AksHciNodePool -clusterName mycluster -name nodepool1
```

```output
ClusterName : mycluster
NodePoolName : linuxnodepool
Version : v1.20.7
OsType : Linux
NodeCount : 10
VmSize : Standard_K8S3_v1
Phase : Deployed
AutoScalerEnabled : true
```


## Parameters

### -clusterName
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

### -name
The name of the node pool.

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