---
title: Uninstall-AksHciCsiNfs for AKS on Azure Stack HCI and Windows Server
author: mattbriggs
description: The Uninstall-AksHciCsiNfs PowerShell command uninstalls CSI NFS Plugin in a cluster
ms.topic: reference
ms.date: 4/13/2021
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan

---

# Uninstall-AksHciCsiNfs

## Synopsis
Uninstalls CSI NFS Plugin in a cluster.

## Syntax

```powershell
Uninstall-AksHciCsiNfs -name <String>                       
```

## Description
Uninstalls CSI NFS Plugin in a cluster.

## Examples

### Example

```PowerShell
Uninstall-AksHciCsiNfs -name mycluster
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