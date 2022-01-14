---
title: Remove-AksHciCluster for AKS on Azure Stack HCI
description: The Remove-AksHciCluster PowerShell command deletes a managed Kubernetes cluster.
author: mattbriggs
ms.topic: reference
ms.date: 2/12/2021
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan

---

# Remove-AksHciCluster

## Synopsis
Delete a managed Kubernetes cluster.

## Syntax

### Delete a managed Kubernetes cluster
```powershell
Remove-AksHciCluster -name 
                    [-force]   
```

> [!NOTE]
> Make sure that your cluster is deleted by looking at the existing VMs. If they are not deleted, then you can manually delete the VMs. Then, run the command `Restart-Service wssdagent`. This should be done on each node in the failover cluster.

## Description
Delete a managed Kubernetes cluster.

## Examples

### Delete an existing managed Kubernetes cluster
```powershell
PS C:\> Remove-AksHciCluster -name myCluster
```

## Parameters

### -name
The name of your Kubernetes cluster.

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