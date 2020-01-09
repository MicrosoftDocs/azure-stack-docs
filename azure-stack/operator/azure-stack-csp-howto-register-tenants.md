---
title: Add tenants for usage and billing to Azure Stack Hub | Microsoft Docs
description: Learn how to add a tenant for usage and billing to Azure Stack Hub.
services: azure-stack
documentationcenter: ''
author: sethmanheim
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: na
pms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 09/25/2019
ms.author: sethm
ms.reviewer: alfredop
ms.lastreviewed: 09/17/2019

---

# Add tenant for usage and billing to Azure Stack Hub

*Applies to: Azure Stack Hub integrated systems*

This article shows you how to add a tenant to an Azure Stack Hub deployment managed by a Cloud Solution Provider (CSP). When the new tenant uses resources, Azure Stack Hub reports usage to their CSP subscription.

CSPs often offer services to multiple end customers (tenants) on their Azure Stack Hub deployment. Adding tenants to the Azure Stack Hub registration ensures that each tenant's usage is reported and billed to the corresponding CSP subscription. If you don't complete the steps in this article, tenant usage is charged to the subscription used in the initial registration of Azure Stack Hub. Before you can add an end customer to Azure Stack Hub for usage tracking and to manage their tenant, you must configure Azure Stack Hub as a CSP. For steps and resources, see [Manage usage and billing for Azure Stack Hub as a Cloud Solution Provider](azure-stack-add-manage-billing-as-a-csp.md).

The following figure shows the steps that a CSP needs to follow to enable a new end customer to use Azure Stack Hub, and to set up usage tracking for the customer. By adding the end customer, you're also able to manage resources in Azure Stack Hub. You have two options for managing their resources:

- You can maintain the end customer and provide credentials for the local Azure Stack Hub subscription to the end customer.  
- The end customer can work with their subscription locally and add the CSP as a guest with owner permissions.

## Add an end customer

Before you add an end customer, you must enable multi-tenant billing on your registration. In order to enable multi-tenant billing, send the registration subscription ID, resource group name, and registration name to `azstcsp@microsoft.com`. It usually takes 1-2 business days to enable multi-tenancy.

Perform the following steps to add an end customer, as pictured in the following figure:

![Set up Cloud Solution Provider for usage tracking and to manage the end customer account](media/azure-stack-csp-enable-billing-usage-tracking/process-csp-enable-billing.png)

### Create a new customer in Partner Center

In Partner Center, create a new Azure subscription for the customer. For instructions, see [Add a new customer](/partner-center/add-a-new-customer).

### Create an Azure subscription for the end customer

After you've created a record of your customer in Partner Center, you can sell them subscriptions to products in the catalog. For instructions, see [Create, suspend, or cancel customer subscriptions](/partner-center/create-a-new-subscription).

### Create a guest user in the end customer directory

By default, you, as the CSP, won't have access to the end customer's Azure Stack Hub subscription. However, if your customer wants you to manage their resources, they can then add your account as owner/contributor to their Azure Stack Hub subscription. In order to do that, they'll need to add your account as guest user to their Azure AD tenant. It's advised that you use a different account from your Azure CSP account to manage your customer's Azure Stack Hub subscription to ensure you don't lose access to your customer's Azure subscription.

### Update the registration with the end customer subscription

Update your registration with the new customer subscription. Azure reports the customer usage using the customer identity from Partner Center. This step ensures that each customer's usage is reported under that customer's individual CSP subscription. This makes tracking usage and billing easier. To perform this step, you must first [register Azure Stack Hub](azure-stack-registration.md).

1. Open Windows PowerShell with an elevated prompt, and run:  

   ```powershell
   Add-AzureRmAccount
   ```

   >[!Note]
   > If your session expires, your password has changed, or you simply wish to switch accounts, run the following cmdlet before you sign in using Add-AzureRmAccount: `Remove-AzureRmAccount-Scope Process`

2. Type your Azure credentials.
3. In the PowerShell session, run:

   ```powershell
   New-AzureRmResource -ResourceId "subscriptions/{registrationSubscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AzureStack/registrations/{registrationName}/customerSubscriptions/{customerSubscriptionId}" -ApiVersion 2017-06-01
   ```

### New-AzureRmResource PowerShell parameters

The following section describes the parameters for the **New-AzureRmResource** cmdlet:

| Parameter | Description |
| --- | --- |
|registrationSubscriptionID | The Azure subscription that was used for the initial registration of the Azure Stack Hub.|
| customerSubscriptionID | The Azure subscription (not Azure Stack Hub) belonging to the customer to be registered. Must be created in the CSP offer. In practice, this means through Partner Center. If a customer has more than one Azure Active Directory tenant, this subscription must be created in the tenant that will be used to log into Azure Stack Hub. The customer subscription ID must use lowercase letters. |
| resourceGroup | The resource group in Azure in which your registration is stored. |
| registrationName | The name of the registration of your Azure Stack Hub. It's an object stored in Azure. 

> [!NOTE]  
> Tenants must be registered with each Azure Stack Hub they use. If you have two Azure Stack Hub deployments, and a tenant uses both of them, you must update the initial registrations of each deployment with the tenant subscription.

### Onboard tenant to Azure Stack Hub

Configure Azure Stack Hub to support users from multiple Azure AD tenants to use services in Azure Stack Hub. For instructions, see [Enable multi-tenancy in Azure Stack Hub](azure-stack-enable-multitenancy.md).

### Create a local resource in the end customer tenant in Azure Stack Hub

Once you've added the new customer to Azure Stack Hub, or the end customer tenant has enabled your guest account with owner privileges, verify that you can create a resource in their tenant. For example, they can [Create a Windows virtual machine with the Azure Stack Hub portal](../user/azure-stack-quick-windows-portal.md).

## Next steps

- To review error messages if they're triggered in your registration process, see [Tenant registration error messages](azure-stack-registration-errors.md).
- To learn more about how to retrieve resource usage information from Azure Stack Hub, see [Usage and billing in Azure Stack Hub](azure-stack-billing-and-chargeback.md).
- To review how an end customer may add you, the CSP, as the manager for their Azure Stack Hub tenant, see [Enable a Cloud Solution Provider to manage your Azure Stack Hub subscription](../user/azure-stack-csp-enable-billing-usage-tracking.md).
