---
title: Compare Azure Stack HCI to Azure Stack Hub and Windows Server
description: This topic helps you determine whether Azure Stack HCI, Azure Stack Hub, or Windows Server is right for your organization.
ms.topic: conceptual
author: khdownie
ms.author: v-kedow
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 12/22/2020
---

# Compare Azure Stack HCI to Azure Stack Hub and Windows Server

> Applies to: Azure Stack HCI, version 20H2; Windows Server 2019; Azure Stack Hub

Many customers will wonder whether Windows Server, Azure Stack HCI, or Azure Stack Hub is a better fit for their needs. This topic helps you determine which is right for your organization. 

## Compare Azure Stack HCI to Windows Server

Both Windows Server and Azure Stack HCI provide the same high-quality user experience with a road map of new releases.

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
| Windows Server can run on-premises or in the cloud, but will not offer the latest hyperconverged features moving forward.| Azure Stack HCI is Microsoft's premier hyperconverged infrastructure platform for running VMs on-premises, optionally stretched across two sites and with connections to Azure hybrid services. It's an easy way to modernize and secure your data centers and branch offices, achieve industry-best performance for SQL Server databases, and run VMs or virtual desktops on-premises for low latency and data sovereignty|
| Windows Server is a great multi-purpose "Swiss Army knife" for all Windows Server roles, virtualized or not. | Use Azure Stack HCI to virtualize classic enterprise apps like Exchange, SharePoint, and SQL Server, and to virtualize Windows Server roles like File Server, DNS, DHCP, IIS, and AD. Includes unrestricted access to all Hyper-V features like Shielded VMs.|
| Many Windows Server deployments run on aging hardware. | Use Azure Stack HCI to use software-defined infrastructure in place of aging storage arrays or network appliances, without major rearchitecture. Built-in Hyper-V, Storage Spaces Direct, and Software-Defined Networking (SDN) are directly accessible and manageable. Run apps inside Windows or Linux VMs.|

## Compare Azure Stack HCI to Azure Stack Hub

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

## Next steps

- [What is Azure Stack HCI?](../overview.md)
