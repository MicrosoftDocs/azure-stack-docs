---
title: Use the administrator portal in Azure Stack Hub 
description: Learn how to use the administrator portal in Azure Stack Hub.
author: sethmanheim
ms.topic: quickstart
ms.date: 01/15/2025
ms.author: sethm
ms.lastreviewed: 06/07/2019

# Intent: As an Azure Stack operator, I want to learn how to use the administrator portal so I can do my day-to-day operations.
# Keyword: administrator portal azure stack

ms.custom: mode-portal
---

# Use the administrator portal in Azure Stack Hub

There are two portals in Azure Stack Hub: the administrator portal and the user portal. As an Azure Stack Hub operator, you use the administrator portal for day-to-day management and operations of Azure Stack Hub.

## Access the administrator portal

To access the administrator portal, browse to the portal URL and sign in using your Azure Stack Hub operator credentials. For an integrated system, the portal URL varies based on the region name and external fully qualified domain name (FQDN) of your Azure Stack Hub deployment; for example, `https://adminportal.<region>.<FQDN>`.

[!INCLUDE [Azure Stack Hub Operator Access Workstation](../includes/operator-note-owa.md)]

![Azure Stack Hub administrator portal](media/azure-stack-manage-portals/admin-portal.png)

The default timezone for all Azure Stack Hub deployments is set to Coordinated Universal Time (UTC).

In the administrator portal, you can do things such as:

* [Register Azure Stack Hub with Azure](azure-stack-registration.md)
* [Populate the marketplace](azure-stack-download-azure-marketplace-item.md)
* [Create plans, offers, and subscriptions for users](service-plan-offer-subscription-overview.md)
* [Monitor health and alerts](azure-stack-monitor-health.md)
* [Manage Azure Stack Hub updates](azure-stack-updates.md)

The **Quickstart tutorial** tile provides links to online documentation for the most common tasks.

Although an operator can create resources such as virtual machines (VMs), virtual networks, and storage accounts in the administrator portal, you should [sign in to the user portal](../user/azure-stack-use-portal.md) to create and test resources.

> [!NOTE]
> The **Create a virtual machine** link in the quickstart tutorial tile describes how to create a VM in the administrator portal, but this procedure is only intended to validate that Azure Stack Hub was deployed successfully.

## Understand subscription behavior

There are three subscriptions created by default in the administrator portal: consumption, default provider, and metering. As an operator, you mostly use the **Default Provider Subscription**. You can't add any other subscriptions and use them in the administrator portal.

Other subscriptions are created by users in the user portal based on the plans and offers you create for them. However, the user portal doesn't provide access to any of the administrative or operational capabilities of the administrator portal.

The administrator and user portals are backed by separate instances of Azure Resource Manager. Because of this Azure Resource Manager separation, subscriptions don't cross portals. For example, if you, as an Azure Stack Hub operator, sign in to the user portal, you can't access the *Default Provider Subscription*. Although you don't have access to any administrative functions, you can create subscriptions for yourself from available public offers. As long as you're signed in to the user portal, you're considered a tenant user.

## Administrator portal tips

### Customize the dashboard

The dashboard contains a set of default tiles. You can select **Edit dashboard** to modify the default dashboard, or select **New dashboard** to add a custom dashboard. You can also add tiles to a dashboard. For example, select **+ Create a resource**, right-click **Offers + Plans**, and then select **Pin to dashboard**.

Sometimes, you might see a blank dashboard in the portal. To recover the dashboard, click **Edit Dashboard**, and then right-click and select **Reset to default state**.

### Quick access to online documentation

To access the Azure Stack Hub operator documentation, use the help and support icon (question mark) in the upper-right corner of the administrator portal. Move your cursor to the icon, and then select **Help + support**.

### Quick access to help and support

Click the help icon (question mark) in the upper-right corner of the administrator portal, then click **Help + support**, and then click **New support request** under **Support**. A page appears in which you can directly open a support ticket with Microsoft Support. See [Where to get support](azure-stack-manage-basics.md#where-to-get-support) to understand when you should go through Microsoft support or through your original equipment manufacturer (OEM) hardware vendor support.

### Quick access to the Azure roadmap

If you select **Help and support** (the question mark) in the upper right corner of the administrator portal, and then select **Azure roadmap**, a new browser tab opens and takes you to the Azure roadmap. By typing **Azure Stack Hub** in the **Products** search box, you can see all Azure Stack Hub roadmap updates.

### Recommended browsers

Similar to Azure, we recommend that you use the most up-to-date browser that's compatible with your operating system. For a list of Azure recommended browsers, see [Recommended browsers](/azure/azure-portal/azure-portal-supported-browsers-devices#recommended-browsers).

## Next steps

[Register Azure Stack Hub with Azure](azure-stack-registration.md) and populate [Azure Stack Hub Marketplace](azure-stack-marketplace.md) with items to offer your users.
