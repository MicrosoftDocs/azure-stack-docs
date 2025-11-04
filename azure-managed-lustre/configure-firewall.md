---
title: Use Azure Firewall with Azure Managed Lustre
description: Learn how to use Azure Firewall with an Azure Managed Lustre file system.
ms.topic: how-to
ms.date: 09/05/2025
author: ronhogue
ms.author: sanpand
ms.reviewer: rohogue

#customer intent: As an IT Pro, I want to know how to deploy my Azure Managed Lustre file system by using Azure Firewall and custom DNS.

---

# Use Azure Firewall with Azure Managed Lustre

This article provides guidelines if you're using Azure Firewall with an Azure Managed Lustre file system. A common architecture is to use hub virtual networks for the firewall and spoke virtual networks for services like Managed Lustre.

In most scenarios, a spoke should be peered only to a single hub network. The peered hub network should be in the same region as the spoke.

For more information about this architecture, see [Hub-spoke network topology in Azure](/azure/architecture/networking/architecture/hub-spoke).

Azure Firewall is a cloud-native, intelligent network firewall security service that offers top-tier threat protection for your Azure cloud workloads. It's a fully stateful firewall as a service, featuring built-in high availability and unlimited cloud scalability. For more information, see [Azure Firewall](/azure/firewall).

## Prerequisites

- A virtual network with a subnet configured to allow Managed Lustre support. To learn more, see [Networking prerequisites](amlfs-prerequisites.md#network-prerequisites).
- An Azure Firewall. If you don't have an instance of Azure Firewall, see [Deploy and configure Azure Firewall Basic and policy via the Azure portal](/azure/firewall/deploy-firewall-basic-portal-policy).

## Add Azure Firewall Policy rule sets

Azure Firewall Policy is a top-level resource that contains security and operational settings for Azure Firewall. You can use Firewall Policy to manage rule sets that Azure Firewall uses to filter traffic. Firewall Policy organizes, prioritizes, and processes rule sets based on a hierarchy that has the following components: rule collection groups, rule collections, and rules. For more information about Azure Firewall Policy rule sets, see [Azure Firewall Policy rule sets](/azure/firewall/policy-rule-sets).

:::image type="content" source="media/firewall/firewall-policy.png" alt-text="Screenshot of the Azure Firewall Rules policy pane with the Rules section expanded." lightbox="media/firewall/firewall-policy.png":::

If you don't have a rule collection group, create one. For more information, see [Rule collection groups](/azure/firewall/policy-rule-sets#rule-collection-groups).

### Add application rules

Application rules allow Managed Lustre to access essential services. For Microsoft fully qualified domain names (FQDNs), essential services include Azure Blob Storage, metrics, diagnostics, and health monitoring. Non-Microsoft FQDNs allow access to operating system security updates, security scanners, and Azure Load Balancer.

To create an application rule collection:

1. In your firewall policy, under **Rules**, select **Application rules**.
1. Select **Add a rule collection**.
1. Enter a name for the rule collection. An example is *LustreApplicationRules*.
1. For **Rule collection type**, retain **Application**. Then enter a priority value, like **200**.
1. For **Rule collection action**, retain **Allow**. For **Rule collection group**, retain **DefaultApplicationRuleCollectionGroup**.
1. In the **Rules** section, add two rules:

    | Name | Source type | Source | Protocol | Destination type | Destination |
    |------|-------------|--------|----------|------------------|-------------|
    | `AllowMicrosoftFQDNs` | IP address | `http:80`, `https:443` | *Managed-Lustre-subnet* | FQDN | `\*.azure.com`, `\*.windows.com`, `\*.windows.net`, `\*.microsoft.com`, `\*.azure.net` |
    | `AllowNonMicrosoftFQDNs` | IP address | `http:80`, `https:443` | *Managed-Lustre-subnet* | FQDN | `\*.archive.ubuntu.com`, `\*.cvd.clamav.net`, `\*.trafficmanager.net` |

1. Select  **Add**.

### Add network rules

In this section, add three rules.

- `LustreSubnetAllowAll`: Allows all IP addresses within the Managed Lustre subnet to communicate with each other.
- `AllowLustreDependencies`: Allows Managed Lustre to access essential services required for a secure environment, engineering diagnostic support, and storage account integration. For more information about each service, see the table under [Create outbound security rules](/azure/azure-managed-lustre/configure-network-security-group#create-outbound-security-rules).
- `NTPAccess`: Allows access to a Microsoft Network Time Protocol (NTP) server for time synchronization.

To create a network rule collection:

1. In your firewall policy, under **Rules**, select **Network rules**.
1. Select **Add a rule collection**
1. Enter a name for the network rule collection. An example is *LustreNetworkRules*.
1. For **Rule collection type**, retain **Network**. Enter a priority value, like **199**.
1. For **Rule collection action**, retain **Allow**. For **Rule collection group**, retain  **DefaultNetworkRuleCollectionGroup**.
1. Under **Rules**, add three rules:

    | Name | Source type | Source | Protocol | Destination ports | Destination Type | Destination |
    |------|-------------|--------|----------|-------------------|------------------|-------------|
    | `LustreSubnetAllowAll` | IP address | *Managed-Lustre-subnet* | Any | \* | IP address | *Managed-Lustre-subnet* |
    | `AllowLustreDependencies` | IP address | *Managed-Lustre-subnet* | TCP | 443 | Service Tag | `ActionGroup`, `ApiManagement`, `AzureActiveDirectory`, `AzureDataLake`, `AzureKeyVault`, `AzureMonitor`, `AzureResourceManager`, `EventHub`, `GuestAndHybridManagement`, `Storage` |
    | `NTPAccess` | IP address | *Managed-Lustre-subnet* | UDP | 123 | IP address | `168.61.215.74/32`     |

1. Select **Add**.

## Related content

- [Managed Lustre file system prerequisites](/azure/azure-managed-lustre/amlfs-prerequisites)
- [Create a Managed Lustre file system by using the Azure portal](/azure/azure-managed-lustre/create-file-system-portal)
