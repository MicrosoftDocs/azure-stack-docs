---
title: Azure Stack HCI overview
description: Azure Stack HCI is a hyper-converged Windows Server 2019 cluster that uses validated hardware to run virtualized workloads on-premises. You can also optionally connect to Azure services for cloud-based backup, site-recovery, and more. Azure Stack HCI solutions use Microsoft-validated hardware to ensure optimal performance and reliability, and include support for technologies such as NVMe drives, persistent memory, and remote-direct memory access (RDMA) networking.
ms.topic: article
author: jasongerend
ms.author: jgerend
ms.localizationpriority: medium
ms.date: 11/04/

# Intent: Notdone: As a < type of user >, I want < what? > so that < why? >
# Keyword: Notdone: keyword noun phrase

---

# Azure Stack HCI overview

Azure Stack HCI is a hyperconverged Windows Server 2019 cluster that uses validated hardware to run virtualized workloads on-premises. You can also optionally connect to Azure services for cloud-based backup, site-recovery, and more. Azure Stack HCI solutions use Microsoft-validated hardware to ensure optimal performance and reliability, and include support for technologies such as NVMe drives, persistent memory, and remote-direct memory access (RDMA) networking.

Azure Stack HCI is a solution that combines several products:

- Hardware from an OEM partner

- Windows Server 2019 Datacenter edition

- Windows Admin Center

- Azure services (optional)

![Azure Stack HCI is Microsoft’s hyperconverged solution available from a wide range of hardware partners.](media/overview/azure-stack-hci-solution.png)

Azure Stack HCI is Microsoft’s hyperconverged solution available from a wide range of hardware partners. Consider the following scenarios for a hyperconverged solution to help you determine if Azure Stack HCI is the solution that best suits your needs:

- **Refresh aging hardware.** Replace older servers and storage infrastructure and run Windows and Linux virtual machines on-premises and at the edge with existing IT skills and tools.

- **Consolidate virtualized workloads.** Consolidate legacy apps on an efficient, hyperconverged infrastructure. Tap into the same types of cloud efficiencies used to run hyper-scale datacenters such as Microsoft Azure.

- **Connect to Azure for hybrid cloud services.** Streamline access to cloud management and security services in Azure, including offsite backup, site recovery, cloud-based monitoring, and more.

## The Azure Stack family

Azure Stack HCI is part of the Azure and Azure Stack family, using the same software-defined compute, storage, and networking software as Azure Stack Hub. Here's a quick summary of the different solutions (for more details, see [Comparing the Azure Stack ecosystem](../operator/compare-azure-azure-stack.md)):

- [Azure](https://azure.microsoft.com) - Use public cloud services for on-demand, self-service computing resources to migrate and modernize existing apps and build new cloud-native apps.
- [Azure Stack Edge](https://docs.microsoft.com/azure/databox-online/data-box-edge-overview) - Accelerate machine learning workloads and run containerized apps or virtualized workloads on-premises, on a cloud-managed appliance.
- [Azure Stack HCI](https://azure.microsoft.com/overview/azure-stack/hci) - Run virtualized apps on-premises, replace and consolidate aging server infrastructure, and connect to Azure for cloud services.
- [Azure Stack Hub](../operator/azure-stack-overview.md) - Run cloud apps on-premises, when disconnected, or to meet regulatory requirements, using consistent Azure services.

![Azure Stack Edge is a cloud-managed appliance for running machine-learning and containerized apps at the edge, Azure Stack HCI is a hyperconverged solution for running VMs and storage on-premises, while Azure Stack Hub provides cloud-native, Azure-consistent services on-premises.](media/overview/azure-family.png)

To learn more:

- Learn more at our [Azure Stack HCI](https://azure.microsoft.com/overview/azure-stack/hci) solutions website.
- Watch Microsoft experts Jeff Woolsey and Vijay Tewari [discuss the new Azure Stack HCI solutions](https://aka.ms/AzureStackOverviewVideo).

## Hyperconverged efficiencies

Azure Stack HCI solutions bring together highly virtualized compute, storage, and networking on industry-standard x86 servers and components. Combining resources in the same cluster makes it easier for you to deploy, manage, and scale. Manage with your choice of command-line automation or Windows Admin Center.

Achieve industry-leading virtual machine performance for your server applications with Hyper-V, the foundational hypervisor technology of the Microsoft cloud, and Storage Spaces Direct technology with built-in support for NVMe, persistent memory, and remote-direct memory access (RDMA) networking.

Help keep apps and data secure with shielded virtual machines, network microsegmentation, and native encryption.

## Hybrid capabilities

You can take advantage of cloud and on-premises working together with a hyperconverged infrastructure platform in public cloud. Your team can start building cloud skills with built-in integration to Azure infrastructure management services:

- Azure Site Recovery for high availability and disaster recovery as a service (DRaaS).

- Azure Monitor, a centralized hub to track what’s happening across your applications, network, and infrastructure – with advanced analytics powered by AI.

- Cloud Witness, to use Azure as the lightweight tie breaker for cluster quorum.

- Azure Backup for offsite data protection and to protect against ransomware.

- Azure Update Management for update assessment and update deployments for Windows VMs running in Azure and on-premises.

- Azure Network Adapter to connect resources on-premises with your VMs in Azure via a point-to-site VPN.

- Sync your file server with the cloud, using Azure File Sync.

For details, see [Connecting Windows Server to Azure hybrid services](https://docs.microsoft.com/windows-server/manage/windows-admin-center/azure/index).

## Management tools and System Center

Azure Stack HCI uses the same virtualization and software-defined storage and networking software as Azure Stack Hub. However, with Azure Stack HCI you have full admin rights on the cluster and can manage any of its technologies directly:

- [Hyper-V](https://docs.microsoft.com/windows-server/virtualization/hyper-v/hyper-v-on-windows-server)
- [Storage Spaces Direct](https://docs.microsoft.com/windows-server/storage/storage-spaces/storage-spaces-direct-overview)
- [Software Defined Networking](https://docs.microsoft.com/windows-server/networking/sdn/)
- [Failover Clustering](https://docs.microsoft.com/windows-server/failover-clustering/failover-clustering-overview)

To manage these technologies, you can use the following management tools:

- [Windows Admin Center](https://docs.microsoft.com/windows-server/manage/windows-admin-center/overview)
- [System Center](https://www.microsoft.com/cloud-platform/system-center)
- [PowerShell](https://docs.microsoft.com/powershell/?view=powershell-6)
- Other management tools such as [Server Manager](https://docs.microsoft.com/windows-server/administration/server-manager/server-manager), and MMC snap-ins
- Non-Microsoft tools such as 5Nine Manager

If you choose to use System Center to deploy and manage your infrastructure, you'll use System Center Virtual Machine Management (VMM) and System Center Operations Manager. With VMM, you provision and manage the resources needed to create and deploy virtual machines and services to private clouds. With Operations Manager, you monitor services, devices, and operations across your enterprise to identify problems for immediate action.

## Hardware partners

You can purchase validated Azure Stack HCI solutions that run Windows Server 2019 from 20 partners. Your preferred Microsoft partner gets you up and running without lengthy design and build time. They also offer a single point of contact for implementation and support services.

Visit the [Azure Stack HCI website](https://azure.microsoft.com/overview/azure-stack/hci) to view our 70+ Azure Stack HCI solutions currently available from these Microsoft partners: ASUS, Axellio, bluechip, DataON, Dell EMC, Fujitsu, HPE, Hitachi, Huawei, Lenovo, NEC, primeLine Solutions, QCT, SecureGUARD, and Supermicro.

## Video-based learning

Here are some videos from Microsoft Ignite 2019 sessions:

- [Microsoft Ignite Live 2019 - Getting Started with Azure Stack HCI](https://www.youtube.com/watch?v=vueHIBqNIEU)
- [Discover Azure Stack HCI](https://www.youtube.com/watch?v=4aGZK0Ndmh8&list=PLQXpv_NQsPICdXZoH-EzlIFa4P6VS5m11&index=13&t=0s)
- [Modernize your retail stores or branch offices with Azure Stack HCI](https://www.youtube.com/watch?v=-JzLhjfkhmM&list=PLQXpv_NQsPICdXZoH-EzlIFa4P6VS5m11&index=9&t=0s)
- [What's new for Azure Stack HCI: 45 things in 45 minutes](https://www.youtube.com/watch?v=C5J4IEnlS_E&list=PLQXpv_NQsPICdXZoH-EzlIFa4P6VS5m11&index=12&t=0s)
- [Jumpstart your Azure Stack HCI deployment](https://www.youtube.com/watch?v=gxaPJLrWy5w&list=PLQXpv_NQsPICdXZoH-EzlIFa4P6VS5m11&index=11&t=0s)
- [The case of the shrinking data: Data Deduplication in Azure Stack HCI](https://www.youtube.com/watch?v=fmm4iDbDiY4&list=PLQXpv_NQsPICdXZoH-EzlIFa4P6VS5m11&index=23&t=0s)
- [Dave Kawula's notes from the field on Azure Stack HCI](https://www.youtube.com/watch?v=OXv7fLlz0ew&list=PLQXpv_NQsPICdXZoH-EzlIFa4P6VS5m11&index=2&t=0s)

Here is a video from a Hybrid Cloud Virtual Event:

- [Azure Stack HCI | Hybrid Cloud Virtual Event](https://www.youtube.com/watch?v=nxpoEva-R2Y)

## FAQ

### What do Azure Stack Hub and Azure Stack HCI solutions have in common?

Azure Stack HCI solutions feature the same Hyper-V based software-defined compute, storage, and networking technologies as Azure Stack Hub. Both offerings meet rigorous testing and validation criteria to ensure reliability and compatibility with the underlying hardware platform.

### How are they different?

With Azure Stack Hub, you run cloud services on-premises. You can run Azure IaaS and PaaS services on-premises to consistently build and run cloud applications anywhere, managed with the Azure portal on-premises.

With Azure Stack HCI, you run virtualized workloads on-premises, managed with Windows Admin Center and familiar Windows Server tools. You can optionally connect to Azure for hybrid scenarios such as cloud-based site recovery, monitoring, and others.

### Why is Microsoft bringing its HCI offering to the Azure Stack family?

Microsoft’s hyperconverged technology is already the foundation of Azure Stack Hub.

Many Microsoft customers have complex IT environments and our goal is to provide solutions that meet them where they are with the right technology for the right business need. Azure Stack HCI is an evolution of the Windows Server 2016-based Windows Server Software-Defined (WSSD) solutions previously available from our hardware partners. We brought it into the Azure Stack family because we have started to offer new options to connect seamlessly with Azure for infrastructure management services.

### Does Azure Stack HCI need to be connected to Azure?

No, it’s optional. You can take advantage of integration with Azure for hybrid scenarios such as off-site backup and disaster recovery, and cloud-based monitoring and update management, but they're optional. It's no problem to run disconnected from the Internet.

### How does Azure Stack HCI relate to Windows Server?

Windows Server 2019 is the foundation of nearly every Azure product. All the features you value continue to ship and be supported in Windows Server. Azure Stack HCI is the recommended way to deploy HCI on-premises, using Microsoft-validated hardware from our partners.

### Can I upgrade from Azure Stack HCI to Azure Stack Hub? 

No, but customers can migrate their workloads from Azure Stack HCI to Azure Stack Hub or Azure.

### What Azure services can I connect to Azure Stack HCI?

For an updated list of Azure services that you can connect Azure Stack HCI to, see [Connecting Windows Server to Azure hybrid services](https://docs.microsoft.com/windows-server/manage/windows-admin-center/azure/index).

### How does the cost of Azure Stack HCI compare to Azure Stack Hub? 

Azure Stack Hub is sold as a fully integrated system that includes services and support. You can purchase Azure Stack Hub as a system you manage, or as a fully managed service from our partners. In addition to the base system, the Azure services that run on Azure Stack Hub or Azure are sold on a pay-as-you-use basis.

Azure Stack HCI solutions follow the traditional purchasing model. You can purchase validated hardware from Azure Stack HCI partners and software (Windows Server 2019 Datacenter edition with software-defined datacenter capabilities and Windows Admin Center) from various existing channels. For Azure services that you can use with Windows Admin Center, you pay with an Azure subscription.

### How do I buy Azure Stack HCI solutions?

Follow these steps:

1. Buy a Microsoft-validated hardware system from your preferred hardware partner.
1. Install Windows Server 2019 Datacenter edition and Windows Admin Center for management and the ability to connect to Azure for cloud services
1. Optionally use your Azure account to attach cloud-based management and security services to your workloads.

![To buy Azure Stack HCI solutions, choose the hardware partner and configuration that best fits your needs.](media/overview/buying-azure-stack-hci.png)

## Compare Azure Stack Hub and Azure Stack HCI

As your organization digitally transforms, you may find that you can move faster by using public cloud services to build on modern architectures and refresh legacy apps. However, for reasons that include technological and regulatory obstacles, many workloads must remain on-premises. The following table helps you determine which Microsoft hybrid cloud strategy provides what you need where you need it, delivering cloud innovation for workloads wherever they are.

| Azure Stack Hub | Azure Stack HCI |
| --------------- | --------------- |
| New skills, innovative processes | Same skills, familiar processes |
| Azure services in your datacenter | Connect your datacenter to Azure services |

### When to use Azure Stack Hub

| Azure Stack Hub | Azure Stack HCI |
| --------------- | --------------- |
| Use Azure Stack Hub for self-service Infrastructure-as-a-Service (IaaS), with strong isolation and precise usage tracking and chargeback for multiple colocated tenants. Ideal for service providers and enterprise private clouds. Templates from the Azure Marketplace. | Azure Stack HCI doesn't natively enforce or provide for multi-tenancy. |
| Use Azure Stack Hub to develop and run apps that rely on Platform-as-a-Service (PaaS) services like Web Apps, Functions, or Event Hubs on-premises. These services run on Azure Stack Hub exactly like they do in Azure, providing a consistent hybrid development and runtime environment. | Azure Stack HCI doesn't run PaaS services on-premises. |
| Use Azure Stack Hub to modernize app deployment and operation with DevOps practices like infrastructure as code, continuous integration and continuous deployment (CI/CD), and convenient features like Azure-consistent VM Extensions. Ideal for Dev and DevOps teams. | Azure Stack HCI doesn't natively include any DevOps tooling. |

### When to use Azure Stack HCI

| Azure Stack Hub | Azure Stack HCI |
| --------------- | --------------- |
| Azure Stack Hub requires minimum 4 nodes and its own network switches. | Use Azure Stack HCI for the minimum footprint for remote offices and branches. Start with just 2 server nodes and switchless back-to-back networking for peak simplicity and affordability. Hardware offers start at 4 drives, 64 GB of memory, well under $10k / node. |
| Azure Stack Hub constrains Hyper V configurability and feature set for consistency with Azure. | Use Azure Stack HCI for no-frills Hyper-V virtualization for classic enterprise apps like Exchange, SharePoint, and SQL Server, and to virtualize Windows Server roles like File Server, DNS, DHCP, IIS, and AD. Unrestricted access to all Hyper-V features like Shielded VMs.|
| Azure Stack Hub doesn't expose these infrastructural technologies. | Use Azure Stack HCI to use software-defined infrastructure in place of aging storage arrays or network appliances, without major rearchitecture. Built-in Hyper-V, Storage Spaces Direct, and Software-Defined Networking (SDN) are directly accessible and manageable. |
