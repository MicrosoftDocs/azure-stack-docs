---
title: Compare Azure Stack HCI to Windows Server
description: This topic helps you determine whether Azure Stack HCI or Windows Server is right for your organization.
ms.topic: conceptual
author: khdownie
ms.author: v-kedow
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 1/12/2021
---

# Compare Azure Stack HCI to Windows Server 2019

> Applies to: Azure Stack HCI, version 20H2; Windows Server 2019

This topic explains the key differences between Windows Server 2019 and Azure Stack HCI and provides guidance about when to use each. It's important to remember that both Windows Server 2019 and Azure Stack HCI are current products that are actively supported and maintained by Microsoft. Many organizations may choose to deploy both, as they are intended for different purposes.

## When to use Windows Server 2019

Windows Server is a highly versatile, multi-purpose operating system, with dozens of roles and hundreds of features, including guest rights. Windows Server machines can be in the cloud or on-premises, including virtualized on top of Azure Stack HCI. 

Use Windows Server 2019 for:

- A guest operating system inside of virtual machines (VMs) or containers
- As the runtime for a Windows application
- To use one or more of the built-in server roles such as Active Directory, file services, DNS, DHCP, Internet Information Services (IIS), or Host Guardian Service (HGS)
- As a traditional server, such as a bare-metal domain controller or SQL Server installation
- For traditional infrastructure such as VMs connected to Fibre Channel SAN storage

## When to use Azure Stack HCI

Azure Stack HCI is Microsoft's premier hyperconverged infrastructure platform for running VMs or virtual desktops on-premises with connections to Azure hybrid services. It's an easy way to modernize and secure your datacenters and branch offices, and achieve industry-best performance with low latency and data sovereignty.

Use Azure Stack HCI for:

- The best virtualization host to modernize your infrastructure, either for existing workloads in your core datacenter or emerging requirements for branch office and edge locations
- Easy extensibility to the cloud, with a regular stream of innovations from your Azure subscription and a consistent set of tools and experiences
- All the benefits of hyperconverged infrastructure: a simpler, more consolidated datacenter architecture with high-speed storage and networking

>[!NOTE]
>Because Azure Stack HCI is intended to be used as a Hyper-V virtualization host for a modern, hyperconverged architecture, it does not include guest rights. Because of this, Azure Stack HCI is only licensed to run a small number of server roles directly; any other roles must run inside of VMs.

## Next steps

- [Compare Azure Stack HCI to Azure Stack Hub](compare-azure-stack-hub.md)
