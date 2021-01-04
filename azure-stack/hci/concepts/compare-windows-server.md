---
title: Compare Azure Stack HCI to Windows Server
description: This topic helps you determine whether Azure Stack HCI or Windows Server is right for your organization.
ms.topic: conceptual
author: khdownie
ms.author: v-kedow
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 1/4/2021
---

# Compare Azure Stack HCI to Windows Server 2019

> Applies to: Azure Stack HCI, version 20H2; Windows Server 2019

Many customers will wonder whether Windows Server 2019 or Azure Stack HCI is a better fit for their needs. This topic helps you determine which is right for your organization.

| Windows Server 2019 | Azure Stack HCI |
| --------------- | --------------- |
| Best guest and traditional server | Best virtualization host for a software-defined data center, including Storage Spaces Direct |
| Runs anywhere, using a traditional software licensing model | Runs on hardware from your preferred vendor, but is delivered as an Azure service and billed to your Azure account |
| Two installation options: Server with desktop experience or Server Core | Based on a lightly customized Server Core |

## When to use Windows Server 2019

| Windows Server 2019 | Azure Stack HCI |
| --------------- | --------------- |
| Windows Server is a highly versatile, multi-purpose operating system, with dozens of roles and hundreds of features, including guest rights. | Azure Stack HCI doesn't include guest rights and is intended to be used for a modern, hyperconverged architecture. |
| Use Windows Server to run VMs or for bare metal installations encompassing all traditional server roles, including Active Directory, file services, DNS, DHCP, Internet Information Services (IIS), container host/guest, SQL Server, Exchange Server, Host Guardian Service (HGS), and many more. | Intended as a Hyper-V virtualization host, Azure Stack HCI is only licensed to run a small number of server roles directly; any other roles must run inside of VMs. |

## When to use Azure Stack HCI

| Windows Server 2019 | Azure Stack HCI |
| --------------- | --------------- |
| Windows Server can run on-premises or in the cloud, but will not offer the latest hyperconverged features moving forward.| Azure Stack HCI is Microsoft's premier hyperconverged infrastructure platform for running VMs on-premises, optionally stretched across two sites and with connections to Azure hybrid services. It's an easy way to modernize and secure your data centers and branch offices, achieve industry-best performance for SQL Server databases, and run VMs or virtual desktops on-premises for low latency and data sovereignty.|
| Windows Server is a great multi-purpose "Swiss Army knife" for all Windows Server roles, virtualized or not. | Use Azure Stack HCI to virtualize classic enterprise apps like Exchange, SharePoint, and SQL Server, and to virtualize Windows Server roles like File Server, DNS, DHCP, IIS, and AD. Includes unrestricted access to all Hyper-V features like Shielded VMs.|
| Many Windows Server deployments run on aging hardware. | Use Azure Stack HCI to use software-defined infrastructure in place of aging storage arrays or network appliances, without major rearchitecture. Built-in Hyper-V, Storage Spaces Direct, and Software-Defined Networking (SDN) are directly accessible and manageable. Run apps inside Windows or Linux VMs.|

## Next steps

- [Compare Azure Stack HCI to Azure Stack Hub](compare-azure-stack-hub.md)
