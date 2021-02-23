---
title: Get-AksHciLogs
author: jessicaguan
description: The Get-AksHciLogs PowerShell command creates a zipped folder with logs from all your pods.
ms.topic: reference
ms.date: 2/12/2021
ms.author: jeguan
---

# Get-AksHciLogs

## Synopsis
Create a zipped folder with logs from all your pods. This command will create an output zipped folder called `akshcilogs` in the path `c:\%workingdirectory%\%AKS HCI release number%\%filename%` (for example, `c:\AksHci\0.9.6.0\akshcilogs.zip`). 

## Syntax

```powershell
Get-AksHciLogs
```

## Description
Create a zipped folder with logs from all your pods. This command will create an output zipped folder called `akshcilogs` in the path `c:\%workingdirectory%\%AKS HCI release number%\%filename%` (for example, `c:\AksHci\0.9.6.0\akshcilogs.zip`).

## Examples

### Example
```powershell
PS C:\> Get-AksHciLogs
```
