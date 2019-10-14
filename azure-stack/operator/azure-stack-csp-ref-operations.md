---
title: Register tenants for usage tracking in Azure Stack | Microsoft Docs
description: Learn how to register tenants and how tenant usage is tracked in Azure Stack.
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
ms.date: 10/14/2019
ms.author: sethm
ms.reviewer: alfredop
ms.lastreviewed: 10/14/2019

---

# Register tenants for usage tracking in Azure Stack

*Applies to: Azure Stack integrated systems*

This article contains details about registration operations. You can use these operations to:

- Manage tenant registrations
- Manage tenant usage tracking

## Add tenant to registration

You can use this operation when you want to add a new tenant to your registration. Tenant usage is reported under an Azure subscription connected with the Azure Active Directory (Azure AD) tenant.

You can also use this operation to change the subscription associated with a tenant. Call PUT or **New-AzureRMResource** to overwrite the previous mapping.

You can associate a single Azure subscription with a tenant. If you try to add a second subscription to an existing tenant, the first subscription is overwritten.

### Use API profiles

The following registration cmdlets require that you specify an API profile when running PowerShell. API profiles represent a set of Azure resource providers and their API versions. They help you use the right version of the API when interacting with multiple Azure clouds. For example, if you work with multiple clouds when working with global Azure and Azure Stack, API profiles specify a name that matches their release date. You use the **2017-09-03** profile.

For more information about Azure Stack and API profiles, see [Manage API version profiles in Azure Stack](../user/azure-stack-version-profiles.md).

### Parameters

| Parameter                  | Description |
|---                         | --- |
| registrationSubscriptionID | The Azure subscription that was used for the initial registration. |
| customerSubscriptionID     | The  Azure subscription (not Azure Stack) belonging to the customer to be registered. Must be created in the Cloud Solution Provider (CSP) offer through the Partner Center. If a customer has more than one tenant, create a subscription for the tenant to sign in to Azure Stack. |
| resourceGroup              | The resource group in Azure in which your registration is stored. |
| registrationName           | The name of the registration of your Azure Stack. It's an object stored in Azure. The name is usually in the form **azurestack-CloudID**, where **CloudID** is the cloud ID of your Azure Stack deployment. |

> [!NOTE]  
> Tenants need to be registered with each Azure Stack deployment that they use. If a tenant uses more than one Azure Stack, update the initial registrations of each deployment with the tenant subscription.

### PowerShell

Use the **New-AzureRmResource** cmdlet to add a tenant. [Connect to Azure Stack](azure-stack-powershell-configure-admin.md), and then from an elevated prompt use the following cmdlet:

```powershell  
New-AzureRmResource -ResourceId "subscriptions/{registrationSubscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AzureStack/registrations/{registrationName}/customerSubscriptions/{customerSubscriptionId}" -ApiVersion 2017-06-01
```

### API call

**Operation**: PUT  
**RequestURI**: `subscriptions/{registrationSubscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AzureStack/registrations/{registrationName}/customerSubscriptions/
{customerSubscriptionId}?api-version=2017-06-01 HTTP/1.1`  
**Response**: 201 Created  
**Response Body**: Empty  

## List all registered tenants

Get a list of all tenants that have been added to a registration.

 > [!NOTE]  
 > If no tenants have been registered, you won't receive a response.

### Parameters

| Parameter                  | Description          |
|---                         | ---                  |
| registrationSubscriptionId | The Azure subscription that was used for the initial registration.   |
| resourceGroup              | The resource group in Azure in which your registration is stored.    |
| registrationName           | The name of the registration of your Azure Stack deployment. It's an object stored in Azure. The name is usually in the form of **azurestack-CloudID**, where **CloudID** is the cloud ID of your Azure Stack deployment.   |

### PowerShell

Use the **Get-AzureRmResource** cmdlet to list all registered tenants. [Connect to Azure Stack](azure-stack-powershell-configure-admin.md), and then from an elevated prompt run the following cmdlet:

```powershell
Get-AzureRmResource -ResourceId "subscriptions/{registrationSubscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AzureStack/registrations/{registrationName}/customerSubscriptions" -ApiVersion 2017-06-01
```

### API call

You can get a list of all tenant mappings using the GET operation.

**Operation**: GET  
**RequestURI**: `subscriptions/{registrationSubscriptionId}/resourceGroups/{resourceGroup}  
/providers/Microsoft.AzureStack/registrations/{registrationName}/customerSubscriptions?  
api-version=2017-06-01 HTTP/1.1`  
**Response**: 200  
**Response Body**:

```json
{
    "value": [{
            "id": " subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AzureStack/registrations/{registrationName}/customerSubscriptions/{ cspSubscriptionId 1}",
            "name": " cspSubscriptionId 1",
            "type": "Microsoft.AzureStack\customerSubscriptions",
            "properties": { "tenantId": "tId1" }
        },
        {
            "id": " subscriptions/{subscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AzureStack/registrations/{registrationName}/customerSubscriptions/{ cspSubscriptionId 2}",
            "name": " cspSubscriptionId2 ",
            "type": "Microsoft.AzureStack\customerSubscriptions",
            "properties": { "tenantId": "tId2" }
        }
    ],
    "nextLink": "{originalRequestUrl}?$skipToken={opaqueString}"
}
```

## Remove a tenant mapping

You can remove a tenant that has been added to a registration. If that tenant is still using resources on Azure Stack, their usage is charged to the subscription used in the initial Azure Stack registration.

### Parameters

| Parameter                  | Description          |
|---                         | ---                  |
| registrationSubscriptionId | Subscription ID for the registration.   |
| resourceGroup              | The resource group for the registration.   |
| registrationName           | The name of the registration.  |
| customerSubscriptionId     | The customer subscription ID.  |

### PowerShell

Use the **Remove-AzureRmResource** cmdlet to remove a tenant. [Connect to Azure Stack](azure-stack-powershell-configure-admin.md), and then from an elevated prompt run the following cmdlet:

```powershell
Remove-AzureRmResource -ResourceId "subscriptions/{registrationSubscriptionId}/resourceGroups/{resourceGroup}/providers/Microsoft.AzureStack/registrations/{registrationName}/customerSubscriptions/{customerSubscriptionId}" -ApiVersion 2017-06-01
```

### API call

You can remove tenant mappings using the DELETE operation.

**Operation**: DELETE  
**RequestURI**: `subscriptions/{registrationSubscriptionId}/resourceGroups/{resourceGroup}  
/providers/Microsoft.AzureStack/registrations/{registrationName}/customerSubscriptions/  
{customerSubscriptionId}?api-version=2017-06-01 HTTP/1.1`  
**Response**: 204 No Content  
**Response Body**: Empty

## Next steps

- [How to retrieve resource usage information from Azure Stack](azure-stack-billing-and-chargeback.md)
