---
title: Azure disconnected deployment decisions for Azure Stack Hub integrated systems 
description: Learn about Azure disconnected deployment of Azure Stack Hub integrated systems and the planning decisions to consider.
author: sethmanheim
ms.topic: conceptual
ms.date: 05/10/2022
ms.author: sethm
ms.reviewer: wfayed
ms.lastreviewed: 11/01/2019

# Intent: As an Azure Stack operator, I want to know the planning decisions for deploying Azure Stack integrated systems disconnected from Azure.
# Keyword: azure stack disconnected deployment

---


# Azure disconnected deployment planning decisions for Azure Stack Hub integrated systems
After you've decided [how you'll integrate Azure Stack Hub into your hybrid cloud environment](azure-stack-connection-models.md), you can finish your Azure Stack Hub deployment decisions.

You can deploy and use Azure Stack Hub without a connection to the internet. However, with a disconnected deployment, you're limited to an Active Directory Federation Services (AD FS) identity store and the capacity-based billing model. Because multitenancy requires the use of Microsoft Entra ID, multitenancy isn't supported for disconnected deployments.

Choose this option if:
- You have security or other restrictions that require you to deploy Azure Stack Hub in an environment that isn't connected to the internet.
- You want to block data (including usage data) from being sent to Azure.
- You want to use Azure Stack Hub purely as a private cloud solution that's deployed to your corporate intranet, and aren't interested in hybrid scenarios.

> [!TIP]
> Sometimes, this kind of environment is also referred to as a *submarine scenario*.

A disconnected deployment doesn't restrict you from later connecting your Azure Stack Hub instance to Azure for hybrid tenant VM scenarios. It means that you don't have connectivity to Azure during deployment or you don't want to use Microsoft Entra ID as your identity store.

## Features that are impaired or unavailable in disconnected deployments 
Azure Stack Hub was designed to work best when connected to Azure, so it's important to note that there are some features and functionality that are either impaired or completely unavailable in the disconnected mode.

|Feature|Impact in Disconnected mode|
|-----|-----|
|VM deployment with DSC extension to configure VM post deployment|Impaired - DSC extension looks to the internet for the latest WMF.|
|VM deployment with Docker Extension to run Docker commands|Impaired - Docker will check the internet for the latest version and this check will fail.|
|Documentation links in the Azure Stack Hub Portal|Unavailable - Links like Give Feedback, Help, and Quickstart that use an internet URL won't work.|
|Alert remediation/mitigation that references an online remediation guide|Unavailable - Any alert remediation links that use an internet URL won't work.|
|Marketplace - The ability to select and add Gallery packages directly from Azure Marketplace|Impaired - When you deploy Azure Stack Hub in a disconnected mode, you can't download marketplace items by using the Azure Stack Hub portal. However, you can use the [marketplace syndication tool](azure-stack-download-azure-marketplace-item.md) to download the marketplace items to a machine that has internet connectivity and then transfer them to your Azure Stack Hub environment.|
|Using Microsoft Entra federation accounts to manage an Azure Stack Hub deployment|Unavailable - This feature requires connectivity to Azure. AD FS with a local Active Directory instance must be used instead.|
|App Services|Impaired - WebApps may require internet access for updated content.|
|Command Line Interface (CLI)|Impaired - CLI has reduced functionality for authentication and provisioning of service principals.|
|Visual Studio - Cloud discovery|Impaired - Cloud Discovery will either discover different clouds or won't work at all.|
|Visual Studio - AD FS|Impaired - Only Visual Studio Enterprise and Visual Studio Code support AD FS authentication.
Telemetry|Unavailable - Telemetry data for Azure Stack Hub and any third-party gallery packages that depend on telemetry data.|
|Certificate Authority (CA)|**Public/external Certificate Authority (CA)**<br>Unavailable – Deployment will fail if certificates were issued from a public CA, as internet connectivity is required to access the Certificate Revocation List (CRL) and Online Certificate Status Protocol (OCSP) services in the context of HTTPS.<br><br>**Private/internal Certificate Authority (CA)**<br>No impact - In cases where the deployment uses certificates issued by a private CA, such as an internal CA within an organization, only internal network access to the CRL endpoint is required. Internet connectivity is not required, but **you should verify that your Azure Stack Hub infrastructure has the required network access to contact the CRL endpoint defined in the certificates CDP extension.**|
|Key Vault|Impaired - A common use case for Key Vault is to have an app read secrets at runtime. For this use case, the app needs a service principal in the directory. In Microsoft Entra ID, regular users (non-admins) are by default allowed to add service principals. In Microsoft Entra ID (using AD FS), they're not. This impairment places a hurdle in the end-to-end experience because one must always go through a directory admin to add any app.
|Containers|Impaired - Unable to import container images in disconnected mode from an Azure Container Registry in Azure public or another accessible registry. See FAQ entry at [Azure Container Registry on Azure Stack Hub](/azure-stack/user/container-registry-faq#how-do-i-push-a-container-image-in-azure-container-registry-to-a-disconnected-azure-stack-hub-deployment-running-kubernetes-) for information on how to import container images in Azure Container Registry to a disconnected Azure Stack Hub deployment running Kubernetes.

## Learn more
- For information about use cases, purchasing, partners, and OEM hardware vendors, see the [Azure Stack Hub](https://azure.microsoft.com/overview/azure-stack/) product page.
- For information about the roadmap and geo-availability for Azure Stack Hub integrated systems, see the white paper: [Azure Stack Hub: An extension of Azure](https://azure.microsoft.com/resources/videos/azure-friday-azure-stack-an-extension-of-azure/). 
- To learn more about Microsoft Azure Stack Hub packaging and pricing, [download the .pdf](https://azure.microsoft.com/resources/azure-stack-hub-licensing-packaging-pricing-guide/). 

## Next steps
[Datacenter network integration](azure-stack-network.md)
