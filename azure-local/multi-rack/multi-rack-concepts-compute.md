---
title: "Compute for Multi-rack Deployments of Azure Local (Preview)"
description: Get an overview of compute resources for multi-rack deployments of Azure Local (Preview).
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.topic: conceptual
ms.date: 11/06/2025
ms.custom: conceptual
---

# Compute overview for multi-rack deployments of Azure Local (Preview)

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article provides an overview of compute resources for multi-rack deployments of Azure Local.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## About compute infrastructure in multi-rack deployments of Azure Local

Azure Local is built on basic constructs like compute servers, storage appliances, and network fabric devices. These compute servers, also called bare-metal machines (BMMs), represent the physical machines on the rack. They run the Azure Linux operating system and provide closed integration support for high-performance workloads.

These BMMs are deployed as part of the Azure Local automation suite. They exist as nodes in a Kubernetes cluster to serve various virtualized and containerized workloads in the ecosystem.

Each BMM in your instance is represented as an Azure resource. Operators get access to perform various operations to manage the BMM's lifecycle like any other Azure resource.

<!--The following section contains unresolved comment in the starter doc. I've made edits as per the starter doc, but commented out the entire section until the comment is resolved.

## Key capabilities of scompute for multi-rack deployments

### NUMA alignment

Nonuniform memory access (NUMA) alignment is a technique to optimize performance and resource utilization in multiple-socket servers. It involves aligning memory and compute resources to reduce latency and improve data access within a server system.

Through the strategic placement of software components and workloads in a NUMA-aware way, Operators can enhance the performance of applications, such as virtualized routers and firewalls. This placement leads to improved service delivery and responsiveness in their cloud environments.

By default, all the workloads deployed in an Azure Local instance are NUMA aligned.

### CPU pinning

CPU pinning is a technique to allocate specific CPU cores to dedicated tasks or workloads, which help ensure consistent performance and resource isolation. Pinning critical network functions or real-time applications to specific CPU cores allows operators to minimize latency and improve predictability in their infrastructure. This approach is useful in scenarios where strict quality-of-service requirements exist, because these tasks can receive dedicated processing power for optimal performance.

All of the virtual machines created for workloads on Azure Local compute are pinned to specific virtual cores. This pinning provides better performance and avoids CPU stealing.

### CPU isolation

CPU isolation provides a clear separation between the CPUs allocated for workloads and the CPUs allocated for control plane and platform activities. CPU isolation prevents interference and limits the performance predictability for critical workloads. By isolating CPU cores or groups of cores, operators can mitigate the effect of noisy neighbors. It helps guarantee the required processing power for latency-sensitive applications.

Azure Local reserves a small set of CPUs for the host operating system and other platform applications. The remaining CPUs are available for running actual workloads.

### Huge page support

Huge page usage in workloads refers to the utilization of large memory pages, typically 2 MiB or 1 GiB in size, instead of the standard 4 KiB pages. This approach helps reduce memory overhead and improves the overall system performance. It reduces the translation look-aside buffer (TLB) miss rate and improves memory access efficiency.

Workloads that involve large data sets or intensive memory operations can benefit from huge page usage because it enhances memory performance and reduces memory-related bottlenecks. As a result, users see improved throughput and reduced latency.

All virtual machines created on Azure Local are backed by 1GiB(1G) hugepages for the requested memory.  The kernel running inside the VM can manage these available memory anyway it likes, including the allocation of memory to support hugepages (2M or 1G).

### Dual-stack support

Dual-stack support refers to the ability of networking equipment and protocols to simultaneously handle both IPv4 and IPv6 traffic. With the depletion of available IPv4 addresses and the growing adoption of IPv6, dual-stack support is crucial for seamless transition and coexistence between the two protocols.

Telco operators use dual-stack support to ensure compatibility, interoperability, and future-proofing of their networks. It allows them to accommodate both IPv4 and IPv6 devices and services while gradually transitioning toward full IPv6 deployment.

Dual-stack support helps ensure uninterrupted connectivity and smooth service delivery to customers regardless of their network addressing protocols. Azure Local provides support for both IPv4 and IPv6 configuration across all layers of the stack.

### Network interface cards

Computes in Azure Local are designed to meet the requirements for running critical applications that are enterprise grade. They can perform fast and efficient data transfer between servers and networks.

Workloads can make use of single-root I/O virtualization (SR-IOV). SR-IOV enables the direct assignment of physical I/O resources, such as network interfaces, to virtual machines. This direct assignment bypasses the hypervisor's virtual switch layer.

This direct hardware access improves network throughput, reduces latency, and enables more efficient utilization of resources. It makes SR-IOV an ideal choice for operators running enterprise applications.
-->

## BMM status

The following properties reflect the operational state of a BMM:

- `Power State` indicates the state as derived from a bare-metal controller (BMC). The state can be either `On` or `Off`.

- `Ready State` provides an overall assessment of BMM readiness. It looks at a combination of `Detailed Status`, `Power State`, and the provisioning state of the resource to determine whether the BMM is ready or not. When `Ready State` is `True`, the BMM is turned on, `Detailed Status` is `Provisioned`, and the node that represents the BMM has successfully joined the infrastructure Kubernetes cluster (also referred to as the **Undercloud** cluster). If any of those conditions aren't met, `Ready State` is set to `False`.

- `Cordon State` reflects the ability to run any workloads on a machine. Valid values are `Cordoned` and `Uncordoned`. `Cordoned` seizes creation of any new workloads on the machine. `Uncordoned` ensures that workloads can now run on this BMM.

- `Detailed Status` reflects the current status of the machine:

  - `Preparing`: The machine is being prepared for provisioning.
  - `Provisioning`: Provisioning is in progress.
  - `Provisioned`: The operating system is provisioned to the machine.
  - `Available`: The machine is available to participate in the cluster. The machine was successfully provisioned but is currently turned off.
  - `Error`: The machine couldn't be provisioned.

  `Preparing` and `Provisioning` are transitory states. `Provisioned`, `Available`, and `Error` are end-state statuses.

- `MachineRoles` helps identify the roles that the BMM fulfills in the cluster. The following roles are assigned to BMM resources:

  - `Control plane`: The BMM runs the Kubernetes control plane agents for infrastructure cluster.
  - `Management plane`: The BMM runs the platform software including controllers and extensions.
  - `Compute plane`: The BMM responsible for running actual tenant workloads including Virtual Machines.
  
  For frequently asked questions about BMM roles, see the [FAQ](#faq) section.

## BMM operations

- **Update/Patch BareMetal Machine**: Update the BMM resource properties.
- **List/Show BareMetal Machine**: Retrieve BMM information.
- **Reimage BareMetal Machine**: Reprovision a BMM that matches the image version that's used across the cluster.
- **Replace BareMetal Machine**: Replace a BMM as part of an effort to service the machine.
- **Restart BareMetal Machine**: Restart a BMM.
- **Power Off BareMetal Machine**: Turn off a BMM.
- **Start BareMetal Machine**: Turn on a BMM.
- **Cordon BareMetal Machine**: Prevent scheduling of workloads on the specified BMM's Kubernetes node. Optionally, allow for evacuation of the workloads from the node.
- **Uncordon BareMetal Machine**: Allow scheduling of workloads on the specified BMM's Kubernetes node.
- **BareMetalMachine Validate**: Trigger hardware validation of a BMM.
- **BareMetalMachine Run**: Allow the customer to run a script specified directly in the input on the targeted BMM.
- **BareMetalMachine Run Data Extract**: Allow the customer to run one or more data extractions against a BMM.
- **BareMetalMachine Run Read-only**: Allow the customer to run one or more read-only commands against a BMM.

> [!NOTE]
> Customers can't create or delete BMMs directly. These machines are created only as the realization of the cluster lifecycle. Implementation blocks creation or deletion requests from any user, and it allows only internal/application-driven creation or deletion operations.

## FAQ

This section answers common questions about BMM roles.

### How do machine roles work?

Kubernetes labels are applied to BMM resources during the cluster deployment. The `machineRoles` property is derived from the Kubernetes labels applied to the BMM resource.

### How to determine the BareMetal Machine role?

In any standard multi-rack instance with three or more compute racks, there are three powered-on control plane nodes.
Additionally, there's one node that is powered off but available to join the cluster.
The `machineRoles` field is used in addition to the `powerState` and `detailedStatus` fields to identify the spare control plane node in an instance.

This command lists the control plane servers along with their power states and statuses:

```azurecli
az networkcloud baremetalmachine list \
  -g <resource-group> \
  --sub <subscription> \
  --query "sort_by([].{name:name,readyState:readyState,detailedStatus:detailedStatus,detailedStatusMessage:detailedStatusMessage,powerState:powerState,cordonStatus:cordonStatus,machineRoles:machineRoles | join(', ', @)}, &name)" \
  --output table

| Name | ReadyState | DetailedStatus | DetailedStatusMessage | PowerState | CordonStatus | MachineRoles | Notes |
|--|--|--|--|--|--|--|--|
| x01dev01c1mg01 | True | Provisioned | The OS is provisioned to the machine. | On | Uncordoned | platform.afo-nc.microsoft.com/control-plane=true | Control plane node |
| *x01dev01c2mg02* | False | Available | Available to participate in the cluster. | Off | Uncordoned | platform.afo-nc.microsoft.com/control-plane=true | Spare control plane node |
| x01dev01c3mg01 | True | Provisioned | The OS is provisioned to the machine. | On | Uncordoned | platform.afo-nc.microsoft.com/control-plane=true | Control plane node |
| x01dev01c4mg01 | True | Provisioned | The OS is provisioned to the machine. | On | Uncordoned | platform.afo-nc.microsoft.com/control-plane=true | Control plane node |
| x01dev01c1mg02 | True | Provisioned | The OS is provisioned to the machine. | On | Uncordoned | platform.afo-nc.microsoft.com/management-plane=true | Management plane node |
| x01dev01c2mg01 | True | Provisioned | The OS is provisioned to the machine. | On | Uncordoned | platform.afo-nc.microsoft.com/management-plane=true | Management plane node |
| x01dev01c3mg02 | True | Provisioned | The OS is provisioned to the machine. | On | Uncordoned | platform.afo-nc.microsoft.com/management-plane=true | Management plane node |
| x01dev01c4mg02 | True | Provisioned | The OS is provisioned to the machine. | On | Uncordoned | platform.afo-nc.microsoft.com/management-plane=true | Management plane node |
| x01dev01c1co01 | True | Provisioned | The OS is provisioned to the machine. | On | Uncordoned | platform.afo-nc.microsoft.com/compute-plane=true | Compute plane node |
| x01dev01c1co02 | True | Provisioned | The OS is provisioned to the machine. | On | Uncordoned | platform.afo-nc.microsoft.com/compute-plane=true | Compute plane node |
```

In the example, the BMM `x01dev01c2mg02` serves as the spare control plane node, which is currently powered off but in `Available` state.

### What is the spare node?

This spare control plane BMM functions as a standby, ready to be provisioned just-in-time during cluster upgrades or to replace another control plane BMM deemed unhealthy.

For any initial cluster deployment *(greenfield, GF)*, there will always be one BMM designated as the spare node from the control plane pool.
The spare node is never provisioned and doesn't have the cluster version, Kubernetes version, and Operations, Administration, and Maintenance (OAM) IP information populated on the resource.

The spare node’s `cordonState` is set to `Uncordoned`, the `powerState` is set to `Off`, and the Kubernetes version value is unset.
The `detailedStatus` is made `Available` and its `detailedStatusMessage` is `Available to participate in the cluster.`

When a spare node has been provisioned, the spare node designation is reassigned to another node in the control plane pool.

After the runtime upgrade concludes, there's one spare node that used to be an active node at some point in time. Outside of a runtime upgrade, an active Kubernetes control plane node can become the spare, if it moves into an unhealthy state.

The newly designated spare node reflects the previous Cluster version and includes the OAM IP information.
The spare node’s `cordonState` is set to `Cordoned`, the `powerState` is set to `Off`, and the Kubernetes version value is unset.
The `detailedStatus` is made `Available` and its `detailedStatusMessage` is `Available to participate in the cluster.`