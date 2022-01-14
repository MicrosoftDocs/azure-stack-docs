---
title: Remove-AksHciGmsaCredentialSpec for AKS on Azure Stack HCI
author: mattbriggs
description: The Remove-AksHciGmsaCredentialSpec PowerShell command deletes a credentials spec for gMSA deployments on a cluster.
ms.topic: reference
ms.date: 2/12/2021
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan
---

# Remove-AksHciGmsaCredentialSpec

## Synopsis
Deletes a credentials spec for gMSA deployments on a cluster.

## Syntax

```powershell
Remove-AksHciGmsaCredentialSpec -name <String> 
                             -credSpecName <String>
                             -clusterRoleName <String>
                             [-secretNamespace <String>]
                             [-serviceAccount <String>]
                             [-activity <String>]                      
```

## Description
Deletes a credentials spec for gMSA deployments on a cluster.

## Examples

### Example

```PowerShell
Remove-AksHciGmsaCredentialSpec -Name mycluster -CredSpecName credspec-mynewcluster -clusterRoleName clusterrole-mynewcluster
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

### -credSpecName
Name of the Kubernetes credential spec object the user would like to designate. 

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

### -clusterRoleName
Name of the Kubernetes cluster role assigned to use the Kubernetes gMSA credspec object.

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

### -secretNamespace
Namespace where the Kubernetes secret object resides in.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

### -serviceAccount
Name of the Kubernetes service account assigned to read the k8s gMSA credspec object. 

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Default
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