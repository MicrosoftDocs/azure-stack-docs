---
title: Prerequisites for installing Event Hubs on Azure Stack Hub
description: Learn about the required prerequisites, before installing the Event Hubs resource provider on Azure Stack Hub. 
author: BryanLa
ms.author: bryanla
ms.service: azure-stack
ms.topic: how-to
ms.date: 11/18/2019
ms.reviewer: jfggdl
ms.lastreviewed: 11/18/2019
---

# Prerequisites for installing Event Hubs on Azure Stack Hub

The following prerequisites must be completed, before you can install Event Hubs on Azure Stack Hub. **Several days or weeks of lead time may be required**, to complete all steps.

## Prerequisites

> [!IMPORTANT]
> **Private Preview Only**. Azure Stack Hub 1910 build version or higher is required by Event Hubs. Please note that Azure Stack Hub builds are incremental. For example, if you have [version 1907](/azure-stack/operator/release-notes?view=azs-1907#1907-build-reference) installed, you must first upgrade to [1908](/azure-stack/operator/release-notes?view=azs-1908#1908-build-reference), and then to 1910, in order to participate in the private preview. That is, you cannot skip builds in-between.

1. [Register your Azure Stack Hub instance with Azure](azure-stack-registration.md), if you haven't done so. This step is required as you'll be connecting to and downloading items to marketplace from Azure.

2. Update your Azure Active Directory (Azure AD) home directory. Starting with build 1910, the new Deployment Resource Provider (DRP) application must be used to register your home directory tenant. This app will enable DRP to successfully create and register Resource Providers. If this step isn't completed, your Resource Provider installation will fail. 

   - After you've successfully updated your Azure Stack Hub instance to 1910, follow the [instructions for cloning/downloading the Azure Stack Hub Tools repository](azure-stack-powershell-download.md). 
   - Then, follow the instructions for [Updating the Azure Stack Hub Azure AD Home Directory (after installing updates or new Resource Providers)](https://github.com/Azure/AzureStack-Tools/tree/master/Identity#updating-the-azure-stack-aad-home-directory-after-installing-updates-or-new-resource-providers). 

3. Procure public key infrastructure (PKI) SSL certificates for Event Hubs. For more information about required certificates for resource providers, see [PKI certificate requirements](azure-stack-pki-certs.md). 

   Please also adhere to the following naming pattern for the certificate `Subject Name` and `Alternate Subject Name` : 

   | Subject name | Alternative subject name |
   |--------------|--------------------------|
   | `*.eventhub.<region>.<fqdn>` | `*.eventhub.<region>.<fqdn>`|

4. See [Validate Azure Stack Hub PKI certificates](/azure-stack/operator/azure-stack-validate-pki-certs.mdperform-platform-as-a-service-certificate-validation), to prepare and validate the certificates you use for the Event Hubs resource provider. 

5. If you're not familiar with the **Marketplace Management** feature of the Azure Stack Hub administrator portal, spend time reviewing [Download marketplace items from Azure and publish to Azure Stack Hub](azure-stack-download-azure-marketplace-item.md). This article will walk you through the process of downloading items from Azure to the Azure Stack Hub marketplace. It covers both connected and disconnected scenarios. If your Azure Stack Hub instance is disconnected or partially connected, there are some additional prerequisites to complete in preparation for installation.

## Next steps

Next, [install the Event Hubs resource provider](event-hubs-rp-install.md).