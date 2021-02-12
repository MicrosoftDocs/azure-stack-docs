---
title: Get-AksHciKubernetesVersion
author: jessicaguan
ms.topic: reference
ms.date: 2/12/2021
ms.author: jeguan
---

# Get-AksHciKubernetesVersion

## Synopsis
List the available versions for creating a managed Kubernetes cluster.

## Syntax

```powershell
Get-AksHciKubernetesVersion
```

## Description
List the available versions for creating a managed Kubernetes cluster.

## Examples

### Example 
```powershell
PS C:\> Get-AksHciKubernetesVersion
```

```Output
Linux {v1.16.10, v1.16.15, v1.17.11, v1.17.13...}
Windows {v1.18.8, v1.18.10}
```
