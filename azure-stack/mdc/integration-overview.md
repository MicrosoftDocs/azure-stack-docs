---
title: Modular Datacenter integration overview
description: Learn what to expect for a successful onsite deployment of Azure Modular Datacenter (MDC), from planning to post deployment.
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
ms.lastreviewed: 11/04/2020
---
 

# Modular Datacenter integration overview

This article describes the end-to-end process for Azure Modular Datacenter (MDC) integration, from purchasing to post deployment. The integration is a collaborative project between the customer and Microsoft. The following sections cover different phases of the project timeline and specific steps for project members.

## Introduction

The following table lists what can be expected during the various phases of deployment.

| Participant |Order process |Predeployment |Integration, validation, transport |Onsite deployment |Post deployment |
|---|---------------|---------------|-----------------------------------|--------------------|----------------|
|Microsoft | Signal to delivery to US location. |Provide required tooling and documentation to collect datacenter requirements. |- Validate configuration artifacts and check validation results.<br>- Ensure hardware is delivered. |- Rack and stack.<br>- Network integration.<br>- Azure Stack Hub deployment.<br>- Hand off to customer. |Registration and Azure Stack Hub Marketplace syndication.|
|Customer |Signal purchase. |- Fill out network details in deployment worksheet.<br>- Collect certificates.<br>- Obtain Azure Active Directory (Azure AD) accounts.<br>- Run any validation tooling provided. |Ensure the site is ready with network, power, and cooling prerequisites. |- Be prepared with deployment configuration artifacts.<br>- Ensure customer's network engineer is available. |     |

## Order process

Your organization will work with Microsoft to place an order for an allocated number of systems. After you place the order, Microsoft will deliver MDC to your US location. Microsoft will ensure that all secure supply chain requirements are met.

## Pre-deployment

You decide how to integrate Azure Stack Hub into your datacenter. Microsoft has published a [deployment worksheet](../operator/azure-stack-deployment-worksheet.md) that guides you through gathering all necessary information needed to integrate successfully into your datacenter. In addition, a certain set of certificates is required at the time of deployment. To help you obtain these certificates, Microsoft provides you with the [Azure Stack Hub Readiness Checker](../operator/azure-stack-validation-report.md). This tool will help you create Certificate Signing Requests (CSRs) to provide to your internal certificate authority.

>[!Important]
>All prerequisites are validated to help prevent deployment delays. Verifying prerequisites can take time and require coordination and data gathering from different departments within your organization.

You'll choose the following items:

- **Azure Stack Hub connection model and identity provider.** You can choose to deploy Azure Stack Hub either [connected to the internet (and to Azure)](../operator/azure-stack-connected-deployment.md) or [disconnected](../operator/azure-stack-disconnected-deployment.md). To get the most benefit from Azure Stack Hub, including hybrid scenarios, you want to deploy connected to Azure. Choosing Active Directory Federation Services (AD FS) or Azure AD is a one-time decision that you must make at deployment time. *You can't change your identity provider later without redeploying the entire system.*
- **Network integration.** [Network integration](../operator/azure-stack-network.md) is crucial for deployment, operation, and management of Azure Stack Hub systems. There are several considerations that go into ensuring the Azure Stack Hub solution is resilient and has a highly available physical infrastructure to support its operations.
- **Firewall integration.** We recommend that you [use a firewall](../operator/azure-stack-firewall.md) to help secure Azure Stack Hub. Firewalls can help prevent DDoS attacks, intrusion detection, and content inspection. Note that firewalls can become a throughput bottleneck for Azure storage services.
- **Certificate requirements.** It's critical that all [required certificates](../operator/azure-stack-pki-certs.md) are available before an onsite engineer arrives at your datacenter for deployment.

After all the prerequisite information is gathered through the deployment worksheet, Microsoft will ensure that we verify all validation tools have been run and assist with any further questions that you might have.

## Hardware delivery

Microsoft will work with you to ensure all required hardware arrives at the US location within the allocated time given.

It's *crucial* that all prerequisite data is locked and available *before the onsite Microsoft deployment engineer arrives to deploy the solution.*

- Deployment worksheet has all data filled out.
- All certificates must be validated and ready.
- Region name must be decided on.
- All network integration parameters are finalized.

>[!Tip]
>If any of this information has changed, make sure to work with your internal organization to ensure the information is updated prior to the arrival of the onsite deployment engineer. Updating your information will prevent any delays in the deployment process.
## Onsite deployment

To deploy Azure Stack Hub, a Microsoft deployment engineer will be present to kick off the deployment. We also require a network engineer from your organization to be available during the onsite deployment.

The following checks are what you should expect from the onsite engineer during the deployment experience:

- Unbox and inventory hardware.
- Connect power and power on the solution.
- Validate physical hardware health.
- Check all the cabling and border connectivity to ensure the solution is properly put together and meets your requirements.
- Configure the solution Hardware Lifecycle Host (HLH).
- Integrate the datacenter network.
- Check to make sure all physical hardware settings are correct.
- Make sure firmware for all components is at the latest approved version by the solution.
- Start the deployment.

## Post deployment

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

[Modular Datacenter deployment overview](deployment-overview.md)

