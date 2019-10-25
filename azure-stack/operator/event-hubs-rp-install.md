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

The first step towards installing Event Hubs on Azure Stack is to download Event Hubs and dependent packages. You have two options depending on your situation or requirements:
1.	Download Event Hubs under a connected scenario.
2.	Download Event Hubs under a disconnected or partially connected scenario. 
Download Event Hubs under a connected scenario
Follow these instructions if your Azure Stack has internet connectivity.
1.	Log into the Azure Stack Admin Portal.
2.	Navigate to Marketplace Management.
3.	On the left blade select Resource providers.
4.	Click + Add from Azure.
5.	Search for Event Hubs using the search bar.
6.	Click on the Event Hubs row on the search results. 
7.	Select the Event Hubs version you wish to install. 

 

8.	Click Download at the bottom of the page. This step usually takes 30 minutes to 2 hours depending on the network latency and existing packages on your Azure Stack.  You will notice that several software packages are downloaded along with Event Hubs. These are:
•	Microsoft AzureStack Add-On RP Windows Server INTERNAL ONLY
•	PowerShell Desired State Configuration




9.	Skip to Install Prerequisites.
Download Event Hubs under a disconnected or partially connected scenario
If you do not have internet connection, the internet connection from you Azure Stack is not reliable, or your requirements prevents you from directly using your Azure Stack to download packages, follow the instructions in Disconnected or partially connected scenario. Make sure to follow all the instructions. At some point, you will download the Maketplace Syndication tool (Powershell module). Using this tool select Event Hubs  to download all the required packages that Event Hubs comprises. 
Install Prerequisites
1.	Once Event Hubs and other required software have been downloaded, Marketplace Management should show all packages with a status of “Downloaded” except for Event Hubs whose status should be “Not Installed”.
 
2.	Click on the Event Hubs  row. The portal should show a blue banner across the top. Click on that blue banner to start the installation of Event Hubs.
 






3.	Click on Install Prerequisites.
 

Wait until the installation of prerequisites succeeds. Make sure the installation is completed (green checkmark next to Install prerequisites) before proceeding to the next step.

 

Upload Event Hubs SSL Certificate
1.	Under Prepare secrets step click on Add certificate.

 

2.	Click on the browse button on the Add a certificate blade.
3.	Select the .pfx certificate file you procured based on Procure SSL Certificate for Azure Stack integrated systems (multi-node). Please see Prerequisites for more information.	

4.	Input the password you provided to create a secure string for  Event Hubs SSL Certificate and click Add.


 


Install resource provider
1.	Click on the Install button in step 3 Install resource provider.


 
2.	You will now see the following page which informs that Event Hubs is being installed.
 

3.	Wait for the installation to complete. This usually takes 1+ hours depending on your Azure Stack type. 

 

4.	Verify that the installation of Event Hubs has succeeded by navigating to Marketplace Management. The status of Event Hubs should read “Installed”.
 

Register Event Hubs
You now need to register the Event Hubs resource provider so that you can use see Event Hubs’ Admin page, which is the blade used to manage the service. 
1.	Navigate to All services.
2.	Click on Subscriptions. You will be presented with a list of subscriptions.
3.	Click on Default Provider Subscription.
4.	Click on Resource providers on the left blade.
5.	Search for EventHub.
6.	Look for the status of Microsoft.EventHub and Microsoft.EventHub.Admin. 



7.	If any of them is Unregistered, click on the first provider and click Register. 
 
8.	After a few seconds click on Refresh. You should now see the resource provider with a status of Registered. 
9.	Repeat the steps above with the other resource provider, if needed. You should now see Microsoft.EventHub and Microsoft.EventHub.Admin with a status of Registered.

 

10.	Navigate to All services.
11.	Search for Event Hubs. You should now see Event Hubs. That is your entry point to Event Hubs Admin page. 
 
## Next steps

You need to create one or more plans, offers, and subscriptions, before users can use Event Hubs. 

- If this is the first time you're offering a service, start with the [Offer services to users](tutorial-offer-services.md) tutorial. Then continue with the next tutorial, [Test a service offering](tutorial-test-offer.md).
- Once you're familiar with the concept of offering a service, create an offer and plan that includes the Event Hubs resource provider. Then create a subscription for your users, or give them the offer information so they can create their own. For reference, you can also follow the series of articles under the [Service, plan, offer, subscription overview](service-plan-offer-subscription-overview.md).


If you need to remove the resource provider, see [Remove the Event Hubs resource provider](event-hubs-rp-remove.md)