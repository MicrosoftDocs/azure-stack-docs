---
title: Install-AksHciCsiSmb for AKS on Azure Stack HCI
author: mattbriggs
description: The Install-AksHciCsiSmb PowerShell command Installs CSI SMB Plugin to a cluster
ms.topic: reference
ms.date: 4/13/2021
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan

---

# Install-AksHciCsiSmb

## Synopsis
Installs the CSI SMB plug-in to a cluster.

## Syntax

```powershell
Install-AksHciCsiSmb -clusterName <String>                       
```

## Description
Installs CSI SMB Plugin to a cluster.

## Examples

### Example

```PowerShell
Install-AksHciCsiSmb -clusterName mycluster
```

## Parameters

### -clusterName
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


## Next steps

[AksHci PowerShell Reference](index.md)