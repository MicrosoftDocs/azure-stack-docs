---
title: Use the Azure Stack Hub policy module
description: Learn how to constrain an Azure subscription to behave like an Azure Stack Hub subscription
author: sethmanheim

ms.topic: how-to
ms.custom:
  - devx-track-azurepowershell
ms.date: 06/06/2022
ms.author: sethm
ms.lastreviewed: 11/22/2020

# Intent: As an Azure/Azure Stack user, I want to use the Azure Stack policy module to configure an Azure sub with the same versioning and service availability as my Azure Stack sub, allowing me to develop apps targeted for Azure Stack.
# Keyword: azure stack policy module
---


# Manage Azure policy using the Azure Stack Hub policy module

The Azure Stack Hub policy module enables you to configure an Azure subscription with the same versioning and service availability as Azure Stack Hub. The module uses the [**New-AzPolicyDefinition**](/powershell/module/Az.resources/new-Azpolicydefinition) PowerShell cmdlet to create an Azure policy, which limits the resource types and services available in a subscription. You then create a policy assignment within the appropriate scope by using the [**New-AzPolicyAssignment**](/powershell/module/Az.resources/new-Azpolicyassignment) cmdlet. After configuring the policy, you can use your Azure subscription to develop apps targeted for Azure Stack Hub.

> [!NOTE]
> The Azure Stack Hub policy module is intended to be used in public Azure as a test for deployment to Azure Stack Hub.

## Install the module

1. Install the required version of the Az PowerShell module, as described in Step 1 of [Install PowerShell for Azure Stack Hub](../operator/powershell-install-az-module.md).
2. [Download the Azure Stack Hub tools from GitHub](../operator/azure-stack-powershell-download.md).
3. [Configure PowerShell for use with Azure Stack Hub](azure-stack-powershell-configure-user.md).
4. Import the **AzureStack.Policy.psm1** module:

   ```powershell
   Import-Module .\Policy\AzureStack.Policy.psm1
   ```

## Apply policy to Azure subscription

You can use the following commands to apply a default Azure Stack Hub policy to your Azure subscription. Before running these commands, replace `Azure subscription name` with the name of your Azure subscription.

### [Az modules](#tab/az1)

```powershell
Connect-AzAccount
$s = Select-AzSubscription -SubscriptionName "Azure subscription name"
$policy = New-AzPolicyDefinition -Name AzureStackPolicyDefinition -Policy (Get-AzsPolicy)
$subscriptionID = $s.Subscription.SubscriptionId
New-AzPolicyAssignment -Name AzureStack -PolicyDefinition $policy -Scope /subscriptions/$subscriptionID
```
### [AzureRM modules](#tab/azurerm1)

```powershell
Add-AzureRMAccount
$s = Select-AzureRMSubscription -SubscriptionName "Azure subscription name"
$policy = New-AzureRMPolicyDefinition -Name AzureStackPolicyDefinition -Policy (Get-AzsPolicy)
$subscriptionID = $s.Subscription.SubscriptionId
New-AzureRMPolicyAssignment -Name AzureStack -PolicyDefinition $policy -Scope /subscriptions/$subscriptionID
```

---

## Apply policy to a resource group

You might want to apply policies that are more granular. For example, you might have other resources running in the same subscription. You can scope the policy application to a specific resource group, which enables you to test your apps for Azure Stack Hub using Azure resources. Before running the following commands, replace `Azure subscription name` with the name of your Azure subscription:

### [Az modules](#tab/az2)

```powershell
Connect-AzAccount
$rgName = 'myRG01'
$s = Select-AzSubscription -SubscriptionName "Azure subscription name"
$policy = New-AzPolicyDefinition -Name AzureStackPolicyDefinition -Policy (Get-AzsPolicy)
$subscriptionID = $s.Subscription.SubscriptionId
New-AzPolicyAssignment -Name AzureStack -PolicyDefinition $policy -Scope /subscriptions/$subscriptionID/resourceGroups/$rgName
```
### [AzureRM modules](#tab/azurerm2)
 
```powershell
Add-AzureRMAccount
$rgName = 'myRG01'
$s = Select-AzureRMSubscription -SubscriptionName "Azure subscription name"
$policy = New-AzureRMPolicyDefinition -Name AzureStackPolicyDefinition -Policy (Get-AzsPolicy)
$subscriptionID = $s.Subscription.SubscriptionId
New-AzureRMPolicyAssignment -Name AzureStack -PolicyDefinition $policy -Scope /subscriptions/$subscriptionID/resourceGroups/$rgName
```

---

## Policy in action

Once you've deployed the Azure policy, you receive an error when you try to deploy a resource that is prohibited by policy:

![Result of resource deployment failure because of policy constraint](./media/azure-stack-policy-module/image1.png)

## Next steps

* [Deploy templates with PowerShell](azure-stack-deploy-template-powershell.md)
* [Deploy templates with Azure CLI](azure-stack-deploy-template-command-line.md)
* [Deploy Templates with Visual Studio](azure-stack-deploy-template-visual-studio.md)
