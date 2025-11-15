---
title: Compute for Multi-rack Deployments of Azure Local (Preview)
description: Get an overview of compute resources for multi-rack deployments of Azure Local (Preview).
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.topic: conceptual
ms.date: 11/12/2025
ms.custom: conceptual
---

# Compute overview for multi-rack deployments of Azure Local (Preview)

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article provides an overview of compute resources for multi-rack deployments of Azure Local.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## About compute infrastructure in multi-rack deployments of Azure Local

Azure Local for multi-rack deployments is built on basic constructs like compute servers, storage appliances, and network devices. These compute servers, also called bare-metal machines (BMMs), represent the physical machines on the compute rack. They run the Azure Linux operating system and provide closed integration support for high-performance workloads.

These BMMs are deployed as part of the Azure Local automation suite. They exist as nodes in the infrastructure Kubernetes cluster to serve various virtualized and containerized workloads in the multi-rack cluster.

Each BMM in your cluster is represented as an Azure resource. Users can perform various operations to manage the BMM's lifecycle like any other Azure resource.

## Key capabilities of compute for multi-rack deployments

### CPU isolation

CPU isolation provides a clear separation between the CPUs allocated for workloads and the CPUs allocated for platform activities. CPU isolation prevents interference and limits the performance predictability for critical workloads. By isolating CPU cores or groups of cores, you can mitigate the effect of noisy neighbors. It helps guarantee the required processing power for latency-sensitive applications.

Azure Local reserves a small set of CPUs for the host operating system and other platform applications. The remaining CPUs are available for running actual workloads.

### CPU oversubscription

CPU oversubscription enables efficient utilization of compute resources by allowing multiple virtual CPUs (vCPUs) to share a single physical CPU core. Azure Local with multi-rack deployments supports a default 4:1 CPU oversubscription ratio, meaning up to four vCPUs can be mapped to one physical core. This capability increases workload density and optimizes infrastructure efficiency, allowing users to run more workloads within the same hardware footprint. It is particularly beneficial in environments where workloads have variable or intermittent CPU usage, helping maximize performance and overall platform scalability.

## BMM status

The following properties reflect the operational state of a BMM:

- `Power State` indicates the state as derived from a baseboard management controller (BMC). The state can be either `On` or `Off`.

- `Ready State` provides an overall assessment of BMM readiness. It looks at a combination of `Detailed Status`, `Power State`, and the provisioning state of the resource to determine whether the BMM is ready or not. When `Ready State` is `True`, the BMM is turned on, `Detailed Status` is `Provisioned`, and the node that represents the BMM has successfully joined the infrastructure Kubernetes cluster. If any of those conditions aren't met, `Ready State` is set to `False`.

- `Cordon State` reflects the ability to run any workloads on a machine. Valid values are `Cordoned` and `Uncordoned`. `Cordoned` seizes creation of any new workloads on the machine. `Uncordoned` ensures that workloads can now run on this BMM.

- `Detailed Status` reflects the current status of the machine:

  - `Preparing`: The machine is being prepared for provisioning.
  - `Provisioning`: Provisioning is in progress.
  - `Provisioned`: The operating system is provisioned to the machine.
  - `Available`: The machine is available to participate in the cluster. The machine was successfully provisioned but is currently turned off.
  - `Error`: The machine couldn't be provisioned.

  `Preparing` and `Provisioning` are transitory states. `Provisioned`, `Available`, and `Error` are end-state statuses.

- `MachineRoles` helps identify the roles that the BMM fulfills in the cluster. The following roles are assigned to BMM resources:

  - `Control plane`: The BMM runs the Kubernetes control plane agents for the infrastructure cluster.
  - `Management plane`: The BMM runs the platform software including controllers and extensions.
  - `Compute plane`: The BMM responsible for running workloads including Virtual Machines.
  
  For frequently asked questions about BMM roles, see the [FAQ](#faq) section.

## BMM operations

- **Update/Patch BareMetal Machine**: Update the BMM resource properties.
- **List/Show BareMetal Machine**: Retrieve BMM information.
- **Reimage BareMetal Machine**: Reprovision a BMM that matches the image version that's used across the cluster.
- **Replace BareMetal Machine**: Replace a BMM for servicing the machine.
- **Restart BareMetal Machine**: Restart a BMM.
- **Power Off BareMetal Machine**: Turn off a BMM.
- **Start BareMetal Machine**: Turn on a BMM.
- **Cordon BareMetal Machine**: Prevent scheduling of workloads on the specified BMM's Kubernetes node. Optionally, allow for evacuation of the workloads from the node.
- **Uncordon BareMetal Machine**: Allow scheduling of workloads on the specified BMM's Kubernetes node.
- **BareMetalMachine Validate**: Trigger hardware validation of a BMM.
- **BareMetalMachine Run**: Allows you to run a script specified directly in the input on the targeted BMM.
- **BareMetalMachine Run Data Extract**: Allows you to run one or more data extractions against a BMM.
- **BareMetalMachine Run Read-only**: Allows you to run one or more read-only commands against a BMM.

> [!NOTE]
> You can't create or delete BMMs directly. These machines are created only as the realization of the Azure Local cluster lifecycle. Implementation blocks creation or deletion requests from any user, and it allows only internal/application-driven creation or deletion operations.

## FAQ

This section answers common questions about BMM roles.

### How do machine roles work?

Kubernetes labels are applied to BMM resources during the multi-rack cluster deployments of Azure Local. The `machineRoles` property is derived from the Kubernetes labels applied to the BMM resource.

### How to determine the BareMetal Machine role?

In any standard multi-rack cluster with three or more compute racks, there are three powered-on control plane nodes.
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