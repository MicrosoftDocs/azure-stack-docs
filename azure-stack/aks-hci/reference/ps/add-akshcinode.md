---
title: Add-AksHciNode for AKS on Azure Stack HCI and Windows Server
author: mattbriggs
description: The Add-AksHciNode PowerShell command adds a new physical node to a deployment.
ms.topic: reference
ms.date: 4/16/2021
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan

---

# Add-AksHciNode

## Synopsis
Add a new physical node to a deployment.

## Syntax

```powershell
Add-AksHciNode -nodeName <String>
```

## Description
Add a new physical node to your deployment.

## Examples

### Add a new physical node
```powershell
Add-AksHciNode -nodeName newnode
```

## Parameters

### -nodeName
The name of the node in the failover cluster. The node should already be added to the failover cluster.

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