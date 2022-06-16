---
title: Invoke-AksHciRotateCACertificate for AKS on Azure Stack HCI and Windows Server
description: The Invoke-AksHciRotateCACertificate PowerShell command rotates the Cloudagent CA certificates.
author: sethmanheim
ms.topic: reference
ms.date: 6/16/2022
ms.author: sethm 
ms.lastreviewed: 6/16/2022
ms.reviewer: jeguan

---

# Invoke-AksHciRotateCACertificate

## Synopsis

Rotates the the Cloudagent CA certificates.

## Syntax

```powershell
Invoke-AksHciRotateCACertificate 
```

## Description

Rotates the the Cloudagent CA certificates. **This command will cause some service downtime and should be used with caution.**

## Examples

### Example

```PowerShell
Invoke-AksHciRotateCACertificate 
```

## Next steps

[AksHci PowerShell Reference](index.md)
