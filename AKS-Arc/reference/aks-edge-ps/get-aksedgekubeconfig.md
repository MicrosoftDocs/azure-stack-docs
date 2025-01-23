---
title:  Get-AksEdgeKubeConfig for AKS Edge
author: rcheeran
description: The Get-AksEdgeKubeConfig  PowerShell command pulls the KubeConfig file from the node.
ms.topic: reference
ms.date: 10/04/2022
ms.author: rcheeran 
ms.lastreviewed: 10/04/2022
#ms.reviewer: jeguan

---

# Get-AksEdgeKubeConfig

Pulls the KubeConfig file from the Kubernetes Linux node.

## Syntax

```powershell
Get-AksEdgeKubeConfig [[-KubeConfigPath] <String>] [-NodeType <String>] [-ignoreError] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## Description

Pulls the KubeConfig file from the Linux so that kubectl on the host to access the AKS Edge Essentials cluster. The function will set the AKS Edge Essentials cluster's kubeconfig file as the default kubeconfig file for kubectl.


## Parameters

### -KubeConfigPath

Optional parameter to specify a custom location to output the credential/kubeconfig file. Defaults to the `.kube` folder under the user's profile folder.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $($env:USERPROFILE+"\.kube")
Accept pipeline input: False
Accept wildcard characters: False
```

### -NodeType

Optional parameter to get the kubeconfig file alternatively from the Windows node

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Linux
Accept pipeline input: False
Accept wildcard characters: False
```

### -ignoreError

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf

Shows what would happen if the cmdlet runs. The cmdlet isn't run.

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

### Common parameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## Next steps

[AksEdge PowerShell Reference](./index.md)
