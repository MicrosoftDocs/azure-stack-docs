---
title: Azure Kubernetes Service (AKS) Cloud, Edge, and On-Premises Comparison
description: Compare Azure Kubernetes Service (AKS) features, capabilities, and pricing across cloud, edge, and on-premises environments to choose the best deployment for your needs.
author: sethmanheim
ms.topic: concept-article
ms.date: 06/10/2025
ms.author: sethm
ms.reviewer: rmody
---

# Azure Kubernetes Service (AKS) Cloud, Edge, and on-premises comparison

Azure Kubernetes Service (AKS) is a fully managed Kubernetes platform that simplifies how organizations deploy, scale, and manage containerized applications in the cloud. As customer needs evolve to span cloud, on-premises, and edge environments, AKS expands its footprint and brings the same trusted Kubernetes capabilities to a broader range of edge and on-premises infrastructure.

With solutions like AKS on Azure Local enabled by Azure Arc, organizations can now run AKS clusters closer to where their workloads and data reside, whether in remote edge sites or within their own datacenters, while maintaining a consistent operational and developer experience. While AKS is delivered differently across environments, the underlying platform stays aligned in its goals, behavior, and experience.

The focus is on delivering a cohesive and adaptable AKS offering that meets customers across cloud and edge, while preserving the simplicity and power that define the AKS experience.

This article explores how AKS extends across multiple platforms and highlights the unique advantages and capabilities it brings to cloud, on-premises, and edge environments.

> [!NOTE]
> AKS enabled by Azure Arc architecture on Windows Server (2019 and 2022) isn't supported after April 2025. AKS support on Windows Server continues to evolve. For more information, see [Retirement of AKS architecture on Windows Server 2019 and Windows Server 2022](aks-windows-server-retirement.md).

## General comparison of AKS across platforms

| Platform | Azure (Cloud) | Azure Local (Edge/On-premises) | Edge Essentials (Edge/On-premises, Windows IoT client/server) | Windows Server (Edge/On-premises) |
| --- | --- | --- | --- | --- |
| Supported infrastructure for K8s cluster | Azure cloud | Azure Local, version 23H2 or later | Windows 10/11 IoT Enterprise<br>Windows 10/11 Enterprise<br>Windows 10/11 Pro<br>Windows Server 2019/2022 | Windows Server 2019<br>Windows Server 2022 |
| CNCF conformant | Yes | Yes | Yes | Yes |
| K8s cluster lifecycle management tools (create, scale, upgrade and delete clusters) | Az CLI<br>Az PowerShell<br>Azure Portal<br>ARM templates<br>Bicep<br>Bicep Kubernetes Provider<br>Azure Developer CLI | Azure Portal<br>Azure CLI<br>ARM templates<br>Bicep templates | PowerShell | PowerShell<br>Windows Admin Center |
| K8s cluster management plane | AKS is a managed Kubernetes offering. AKS control plane is hosted and managed by Microsoft. AKS worker nodes are created in customer subscriptions. | Kubernetes clusters are managed through Arc Resource Bridge which is automatically created when Azure local gets deployed. | Kubernetes clusters are self-managed, to preserve resources. | Kubernetes clusters are managed using a "management cluster", that is installed using PowerShell before Kubernetes workload clusters can be created. |
| Support for Kubectl or other open source K8s tool | Yes | Yes | Yes | Yes |
| Supported K8s Versions | Continuous updates to supported Kubernetes versions. For latest version support, run [az aks get-versions.](/cli/azure/aks#az_aks_get_versions) | Supports K8s only.<br>For latest version support, run: [az aksarc get-versions](/cli/azure/aks#az_aks_get_versions) | Supports K3s and K8s. For the latest K8s version support, visit [steps to prepare your machine for AKS Edge Essentials](aks-edge-howto-setup-machine.md#download-aks-edge-essentials). | Supports K8s only.<br>Continuous updates to supported Kubernetes versions. For latest version support, visit [AKS hybrid releases on GitHub.](https://github.com/Azure/aksArc/releases) |
| Azure Fleet Manager integration | Yes | No | No | No |
| Terraform integration | Yes | Yes (Preview) | No | No |
| Support for Taints and Label | Yes | Yes | Not validated – these settings do not persist when cluster is upgraded. | Yes |
| AKS Automatic | Yes | No | No | No |

## Monitoring and diagnostic capabilities

|   Feature       |     Azure Cloud    |     AKS on Azure Local    |      Edge Essentials (Windows IoT client/server)    |     Windows Server    |
| --- | --- | --- | --- | --- |
|     Azure Monitor Container Insights     |     Yes    |     Yes, via Arc extensions    |     Yes, via Arc extensions    |     Yes, via Arc extensions    |
|     Azure Monitor Managed Prometheus and control plane metrics scraping     |     Yes    |     Yes, via Arc extensions    |     Yes, via Arc extensions    |     Yes, via Arc extensions    |
|     Control plane audit logs    |     Yes    |     Yes, via Arc extensions    |     No    |     No    |
|     Platform/Shoebox metrics     |     Yes    |     Yes, via Arc extensions          |     No    |     No    |
|     Diagnostics log collection (local)    |     Yes    |     Yes    |     Yes    |     Yes    |

## Node pool capabilities

|  Feature                      | Azure Cloud | AKS on Azure Local    | Edge Essentials (Windows IoT client/server) | Windows Server |
| --- | --- | --- | --- | --- |
| Windows node pool support      | Yes<br>Windows Server 2019 Datacenter<br>Windows Server 2022 Datacenter | Yes<br>Windows Server 2019 Datacenter<br>Windows Server 2022 Datacenter | Yes<br>Windows Server 2022 Datacenter (Core) | Yes<br>Windows Server 2019 Datacenter<br>Windows Server 2022 Datacenter |
| Linux OS offerings            | Ubuntu 18.04<br>Azure Linux | [CBL-Mariner](https://github.com/microsoft/CBL-Mariner) | [CBL-Mariner](https://github.com/microsoft/CBL-Mariner) | [CBL-Mariner](https://github.com/microsoft/CBL-Mariner) |
| Container runtime             | Containerd for Linux and Windows nodes | Containerd for Linux and Windows nodes | Containerd for Linux and Windows nodes | Containerd for Linux and Windows nodes |
| Node pool auto-scaler         | Manual<br>Auto-scalar<br>Horizontal pod scalar | Manual<br>Auto-scalar | Manual | Manual<br>Auto-scalar<br>Horizontal pod scalar |
|     Azure container registry    |     Yes    |     Yes    |     Yes    |     Yes    |
|     Azure Container Instance     |     Yes    |     Yes    |     No    |     No    |
|     Start/stop a Kubernetes cluster    |     Yes     |     Yes    |     Yes    |     Yes    |
|     Virtual nodes     |     Yes    |     Yes    |     Yes    |     Yes    |
|     Private cluster    |     Yes    |     No    |     No    |     No    |
|     Node pool snapshot     |     Yes    |     No    |     No    |     No    |
|     Custom node configuration at deployment    |     Yes    |     Yes    |     Yes    |     Yes    |
|     SSH to nodes    |     Yes    |     Yes    |     Yes    |     Yes    |
|     Availability zones    |     Yes    |     No    |     No    |     No    |
|     Proximity placement groups    |     Yes    |     No    |     No    |     No    |

## Networking capabilities

|  Feature                      | Azure Cloud | AKS on Azure Local    | Edge Essentials (Windows IoT /Client/Server) | Windows Server |
| --- | --- | --- | --- | --- |
| Network creation and management | By default, Azure creates a virtual network and subnet for you. You can also choose an existing virtual network in which to create your AKS clusters. | Setting up networking parameters is a required prerequisite to deploy AKS on Azure Local.<br>Network must have connectivity and IP address availability for successful operation of cluster. | You must provide the IP address range for node IPs and Service IPs, that are available and have the right connection. The network configuration needed for the cluster is handled by AKS. See [AKS Edge Essentials networking](aks-edge-concept-networking.md). | You must create the network in Windows Server before creating an AKS cluster.<br>Network must have connectivity and IP address availability for successful operation of cluster. |
| Supported networking option    | Bring your own Azure virtual network for AKS clusters. | Static IP networks with/without VLAN ID. | Static IP address or use reserved IPs when using DHCP. | DHCP networks with/without VLAN ID.<br>Static IP networks with/without VLAN ID. |
| SDN support                   | Not applicable since the cluster runs on Azure. | Not yet                    | No                                              | Yes                  |
| Support for Arc Gateway        | N/A (works with Azure Application Gateway) | Yes                        | Yes – support for Azure IoT Operations only                    | No                   |
| Supported CNIs                | Azure CNI<br>Calico<br>Azure CNI Overlay (Cillium)<br>Bring your own CNI | Calico                     | Calico (K8s)<br>Flannel (K3s)                   | Calico               |
| Service Mesh                  | Istio addon      | Open Service Mesh, via Arc extensions. | Open Service Mesh, via Arc extensions.           | Open Service Mesh, via Arc extensions. |
| Load Balancer                 | Azure load balancer – Basic SKU or Standard SKU<br>Internal load balancer<br>Bring Your Own Load Balancer (BYOLB) | Bring your own load balancer (BYOLB)<br>MetalLB Arc Extension | KubeVIP<br>Bring your own load balancer (BYOLB) | HAProxy<br>SDN load balancer<br>Bring your own load balancer (BYOLB) |

## Storage features

| Feature                       | Azure Cloud                                                          | AKS on Azure Local                                                                                 | Edge Essentials (Windows IoT /Client/Server) | Windows Server                        |
| --- | --- | --- | --- | --- |
| Types of supported persistent volumes | Read Write Once<br>Read Write Many                                         | VHDX – ReadWriteOnce<br>SMB or NFS – ReadWriteMany<br>ACSA - ReadWriteMany                             | PVC using local storage<br>ACSA                 | VHDX – ReadWriteOnce<br>SMB or NFS - ReadWriteMany |
| Container storage interface (CSI) support | Yes                                                                      | Yes                                                                                                    | Yes                                             | Yes                                         |
| CSI drivers                       | Azure Storage<br>Azure Files and Azure Disk<br>Premium CSI drivers deployed by default. | Disk and Files (SMB and NFS) drivers installed by default.                                             | Support for SMB and NFS storage drivers.        | Support for SMB and NFS storage drivers.     |
| Dynamic provisioning support      | Yes                                                                      | Yes                                                                                                    | Yes                                             | Yes                                         |
| Volume resizing support           | Yes                                                                      | Yes                                                                                                    | Yes                                             | Yes                                         |
| Volume snapshots support          | Yes                                                                      | No                                                                                                     | No                                              | No                                          |

## Security and authentication options

| Feature                       | Azure Cloud | AKS on Azure Local    | Edge Essentials (Windows IoT /Client/Server) | Windows Server |
| --- | --- | --- | --- | --- |
| Access to K8s cluster             | Kubectl         | Kubectl                   | Kubectl                                         | Kubectl              |
| K8s cluster authorization (RBAC)  | Kubernetes RBAC<br>Azure RBAC | Kubernetes RBAC<br>Azure RBAC | Kubernetes RBAC                                 | Kubernetes RBAC      |
| K8s cluster authentication        | Certificate based Kubeconfig<br>Microsoft Entra ID | Certificate based Kubeconfig<br>Microsoft Entra ID | Certificate based Kubeconfig<br>Microsoft Entra ID | Certificate based Kubeconfig<br>Microsoft Entra ID |
| Support for network policies      | Yes             | No                        | No                                              | Yes – only for Linux containers |
| Support for workload identity     | Yes             | Yes                       | Yes - (Support for AIO only)                    | Yes                  |
| Limit source networks that can access API server | Yes | Yes | Yes | Yes |
| Encrypt etcd secrets              | Yes             | Yes                       | Yes                                             | Yes                  |
| Certificate rotation and encryption | Yes           | Yes                       | Yes                                             | Yes                  |
| Secrets store CSI driver          | Yes             | Yes                       | Yes                                             | Yes                  |
| gMSA support                      | Yes             | No                        | Yes                                             | Yes                  |
| Azure Policy                      | Yes             | Yes, via Arc extensions   | Yes, via Arc extensions                         | Yes, via Arc extensions |
| Azure Defender                    | Yes             | Yes, via Arc extensions (preview) | Yes, via Arc extensions (preview)         | Yes, via Arc extensions (preview) |

## Pricing and SLA details

| Feature                       | Azure Cloud                                                                           | AKS on Azure Local                        | Edge Essentials (Windows IoT /Client/Server) | Windows Server                                               |
| --- | --- | --- | --- | --- |
| Pricing                           | Unlimited free clusters, pay for on-demand compute of worker node VMs.<br>Paid tier available with uptime SLA, support for 5k nodes. | Included in Azure Local at no extra cost  | Cost is per device per month.                        | Pricing is based on the number of workload cluster vCPUs. Control plane nodes & load balancer VMs are free. |
| Azure hybrid benefit support       | Not applicable                                                                            | Not applicable - AKS already included at no extra cost. | No                                              | Yes                                                               |
| SLA                               | Paid uptime SLA clusters for production with fixed cost on the API + worker node compute, storage and networking costs. | No SLA offered as the K8s cluster is running on premises | No SLA offered as the K8s cluster is running on premises | No SLA offered as the K8s cluster is running on premises           |

AI/ML capabilities offered in each platform:

|  Feature                      | Azure Cloud | AKS on Azure Local    | Edge Essentials (Windows IoT /Client/Server) | Windows Server |
| --- | --- | --- | --- | --- |
| GPU support                       | Yes             | Yes                       | Yes                                             | Yes                  |
| KAITO (K8s AI toolchain operator) | Yes             | Yes, via Arc extensions   | No                                              | No                   |
| Edge RAG                          | Yes             | Yes                       | No                                              | No                   |

## Next steps

- Overview of [Azure Kubernetes Service (AKS)](aks-overview.md)
- [Deploy a Linux application on a Kubernetes cluster](deploy-linux-application.md)
- [Deploy a Windows Server application on a Kubernetes cluster](deploy-windows-application.md)
