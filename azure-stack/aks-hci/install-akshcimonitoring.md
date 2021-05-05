---
title: Install-AksHciMonitoring
author: jessicaguan
description: The Install-AksHciMonitoring PowerShell command deploys Prometheus-based monitoring solution.
ms.topic: reference
ms.date: 2/12/2021
ms.author: jeguan
---

# Install-AksHciMonitoring

## Synopsis
Installs Prometheus for monitoring in the Azure Kubernetes Service on Azure Stack HCI deployment.

## Syntax

```powershell
Install-AksHciMonitoring -name <String> 
                         -storage <String>
                         -retentionTime <String>                        
```

## Description
Installs Prometheus for monitoring in the Azure Kubernetes Service on Azure Stack HCI deployment.

## Examples

### Example

```PowerShell
Install-AksHciMonitoring -name mycluster
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


### -storage
The amount of storage in Gi.

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

### -retentionTime
The retention time in days.

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
