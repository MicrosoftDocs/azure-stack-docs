---
title: Uninstall-AksHciMonitoring for AKS on Azure Stack HCI
author: jessicaguan
description: The Uninstall-AksHciMonitoring PowerShell command removes Prometheus-based monitoring solution.
ms.topic: reference
ms.date: 06/22/2021
ms.author: jeguan
---

# Uninstall-AksHciMonitoring

## Synopsis
Removes Prometheus for monitoring from the Azure Kubernetes Service on Azure Stack HCI deployment.

## Syntax

```powershell
Uninstall-AksHciMonitoring -name <String>                     
```

## Description
Removes Prometheus for monitoring from the Azure Kubernetes Service on Azure Stack HCI deployment.

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