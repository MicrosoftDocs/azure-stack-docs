---
title: Get-AksHciStorageContainer for AKS hybrid
author: sethmanheim
description: The Get-AksHciStorageContainer PowerShell command returns the Storage container name and location for the specified Storage container.
ms.topic: reference
ms.date: 08/25/2023
ms.author: sethm 
ms.lastreviewed: 1/14/2022

---

# Get-AksHciStorageContainer

## Synopsis

Gets information about the specified storage container.

## Syntax

```powershell
Get-AksHciStorageContainer [-name <String>]
```

## Description

Gets information about the specified storage container. If the storage container is not specified, the command returns all the storage containers.

## Examples

### Example

```powershell
Get-AksHciStorageContainer -name mystoragecontainer
```

## Parameters

### -name

The name of the new Storage container.

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

## Next steps

[AksHci PowerShell Reference](index.md)
