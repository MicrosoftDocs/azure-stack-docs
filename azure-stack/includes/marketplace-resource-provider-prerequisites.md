---
author: BryanLa
ms.author: bryanla
ms.service: azure-stack
ms.topic: include
ms.date: 11/27/2019
ms.reviewer: bryanla
ms.lastreviewed: 11/27/2019
---

If you've already installed a resource provider from Azure Stack Hub Marketplace, you've likely completed the common prerequisites, and can skip this section. Otherwise, complete the following prerequisites first: 

1. [Register your Azure Stack Hub instance with Azure](../operator/azure-stack-registration.md), if you haven't done so. This step is required as you'll be connecting to and downloading items to marketplace from Azure.

2. If you're not familiar with the **Marketplace Management** feature of the Azure Stack Hub administrator portal, review [Download marketplace items from Azure and publish to Azure Stack Hub](../operator/azure-stack-download-azure-marketplace-item.md). The article walks you through the process of downloading items from Azure to the Azure Stack Hub marketplace. It covers both connected and disconnected scenarios. If your Azure Stack Hub instance is disconnected or partially connected, there are additional prerequisites to complete in preparation for installation.

3. Update your Azure Active Directory (Azure AD) home directory. Starting with build 1910, the new Deployment Resource Provider (DRP) application must be used to register your home directory tenant. This app will enable DRP to successfully create and register Resource Providers. If this step isn't completed, your Resource Provider installation will fail. 

   - After you've successfully updated your Azure Stack Hub instance to 1910, follow the [instructions for cloning/downloading the Azure Stack Hub Tools repository](../operator/azure-stack-powershell-download.md). 
   - Then, follow the instructions for [Updating the Azure Stack Hub Azure AD Home Directory (after installing updates or new Resource Providers)](https://github.com/Azure/AzureStack-Tools/tree/master/Identity#updating-the-azure-stack-aad-home-directory-after-installing-updates-or-new-resource-providers). 