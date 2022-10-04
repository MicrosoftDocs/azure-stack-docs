---
title: Set-AksHciOffsiteConfig for AKS on Azure Stack HCI
description: The Set-AksHciOffsiteConfig PowerShell command sets the offsite configuration to use offline download
ms.topic: reference
ms.date: 10/03/2022
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 10/03/2022
ms.reviewer: jeguan
---

# Set-AksHciOffsiteConfig

## Synopsis
Sets the offsite configuration to get the AKS on HCI images with offline downloading at an offsite location.

## Syntax

```powershell
Set-AksHciOffsiteConfig  [-version <String>]
                         -stagingShare <String>
```

## Description
Sets the offsite configuration to get the AKS on HCI images with offline downloading at an offsite location.

## Examples

```PowerShell
Set-AksHciOffsiteConfig -version 1.1.41 -stagingShare c:\akshciimages
```

## Parameters

### -version
The version of AKS on HCI that you want to download. The default is the latest version.

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

### -stagingShare
The local path where the AKS on HCI images will be downloaded. This parameter is required.

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