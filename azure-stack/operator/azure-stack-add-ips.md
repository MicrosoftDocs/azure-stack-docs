---
title: Add public IP addresses in Azure Stack Hub | Microsoft Docs
description: Learn how to add public IP addresses to Azure Stack Hub.  
services: azure-stack
documentationcenter: ''
author: justinha
manager: femila
editor: ''

ms.assetid: 
ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 09/10/2019
ms.author: justinha
ms.reviewer: scottnap
ms.lastreviewed: 09/10/2019

---
# Add public IP addresses

In this article, we refer to external addresses as public IP addresses. In the context of Azure Stack Hub, a public IP address is an IP address that's accessible from outside of Azure Stack Hub. Whether that external network is public internet routable or is on an intranet and uses private address space doesn't matter for the purposes of this article—the steps are the same.

> [!IMPORTANT]
> The steps in this article apply only to systems that were deployed using the partner toolkit version 1809 or later. Systems that were deployed before version 1809 require the top-of-rack (TOR) switch access control lists (ACLs) to be updated to PERMIT the new public VIP pool range. If you are running older switch configurations, work with your OEM to either add the appropriate PERMIT ACLs for the new public IP pool or reconfigure your switch using the latest partner toolkit to prevent the new public IP addresses from being blocked.

## Add a public IP address pool
You can add public IP addresses to your Azure Stack Hub system at any time after the initial deployment of the Azure Stack Hub system. Check out how to [View public IP address consumption](azure-stack-viewing-public-ip-address-consumption.md) to see what the current usage and public IP address availability is on your Azure Stack Hub.

At a high level, the process of adding a new public IP address block to Azure Stack Hub looks like this:

 ![Add IP flow](media/azure-stack-add-ips/flow.PNG)

## Obtain the address block from your provider
The first thing you'll need to do is to obtain the address block you want to add to Azure Stack Hub. Depending on where you obtain your address block from, consider what the lead time is and manage this against the rate at which you're consuming public IP addresses in Azure Stack Hub.

> [!IMPORTANT]
> Azure Stack Hub will accept any address block that you provide if it's a valid address block and doesn't overlap with an existing address range in Azure Stack Hub. Please make sure you obtain a valid address block that's routable and non-overlapping with the external network to which Azure Stack Hub is connected. After you add the range to Azure Stack Hub, you can't remove it.

## Add the IP address range to Azure Stack Hub

1. In a browser, go to your administrator portal dashboard. For this example, we'll use https://adminportal.local.azurestack.external.
2. Sign in to the Azure Stack Hub administrator portal as a cloud operator.
3. On the default dashboard, find the Region management list and select the region you want to manage. For this example, we use local.
4. Find the Resource providers tile and click on the network resource provider.
5. Click on the Public IP pools usage tile.
6. Click on the Add IP pool button.
7. Provide a name for the IP pool. The name you choose helps you easily identify the IP pool. It's a good practice to make the name the same as the address range, but that isn't required.
8. Enter the address block you want to add in CIDR notation. For example: 192.168.203.0/24
9. When you provide a valid CIDR range in the Address range (CIDR block) field the Start IP address, End IP address and Available IP addresses fields will automatically populate. They're read-only and automatically generated so you can't change these fields without modifying the value in the Address range field.
10. After you review the info on the blade and confirm that everything looks correct, select **Ok** to commit the change and add the address range to Azure Stack Hub.


## Next steps 
[Review scale unit node actions](azure-stack-node-actions.md).
