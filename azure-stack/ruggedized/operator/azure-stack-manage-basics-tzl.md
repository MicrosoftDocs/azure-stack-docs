---
title: Azure Stack Hub administration basics - Ruggedized
titleSuffix: Azure Stack Hub
description: Learn the basics to Azure Stack Hub administration.
author: sethmanheim
ms.topic: article
ms.date: 06/16/2020
ms.author: sethm
ms.reviewer: thoroet
ms.lastreviewed: 06/16/2020

# Intent: As an Azure Stack operator, I want to learn the basics to Azure Stack Hub administration.
# Keyword: azure stack hub administration

---

# Azure Stack Hub administration basics - Ruggedized

If you're new to Azure Stack Hub administration, there are several things you need to know. This article provides an overview of your role as an Azure Stack Hub operator and what you need to tell your users to help them become productive.

## Understand the builds

If you're using an Azure Stack Hub integrated system, updated versions of Azure Stack Hub are distributed via update packages. You can import these packages and apply them by using the **Updates** tile in the administrator portal.

## Learn about available services

Be aware of the services you can make available to your users. Azure Stack Hub supports a subset of Azure services. The list of supported services will continue to evolve.

### Foundational services

By default, Azure Stack Hub includes the following foundational services when you deploy Azure Stack Hub:

- Compute
- Storage
- Networking
- Key Vault

With these foundational services, you can offer infrastructure-as-a-service (IaaS) to your users with minimal configuration.

### Additional services

We support the following additional platform-as-a-service (PaaS) services:

- App Service
- Azure Functions
- SQL and MySQL databases
- Kubernetes
- Event Hub

These services require additional configuration before you can make them available to your users. For more information, see **Tutorials** and **How-to guides** > **Offer services** in our [Azure Stack Hub operator documentation](../../operator/index.yml).

### Service roadmap

Azure Stack Hub will continue to add support for Azure services. For the projected roadmap, see the [Azure Stack Hub: An extension of Azure](https://azure.microsoft.com/resources/videos/azure-friday-azure-stack-an-extension-of-azure/) whitepaper. You can also monitor the [Azure Stack Hub blog posts](https://azure.microsoft.com/blog/tag/azure-stack-technical-preview) for new announcements.

## What account should I use?

There are a few account considerations to be aware of when managing Azure Stack Hub. This is especially true in deployments using Windows Server Active Directory Federation Services (AD FS) as the identity provider instead of Azure Active Directory (Azure AD).

| **Account** | **Azure** | **AD FS** |
|---|---|---|
| Local administrator (.\Administrator) |   |
| Azure AD global administrator | Used during installation. <br> Owner of the default provider | Not applicable. |
| Account for Extended Storage|   |   |
||

## What tools do I use to manage?

You can use the [administrator portal](../../operator/azure-stack-manage-portals.md) or PowerShell to manage Azure Stack Hub. The easiest way to learn the basic concepts is through the portal. If you want to use PowerShell, there are preparation steps. Before you get started, you might want to get familiar with how PowerShell is used on Azure Stack Hub. For more information, see [Get started with PowerShell on Azure Stack Hub](../../user/azure-stack-powershell-overview.md).

Azure Stack Hub uses Azure Resource Manager as its underlying deployment, management, and organization mechanism. If you're going to manage Azure Stack Hub and help support users, you should learn about Resource Manager. See the [Getting Started with Azure Resource Manager](https://download.microsoft.com/download/E/A/4/EA4017B5-F2ED-449A-897E-BD92E42479CE/Getting_Started_With_Azure_Resource_Manager_white_paper_EN_US.pdf) whitepaper.

## Your typical responsibilities

Your users want to use services. From their perspective, your main role is to make these services available to them. Decide which services to offer and make those services available by creating plans, offers, and quotas. For more information, see [Overview of offering services in Azure Stack Hub](../../operator/service-plan-offer-subscription-overview.md).

You'll also need to add items to [Azure Stack Hub Marketplace](../../operator/azure-stack-marketplace.md). The easiest way is to [download marketplace items from Azure to Azure Stack Hub](../../operator/azure-stack-download-azure-marketplace-item.md).

If you want to test your plans, offers, and services, you can use the [user portal](../../operator/azure-stack-manage-portals.md); not the administrator portal.

In addition to providing services, you must do the regular duties of an operator to keep Azure Stack Hub up and running. These duties include the following tasks:

- Add user accounts for [Azure AD](../../operator/azure-stack-add-new-user-aad.md) deployment.
- [Set access permissions using role-based access control](../../operator/azure-stack-manage-permissions.md). (This task isn't restricted to admins.)
- [Monitor infrastructure health](../../operator/azure-stack-monitor-health.md).
- Manage [network](../../operator/azure-stack-viewing-public-ip-address-consumption.md) and [storage](../../operator/azure-stack-manage-storage-accounts.md) resources.
- [Start and stop Azure Stack Hub](../../operator/azure-stack-start-and-stop.md).
- [Operating the extended storage](../../user/azure-stack-network-howto-extend-datacenter.md).
- [Manage Event Hub](../../operator/event-hubs-rp-overview.md?bc=/azure-stack/breadcrumb/toc.json&branch=release-tzl&toc=/azure-stack/tdc/toc.json).
- [Manage App Service](../../operator/azure-stack-app-service-overview.md?bc=/azure-stack/breadcrumb/toc.json&branch=release-tzl&toc=/azure-stack/tdc/toc.json).
- Replace bad hardware. Here is the list of [replaceable parts](../../operator/azure-stack-replace-component.md).
- [Get support](../../operator/azure-stack-help-and-support-overview.md?bc=/azure-stack/breadcrumb/toc.json&branch=release-tzl&toc=/azure-stack/tdc/toc.json).

## Operator tasks

Here is a list of daily, weekly, and monthly tasks for an operator:

# [Daily](#tab/daily)

1. Check alerts.
2. Check backup state.
3. Update Defender Signature (disconnected systems).
4. Check Isilon system health and events in OneFS.
5. Check Isilon capacity.

# [Weekly](#tab/weekly)

1. Check capacity.
2. Run `isi status –verbose` in Avocent connection.

# [Monthly](#tab/monthly)

1. Apply monthly update packages (Microsoft & OEM).
2. Validate backup using ASDK.
3. Manage Azure Stack Hub Marketplace (keep current).
4. Update switch firmware & Avocent.
5. Reclaim storage capacity.

# [OnDemand](#tab/ondemand)

1. Secret rotation.
2. Create and update offers, plans, and quotas.
3. Apply hotfix packages.
4. Apply hotfix packages.
5. Expand capacity (nodes & IPSpace).
6. Run `isi status –verbose` in Avocent connection.
7. Restore storage accounts.
8. Stop system.
9. Diagnostic log collection.

---

## What to tell your users

You'll need to let your users know how to work with services in Azure Stack Hub, how to connect to the environment, and how to subscribe to offers. Besides any custom documentation that you may want to provide your users, you can direct users to [Azure Stack Hub User Documentation](../../user/index.yml).

### Understand how to work with services in Azure Stack Hub

There's information your users must understand before they use services and build apps in Azure Stack Hub. For example, there are specific PowerShell and API version requirements. Also, there are some feature deltas between a service in Azure and the equivalent service in Azure Stack Hub. Make sure that your users review the following articles:

- [Differences between Azure Stack Hub and Azure when using services and building apps](../../user/azure-stack-considerations.md)
- [Azure Stack Hub VM features](../../user/azure-stack-vm-considerations.md)
- [Azure Stack Hub storage: Differences and considerations](../../user/azure-stack-acs-differences.md)

The information in these articles summarizes the differences between a service in Azure and Azure Stack Hub. It supplements the information that's available for an Azure service in the global Azure documentation.

### Connect to Azure Stack Hub as a user

Your users will want to know how to [access the user portal](../../user/azure-stack-use-portal.md) or how to connect through PowerShell. In an integrated systems environment, the user portal address varies per deployment. You'll need to provide your users with the correct URL.

If using PowerShell, users may have to register resource providers before they can use services. A resource provider manages a service. For example, the networking resource provider manages resources like virtual networks, network interfaces, and load balancers. They must [install](../../operator/azure-stack-powershell-install.md) PowerShell, [download](../../operator/azure-stack-powershell-download.md) additional modules,
and [configure](../../user/azure-stack-powershell-configure-user.md) PowerShell (which includes resource provider registration).

### Subscribe to an offer

Before a user can use services, they must [subscribe to an offer](../../operator/azure-stack-subscribe-plan-provision-vm.md) that you've created as an operator.

## Where to get support

To find support information for earlier releases of Azure Stack Hub, see [Azure Stack Hub servicing policy](../../operator/azure-stack-servicing-policy.md).

For an integrated system, there's a coordinated escalation and resolution process between Microsoft and our original equipment manufacturer (OEM) hardware partners.

If there's a cloud services issue, support is offered through Microsoft Customer Support Services (CSS). To open a support request, select the help and support icon (question mark) in the upper-right corner of the administrator portal. Then select **Help + support** and then **New support request** under the **Support** section.

If there's an issue with deployment, patch and update, hardware (including field replaceable units), or any hardware-branded software—like software running on the hardware lifecycle host—contact your OEM hardware vendor first.

For anything else, contact Microsoft CSS.

## Next steps

- [Region management in Azure Stack Hub](../../operator/azure-stack-region-management.md)
