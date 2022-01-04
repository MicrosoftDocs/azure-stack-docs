---
title: What's new in Azure Stack HCI
description: Find out what's new in Azure Stack HCI
ms.topic: overview
author: jasongerend
ms.author: jgerend
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 12/15/2021
---

# What's new in Azure Stack HCI, version 21H2

> Applies to: Azure Stack HCI, versions 21H2

This article lists the various features and improvements that are now generally available in Azure Stack HCI, versions 21H2 and also the ones that are currently in public preview. It also describes what's added in Windows Admin Center version 2110 to manage these new Azure Stack HCI features.

Microsoft provides monthly quality and security updates for each supported version of Azure Stack HCI and also provides yearly feature updates. For information on the available updates for each version of Azure Stack HCI, see [Azure Stack HCI release information](release-information.md).

To evaluate the new features and enhancements that are currently in public preview, [join the Azure Stack HCI preview channel](manage/preview-channel.md).

## New Azure workloads and benefits
Azure Stack HCI, version 21H2 brings the most popular Azure workloads and their benefits to your Azure Stack HCI clusters. This section describes the Azure workloads and benefits that are now generally available (and in public preview) with Azure Stack HCI, version 21H2.

### New Azure platform attestation service

With Azure Stack HCI, version 21H2, you can now run Azure-exclusive workloads and the benefits associated with them in your on-premises Azure Stack HCI clusters. Azure benefits is a recommended and optional feature in Azure Stack HCI, which makes it possible for supported Azure-exclusive workloads to work outside of the cloud. You can enable Azure benefits on Azure Stack HCI at no additional cost. For more information, see [Azure Benefits on Azure Stack HCI](manage/azure-benefits.md).

### Continuous innovations for Azure Kubernetes Service on Azure Stack HCI

Microsoft releases regular AKS-HCI updates since its general availability in May 2021. For the latest release information, see [Azure Kubernetes Service on Azure Stack HCI release information page](https://github.com/azure/aks-hci/releases).

### Azure Virtual Desktop for Azure Stack HCI (preview)

With Azure Stack HCI, version 21H2, you can now deploy Azure Virtual Desktop session hosts to your on-premises Azure Stack HCI infrastructure with Azure Virtual Desktop for Azure Stack HCI (preview). You can also use Azure Virtual Desktop for Azure Stack HCI to manage your session hosts from the Azure portal. For more information, see [Azure Virtual Desktop for Azure Stack HCI (preview)](/azure/virtual-desktop/azure-stack-hci-overview).

## New Azure management and governance capabilities

Azure Stack HCI natively integrates with the Azure Resource Manager to project your cluster into Azure as a first-class resource in the Azure Portal. This section lists the new features and enhancements introduced in Azure Stack HCI, version 21H2 to manage your Azure Stack HCI resources just like you’d manage cloud resources.

### Azure Backup support for Azure Stack HCI

With MABS v3 UR2, you can now back up Azure Stack HCI host (System State/BMR) and VMs running on the Azure stack HCI cluster. For more information see [Back up Azure Stack HCI virtual machines with Azure Backup Server](azure/backup/back-up-azure-stack-hyperconverged-infrastructure-virtual-machines.md).

### Azure Site Recovery support for Azure Stack HCI

With Azure Site Recovery support, you can now continuously replicate VMs from Azure Stack HCI to Azure, failover, and failback. For more information, see [Protect your Hyper-V Virtual Machines with Azure Site Recovery](manage/azure-site-recovery.md)

### Arc-enabled PaaS services on Azure Stack HCI (preview)

Azure Stack HCI runs Platform-as-a-Service (PaaS) services on-premises with Azure Arc, and offers the ability to host Azure Kubernetes Service. You can also run Azure Arc enabled data services, including [SQL Managed Instance](azure/azure-arc/data/managed-instance-overview.md) and [PostgreSQL Hyperscale (preview)](azure/azure-arc/data/what-is-azure-arc-enabled-postgres-hyperscale.md), and [App Service, Functions, and Logic Apps on Azure Arc (preview)](azure/app-service/overview-arc-integration.md) on Azure Stack HCI. To learn more about these services through tutorials and demos, visit [Azure Arc Jumpstart](https://azurearcjumpstart.io/).

### Multi-cluster monitoring in the Azure Portal (preview)

Azure Stack HCI Insights provides health, performance, and usage insights about registered Azure Stack HCI, version 21H2 clusters that are connected to Azure and are enrolled in monitoring. Starting with Azure Stack HCI, version 21H2, your cluster automatically Arc-enables your host servers when you register, so that you’re ready to start using extensions. This article explains the benefits of this new Azure Monitor experience, as well as how to modify and adapt the experience to fit the unique needs of your organization. For more information, see [Monitor multiple clusters with Azure Stack HCI Insights (preview)](manage/azure-stack-hci-insights.md).

## New Azure infrastructure innovations

Clusters running Azure Stack HCI, version 21H2 now have the following new features:

- **[Use GPUs with clustered VMs](manage/use-gpu-with-clustered-vm.md)**: Provide GPU acceleration to workloads running in clustered VMs.
- **[Dynamic CPU compatibility mode](manage/processor-compatibility-mode.md)**: Processor compatibility mode has been updated to take advantage of new processor capabilities in a clustered environment.
- **[Storage thin provisioning](manage/thin-provisioning.md)**: Improve storage efficiency and simplify management with thin provisioning.
- **[Network ATC](deploy/network-atc.md)**: Simplify host networking and network configuration management.
- **[Adjustable storage repair speed](manage/storage-repair-speed.md)**: Gain more control over the data resync process by allocating resources to either resiliency or performance to service your clusters more flexibly and efficiently.
- **[Support for nested virtualization on AMD processors](concepts/nested-virtualization.md#nested-virtualization-processor-support)**: Improve flexibility in evaluation and testing scenarios with VM-based clusters.
- **[Manage quick restarts with Kernel Soft Reboot](manage/kernel-soft-reboot.md)**: Improve reboot performance and reduce overall cluster update time (available only on Azure Stack HCI Integrated Systems).
To upgrade your cluster to Azure Stack HCI, version 21H2, see [Update Azure Stack HCI clusters](manage/update-cluster.md).


<!--## What's new in Azure Stack HCI, version 20H2

Clusters running Azure Stack HCI, version 20H2 now have the following new features:

- **Azure Kubernetes Service hosting**: Azure Stack HCI now includes the ability to host [Azure Kubernetes Service on Azure Stack HCI](../aks-hci/overview.md).
- **New capabilities in Windows Admin Center**: With the ability to create and update hyperconverged clusters via an intuitive UI, Azure Stack HCI is easier than ever to use.
- **Stretched clusters for automatic failover**: Multi-site clustering with Storage Replica replication and automatic VM failover provides native disaster recovery and business continuity.
- **Affinity and anti-affinity rules**: These can be used similarly to how Azure uses Availability Zones to keep VMs and storage together or apart in clusters with multiple fault domains, such as stretched clusters.
- **Azure portal integration**: The Azure portal experience for Azure Stack HCI is designed to view all of your Azure Stack HCI clusters across the globe, with new features in development.
- **GPU acceleration for high-performance workloads**: AI/ML applications can benefit from boosting performance with GPUs.
- **BitLocker encryption**: You can now use BitLocker to encrypt the contents of data volumes on Azure Stack HCI, helping government and other customers stay compliant with standards such as FIPS 140-2 and HIPAA.
- **Improved Storage Spaces Direct volume repair speed**: Repair volumes quickly and seamlessly.

To learn more about what's new in Azure Stack HCI 20H2, [watch this video](https://www.youtube.com/watch?v=DPG7wGhh3sAa) from Microsoft Inspire.-->

## Enhancements in Windows Admin Center

Windows Admin Center version 2110 includes a number of features and improvements to manage Azure Stack HCI systems.

- **Support for new operating systems**: Windows Admin Center now supports managing systems running Azure Stack HCI, version 21H2 and Windows Server 2022.

- **Windows Admin Center platform upgraded to Angular 11**: Upgrading the front-end of our platform from Angular 7 to Angular 11 enhances security and performance across the product. We also updated our SDK so that extension developers can use it too.

- **Virtual Machine tool improvements**: We’ve improved the tool’s performance and you can now create VHDs when adding a new disk to your VM.

- **New Security tool**: This new tool centralizes some key security settings for servers and clusters, including the ability to easily view the Secured-core status of systems.

- **New features when creating volumes on clusters**: The Volumes tool in Cluster Manager can now create volumes with thin provisioning, nested resiliency, and optional stretched cluster features.

- **Feature updates for Azure Stack HCI**: The Updates tool has an improved history page and can upgrade clusters to Azure Stack HCI, version 21H2.

- **Automatic VM activation**: You can now set up Azure Stack HCI clusters to automatically activate Windows Server VMs (this was previously available via an extension update). To do so, connect to the cluster and then go to Settings > Activate Windows Server VMs.

- **Set up SDN at any time**: You can now set up SDN after creating the cluster in addition to during cluster creation.

- **Azure hybrid services are available in Azure US Government**: You can now register Windows Admin Center with the Azure Government region to use Azure hybrid services.

For details on the new features and improvements, see the blog on [Windows Admin Center version 2110](https://techcommunity.microsoft.com/t5/windows-admin-center-blog/windows-admin-center-version-2110-is-now-generally-available/ba-p/2911579). 

More information on these and many more improvements to Windows Admin Center can be found in the [Windows Admin Center documentation](/windows-server/manage/windows-admin-center/understand/what-is).

<!--### What's new in Windows Admin Center version 2103

Windows Admin Center version 2103 includes the following improvements:

- **Windows Admin Center updates automatically**: Windows Admin Center and extensions now update automatically when a new release is available.

- **Deploy Network Controller using Windows Admin Center**: An update to the Cluster Creation extension in Windows Admin Center allows you to set up a Network Controller for Software Defined Networking (SDN) deployments.

- **Use Windows Admin Center in the Azure portal (Preview)**: Manage the Windows Server operating system running in an Azure VM by using Windows Admin Center directly in the Azure portal.
To learn more, see [Windows Admin Center in the Azure portal](https://cloudblogs.microsoft.com/windowsserver/2021/03/02/announcing-public-preview-of-window-admin-center-in-the-azure-portal/).

- **Event tool redesign (Preview)**: We’ve redesigned the Events tool for servers and PCs for the first time in ages. To check it out, open the Events tool and then toggle **Preview Mode**.

- **Install and manage Azure IoT Edge for Linux on Windows**: Install, manage, and troubleshoot IoT Edge for Linux on Windows from within Windows Admin Center.
To learn more, see [Enabling Linux based Azure IoT Edge Modules on Windows IoT](https://techcommunity.microsoft.com/t5/internet-of-things/enabling-linux-based-azure-iot-edge-modules-on-windows-iot/ba-p/2075882?ocid=wac2103).

- **Open tools in separate windows**: Connect to a system and then on the **Tools** menu, hover over a tool and select **Open tool in a separate window**.

- **Virtual machines tool improvements**: You can now create your own VM groups in the tool and edit columns. We’ve also made moving a VM easier, allowing you to reassign virtual switches while moving a VM.

For details on the new features and improvements, see the blog on [Windows Admin Center version 2103](https://techcommunity.microsoft.com/t5/windows-admin-center-blog/windows-admin-center-version-2103-is-now-generally-available/ba-p/2176438).-->

## Next steps

- [Download Azure Stack HCI](https://azure.microsoft.com/products/azure-stack/hci/hci-download/)
