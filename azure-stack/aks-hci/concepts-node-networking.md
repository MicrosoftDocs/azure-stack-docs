---
title: Concepts - Node virtual machine networking in Azure Kubernetes Services (AKS) on Azure Stack HCI
description: Learn about virtual machine networking in Azure Kubernetes Service (AKS) on Azure Stack HCI, including static IP and DHCP networking and load balancers.
ms.topic: conceptual
ms.date: 03/04/2021
ms.custom: fasttrack-edit
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: mikek
author: mattbriggs
---

---
# Network concepts for deploying Azure Kubernetes Service (AKS) nodes on Azure Stack HCI

There are two IP address assignment models to choose from, depending on the AKS on Azure Stack HCI networking architecture you choose to use. 

> [!NOTE]
> The virtual networking architecture defined here for AKS on Azure Stack HCI deployments could be different from the underlying physical networking architecture in a data center.

- Static IP networking - The virtual network allocates static IP addresses to the Kubernetes cluster API server, Kubernetes nodes, underlying VMs, load balancers, and any Kubernetes services that run on top of the cluster.

- DHCP networking - The virtual network allocates dynamic IP addresses to the Kubernetes nodes, underlying VMs, and load balancers using a DHCP server. The Kubernetes cluster API server, and any Kubernetes services you run on top of your cluster, are still allocated static IP addresses.

## Virtual IP pool

Virtual IP (VIP) pool is set of IP addresses that are mandatory for any AKS on Azure Stack HCI deployment. The VIP pool is a range of reserved IP addresses used for allocating IP addresses to the Kubernetes cluster API server and for Kubernetes services to guarantee that your applications are always reachable. Irrespective of the virtual networking model and the address assignment model you choose, you must provide a VIP pool for your AKS host deployment.

The number of IP addresses in the VIP pool depends on the number of workload clusters and Kubernetes services planned for your deployment.

Depending on your networking model, the VIP pool definition will differ in the following ways:

- Static IP - If you're using static IP, make sure your virtual IP addresses are from the same subnet provided.
- DHCP - If your network is configured with DHCP, you will need to work with your network administrator and exclude the VIP pool IP range from the DHCP scope used for the AKS on Azure Stack HCI deployment.

## Kubernetes node VM IP pool

Kubernetes nodes are deployed as specialized virtual machines in an AKS on Azure Stack HCI deployment. AKS on Azure Stack HCI allocates IP addresses to these virtual machines to enable communication between Kubernetes nodes.

- Static IP - You must specify a Kubernetes node VM IP pool range. The number of IP addresses in this range depends on the total number of Kubernetes nodes you plan to deploy across your AKS host and workload Kubernetes clusters. You should take into account that updates will consume one to three additional IP addresses during the update.
- DHCP - You do not need to specify a Kubernetes node VM pool as IP addresses to the Kubernetes nodes are dynamically allocated by the DHCP server on your network.

## Virtual network with static IP networking (Recommended)

This networking model creates a virtual network that allocates IP addresses from a statically defined address pool to all objects in your deployment. An added benefit of using static IP networking is that long-lived deployments and application workloads are guaranteed to always be reachable.

Specify the following parameters while defining a virtual network with static IP configurations:

> [!Important]
> In this version of AKS on Azure Stack HCI, it is not possible to change the network configuration once the AKS host or the workload cluster are deployed. The only way to change the networking settings is to start fresh by removing the workload cluster(s) and uninstall AKS on Azure Stack HCI.

- Name: The name of your virtual network.
- Address prefix: The IP address prefix to use for your subnet.
- Gateway: The IP address of the default gateway for the subnet.
- DNS server: An array of IP addresses pointing to the DNS servers to be used for the subnet. A minimum of one and a maximum of three servers can be provided.
- Kubernetes node VM pool: A continuous range of IP addresses to be used for your Kubernetes node VMs.
- Virtual IP pool: A continuous range of IP addresses to be used for your Kubernetes cluster API server and Kubernetes services.

  > [!Note]
  > The VIP pool must be part of the same subnet as the Kubernetes node VM pool.

- vLAN ID: The vLAN ID for the virtual network. If omitted, the virtual network will not be tagged.

## Virtual network with DHCP networking

This networking model creates a virtual network that allocates IP addresses using DHCP to all objects in the deployment.  

You must specify the following parameters while defining a virtual network with static IP configurations:

> [!Important]
> In this version of AKS on Azure Stack HCI, it is not possible to change the network configuration once the AKS host or the workload cluster are deployed. The only way to change the networking settings is to start fresh by removing the workload cluster(s) and uninstall AKS on Azure Stack HCI.

- Name: The name of your virtual network.
- Virtual IP pool: The continuous range of IP addresses to be used for your Kubernetes cluster API server and Kubernetes services. 

  > [!Note]
  > The VIP pool addresses need to be in the same subnet as the DHCP scope and have to be excluded from the DHCP scope to avoid address conflicts.

- vLAN ID: The vLAN ID for the virtual network. If omitted, the virtual network will not be tagged.

## Microsoft On-premises Cloud service

Microsoft On-premises Cloud (MOC) is the management stack that enables virtual machines on Azure Stack HCI and Windows Server-based SDDC to be managed in the cloud. MOC consists of:

- A single instance of a highly available `cloud agent` service deployed in the cluster. This agent runs on any one node in the Azure Stack HCI cluster and is configured to fail over to another node.
- A `node agent` running on every Azure Stack HCI physical node. 

To enable communication with MOC, you need to provide the IP Address CIDR to be used for the service. The `-cloudserviceCIDR` is a parameter in the [`Set-AksHciConfig`](./reference/ps/set-akshciconfig.md) command that's used to assign the IP address to the cloud agent service and enable high availability of the cloud agent service.

The choice of an IP address for the MOC service depends on the underlying networking model used by your Azure Stack HCI cluster deployment.

> [!Note]
> The IP address allocation for the MOC service is independent of your Kubernetes virtual network model. The IP address allocation is dependent on the underlying physical network, and the IP addresses configured for the Azure Stack HCI cluster nodes in your data center.

- **Azure Stack HCI cluster nodes with a DHCP-based IP address allocation mode**: If your Azure Stack HCI nodes are assigned an IP address from a DHCP server present on the physical network, then you do not need to explicitly provide an IP address to the MOC service as the MOC service will also receive an IP address from the DHCP server.

- **Azure Stack HCI cluster nodes with a static IP allocation model**: If your Azure Stack HCI cluster nodes are assigned static IP addresses, then you must explicitly provide an IP address for the MOC cloud service. The IP address for the MOC service must be in the same subnet as the IP addresses of Azure Stack HCI cluster nodes. To explicitly assign an IP address for MOC service, use the `-cloudserviceCIDR` parameter in the `Set-AksHciConfig` command. Make sure you enter an IP address in the CIDR format, for example: "10.11.23.45/16".

## Compare network models

Both DHCP and Static IP provide network connectivity for your AKS on Azure Stack HCI deployment. However, there are advantages and disadvantages to each. At a high level, the following considerations apply:

**DHCP**
    - Does not guarantee long-lived IP addresses for some resource types in an AKS on Azure Stack HCI deployment.
    - Supports expansion of reserved DHCP IP addresses if your deployment gets bigger than you initially anticipated.

**Static IP**
    - Guarantees long-lived IP addresses for all resources in an  AKS on Azure Stack HCI deployment.
    - Since automatic expansion of Kubernetes node IP pool is not supported, you may not be able to create new clusters if you have exhausted the Kubernetes node IP pool.

The following table compares IP address allocation for resources between static IP and DHCP networking models:

| Capability| Static IP | DHCP |
|-----------|-----------|-----------|
| Kubernetes cluster API server| Assigned statically using VIP pool | Assigned statically using VIP pool |
| Kubernetes nodes (on virtual machines) | Assigned using Kubernetes node IP pool | Assigned dynamically |
| Kubernetes services | Assigned statically using VIP pool | Assigned statically using VIP pool |
| HAProxy load balancer VM | Assigned using Kubernetes node IP pool | Assigned dynamically |
| Microsoft On-Premise Cloud Service | Depends on the physical networking configuration for Azure Stack HCI cluster nodes | Depends on the physical networking configuration for Azure Stack HCI cluster nodes |
| VIP pool | Mandatory | Mandatory |
| Kubernetes node VM IP pool | Mandatory | Not Supported |

## Minimum IP address reservations for an AKS on Azure Stack HCI deployment

Irrespective of your deployment model, the number of IP addresses reserved remains the same. This section talks about the number of IP addresses to reserve based on your AKS on Azure Stack HCI deployment model.

### Minimum IP address reservation

At a minimum, you should reserve the following number of IP addresses for your deployment:

| Cluster type  | Control plane node | Worker node | For update operations | Load balancer  |
| ------------- | ------------------ | ---------- | ----------| -------------|
| AKS Host |  1 IP |  NA  |  2 IP |  NA  |
| Workload cluster  |  1 IP per node  | 1 IP per node |  5 IP  |  1 IP |

Additionally, you should reserve the following number of IP addresses for your VIP pool:

| Resource type  | Number of IP addresses |
| ------------- | ------------------|
| Cluster API server |  1 per cluster |
| Kubernetes Services  |  1 per service  |
| Application Services | 1 per service planned |

As you can see, the number of required IP addresses is variable depending on the AKS on Azure Stack HCI architecture, and the number of services you run on your Kubernetes cluster. We recommend reserving a minimum of 256 IP addresses (/24 subnet) for your deployment.

### Walking through an example deployment

Jane is an IT administrator just starting with AKS on Azure Stack HCI. She wants to deploy two Kubernetes clusters - Kubernetes cluster A and Kubernetes cluster B on her Azure Stack HCI cluster. She also wants to run a voting application on top of her cluster. This application has three instances of the front-end UI running across the two clusters and one instance of the backend database.

- Kubernetes cluster A has 3 control plane nodes and 5 worker nodes
- Kubernetes cluster B has 1 control plane node and 3 worker nodes
- 3 instances of the front-end UI (port 443)
- 1 instance of the backend database (port 80)

Based on the table above, she will have to reserve:

- 3 IP addresses for the AKS host (one IP for control plane node and two IPs for running update operations)
- 3 IP addresses for the control plane nodes in cluster A (one IP per control plane node)
- 5 IP addresses for the worker nodes in cluster A (one IP per worker node)
- 6 IP addresses additionally for cluster A (five IPs for running update operations and 1 IP for load balancer)
- 1 IP addresses for the control plane nodes in cluster B (one IP per control plane node)
- 3 IP addresses for the worker nodes in cluster B (one IP per worker node)
- 6 IP addresses additionally for cluster B (five IPs for running update operations and 1 IP for load balancer)
- 2 IP addresses for the Kubernetes cluster API servers (one IP per Kubernetes cluster)
- 3 IP addresses for the Kubernetes service (one IP address per instance of the front-end UI, since they all use the same port. The backend database can use any one of the three IP addresses as long as it will use a different port)

As explained above, Jane requires a total of 32 IP addresses to deploy the cluster. Jane should therefore reserve a /26 subnet for her virtual network. 

### Splitting reserved IP addresses based on a static IP network model

While the total number of reserved IP addresses remains the same, the deployment model determines how these IP addresses are divided among IP groups. As discussed before, the static IP network model has two IP pools:

- **Kubernetes node VM IP pool** - for Kubernetes node VMs and the load balancer VM. This IP pool also includes the IP address required for running update operations.
- **Virtual IP pool** - for the Kubernetes API server and Kubernetes services.

Working with the example above, Jane must further divide these IP addresses across VIP pools and Kubernetes node IP pools:

- 5 (two for Kubernetes cluster API server and three for Kubernetes services) out of the 32 IP addresses for her VIP pool.
- 27 (all the IP addresses for her Kubernetes nodes and underlying VMs, the load balancer VMs, and update operations) for her Kubernetes node IP pool.

### Splitting reserved IP addresses based on a DHCP network model

While the total number of reserved IP addresses remain the same, the deployment model determines how these IP addresses are divided among IP group(s). As discussed before, the DHCP network model has one IP scope:

- **Virtual IP pool** - for the Kubernetes API server and Kubernetes services

Working with the example above:

- Jane must reserve a total of 32 IP addresses or a /26 subnet on her DHCP server. 
- She must exclude 5 (two for Kubernetes cluster API server and three for Kubernetes services) from the DHCP scope of 32 IP addresses for her VIP pool.

## Ingress controllers

During deployment of a target cluster, a `HAProxy`-based load balancer resource is created. The load balancer is configured to distribute traffic to the pods in your service on a given port. The load balancer only works at layer 4 that means the Service is unaware of the actual applications, and it can't make any additional routing considerations.

Ingress controllers work at layer 7 and can use more intelligent rules to distribute application traffic. A common use of an Ingress controller is to route HTTP traffic to different applications based on the inbound URL.

![Diagram showing Ingress traffic flow in an AKS-HCI cluster](media/net/aks-ingress.png)

## Next steps
This article covers some of the networking concepts for deploying AKS nodes on Azure Stack HCI. For more information on AKS on Azure Stack HCI concepts, see the following articles:

- [Container networking concepts](./concepts-container-networking.md)
- [Cluster and workloads](./kubernetes-concepts.md)
- [Deploy a Kubernetes workload cluster](./kubernetes-walkthrough-powershell.md)
