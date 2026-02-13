---
title: What's new in Hyperconverged Deployments of Azure Local previous releases - version 23xx
description: Find out about the new features and enhancements in the Azure Local previous releases - version 23xx.
ms.topic: overview
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.date: 02/11/2026
ms.subservice: hyperconverged
---

# What's new in hyperconverged deployments of Azure Local previous releases - version 23xx?

This article lists the features and improvements that are available in hyperconverged deployments of Azure Local (*formerly Azure Stack HCI*) previous releases - version 23xx.

> [!NOTE]
> Azure Local previous releases - version 23xx are not in a supported state. For more information, see [Azure Local release information](../release-information-23h2.md).

## Features and improvements in 2311.5

This release primarily fixes bugs. See the [Fixed issues list](../known-issues.md?view=azloc-previous&preserve-view=true) to understand the bug fixes.

## Features and improvements in 2311.4

This release primarily fixes bugs. See the [Fixed issues list](../known-issues.md?view=azloc-previous&preserve-view=true) to understand the bug fixes.

## Features and improvements in 2311.3

A new Azure built-in role called **Azure Resource Bridge Deployment Role** is available to improve the security posture for Azure Local. If you provisioned a cluster before January 2024, assign the Azure Resource Bridge Deployment User role to the Arc Resource Bridge service principal.

The role follows the principle of least privilege. Assign it to the Arc Resource Bridge service principal, `clustername.arb`, before you update the cluster.

Remove the previously assigned permissions to take advantage of the constraint permission. Follow the steps to [Assign an Azure RBAC role via the portal](/azure/role-based-access-control/role-assignments-portal?tabs=delegate-condition). Search for and assign the Azure Resource Bridge Deployment role to the member: `<deployment-cluster-name>-cl.arb`.

This release also includes an update health check that confirms the assignment of the new role before applying the update.

## Features and improvements in 2311.2 GA

This section lists the new features and improvements in the 2311.2 General Availability (GA) release for Azure Local.

> [!IMPORTANT]
> Production workloads are only supported on the Azure Local systems running the generally available 2311.2 release. To run the GA version, start with a new 2311 deployment and then update to 2311.2.

In this generally available release of Azure Local, all the features that were available with the [2311](#features-and-improvements-in-2311) preview releases are also now generally available. In addition, the following improvements and enhancements are available:

### Deployment changes

With this release:

- Deployment supports existing storage accounts.
- The **Rerun deployment** option becomes available in the cluster **Overview** page for a failed deployment.
- You can customize network settings such as storage traffic priority, cluster traffic priority, storage traffic bandwidth reservation, jumbo frames, and RDMA protocol.
- You must explicitly start validation via the **Start validation** button.

For more information, see [Deploy via Azure portal](../deploy/deploy-via-portal.md).

### Add server and repair server changes

- Bug fixes in the Add server and Repair server scenarios. For more information, see the [Fixed issues in 2311.2](../known-issues.md?view=azloc-previous&preserve-view=true).

### Azure Local VM management changes

In this release:

- You can manage guests through Azure CLI. For more information, see [Enable guest management](../manage/manage-arc-virtual-machines.md).
- Proxy support is added for Azure Local VMs. For more information, see [Set up proxy for Azure Local VMs](../manage/create-arc-virtual-machines.md#create-vm-with-proxy-configured).
- You can select the storage path during the Azure Local VM image creation via the Azure portal. For more information, see [Create an Azure Local VM image from Azure Marketplace via the Azure portal](../manage/virtual-machine-image-azure-marketplace.md).

### Migration of Hyper-V VMs to Azure Local (preview)

You can now migrate Hyper-V VMs to Azure Local using Azure Migrate. This feature is currently in preview. For more information, see [Migration of Hyper-V VMs using Azure Migrate to Azure Local (preview)](../migrate/migration-azure-migrate-overview.md).

### Monitoring changes

In the Azure portal, you can now monitor platform metrics of your cluster by navigating to the **Monitoring** tab on your cluster's **Overview** page. This tab offers a quick way to view graphs for different platform metrics. You can select any graph to open it in Metrics Explorer for a more in-depth analysis. For more information, see [Monitor Azure Local through the Monitoring tab](../manage/monitor-cluster-with-metrics.md#monitor-azure-local-through-the-monitoring-tab).

### Security via Microsoft Defender for Cloud (preview)

You can now use Microsoft Defender for Cloud to help improve the security posture of your Azure Local environment and protect against existing and evolving threats. This feature is currently in preview. For more information, see [Microsoft Defender on Cloud for Azure Local (Preview)](../manage/manage-security-with-defender-for-cloud.md).

### Supported workloads

Starting with this release, the following workloads are generally available on Azure Local:

- Azure Kubernetes Service (AKS) on Azure Local. For more information, see [Create Kubernetes clusters](/azure/aks/hybrid/aks-create-clusters-cli).

    In addition, AKS on HCI has a new CLI extension and Azure portal experience, [Support for logical networks](/azure/aks/hybrid/aks-networks), [Support for taints and labels](/azure/aks/hybrid/cluster-labels), [Support for upgrade via Azure CLI](/azure/aks/hybrid/cluster-upgrade), [Support for Nvidia A2](/azure/aks/hybrid/deploy-gpu-node-pool?pivots=aks-23h2) and more. For details, see [What's new in AKS on Azure Local?](/azure/aks/hybrid/aks-whats-new-23h2).

- Azure Virtual Desktops (AVD) on Azure Local. For more information, see [Deploy AVD on Azure Local](/azure/virtual-desktop/azure-stack-hci-overview).

## Features and improvements in 2311

This section lists the new features and improvements in the 2311 release of Azure Local. Additionally, this section includes features and improvements that were originally released for 2310 starting with cloud-based deployment.


### Cloud-based deployment

For machines running Azure Local, release 2311.2, you can perform new deployments via the cloud. You can deploy an Azure Local instance in one of the two ways - via the Azure portal or via an Azure Resource Manager deployment template.

For more information, see [Deploy Azure Local instance using the Azure portal](../deploy/deploy-via-portal.md) and [Deploy Azure Local via the Azure Resource Manager deployment template](../deploy/deployment-azure-resource-manager-template.md).

### Cloud-based updates

This new release has the infrastructure to consolidate all the relevant updates for the OS, software agents, Azure Arc infrastructure, and OEM drivers and firmware into a unified monthly update package. This comprehensive update package is identified and applied from the cloud through the Azure Update Manager tool. Alternatively, you can apply the updates using the PowerShell.

For more information, see [Update your Azure Local instance via the Azure Update Manager](../update/azure-update-manager-23h2.md) and [Update your Azure Local via the PowerShell](../update/update-via-powershell-23h2.md).​

### Cloud-based monitoring

#### Respond to health alerts

This release integrates the Azure Monitor alerts with Azure Stack HCI so that any health alerts generated within your on-premises Azure Stack HCI system are automatically forwarded to Azure Monitor alerts. You can link these alerts with your automated incident management systems, ensuring timely and efficient response.

For more information, see [Respond to Azure Stack HCI health alerts using Azure Monitor alerts](../manage/health-alerts-via-azure-monitor-alerts.md).

#### Monitor metrics

This release also integrates the Azure Monitor metrics with Azure Stack HCI so that you can monitor the health of your Azure Stack HCI system via the metrics collected for compute, storage, and network resources. This integration enables you to store cluster data in a dedicated time-series database that you can use to analyze data from your Azure Stack HCI system.

For more information, see [Monitor Azure Stack HCI with Azure Monitor metrics](../manage/monitor-cluster-with-metrics.md).

#### Enhanced monitoring capabilities with Insights

By using Insights for Azure Stack HCI, you can monitor and analyze performance, savings, and usage insights about key Azure Stack HCI features, such as ReFS deduplication and compression. To use these enhanced monitoring capabilities, ensure that your cluster is deployed, registered, and connected to Azure, and enrolled in monitoring. For more information, see [Monitor Azure Stack HCI features with Insights](../manage/monitor-features.md).

### Azure Local VM management

Starting with this release, the following Azure Local VM management capabilities are available:

- **Simplified Azure Arc resource bridge deployment**. The Azure Arc resource bridge is now deployed as part of the Azure Local deployment.
    For more information, see [Deploy Azure Local instance using the Azure portal](../deploy/deploy-via-portal.md).
- **New RBAC roles for Azure Local VMs**. This release introduces new RBAC roles for Azure Local VMs.
    For more information, see [Manage RBAC roles for Azure Local VMs](../manage/assign-vm-rbac-roles.md).
- **New Azure consistent CLI**. Starting with this preview release, a new consistent command line experience is available to create VM and VM resources such as VM images, storage paths, logical networks, and network interfaces. 
    For more information, see [Create Azure Local VMs on Azure Local](../manage/create-arc-virtual-machines.md).
- **Support for static IPs**. This release adds support for static IPs. 
    For more information, see [Create static logical networks on Azure Local](../manage/create-logical-networks.md#create-a-static-logical-network-via-portal).
- **Support for storage paths**. While default storage paths are created during the deployment, you can also specify custom storage paths for your Azure Local VMs.
    For more information, see [Create storage paths on Azure Local](../manage/create-storage-path.md).
- **Support for Azure VM extensions on Azure Local VMs**. Starting with this preview release, you can also enable and manage the Azure VM extensions that are supported on Azure Arc, on Azure Local VMs.
    For more information, see [Manage VM extensions for Azure Local VMs](../manage/virtual-machine-manage-extension.md).
- **Trusted launch for Azure Local VMs**. Azure Trusted Launch protects VMs against boot kits, rootkits, and kernel-level malware. Starting with this preview release, some of those Trusted Launch capabilities are available for Azure Local VMs.
    For more information, see [Trusted launch for Azure Local VMs](../manage/trusted-launch-vm-overview.md).

### AKS on Azure Local

Starting with this release, you can run Azure Kubernetes Service (AKS) workloads on your Azure Local system. AKS on Azure Local uses Azure Arc to create new Kubernetes clusters on Azure Local directly from Azure. For more information, see [What's new in AKS on Azure Local?](/azure/aks/hybrid/aks-whats-new-23h2)

The following Azure Kubernetes cluster deployment and management capabilities are available:

- **Simplified infrastructure deployment on Azure Local**. In this release, the infrastructure components of Azure Kubernetes on Azure Local including the Azure Arc resource bridge, custom location, and the Azure Kubernetes Extension for the Azure Kubernetes operator, are all deployed as part of the Azure Local deployment. For more information, see [Deploy Azure Local instance using the Azure portal (preview)](../deploy/deploy-via-portal.md).
- **Integrated infrastructure upgrade on Azure Local**. The whole lifecycle management of Azure Kubernetes infrastructure follows the same approach as the other components on Azure Local. For more information, see [Infrastructure component updates for AKS on Azure Local (preview)](/azure/aks/hybrid/infrastructure-components).
- **New Azure consistent CLI**. Starting with this preview release, a new consistent command line experience is available to create and manage Kubernetes clusters. <!--For more information, see [Azure CLI extension az akshybrid reference](https://learn.microsoft.com/cli/azure/akshybrid).-->
- **Cloud-based management**. You can now create and manage Kubernetes clusters on Azure Local by using familiar tools such as Azure portal and Azure CLI. For more information, see [Create Kubernetes clusters using Azure CLI](/azure/aks/hybrid/aks-create-clusters-cli).
- **Support for upgrading a Kubernetes cluster using Azure CLI**. You can use Azure CLI to upgrade the Kubernetes cluster to a newer version and apply the OS version updates. For more information, see [Upgrade an Azure Kubernetes Service (AKS) cluster (preview)](/azure/aks/hybrid/cluster-upgrade).
- **Support for Azure Container Registry to deploy container images**. In this release, you can deploy container images from a private container registry by using Azure Container Registry to your Kubernetes clusters running on Azure Local. For more information, see [Deploy from private container registry to on-premises Kubernetes using Azure Container Registry and Azure Kubernetes](/azure/aks/hybrid/deploy-container-registry).
- **Support for managing and scaling the node pools**. For more information, see [Manage multiple node pools in Azure Kubernetes](/azure/aks/hybrid/manage-node-pools).
- **Support for Linux and Windows Server containers**. For more information, see [Create Windows Server containers](/azure/aks/hybrid/aks-create-containers).

### Security capabilities

The new installations with this release of Azure Local start with a *secure-by-default* strategy. The new version has a tailored security baseline coupled with a security drift control mechanism and a set of well-known security features enabled by default. This release provides:

- A tailored security baseline with over 300 security settings configured and enforced with a security drift control mechanism. For more information, see [Security baseline settings for Azure Local](../concepts/secure-baseline.md).
- Out-of-box protection for data and network with SMB signing and BitLocker encryption for OS and Cluster Shared Volumes. For more information, see [BitLocker encryption for Azure Local](../concepts/security-bitlocker.md).
- Reduced attack surface as Windows Defender Application Control is enabled by default and limits the applications and the code that you can run on the core platform. For more information, see [Windows Defender Application Control for Azure Local](../concepts/security-windows-defender-application-control.md).

### Support for web proxy

This release supports configuring a web proxy for your Azure Local system. Perform this optional configuration if your network uses a proxy server for internet access. For more information, see [Configure web proxy for Azure Local](../manage/configure-proxy-settings-23h2.md).

### Removal of GMSA accounts

In this release, the Group Managed Service Accounts (gMSA) created during the Active Directory preparation are removed. For more information, see [Prepare Active Directory](../deploy/deployment-prep-active-directory.md).

<!--### Guest management operations via Azure CLI

In this release, you can perform an extended set of guest management operations via the Azure CLI.-->

### Capacity management

In this release, you can add and remove machines, or repair machines from your Azure Local system via the PowerShell.

For more information, see [Add server](../manage/add-server.md) and [Repair server](../manage/repair-server.md).

### ReFS deduplication and compression

This release introduces the Resilient File System (ReFS) deduplication and compression feature designed specifically for active workloads, such as Azure Virtual Desktop (AVD) on Azure Local. Enable this feature using Windows Admin Center or PowerShell to optimize storage usage and reduce cost.

For more information, see [Optimize storage with ReFS deduplication and compression in Azure Local](../manage/refs-deduplication-and-compression.md).

## Next steps

- [Read the Azure Local blog](https://aka.ms/ignite25/blog/azurelocal) post.
- Read the [blog announcing the general availability of Azure Local](https://techcommunity.microsoft.com/t5/azure-stack-blog/azure-stack-hci-version-23h2-is-generally-available/ba-p/4046110).
- Read [About hyperconverged deployment methods](../deploy/deployment-introduction.md).
- Learn how to [Deploy Azure Local via the Azure portal](../deploy/deploy-via-portal.md).
