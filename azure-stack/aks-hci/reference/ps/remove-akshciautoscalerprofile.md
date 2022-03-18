---
title: Remove-AksHciAutoScalerProfile for AKS on Azure Stack HCI
author: mkostersitz
description: The Remove-AksHciAutoScalerProfile PowerShell command removes an unused auto scaler configuration profile from the system.
ms.topic: reference
ms.date: 03/16/2022
ms.author: mikek 
ms.lastreviewed: 
ms.reviewer: jeguan

---

# Remove-AksHciAutoScalerProfile

## Synopsis
Remove an unused auto scaler configuration profile from the system.

## Syntax

### Remove an unused auto scaler profile
```powershell
Remove-AksHciAutoScalerProfile -name myProfile
```

## Description
This command will verify that the profile is not associated with any cluster or node pool and then remove it from the system. If there is still an active auto scaler associated witht the profile a respective error message will be displayed and the operation will be stopped.

## Examples

### Remove the auto scaler configuration profile myProfile from the system
```powershell
PS C:\> Remove-AksHciAutoScalerProfile -name myProfile
```

## Parameters

### -name
The alphanumeric name of auto scaler configuration profile.
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