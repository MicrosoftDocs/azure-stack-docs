---
title:  Get-AksEdgeKubeConfig for AKS Lite
author: rcheeran
description: The Get-AksEdgeKubeConfig  PowerShell command pulls the KubeConfig file from the Linux node.
ms.topic: reference
ms.date: 10/04/2022
ms.author: rcheeran 
ms.lastreviewed: 10/04/2022
#ms.reviewer: jeguan

---

# Get-AksEdgeKubeConfig

## Synopsis
Pulls the KubeConfig file from the Linux node.

## Syntax

```powershell
Get-AksEdgeKubeConfig [-KubeConfigPath <String>] [-NodeType <WorkloadType>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## Description
Pulls the KubeConfig file from the Linux node.
Thus, enables kubectl on the host to access the AksIot
cluster.
The function will set the AksIot cluster's kubeconfig file as the
default kubeconfig file for kubectl.


## Parameters

### -KubeConfigPath
Optional parameter that allows specifying a custom location to output the credential/kubeconfig file to.
Defaults to the .kube folder under the user's profile folder.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $($env:USERPROFILE+"\.kube")
Accept pipeline input: False
Accept wildcard characters: False
```

### -NodeType
Optional parameter allowing to get the kubeconfig file alternatively from the Windows node

```yaml
Type: WorkloadType
Parameter Sets: (All)
Aliases:
Accepted values: Linux, Windows, LinuxAndWindows

Required: False
Position: Named
Default value: Linux
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## Next steps

[Akslite PowerShell Reference](./index.md)
