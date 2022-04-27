---
title: Enable-AksHciArcConnection for AKS on Azure Stack HCI and Windows Server
author: mattbriggs
description: The Enable-AksHciArcConnection PowerShell command enables the Arc connection on an AKS on Azure Stack HCI and Windows Server cluster.
ms.topic: reference
ms.date: 05/25/2021
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan

---

# Enable-AksHciArcConnection

## Synopsis
Enables Arc connection for an AKS on Azure Stack HCI and Windows Server cluster.

## Syntax

```powershell
Enable-AksHciArcConnection -name <String> 
                          [-tenantId <String>]
                          [-subscriptionId <String>] 
                          [-resourceGroup <String>]
                          [-credential <PSCredential>]
                          [-location <String>]
```

## Description
Enables Arc connection for an AKS on Azure Stack HCI and Windows Server cluster.

## Examples

### Connect an AKS on Azure Stack HCI and Windows Server cluster to Azure Arc for Kubernetes using Azure user login 
This command connects your workload cluster to Azure Arc using the subscription ID and resource group passed in the `Set-AksHciRegistration` command while registering the AKS host for billing. Make sure that you have access to the subscription on an "Owner" role. You can check your access level by navigating to your subscription, clicking on "Access control (IAM)" on the left hand side of the Azure portal and then clicking on "View my access". 


```PowerShell
Connect-AzAccount
Enable-AksHciArcConnection -name "myCluster"
```

### Connect an AKS on Azure Stack HCI and Windows Server cluster to Azure Arc for Kubernetes using a service principal
If you do not have access to a subscription on which you're an "Owner", you can connect your AKS cluster to Azure Arc using a service principal.



The first command prompts for service principal credentials and stores them in the `credential` variable. Enter your application ID for the username and service principal secret as the password when prompted. Make sure you get these values from your subscription admin. The second command connects your cluster to Azure Arc using the service principal credentials stored in the `credential` variable. 


```powershell
$Credential = Get-Credential
Enable-AksHciArcConnection -name "myCluster" -subscriptionId "3000e2af-000-46d9-0000-4bdb12000000" -resourceGroup "myAzureResourceGroup" -credential $Credential -tenantId "xxxx-xxxx-xxxx-xxxx" -location "eastus"
```

Make sure the service principal used in the command above has the "Owner", "Contributor" or "Kubernetes Cluster - Azure Arc Onboarding" role assigned to them and that it has scope over the subscription ID and resource group used in the command. For more information on service principals, visit [creating service principals with Azure PowerShell](/powershell/azure/create-azure-service-principal-azureps?view=azps-5.9.0#create-a-service-principal).

## Parameters

### -Name
The alphanumeric name of your AKS cluster.

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
The tenant ID of your Azure service principal. Default value is the Azure login context. You can find out the default tenant ID using `(Get-AzContext).Tenant.Id` command.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -subscriptionId
Your Azure account's subscription ID. Default value is the subscription ID passed in Set-AksHciRegistration.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -resourceGroup
The name of the Azure resource group. Default value is the resource group passed in Set-AksHciRegistration.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -credential
This is the [PSCredential] for the Azure service principal.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -location
The location or Azure region of your Azure resource. Default value is the location passed in `Set-AksHciRegistration`. If you did not pass a location in `Set-AksHciRegistration`, then the default value is the location of the resource group passed in the `Enable-AksHciConnection` command.

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
## Next steps

[AksHci PowerShell Reference](index.md)