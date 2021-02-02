---
external help file: 
Module Name: Aks.Hci
online version: 
schema: 
---

# Get-AksHciClusterUpgrades

## SYNOPSIS
Get the available upgrades for an Azure Kubernetes Service cluster.

## SYNTAX

### Get a virtual network
```powershell
Get-AksHciClusterUpgrades -name <String>
                          
```

## DESCRIPTION
Get the available upgrades for an Azure Kubernetes Service cluster.

## EXAMPLES

### Get a virtual network
```powershell
PS C:\> Get-AksHciClusterUpgrades -name mycluster
```

## PARAMETERS

### -name
The alphanumeric name of your cluster.

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