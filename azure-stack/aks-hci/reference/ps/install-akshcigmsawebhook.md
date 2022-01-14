---
title: Install-AksHciGmsaWebhook for AKS on Azure Stack HCI
author: mattbriggs
description: The Install-AksHciGmsaWebhook PowerShell command installs gMSA webhook addon to the cluster.
ms.topic: reference
ms.date: 4/13/2021
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan
---

# Install-AksHciGmsaWebhook

## Synopsis
Installs gMSA webhook add-on to the cluster.

## Syntax

```powershell
Install-AksHciGmsaWebhook -name <String> 
                          [-activity <String>]                      
```

## Description
Installs gMSA webhook addon to the cluster.

## Examples

### Example

```PowerShell
Install-AksHciGmsaWebhook -name mycluster
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
