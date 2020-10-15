---
title: Before you deploy Azure Stack HCI
description: How to prepare to deploy Azure Stack HCI.
author: khdownie
ms.author: v-kedow
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 10/15/2020
---

# Before you deploy Azure Stack HCI

> Applies to: Azure Stack HCI, version 20H2

In this how-to guide, you learn how to:

- Determine whether your hardware meets the base requirements for standard (single site) or stretched (two-site) Azure Stack HCI clusters
- Make sure you're not exceeding the maximum supported hardware specifications
- Gather the required information for a successful deployment
- Install Windows Admin Center on a management PC or server

For Azure Kubernetes Service on Azure Stack HCI requirements, see [AKS requirements on Azure Stack HCI](../../aks-hci/overview.md#what-you-need-to-get-started).

## Determine hardware requirements

Microsoft recommends purchasing a validated Azure Stack HCI hardware/software solution from our partners. These solutions are designed, assembled, and validated against our reference architecture to ensure compatibility and reliability, so you get up and running quickly. Check that the systems, components, devices, and drivers you are using are Windows Server 2019 Certified per the Windows Server Catalog. Visit the [Azure Stack HCI solutions](https://azure.microsoft.com/overview/azure-stack/hci) website for validated solutions.

At minimum, you will need two servers, a reliable high-bandwidth, low-latency network connection between servers, and SATA, SAS, NVMe, or persistent memory drives that are physically attached to just one server each.

However, your hardware requirements may vary depending on the size and configuration of the cluster(s) you wish to deploy. To make sure your deployment is successful, review the following:

- [Server requirements for Azure Stack HCI](../requirements/server-requirements.md)
- [Networking requirements for Azure Stack HCI](../requirements/networking-requirements.md)
- [Storage requirements for Azure Stack HCI](../requirements/storage-requirements.md)

## Review maximum supported hardware specifications

Azure Stack HCI deployments that exceed the following specifications are not supported:

| Resource                     | Maximum |
| ---------------------------- | --------|
| Physical servers per cluster | 16      |
| VMs per host                 | 1,024   |
| Disks per VM (SCSI)          | 256     |
| Storage per cluster          | 4 PB    |
| Storage per server           | 400 TB  |
| Logical processors per host  | 512     |
| RAM per host                 | 24 TB   |
| RAM per VM                   | 12 TB (generation 2 VM) or 1 TB (generation 1)|
| Virtual processors per host  | 2,048   |
| Virtual processors per VM    | 240 (generation 2 VM) or 64 (generation 1)|

## Gather information

To prepare for deployment, gather the following details about your environment:

- **Server names:** Get familiar with your organization's naming policies for computers, files, paths, and other resources. You'll need to provision several servers, each with unique names.
- **Domain name:** Get familiar with your organization's policies for domain naming and domain joining. You'll be joining the servers to your domain, and you'll need to specify the domain name.
- **Static IP addresses:** Azure Stack HCI requires static IP addresses for storage and workload (VM) traffic and doesn't support dynamic IP address assignment through DHCP for this high-speed network. You can use DHCP for the management network adapter unless you're using two in a team, in which case again you need to use static IPs. Consult your network administrator about the IP address you should use for each server in the cluster.
- **RDMA networking:** There are two types of RDMA protocols: iWarp and RoCE. Note which one your network adapters use, and if RoCE, also note the version (v1 or v2). For RoCE, also note the model of your top-of-rack switch.
- **VLAN ID:** Note the VLAN ID to be used for the network adapters on the servers, if any. You should be able to obtain this from your network administrator.
- **Site names:** For stretched clusters, two sites are used for disaster recovery. You can set up sites using [Active Directory Domain Services](/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview), or the Create cluster wizard can automatically set them up for you. Consult your domain administrator about setting up sites.

## Install Windows Admin Center

Windows Admin Center is a locally deployed, browser-based app for managing Azure Stack HCI. The simplest way to [install Windows Admin Center](/windows-server/manage/windows-admin-center/deploy/install) is on a local management PC (desktop mode), although you can also install it on a server (service mode).

If you install Windows Admin Center on a server, tasks that require CredSSP, such as cluster creation and installing updates and extensions, require using an account that's a member of the Gateway Administrators group on the Windows Admin Center server. For more information, see the first two sections of [Configure User Access Control and Permissions](/windows-server/manage/windows-admin-center/configure/user-access-control#gateway-access-role-definitions).

## Next steps

Advance to the next article to learn how to deploy the Azure Stack HCI operating system.
> [!div class="nextstepaction"]
> [Deploy the Azure Stack HCI operating system](operating-system.md)
