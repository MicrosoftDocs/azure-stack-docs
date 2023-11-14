---
title: Azure Stack HCI solution overview
description: Azure Stack HCI is a hyperconverged infrastructure (HCI) cluster solution that hosts virtualized Windows and Linux workloads and their storage in a hybrid on-premises environment. Azure hybrid services enhance the cluster with capabilities such as cloud-based monitoring, Site Recovery, and VM backups, as well as a central view of all of your Azure Stack HCI deployments in the Azure portal.
ms.topic: overview
author: jasongerend
ms.author: jgerend
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 11/14/2023
ms.custom: "e2e-hybrid, contperf-fy22q1"
---

# Azure Stack HCI solution overview

[!INCLUDE [applies-to](../includes/hci-applies-to-22h2-21h2.md)]

> Looking for the latest preview? See [What's new in Azure Stack HCI](whats-new.md).

Azure Stack HCI is a hyperconverged infrastructure (HCI) solution that hosts Windows and Linux VM or containerized workloads and their storage. It's a hybrid product that connects the on-premises system to Azure for cloud-based services, monitoring, and management.

## Overview

An Azure Stack HCI system consists of a server or a cluster of servers running the Azure Stack HCI operating system and connected to Azure. You can use the Azure portal to monitor and manage individual Azure Stack HCI systems as well as view all of your Azure Stack HCI deployments. You can also manage with your existing tools, including Windows Admin Center and PowerShell.

Azure Stack HCI is available for download from the Azure portal with a free 60-day trial ([Download Azure Stack HCI](deploy/download-azure-stack-hci-software.md)).

To acquire the servers to run Azure Stack HCI, you can purchase Azure Stack HCI integrated systems from a Microsoft hardware partner with the operating system pre-installed, or buy validated nodes and install the operating system yourself. See the [Azure Stack HCI Catalog](https://aka.ms/AzureStackHCICatalog) for hardware options and use the Azure Stack HCI sizing tool to estimate hardware requirements.

## Azure Stack HCI features and architecture

Azure Stack HCI is built on proven technologies including Hyper-V, Storage Spaces Direct, Azure Kubernetes Service (AKS), and Azure-inspired software defined networking (SDN).

Each Azure Stack HCI system consists of between 1 and 16 physical servers. All servers share common configurations and resources by leveraging the Windows Server Failover Clustering feature.

Azure Stack HCI combines the following:

- Azure Stack HCI operating system
- Validated hardware from a hardware partner
- Azure services including monitoring and management
- Windows Admin Center for management via Azure and on-premises
- Hyper-V-based compute resources
- Storage Spaces Direct-based virtualized storage
- SDN-based virtualized networking using Network Controller (optional)
- Azure Kubernetes Service (AKS) hybrid (optional)

:::image type="content" source="media/overview/azure-stack-hci-solution.png" alt-text="The Azure Stack HCI OS runs on top of validated hardware, is managed by Windows Admin Center, and connects to Azure" border="false":::

See [What's new in Azure Stack HCI](whats-new.md) for details on the latest enhancements.

## Why Azure Stack HCI?

There are many reasons customers choose Azure Stack HCI, including:

- It provides industry-leading virtualization performance and value.
- You pay for the software monthly via an Azure subscription instead of when buying the hardware.
- It's familiar for Hyper-V and server admins, allowing them to leverage existing virtualization and storage concepts and skills.
- It can be monitored and managed from the Azure portal or using on-premises tools such as Microsoft System Center, Active Directory, Group Policy, and PowerShell scripting.
- It works with popular third-party backup, security, and monitoring tools.
- Flexible hardware choices allow customers to choose the vendor with the best service and support in their geography.
- Joint support between Microsoft and the hardware vendor improves the customer experience.
- Solution updates make it easy to keep the entire solution up-to-date.

### Common use cases for Azure Stack HCI

Customers often choose Azure Stack HCI in the following scenarios.

| Use case                                          | Description                             |
| :------------------------------------------------ | :-------------------------------------- |
| Azure Virtual Desktop (AVD)            | Azure Virtual Desktop for Azure Stack HCI lets you deploy Azure Virtual Desktop session hosts on your on-premises Azure Stack HCI infrastructure. You manage your session hosts from the Azure portal. To learn more, see [Azure Virtual Desktop for Azure Stack HCI](/azure/virtual-desktop/azure-stack-hci-overview).|
| Azure Kubernetes Service (AKS) hybrid              | You can leverage Azure Stack HCI to host container-based deployments, which increases workload density and resource usage efficiency. Azure Stack HCI also further enhances the agility and resiliency inherent to Azure Kubernetes deployments. Azure Stack HCI manages automatic failover of VMs serving as Kubernetes cluster nodes in case of a localized failure of the underlying physical components. This supplements the high availability built into Kubernetes, which automatically restarts failed containers on either the same or another VM. To learn more, see [Azure Kubernetes Service on Azure Stack HCI and Windows Server](/azure/aks/hybrid/overview).|
| Run Azure Arc services on-premises                    | Azure Arc allows you to run Azure services anywhere. This allows you to build consistent hybrid and multicloud application architectures by using Azure services that can run in Azure, on-premises, at the edge, or at other cloud providers. Azure Arc enabled services allow you to run Arc VMs, Azure data services and Azure application services such as Azure App Service, Functions, Logic Apps, Event Grid, and API Management anywhere to support hybrid workloads. To learn more, see [Azure Arc overview](/azure/azure-arc/overview).|
| Highly performant SQL Server                      | Azure Stack HCI provides an additional layer of resiliency to highly available, mission-critical Always On availability groups-based deployments of SQL Server. This approach also offers extra benefits associated with the single-vendor approach, including simplified support and performance optimizations built into the underlying platform. To learn more, see [Deploy SQL Server on Azure Stack HCI](deploy/sql-server.md).|
| Trusted enterprise virtualization                 | Azure Stack HCI satisfies the trusted enterprise virtualization requirements through its built-in support for Virtualization-based Security (VBS). VBS relies on Hyper-V to implement the mechanism referred to as virtual secure mode, which forms a dedicated, isolated memory region within its guest VMs. By using programming techniques, it's possible to perform designated, security-sensitive operations in this dedicated memory region while blocking access to it from the host OS. This considerably limits potential vulnerability to kernel-based exploits. To learn more, see [Deploy Trusted Enterprise Virtualization on Azure Stack HCI](deploy/trusted-enterprise-virtualization.md).|
| Scale-out storage                                 | Storage Spaces Direct is a core technology of Azure Stack HCI that uses industry-standard servers with locally attached drives to offer high availability, performance, and scalability. Using Storage Spaces Direct results in significant cost reductions compared with competing offers based on storage area network (SAN) or network-attached storage (NAS) technologies. These benefits result from an innovative design and a wide range of enhancements, such as persistent read/write cache drives, mirror-accelerated parity, nested resiliency, and deduplication.|
| Disaster recovery for virtualized workloads       | An Azure Stack HCI stretched cluster provides automatic failover of virtualized workloads to a secondary site following a primary site failure. Synchronous replication ensures crash consistency of VM disks.|
| Data center consolidation and modernization       | Refreshing and consolidating aging virtualization hosts with Azure Stack HCI can improve scalability and make your environment easier to manage and secure. It's also an opportunity to retire legacy SAN storage to reduce footprint and total cost of ownership. Operations and systems administration are simplified with unified tools and interfaces and a single point of support.|
| Branch office and edge                            | For branch office and edge workloads, you can minimize infrastructure costs by deploying two-node clusters with inexpensive witness options, such as Cloud Witness or a USB drive–based file share witness. Another factor that contributes to the lower cost of two-node clusters is support for switchless networking, which relies on crossover cable between cluster nodes instead of more expensive high-speed switches. Customers can also centrally view remote Azure Stack HCI deployments in the Azure portal. To learn more, see [Deploy branch office and edge on Azure Stack HCI](deploy/branch-office-edge.md).|

#### Demo of using Microsoft Azure with Azure Stack HCI

For an end-to-end example of using Microsoft Azure to manage apps and infrastructure at the Edge using Azure Arc, Azure Kubernetes Service, and Azure Stack HCI, see the **Retail edge transformation with Azure hybrid** demo.

Using a fictional customer, inspired directly by real customers, you will see how to deploy Kubernetes, set up GitOps, deploy VMs, use Azure Monitor and drill into a hardware failure, all without leaving the Azure portal.

> [!VIDEO https://www.youtube.com/embed/t81MNUjAnEQ]

This video includes preview functionality which shows real product functionality, but in a closely controlled environment.

### Azure integration benefits

Azure Stack HCI allows you to take advantage of cloud and on-premises resources working together and natively monitor, secure, and back up to the cloud.

You can use the Azure portal for an increasing number of tasks including:

- **Monitoring:** View all of your Azure Stack HCI systems in a single, global view where you can group them by resource group and tag them.
- **Billing:** Pay for Azure Stack HCI through your Azure subscription.

You can also subscribe to additional Azure hybrid services.

For more details on the cloud service components of Azure Stack HCI, see [Azure Stack HCI hybrid capabilities with Azure services](hybrid-capabilities-with-azure-services.md).

## What you need for Azure Stack HCI

To get started, you'll need:

- One or more servers from the [Azure Stack HCI Catalog](https://aka.ms/AzureStackHCICatalog), purchased from your preferred Microsoft hardware partner.
- An [Azure subscription](https://azure.microsoft.com/).
- Operating system licenses for your workload VMs – for example, Windows Server. See [Activate Windows Server VMs](manage/vm-activate.md).
- An internet connection for each server in the cluster that can connect via HTTPS outbound traffic to well-known Azure endpoints at least every 30 days. See [Azure connectivity requirements](concepts/firewall-requirements.md) for more information.
- For clusters stretched across sites:
    - At least four severs (two in each site)
    - At least one 1 Gb connection between sites (a 25 Gb RDMA connection is preferred)
    - An average latency of 5 ms round trip between sites if you want to do synchronous replication where writes occur simultaneously in both sites.
- If you plan to use SDN, you'll need a virtual hard disk (VHD) for the Azure Stack HCI operating system to create Network Controller VMs (see [Plan to deploy Network Controller](concepts/network-controller.md)).

Make sure your hardware meets the [System requirements](concepts/system-requirements.md) and that your network meets the [physical network](concepts/physical-network-requirements.md) and [host network](concepts/host-network-requirements.md) requirements for Azure Stack HCI.

For Azure Kubernetes Service on Azure Stack HCI and Windows Server requirements, see [AKS requirements on Azure Stack HCI](/azure/aks/hybrid/overview#what-you-need-to-get-started).

Azure Stack HCI is priced on a per core basis on your on-premises servers. For current pricing, see [Azure Stack HCI pricing](https://azure.microsoft.com/pricing/details/azure-stack/hci/).

## Hardware and software partners

Microsoft recommends purchasing Integrated Systems built by our hardware partners and validated by Microsoft to provide the best experience running Azure Stack HCI. You can also run Azure Stack HCI on Validated Nodes, which offer a basic building block for HCI systems to give customers more hardware choices. Microsoft partners also offer a single point of contact for implementation and support services.

Browse the [Azure Stack HCI Catalog](https://aka.ms/AzureStackHCICatalog) to view Azure Stack HCI solutions from Microsoft partners such as ASUS, Blue Chip, DataON, Dell EMC, Fujitsu, HPE, Hitachi, Lenovo, NEC, primeLine Solutions, QCT, SecureGUARD, and Supermicro.

Some Microsoft partners are developing software that extends the capabilities of Azure Stack HCI while allowing IT admins to use familiar tools. To learn more, see [Utility applications for Azure Stack HCI](concepts/utility-applications.md).
