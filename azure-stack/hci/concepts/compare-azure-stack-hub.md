---
title: Compare Azure Stack HCI to Azure Stack Hub
description: This topic helps you determine whether Azure Stack HCI or Azure Stack Hub is right for your organization.
ms.topic: conceptual
author: jasongerend
ms.author: jgerend
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 10/06/2021
---

# Compare Azure Stack HCI to Azure Stack Hub

> Applies to: Azure Stack HCI, versions 21H2 and 20H2; Azure Stack Hub

As your organization digitally transforms, you may find you can move faster by using public cloud services to build on modern architectures and refresh legacy apps. However, for reasons that include technological and regulatory obstacles, many workloads must remain on-premises. Use this table to help determine which Microsoft hybrid cloud strategy provides what you need where you need it, delivering cloud innovation for workloads wherever they are.

| Azure Stack HCI | Azure Stack Hub |
| --------------- | --------------- |
| Same skills, familiar processes | New skills, innovative processes |
| Azure services in your datacenter using [Azure Arc](/azure/azure-arc/overview) | Azure services in your datacenter in disconnected scenarios |
| Connect your datacenter to Azure services and Azure control plane | Run your own instance of Azure Resource Manager |
| Flexible platform using integrated systems or validated nodes from OEMs | Delivered as an integrated system from OEMs |

## When to use Azure Stack HCI versus Azure Stack Hub

The following table compares Azure Stack HCI to Azure Stack Hub and explains why one may be better than the other for your use case: 

| Use cases and features | Azure Stack HCI | Azure Stack Hub |
| ---------| ----------------| --------------- |
| Lower server footprint | Use Azure Stack HCI for the minimum footprint for remote offices and branches. Start with just two servers and switchless back-to-back networking for peak simplicity and affordability. | Azure Stack Hub requires minimum of four servers and its own network switches. |
| Hyper-V support | Use Azure Stack HCI to virtualize classic enterprise apps like Exchange, SharePoint, and SQL Server, and to virtualize Windows Server roles like File Server, DNS, DHCP, IIS, and Active Directory. It provides unrestricted access to Hyper-V features.| Azure Stack Hub constrains Hyper-V configurability and feature set for consistency with Azure. | 
| Software-defined infrastructure stack | Use Azure Stack HCI to use software-defined infrastructure in place of aging storage arrays or network appliances, without major rearchitecture. Built-in Hyper-V, Storage Spaces Direct, and Software-Defined Networking (SDN) are directly accessible and manageable. | Azure Stack Hub doesn't expose these infrastructural technologies. |
| Platform-as-a-Service (PaaS) | Azure Stack HCI runs Platform-as-a-Service (PaaS) services on-premises with Azure Arc, and offers the ability to host [Azure Kubernetes Service](../../aks-hci/overview.md). You can also run [Azure Arc-enabled data services](/azure/azure-arc/data/overview), including [SQL Managed Instance](/azure/azure-arc/data/managed-instance-overview) and [PostgreSQL Hyperscale (preview)](/azure/azure-arc/data/what-is-azure-arc-enabled-postgres-hyperscale), and [App Service, Functions, and Logic Apps on Azure Arc (preview)](/azure/app-service/overview-arc-integration) on Azure Stack HCI. | Use Azure Stack Hub to develop and run apps that rely on PaaS services like Web Apps, Functions, or Event Hubs on-premises in a disconnected scenario. These services run on Azure Stack Hub exactly like they do in Azure, providing a consistent hybrid development and runtime environment. |
| Multi-tenancy support | Azure Stack HCI doesn't natively enforce or provide for multi-tenancy. | Use Azure Stack Hub for self-service Infrastructure-as-a-Service (IaaS), with strong isolation and precise usage tracking and chargeback for multiple colocated tenants. Ideal for service providers and enterprise private clouds. Templates from the Azure Marketplace. | 
| DevOps tools | Azure Stack HCI doesn't natively include any DevOps tooling. | Use Azure Stack Hub to modernize app deployment and operation with DevOps practices like infrastructure as code, continuous integration and continuous deployment (CI/CD), and convenient features like Azure-consistent VM extensions. Ideal for Dev and DevOps teams. |

## Next steps

- [Compare Azure Stack HCI and Windows Server](compare-windows-server.md)
