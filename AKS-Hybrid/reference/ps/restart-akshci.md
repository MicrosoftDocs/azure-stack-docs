---
title: Restart-AksHci for AKS hybrid
author: sethmanheim
description: The Restart-AksHci PowerShell command restarts AKS hybrid and removes all deployed Kubernetes clusters.
ms.topic: reference
ms.date: 2/12/2021
ms.author: sethm 
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan

---

# Restart-AksHci

## Synopsis
Restart AKS hybrid and remove all deployed Kubernetes clusters.

## Syntax

### Restart AKS-HCI
```powershell
Restart-AksHci
```

## Description
Restarting AKS hybrid removes all of your Kubernetes clusters if any, and the Azure Kubernetes Service host. It also uninstalls the AKS hybrid agents and services from the nodes. It then goes back through the original install process steps until the host is recreated. The AKS hybrid configuration that you configured via **Set-AksHciConfig** and the downloaded VHDX images is preserved.

## Examples

### Example

```powershell
Restart-AksHci
```

## Next steps

[AksHci PowerShell Reference](index.md)