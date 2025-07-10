---
title: Azure Stack Hub compute capacity
description: Learn about compute capacity planning for Azure Stack Hub deployments.
author: sethmanheim
ms.topic: article
ms.date: 01/23/2025
ms.author: sethm
ms.lastreviewed: 03/02/2021

# Intent: As an Azure Stack Hub operator, I want to learn about compute capacity planning for Azure Stack Hub deployments
# Keyword: azure stack hub compute capacity

---


# Azure Stack Hub compute capacity

The [virtual machine (VM) sizes](../user/azure-stack-vm-sizes.md) supported on Azure Stack Hub are a subset of those supported on Azure. Azure imposes resource limits along many vectors to avoid overconsumption of resources (server local and service-level). Without imposing some limits on tenant consumption, the tenant experiences suffer when other tenants overconsume resources. For networking egress from the VM, there are bandwidth caps in place on Azure Stack Hub that match Azure limitations. For storage resources on Azure Stack Hub, storage IOPS limits avoid basic over consumption of resources by tenants for storage access.

> [!IMPORTANT]
> The [Azure Stack Hub Capacity Planner](https://aka.ms/azstackcapacityplanner) does not consider or guarantee IOPS performance. The administrator portal shows a warning alert when the total system memory consumption reaches 85%. This alert can be remediated by [adding more capacity](azure-stack-add-scale-node.md), or by removing virtual machines that are no longer required.

## VM placement

The Azure Stack Hub placement engine places tenant VMs across the available hosts.

Azure Stack Hub uses two considerations when placing VMs. One, is there enough memory on the host for that VM type? And two, are the VMs a part of an [availability set](/azure/virtual-machines/windows/manage-availability) or are they [virtual machine scale sets](/azure/virtual-machine-scale-sets/overview)?

To achieve high availability of a multi-VM production workload in Azure Stack Hub, virtual machines (VMs) are placed in an availability set that spreads them across multiple fault domains. A fault domain in an availability set is defined as a single node in the scale unit. Azure Stack Hub supports having an availability set with a maximum of three fault domains to be consistent with Azure. VMs placed in an availability set are physically isolated from each other by spreading them as evenly as possible over multiple fault domains (Azure Stack Hub nodes). If there's a hardware failure, VMs from the failed fault domain are restarted in other fault domains. If possible, they're kept in separate fault domains from the other VMs in the same availability set. When the host comes back online, VMs are rebalanced to maintain high availability.

Virtual machine scale sets use availability sets on the back end and make sure each virtual machine scale set instance is placed in a different fault domain. This means they use separate Azure Stack Hub infrastructure nodes. For example, in a four-node Azure Stack Hub system, there might be a situation where a virtual machine scale set of three instances fails at creation due to the lack of the four-node capacity to place three virtual machine scale set instances on three separate Azure Stack Hub nodes. In addition, Azure Stack Hub nodes can be filled up at varying levels before trying placement.

Azure Stack Hub doesn't overcommit memory. However, an overcommit of the number of physical cores is allowed.

Since placement algorithms don't look at the existing virtual to physical core overprovisioning ratio as a factor, each host could have a different ratio. As Microsoft, we don't provide guidance on the physical-to-virtual core ratio because of the variation in workloads and service level requirements.

## Consideration for total number of VMs

There is a limit on the total number of VMs that can be created. The maximum number of VMs on Azure Stack Hub is 700 and 60 per scale unit node. For example, an eight-server Azure Stack Hub VM limit would be 480 (8 * 60). For a 12 to 16 server Azure Stack Hub solution, the limit would be 700. This limit waws created with all the compute capacity considerations in mind, such as the resiliency reserve and the CPU virtual-to-physical ratio that an operator would like to maintain on the stamp.

If the VM scale limit is reached, the following error codes are returned as a result: `VMsPerScaleUnitLimitExceeded`, `VMsPerScaleUnitNodeLimitExceeded`.

> [!NOTE]
> A portion of the 700 VM maximum is reserved for Azure Stack Hub infrastructure VMs. For more information, refer to the [Azure Stack Hub capacity planner](https://aka.ms/azstackcapacityplanner).

## Consideration for batch deployment of VMs

In releases before and including 2002, 2-5 VMs per batch with 5 mins gap in between batches provided reliable VM deployments to reach a scale of 700 VMs. With the 2005 version of Azure Stack Hub onwards, we are able to reliably provision VMs at batch sizes of 40 with 5 mins gap in between batch deployments. Start, Stop-deallocate, and update operations should be done at a batch size of 30, leaving 5 mins in between each batch.

## Consideration for GPU VMs

Azure Stack hub reserves memory for the infrastructure and tenant VMs to failover. Unlike other VMs, GPU VMs run in a non-HA (high availability) mode and therefore do not failover. As a result, reserved memory for a GPU VM-only stamp is what is required by the infrastructure to failover, as opposed to accounting for HA tenant VM memory too.  

## Azure Stack Hub memory

Azure Stack Hub is designed to keep VMs running that were successfully provisioned. For example, if a host is offline because of a hardware failure, Azure Stack Hub attempts to restart that VM on another host. A second example during patching and updating of the Azure Stack Hub software. If there's a need to reboot a physical host, an attempt is made to move the VMs executing on that host to another available host in the solution.

This VM management or movement can only be achieved if there's reserved memory capacity to allow for the restart or migration to occur. A portion of the total host memory is reserved and unavailable for tenant VM placement.

You can review a pie chart in the administrator portal that shows the free and used memory in Azure Stack Hub. The following diagram shows the physical memory capacity on an Azure Stack Hub scale unit in the Azure Stack Hub:

![Physical memory capacity on an Azure Stack Hub scale unit](media/azure-stack-capacity-planning/physical-memory-capacity.png)

Used memory is made up of several components. The following components consume the memory in the use section of the pie chart:  

- **Host OS usage or reserve:** The memory used by the operating system (OS) on the host, virtual memory page tables, processes that are running on the host OS, and the Spaces Direct memory cache. Since this value is dependent on the memory used by the different Hyper-V processes running on the host, it can fluctuate.
- **Infrastructure services:** The infrastructure VMs that make up Azure Stack Hub. As discussed previously, these VMs are part of the 700 VM maximum. The memory utilization of the infrastructure services component may change as we work on making our infrastructure services more scalable and resilient. For more information see the [Azure Stack Hub capacity planner](https://aka.ms/azstackcapacityplanner)
- **Resiliency reserve:** Azure Stack Hub reserves a portion of the memory to allow for tenant availability during a single host failure as well as during patch and update to allow for successful live migration of VMs.
- **Tenant VMs:** The tenant VMs created by Azure Stack Hub users. In addition to running VMs, memory is consumed by any VMs that have landed on the fabric. This means that VMs in "Creating" or "Failed" state, or VMs shut down from within the guest, consume memory. However, VMs that were deallocated using the stop deallocated option from portal/powershell/cli won't consume memory from Azure Stack Hub.
- **Value-add resource providers (RPs):** VMs deployed for the value-add RPs like SQL, MySQL, App Service, and so on.

The best way to understand memory consumption on the portal is to use the [Azure Stack Hub Capacity Planner](https://aka.ms/azstackcapacityplanner) to see the impact of various workloads. The following calculation is the same one used by the planner.

This calculation results in the total available memory that can be used for tenant VM placement. This memory capacity is for the entirety of the Azure Stack Hub scale unit.

Available memory for VM placement = total host memory - resiliency reserve - memory used by running tenant VMs - Azure Stack Hub Infrastructure Overhead <sup>1</sup>

- Total host memory = Sum of memory from all nodes
- Resiliency reserve = H + R * ((N-1) * H) + V * (N-2)
- Memory used by tenant VMs = Actual memory consumed by tenant workload, does not depend on HA configuration
- Azure Stack Hub Infrastructure Overhead = 268 GB + (4GB x N)

Where:

- H = Size of single server memory
- N = Size of Scale Unit (number of servers)
- R = The operating system reserve for OS overhead, which is .15 in this formula<sup>2</sup>
- V = Largest HA VM in the scale unit

<sup>1</sup> Azure Stack Hub Infrastructure overhead = 268 GB + (4 GB x # of nodes). Approximately 31 VMs are used to host Azure Stack Hub's infrastructure and, in total, consume about 268 GB + (4 GB x # of nodes) of memory and 146 virtual cores. The rationale for this number of VMs is to satisfy the needed service separation to meet security, scalability, servicing, and patching requirements. This internal service structure allows for the future introduction of new infrastructure services as they're developed.

<sup>2</sup> Operating system reserve for overhead = 15% (.15) of node memory. The operating system reserve value is an estimate and varies based on the physical memory capacity of the server and general operating system overhead.

The value V, largest HA VM in the scale unit, is dynamically based on the largest tenant VM memory size. For example, the largest HA VM value is a minimum of 12 GB (accounting for the infrastructure VM) or 112 GB or any other supported VM memory size in the Azure Stack Hub solution. Changing the largest HA VM on the Azure Stack Hub fabric results in an increase in the resiliency reserve and also to the increase in the memory of the VM itself. Remember that GPU VMs run in non-HA mode.

### Sample calculation

We have a small four-node Azure Stack Hub deployment with 768 GB RAM on each node. We plan to place a virtual machine for SQL server with 128GB of RAM (Standard_E16_v3). What is the available memory for VM placement?

- Total host memory = Sum of memory from all nodes = 4 * 768 GB = 3072 GB
- Resiliency reserve = H + R * ((N-1) * H) + V * (N-2) = 768 + 0.15 * ((4 - 1) * 768) + 128 * (4 - 2) = 1370 GB
- Memory used by tenant VMs = Actual memory consumed by tenant workload, does not depend on HA configuration = 0 GB
- Azure Stack Hub Infrastructure Overhead = 268 GB + (4GB x N) = 268 + (4 * 4) = 284 GB

Available memory for VM placement = total host memory - resiliency reserve - memory used by running tenant VMs - Azure Stack Hub Infrastructure Overhead

Available memory for VM placement = 3072 - 1370 - 0 - 284 = 1418 GB

## Considerations for deallocation

When a VM is in the _deallocated_ state, memory resources aren't being used. This allows others VMs to be placed in the system.

If the deallocated VM is then started again, the memory usage or allocation is treated like a new VM placed into the system and available memory is consumed. If there's no available memory, then the VM won't start.

Current deployed large VMs show that the allocated memory is 112 GB, but the memory demand of these VMs is about 2-3 GB.
    
| Name | Memory Assigned (GB) | Memory Demand (GB) | ComputerName |  
| ---- | -------------------- | ------------------ | ------------ |                                        
| ca7ec2ea-40fd-4d41-9d9b-b11e7838d508 |                 112  |     2.2392578125  |  LISSA01P-NODE01 |
| 10cd7b0f-68f4-40ee-9d98-b9637438ebf4  |                112  |     2.2392578125  |   LISSA01P-NODE01 |
| 2e403868-ff81-4abb-b087-d9625ca01d84   |               112   |    2.2392578125  |   LISSA01P-NODE04 |

There are three ways to deallocate memory for VM placement using the formula **Resiliency reserve = H + R * ((N-1) * H) + V * (N-2)**:
* Reduce the size of the largest VM
* Increase the memory of a node
* Add a node

### Reduce the size of the largest VM 

Reducing the size of the largest VM to the next smallest VM in stamp (24 GB) reduces the size of the resiliency reserve.

![Reduce the VM size](media/azure-stack-capacity-planning/decrease-vm-size.png)        

 Resiliency reserve = 384 + 172.8 + 48 = 604.8 GB

| Total memory | Infra GB | Tenant GB | Resiliency reserve | Total memory reserved          | Total GB available for placement |
|--------------|--------------------|---------------------|--------------------|--------------------------------|----------------------------------|
| 1536 GB      | 258 GB             | 329.25 GB           | 604.8 GB           | 258 + 329.25 + 604.8 = 1168 GB | **~344 GB**                         |

### Add a node

[Adding an Azure Stack Hub node](./azure-stack-add-scale-node.md) deallocates memory by equally distributing the memory between the two nodes.

![Add a node](media/azure-stack-capacity-planning/add-a-node.png)

Resiliency reserve = 384 + (0.15) ((5)*384) + 112 * (3) = 1008  GB

| Total Memory | Infra GB | Tenant GB | Resiliency reserve | Total memory reserved          | Total GB available for placement |
|--------------|--------------------|---------------------|--------------------|--------------------------------|----------------------------------|
| 1536 GB      | 258 GB             | 329.25 GB           | 604.8 GB           | 258 + 329.25 + 604.8 = 1168 GB | **~ 344 GB**                         |

### Increase memory on each node to 512 GB

[Increasing the memory of each node](./azure-stack-manage-storage-physical-memory-capacity.md) increases the total available memory.

![Increase the size of the node](media/azure-stack-capacity-planning/increase-node-size.png)

Resiliency reserve = 512 + 230.4 + 224 = 966.4 GB

| Total Memory    | Infra GB | Tenant GB | Resiliency reserve | Total memory reserved | Total GB available for placement |
|-----------------|----------|-----------|--------------------|-----------------------|----------------------------------|
| 2048 (4*512) GB | 258 GB   | 505.75 GB | 966.4 GB           | 1730.15 GB            | **~ 318 GB**                         |

## Frequently Asked Questions

**Q**: My tenant deployed a new VM, how long does it take for the capability chart on the administrator portal to show remaining capacity?

**A**: The capacity blade refreshes every 15 minutes, so take that into consideration.

**Q**: How can I see the available cores and assigned cores?

**A**: In **PowerShell** run `test-azurestack -include AzsVmPlacement -debug`, which generates an output like this:

```console
    Starting Test-AzureStack
    Launching AzsVmPlacement
     
    Azure Stack Scale Unit VM Placement Summary Results
     
    Cluster Node    VM Count VMs Running Physical Core Total Virtual Co Physical Memory Total Virtual Mem
    ------------    -------- ----------- ------------- ---------------- --------------- -----------------
    LNV2-Node02     20       20          28            66               256             119.5            
    LNV2-Node03     17       16          28            62               256             110              
    LNV2-Node01     11       11          28            47               256             111              
    LNV2-Node04     10       10          28            49               256             101              
    
    PASS : Azure Stack Scale Unit VM Placement Summary
```

**Q**: The number of deployed VMs on my Azure Stack Hub hasn't changed, but my capacity is fluctuating. Why?

**A**: The available memory for VM placement has multiple dependencies, one of which is the host OS reserve. This value is dependent on the memory used by the different Hyper-V processes running on the host, which isn't a constant value.

**Q**: What state do tenant VMs have to be in to consume memory?

**A**: In addition to running VMs, memory is consumed by any VMs that have landed on the fabric. This means that VMs that are in a "Creating" or "Failed" state consume memory. VMs shut down from within the guest as opposed to stop deallocated from portal/powershell/cli also consume memory.

**Q**: I have a four-host Azure Stack Hub. My tenant has 3 VMs that consume 56 GB of RAM (D5_v2) each. One of the VMs is resized to 112 GB RAM (D14_v2), and available memory reporting on dashboard resulted in a spike of 168 GB usage on the capacity blade. Subsequent resizing of the other two D5_v2 VMs to D14_v2 resulted in only 56 GB of RAM increase each. Why is this so?

**A**: The available memory is a function of the resiliency reserve maintained by Azure Stack Hub. The Resiliency reserve is a function of the largest VM size on the Azure Stack Hub stamp. At first, the largest VM on the stamp was 56 GB memory. When the VM was resized, the largest VM on the stamp became 112 GB memory which not only increased the memory used by that tenant VM but also increased the resiliency reserve. This change resulted in an increase of 56 GB (56 GB to 112 GB tenant VM memory increase) + 112 GB resiliency reserve memory increase. When subsequent VMs were resized, the largest VM size remained as the 112 GB VM and therefore there was no resultant resiliency reserve increase. The increase in memory consumption was only the tenant VM memory increase (56 GB).

> [!NOTE]
> The capacity planning requirements for networking are minimal as only the size of the public VIP is configurable. For information about how to add more public IP addresses to Azure Stack Hub, see [Add public IP addresses](azure-stack-add-ips.md).

## Next steps

Learn about [Azure Stack Hub storage](azure-stack-capacity-planning-storage.md)
