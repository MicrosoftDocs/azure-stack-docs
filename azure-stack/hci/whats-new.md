---
title: What's new in Azure Stack HCI
description: Find out what's new in Azure Stack HCI
ms.topic: overview
author: khdownie
ms.author: v-kedow
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 09/09/2021
---

# What's new in Azure Stack HCI

> Applies to: Azure Stack HCI, version 20H2

## What's new in Azure Stack HCI

Windows Admin Center version 2103 adds a number of features and improvements to Azure Stack HCI, version 20H2, including the following:

- **Windows Admin Center updates automatically**: Windows Admin Center and extensions now update automatically when a new release is available.

- **Deploy Network Controller using Windows Admin Center**: An update to the Cluster Creation extension in Windows Admin Center allows you to set up a Network Controller for Software Defined Networking (SDN) deployments.

- **Use Windows Admin Center in the Azure portal (Preview)**: Manage the Windows Server operating system running in an Azure VM by using Windows Admin Center directly in the Azure portal.
To learn more, see [Windows Admin Center in the Azure portal](https://cloudblogs.microsoft.com/windowsserver/2021/03/02/announcing-public-preview-of-window-admin-center-in-the-azure-portal/).

- **Event tool redesign (Preview)**: We’ve redesigned the Events tool for servers and PCs for the first time in ages. To check it out, open the Events tool and then toggle **Preview Mode**.

- **Install and manage Azure IoT Edge for Linux on Windows**: Install, manage, and troubleshoot IoT Edge for Linux on Windows from within Windows Admin Center.
To learn more, see [Enabling Linux based Azure IoT Edge Modules on Windows IoT](https://techcommunity.microsoft.com/t5/internet-of-things/enabling-linux-based-azure-iot-edge-modules-on-windows-iot/ba-p/2075882?ocid=wac2103).

- **Open tools in separate windows**: Connect to a system and then on the **Tools** menu, hover over a tool and select **Open tool in a separate window**.

- **Virtual machines tool improvements**: You can now create your own VM groups in the tool and edit columns. We’ve also made moving a VM easier, allowing you to reassign virtual switches while moving a VM.

For details on the new features and improvements, see [Windows Admin Center version 2103 is now generally available](https://techcommunity.microsoft.com/t5/windows-admin-center-blog/windows-admin-center-version-2103-is-now-generally-available/ba-p/2176438).

Clusters running Azure Stack HCI, version 20H2 have the following new features:

- **Azure Kubernetes Service hosting**: Azure Stack HCI now includes the ability to host [Azure Kubernetes Service on Azure Stack HCI](../aks-hci/overview.md).
- **New capabilities in Windows Admin Center**: With the ability to create and update hyperconverged clusters via an intuitive UI, Azure Stack HCI is easier than ever to use.
- **Stretched clusters for automatic failover**: Multi-site clustering with Storage Replica replication and automatic VM failover provides native disaster recovery and business continuity.
- **Affinity and anti-affinity rules**: These can be used similarly to how Azure uses Availability Zones to keep VMs and storage together or apart in clusters with multiple fault domains, such as stretched clusters.
- **Azure portal integration**: The Azure portal experience for Azure Stack HCI is designed to view all of your Azure Stack HCI clusters across the globe, with new features in development.
- **GPU acceleration for high-performance workloads**: AI/ML applications can benefit from boosting performance with GPUs.
- **BitLocker encryption**: You can now use BitLocker to encrypt the contents of data volumes on Azure Stack HCI, helping government and other customers stay compliant with standards such as FIPS 140-2 and HIPAA.
- **Improved Storage Spaces Direct volume repair speed**: Repair volumes quickly and seamlessly.

To learn more about what's new in Azure Stack HCI 20H2, [watch this video](https://www.youtube.com/watch?v=DPG7wGhh3sAa) from Microsoft Inspire.

## Next steps

- [Download Azure Stack HCI](https://azure.microsoft.com/products/azure-stack/hci/hci-download/)
