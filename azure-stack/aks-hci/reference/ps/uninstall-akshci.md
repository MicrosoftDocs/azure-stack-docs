---
title: Uninstall-AksHci for AKS on Azure Stack HCI and Windows Server
author: mattbriggs
description: The Uninstall-AksHci PowerShell command removes AKS on Azure Stack HCI and Windows Server.
ms.topic: reference
ms.date: 2/12/2021
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan

---

# Uninstall-AksHci

## Synopsis
Removes Azure Kubernetes Service on Azure Stack HCI.

## Syntax

```powershell
Uninstall-AksHci [-skipConfigCleanup]
```

## Description
Removes Azure Kubernetes Service on Azure Stack HCI. 

If PowerShell commands are run on a cluster where Windows Admin Center was previously used to deploy, the PowerShell module checks the existence of the Windows Admin Center configuration file. Windows Admin Center places the Windows Admin Center configuration file across all nodes. 

## Example

### Example
```powershell
Uninstall-AksHci
```

## Parameters

### -skipConfigCleanup
Skips removal of the configurations after uninstall. If you use this flag, your old configuration will be retained.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```
## Next steps

[AksHci PowerShell Reference](index.md)