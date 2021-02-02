---
external help file: 
Module Name: Aks.Hci
online version: 
schema: 
---

# Uninstall-AksHci

## SYNOPSIS
Remove Azure Kubernetes Service on Azure Stack HCI.

## SYNTAX

```powershell
Uninstall-AksHci [-skipConfigCleanup]
```

```powershell
Uninstall-AksHci -Force
```

## DESCRIPTION
Remove Azure Kubernetes Service on Azure Stack HCI. **If you are using PowerShell to uninstall a Windows Admin Center deployment, you must run the command with the -Force flag.**

If PowerShell commands are run on a cluster where Windows Admin Center was previously used to deploy, the PowerShell module checks the existence of the Windows Admin Center configuration file. Windows Admin Center places the Windows Admin Center configuration file across all nodes. **If you use the uninstall command and go back to Windows Admin Center, run the above uninstall command with the -Force flag. If this is not done, PowerShell and Windows Admin Center will be out of sync.**

## EXAMPLES

### Example
```powershell
PS C:\> Uninstall-AksHci
```

## PARAMETERS

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