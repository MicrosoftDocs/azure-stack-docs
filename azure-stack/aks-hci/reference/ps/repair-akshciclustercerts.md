---
title: Repair-AksHciClusterCerts for AKS on Azure Stack HCI
description: The Repair-AksHciClusterCerts PowerShell command troubleshoots and fixes errors related to expired certificates for Kubernetes built-in components. 
author: mattbriggs
ms.topic: reference
ms.date: 6/12/2021
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan

---

# Repair-AksHciClusterCerts

## Synopsis
Troubleshoots and fixes errors related to expired certificates for Kubernetes built-in components. 

## Syntax

```powershell
Repair-AksHciClusterCerts -name 
                          -fixCloudCredentials
                         [-sshPrivateKeyFile <String>] 
                         [-force]
```

```powershell
Repair-AksHciClusterCerts -name 
                          -fixKubeletCredentials
                         [-sshPrivateKeyFile <String>] 
```

## Description
Troubleshoots and fixes errors related to expired certificates for Kubernetes built-in components. 

## Examples

### To fix cloudagent related certs, if the target cluster loses communication with the cloud agent

```powershell
PS C:\> Repair-AksHciClusterCerts -name mycluster -fixCloudCredentials
```

### To fix the cluster certs, if there are communication issues between target clusters

```powershell
PS C:\> Repair-AksHciClusterCerts -name mycluster -fixKubeletCredentials
```

## Parameters

### -name
The name of the Kubernetes cluster on which you want to reprovision the certificates.

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

### -fixCloudCredentials
Use this flag if the workload cluster loses communication with the cloudagent.

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

### -fixKubeletCredentials
Use this flag if the workload clusters lose communication between other workload clusters.

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


### -sshPrivateKeyFile
The SSH key used to remotely access the host VMs for the cluster.

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

### -force
Use this flag to force repair without checks. This flag is only valid for `fixCloudCredentials`

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
