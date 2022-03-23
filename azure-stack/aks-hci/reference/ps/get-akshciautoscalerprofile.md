---
title: Get-AksHciAutoScalerProfile for AKS on Azure Stack HCI
author: mattbriggs
description: The Get-AksHciAutoScalerProfile PowerShell command retrieves a list of autoscaler configuration profiles or a specific autoscaler profile and its settings.
ms.topic: reference
ms.date: 03/16/2022
ms.author: mabrigg 
ms.lastreviewed: 03/16/2022
ms.reviewer: mikek
---

# Get-AksHciAutoScalerProfile

## Synopsis
Retrieve a list of available autoscaler configuration profiles in the system or a specific autoscaler configuration profile and its settings.

## Syntax

### Retrieve a list of autoscaler configuration profiles
```powershell
Get-AksHciAutoScalerProfile
```

```output
Name                    Cluster
----------              --------------
default                 myCluster, clusterProd2,...
myProfile2              staging3,dev3,dev2,...
myProfile4              myCluster2
```

### Retrieve the settings of a specific autoscaler profile
```powershell
Get-AksHciAutoScalerProfile -name myProfile
```

```output
ProfileSetting                   Value
--------------                   ---------
name                             myProfile
scan-interval                    10 seconds
scale-down-delay-after-add       10 minutes
scale-down-delay-after-delete    10 seconds
scale-down-delay-after-failure   3 minutes 
scale-down-unneeded-time         10 minutes
scale-down-unready-time          20 minutes
scale-down-utilization-threshold 0.5
max-graceful-termination-sec     600 seconds
balance-similar-node-groups      false     
expander                         random 
skip-nodes-with-local-storage    true
skip-nodes-with-system-pods      true 
max-empty-bulk-delete            10 nodes  
new-pod-scale-up-delay           0 seconds
max-total-unready-percentage     45%
max-node-provision-time          15 minutes      
ok-total-unready-count           3 nodes   
clusters                         [myCluster1,dev2,dev3,...]
```
## Parameters

### -name
The alphanumeric name of the autoscaler configuration profile.

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