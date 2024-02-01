---
title: What's new in Azure Stack HCI, version 23H2 release
description: Find out what's new in Azure Stack HCI, version 23H2 release.
ms.topic: overview
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 01/31/2024
---

# What's new in Azure Stack HCI, version 23H2

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article lists the various features and improvements that are available in Azure Stack HCI, version 23H2.

Azure Stack HCI, version 23H2 is the latest version of the Azure Stack HCI solution that focuses on cloud-based deployment and updates, cloud-based monitoring, new and simplified experience for Arc VM management, security, and more. For an earlier version of Azure Stack HCI, see [What's new in Azure Stack HCI, version 22H2](./whats-new-in-hci-22h2.md).

The following sections briefly describe the various features and enhancements in Azure Stack HCI, version 23H2 releases.

## Features and improvements in 2311.2 GA

This section lists the new features and improvements in the 2311.2 General Availability (GA) release for Azure Stack HCI, version 23H2.

> [!IMPORTANT]
> The production workloads are only supported on the Azure Stack HCI systems running the generally available 2311.2 release. To run the GA version, start with a new 2311 deployment and then update to 2311.2.

In this generally available release of the Azure Stack HCI, version 23H2, all the features that were available with the [2310](#features-and-improvements-in-2310) and [2311](#features-and-improvements-in-2311) preview releases are also now generally available. In addition, the following improvements and enhancements are available:

### Deployment changes

With this release:

- Deployment is supported using existing storage accounts and existing Azure Key Vaults.
- A failed deployment can be run using the **Rerun deployment** option that becomes available in the cluster **Overview** page.
- Network settings such as storage traffic priority, cluster traffic priority, storage traffic bandwidth reservation, jumbo frames, and RDMA protocol can all be customized.
- Validation must be started explicitly via the **Start validation** button.

For more information, see [Deploy via Azure portal](./deploy/deploy-via-portal.md).

### Add server and repair server changes

- Bug fixes in the add server and repair server scenarios. For more information, see the [Fixed issues in 2311.2](./known-issues-2311-2.md).

### Arc VM management changes

In this release:

- Guest management is available via Azure CLI. For more information, see [Enable guest management](./manage/manage-arc-virtual-machines.md).
- Proxy is supported for Arc VMs. For more information, see [Set up proxy for Arc VMs on Azure Stack HCI](./manage/create-arc-virtual-machines.md#create-a-vm-from-network-interface).
- Storage path selection is available during the VM image creation via the Azure portal. For more information, see [Create a VM image from Azure Marketplace via the Azure portal](./manage/virtual-machine-image-azure-marketplace.md)

### Migration of Hyper-V VMs to Azure Stack HCI (preview)

You can now migrate Hyper-V VMs to Azure Stack HCI using Azure Migrate . This feature is currentnly in Preview. For more information, see [Migration of Hyper-V VMs using Azure Migrate to Azure Stack HCI (preview)](./index.yml)

### Monitoring changes

In the Azure portal, you can now monitor platform metrics of your cluster by navigating to the **Monitoring** tab on your cluster’s **Overview** page. This tab offers a quick way to view graphs for different platform metrics. You can select any graph to open it in Metrics Explorer for a more in-depth analysis. For more information, see [Monitor Azure Stack HCI through the Monitoring tab](./manage/monitor-cluster-with-metrics.md#monitor-azure-stack-hci-through-the-monitoring-tab).

### Security via Microsoft Defender for Cloud (preview)

You can now use Microsoft Defender for Cloud to help improve the security posture of your Azure Stack HCI environment and protect against existing and evolving threats. This feature is currently in Preview. For more information, see [Microsoft Defender on Cloud for Azure Stack HCI (Preview)](./manage/manage-security-with-defender-for-cloud.md).

### Supported workloads

Starting with this release, the following workloads are generally available on Azure Stack HCI:

- Azure Kubernetes Service (AKS) on Azure Stack HCI. For more information, see [Set up an Azure Kubernetes Service host on Azure Stack HCI and deploy a workload cluster using PowerShell](/azure/aks/hybrid/kubernetes-walkthrough-powershell).
- Azure Virtual Desktops (AVD) on Azure Stack HCI. For more information, see [Deploy AVD on Azure Stack HCI](/azure/virtual-desktop/azure-stack-hci-overview).

### AKS on Azure Stack HCI, version 23H2

The following Kubernetes cluster deployment and management capabilities are available:

- **New CLI extension and Azure portal experience**. The new GA version of the Azure CLI extension starting with this release is [**az aksarc**](/cli/azure/aksarc). For more information, see [Create Kubernetes clusters using Azure CLI](aks-create-clusters-cli.md). You can also see the new portal cluster creation experience in [Create Kubernetes clusters using the Azure portal](aks-create-clusters-portal.md).  
- **Support for logical networks**. Starting with this release, creating Kubernetes clusters on Azure Stack HCI 23H2 requires [logical networks](/azure-stack/hci/manage/create-logical-networks?tabs=azurecli) as a prerequisite. For more information, see [How to create logical networks](aks-networks.md).
- **Available K8S versions and VM sizes**. You can use [`az aksarc get-versions`](/cli/azure/aksarc#az-aksarc-get-versions) and [`az aksarc vmsize list`](/cli/azure/aksarc/vmsize#az-aksarc-vmsize-list) to get the available Kubernetes versions and VM sizes on your system.
- **Support for Taints and labels**. See [Manage node pools](manage-node-pools.md) for a cluster, and [Use cluster labels](cluster-labels.md) to set the taints and labels for node pools.
- **Support for upgrading a Kubernetes cluster using Azure CLI**. You can use the Azure CLI to upgrade a Kubernetes cluster to a newer version and apply the OS version updates. For more information, see [Upgrade a Kubernetes cluster](cluster-upgrade.md).
- **Support for both disks and files for persistent volumes**. To support stateful applications, you can use the default storage class for disks, or a custom storage class that points to a specific storage path. See [Use persistent volumes](persistent-volume.md) and [Use Container Storage Interface (CSI) disk drivers](container-storage-interface-disks.md). You can also create persistent volumes on file shares, in either SMB or NFS. For more information, see [Use Container Storage Interface (CSI) file drivers](container-storage-interface-files.md).
- **Support for NVIDIA A2**. You can now create node pools with new VM sizes with GPU NVIDIA A2. For more information, see [Use GPUs for compute-intensive workloads](deploy-gpu-node-pool.md).
- **Diagnostics settings**. You can export audit logs and other control plane logs to one or more destinations. For more information, see [Diagnostic settings in Azure Monitor](/azure/azure-monitor/essentials/diagnostic-settings).

For more information, see [What's new in AKS on Azure Stack HCI, version 23H2](/azure/aks/hybrid/aks-whats-new-23h2).

## Features and improvements in 2311

This section lists the new features and improvements in the 2311 release of Azure Stack HCI, version 23H2.

### AKS on Azure Stack HCI, version 23H2

Starting with this release, you can run Azure Kubernetes Service (AKS) workloads on your Azure Stack HCI system. AKS on Azure Stack HCI, version 23H2 uses Azure Arc to create new Kubernetes clusters on Azure Stack HCI directly from Azure. For more information, see [What's new in AKS on Azure Stack HCI, version 23H2](/azure/aks/hybrid/aks-whats-new-23h2).

The following Kubernetes cluster deployment and management capabilities are available:

- **Simplified infrastructure deployment on Azure Stack HCI**. In this release, the infrastructure components of AKS on Azure Stack HCI 23H2 including the Arc Resource Bridge, Custom Location, and the Kubernetes Extension for the AKS Arc operator, are all deployed as part of the Azure Stack HCI deployment. For more information, see [Deploy Azure Stack HCI cluster using the Azure portal (preview)](./deploy/deploy-via-portal.md).
- **Integrated infrastructure upgrade on Azure Stack HCI**. The whole lifecycle management of AKS Arc infrastructure follows the same approach as the other components on Azure Stack HCI 23H2. For more information, see [Infrastructure component updates for AKS on Azure Stack HCI (preview)](/azure/aks/hybrid/infrastructure-components).
- **New Azure consistent CLI**. Starting with this preview release, a new consistent command line experience is available to create and manage Kubernetes clusters. <!--For more information, see [Azure CLI extension az akshybrid reference](https://learn.microsoft.com/cli/azure/akshybrid).-->
- **Cloud-based management**. You can now create and manage Kubernetes clusters on Azure Stack HCI with familiar tools such as Azure portal and Azure CLI. For more information, see [Create Kubernetes clusters using Azure CLI](/azure/aks/hybrid/aks-create-clusters-cli).
- **Support upgrading a Kubernetes cluster using Azure CLI**. You can use the Azure CLI to upgrade the Kubernetes cluster to a newer version and apply the OS version updates. For more information, see [Upgrade an Azure Kubernetes Service (AKS) cluster (preview)](/azure/aks/hybrid/cluster-upgrade).
- **Support Azure Container Registry to deploy container images**. In this release, you can deploy container images from a private container registry using Azure Container Registry to your Kubernetes clusters running on Azure Stack HCI. For more information, see [Deploy from private container registry to on-premises Kubernetes using Azure Container Registry and AKS Arc](/azure/aks/hybrid/deploy-container-registry).
- **Support for managing and scaling the node pools**. For more information, see [Manage multiple node pools in AKS Arc](/azure/aks/hybrid/manage-node-pools). 
- **Support for Linux and Windows Server containers**. For more information, see [Create Windows Server containers](/azure/aks/hybrid/aks-create-containers).

### Support for web proxy

This release supports configuring a web proxy for your Azure Stack HCI system. You perform this optional configuration if your network uses a proxy server for internet access. For more information, see [Configure web proxy for Azure Stack HCI](./manage/configure-proxy-settings-23h2.md).

### Removal of GMSA accounts

In this release, the Group Managed Service Accounts (gMSA) created during the Active Directory preparation are removed. For more information, see [Prepare Active Directory](./deploy/deployment-prep-active-directory.md).

<!--### Guest management operations via Azure CLI

In this release, you can perform an extended set of guest management operations via the Azure CLI.-->

## Features and improvements in 2310

This section lists the new features and improvements in the 2310 release of Azure Stack HCI, version 23H2.

### Cloud-based deployment

For servers running Azure Stack HCI, version 23H2, you can perform new deployments via the cloud. You can deploy an Azure Stack HCI cluster in one of the two ways - via the Azure portal or via an Azure Resource Manager deployment template.

For more information, see [Deploy Azure Stack HCI cluster using the Azure portal](./deploy/deploy-via-portal.md) and [Deploy Azure Stack HCI via the Azure Resource Manager deployment template](./deploy/deployment-azure-resource-manager-template.md).

### Cloud-based updates

This new release has the infrastructure to consolidate all the relevant updates for the OS, software agents, Azure Arc infrastructure, and OEM drivers and firmware into a unified monthly update package. This comprehensive update package is identified and applied from the cloud through the Azure Update Manager tool. Alternatively, you can apply the updates using the PowerShell.

For more information, see [Update your Azure Stack HCI cluster via the Azure Update Manager](./update/azure-update-manager-23h2.md) and [Update your Azure Stack HCI via the PowerShell](./update/update-via-powershell-23h2.md).​

### Cloud-based monitoring

#### Respond to health alerts

This release integrates the Azure Monitor alerts with Azure Stack HCI so that any health alerts generated within your on-premises Azure Stack HCI system are automatically forwarded to Azure Monitor alerts. You can link these alerts with your automated incident management systems, ensuring timely and efficient response.

For more information, see [Respond to Azure Stack HCI health alerts using Azure Monitor alerts](./manage/health-alerts-via-azure-monitor-alerts.md).

#### Monitor metrics

This release also integrates the Azure Monitor metrics with Azure Stack HCI so that you can monitor the health of your Azure Stack HCI system via the metrics collected for compute, storage, and network resources. This integration enables you to store cluster data in a dedicated time-series database that you can use to analyze data from your Azure Stack HCI system.
 
For more information, see [Monitor Azure Stack HCI with Azure Monitor metrics](./manage/monitor-cluster-with-metrics.md).

#### Enhanced monitoring capabilities with Insights
 
With Insights for Azure Stack HCI, you can now monitor and analyze performance, savings, and usage insights about key Azure Stack HCI features, such as ReFS deduplication and compression. To use these enhanced monitoring capabilities, ensure that your cluster is deployed, registered, and connected to Azure, and enrolled in monitoring. For more information, see [Monitor Azure Stack HCI features with Insights](./manage/monitor-features.md).

### Azure Arc VM management

Beginning this release, the following Azure Arc VM management capabilities are available:

- **Simplified Arc Resource Bridge deployment**. The Arc Resource Bridge is now deployed as part of the Azure Stack HCI deployment. 
    For more information, see [Deploy Azure Stack HCI cluster using the Azure portal](./deploy/deploy-via-portal.md).
- **New RBAC roles for Arc VMs**. This release introduces new RBAC roles for Arc VMs.
    For more information, see [Manage RBAC roles for Arc VMs](./manage/assign-vm-rbac-roles.md).
- **New Azure consistent CLI**. Beginning this preview release, a new consistent command line experience is available to create VM and VM resources such as VM images, storage paths, logical networks, and network interfaces. 
    For more information, see [Create Arc VMs on Azure Stack HCI](./manage/create-arc-virtual-machines.md).
- **Support for static IPs**. This release has the support for static IPs. 
    For more information, see [Create static logical networks on Azure Stack HCI](./manage/create-logical-networks.md#create-a-static-logical-network-via-portal).
- **Support for storage paths**. While default storage paths are created during the deployment, you can also specify custom storage paths for your Arc VMs. 
    For more information, see [Create storage paths on Azure Stack HCI](./manage/create-storage-path.md).
- **Support for Azure VM extensions on Arc VMs on Azure Stack HCI**. Starting with this preview release, you can also enable and manage the Azure VM extensions that are supported on Azure Arc, on Azure Stack HCI Arc VMs created via the Azure CLI. You can manage these VM extensions using the Azure CLI or the Azure portal. 
    For more information, see [Manage VM extensions for Azure Stack HCI VMs](./manage/virtual-machine-manage-extension.md).
- **Trusted launch for Azure Arc VMs**. Azure Trusted Launch protects VMs against boot kits, rootkits, and kernel-level malware. Starting this preview release, some of those Trusted Launch capabilities are available for Arc VMs on Azure Stack HCI.
    For more information, see [Trusted launch for Arc VMs](./manage/trusted-launch-vm-overview.md).

### Security capabilities

The new installations with this release of Azure Stack HCI start with a *secure-by-default* strategy. The new version #has a tailored security baseline coupled with a security drift control mechanism and a set of well-known security features enabled by default. This release provides:

- A tailored security baseline with over 300 security settings configured and enforced with a security drift control mechanism. For more information, see [Security baseline settings for Azure Stack HCI](../hci/concepts/secure-baseline.md).
- Out-of-box protection for data and network with SMB signing and BitLocker encryption for OS and Cluster Shared Volumes. For more information, see [BitLocker encryption for Azure Stack HCI](./concepts/security-bitlocker.md).
- Reduced attack surface as Windows Defender Application Control is enabled by default and limits the applications and the code that you can run on the core platform. For more information, see [Windows Defender Application Control for Azure Stack HCI](./concepts/security-windows-defender-application-control.md).

### Capacity management

In this release, you can add and remove servers, or repair servers from your Azure Stack HCI system via the PowerShell.

For more information, see [Add server](./manage/add-server.md) and [Repair server](./manage/repair-server.md).

### ReFS deduplication and compression

This release introduces the Resilient File System (ReFS) deduplication and compression feature designed specifically for active workloads, such as Azure Virtual Desktop (AVD) on Azure Stack HCI. Enable this feature using Windows Admin Center or PowerShell to optimize storage usage and reduce cost.

For more information, see [Optimize storage with ReFS deduplication and compression in Azure Stack HCI](./manage/refs-deduplication-and-compression.md).

## Next steps

- [Read the blog about What’s new for Azure Stack HCI at Microsoft Ignite 2023](https://aka.ms/ashciignite2023).
- For Azure Stack HCI, version 23H2 deployments:
    - Read the [Deployment overview](./deploy/deployment-introduction.md).
    - Learn how to [Deploy Azure Stack HCI, version 23H2 via the Azure portal](./deploy/deploy-via-portal.md).
