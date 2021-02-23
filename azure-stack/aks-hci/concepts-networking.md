---
title: Concepts - Networking in Azure Kubernetes Services (AKS) on Azure Stack HCI
description: Learn about networking in Azure Kubernetes Service (AKS) on Azure Stack HCI, including static IP and DHCP networking and load balancers.
author: abha
ms.topic: conceptual
ms.date: 02/17/2021
ms.author: abha
ms.custom: fasttrack-edit

---

# Network concepts for deploying Azure Kubernetes Service (AKS) on Azure Stack HCI

In a container-based microservices approach to application development, application components must work together to process their tasks. Kubernetes provides various resources that enable this application communication. You can connect to and expose applications internally or externally. To build highly available applications, you can load balance your applications. 

This article introduces the core concepts that provide networking to your applications in AKS on Azure Stack HCI. Then, it walks you through different deployment models and examples on setting the best networking infrastructure for your on-premises AKS deployment.

## Kubernetes on Azure Stack HCI basics

To allow access to your applications, or for application components to communicate with each other, Kubernetes provides an abstraction layer to virtual networking. Kubernetes nodes are connected to a virtual network and can provide inbound and outbound connectivity for pods. The *kube-proxy* component runs on each node to provide these network features.

In Kubernetes, *services* logically group pods to allow for direct access via an IP address or DNS name and on a specific port. You can also distribute traffic using a *load balancer*. 

The Azure Stack HCI platform also helps to simplify virtual networking for AKS on Azure Stack HCI clusters. When you create a cluster on AKS on Azure Stack HCI, an underlying `HAProxy` load balancer resource is created and configured. As you build applications on top of your Kubernetes clusters, IP addresses are configured for your Kubernetes services.

## AKS on Azure Stack HCI resources 

To simplify the network configuration for application workloads, AKS on Azure Stack HCI allocates IP addresses to the following objects in a deployment: 

- **Kubernetes cluster API server** - The API server is a component of the Kubernetes control plane that exposes the Kubernetes API. The API server is the front end for the Kubernetes control plane. API servers are always allocated static IP addresses irrespective of the underlying networking model.

- **Kubernetes nodes (on virtual machines)** - A Kubernetes cluster consists of a set of worker machines, called nodes, that run containerized applications. Every cluster has at least one worker node. For an AKS on Azure Stack HCI, Kubernetes nodes run inside virtual machines. These virtual machines are created on top of your Azure Stack HCI cluster. 

- **Kubernetes services** - In Kubernetes, *Services* logically group pods to allow for direct access via an IP address or DNS name and on a specific port. You can also distribute traffic using a *load balancer*. Kubernetes services are always allocated static IP addresses irrespective of the underlying networking model.

- **HAProxy load balancers** - HAProxy (High Availability Proxy) is a TCP/HTTP load balancer and proxy server that allows a webserver to spread incoming requests across multiple endpoints. Every workload cluster in AKS-HCI has a HAProxy load balancer running inside its own specialized virtual machine.

- **Microsoft On Premise Cloud Service** - This is the Azure Stack HCI cloud provider for running Kubernetes on an on-premises Azure Stack HCI cluster. The networking model followed by your Azure Stack HCI cluster determines the IP address allocation method for this object.


## Virtual networks

In AKS on Azure Stack HCI, virtual networks are used to allocate IP addresses to the Kubernetes resources that require them, as listed above. There are two networking models to choose from, depending on your desired AKS on Azure Stack HCI networking architecture. Note that the virtual networking architecture defined here for your AKS on Azure Stack HCI deployments is different from the underlying physical networking architecture in your datacenter.

- Static IP networking - The virtual network allocates static IP addresses to the Kubernetes cluster API server, Kubernetes nodes, underlying VMs, load balancers and any Kubernetes services you run on top of your cluster.

- DHCP networking - The virtual network allocates dynamic IP addresses to the Kubernetes nodes, underlying VMs and load balancers using a DHCP server. The Kubernetes cluster API server and any Kubernetes services you run on top of your cluster are still allocated static IP addresses.

### Virtual IP Pool
Virtual IP (VIP) pool is mandatory for an AKS on Azure Stack HCI deployment. VIP pool is a range of reserved static IP addresses that are used for allocating IP addresses to the Kubernetes cluster API server and external IPs for Kubernetes services to guarantee that your applications are always reachable. Irrespective of your virtual networking model, you must provision a VIP pool for your AKS host deployment. The number of IP addresses in the VIP pool depends on the number of workload clusters and Kubernetes services running in your deployment, for both static and DHCP networking models. However, VIP pool differs in the following ways depending on your networking model:

- Static IP - If you're using static IP, make sure your virtual IPs are from the same subnet. 
- DHCP - If your network is configured with DHCP, you will need to work with your network administrator and reserve an IP range to use for the VIP Pool.

### Kubernetes node IP pool
As explained above, Kubernetes nodes run on specialized virtual machines in an AKS on Azure Stack HCI deployment. AKS on Azure Stack HCI allocates IP addresses to these virtual machines in order to communicate between Kubernetes nodes. For a DHCP networking model, you dont need to specify a Kubernetes Node VM Pool as IP addresses to the Kubernetes nodes are dynamically allocated by the DHCP server on your network. For a static IP based networking model, you must specify a Kubernetes node IP pool range. The number of IP addresses in this range depends on the sum total number of Kubernetes nodes across your AKS host and workload Kubernetes clusters.

### Virtual network with static IP networking

This networking model creates a virtual network that allocates static IP addresses to all objects in your deployment. An added benefit of using static IP networking is that long-lived deployments and application workloads are guaranteed to always be reachable. We recommend creating a static IP virtual network model for your AKS on Azure Stack HCI deployment.

You must specify the following parameters while defining a virtual network with static IP configurations:

- Name: The name of your virtual network
- AddressPrefix: The IP address prefix to use for your subnet.
- Gateway: The IP address of the default gateway for the subnet.
- DNS server: An array of IP addresses pointing to the DNS servers to be used for the subnet. A minimum of one and a maximum of 3 servers can be provided.
- Kubernetes node IP pool: The continuous range of IP addresses to be used for your Kubernetes node VMs.
- Virtual IP pool: The continuous range of IP addresses to be used for your Kubernetes cluster API server and Kubernetes services that require an external IP address.
- vLAN ID: The vLAN ID for the virtual network. If omitted, the virtual network will not be tagged.

### Virtual network with DHCP networking

This networking model creates a virtual network that allocates dynamic IP addresses to all objects in your deployment.  

You must specify the following parameters while defining a virtual network with static IP configurations:

- Name: The name of your virtual network
- Virtual IP pool: The continuous range of IP addresses to be used for your Kubernetes cluster API server and Kubernetes services that require an external IP address.
- vLAN ID: The vLAN ID for the virtual network. If omitted, the virtual network will not be tagged.

## Microsoft On-premises Cloud service

Microsoft On-Premise Cloud (MOC) is new management stack that enables management of virtual machines on Azure Stack HCI and Windows Server based SDDC clouds. MOC consists of:

- a single instance of a highly available `cloud agent` service that is deployed on a  cluster. This agent runs on any one node in the Azure Stack HCI cluster. 
- a `node agent` running on every Azure Stack HCI physical node. 

The `-cloudserviceCIDR` is a parameter in the `Set-AksHciConfig` command that's used to assign a virtual IP to make sure we have a highly available cloud agent service.

The allocation of an IP address for MOC service depends on the underlying networking model followed by your Azure Stack HCI cluster deployment. **The IP address allocation for MOC service is independent of your virtual network model and is ONLY dependent on the underlying physical network that gives IP addresses to the Azure Stack HCI cluster nodes in your datacenter.**

### Azure Stack HCI cluster nodes with a DHCP based IP address allocation model

If your Azure Stack HCI nodes are assigned an IP address from a DHCP server present on the physical network, then you do not need to explicitly provide an IP address to the MOC service.

### Azure Stack HCI cluster nodes with a static IP allocation model 

If your Azure Stack HCI cluster nodes are assigned static IP addresses, then you must explicitly provide an IP address for the MOC cloud service. This IP address for MOC service must be in the same subnet as the Azure Stack HCI cluster nodes. To explicitly assign an IP address for MOC service use the `-cloudserviceCIDR` parameter in the `Set-AksHciConfig` command. Make sure you enter an IP address in the CIDR format, for example - "10.11.23.45/16".

## Compare network models

Both DHCP and Static IP provide network connectivity for your AKS on Azure Stack HCI deployment. However, there are advantages and disadvantages to each. At a high level, the following considerations apply:

* **DHCP**
    - Does not guarantee long lived IP addresses for some resource types in an AKS on Azure Stack HCI deployment.
    - Supports expansion of reserved DHCP IP addresses if your deployment gets bigger than you initially anticipated.
    
* **Static IP**
    - Guarantees long lived IP addresses for all resources in an AKS on Azure Stack HCI deployment.
    - Since we do not support automatic expansion of Kubernetes node IP pool, you may not be able to create new clusters if you have exhausted the Kubernetes node IP pool.


The following table compares IP address allocation for resources between static IP and DHCP networking models:

| Capability                                                                                   | Static IP   | DHCP |
|----------------------------------------------------------------------------------------------|-----------|-----------|
| Kubernetes cluster API server                                             | Assigned statically using VIP pool | Assigned statically using VIP pool |
| Kubernetes nodes (on virtual machines)                                                                         | Assigned using Kubernetes node IP pool | Assigned dynamically |
| Kubernetes services                                          | Assigned statically using VIP pool | Assigned statically using VIP pool |
| HAProxy load balancer VM                                          | Assigned using Kubernetes node IP pool | Assigned dynamically |
| Microsoft On Premise Cloud Service                                               | Depends on the physical networking configuration for Azure Stack HCI cluster nodes | Depends on the physical networking configuration for Azure Stack HCI cluster nodes |
| VIP pool                                             | Mandatory | Mandatory |
| Kubernetes node IP pool | Mandatory | Not Supported |


## Minimum IP address reservations for an AKS on Azure Stack HCI deployment
Irrespective of your deployment model, the number of IP addresses reserved remains the same. This section talks about the number of IP address to reserve based on your AKS on Azure Stack HCI deployment model.

### Minimum IP address reservation

At a minimum, you should reserve the following number of IP addresses for your deployment:

| Cluster type  | Control plane node | Worker node | For update operations | Load balancer  |
| ------------- | ------------------ | ---------- | ----------| -------------|
| AKS Host |  1 IP |  NA  |  2 IP |  NA  |
| Workload cluster  |  1 IP per node  | 1 IP per node |  5 IP  |  1 IP |

Additionally, you should reserve the following number of IP addresses for your VIP pool:

| Resource type  | Number of IP addresses 
| ------------- | ------------------
| Cluster API server |  1 per cluster 
| Kubernetes Services  |  1 per service  

As you can see, the number of required IP addresses is variable depending on the AKS on Azure Stack HCI architecture and the number of services you run on your Kubernetes cluster. We recommend reserving a total of 256 IP addresses (/24 subnet) for your deployment.

### Walking through an example deployment

Jane is an IT administrator just starting with AKS on Azure Stack HCI. She wants to deploy 2 Kubernetes clusters - Kubernetes cluster A and Kubernetes cluster B on her Azure Stack HCI cluster. She also wants to run a voting application on top of her cluster. This application has 3 instances of the front-end UI running across the two clusters and 1 instance of the backend database.

- Kubernetes cluster A has 3 control plane nodes and 5 worker nodes
- Kubernetes cluster B has 1 control plane node and 3 worker nodes
- 3 instances of the front-end UI (port 443)
- 1 instance of the backend database (port 80)

Based on the table above, she will have to reserve:

- 3 IP addresses for her AKS host (1 IP for control plane node and 2 IPs for running update operations)
- 3 IP addresses for her control plane nodes in cluster A (1 IP per control plane node)
- 5 IP addresses for her worker nodes in cluster A (1 IP per control plane node)
- 6 IP addresses additionally for cluster A (5 IPs for running update operations and 1 IP for load balancer)
- 1 IP addresses for her control plane nodes in cluster B (1 IP per control plane node)
- 3 IP addresses for her worker nodes in cluster B (1 IP per control plane node)
- 6 IP addresses additionally for cluster B (5 IPs for running update operations and 1 IP for load balancer)
- 2 IP addresses for her Kubernetes cluster API servers (1 IP per Kubernetes cluster)
- 3 IP addresses for her Kubernetes service (1 IP address per instance of the front-end UI, since they all use the same port. The backend database can use any one of the 3 IP addresses since it is on a different port)

As explained above, Jane requires a total of 32 IP addresses. Jane should therefore reserve a /26 subnet for her virtual network. 

### Splitting reserved IP addresses based on a static IP network model

While the total number of reserved IP addresses remain the same, the deployment model determines how these IP addresses are divided among IP groups. As we've discussed before, static IP network model has 2 IP pools:

- Kubernetes node IP pool - for Kubernetes node VMs and the load balancer VM. This IP pool also includes IP address required for running update operations.
- Virtual IP pool - for the Kubernetes API server and Kubernetes services

Working with the example above, Jane must further divide these IP addresses across VIP pools and Kubernetes node IP pools:
- 5 (2 for Kubernetes cluster API server and 3 for Kubernetes services ) out of the 32 IP addresses for her VIP pool.
- 27 (all the IP addresses for her Kubernetes nodes and underlying VMs, load balancer VMs and updates operations) for her Kubernetes node IP pool.

### Splitting reserved IP addresses based on a DHCP network model

While the total number of reserved IP addresses remain the same, the deployment model determines how these IP addresses are divided among IP group(s). As we've discussed before, the DHCP network model has 1 IP pool:

- Virtual IP pool - for the Kubernetes API server and Kubernetes services

Working with the example above:
- Jane must reserve a total of 32 IP addresses or a /26 subnet on her DHCP server. 
- She must reserve 5 (2 for Kubernetes cluster API server and 3 for Kubernetes services) out of the 32 IP addresses for her VIP pool 

## Next steps

In this topic, you learned the core concepts that provide networking to your applications in AKS on Azure Stack HCI. Next, you can:

- [Configure proxy settings on AKS on Azure Stack HCI](./proxy.md)
- [System requirements](./system-requirements.md)

