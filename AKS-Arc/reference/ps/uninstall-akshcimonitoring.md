---
title: Uninstall-AksHciMonitoring for AKS hybrid
author: sethmanheim
description: The Uninstall-AksHciMonitoring PowerShell command removes Prometheus-based monitoring solution.
ms.topic: reference
ms.date: 06/22/2021
ms.author: sethm 
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan

---

# Uninstall-AksHciMonitoring

## Synopsis
Removes Prometheus for monitoring from the AKS hybrid deployment.

## Syntax

```powershell
Uninstall-AksHciMonitoring -name <String>                     
```

## Description
Removes Prometheus for monitoring from the AKS hybrid deployment.

## Examples

### Example

```PowerShell
Uninstall-AksHciMonitoring -name mycluster
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

## Next steps

[AksHci PowerShell Reference](index.md)
