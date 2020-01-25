---
title: Azure disconnected deployment decisions for Azure Stack Hub integrated systems | Microsoft Docs
description: Learn about Azure disconnected deployment of Azure Stack Hub integrated systems and the planning decisions to consider.
author: mattbriggs

ms.service: azure-stack
ms.topic: article
ms.date: 11/01/2019
ms.author: mabrigg
ms.reviewer: wfayed
ms.lastreviewed: 11/01/2019

---
# Azure disconnected deployment planning decisions for Azure Stack Hub integrated systems
After you've decided [how you'll integrate Azure Stack Hub into your hybrid cloud environment](azure-stack-connection-models.md), you can finish your Azure Stack Hub deployment decisions.

You can deploy and use Azure Stack Hub without a connection to the internet. However, with a disconnected deployment, you're limited to an Active Directory Federation Services (AD FS) identity store and the capacity-based billing model. Because multitenancy requires the use of Azure Active Directory (Azure AD), multitenancy isn't supported for disconnected deployments.

Choose this option if:
- You have security or other restrictions that require you to deploy Azure Stack Hub in an environment that isn't connected to the internet.
- You want to block data (including usage data) from being sent to Azure.
- You want to use Azure Stack Hub purely as a private cloud solution that's deployed to your corporate intranet, and aren't interested in hybrid scenarios.

> [!TIP]
> Sometimes, this kind of environment is also referred to as a *submarine scenario*.

A disconnected deployment doesn't restrict you from later connecting your Azure Stack Hub instance to Azure for hybrid tenant VM scenarios. It means that you don't have connectivity to Azure during deployment or you don't want to use Azure AD as your identity store.

## Features that are impaired or unavailable in disconnected deployments 
Azure Stack Hub was designed to work best when connected to Azure, so it's important to note that there are some features and functionality that are either impaired or completely unavailable in the disconnected mode.

|Feature|Impact in Disconnected mode|
|-----|-----|
|VM deployment with DSC extension to configure VM post deployment|Impaired - DSC extension looks to the internet for the latest WMF.|
|VM deployment with Docker Extension to run Docker commands|Impaired - Docker will check the internet for the latest version and this check will fail.|
|Documentation links in the Azure Stack Hub Portal|Unavailable - Links like Give Feedback, Help, and Quickstart that use an internet URL won't work.|
|Alert remediation/mitigation that references an online remediation guide|Unavailable - Any alert remediation links that use an internet URL won't work.|
|Marketplace - The ability to select and add Gallery packages directly from Azure Marketplace|Impaired - When you deploy Azure Stack Hub in a disconnected mode, you can't download marketplace items by using the Azure Stack Hub portal. However, you can use the [marketplace syndication tool](azure-stack-download-azure-marketplace-item.md) to download the marketplace items to a machine that has internet connectivity and then transfer them to your Azure Stack Hub environment.|
|Using Azure AD federation accounts to manage an Azure Stack Hub deployment|Unavailable - This feature requires connectivity to Azure. AD FS with a local Active Directory instance must be used instead.|
|App Services|Impaired - WebApps may require internet access for updated content.|
|Command Line Interface (CLI)|Impaired - CLI has reduced functionality for authentication and provisioning of service principals.|
|Visual Studio - Cloud discovery|Impaired - Cloud Discovery will either discover different clouds or won't work at all.|
|Visual Studio - AD FS|Impaired - Only Visual Studio Enterprise and Visual Studio Code support AD FS authentication.
Telemetry|Unavailable - Telemetry data for Azure Stack Hub and any third-party gallery packages that depend on telemetry data.|
|Certificates|Unavailable - internet connectivity is required for Certificate Revocation List (CRL) and Online Certificate Status Protocol (OSCP) services in the context of HTTPS.|
|Key Vault|Impaired - A common use case for Key Vault is to have an app read secrets at runtime. For this use case, the app needs a service principal in the directory. In Azure AD, regular users (non-admins) are by default allowed to add service principals. In Azure AD (using AD FS), they're not. This impairment places a hurdle in the end-to-end experience because one must always go through a directory admin to add any app.

## Learn more
- For information about use cases, purchasing, partners, and OEM hardware vendors, see the [Azure Stack Hub](https://azure.microsoft.com/overview/azure-stack/) product page.
- For information about the roadmap and geo-availability for Azure Stack Hub integrated systems, see the white paper: [Azure Stack Hub: An extension of Azure](https://azure.microsoft.com/resources/azure-stack-an-extension-of-azure/). 
- To learn more about Microsoft Azure Stack Hub packaging and pricing, [download the .pdf](https://azure.microsoft.com/mediahandler/files/resourcefiles/5bc3f30c-cd57-4513-989e-056325eb95e1/Azure-Stack-packaging-and-pricing-datasheet.pdf). 

## Next steps
[Datacenter network integration](azure-stack-network.md)
