---
title: Set-AksHciCluster for AKS on Azure Stack HCI
author: mkostersitz
description: The Set-AksHciCluster PowerShell command scales the number of control plane nodes, enable or disable the auto scaler, set the auto scaler configuration profile.
ms.topic: reference
ms.date: 03/16/2022
ms.author: mikek 
ms.lastreviewed: 
ms.reviewer: jeguan

---

# Set-AksHciCluster

## Synopsis
Scale the number of control plane nodes, enable or disable the auto scaler, set the auto scaler configuration profile.

## Syntax

### Scale control plane nodes
```powershell
Set-AksHciCluster -name <String>
                  -controlPlaneNodeCount <int> 
                  -enableAutoScaler <boolean>
                  -autoScalerProfileName <string>
```

## Description
Scale the number of control plane nodes or worker nodes in a cluster. The control plane nodes and the worker nodes must be scaled independently.

## Examples

### Scale control plane nodes
```powershell
PS C:\> Set-AksHciCluster -name myCluster -controlPlaneNodeCount 3
```

### Enable the auto scaler with the default configuration profile
```powershell
PS C:\> Set-AksHciCluster -name myCluster -enableAutoScaler $true
```

### Enable the auto scaler with a named configuration profile
```powershell
PS C:\> Set-AksHciCluster -name myCluster -enableAutoScaler $true -autoScalerProfileName myAutoScalerProfile
```

### Disable the auto scaler 
```powershell
PS C:\> Set-AksHciCluster -name myCluster -enableAutoScaler $false
```

### Change the auto scaler configuration profile
```powershell
PS C:\> Set-AksHciCluster -name myCluster -autoScalerProfileName anotherAutoScalerProfile
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

### -enableAutoScaler
If set to '$true': Enables the workernode autoscaler for the specified AKS on Azure Stack HCI cluster. All nodepools in the cluster will now automatically scale from the minimum to the maximum number of nodes based on demand for additional nodes when the Kubernetes scheduler is not able to find sufficient worker node resources to schedule pods. See the documentation [Link to auto scaler doc.md](link to autoscalerdoc.md) for more details.
If set to $false: Disables the auto scaler for the specified cluster. The node pools in the cluster will remain at the scale they were when the auto scaler was disabled.
>![NOTE]
> Unlike in Azure the auto scaler in AKS on Azure Stack HCI does not have unlimited resources available. It does not reserve resources to ensure automatic scaling can always succeed. If there are other workloads in the cluster i.e. virtual machines, AKS clusters etc. consuming resources, the auto scaler can potentially fail. You can use the 'kubectl get events' command to determine the reason why an auto scaler operation has failed. The auto scaler will retry a failed operation based on the settings in the auto scaler configuration profile.  See the documentation [Link to auto scaler doc.md](link to autoscalerdoc.md) for more details.
 
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

### -autoScalerProfleName
The Name of the auto scaler configuration profile that was defined by the 'New-AksHciAutoScalerProfile' command. If not specified the default profile is used.  See the documentation [Link to auto scaler doc.md](link to autoscalerdoc.md) for more details.

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

>![NOTE]
>The paramters 'windowsNodeCount' and 'linuxNodeCount' have been deprecated and removed from the 'Set-AksHciCLuster' command. Please use the 'count' parameter for the  'Set-AksHciNodePool' command to manually change the number of worker nodes in a nodepool of a AKS on Azure Stack HCI cluster.

## Next steps

[AksHci PowerShell Reference](index.md)