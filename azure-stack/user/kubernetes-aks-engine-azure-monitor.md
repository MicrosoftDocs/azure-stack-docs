---
title: Use Azure Monitor for containers on Azure Stack Hub | Microsoft Docs
description: Learn how to use Azure Monitor for containers on Azure Stack Hub.
author: mattbriggs

ms.service: azure-stack
ms.topic: article
ms.date: 11/15/2019
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 11/15/2019

---

# Use Azure Monitor for containers on Azure Stack Hub

You can use [Azure Monitor](https://docs.microsoft.com/azure/azure-monitor/) for containers to monitor your containers in an AKS engine deployed Kubernetes cluster in Azure Stack Hub. 

> [!IMPORTANT]
> Azure Monitor for containers on Azure Stack Hub is currently in public preview.
> This preview version is provided without a service level agreement, and it's not recommended for production workloads. Certain features might not be supported or might have constrained capabilities. 
> For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

You can review container performance with Azure Monitor by collecting memory and processor metrics from controllers, nodes, and containers available in Kubernetes through the Metrics API. In addition, the service collects container logs. You can use these logs to diagnose issues in your on-premises cluster from Azure. After you set up monitoring from your Kubernetes clusters, these metrics and logs are automatically gathered. A containerized version of the Azure Monitor Log Analytics agent for Linux gathers the logs. Azure Monitor stores the metrics and logs in your log analytics workspace accessible in your Azure subscription.

There are two ways to enable Azure Monitor on your cluster. Both ways require you to set up an Azure Monitor Log Analytics workspace in Azure.

## Prerequisites

Both methods require the [pre-requisites](https://github.com/Helm/charts/tree/master/incubator/azuremonitor-containers#pre-requisites) listed in the [Azure Monitor – Containers](https://github.com/Helm/charts/tree/master/incubator/azuremonitor-containers).

## Method one

You can also use the [Helm](https://helm.sh/) chart to install the monitoring agents in your cluster. Follow the instructions in the following article, [Azure Monitor – Containers](https://github.com/Helm/charts/tree/master/incubator/azuremonitor-containers).

## Method two

You can specify an **addon** in the AKS engine cluster specification json file. The file is also called the API Model. In this addon, provide the base64 encoded version of **WorkspaceGUID** and **WorkspaceKey** of the Azure Log Analytics Workspace where the monitoring information will be stored.

Supported API definitions for the Azure Stack Hub cluster can be found in this example: [kubernetes-container-monitoring_existing_workspace_id_and_key.json](https://github.com/Azure/aks-engine/blob/master/examples/addons/container-monitoring/kubernetes-container-monitoring_existing_workspace_id_and_key.json). Specifically, find the **addons** property in **kubernetesConfig**:

```JSON  
 "orchestratorType": "Kubernetes",
       "kubernetesConfig": {
         "addons": [
           {
             "name": "container-monitoring",
             "enabled": true,
             "config": {
               "workspaceGuid": "<Azure Log Analytics Workspace Guid in Base-64 encoded>",
               "workspaceKey": "<Azure Log Analytics Workspace Key in Base-64 encoded>"
             }
           }
         ]
       }
```

## Next steps

- Read about the [The AKS engine on Azure Stack Hub](azure-stack-kubernetes-aks-engine-overview.md)  
- Read about [Azure Monitor for containers overview](https://docs.microsoft.com/azure/azure-monitor/insights/container-insights-overview)
