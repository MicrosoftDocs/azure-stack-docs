---
title: Repair-AksEdgeKms for AKS Edge
author: khareanushka
description: The Remove-AksEdgeNode PowerShell command removes a local node from an existing cluster.
ms.topic: reference
ms.date: 2/18/2025
ms.author: khareanushka
ms.lastreviewed: 2/18/2025
ms.reviewer: 

---


# Repair-AksEdgeKms

Repair the KMS plugin for an existing cluster.

## Syntax

```powershell
Repair-AksEdgeKms
```

## Description

Removes a local node from an existing cluster. This function is supported only for single node and scalable clusters.The command below rehydrates nodeagent tokens required for key rotation to get KMS back in a healthy state.

## Examples
### Repairing the KMS plugin

```powershell
Repair-AksEdgeKms
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## Next steps

[AksEdge PowerShell Reference](./index.md)
