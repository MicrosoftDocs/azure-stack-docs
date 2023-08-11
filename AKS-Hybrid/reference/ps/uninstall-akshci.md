---
title: Uninstall-AksHci for AKS hybrid
author: sethmanheim
description: The Uninstall-AksHci PowerShell command removes AKS hybrid.
ms.topic: reference
ms.date: 11/04/2022
ms.author: mikek 
ms.lastreviewed: 11/04/2022
ms.reviewer: mikek

---

# Uninstall-AksHci

## Synopsis

Removes Azure Kubernetes Service and all Settings from AKS hybrid.

## Syntax

```powershell
Uninstall-AksHci [-skipConfigCleanup]
```

## Description

Removes Azure Kubernetes Service and all settings from AKS hybrid.

If PowerShell commands are run on a cluster where Windows Admin Center was previously used to deploy, the PowerShell module checks the existence of the Windows Admin Center configuration file. Windows Admin Center places the Windows Admin Center configuration file across all nodes.

> [!IMPORTANT]
> To re-install AKS hybrid, complete all configuration steps as outlined in the [PowerShell deployment documentation](../../kubernetes-walkthrough-powershell.md) or the [Windows Admin Center
> documentation](../../setup.md).

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
