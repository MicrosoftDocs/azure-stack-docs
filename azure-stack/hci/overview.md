---
title: Azure Stack HCI solution overview
description: Azure Stack HCI is a hyperconverged infrastructure (HCI) cluster solution that hosts virtualized Windows and Linux workloads and their storage in a hybrid on-premises environment. Azure hybrid services enhance the cluster with capabilities such as cloud-based monitoring, Site Recovery, and VM backups, as well as a central view of all of your Azure Stack HCI deployments in the Azure portal.
ms.topic: overview
author: khdownie
ms.author: v-kedow
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 10/28/2020
---

# Azure Stack HCI solution overview

Azure Stack HCI is a hyperconverged infrastructure (HCI) cluster solution that hosts virtualized Windows and Linux workloads and their storage in a hybrid on-premises environment. Azure hybrid services enhance the cluster with capabilities such as cloud-based monitoring, Site Recovery, and VM backups, as well as a central view of all of your Azure Stack HCI deployments in the Azure portal. You can manage the cluster with your existing tools including Windows Admin Center, System Center, and PowerShell.

Azure Stack HCI, version 20H2 is a new operating system now in Public Preview and [available for download](https://azure.microsoft.com/products/azure-stack/hci/hci-download/). It's intended for on-premises clusters running virtualized workloads, with hybrid-cloud connections built-in. As such, Azure Stack HCI is delivered as an Azure service and billed on an Azure subscription. Azure Stack HCI also now includes the ability to host the Azure Kubernetes Service; for details, see [Azure Kubernetes Service on Azure Stack HCI](../aks-hci/overview.md).

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
- **Billing:** Pay for Azure Stack HCI through your Azure subscription (note that there's no cost during the Public Preview).

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

- A cluster of two or more servers from the [Azure Stack HCI Catalog](https://azure.microsoft.com/products/azure-stack/hci/catalog/), purchased from your preferred Microsoft hardware partner
- An [Azure subscription](https://azure.microsoft.com/)
- An internet connection for each server in the cluster that can connect via HTTPS outbound traffic to the following endpoint at least every 30 days: *-azurestackhci-usage.azurewebsites.net
- For clusters stretched across sites, you need at least one 1 Gb connection between sites (a 25 Gb RDMA connection is preferred), with an average latency of 5 ms round trip if you want to do synchronous replication where writes occur simultaneously in both sites

For more information, see [System requirements](concepts/system-requirements.md). For Azure Kubernetes Service on Azure Stack HCI requirements, see [AKS requirements on Azure Stack HCI](../aks-hci/overview.md#what-you-need-to-get-started).

## Hardware partners

You can purchase validated Azure Stack HCI solutions from your preferred Microsoft partner to get up and running without lengthy design and build time. Microsoft partners also offer a single point of contact for implementation and support services. You can either purchase validated nodes or an integrated system, which includes the Azure Stack HCI operating system pre-installed as well as partner extensions for driver and firmware updates.

Visit the [Azure Stack HCI solutions](https://azure.microsoft.com/overview/azure-stack/hci) page or browse the [Azure Stack HCI Catalog](https://azure.microsoft.com/products/azure-stack/hci/catalog/) to view 70+ Azure Stack HCI solutions currently available from Microsoft partners such as ASUS, Axellio, Blue Chip, DataON, Dell EMC, Fujitsu, HPE, Hitachi, Huawei, Lenovo, NEC, primeLine Solutions, QCT, SecureGUARD, and Supermicro.

## Software partners

There are a variety of Microsoft partners working on software that extends the capabilities of Azure Stack HCI while allowing IT admins to use familiar tools. For example, Altaro, a worldwide provider of backup solutions and Microsoft Gold Partner, has committed to supporting Azure Stack HCI in its Altaro VM Backup solution. This will allow customers and managed service providers to back up virtual machines running on Azure Stack HCI for free until end of June 2021. [Learn more about this announcement](http://www.altaro.com/news/single/News-Altaro-applies-its-expertise-in-Hyper-V-backup-to-support-Microsoft.php).

## Licensing, billing, and pricing

Azure Stack HCI billing is based on a monthly subscription fee per physical processor core, not a perpetual license. When customers connect to Azure, the number of cores used is automatically uploaded and assessed for billing purposes. Cost doesn’t vary with consumption beyond the physical processor cores, meaning that more VMs don’t cost more, and customers who are able to run denser virtual environments are rewarded.

Customers can either purchase validated servers from a hardware partner with the Azure Stack HCI operating system pre-installed, or they can buy validated bare metal servers from an OEM and then subscribe to the Azure Stack HCI service and download the Azure Stack HCI operating system from the [Azure portal](https://azure.microsoft.com/products/azure-stack/hci/).

## Management tools

With Azure Stack HCI, you have full admin rights on the cluster and can manage any of its technologies directly:

- [Hyper-V](/windows-server/virtualization/hyper-v/hyper-v-on-windows-server)
- [Storage Spaces Direct](/windows-server/storage/storage-spaces/storage-spaces-direct-overview)
- [Software Defined Networking](/windows-server/networking/sdn/)
- [Failover Clustering](/windows-server/failover-clustering/failover-clustering-overview)

To manage these technologies, you can use the following management tools:

- [Windows Admin Center](/windows-server/manage/windows-admin-center/overview)
- [System Center](https://www.microsoft.com/cloud-platform/system-center)
- [PowerShell](/powershell/)
- Other management tools, like [Server Manager](/windows-server/administration/server-manager/server-manager), and MMC snap-ins
- Non-Microsoft tools like 5Nine Manager

## FAQ

### How does Azure Stack HCI relate to Windows Server?

Windows Server is the foundation of nearly every Azure product, and all the features you value continue to ship and be supported in Windows Server. The initial offering of Azure Stack HCI was based on Windows Server 2019 and used the traditional Windows Server licensing model. Today, Azure Stack HCI has its own operating system and subscription-based licensing model. Azure Stack HCI is the recommended way to deploy HCI on-premises, using Microsoft-validated hardware from our partners.

### Does Azure Stack HCI need to connect to Azure?

Yes, the cluster must connect to Azure at least once every 30 days in order for the number of cores to be assessed for billing purposes. You can also take advantage of integration with Azure for hybrid scenarios like off-site backup and disaster recovery, and cloud-based monitoring and update management, but they're optional. It's no problem to run disconnected from the internet for extended periods.

### Can I upgrade from Windows Server 2019 to Azure Stack HCI?

There is no in-place upgrade from Windows Server to Azure Stack HCI at this time. Stay tuned for specific migration guidance for customers running hyperconverged clusters based on Windows Server 2019 and 2016.

### What do Azure Stack Hub and Azure Stack HCI solutions have in common?

Azure Stack HCI features the same Hyper-V-based software-defined compute, storage, and networking technologies as Azure Stack Hub. Both offerings meet rigorous testing and validation criteria to ensure reliability and compatibility with the underlying hardware platform.

### How are they different?

With Azure Stack Hub, you run cloud services on-premises. You can run Azure IaaS and PaaS services on-premises to consistently build and run cloud apps anywhere, managed with the Azure portal on-premises.

With Azure Stack HCI, you run virtualized workloads on-premises, managed with Windows Admin Center and familiar Windows Server tools. You can also connect to Azure for hybrid scenarios like cloud-based Site Recovery, monitoring, and others.

### Why is Microsoft bringing its HCI offering to the Azure Stack family?

Microsoft's hyperconverged technology is already the foundation of Azure Stack Hub.

Many Microsoft customers have complex IT environments and our goal is to provide solutions that meet them where they are with the right technology for the right business need. Azure Stack HCI is an evolution of the Windows Server Software-Defined (WSSD) solutions previously available from our hardware partners. We brought it into the Azure Stack family because we've started to offer new options to connect seamlessly with Azure for infrastructure management services.

### Can I upgrade from Azure Stack HCI to Azure Stack Hub?

No, but customers can migrate their workloads from Azure Stack HCI to Azure Stack Hub or Azure.

### What Azure services can I connect to Azure Stack HCI?

For an updated list of Azure services that you can connect Azure Stack HCI to, see [Connecting Windows Server to Azure hybrid services](/windows-server/manage/windows-admin-center/azure/index).

### Does Azure Stack HCI collect any data from my system?

Yes - a very limited set of data is collected. This data is used to keep HCI up to date, performing properly, provide information to the Azure portal, and to assess the number of processor cores in the cluster for billing purposes.

### To which endpoints is the data transmitted?  

Azure Stack HCI uses the following endpoint to transmit billing data: *-azurestackhci-usage.azurewebsites.net

### How do I identify an Azure Stack HCI server?

Windows Admin Center lists the operating system in the All Connections list and various other places, or you can use the following PowerShell command to query for the operating system name and version.

```PowerShell
Get-ComputerInfo -Property 'osName', 'osDisplayVersion'
```

Here’s some example output:

```
OsName                    OSDisplayVersion
------                    ----------------
Microsoft Azure Stack HCI 20H2
```

## The Azure Stack family

Azure Stack HCI is part of the Azure and Azure Stack family, using the same software-defined compute, storage, and networking software as Azure Stack Hub. The following provides a quick summary of the different solutions. For more information, see [Comparing the Azure Stack ecosystem](../operator/compare-azure-azure-stack.md).

- [Azure](https://azure.microsoft.com) - Use public cloud services for on-demand, self-service computing resources to migrate and modernize existing apps and to build new cloud-native apps.
- [Azure Stack Edge](/azure/databox-online/data-box-edge-overview) - Accelerate machine learning workloads and run containerized apps or virtualized workloads on-premises, on a cloud-managed appliance.
- [Azure Stack HCI](https://azure.microsoft.com/overview/azure-stack/hci) - Run virtualized apps on-premises, replace and consolidate aging server infrastructure, and connect to Azure for cloud services.
- [Azure Stack Hub](../operator/azure-stack-overview.md) - Run cloud apps on-premises, when disconnected, or to meet regulatory requirements, using consistent Azure services.

:::image type="content" source="media/overview/azure-family-updated.png" alt-text="Azure Stack family solution diagram" border="false":::

## Compare Windows Server and Azure Stack HCI

Many customers will wonder whether Windows Server or Azure Stack HCI is a better fit for their needs. The following table helps you determine which is right for your organization. Both Windows Server and Azure Stack HCI provide the same high-quality user experience with a road map of new releases.

| Windows Server | Azure Stack HCI |
| --------------- | --------------- |
| Best guest and traditional server | Best virtualization host for a software-defined data center, including Storage Spaces Direct |
| Runs anywhere, using a traditional software licensing model | Runs on hardware from your preferred vendor, but is delivered as an Azure service and billed to your Azure account |
| Two installation options: Server with desktop experience or Server Core | Based on a lightly customized Server Core |

### When to use Windows Server

| Windows Server | Azure Stack HCI |
| --------------- | --------------- |
| Windows Server is a highly versatile, multi-purpose operating system, with dozens of roles and hundreds of features, including guest rights. | Azure Stack HCI doesn't include guest rights and is intended to be used for a modern, hyperconverged architecture. |
| Use Windows Server to run VMs or for bare metal installations encompassing all traditional server roles, including Active Directory, file services, DNS, DHCP, Internet Information Services (IIS), container host/guest, SQL Server, Exchange Server, Host Guardian Service (HGS), and many more. | Intended as a Hyper-V virtualization host, Azure Stack HCI is only licensed to run a small number of server roles directly; any other roles must run inside of VMs. |

### When to use Azure Stack HCI

| Windows Server | Azure Stack HCI |
| --------------- | --------------- |
| Windows Server can run on-premises or in the cloud, but isn't itself a complete hyperconverged offering.| Use Azure Stack HCI to run VMs on-premises, optionally stretched across two sites and with connections to Azure hybrid services. It's an easy way to modernize and secure your data centers and branch offices, achieve industry-best performance for SQL Server databases, and run virtual desktops on-premises for low latency and data sovereignty|
| Windows Server is a great multi-purpose "Swiss Army knife" for all Windows Server roles, virtualized or not. | Use Azure Stack HCI to virtualize classic enterprise apps like Exchange, SharePoint, and SQL Server, and to virtualize Windows Server roles like File Server, DNS, DHCP, IIS, and AD. Includes unrestricted access to all Hyper-V features like Shielded VMs.|
| Many Windows Server deployments run on aging hardware. | Use Azure Stack HCI to use software-defined infrastructure in place of aging storage arrays or network appliances, without major rearchitecture. Built-in Hyper-V, Storage Spaces Direct, and Software-Defined Networking (SDN) are directly accessible and manageable. Run apps inside Windows or Linux VMs.|

## Compare Azure Stack Hub and Azure Stack HCI

As your organization digitally transforms, you may find you can move faster by using public cloud services to build on modern architectures and refresh legacy apps. However, for reasons that include technological and regulatory obstacles, many workloads must remain on-premises. Use this table to help determine which Microsoft hybrid cloud strategy provides what you need where you need it, delivering cloud innovation for workloads wherever they are.

| Azure Stack Hub | Azure Stack HCI |
| --------------- | --------------- |
| New skills, innovative processes | Same skills, familiar processes |
| Azure services in your datacenter | Connect your datacenter to Azure services |

### When to use Azure Stack Hub

| Azure Stack Hub | Azure Stack HCI |
| --------------- | --------------- |
| Use Azure Stack Hub for self-service Infrastructure-as-a-Service (IaaS), with strong isolation and precise usage tracking and chargeback for multiple colocated tenants. Ideal for service providers and enterprise private clouds. Templates from the Azure Marketplace. | Azure Stack HCI doesn't natively enforce or provide for multi-tenancy. |
| Use Azure Stack Hub to develop and run apps that rely on Platform-as-a-Service (PaaS) services like Web Apps, Functions, or Event Hubs on-premises. These services run on Azure Stack Hub exactly like they do in Azure, providing a consistent hybrid development and runtime environment. | Azure Stack HCI doesn't run PaaS services on-premises. |
| Use Azure Stack Hub to modernize app deployment and operation with DevOps practices like infrastructure as code, continuous integration and continuous deployment (CI/CD), and convenient features like Azure-consistent VM extensions. Ideal for Dev and DevOps teams. | Azure Stack HCI doesn't natively include any DevOps tooling. |

### When to use Azure Stack HCI

| Azure Stack Hub | Azure Stack HCI |
| --------------- | --------------- |
| Azure Stack Hub requires minimum 4 nodes and its own network switches. | Use Azure Stack HCI for the minimum footprint for remote offices and branches. Start with just 2 server nodes and switchless back-to-back networking for peak simplicity and affordability. Hardware offers start at 4 drives, 64 GB of memory, well under $10k/node. |
| Azure Stack Hub constrains Hyper V configurability and feature set for consistency with Azure. | Use Azure Stack HCI for no-frills Hyper-V virtualization for classic enterprise apps like Exchange, SharePoint, and SQL Server, and to virtualize Windows Server roles like File Server, DNS, DHCP, IIS, and AD. Unrestricted access to all Hyper-V features like Shielded VMs.|
| Azure Stack Hub doesn't expose these infrastructural technologies. | Use Azure Stack HCI to use software-defined infrastructure in place of aging storage arrays or network appliances, without major rearchitecture. Built-in Hyper-V, Storage Spaces Direct, and Software-Defined Networking (SDN) are directly accessible and manageable. |

## What's new in Azure Stack HCI

Windows Admin Center version 2009 adds a number of features to Azure Stack HCI, including the following:

- **Azure Kubernetes Service hosting capabilities**: You can now install a preview version of [Azure Kubernetes Service on Azure Stack HCI](https://azure.microsoft.com/products/azure-stack/hci/hci-download/).
- **Inclusion of Software Defined Networking in the Cluster Creation wizard**: The Cluster Creation wizard now includes the option to deploy the [Software Defined Networking (SDN)](concepts/software-defined-networking.md) Network Controller feature during [cluster creation](deploy/create-cluster.md#step-5-sdn-optional).

For details on new features in Windows Admin Center, see the [Windows Admin Center blog](https://techcommunity.microsoft.com/t5/windows-admin-center-blog/bg-p/Windows-Admin-Center-Blog).

Clusters running Azure Stack HCI, version 20H2 have the following new features as compared to Windows Server 2019-based solutions:

- **New capabilities in Windows Admin Center**: With the ability to create and update hyperconverged clusters via an intuitive UI, Azure Stack HCI is easier than ever to use.
- **Stretched clusters for automatic failover**: Multi-site clustering with Storage Replica replication and automatic VM failover provides native disaster recovery and business continuity to clusters that use Storage Spaces Direct.
- **Affinity and anti-affinity rules**: These can be used similarly to how Azure uses Availability Zones to keep VMs and storage together or apart in clusters with multiple fault domains, such as stretched clusters.
- **Azure portal integration**: The Azure portal experience for Azure Stack HCI is designed to view all of your Azure Stack HCI clusters across the globe, with new features in development.
- **GPU acceleration for high-performance workloads**: AI/ML applications can benefit from boosting performance with GPUs.
- **BitLocker encryption**: You can now use BitLocker to encrypt the contents of data volumes on Azure Stack HCI, helping government and other customers stay compliant with standards such as FIPS 140-2 and HIPAA.
- **Improved Storage Spaces Direct volume repair speed**: Repair volumes quickly and seamlessly.

Windows Admin Center, version 20H2 also provides new cluster updating UI to Windows Server-based clusters, including the original Azure Stack HCI solutions. And while you can use the new cluster creation wizard with Windows Server, it can't create Windows Server clusters with Storage Spaces Direct; you need the Azure Stack HCI operating system for that.

## Roles you can run without virtualizing

Because Azure Stack HCI is intended as a virtualization host where you run all of your workloads in virtual machines, the Azure Stack HCI terms allow you to run only what's necessary for hosting virtual machines.

This means that you can run the following server roles:

- Hyper-V
- Network controller and other components required for Software Defined Networking (SDN)

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
- [Use Azure Stack HCI with Windows Admin Center](get-started.md)
