---
title: Operator Nexus rack resiliency
description: Document how rack resiliency works in Operator Nexus
ms.topic: concept-article
ms.date: 06/24/2026
author: santhosh-kumar-cm
ms.author: sacm
ms.service: azure-operator-nexus
---

# Ensuring control plane resiliency with Operator Nexus Service

The Nexus service is engineered to uphold control plane resiliency across various compute rack configurations.

## Instances with three or more compute racks

Operator Nexus ensures the availability of three active Kubernetes control plane (KCP) servers in instances with three or more compute racks. It strategically distributes these roles across different racks to guarantee control plane resiliency.

> [!TIP]
> The Kubernetes control plane is a set of components that manage the state of a Kubernetes cluster, schedule workloads, and respond to cluster events. It includes the API server, etcd storage, scheduler, and controller managers.
>
> The remaining management servers contain various operators that run the platform software and other components that perform support capabilities for monitoring, storage, and networking.
>
> Auto-remediation actions on control plane servers maintain the health and availability of the Kubernetes management layer. These actions on the control plane are strictly isolated to the platform’s management infrastructure and don't interact with compute servers or customer workloads. Applications and services running on compute servers continue to operate normally during control plane remediation events, ensuring runtime stability and uninterrupted service.

During runtime upgrades, Operator Nexus implements a sequential upgrade of the control plane servers. The sequential server approach preserves resiliency throughout the upgrade.

Three compute racks:

KCP = Kubernetes Control Plane server
MGMT = Management server

| Rack 1    | Rack 2 | Rack 3 |
|-----------|--------|--------|
| KCP       | KCP    | KCP    |
| KCP-spare | MGMT   | MGMT   |

Four or more compute racks:

| Rack 1 | Rack 2 | Rack 3 | Rack 4    |
|--------|--------|--------|-----------|
| KCP    | KCP    | KCP    | KCP-spare |
| MGMT   | MGMT   | MGMT   | MGMT      |


## Spare control plane server

The spare control plane server is a critical component of Operator Nexus resiliency architecture. This server acts as a standby control plane instance that maintains cluster quorum and provides seamless failover capabilities during upgrades and failure scenarios.

In disaster situations when the control plane loses quorum, there are impacts to the Kubernetes API across the instance. This scenario can affect a workload's ability to read and write Custom Resources (CRs) and talk across racks.

### Spare server characteristics

A spare control plane server has the following characteristics:

- **Power state**: Off (powered down when not in use)
- **BMM status**: Available (ready to participate in the cluster)  
- **Ready state**: False (not currently active in the cluster)
- **Cordoned status**: Cordoned (prevented from scheduling workloads)
- **Labels**: `platform.afo-nc.microsoft.com/control-plane=true`
- **OAM IP**: Not assigned until the server is provisioned and becomes active

### How the spare server works

The spare control plane server acts as a standby that can be activated to maintain cluster quorum in several scenarios:

- **Runtime upgrades**: During cluster runtime upgrades, the spare server is the first server upgraded and provisioned, ensuring continuous control plane availability throughout the upgrade process.
- **Control plane failures**: If an active control plane server becomes unhealthy, the spare server automatically provisions to replace it and maintain quorum.
- **Maintenance operations**: When you perform maintenance on active control plane servers, the spare server provides redundancy.

### Identifying spare servers

You can identify spare control plane servers by using the Azure portal or Azure CLI:

#### Azure portal

In the Azure portal, go to your Nexus cluster's bare metal machines. From the Cluster resource, under **Workloads** > **Compute Servers**, you can see the spare control plane server with these properties:

- Power state: Off
- Detailed status: Available
- Machine roles: control-plane

![Compute spare control plane server](media/compute-spare-control.png)

#### Azure CLI

Use the following command to list control plane servers and identify the spare:

```azurecli
az networkcloud baremetalmachine list \
  -g <resource-group> \
  --subscription <subscription> \
  --output table
```

You can identify the spare server by looking for these attributes: `powerState: Off`, `detailedStatus: Available`, and `machineRoles: control-plane`.

### Spare server provisioning and lifecycle

#### Initial setup

- **BIOS configuration**: Matches the server configuration at the time of initial deployment
- **Operating system**: Not loaded initially; the server remains unprovisioned until needed.
- **RAID configuration**: Matches the state of the server at the version it was running at deployment
- **Firmware**: Initially matches the deployment version (typically N-1 version following an upgrade)

#### Activation process

When a spare server needs to become active:

1. The server powers on automatically.
2. The operating system is provisioned with the current cluster runtime version
3. Kubernetes control plane components are deployed and configured
1. The server joins the active control plane cluster.
5. An OAM IP address is assigned

The spare control plane server's firmware updates when the server becomes active, such as during runtime upgrades. This process ensures firmware compatibility while minimizing unnecessary updates to inactive servers.

### Transition to active control plane

A spare control plane server becomes an active control plane server through several mechanisms:

- **Automated upgrade process**: During runtime upgrades, orchestrated by the upgrade workflow
- **Machine Health Check (MHC)**: Automatic replacement of failed active control plane servers
- **Manual intervention**: Replace or reimage operations on active control plane servers might trigger spare activation

For detailed information about these processes, see the [Automated remediation](#automated-remediation) section in this document.

## Automated remediation

Operator Nexus continuously monitors the health of all servers (Compute, Management Plane, and Kubernetes Control Plane) and automatically remediates issues when specific conditions are detected. The goal is to maintain cluster stability and control plane quorum without operator intervention.

### Triggers for automated remediation

The conditions that trigger automated remediation differ by server role type:

| Trigger                                                   | Compute | Management Plane | Control Plane (KCP) |
|-----------------------------------------------------------|:-------:|:----------------:|:-------------------:|
| Server fails to provision within the expected timeframe   |   Yes   |       Yes        |         Yes         |
| Kubernetes node Ready condition is Unknown for 30 minutes |   No    |       Yes        |         Yes         |

> [!NOTE]
> Provisioning failures are detected through dynamic per-phase monitoring rather than a single fixed timeout. The system tracks each stage of the provisioning process and detects stalls at any phase.

### Remediation process

The system performs remediation actions sequentially. If an action doesn't resolve the issue, the system escalates to the next step. The available actions differ by server type:

| server type         | Step 1      | Step 2      | Final step     |
|---------------------|-------------|-------------|----------------|
| Compute             | Reprovision | —           | Mark Unhealthy |
| Management Plane    | Reboot      | Reprovision | Mark Unhealthy |
| Control Plane (KCP) | Reboot      | —           | Mark Unhealthy |

**Key behaviors:**

- **Compute servers** skip the reboot step because remediation only triggers on provisioning failures, where a reboot wouldn't help.
- **Control Plane servers** skip reprovisioning because potential loss of quorum is too critical to wait for a reprovision attempt. Instead, the system escalates directly to marking the server unhealthy and triggering a role swap with a healthy Management Plane server.
- **Reprovision** is a single attempt. If it fails, the system doesn't retry indefinitely - it escalates to mark the server unhealthy.
- **Disabling compute reprovision**: Operators can optionally disable the reprovision step for compute servers. When disabled, the system escalates directly from a provisioning failure to marking the server unhealthy.

### Safeguards

- If an individual server was recently reprovisioned and fails again shortly after, the system considers remediation to be unsuccessful, and continues to the next remediation step.
- The system suspends remediation while a user-initiated disruptive action (such as BMM Replace, Reimage, Restart, or Power Off) is in progress. This step prevents race conditions and conflicts between automated remediation and the user's operation.

### Mark Unhealthy outcome

When you mark a Bare Metal Machine as unhealthy:

- The process updates the BMM's `detailedStatusMessage` to: `Warning: BMM Node is unhealthy and may require hardware replacement.`
- The process removes the server from the Kubernetes cluster, which triggers a node drain.
- The process powers off the Bare Metal Machine.
- **User action required**: Run a BMM Replace action to return the machine into service and have it rejoin the cluster.

> [!TIP]
> The `detailedStatusMessage` value is an alertable signal. You can configure Azure Monitor alerts on this property to be notified when a machine requires manual intervention. For troubleshooting guidance, see [Troubleshoot BMM Warning messages](./troubleshoot-bare-metal-machine-warning.md#warning-bmm-node-is-unhealthy-and-may-require-hardware-replacement).

### Monitoring remediation activity

Automated remediation emits customer-visible logs in the **Platform Operation Logs** category each time a remediation strategy starts, completes, or fails. These logs are prefixed with `Machine Health Check Remediation:` and include the name of the affected server.

Example log messages:

| Event              | Example message                                                                                                                         |
|--------------------|-----------------------------------------------------------------------------------------------------------------------------------------|
| Strategy starts    | `Machine Health Check Remediation: starting reboot strategy for BareMetalHost rack1compute01`                                           |
| Strategy completes | `Machine Health Check Remediation: reprovision-in-place strategy completed for BareMetalHost rack1compute01`                            |
| Strategy fails     | `Machine Health Check Remediation: Reboot strategy failed for BareMetalHost rack1compute01: timeout waiting for host to become healthy` |

To receive and configure these logs, see [List of logs available for streaming](./list-logs-available.md).

### KCP remediation details

When a KCP server fails remediation and is marked unhealthy, the server is deprovisioned. The unhealthy KCP server is exchanged with a suitable healthy Management Plane server. This Management Plane server becomes the new KCP server. The failed KCP server is updated and labeled as a Management Plane server. Once the label changes, an attempt to provision the newly labeled Management Plane server occurs. If it fails to provision, the Management Plane remediation process takes over. If it fails provisioning or doesn't run successfully, the machine's status remains unhealthy, and the user must fix the server. The unhealthy condition surfaces to the Bare Metal Machine's (BMM) `detailedStatus` and `detailedStatusMessage` fields in Azure and clears through a BMM Replace action.

Only one KCP role swap can be in progress at a time. If a swap is already underway, additional remediation requests wait until the active swap completes before proceeding.

## Related links

[Determining Control Plane Role](./reference-near-edge-baremetal-machine-roles.md)

[Troubleshooting failed Control Plane Quorum](./troubleshoot-control-plane-quorum.md)
