---
title: Start-AzsCryptoWipe privileged endpoint for Azure Stack Hub
description: Reference for PowerShell Azure Stack privileged endpoint - Start-AzsCryptoWipe
author: sethmanheim
ms.topic: reference
ms.date: 03/22/2023
ms.author: sethm
---

# Start-AzsCryptoWipe

## Synopsis

Performs cryptographic wipe of Azure Stack Hub infrastructure.

## Syntax

```powershell
Start-AzsCryptoWipe [-WhatIf] [-Confirm] [<CommonParameters>]
```

## Description

Destroys Azure Stack Hub infrastructure and performs cryptographic wipe. After this command is executed, the stamp is not recoverable.

## Next steps

For information about how to access and use the privileged endpoint, see [Use the privileged endpoint in Azure Stack Hub](../../operator/azure-stack-privileged-endpoint.md).
