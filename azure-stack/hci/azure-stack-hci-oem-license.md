---
title: About the Azure Stack HCI OEM license
description: Learn about the Azure Stack HCI OEM license, its benefits, requirements, and mixed-node scenarios that might cause billing conflicts.
author: ronmiab
ms.topic: conceptual
ms.date: 03/13/2024
ms.author: robess
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
# customer intent: As a content developer, I want to provide customers with the appropriate Azure Stack HCI OEM license information so that they can have a clear understanding of what the license covers for their purchase.
---

# About the Azure Stack HCI OEM license

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article covers the Azure Stack HCI OEM license, its benefits, license requirements, and more.

## About the license

The Azure Stack HCI OEM license is designed for Azure Stack HCI hardware including Azure Stack HCI Premier Solutions, integrated systems, and validated nodes. The license remains valid for the lifetime of the hardware, covers up to 16 cores, and includes three essential services for your cloud infrastructure:

- Azure Stack HCI
- Azure Kubernetes Services (AKS)
- Windows Server Datacenter 2022

For systems with 16 cores or more, there are extra two-core and four-core license add-ons available.

 Additionally, this license grants you access to the latest versions of Azure Stack HCI and AKS, along with unlimited containers and virtual machines (VMs).

## Benefits

The Azure Stack HCI OEM license simplifies the licensing and activation process, as well as reduces costs and operational complexity. Other benefits include:

- A single license for Windows Server and Azure Stack HCI.

- No tools or keys to activate the Azure Stack HCI operating system.

## License requirements

An active Azure account is required for license activation. When you purchase hardware and activate this license, you should:

- Install the latest versions of Azure Stack HCI, AKS, and Windows Server Datacenter 2022.

- Ensure your Azure Stack HCI and AKS remain current to receive the latest updates and security patches.

- Upgrade to the next version of Azure Stack HCI when the current version lifecycle ends to ensure continuous support and receive updates.

## Verify license status

To verify if you have an active Azure Stack HCI OEM License, use these steps:

1. Go to [the Azure portal](https://portal.azure.com).
2. Search for your Azure Stack HCI cluster.
3. Under your cluster, select **Overview** to check the **Billing status**.
    - If you have an active Azure Stack HCI OEM license, your billing status should be **OEM License**, and your OEM license status should be **Activated**.

        :::image type="content" source="media/oem-license/active-oem-license.png" alt-text="Screenshot of a cluster with an active Azure Stack HCI OEM license." lightbox="media/oem-license/active-oem-license.png":::

    - If you don't have an active Azure Stack HCI OEM license, you should see a billing status of **Billed monthly**, and an OEM license status of **Not activated**.

        :::image type="content" source="media/oem-license/no-active-oem-license.png" alt-text="Screenshot of a billed monthly cluster without an active Azure Stack HCI OEM license." lightbox="media/oem-license/no-active-oem-license.png":::

## Mixed-node scenarios

Mixed-node scenarios arise when different server types or nodes are combined within the same cluster or system. If your cluster includes a mixed-node scenario, a notification in your monthly billing status details appears.

:::image type="content" source="media/oem-license/no-active-oem-license.png" alt-text="Screenshot of a billed monthly cluster without an active Azure Stack HCI OEM license." lightbox="media/oem-license/no-active-oem-license.png":::

:::image type="content" source="media/oem-license/warning-mixed-node.png" alt-text="Screenshot of a warning for a cluster with an unsupported mixed-node scenario." lightbox="media/oem-license/warning-mixed-node.png":::

***We have detected mixed nodes in the same cluster. You will be fully billed as one or more of your servers do not have the OEM license. To see which servers do not have the OEM license, go to Overview > Nodes and check the OEM license column.***

> [!NOTE]
> Using the Azure Stack HCI OEM license in a mixed-node scenario may lead to inadvertent billing issues. All nodes in an Azure Stack HCI system require uniformity across the hardware, operating system, and billing treatment.

Here are some examples of mixed-mode scenarios that aren't supported:

| Scenario                                | Description         |
|-----------------------------------------|---------------------|
|Different hardware models or generations. | Using different manufacturers or different generations of hardware within the same cluster isn't supported.|
|Varying operating systems or versions.    | Running different operating systems or different versions of the same operating system across the nodes in a cluster isn't supported.|
|Different billing on server nodes.        | Mixing server hardware sold with an Azure Stack HCI OEM license and server hardware purchased with a regular Azure subscription isn't supported.|

For more information on the Azure Stack HCI OEM License, see [Azure Stack HCI FAQ - License and Billing](azure-stack-hci-license-billing.yml).

## Next step

- Read the [License Windows Server VMs on Azure Stack HCI](/azure-stack/hci/manage/vm-activate?tabs=azure-portal).
