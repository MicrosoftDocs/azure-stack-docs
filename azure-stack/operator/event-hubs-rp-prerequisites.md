---
title: Prerequisites for installing Event Hubs on Azure Stack
description: Learn about the required prerequisites, before installing the Event Hubs resource provider on Azure Stack. 
author: BryanLa
ms.author: bryanla
ms.service: azure-stack
ms.topic: how-to
ms.date: 10/31/2019
ms.reviewer: jfggdl
ms.lastreviewed: 10/31/2019
---

# Prerequisites for installing Event Hubs on Azure Stack

The following prerequisites must be completed, before you can install Event Hubs on Azure Stack. **Several days or weeks of lead time may be required**, to complete all steps.

> [!IMPORTANT]
> **Private Preview Only**. Azure Stack 1910 build version or higher is required by Event Hubs. Please note that Azure Stack builds are incremental. For example, if you have [version 1907](/azure-stack/operator/release-notes?view=azs-1907#1907-build-reference) installed, you must first upgrade to [1908](/azure-stack/operator/release-notes?view=azs-1908#1908-build-reference), and then to 1910, in order to participate in the private preview. That is, you cannot skip builds in-between.


1. [Register your Azure Stack instance with Azure](azure-stack-registration.md), if you haven't done so. This step is required as you'll be connecting to and downloading items to marketplace from Azure.

2. Update your Azure Active Directory (Azure AD) home directory. 
    - Starting with build 1910, the new Deployment Resource Provider (DRP) application must be used to register your home directory tenant. This app will enable DRP to successfully create and register Resource Providers. If this step isn't completed, your Resource Provider installations will fail. 
    - After you've successfully updated your Azure Stack instance to 1910, please ensure that you update your Azure AD Home directory. Use the `Update-AzsHomeDirectoryTenant` cmdlet from the Azure Stack Tools repository (https://github.com/Azure/AzureStack-Tools/tree/master/Identity#updating-the-azure-stack-aad-home-directory-after-installing-updates-or-new-resource-providers). Instructions to get the clone/download repository are here: https://github.com/Azure/AzureStack-Tools#azure-stack 

3. Procure SSL certificates for Event Hubs. For more information about the process, see Procure SSL Certificate for Azure Stack integrated systems (multi-node). 

4. See [Validate Azure Stack PKI certificates](/azure-stack/operator/azure-stack-validate-pki-certs.mdperform-platform-as-a-service-certificate-validation), to prepare and validate the certificates you use for the Event Hubs resource provider. 

5. Configure your identity provider. You have two general options:

   - Azure AD: If your Azure Stack instance is connected to the internet, using Azure AD for identity management, follow the instructions in [Add a new Azure Stack tenant account in AAD](azure-stack-add-new-user-aad.md). 
   - Active Directory Federation Services (ADFS): If you're using ADFS as your identity provider, follow the steps in [Add Azure Stack users in ADFS](azure-stack-add-users-adfs.md). ADFS can be used when you want to manage identities locally, where Azure Stack is disconnected from the Internet.

6. If you're not familiar with the **Marketplace Management** feature of the Azure Stack administrator portal, spend time reviewing [Download marketplace items from Azure and publish to Azure Stack](azure-stack-download-azure-marketplace-item.md). This article will walk you through the process of downloading items from Azure to the Azure Stack marketplace. It covers both connected and disconnected scenarios. If your Azure Stack instance is disconnected or partially connected, there are some additional prerequisites to complete in preparation for installation.

## Next steps

[Install the Event Hubs resource provider](event-hubs-rp-install.md)