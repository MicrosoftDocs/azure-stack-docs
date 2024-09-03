---
title: Azure Stack HCI OEM license overview
description: Learn about the Azure Stack HCI OEM license, its benefits, license requirements, activation, and more.
author: ronmiab
ms.topic: overview
ms.date: 07/15/2024
ms.author: robess
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
# customer intent: As a content developer, I want to provide customers with the appropriate Azure Stack HCI OEM license information so that they can have a clear understanding of what the license is and how it can be beneficial to them.
---

# Azure Stack HCI OEM license overview

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article covers the Azure Stack HCI OEM license, its benefits, license requirements, activation, and more.

## About the OEM license

The Azure Stack HCI OEM license is designed for Azure Stack HCI hardware including [Azure Stack HCI Premier Solutions, Integrated Systems, and Validated Nodes](https://azurestackhcisolutions.azure.microsoft.com/#/catalog?systemType=PremierSolution). The license remains valid for the lifetime of the hardware, covers up to 16 cores, and includes three essential services for your cloud infrastructure:

- Azure Stack HCI
- Azure Kubernetes Services (AKS)
- Windows Server Datacenter 2022, or [earlier version](/windows-server/get-started/automatic-vm-activation?tabs=server2025) supported guest virtual machines (VMs)

For systems with 16 cores or more, there are extra two-core and four-core license add-ons available.

 Additionally, this license grants you access to the latest versions of Azure Stack HCI and AKS, along with unlimited containers and VMs.

## Benefits

The Azure Stack HCI OEM license simplifies the licensing and activation process, reduces costs, and minimizes operational complexity. Other benefits include:

- A single license for Azure Stack HCI, AKS, and Windows Server 2022 guest VMs.

- No tools or keys to activate the Azure Stack HCI operating system.

- Single vendor procurement for hardware, software, and full stack support.

## OEM License requirements

An active Azure account is required for license activation. When you purchase the hardware and activate this license, you should:

- Install the latest versions of Azure Stack HCI, AKS, and Windows Server Datacenter 2022 guest VMs.

- Ensure your Azure Stack HCI and AKS remain current to receive the latest updates and security patches.

- Upgrade to the next version of Azure Stack HCI when the current version lifecycle ends to ensure continuous support and receive updates.

## Verify the license status

To verify if you have an active Azure Stack HCI OEM License, use these steps:

1. Go to [the Azure portal](https://portal.azure.com).
2. Search for your Azure Stack HCI cluster.
3. Under your cluster, select **Overview** to check the **Billing status**.
    - If you have an active Azure Stack HCI OEM license, your billing status should be **OEM License**, and your OEM license status should be **Activated**.

        :::image type="content" source="media/oem-license/active-oem-license.png" alt-text="Screenshot of a cluster with an active Azure Stack HCI OEM license." lightbox="media/oem-license/active-oem-license.png":::

    - If you don't have an active Azure Stack HCI OEM license, you should see a billing status of **Billed monthly**, and an OEM license status of **Not activated**.

        :::image type="content" source="media/oem-license/no-active-oem-license.png" alt-text="Screenshot of a billed monthly cluster without an active Azure Stack HCI OEM license." lightbox="media/oem-license/no-active-oem-license.png":::

For support with your Azure Stack HCI OEM license first contact your OEM vendor. If you're unable to obtain vendor support, file an Azure support request through [the Azure portal](https://portal.azure.com/).

For more information on the Azure Stack HCI OEM license, see [Azure Stack HCI OEM license FAQ](./azure-stack-hci-license-billing.yml).

## Licensing Windows Server guest VMs on Azure Stack HCI

You can activate Windows Server VMs on an Azure Stack HCI cluster using generic Automatic Virtual Machine Activation (AVMA) client keys. This can be done through either Windows Admin Center or PowerShell. For more information on using AVMA to activate Windows Server VMs, see [Activate Windows Server VMs using Automatic Virtual Machine Activation](manage/vm-activate.md#activate-azure-hybrid-benefit-ahb-through-avma).

## Licensing AKS on Azure Stack HCI

For information on activating AKS, see [Azure Kubernetes Service on Azure Stack HCI](/azure/aks/hybrid/aks-create-clusters-portal).

## Mixed-node scenarios

When a cluster or system uses different hardware models, operating system versions, or billing models this is known as a mixed-node scenario. Specifically for OEM license, if your cluster includes a mixed-node scenario where one or more of your servers don't have the OEM license, a notification in your monthly billing status details appears.

:::image type="content" source="media/oem-license/warning-mixed-node.png" alt-text="Screenshot of a warning for a cluster with an unsupported mixed-node scenario." lightbox="media/oem-license/warning-mixed-node.png":::

***We have detected mixed nodes in your cluster. You will be billed monthly for each node in your cluster as one or more servers in your cluster do not have an OEM license. To see which servers do not have the OEM license, go to Overview > Nodes and check the OEM license column. Learn more.***

> [!NOTE]
> Using the Azure Stack HCI OEM license in a mixed-node scenario may lead to inadvertent billing issues. All nodes in an Azure Stack HCI system require uniformity across the hardware, operating system, and billing treatment.

Here are some examples of mixed-mode scenarios that aren't supported:

| Scenario                                | Description         |
|-----------------------------------------|---------------------|
|Different hardware models or generations. | Using different manufacturers or different generations of hardware within the same cluster isn't supported.|
|Varying operating systems or versions.    | Running different operating systems or different versions of the same operating system across the nodes in a cluster isn't supported.|
|Different billing on server nodes.        | Mixing server hardware sold with an Azure Stack HCI OEM license and server hardware purchased with a regular Azure subscription isn't supported.|

For support with billing issues related to mixed node scenarios, file an Azure support request through [the Azure Portal](https://portal.azure.com).

## Next step

- Read [License Windows Server VMs on Azure Stack HCI](/azure-stack/hci/manage/vm-activate?tabs=azure-portal).

- Read [Azure Kubernetes Service on Azure Stack HCI](/azure/aks/hybrid/aks-create-clusters-portal).

- Read more about billing for specific OEM partners, see [Azure Stack HCI billing and payments](./concepts/billing.md).