---
title: Get-AksEdgeManagedServiceToken for AKS Edge
author: rcheeran
description: The Get-AksEdgeManagedServiceToken  PowerShell command gets the AksEdge managed service token
ms.topic: reference
ms.date: 10/04/2022
ms.author: rcheeran 
ms.lastreviewed: 10/04/2022
#ms.reviewer: jeguan

---


# Get-AksEdgeManagedServiceToken

## Synopsis

Gets the AksEdge managed service token, for instance for use for Azure ARC for Kubernetes connected cluster.

## Syntax

```powershell
Get-AksEdgeManagedServiceToken
```

## Description

Gets the AksEdge managed service token, for instance for use for Azure ARC for Kubernetes connected cluster.
This commandlet can only be successfully triggered when a control plane node is running on this deployment.

## Examples

```powershell
Get-AksEdgeManagedServiceToken
```

## Next steps

[AksEdge PowerShell Reference](./index.md)
