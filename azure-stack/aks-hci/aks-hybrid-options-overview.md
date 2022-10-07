---
title: What are AKS hybrid deployment options?
description: Azure Kubernetes Service hybrid is an on-premises Kubernetes implementation of Azure Kubernetes Service (AKS), which automates running containerized applications at scale.
ms.topic: overview
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 09/20/2022
ms.reviewer: abha
ms.date: 09/20/2022

# Intent: As an IT Pro, I want to use AKS on-premises to manage and run containerized workloads.
# Keyword: on-premises Kubernetes

---
# What are AKS hybrid deployment options?

AKS hybrid deployment options simplify simplifies managing, deploying and maintaining a Kubernetes cluster on-premises, making it quicker to get started hosting Linux and Windows containers in your datacenter. As a hosted Kubernetes service, AKS hybrid handles critical day-to-day management, such as easy upgrades and automatic certificate rotations so you can focus on running and developing containerized workloads. AKS hybrid also natively connects to Azure Arc, so you have a single Azure control plane to manage all your AKS clusters running anywhere - on Azure and on-premises.

You can create an AKS cluster using:

- PowerShell
- Windows Admin Center
- The Azure CLI (preview)
- The Azure portal (preview)
- Azure Resource Manager templates (preview)

When you deploy an AKS cluster, you can choose default options that configure the Kubernetes control plane nodes and Kubernetes cluster settings for you. We offer the flexibility to configure advanced settings like Azure Active Directory (Azure AD), monitoring, and other features during and after the deployment process.

For more information on Kubernetes basics, see [Kubernetes core concepts for AKS](kubernetes-concepts.md).

## Why use AKS hybrid for containerized applications?
If you've been using AKS in Azure to deploy and run your applications, you'll find it very easy to get started with running AKS on-premises. While you can certainly manage a few containers manually using using Docker and Windows, apps often make use of five, ten, or even hundreds of containers, which is what a Kuberenetes orchestrator helps with.

Kubernetes is an open-source orchestrator for automating container management at scale. AKS simplifies on-premises Kubernetes deployment by providing wizards you can use to set up Kubernetes, essential add-ons, and create Kubernetes clusters to host your workloads.

Here's some of the functionality AKS provides:

### Native integration with Azure Arc-enabled Kubernetes
With AKS hybrid, you can connect your AKS clusters to Azure Arc while creating the cluster. Once connected to Azure Arc-enabled Kubernetes, you can access your AKS clusters running on-premises via Azure Portal and deploy management services such as GitOps and Azure Policy as well as data services such as SQL Managed Instance and PostgreSQL Hyperscale. To learn more about Azure Arc-enabled Kubernetes, see the [Azure Arc overview](/azure/azure-arc/kubernetes/overview).

### Create and manage AKS clusters using Azure Portal and ARM templates
You can now use familiar tools like Azure Portal and ARM templates to manage your AKS hybrid clusters running on Azure Stack HCI or Windows Server. We automatically enable Azure Arc on all AKS hybrid clusters. Through Azure Arc, you can use your AAD identity for cluster admin authentication and have a simplified, end to end governance and security story for your AKS clusters through Azure Defender. We've also focused on delivering a consistent user experience for all your AKS clusters. If you’ve ever used Azure Portal or Azure CLI to create and manage AKS clusters in Azure, you’ll feel right at home using AKS hybrid on Windows Server or Azure Stack HCI. To learn more, visit [AKS hybrid cluster provisioning from Azure](aks-hybrid-preview-overview.md).

### Integrated logging and monitoring
Once you've connected your cluster to Azure Arc, you can use Azure Monitor for monitoring the health of your Kubernetes cluster and applications. Azure Monitor for containers gives you performance visibility by collecting memory and processor metrics from controllers, nodes, and containers. Metrics and container logs are automatically collected for you and are sent to the metrics database in Azure Monitor, while log data is sent to your Log Analytics workspace. To learn more about Azure Monitor, see the [container insights overview](/azure/azure-monitor/containers/container-insights-overview).

### Software defined networking for your Kubernetes nodes and containerized applications
With SDN integration on AKS on Azure Stack HCI (currently in preview), customers can now bring in their own networks and attach the AKS-HCI nodes to these networks. Additionally, customers can use the SDN Software Load Balancer to provide load balancer services for their containerized applications. To learn more, visit [software defined networking with AKS](software-defined-networking.md).

### Autoscaler to automatically resize your Kubernetes node pools
To keep up with application demands in AKS hybrid, you may need to adjust the number and size of nodes that run your workloads. The cluster autoscaler component can watch for pods in your cluster that can't be scheduled because of resource constraints. When issues are detected, the number of nodes in a node pool is increased to meet the application demand. Nodes are also regularly checked for a lack of running pods, with the number of nodes then decreased as needed. This ability to automatically scale up or down the number of nodes in your AKS hybrid cluster lets you run an efficient, cost-effective cluster.

### Deploy and manage Windows-based containerized apps 
AKS hybrid fully supports running both Linux-based and Windows-based containers. When you create a Kubernetes cluster on Azure Stack HCI, you can choose whether to create node pools (groups of identical Kubernetes cluster nodes) to run Linux containers, Windows containers, or both. AKS creates the Linux and Windows nodes so that you don't have to directly manage the Linux or Windows operating systems.

### AKS hybrid supports deploying GPU-enabled nodes
AKS hybrid supports deploying GPU-enabled node pools on top of NVIDIA Tesla T4 GPUs using Discrete Device Assignment (DDA) mode also known as GPU Passthrough. In this mode, one or more physical GPUs are dedicated to a single worker node with a GPU enabled VM size which gets full access to the entire GPU hence offering high level application compatibility as well as better performance. To learn more about GPU-enabled node pools, visit [GPU documentation](https://github.com/Azure/aks-hci/blob/main/preview/GPU/GPU-private-preview-documentation.md).

## Azure Kubernetes Service hybrid deployment options

Depending on your hardware class, compute availability and your Kubernetes adoption process, we offer multiple AKS hybrid deployment options to get started.

AKS hybrid deployment option | Host OS | Minimum compute requirement | Failover clustering support | AKS cluster management tools | Azure Arc integration | 
|-------|-------------------|-----------|----------|---------|---------|
AKS on Windows Server | Windows Server 2019 </br> Windows Server 2022 </br>  | Memory: 30GB per node </br> CPU cores: 16 per node </br> Disk Space: 128 GB per node | Single node OR </br> 2-8 node failover cluster | Local PowerShell </br> Windows Admin Center | Manual Azure Arc integration | 
AKS on Azure Stack HCI | Azure Stack HCI 21H2 | Memory: 30GB per node </br> CPU cores: 16 per node </br> Disk Space: 128 GB per node | Single node OR </br> 2-8 node Azure Stack HCI cluster | Local PowerShell  </br> Windows Admin Center | Manual Azure Arc integration | 
AKS cluster provisioning from Azure (PREVIEW) | Windows Server 2019 </br> Windows Server 2022 </br> Azure Stack HCI 21H2 | Memory: 32GB per node </br> CPU cores: 16 per node </br> Disk Space: 128 GB per node | Single node OR </br> 2 node cluster | Azure Portal  </br> Azure CLI </br> Azure Resource Manager templates | Automatic Azure Arc integration | 
AKS on Windows IOT (PREVIEW) | Windows 10/11 IoT Enterprise </br> Windows 10/11 Enterprise </br> Windows 10/11 Pro </br> Windows Server 2019/2022 | Free memory: > 2GB </br> CPU cores: 2 </br> Clock speed: 1.8 GHz </br> Free disk Space: 14 GB | No | Local PowerShell | Manual Azure Arc integration |

## Next steps

To get started with AKS hybrid, see the following articles:

- [AKS on Azure Stack HCI or Windows Server overview](overview.md)
- [AKS hybrid cluster provisioning from Azure overview](aks-hybrid-preview-overview.md)
