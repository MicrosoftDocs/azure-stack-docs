---
title: Azure Stack HCI OEM license
description: Learn about the Azure Stack HCI OEM license.
author: alkohli
ms.topic: conceptual
ms.date: 02/16/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Azure Stack HCI OEM license

This article covers the Azure Stack HCI OEM license, which is specifically designed for Azure Stack HCI hardware, including Azure Stack HCI Premier Solutions, integrated systems, and validated nodes.

The Azure Stack HCI OEM license integrates three essential services for your cloud infrastructure:

- Azure Stack HCI
- Azure Kubernetes Services (AKS)
- Windows Server Datacenter 2022

This license covers up to 16 cores, is valid for the lifetime of the hardware, and gives you access to the latest versions of Azure Stack HCI and AKS, with unlimited containers and virtual machines (VMs).

Additional two-core and four-core license add-ons are available for systems with 16-cores or more.

## Benefits

With the Azure Stack HCI OEM license, you can simplify the licensing and activation process, as well as reduce costs and operational complexity. Other benefits include:

- Eliminates the need for separate licenses for Windows Server and Azure Stack HCI. Instead, you only need one license per physical server, which covers both the host operating system (Azure Stack HCI), AKS, and the guest operating system (Windows Server Datacenter 2022).

- No need for additional tools or keys to activate the Azure stack HCI operating system. This simplifies license management and reduces operational overhead.  

- Provides hyper-converged infrastructure, container orchestration, and unlimited VMs, all with access to Azure services. This enhances cloud service delivery and simplifies cloud adoption.

- Leverages Azure services that are integrated with Azure Stack HCI, such as Azure Backup, Azure Site Recovery, Azure Monitor, and Azure Security Center. These services enable you to protect, monitor, and secure workloads, while reducing infrastructure and operational complexity.

- With Windows Server Datacenter 2022, you can run applications on a secure and robust guest operating system, with unlimited VMs.

## License requirements

An active Azure account is required for license activation. When you purchase hardware and activate this license, do the following:

- Install the latest versions of Azure Stack HCI (version 23H2), AKS, and Windows Server Datacenter 2022.

- Keep Azure Stack HCI and AKS versions up to date to receive the latest updates and security patches.

- Once the Azure Stack HCI version 23H2 lifecycle ends, upgrade to the next Azure Stack HCI version (version 24H2) to continue receiving support and updates.

These requirements to stay current are no different than from previous Azure Stack HCI requirements.

## Frequently Asked Questions (FAQ)

**How can I purchase this license?**

This license is exclusively available through select OEM partners. Please contact your OEM partner for additional information.

**Do I have to license all physical cores?**

Every physical core in the server must be licensed - this license does not support a dynamic core license model. The base license covers up to 16 cores. Additional two-core and four-core add-ons are available for systems with 16-cores or more. For systems with 16-cores or more, you may combine licenses to cover all cores. For example, a 36-core system requires two 16-core licenses plus a four-core add-on license.  

**Is annual renewal or subscription required for this license?**

There is no annual renewal or subscription required for this license. This is a one-time prepaid license, exclusively available through select OEM partners. An active Azure account is required for activation. Once purchased, the license remains active for the life of the hardware. You can continue to use the license for as long as the associated hardware that the Azure Stack HCI OS is installed on remains functional and supported.

**Which version of Windows Server is supported for this license?**

You can use Windows Server Datacenter 2022, or an earlier version that is supported by Microsoft, as a guest license.  

**Are next version rights for Windows Server Datacenter included?**

No, this license is limited to Windows Server Datacenter 2022 and does not include subsequent newer versions unless permitted by Microsoft.

**Where can I get support for this license?**

Contact your OEM vendor for support or file an Azure support request through Azure portal.

**Are mixed-node scenarios supported?**

This license doesn't currently support environments with mixed nodes in the same Azure Stack HCI system. Mixed-node scenarios occur when diverse types of servers or nodes are used together within the same cluster or system.

Utilizing this license in a mixed-node scenario will lead to inadvertent billing issues. All nodes in an Azure Stack HCI system require uniformity across the hardware, operating system, and billing treatment. Here are some examples of mixed-mode scenarios that are not supported:

- **Different hardware models or generations**: Using servers from different manufacturers or different generations of hardware within the same cluster.

- **Varying operating systems or versions**: Running different operating systems or different versions of the same operating system across the nodes in a cluster.

- **Disparate billing on server nodes**: Server hardware sold with an Azure Stack HCI OEM license cannot be combined with server hardwware bought with a regular Azure subscription within the same Azure Stack HCI system.

## Next steps

- Read the [License Windows Server VMs on Azure Stack HCI](./manage/vm-activate).
