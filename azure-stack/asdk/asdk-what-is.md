---
title: What is the Azure Stack Development Kit (ASDK)? | Microsoft Docs
description: Learn about the Azure Stack Development Kit and how it's used to evaluate Azure Stack Hub.
author: justinha
ms.topic: overview
ms.date: 11/27/2019
ms.author: justinha
ms.reviewer: misainat
ms.lastreviewed: 11/27/2019
---

# What is the Azure Stack Development Kit (ASDK)?
[Microsoft Azure Stack Hub integrated systems](../operator/azure-stack-overview.md) range in size from 4-16 nodes, and are jointly supported by a hardware partner and Microsoft. Use Azure Stack Hub integrated systems to enable new scenarios for your production workloads. If you're an Azure Stack Hub operator who manages the integrated systems infrastructure and offers services, see our [operator documentation](/azure-stack/operator).

The ASDK is a single-node deployment of Azure Stack Hub that you can download and use **for free**. All ASDK components are installed in virtual machines (VMs) running on a single host computer that must meet or exceed the [minimum hardware requirements](asdk-deploy-considerations.md#hardware). The ASDK is meant to provide an environment in which you can evaluate Azure Stack Hub and develop modern apps using APIs and tooling consistent with Azure in a *non-production* environment. 

> [!IMPORTANT]
> The ASDK isn't intended to be used or supported in a production environment.

Because all of the ASDK components are deployed to a single host computer, there are limited physical resources available. With ASDK deployments, both the Azure Stack Hub infrastructure VMs and tenant VMs coexist on the same server computer. This configuration isn't intended for scale or performance evaluation.

The ASDK is designed to provide an Azure-consistent hybrid cloud experience for:
- **Administrators** (Azure Stack Hub Operators): The ASDK is a great resource to evaluate and learn about the available Azure Stack Hub services.
- **Developers**: The ASDK can be used to develop hybrid or modern apps on-premises (dev/test environments). This flexibility offers repeatability of development experience before, or alongside, Azure Stack Hub production deployments.

Watch this short video to learn more about the ASDK:

> [!VIDEO https://www.youtube.com/embed/dbVWDrl00MM]


## ASDK and multi-node Azure Stack Hub differences
Single-node ASDK deployments differ from multi-node Azure Stack Hub deployments in a few important ways:

|Description|ASDK|Multi-node Azure Stack Hub|
|-----|-----|-----|
|**Scale**|All components are installed on a single-node server computer.|Can range in size from 4-16 nodes.|
|**Resilience**|Single-node configuration doesn't provide high availability|High availability capabilities are supported.|
|**Networking**|The ASDK host routes all ASDK network traffic. There are no additional switch requirements.|More complex [network routing infrastructure](../operator/azure-stack-network.md#network-infrastructure) in multi-node deployments is necessary including Top-Of-Rack (TOR), Baseboard Management Controller (BMC), and border (datacenter network) switches.|
|**Patch and update process**|To move to a new version of the ASDK, you must redeploy the ASDK on the ASDK host computer.|[Patch and update](../operator/azure-stack-updates.md) process used to update the installed Azure Stack Hub version.|
|**Support**|MSDN Azure Stack forum. Microsoft Customer Service and Support (CSS) support is *not* available for non-production environments.|[MSDN Azure Stack forum](https://social.msdn.microsoft.com/Forums/en-US/home?forum=AzureStack) and full CSS support.|
| | |

## Learn about available services
As an Azure Stack Hub Operator, you need to know which services you can make available to your users. Azure Stack Hub supports a subset of Azure services and the list of supported services will continue to evolve over time.

### Foundational services
By default, Azure Stack Hub includes the following "foundational services" when you deploy the ASDK:
- Compute
- Storage
- Networking
- Key Vault

With these foundational services, you can offer Infrastructure-as-a-Service (IaaS) to your users with minimal configuration.

### Additional services
Currently, the following additional Platform-as-a-Service (PaaS) services are supported:
- App Service
- Azure Functions
- SQL and MySQL databases

> [!NOTE]
> These services require additional configuration before you can make them available to your users and aren't available by default when you install the ASDK.

## Service roadmap
Azure Stack Hub will continue to add support for additional Azure services. To learn about what's coming next with Azure Stack Hub, see the [Azure Stack roadmap](https://azure.microsoft.com/roadmap/?tag=azure-stack). 


## Next steps
To get started evaluating Azure Stack Hub, you need to first [download the latest ASDK](asdk-download.md) and prepare the ASDK host computer. Then you can install the ASDK and sign in to the admin and user portals to start using Azure Stack Hub.