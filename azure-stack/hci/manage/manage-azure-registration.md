---
title: Manage Azure registration for Azure Stack HCI
description: How to manage your Azure registration for Azure Stack HCI and understand registration status using PowerShell.
author: khdownie
ms.author: v-kedow
ms.topic: how-to
ms.date: 07/21/2020
---

# Manage Azure registration

> Applies to Azure Stack HCI v20H2

Once you've created an Azure Stack HCI cluster, you must [register the cluster with Azure Arc](../deploy/register-with-azure.md). Once the cluster is registered, it periodically syncs information between the on-premises cluster and the cloud. This topic explains how to understand your registration status and unregister your cluster if necessary.

## Understanding registration status

To understand registration status, use the `Get-AzureStackHCI` PowerShell cmdlet and the `ClusterStatus`, `RegistrationStatus`, and `ConnectionStatus` properties. For example, after installing the Azure Stack HCI operating system, before creating or joining a cluster, the `ClusterStatus` property shows "not yet" status:

:::image type="content" source="media/manage-azure-registration/get-azurestackhci1.png" alt-text="Azure registration status before cluster creation":::

Once the cluster is created, only `RegistrationStatus` shows "not yet" status:

:::image type="content" source="media/manage-azure-registration/get-azurestackhci2.png" alt-text="Azure registration status after cluster creation":::

Azure Stack HCI needs to register within 30 days of installation per the Azure Online Services Terms. If not clustered after 30 days, the `ClusterStatus` will show `OutOfPolicy`, and if not registered after 30 days, the `RegistrationStatus` will show `OutOfPolicy`.

Once the cluster is registered, you can see the `ConnectionStatus` and `LastConnected` time, which is usually within the last day unless the cluster is temporarily disconnected from the Internet. An Azure Stack HCI cluster can operate fully offline for up to 30 consecutive days.

:::image type="content" source="media/manage-azure-registration/get-azurestackhci3.png" alt-text="Azure registration status after registration":::

If that maximum period is exceeded, the `ConnectionStatus` will show `OutOfPolicy`.

## Unregister Azure Stack HCI with Azure

When you're ready to decommission your Azure Stack HCI cluster, use the `Unregister-AzureStackHCI` cmdlet to unregister. This stops all monitoring, support, and billing functionality through Azure Arc. The Azure resource representing the cluster and the Azure Active Directory app identity are deleted, but the resource group is not, because it may contain other unrelated resources.

The minimum syntax requires no parameters at all, you just need to authenticate before running the following cmdlet:

```PowerShell
Unregister-AzureStackHCI
```

## Next steps

For related information, see also:

- [Connect Azure Stack HCI to Azure](../deploy/register-with-azure.md)
- [Monitor Azure Stack HCI with Azure Monitor](azure-monitor.md)
