---
title: Get-AksHciCredential for AKS on Azure Stack HCI and Windows Server
author: sethmanheim
description: The Get-AksHciCredential PowerShell command accesses your cluster using kubectl.
ms.topic: reference
ms.date: 2/12/2021
ms.author: sethm 
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan

---

# Get-AksHciCredential

## Synopsis
Access your cluster using `kubectl`. This will use the specified cluster's _kubeconfig_ file as the default _kubeconfig_ file for `kubectl`.

## Syntax

```powershell
Get-AksHciCredential -name <String>
                    [-configPath <String>]
                    [-adAuth]
```

## Description
Access your cluster using kubectl.

## Examples

### Access your cluster using kubectl.
```powershell
Get-AksHciCredential -name myCluster
```

## Parameters

### -name
The name of the cluster.

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

### -configPath
The location where you want the kubeconfig downloaded. Default is `%USERPROFILE%\.kube`.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: %USERPROFILE%\.kube
Accept pipeline input: False
Accept wildcard characters: False
```

### -adAuth
Use this flag to get the Active Directory SSO version of the kubeconfig.

```yaml
Type: System.Management.Automation.SwitchParameter
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