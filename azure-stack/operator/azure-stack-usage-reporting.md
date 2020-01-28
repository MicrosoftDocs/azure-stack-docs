---
title: Report Azure Stack Hub usage data to Azure | Microsoft Docs
description: Learn how to set up usage data reporting in Azure Stack Hub.
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
ms.date: 01/27/2020
ms.author: sethm
ms.reviewer: alfredop
ms.lastreviewed: 05/07/2019
---

# Report Azure Stack Hub usage data to Azure

Usage data, also called consumption data, represents the amount of resources used.

Azure Stack Hub multi-node systems that use the consumption-based billing model should report usage data to Azure for billing purposes. Azure Stack Hub operators should configure their Azure Stack Hub instance to report usage data to Azure.

> [!IMPORTANT]
> All workloads [must be deployed under tenant subscriptions](#are-users-charged-for-the-infrastructure-vms) to comply with the licensing terms of Azure Stack Hub.

Usage data reporting is required for the Azure Stack Hub multi-node users who license under the pay-as-you-use model. It is optional for customers who license under the capacity model (see the [How to buy](https://azure.microsoft.com/overview/azure-stack/how-to-buy/) page). For Azure Stack Development Kit (ASDK) users, Azure Stack Hub operators can report usage data and test the feature. However, users will not be charged for any usage they incur.

![billing flow](media/azure-stack-usage-reporting/billing-flow.png)

Usage data is sent from Azure Stack Hub to Azure through the Azure Bridge. In Azure, the commerce system processes the usage data and generates the bill. After the bill is generated, the Azure subscription owner can view and download it from the [Azure Account Center](https://account.windowsazure.com/subscriptions). To learn about how Azure Stack Hub is licensed, see the [Azure Stack Hub packaging and pricing document](https://go.microsoft.com/fwlink/?LinkId=842847).

## Set up usage data reporting

To set up usage data reporting, you must [register your Azure Stack Hub instance with Azure](azure-stack-registration.md). As part of the registration process, the Azure Bridge component of Azure Stack Hub, which connects Azure Stack Hub to Azure and sends the usage data, is configured. The following usage data is sent from Azure Stack Hub to Azure:

- **Meter ID** - Unique ID for the resource that was consumed.
- **Quantity** - Amount of resource usage.
- **Location** - Location where the current Azure Stack Hub resource is deployed.
- **Resource URI** - Fully qualified URI of the resource for which usage is being reported.
- **Subscription ID** - Subscription ID of the Azure Stack Hub user, which is the local (Azure Stack Hub) subscription.
- **Time** - Start and end time of the usage data. There is some delay between the time when these resources are consumed in Azure Stack Hub and when the usage data is reported to commerce. Azure Stack Hub aggregates usage data for every 24 hours, and reporting usage data to the commerce pipeline in Azure takes another few hours. Therefore, usage that occurs shortly before midnight can appear in Azure the following day.

## Generate usage data reporting

- To test usage data reporting, create a few resources in Azure Stack Hub. For example, you can create a [storage account](azure-stack-provision-storage-account.md), [Windows Server VM](../user/azure-stack-create-vm-template.md), and a Linux VM with Basic and Standard SKUs to see how core usage is reported. The usage data for different types of resources are reported under different meters.

- Leave your resources running for a few hours. Usage information is collected approximately once every hour. After collecting, this data is transmitted to Azure and processed into the Azure commerce system. This process can take up to a few hours.

## View usage - CSP subscriptions

If you registered your Azure Stack Hub using a CSP subscription, you can view your usage and charges in the same way in which you view Azure consumption. Azure Stack Hub usage is included in your invoice and in the reconciliation file, available through the [Partner Center](https://partnercenter.microsoft.com/partner/home). The reconciliation file is updated monthly. If you need to access recent Azure Stack Hub usage information, you can use the Partner Center APIs.

![partner center](media/azure-stack-usage-reporting/partner-center.png)

## View usage - Enterprise Agreement subscriptions

If you registered your Azure Stack Hub using an Enterprise Agreement subscription, you can view your usage and charges in the [EA portal](https://ea.azure.com/). Azure Stack Hub usage is included in the advanced downloads along with Azure usage under the reports section in this portal.

## View usage - other subscriptions

If you registered your Azure Stack Hub using any other subscription type; for example, a pay-as-you-go subscription, you can view usage and charges in the Azure Account Center. Sign in to the [Azure Account Center](https://account.windowsazure.com/subscriptions) as the Azure account administrator, and select the Azure subscription that you used to register Azure Stack Hub. You can view the Azure Stack Hub usage data, the amount charged for each of the used resources, as shown in the following image:

![billing flow](media/azure-stack-usage-reporting/pricing-details.png)

For the ASDK, Azure Stack Hub resources are not charged, so the price shown is $0.00.

## Which Azure Stack Hub deployments are charged?

Resource usage is free for the ASDK. Azure Stack Hub multi-node systems, workload VMs, Storage services, and App Services, are charged.

## Are users charged for the infrastructure VMs?

No. Usage data for some Azure Stack Hub resource provider VMs are reported to Azure, but there are no charges for these VMs, nor for the VMs created during deployment to enable the Azure Stack Hub infrastructure.  

Users are only charged for VMs that run under tenant subscriptions. All workloads must be deployed under tenant subscriptions to comply with the licensing terms of Azure Stack Hub.

## I have a Windows Server license I want to use on Azure Stack Hub, how do I do it?

Using the existing licenses avoids generating usage meters. Existing Windows Server licenses can be used in Azure Stack Hub, as described in the "Using existing software with Azure Stack Hub" section of the [Azure Stack Hub Licensing Guide](https://go.microsoft.com/fwlink/?LinkId=851536). In order to use their existing licenses, customers must deploy their Windows Server virtual machines as described in [Hybrid benefit for Windows Server license](/azure/virtual-machines/windows/hybrid-use-benefit-licensing).

## Which subscription is charged for the resources consumed?

The subscription that is provided when [registering Azure Stack Hub with Azure](azure-stack-registration.md) is charged.

## What types of subscriptions are supported for usage data reporting?

For Azure Stack Hub multi-node, Enterprise Agreement (EA) and CSP subscriptions are supported. For the Azure Stack Development Kit, Enterprise Agreement (EA), pay-as-you-go, CSP, and MSDN subscriptions support usage data reporting.

## Does usage data reporting work in sovereign clouds?

In the Azure Stack Development Kit, usage data reporting requires subscriptions that are created in the global Azure system. Subscriptions created in one of the sovereign clouds (the Azure Government, Azure Germany, and Azure China 21Vianet clouds) cannot be registered with Azure, so they do not support usage data reporting.

## Why doesn't the usage reported in Azure Stack Hub match the report generated from Azure Account Center?

There is always a delay between the usage data reported by the Azure Stack Hub usage APIs and the usage data reported in the Azure Account Center. This delay is the time required to upload usage data from Azure Stack Hub to Azure commerce. Due to this delay, usage that occurs shortly before midnight might appear in Azure the following day. If you use the [Azure Stack Hub usage APIs](azure-stack-provider-resource-api.md), and compare the results to the usage reported in the Azure billing portal, you can see a difference.

## Next steps

- [Provider usage API](azure-stack-provider-resource-api.md)  
- [Tenant usage API](azure-stack-tenant-resource-usage-api.md)
- [Usage FAQ](azure-stack-usage-related-faq.md)
- [Manage usage and billing as a Cloud Solution Provider](azure-stack-add-manage-billing-as-a-csp.md)
