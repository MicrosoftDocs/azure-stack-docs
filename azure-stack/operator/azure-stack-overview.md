---
title: Azure Stack Hub overview | Microsoft Docs
description: An overview of what Azure Stack Hub is and how it lets you run Azure services in your datacenter.  
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
ms.topic: overview
ms.date: 09/16/2019
ms.author: justinha
ms.reviewer: unknown
ms.custom: 
ms.lastreviewed: 05/14/2019

---
# Azure Stack Hub overviews

Azure Stack Hub is an extension of Azure that provides a way to run apps in an on-premises environment and deliver Azure services in your datacenter. With a consistent cloud platform, organizations can confidently make technology decisions based on business requirements, rather than business decisions based on technology limitations.

## Why use Azure Stack Hub ?

Azure provides a rich platform for developers to build modern apps. However, some cloud-based apps face obstacles like latency, intermittent connectivity, and regulations. Azure and Azure Stack Hub unlock new hybrid cloud use cases for both customer-facing and internal line-of-business apps:

- **Edge and disconnected solutions**. Address latency and connectivity requirements by processing data locally in Azure Stack Hub and then aggregating it in Azure for further analytics, with common app logic across both. You can even deploy Azure Stack Hub disconnected from the internet without connectivity to Azure. Think of factory floors, cruise ships, and mine shafts as examples.

- **Cloud apps that meet varied regulations**. Develop and deploy apps in Azure with full flexibility to deploy on-premises with Azure Stack Hub to meet regulatory or policy requirements. No code changes are needed. App examples include global audit, financial reporting, foreign exchange trading, online gaming, and expense reporting.

- **Cloud app model on-premises**. Use Azure services, containers, serverless, and microservice architectures to update and extend existing apps or build new ones. Use consistent DevOps processes across Azure in the cloud and Azure Stack Hub on-premises to speed up app modernization for core mission-critical apps.

Azure Stack Hub enables these usage scenarios by providing:

- An integrated delivery experience to get up and running quickly with purpose-built Azure Stack Hub integrated systems from trusted hardware partners. After delivery, Azure Stack Hub easily integrates into the datacenter with monitoring through the System Center Operations Manager Management Pack or Nagios extension.

- Flexible identity management using Azure Active Directory (Azure AD) for Azure and Azure Stack Hub hybrid environments, and leveraging Active Directory Federation Services (AD FS) for disconnected deployments.

- An Azure-consistent app development environment to maximize developer productivity and enable common DevOps approaches across hybrid environments.

- Azure services delivery from on-premises using hybrid cloud computing power. Adopt common operational practices across Azure and Azure Stack Hub to deploy and operate Azure IaaS (infrastructure as a service) and PaaS (platform as a service) services using the same administrative experiences and tools as Azure. Microsoft delivers continuous Azure innovation to Azure Stack Hub, including new Azure services, updates to existing services, and additional Azure Marketplace apps and images.

## Azure Stack Hub architecture

Azure Stack Hub integrated systems are comprised in racks of 4-16 servers built by trusted hardware partners and delivered straight to your datacenter. After delivery, a solution provider will work with you to deploy the integrated system and ensure the Azure Stack Hub solution meets your business requirements. Prepare your datacenter by ensuring all required power and cooling, border connectivity, and other required datacenter integration requirements are in place.

> For more information about the Azure Stack Hub datacenter integration experience, see [Azure Stack Hub datacenter integration](azure-stack-customer-journey.md).

Azure Stack Hub is built on industry standard hardware and is managed using the same tools you already use for managing Azure subscriptions. As a result, you can apply consistent DevOps processes whether you're connected to Azure or not.

The Azure Stack Hub architecture lets you provide Azure services at the edge for remote locations or intermittent connectivity, disconnected from the internet. You can create hybrid solutions that process data locally in Azure Stack Hub and then aggregate it in Azure for additional processing and analytics. Finally, because Azure Stack Hub is installed on-premises, you can meet specific regulatory or policy requirements with the flexibility of deploying cloud apps on-premises without changing any code.

## Deployment options

### Production or evaluation environments

Azure Stack Hub is offered in two deployment options to meet your needs, Azure Stack Hub integrated systems for production use and the Azure Stack Hub Development Kit (ASDK) for evaluating Azure Stack Hub:

- **Azure Stack Hub integrated systems**: Azure Stack Hub integrated systems are offered through a partnership of Microsoft and hardware partners, creating a solution that offers cloud-paced innovation and computing management simplicity. Because Azure Stack Hub is offered as an integrated hardware and software system, you have the flexibility and control you need, along with the ability to innovate from the cloud. Azure Stack Hub integrated systems range in size from 4-16 nodes, and are jointly supported by the hardware partner and Microsoft. Use Azure Stack Hub integrated systems to create new scenarios and deploy new solutions for your production workloads.

- **Azure Stack Hub Development Kit (ASDK)**: [The ASDK](../asdk/asdk-what-is.md) is a free, single-node deployment of Azure Stack Hub that you can use to evaluate and learn about Azure Stack Hub. You can also use the ASDK as a developer environment to build apps using the APIs and tooling that's consistent with Azure. However, the ASDK isn't intended to be used as a production environment and has the following limitations as compared to the full integrated systems production deployment:

    - The ASDK can only be associated with a single Azure AD or AD FS identity provider.
    - Because Azure Stack Hub components are deployed on a single host computer, there are limited physical resources available for tenant resources. This configuration isn't intended to scale or for performance evaluation.
    - Networking scenarios are limited because of the single host and NIC deployment requirements.

### Connection models

You can choose to deploy Azure Stack Hub either **connected** to the internet (and to Azure) or **disconnected** from it. This choice defines which options are available for your identity store (Azure AD or AD FS) and billing model (Pay as you use-based billing or capacity-based billing).

> For more information, see the considerations for [connected](azure-stack-connected-deployment.md) and [disconnected](azure-stack-disconnected-deployment.md) deployment models.

### Identity provider 

Azure Stack Hub uses either Azure AD or Active AD FS to provide identities. Azure AD is Microsoft's cloud-based, multi-tenant identity provider. Most hybrid scenarios with internet-connected deployments use Azure AD as the identity store.

For disconnected deployments of Azure Stack Hub, you need to use AD FS. Azure Stack Hub resource providers and other apps work similarly with AD FS or Azure AD. Azure Stack Hub includes its own Active Directory instance and an Active Directory Graph API.

> [!IMPORTANT]
> You can't change the identity provider after deployment. To use a different identity provider, you need to re-deploy Azure Stack Hub. You can learn more about Azure Stack Hub identity considerations at [Overview of identity for Azure Stack Hub](azure-stack-identity-overview.md).

## How is Azure Stack Hub managed?

You can manage Azure Stack Hub with the administrator portal, user portal, or [PowerShell](https://docs.microsoft.com/powershell/azure/azure-stack/overview?view=azurestackps-1.7.1). The Azure Stack Hub portals are each backed by separate instances of Azure Resource Manager. An **Azure Stack Hub Operator** uses the administrator portal to manage Azure Stack Hub, and to do things like create tenant offerings and maintain the health and monitor status of the integrated system. The user portal provides a self-service experience for consumption of cloud resources like virtual machines (VMs), storage accounts, and web apps.

> For more information about managing Azure Stack Hub using the administrator portal, see the use the [Azure Stack Hub administration portal quickstart](azure-stack-manage-portals.md).

As an Azure Stack Hub operator, you can deliver a wide variety of services and apps, like [VMs](azure-stack-tutorial-tenant-vm.md), [web apps](azure-stack-app-service-overview.md), highly available [SQL Server](azure-stack-tutorial-sql.md), and [MySQL Server](azure-stack-tutorial-mysql.md) databases. You can also use [Azure Stack Hub quickstart Azure Resource Manager templates](https://github.com/Azure/AzureStack-QuickStart-Templates) to deploy SharePoint, Exchange, and more.

Using the administrator portal, you can [configure Azure Stack Hub to deliver services](service-plan-offer-subscription-overview.md) to tenants using plans, quotas, offers, and subscriptions. Tenant users can subscribe to multiple offers. Offers can have one or more plans, and plans can have one or more services. Operators also manage capacity and respond to alerts.

When Azure Stack Hub is configured, an **Azure Stack Hub User** consumes services that the operator offers. Users can provision, monitor, and manage services that they've subscribed to, like web apps, storage, and VMs.

> To learn more about managing Azure Stack Hub, including what accounts to use where, typical operator responsibilities, what to tell your users, and how to get help, review [Azure Stack Hub administration basics](azure-stack-manage-basics.md).

## Resource providers

Resource providers are web services that form the foundation for all Azure Stack Hub IaaS and PaaS services. Azure Resource Manager relies on different resource providers to provide access to services. Each resource provider helps you configure and control its respective resources. Service admins can also add new custom resource providers.

### Foundational resource providers

There are three foundational IaaS resource providers:

- **Compute**: The Compute Resource Provider lets Azure Stack Hub tenants to create their own VMs. The Compute Resource Provider includes the ability to create VMs as well as VM extensions. The VM extension service helps provide IaaS capabilities for Windows and Linux VMs. As an example, you can use the Compute Resource Provider to provision a Linux VM and run Bash scripts during deployment to configure the VM.
- **Network Resource Provider**: The Network Resource Provider delivers a series of Software Defined Networking (SDN) and Network Function Virtualization (NFV) features for the private cloud. You can use the Network Resource Provider to create resources like software load balancers, public IPs, network security groups, and virtual networks.
- **Storage Resource Provider**: The Storage Resource Provider delivers four Azure-consistent storage services: [blob](https://docs.microsoft.com/azure/storage/common/storage-introduction#blob-storage), [queue](https://docs.microsoft.com/azure/storage/common/storage-introduction#queue-storage), [table](https://docs.microsoft.com/azure/storage/common/storage-introduction#table-storage), and [Key Vault](https://docs.microsoft.com/azure/key-vault/) account management providing management and auditing of secrets, such as passwords and certificates. The storage resource provider also offers a storage cloud administration service to facilitate service provider administration of Azure-consistent storage services. Azure Storage provides the flexibility to store and retrieve large amounts of unstructured data, like documents and media files with Azure Blobs, and structured NoSQL based data with Azure Tables.

### Optional resource providers

There are three optional PaaS resource providers that you can deploy and use with Azure Stack Hub:

- **App Service**: [Azure App Service on Azure Stack Hub](azure-stack-app-service-overview.md) is a PaaS offering of Microsoft Azure available to Azure Stack Hub. The service enables your internal or external customers to create web, API, and Azure Functions apps for any platform or device.
- **SQL Server**: Use the [SQL Server resource provider](azure-stack-sql-resource-provider.md) to offer SQL databases as a service of Azure Stack Hub. After you install the resource provider and connect it to one or more SQL Server instances, you and your users can create databases for cloud-native apps, websites that use SQL, and other workloads that use SQL.
- **MySQL Server**: Use the [MySQL Server resource provider](azure-stack-mysql-resource-provider-deploy.md) to expose MySQL databases as an Azure Stack Hub service. The MySQL resource provider runs as a service on a Windows Server 2016 Server Core VM.

## Providing high availability

To achieve high availability of a multi-VM production system in Azure, VMs are placed in an [availability set](https://docs.microsoft.com/azure/virtual-machines/windows/manage-availability#configure-multiple-virtual-machines-in-an-availability-set-for-redundancy) that spreads them across multiple fault domains and update domains. In the smaller scale of Azure Stack Hub, a fault domain in an availability set is defined as a single node in the scale unit.  

While the infrastructure of Azure Stack Hub is already resilient to failures, the underlying technology (failover clustering) still incurs some downtime for VMs on an impacted physical server if there's a hardware failure. Azure Stack Hub supports having an availability set with a maximum of three fault domains to be consistent with Azure.

- **Fault domains**: VMs placed in an availability set will be physically isolated from each other by spreading them as evenly as possible over multiple fault domains (Azure Stack Hub nodes). If there's a hardware failure, VMs from the failed fault domain will be restarted in other fault domains. They'll be kept in separate fault domains from the other VMs but in the same availability set if possible. When the hardware comes back online, VMs will be rebalanced to maintain high availability.

- **Update domains**: Update domains are another Azure concept that provides high availability in availability sets. An update domain is a logical group of underlying hardware that can undergo maintenance at the same time. VMs located in the same update domain will be restarted together during planned maintenance. As tenants create VMs within an availability set, the Azure platform automatically distributes VMs across these update domains. In Azure Stack Hub, VMs are live migrated across the other online hosts in the cluster before their underlying host is updated. Since there's no tenant downtime during a host update, the update domain feature on Azure Stack Hub only exists for template compatibility with Azure. VMs in an availability set will show **0** as their update domain number on the portal.

## Role-based access control

You can use role-based access control (RBAC) to grant system access to authorized users, groups, and services by assigning them roles at a subscription, resource group, or individual resource level. Each role defines the access level a user, group, or service has over Microsoft Azure Stack Hub resources.

Azure Stack Hub RBAC has three basic roles that apply to all resource types: Owner, Contributor, and Reader. Owner has full access to all resources including the right to delegate access to others. Contributor can create and manage all types of Azure resources but can't grant access to others. Reader can only view existing resources. The rest of the RBAC roles allow management of specific Azure resources. For instance, the Virtual Machine Contributor role allows creation and management of VMs but doesn't allow management of the virtual network or the subnet that the VM connects to.

> For more information, see [Manage role-based access control](azure-stack-manage-permissions.md).

## Reporting usage data

Azure Stack Hub collects and aggregates usage data across all resource providers, and transmits it to Azure for processing by Azure commerce. The usage data collected on Azure Stack Hub can be viewed via a REST API. There's an Azure-consistent Tenant API as well as Provider and Delegated Provider APIs to get usage data across all tenant subscriptions. This data can be used to integrate with an external tool or service for billing or chargeback. Once usage has been processed by Azure commerce, it can be viewed in the Azure billing portal.

> Learn more about [reporting Azure Stack Hub usage data to Azure](azure-stack-usage-reporting.md).

## Next steps

[Compare Azure Stack Hub and global Azure](compare-azure-azure-stack.md).

[Administration basics](azure-stack-manage-basics.md).

[Quickstart: use the Azure Stack Hub administration portal](azure-stack-manage-portals.md).
