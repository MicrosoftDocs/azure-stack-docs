---
title: Azure Stack Hub datacenter integration walkthrough | Microsoft Docs
description: Learn what to expect for a successful on-site deployment of Azure Stack Hub in your datacenter, from planning to post-deployment.
author: mattbriggs

ms.topic: article
ms.date: 11/07/2019
ms.author: mabrigg
ms.reviewer: asganesh
ms.lastreviewed: 11/07/2019
---
 
# Azure Stack Hub datacenter integration walkthrough

This article describes the end-to-end process for Azure Stack Hub datacenter integration, from purchasing to post-deployment support. The integration is a collaborative project between the customer, a solution provider, and Microsoft. Click the following tabs to see the specific steps for each member of the project, and see the next sections for a summary of different phases for the project timeline. 

# [Customer](#tab/customer)

1. Describe use cases and requirements
1. Determine the billing model
1. Review and approve contracts
1. Complete the [Deployment Worksheet](azure-stack-deployment-worksheet.md)
1. Make sure deployment prerequisites are met
1. Prepare the datacenter 
1. Provide subscription info during deployment
1. Resolve any questions about the provided data

# [Partner](#tab/partner)

1. Recommend solution options based on customer requirements
1. Propose proof of concept (POC) 
1. Decide level of support
1. Prepare contracts with the customer
1. Create customer purchase order
1. Decide delivery schedule
1. Connect customer with Microsoft 
1. Train customer on deployment 
1. Help customer validate collected data
1. Install and validate baseline build and Microsoft deployment toolkit
1. Ship hardware to customer site
1. Provide onsite engineer
1. Rack and stack
1. Deploy Hardware lifecycle host (HLH) 
1. Deploy Azure Stack Hub
1. Hand off to customer

# [Microsoft](#tab/micro)

1. Engage partner for presales support
2. Prepare software licensing and contracts
3. Provide tools to collect datacenter integration requirements
4. Provide monthly baseline builds and tool chain updates
5. Microsoft support engineers assist with any deployment issues

---

## Planning
Microsoft or an Azure Stack Hub solution partner will help evaluate your goals. They'll help you decide questions like:

-   Is Azure Stack Hub the right solution for your organization?
-   What type of billing and licensing model will work for your organization?
-   What size solution will you need?
-   What are the power and cooling requirements?

Use the [Azure Stack Hub Capacity Planner](https://gallery.technet.microsoft.com/Azure-Stack-Capacity-24ccd822) to investigate and analyze the best hardware capacity and configuration for your needs. 

## Ordering
Your organization commits to purchasing Azure Stack Hub, signs contracts and purchase orders, and provides the integration requirements data to the solution provider.

## Pre-deployment
You decide how to integrate Azure Stack Hub into your datacenter. Microsoft collaborated with solution providers to publish a [deployment worksheet](azure-stack-deployment-worksheet.md) to help you gather the necessary information.
The [general datacenter integration considerations](azure-stack-datacenter-integration.md) article provides information that helps you complete the template, known as the Deployment Worksheet.

> [!IMPORTANT]
> All prerequisites are investigated before ordering the solution to help prevent deployment delays. Verifying prerequisites can take time and require coordination and data gathering from different departments within your organization. 

You'll choose the following items:

- **Azure Stack Hub connection model and identity provider**. You can choose to deploy Azure Stack Hub either [connected to the internet (and to Azure) or disconnected](azure-stack-connection-models.md). To get the most benefit from Azure Stack Hub, including hybrid scenarios, you'd want to deploy connected to Azure. Choosing Active Directory Federation Services (AD FS) or Azure Active Directory (Azure AD) is a one-time decision that you must make at deployment time. **You can't change your identity provider later without redeploying the entire system**.

- **Licensing model**. The licensing model options for you to choose from depend on the kind of deployment you'll have. Your identity provider choice has no bearing on tenant virtual machines or the identity system and accounts they use.
    - Customers that are in a [disconnected deployment](azure-stack-disconnected-deployment.md) have only one option: capacity-based billing.

    - Customers that are in a [connected deployment](azure-stack-connected-deployment.md) can choose between capacity-based billing and pay-as-you-use. Capacity-based billing requires an Enterprise Agreement (EA) Azure Subscription for registration. This is necessary for registration, which provides for the availability of items in Azure Marketplace through an Azure Subscription.

- **Network integration**. [Network integration](azure-stack-network.md) is crucial for deployment, operation, and management of Azure Stack Hub systems. There are several considerations that go into ensuring the Azure Stack Hub solution is resilient and has a highly available physical infrastructure to support its operations.

- **Firewall integration**. It's recommended that you [use a firewall](azure-stack-firewall.md) to help secure Azure Stack Hub. Firewalls can help prevent DDOS attacks, intrusion detection, and content inspection. However, it should be noted that it can become a throughput bottleneck for Azure storage services.

- **Certificate requirements**. It's critical that all [required certificates](azure-stack-pki-certs.md) are available *before* an onsite engineer arrives at your datacenter for deployment.

Once all the pre-requisite information is gathered through the deployment worksheet, the solution provider will kick off the factory process based on the data collected to ensure a successful integration of Azure Stack Hub into your datacenter.

## Hardware delivery 
Your solution provider will work with you on scheduling when the solution will arrive to your facility. Once received and put in place, you'll need to schedule time with the solution provider to have an engineer come onsite to perform the Azure Stack Hub deployment.

It's **crucial** that all prerequisite data is locked and available *before the onsite engineer arrives to deploy the solution*.

-   All certificates must be purchased and ready.

-   Region name must be decided on.

-   All network integration parameters are finalized and match with what you have shared with your solution provider.

> [!TIP]
> If any of this information has changed, make sure to communicate the change with the solution provider before you schedule the actual deployment.

## Onsite deployment 
To deploy Azure Stack Hub, an onsite engineer from your hardware solution provider will need to be present to kick off the deployment. To ensure a successful deployment, ensure that all information provided through the deployment worksheet hasn't changed.

The following checks are what you should expect from the onsite engineer during the deployment experience:

- Check all the cabling and border connectivity to ensure the solution is properly put together and meets your requirements.
- Configure the solution HLH (Hardware Lifecycle Host), if present.
- Check to make sure all BMC, BIOS, and network settings are correct.
- Make sure firmware for all components is at the latest approved version by the solution.
- Start the deployment.

> [!NOTE]
> A deployment procedure by the onsite engineer might take about one business week to complete.

## Post-deployment 
Several steps must be performed by the partner before the solution is handed off to the customer in the post-integration phase. In this phase, validation is important to ensure the system is deployed and performing correctly. 

Actions that should be taken by the OEM Partner are:

- [Run test-azurestack](azure-stack-diagnostic-test.md).

- [Registration with Azure](azure-stack-registration.md).

- [Marketplace Syndication](azure-stack-download-azure-marketplace-item.md#use-the-marketplace-syndication-tool-to-download-marketplace-items).

- Backup Switch Configuration and HLH Configuration files.

- Remove DVM.

- Prepare a customer summary for deployment.

- [Check updates to make sure the solution software is updated to the latest version](./azure-stack-updates.md).

There are several steps that are required or optional depending on the installation type.

- If deployment was completed using [AD FS](azure-stack-integrate-identity.md), then the Azure Stack Hub stamp will need to be integrated with customer's own AD FS.

  > [!NOTE]
  > This step is the responsibility of the customer, although the partner may optionally choose to offer services to do this.

- Integration with an existing monitoring system from the respective partner.

  -   [System Center Operations Manager Integration](azure-stack-integrate-monitor.md) also supports fleet management capabilities.

  -   [Nagios Integration](azure-stack-integrate-monitor.md#integrate-with-nagios).

## Schedule

![Overall timeline for Azure Stack Hub on-site deployment](./media/azure-stack-datacenter-integration-walkthrough/image1.png)

## Support
Azure Stack Hub enables an Azure-consistent, integrated support experience that covers the full system lifecycle. To fully support Azure Stack Hub integrated systems, customers need two support contracts: one with Microsoft (or their Cloud Solution Provider) for Azure services support and one with the hardware provider for system support. The integrated support experience provides coordinated escalation and resolution so that customers get a consistent support experience no matter whom they call first. For customers who already have Premier, Azure -Standard / ProDirect or Partner support with Microsoft, Azure Stack Hub software support is included.

The integrated support experience makes use of a Case Exchange mechanism for bi-directional transfer of support cases and case updates between Microsoft and the hardware partner. Microsoft Azure Stack Hub will follow the [Modern Lifecycle policy](https://support.microsoft.com/help/30881).

## Next steps
Learn more about [general datacenter integration considerations](azure-stack-datacenter-integration.md).
