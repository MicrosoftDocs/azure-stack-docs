---
external help file: 
Module Name: Aks.Hci
online version:
schema: 
---

# Install-AksHciArcOnboarding

## SYNOPSIS
Connects an AKS-HCI workload cluster to Azure Arc for Kubernetes.

## SYNTAX

```powershell
Install-AksHciArcOnboarding -Name <String> 
                            -tenantId <String>
                            -subscriptionId <String> 
                            -resourceGroup <String>
                            -clientId <String>
                            -clientSecret <String>
                            [-location <String>]
```

## DESCRIPTION
Connects an AKS-HCI workload cluster to Azure Arc for Kubernetes.

## EXAMPLES

### Connect an AKS-HCI cluster to Azure Arc for Kubernetes with required parameters

```PowerShell
Install-AksHciArcOnboarding -clusterName "myCluster" -resourcegroup "myResourceGroup" -subscriptionid "57ac26cf-a9f0-4908-b300-9a4e9a0fb205"  -clientid "22cc2695-54b9-49c1-9a73-2269592103d8" -clientsecret "09d3a928-b223-4dfe-80e8-fed13baa3b3d" -tenantid "72f988bf-86f1-41af-91ab-2d7cd011db47"
```

### Connect an AKS-HCI cluster to Azure Arc for Kubernetes with all parameters

```PowerShell
Install-AksHciArcOnboarding -clusterName "myCluster" -resourcegroup "myResourceGroup" -location "eastus" -subscriptionid "57ac26cf-a9f0-4908-b300-9a4e9a0fb205"  -clientid "22cc2695-54b9-49c1-9a73-2269592103d8" -clientsecret "09d3a928-b223-4dfe-80e8-fed13baa3b3d" -tenantid "72f988bf-86f1-41af-91ab-2d7cd011db47"
```

## PARAMETERS

### -Name
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
### -tenantId
The tenant Id of your Azure service principal.

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

### -subscriptionId
Your Azure account's subscirption Id.

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

### -resourceGroup
The name of the Azure resource group

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

### -clientId
The client Id or app Id of your Azure service principal

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

### -clientSecret
The client secret or password of your Azure service principal

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

### -location
The location or Azure region of your Azure resource. Default value is the location of your Azure resource group. This can only be eastus or westeurope for Azure Arc for Kubernetes.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Azure resource group's location
Accept pipeline input: False
Accept wildcard characters: False
```