---
external help file: 
Module Name: Aks.Hci
online version: 
schema: 
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
PS C:\> Uninstall-AksHci
```

## Parameters

### -skipConfigCleanup
Skips removal of the configurations after uninstall. If you use this flag, you must run `Set-AksHciConfig` to install again.

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