---
title: Using Azure Firewall with Azure Managed Lustre
description: How to use Azure Firewall for use with Azure Managed Lustre file system.
ms.topic: how-to
ms.date: 09/05/2025
author: ronhogue
ms.author: sanpand
ms.reviewer: rohogue

# Intent: As an IT Pro, I need to be able to deploy my Azure Managed Lustre file system using Azure Firewall and custom DNS.

---

# Optional: Using Azure Firewall with Azure Managed Lustre

This article provides guidelines if you are using Azure Firewall with Azure Managed Lustre filesystem (AMLFS). A common architecture is to use hub virtual networks (vnets) for the firewall and spoke vnets for services like AMLFS. In most scenarios, a spoke should only be peered to a single hub network and that hub network should be in the same region as the spoke. For more information about this architecture, see [Hub-spoke network topology in Azure](/azure/architecture/networking/architecture/hub-spoke).

Azure Firewall is a cloud-native, intelligent network firewall security service that offers top-tier threat protection for your Azure cloud workloads. It is a fully stateful firewall as a service, featuring built-in high availability and unlimited cloud scalability. For more information, see [Azure Firewall](/azure/firewall).

## Prerequisites

- A virtual network with a subnet configured to allow AMLFS support. To learn more, see [Networking prerequisites](amlfs-prerequisites.md#network-prerequisites).
- An Azure Firewall. If you don't have an Azure Firewall, see [Deploy and configure Azure Firewall Basic and policy using the Azure portal](/azure/firewall/deploy-firewall-basic-portal-policy).

## Add Azure Firewall Policy rule sets

Firewall Policy is a top-level resource that contains security and operational settings for Azure Firewall. It allows you to manage rule sets that Azure Firewall uses to filter traffic. Firewall Policy organizes, prioritizes, and processes rule sets based on a hierarchy with the following components: rule collection groups, rule collections, and rules. For more information about Azure Firewall Policy rule sets, see [Azure Firewall Policy rule sets](/azure/firewall/policy-rule-sets).

:::image type="content" source="media/firewall/firewall-policy.png" alt-text="Screenshot of the Azure Firewall Rules policy pane with the Rules section expanded." lightbox="media/firewall/firewall-policy.png":::

If you don't have a rule collection group, you'll need to create one. For more information about Azure rule collection groups, see [Rule collection groups](/azure/firewall/policy-rule-sets#rule-collection-groups).

### Add application rules

Application rules allow AMLFS to access essential services. For MicrosoftFQDNs, essential services include blob storage, metrics, diagnostics, and health monitoring. NonMicrosoftFQDNs allow access to OS security updates, security scanners, and Azure load balancer.

To create an application rule collection:

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

In this section, we'll add three rules.

- LustreSubnetAllowAll allows all IP addresses within the AMLFS subnet to communicate with each other.
- AllowLustreDependencies allows AMLFS to access essential services required for a secure environment, engineering diagnostic support, and storage account integration. For more information about each service, refer to the table under [Create outbound security rules](/azure/azure-managed-lustre/configure-network-security-group#create-outbound-security-rules).
- NTPAccess allows access to a Microsoft NTP server for time synchronization.

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
