---
title: Invoke-AksEdgeNodeCommand for AKS Edge
author: rcheeran
description: The Invoke-AksEdgeNodeCommand PowerShell command executes an SSH command on the Linux VM.
ms.topic: reference
ms.date: 10/04/2022
ms.author: rcheeran 
ms.lastreviewed: 10/04/2022
#ms.reviewer: jeguan

---

# Invoke-AksEdgeNodeCommand

Executes an SSH command on the VM.

## Syntax

```powershell
Invoke-AksEdgeNodeCommand [[-command] <String>] [-ignoreError] [[-NodeType] <String>]
```

## Description

The Invoke-AksEdgeNodeCommand cmdlet executes a Linux command inside the virtual machine and returns the output.
This cmdlet only works for Linux commands that return a finite output.
It cannot be used for Linux commands that require user interaction or that run indefinitely.

## Examples

```powershell
Invoke-AksEdgeNodeCommand -Command "sudo ps aux"
```

## Parameters

## -command
Command to be executed in the VM

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ignoreError
Optionally, if this flag is present, ignore errors from the command (don't throw).

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
NodeType specifies Linux or Windows node to connect to.
Default is Linux.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Linux
Accept pipeline input: False
Accept wildcard characters: False
```
## Next steps

[AksEdge PowerShell Reference](./index.md)
