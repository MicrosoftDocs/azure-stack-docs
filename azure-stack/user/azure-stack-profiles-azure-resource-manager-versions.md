---
title: Resource provider API versions supported by profiles in Azure Stack Hub 
description: Learn about the Azure Resource Manager API versions supported by profiles in Azure Stack Hub.
author: sethmanheim
ms.custom: contperf-fy20q4
ms.topic: article
ms.date: 12/6/2021
ms.author: sethm
ms.reviewer: thoroet
ms.lastreviewed: 12/6/2021

# Intent: As an Azure Stack user, I want to know which resource provider API versions are supported by profiles in Azure Stack.
# Keyword: resource api versions

---


# Resource provider API versions supported by profiles in Azure Stack Hub

You can find the resource provider and version numbers for each API profile used by Azure Stack Hub in this article. The tables in this article list the versions supported for each resource provider and the API versions of the profiles. Each resource provider contains a set of resource types and specific version numbers.

The API profile uses three naming conventions:

- **latest**
- **yyyy-mm-dd-hybrid**
- **yyyy-mm-dd-profile**

For an explanation of API profiles and version release cadence for Azure Stack Hub, see [Manage API version profiles in Azure Stack Hub](azure-stack-version-profiles.md).

> [!NOTE]
> The **latest** API profile contains the latest version of the resource provider API, and is not listed in this article.

## Overview of the 2020-09-01-hybrid profile

| Resource provider | Api-version |
| --- | --- |
| Microsoft.Authorization | 2016-09-011<br>(Not changing) |
| Microsoft.Commerce | 2015-06-01-preview |
| Microsoft.Compute | 2020-06-01 |
| Microsoft.Databoxedge | 2019-08-01 |
| Microsoft.Devices | 2019-07-01-preview |
| Microsoft.Eventhubs | 2018-01-01-preview |
| Microsoft.Insights | 2018-01-01<br>(Not changing) |
| Microsoft.Keyvault | 2019-09-01 <br>(Not changing)|
| Microsoft.Network | 2018-11-01<br>VPN Gateway will be 2018-11-01 |
| Microsoft.Resources | 2016-06-01<br>(Not changing) |
| Microsoft.Storage | 2019-06-01 |
| Microsoft.Web | 2018-02-01<br>(Not changing) |


For a list of the versions for each resource type for the providers in the API profile, see [Details for the 2020-09-01-hybrid profile](#details-for-the-2020-09-01-hybrid-profile).

## Details for the 2020-09-01-hybrid profile

### Microsoft.Authorization

Role-based access control lets you manage the actions users in your organization can take on resources. You can define roles, assign roles to users or groups, and get information about permissions. For more information, see [Authorization](/rest/api/authorization/).

| Resource Types | API Versions |
|---------------------|--------------------|
| Locks | 2016-09-01 |
| Policy assignments | 2016-12-01 |
| Policy definitions | 2016-12-01 |
| Permissions | 2015-07-01 |
| Role assignments | 2015-07-01 |
| Role definitions | 2015-07-01 |
| Provider operations | 2015-07-01 |
### Microsoft.Commerce

| Resource Type | API Version |
|----------------------------------|----------------------|
| Estimate resource spend | 2015-06-01-preview |
| Operations | 2015-06-01-preview |
| Subscriber usage aggregates | 2015-06-01-preview |
| Usage aggregates |  2015-06-01-preview|
### Microsoft.Compute

The Azure Compute APIs give you programmatic access to virtual machines and their supporting resources. For more information, see [Azure Compute](/rest/api/compute/).

| Resource Type | API Version |
|---------------------------------------------------------------|-------------|
| Availability Sets | 2020-06-01 |
| Images | 2020-06-01 |
| Locations | 2020-06-01 |
| Locations/operations | 2020-06-01 |
| Locations/publishers | 2020-06-01 |
| Locations/usages | 2020-06-01 |
| Locations/vmSizes | 2020-06-01 |
| Operations | 2020-06-01 |
| Virtual Machines | 2020-06-01 |
| Virtual Machines/extensions | 2020-06-01 |
| Virtual Machine Scale Sets | 2020-06-01 |
| Virtual Machine Scale Sets/extensions | 2020-06-01 |
| Virtual Machine Scale Sets/network Interfaces | 2020-06-01 |
| Virtual Machine Scale Sets/Virtual Machines | 2020-06-01 |
| Virtual Machines Scale Sets/virtualMachines/networkInterfaces | 2020-06-01 |

### Microsoft.Databoxedge

| Resource Types | API Versions |
|--------------------|--------------------|
| Data Box Edge devices | 2019-08-01 |
| Data Box Edge devices/checkNameAvailability | 2019-08-01 |
| Operations | 2019-08-01 |

### Microsoft.Devices

| Resource Types | API Versions |
|--------------------|--------------------|
| Usages | 2019-07-01-preview |
| Locations | 2019-07-01-preview |
| Locations/quotas | 2019-07-01-preview |
| locations/skus | 2019-07-01-preview |
| Check name availability | 2019-07-01-preview |
| Operations | 2019-07-01-preview |
| Operation results | 2019-07-01-preview |
| Backup providers | 2019-07-01-preview |
| Backup providers/operationResults | 2019-07-01-preview |

### Microsoft.Eventhubs

| Resource Types | API Versions |
|--------------------|--------------------|
| Available cluster regions | 2018-01-01-preview |
| Clusters | 2018-01-01-preview |
| Namespaces | 2018-01-01-preview |
| Check name availability | 2017-04-01 |
| Namespaces/authorizationRules | 2017-04-01 |
| Namespaces/eventhubs | 2017-04-01 |
| Namespaces/eventhubs/authorizationRules | 2017-04-01 |
| Namespaces/eventhubs/consumerGroups | 2017-04-01 |
| Operations | 2017-04-01 |
| Sku | 2017-04-01 |

### Microsoft.Insights

| Resource Types | API Versions |
|--------------------|--------------------|
| Operations | 2015-04-01 |
| Event Types | 2018-01-01 |
| Event Categories | 2018-01-01 |
| Metric Definitions | 2018-01-01 |
| Metrics | 2018-01-01 |
| Diagnostic Settings | 2018-01-01 |
| Diagnostic Settings Categories | 2018-01-01 |

### Microsoft.KeyVault

Manage your Key Vault as well as the keys, secrets, and certificates within your Key Vault. For more information, see the [Azure Key Vault REST API reference](/rest/api/keyvault/).

| Resource Types | API Versions |
|-------------------------|--------------|
| Operations | 2019-09-01 |
| Vaults | 2019-09-01 |
| Vaults/ Access Policies | 2019-09-01 |
| Vaults/secrets | 2019-09-01 |

### Microsoft.Network

The operations call result is a representation of the available network cloud operations list. For more information, see [Operation REST API](/rest/api/operation/).

| Resource Types | API Versions |
|---------------------------|--------------|
| Connections | 2018-11-01 |
| DNS Zones | 2016-04-01 |
| Load Balancers | 2018-11-01 |
| Local Network Gateway | 2018-11-01 |
| Locations | 2018-11-01|
| Location/operationResults | 2018-11-01 |
| Locations/operations | 2018-11-01 |
| Locations/usages | 2018-11-01 |
| Network Interfaces | 2018-11-01 |
| Network Security Groups | 2018-11-01 |
| Operations | 2018-11-01 |
| Public IP Address | 2018-11-01 |
| Route Tables | 2018-11-01 |
| Virtual Network Gateway | 2018-11-01 |
| Virtual Networks | 2018-11-01 |

### Microsoft.Resources

Azure Resource Manager lets you deploy and manage the infrastructure for your Azure solutions. You organize related resources in resource groups and deploy your resources with JSON templates. For an introduction to deploying and managing resources with Resource Manager, see the [Azure Resource Manager overview](/azure/azure-resource-manager/resource-group-overview).

| Resource Types | API Versions |
|-----------------------------------------|-------------------|
| Deployments | 2019-10-01 |
| Deployments/operations |2019-10-01 |
| Links | 2019-10-01 |
| Locations | 2019-10-01 |
| Operations | 2019-10-01 |
| Providers | 2019-10-01 |
| ResourceGroups| 2019-10-01 |
| Resources | 2019-10-01 |
| Subscriptions | /2016-06-01 |
| Subscriptions/locations | 2016-06-01 |
| Subscriptions/operationresults | 2019-10-01 |
| Subscriptions/providers | /2019-10-01 |
| Subscriptions/ResourceGroups | 2019-10-01 |
| Subscriptions/resourceGroups/resources | 2019-10-01 |
| Subscriptions/resources | 2019-10-01 |
| Subscriptions/tagNames | 2019-10-01 |
| Subscriptions/tagNames/tagValues | 2019-10-01 |
| Tenants | 2016-06-01 |

### Microsoft.Storage

The Storage Resource Provider (SRP) lets you manage your storage account and keys programmatically. For more information, see the [Azure Storage Resource Provider REST API reference](/rest/api/storagerp/).

| Resource Types | API Versions |
|-------------------------|--------------|
| CheckNameAvailability |2019-06-01 |
| Locations | 2019-06-01 |
| Locations/quotas | 2019-06-01 |
| Operations | 2019-06-01 |
| StorageAccounts | 2019-06-01 |
| Usages | 2019-06-01 |

### Microsoft.Web

| Resource Types | API Versions |
|--------------------|--------------------|
| Certificates | 2018-02-01 |
| Operations | 2018-02-01 |
| Checknameavailability | 2018-02-01 |
| Metadata | 2018-02-01 |
| Sites | 2018-02-01 |
| Sites/domainOwnershipIdentifiers | 2018-02-01 |
| Sites/extensions | 2018-02-01 |
| Sites/hostNameBindings | 2018-02-01 |
| Sites/instances | 2018-02-01 |
| Sites/instances/extensions | 2018-02-01 |
| Sites/slots | 2018-02-01 |
| Sites/slots/hostNameBindings | 2018-02-01 |
| Sites/slots/instances | 2018-02-01 |
| Sites/slots/instances/extensions | 2018-02-01 |
| Server farms | 2018-02-01 |
| Server farms/metricDefinitions | 2018-02-01 |
| Server farms/metrics | 2018-02-01 |
| Server farms/usages | 2018-02-01 |
| Available stacks | 2018-02-01 |
| Deployment locations | 2018-02-01 |
| Georegions | 2018-02-01 |
| List sites assigned to host name | 2018-02-01 |
| Publishing users | 2018-02-01 |
| Recommendations | 2018-02-01 |
| Source controls | 2018-02-01 |
| Validate | 2018-02-01 |

## Next steps

- [Install PowerShell for Azure Stack Hub](../operator/powershell-install-az-module.md)
- [Configure the Azure Stack Hub PowerShell environment](azure-stack-powershell-configure-user.md)  
