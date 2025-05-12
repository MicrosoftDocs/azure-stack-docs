---
title: Repair-AksEdgeKms for AKS Edge
description: The Repair-AksEdgeKms command repairs the KMS plugin for an existing cluster
author: sethmanheim
ms.topic: reference
ms.date: 3/10/2025
ms.author: sethm
ms.lastreviewed: 3/10/2025
ms.reviewer: khareanushka

---


# Repair-AksEdgeKms

Repairs the KMS plugin for an existing cluster.

## Syntax

```powershell
Repair-AksEdgeKms
```

## Description

This command repairs the KMS plugin for an existing cluster. This function is supported only for single node and scalable clusters. To get the KMS plugin back to a healthy state, the command rehydrates **nodeagent** tokens required for key rotation.

## Examples

### Repair the KMS plugin

```powershell
Repair-AksEdgeKms
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## Next steps

[AksEdge PowerShell Reference](./index.md)
