---
author: sethmanheim
ms.author: sethm
ms.service: azure-stack
ms.topic: include
ms.date: 12/09/2019
ms.reviewer: sethm
ms.lastreviewed: 12/09/2019
---

If you've already installed a resource provider, you've likely completed the following prerequisites, and can skip this section. Otherwise, complete these steps before continuing: 

1. [Register your Azure Stack Hub instance with Azure](../operator/azure-stack-registration.md), if you haven't done so. This step is required as you'll be connecting to and downloading items to marketplace from Azure.

2. If you're not familiar with the **Marketplace Management** feature of the Azure Stack Hub administrator portal, review [Download marketplace items from Azure and publish to Azure Stack Hub](../operator/azure-stack-download-azure-marketplace-item.md). The article walks you through the process of downloading items from Azure to the Azure Stack Hub marketplace. It covers both connected and disconnected scenarios. If your Azure Stack Hub instance is disconnected or partially connected, there are additional prerequisites to complete in preparation for installation.

3. Update your Microsoft Entra home directory. Starting with build 1910, a new application must be registered in your home directory tenant. This app will enable Azure Stack Hub to successfully create and register newer resource providers (like Event Hubs and others) with your Microsoft Entra tenant. This is an one-time action that needs to be done after upgrading to build 1910 or newer. If this step isn't completed, marketplace resource provider installations will fail. 

   - After you've successfully updated your Azure Stack Hub instance to 1910 or greater, follow the [instructions for cloning/downloading the Azure Stack Hub Tools repository](../operator/azure-stack-powershell-download.md). 
   - Then, follow the instructions for [Updating the Azure Stack Hub Microsoft Entra Home Directory (after installing updates or new Resource Providers)](https://github.com/Azure/AzureStack-Tools/tree/master/Identity#updating-the-azure-stack-aad-home-directory-after-installing-updates-or-new-resource-providers). 
