---
title: Uninstall-AksHciGmsaWebhook for AKS on Azure Stack HCI and Windows Server
author: sethmanheim
description: The Uninstall-AksHciGmsaWebhook PowerShell command uninstalls the gMSA webhook add-on to the cluster.
ms.topic: reference
ms.date: 2/12/2021
ms.author: sethm 
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan

---

# Uninstall-AksHciGmsaWebhook

## Synopsis
Uninstalls the gMSA webhook add-on to the cluster.

## Syntax

```powershell
Uninstall-AksHciGmsaWebhook -name <String> 
                          [-activity <String>]                      
```

## Description
Uninstalls gMSA webhook addon to the cluster.

## Examples

### Example

```PowerShell
Uninstall-AksHciGmsaWebhook -name mycluster
```

## Parameters

### -name
The alphanumeric name of your Kubernetes cluster.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -activity
The name of the activity when updating progress.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```
## Next steps

[AksHci PowerShell Reference](index.md)