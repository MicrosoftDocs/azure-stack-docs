---
title: Update-AksHciClusterCertificates for AKS on Azure Stack HCI and Windows Server
description: The Update-AksHciClusterCertificates PowerShell command rotates tokens and certificates of all clients in the workload cluster.
author: sethmanheim
ms.topic: reference
ms.date: 6/16/2022
ms.author: sethm 
ms.lastreviewed: 6/16/2022
ms.reviewer: jeguan

---

# Update-AksHciClusterCertificates

## Synopsis

Rotates the tokens and certificates of all clients in the workload cluster.

## Syntax

```powershell
Update-AksHciClusterCertificates  -name
                                 [-fixCloudCredentials]
                                 [-force]
```

```powershell
Update-AksHciClusterCertificates  -name
                                 [-fixKubeletCredentials]
                                 [-force]
```

## Description

Rotates the tokens and certificates of all clients in the workload cluster.

## Examples

### To fix cloudagent related certs, if the target cluster loses communication with the cloud agent

```PowerShell
Update-AksHciClusterCertificates -name mycluster -fixCloudCredentials
```

### To fix the cluster certs, if there are communication issues between target clusters

```PowerShell
Update-AksHciClusterCertificates -name mycluster -fixKubeletCredentials
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

Reprovisions tokens for cluster pods that communicate with MOC. Use this flag if the workload cluster loses communication with the cloudagent.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -fixKubeletCredentials

Reprovision certificates for the cluster control plane nodes.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -force

Use this flag to force token and certificate rotation regardless of expiry dates.

```yaml
Type: System.Management.Automation.SwitchParameter
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
