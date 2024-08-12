---
title: Troubleshoot issues in Azure Container Registry on Azure Stack Hub 
description: Find answers to common issues with Azure Container Registry on Azure Stack Hub.
author: sethmanheim
ms.topic: reference
ms.date: 07/25/2024
ms.author: sethm
ms.reviewer: dgarrity
ms.lastreviewed: 04/10/2024

# Intent: As an Azure Stack Hub user, I want to know how to troubleshoot common issues with Azure Container Registry on Azure Stack Hub so that I can resolve issues quickly and efficiently.

---

# Troubleshoot issues in Azure Container Registry on Azure Stack Hub

This article provides guidance on how to troubleshoot issues with Azure Container Registry on Azure Stack Hub.

## Enable diagnostic collection settings

Platform metrics and the activity log are collected and stored automatically but can be routed to other locations by using a diagnostic setting.

Resource Logs are not collected and stored until you create a diagnostic setting and route them to one or more locations.

See [Create diagnostic setting to collect platform logs and metrics in Azure](/azure/azure-monitor/essentials/diagnostic-settings) for information about creating a diagnostic setting using the Azure portal, CLI, or PowerShell. When you create a diagnostic setting, you specify which categories of logs to collect. The categories for Azure Container Registry are listed in [Azure Container Registry monitoring data reference](/azure/container-registry/monitor-service-reference#resource-logs).

On Azure Stack Hub, the only destinations for these logs and metrics are either a local Azure Storage account on Azure Stack Hub or an Event Hubs instance on Azure Stack Hub. Log analytics workspaces are not available locally on Azure Stack Hub. For more information about the format of logs when using an Azure Storage account, see [Azure resource logs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-storage).

## Detect common issues

You might occasionally encounter problems when using Azure Container Registry on Azure Stack Hub. For example, you might not be able to pull a container image because of an issue with Docker in your local environment. Or, a network issue might prevent you from connecting to the registry.

As a first diagnostic step, run the `az acr check-health` command to get information about the health of the environment and optionally access to a target registry. This command is supported in Azure CLI version 2.28.0 or later. If you need to install or upgrade CLI, see [Install Azure CLI](/cli/azure/install-azure-cli).

For more information about running this command, see [Check registry health](/azure/container-registry/container-registry-check-health).

## Troubleshoot specific issues

To troubleshoot login issues, see [Troubleshoot login to registry](/azure/container-registry/container-registry-troubleshoot-login).

To troubleshoot potential network issues, see [Troubleshoot network issues with registry](/azure/container-registry/container-registry-troubleshoot-access).

To troubleshoot quota-related issues, there are three cases in which you might encounter quota-related issues with Azure Container Registry on Azure Stack Hub:

- When the number of container registries has exceeded the quota set by your Azure Stack Hub operator.
- When the size of one (or more) of your container registries exceeds the quota set by your Azure Stack Hub operator<sup>*</sup>.
- When the storage capacity of your Azure Stack Hub stamp is exceeded.

<sup>*</sup>By default, the maximum size of a container registry is 100 GiB, but your operator might have changed this based on their needs.

In any of these three cases, you receive an error saying that a quota was exceeded, or an error saying that some operation is disallowed. To resolve the error, contact your Azure Stack Hub operator, who can increase quotas and/or reconfigure stamps. For more information about how operators manage capacity and quotas for Azure Container Registry on Azure Stack Hub, see [Manage container registry quotas](../operator/container-registries-manage.md).

## Find your registry Resource ID for support

You might need to use the resource ID for your container registry to help resolve issues. You might need to provide this ID to your cloud operator or to Microsoft support. Follow these steps to get your resource ID:

1. Open the Azure Stack Hub user portal.
2. Navigate to your container registry.
3. Select **JSON view**.
4. Find the resource ID. Select **Copy**.

   ![get the resource id string for Azure Container Registry](.\media\container-registry-get-resource-id\acs-resource-id.png)

## Next steps

[Container registry overview](container-registry-overview.md)
