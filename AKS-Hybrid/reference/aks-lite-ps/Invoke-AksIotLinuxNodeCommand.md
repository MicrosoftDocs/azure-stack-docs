---
title: Invoke-AksIotLinuxNodeCommand for AKS Lite
author: rcheeran
description: The Invoke-AksIotLinuxNodeCommand PowerShell command executes an SSH command on the Linux VM.
ms.topic: reference
ms.date: 10/04/2022
ms.author: rcheeran 
ms.lastreviewed: 10/04/2022
#ms.reviewer: jeguan

---

# Invoke-AksIotLinuxNodeCommand

## SYNOPSIS
Executes an SSH command on the Linux VM.

## SYNTAX

```
Invoke-AksIotLinuxNodeCommand [-Command] <String> [-IgnoreError] [<CommonParameters>]
```

## DESCRIPTION
The Invoke-AksIotLinuxNodeCommand cmdlet executes a Linux command inside the virtual machine and returns the output.
This cmdlet only works for Linux commands that return a finite output.
It cannot be used for Linux commands that require user interaction or that run indefinitely.

## EXAMPLES

### EXAMPLE 1
```
Invoke-AksIotLinuxNodeCommand -Command "sudo ps aux"
```

## PARAMETERS

### -Command
Command to be executed in the Linux VM

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

### -IgnoreError
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### String - Response from the Linux VM
## NOTES

## RELATED LINKS
