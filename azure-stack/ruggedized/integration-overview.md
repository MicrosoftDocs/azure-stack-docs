---
title: Azure Stack Hub datacenter integration overview
description: Learn what to expect for a successful on-site deployment of Azure Stack Hub ruggedized from Microsoft, from planning to post-deployment.
services: azure-stack
documentationcenter: ''
author: PatAltimore
manager: femila
editor: ''

ms.assetid: 
ms.service: azure-stack
ms.workload: na
pms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 02/18/2021
ms.author: patricka
ms.reviewer: asganesh
ms.lastreviewed: 10/14/2020
---
 
# Azure Stack Hub datacenter integration overview

This article describes the end-to-end process for Azure Stack Hub datacenter integration, from purchasing to post-deployment. The integration is a collaborative project between the customer and Microsoft. The following sections cover different phases for the project timeline and specific steps for project members.

## Introduction

The following table depicts what can be expected during the various phases of deployment.

| Participant |Order Process |Pre-Deployment |Integration, Validation, Transport |Onsite Deployment |Post-Deployment |
|---|---------------|---------------|-----------------------------------|--------------------|----------------|
|Microsoft |- Signal to delivery to US location<br>- Azure Stack Hub ruggedized  = 10 Days |Provide required tooling and documentation to collect datacenter requirements |- Validate configuration artifacts and check validation results<br>- Ensure hardware is delivered |- Rack and stack<br>- Network integration<br>- Azure Stack Hub deployment<br>- Hand off to customer |Registration and Marketplace syndication|
| Customer |Signals purchase |- Fills out network details in deployment worksheet<br>- Collects certificates<br>- Obtains Azure AD accounts<br>- Runs any validation tooling provided |Ensure the site is ready with network, power, cooling prerequisites |- Be prepared with deployment configuration artifacts<br>- Customer’s network engineer available |     |

## Order process

Your organization will work with Microsoft to place an order for an allocated number of systems. After you place the order, Microsoft will have 10 days to deliver the Azure Stack Hub ruggedized to your US location. Microsoft will ensure that all secure supply chain requirements are met.

>[!NOTE] 
>Billing starts 14 days after the hardware has shipped.

To create an Azure Stack Hub resource, take the following steps in the Azure portal.

1. Use your Microsoft Azure credentials to sign in to the Azure portal at this URL: [https://portal.azure.com](https://portal.azure.com).
1. In the left-pane, select **+ Create a resource**. Search for and select **Azure Stack Hub ruggedized**. Select **Create**.
1. Pick the subscription that you want to use for the Azure Stack Hub device. Select the country to where you want to ship this physical device. Select **Show devices**.
1. A short form is displayed. Fill out the form and select **Submit**. Microsoft will enable your subscription.
1. After the subscription is enabled, you should be able to able to proceed with the resource creation. In the **Select device type** blade, choose **Select**. 
1. On the **Basics** tab, enter or select the following **Project details**.
    
    |Setting  |Value  |
    |---------|---------|
    |Subscription    |This is automatically populated based on the earlier selection. Subscription is linked to your billing account. |
    |Resource group  |Select an existing group or create a new group.   |

1. Enter or select the following **Instance details**.

    |Setting  |Value  |
    |---------|---------|
    |Name   | A friendly name to identify the resource.<br>The name has between 2 and 50 characters containing letter, numbers, and hyphens.<br> Name starts and ends with a letter or a number.        |
    |Region     |For a list of all the regions where the Azure Stack Hub resource is available, see [Azure products available by region](https://azure.microsoft.com/global-infrastructure/services/?products=databox&regions=all). If using Azure Government, all the government regions are available as shown in the [Azure regions](https://azure.microsoft.com/global-infrastructure/regions/).<br> Choose a location closest to the geographical region where you want to deploy your device.|


1. Select **Next: Shipping address**.

    - If you already have a device, select the combo box for **I have a Azure Stack Hub device**.

    - If this is the new device that you are ordering, enter the contact name, company, address to ship the device, and contact information.

1. Select **Next: Review + create**.
1. On the **Review + create** tab, review the **Pricing details**, **Terms of use**, and the details for your resource. Select the combo box for **I have reviewed the privacy terms**.
1. Select **Create**.

The resource creation takes a few minutes. After the resource is successfully created and deployed, you're notified. Select **Go to resource**.

After the order is placed, Microsoft reviews the order and reaches out to you (via email) with shipping details.

## Pre-deployment

You decide how to integrate Azure Stack Hub into your datacenter. 
Microsoft has published a [deployment worksheet](../operator/azure-stack-deployment-worksheet.md) that guides you through gathering all necessary information needed to integrate successfully into your datacenter. In addition, a certain set of certificates are required at time of deployment. To help you obtain these certificates, Microsoft provides you with the [Azure Stack Hub Readiness Checker](../operator/azure-stack-validation-report.md). This tool will help you create Certificate Signing Requests (CSRs) to provide to your internal certificate authority. 

>[!Important]
>All prerequisites are validated to help prevent deployment delays. Verifying prerequisites can take time and require coordination and data gathering from different departments within your organization.

You'll choose the following items:

- **Azure Stack Hub connection model and identity provider.** You can choose to deploy Azure Stack Hub either [connected to the internet (and to Azure)](../operator/azure-stack-connected-deployment.md) or [disconnected](../operator/azure-stack-disconnected-deployment.md). To get the most benefit from Azure Stack Hub, including hybrid scenarios, you'd want to deploy connected to Azure. Choosing Active Directory Federation Services (AD FS) or Azure Active Directory (Azure AD) is a one-time decision that you must make at deployment time. *You can't change your identity provider later without redeploying the entire system.*
- **Network integration.** [Network integration](../operator/azure-stack-network.md) is crucial for deployment, operation, and management of Azure Stack Hub systems. There are several considerations that go into ensuring the Azure Stack Hub solution is resilient and has a highly available physical infrastructure to support its operations.
- **Firewall integration.** We recommended that you [use a firewall](../operator/azure-stack-firewall.md) to help secure Azure Stack Hub. Firewalls can help prevent DDoS attacks, intrusion detection, and content inspection. Note that firewalls can become a throughput bottleneck for Azure storage services.
- **Certificate requirements.** It's critical that all [required certificates](../operator/azure-stack-pki-certs.md) are available before an onsite engineer arrives at your datacenter for deployment.

After all the pre-requisite information is gathered through the deployment worksheet, Microsoft will ensure that we verify all validation tools have been run and assist with any further questions that you might have.

## Hardware Delivery

Microsoft will work with you to ensure all required hardware arrives at the US Location within the allocated time given.  

It's *crucial* that all prerequisite data is locked and available *before the onsite Microsoft deployment engineer arrives to deploy the solution.*

- Deployment Worksheet has all data filled out. 
- All certificates must be validated and ready.
- Region name must be decided on.
- All network integration parameters are finalized.

>[!Tip]
>If any of this information has changed, make sure to work with your internal organization to ensure the information is updated prior to the arrival of the onsite deployment engineer. This will prevent any delays in the deployment process.

## Onsite Deployment

To deploy Azure Stack Hub, a Microsoft deployment engineer will be present to kick off the deployment. We require that a network engineer from your organization to be available during the period of the onsite deployment.

The following checks are what you should expect from the onsite engineer during the deployment experience:

- Unbox and inventory of hardware.
- Connect power and power on the solution.
- Validate physical hardware health.
- Check all the cabling and border connectivity to ensure the solution is properly put together and meets your requirements.
- Configure the solution Hardware Lifecycle Host (HLH).
- Integrate the datacenter network.
- Check to make sure all physical hardware settings are correct.
- Make sure firmware for all components is at the latest approved version by the solution.
- Start the deployment. 

## Post Deployment

Several steps must be performed by the Microsoft deployment engineer before the solution is handed off to the customer. In this phase, validation is important to ensure the system is deployed and performing correctly.

Actions that should be taken by the Microsoft deployment engineer:

- Enable value-add resource providers.
- Run [test-azurestack](../operator/azure-stack-diagnostic-test.md).
- [Register](../operator/azure-stack-registration-role.md) with Azure.
- Ensure [Azure Stack Hub Marketplace syndication](../operator/azure-stack-marketplace.md).
- Back up switch configuration and HLH configuration files.
- Prepare a customer summary for deployment.
- [Check updates](../operator/azure-stack-updates.md) to make sure the solution software is updated to the latest version.

## Next steps

Learn more about [steps to install and configure Microsoft Azure Stack Hub Ruggedized](deployment-overview.md).

