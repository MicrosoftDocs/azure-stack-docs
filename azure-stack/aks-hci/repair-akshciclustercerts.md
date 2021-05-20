---
title: Repair-AksHciClusterCerts
description: The Repair-AksHciClusterCerts PowerShell troubleshoots and fixes errors related to expired certificated for Kubernetes built-in components 
author: jessicaguan
ms.topic: reference
ms.date: 2/12/2021
ms.author: jeguan
---

# Repair-AksHciClusterCerts

## Synopsis
Troubleshoots and fixes errors related to expired certificated for Kubernetes built-in components. 

## Syntax

```powershell
Repair-AksHciClusterCerts -name 
                         [-sshPrivateKeyFile <String>] 
```

## Description
Troubleshoots and fixes errors related to expired certificated for Kubernetes built-in components. 

## Example

```powershell
PS C:\> Repair-AksHciClusterCerts -name mycluster
```

## Parameters

### -name
The name of your Kubernetes cluster to reprovision certs on.

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

### -sshPrivateKeyFile
The SSH key used to remote into the host VMs for the cluster.

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