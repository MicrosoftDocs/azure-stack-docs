---
title: Install-AksHciCsiSmb
author: jessicaguan
description: The Install-AksHciCsiSmb PowerShell command Installs CSI SMB Plugin to a cluster
ms.topic: reference
ms.date: 4/13/2021
ms.author: jeguan
---

# Install-AksHciCsiSmb

## Synopsis
Installs the CSI SMB plug-in to a cluster.

## Syntax

```powershell
Install-AksHciCsiSmb -name <String>                       
```

## Description
Installs CSI SMB Plugin to a cluster.

## Examples

### Example

```PowerShell
Install-AksHciCsiSmb -name mycluster
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


