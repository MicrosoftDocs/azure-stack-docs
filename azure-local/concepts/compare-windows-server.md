---
title: Compare Azure Local to Windows Server - Key Differences and Benefits
description: Learn the key differences between Azure Local and Windows Server to choose the best solution for your organization. Compare features, benefits, and scenarios.
ms.topic: product-comparison
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.date: 09/03/2025
---

# Compare Azure Local to Windows Server

> Applies to: Azure Local 2311.2 and later; Windows Server 2025

This article compares Azure Local and Windows Server, and highlights key differences between the two products. It helps you learn when to use each product, and how they can work together.

Azure Local and Windows Server share many similarities, such as letting you run virtual machines and container-based workloads. But they're designed for different scenarios and use cases. Azure Local is a cloud-connected hyperconverged solution that gives you a consistent experience across on-premises and cloud environments. Windows Server is a versatile operating system you can use as a host for virtual machines, as a traditional server, or as a guest operating system inside a virtual machine.

Note that if you want to migrate VMware virtual machines (VMs), we currently provide several options:

- [Use Azure VMware Solution to migrate to Azure](/azure/azure-vmware)
- [Use Azure Migrate to migrate VMware VMs to Azure Local](../migrate/migrate-vmware-migrate.md)
- [Use System Center Virtual Machine Manager (VMM) to convert a VMware VM to a Windows Server VM](/system-center/vmm/vm-convert-vmware)

## When to use Azure Local

Azure Local is Microsoft's premier hyperconverged infrastructure platform for running virtual machines (VMs) or virtual desktops on-premises with connections to Azure hybrid services. Azure Local can help to modernize and secure your datacenters and branch offices, and achieve industry-best performance with low latency and data sovereignty.

:::image type="content" source="media/compare-windows-server/hci-scenarios.png" alt-text="Diagram showing when to use Azure Local over Windows Server" border="false" lightbox="media/compare-windows-server/hci-scenarios.png":::

Use Azure Local for:

- The best virtualization host to modernize your infrastructure, either for existing workloads in your core datacenter or emerging requirements for branch office and edge locations.
- Easy extensibility to the cloud, with a regular stream of innovations from your Azure subscription and a consistent set of tools and experiences.
- All the benefits of hyperconverged infrastructure: a simpler, more consolidated datacenter architecture with high-speed storage and networking.

>[!NOTE]
> When using Azure Local, run all of your workloads inside virtual machines or containers, not directly on the cluster. Azure Local isn't licensed for clients to connect directly to it using Client Access Licenses (CALs).

For information about licensing Windows Server VMs running on an Azure Local instance, see [Activate Windows Server VMs](/windows-server/get-started/automatic-vm-activation).

## When to use Windows Server

Windows Server is a versatile, multi-purpose operating system with numerous roles and features. It lets clients connect directly with appropriate Client Access Licenses (CALs). You can run Windows Server machines in the cloud or on-premises, including virtualized on Azure Local.

:::image type="content" source="media/compare-windows-server/windows-server-scenarios.png" alt-text="Diagram showing when to use Windows Server instead of Azure Local" border="false" lightbox="media/compare-windows-server/windows-server-scenarios.png":::

Use Windows Server for:

- Running as a guest operating system inside of VMs or containers
- Hosting Hyper-V VMs
- Flexible storage architectures such as SANs or hyperconverged infrastructure with Storage Spaces Direct
- Acting as a traditional server, such as a bare-metal SQL Server installation
- Supporting extensive hardware compatibility, including broad support for SANs, legacy hardware, and drivers

## Compare product positioning

The following table shows the high-level product positioning for Azure Local and Windows Server.

| Attribute    | Azure Local | Windows Server |
| ---------------- | ------------------- | ----------------------- |
| Cloud connection | Required <br>(at least once every 30 days) | Optional<br>(Required to use Azure Arc or Windows Server Pay-as-You-Go) |
| Host licensing options        | - Pay as you go<br> - [Azure Hybrid Benefit](https://azure.microsoft.com/pricing/hybrid-benefit) | - [Traditional licenses](https://www.microsoft.com/windows-server/pricing) <br> - [Windows Server Pay-as-You-Go](/windows-server/get-started/windows-server-pay-as-you-go) |
| Windows Server VM guest licensing<sup>1</sup>       | - Windows Server Subscription<br> - Azure Hybrid Benefit<br>- Bring your own license  | - Standard Edition: 2 VMs included<br>- Datacenter Edition: Unlimited VMs |
| Runs in VMs      | For evaluation only; intended as a host operating system | Yes, in the cloud or on-premises |
| Hardware         | Runs on any of more than 200 pre-validated solutions from the [Azure Local Catalog](https://aka.ms/AzureStackHCICatalog) | Runs on any hardware with the "Certified for Windows Server" logo. See the [WindowsServerCatalog](https://www.windowsservercatalog.com/)|
| Support          | Covered under Azure support | Can be covered by different support agreements, including Microsoft Premier Support |
| Lifecycle policy | Always up to date with the latest features. You have up to six months to install updates. | - Long-Term Servicing Channel (LTSC): 5 years of mainstream support and 5 years of extended support<br>- [Annual Channel](/windows-server/get-started/servicing-channels-comparison): 18 months of mainstream support and 6 months of extended support |
| Where to get it  | Download from [the Azure portal](../deploy/download-software.md) or comes preinstalled on integrated systems | Microsoft Volume Licensing Service Center or Evaluation Center |
| Sizing tool| [Azure Local sizing tool](https://azurestackhcisolutions.azure.microsoft.com/#/sizer) | None |

<sup>1</sup>Client Access Licenses (CALs) are required for each user or device that accesses a server. CALs are purchased separately from the server license, unless included with specific licenses, such as [Azure Local OEM License](../license-billing.yml#do-i-need-device-or-user-client-access-licenses--cals--with-this-license). [Windows Server Pay-as-You-Go](/windows-server/get-started/windows-server-pay-as-you-go) also includes CALs for standard functionality, but not Remote Desktop Services (RDS) CALs.

## Compare workloads and benefits

The following table compares the workloads and benefits of Azure Local and Windows Server.

| Attribute | Azure Local | Windows Server |
| ------------- | ------------------- | ----------------------- |
| Directly hosted server roles and apps | No | Yes |
| Hyper-V virtual machines | Yes | Yes |
| Azure Kubernetes Service (AKS)| Built-in | Installable |
| Azure Arc-Enabled PaaS Services | Yes | Yes |
| Windows Server Datacenter: Azure Edition | Yes | No|
| Windows Server subscription add-on (Dec. 2021)| Yes | No |
| Extended Security Updates (ESUs) for Windows Server | Included | Purchased separately and applied via Azure Arc or  Multiple Activation Keys (MAKs) manually applied to every server |
| VMware migration method | [Azure Migrate](../migrate/migrate-vmware-migrate.md) | [System Center VMM](/system-center/vmm/vm-convert-vmware) |

## Compare technical features

The following table compares select technical features of Azure Local and Windows Server.

| Attribute | Azure Local | Windows Server 2025 |
| ------------- | ------------------- | ----------------------- |
| Integrated driver and firmware updates | Yes (Integrated Systems and Premier solutions) | No |
| Restart up to 10x faster with kernel-only restarts | Yes | No |
| Host hotpatching | In preview | Yes (via Azure Arc) |
| Hyper-V dynamic processor compatibility mode<sup>1</sup>| Yes | Yes |
| Hyper-V high availability for GPU workloads w/GPU partitioning | Yes | Yes |
| Storage Spaces Direct | Yes | Yes |
| Storage Spaces Direct thin provisioning | Yes | Yes |
| Resilient file system (ReFS) deduplication | Yes | Yes |
| Stretch clustering for disaster recovery with Storage Spaces Direct | Yes<sup>2</sup> | Yes |
| Software-Defined Networking | Yes | Yes |
| Secured-core Server| Yes | Yes |
| Simplified host networking with Network ATC | Yes | Yes |
| Cluster-Aware OS feature updates | Yes | Yes |

<sup>1</sup> [Dynamic processor compatibility mode](/windows-server/virtualization/hyper-v/manage/dynamic-processor-compatibility-mode) ensures compatibility for online (live) migrations between hosts with different processor generations.

<sup>2</sup> Stretched clusters that use Storage Replication are available only in Azure Local, version 22H2. For info on newer versions, see [Evolving Stretch Clustering for Azure Local](https://techcommunity.microsoft.com/blog/azurearcblog/evolving-stretch-clustering-for-azure-local/4352751).

For more information, see [What's New in Azure Local](../whats-new.md) and [Using Azure Local on a single machine](single-server-clusters.md).

## Compare management options

The following table compares the management options for Azure Local and Windows Server. Both products are designed for remote management and can be managed with many of the same tools.

| Attribute | Azure Local | Windows Server |
| ------------- | ------------------- | ----------------------- |
| Preferred host management tool | Azure portal | Windows Admin Center |
| Preferred VM management tool | Azure portal via Azure Arc | Azure portal via Azure Arc |
| On-premises management tools | - Windows Admin Center<br> - PowerShell | - Windows Admin Center<br> - PowerShell<br>- Server Manager |
| Microsoft System Center | Yes (sold separately) | Yes (sold separately) |
| Third-party tools | Yes | Yes |
| Azure Backup and Azure Site Recovery support | Yes | Yes |
| Azure portal | Yes (natively) | Requires Azure Arc agent |
| Azure portal > Extensions and Arc-enabled host | Yes | Manual <sup>1</sup>|
| Azure portal > Windows Admin Center integration (preview) | Yes | Azure VMs only <sup>1</sup>|
| Azure portal > Multi-cluster monitoring for Azure Local | Yes | No |
| Azure portal > Azure Resource Manager integration for clusters | Yes | No |
| Azure portal > Management of Azure Local VMs enabled by Arc | Yes | No |
| Desktop experience | No | Yes |

<sup>1</sup> Requires manually installing the [Azure Connected Machine agent](/azure/azure-arc/servers/agent-overview) on every machine.

## Compare Arc management options

The following table compares select Arc management options of Azure Local and Windows Server.

| Attribute | Azure Local | Windows Server 2025 |
| ------------- | ------------------- | ----------------------- |
| Basic VM management<br>(Start, restart, stop, save, pause, delete, shutdown, and manage snapshots)| Yes<sup>1</sup><br>(Shutdown and manage snapshots not supported) | Yes |
| Connect via SSH | Yes | Yes |
| Connect via RDP | Yes | Yes |
| Configure operations<br>(Add/delete/expand data disks and change memory/vCPU)<sup>2</sup> | Yes | Yes |
| Azure operations<br>(Microsoft Defender for Cloud, security recommendations, Azure extension support, WAC extension support, resource locks, policies, Automanage, and run command) | Yes | Yes<br>(Automanage not supported) |
| Azure Update Manager | Yes<br>(included) | Yes<br>(free via Azure Hybrid Benefit)  |
| Monitoring<br>(Azure Monitor, Insights, logs, alerts, and workbooks) | Yes | Yes<br>(Alerts not supported)  |
| Automation<br>(Azure CLI, PowerShell, Azure tasks, and resource health) | Yes<sup>2</sup> | Yes  |

<sup>1</sup> Shutdown and manage snapshots aren't supported. For more information, see [Supported VM operations for Azure Local](../manage/virtual-machine-operations.md).

<sup>2</sup> Export ARM template isn't supported.

## Next steps

- [Evaluate Azure Local](../deploy/deployment-virtual.md)
- [Get started with Windows Server](/windows-server/get-started/get-started-with-windows-server)