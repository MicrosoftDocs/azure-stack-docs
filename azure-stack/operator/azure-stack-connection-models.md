---
title: Azure Stack Hub integrated systems connection models 
description: Determine connection models and other deployment planning decisions for Azure Stack Hub integrated systems.
author: IngridAtMicrosoft
ms.topic: article
ms.date: 1/22/2020
author: inhenkel
ms.reviewer: wfayed
ms.lastreviewed: 02/21/2019
---

# Azure Stack Hub integrated systems connection models
If you're interested in purchasing an Azure Stack Hub integrated system, you need to understand [several datacenter integration considerations](azure-stack-datacenter-integration.md) for Azure Stack Hub deployment to determine how the system will fit into your datacenter. In addition, you need to decide how you'll integrate Azure Stack Hub into your hybrid cloud environment. This article provides an overview of these major decisions including Azure connection models, identity store options, and billing model options.

If you decide to purchase an integrated system, your original equipment manufacturer (OEM) hardware vendor will help guide you through the planning process in more detail. The OEM hardware vendor also performs the actual deployment.

## Choose an Azure Stack Hub deployment connection model
You can choose to deploy Azure Stack Hub either connected to the internet (and to Azure) or disconnected. Deploy connected to Azure to get the most benefit from Azure Stack Hub, including hybrid scenarios between Azure Stack Hub and Azure. This choice defines which options are available for your identity store (Azure Active Directory or Active Directory Federation Services) and billing model (pay as you use-based billing or capacity-based billing) as summarized in the following diagram and table:

![Azure Stack Hub deployment and billing scenarios](media/azure-stack-connection-models/azure-stack-scenarios.png)
  
> [!IMPORTANT]
> This is a key decision point! Choosing Active Directory Federation Services (AD FS) or Azure Active Directory (Azure AD) is a one-time decision that you must make at deployment time. You can't change this later without re-deploying the entire system.  


|Options|Connected to Azure|Disconnected from Azure|
|-----|:-----:|:-----:|
|Azure AD|![Supported](media/azure-stack-connection-models/check.png)| |
|AD FS|![Supported](media/azure-stack-connection-models/check.png)|![Supported](media/azure-stack-connection-models/check.png)|
|Consumption-based billing|![Supported](media/azure-stack-connection-models/check.png)| |
|Capacity-based billing|![Supported](media/azure-stack-connection-models/check.png)|![Supported](media/azure-stack-connection-models/check.png)|
|Licensing| Enterprise Agreement or Cloud Solution Provider | Enterprise Agreement |
|Patch and update|Update package can be downloaded directly from the Internet to Azure Stack Hub |  Required<br><br>Also requires removable media<br> and a separate connected device |
| Registration | Automated | Required<br><br>Also requires removable media<br> and a separate connected device |

After you've decided on the Azure connection model to be used for your Azure Stack Hub deployment, additional connection-dependent decisions must be made for the identity store and billing method.

## Next steps

[Azure connected Azure Stack Hub deployment decisions](azure-stack-connected-deployment.md)

[Azure disconnected Azure Stack Hub deployment decisions](azure-stack-disconnected-deployment.md)
