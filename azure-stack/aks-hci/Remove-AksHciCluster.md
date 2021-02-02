---
external help file: 
Module Name: Aks.Hci
online version: 
schema: 
---

# Remove-AksHciCluster

## SYNOPSIS
Delete a managed Kubernetes cluster.

## SYNTAX

### Delete a managed Kubernetes cluster
```powershell
Remove-AksHciCluster -name 
                    [-force]   
```

## DESCRIPTION
Delete a managed Kubernetes cluster.

## EXAMPLES

### Delete an existing managed Kubernetes cluster
```powershell
PS C:\> Remove-AksHciCluster -name myCluster
```

## PARAMETERS

### -name
The alphanumeric name of your Kubernetes cluster.

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

### -force
Delete a cluster without prompt.

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