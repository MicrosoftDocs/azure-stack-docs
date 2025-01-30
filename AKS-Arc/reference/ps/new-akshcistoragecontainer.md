---
title: New-AksHciStorageContainer for AKS hybrid
author: sethmanheim
description: The New-AksHciStorageContainer PowerShell command creates a new storage container.
ms.topic: reference
ms.date: 04/12/2021
ms.author: sethm 
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan

---

# New-AksHciStorageContainer

## Synopsis

Creates a new storage container.

## Syntax

```powershell
New-AksHciStorageContainer -name <String>
                           -path <String>          
```

## Description

Creates a new storage container.

## Examples

### New AKS hybrid cluster with required parameters

```powershell
New-AksHciStorageContainer -name mystoragecontainer -path c:\clusterstorage\volume1
```

## Parameters

### -name
The name of the new storage container

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

### -path
The location where the new storage container will be created. The Storage class uses the storage container to store dynamically provisioned persistent volumes.

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
