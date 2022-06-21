---
title: Update-AksHciCertificates for AKS on Azure Stack HCI and Windows Server
description: The Update-AksHciCertificates PowerShell command rotates tokens and certificates of all clients in the management cluster.
author: sethmanheim
ms.topic: reference
ms.date: 6/16/2022
ms.author: sethm 
ms.lastreviewed: 6/16/2022
ms.reviewer: jeguan

---

# Update-AksHciCertificates

## Synopsis

Rotates the tokens and certificates of all clients in the AKS on Azure Stack HCI and Windows Server host.

## Syntax

```powershell
Update-AksHciCertificates [-force]
```

## Description

Rotates the tokens and certificates of all clients in the AKS on Azure Stack and Windows Server HCI host.

## Examples

### Example

```PowerShell
Update-AksHciCertificates
```

## Parameters

### -force

Use this flag to force token and certificate rotation regardless of expiry dates.

```yaml
Type: System.Management.Automation.SwitchParameter
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
