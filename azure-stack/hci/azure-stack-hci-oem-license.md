---
title: Azure Stack HCI OEM license
description: Learn about the Azure Stack HCI OEM license, its benefits, requirements, and mixed-node scenarios that might cause billing conflicts.
author: ronmiab
ms.topic: conceptual
ms.date: 02/16/2024
ms.author: robess
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
# customer intent: As a content developer, I want to provide customers with the appropriate Azure Stack HCI OEM license information so that they can have a clear understanding of what the license covers for their purchase.
---

# Azure Stack HCI OEM license

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article covers the Azure Stack HCI OEM license, which is designed for Azure Stack HCI hardware. The license also includes Azure Stack HCI Premier Solutions, integrated systems, and validated nodes.

The Azure Stack HCI OEM license integrates three essential services for your cloud infrastructure:

- Azure Stack HCI
- Azure Kubernetes Services (AKS)
- Windows Server Datacenter 2022

This license covers up to 16 cores and is valid for the lifetime of the hardware. Additionally, it gives you access to the latest versions of Azure Stack HCI and AKS, with unlimited containers and virtual machines (VMs).

An extra two-core and four-core license add-ons are available for systems with 16-cores or more.

:::image type="content" source="media/oem-license/active-oem-license.png" alt-text="Screenshot of a cluster with an active Azure Stack HCI OEM license." lightbox="media/oem-license/active-oem-license.png":::

## Benefits

With the Azure Stack HCI OEM license, you can simplify the licensing and activation process, as well as reduce costs and operational complexity. Other benefits include:

- Eliminates the need for separate licenses for Windows Server and Azure Stack HCI.

- No need for more tools or keys to activate the Azure Stack HCI operating system. License requirements.

## License requirements

An active Azure account is required for license activation. When you purchase hardware and activate this license, you should:

- Install the latest versions of Azure Stack HCI, AKS, and Windows Server Datacenter 2022.

- Receive the latest updates and security patches by keeping your Azure Stack HCI and AKS up to date.

- Upgrade to the next version of Azure Stack HCI, once the lifecycle of the latest version ends, to continue receiving support and updates.

## Mixed-node scenarios

Mixed-node scenarios occur when different types of servers or nodes are used together within the same cluster or system.

Utilizing this license in a mixed-node scenario may lead to inadvertent billing issues. All nodes in an Azure Stack HCI system require uniformity across the hardware, operating system, and billing treatment.

Here are some examples of mixed-mode scenarios that aren't supported:

| Scenario                                | Description         |
|-----------------------------------------|---------------------|
|Different hardware models or generations | Using different manufacturers or different generations of hardware within the same cluster isn't supported.|
|Varying operating systems or versions    | Running different operating systems or different versions of the same operating system across the nodes in a cluster isn't supported.|
|Different billing on server nodes        | Mixing server hardware sold with an Azure Stack HCI OEM license and server hardware purchased with a regular Azure subscription isn't supported.|

If you have a mixed-node scenario in your cluster, the following notification appears in your billed monthly status details:

:::image type="content" source="media/oem-license/no-active-oem-license.png" alt-text="Screenshot of a billed monthly cluster without an active Azure Stack HCI OEM license." lightbox="media/oem-license/no-active-oem-license.png":::

:::image type="content" source="media/oem-license/warning-mixed-node.png" alt-text="Screenshot of a warning for a cluster with an unsupported mixed-node scenario." lightbox="media/oem-license/warning-mixed-node.png":::

*We have detected mixed nodes in the same cluster. You will be fully billed as one or more of your servers do not have the OEM license. To see which servers do not have the OEM license, go to Overview > Nodes and check the OEM license column.*

Check your nodes to see which servers don't have the OEM license.

For more information on the Azure Stack HCI OEM License, see [Azure Stack HCI FAQ - License and Billing](azure-stack-hci-license-billing).

## Next step

- Read the [License Windows Server VMs on Azure Stack HCI](/azure-stack/hci/manage/vm-activate?tabs=azure-portal).
