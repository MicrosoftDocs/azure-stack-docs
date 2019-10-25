---
title: How to install Event Hubs on Azure Stack
description: Learn how to install the Event Hubs resource provider on Azure Stack. 
author: BryanLa
ms.author: bryanla
ms.service: azure-stack
ms.topic: how-to
ms.date: 10/31/2019
ms.reviewer: jfggdl
ms.lastreviewed: 10/31/2019
---

# How to install Event Hubs on Azure Stack

This article shows you how to download and install the Event Hubs resource provider, making it available to offer to customers for subscription.

## Download packages

Before you can install Event Hubs on Azure Stack, you must download the resource provider and its dependent packages. You have two options depending on your situation or requirements:

- Download Event Hubs under a connected scenario.
- Download Event Hubs under a disconnected or partially connected scenario.

### Download Event Hubs under a connected scenario

Follow these instructions if your Azure Stack has Internet connectivity:

1. Sign in to the Azure Stack administrator portal.
2. Select **Marketplace Management** on the left.
3. Select **Resource providers**.
4. Click **+ Add from Azure**.
5. Search for "Event Hubs" using the search bar.
6. Click on the "Event Hubs" row on the search results. 
7. Select the Event Hubs version you wish to install, then click **Download** at the bottom of the page. 
   ![Marketplace management packages](media/event-hubs-rp-install/1-marketplace-management-download.png)

> [!NOTE]
> The download process can take 30 minutes to 2 hours, depending on the network latency and existing packages on your Azure Stack instance. 

You'll notice that additional software packages are downloaded along with Event Hubs, including:

- Microsoft AzureStack Add-On RP Windows Server INTERNAL ONLY
- PowerShell Desired State Configuration

Once the download process is complete, skip to the [Install Prerequisites section](#install-prerequisites).

### Download Event Hubs under a disconnected or partially connected scenario

This option is necessary when any of the following is true:

- You do not have an Internet connection.
- Your connection is not reliable.
- Your requirements prevent you from directly using Azure Stack to download packages.

1. If you haven't already, follow the instructions in [Disconnected or partially connected scenarios](azure-stack-download-azure-marketplace-item.md#disconnected-or-a-partially-connected-scenario). Here you download the Marketplace Syndication tool, which allows you to download the Event Hubs packages.
2. Run the Marketplace Syndicationi tool (`Export-AzSOfflineMarketplaceItem` PowerShell cmdlet). 
3. After the tool's "Azure Marketplace Items" window opens, find and select "Event Hubs" to download the required packages to your local machine.
4. Once the download finishes, you import the packages to your Azure Stack instance and publish to Marketplace. 

## Installation 

1. If you haven't already, sign in to the Azure Stack administrator portal.
2. Select **Marketplace Management** on the left, then select **Resource providers**.
3. Once Event Hubs and other required software have been downloaded, **Marketplace Management** should show the Event Hubs packages with a status of "Not Installed". There may be other packages that show a status of "Downloaded".

   ![Marketplace management downloaded packages](media/event-hubs-rp-install/2-marketplace-management-downloaded.png)
 
4. Click on the Event Hubs row. The portal should show a blue banner across the top. Click on that blue banner to start the installation of Event Hubs.
   ![Marketplace management event hubs - start install](media/event-hubs-rp-install/3-marketplace-management-install-ready.png)

### Install prerequisites

1. Click **Install Prerequisites**.
   ![Marketplace management event hubs - prerequisites](media/event-hubs-rp-install/4-marketplace-management-install-prereqs-start.png)
 
2. Wait until the installation of prerequisites succeeds. Make sure the installation is completed (green checkmark next to Install prerequisites) before proceeding to the next step.

   ![Marketplace management event hubs - prerequisites](media/event-hubs-rp-install/5-marketplace-management-install-prereqs-succeeded.png)

### Prepare secrets 

1. Under Prepare secrets step click on Add certificate.
   ![Marketplace management event hubs - prepare secrets](media/event-hubs-rp-install/6-marketplace-management-install-prereqs-secrets.png)

2. Click on the browse button on the Add a certificate blade.
3. Select the .pfx certificate file you procured based on Procure SSL Certificate for Azure Stack integrated systems (multi-node). Please see Prerequisites for more information. 

4. Input the password you provided to create a secure string for Event Hubs SSL Certificate and click Add.
   ![Marketplace management event hubs - add certificate](media/event-hubs-rp-install/7-marketplace-management-install-prereqs-secrets-add-cert.png)

### Install resource provider

1. Click on the Install button in step 3 Install resource provider.
   ![Marketplace management event hubs - start install](media/event-hubs-rp-install/8-marketplace-management-install-start.png)
 
2. You will now see the following page which informs that Event Hubs is being installed.
   ![Marketplace management event hubs - installing](media/event-hubs-rp-install/9-marketplace-management-install-inprogress.png)
 
3. Wait for the installation to complete. This usually takes 1+ hours depending on your Azure Stack type. 
   ![Marketplace management event hubs - install complete](media/event-hubs-rp-install/10-marketplace-management-install-complete.png)

4. Verify that the installation of Event Hubs has succeeded by navigating to Marketplace Management. The status of Event Hubs should read "Installed".
   ![Marketplace management event hubs available](media/event-hubs-rp-install/11-marketplace-management-rps-installed.png)

## Register Event Hubs

You now need to register the Event Hubs resource provider so that you can use see Event Hubs’ Admin page, which is the blade used to manage the service. 
1. Navigate to All services.
2. Click on Subscriptions. You will be presented with a list of subscriptions.
3. Click on Default Provider Subscription.
4. Click on Resource providers on the left blade.
5. Search for EventHub.
6. Look for the status of Microsoft.EventHub and Microsoft.EventHub.Admin. 
7. If any of them are Unregistered, click on the first provider and click Register. 
   ![Resource providers unregistered](media/event-hubs-rp-install/12-default-subscription-rps-unregistered.png)

8. After a few seconds click on Refresh. You should now see the resource provider with a status of Registered. 

9. Repeat the steps above with the other resource provider, if needed. You should now see Microsoft.EventHub and Microsoft.EventHub.Admin with a status of Registered.
   ![Resource providers registered](media/event-hubs-rp-install/13-default-subscription-registered.png)

10. Navigate to All services.
11. Search for Event Hubs. You should now see Event Hubs. That is your entry point to Event Hubs Admin page. 
   ![Services available - event hubs](media/event-hubs-rp-install/14-all-service-event-hubs.png)
 
## Next steps

You need to create one or more plans, offers, and subscriptions, before users can use Event Hubs. 

- If this is the first time you're offering a service, start with the [Offer services to users](tutorial-offer-services.md) tutorial. Then continue with the next tutorial, [Test a service offering](tutorial-test-offer.md).
- Once you're familiar with the concept of offering a service, create an offer and plan that includes the Event Hubs resource provider. Then create a subscription for your users, or give them the offer information so they can create their own. For reference, you can also follow the series of articles under the [Service, plan, offer, subscription overview](service-plan-offer-subscription-overview.md).


If you need to remove the resource provider, see [Remove the Event Hubs resource provider](event-hubs-rp-remove.md)