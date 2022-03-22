---
title: Uninstall-AksHciAdAuth for AKS on Azure Stack HCI
author: mattbriggs
description: The Uninstall-AksHciAdAuth PowerShell command uninstalls AD authentication.
ms.topic: reference
ms.date: 2/12/2021
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan

---

# Uninstall-AksHciAdAuth

## Synopsis
Uninstall Active Directory authentication.

## Syntax

```powershell
Uninstall-AksHciAdAuth -name <String>
```

## Description
Uninstall Active Directory authentication.

## Examples

### Example
```powershell
Uninstall-AksHciAksHciAdAuth -name myCluster
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