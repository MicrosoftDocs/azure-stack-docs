---
title: Uninstall-AksHciCsiSmb for AKS on Azure Stack HCI
author: mattbriggs
description: The Uninstall-AksHciCsiSmb PowerShell command uninstalls the CSI SMB plug-in in a cluster.
ms.topic: reference
ms.date: 4/13/2021
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan
---

# Uninstall-AksHciCsiSmb

## Synopsis
Uninstalls the CSI SMB plug-in in a cluster.

## Syntax

```powershell
Uninstall-AksHciCsiSmb -name <String>                       
```

## Description
Uninstalls CSI SMB Plugin in a cluster.

## Examples

### Example

```PowerShell
Uninstall-AksHciCsiSmb -name mycluster
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


## Next steps

[AksHci PowerShell Reference](index.md)