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

# What's new in Azure Stack HCI

> Applies to: Azure Stack HCI, versions 21H2 and 20H2

This article lists the various features and improvements introduced in Azure Stack HCI, versions 21H2 and 20H2. It also lists what's new in different versions of Windows Admin Center to manage Azure Stack HCI systems.

Microsoft provides monthly quality and security updates for each supported version of Azure Stack HCI and also provides yearly feature updates. For information on the available updates for each version of Azure Stack HCI, see [Azure Stack HCI release information](release-information.md).

## What's new in Azure Stack HCI, version 21H2

Clusters running Azure Stack HCI, version 21H2 now have the following new features:

- **[Use GPUs with clustered VMs](manage/use-gpu-with-clustered-vm.md)**: Provide GPU acceleration to workloads running in clustered VMs.
- **[Dynamic CPU compatibility mode](manage/processor-compatibility-mode.md)**: Processor compatibility mode has been updated to take advantage of new processor capabilities in a clustered environment.
- **[Storage thin provisioning](manage/thin-provisioning.md)**: Improve storage efficiency and simplify management with thin provisioning.
- **[Network ATC](deploy/network-atc.md)**: Simplify host networking and network configuration management.
- **[Adjustable storage repair speed](manage/storage-repair-speed.md)**: Gain more control over the data resync process by allocating resources to either resiliency or performance to service your clusters more flexibly and efficiently.
- **[Support for nested virtualization on AMD processors](concepts/nested-virtualization.md#nested-virtualization-processor-support)**: Improve flexibility in evaluation and testing scenarios with VM-based clusters.
- **[Manage quick restarts with Kernel Soft Reboot](manage/kernel-soft-reboot.md)**: Improve reboot performance and reduce overall cluster update time (available only on Azure Stack HCI Integrated Systems).

To upgrade your cluster to Azure Stack HCI, version 21H2, see [Update Azure Stack HCI clusters](manage/update-cluster.md).

## What's new in Azure Stack HCI, version 20H2

Clusters running Azure Stack HCI, version 20H2 now have the following new features:

- **Azure Kubernetes Service hosting**: Azure Stack HCI now includes the ability to host [Azure Kubernetes Service on Azure Stack HCI](../aks-hci/overview.md).
- **New capabilities in Windows Admin Center**: With the ability to create and update hyperconverged clusters via an intuitive UI, Azure Stack HCI is easier than ever to use.
- **Stretched clusters for automatic failover**: Multi-site clustering with Storage Replica replication and automatic VM failover provides native disaster recovery and business continuity.
- **Affinity and anti-affinity rules**: These can be used similarly to how Azure uses Availability Zones to keep VMs and storage together or apart in clusters with multiple fault domains, such as stretched clusters.
- **Azure portal integration**: The Azure portal experience for Azure Stack HCI is designed to view all of your Azure Stack HCI clusters across the globe, with new features in development.
- **GPU acceleration for high-performance workloads**: AI/ML applications can benefit from boosting performance with GPUs.
- **BitLocker encryption**: You can now use BitLocker to encrypt the contents of data volumes on Azure Stack HCI, helping government and other customers stay compliant with standards such as FIPS 140-2 and HIPAA.
- **Improved Storage Spaces Direct volume repair speed**: Repair volumes quickly and seamlessly.

To learn more about what's new in Azure Stack HCI 20H2, [watch this video](https://www.youtube.com/watch?v=DPG7wGhh3sAa) from Microsoft Inspire.

## What's new in Windows Admin Center for Azure Stack HCI

Windows Admin Center versions 2110 and 2103 include a number of features and improvements to manage Azure Stack HCI systems. More information on these and many more improvements to Windows Admin Center can be found in the [Windows Admin Center documentation](/windows-server/manage/windows-admin-center/understand/what-is).

### What's new in Windows Admin Center version 2110

Windows Admin Center version 2110 includes the following improvements:

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

### What's new in Windows Admin Center version 2103

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

For details on the new features and improvements, see the blog on [Windows Admin Center version 2103](https://techcommunity.microsoft.com/t5/windows-admin-center-blog/windows-admin-center-version-2103-is-now-generally-available/ba-p/2176438).

## Next steps

- [Download Azure Stack HCI](https://azure.microsoft.com/products/azure-stack/hci/hci-download/)
