---
title: Compare Azure Stack HCI to Azure Stack Hub
description: This topic helps you determine whether Azure Stack HCI or Azure Stack Hub is right for your organization.
ms.topic: conceptual
author: khdownie
ms.author: v-kedow
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 1/12/2021
---

# Compare Azure Stack HCI to Azure Stack Hub

> Applies to: Azure Stack HCI, version 20H2; Azure Stack Hub

As your organization digitally transforms, you may find you can move faster by using public cloud services to build on modern architectures and refresh legacy apps. However, for reasons that include technological and regulatory obstacles, many workloads must remain on-premises. Use this table to help determine which Microsoft hybrid cloud strategy provides what you need where you need it, delivering cloud innovation for workloads wherever they are.

| Azure Stack Hub | Azure Stack HCI |
| --------------- | --------------- |
| New skills, innovative processes | Same skills, familiar processes |
| Azure services in your datacenter | Connect your datacenter to Azure services |

## When to use Azure Stack Hub

| Azure Stack Hub | Azure Stack HCI |
| --------------- | --------------- |
| Use Azure Stack Hub for self-service Infrastructure-as-a-Service (IaaS), with strong isolation and precise usage tracking and chargeback for multiple colocated tenants. Ideal for service providers and enterprise private clouds. Templates from the Azure Marketplace. | Azure Stack HCI doesn't natively enforce or provide for multi-tenancy. |
| Use Azure Stack Hub to develop and run apps that rely on Platform-as-a-Service (PaaS) services like Web Apps, Functions, or Event Hubs on-premises. These services run on Azure Stack Hub exactly like they do in Azure, providing a consistent hybrid development and runtime environment. | Azure Stack HCI doesn't run PaaS services on-premises. |
| Use Azure Stack Hub to modernize app deployment and operation with DevOps practices like infrastructure as code, continuous integration and continuous deployment (CI/CD), and convenient features like Azure-consistent VM extensions. Ideal for Dev and DevOps teams. | Azure Stack HCI doesn't natively include any DevOps tooling. |

## When to use Azure Stack HCI

| Azure Stack Hub | Azure Stack HCI |
| --------------- | --------------- |
| Azure Stack Hub requires minimum 4 nodes and its own network switches. | Use Azure Stack HCI for the minimum footprint for remote offices and branches. Start with just 2 server nodes and switchless back-to-back networking for peak simplicity and affordability. Hardware offers start at 4 drives, 64 GB of memory, well under $10k/node. |
| Azure Stack Hub constrains Hyper V configurability and feature set for consistency with Azure. | Use Azure Stack HCI for no-frills Hyper-V virtualization for classic enterprise apps like Exchange, SharePoint, and SQL Server, and to virtualize Windows Server roles like File Server, DNS, DHCP, IIS, and AD. Unrestricted access to Hyper-V features.|
| Azure Stack Hub doesn't expose these infrastructural technologies. | Use Azure Stack HCI to use software-defined infrastructure in place of aging storage arrays or network appliances, without major rearchitecture. Built-in Hyper-V, Storage Spaces Direct, and Software-Defined Networking (SDN) are directly accessible and manageable. |

## Next steps

- [Compare Azure Stack HCI and Windows Server 2019](compare-windows-server.md)
