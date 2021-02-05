---
author: PatAltimore
ms.topic: include
ms.date: 02/04/2021
ms.author: patricka
---

When you're evaluating an Azure Stack Hub solution, consider the hardware configuration choices that have a direct impact on the overall capacity of the Azure Stack Hub cloud.

For example, you need to make choices regarding the CPU, memory density, storage configuration, and overall solution scale or number of servers. However, determining usable capacity will be different than a traditional virtualization solution because some capacity is already in use. Azure Stack Hub is built to host the infrastructure or management components within the solution itself. Also, some of the solution's capacity is reserved to support resiliency. Resiliency is defined as the updating of the solution's software in a way to minimize disruption of tenant workloads.

> [!IMPORTANT]
> This capacity planning information and the [Azure Stack Hub Capacity Planner](https://download.microsoft.com/download/4/a/2/4a2bd10c-58a0-4ee7-8c3f-55b526ce7e75/AzureStackHubCapacityPlanner_v2005.01.xlsm) are a starting point for Azure Stack Hub planning and configuration decisions. This information isn't intended to serve as a substitute for your own investigation and analysis. Microsoft makes no representations or warranties, express or implied, with respect to the information provided here.

## Hyperconvergence and the scale unit

An Azure Stack Hub solution is built as a hyperconverged cluster of compute and storage. The convergence allows for the sharing of the hardware capacity in the cluster, referred to as a *scale unit*. In Azure Stack Hub, a scale unit provides the availability and scalability of resources. A scale unit consists of a set of Azure Stack Hub servers, referred to as *hosts*. The infrastructure software is hosted within a set of virtual machines (VMs), and shares the same physical servers as the tenant VMs. All Azure Stack Hub VMs are then managed by the scale unit’s Windows Server clustering technologies and individual Hyper-V instances.

The scale unit simplifies the acquisition and management of Azure Stack Hub. The scale unit also allows for the movement and scalability of all services (tenant and infrastructure) across Azure Stack Hub.

The following topics provide more details about each component:

- [Azure Stack Hub compute](azure-stack-capacity-planning-compute.md)
- [Azure Stack Hub storage](azure-stack-capacity-planning-storage.md)
- [Azure Stack Hub Capacity Planner](azure-stack-capacity-planner.md)
