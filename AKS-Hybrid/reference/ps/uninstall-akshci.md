---
title: Uninstall-AksHci for AKS on Azure Stack HCI and Windows Server
author: sethmanheim
description: The Uninstall-AksHci PowerShell command removes AKS on Azure Stack HCI and Windows Server.
ms.topic: reference
ms.date: 2/12/2021
ms.author: sethm 
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan

---

# Uninstall-AksHci

## Synopsis
Removes Azure Kubernetes Service on Azure Stack HCI and Windows Server.

## Syntax

```powershell
Uninstall-AksHci
```

## Description
Removes Azure Kubernetes Service on Azure Stack HCI and Windows Server. 

If PowerShell commands are run on a cluster where Windows Admin Center was previously used to deploy, the PowerShell module checks the existence of the Windows Admin Center configuration file. Windows Admin Center places the Windows Admin Center configuration file across all nodes. 

## Example

### Example
```powershell
Uninstall-AksHci
```

## Next steps

[AksHci PowerShell Reference](index.md)
