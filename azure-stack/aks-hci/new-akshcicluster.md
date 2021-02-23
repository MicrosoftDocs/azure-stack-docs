---
title: New-AksHciCluster
author: jessicaguan
description: The New-AksHciCluster PowerShell command creates a new managed Kubernetes cluster.
ms.topic: reference
ms.date: 2/12/2021
ms.author: jeguan
---


# New-AksHciCluster

## Synopsis
Create a new managed Kubernetes cluster.

## Syntax

```powershell
New-AksHciCluster -name <String>
                 [-kubernetesVersion <String>]
                 [-controlPlaneNodeCount <int>]
                 [-linuxNodeCount <int>]
                 [-windowsNodeCount <int>]
                 [-controlPlaneVmSize <VmSize>]
                 [-loadBalancerVmSize <VmSize>]
                 [-linuxNodeVmSize <VmSize>]
                 [-windowsNodeVmSize <VmSize>]
                 [-vnet <Virtual Network>]
                 [-primaryNetworkPlugin <Network Plugin>]   
                 [-enableAdAuth]
                 [-enableSecretsEncryption]          
```

## Description

Create a new Azure Kubernetes Service on Azure Stack HCI cluster.

## Examples

### New AKS-HCI cluster with required params.

```powershell
PS C:\> New-AksHciCluster -name myCluster
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

### -kubernetesVersion
The version of Kubernetes that you want to deploy. The default is the latest version. To get a list of available versions, run `Get-AksHciKubernetesVersion`.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: v1.18.8 or later
Accept pipeline input: False
Accept wildcard characters: False
```

### -controlPlaneNodeCount
The number of nodes in your control plane. Default is 1.

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -linuxNodeCount
The number of Linux nodes in your Kubernetes cluster. Default is 1.

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -windowsNodeCount
The number of Windows nodes in your Kubernetes cluster. Default is 0. You can only deploy Windows nodes if you are running Kubernetes v1.18.8 or higher.

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -controlPlaneVmSize
The size of your control plane VM. Default is Standard_A4_V2. To get a list of available VM sizes, run `Get-AksHciVmSize`.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Standard_A4_V2
Accept pipeline input: False
Accept wildcard characters: False
```

### -loadBalancerVmSize
The size of your load balancer VM. Default is Standard_A4_V2. To get a list of available VM sizes, run `Get-AksHciVmSize`.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Standard_A4_V2
Accept pipeline input: False
Accept wildcard characters: False
```

### -linuxNodeVmSize
The size of your Linux Node VM. Default is Standard_K8S3_v1. To get a list of available VM sizes, run `Get-AksHciVmSize`.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Standard_K8S3_v1
Accept pipeline input: False
Accept wildcard characters: False
```

### -windowsVmSize
The size of your Windows Node VM. Default is Standard_K8S3_v1. To get a list of available VM sizes, run `Get-AksHciVmSize`.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Standard_K8S3_v1
Accept pipeline input: False
Accept wildcard characters: False
```

### -vnet
The name of the AksHciNetworkSetting object created with New-AksHciNetworkSetting command.

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

### -primaryNetworkPlugin
The network plugin to be used for your deployment. This parameter takes in either `flannel` or `calico`. Calico is only available for Linux only clusters. If you choose Calico for your cluster, the addition of Windows nodes is not allowed.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: flannel
Accept pipeline input: False
Accept wildcard characters: False
```

### -enableADAuth
Use this flag to enable Active Directory in your Kubernetes cluster.

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

### -enableSecretsEncryption
Use this flag to enable encryption in your Kubernetes secrets.

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
