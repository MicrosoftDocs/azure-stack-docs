---
title: Use the Azure portal with Azure Stack HCI
description: How to view and manage your Azure Stack HCI clusters using the Azure portal.
author: khdownie
ms.author: v-kedow
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 08/19/2020
---

# Use the Azure portal with Azure Stack HCI

> Applies to Azure Stack HCI v20H2; Windows Server 2019

This topic explains how to connect to the Azure Stack HCI portion of the Azure portal for a global view of your Azure Stack HCI clusters. You can use the Azure portal to manage and monitor your cluster even if your physical infrastructure is hosted on premises.

## View your clusters in the Azure portal

Log into the [Azure portal](https://portal.azure.com). If you've already [registered your cluster with Azure](../deploy/register-with-azure.md), you should see a new resource group with the name of your cluster appended with "-rg". If your Azure Stack HCI resource group is not displayed, search for "hci" and select your cluster from the drop-down menu:

:::image type="content" source="media/azure-portal/azure-portal-search.png" alt-text="Search Azure portal for hci to find your Azure Stack HCI resource":::

The home page for the Azure Stack HCI Service will list all of your clusters, along with their resource group, location, and associated subscription.

:::image type="content" source="media/azure-portal/azure-portal-home.png" alt-text="Home page for Azure Stack HCI resource on Azure portal":::

## Compare Azure portal and Windows Admin Center

Many customers will wonder whether the Azure portal or Windows Admin Center is better suited to various tasks. The following table helps you determine which is right for your needs. Together, they offer a consistent design and are useful in complementary scenarios.

| Windows Admin Center | Azure portal |
| --------------- | --------------- |
| Edge-local hardware and virtual machine (VM) management, always available | At-scale management, additional features |
| Manage Azure Stack HCI infrastructure | Manage other Azure services |
| Monitoring and updating for individual clusters | Monitoring and updating at scale |
| Manual VM provisioning and management | Self-service VMs from Azure Arc |
| View detailed performance, capacity, and logs | View billing information |

## Next steps

For related information, see also:

- [Connect Azure Stack HCI to Azure](../deploy/register-with-azure.md)
- [Monitor Azure Stack HCI with Azure Monitor](azure-monitor.md)
