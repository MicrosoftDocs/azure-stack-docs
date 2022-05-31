---
title: Compare Azure Stack HCI to Windows Server
description: This topic helps you determine whether Azure Stack HCI or Windows Server is right for your organization.
ms.topic: conceptual
author: jasongerend
ms.author: jgerend
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 05/24/2021
---

# Compare Azure Stack HCI to Windows Server

> Applies to: Azure Stack HCI, version 21H2; Windows Server 2022

This article explains the key differences between Azure Stack HCI and Windows Server and provides guidance about when to use each. Both products are actively supported and maintained by Microsoft. Many organizations may choose to deploy both as they are intended for different and complementary purposes.

## When to use Azure Stack HCI

Azure Stack HCI is Microsoft's premier hyperconverged infrastructure platform for running VMs or virtual desktops on-premises with connections to Azure hybrid services. It's an easy way to modernize and secure your datacenters and branch offices and achieve industry-best performance with low latency and data sovereignty.

:::image type="content" source="media/compare-windows-server/hci-scenarios.png" alt-text="When to use Azure Stack HCI over Windows Server 2019" border="false" lightbox="media/compare-windows-server/hci-scenarios.png":::

Use Azure Stack HCI for:

- The best virtualization host to modernize your infrastructure, either for existing workloads in your core datacenter or emerging requirements for branch office and edge locations
- Easy extensibility to the cloud, with a regular stream of innovations from your Azure subscription and a consistent set of tools and experiences
- All the benefits of hyperconverged infrastructure: a simpler, more consolidated datacenter architecture with high-speed storage and networking

  >[!NOTE]
  > When using Azure Stack HCI, run all of your workloads inside virtual machines or containers, not directly on the cluster. Azure Stack HCI isn't licensed for clients to connect directly to it using Client Access Licenses (CALs).

For info on licensing Window Server VMs running on an Azure Stack HCI cluster, see Activate Windows Server VMs.

## When to use Windows Server

Windows Server is a highly versatile, multi-purpose operating system with dozens of roles and hundreds of features, and includes the right for clients to connect directly with appropriate Client Access Licenses (CALs). Windows Server machines can be in the cloud or on-premises, including virtualized on top of Azure Stack HCI.

:::image type="content" source="media/compare-windows-server/windows-server-scenarios.png" alt-text="When to use Windows Server 2019 over Azure Stack HCI" border="false" lightbox="media/compare-windows-server/windows-server-scenarios.png":::

Use Windows Server for:

- A guest operating system inside of virtual machines (VMs) or containers
- As the runtime server for a Windows application
- To use one or more of the built-in server roles such as Active Directory, file services, DNS, DHCP, or Internet Information Services (IIS)
- As a traditional server, such as a bare-metal domain controller or SQL Server installation
- For traditional infrastructure connected to SAN storage

## Compare product positioning

The following table shows the high-level product packaging for Azure Stack HCI and Windows Server.

| Attribute    | Azure Stack HCI | Windows Server |
| ---------------- | ------------------- | ----------------------- |
| Product type     | Cloud service which includes an operating system and more | Operating system |
| Legal            | Covered under your Microsoft Customer Agreement or Online Subscription Agreement | Has its own end-user license agreement |
| Licensing        | Billed to your Azure subscription | Has its own paid license |
| Support          | Covered under Azure support | Can be covered by different support agreements, including Microsoft Premier Support |
| Where to get it  | Download from [Azure.com/HCI](https://azure.com/hci), or comes preinstalled on Integrated Systems | Microsoft Volume Licensing Service Center or Evaluation Center |
| Runs in VMs      | For evaluation only; intended as a host OS | Yes, in the cloud or on premises |
| Hardware         | Runs on any of more than 200 pre-validated solutions from the [Azure Stack HCI Catalog](https://aka.ms/AzureStackHCICatalog) | Runs on any hardware with the "Certified for Windows Server" logo. See the Windows Server catalog at [WindowsServerCatalog](https://www.windowsservercatalog.com/)|
| Sizing| [Azure Stack HCI sizing tool](https://azurestackhcisolutions.azure.microsoft.com/#/sizer) |None.|
| Lifecycle policy | Always up to date with the latest features. You have up to six months to install updates. | Use this option of the [Windows Server servicing channels](/windows-server/get-started/servicing-channels-comparison): Long-Term Servicing Channel (LTSC) |

## Compare workloads and benefits

The following table compares the workloads and benefits of Azure Stack HCI and Windows Server.

| Attribute | Azure Stack HCI | Windows Server |
| ------------- | ------------------- | ----------------------- |
| Azure Kubernetes Service (AKS)| Yes | Yes |
| Azure Arc-Enabled PaaS Services | Yes | Yes |
| Windows Server 2022 Azure Edition | Yes | No|
| Windows Server subscription add-on (Dec. 2021)| Yes | No |
| Free Extended Security Updates (ESUs) for Windows Server and SQL 2008/R2 and 2012/R2. | Yes | No <sup>1</sup>|

<sup>1</sup> This requires purchasing an Extended Security Updates (ESU) license key and manually applying it to every VM.

## Compare technical features

The following table compares the technical features of Azure Stack HCI and Windows Server 2022.

| Attribute | Azure Stack HCI | Windows Server 2022 |
| ------------- | ------------------- | ----------------------- |
| Hyper-V | Yes | Yes |
| Storage Spaces Direct | Yes | Yes |
| Software-Defined Networking | Yes | Yes |
| Adjustable storage repair speed | Yes | Yes|
| Secured-core Server| Yes | Yes |
| Stronger, faster network encryption | Yes | Yes |
| 4-5x faster Storage Spaces repairs | Yes | Yes |
| Stretch clustering for disaster recovery with Storage Spaces Direct | Yes | No |
| High availability for GPU workload | Yes | No |
| Restart up to 10x faster with kernel-only restarts | Yes | No |
| Simplified host networking with Network ATC | Yes | No |
| Single-node clusters with Storage Spaces Direct | Yes | No |
| Storage Spaces Direct thin provisioning | Yes | No |
| Dynamic processor compatibility mode| Yes | No |
| Cluster-Aware OS feature update | Yes | No |
| Integrated driver and firmware updates | Yes (Integrated Systems only) | No |

For more info, see [What's New in Azure Stack HCI, version 21H2](../whats-new.md) and [Using Azure Stack HCI on a single server](single-server-clusters.md).

## Compare management options

The following table compares the management options for Azure Stack HCI and Windows Server. Both products are designed for remote management and can be managed with many of the same tools.

| Attribute | Azure Stack HCI | Windows Server |
| ------------- | ------------------- | ----------------------- |
| Desktop experience | No | Yes |
| Windows Admin Center | Yes | Yes |
| Microsoft System Center | Yes (sold separately) | Yes (sold separately) |
| Third-party tools | Yes | Yes |
| Azure portal | Yes (natively) | Requires Azure Arc agent |
| Azure Backup and Azure Site Recovery support | Yes | Yes |
| Cluster integrates with Azure Resource Manager | Yes | No |
| Extensions and Azure Arc-enabled host servers | Yes | Manual <sup>1</sup> |
| Multi-cluster monitoring for Azure Stack HCI (preview) | Yes | No |
| Windows Admin Center for Azure Stack HCI (preview)| Yes |Manual <sup>1</sup> |
| Azure Arc-enabled VM management (preview)| Yes | No |

<sup>1</sup> This requires purchasing an Extended Security Updates (ESU) license key and manually applying it to every VM.


## Compare product pricing

The table below compares the product pricing for Azure Stack HCI and Windows Server. For details, see [Azure Stack HCI pricing](https://azure.microsoft.com/pricing/details/azure-stack/hci/).

| Attribute | Azure Stack HCI | Windows Server |
| ------------- | ------------------- | ----------------------- |
| Price type | Subscription service | Varies: most often a one-time license |
| Price structure | Per core, per month | Varies: usually per core |
| Price | $10 USD per core, per month | See [Pricing and licensing for Windows Server 2022](https://www.microsoft.com/windows-server/pricing) |
| Evaluation/trial period | 60-day free trial once registered | 180-day evaluation copy |
| Channels | Enterprise agreement, cloud service provider, or direct | Enterprise agreement/volume licensing, OEM, services provider license agreement (SPLA) |

## Next steps

- [Compare Azure Stack HCI to Azure Stack Hub](compare-azure-stack-hub.md)
