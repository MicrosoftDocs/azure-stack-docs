---
title: Troubleshoot for Azure Container Registry on Azure Stack Hub 
description: Find answers to common issues with Azure Container Registry on Azure Stack Hub
author: mattbriggs
ms.topic: reference
ms.date: 10/26/2021
ms.author: mabrigg
ms.reviewer: chasat
ms.lastreviewed: 10/26/2021

# Intent: As an Azure Stack user, I want to XXX so I can XXX.
# Keyword: XXX

---

# Troubleshoot for Azure Container Registry on Azure Stack Hub

You can find common solutions to issues found when using Azure Container Registry (ACR) on Azure Stack Hub

## Enable diagnostic collection settings

Platform metrics and the activity log are collected and stored automatically but can be routed to other locations by using a diagnostic setting.

Resource Logs are not collected and stored until you create a diagnostic setting and route them to one or more locations.

See [Create diagnostic setting to collect platform logs and metrics in Azure](/azure/azure-monitor/essentials/diagnostic-settings) for the detailed process for creating a diagnostic setting using the Azure portal, CLI, or PowerShell. When you create a diagnostic setting, you specify which categories of logs to collect. The categories for ACR are listed in [Azure Container Registry monitoring data reference](/azure/container-registry/monitor-service-reference#resource-logs).

On Azure Stack Hub the only destinations for these logs and metrics are either a local Azure Storage account on Azure Stack Hub or an Event Hubs instance on Azure Stack Hub. Log analytics workspaces are not available locally on Azure Stack Hub. More details of the format of logs when using an Azure Storage account can be found here [Azure resource logs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-storage)

## Detect common issues

When using an ACR on Azure Stack Hub, you might occasionally encounter problems. For example, you might not be able to pull a container image because of an issue with Docker in your local environment. Or, a network issue might prevent you from connecting to the registry.

As a first diagnostic step, run the az acr check-health command to get information about the health of the environment and optionally access to a target registry. This command is available to support Azure Stack Hub in Azure CLI version 2.28.0 or later. If you need to install or upgrade, see [Install Azure CLI](/cli/azure/install-azure-cli).

For more information about running this command, visit this page: [Check registry health](/azure/container-registry/container-registry-check-health)

### Resolve specific issues

To troubleshoot login issues,  refer to  [Troubleshoot login to registry](/azure/container-registry/container-registry-troubleshoot-login)

To troubleshoot potential network issues, refer to [Troubleshoot network issues with registry](/azure/container-registry/container-registry-troubleshoot-access)

## Find your registry Resource ID for support

You may need to use the resource ID for our container registry to help resolve issues. You may need to provide the ID to your cloud operator or to Microsoft support. This article walks you through the steps to get your resource ID.

1.  Open the Azure Stack Hub user portal.
2.  Navigate to your container registry.
3.  Select **JSON view**.
4.  Find the resource ID. Select **copy**.

    ![get the resource id string for ACR](.\media\container-registry-get-resource-id\acs-resource-id.png)


## Next steps
