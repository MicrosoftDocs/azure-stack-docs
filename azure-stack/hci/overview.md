---
title: Azure Stack HCI solution overview
description: Azure Stack HCI is a hyperconverged infrastructure (HCI) cluster solution that hosts virtualized Windows and Linux workloads and their storage in a hybrid on-premises environment. Azure hybrid services enhance the cluster with capabilities such as cloud-based monitoring, Site Recovery, and VM backups, as well as a central view of all of your Azure Stack HCI deployments in the Azure portal.
ms.topic: overview
author: khdownie
ms.author: v-kedow
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 12/15/2020
---

# Azure Stack HCI solution overview

> Applies to: Azure Stack HCI, version 20H2

Azure Stack HCI is a hyperconverged infrastructure (HCI) cluster solution that hosts virtualized Windows and Linux workloads and their storage in a hybrid, on-premises environment. Azure hybrid services enhance the cluster with capabilities such as cloud-based monitoring, Site Recovery, and VM backups, as well as a central view of all of your Azure Stack HCI deployments in the Azure portal. You can manage the cluster with your existing tools including Windows Admin Center and PowerShell.

Azure Stack HCI, version 20H2 is now [available for download](https://azure.microsoft.com/products/azure-stack/hci/hci-download/). It's intended for on-premises clusters running virtualized workloads, with hybrid-cloud connections built-in. As such, Azure Stack HCI is delivered as an Azure service and billed on an Azure subscription. Azure Stack HCI also now includes the ability to host the Azure Kubernetes Service; for details, see [Azure Kubernetes Service on Azure Stack HCI](../aks-hci/overview.md).

Take a few minutes to watch the video on the high-level features of Azure Stack HCI:

> [!VIDEO https://www.youtube.com/embed/fw8RVqo9dcs]

At its core, Azure Stack HCI is a solution that combines the following:

- Validated hardware from an OEM partner
- Azure Stack HCI operating system
- Windows Admin Center
- Azure services

:::image type="content" source="media/overview/azure-stack-hci-solution.png" alt-text="The Azure Stack HCI OS runs on top of validated hardware, is managed by Windows Admin Center, and connects to Azure" border="false":::

Azure Stack HCI, version 20H2 provides new functionality not present in Windows Server, such as the ability to use Windows Admin Center to create a hyperconverged cluster that uses Storage Spaces Direct for superior storage price-performance. This includes the option to stretch the cluster across sites for automatic failover across sites. See [What's new in Azure Stack HCI](#whats-new-in-azure-stack-hci) for details.

## Use cases for Azure Stack HCI

There are many use cases for Azure Stack HCI, although it isn't intended for non-virtualized workloads. Customers often choose Azure Stack HCI in the following scenarios:

### Data center consolidation and modernization

Refreshing and consolidating aging virtualization hosts with Azure Stack HCI can improve scalability and make your environment easier to manage and secure. It's also an opportunity to retire legacy SAN storage to reduce footprint and total cost of ownership. Operations and systems administration are simplified with unified tools and interfaces and a single point of support.

### Remote and branch offices

With two-server cluster solutions starting at less than $20,000 per location, Azure Stack HCI is a great way to affordably modernize remote and branch offices, retail stores, and field sites. Innovative nested resiliency allows volumes to stay online and accessible even if multiple hardware failures happen at the same time. Cloud witness technology allows you to use Azure as the lightweight tie-breaker for cluster quorum, preventing split-brain conditions without the cost of a third host. Customers can also centrally view remote Azure Stack HCI deployments in the Azure portal.

### Virtual desktops

Many organizations want to host virtual desktops on-premises for low latency and data sovereignty. Azure Stack HCI can provide like-local performance.

### High-performance virtualized workloads

Azure Stack HCI can provide industry-best performance for SQL Server databases and other performance-sensitive virtualized workloads that require millions of storage IOPS or database transactions per second, offering consistently low latency with NVMe SSDs, a robust RDMA stack, and persistent memory.

## Azure integration benefits

Azure Stack HCI is uniquely positioned for hybrid infrastructure, allowing you to take advantage of cloud and on-premises resources working together and natively monitor, secure, and back up to the cloud.

After you register your Azure Stack HCI cluster with Azure, you can use the Azure portal initially for:

- **Monitoring:** View all of your Azure Stack HCI clusters in a single, global view where you can group them by resource group and tag them.
- **Billing:** Pay for Azure Stack HCI through your Azure subscription.

We're working hard on creating additional capabilities, so stay tuned for more.

You can also subscribe to additional Azure hybrid services:

- **Azure Site Recovery** for high availability and disaster recovery as a service (DRaaS).
- **Azure Monitor**, a centralized hub to track what's happening across your apps, network, and infrastructure – with advanced analytics powered by AI.
- **Cloud Witness**, to use Azure as the lightweight tie-breaker for cluster quorum.
- **Azure Backup** for offsite data protection and to protect against ransomware.
- **Azure Update Management** for update assessment and update deployments for Windows VMs running in Azure and on-premises.
- **Azure Network Adapter** to connect resources on-premises with your VMs in Azure via a point-to-site VPN.
- **Azure File Sync** to sync your file server with the cloud.

For more information, see [Connecting Windows Server to Azure hybrid services](/windows-server/manage/windows-admin-center/azure/index).

## Why Azure Stack HCI?

Azure Stack HCI is a world-class, integrated virtualization stack built on proven technologies that have already been deployed at scale, including Hyper-V, Storage Spaces Direct, and Azure-inspired software-defined networking (SDN). There are many reasons customers choose Azure Stack HCI, including:

- It's familiar for Hyper-V and server admins, allowing them to leverage existing virtualization and storage concepts and skills.
- It works with existing data center processes and tools such as Microsoft System Center, Active Directory, Group Policy, and PowerShell scripting.
- It works with popular third-party backup, security, and monitoring tools.
- Flexible hardware choices allow customers to choose the vendor with the best service and support in their geography.
- Joint support between Microsoft and the hardware vendor improves the customer experience.
- Seamless, full-stack updates make it easy to stay current.
- A flexible and broad ecosystem gives IT professionals the flexibility they need to build a solution that best meets their needs.

## What you need for Azure Stack HCI

To get started, here's what you need:

- A cluster of two or more servers from the [Azure Stack HCI Catalog](https://hcicatalog.azurewebsites.net), purchased from your preferred Microsoft hardware partner
- An [Azure subscription](https://azure.microsoft.com/)
- An internet connection for each server in the cluster that can connect via HTTPS outbound traffic to well-known Azure endpoints at least every 30 days
- For clusters stretched across sites, you need at least one 1 Gb connection between sites (a 25 Gb RDMA connection is preferred), with an average latency of 5 ms round trip if you want to do synchronous replication where writes occur simultaneously in both sites
- If you plan to use Software Defined Networking (SDN), you'll need a virtual hard disk (VHD) for the Azure Stack HCI operating system to create Network Controller VMs (see [Plan to deploy Network Controller](concepts/network-controller.md))

For more information, see [System requirements](concepts/system-requirements.md). For Azure Kubernetes Service on Azure Stack HCI requirements, see [AKS requirements on Azure Stack HCI](../aks-hci/overview.md#what-you-need-to-get-started).

## Hardware partners

You can purchase validated Azure Stack HCI solutions from your preferred Microsoft partner to get up and running without lengthy design and build time. Microsoft partners also offer a single point of contact for implementation and support services. You can either purchase validated nodes or an integrated system, which includes the Azure Stack HCI operating system pre-installed as well as partner extensions for driver and firmware updates.

Visit the [Azure Stack HCI solutions](https://azure.microsoft.com/overview/azure-stack/hci) page or browse the [Azure Stack HCI Catalog](https://hcicatalog.azurewebsites.net) to view 70+ Azure Stack HCI solutions currently available from Microsoft partners such as ASUS, Axellio, Blue Chip, DataON, Dell EMC, Fujitsu, HPE, Hitachi, Huawei, Lenovo, NEC, primeLine Solutions, QCT, SecureGUARD, and Supermicro.

## Software partners

There is a variety of Microsoft partners working on software that extends the capabilities of Azure Stack HCI while allowing IT admins to use familiar tools. To learn more, see [Utility applications for Azure Stack HCI](concepts/utility-applications.md).

## Licensing, billing, and pricing

Azure Stack HCI billing is based on a monthly subscription fee per physical processor core, not a perpetual license. When customers connect to Azure, the number of cores used is automatically uploaded and assessed for billing purposes. Cost doesn’t vary with consumption beyond the physical processor cores, meaning that more VMs don’t cost more, and customers who are able to run denser virtual environments are rewarded.

Customers can either purchase validated servers from a hardware partner with the Azure Stack HCI operating system pre-installed, or they can buy validated bare metal servers from an OEM and then subscribe to the Azure Stack HCI service and [download the Azure Stack HCI operating system](https://azure.microsoft.com/products/azure-stack/hci/).

## The Azure Stack family

Azure Stack HCI is part of the Azure and Azure Stack family, using the same software-defined compute, storage, and networking software as Azure Stack Hub. The following provides a quick summary of the different solutions. For more information, see [Comparing the Azure Stack ecosystem](../operator/compare-azure-azure-stack.md).

- [Azure](https://azure.microsoft.com) - Use public cloud services for on-demand, self-service computing resources to migrate and modernize existing apps and to build new cloud-native apps.
- [Azure Stack Edge](/azure/databox-online/data-box-edge-overview) - Accelerate machine learning workloads and run containerized apps or virtualized workloads on-premises, on a cloud-managed appliance.
- [Azure Stack HCI](https://azure.microsoft.com/overview/azure-stack/hci) - Run virtualized apps on-premises, replace and consolidate aging server infrastructure, and connect to Azure for cloud services.
- [Azure Stack Hub](../operator/azure-stack-overview.md) - Run cloud apps on-premises, when disconnected, or to meet regulatory requirements, using consistent Azure services.

:::image type="content" source="media/overview/azure-family-updated.png" alt-text="Azure Stack family solution diagram" border="false":::

## What's new in Azure Stack HCI

Windows Admin Center version 2009 adds a number of features to Azure Stack HCI, including the following:

- **Azure Kubernetes Service hosting capabilities**: You can now install a preview version of [Azure Kubernetes Service on Azure Stack HCI](https://azure.microsoft.com/products/azure-stack/hci/hci-download/).
- **Inclusion of Software Defined Networking in the Cluster Creation wizard**: The Cluster Creation wizard now includes the option to deploy the [Software Defined Networking (SDN)](concepts/software-defined-networking.md) Network Controller feature during [cluster creation](deploy/create-cluster.md#step-5-sdn-optional).
- **Remote direct memory access (RDMA) enhancements in the Cluster Creation wizard**: The Cluster Creation wizard can now configure RDMA for iWARP and RoCE network adapters, including Data Center Bridging (DCB).

For details on new features, see [Announcing general availability of the cluster creation extension in Windows Admin Center](https://techcommunity.microsoft.com/t5/windows-admin-center-blog/announcing-general-availability-of-the-cluster-creation/ba-p/1978332).

Clusters running Azure Stack HCI, version 20H2 have the following new features as compared to Windows Server 2019-based solutions:

- **New capabilities in Windows Admin Center**: With the ability to create and update hyperconverged clusters via an intuitive UI, Azure Stack HCI is easier than ever to use.
- **Stretched clusters for automatic failover**: Multi-site clustering with Storage Replica replication and automatic VM failover provides native disaster recovery and business continuity.
- **Affinity and anti-affinity rules**: These can be used similarly to how Azure uses Availability Zones to keep VMs and storage together or apart in clusters with multiple fault domains, such as stretched clusters.
- **Azure portal integration**: The Azure portal experience for Azure Stack HCI is designed to view all of your Azure Stack HCI clusters across the globe, with new features in development.
- **GPU acceleration for high-performance workloads**: AI/ML applications can benefit from boosting performance with GPUs.
- **BitLocker encryption**: You can now use BitLocker to encrypt the contents of data volumes on Azure Stack HCI, helping government and other customers stay compliant with standards such as FIPS 140-2 and HIPAA.
- **Improved Storage Spaces Direct volume repair speed**: Repair volumes quickly and seamlessly.

To learn more about what's new in Azure Stack HCI 20H2, [watch this video](https://www.youtube.com/watch?v=DPG7wGhh3sAa) from Microsoft Inspire.

## Roles you can run without virtualizing

Because Azure Stack HCI is intended as a virtualization host where you run all of your workloads in virtual machines, the Azure Stack HCI terms allow you to run only what's necessary for hosting virtual machines.

This means that you can run the following server roles:

- Hyper-V
- Network Controller and other components required for Software Defined Networking (SDN)

But any other roles and apps must run inside of VMs. Note that you can run utilities, apps, and services necessary for the management and health of hosted VMs.

## Video-based learning

The Azure extended network video is here:

- [Seamless connectivity to Azure with Windows Server and hybrid networking](https://www.youtube.com/watch?v=do2_4Y2p9dk)

Videos about the original, Windows Server 2019-based version of Azure Stack HCI:

- [Azure Stack and Azure Stack HCI overview view](https://aka.ms/AzureStackOverviewVideo)
- [Microsoft Ignite Live 2019 - Getting Started with Azure Stack HCI](https://www.youtube.com/watch?v=vueHIBqNIEU)
- [Discover Azure Stack HCI](https://www.youtube.com/watch?v=4aGZK0Ndmh8&list=PLQXpv_NQsPICdXZoH-EzlIFa4P6VS5m11&index=13&t=0s)
- [Modernize your retail stores or branch offices with Azure Stack HCI](https://www.youtube.com/watch?v=-JzLhjfkhmM&list=PLQXpv_NQsPICdXZoH-EzlIFa4P6VS5m11&index=9&t=0s)
- [What's new for Azure Stack HCI: 45 things in 45 minutes](https://www.youtube.com/watch?v=C5J4IEnlS_E&list=PLQXpv_NQsPICdXZoH-EzlIFa4P6VS5m11&index=12&t=0s)
- [Jumpstart your Azure Stack HCI deployment](https://www.youtube.com/watch?v=gxaPJLrWy5w&list=PLQXpv_NQsPICdXZoH-EzlIFa4P6VS5m11&index=11&t=0s)
- [The case of the shrinking data: Data Deduplication in Azure Stack HCI](https://www.youtube.com/watch?v=fmm4iDbDiY4&list=PLQXpv_NQsPICdXZoH-EzlIFa4P6VS5m11&index=23&t=0s)
- [Dave Kawula's notes from the field on Azure Stack HCI](https://www.youtube.com/watch?v=OXv7fLlz0ew&list=PLQXpv_NQsPICdXZoH-EzlIFa4P6VS5m11&index=2&t=0s)

Here's a video from a Hybrid Cloud Virtual Event:

- [Azure Stack HCI | Hybrid Cloud Virtual Event](https://www.youtube.com/watch?v=nxpoEva-R2Y)

## Next steps

- [Download Azure Stack HCI](https://azure.microsoft.com/products/azure-stack/hci/hci-download/)
- [Create an Azure Stack HCI cluster and register it with Azure](deploy/deployment-quickstart.md)
- [Use Azure Stack HCI with Windows Admin Center](get-started.md)
