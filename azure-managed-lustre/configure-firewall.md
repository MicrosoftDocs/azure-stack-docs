---
title: Configuring Azure Firewall for Azure Managed Lustre
description: How to configure Azure Firewall for use with Azure Managed Lustre file system.
ms.topic: how-to
ms.date: 09/05/2025
author: ronhogue
ms.author: sanpand
ms.reviewer: rohogue

# Intent: As an IT Pro, I need to be able to deploy my Azure Managed Lustre file system using Azure Firewall and custom DNS.

---

# Configuring Azure Firewall for Azure Managed Lustre

Azure Firewall is a cloud-native, intelligent network firewall security service that offers top-tier threat protection for your Azure cloud workloads. It is a fully stateful firewall as a service, featuring built-in high availability and unlimited cloud scalability. For more information, see [Azure Firewall](/azure/firewall).

## Prerequisites

- An Azure subscription. If you don't have an Azure subscription, [create a free account](https://azure.microsoft.com/free/) before you begin.
- A virtual network with a subnet configured to allow Azure Managed Lustre file system support. To learn more, see [Networking prerequisites](amlfs-prerequisites.md#network-prerequisites).
- An Azure Firewall. If you don't have an Azure Firewall, see [Deploy and configure Azure Firewall Basic and policy using the Azure portal](/azure/firewall/deploy-firewall-basic-portal-policy).

## Add the firewall as a DNS server

Add the Azure Firewall private IP address as a custom DNS server. If the firewall is not used for DNS, then the firewall and virtual network may get different IP addresses from DNS resolution which could lead to intermittent failures.

> [!WARNING]
> When updating the firewall DNS settings, a warning will appear in the portal stating: Virtual machines and Application gateways(v2 SKU) within this virtual network must be restarted to utilize the updated DNS server settings.

To add the firewall private IP address as a custom DNS server:

:::image type="content" source="media/firewall/copy-firewall-ip-address.png" alt-text="Screenshot of the Azure Firewall page highlighting the firewall IP address." lightbox="media/firewall/copy-firewall-ip-address.png":::

1. In the Azure portal, open the virtual network for your Azure Managed Lustre.
1. Under the Settings option, click Firewall.
1. Copy the IP address of the firewall.
:::image type="content" source="media/firewall/add-custom-dns-ip.png" alt-text="Screenshot of the Azure DNS page highlighting the Custom radio button, the IP address field, and the Save button." lightbox="media/firewall/add-custom-dns-ip.png":::
1. Return to the virtual network for your Azure Managed Lustre.
1. Under the Settings option, click DNS.
1. In the IP address field, paste the firewall's IP address.
1. Click Save.
1. Restart any virtual machines and/or application gateways.

## Add a route table

To secure network traffic to and from your Azure Managed Lustre, add a route table to direct all non-local traffic through your Azure Firewall. For more information about Azure Route tables, see [Create, change, or delete a route table](/azure/virtual-network/manage-route-table).

To add a route table to your Azure Managed Lustre subnet, follow these steps:

<!-- >:::image type="content" source="media/firewall/create-route-table.png" alt-text="Screenshot of the Azure Route Tables page highlighting the Create button." lightbox="media/firewall/create-route-table.png"::: -->

1. Open **Route Tables** and click **Create**.
:::image type="content" source="media/firewall/name-route-table.png" alt-text="Screenshot of the Azure Route Tables page highlighting the Create button." lightbox="media/firewall/name-route-table.png":::
1. Select the **Subscription**, **Resource Group**, and **Region**.
1. Enter a Name for the route table.
1. Click **Review + Create**
1. On the next page, click **Create**

## Add a default route

To secure any network traffic to or from the internet, add a default route to your route table. The default route routes traffic specified by the address prefix to the internet. For more information about default routes, see [Default system routes](/azure/virtual-network/virtual-networks-udr-overview#default-system-routes)

To add a default system route to your route table:

1. Open the route table and click the **+ Add** button.
:::image type="content" source="media/firewall/add-route-fields.png" alt-text="Screenshot of the Azure Add Route pane listing the 5 fields to be completed and the Add button." lightbox="media/firewall/add-route-fields.png":::
1. Enter a name for the route.
1. Choose **IP address** for Destination type.
1. Enter **0.0.0.0/0** for the destination IP address.
1. Choose **Virtual Appliance** for the Next hop type.
1. Paste the firewall's private IP address for the Next hop address.
1. Click **Add**.

## Add Azure Firewall Policy rule sets

Firewall Policy is a top-level resource that contains security and operational settings for Azure Firewall. It allows you to manage rule sets that Azure Firewall uses to filter traffic. Firewall Policy organizes, prioritizes, and processes rule sets based on a hierarchy with the following components: rule collection groups, rule collections, and rules. For more information about Azure Firewall Policy rule sets, see [Azure Firewall Policy rule sets](/azure/firewall/policy-rule-sets).

:::image type="content" source="media/firewall/firewall-policy.png" alt-text="Screenshot of the Azure Firewall Rules policy pane with the Rules section expanded." lightbox="media/firewall/firewall-policy.png":::

If you don't have a rule collection group, you'll need to create one. For more information about Azure rule collection groups, see [Rule collection groups](/azure/firewall/policy-rule-sets#rule-collection-groups).

### Add application rules

To create an application rule collection:

<!-- :::image type="content" source="media/firewall/add-rule-collection.png" alt-text="Screenshot of the Azure Firewall Rules policy pane with the Rules section expanded." lightbox="media/firewall/add-rule-collection.png"::: -->

1. In your firewall policy, click **Application rules** under the Rules section.
1. Click **Add a rule collection**
1. Enter a name like **LustreApplicationRules**.
1. Leave the Rule collection type as **Application** and provide a priority value like **200**.
1. Leave Rule collection action as **Allow** and leave the Rule collection group as **DefaultApplicationRuleCollectionGroup**.
1. Under the Rules section, add two rules:

| Name | Source Type | Source | Protocol | Destination Type | Destination |
|------|-------------|--------|----------|------------------|-------------|
| AllowMicrosoftFQDNs | IP Address | http:80,https:443 | \<AMLFS subnet> | FQDN | \*.azure.com,\*.windows.com,\*.windows.net,\*.microsoft.com,\*.azure.net |
| AllowNonMicrosoftFQDNs | IP Address | http:80,https:443 | \<AMLFS subnet> | FQDN | \*.archive.ubuntu.com,\*.cvd.clamav.net,\*.trafficmanager.net |

7. Click **Add**.

### Add network rules

To create a network rule collection:

1. In your firewall policy, click **Network rules** under the Rules section.
1. Click **Add a rule collection**
1. Enter a name like **LustreNetworkRules**.
1. Leave the Rule collection type as **Network**. and provide a priority value like **199**.
1. Leave the Rule collection action as **Allow** and choose the Rule collection group as **DefaultNetworkRuleCollectionGroup**.
1. Under the Rules section, add three rules:

| Name | Source Type | Source | Protocol | Destination Ports | Destination Type | Destination |
|------|-------------|--------|----------|-------------------|------------------|-------------|
| LustreSubnetAllowAll | IP Address | \<AMLFS subnet> | Any | * | IP address | \<AMLFS subnet> |
| AllowLustreDependencies | IP Address | \<AMLFS subnet> | TCP | 443 | Service Tag | ActionGroup, ApiManagement, AzureActiveDirectory, AzureDataLake, AzureKeyVault, AzureMonitor, AzureResourceManager, EventHub, GuestAndHybridManagement, Storage |
| NTPAccess | IP Address | \<AMLFS subnet> | UDP | 123 | IP address | 168.61.215.74/32 |

7. Click **Add**.

## Next steps

These articles explain more about the creation of an Azure Managed Lustre file system (AMLFS):

- [AMLFS Prerequisites](/azure/azure-managed-lustre/amlfs-prerequisites)
- [Create an Azure Managed Lustre file system by using the Azure portal](/azure/azure-managed-lustre/create-file-system-portal)
