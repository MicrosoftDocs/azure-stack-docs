---
title: Get-AksIotManagedServiceToken for AKS Lite
author: rcheeran
description: The Get-AksIotManagedServiceToken  PowerShell command gets the AksIot managed service token
ms.topic: reference
ms.date: 10/04/2022
ms.author: rcheeran 
ms.lastreviewed: 10/04/2022
#ms.reviewer: jeguan

---


# Get-AksIotManagedServiceToken

## Synopsis

Gets the AksIot managed service token, for instance for use for Azure ARC for Kubernetes connected cluster.

## Syntax

```powershell
Get-AksIotManagedServiceToken
```

## Description

Gets the AksIot managed service token, for instance for use for Azure ARC for Kubernetes connected cluster.
This commandlet can only be successfully triggered when a control plane node is running on this deployment.

## ExamplesA

```powershell
Get-AksIotManagedServiceToken
```

## Next steps

[Akslite PowerShell Reference](./index.md)
