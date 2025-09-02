---
title: Compare Azure Local to Windows Server
description: This topic helps you determine whether Azure Local or Windows Server is right for your organization.
ms.topic: article
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.date: 04/08/2025
---

# Compare Azure Local to Windows Server

> Applies to: Azure Local 2311.2 and later; Windows Server 2025; Windows Server 2022

This article explains key differences between Azure Local and Windows Server and provides guidance about when to use each. Both products are actively supported and maintained by Microsoft. Many organizations choose to deploy both as they are intended for different and complementary purposes.

When replacing a datacenter primarily running VMware, Azure Local is typically not the optimal solution, as it is better suited for specific distributed scenarios, like retail stores, manufacturing facilities, or branch offices. Azure Local is optimized for distributed sites with fewer than three clusters of 16 nodes, especially when there are latency or regulatory constraints. Instead, we recommend [Azure VMware Solution](/azure/azure-vmware), which is specifically designed for VMware workload modernization and datacenter replacement.

## When to use Azure Local

Azure Local is Microsoft's premier hyperconverged infrastructure platform for running virtual machines (VMs) or virtual desktops on-premises with connections to Azure hybrid services. Azure Local can help to modernize and secure your datacenters and branch offices, and achieve industry-best performance with low latency and data sovereignty.

:::image type="content" source="media/compare-windows-server/hci-scenarios.png" alt-text="When to use Azure Local over Windows Server 2019" border="false" lightbox="media/compare-windows-server/hci-scenarios.png":::

Use Azure Local for:

- The best virtualization host to modernize your infrastructure, either for existing workloads in your core datacenter or emerging requirements for branch office and edge locations.
- Easy extensibility to the cloud, with a regular stream of innovations from your Azure subscription and a consistent set of tools and experiences.
- All the benefits of hyperconverged infrastructure: a simpler, more consolidated datacenter architecture with high-speed storage and networking.

  >[!NOTE]
  > When using Azure Local, run all of your workloads inside virtual machines or containers, not directly on the cluster. Azure Local isn't licensed for clients to connect directly to it using Client Access Licenses (CALs).

For information about licensing Windows Server VMs running on an Azure Local instance, see [Activate Windows Server VMs](/windows-server/get-started/automatic-vm-activation).

## When to use Windows Server

Windows Server is a highly versatile, multi-purpose operating system with dozens of roles and hundreds of features and includes the right for clients to connect directly with appropriate CALs. Windows Server machines can be in the cloud or on-premises, including virtualized on top of Azure Local.

:::image type="content" source="media/compare-windows-server/windows-server-scenarios.png" alt-text="When to use Windows Server over Azure Local" border="false" lightbox="media/compare-windows-server/windows-server-scenarios.png":::

Use Windows Server for:

- A guest operating system inside of VMs or containers
- As the runtime server for a Windows application
- To use one or more of the built-in server roles such as Active Directory, file services, DNS, DHCP, or Internet Information Services (IIS)
- As a traditional server, such as a bare-metal domain controller or SQL Server installation
- For traditional infrastructure, such as VMs connected to Fibre Channel SAN storage

## Compare product positioning

The following table shows the high-level product packaging for Azure Local and Windows Server.

| Attribute    | Azure Local | Windows Server |
| ---------------- | ------------------- | ----------------------- |
| Product type     | Cloud service that includes an operating system and more | Operating system |
| Legal            | Covered under your Microsoft customer agreement or online subscription agreement | Has its own end-user license agreement |
| Licensing        | Billed to your Azure subscription | Has its own paid license |
| Support          | Covered under Azure support | Can be covered by different support agreements, including Microsoft Premier Support |
| Where to get it  | Download from [the Azure portal](../deploy/download-software.md) or comes preinstalled on integrated systems | Microsoft Volume Licensing Service Center or Evaluation Center |
| Runs in VMs      | For evaluation only; intended as a host operating system | Yes, in the cloud or on premises |
| Hardware         | Runs on any of more than 200 pre-validated solutions from the [Azure Local Catalog](https://aka.ms/AzureStackHCICatalog) | Runs on any hardware with the "Certified for Windows Server" logo. See the [WindowsServerCatalog](https://www.windowsservercatalog.com/)|
| Sizing| [Azure Local sizing tool](https://azurestackhcisolutions.azure.microsoft.com/#/sizer) | None |
| Lifecycle policy | Always up to date with the latest features. You have up to six months to install updates. | Use this option of the [Windows Server servicing channels](/windows-server/get-started/servicing-channels-comparison): Long-Term Servicing Channel (LTSC) |

## Compare workloads and benefits

The following table compares the workloads and benefits of Azure Local and Windows Server.

| Attribute | Azure Local | Windows Server |
| ------------- | ------------------- | ----------------------- |
| Azure Kubernetes Service (AKS)| Yes | Yes, but sunset <sup>1</sup> |
| Azure Arc-Enabled PaaS Services | Yes | Yes |
| Windows Server 2022 Azure Edition | Yes | No |
| Windows Server 2025 Azure Edition | Yes | No |
| Windows Server Management Features via Arc (Nov. 2024) | Yes | Yes |
| Windows Server subscription add-on (Dec. 2021)| Yes | No |
| Free Extended Security Updates (ESUs) for Windows Server and SQL 2008/R2 and 2012/R2 | Yes | No <sup>2</sup> |

 <sup>1</sup> [AKS on Windows Server End of Support 27th March 2027])(https://learn.microsoft.com/en-us/azure/aks/aksarc/aks-windows-server-retirement?tabs=ws).<br>
 <sup>2</sup> Requires purchasing an Extended Security Updates (ESU) license key and manually applying it to every VM.
 
## Compare technical features

The following table compares the technical features of Azure Local and Windows Server 2025.

| Attribute | Azure Local 23H2 / 24H2 | Windows Server 2025 | Windows Server 2022
| ------------- | ------------------- | ----------------------- | ----------------------- |
| Hyper-V | Yes | Yes | Yes |
| Storage Spaces Direct | Yes | Yes | Yes |
| Software-Defined Networking | Yes | Yes | Yes |
| Adjustable storage repair speed | Yes | Yes | Yes |
| Secured-core Server| Yes | Yes | Yes |
| Stronger, faster network encryption | Yes | Yes | Yes |
| 4-5x faster Storage Spaces repairs (256kb slab size) | Yes | Yes | Yes |
| Stretch clustering for disaster recovery with Storage Spaces Direct | No <sup>1</sup> | Work in Progress | No |
| High availability for GPU workload | Yes | Yes | No |
| Restart up to 10x faster with kernel-only restarts | Yes <sup>2</sup> | No | No |
| Simplified host networking with Network ATC | Yes | Yes | No |
| Storage Spaces Direct on a single machine | Yes | Yes | No |
| Storage Spaces Direct thin provisioning | Yes | Yes | No |
| Dynamic processor compatibility mode| Yes | Yes | No |
| Cluster-Aware OS feature update | Yes | Yes | No |
| Integrated driver and firmware updates | Yes <sup>2</sup> | No | No

<sup>1</sup> Functionality only available in Azure Local 22H2. These may be upgraded to supported versions with known feature limitations.<br>
<sup>2</sup> With Azure Local Integrated Systems and Premier Systems Hardware only.

For more information, see [What's New in Azure Local](../whats-new.md) and [Using Azure Local on a single machine](single-server-clusters.md).

## Compare management options

The following table compares the management options for Azure Local and Windows Server. Both products are designed for remote management and can be managed with many of the same tools.

| Attribute | Azure Local 24H2 | Azure Local 23H2 | Windows Server 2025 |
| ------------- | ------------------- | ----------------------- | ----------------------- |
| Windows Admin Center | Partly | Partly | Yes |
| Microsoft System Center | Yes <sup>1</sup> | Yes <sup>1</sup> | Yes <sup>1</sup> |
| Third-party tools | Yes | Yes | Yes |
| Azure Backup and Azure Site Recovery support | Yes | Yes | Yes |
| Azure portal | Yes (natively) | Yes (natively) | Requires Azure Arc agent |
| Azure portal > Extensions and Arc-enabled host | Yes | Yes | Manual <sup>1</sup>|
| Azure portal > Windows Admin Center integration (preview) | Yes | Yes | Azure Arc-enabled VMs only <sup>2</sup>|
| Azure portal > Multi-cluster monitoring for Azure Local | Yes | Yes | No |
| Azure portal > Azure Resource Manager integration for clusters | Yes | Yes | No |
| Azure portal > Management of Azure Local VMs enabled by Arc | Yes | Yes | No |
| OS Desktop experience | No | No | Yes |

<sup>1</sup> Microsoft System Center and System Center Virtual Machine Manager (SCVMM) are sold and licensed seperately. Please check which version of SCVMM supports which Azure Local solution version.
<sup>2</sup> Requires manually installing the Arc-git status Connected Machine agent on every machine.

## Compare product pricing

The table below compares the product pricing for Azure Local and Windows Server. For details, see [Azure Local pricing](https://azure.microsoft.com/pricing/details/azure-stack/hci/).

| Attribute | Azure Local | Windows Server |
| ------------- | ------------------- | ----------------------- |
| Price type | Subscription service | Varies: most often a one-time license |
| Price structure | Per core, per month | Varies: usually per core |
| Price | Per core, per month | See [Pricing and licensing for Windows Server 2022](https://www.microsoft.com/windows-server/pricing) |
| Evaluation/trial period | 60-day free trial once registered | 180-day evaluation copy |
| Channels | Enterprise agreement, cloud service provider, Azure Local OEM, or direct | Enterprise agreement/volume licensing, OEM, services provider license agreement (SPLA) |

## Next steps

- [Evaluate Azure Local](../deploy/deployment-virtual.md).
