---
title: What's new in Azure Stack HCI, version 21H2
description: Find out what's new in Azure Stack HCI, version 21H2
ms.topic: overview
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 11/22/2023
---

# What's new in Azure Stack HCI, version 21H2

> Applies to: Azure Stack HCI, version 21H2

This article lists the various features and improvements that are now available in Azure Stack HCI, version 21H2, including the ability to run it on a [single server](../hci/concepts/single-server-clusters.md). It also describes what's added in Windows Admin Center version 2110 to manage these new Azure Stack HCI features. To find out what's new in the latest version of Azure Stack HCI, see [What's new in Azure Stack HCI](whats-new.md).

For information on monthly quality and security updates, see [Azure Stack HCI release information](release-information.md). To see what we added in the previous release of Azure Stack HCI, see [What's new in Azure Stack, version 20H2](whats-new-in-hci-20h2.md).

You can also join the Azure Stack HCI preview channel to test out features coming to a future version of the Azure Stack HCI operating system. For more info, see [Join the Azure Stack HCI preview channel](manage/preview-channel.md).

## New hardware security capabilities

This section describes the new hardware security capabilities in Azure Stack HCI, version 21H2 systems that provide additional defense-in-depth protection against advanced threats.

### Secured-core server

Certified Secured-core server hardware from an original equipment manufacturer (OEM) partner provides additional security protections that are useful against sophisticated attacks. This can provide increased assurance when handling mission critical data in some of the most data sensitive industries. A Secured-core server uses hardware, firmware, and driver capabilities to enable advanced Azure Stack HCI security features. Many of these features are available in [Windows Secured-core PCs](/windows-hardware/design/device-experiences/oem-highly-secure) and are now also available with Secured-core server hardware and Azure Stack HCI, version 21H2. For more information about Secured-core server, see [Secured-core server](/windows-server/security/secured-core-server). For information about how to manage Secured-core server using Windows Admin Center, see "Security tools" in [Manage Hyper-Converged Infrastructure with Windows Admin Center](/windows-server/manage/windows-admin-center/use/manage-hyper-converged#security-tool).

### SMB Direct and RDMA encryption

Server Message Block Direct (SMB Direct) and Remote Direct Memory Access (RDMA) supply high bandwidth, low latency networking fabric for workloads like Storage Spaces Direct, Storage Replica, Hyper-V, Scale-out File Server, and SQL Server. SMB Direct in Azure Stack HCI, version 21H2 now supports encryption. Previously, enabling SMB encryption disabled direct data placement; this was intentional, but seriously impacted performance. Now data is encrypted before data placement, leading to far less performance degradation while adding AES-128 and AES-256 protected packet privacy.

For more information about SMB encryption, signing acceleration, secure RDMA, and cluster support, see [SMB Direct](/windows-server/storage/file-server/smb-direct). For more information about SMB security enhancements, see [SMB security enhancements](/windows-server/storage/file-server/smb-security).

## New Azure workloads and benefits

Azure Stack HCI, version 21H2 brings new Azure workloads and their benefits to your Azure Stack HCI clusters.

This section describes the Azure workloads and benefits that are now available or in preview with Azure Stack HCI, version 21H2.

### Azure Benefits enables Azure-exclusive workloads

With Azure Stack HCI, version 21H2, you can now run Azure-exclusive workloads, such as Windows Server Datacenter: Azure Edition, on your on-premises Azure Stack HCI clusters. Azure Stack HCI, version 21H2 includes a new Azure platform attestation service called Azure Benefits, which makes it possible for supported Azure-exclusive workloads to work on your Azure Stack HCI cluster. You can enable Azure Benefits on Azure Stack HCI at no additional cost. For more information on Azure Benefits and the supported workloads, see [Azure Benefits on Azure Stack HCI](manage/azure-benefits.md).

### Azure Virtual Desktop for Azure Stack HCI (preview)

You can now deploy Azure Virtual Desktop session hosts to your on-premises Azure Stack HCI infrastructure with Azure Virtual Desktop for Azure Stack HCI (preview). You can also use Azure Virtual Desktop for Azure Stack HCI to manage your session hosts from the Azure portal. For more information, see [Azure Virtual Desktop for Azure Stack HCI (preview)](/azure/virtual-desktop/azure-stack-hci-overview).

### Improvements to Azure Kubernetes Service on Azure Stack HCI and Windows Server 

We continue to make improvements to Microsoft's on-premises Kubernetes solution for Azure Stack HCI, Azure Kubernetes Service (AKS) on Azure Stack HCI. For more info, see [AKS on Azure Stack HCI](/azure/aks/hybrid/overview).

## New Azure management and governance capabilities

Azure Stack HCI natively integrates with the Azure Resource Manager to project your cluster into Azure as a first-class resource in the Azure portal. This section lists the new features and enhancements introduced in Azure Stack HCI, version 21H2 to manage your Azure Stack HCI resources just like you'd manage cloud resources.

### Azure Backup support for Azure Stack HCI

With Microsoft Azure Backup Server (MABS) v3 UR2, you can now back up Azure Stack HCI host (System State/BMR) and virtual machines (VMs) running on the Azure Stack HCI cluster. For more information, see [Back up Azure Stack HCI virtual machines with Azure Backup Server](/azure/backup/back-up-azure-stack-hyperconverged-infrastructure-virtual-machines).

### Azure Site Recovery support for Azure Stack HCI

With Azure Site Recovery support, you can now continuously replicate VMs from Azure Stack HCI to Azure, as well as fail over and fail back. For more information, see [Protect your Hyper-V Virtual Machines with Azure Site Recovery](manage/azure-site-recovery.md)

### Arc-enabled PaaS services on Azure Stack HCI (preview)

Azure Stack HCI runs Platform-as-a-Service (PaaS) services on-premises with Azure Arc, and offers the ability to host Azure Kubernetes Service. You can also run Azure Arc enabled data services, including [SQL Managed Instance](/azure/azure-arc/data/managed-instance-overview) and [PostgreSQL Hyperscale (preview)](/azure/azure-arc/data/what-is-azure-arc-enabled-postgres-hyperscale), and [App Service, Functions, and Logic Apps on Azure Arc (preview)](/azure/app-service/overview-arc-integration) on Azure Stack HCI.

### Arc VM management on Azure Stack HCI (preview)

Azure Stack HCI, version 21H2 enables you to use the Azure portal to provision and manage on-premises Windows and Linux VMs running on Azure Stack HCI clusters. For more information about managing Arc VMs, see [Manage Arc VMs](manage/azure-arc-vm-management-overview.md).
 
### Multi-cluster monitoring in the Azure portal (preview)

Azure Stack HCI Insights provides health, performance, and usage insights about registered Azure Stack HCI, version 21H2 clusters that are connected to Azure and are enrolled in monitoring. Starting with Azure Stack HCI, version 21H2, your cluster automatically Arc-enables your host servers when you register, so that you're ready to start using extensions. For more information on the benefits of this new Azure Monitor experience and how to modify and adapt the experience to fit your unique needs, see [Monitor multiple clusters with Azure Stack HCI Insights (preview)](/azure-stack/hci/manage/monitor-hci-multi).

## New Azure infrastructure innovations

This section lists the new cluster infrastructure features that are available in Azure Stack HCI, version 21H2:

- **[Use Azure Stack HCI on a single server](../hci/concepts/single-server-clusters.md)**: Minimize hardware and software costs in locations that can tolerate lower resiliency.
- **[Use GPUs with clustered VMs](manage/use-gpu-with-clustered-vm.md)**: Provide GPU acceleration to workloads running in clustered VMs.
- **[Dynamic CPU compatibility mode](manage/processor-compatibility-mode.md)**: Processor compatibility mode has been updated to take advantage of new processor capabilities in a clustered environment.
- **[Storage thin provisioning](manage/thin-provisioning.md)**: Improve storage efficiency and simplify management with thin provisioning.
- **[Network ATC](deploy/network-atc.md)**: Simplify host networking and network configuration management.
- **[Adjustable storage repair speed](manage/storage-repair-speed.md)**: Gain more control over the data resync process by allocating resources to either resiliency or performance to service your clusters more flexibly and efficiently.
- **[Support for nested virtualization on AMD processors](concepts/nested-virtualization.md#nested-virtualization-processor-support)**: Improve flexibility in evaluation and testing scenarios with VM-based clusters.
- **[Manage quick restarts with Kernel Soft Reboot](manage/kernel-soft-reboot.md)**: Improve reboot performance and reduce overall cluster update time (available only on Azure Stack HCI integrated systems).
To upgrade your cluster to Azure Stack HCI, version 21H2, see [Update Azure Stack HCI clusters](manage/update-cluster.md).

## New Azure Stack HCI sizing tool (public preview)

To help plan your Azure Stack HCI solution, you can now estimate the hardware requirements and visualize utilization by using the new Azure Stack HCI sizing tool. This tool, currently in public preview, comes with no additional cost and does not require Azure subscription. Sign in with your personal Microsoft account (MSA) credentials (not a corporate account) to try the [Azure Stack HCI sizing tool](https://azurestackhcisolutions.azure.microsoft.com/#/sizer).

For more information, see the blog on the [Azure Stack HCI sizing tool](https://techcommunity.microsoft.com/t5/azure-stack-blog/introducing-the-all-new-azure-stack-hci-sizing-tool-preview/ba-p/3053920).

## New remote support capability (preview)

You can now get remote support from Microsoft for limited troubleshooting and repairs of your Azure Stack HCI operating system. You can enable remote support by granting consent while controlling the access level and duration of access. Microsoft support can access your device only after a support request is submitted. For more information about how to get remote support, see [Get remote support](manage/get-remote-support.md).

## Enhancements in Windows Admin Center

Windows Admin Center version 2110 includes several features and improvements to manage your Azure Stack HCI systems.

- **Support for new operating systems**: Windows Admin Center now supports managing systems running Azure Stack HCI, version 21H2 and Windows Server 2022.

- **Windows Admin Center platform upgraded to Angular 11**: Upgrading the front end of our platform from Angular 7 to Angular 11 enhances security and performance across the product. We also updated our SDK so that extension developers can use it too.

- **Virtual Machine tool improvements**: We've improved the tool's performance and you can now create VHDs when adding a new disk to your VM.

- **New Security tool**: This new tool centralizes some key security settings for servers and clusters, including the ability to easily view the Secured-core status of systems.

- **New features when creating volumes on clusters**: The Volumes tool in Cluster Manager can now create volumes with thin provisioning, nested resiliency, and optional stretched cluster features.

- **Feature updates for Azure Stack HCI**: The Updates tool has an improved history page and can upgrade clusters to Azure Stack HCI, version 21H2.

- **Automatic VM activation**: You can now set up Azure Stack HCI clusters to automatically activate Windows Server VMs (this was previously available via an extension update). To do so, connect to the cluster and then go to **Settings** > **Activate Windows Server VMs**.

- **Set up SDN at any time**: You can now set up SDN after creating the cluster in addition to during cluster creation.

- **Azure hybrid services are available in Azure US Government**: You can now register Windows Admin Center with the Azure Government region to use Azure hybrid services.

For more information about the new features and improvements, see the blog on [Windows Admin Center version 2110](https://techcommunity.microsoft.com/t5/windows-admin-center-blog/windows-admin-center-version-2110-is-now-generally-available/ba-p/2911579).

For more information about Windows Admin Center, see the [Windows Admin Center documentation](/windows-server/manage/windows-admin-center/understand/what-is).

## Next steps

- [Watch the webinar on what's new in Azure Stack HCI, version 21H2](https://www.youtube.com/watch?v=uiU1XTO0oMw&t=343s)
- [Download Azure Stack HCI](deploy/download-azure-stack-hci-software.md)