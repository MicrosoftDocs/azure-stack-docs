---
title: Prerequisites for installing Azure Stack Hub resource providers from marketplace.
description: Learn about the required prerequisites, for marketplace-installable resource providers on Azure Stack Hub. 
author: BryanLa
ms.author: bryanla
ms.service: azure-stack
ms.topic: how-to
ms.date: 11/27/2019
ms.reviewer: bryanla
ms.lastreviewed: 11/27/2019
---

# Prerequisites for installing Azure Stack Hub resource providers from Marketplace

The following prerequisites must be completed, before you can install resource providers from Marketplace on Azure Stack Hub. 

## Prerequisites

1. [Register your Azure Stack Hub instance with Azure](azure-stack-registration.md), if you haven't done so. This step is required as you'll be connecting to and downloading items to marketplace from Azure.

2. If you're not familiar with the **Marketplace Management** feature of the Azure Stack Hub administrator portal, review [Download marketplace items from Azure and publish to Azure Stack Hub](azure-stack-download-azure-marketplace-item.md). The article walks you through the process of downloading items from Azure to the Azure Stack Hub marketplace. It covers both connected and disconnected scenarios. If your Azure Stack Hub instance is disconnected or partially connected, there are additional prerequisites to complete in preparation for installation.

2. Update your Azure Active Directory (Azure AD) home directory. Starting with build 1910, the new Deployment Resource Provider (DRP) application must be used to register your home directory tenant. This app will enable DRP to successfully create and register Resource Providers. If this step isn't completed, your Resource Provider installation will fail. 

   - After you've successfully updated your Azure Stack Hub instance to 1910, follow the [instructions for cloning/downloading the Azure Stack Hub Tools repository](azure-stack-powershell-download.md). 
   - Then, follow the instructions for [Updating the Azure Stack Hub Azure AD Home Directory (after installing updates or new Resource Providers)](https://github.com/Azure/AzureStack-Tools/tree/master/Identity#updating-the-azure-stack-aad-home-directory-after-installing-updates-or-new-resource-providers). 

## Next steps

Next, continue with the installation of the desired resource provider:

- [Event Hubs on Azure Stack Hub](event-hubs-rp-overview.md)
- [IoT Hub on Azure Stack Hub](event-hubs-rp-overview.md)