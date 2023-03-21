---
title: Get-AksHciCredential for AKS hybrid
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

### Update to the kubelogin authentication plugin

To provide authentication tokens for communicating with AKS hybrid clusters, **Kubectl** clients require [an authentication plugin](https://kubernetes.io/docs/reference/access-authn-authz/authentication/#client-go-credential-plugins). After Kubernetes version 1.26, AKS hybrid will require the [Azure **kubelogin** binary](https://github.com/Azure/kubelogin) installed. If this plugin is not installed, existing installations of kubectl will stop working. The Azure **kubelogin** plugin is supported from version 1.23 and later.

You can run `Get-AksHciCredential -Name <cluster name> -aadauth` to automatically download **kubelogin.exe** and make it available for use.
You can verify the installation by running `kubelogin.exe –help`.

For more information about how to convert to the **kubelogin** authentication plugin, see the [Azure kubelogin page](https://github.com/Azure/kubelogin).

## Examples

### Access your cluster using kubectl

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
