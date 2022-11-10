---
title: Get-AksIotLinuxNodeAddr for AKS Lite
author: rcheeran
description: The Get-AksIotLinuxNodeAddr PowerShell command gets the Linux VM's IP and MAC addresses
ms.topic: reference
ms.date: 10/04/2022
ms.author: rcheeran 
ms.lastreviewed: 10/04/2022
#ms.reviewer: jeguan

---

# Get-AksIotLinuxNodeAddr

## Synopsis
Gets the Linux VM's IP and MAC addresses

## Syntax

```
Get-AksIotLinuxNodeAddr [<CommonParameters>]
```

## Description
The Get-AksIotLinuxNodeAddr cmdlet queries the Linux VM primary interface's current IP & Mac address, which can change over time.

## Examples
```
Get-AksIotLinuxNodeAddr
```

## Parameters

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## Next steps

[Akslite PowerShell Reference](./index.md)
