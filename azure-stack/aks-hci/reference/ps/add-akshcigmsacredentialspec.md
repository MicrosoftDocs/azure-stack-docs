---
title: Add-AksHciGmsaCredentialSpec for AKS on Azure Stack HCI and Windows Server
author: sethmanheim
description: The Add-AksHciGmsaCredentialSpec PowerShell command adds a credentials spec for gMSA deployments on a cluster.
ms.topic: reference
ms.date: 4/13/2021
ms.author: sethm 
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan

---

# Add-AksHciGmsaCredentialSpec

## Synopsis
Adds a credentials spec for gMSA deployments on a cluster.

## Syntax

```powershell
Add-AksHciGmsaCredentialSpec -name <String> 
                             -credSpecFilePath <String>
                             -credSpecName <String>
                             -clusterRoleName <String>
                             -secretName <String>
                             [-secretNamespace <String>]
                             [-serviceAccount <String>]
                             [-overwrite][-activity <String>]                      
```

## Description
Adds a credentials spec for gMSA deployments on a cluster.

## Examples

### Example

```PowerShell
Add-AksHciGMSACredentialSpec -Name mycluster -CredFilePath .\credspectest.json -CredSpecName credspec-mynewcluster -secretName mysecret -clusterRoleName clusterrole-mynewcluster
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

### -credSpecFilePath
File Path of the JSON cred spec file.

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

### -secretName
Name of the Kubernetes secret object storing the Active Directory user credentials and gMSA domain. 

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

### -overwrite
Overwrites existing Cluster role and service account role binding.

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