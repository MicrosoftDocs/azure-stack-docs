---
title: Copy-AksEdgeNodeFile for AKS Edge
author: rcheeran
description: The Copy-AksEdgeNodeFile PowerShell command copies a file to or from a node.
ms.topic: reference
ms.date: 02/01/2023
ms.author: rcheeran 
ms.lastreviewed: 02/01/2023
#ms.reviewer: jeguan

---

# Copy-AksEdgeNodeFile

Copies a file to or from a node.

## Syntax

```powershell
Copy-AksEdgeNodeFile [-FromFile <String>] [-ToFile <String>] [-PushFile][-NodeType] [<CommonParameters>]
```

## Description

Copies files to or from a node. 


## Examples

### Example 1

Pushes the sample.json to a file to the Linux node and names the file as config.json.

```powershell
Copy-AksEdgeNodeFile -FromFile ./sample.json -ToFile /var/config.json -PushFile -NodeType Linux
```

## Parameters

### -FromFile

 Name of the file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ToFile

Name of the file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PushFile

Name of the file.

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

### -NodeType

This parameter indicates whether the 'Linux' node, the 'Windows' node, or both at the same time with
'LinuxAndWindows', should be drained. When not specified, the 'Linux' node is drained only. When both nodes are drained, the Windows node is drained first, then the Linux node.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Linux
Accept pipeline input: False
Accept wildcard characters: False
```


### Common parameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## Next steps

[AksEdge PowerShell Reference](./index.md)
