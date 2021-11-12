---
title: What is the Azure Stack Development Kit (ASDK)? | Microsoft Docs
description: Learn about the Azure Stack Development Kit and how it's used to evaluate Azure Stack Hub.
author: PatAltimore
ms.topic: overview
ms.date: 10/04/2021
ms.author: patricka
ms.reviewer: misainat
ms.lastreviewed: 11/27/2019
ms.custom: contperf-fy22q2

# Intent: As a potential ASDK user, I want to know what the ASDK is.
# Keyword: what is the asdk

---


# What is the Azure Stack Development Kit (ASDK)?

The ASDK is a single-node deployment of Azure Stack Hub that you can download and use for free. All ASDK components are installed in virtual machines (VMs) running on a single host computer that must meet or exceed the [minimum hardware requirements](asdk-deploy-considerations.md#hardware). The ASDK is meant to provide an environment in which you can evaluate Azure Stack Hub and develop modern apps using APIs and tooling consistent with Azure in a non-production environment.

> [!IMPORTANT]
> The ASDK is not intended to be used, and is not supported, in a production environment.

Because all of the ASDK components are deployed to a single host computer, there are limited physical resources available. With ASDK deployments, both the Azure Stack Hub infrastructure VMs and tenant VMs coexist on the same server computer. This configuration isn't intended for scale or performance evaluation.

For production workloads, use [Microsoft Azure Stack Hub integrated systems](../operator/azure-stack-overview.md). Microsoft Azure Stack Hub integrated systems range in size from 4-16 nodes, and are jointly supported by a hardware partner and Microsoft. If you're an Azure Stack Hub operator who manages the integrated systems infrastructure and offers services, see our [operator documentation](../operator/index.yml).

The ASDK is designed to provide an Azure-consistent hybrid cloud experience for:

- **Administrators** (Azure Stack Hub operators): The ASDK is a resource to help evaluate and learn about the available Azure Stack Hub services.
- **Developers**: The ASDK can be used to develop hybrid or modern apps on-premises (dev/test environments). This flexibility offers repeatability of the development experience before, or alongside, Azure Stack Hub production deployments.

Watch this short video to learn more about the ASDK:

> [!VIDEO https://www.youtube.com/embed/dbVWDrl00MM]

## ASDK and multi-node Azure Stack Hub differences

Single-node ASDK deployments differ from multi-node Azure Stack Hub deployments in a few important ways:

|Description|ASDK|Multi-node Azure Stack Hub|
|-----|-----|-----|
|**Scale**|All components are installed on a single-node server computer.|Can range in size from 4-16 nodes.|
|**Resilience**|Single-node configuration does not provide high availability.|High availability capabilities are supported.|
|**Networking**|The ASDK host routes all ASDK network traffic. There are no additional switch requirements.|More complex [network routing infrastructure](../operator/azure-stack-network.md#network-infrastructure) in multi-node deployments is necessary including Top-Of-Rack (TOR), Baseboard Management Controller (BMC), and border (datacenter network) switches.|
| **GPU support** | Not available. | [Support for GPU virtual machines on Azure Stack Hub](../user/gpu-vms-about.md) |
| **IoT Hub** | Not available. | [Available as a private preview](../operator/iot-hub-rp-overview.md). |
| **Event Hubs** | Not available. | [Event Hubs on Azure Stack Hub](../operator/event-hubs-rp-overview.md) |
|**Patch and update process**|To move to a new version of the ASDK, you must redeploy the ASDK on the ASDK host computer.|[Patch and update](../operator/azure-stack-updates.md) process used to update the installed Azure Stack Hub version.|
|**Support**|MSDN Azure Stack forum. Microsoft Support is not available for non-production environments.|[MSDN Azure Stack forum](https://social.msdn.microsoft.com/Forums/en-US/home?forum=AzureStack) and full support.|
| | |

## Learn about available services

As an Azure Stack Hub operator, you need to know which services you can make available to your users. Azure Stack Hub supports a subset of Azure services, and the list of supported services continues to evolve.

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
> These services require additional configuration before you can make them available to your users and are not available by default when you install the ASDK.

Azure Stack Hub continues to add support for additional Azure services.

## Next steps

To get started evaluating Azure Stack Hub, first [download the latest ASDK](asdk-download.md) and prepare the ASDK host computer. Then you can install the ASDK and sign in to the admin and user portals to start using Azure Stack Hub.
