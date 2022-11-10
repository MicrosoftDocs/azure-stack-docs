---
title: Get-AksIotClusterJoinData for AKS Lite
author: rcheeran
description: The Get-AksIotClusterJoinData PowerShell command Pulls the cluster join data from a Linux control plane node
ms.topic: reference
ms.date: 10/04/2022
ms.author: rcheeran 
ms.lastreviewed: 10/04/2022
#ms.reviewer: jeguan

---
# Get-AksIotClusterJoinData

## Synopsis
Pulls the cluster join data from a Linux control plane node.

## Syntax

```
Get-AksIotClusterJoinData
```

## Description
Pulls the cluster join data from a Linux control plane node.
This is the control plane endpoint IP and
port as well as the cluster join token.
The information returned can be used to add nodes to existing
clusters.
A new join token will be generated each time this call is made.

## Next steps

[Akslite PowerShell Reference](./index.md)
