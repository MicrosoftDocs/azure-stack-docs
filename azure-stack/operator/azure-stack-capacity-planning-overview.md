---
title: Overview of capacity planning for Azure Stack | Microsoft Docs
description: Learn about capacity planning for Azure Stack deployments.
services: azure-stack
documentationcenter: ''
author: prchint
manager: femila
editor: ''

ms.assetid:
ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 05/31/2019
ms.author: justinha
ms.reviewer: prchint
ms.lastreviewed: 05/31/2019
---

# Overview of Azure Stack capacity planning

When you're evaluating an Azure Stack solution, consider the hardware configuration choices that have a direct impact on the overall capacity of the Azure Stack cloud. 

For example, you need to make choices regarding the CPU, memory density, storage configuration, and overall solution scale or number of servers. Unlike a traditional virtualization solution, the simple arithmetic of these components to determine usable capacity doesn't apply. Azure Stack is built to host the infrastructure or management components within the solution itself. Also, some of the solution's capacity is reserved to support resiliency, the updating of the solution's software in a way to minimize disruption of tenant workloads. 

> [!IMPORTANT]
> This capacity planning information and the [Azure Stack Capacity Planner](https://aka.ms/azstackcapacityplanner) are a starting point for Azure Stack planning and configuration decisions. This information isn't intended to serve as a substitute for your own investigation and analysis. Microsoft makes no representations or warranties, express or implied, with respect to the information provided here.
 
An Azure Stack solution is built as a hyperconverged cluster of compute and storage. The convergence allows for the sharing of the hardware capacity in the cluster, referred to as a *scale unit*. In Azure Stack, a scale unit provides the availability and scalability of resources. A scale unit consists of a set of Azure Stack servers, referred to as *hosts*. The infrastructure software is hosted within a set of virtual machines (VMs), and shares the same physical servers as the tenant VMs. All Azure Stack VMs are then managed by the scale unit’s Windows Server clustering technologies and individual Hyper-V instances. 

The scale unit simplifies the acquisition and management Azure Stack. The scale unit also allows for the movement and scalability of all services (tenant and infrastructure) across Azure Stack. 

The following topics provide more details about each component:

- [Azure Stack compute](azure-stack-capacity-planning-compute.md)
- [Azure Stack storage](azure-stack-capacity-planning-storage.md)
- [Azure Stack Capacity Planner](azure-stack-capacity-planner.md)
