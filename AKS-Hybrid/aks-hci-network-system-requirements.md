---
title: AKS enabled by Azure Arc network requirements
description: Learn about AKS network prerequisites.
ms.topic: overview
ms.date: 03/27/2024
author: sethmanheim
ms.author: sethm
ms.reviewer: abha
ms.lastreviewed: 03/26/2024
---

# AKS enabled by Azure Arc network requirements

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

This article introduces the core concepts that provide networking to your VMs and applications in AKS:

- Azure Stack HCI logical networks
- Control plane IP
- Kubernetes load balancers

This article also describes the required networking prerequisites for creating Kubernetes clusters. We recommend that you work with a network administrator to provide and set up the networking parameters required to deploy AKS.

## Network concepts for AKS clusters

Ensure that you set up networking correctly for the following components in your Kubernetes clusters:

- AKS cluster VMs
- AKS control plane IP
- Load balancer for containerized applications

## Network for AKS cluster VMs

Kubernetes nodes are deployed as specialized virtual machines in AKS. These VMs are allocated IP addresses to enable communication between Kubernetes nodes. AKS uses Arc VM logical networks to provide IP addresses and networking for the underlying VMs of the Kubernetes clusters. For more information about Arc VM networks, see [Logical networks for Azure Stack HCI](/azure-stack/hci/manage/create-logical-networks?tabs=azurecli). You must plan to reserve one IP address per AKS cluster node VM in your Azure Stack HCI environment.

### Static IP address allocation for AKS cluster VMs

While Arc VM networks support static IP and DHCP-based logical networks, if you want to use the Arc VM logical network for AKS enabled by Arc, you must ensure that the Arc VM logical network has an IP pool.

The following input is required in order to use an Arc VM logical network for AKS Arc:

| Arc VM logical network parameter| Description| Required parameter for AKS Arc cluster|
|------------------|---------|-----------|
| `$clustervnetname` | The name of the Arc VM logical network. This name must be lowercase. | ![Supported](media/aks-hybrid-networks/check.png) |
| `$vswitchname`     | The name of the VM switch. | ![Supported](media/aks-hybrid-networks/check.png) |
| `$ipaddressprefix` | The IP address prefix of the logical network.  | ![Supported](media/aks-hybrid-networks/check.png) |
| `$gateway`         | The IP address of the gateway for the subnet.  | ![Supported](media/aks-hybrid-networks/check.png) |
| `$dnsservers`      | The IP address value(s) of your DNS servers. | ![Supported](media/aks-hybrid-networks/check.png) |
| `$IPPoolStart`     | The start IP address of your VM IP pool. The address must be in range of the subnet.  | ![Supported](media/aks-hybrid-networks/check.png) |
| `$IPPoolEnd`       | The end IP address of your VM IP pool. The address must be in range of the subnet.  | ![Supported](media/aks-hybrid-networks/check.png) |

### Create logical networks for Kubernetes clusters on Azure Stack HCI 23H2

For instructions on how to create logical networks using Azure CLI and the Azure portal, see [Create logical networks on Azure Stack HCI 23H2](/azure-stack/hci/manage/create-logical-networks?tabs=azureportal#create-the-logical-network).

## Control plane IP

Kubernetes uses a control plane to ensure every component in the Kubernetes cluster is kept in the desired state. The control plane also manages and maintains the worker nodes that hold the containerized applications. AKS deploys the KubeVIP load balancer to ensure that the API server IP address of the Kubernetes control plane is available at all times. This KubeVIP instance requires a single immutable "control plane IP address" to function correctly. The control plane IP is a required parameter to create a Kubernetes cluster. You must ensure that the control plane IP address of a Kubernetes cluster does not overlap anywhere else, including Arc VM logical networks, infrastructure network IPs, load balancers, etc. Note that overlapping IP addresses can lead to unexpected failures for both the AKS cluster and any other place the IP address is being used. You must plan to reserve one IP address per Kubernetes cluster in your environment.

## Load balancer IPs for containerized applications

The main purpose of a load balancer is to distribute traffic across multiple nodes in a Kubernetes cluster. This load balancing can help prevent downtime and improve overall performance of applications. AKS supports the following options to deploy a load balancer for your Kubernetes cluster:

- [Deploy MetalLB load balancer using Azure Arc extensions](deploy-load-balancer-portal.md).
- Bring your own third party load balancer.

Regardless of the option you choose, you must ensure that the IP addresses allocated to the load balancer don't conflict with the IP addresses in the Arc VM logical network or control plane IPs for your Kubernetes clusters. Conflicting IP addresses can lead to unforeseen failures in your AKS deployment and applications.

## IP address planning for Kubernetes clusters and applications

At a minimum, you should reserve the following number of IP addresses per Kubernetes cluster from 1 subnet. The actual number of IP addresses depends on the number of Kubernetes clusters, the number of nodes in each cluster, and the number of services and applications you need to run on the Kubernetes cluster.

| Parameter    | Minimum number of IP addresses | How and where to make this reservation |
|------------------|---------|---------------|
| IP pool in Arc VM logical network | Reserve one IP address for every worker node in your Kubernetes cluster. For example, if you want to create 3 node pools with 3 nodes in each node pool, you need to have 9 IP addresses in your IP pool. | Reserve IP addresses for AKS Arc VMs through IP pools in Arc VM logical network. |
| Upgrade IPs in Arc VM logical network | Reserve one IP address for every AKS Arc cluster for Kubernetes version upgrade operations. | Reserve IP addresses for K8s version upgrade operation through IP pools in Arc VM logical network. |
| Control plane IP | Reserve one IP address for every Kubernetes cluster in your environment. For example, if you want to create 5 clusters in total, reserve 5 IP addresses, one for each Kubernetes cluster. | Reserve IP addresses for control plane IPs in the same subnet as Arc VM logical network, but outside the specified IP pool. |
| Load balancer IPs | The number of IP addresses reserved depends on your application deployment model. As a starting point, you can reserve one IP address for every Kubernetes service. | Reserve IP addresses for control plane IPs in the same subnet as Arc VM logical network, but outside the specified IP pool. |

### Example walkthrough for IP address reservation for Kubernetes clusters and applications

Jane is an IT administrator just starting with AKS enabled by Azure Arc. She wants to deploy two Kubernetes clusters: Kubernetes cluster A and Kubernetes cluster B on her Azure Stack HCI cluster. She also wants to run a voting application on top of cluster A. This application has three instances of the front-end UI running across the two clusters and one instance of the backend database.

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
| Load balancer IPs | 3 IP address for Kubernetes services, for Jane's voting application. | These IP addresses are used when you install a load balancer on cluster A. You can use the MetalLB Arc extension, or bring your own 3rd party load balancer. Ensure that this IP is in the same subnet as the Arc logical network, but outside the IP pool defined in the Arc logical network. |

## Proxy settings

Proxy settings in AKS are inherited from the underlying infrastructure system. The functionality to set individual proxy settings for Kubernetes clusters and change proxy settings isn't supported yet.

## Network port requirements

The configuration of required network ports is now incorporated into the infrastructure deployment. Manual configuration of these ports is no longer required. Use the following port list to troubleshoot communication issues between the Arc Resource Bridge and Kubernetes clusters:

| Destination Port | Destination | Source | Description | Cross vlan firewall notes |
|------------------|-------------|--------|-------------|----------------|
| 22 | AKS Arc VMs | Azure Arc Resource Bridge, Azure Stack HCI physical hosts | Required to collect logs for troubleshooting. | If you use separate VLANs, the physical Hyper-V Hosts need to access the AKS Arc cluster VMs on this port.|
| 6443 | AKS Arc VMs | Azure Arc Resource Bridge VM | Required to communicate with Kubernetes APIs. | If you use separate VLANs, Arc Resource Bridge needs to access the AKS Arc cluster VMs on this port.|
| 55000    | Cloud agent for MOC | AKS Arc VMs | Cloud Agent gRPC server | If you use separate VLANs, the AKS Arc VMs need to access the cloud agent IP on this port.|
| 65000    | Cloud agent for MOC | AKS Arc VMs | Cloud Agent gRPC authentication | If you use separate VLANs, the Azure Arc Resource Bridge VM needs to access the cloud agent IP on this port.|

## Firewall URL exceptions

For information about the Azure Arc firewall/proxy URL allowlist, see the [Azure Arc resource bridge network requirements](/azure/azure-arc/resource-bridge/network-requirements#firewallproxy-url-allowlist) and [Azure Stack HCI 23H2 network requirements](/azure-stack/hci/manage/use-environment-checker?tabs=connectivity#prerequisites).

For deployment and operation of Kubernetes clusters, the following URLs must be reachable from all physical nodes and AKS Arc VMs in the deployment. Ensure that these URLS are allowed in your firewall configuration:

| URL | Port | Service | Notes |
|---|---|---|---|
| `https://mcr.microsoft.com` | 443 | Microsoft container registry | Used for official Microsoft artifacts such as container images. |
| `https://*.his.arc.azure.com` | 443 | Azure Arc identity service | Used for identity and access control. |
| `https://*.dp.kubernetesconfiguration.azure.com` | 443 | Kubernetes | Used for Azure Arc configuration. |
| `https://*.servicebus.windows.net` | 443 | Cluster connect | Used to securely connect to Azure Arc-enabled Kubernetes clusters without requiring any inbound port to be enabled on the firewall. |
| `https://guestnotificationservice.azure.com` | 443 | Notification service | Used for guest notification operations. |
| `https://*.dp.prod.appliances.azure.com` | 443 | Data plane service | Used for data plane operations for Resource bridge (appliance). |
| `*.data.mcr.microsoft.com`<br> `azurearcfork8s.azurecr.io`<br> `linuxgeneva-microsoft.azurecr.io`<br> `pipelineagent.azurecr.io`<br> `ecpacr.azurecr.io` | 443 | Download agent | Used to download images and agents. |
| `*.prod.microsoftmetrics.com`<br> `*.prod.hot.ingestion.msftcloudes.com`<br> `dc.services.visualstudio.com`<br> `*.prod.warm.ingest.monitor.core.windows.net`<br> `gcs.prod.monitoring.core.windows.net` | 443 | Metrics and health monitoring | Used for metrics and monitoring telemetry traffic. |
| `*.blob.core.windows.net`<br> `*.dl.delivery.mp.microsoft.com` <br> `*.do.dsp.mp.microsoft.com` | 443 | TCP | Used to download Resource bridge (appliance) images. |
| `https://azurearcfork8sdev.azurecr.io` | 443 | Kubernetes | Used to download Azure Arc for Kubernetes container images. |
| `https://adhs.events.data.microsoft.com` | 443 | Telemetry | ADHS is a telemetry service running inside the appliance/mariner OS. Used periodically to send required diagnostic data to Microsoft from control plane nodes. Used when telemetry is coming off mariner, which means any Kubernetes control plane. |
| `https://v20.events.data.microsoft.com`  | 443 | Telemetry | Used periodically to send required diagnostic data to Microsoft from the Windows Server host. |
| `gcr.io` | 443 | Google container registry | Used for Kubernetes official artifacts such as container base images. |
| `pypi.org`  | 443 | Python package | Validate Kubernetes and Python versions. |
| `*.pypi.org`  | 443 | Python package | Validate Kubernetes and Python versions. |
| `https://hybridaks.azurecr.io` | 443 | Container image | Required to access the HybridAKS operator image. |
| `aka.ms` | 443 | az extensions | Required to download Azure CLI extensions such as **akshybrid** and **connectedk8s**. |
| `*.login.microsoft.com` | 443 | Azure    | Required to fetch and update Azure Resource Manager tokens. |
| `sts.windows.net` | 443 | Azure Arc |    For Cluster Connect and Custom Location-based scenario. |
| `hybridaksstorage.z13.web.core.windows.net` |    443 | Azure Stack HCI |    AKSHCI static website hosted in Azure Storage. |
| `raw.githubusercontent.com` |    443 | GitHub | Used for GitHub. |
| `www.microsoft.com` |    80 | Microsoft official web site. | Microsoft official web site. |
| `*.prod.do.dsp.mp.microsoft.com` | 443 | Microsoft Update | Resource bridge (appliance) image download. |
| `files.pythonhosted.org` | 443 | Python package | Python package. |

## Next steps

[Create Arc-enabled logical networks for AKS clusters on Azure Stack HCI 23H2](aks-networks.md)
