---
title: New-AksHciStorageContainer for AKS on Azure Stack HCI and Windows Server
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

### New AKS-HCI cluster with required parameters

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
The location where new Storage Container will be created. Storage Class uses Storage Container to store dynamically provisioned Persistent Volumes.

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
