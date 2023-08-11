---
title: Get-AksHciRelease for AKS hybrid
description: The Get-AksHciRelease PowerShell command Downloads the install and upgrade bits to a local share that was configured in Enable-AksHciOfflineDownload.
ms.topic: reference
ms.date: 04/11/2023
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 04/11/2023
ms.reviewer: jeguan
---

# Get-AksHciRelease

## Synopsis

Downloads the install and upgrade bits to a local share that was configured in [Enable-AksHciOfflineDownload](enable-akshciofflinedownload.md).

## Syntax

```powershell
Get-AksHciRelease [-mode {minimum, full}]
```

## Description

Downloads the install and upgrade bits to a local share that was configured in [Enable-AksHciOfflineDownload](enable-akshciofflinedownload.md).

## Examples

### Download with minimum Linux images and one Kubernetes version

```PowerShell
Get-AksHciRelease -mode minimum
```

### Download with all Linux and Windows images and all supported Kubernetes versions

```Powershell
Get-AksHciRelease -mode full
```

This is the default behavior, and running `Get-AksHciRelease` with no parameters has the same behavior.

## Parameters

### -mode

The download mode you want to use for offline download. Use `minimum` if you want the minimum images for AKS hybrid deployment. This includes the required Linux images and only the required Kubernetes image. Use `full` if you want all images for AKS hybrid deployment. This includes all Linux and Windows images and all supported Kubernetes images. Use this parameter in tandem with the `-offlineDownload` parameter. The default is `full`.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: full
Accept pipeline input: False
Accept wildcard characters: False
```

## Next steps

[AksHci PowerShell Reference](index.md)