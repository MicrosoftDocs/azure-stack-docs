---
title: Set-AksHciAutoScalerProfile for AKS on Azure Stack HCI and Windows Server
author: mkostersitz
description: The Set-AksHciAutoScalerProfile PowerShell command allows reconfiguration of an autoscaler configuration profile
ms.topic: reference
ms.date: 04/15/2022
ms.author: mikek 
ms.lastreviewed: 
ms.reviewer: jeguan

---

# Set-AksHciAutoScalerProfile

## Synopsis
Configure individual settings of an autoscaler configuration profile. 

## Syntax

### Change a setting in an existing autoscaler configuration profile
```powershell
Set-AksHciAutoScalerProfile 
                              -name myProfile 
                              -autoScalerProfileConfig @{ "max-node-count"=5; "min-node-count"=2 }
```

## Description
Changes one or more individual settings of an existing autoscaler configuration profile to a new value.
Possible values to set are:

| ProfileSetting  | Value |
| -------------- | --------- |
| min-node-count | 0 |
| max-node-count | 1 |
| scan-interval | 10 seconds |
| scale-down-delay-after-add | 10 minutes |
| scale-down-delay-after-delete | 10 seconds |
| scale-down-delay-after-failure | 3 minutes  |
| scale-down-unneeded-time | 10 minutes |
| scale-down-unready-time | 20 minutes |
| scale-down-utilization-threshold | 0.5 |
| max-graceful-termination-sec | 600 seconds |
| balance-similar-node-groups | false  |
| expander | random  |
| skip-nodes-with-local-storage | true |
| skip-nodes-with-system-pods | true  |
| max-empty-bulk-delete | 10 nodes   |
| new-pod-scale-up-delay | 0 seconds |
| max-total-unready-percentage | 45% |
| max-node-provision-time | 15 minutes  |
| ok-total-unready-count | 3 nodes  |

## Examples

### Change the minimum and maximum node count
Setting the max-node-count too high can result in failures should the system run out of resources. If that happens. Change the value to a lower setting and wait for the system to catch up. This process can take up to 90 minutes with the default settings.
```powershell
Set-AksHciAutoScalerProfile -name myProfile -autoScalerProfileConfig @{ "max-node-count"=5; "min-node-count"=2 }
```

### Change the time the system waits between scale attempts to 1 minute.
Setting this too low, for example, to 1 second could result in excessive node creation/deletion cycles if this happens. Use the `Set-AksHciCluster -name myCluster -enableAutoScaler $false` command to turn off the autoscaler. Modify the profile to a more moderate value and then re-enable the autoscaler to recover more gracefully.
```powershell
Set-AksHciAutoScalerProfile -name myProfile -autoScalerProfileConfig @{ "scan-interval"="1m" }
```

### Change the time the system waits for a new node to be ready.
```powershell
Set-AksHciAutoScalerProfile -name myProfile -autoScalerProfileConfig @{ "scan-interval"="1m" }
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

### -autoScalerProfileConfig
An array of key-value pairs of parameters to set for the autoscaler configuration profile

```yaml
Type: System.Array
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