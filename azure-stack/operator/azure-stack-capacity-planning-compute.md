---
title: Azure Stack Hub compute capacity
description: Learn about compute capacity planning for Azure Stack Hub deployments.
author: IngridAtMicrosoft
ms.topic: article
ms.date: 07/16/2019
ms.author: inhenkel
ms.reviewer: prchint
ms.lastreviewed: 06/13/2019

# Intent: As an Azure Stack Hub operator, I want to learn about compute capacity planning for Azure Stack Hub deployments
# Keyword: azure stack hub compute capacity

---


# Azure Stack Hub compute capacity

The [virtual machine (VM) sizes](https://docs.microsoft.com/azure-stack/user/azure-stack-vm-sizes) supported on Azure Stack Hub are a subset of those supported on Azure. Azure imposes resource limits along many vectors to avoid overconsumption of resources (server local and service-level). Without imposing some limits on tenant consumption, the tenant experiences will suffer when other tenants overconsume resources. For networking egress from the VM, there are bandwidth caps in place on Azure Stack Hub that match Azure limitations. For storage resources on Azure Stack Hub, storage IOPS limits avoid basic over consumption of resources by tenants for storage access.

>[!IMPORTANT]
>The [Azure Stack Hub Capacity Planner](https://aka.ms/azstackcapacityplanner) does not consider or guarantee IOPS performance.

## VM placement

The Azure Stack Hub placement engine places tenant VMs across the available hosts.

Azure Stack Hub uses two considerations when placing VMs. One, is there enough memory on the host for that VM type? And two, are the VMs a part of an [availability set](https://docs.microsoft.com/azure/virtual-machines/windows/manage-availability) or are they [virtual machine scale sets](https://docs.microsoft.com/azure/virtual-machine-scale-sets/overview)?

To achieve high availability of a multi-VM production system in Azure Stack Hub, virtual machines (VMs) are placed in an availability set that spreads them across multiple fault domains. A fault domain in an availability set is defined as a single node in the scale unit. Azure Stack Hub supports having an availability set with a maximum of three fault domains to be consistent with Azure. VMs placed in an availability set will be physically isolated from each other by spreading them as evenly as possible over multiple fault domains (Azure Stack Hub hosts). If there's a hardware failure, VMs from the failed fault domain will be restarted in other fault domains. If possible, they'll be kept in separate fault domains from the other VMs in the same availability set. When the host comes back online, VMs will be rebalanced to maintain high availability.  

Virtual machine scale sets use availability sets on the back end and make sure each virtual machine scale set instance is placed in a different fault domain. This means they use separate Azure Stack Hub infrastructure nodes. For example, in a four-node Azure Stack Hub system, there may be a situation where a virtual machine scale set of three instances will fail at creation due to the lack of the four-node capacity to place three virtual machine scale set instances on three separate Azure Stack Hub nodes. In addition, Azure Stack Hub nodes can be filled up at varying levels before trying placement.

Azure Stack Hub doesn't overcommit memory. However, an overcommit of the number of physical cores is allowed.

Since placement algorithms don't look at the existing virtual to physical core overprovisioning ratio as a factor, each host could have a different ratio. As Microsoft, we don't provide guidance on the physical-to-virtual core ratio because of the variation in workloads and service level requirements.

## Consideration for total number of VMs

There's a new consideration for accurately planning Azure Stack Hub capacity. With the 1901 update (and every update going forward), there's now a limit on the total number of VMs that can be created. This limit is intended to be temporary to avoid solution instability. The source of the stability issue at higher numbers of VMs is being addressed but a specific timeline for remediation hasn't been determined. There's now a per-server limit of 60 VMs with a total solution limit of 700. For example, an eight-server Azure Stack Hub VM limit would be 480 (8 * 60). For a 12 to 16 server Azure Stack Hub solution, the limit would be 700. This limit has been created keeping all the compute capacity considerations in mind, such as the resiliency reserve and the CPU virtual-to-physical ratio that an operator would like to maintain on the stamp. For more information, see the new release of the capacity planner.

If the VM scale limit is reached, the following error codes are returned as a result: `VMsPerScaleUnitLimitExceeded`, `VMsPerScaleUnitNodeLimitExceeded`.

## Considerations for deallocation

When a VM is in the _deallocated_ state, memory resources aren't being used. This allows others VMs to be placed in the system.

If the deallocated VM is then started again, the memory usage or allocation is treated like a new VM placed into the system and available memory is consumed.

If there's no available memory, then the VM won't start.

## Azure Stack Hub memory

Azure Stack Hub is designed to keep VMs running that have been successfully provisioned. For example, if a host is offline because of a hardware failure, Azure Stack Hub will attempt to restart that VM on another host. A second example during patching and updating of the Azure Stack Hub software. If there's a need to reboot a physical host, an attempt is made to move the VMs executing on that host to another available host in the solution.

This VM management or movement can only be achieved if there's reserved memory capacity to allow for the restart or migration to occur. A portion of the total host memory is reserved and unavailable for tenant VM placement.

You can review a pie chart in the administrator portal that shows the free and used memory in Azure Stack Hub. The following diagram shows the physical memory capacity on an Azure Stack Hub scale unit in the Azure Stack Hub:

![Physical memory capacity on an Azure Stack Hub scale unit](media/azure-stack-capacity-planning/physical-memory-capacity.png)

Used memory is made up of several components. The following components consume the memory in the use section of the pie chart:  

- **Host OS usage or reserve:** The memory used by the operating system (OS) on the host, virtual memory page tables, processes that are running on the host OS, and the Spaces Direct memory cache. Since this value is dependent on the memory used by the different Hyper-V processes running on the host, it can fluctuate.
- **Infrastructure services:** The infrastructure VMs that make up Azure Stack Hub. As of the 1904 release version of Azure Stack Hub, this entails ~31 VMs that take up 242 GB + (4 GB x # of nodes) of memory. The memory utilization of the infrastructure services component may change as we work on making our infrastructure services more scalable and resilient.
- **Resiliency reserve:** Azure Stack Hub reserves a portion of the memory to allow for tenant availability during a single host failure as well as during patch and update to allow for successful live migration of VMs.
- **Tenant VMs:** The tenant VMs created by Azure Stack Hub users. In addition to running VMs, memory is consumed by any VMs that have landed on the fabric. This means that VMs in "Creating" or "Failed" state, or VMs shut down from within the guest, will consume memory. However, VMs that have been deallocated using the stop deallocated option from portal/powershell/cli won't consume memory from Azure Stack Hub.
- **Value-add resource providers (RPs):** VMs deployed for the value-add RPs like SQL, MySQL, App Service, and so on.

The best way to understand memory consumption on the portal is to use the [Azure Stack Hub Capacity Planner](https://aka.ms/azstackcapacityplanner) to see the impact of various workloads. The following calculation is the same one used by the planner.

This calculation results in the total available memory that can be used for tenant VM placement. This memory capacity is for the entirety of the Azure Stack Hub scale unit.

Available memory for VM placement = total host memory - resiliency reserve - memory used by running tenant VMs - Azure Stack Hub Infrastructure Overhead <sup>1</sup>

Resiliency reserve = H + R * ((N-1) * H) + V * (N-2)

> Where:
> -	H = Size of single server memory
> - N = Size of Scale Unit (number of servers)
> -	R = The operating system reserve for OS overhead, which is .15 in this formula<sup>2</sup>
> -	V = Largest VM in the scale unit

<sup>1</sup> Azure Stack Hub Infrastructure overhead = 242 GB + (4 GB x # of nodes). Approximately 31 VMs are used to host Azure Stack Hub's infrastructure and, in total, consume about 242 GB + (4 GB x # of nodes) of memory and 146 virtual cores. The rationale for this number of VMs is to satisfy the needed service separation to meet security, scalability, servicing, and patching requirements. This internal service structure allows for the future introduction of new infrastructure services as they're developed.

<sup>2</sup> Operating system reserve for overhead = 15% (.15) of node memory. The operating system reserve value is an estimate and will vary based on the physical memory capacity of the server and general operating system overhead.

The value V, largest VM in the scale unit, is dynamically based on the largest tenant VM memory size. For example, the largest VM value could be 7 GB or 112 GB or any other supported VM memory size in the Azure Stack Hub solution. Changing the largest VM on the Azure Stack Hub fabric will result in an increase in the resiliency reserve and also to the increase in the memory of the VM itself.

## Frequently Asked Questions

**Q**: My tenant deployed a new VM, how long will it take for the capability chart on the administrator portal to show remaining capacity?

**A**: The capacity blade refreshes every 15 minutes, so take that into consideration.

**Q**: The number of deployed VMs on my Azure Stack Hub hasn't changed, but my capacity is fluctuating. Why?

**A**: The available memory for VM placement has multiple dependencies, one of which is the host OS reserve. This value is dependent on the memory used by the different Hyper-V processes running on the host, which isn't a constant value.

**Q**: What state do tenant VMs have to be in to consume memory?

**A**: In addition to running VMs, memory is consumed by any VMs that have landed on the fabric. This means that VMs that are in a "Creating" or "Failed" state will consume memory. VMs shut down from within the guest as opposed to stop deallocated from portal/powershell/cli will also consume memory.

**Q**: I have a four-host Azure Stack Hub. My tenant has 3 VMs that consume 56 GB of RAM (D5_v2) each. One of the VMs is resized to 112 GB RAM (D14_v2), and available memory reporting on dashboard resulted in a spike of 168 GB usage on the capacity blade. Subsequent resizing of the other two D5_v2 VMs to D14_v2 resulted in only 56 GB of RAM increase each. Why is this so?

**A**: The available memory is a function of the resiliency reserve maintained by Azure Stack Hub. The Resiliency reserve is a function of the largest VM size on the Azure Stack Hub stamp. At first, the largest VM on the stamp was 56 GB memory. When the VM was resized, the largest VM on the stamp became 112 GB memory which not only increased the memory used by that tenant VM but also increased the resiliency reserve. This change resulted in an increase of 56 GB (56 GB to 112 GB tenant VM memory increase) + 112 GB resiliency reserve memory increase. When subsequent VMs were resized, the largest VM size remained as the 112 GB VM and therefore there was no resultant resiliency reserve increase. The increase in memory consumption was only the tenant VM memory increase (56 GB).

> [!NOTE]
> The capacity planning requirements for networking are minimal as only the size of the public VIP is configurable. For information about how to add more public IP addresses to Azure Stack Hub, see [Add public IP addresses](azure-stack-add-ips.md).

## Next steps
Learn about [Azure Stack Hub storage](azure-stack-capacity-planning-storage.md)
