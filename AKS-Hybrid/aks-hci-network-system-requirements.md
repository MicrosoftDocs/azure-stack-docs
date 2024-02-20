---
title: AKS enabled by Azure Arc network requirements
description: Learn about AKS network prerequisites.
ms.topic: overview
ms.date: 02/07/2024
author: sethmanheim
ms.author: sethm
ms.reviewer: abha
ms.lastreviewed: 02/07/2024
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

Kubernetes nodes are deployed as specialized virtual machines in AKS. These VMs are allocated IP addresses to enable communication between Kubernetes nodes. AKS uses Arc VM logical networks to provide IP addresses and networking for the underlying VMs of the Kubernetes clusters. For more information about Arc VM networks, see [Logical networks for Azure Stack HCI](/azure-stack/hci/manage/create-logical-networks?tabs=azurecli). You must plan to reserve one IP address per AKS cluster node in your environment.

### IP address allocation options for AKS cluster VMs

Arc VM networks support the following two IP address assignment models for your Kubernetes VMs:

- Static IP networking: The Arc VM logical network allocates static IP addresses from an IP pool to the underlying VMs of the Kubernetes clusters.
- DHCP networking: The Arc VM logical network dynamically allocates IP addresses to the underlying VMs of the Kubernetes clusters. We do not recommend using DHCP networking for production workloads, since Kubernetes requires long-lived IP addresses in order to function. A change in the IP address of a Kubernetes cluster can lead to unforeseen failures, and might require you to re-create the Kubernetes cluster.

### Compare supported parameters for creating static IP or DHCP-based logical networks

| Parameter    | Description | Supported for DHCP | Supported for static IP |
|------------------|---------|-----------|-------------------|
| `$clustervnetname` | Required parameter for static IP and DHCP. The name of your logical network for Kubernetes cluster VMs. This name must be lowercase. | ![Supported](media/aks-hybrid-networks/check.png) | ![Supported](media/aks-hybrid-networks/check.png) |
| `$vswitchname`     | Required parameter for static IP and DHCP. The name of your VM switch. | ![Supported](media/aks-hybrid-networks/check.png) | ![Supported](media/aks-hybrid-networks/check.png) |
| `$ipaddressprefix` | Required parameter for static IP. The IP address of your subnet.  | Not supported. | ![Supported](media/aks-hybrid-networks/check.png) |
| `$gateway`         | Required parameter for static IP. The IP address of the gateway for the subnet.  | Not supported. | ![Supported](media/aks-hybrid-networks/check.png) |
| `$dnsservers`      | Required parameter for static IP. The IP address value(s) of your DNS servers. | Not supported. | ![Supported](media/aks-hybrid-networks/check.png) |
| `$IPPoolStart`     | Required parameter for static IP. The start IP address of your VM IP pool. The address must be in range of the subnet.  | Not supported. | ![Supported](media/aks-hybrid-networks/check.png) |
| `$IPPoolEnd`       | Required parameter for static IP. The end IP address of your VM IP pool. The address must be in range of the subnet.  | Not supported. | ![Supported](media/aks-hybrid-networks/check.png) |
| `$vlanId`          | Optional parameter for static IP and DHCP. The identification number of the VLAN in use. Every virtual machine is tagged with that VLAN ID. Default value is 0. | ![Supported](media/aks-hybrid-networks/check.png) | ![Supported](media/aks-hybrid-networks/check.png) |

### How to create logical networks for Kubernetes clusters on Azure Stack HCI 23H2

For instructions on how to create logical networks using Azure CLI and the Azure portal, see [Create logical networks on Azure Stack HCI 23H2](/azure-stack/hci/manage/create-logical-networks?tabs=azureportal#create-the-logical-network).

## Control plane IP

Kubernetes uses a control plane to ensure every component in the Kubernetes cluster is kept in the desired state. The control plane also manages and maintains the worker nodes that hold the containerized applications. AKS deploys the KubeVIP load balancer to ensure that the API server IP address of the Kubernetes control plane is available at all times. This KubeVIP instance requires a single immutable "control plane IP address" to function correctly. The control plane IP is a required parameter to create a Kubernetes cluster. You must ensure that the control plane IP address of a Kubernetes cluster does not overlap anywhere else, including Arc VM logical networks, infrastructure network IPs, load balancers, etc. Note that overlapping IP addresses can lead to unexpected failures for both the AKS cluster and any other place the IP address is being used. You must plan to reserve one IP address per Kubernetes cluster in your environment.

## Load balancer IPs for containerized applications

The main purpose of a load balancer is to distribute traffic across multiple nodes in a Kubernetes cluster. This load balancing can help prevent downtime and improve overall performance of applications. AKS supports the following options to deploy a load balancer for your Kubernetes cluster:

- [Deploy MetalLB load balancer using Azure Arc extensions](deploy-load-balancer-portal.md).
- Bring your own third party load balancer.

Regardless of the option you choose, you must ensure that the IP addresses allocated to the load balancer don't conflict with the IP addresses in the Arc VM logical network or control plane IPs for your Kubernetes clusters. Conflicting IP addresses can lead to unforeseen failures in your AKS deployment and applications.

## IP address planning for Kubernetes clusters and applications

At a minimum, you should reserve the following number of IP addresses per Kubernetes cluster. The actual number of IP addresses depends on the number of Kubernetes clusters, the number of nodes in each cluster, and the number of services and applications you intend to run on the Kubernetes cluster.

| Parameter    | Minimum number of IP addresses |
|------------------|---------|
| IP pool in Arc VM logical network | Reserve 1 IP address for every worker node in your Kubernetes cluster. For example, if you intend to create 3 node pools with 3 nodes in each node pool, you need to have 9 IP addresses in your IP pool.
| Control plane IP | Reserve 1 IP address for every Kubernetes cluster in your environment. For example, if you intend to create 5 clusters in total, you need to reserve 5 IP addresses, one for each Kubernetes cluster.
| Load balancer IPs | The number of IP addresses reserved depends on your application deployment model. As a starting point, you can reserve 1 IP address for every Kubernetes service. |

## Proxy settings

Proxy settings in AKS are inherited from the underlying infrastructure system. The functionality to set individual proxy settings for Kubernetes clusters and change proxy settings isn't supported yet.

## Network port requirements

The configuration of required network ports is now incorporated into the infrastructure deployment. Manual configuration of these ports is no longer required. Use the following port list to troubleshoot communication issues between the Arc Resource Bridge and Kubernetes clusters:

| Port | Source                           | Description                                          | Firewall notes                                                                                                        |
|----------|--------------------------------------|----------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------|
| 22       | Azure Arc Resource Bridge VM         | Required to collect logs when troubleshooting the system. | If you use separate VLANs, the physical Hyper-V Hosts need to access the Kubernetes cluster VMs on this port.              |
| 6443     | Azure Arc Resource Bridge VM         | Required to communicate with Kubernetes APIs.            | If you use separate VLANs, the physical Hyper-V Hosts need to access the Azure Arc Resource Bridge VM on this port. |
| 45000    | Physical Hyper-V hosts               | wssdAgent gRPC server                                    | No cross-VLAN rules are needed.                                                                                           |
| 45001    | Physical Hyper-V hosts               | wssdAgent gRPC authentication                            | No cross-VLAN rules are needed.                                                                                           |
| 46000    | Azure Arc Resource Bridge VM         | wssdCloudAgent to lbagent                                | If you use separate VLANs, the physical Hyper-V Hosts need to access the Azure Arc Resource Bridge VM on this port. |
| 55000    | Cluster Resource (-CloudServiceCIDR) | Cloud Agent gRPC server                                  | If you use separate VLANs, the Azure Arc Resource Bridge VM needs to access the Cluster Resource IP on this port.   |
| 65000    | Cluster Resource (-CloudServiceCIDR) | Cloud Agent gRPC authentication                          | If you use separate VLANs, the Azure Arc Resource Bridge VM needs to access the Cluster Resource IP on this port.   |

## Firewall URL exceptions

For information about the Azure Arc firewall/proxy URL allowlist, see the [Azure Arc resource bridge network requirements](/azure/azure-arc/resource-bridge/network-requirements#firewallproxy-url-allowlist) and [Azure Stack HCI 23H2 network requirements](/azure-stack/hci/manage/use-environment-checker?tabs=connectivity#prerequisites).

For deployment and operation of Kubernetes clusters, the following URLs must be reachable from all physical nodes and virtual machines in the deployment. Ensure that these URLS are allowed in your firewall configuration:

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

- [Create Arc enabled logical networks for AKS clusters on Azure Stack HCI 23H2](aks-networks.md)
