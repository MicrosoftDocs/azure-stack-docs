---
title: Operator Nexus rack resiliency
description: Document how rack resiliency works in Operator Nexus
ms.topic: article
ms.date: 12/18/2025
author: eak13
ms.author: matthewernst
ms.service: azure-operator-nexus
---

# Ensuring control plane resiliency with Operator Nexus Service

The Nexus service is engineered to uphold control plane resiliency across various compute rack configurations.

## Instances with three or more compute racks

Operator Nexus ensures the availability of three active Kubernetes control plane (KCP) nodes in instances with three or more compute racks. These nodes are strategically distributed across different racks to guarantee control plane resiliency, when possible.

> [!TIP]
> The Kubernetes control plane is a set of components that manage the state of a Kubernetes cluster, schedule workloads, and respond to cluster events. It includes the API server, etcd storage, scheduler, and controller managers.
>
> The remaining management nodes contain various operators that run the platform software and other components performing support capabilities for monitoring, storage, and networking.
>
> Auto-remediation actions on control plane servers are designed to maintain the health and availability of the Kubernetes management layer. These actions on the control plane are strictly isolated to the platform’s management infrastructure and do not interact with compute nodes or customer workloads. Applications and services running on compute nodes continue to operate normally during control plane remediation events, ensuring runtime stability and uninterrupted service.

During runtime upgrades, Operator Nexus implements a sequential upgrade of the control plane nodes. The sequential node approach preserves resiliency throughout the upgrade.

Three compute racks:

KCP = Kubernetes Control Plane Node
MGMT = Management Node Pool Node

| Rack 1    | Rack 2 | Rack 3 |
| --------- | ------ | ------ |
| KCP       | KCP    | KCP    |
| KCP-spare | MGMT   | MGMT   |

Four or more compute racks:

| Rack 1 | Rack 2 | Rack 3 | Rack 4    |
| ------ | ------ | ------ | --------- |
| KCP    | KCP    | KCP    | KCP-spare |
| MGMT   | MGMT   | MGMT   | MGMT      |


## Spare control plane node

The spare control plane node is a critical component of Operator Nexus resiliency architecture. This node serves as a standby control plane instance that maintains cluster quorum and provides seamless failover capabilities during upgrades and failure scenarios.

In disaster situations when the control plane loses quorum, there are impacts to the Kubernetes API across the instance. This scenario can affect a workload's ability to read and write Custom Resources (CRs) and talk across racks.

### Spare node characteristics

A spare control plane node has the following characteristics:

- **Power state**: Off (powered down when not in use)
- **BMM status**: Available (ready to participate in the cluster)  
- **Ready state**: False (not currently active in the cluster)
- **Cordoned status**: Cordoned (prevented from scheduling workloads)
- **Labels**: `platform.afo-nc.microsoft.com/control-plane=true`
- **OAM IP**: Not assigned until the node is provisioned and becomes active

### How the spare node works

The spare control plane node acts as a standby that can be activated to maintain cluster quorum in several scenarios:

- **Runtime upgrades**: During cluster runtime upgrades, the spare node is the first to be upgraded and provisioned, ensuring continuous control plane availability throughout the upgrade process
- **Control plane failures**: If an active control plane node becomes unhealthy, the spare node can be automatically provisioned to replace it and maintain quorum
- **Maintenance operations**: When performing maintenance on active control plane nodes, the spare provides redundancy

### Identifying spare nodes

You can identify spare control plane nodes using the Azure portal or Azure CLI:

#### Azure portal

In the Azure portal, navigate to your Nexus cluster's bare metal machines, from the Cluster resource under Workloads > Compute Servers. The spare control plane node appears with:

- Power state: Off
- Detailed status: Available
- Machine roles: control-plane

![Compute spare control plane node](media/compute-spare-control.png)

#### Azure CLI

Use the following command to list control plane nodes and identify the spare:

```azurecli
az networkcloud baremetalmachine list \
  -g <resource-group> \
  --subscription <subscription> \
  --output table
```

You can identify the spare node by looking for these attributes: `powerState: Off`, `detailedStatus: Available`, and `machineRoles: control-plane`.

### Spare node provisioning and lifecycle

#### Initial setup

- **BIOS configuration**: Matches the server configuration at the time of initial deployment
- **Operating system**: Not loaded initially; the node remains unprovisioned until needed  
- **RAID configuration**: Matches the state of the server at the version it was running at deployment
- **Firmware**: Initially matches the deployment version (typically N-1 version following an upgrade)

#### Activation process

When a spare node needs to become active:

1. The node is powered on automatically
2. The operating system is provisioned with the current cluster runtime version
3. Kubernetes control plane components are deployed and configured
4. The node joins the active control plane cluster
5. An OAM IP address is assigned

The spare control plane node's firmware is updated when the node becomes active, such as during runtime upgrades. This process ensures firmware compatibility while minimizing unnecessary updates to inactive nodes.

### Transition to active control plane

A spare control plane node can become an active control plane node through several mechanisms:

- **Automated upgrade process**: During runtime upgrades, orchestrated by the upgrade workflow
- **Machine Health Check (MHC)**: Automatic replacement of failed active control plane nodes
- **Manual intervention**: Replace or reimage operations on active control plane nodes may trigger spare activation

For detailed information about these processes, see [Automated remediation](./automated-remediation.md).

> [!NOTE]
>The provisioning retry process doesn't execute on compute and management node pool nodes for systems running the 4.1 NetworkCloud runtime. This capability is available when the Nexus Cluster is updated to the 4.4 runtime.

## Related links

[Determining Control Plane Role](./reference-near-edge-baremetal-machine-roles.md)

[Troubleshooting failed Control Plane Quorum](./troubleshoot-control-plane-quorum.md)
