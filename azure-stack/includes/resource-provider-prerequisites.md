---
author: sethmanheim
ms.author: sethm
ms.service: azure-stack
ms.topic: include
ms.date: 05/22/2026
ms.reviewer: sethm

---

If you already installed a resource provider, you likely completed the following prerequisites and can skip this section. Otherwise, complete these steps before continuing.

1. [Register your Azure Stack Hub instance with Azure](../operator/azure-stack-registration.md), if you haven't done so. You need to register your Azure Stack Hub instance with Azure because you'll connect to Azure and download items from the marketplace.

1. If you're not familiar with the **Marketplace Management** feature of the Azure Stack Hub administrator portal, review [Download marketplace items from Azure and publish to Azure Stack Hub](../operator/azure-stack-download-azure-marketplace-item.md). The article walks you through the process of downloading items from Azure to the Azure Stack Hub marketplace. It covers both connected and disconnected scenarios. If your Azure Stack Hub instance is disconnected or partially connected, you need to complete additional prerequisites in preparation for installation.

1. Update your Microsoft Entra home directory. Starting with build 1910, you must register a new application in your home directory tenant. This app enables Azure Stack Hub to successfully create and register newer resource providers (like Azure Event Hubs and others) with your Microsoft Entra tenant.

   This action is required after you upgrade to build 1910 or newer. If you don't complete this step, installations of resource providers from the marketplace fail.

1. After you successfully update your Azure Stack Hub instance to 1910 or later, follow the [instructions for cloning/downloading the Azure Stack Hub Tools repository](../operator/azure-stack-powershell-download.md).

1. Follow the [instructions for updating the Azure Stack Hub Microsoft Entra home directory (after installing updates or new resource providers)](https://github.com/Azure/AzureStack-Tools/tree/master/Identity#updating-the-azure-stack-aad-home-directory-after-installing-updates-or-new-resource-providers).
