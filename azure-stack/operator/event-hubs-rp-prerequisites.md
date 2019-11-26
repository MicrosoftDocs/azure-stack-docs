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

1. [TODO - deploy at least 4-node Azure Stack Hub. look for link. make sure this includes registration and AAD home directory designation and remove #2 below. Also add NOTE: Event Hubs is not supported on ASDK]

2. Update your Azure Active Directory (Azure AD) home directory. Starting with build 1910, the new Deployment Resource Provider (DRP) application must be used to register your home directory tenant. This app will enable DRP to successfully create and register Resource Providers. If this step isn't completed, your Resource Provider installation will fail. 

   - After you've successfully updated your Azure Stack Hub instance to 1910, follow the [instructions for cloning/downloading the Azure Stack Hub Tools repository](azure-stack-powershell-download.md). 
   - Then, follow the instructions for [Updating the Azure Stack Hub Azure AD Home Directory (after installing updates or new Resource Providers)](https://github.com/Azure/AzureStack-Tools/tree/master/Identity#updating-the-azure-stack-aad-home-directory-after-installing-updates-or-new-resource-providers). 

3. Procure public key infrastructure (PKI) SSL certificates for Event Hubs. 

   Please adhere to the following naming pattern for the certificate `Alternate Subject Name`. See [PKI certificate requirements](azure-stack-pki-certs.md) for the full list of detailed requirements. : 

   | Subject name | Alternative subject name |
   |--------------|--------------------------|
   | \<user-defined\> | `CN=*.eventhub.<region>.<fqdn>`|

   ![example certificate](media/event-hubs-rp-prerequisites/certificate-example.png)

    [!NOTE] PFX files must be password protected. The password will be requested during installation.


    Be sure to [Validate your certificate](/azure-stack/operator/azure-stack-validate-pki-certs.mdperform-platform-as-a-service-certificate-validation), to prepare and validate the certificates you use for the Event Hubs resource provider. 

## Next steps

Next, [install the Event Hubs resource provider](event-hubs-rp-install.md).