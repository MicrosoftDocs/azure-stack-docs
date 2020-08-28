---
title: Usage and billing registration error codes in Azure Stack Hub
description: Learn about usage and billing registration error codes in Azure Stack Hub.
author: sethmanheim
ms.topic: article
ms.date: 08/27/2020
ms.author: sethm
ms.reviewer: avishwan
ms.lastreviewed: 06/27/2019

# Intent: As an Azure Stack operator, I want to learn about the error registration codes in Azure Stack Hub so I can address them.
# Keyword: registration error codes azure stack hub
---

# Usage and billing registration error codes

If you're a Cloud Solution Provider (CSP), the following error messages can happen when [adding tenants](azure-stack-csp-ref-operations.md#add-tenant-to-registration) to a registration for reporting usage against the customer's Azure subscription ID.

## List of registration error codes

| Error   | Details  | Comments  |
|---|---|---|
| RegistrationNotFound | The provided registration wasn't found. Make sure the following information was provided correctly:<br>1. Subscription identifier (value provided: **subscription identifier**),<br>2. Resource group (value provided: **resource group**),<br>3. Registration name (value provided: **registration name**). | This error usually happens when the information pointing to the initial registration isn't correct. If you need to verify the resource group and name of your registration, you can find it in the Azure portal, by listing all resources. If you find more than one registration resource, look at the **CloudDeploymentID** in the properties, and select the registration whose **CloudDeploymentID** matches that of your cloud. To find the **CloudDeploymentID**, you can use this PowerShell command on Azure Stack Hub:<br>`$azureStackStampInfo = Invoke-Command -Session $session -ScriptBlock { Get-AzureStackStampInformation }` |
| BadCustomerSubscriptionId | The provided **customer subscription identifier** and the **registration name** subscription identifier aren't owned by the same Microsoft CSP. Check that the customer subscription identifier is correct. The customer subscription ID is case sensitive. If the problem persists, contact support. | This error happens when the customer subscription is a CSP subscription, but it rolls up to a CSP partner different from the one to which the subscription used in the initial registration rolls up. This check is made to prevent a situation that would result in billing a CSP partner who isn't responsible for the Azure Stack Hub used. |
| InvalidCustomerSubscriptionId  | The **customer subscription identifier** isn't valid. Make sure a valid Azure subscription is provided. |   |
| CustomerSubscriptionNotFound  | **Customer subscription identifier** wasn't found under **registration name**. Make sure a valid Azure subscription is being used and that the subscription ID was added to the registration using the PUT operation. | This error happens when trying to verity that a tenant has been added to a subscription but the customer subscription isn't found to be associated with the registration. The customer hasn't been added to the registration, or the subscription ID has been written incorrectly. |
| UnauthorizedCspRegistration | The provided **registration name** isn't approved to use multi-tenancy. Send an email to azstCSP@microsoft.com and include your registration name, resource group, and the subscription identifier used in the registration. | A registration must be approved for multi-tenancy by Microsoft before you can start adding tenants to it. |
| CustomerSubscriptionsNotAllowed | Customer subscription operations aren't supported for disconnected customers. To use this feature, re-register with pay-as-you-use licensing. | The registration to which you're trying to add tenants is a capacity registration. So when the registration was created, the parameter `BillingModel Capacity` was used. Only pay-as-you-use registrations are allowed to add tenants. You must re-register using the parameter `BillingModel PayAsYouUse`. |
| InvalidCSPSubscription | The provided **customer subscription identifier** isn't a valid CSP subscription. Make sure a valid Azure subscription is provided. | This error is most likely due to the customer subscription being mistyped. |
| MetadataResolverBadGatewayError | One of the upstream servers returned an unexpected error. Try again later. If the problem persists, contact support. |

## Next steps

- Learn more about the [Usage reporting infrastructure for Cloud Solution Providers](azure-stack-csp-ref-infrastructure.md).
- To learn more about the CSP program, see [Cloud Solutions](https://partner.microsoft.com/solutions/microsoft-cloud-solutions).
- To learn more about how to retrieve resource usage information from Azure Stack Hub, see [Usage and billing in Azure Stack Hub](azure-stack-billing-and-chargeback.md).
