---
title: Overview of capacity planning for Azure Stack Hub | Microsoft Docs
description: Learn about capacity planning for Azure Stack Hub deployments.
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
ms.date: 10/14/2020
ms.author: justinha
ms.reviewer: prchint
ms.lastreviewed: 10/14/2020
---

# Overview of Azure Stack Hub capacity planning

When you're evaluating an Azure Stack Hub solution, consider the hardware configuration choices that have a direct impact on the overall capacity of the Azure Stack Hub cloud. 

For example, you need to make choices regarding the CPU, memory density, storage configuration, and overall solution scale or number of servers. Unlike a traditional virtualization solution, the simple arithmetic of these components to determine usable capacity doesn't apply. Azure Stack Hub is built to host the infrastructure or management components within the solution itself. Also, some of the solution's capacity is reserved to support resiliency, the updating of the solution's software in a way to minimize disruption of tenant workloads. 

> [!IMPORTANT]
> This capacity planning information and the [Azure Stack Hub Capacity Planner](https://aka.ms/azstackcapacityplanner) are a starting point for Azure Stack Hub planning and configuration decisions. This information isn't intended to serve as a substitute for your own investigation and analysis. Microsoft makes no representations or warranties, express or implied, with respect to the information provided here.
 
An Azure Stack Hub solution is built as a hyperconverged cluster of compute and storage. The convergence allows for the sharing of the hardware capacity in the cluster, referred to as a *scale unit*. In Azure Stack Hub, a scale unit provides the availability and scalability of resources. A scale unit consists of a set of Azure Stack Hub servers, referred to as *hosts*. The infrastructure software is hosted within a set of virtual machines (VMs), and shares the same physical servers as the tenant VMs. All Azure Stack Hub VMs are then managed by the scale unit's Windows Server clustering technologies and individual Hyper-V instances. 

The scale unit simplifies the acquisition and management Azure Stack Hub. The scale unit also allows for the movement and scalability of all services (tenant and infrastructure) across Azure Stack Hub. 

The following topics provide more details about each component:

- [Azure Stack Hub compute](../operator/azure-stack-capacity-planning-compute.md?toc=/azure-stack/tdc/toc.json&bc=/azure-stack/breadcrumb/toc.json)
- [Azure Stack Hub storage](../operator/azure-stack-capacity-planning-storage.md?toc=/azure-stack/tdc/toc.json&bc=/azure-stack/breadcrumb/toc.json)
- [Azure Stack Hub Capacity Planner](../operator/azure-stack-app-service-capacity-planning.md?toc=/azure-stack/tdc/toc.json&bc=/azure-stack/breadcrumb/toc.json)

## Azure Stack Hub ruggedized high and low models

The following table lists specifications for high and low models of the Azure Stack Hub ruggedized.

| Component               | Specification |
|-------------------------|---------------|
| CPU                     |High: 284 vCPU cores<br>Low: 184 vCPU cores  |
| Memory                  |High: 1,037 GB<br>Low: 547 GB                |
| Storage                 |High: 34.2 TB<br>Low: 15.4 TB                |
| Acceleration            |N/A                                          |
| Size/Weight             |Compute: 31.5" L x 23.8" W x 15.33" H<br>Weight 120 lbs. (qty 2)<br>Networking: 31.5" L x 23.8" W x 17.12" H<br>Weight 145 lbs. (qty 1)              |
| Optional configurations |Pre-Heater<br>High or Low configurations     |

## Next steps

[Azure Stack Hub compute](../operator/azure-stack-capacity-planning-compute.md?toc=/azure-stack/tdc/toc.json&bc=/azure-stack/breadcrumb/toc.json)
[Azure Stack Hub storage](../operator/azure-stack-capacity-planning-storage.md?toc=/azure-stack/tdc/toc.json&bc=/azure-stack/breadcrumb/toc.json)
[Azure Stack Hub Capacity Planner](../operator/azure-stack-app-service-capacity-planning.md?toc=/azure-stack/tdc/toc.json&bc=/azure-stack/breadcrumb/toc.json)
