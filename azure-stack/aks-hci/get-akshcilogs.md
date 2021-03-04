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
Create a zipped folder with logs from all your pods. 

## Syntax

```powershell
Get-AksHciLogs
```

## Description
Create a zipped folder with logs from all your pods. This command will create an output zipped folder called `akshcilogs.zip` in your AKS on Azure Stack HCI working directory. The full path to the `akshcilogs.zip` file will be the output after running  `Get-AksHciLogs` (for example, `C:\AksHci\0.9.6.3\akshcilogs.zip`, where `0.9.6.3` is the AKS on Azure Stack HCI release number).

## Examples

### Example
```powershell
PS C:\> Get-AksHciLogs
```
