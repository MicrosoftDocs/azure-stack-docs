---
title: Install-AksHciMonitoring for AKS on Azure Stack HCI and Windows Server
author: mattbriggs
description: The Install-AksHciMonitoring PowerShell command deploys Prometheus-based monitoring solution.
ms.topic: reference
ms.date: 2/12/2021
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan

---

# Install-AksHciMonitoring

## Synopsis
Installs Prometheus for monitoring in the Azure Kubernetes Service on Azure Stack HCI and Windows Server deployment.

## Syntax

```powershell
Install-AksHciMonitoring -name <String> 
                         -storageSizeGB <String> 
                         -retentionTimeHours <String>                        
```

## Description
Installs Prometheus for monitoring in the Azure Kubernetes Service on Azure Stack HCI and Windows Server deployment.

## Examples

### Example

```PowerShell
Install-AksHciMonitoring -Name mycluster -storageSizeGB 100 -retentionTimeHours 240
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
The amount of storage in GB.

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
The retention time for collected metrics in hours.

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