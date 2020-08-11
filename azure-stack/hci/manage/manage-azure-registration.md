---
title: Manage Azure registration for Azure Stack HCI
description: How to manage your Azure registration for Azure Stack HCI and understand registration status using PowerShell.
author: khdownie
ms.author: v-kedow
ms.topic: how-to
ms.date: 07/29/2020
---

# Manage Azure registration

> Applies to Azure Stack HCI v20H2

Once you've created an Azure Stack HCI cluster, you must [register the cluster with Azure Arc](../deploy/register-with-azure.md). Once the cluster is registered, it periodically syncs information between the on-premises cluster and the cloud. This topic explains how to understand your registration status and unregister your cluster when you're ready to decommission it.

## Understanding registration status

To understand registration status, use the `Get-AzureStackHCI` PowerShell cmdlet and the `ClusterStatus`, `RegistrationStatus`, and `ConnectionStatus` properties. For example, after installing the Azure Stack HCI operating system, before creating or joining a cluster, the `ClusterStatus` property shows "not yet" status:

:::image type="content" source="media/manage-azure-registration/1-get-azurestackhci.png" alt-text="Azure registration status before cluster creation":::

Once the cluster is created, only `RegistrationStatus` shows "not yet" status:

:::image type="content" source="media/manage-azure-registration/2-get-azurestackhci.png" alt-text="Azure registration status after cluster creation":::

Azure Stack HCI needs to register within 30 days of installation per the Azure Online Services Terms. If not clustered after 30 days, the `ClusterStatus` will show `OutOfPolicy`, and if not registered after 30 days, the `RegistrationStatus` will show `OutOfPolicy`.

Once the cluster is registered, you can see the `ConnectionStatus` and `LastConnected` time, which is usually within the last day unless the cluster is temporarily disconnected from the Internet. An Azure Stack HCI cluster can operate fully offline for up to 30 consecutive days.

:::image type="content" source="media/manage-azure-registration/3-get-azurestackhci.png" alt-text="Azure registration status after registration":::

If that maximum period is exceeded, the `ConnectionStatus` will show `OutOfPolicy`.

## Azure Active Directory permissions

In addition to creating an Azure resource in your subscription, registering Azure Stack HCI creates an app identity, conceptually similar to a user, in your Azure Active Directory tenant. The app identity inherits the cluster name. This identity acts on behalf on the Azure Stack HCI cloud service, as appropriate, within your subscription.

If the user who runs `Register-AzureStackHCI` is an Azure Active Directory administrator or has been delegated sufficient permissions, this all happens automatically, and no additional action is required. If not, approval may be needed from your Azure Active Directory administrator to complete registration. Your administrator can either explicitly grant consent to the app, or they can delegate permissions so that you can grant consent to the app:

:::image type="content" source="media/manage-azure-registration/aad-permissions.png" alt-text="Azure Active Directory permissions and identity diagram" border="false":::

To grant consent, open portal.azure.com and sign in with an Azure account that has sufficient permissions on the Azure Active Directory. Navigate to **Azure Active Directory**, then **App registrations**. Select the app identity named after your cluster and navigate to **API permissions**.

The app requires two permissions:

```http
https://azurestackhci-usage.trafficmanager.net/AzureStackHCI.Census.Sync

https://azurestackhci-usage.trafficmanager.net/AzureStackHCI.Billing.Sync
```

Seeking approval from your Azure Active Directory administrator could take some time, so the `Register-AzureStackHCI` cmdlet will exit and leave the registration in status "pending admin consent," i.e. partially completed. Once consent has been granted, simply re-run `Register-AzureStackHCI` to complete registration.

## Unregister Azure Stack HCI with Azure

When you're ready to decommission your Azure Stack HCI cluster, use the `Unregister-AzStackHCI` cmdlet to unregister. This stops all monitoring, support, and billing functionality through Azure Arc. The Azure resource representing the cluster and the Azure Active Directory app identity are deleted, but the resource group is not, because it may contain other unrelated resources.

If running the `Unregister-AzStackHCI` cmdlet on a cluster node, use this syntax and specify your Azure subscription ID as well as the resource name of the Azure Stack HCI cluster you wish to unregister:

```PowerShell
Unregister-AzStackHCI -SubscriptionId "e569b8af-6ecc-47fd-a7d5-2ac7f23d8bfe" -ResourceName HCI001
```

You'll be prompted to visit microsoft.com/devicelogin on another device (like your PC or phone), enter the code, and sign in there to authenticate with Azure.

If running the cmdlet from a management PC, you'll also need to specify the name of a server in the cluster:

```PowerShell
Unregister-AzStackHCI -ComputerName ClusterNode1 -SubscriptionId "e569b8af-6ecc-47fd-a7d5-2ac7f23d8bfe" -ResourceName HCI001
```

An interactive Azure login window will pop up. The exact prompts you see will vary depending on your security settings (e.g. two-factor authentication). Follow the prompts to log in.

## Next steps

For related information, see also:

- [Connect Azure Stack HCI to Azure](../deploy/register-with-azure.md)
- [Monitor Azure Stack HCI with Azure Monitor](azure-monitor.md)
