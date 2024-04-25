---
title: AKS enabled by Azure Arc on VMware network requirements (preview)
description: Learn about AKS enabled by Arc on VMware network prerequisites.
ms.topic: overview
ms.date: 03/25/2024
author: sethmanheim
ms.author: sethm
ms.reviewer: abha
ms.lastreviewed: 03/25/2024
---

# AKS enabled by Azure Arc on VMware network requirements (preview)

[!INCLUDE [aks-applies-to-vmware](includes/aks-hci-applies-to-skus/aks-applies-to-vmware.md)]

This article introduces the core concepts that provide networking to your VMs and applications in Azure Kubernetes Service (AKS) enabled by Azure Arc on VMware:

- Logical networks for AKS enabled by Arc VMs
- Control plane IP
- Kubernetes load balancers

This article also describes the required networking prerequisites for creating Kubernetes clusters. We recommend that you work with a network administrator to provide and set up the networking parameters required to deploy AKS.

## Network concepts for AKS clusters

Ensure that you set up networking correctly for the following components in your Kubernetes clusters:

- AKS cluster VMs
- AKS control plane IP
- Load balancer for containerized applications

## Network for AKS cluster VMs

Kubernetes nodes are deployed as specialized virtual machines in AKS. These VMs are allocated IP addresses to enable communication between Kubernetes nodes. AKS uses VMware logical network segments to provide IP addresses and networking for the underlying VMs of the Kubernetes clusters. For this preview, only DHCP-based VMware logical network segments are supported. Once the VMware network segment is provided during AKS Arc cluster creation, IP addresses are dynamically allocated to the underlying VMs of the Kubernetes clusters.

## Control plane IP

Kubernetes uses a control plane to ensure every component in the Kubernetes cluster is kept in the desired state. The control plane also manages and maintains the worker nodes that hold the containerized applications. AKS deploys the KubeVIP load balancer to ensure that the API server IP address of the Kubernetes control plane is always available. To function correctly, this KubeVIP instance requires a single immutable "control plane IP address." The control plane IP is a required parameter to create a Kubernetes cluster. You must ensure that the control plane IP address of a Kubernetes cluster doesn't overlap with any other IP address. Overlapping IP addresses can lead to unexpected failures for both the AKS cluster and any other place the IP address is used. You must plan to reserve one IP address per Kubernetes cluster in your environment. Ensure that the control plane IP address is excluded from the scope of your DHCP server.

## Load balancer IPs for containerized applications

The main purpose of a load balancer is to distribute traffic across multiple nodes in a Kubernetes cluster. This load balancing can help prevent downtime and improve overall performance of applications. For this preview, you must bring your own third party load balancer; for example, [MetalLB](https://metallb.org/installation/). You must also ensure that the IP addresses allocated to the load balancer don't conflict with the IP addresses used anywhere else. Conflicting IP addresses can lead to unforeseen failures in your AKS deployment and applications.

## IP address planning for Kubernetes clusters and applications

At a minimum, you should have the following number of IP addresses available per Kubernetes cluster. The actual number of IP addresses depends on the number of Kubernetes clusters, the number of nodes in each cluster, and the number of services and applications you want to run on the Kubernetes cluster:

| Parameter    | Minimum number of IP addresses |
|------------------|---------|
| VMware logical network segment | One IP address for every worker node in your Kubernetes cluster. For example, if you want to create 3 node pools with 3 nodes in each node pool, you need 9 available IP addresses from your DHCP server. |
| Control plane IP | Reserve one IP address for every Kubernetes cluster in your environment. For example, if you need to create 5 clusters in total, you must reserve 5 IP addresses, one for each Kubernetes cluster. These 5 IP addresses must be outside the scope of your DHCP server. |
| Load balancer IPs | The number of IP addresses reserved depends on your application deployment model. As a starting point, you can reserve one IP address for every Kubernetes service. |

## Proxy settings

For this preview, creating AKS Arc clusters in a proxy enabled VMware environment isn't supported.

## Firewall URL exceptions

For information about the Azure Arc firewall/proxy URL allowlist, see the [Azure Arc resource bridge network requirements](/azure/azure-arc/resource-bridge/network-requirements#firewallproxy-url-allowlist).

For deployment and operation of Kubernetes clusters, the following URLs must be reachable from all physical nodes and virtual machines in the deployment. Ensure that these URLs are allowed in your firewall configuration:

| URL | Port |
|---|---|
|.dp.prod.appliances.azure.com | HTTPS/443 |
|.eus.his.arc.azure.com    | HTTPS/443 |
|guestnotificationservice.azure.com | HTTPS/443 |
|.dp.kubernetesconfiguration.azure.com | HTTPS/443 |
|management.azure.com | HTTPS/443 |
|raw.githubusercontent.com | HTTPS/443 |
|storage.googleapis.com | HTTPS/443 |
|msk8s.api.cdp.microsoft.com | HTTPS/443 |
|adhs.events.data.microsoft.com | HTTPS/443 |
|.events.data.microsoft.com | HTTPS/443 |
|graph.microsoft.com | HTTPS/443 |
|.login.microsoft.com | HTTPS/443 |
|mcr.microsoft.com | HTTPS/443 |
|.data.mcr.microsoft.com | HTTPS/443 |
|msk8s.sb.tlu.dl.delivery.mp.microsoft.com | HTTPS/443 |
|.prod.microsoftmetrics.com | HTTPS/443 | 
|login.microsoftonline.com | HTTPS/443 |
|dc.services.visualstudio.com | HTTPS/443 |
|ctldl.windowsupdate.com | HTTP/80 |
|azurearcfork8s.azurecr.io | HTTPS/443 |
|ecpacr.azurecr.io | HTTPS/443 |
|hybridaks.azurecr.io | HTTPS/443 |
|kvamanagementoperator.azurecr.io |    HTTPS/443 |
|linuxgeneva-microsoft.azurecr.io    | HTTPS/443 |
|gcr.io    | HTTPS/443 |
|aka.ms    | HTTPS/443 |
|k8connecthelm.azureedge.net | HTTPS/443 |
|k8sconnectcsp.azureedge.net | HTTPS/443 |
|.blob.core.windows.net | HTTPS/443 |

## Next steps

- [Review system requirements for AKS on VMware](aks-vmware-system-requirements.md)
- [Review scale requirements for AKS on VMware](aks-vmware-scale-requirements.md)
