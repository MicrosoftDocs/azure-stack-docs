---
title: Add public IP addresses in Azure Stack Hub 
description: Learn how to add public IP addresses to an Azure Stack Hub system.  
author: sethmanheim
ms.topic: how-to
ms.date: 08/12/2024
ms.author: sethm
ms.lastreviewed: 09/10/2019

# Intent: As an Azure Stack operator, I want to add public IP addresses to my Azure Stack network.
# Keyword: add ip addresses azure stack

---

# Add public IP addresses

In this article, we refer to external addresses as public IP addresses. In the context of Azure Stack Hub, a public IP address is an IP address that's accessible from outside of Azure Stack Hub. Whether that external network is public internet routable or is on an intranet and uses private address space doesn't matter for the purposes of this article; the steps are the same.

While you can set up multiple IP pools, you can't select which pool is used to allocate public IP addresses. Azure Stack Hub treats all IP pools as one. IP addresses from any additional pools are allocated only after the IP addresses in existing pools are exhausted. When you create a network resource, you can't choose a specific public IP for assignment, but once assigned it can be made static.

> [!IMPORTANT]
> The steps in this article apply only to systems that were deployed using the partner toolkit version 1809 or later. Systems that were deployed before version 1809 require the top-of-rack (TOR) switch access control lists (ACLs) to be updated to PERMIT the new public VIP pool range. If you are running older switch configurations, work with your OEM to either add the appropriate PERMIT ACLs for the new public IP pool or reconfigure your switch using the latest partner toolkit to prevent the new public IP addresses from being blocked.

## Add a public IP address pool

You can add public IP addresses to your Azure Stack Hub system at any time after the initial deployment of the Azure Stack Hub system. The network size on this subnet for the new public IP pool can range from a minimum of /26 (64 hosts) to a maximum of /22 (1022 hosts). We recommend that you plan for a /24 network.

See [how to view public IP address consumption](azure-stack-viewing-public-ip-address-consumption.md) to determine what the current usage and public IP address availability is on your Azure Stack Hub.

At a high level, the process of adding a new public IP address block to Azure Stack Hub looks like this:

![Screenshot showing adding IP flow.](media/azure-stack-add-ips/flow.svg)

## Obtain the address block from your provider

First, obtain the address block you want to add to Azure Stack Hub. Depending on where you obtain your address block from, consider what the lead time is and manage this against the rate at which you're consuming public IP addresses in Azure Stack Hub.

> [!IMPORTANT]
> Azure Stack Hub accepts any address block that you provide as long as it's a valid address block and doesn't overlap with an existing address range in Azure Stack Hub. Make sure you obtain a valid address block that's routable and doesn't overlap with the external network to which Azure Stack Hub is connected. After you add the range to Azure Stack Hub, you can't remove it without the assistance of Microsoft Support. Only IP pools specified post-deployment can be removed. The IP pool range specified during deployment cannot be modified or removed; a redeployment of the stamp is required if the original IP pool range needs to be changed.

## Add the IP address range to Azure Stack Hub

1. In a browser, go to your administrator portal dashboard. This example uses `https://adminportal.local.azurestack.external`.
1. Sign in to the Azure Stack Hub administrator portal as a cloud operator.
1. On the default dashboard, find the region management list and select the region you want to manage. This example uses **local**.
1. Find the **Resource providers** tile and select the network resource provider.
1. Select **Public IP pools usage**.
1. Select **Add IP pool**.
1. Provide a name for the IP pool. The name you choose helps you easily identify the IP pool. You can't use a special character like `/` in this field. It's a good practice to make the name the same as the address range, but that isn't required.
1. Enter the address block you want to add, in CIDR notation. For example, **192.168.203.0/24**.
1. When you provide a valid CIDR range in the address range (CIDR block) field, the **Start IP address**, **End IP address**, and **Available IP addresses** fields automatically populate. They're read-only so you can't change these fields without modifying the value in the **Address range** field.
1. After you review the info on the blade and confirm that everything looks correct, select **Ok** to commit the change and add the address range to Azure Stack Hub.

## Next steps

[Review scale unit node actions](azure-stack-node-actions.md).
