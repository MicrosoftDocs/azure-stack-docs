---
title: How to install Event Hubs on Azure Stack Hub
description: Learn how to install the Event Hubs resource provider on Azure Stack Hub. 
author: BryanLa
ms.author: bryanla
ms.service: azure-stack
ms.topic: how-to
ms.date: 09/02/2020
ms.reviewer: jfggdl
ms.lastreviewed: 09/02/2020
---

# How to install Event Hubs on Azure Stack Hub

This article shows you how to download and install the Event Hubs resource provider, making it available to offer to customers for subscription.

## Download packages

> [!NOTE]
> Installing the Event Hubs resource provider in a disconnected Azure Stack Hub is not yet supported.

Before you can install Event Hubs on Azure Stack Hub, you must download the resource provider and its dependent packages using the Marketplace Management feature. If you're not familiar with Marketplace Management, spend time reviewing [Download marketplace items from Azure and publish to Azure Stack Hub](azure-stack-download-azure-marketplace-item.md). This section walks you through the process of downloading items from Azure to the Azure Stack Hub marketplace: 

> [!NOTE]
> The download process can take 30 minutes to 2 hours, depending on the network latency and existing packages on your Azure Stack Hub instance. 

1. Sign in to the Azure Stack Hub administrator portal.
2. Select **Marketplace Management** on the left.
3. Select **Resource providers**.
4. Select **+ Add from Azure**.
5. Search for "Event Hubs" using the search bar.
6. Select the "Event Hubs" row on the search results. 
7. On the "Event Hubs" download page, select the Event Hubs version you wish to install, then select **Download** at the bottom of the page. 
   [![Marketplace management packages](media/event-hubs-rp-install/1-marketplace-management-download.png)](media/event-hubs-rp-install/1-marketplace-management-download.png#lightbox)

Notice that additional software packages are downloaded along with Event Hubs, including:

- Microsoft Azure Stack Hub Add-On RP Windows Server INTERNAL ONLY
- PowerShell Desired State Configuration

## Installation 

1. If you haven't already, sign in to the Azure Stack Hub administrator portal, select **Marketplace Management** on the left, select **Resource providers**.
2. Once Event Hubs and other required software have been downloaded, **Marketplace Management** shows the "Event Hubs" packages with a status of "Not Installed". There may be other packages that show a status of "Downloaded". Select the "Event Hubs" row you wish to install.
   [![Marketplace management downloaded packages](media/event-hubs-rp-install/2-marketplace-management-downloaded.png)](media/event-hubs-rp-install/2-marketplace-management-downloaded.png#lightbox)
 
3. The Event Hubs install package page shows a blue banner across the top. Select the banner to start the installation of Event Hubs.
   [![Marketplace management event hubs - begin install](media/event-hubs-rp-install/3-marketplace-management-install-ready.png)](media/event-hubs-rp-install/3-marketplace-management-install-ready.png#lightbox)

### Install prerequisites

1. Next you're transferred to the install page. Select **Install Prerequisites** to begin the installation process.
   ![Marketplace management event hubs - install prerequisites](media/event-hubs-rp-install/4-marketplace-management-install-prereqs-start.png)
 
2. Wait until the installation of prerequisites succeeds. You should see a green checkmark next to **Install prerequisites** before proceeding to the next step.

   ![Marketplace management event hubs - install prerequisites succeeded](media/event-hubs-rp-install/5-marketplace-management-install-prereqs-succeeded.png)

### Prepare secrets 

1. Under the **2. Prepare secrets** step, select **Add certificate**, and the **Add a certificate** panel will appear.
   ![Marketplace management event hubs - prepare secrets](media/event-hubs-rp-install/6-marketplace-management-install-prepare-secrets.png)

2. Select the browse button on **Add a certificate**, just to the right of the certificate filename field.
3. Select the .pfx certificate file you procured when completing the prerequisites. For more information, see [the installation Prerequisites](event-hubs-rp-prerequisites.md). 

4. Enter the password you provided to create a secure string for Event Hubs SSL Certificate. Then select **Add**.
   ![Marketplace management event hubs - add certificate](media/event-hubs-rp-install/7-marketplace-management-install-prepare-secrets-add-cert.png)

### Install resource provider

1. When the installation of the certificate succeeds, you should see a green checkmark next to **Prepare secrets** before proceeding to the next step. Now select the **Install** button next to **3 Install resource provider**.
   ![Marketplace management event hubs - start RP install](media/event-hubs-rp-install/8-marketplace-management-install-start.png)
 
2. Next you'll see the following page, which indicates that Event Hubs resource provider is being installed.
   [![Marketplace management event hubs - RP installing](media/event-hubs-rp-install/9-marketplace-management-install-inprogress.png)](media/event-hubs-rp-install/9-marketplace-management-install-inprogress.png#lightbox)
 
3. Wait for the installation complete notification. This process usually takes one or more hours, depending on your Azure Stack Hub type. 
   [![Marketplace management event hubs - RP install complete](media/event-hubs-rp-install/10-marketplace-management-install-complete.png)](media/event-hubs-rp-install/10-marketplace-management-install-complete.png#lightbox)

4. Verify that the installation of Event Hubs has succeeded, by returning to the **Marketplace Management**, **Resource Providers** page. The status of Event Hubs should show "Installed".
   ![Marketplace management event hubs available](media/event-hubs-rp-install/11-marketplace-management-rps-installed.png)

## Next steps

Before users can deploy Event Hubs resources, you must create one or more plans, offers, and subscriptions. 

- If this is the first time you're offering a service, start with the [Offer services to users](tutorial-offer-services.md) tutorial. Then continue with the next tutorial, [Test a service offering](tutorial-test-offer.md).
- Once you're familiar with the concept of offering a service, create an offer and plan that includes the Event Hubs resource provider. Then create a subscription for your users, or give them the offer information so they can create their own. For reference, you can also follow the series of articles under the [Service, plan, offer, subscription overview](service-plan-offer-subscription-overview.md).

To check for updates, [How to update Event Hubs on Azure Stack Hub](resource-provider-apply-updates.md).

If you need to remove the resource provider, see [Remove the Event Hubs resource provider](event-hubs-rp-remove.md)

To learn more about the user experience, visit the [Event Hubs on Azure Stack Hub overview](../user/event-hubs-overview.md) in the User documents.