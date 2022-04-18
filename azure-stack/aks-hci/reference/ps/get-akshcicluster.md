---
title: Get-AksHciCluster for AKS on Azure Stack HCI
author: mkostersitz
description: The Get-AksHciCluster PowerShell command lists Kubernetes managed clusters including the Azure Kubernetes Service host.
ms.topic: reference
ms.date: 03/16/2022
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan

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
Get-AksHciCluster
```

### List a specific Kubernetes cluster
```powershell
Get-AksHciCluster -name mycluster
```

``` output
ProvisioningState :     provisioned
AutoScalerEnabled :     true
AutoScalerProfileName:  myAutoScalerProfile
KubernetesVersion :     v1.20.7
NodePools :             linuxnodepool
WindowsNodeCount :      0
LinuxNodeCount :        0
ControlPlaneNodeCount : 1
ControlPlaneVmSize :    Standard_A4_v2
Name :                  mycluster
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
## Next steps

[AksHci PowerShell Reference](index.md)