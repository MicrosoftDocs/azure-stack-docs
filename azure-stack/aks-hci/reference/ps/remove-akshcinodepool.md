---
title: Remove-AksHciNodePool for AKS on Azure Stack HCI
author: mattbriggs
description: The Remove-AksHciNodePool PowerShell command deletes a node pool from a cluster
ms.topic: reference
ms.date: 7/20/2021
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan
---

# Remove-AksHciNodePool

## Synopsis
Delete a node pool from a cluster.

## Syntax
```powershell
Remove-AksHciNodePool -clusterName <String>
                      -name <String>
```

## Description
Delete a node pool from a cluster.


## Example

```powershell
PS C:\> Remove-AksHciNodePool -clusterName mycluster -name nodepool1
```


### -clusterName
The name of the existing Kubernetes cluster.

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

### -name
The name of your node pool.

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
