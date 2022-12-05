---
title: Control plane on two physical hosts deployment model availability scenarios
description: Recommended architecture for deploying an AKS hybrid cluster on a two-node Azure Stack HCI system
author: sethmanheim
ms.author: sethm
ms.topic: conceptual
ms.date: 12/05/2022
---

# Control plane on two physical hosts deployment model availability scenarios

> Applies to: XXX

This article describes the recommended architecture for deploying an AKS hybrid cluster on a two-node Azure Stack HCI cluster. The article also describes failure modes for an Azure Stack HCI system, their impact on the AKS hybrid cluster, and how AKS can recover from these failures.<!--1) VERIFY: These failure scenarios are specific to an AKS hybrid cluster deployed on a 2-node HCI cluster - or are they generally applicable? 2) NEEDS MORE WORK to capture essence of the article.-->

## Architecture

Traditional Kubernetes deployments require three physical machines to survive a single failure. This usually means a higher Total Cost of Ownership (TCO). For cost-sensitive deployments, AKS hybrid can be deployed on a two-node Azure Stack HCI system, as shown below, with a few trade-offs in availability.  

:::image type="content" source="media/deploy-cluster-on-two-node-hci/hci-two-node-architecture.png" alt-text="Illustration showing architecture of an AKS cluster that runs on a two-node Azure Stack HCI cluster" border="false":::<!--1) PLACEHOLDER GRAPHIC: Need PNG original. 2) EDIT GRAPHIC FOR CONSISTENCY. Azure Stack HCI diagrams don't refer to the Kubernetes user cluster - just workload clusters. Standardize labeling.-->

For more information on architecture, cluster deployment strategies, reliability considerations, and cost optimization for AKS, see [Azure Kubernetes Service (AKS) baseline architecture for AKS on Azure Stack HCI](/azure/architecture/example-scenario/hybrid/aks-baseline).

## Terminology

The following terminology is used in this article.

| Term | Definition |
|------|------------|
| Host | Physical ASZ host, which typically sets a quorum for control plane VMs. |  
| Guest OS | Operating system running inside the control plane virtual machines (VMs), load balancer VM, or node pool VMs. |
| Windows Server Failover Clustering (WSFC) | Provides infrastructure features that support high availability of VMs and applications. If a cluster node or service fails, the VMs or applications that are hosted on that node can be automatically or manually transferred to another available node in a process known as failover. |
| user cluster | Kubernetes clusters that are deployed by Azure Kubernetes Service (AKS) to host the containerized end-user application or workload.<!--AKS content refers strictly to "worker nodes" with no reference to Kubernetes "user nodes." Better to define "worker nodes" as "Kubernetes user nodes," and use "worker nodes" throughout.--> |
| management cluster | Provides the core orchestration mechanism and interface for deploying and managing one or more user clusters. The management cluster contains a single control plane VM. |
| load balancer | The load balancer is a single dedicated Linux VM with a load-balancing rule for the API server. |
| API server | The API server enables interaction with the Kerberos cluster. This component provides the interaction for management tools such as Windows Admin Center, PowerShell modules, and `kubectl`. |
| CRUD | Create, Read, Update, and Delete operations |

## Hardware failures on the host

The physical host that runs the VMs hosting the Kubernetes nodes might stop functioning because of hardware issues or might become network partitioned. 


| Existing workloads | CRUD on workload clusters | New workload cluster lifecycle | API server availability |
|---------------------------------|-----------------------------------------|-------------------------------------|-------------------------|
| Potential disruption, automatic recovery | Potential disruption, automatic recovery | Potential disruption, automatic recovery |Potential disruption, with automatic recovery |
| Existing workloads continue to run without disruption as long as:<br>- The worker nodes are on separate hosts.<br>- The application has defined at least two replicas with `podAntiAffinity` specified.<br><br>If an application has a dependency on an external VIP of the API, disruption occurs. | If the control plane VM of the user’s cluster resides on the host that went down, workloads will not scale. Adding new worker nodes, scaling pods, and so forth won't work. | If the control plane VM of the management cluster resides on the host that went down, new clusters can't be created, and existing clusters won't work. | If the control plane VM of the user's cluster or the load balancer VM resides on the host that went down, the API server isn't available. |
| If the worker nodes are on the same physical host, the Windows Server Failover Cluster will fail over the worker nodes on the surviving host.<br><br>If the application wasn't created with anti-affinity, Kerberos will move the pod over to the existing worker node.<br><br>If the application depends on the API server, and the control plane VM or load balancer VM of the user’s cluster goes down, the Windows Server Failover Cluster will move those VMs to the surviving<!--Find a better word.--> host, and the application will resume working. These pods may restart because of the way the application handles the loss of the API server. | Windows Server Failover Cluster will fail over the control plane VM of the user’s cluster to the healthy host. Once this is done, scaling workloads will work. | Windows Server Failover Cluster will fail over the control plane VM of the management cluster on the healthy host. Once this is done, CRUD operations on new target clusters will work. | Windows Server Failover Cluster will fail over the control plane VM of the users cluster on the healthy host. Once this is done, the API server will be available. |

## Updates

Updates of both the Azure Stack HCI stack and the AKS software stack.

| Existing workloads | CRUD on workload clusters | New workload cluster lifecycle | API server availability |
|--------------------|-----------------------------------------|---------------------------|-------------------------|
| No disruption | No disruption | No disruption | No disruption |
| Cluster Aware Updates on Azure Stack HCI live-migrates the worker nodes to the other node before rebooting. Applications aren't disrupted during this. | Cluster Aware Updates on Azure Stack HCI live-migrates the control plane VM of the user’s cluster to the other node before rebooting. Existing workloads can be scaled without disruption during an update. | Cluster Aware Updates on Azure Stack HCI are migrated to the control plane VM of the management cluster to the other node before rebooting. New workloads can be created without disruption during an update. | Cluster Aware Updates on Azure Stack HCI migrate the control plane VM of the user's cluster to the other node before rebooting. The API server cluster remains available during an update. |

## Host OS failures

The physical host which runs the VMs hosting the Kubernetes nodes might have a software issue in the OS and cause a failure.

| Existing workloads | CRUD on workload clusters | New workload cluster lifecycle | API server availability |
|--------------------|-----------------------------------------|---------------------------|-------------------------|
| Potential disruption, automatic recovery | Potential disruption, automatic recovery | Potential disruption, automatic recovery |Potential disruption, automatic recovery |
| Existing Workloads will continue to run without disruption as long as:<br>- The worker nodes are on separate hosts.<br>- The application has defined at least two replicas with `podAntiAffinity` specified.<br><br>If the application has a dependency on an external VIP of the API, there will be disruption. | If the control plane VM in the target cluster happens to reside on the host that has OS failures, adding new worker nodes, scaling pods, and so forth, won't work. | If the control plane VM in the target cluster happens to reside on the host that has OS failures, new clusters won't be created and existing clusters can't be scaled. | If the control plane VM happens to reside on the host that has OS failures, the API server won't be available. |
| If the worker nodes are on the same physical host, Windows Server Failover Clustering fails over the worker nodes on the surviving host.<br><br>If the application wasn't created with anti-affinity, Kerberos will move the pod over to the existing worker node.<br><br>If the application has a dependency on the API server, and the control plane VM or load balancer VM of the user’s cluster shuts down, Windows Server Failover Clustering moves those VMs to the surviving host, and the application will resume working. Depending on how the application handles the loss of the API server, pods may be restarted on the new host. | Windows Server Failover Clustering fails over the control plane VM of the user’s cluster on the healthy host. After failover, workloads can be scaled. | Windows Server Failover Clustering fails over the control plane VM of the management cluster on the healthy host. After failover, CRUD operations on new target clusters will work. | Windows Server Failover Clustering restarts the control plane VM of the user’s cluster on the healthy host. After that, the API server is available. |

## Management plane VM failure

Control plane VM of the management cluster might get deleted unexpectedly, or the boot disk might get corrupted. Also, the control plane VM of the management cluster might not boot because of OS issues.

| Existing workloads | CRUD on workload clusters | New workload cluster lifecycle | API server availability |
|--------------------|-----------------------------------------|---------------------------|-------------------------|
| No disruption | Disruption, manual recovery | Disruption, manual recovery | No disruption |
| Existing workloads continue to run if the management cluster VM fails. | Worker nodes can't be added to scale the application. | Workload creation won't succeed while the management cluster is down. | The API server should remain available in case the management cluster VM fails. |
| Not applicable | If Windows Server Failover Clustering can recover from the error, it will try to restart the management plane VM on a different host. If Windows Server Failover Clustering can't recover the VM, the management cluster must be rebuilt manually. For more information, see see [Back up and restore workload clusters](backup-workload-cluster.md). | If Windows Failover Clustering can recover from the error, it will try to restart the management plane VM on a different host. If Windows Server Failover Clustering can't recover the VM, the management cluster must be rebuilt manually. For instructions, see [Back up and restore workload clusters](backup-workload-cluster.md). | Not applicable |
| Not applicable | If Windows Server Failover Clustering can recover from the error, it will try to restart the management plane VM on a different host. If Windows Server Failover Clustering can't recover the VM, the management cluster must be rebuilt manually. For instructions, see [Back up and restore workload clusters](backup-workload-cluster.md). | If Windows Server Failover Clustering can recover from the error, it will try to restart the management plane VM on a different host. If Windows Server Failover Clustering can't recover the VM, the management cluster must be rebuilt manually. For instructions, see [Back up and restore workload clusters](backup-workload-cluster.md). | Not applicable |

## Control plane VM failure

Control plane VM of the user’s cluster might get deleted unexpectedly, the boot disk might get corrupted, or the VM might not start because of OS issues.

| Existing workloads | CRUD on workload clusters | New workload cluster lifecycle | API server availability |
|--------------------|-----------------------------------------|---------------------------|-------------------------|
| No disruption | Disruption, manual recovery | No disruption | Disruption, manual recovery |
| Existing Workloads will continue to run without disruption.<br><br>If the application has a dependency on an external VIP of the API or liveness probe using the clusters VIP, there will be application downtime.<!--What is "a dependency ... on the liveness probe using the clusters VIP"--> | Workloads can't be scaled while the control plane VM is in a failed state. Worker nodes can't be added, and pods can't be scaled. | Workload creation will succeed while the control plane VM is down. | The API server isn't available when the control plane VM is in a failed state. |
| Not applicable | If Windows Server Failover Clustering can recover from the error, it will try to restart the control plane VM on a different host. If Windows Server Failover Clustering can't recover the VM, the control plane VM must be rebuilt manually. For instructions, see [Back up and restore workload clusters](backup-workload-cluster.md). | Not applicable | If Windows Server Failover Clustering can recover from the error, it will try to restart the control plane VM on a different host. If Windows Server Failover Clustering can't recover the VM, the control plane VM must be rebuild manually.  For instructions, see [Back up and restore workload clusters](backup-workload-cluster.md). |

## Node pool (worker nodes) VM failure

The VMs hosting the Kubernetes nodes get deleted unexpectedly, or the boot disk might get corrupted. Also, worker node VMs might not boot because of OS issues.

| Existing workloads | CRUD on workload clusters | New workload cluster lifecycle | API server availability |
|--------------------|-----------------------------------------|---------------------------|-------------------------|
| Potential disruption, manual recovery | No disruption | No disruption | No disruption |
| Existing workloads will continue to run without disruption as long as:<br>- The worker nodes are on separate hosts.<br>- The application has defined at least two replicas with `podAntiAffinity` specified. | Worker nodes can be added.<br>Pod scheduling succeeds if the remaining nodes have enough capacity. | Workload creation will succeed. | The API server remains available in case there is a single worker VM failure. |
| If Windows Server Failover Cluster can recover from the error, it will attempt to restart the control plane VM on a different host. If Windows Server Failover Clustering can't recover the VM, worker nodes must be recreated manually.  | Not applicable | Not applicable | Not applicable |

## Load balancer VM failure

Load balancer VM might get deleted unexpectedly, the boot disk might get corrupted, or the VM might not boot because of OS issues.

| Existing workloads | CRUD on workload clusters | New workload cluster lifecycle | API server availability |
|--------------------|-----------------------------------------|---------------------------|-------------------------|
| Potential disruption, automatic recovery | Disruption, manual recovery | No disruption | Disruption, manual recovery |
| If an application has a dependency on an external VIP of the API or liveness probe using the clusters VIP, there will be application downtime.<br><br>If Windows Server Failover Clustering can recover from the error, it will attempt to restart the load balancer VM on a different host. If Windows Server Failover Cluster can't recover the VM, the control plane VM must be rebuild manually. See the document for manual rebuild here.| Workloads cannot be scaled while Load Balancer VM has failed - adding new worker nodes, scaling pods etc will not work.<br><br>If this is an error which Windows Failover Clustering can recover from, it will attempt to restart the LoadBalancer VM on a different host. If Windows Failover Server Clustering cannot recover the VM, Control Plane VM will need to be rebuild manually. For instructions, see [Back up and restore workload clusters](backup-workload-cluster.md). | Workload creation will succeed. | The API server remains unavailable while the load balancer VM is down.<br><br>If Windows Server Failover Clustering can recover from the error, it attempts to restart the load balancer VM on a different host. If Windows Failover Server Clustering can't recover the VM, the control plane VM must be rebuilt manually. For instructions, see [Back up and restore workload clusters](backup-workload-cluster.md). |

## Next steps

- [Learn more about AKS baseline architecture, cluster deployment strategies, and reliability and pricing considerations](/azure/architecture/example-scenario/hybrid/aks-baseline)
- [Plan your architecture](/azure/architecture/framework/)
- Use the [Azure Pricing Calculator](https://azure.microsoft.com/en-us/pricing/calculator/) to calculate costs
