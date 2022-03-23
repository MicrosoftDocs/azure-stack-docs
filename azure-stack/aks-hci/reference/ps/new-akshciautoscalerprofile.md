---
title: New-AksHciAutoScalerProfile for AKS on Azure Stack HCI
author: mkostersitz
description: The New-AksHciAutoScalerProfile PowerShell command creates an autoscaler configuration profile
ms.topic: reference
ms.date: 03/16/2022
ms.author: mikek 
ms.lastreviewed: 03/16/2022
ms.reviewer: jeguan

---

# New-AksHciAutoScalerProfile

## Synopsis
Create a new autoscaler configuration profile for the node pool autoscaler.
Auto scaler configuration profiles are stored on an AKS on Azure Stack HCI deployment wide basis and can be reused across multiple clusters.
Changing a profile will impact all clusters using that profile.

## Syntax

### Create a new autoscaler configuration profile

```powershell
New-AksHciAutoScalerProfile 
                            -name myProfile 
                            -autoScalerProfileConfig @{ "min-node-count"=2; "max-node-count"=7; 'scale-down-unneeded-time'='1m'}
```

## Description

Create a new autoscaler configuration profile setting the minimum node count to 2, the maximum node count to 7 and the time the system will wait until unneeded nodes are scaled down again to 1 minute. 

## Examples

### Create a copy of the default autoscaler configuration profile with a minimum node count of 1 and a maximum node count of 3

```powershell
New-AksHciAutoScalerProfile -name myProfile -autoScalerProfileConfig @{ "min-node-count"=1; "max-node-count"=3}
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

### -autoScalerProfileConfig
An array of the key-value pair parameters to change from the default profile values. If not specified the default values are assumed. See the documentation [Use the autoscaler profile to configure cluster autoscaler](../../work-with-autoscaler-profiles.md) for more details.
Default values for min-node-count is 0 and max-node-count is 1.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

## Next steps

[AksHci PowerShell Reference](index.md)