---
title: What is AKS enabled by Arc?
description: AKS enabled by Arc is an on-premises Kubernetes implementation of Azure Kubernetes Service (AKS), which automates running containerized applications at scale.
ms.topic: overview
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 12/01/2023
ms.reviewer: abha
ms.date: 10/07/2022

# Intent: As an IT Pro, I want to use AKS on-premises to manage and run containerized workloads.
# Keyword: on-premises Kubernetes

---
# What is AKS enabled by Arc?

AKS simplifies managing, deploying, and maintaining a Kubernetes cluster on-premises, making it quicker to get started hosting Linux and Windows containers in your datacenter. As a hosted Kubernetes service, AKS handles critical day-to-day management, such as upgrades and automatic certificate rotations, so you can focus on running and developing containerized workloads. AKS also natively connects to Azure Arc, so you have a single Azure control plane to manage all your AKS clusters running anywhere - on Azure and on-premises.

You can create an AKS cluster using:

- PowerShell
- Windows Admin Center
- The Azure CLI (preview)
- The Azure portal (preview)
- Azure Resource Manager templates (preview)

When you deploy a Kubernetes cluster, you can choose default options that configure the Kubernetes control plane nodes and Kubernetes cluster settings for you. We offer the flexibility to configure advanced settings like Microsoft Entra ID, monitoring, and other features during and after the deployment process.

For more information about Kubernetes basics, see [Kubernetes core concepts for AKS](kubernetes-concepts.md).

## Why use Kubernetes for containerized applications?

If you've been using AKS in Azure to deploy and run your Kubernetes managed applications, it's easy to get started with running the same application using AKS on-premises. While you can certainly manage a few containers manually using Docker and Windows, apps often make use of five, ten, or even hundreds of containers, which is what a Kubernetes orchestrator helps with.

Kubernetes is an open-source orchestrator for automating container management at scale. AKS simplifies on-premises Kubernetes deployment by providing wizards you can use to set up Kubernetes, essential add-ons, and create Kubernetes clusters to host your workloads.

Here's some of the functionality AKS provides:

### Native integration using Azure Arc

With AKS, you can connect your Kubernetes clusters to Azure. Once connected to Azure Arc-enabled Kubernetes, you can access your Kubernetes clusters running on-premises via the Azure portal and deploy management services such as GitOps and Azure Policy. You can also deploy data services such as SQL Managed Instance and PostgreSQL Hyperscale. For more information about Azure Arc-enabled Kubernetes, see the [Azure Arc overview](/azure/azure-arc/kubernetes/overview).

### Create and manage Kubernetes clusters using Azure portal and Resource Manager templates (preview)

You can now use familiar tools like the Azure portal and Azure Resource Manager templates to manage your Kubernetes clusters running on Azure Stack HCI. We automatically enable Azure Arc on all Kubernetes clusters. Through Azure Arc, you can use your Microsoft Entra identity for cluster admin authentication and have a simplified, end-to-end governance and security story for your AKS clusters through Azure Defender. We've also focused on delivering a consistent user experience for all your AKS clusters. If you've used the Azure portal or Azure CLI to create and manage Kubernetes clusters in Azure, it's easy to use AKS hybrid. For more information, see [AKS hybrid cluster provisioning from Azure](aks-hybrid-preview-overview.md).

### Integrated logging and monitoring

Once you've connected your cluster to Azure Arc, you can use Azure Monitor for monitoring the health of your Kubernetes cluster and applications. Azure Monitor for containers gives you performance visibility by collecting memory and processor metrics from controllers, nodes, and containers. Metrics and container logs are automatically collected for you and are sent to the metrics database in Azure Monitor, while log data is sent to your Log Analytics workspace. For more information about Azure Monitor, see the [container insights overview](/azure/azure-monitor/containers/container-insights-overview).

### Software defined networking for your Kubernetes nodes and containerized applications

With SDN integration on Azure Stack HCI, you can now bring in your own networks and attach the Kubernetes nodes to these networks. Additionally, you can use the SDN Software Load Balancer to provide load balancer services for their containerized applications. For more information, see [software defined networking with AKS](software-defined-networking.md).

### Automatically resize your Kubernetes node pools

To keep up with application demands, you might need to adjust the number and size of nodes that run your workloads. The cluster autoscaler component can watch for pods in your cluster that can't be scheduled because of resource constraints. When issues are detected, the number of nodes in a node pool is increased to meet the application demand. Nodes are also regularly checked for a lack of running pods, with the number of nodes then decreased as needed. This ability to automatically scale up or down the number of nodes in your Kubernetes cluster lets you run an efficient, cost-effective environment.

### Deploy and manage Windows-based containerized apps

AKS fully supports running both Linux-based and Windows-based containers. When you create a Kubernetes cluster on Azure Stack HCI, you can choose whether to create node pools (groups of identical Kubernetes cluster nodes) to run Linux containers, Windows containers, or both. AKS creates the Linux and Windows nodes so that you don't have to directly manage the Linux or Windows operating systems.

### AKS supports deploying GPU-enabled nodes

AKS supports deploying GPU-enabled node pools on top of NVIDIA Tesla T4 GPUs using Discrete Device Assignment (DDA) mode, also known as *GPU Passthrough*. In this mode, one or more physical GPUs are dedicated to a single worker node with a GPU enabled VM size which gets full access to the entire GPU hence offering high level application compatibility as well as better performance. For more information about GPU-enabled node pools, see the [GPU documentation](deploy-gpu-node-pool.md).

## AKS deployment options

Depending on your hardware class, compute availability and your Kubernetes adoption process, we offer multiple AKS deployment options to get started:

Deployment option | Host OS | Minimum compute requirement | Failover clustering support | Management tools | Azure Arc integration |
|-------|-------------------|-----------|----------|---------|---------|
AKS on Windows Server | Windows Server 2019 </br> Windows Server 2022 </br>  | Memory: 30GB per node </br> CPU cores: 16 per node </br> Disk Space: 128 GB per node | Single node OR </br> 2-8 node failover cluster | Local PowerShell </br> Windows Admin Center | Manual Azure Arc integration |
AKS on Azure Stack HCI | Azure Stack HCI 21H2 | Memory: 30GB per node </br> CPU cores: 16 per node </br> Disk Space: 128 GB per node | Single node OR </br> 2-8 node Azure Stack HCI cluster | Local PowerShell  </br> Windows Admin Center | Manual Azure Arc integration |
AKS cluster provisioning from Azure (PREVIEW) | Windows Server 2019 </br> Windows Server 2022 </br> Azure Stack HCI 21H2 | Memory: 32GB per node </br> CPU cores: 16 per node </br> Disk Space: 128 GB per node | Single node OR </br> 2 node cluster | Azure portal  </br> Azure CLI </br> Azure Resource Manager templates | Automatic Azure Arc integration |
AKS Edge Essentials | Windows 10/11 IoT Enterprise </br> Windows 10/11 Enterprise </br> Windows 10/11 Pro </br> Windows Server 2019/2022 | Free memory: > 2GB </br> CPU cores: 2 </br> Clock speed: 1.8 GHz </br> Free disk Space: 14 GB | No | Local PowerShell | Manual Azure Arc integration |

## Next steps

To get started with AKS, see the following articles:

- [Review AKS on Azure Stack HCI 23H2 prerequisites](aks-hci-network-system-requirements.md)
