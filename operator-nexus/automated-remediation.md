---
title: Automated remediation in Azure Operator Nexus
description: Learn how automated remediation maintains cluster health for control plane, management, and compute nodes in Azure Operator Nexus.
ms.topic: conceptual
ms.date: 12/18/2025
author: sanjaykumaran
ms.author: sanjaykumaran
ms.service: azure-operator-nexus
---

# Automated remediation

To maintain Kubernetes control plane (KCP) quorum, Operator Nexus provides automated remediation when specific server issues are detected. Additionally, this automated remediation extends to Management Plane & Compute nodes.

Here are the triggers for automated remediation:

- For all servers (Compute, Management and KCP): if a server fails to provision successfully after six hours, automated remediation occurs. This check includes provisioning a new machine at initial deployment time or provisioning during a Replace action.
- For all servers (Compute, Management and KCP): if a running node is stuck in a read only root file system mode for 10 minutes, automated remediation occurs, deprecated in 2510.
- For KCP and Management Plane servers only, if a Kubernetes node is in an Unknown state for 30 minutes, automated remediation occurs.

## Remediation process

- Remediation of a Compute node is now one reprovisioning attempt. If the reprovisioning fails, the node is marked Unhealthy. Reprovisioning no longer continues to retry infinitely, and the Bare Metal Machine is powered off.
- Remediation of a Management Plane node is to attempt one reboot and then one reprovisioning attempt. If those steps fail, the node is marked Unhealthy.
- Remediation of a KCP node is to attempt one reboot. If the reboot fails, the node is marked Unhealthy and Nexus triggers the immediate provisioning of the spare KCP node. This process is outlined in the [KCP remediation details](#kcp-remediation-details) section.
- In all instances, when the Bare Metal Machine is marked unhealthy, the BMM's `detailedStatusMessage` is updated to read `Warning: BMM Node is unhealthy and may require hardware replacement.` The Bare Metal Machine's node is removed from the Kubernetes Cluster, which triggers a node drain. Users need to run a BMM Replace action to return the BMM into service and have it rejoin the Kubernetes Cluster.

## KCP remediation details

Ongoing control plane resiliency requires a spare KCP node. When KCP node fails remediation and is marked Unhealthy, a deprovisioning of the node occurs. For NC 4.7.x runtimes, the unhealthy KCP node is exchanged with a suitable healthy Management Plane server. This Management Plane server becomes the new spare KCP node. The failed KCP node is updated and labeled as a Management Plane node. Once the label changes, an attempt to provision the newly labeled management plane node occurs. If it fails to provision, the management plane remediation process takes over. If it fails provisioning or doesn't run successfully, the machine's status remains unhealthy, and the user must fix. The unhealthy condition surfaces to the Bare Metal Machine's (BMM) `detailedStatus` and `detailedStatusMessage` fields in Azure and clears through a BMM Replace action.

## Related content

- [Control Plane Resiliency](./concepts-rack-resiliency.md)
- [Troubleshoot BMM Warning messages](./troubleshoot-bare-metal-machine-warning.md)
- [BMM Replace action](./howto-baremetal-functions.md)
