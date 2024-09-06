---
title: What's new in AKS on Azure Stack HCI version 23H2
description: Learn about what's new in AKS on Azure Stack HCI version 23H2.
ms.topic: overview
ms.date: 09/05/2024
author: sethmanheim
ms.author: sethm 
ms.reviewer: guanghu
ms.lastreviewed: 06/25/2024

---

# What's new in AKS on Azure Stack HCI version 23H2

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

This article lists the various features and improvements that are available in AKS enabled by Azure Arc, on HCI version 23H2.

## About AKS Arc on Azure Stack HCI 23H2

AKS on Azure Stack HCI 23H2 uses [Azure Arc](/azure/azure-arc/overview) to create new Kubernetes clusters on Azure Stack HCI directly from Azure. It enables you to use familiar tools like the Azure portal, Azure CLI, and Azure Resource Manager templates to create and manage your Kubernetes clusters running on Azure Stack HCI. Since clusters are automatically connected to Arc when they are created, you can use your Microsoft Entra ID for connecting to your clusters from anywhere. This ensures your developers and application operators can provision and configure Kubernetes clusters in accordance with company policies.

Microsoft continues to focus on delivering a consistent user experience for all your AKS clusters. If you have created and managed Kubernetes clusters using Azure, you'll feel right at home managing Kubernetes clusters running on Azure Stack HCI 23H2 using Azure portal or Azure CLI management experiences.

## Simplified AKS component management on Azure Stack HCI 23H2

AKS on Azure Stack HCI 23H2 includes several infrastructure components that provide Azure experiences, including the Arc Resource Bridge, Custom Location, and the Kubernetes Extension for the AKS Arc operator. These infrastructure components are now included in Azure Stack HCI 23H2:

- **Arc Resource Bridge**: The Arc Resource Bridge is created automatically when you deploy Azure Stack HCI. This lightweight Kubernetes VM connects your Azure Stack HCI to Azure Cloud and enables on-premises resource management from Azure. Azure Arc Resource Bridge provides the line of sight to private clouds required to manage resources such as Kubernetes clusters on-premises through Azure.
- **Custom Location**: Just like Azure Arc Resource Bridge, a custom location is created automatically when you deploy Azure Stack HCI. A custom location is the on-premises equivalent of an Azure region and is an extension of the Azure location construct. Custom locations provide a way for tenant administrators to use their data center with the right extensions installed, as target locations for deploying AKS.
- **Kubernetes Extension for AKS Arc Operators**: The Kubernetes Extension for AKS Operators is automatically installed on Arc Resource Bridge when you deploy Azure Stack HCI. It's the on-premises equivalent of an Azure Resource Manager resource provider, to help manage AKS via Azure.

By integrating these components, Azure Arc offers a unified and efficient Kubernetes provisioning and management solution, seamlessly bridging the gap between on-premises and cloud infrastructures.

## Key personas

**Infrastructure administrator**: The role of the infrastructure administrator is to set up Azure Stack HCI, which includes all the infrastructure component deployments previously mentioned. Administrators must also set up the platform configuration, such as the networking and storage configuration, so that Kubernetes operators can create and manage Kubernetes clusters.

**Kubernetes operator**: Kubernetes operators can create and manage Kubernetes clusters on Azure Stack HCI so they can run applications without coordinating with infrastructure administrators. The operator is given access to the Azure subscription, Azure custom location, and virtual network by the infrastructure administrator. No access to the underlying on-premises infrastructure is necessary. Once the operator has the required access, they can create Kubernetes clusters according to application needs: Windows/Linux node pools, Kubernetes versions, etc.

## Features and improvements

This section lists the new features and improvements in AKS Arc in each release of Azure Stack HCI, version 23H2.

### Release 2408

The following Kubernetes cluster deployment and management capabilities are available:

- **High availability improvements**. You can now deploy nodes with anti-affinity on specific physical hosts on Azure Stack HCI clusters. For more information, see [Availability sets](availability-sets.md).
- **PowerShell**. You can now use PowerShell cmdlets to manage your AKS Arc clusters on Azure Stack HCI 23H2 with CRUD support. For more information, see the [PowerShell reference documentation](/powershell/module/az.aksarc/?view=azps-12.1.0&preserve-view=true).
- **Error report improvements**. You can now get improved error case reporting with prechecks; for example, a check for incorrect Kubernetes versions and available GPU capacity.
- **Support for NVIDIA T4**. You can now create node pools in new VM sizes with GPU NVIDIA T4. For more information, see [Use GPUs](deploy-gpu-node-pool.md).
- **Arc Gateway**. You can now use the Arc Gateway to configure very few of the outbound URLs to use AKS clusters on Azure Stack HCI.
- **Support pod CIDR**. You can now create an AKS Arc cluster with a user-specified pod CIDR IP arrange.

#### Supported component versions for 2408

| Component           | Version                                       |
|---------------------|--------------------------------------------------|
| AKS Arc             | 1.3.218                                     |
| Kubernetes versions | 1.27.7, 1.27.9, 1.28.5, 1.28.9, 1.29.2, 1.29.4 |

### Release 2405

The following Kubernetes cluster deployment and management capabilities are available:

- **Azure RBAC support**. You can now enable Azure RBAC for Kubernetes while creating AKS Arc clusters using Azure CLI and Azure Resource Manager templates.
- **Taints and labels update**. You can now update taints and labels during an AKS Arc node pool update operation using Azure CLI and Azure Resource Manager templates.
- **AKS Arc cluster platform metrics and alerts**. You can now view AKS Arc cluster metrics (platform metrics) and create metric-based alerts.
- **Auto cert repair**. You can now automatically repair certificates, managed by cert-tattoo, that expired when the cluster was shut down.
- **Download VHDs manually (offline download)**. This feature, now available only in private preview, enables you to download virtual machine images and upload them to the target center using a manual process. This can help in environments in which downloading large files is inconvenient. If you are interested in using it, contact your Microsoft Account representative.

#### Supported component versions for 2405

The following component versions are supported in release 2405:

| Component           | Version                                       |
|---------------------|--------------------------------------------------|
| AKS Arc             | 1.0.23.10605                                     |
| Kubernetes versions | 1.26.10, 1.26.12, 1.27.7, 1.27.9, 1.28.3, 1.28.5 |

### Release 2402

The following Kubernetes cluster deployment and management capabilities are available:

- **Autoscaling**. You can now enable the autoscaling feature when you create or update Kubernetes clusters and node pools.
- **Support for NVIDIA A16**. You can now create node pools in new VM sizes with GPU NVIDIA A16. For more information, see [Use GPUs for compute-intensive workloads](deploy-gpu-node-pool.md).
- **Diagnostic settings**. You can export audit logs and other control plane logs to one or more destinations. For more information, see [Diagnostic settings in Azure Monitor](/azure/azure-monitor/essentials/diagnostic-settings).
- **Certificate expiration**. You can now shut down Kubernetes clusters for up to 7 days without any certificate expiration issues.
- **Update status**. You can now view the status of ongoing Kubernetes cluster upgrades.

### Release 2311.2

AKS enabled by Azure Arc on HCI version 23H2 is generally available starting with this release.

The following Kubernetes cluster deployment and management capabilities are available:

- **New CLI extension and Azure portal experience**. The new GA version of the Azure CLI extension starting with this release is [**az aksarc**](/cli/azure/aksarc). For more information, see [Create Kubernetes clusters using Azure CLI](aks-create-clusters-cli.md). You can also see the new portal cluster creation experience in [Create Kubernetes clusters using the Azure portal](aks-create-clusters-portal.md).  
- **Support for logical networks**. Starting with this release, creating Kubernetes clusters on Azure Stack HCI 23H2 requires [logical networks](/azure-stack/hci/manage/create-logical-networks?tabs=azurecli) as a prerequisite. For more information, see [How to create logical networks](aks-networks.md).
- **Available K8S versions and VM sizes**. You can use [`az aksarc get-versions`](/cli/azure/aksarc#az-aksarc-get-versions) and [`az aksarc vmsize list`](/cli/azure/aksarc/vmsize#az-aksarc-vmsize-list) to get the available Kubernetes versions and VM sizes on your system.
- **Support for Taints and labels**. See [Manage node pools](manage-node-pools.md) for a cluster, and [Use cluster labels](cluster-labels.md) to set the taints and labels for node pools.
- **Support for upgrading a Kubernetes cluster using Azure CLI**. You can use the Azure CLI to upgrade a Kubernetes cluster to a newer version and apply the OS version updates. For more information, see [Upgrade a Kubernetes cluster](cluster-upgrade.md).
- **Support for both disks and files for persistent volumes**. To support stateful applications, you can use the default storage class for disks, or a custom storage class that points to a specific storage path. See [Use persistent volumes](persistent-volume.md) and [Use Container Storage Interface (CSI) disk drivers](container-storage-interface-disks.md). You can also create persistent volumes on file shares, in either SMB or NFS. For more information, see [Use Container Storage Interface (CSI) file drivers](container-storage-interface-files.md).
- **Support for NVIDIA A2**. You can now create node pools with new VM sizes with GPU NVIDIA A2. For more information, see [Use GPUs for compute-intensive workloads](deploy-gpu-node-pool.md).

### Release 2311

Starting with this release, you can run Azure Kubernetes Service (AKS) workloads on your Azure Stack HCI system. AKS on HCI version 23H2 uses Azure Arc to create new Kubernetes clusters on Azure Stack HCI directly from Azure.

The following Kubernetes cluster deployment and management capabilities are available:

- **Simplified infrastructure deployment on Azure Stack HCI**. In this release, the infrastructure components of AKS Arc, including the Arc Resource Bridge, Custom Location, and the Kubernetes Extension for the AKS Arc operator, are all deployed as part of the Azure Stack HCI 23H2 deployment. For more information, see [Deploy an Azure Stack HCI version 23H2 system using the Azure portal](/azure-stack/hci/deploy/deploy-via-portal).
- **Integrated infrastructure upgrade on Azure Stack HCI**. The whole lifecycle management of AKS Arc infrastructure follows the same approach as the other components on Azure Stack HCI 23H2. For more information, see [Infrastructure component updates](infrastructure-components.md).
- **New CLI consistent with Azure**. Starting with this release, a new consistent command-line experience is available to create and manage Kubernetes clusters.
- **Cloud-based management**. You can now create and manage Kubernetes clusters on Azure Stack HCI with familiar tools such as the Azure portal and Azure CLI. For more information, see [Create Kubernetes clusters using Azure CLI](aks-create-clusters-cli.md).
- **Support for Azure Container Registry to deploy container images**. In this release, you can deploy container images from a private container registry using Azure Container Registry to your Kubernetes clusters running on Azure Stack HCI. For more information, see [Deploy from private container registry to on-premises Kubernetes](deploy-container-registry.md).
- **Support for managing and scaling the node pools**. For more information, see [Manage multiple node pools in AKS Arc](manage-node-pools.md).
- **Support for Linux and Windows Server containers**. For more information, see [Create Windows Server containers](aks-create-containers.md).

## Next steps

- [Review AKS on Azure Stack HCI 23H2 prerequisites](aks-hci-network-system-requirements.md)
- [System requirements for AKS Arc](system-requirements.md)
