---
title: Azure Local solution overview
description: Azure Local is a hyperconverged infrastructure (HCI) cluster solution that hosts virtualized Windows and Linux workloads and their storage in a hybrid on-premises environment. Azure hybrid services enhance the cluster with capabilities such as cloud-based monitoring, Site Recovery, and VM backups, as well as a central view of all of your Azure Local deployments in the Azure portal.
ms.topic: overview
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.date: 04/30/2025
ms.custom: e2e-hybrid, linux-related-content
---

# Azure Local solution overview

[!INCLUDE [applies-to](./includes/hci-applies-to-23h2-22h2.md)]

[!INCLUDE [azure-local-banner-23h2](./includes/azure-local-banner-23h2.md)]

Azure Local extends Azure to customer-owned infrastructure, enabling local execution of modern and traditional applications across distributed locations. This solution offers a unified management experience on a single control plane and supports a wide range of validated hardware from trusted Microsoft partners.

Azure Local also accelerates cloud and AI innovation by seamlessly delivering new applications, workloads, and services from cloud to edge.

<!--Azure Local is a hyperconverged infrastructure (HCI) solution that hosts Windows and Linux VM or containerized workloads and their storage. It's a hybrid product that connects the on-premises system to Azure for cloud-based services, monitoring, and management.-->

## Overview

An Azure Local instance consists of a machine or a cluster of machines running the Azure Stack HCI operating system and connected to Azure. You can use the Azure portal to monitor and manage individual Azure Local instances as well as view all the deployments of Azure Local. You can also manage Azure Local with your existing tools, including Windows Admin Center and PowerShell.

You can [Download the operating system software](./deploy/download-23h2-software.md) from the Azure portal with a free 60-day trial.

To acquire the machines that support Azure Local, you can purchase validated hardware from a Microsoft hardware partner with the operating system pre-installed. See the [Azure Local Catalog](https://aka.ms/AzureStackHCICatalog) for hardware options and use the sizing tool to estimate hardware requirements.

## Azure Local features and architecture

Azure Local is built on proven technologies including Hyper-V, Storage Spaces Direct, and core Azure Management service.

Each Azure Local instance consists of 1 to 16 physical machines. All machines share common configurations and resources by leveraging the Windows Server Failover Clustering feature.

Azure Local combines the following:

- Validated hardware from a hardware partner.
- Azure Stack HCI OS.
- Hyper-V-based compute resources.
- Storage Spaces Direct-based virtualized storage.
- Windows and Linux virtual machines as Arc-enabled servers.
- Azure Virtual Desktop.
- Azure Kubernetes Service (AKS) enabled by Azure Arc.
- AI and machine learning workload deployment.
- Azure services including monitoring, backup, site recovery, and more.
- Azure portal, Azure Resource Manager and Bicep templates, Azure CLI and tools.

:::image type="content" source="media/overview/azure-stack-hci-solution.png" alt-text="The architecture diagram of the Azure Local solution." lightbox="media/overview/azure-stack-hci-solution.png" :::

See [What's new in Azure Local](whats-new.md) for details on the latest enhancements.

## Why Azure Local?

There are many reasons customers choose Azure Local, including:

- It provides industry-leading virtualization performance and value.
- You pay for the software monthly via an Azure subscription instead of when buying the hardware.
- It's familiar to Hyper-V and server admins, allowing them to leverage existing virtualization and storage concepts and skills.
- It can be monitored and managed from the Azure portal or using on-premises tools such as Microsoft System Center, Active Directory, Group Policy, and PowerShell scripting.
- It works with popular third-party backup, security, and monitoring tools.
- Flexible hardware choices allow customers to choose the vendor with the best service and support in their geography.
- Joint support between Microsoft and the hardware vendor improves the customer experience.
- Solution updates make it easy to keep the entire solution up-to-date.

### Common use cases for Azure Local

Customers often choose Azure Local in the following scenarios.

| Use case | Description |
|:-|:-|
| Azure Virtual Desktop (AVD) | Azure Virtual Desktop for Azure Local lets you deploy Azure Virtual Desktop session hosts on your on-premises infrastructure. You manage your session hosts from the Azure portal. To learn more, see [Azure Virtual Desktop for Azure Local](/azure/virtual-desktop/azure-stack-hci-overview). |
| Azure Kubernetes Service (AKS) enabled by Azure Arc | You can leverage Azure Local to host container-based deployments, which increases workload density and resource usage efficiency. Azure Local also further enhances the agility and resiliency inherent to Azure Kubernetes deployments. Azure Local manages automatic failover of VMs serving as Kubernetes cluster nodes in case of a localized failure of the underlying physical components. This supplements the high availability built into Kubernetes, which automatically restarts failed containers on either the same or another VM. To learn more, see [Azure Kubernetes Service on Azure Local and Windows Server](/azure/aks/hybrid/aks-overview). |
| Run Azure Arc services on-premises | Azure Arc allows you to run Azure services anywhere. This allows you to build consistent hybrid and multicloud application architectures by using Azure services that can run in Azure, on-premises, at the edge, or at other cloud providers. Azure Arc enabled services allow you to run Azure Local VMs, Azure data services and Azure application services such as Azure App Service, Functions, Logic Apps, Event Grid, and API Management anywhere to support hybrid workloads. To learn more, see [Azure Arc overview](/azure/azure-arc/overview). |
| Highly performant SQL Server | Azure Local provides an additional layer of resiliency to highly available, mission-critical Always On availability groups-based deployments of SQL Server. This approach also offers extra benefits associated with the single-vendor approach, including simplified support and performance optimizations built into the underlying platform. To learn more, see [Deploy SQL Server on Azure Local](./deploy/sql-server-23h2.md). |
| Trusted enterprise virtualization | Azure Local satisfies the trusted enterprise virtualization requirements through its built-in support for Virtualization-based Security (VBS). VBS relies on Hyper-V to implement the mechanism referred to as virtual secure mode, which forms a dedicated, isolated memory region within its guest VMs. By using programming techniques, it's possible to perform designated, security-sensitive operations in this dedicated memory region while blocking access to it from the host OS. This considerably limits potential vulnerability to kernel-based exploits. To learn more, see [About Trusted Launch for Azure Local VMs enabled by Arc](./manage/trusted-launch-vm-overview.md). |
| Scale-out storage | Storage Spaces Direct is a core technology of Azure Local that uses industry-standard servers with locally attached drives to offer high availability, performance, and scalability. Using Storage Spaces Direct results in significant cost reductions compared with competing offers based on storage area network (SAN) or network-attached storage (NAS) technologies. These benefits result from an innovative design and a wide range of enhancements, such as persistent read/write cache drives, mirror-accelerated parity, nested resiliency, and deduplication. |
| Data center consolidation and modernization | Refreshing and consolidating aging virtualization hosts with Azure Local can improve scalability and make your environment easier to manage and secure. It's also an opportunity to retire legacy SAN storage to reduce footprint and total cost of ownership. Operations and systems administration are simplified with unified tools and interfaces and a single point of support. |
| Branch office and edge | For branch office and edge workloads, you can minimize infrastructure costs by deploying two-node clusters with inexpensive witness options, such as a cloud witness. Another factor that contributes to the lower cost of two-node clusters is support for switchless networking, which relies on crossover cable between cluster nodes instead of more expensive high-speed switches. Customers can also centrally view remote Azure Local deployments in the Azure portal. To learn more, see [Deploy branch office and edge on Azure Local](deploy/branch-office-edge.md). |

<!--#### Demo of Azure Local

For an end-to-end example of using Microsoft Azure to manage apps and infrastructure at the Edge using Azure Arc, Azure Kubernetes Service, and Azure Local, see the **Retail edge transformation with Azure hybrid** demo.

Using a fictional customer, inspired directly by real customers, you will see how to deploy Kubernetes, set up GitOps, deploy VMs, use Azure Monitor and drill into a hardware failure, all without leaving the Azure portal.

> [!VIDEO https://www.youtube.com/embed/t81MNUjAnEQ]

This video includes preview functionality which shows real product functionality, but in a closely controlled environment.-->

### Azure integration benefits

Azure Local allows you to take advantage of cloud and on-premises resources working together and natively monitor, secure, and back up to the cloud.

You can use the Azure portal for an increasing number of tasks including:

- **Monitoring:** View all of your Azure Local systems in a single, global view where you can group them by resource group and tag them.
- **Billing:** Pay for Azure Local through your Azure subscription.

You can also subscribe to additional Azure hybrid services.

For more details on the cloud service components of Azure Local, see [Azure Local hybrid capabilities with Azure services](./hybrid-capabilities-with-azure-services-23h2.md).

## What you need for Azure Local

To get started, you'll need:

- One or more machines from the [Azure Local Catalog](https://aka.ms/AzureStackHCICatalog), purchased from your preferred Microsoft hardware partner.
- An [Azure subscription](https://azure.microsoft.com/).
- Operating system licenses for your workload VMs – for example, Windows Server. See [Activate Windows Server VMs](manage/vm-activate.md).
- An internet connection for each machine in the system that can connect via HTTPS outbound traffic to well-known Azure endpoints at least every 30 days. See [Azure connectivity requirements](./concepts/firewall-requirements.md) for more information.
- For systems stretched across sites (functionality only available in version 22H2):
  - At least four servers (two in each site)
  - At least one 1 Gb connection between sites (a 25 Gb RDMA connection is preferred)
  - An average latency of 5 ms round trip between sites if you want to do synchronous replication where writes occur simultaneously in both sites.
- If you plan to use SDN, you'll need a virtual hard disk (VHD) for the Azure Stack HCI OS to create Network Controller VMs (see [Plan to deploy Network Controller](./concepts/plan-network-controller-deployment.md)).

Make sure your hardware meets the [System requirements](concepts/system-requirements-23h2.md) and that your network meets the [physical network](./concepts/physical-network-requirements.md) and [host network](concepts/host-network-requirements.md) requirements for Azure Local.

For Azure Kubernetes Service on Azure Local and Windows Server requirements, see [AKS network requirements](/azure/aks/hybrid/aks-hci-network-system-requirements).

Azure Local is priced on a per core basis on your on-premises machines. For current pricing, see [Azure Local pricing](https://aka.ms/azloc-pricing).

## Hardware and software partners

Microsoft recommends purchasing Premier Solutions offered in collaboration with our hardware partners to provide the best experience for Azure Local solution. <!--You can also run Azure Local on Validated Nodes, which offer a basic building block for HCI systems to give customers more hardware choices.--> Microsoft partners also offer a single point of contact for implementation and support services.

Browse the [Azure Local Catalog](https://aka.ms/AzureStackHCICatalog) to view Azure Local solutions from Microsoft partners such as ASUS, Blue Chip, DataON, Dell EMC, Fujitsu, HPE, Hitachi, Lenovo, NEC, primeLine Solutions, QCT, and Supermicro.

Some Microsoft partners are developing software that extends the capabilities of Azure Local while allowing IT admins to use familiar tools. To learn more, see [Utility applications for Azure Local](concepts/utility-applications.md).

## Next steps

- Read the blog post: [Introducing Azure Local: cloud infrastructure for distributed locations enabled by Azure Arc](https://techcommunity.microsoft.com/blog/azurearcblog/introducing-azure-local-cloud-infrastructure-for-distributed-locations-enabled-b/4296017).
- Learn more about [Azure Local deployment](./deploy/deployment-introduction.md).
