---
title: Resource provider API versions supported by profiles in Azure Stack Hub 
description: Learn about the Azure Resource Manager API versions supported by profiles in Azure Stack Hub.
author: sethmanheim

ms.topic: article
ms.date: 01/07/2020
ms.author: sethm
ms.reviewer: sijuman
ms.lastreviewed: 05/08/2019

# Intent: As an Azure Stack user, I want to know which resource provider API versions are supported �by profiles in Azure Stack.
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

## Overview of the 2019-03-01-hybrid profile

| Resource provider | Api-version |
|-----------------------------------------------|-----------------------------------------------------|
| Microsoft.Compute | 2017-12-01 |
| Microsoft.Network | 2017-10-01<br>VPN Gateway will be 2017-10-01 |
| Microsoft.Storage (Data Plane) | 2017-11-09 |
| Microsoft.Storage (Control Plane) | 2017-10-01 |
| Microsoft.Web | 2018-02-01 |
| Microsoft.KeyVault | 2016-10-01 (Not changing) |
| Microsoft.Resources (Azure Resource Manager itself) | 2016-06-01 |
| Microsoft.Authorization (policy operations) | 2016-09-01 |
| Microsoft.Insights | 2018-01-01 |

For a list of the versions for each resource type for the providers in the API profile, see [Details for the 2019-03-01-hybrid profile](#details-for-the-2019-03-01-hybrid-profile).

## Details for the 2019-03-01-hybrid profile

### Microsoft.Authorization

Role-based access control lets you manage the actions users in your organization can take on resources. You can define roles, assign roles to users or groups, and get information about permissions. For more information, see [Authorization](/rest/api/authorization/).

| Resource Types | API Versions |
|---------------------|--------------------|
| Locks | 2016-09-01 |
| Operations | 2015-07-01 |
| Permissions | 2015-07-01 |
| Policy Assignments | 2016-12-01 |
| Policy Definitions | 2016-12-01 |
| Provider Operations | 2015-07-01 |
| Role Assignments | 2015-07-01 |
| Role Definitions | 2015-07-01 |

### Microsoft.Commerce

| Resource Type | API Version |
|----------------------------------|----------------------|
| Delegated Provider Subscriptions | 2015-06-01 - preview |
| Delegated Usage Aggregates | 2015-06-01 - preview |
| Estimate Resource Spend | 2015-06-01 - preview |
| Operations | 2015-06-01 - preview |
| Subscriber Usage Aggregates | 2015-06-01 - preview |
| Usage Aggregates | 2015-06-01 - preview |

### Microsoft.Compute

The Azure Compute APIs give you programmatic access to virtual machines and their supporting resources. For more information, see [Azure Compute](/rest/api/compute/).

| Resource Type | API Version |
|---------------------------------------------------------------|-------------|
| Availability Sets | 2017-12-01 |
| Locations | 2017-12-01 |
| Locations/operations | 2017-12-01 |
| Locations/publishers | 2017-12-01 |
| Locations/usages | 2017-12-01 |
| Locations/vmSizes | 2017-12-01 |
| Operations | 2017-12-01 |
| Virtual Machines | 2017-12-01 |
| Virtual Machines/extensions | 2017-12-01 |
| Virtual Machine Scale Sets | 2017-12-01 |
| Virtual Machine Scale Sets/extensions | 2017-12-01 |
| Virtual Machine Scale Sets/network Interfaces | 2017-12-01 |
| Virtual Machine Scale Sets/Virtual Machines | 2017-12-01|
| Virtual Machines Scale Sets/virtualMachines/networkInterfaces | 2017-12-01 |

### Microsoft.Gallery

| Resource Type | API Version |
|------------------|-------------|
| Curation | 2015-04-01 |
| Curation Content | 2015-04-01 |
| Curation Extract | 2015-04-01 |
| Gallery Items | 2015-04-01 |
| Operations | 2015-04-01 |
| Portal | 2015-04-01 |
| Search | 2015-04-01 |
| Suggest | 2015-04-01 |

### Microsoft.Insights

| Resource Types | API Versions |
|--------------------|--------------------|
| Operations | 2015-04-01 |
| Event Types | 2015-04-01 |
| Event Categories | 2015-04-01 |
| Metric Definitions | 2018-01-01 |
| Metrics | 2018-01-01 |
| Diagnostic Settings | 2017-05-01-preview |
| Diagnostic Settings Categories | 2017-05-01-preview |

### Microsoft.KeyVault

Manage your Key Vault as well as the keys, secrets, and certificates within your Key Vault. For more information, see the [Azure Key Vault REST API reference](/rest/api/keyvault/).

| Resource Types | API Versions |
|-------------------------|--------------|
| Operations | 2016-10-01 |
| Vaults | 2016-10-01 |
| Vaults/ Access Policies | 2016-10-01 |
| Vaults/secrets | 2016-10-01 |

### Microsoft.Network

The operations call result is a representation of the available network cloud operations list. For more information, see [Operation REST API](/rest/api/operation/).

| Resource Types | API Versions |
|---------------------------|--------------|
| Connections | 2017-10-01 |
| DNS Zones | 2016-04-01 |
| Load Balancers | 2017-10-01 |
| Local Network Gateway | 2017-10-01 |
| Locations | 2017-10-01|
| Location/operationResults | 2017-10-01 |
| Locations/operations | 2017-10-01 |
| Locations/usages |2017-10-01 |
| Network Interfaces | 2017-10-01 |
| Network Security Groups | 2017-10-01 |
| Operations | 2017-10-01 |
| Public IP Address | 2017-10-01 |
| Route Tables | 2017-10-01 |
| Virtual Network Gateway | 2017-10-01 |
| Virtual Networks | 2017-10-01 |

### Microsoft.Resources

Azure Resource Manager lets you deploy and manage the infrastructure for your Azure solutions. You organize related resources in resource groups and deploy your resources with JSON templates. For an introduction to deploying and managing resources with Resource Manager, see the [Azure Resource Manager overview](/azure/azure-resource-manager/resource-group-overview).

| Resource Types | API Versions |
|-----------------------------------------|-------------------|
| Deployments | 2018-05-01 |
| Deployments/operations | 2018-05-01 |
| Links | 2018-05-01 |
| Locations | 2018-05-01 |
| Operations | 2018-05-01 |
| Providers | 2018-05-01 |
| ResourceGroups| 2018-05-01 |
| Resources | 2018-05-01/ |
| Subscriptions | 2018-05-01 |
| Subscriptions/locations | 2016-06-01 |
| Subscriptions/operationresults | 2018-05-01 |
| Subscriptions/providers | 2018-05-01 |
| Subscriptions/ResourceGroups | 2018-05-01 |
| Subscriptions/resourceGroups/resources | 2018-05-01 |
| Subscriptions/resources | 2018-05-01 |
| Subscriptions/tagNames | 2018-05-01 |
| Subscriptions/tagNames/tagValues | 2018-05-01 |
| Tenants | 2016-06-01 |

### Microsoft.Storage

The Storage Resource Provider (SRP) lets you manage your storage account and keys programmatically. For more information, see the [Azure Storage Resource Provider REST API reference](/rest/api/storagerp/).

| Resource Types | API Versions |
|-------------------------|--------------|
| CheckNameAvailability | 2017-10-01 |
| Locations | 2017-10-01 |
| Locations/quotas | 2017-10-01 |
| Operations | 2017-10-01 |
| StorageAccounts | 2017-10-01 |
| Usages | 2017-10-01 |

## Next steps

- [Install PowerShell for Azure Stack Hub](../operator/azure-stack-powershell-install.md)
- [Configure the Azure Stack Hub PowerShell environment](azure-stack-powershell-configure-user.md)  
