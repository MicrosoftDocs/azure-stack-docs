---
title: Use the Azure portal with Azure Stack HCI
description: How to view and manage your Azure Stack HCI clusters using the Azure portal.
author: khdownie
ms.author: v-kedow
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 09/01/2020
---

# Use the Azure portal with Azure Stack HCI

> Applies to Azure Stack HCI, version 20H2; Windows Server 2019

This topic explains how to connect to the Azure Stack HCI portion of the Azure portal for a global view of your Azure Stack HCI clusters. You can use the Azure portal to manage and monitor your clusters even if your physical infrastructure is hosted on premises. Cloud-based monitoring eliminates the need to maintain an on-premises monitoring system and database, reducing infrastructure complexity. It also increases scalability by uploading alerts and other information directly to Azure, which already manages millions of objects every day.

## View your clusters in the Azure portal

Once an Azure Stack HCI cluster is registered, its Azure resource is visible in the Azure portal. To view it, first sign in to the [Azure portal](https://portal.azure.com). If you've already [registered your cluster with Azure](../deploy/register-with-azure.md), you should see a new resource group with the name of your cluster appended with "-rg". If your Azure Stack HCI resource group is not displayed, search for "hci" and select your cluster from the drop-down menu:

:::image type="content" source="media/azure-portal/azure-portal-search.png" alt-text="Search Azure portal for hci to find your Azure Stack HCI resource":::

The home page for the Azure Stack HCI Service lists all of your clusters, along with their resource group, location, and associated subscription.

:::image type="content" source="media/azure-portal/azure-portal-home.png" alt-text="Home page for Azure Stack HCI Service on Azure portal":::

Click an Azure Stack HCI resource to view the overview page for that resource, which displays a high-level summary of the cluster and server nodes.

:::image type="content" source="media/azure-portal/azure-portal-overview.png" alt-text="Overview summary page for Azure Stack HCI resource on Azure portal":::

## View the activity log

The activity log provides a list of recent operations and events on the cluster along with their status, time, associated subscription, and initiating user. You can filter events by subscription, severity, time span, resource group, and resource.

:::image type="content" source="media/azure-portal/azure-portal-activity-log.png" alt-text="Activity log screen for Azure Stack HCI resource on Azure portal":::

## Configure access control

Use Access control to check user access, manage roles, and add and view role assignments and deny assignments.

:::image type="content" source="media/azure-portal/azure-portal-iam.png" alt-text="Access control screen for Azure Stack HCI resource on Azure portal":::

## Add and edit tags

Tags are name/value pairs that enable you to categorize resources and view consolidated billing by applying the same tag to multiple resources and resource groups. Tag names are case-insensitive and tag values are case-sensitive. [Learn more about tags](/azure/azure-resource-manager/management/tag-resources).

:::image type="content" source="media/azure-portal/azure-portal-tags.png" alt-text="Add or edit tags for Azure Stack HCI resource on Azure portal":::

## Compare Azure portal and Windows Admin Center

Unlike Windows Admin Center, the Azure portal experience for Azure Stack HCI is designed for global-scale multi-cluster monitoring. Use the following table to help you determine which management tool is right for your needs. Together, they offer a consistent design and are useful in complementary scenarios.

| Windows Admin Center | Azure portal |
| --------------- | --------------- |
| Edge-local hardware and virtual machine (VM) management, always available | At-scale management, additional features |
| Manage Azure Stack HCI infrastructure | Manage other Azure services |
| Monitor and update individual clusters | Monitor and update at scale |
| Manual VM provisioning and management | Self-service VMs from Azure Arc |

## Next steps

For related information, see also:

- [Connect Azure Stack HCI to Azure](../deploy/register-with-azure.md)
- [Monitor Azure Stack HCI with Azure Monitor](azure-monitor.md)
