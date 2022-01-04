---
title: Azure Stack HCI solution overview
description: Azure Stack HCI is a hyperconverged infrastructure (HCI) cluster solution that hosts virtualized Windows and Linux workloads and their storage in a hybrid on-premises environment. Azure hybrid services enhance the cluster with capabilities such as cloud-based monitoring, Site Recovery, and VM backups, as well as a central view of all of your Azure Stack HCI deployments in the Azure portal.
ms.topic: overview
author: jasongerend
ms.author: jgerend
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 10/22/2021
ms.custom: "e2e-hybrid, contperf-fy22q1"
---

# Azure Stack HCI solution overview

> Applies to: Azure Stack HCI, versions 21H2 and 20H2

Azure Stack HCI is a hyperconverged infrastructure (HCI) cluster solution that hosts virtualized Windows and Linux workloads and their storage in a hybrid environment that combines on-premises infrastructure with Azure cloud services.

Azure Stack HCI, version 21H2 is now [available for download](https://azure.microsoft.com/products/azure-stack/hci/hci-download/). You can either purchase integrated systems from a Microsoft hardware partner with the Azure Stack HCI operating system pre-installed, or buy validated nodes and install the operating system yourself. See the [Azure Stack HCI Catalog](https://aka.ms/AzureStackHCICatalog) for hardware options.

Azure Stack HCI is intended as a virtualization host, so most apps and server roles must run inside of virtual machines (VMs). Exceptions include Hyper-V, Network Controller, and other components required for Software Defined Networking (SDN) or for the management and health of hosted VMs.

Azure Stack HCI is delivered as an Azure service and [billed to an Azure subscription](concepts/billing.md). Azure hybrid services enhance the cluster with capabilities such as cloud-based monitoring, Site Recovery, and VM backups, as well as a central view of all of your Azure Stack HCI deployments in the Azure portal. You can manage the cluster with your existing tools, including Windows Admin Center and PowerShell.

## Azure Stack HCI features and architecture

Azure Stack HCI is a world-class, integrated virtualization stack built on proven technologies that have already been deployed at scale, including Hyper-V, Storage Spaces Direct, and Azure-inspired SDN. It's part of the [Azure Stack family](../index.yml), using the same software-defined compute, storage, and networking software as [Azure Stack Hub](https://azure.microsoft.com/products/azure-stack/hub/).

Watch the video on the high-level features of Azure Stack HCI:

> [!VIDEO https://www.youtube.com/embed/fw8RVqo9dcs]

Each Azure Stack HCI cluster consists of between 2 and 16 physical, validated servers. The clustered servers share common configuration and resources by leveraging the Windows Server Failover Clustering feature.

Azure Stack HCI combines the following:

- Azure Stack HCI operating system
- Validated hardware from an OEM partner
- Azure hybrid services
- Windows Admin Center
- Hyper-V-based compute resources
- Storage Spaces Direct-based virtualized storage
- SDN-based virtualized networking using Network Controller (optional)

:::image type="content" source="media/overview/azure-stack-hci-solution.png" alt-text="The Azure Stack HCI OS runs on top of validated hardware, is managed by Windows Admin Center, and connects to Azure" border="false":::

Using Azure Stack HCI and Windows Admin Center, you can create a hyperconverged cluster that's easy to manage and uses Storage Spaces Direct for superior storage price-performance. This includes the option to stretch the cluster across sites and use automatic failover. See [What's new in Azure Stack HCI, version 21H2](whats-new-hci-21h2.md) for details on the latest functionality enhancements.

## Why Azure Stack HCI?

There are many reasons customers choose Azure Stack HCI, including:

- It's familiar for Hyper-V and server admins, allowing them to leverage existing virtualization and storage concepts and skills.
- It works with existing data center processes and tools such as Microsoft System Center, Active Directory, Group Policy, and PowerShell scripting.
- It works with popular third-party backup, security, and monitoring tools.
- Flexible hardware choices allow customers to choose the vendor with the best service and support in their geography.
- Joint support between Microsoft and the hardware vendor improves the customer experience.
- Seamless, full-stack updates make it easy to stay current.
- A flexible and broad ecosystem gives IT professionals the flexibility they need to build a solution that best meets their needs.

### Common use cases for Azure Stack HCI

Customers often choose Azure Stack HCI in the following scenarios.

| Use case                                          | Description                             |
| :------------------------------------------------ | :-------------------------------------- |
| Branch office and edge                            | For branch office and edge workloads, you can minimize infrastructure costs by deploying two-node clusters with inexpensive witness options, such as Cloud Witness or a USB drive–based file share witness. Another factor that contributes to the lower cost of two-node clusters is support for switchless networking, which relies on crossover cable between cluster nodes instead of more expensive high-speed switches. Customers can also centrally view remote Azure Stack HCI deployments in the Azure portal. To learn more about this workload, see [Deploy branch office and edge on Azure Stack HCI](deploy/branch-office-edge.md).|
| Virtual desktop infrastructure (VDI)              | Azure Stack HCI clusters are well suited for large-scale VDI deployments with RDS or equivalent third-party offerings as the virtual desktop broker. Azure Stack HCI provides additional benefits by including centralized storage and enhanced security, which simplifies protecting user data and minimizes the risk of accidental or intentional data leaks. To learn more about this workload, see [Deploy virtual desktop infrastructure (VDI) on Azure Stack HCI](deploy/virtual-desktop-infrastructure.md).|
| Highly performant SQL Server                      | Azure Stack HCI provides an additional layer of resiliency to highly available, mission-critical Always On availability groups-based deployments of SQL Server. This approach also offers extra benefits associated with the single-vendor approach, including simplified support and performance optimizations built into the underlying platform. To learn more about this workload, see [Deploy SQL Server on Azure Stack HCI](deploy/sql-server.md).|
| Trusted enterprise virtualization                 | Azure Stack HCI satisfies the trusted enterprise virtualization requirements through its built-in support for Virtualization-based Security (VBS). VBS relies on Hyper-V to implement the mechanism referred to as virtual secure mode, which forms a dedicated, isolated memory region within its guest VMs. By using programming techniques, it's possible to perform designated, security-sensitive operations in this dedicated memory region while blocking access to it from the host OS. This considerably limits potential vulnerability to kernel-based exploits. To learn more about this workload, see [Deploy Trusted Enterprise Virtualization on Azure Stack HCI](deploy/trusted-enterprise-virtualization.md).|
| Azure Kubernetes Service (AKS)                    | You can leverage Azure Stack HCI to host container-based deployments, which increases workload density and resource usage efficiency. Azure Stack HCI also further enhances the agility and resiliency inherent to Azure Kubernetes deployments. Azure Stack HCI manages automatic failover of VMs serving as Kubernetes cluster nodes in case of a localized failure of the underlying physical components. This supplements the high availability built into Kubernetes, which automatically restarts failed containers on either the same or another VM. To learn more about this workload, see [What is Azure Kubernetes Service on Azure Stack HCI?](../aks-hci/overview.md).|
| Scale-out storage                                 | Storage Spaces Direct is a core technology of Azure Stack HCI that uses industry-standard servers with locally attached drives to offer high availability, performance, and scalability. Using Storage Spaces Direct results in significant cost reductions compared with competing offers based on storage area network (SAN) or network-attached storage (NAS) technologies. These benefits result from an innovative design and a wide range of enhancements, such as persistent read/write cache drives, mirror-accelerated parity, nested resiliency, and deduplication.|
| Disaster recovery for virtualized workloads       | An Azure Stack HCI stretched cluster provides automatic failover of virtualized workloads to a secondary site following a primary site failure. Synchronous replication ensures crash consistency of VM disks.|
| Data center consolidation and modernization       | Refreshing and consolidating aging virtualization hosts with Azure Stack HCI can improve scalability and make your environment easier to manage and secure. It's also an opportunity to retire legacy SAN storage to reduce footprint and total cost of ownership. Operations and systems administration are simplified with unified tools and interfaces and a single point of support.|
| Run Azure services on-premises                    | Azure Arc allows you to run Azure services anywhere. This allows you to build consistent hybrid and multicloud application architectures by using Azure services that can run in Azure, on-premises, at the edge, or at other cloud providers. Azure Arc enabled services allow you to run Azure data services and Azure application services such as Azure App Service, Functions, Logic Apps, Event Grid, and API Management anywhere to support hybrid workloads. To learn more, see [Azure Arc overview](/azure/azure-arc/overview).|

### Azure integration benefits

Azure Stack HCI allows you to take advantage of cloud and on-premises resources working together and natively monitor, secure, and back up to the cloud.

After you [register your Azure Stack HCI cluster](deploy/register-with-azure.md) with Azure, you can use the Azure portal initially for:

- **Monitoring:** View all of your Azure Stack HCI clusters in a single, global view where you can group them by resource group and tag them.
- **Billing:** Pay for Azure Stack HCI through your Azure subscription.

You can also subscribe to additional Azure hybrid services.

## What you need for Azure Stack HCI

To get started, you'll need:

- A cluster of two or more servers from the [Azure Stack HCI Catalog](https://aka.ms/AzureStackHCICatalog), purchased from your preferred Microsoft hardware partner.
- An [Azure subscription](https://azure.microsoft.com/).
- Operating system licenses for your workload VMs – for example, Windows Server. See [Activate Windows Server VMs](manage/vm-activate.md). 
- An internet connection for each server in the cluster that can connect via HTTPS outbound traffic to well-known Azure endpoints at least every 30 days. See [Azure connectivity requirements](concepts/firewall-requirements.md) for more information.
- For clusters stretched across sites, you'll need at least one 1 Gb connection between sites (a 25 Gb RDMA connection is preferred), with an average latency of 5 ms round trip if you want to do synchronous replication where writes occur simultaneously in both sites.
- If you plan to use SDN, you'll need a virtual hard disk (VHD) for the Azure Stack HCI operating system to create Network Controller VMs (see [Plan to deploy Network Controller](concepts/network-controller.md)).

Make sure your hardware meets the [System requirements](concepts/system-requirements.md) and that your network meets the [physical network](concepts/physical-network-requirements.md) and [host network](concepts/host-network-requirements.md) requirements for Azure Stack HCI.

For Azure Kubernetes Service on Azure Stack HCI requirements, see [AKS requirements on Azure Stack HCI](../aks-hci/overview.md#what-you-need-to-get-started).

Azure Stack HCI is priced on a per core basis on your on-premises servers. For current pricing, see [Azure Stack HCI pricing](https://azure.microsoft.com/pricing/details/azure-stack/hci/).

## Hardware and software partners

Microsoft recommends purchasing Integrated Systems built by our hardware partners and validated by Microsoft to provide the best experience running Azure Stack HCI. You can also run Azure Stack HCI on Validated Nodes, which offer a basic building block for HCI clusters to give customers more hardware choices. Microsoft partners also offer a single point of contact for implementation and support services.

Visit the [Azure Stack HCI solutions](https://azure.microsoft.com/overview/azure-stack/hci) page or browse the [Azure Stack HCI Catalog](https://aka.ms/AzureStackHCICatalog) to view Azure Stack HCI solutions from Microsoft partners such as ASUS, Blue Chip, DataON, Dell EMC, Fujitsu, HPE, Hitachi, Lenovo, NEC, primeLine Solutions, QCT, SecureGUARD, and Supermicro.

Some Microsoft partners are developing software that extends the capabilities of Azure Stack HCI while allowing IT admins to use familiar tools. To learn more, see [Utility applications for Azure Stack HCI](concepts/utility-applications.md).

## Next steps

- [Download Azure Stack HCI](https://azure.microsoft.com/products/azure-stack/hci/hci-download/)
- [Create an Azure Stack HCI cluster and register it with Azure](deploy/deployment-quickstart.md)
- [Use Azure Stack HCI with Windows Admin Center](get-started.md)
- [Compare Azure Stack HCI to Windows Server](concepts/compare-windows-server.md)
- [Compare Azure Stack HCI to Azure Stack Hub](concepts/compare-azure-stack-hub.md)