---
title: Remove-AksHciAutoScalerProfile for AKS on Azure Stack HCI and Windows Server
author: mkostersitz
description: The Remove-AksHciAutoScalerProfile PowerShell command removes an unused autoscaler configuration profile from the system.
ms.topic: reference
ms.date: 04/15/2022
ms.author: mikek 
ms.lastreviewed: 
ms.reviewer: jeguan

---

# Remove-AksHciAutoScalerProfile

## Synopsis
Remove an unused autoscaler configuration profile from the system.

## Syntax

### Remove an unused autoscaler profile
```powershell
Remove-AksHciAutoScalerProfile -name myProfile
```

## Description
This command will verify that the profile isn't associated with any cluster or node pool and then remove it from the system. If there's still an active autoscaler associated with the profile a respective error message will be displayed and the operation will be stopped.

## Examples

### Remove the autoscaler configuration profile myProfile from the system
```powershell
Remove-AksHciAutoScalerProfile -name myProfile
```

## Parameters

### -name
The alphanumeric name of autoscaler configuration profile.
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