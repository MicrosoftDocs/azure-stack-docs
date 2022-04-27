---
title: Install-AksHciCsiNfs for AKS on Azure Stack HCI and Windows Server
author: mattbriggs
description: The Install-AksHciCsiNfs PowerShell command Installs CSI NFS Plugin to a cluster
ms.topic: reference
ms.date: 4/13/2021
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan

---

# Install-AksHciCsiNfs

## Synopsis
Installs the CSI NFS plug-in to a cluster.

## Syntax

```powershell
Install-AksHciCsiNfs -clusterName <String>                       
```

## Description
Installs CSI NFS Plugin to a cluster.

## Examples

### Example

```PowerShell
Install-AksHciCsiNfs -clusterName mycluster
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