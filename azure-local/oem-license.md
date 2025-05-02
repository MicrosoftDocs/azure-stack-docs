---
title: OEM license for Azure Local overview
description: Learn about the OEM license for Azure Local, its benefits, license requirements, activation, and more.
author: ronmiab
ms.topic: overview
ms.date: 04/29/2025
ms.author: robess
ms.reviewer: alkohli
---

# OEM license for Azure Local overview

[!INCLUDE [applies-to](./includes/hci-applies-to-23h2.md)]

This article covers the OEM license for Azure Local, its benefits, license requirements, activation, and more.

## About the OEM license

The OEM license for Azure Local is designed for Azure Local hardware including [Premier Solutions, Integrated Systems, and Validated Nodes](https://azurestackhcisolutions.azure.microsoft.com/#/catalog?systemType=PremierSolution). The license remains valid for the lifetime of the hardware, covers up to 16 cores, and includes three essential services for your cloud infrastructure:

- Azure Local
- Windows Server Datacenter 2025, or [earlier version](/windows-server/get-started/automatic-vm-activation?tabs=server2025) supported guest virtual machines (VMs)

For systems with 16 cores or more, there are extra two-core and four-core license add-ons available.

 Additionally, this license grants you access to the latest versions of Azure Local and Azure Kubernetes Service (AKS) enabled by Azure Arc, along with unlimited containers and VMs.

## Benefits

The OEM license for Azure Local simplifies the licensing and activation process, reduces costs, and minimizes operational complexity. Other benefits include:

- A single license for Azure Local and Windows Server Datacenter 2025 guest VMs.

- No tools or keys to activate the operating system on Azure Local.

- Single vendor procurement for hardware, software, and full stack support.

## OEM License requirements

An active Azure account is required for license activation. When you purchase the hardware and activate this license, you should:

- Install the latest versions of Azure Local and Windows Server Datacenter 2025 guest VMs.

- Ensure your Azure Local remains current to receive the latest updates and security patches.

- Upgrade to the next version of Azure Local when the current version lifecycle ends to ensure continuous support and receive updates.

## Verify the license status

To verify if you have an active OEM license for Azure Local, use these steps:

1. Go to [the Azure portal](https://portal.azure.com).
2. Search for your Azure Local instance.
3. Under your cluster, select **Overview** to check the **Billing status**.
    - If you have an active OEM license for Azure Local, your billing status should be **OEM License**, and your OEM license status should be **Activated**.

        :::image type="content" source="media/oem-license/active-oem-license.png" alt-text="Screenshot of a cluster with an active OEM license for Azure Local." lightbox="media/oem-license/active-oem-license.png":::

    - If you don't have an active OEM license for Azure Local, you should see a billing status of **Billed monthly**, and an OEM license status of **Not activated**.

        :::image type="content" source="media/oem-license/no-active-oem-license.png" alt-text="Screenshot of a billed monthly cluster without an active OEM license for Azure Local." lightbox="media/oem-license/no-active-oem-license.png":::

For support with your OEM license for Azure Local first contact your OEM vendor. If you're unable to obtain vendor support, file an Azure support request through [the Azure portal](https://portal.azure.com/).

For more information on the OEM license for Azure Local, see [OEM license for Azure Local FAQ](./license-billing.yml).

## Activate Windows Server guest VMs on Azure Local

You can activate Windows Server VMs on an Azure Local instance using generic Automatic Virtual Machine Activation (AVMA) client keys. This can be done through either Windows Admin Center or PowerShell. For more information on using AVMA to activate Windows Server VMs, see [Activate Windows Server VMs on Azure Local](manage/vm-activate.md#activate-azure-hybrid-benefit-through-avma).

## Licensing AKS on Azure Local

For information on activating AKS, see [AKS on Azure Local](/azure/aks/hybrid/aks-create-clusters-portal).

## Mixed-node scenarios

When a cluster or system uses different hardware models, operating system versions, or billing models this is known as a mixed-node scenario. Specifically for OEM license, if your cluster includes a mixed-node scenario where one or more of your machines don't have the OEM license, a notification in your monthly billing status details appears.

***We have detected mixed nodes in your cluster. You will be billed monthly for each node in your cluster as one or more servers in your cluster do not have an OEM license. To see which servers do not have the OEM license, go to Overview > Nodes and check the OEM license column. Learn more.***

> [!NOTE]
> Using the OEM license for Azure Local in a mixed-node scenario may lead to inadvertent billing issues. All nodes in an Azure Local system require uniformity across the hardware, operating system, and billing treatment.

Here are some examples of mixed-mode scenarios that aren't supported:

| Scenario                                | Description         |
|-----------------------------------------|---------------------|
|Different hardware models or generations. | Using different manufacturers or different generations of hardware within the same cluster isn't supported.|
|Varying operating systems or versions.    | Running different operating systems or different versions of the same operating system across the nodes in a cluster isn't supported.|
|Different billing on machines.        | Mixing machine hardware sold with an OEM license for Azure Local and machine hardware purchased with a regular Azure subscription isn't supported.|

For support with billing issues related to mixed node scenarios, file an Azure support request through [the Azure portal](https://portal.azure.com).

## Next step

- Read [Activate Windows Server VMs on Azure Local](/azure-stack/hci/manage/vm-activate?tabs=azure-portal).

- Read [AKS on Azure Local](/azure/aks/hybrid/aks-create-clusters-portal).

- Read more about billing for specific OEM partners, see [Azure Local billing and payments](./concepts/billing.md).