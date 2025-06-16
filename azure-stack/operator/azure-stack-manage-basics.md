---
title: Azure Stack Hub administration basics 
description: Learn the basics of Azure Stack Hub administration.
author: sethmanheim
ms.topic: article
ms.date: 03/06/2025
ms.author: sethm

# Intent: As an Azure Stack operator, I want to learn the Azure Stack administration basics so I can get my users what they need.
# Keyword: azure stack administration basics

---

# Azure Stack Hub administration basics

This article provides an overview of your role as an Azure Stack Hub operator and administrator.

If you use an Azure Stack Hub integrated system, update packages distribute updated versions of Azure Stack Hub. You can import these packages and apply them by using the **Updates** tile in the administrator portal.

## Learn about available services

You need an awareness of which services you can make available to your users. Azure Stack Hub supports a subset of Azure services. The list of supported services continues to evolve.

### Foundational services

By default, Azure Stack Hub includes the following *foundational services* when you deploy Azure Stack Hub:

- Compute
- Storage
- Networking
- Key Vault

With these foundational services, you can offer Infrastructure-as-a-Service (IaaS) to your users with minimal configuration.

### Other services

Currently, we support the following additional Platform-as-a-Service (PaaS) services:

- App Service
- Azure Functions
- SQL and MySQL databases
- Event Hubs
- Kubernetes (in preview)

These services require additional configuration before you can make them available to your users. For more information, see the "Tutorials" and the "How-to guides\Offer services" sections of our Azure Stack Hub operator documentation.

### Service roadmap

Azure Stack Hub continues to add support for Azure services. For the projected roadmap, see the [Azure Stack Hub: An extension of Azure](https://azure.microsoft.com/products/azure-stack/hub/) whitepaper. You can also monitor the [Azure Stack Hub blog posts](https://techcommunity.microsoft.com/t5/azure-stack-blog/bg-p/AzureStackBlog) for new announcements.

## What account should I use?

There are a few account considerations to be aware of when managing Azure Stack Hub. This is particularly true in deployments that use Windows Server Active Directory Federation Services (AD FS) as the identity provider instead of Microsoft Entra ID. The following account considerations apply to Azure Stack Hub integrated systems deployments:

|Account|Microsoft Entra ID|AD FS|
|-----|-----|-----|
|AzureStack\AzureStackAdmin|Can be used to sign in to the Azure Stack Hub administrator portal.<br><br>Access to view and administer Service Fabric rings.|No access to the Azure Stack Hub administrator portal.<br><br>Access to view and administer Service Fabric rings.<br><br>No longer owner of the Default Provider Subscription (DPS).|
|AzureStack\CloudAdmin|Can access and run permitted commands within the privileged endpoint.|Can access and run permitted commands within the privileged endpoint.<br><br>Owner of the Default Provider Subscription (DPS).|
|Microsoft Entra Application Administrator|Used during installation.<br><br>Owner of the Default Provider Subscription (DPS).|Not applicable.|

[!INCLUDE [CloudAdmin backup account warning](../includes/warning-cloud-admin-backup-account.md)]

## What tools do I use to manage?

You can use the [administrator portal](azure-stack-manage-portals.md) or PowerShell to manage Azure Stack Hub. The easiest way to learn the basic concepts is through the portal. If you want to use PowerShell, there are preparation steps. Before you get started, you might want to get familiar with how PowerShell is used on Azure Stack Hub. For more information, see [Get started with PowerShell on Azure Stack Hub](../user/azure-stack-powershell-overview.md).

Azure Stack Hub uses Azure Resource Manager as its underlying deployment, management, and organization mechanism. If you manage Azure Stack Hub and help to support users, you should be familiar with Resource Manager. See the [Getting Started with Azure Resource Manager](https://download.microsoft.com/download/E/A/4/EA4017B5-F2ED-449A-897E-BD92E42479CE/Getting_Started_With_Azure_Resource_Manager_white_paper_EN_US.pdf) paper.

## Your typical responsibilities

Your users want to use services. From their perspective, your main role is to make these services available to them. Decide which services to offer, and make those services available by creating plans, offers, and quotas. For more information, see [Overview of offering services in Azure Stack Hub](service-plan-offer-subscription-overview.md).

You must also add items to [Azure Stack Hub Marketplace](azure-stack-marketplace.md). The easiest way is to [download marketplace items from Azure to Azure Stack Hub](azure-stack-download-azure-marketplace-item.md).

> [!NOTE]
> If you want to test your plans, offers, and services, you can use the [user portal](azure-stack-manage-portals.md), not the administrator portal.

In addition to providing services, you must perform the regular duties of an operator to keep Azure Stack Hub up and running. These duties include the following tasks:

- Add user accounts (for [Microsoft Entra ID](azure-stack-add-new-user-aad.md) deployment or for [AD FS](azure-stack-add-users-adfs.md) deployment).
- [Assign role-based access control (RBAC) roles](azure-stack-manage-permissions.md). This task isn't restricted to admins. 
- [Monitor infrastructure health](azure-stack-monitor-health.md).
- Manage [network](azure-stack-viewing-public-ip-address-consumption.md) and [storage](azure-stack-manage-storage-accounts.md) resources.
- Replace bad hardware. For example, [replace a failed disk](azure-stack-replace-disk.md).

## Operator tasks

Here is a list of daily, weekly, and monthly tasks for an operator:

# [Daily](#tab/daily)

1. Check alerts.
1. Check backup state.
1. Update Defender Signature (disconnected systems).

# [Weekly](#tab/weekly)

1. Check capacity.

# [Monthly](#tab/monthly)

1. Apply monthly update packages (Microsoft and OEM).
1. Manage Azure Stack Hub Marketplace (keep current).
1. Reclaim storage capacity.

# [OnDemand](#tab/ondemand)

1. Secret rotation.
1. Create and update offers, plans, and quotas.
1. Apply hotfix packages.
1. Expand capacity (nodes & IPSpace).
1. Restore storage accounts.
1. Stop system.
1. Diagnostic log collection.

---

## What to tell your users

You must let your users know how to work with services in Azure Stack Hub, how to connect to the environment, and how to subscribe to offers. Aside from any custom documentation that you might want to provide to your users, you can direct users to the [Azure Stack Hub user documentation](../user/index.yml).

### Understand how to work with services in Azure Stack Hub

There's information your users must understand before they use services and build apps in Azure Stack Hub. For example, there are specific PowerShell and API version requirements. Also, there are some feature differences between a service in Azure and the equivalent service in Azure Stack Hub. Make sure that your users review the following articles:

- [Key considerations: Using services or building apps for Azure Stack Hub](../user/azure-stack-considerations.md)
- [Considerations for Virtual Machines in Azure Stack Hub](../user/azure-stack-vm-considerations.md)
- [Storage: differences and considerations](../user/azure-stack-acs-differences.md)

The information in these articles summarizes the differences between a service in Azure and Azure Stack Hub. It supplements the information that's available for an Azure service in the global Azure documentation.

### Connect to Azure Stack Hub as a user

Your users want to know how to [access the user portal](../user/azure-stack-use-portal.md) or how to connect through PowerShell. In an integrated systems environment, the user portal address varies per deployment. You must provide your users with the correct URL.

If you use PowerShell, users might have to register resource providers before they can use services. A resource provider manages a service. For example, the networking resource provider manages resources like virtual networks, network interfaces, and load balancers. They must [install](powershell-install-az-module.md) PowerShell, [download](azure-stack-powershell-download.md) additional modules, and [configure](../user/azure-stack-powershell-configure-user.md) PowerShell (which includes resource provider registration).

### Subscribe to an offer

Before a user can use services, they must [subscribe to an offer](azure-stack-subscribe-plan-provision-vm.md) that you created as an operator.

## Where to get support

> [!NOTE]  
> To find support information for earlier releases of Azure Stack Hub, see [Help and Support for earlier releases Azure Stack Hub](azure-stack-servicing-policy.md).

### Integrated systems

For an integrated system, there's a coordinated escalation and resolution process between Microsoft and our original equipment manufacturer (OEM) hardware partners.

If there's a cloud services issue, support is offered through Microsoft Support. To open a support request, [select the help and support icon (question mark) in the upper-right corner of the administrator portal](azure-stack-help-and-support-overview.md). Then select **Help + support** and then **New support request** under the **Support** section.

If there's an issue with deployment, patch and update, hardware (including field replaceable units), or any hardware-branded software, such as software running on the hardware lifecycle host, contact your OEM hardware vendor first. For anything else, contact Microsoft Support.

## Next steps

[Region management in Azure Stack Hub](azure-stack-region-management.md)
