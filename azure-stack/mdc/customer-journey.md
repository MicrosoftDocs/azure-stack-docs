---
title: Customer journey from purchasing to Azure Stack Hub post-deployment | Microsoft Docs
description: Learn what to expect for a successful on-site deployment of a Modular Data Center (MDC), from planning to post-deployment.
services: azure-stack
documentationcenter: ''
author: asganesh
manager: femila
editor: ''

ms.assetid: 
ms.service: azure-stack
ms.workload: na
pms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 10/27/2020
ms.author: justinha
ms.reviewer: asganesh
ms.lastreviewed: 10/27/2020
---
 

# MDC integration overview

This article describes the end-to-end process for MDC integration, from purchasing to post-deployment. 
The integration is a collaborative project between the customer and Microsoft. 
The following sections cover different phases for the project timeline and specific steps for project members.

## Introduction

The following table depicts what can be expected during the various phases of deployment.

|	|Order Process	|Pre-Deployment	|Integration, Validation, Transport	|Onsite Deployment	|Post-Deployment |
|---|---------------|---------------|-----------------------------------|--------------------|----------------|
|Microsoft	|- Signal to delivery to US location	|Provide required tooling and documentation to collect datacenter requirements	|- Validate configuration artifacts and check validation results<br>- Ensure hardware is delivered	|- Rack and stack<br>- Network integration<br>- Azure Stack Hub deployment<br>- Hand off to customer	|Registration and Marketplace syndication|
|Customer	|Signals purchase	|- Fills out network details in deployment worksheet<br>- Collects certificates<br>- Obtains Azure AD accounts<br>- Runs any validation tooling provided	|Ensure the site is ready with network, power, cooling prerequisites	|- Be prepared with deployment configuration artifacts<br>- Customer’s network engineer available	|     |


## Order Process

Your organization will work with Microsoft to place an order for an allocated number of systems. 
Once you place the order, Microsoft will deliver the MDC to your US location. Microsoft will ensure that all secure supply chain requirements are met. 


## Pre-Deployment

You decide how to integrate Azure Stack Hub into your datacenter. 
Microsoft has published a [deployment worksheet](../operator/azure-stack-deployment-worksheet.md) that guides you through gathering all necessary information needed to integrate successfully into your datacenter. 
In addition, a certain set of certificates are required at time of deployment. 
To help you obtain these certificates, Microsoft provides you a tool called the [Azure Stack Hub Readiness Checker](../operator/azure-stack-validation-report.md). 
This tool will help you create Certificate Signing Requests (CSRs) to provide to your internal CA. 

>[!Important]
>All prerequisites are validated to help prevent deployment delays. Verifying prerequisites can take time and require coordination and data gathering from different departments within your organization.

You'll choose the following items:

- **Azure Stack Hub connection model and identity provider.** You can choose to deploy Azure Stack Hub either [connected to the internet (and to Azure)](../operator/azure-stack-connected-deployment.md) or [disconnected](../operator/azure-stack-disconnected-deployment.md). To get the most benefit from Azure Stack Hub, including hybrid scenarios, you'd want to deploy connected to Azure. Choosing Active Directory Federation Services (AD FS) or Azure Active Directory (Azure AD) is a one-time decision that you must make at deployment time. **You can't change your identity provider later without redeploying the entire system.**
- **Network integration.** [Network integration](../operator/azure-stack-network.md) is crucial for deployment, operation, and management of Azure Stack Hub systems. There are several considerations that go into ensuring the Azure Stack Hub solution is resilient and has a highly available physical infrastructure to support its operations.
- **Firewall integration.** It's recommended that you [use a firewall](../operator/azure-stack-firewall.md) to help secure Azure Stack Hub. Firewalls can help prevent DDOS attacks, intrusion detection, and content inspection. However, it should be noted that it can become a throughput bottleneck for Azure storage services.
- **Certificate requirements.** It's critical that all [required certificates](../operator/azure-stack-pki-certs.md) are available before an onsite engineer arrives at your datacenter for deployment.

Once all the pre-requisite information is gathered through the deployment worksheet, Microsoft will ensure that we verify all validation tools have been run and assist with any further questions that you may have. 

## Site preparation

For more information about requirements for site preparation, see the Quick Start Guide.

## Hardware Delivery

Microsoft will work with you to ensure all required hardware arrives at the US Location within the allocated time given.  

It's **crucial** that all prerequisite data is locked and available *before the onsite Microsoft deployment engineer arrives to deploy the solution.*

- Deployment Worksheet has all data filled out. 
- All certificates must be validated and ready.
- Region name must be decided on.
- All network integration parameters are finalized.

>[!Tip]
>If any of this information has changed, make sure to work with your internal organization to ensure the information is updated prior to the arrival of the onsite deployment engineer. This will prevent any delays in the deployment process.

## Onsite Deployment

To deploy Azure Stack Hub, a Microsoft deployment engineer will be present to kick off the deployment. 
We require that a Network Engineer from your organization also be available during the period of the onsite deployment.

The following checks are what you should expect from the onsite engineer during the deployment experience:

- Unboxing and inventory of hardware
- Connecting power and powering on the solution
- Validating physical hardware health
- Check all the cabling and border connectivity to ensure the solution is properly put together and meets your requirements
- Configure the solution HLH (Hardware Lifecycle Host)
- Datacenter network integration
- Check to make sure all physical hardware settings are correct
- Make sure firmware for all components is at the latest approved version by the solution
- Start the deployment

## Post Deployment

Several steps must be performed by the Microsoft deployment engineer before the solution is handed off to the customer. 
In this phase, validation is important to ensure the system is deployed and performing correctly.

Actions that should be taken by the Microsoft deployment engineer:

- Enable value-add resource providers (RPs)
- Run [test-azurestack](../operator/azure-stack-diagnostic-test.md)
- [Registration](../operator/azure-stack-registration-role.md) with Azure
- [Marketplace syndication](../operator/azure-stack-marketplace.md)
- Backup switch configuration and HLH configuration files
- Prepare a customer summary for deployment
- [Check updates](../operator/azure-stack-updates.md) to make sure the solution software is updated to the latest version

## Next steps

Learn more about [steps to install and configure a Modular Data Center](deployment-overview.md).

