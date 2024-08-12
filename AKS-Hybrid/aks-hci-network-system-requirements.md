---
title: AKS enabled by Azure Arc network requirements
description: Learn about AKS network prerequisites.
ms.topic: overview
ms.date: 04/02/2024
author: sethmanheim
ms.author: sethm
ms.reviewer: abha
ms.lastreviewed: 04/02/2024
---

# AKS enabled by Azure Arc network requirements

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

This article introduces core networking concepts for your VMs and applications in AKS enabled by Azure Arc. The article also describes the required networking prerequisites for creating Kubernetes clusters. We recommend that you work with a network administrator to provide and set up the networking parameters required to deploy AKS enabled by Arc.

In this conceptual article, the following key components are introduced. These components need a static IP address in order for the AKS Arc cluster and applications to create and operate successfully:

- AKS cluster VMs
- AKS control plane IP
- Load balancer for containerized applications

## Networking for AKS cluster VMs

Kubernetes nodes are deployed as specialized virtual machines in AKS enabled by Arc. These VMs are allocated IP addresses to enable communication between Kubernetes nodes. AKS Arc uses Azure Stack HCI logical networks to provide IP addresses and networking for the underlying VMs of the Kubernetes clusters. For more information about logical networks, see [Logical networks for Azure Stack HCI](/azure-stack/hci/manage/create-logical-networks?tabs=azurecli). You must plan to reserve one IP address per AKS cluster node VM in your Azure Stack HCI environment.

> [!NOTE]
> Static IP is the only supported mode for assigning an IP address to AKS Arc VMs. This is because Kubernetes requires the IP address assigned to a Kubernetes node to be constant throughout the lifecycle of the Kubernetes cluster. 
> Software defined virtual networks and SDN related features are currently not supported on AKS on Azure Stack HCI 23H2. 

The following parameters are required in order to use a logical network for AKS Arc cluster create operation:

| Logical network parameter| Description| Required parameter for AKS Arc cluster|
|------------------|---------|-----------|
| `--address-prefixes` | AddressPrefix for the network. Currently only 1 address prefix is supported. Usage: `--address-prefixes "10.220.32.16/24"`. | ![Supported](media/aks-hybrid-networks/check.png) |
| `--dns-servers`      | Space-separated list of DNS server IP addresses. Usage: `--dns-servers 10.220.32.16 10.220.32.17`. | ![Supported](media/aks-hybrid-networks/check.png) |
| `--gateway`         | Gateway. The gateway IP address must be within the scope of the address prefix. Usage: `--gateway 10.220.32.16`. | ![Supported](media/aks-hybrid-networks/check.png) |
| `--ip-allocation-method`         | The IP address allocation method. Supported values are "Static". Usage: `--ip-allocation-method "Static"`. | ![Supported](media/aks-hybrid-networks/check.png) |
| `--ip-pool-start`     | The start IP address of your IP pool. The address must be in range of the address prefix. Usage: `--ip-pool-start "10.220.32.18"`.  | ![Supported](media/aks-hybrid-networks/check.png) |
| `--ip-pool-end`       | The end IP address of your IP pool. The address must be in range of the address prefix. Usage: `--ip-pool-end "10.220.32.38"`.  | ![Supported](media/aks-hybrid-networks/check.png) |
| `--vm-switch-name`     | The name of the VM switch. Usage: `--vm-switch-name "vm-switch-01"`. | ![Supported](media/aks-hybrid-networks/check.png) |

## Control plane IP

Kubernetes uses a control plane to ensure every component in the Kubernetes cluster is kept in the desired state. The control plane also manages and maintains the worker nodes that hold the containerized applications. AKS enabled by Arc deploys the KubeVIP load balancer to ensure that the API server IP address of the Kubernetes control plane is available at all times. This KubeVIP instance requires a single immutable "control plane IP address" to function correctly.

> [!NOTE]
> The control plane IP is a required parameter to create a Kubernetes cluster. You must ensure that the control plane IP address of a Kubernetes cluster does not overlap with anything else, including Arc VM logical networks, infrastructure network IPs, load balancers, etc. The control plane IP also must be within the scope of the address prefix of the logical network, but outside the IP pool. This is because the IP pool is only used for VMs, and if you choose an IP address from the IP pool for the control plane, an IP address conflict can result. Overlapping IP addresses can lead to unexpected failures for both the AKS cluster and any other place the IP address is being used. You must plan to reserve one IP address per Kubernetes cluster in your environment.

## Load balancer IPs for containerized applications

The main purpose of a load balancer is to distribute traffic across multiple nodes in a Kubernetes cluster. This load balancing can help prevent downtime and improve overall performance of applications. AKS supports the following options to deploy a load balancer for your Kubernetes cluster:

- [Deploy MetalLB load balancer using Azure Arc extension](deploy-load-balancer-portal.md).
- Bring your own third party load balancer.

Whether you choose the MetalLB Arc extension, or bring your own load balancer, you must provide a set of IP addresses to the load balancer service. You have the following options:

- Provide IP addresses for your services from the same subnet as the AKS Arc VMs.
- Use a different network and list of IP addresses if your application needs external load balancing.

Regardless of the option you choose, you must ensure that the IP addresses allocated to the load balancer don't conflict with the IP addresses in the logical network or control plane IPs for your Kubernetes clusters. Conflicting IP addresses can lead to unforeseen failures in your AKS deployment and applications.

## Simple IP address planning for Kubernetes clusters and applications

In the following scenario walk-through, you reserve IP addresses from a single network for your Kubernetes clusters and services. This is the most straightforward and simple scenario for IP address assignment.

| IP address requirement    | Minimum number of IP addresses | How and where to make this reservation |
|------------------|---------|---------------|
| AKS Arc VM IPs | Reserve one IP address for every worker node in your Kubernetes cluster. For example, if you want to create 3 node pools with 3 nodes in each node pool, you need to have 9 IP addresses in your IP pool. | Reserve IP addresses for AKS Arc VMs through IP pools in Arc VM logical network. |
| AKS Arc K8s version upgrade IPs | Because AKS Arc performs rolling upgrades, reserve one IP address for every AKS Arc cluster for Kubernetes version upgrade operations. | Reserve IP addresses for K8s version upgrade operation through IP pools in Arc VM logical network. |
| Control plane IP | Reserve one IP address for every Kubernetes cluster in your environment. For example, if you want to create 5 clusters in total, reserve 5 IP addresses, one for each Kubernetes cluster. | Reserve IP addresses for control plane IPs in the same subnet as Arc VM logical network, but outside the specified IP pool. |
| Load balancer IPs | The number of IP addresses reserved depends on your application deployment model. As a starting point, you can reserve one IP address for every Kubernetes service. | Reserve IP addresses for control plane IPs in the same subnet as Arc VM logical network, but outside the specified IP pool. |

### Example walkthrough for IP address reservation for Kubernetes clusters and applications

Jane is an IT administrator just starting with AKS enabled by Azure Arc. She wants to deploy two Kubernetes clusters: Kubernetes cluster A and Kubernetes cluster B on her Azure Stack HCI cluster. She also wants to run a voting application on top of cluster A. This application has three instances of the front-end UI running across the two clusters and one instance of the backend database. All her AKS clusters and services are running in a single network, with a single subnet.

- Kubernetes cluster A has 3 control plane nodes and 5 worker nodes.
- Kubernetes cluster B has 1 control plane node and 3 worker nodes.
- 3 instances of the front-end UI (port 443).
- 1 instance of the backend database (port 80).

Based on the previous table, she must reserve a total of 19 IP addresses in her subnet:

- 8 IP addresses for the AKS Arc node VMs in cluster A (one IP per K8s node VM).
- 4 IP addresses for the AKS Arc node VMs in cluster B (one IP per K8s node VM).
- 2 IP addresses for running AKS Arc upgrade operation (one IP address per AKS Arc cluster).
- 2 IP addresses for the AKS Arc control plane (one IP address per AKS Arc cluster)
- 3 IP addresses for the Kubernetes service (one IP address per instance of the front-end UI, since they all use the same port. The backend database can use any one of the three IP addresses as long as it uses a different port).

Continuing with this example, and adding it to the following table, you get:

| Parameter    | Number of IP addresses | How and where to make this reservation |
|------------------|---------|---------------|
| AKS Arc VMs and K8s version upgrade  | Reserve 14 IP addresses | Make this reservation through IP pools in the Azure Stack HCI logical network. |
| Control plane IP | Reserve 2 IP addresses, one for AKS Arc cluster | Use the `controlPlaneIP` parameter to pass the IP address for control plane IP. Ensure that this IP is in the same subnet as the Arc logical network, but outside the IP pool defined in the Arc logical network. |
| Load balancer IPs | 3 IP address for Kubernetes services, for Jane's voting application. | These IP addresses are used when you install a load balancer on cluster A. You can use the MetalLB Arc extension, or bring your own 3rd party load balancer. Ensure that this IP is in the same subnet as the Arc logical network, but outside the IP pool defined in the Arc VM logical network. |

## Proxy settings

Proxy settings in AKS are inherited from the underlying infrastructure system. The functionality to set individual proxy settings for Kubernetes clusters and change proxy settings isn't supported yet.

## Network port and cross-VLAN requirements

When you deploy Azure Stack HCI, you allocate a contiguous block of at least [six static IP addresses on your management network's subnet](/azure-stack/hci/deploy/deploy-via-portal#specify-network-settings), omitting addresses already used by the physical servers. These IPs are used by Azure Stack HCI and internal infrastructure (Arc Resource Bridge) for Arc VM management and AKS Arc. If your management network that provides IP addresses to Arc Resource Bridge related Azure Stack HCI services are on a different VLAN than the logical network you used to create AKS clusters, you need to ensure that the following ports are opened to successfully create and operate an AKS cluster. 

| Destination Port | Destination | Source | Description | Cross VLAN networking notes |
|------------------|-------------|--------|-------------|----------------|
| 22 | Logical network used for AKS Arc VMs | IP addresses in management network | Required to collect logs for troubleshooting. | If you use separate VLANs, IP addresses in management network used for Azure Stack HCI and Arc Resource Bridge need to access the AKS Arc cluster VMs on this port.|
| 6443 | Logical network used for AKS Arc VMs | IP addresses in management network | Required to communicate with Kubernetes APIs. | If you use separate VLANs, IP addresses in management network used for Azure Stack HCI and Arc Resource Bridge need to access the AKS Arc cluster VMs on this port.|
| 55000 | IP addresses in management network | Logical network used for AKS Arc VMs | Cloud Agent gRPC server | If you use separate VLANs, the AKS Arc VMs need to access the IP addresses in management network used for cloud agent IP and cluster IP on this port. |
| 65000 | IP addresses in management network | Logical network used for AKS Arc VMs | Cloud Agent gRPC authentication | If you use separate VLANs, the AKS Arc VMs need to access the IP addresses in management network used for cloud agent IP and cluster IP on this port. |

## Firewall URL exceptions

For information about the Azure Arc firewall/proxy URL allowlist, see the [Azure Arc resource bridge network requirements](/azure/azure-arc/resource-bridge/network-requirements#firewallproxy-url-allowlist) and [Azure Stack HCI 23H2 network requirements](/azure-stack/hci/manage/use-environment-checker?tabs=connectivity#prerequisites).

> [!NOTE]
> If you're deploying an older Azure Stack HCI [release, such as 2402](/azure-stack/hci/whats-new?tabs=2402releases#features-and-improvements-in-24023) and earlier, you must also allow the **gcr.io** and **storage.googleapis.com** URLs. These URLs were removed from the latest AKS Arc release.

| URL | Port | Service | Notes |
|---|---|---|---|
| `https://mcr.microsoft.com` <br> `*.data.mcr.microsoft.com`<br> `azurearcfork8s.azurecr.io`<br> `linuxgeneva-microsoft.azurecr.io`<br> `pipelineagent.azurecr.io`<br> `ecpacr.azurecr.io` <br> `https://azurearcfork8sdev.azurecr.io` <br> `https://hybridaks.azurecr.io` <br> `aszk8snetworking.azurecr.io` |  443 | AKS Arc | Used for official Microsoft artifacts such as container images. |
| `docker.io` |  443 | AKS Arc | Used for Kubernetes official artifacts such as container base images. |
| `hybridaksstorage.z13.web.core.windows.net` |    443 | AKS Arc |    AKSHCI static website hosted in Azure Storage. |
| `*.blob.core.windows.net`<br> `*.dl.delivery.mp.microsoft.com` <br> `*.do.dsp.mp.microsoft.com` | 443 | AKS Arc | Used for AKS Arc VHD image download and update. |
| `*.prod.do.dsp.mp.microsoft.com` | 443 | AKS Arc | Used for AKS Arc VHD image download and update. |
| `*.login.microsoft.com` | 443 | Azure | Required to fetch and update Azure Resource Manager tokens for logging into Azure. |
| `https://*.his.arc.azure.com` | 443 | Azure Arc enabled K8s | Used for Arc agents identity and access control. |
| `https://*.dp.kubernetesconfiguration.azure.com` | 443 | Azure Arc enabled K8s | Used for Azure Arc configuration. |
| `https://*.servicebus.windows.net` | 443 | Azure Arc enabled K8s | Used to securely connect to Azure Arc-enabled Kubernetes clusters without requiring any inbound port to be enabled on the firewall. |
| `https://guestnotificationservice.azure.com` | 443 | Azure Arc enabled K8s | Used for guest notification operations. |
| `sts.windows.net` | 443 | Azure Arc enabled K8s |  For Cluster Connect and Custom Location-based scenario. |
| `https://*.dp.prod.appliances.azure.com` | 443 | Arc Resource Bridge | Used for data plane operations for Resource bridge (appliance). |
| `*.prod.microsoftmetrics.com`<br> `*.prod.hot.ingestion.msftcloudes.com`<br> `dc.services.visualstudio.com`<br> `*.prod.warm.ingest.monitor.core.windows.net`<br> `gcs.prod.monitoring.core.windows.net` <br> `https://adhs.events.data.microsoft.com` <br> `https://v20.events.data.microsoft.com` | 443 | Metrics and health monitoring | Used for metrics and monitoring telemetry traffic. |
| `pypi.org` <br> `*.pypi.org` <br> `files.pythonhosted.org` | 443 | Az CLI | Used to download Az CLI and Az CLI extensions. |
| `aka.ms` | 443 | Azure Stack HCI | Required for Azure Stack HCI related downloads. |
| `raw.githubusercontent.com` |    443 | GitHub | Used for GitHub. |
| `www.microsoft.com` |    80 | Microsoft official web site. | Microsoft official web site. |

## Next steps

[Create logical networks for Kubernetes clusters on Azure Stack HCI 23H2](aks-networks.md)
