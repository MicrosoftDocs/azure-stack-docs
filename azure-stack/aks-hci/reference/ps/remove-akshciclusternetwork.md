---
title: Remove-AksHciClusterNetwork for AKS on Azure Stack HCI
author: mattbriggs
description: The Remove-AksHciClusterNetwork PowerShell command removes a virtual network.
ms.topic: reference
ms.date: 4/12/2021
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: mikek

---

# Remove-AksHciClusterNetwork

## Synopsis
Remove an object for a new virtual network.

## Syntax
```powershell
Remove-AksHciClusterNetwork -name <String>
                    
```

## Description
Remove a virtual network from the system. If there is a cluster associated with the network the command will fail. You need to remove all clusters associated with the network first. 
You can get a list of clusters associated with the network by running `Get-AksHciClusterNetwork -name <name of the network>`.

## Examples

### Remove the cluster network named "MyClusterNetwork"

```powershell
PS C:\> Remove-AksHciClusterNetwork -name MyClusterNetwork
```

> [!NOTE]
> The values given in this example command will need to be customized for your environment.
> If a cluster is associated with the network the command will fail

## Parameters

### -name
The name of your cluster network to remove

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