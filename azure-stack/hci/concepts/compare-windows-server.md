---
title: Compare Azure Stack HCI to Windows Server
description: This topic helps you determine whether Azure Stack HCI or Windows Server is right for your organization.
ms.topic: conceptual
author: khdownie
ms.author: v-kedow
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 1/21/2021
---

# Compare Azure Stack HCI to Windows Server 2019

> Applies to: Azure Stack HCI, version 20H2; Windows Server 2019

This topic explains the key differences between Azure Stack HCI and Windows Server 2019, and provides guidance about when to use each. Both products are actively supported and maintained by Microsoft. Many organizations may choose to deploy both, as they are intended for different and complementary purposes.

## When to use Azure Stack HCI

Azure Stack HCI is Microsoft's premier hyperconverged infrastructure platform for running VMs or virtual desktops on-premises with connections to Azure hybrid services. It's an easy way to modernize and secure your datacenters and branch offices, and achieve industry-best performance with low latency and data sovereignty.

<center>

:::image type="content" source="media/compare-windows-server/hci-scenarios.png" alt-text="When to use Azure Stack HCI over Windows Server 2019" border="false" lightbox="media/compare-windows-server/hci-scenarios.png":::

</center>

Use Azure Stack HCI for:

- The best virtualization host to modernize your infrastructure, either for existing workloads in your core datacenter or emerging requirements for branch office and edge locations
- Easy extensibility to the cloud, with a regular stream of innovations from your Azure subscription and a consistent set of tools and experiences
- All the benefits of hyperconverged infrastructure: a simpler, more consolidated datacenter architecture with high-speed storage and networking

  >[!NOTE]
  >Because Azure Stack HCI is intended to be used as a Hyper-V virtualization host for a modern, hyperconverged architecture, it does not include guest rights. Because of this, Azure Stack HCI is only licensed to run a small number of server roles directly; any other roles must run inside of VMs.

## When to use Windows Server 2019

Windows Server 2019 is a highly versatile, multi-purpose operating system, with dozens of roles and hundreds of features, including guest rights. Windows Server machines can be in the cloud or on-premises, including virtualized on top of Azure Stack HCI.

<center>

:::image type="content" source="media/compare-windows-server/windows-server-scenarios.png" alt-text="When to use Windows Server 2019 over Azure Stack HCI" border="false" lightbox="media/compare-windows-server/windows-server-scenarios.png":::

</center>

Use Windows Server 2019 for:

- A guest operating system inside of virtual machines (VMs) or containers
- As the runtime for a Windows application
- To use one or more of the built-in server roles such as Active Directory, file services, DNS, DHCP, or Internet Information Services (IIS)
- As a traditional server, such as a bare-metal domain controller or SQL Server installation
- For traditional infrastructure such as VMs connected to Fibre Channel SAN storage

## Compare product positioning

The following table shows the high-level product packaging for Azure Stack HCI and Windows Server 2019.

| **Attribute**    | **Azure Stack HCI** | **Windows Server 2019** |
| ---------------- | ------------------- | ----------------------- |
| Product type     | Cloud service which includes an operating system and more | Operating system |
| Legal            | Covered under your Microsoft Customer Agreement or Online Subscription Agreement | Has its own end-user license agreement |
| Licensing        | Billed to your Azure subscription | Has its own paid license |
| Support          | Covered under Azure support | Can be covered by different support agreements, including Microsoft Premier Support |
| Where to get it  | Download from [Azure.com/HCI](https://azure.com/hci), or comes preinstalled on Integrated Systems | Microsoft Volume Licensing Service Center or Evaluation Center |
| Runs in VMs      | For evaluation only; intended as a host OS | Yes, in the cloud or on premises |
| Hardware         | Runs on any of more than 200 pre-validated solutions from the [Azure Stack HCI Catalog](https://hcicatalog.azurewebsites.net) | Runs on any hardware with the "Certified for Windows Server 2019" logo |
| Lifecycle policy | Always up to date with the latest features | Choose between [Windows Server servicing channels](/windows-server/get-started-19/servicing-channels-19): Long-Term Servicing Channel (LTSC) and Semi-Annual Channel (SAC) |

## Compare technical features

The following table compares the technical features of Azure Stack HCI and Windows Server 2019.

| **Attribute** | **Azure Stack HCI** | **Windows Server 2019** |
| ------------- | ------------------- | ----------------------- |
| Core Hyper-V | Yes | Yes |
| Core Storage Spaces Direct | Yes | Yes |
| Core SDN | Yes | Yes |
| Stretch clustering for disaster recovery | Yes | - |
| 4-5x faster Storage Spaces repairs | Yes | - |
| Integrated driver and firmware updates | Yes (Integrated Systems only) | - |
| Guided deployment | Yes | - |

## Compare management options

The following table compares the management options for Azure Stack HCI and Windows Server 2019. Both products are designed for remote management and can be managed with many of the same tools.

| **Attribute** | **Azure Stack HCI** | **Windows Server 2019** |
| ------------- | ------------------- | ----------------------- |
| Desktop experience | - | Yes |
| Windows Admin Center | Yes | Yes |
| Microsoft System Center | Yes (sold separately) | Yes (sold separately) |
| Azure portal | Yes (natively) | Requires Arc agent |
| Third-party tools | Yes | Yes |

## Compare product pricing

The table below compares the product pricing for Azure Stack HCI and Windows Server 2019. For details, see [Azure Stack HCI pricing](https://azure.microsoft.com/pricing/details/azure-stack/hci/).

| **Attribute** | **Azure Stack HCI** | **Windows Server 2019** |
| ------------- | ------------------- | ----------------------- |
| Price type | Subscription service | Varies: most often a one-time license |
| Price structure | Per core, per month | Varies: usually per core |
| Price | $10 USD per core, per month | See [Pricing and licensing for Windows Server 2019](/windows-server/pricing) |
| Evaluation/trial period | 30-day free trial once registered | 180-day evaluation copy |
| Channels | Enterprise agreement, cloud service provider, or direct | Enterprise agreement/volume licensing, OEM, services provider license agreement (SPLA) |

## Next steps

- [Compare Azure Stack HCI to Azure Stack Hub](compare-azure-stack-hub.md)
