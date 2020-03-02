---
title: Azure Stack Hub administration basics
titleSuffix: Azure Stack Hub
description: Learn the basics to Azure Stack Hub administration.
author: nicoalba
ms.topic: article
ms.date: 03/02/2020
ms.author: v-nialba
ms.reviewer:
ms.lastreviewed:

# Intent: As an Azure Stack operator, I want to learn the basics to Azure Stack Hub administration.
# Keyword: azure stack hub administration

---

# Azure Stack Hub administration basics

If you're new to Azure Stack Hub administration, there are several things you need to know. This article provides an overview of your role as an Azure Stack Hub operator and what you need to tell your users to help them become productive.

## Understand the builds

### Integrated systems

If you're using an Azure Stack Hub integrated system, update packages distribute updated versions of Azure Stack Hub. You can import these packages and apply them by using the **Updates** tile in the administrator portal.

## Learn about available services

You'll need an awareness of which services you can make available to your users. Azure Stack Hub supports a subset of Azure services. The list of supported services will continue to evolve.

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
- IoT Hub
- Event Hub

These services require additional configuration before you can make them available to your users. For more information, see the "Tutorials" and the "How-to guides>Offer services" sections of our [Azure Stack Hub operator documentation](https://docs.microsoft.com/azure-stack/operator/).

### Service roadmap

Azure Stack Hub will continue to add support for Azure services. For the projected roadmap, see the [Azure Stack Hub: An extension of Azure](https://go.microsoft.com/fwlink/?LinkId=842846&clcid=0x409) whitepaper. You can also monitor the [Azure Stack Hub blog posts](https://azure.microsoft.com/blog/tag/azure-stack-technical-preview) for new announcements.

## What account should I use?

There are a few account considerations to be aware of when managing Azure Stack Hub. This is especially true in deployments using Windows Server Active Directory Federation Services (AD FS) as the identity provider instead of Azure Active Directory (Azure AD).

| **Account** | **Azure** | **AD FS** |
|---|---|---|
| Local Administrator\Administrator) |   |
| Azure AD Global Administrator | Used during installation. <br> Owner of the Default Provider | Not applicable. |
| Account for Extended Storage|   |   |
||

## What tools do I use to manage?

You can use the [administrator portal](https://review.docs.microsoft.com/en-us/azure-stack/operator/azure-stack-manage-portals?view=azs-2002) or PowerShell to manage Azure Stack Hub. The easiest way to learn the basic concepts is through the portal. If you want to use PowerShell, there are preparation steps. Before you get started, you might want to get familiar with how PowerShell is used on Azure Stack Hub. For more information, see [Get started with PowerShell on Azure Stack
Hub](https://review.docs.microsoft.com/en-us/azure-stack/user/azure-stack-powershell-overview?view=azs-2002).

Azure Stack Hub uses Azure Resource Manager as its underlying deployment, management, and organization mechanism. If you're going to manage Azure Stack Hub and help support users, you should learn about Resource Manager. See the [Getting Started with Azure Resource Manager](https://download.microsoft.com/download/E/A/4/EA4017B5-F2ED-449A-897E-BD92E42479CE/Getting_Started_With_Azure_Resource_Manager_white_paper_EN_US.pdf) whitepaper.

## Your typical responsibilities

Your users want to use services. From their perspective, your main role is to make these services available to them. Decide which services to offer and make those services available by creating plans, offers, and quotas. For more information, see [Overview of offering services in Azure Stack Hub](https://review.docs.microsoft.com/en-us/azure-stack/operator/service-plan-offer-subscription-overview?view=azs-2002).

You'll also need to add items to [Azure Stack Hub Marketplace](https://review.docs.microsoft.com/en-us/azure-stack/operator/azure-stack-marketplace?view=azs-2002). The easiest way is to [download marketplace items from Azure to Azure Stack Hub](https://review.docs.microsoft.com/en-us/azure-stack/operator/azure-stack-download-azure-marketplace-item?view=azs-2002).

If you want to test your plans, offers, and services, you can use the [user portal](https://review.docs.microsoft.com/en-us/azure-stack/operator/azure-stack-manage-portals?view=azs-2002); not the administrator portal.

In addition to providing services, you must do the regular duties of an operator to keep Azure Stack Hub up and running. These duties include the following tasks:

- Add user accounts for [Azure AD](https://review.docs.microsoft.com/en-us/azure-stack/operator/azure-stack-add-new-user-aad?view=azs-2002) deployment.
- [Assign role-based access control (RBAC) roles](https://review.docs.microsoft.com/en-us/azure-stack/operator/azure-stack-manage-permissions?view=azs-2002) (This task isn't restricted to admins.)
- [Monitor infrastructure health](https://review.docs.microsoft.com/en-us/azure-stack/operator/azure-stack-monitor-health?view=azs-2002).
- Manage [network](https://review.docs.microsoft.com/en-us/azure-stack/operator/azure-stack-viewing-public-ip-address-consumption?view=azs-2002) and [storage](https://review.docs.microsoft.com/en-us/azure-stack/operator/azure-stack-manage-storage-accounts?view=azs-2002) resources.
- [Start and stop Azure Stack Hub](https://review.docs.microsoft.com/en-us/azure-stack/operator/azure-stack-start-and-stop?view=azs-2002&branch=release-tzl).
- [Manage and update Isilon](https://review.docs.microsoft.com/en-us/azure-stack/tdc/extended-storage-operator-guide?view=azs-2002&branch=release-tzl).
- [Manage IoT Hub](https://review.docs.microsoft.com/en-us/azure-stack/operator/iot-hub-rp-overview?toc=%2Fazure-stack%2Ftdc%2Ftoc.json&.bc=%2Fazure-stack%2Fbreadcrumb%2Ftoc.json&view=azs-2002&branch=release-tzl)
- [Manage Event Hub](https://review.docs.microsoft.com/en-us/azure-stack/operator/event-hubs-rp-overview?toc=%2Fazure-stack%2Ftdc%2Ftoc.json&bc=%2Fazure-stack%2Fbreadcrumb%2Ftoc.json&view=azs-2002&branch=release-tzl).
- [Manage App Service](https://review.docs.microsoft.com/en-us/azure-stack/operator/azure-stack-app-service-overview?toc=%2Fazure-stack%2Ftdc%2Ftoc.json&bc=%2Fazure-stack%2Fbreadcrumb%2Ftoc.json&view=azs-2002&branch=release-tzl).
- Replace bad hardware. Here is the list of [replaceable parts](https://review.docs.microsoft.com/en-us/azure-stack/tdc/cru-replaceable-parts?view=azs-2002&branch=release-tzl).
- [Get Support](https://review.docs.microsoft.com/en-us/azure-stack/operator/azure-stack-help-and-support-overview?toc=%2Fazure-stack%2Ftdc%2Ftoc.json&bc=%2Fazure-stack%2Fbreadcrumb%2Ftoc.json&view=azs-2002&branch=release-tzl).

Here is the list of tasks for an operator on the bases of daily, weekly, and
monthly schedule:

## Operator tasks

# [Daily](#tab/daily)

1. Check alerts.
2. Check backup state.
3. Update Defender Signature (disconnected systems).
4. Check Isilon system health and events in OneFS.
5. Check Isilon capacity.

# [Weekly](#tab/weekly)

1. Check capacity.
2. Run isi `status –verbose` in Avocent connection.

# [Monthly](#tab/monthly)

1. Apply monthly ipdate packages (Microsoft & OEM).
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

## What to tell your users

You'll need to let your users know how to work with services in Azure Stack Hub, how to connect to the environment, and how to subscribe to offers. Besides any custom documentation that you may want to provide your users, you can direct users to [Azure Stack Hub User Documentation](https://review.docs.microsoft.com/en-us/azure-stack/user/).

### Understand how to work with services in Azure Stack Hub

There's information your users must understand before they use services and build apps in Azure Stack Hub. For example, there are specific PowerShell and API version requirements. Also, there are some feature deltas between a service in Azure and the equivalent service in Azure Stack Hub. Make sure that your users review the following articles:

- [Key considerations: Using services or building apps for Azure Stack Hub](https://review.docs.microsoft.com/en-us/azure-stack/user/azure-stack-considerations?view=azs-2002)

- [Considerations for Virtual Machines in Azure Stack Hub](https://review.docs.microsoft.com/en-us/azure-stack/user/azure-stack-vm-considerations?view=azs-2002)

- [Storage: differences and considerations](https://review.docs.microsoft.com/en-us/azure-stack/user/azure-stack-acs-differences?view=azs-2002)

The information in these articles summarizes the differences between a service in Azure and Azure Stack Hub. It supplements the information that's available for an Azure service in the global Azure documentation.

### Connect to Azure Stack Hub as a user

Your users will want to know how to [access the user portal](https://review.docs.microsoft.com/en-us/azure-stack/user/azure-stack-use-portal?view=azs-2002) or how to connect through PowerShell. In an integrated systems environment, the user portal address varies per deployment. You'll need to provide your users with the correct URL.

If using PowerShell, users may have to register resource providers before they can use services. A resource provider manages a service. For example, the networking resource provider manages resources like virtual networks, network interfaces, and load balancers. They must [install](https://review.docs.microsoft.com/en-us/azure-stack/operator/azure-stack-powershell-install?view=azs-2002) PowerShell, [download](https://review.docs.microsoft.com/en-us/azure-stack/operator/azure-stack-powershell-download?view=azs-2002) additional modules,
and [configure](https://review.docs.microsoft.com/en-us/azure-stack/user/azure-stack-powershell-configure-user?view=azs-2002) PowerShell (which includes resource provider registration).

### Subscribe to an offer

Before a user can use services, they must [subscribe to an offer](https://review.docs.microsoft.com/en-us/azure-stack/operator/azure-stack-subscribe-plan-provision-vm?view=azs-2002) that you've created as an operator.

## Where to get support

To find support information for earlier releases of Azure Stack Hub (pre-1905), see [Help and Support for earlier releases Azure Stack Hub (pre-1905)](https://review.docs.microsoft.com/en-us/azure-stack/operator/azure-stack-servicing-policy?view=azs-2002).

For an integrated system, there's a coordinated escalation and resolution process between Microsoft and our original equipment manufacturer (OEM) hardware partners.

If there's a cloud services issue, support is offered through Microsoft Customer Support Services (CSS). To open a support request, select the Help and support icon (question mark) in the upper-right corner of the administrator portal, select **Help + support**, and then select **New support request** under the **Support** section.

If there's an issue with deployment, patch and update, hardware (including field replaceable units), or any hardware-branded software, like software running on the hardware lifecycle host, contact your OEM hardware vendor first.

For anything else, contact Microsoft CSS.

## Next steps

- [Region management in Azure Stack Hub](https://review.docs.microsoft.com/en-us/azure-stack/operator/azure-stack-region-management?view=azs-2002)
