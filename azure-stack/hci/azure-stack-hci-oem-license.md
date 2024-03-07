---
title: Azure Stack HCI OEM license
description: Learn about the Azure Stack HCI OEM license.
author: ronmiab
ms.topic: conceptual
ms.date: 02/16/2024
ms.author: robess
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Azure Stack HCI OEM license

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article covers the Azure Stack HCI OEM license, which is specifically designed for Azure Stack HCI hardware, including Azure Stack HCI Premier Solutions, integrated systems, and validated nodes.

The Azure Stack HCI OEM license integrates three essential services for your cloud infrastructure:

- Azure Stack HCI
- Azure Kubernetes Services (AKS)
- Windows Server Datacenter 2022

This license covers up to 16 cores, is valid for the lifetime of the hardware, and gives you access to the latest versions of Azure Stack HCI and AKS, with unlimited containers and virtual machines (VMs).

Additional two-core and four-core license add-ons are available for systems with 16-cores or more.

## Benefits

With the Azure Stack HCI OEM license, you can simplify the licensing and activation process, as well as reduce costs and operational complexity. Other benefits include:

- Eliminates the need for separate licenses for Windows Server and Azure Stack HCI.

- No need for additional tools or keys to activate the Azure stack HCI operating system. License requirements

## License requirements

An active Azure account is required for license activation. When you purchase hardware and activate this license, do the following:

- Install the latest versions of Azure Stack HCI, AKS, and Windows Server Datacenter 2022.

- To receive the latest updates and security patches, keep Azure Stack HCI and AKS up to date.

- To continue receiving support and updates, upgrade to the next version of Azure Stack HCI once the lifecycle of the latest version ends.

## Mixed-node scenarios

Mixed-node scenarios occur when different types of servers or nodes are used together within the same cluster or system.

Utilizing this license in a mixed-node scenario will lead to inadvertent billing issues. All nodes in an Azure Stack HCI system require uniformity across the hardware, operating system, and billing treatment.

Here are some examples of mixed-mode scenarios that aren't supported:

| Scenario                                | Description         |
|-----------------------------------------|---------------------|
|Different hardware models or generations | Using servers from different manufacturers or different generations of hardware within the same cluster.|
|Varying operating systems or versions    | Running different operating systems or different versions of the same operating system across the nodes in a cluster.|
|Different billing on server nodes        | Server hardware sold with an Azure Stack HCI OEM license can't be combined with server hardware bought with a regular Azure subscription within the same Azure Stack HCI system.|

## Next steps

- Read the [License Windows Server VMs on Azure Stack HCI](/azure-stack/hci/manage/vm-activate?tabs=azure-portal).
