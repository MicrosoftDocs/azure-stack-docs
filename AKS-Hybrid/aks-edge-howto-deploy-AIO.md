---
title: AIO with AKS Edge Essentials
description: Learn how to use Azure IoT Operations with AKS Edge Essentials.
author: rcheeran
ms.author: rcheeran
ms.topic: how-to
ms.date: 10/21/2024
ms.custom: template-how-to
---

# Deploy Azure IoT Operations on AKS Edge Essentials

[Azure IoT Operations (AIO)]() requires an Arc-enabled Kubernetes cluster. You can use AKS Edge Essentials to create a Microsoft managed Kubernetes cluster and deploy AIO as a workload on it. This article describes the steps to run a handy script that creates an AKS Edge Essentials Kubernetes clusters with all the required configurations applicable for AIO. 

> [!INFO]
> AIO is Gnerally Available on AKS EE single machine clusters. Deploying clusters on multiple machines is an experimental feature. 

## Pre-requisites for running the script 

- An Azure subscription. If you don't have an Azure subscription, create one for free before you begin.
- Azure CLI version 2.64.0 or newer installed on your development machine. Use az --version to check your version and az upgrade to update if necessary.For more information, see [How to install the Azure CLI](https://review.learn.microsoft.com/en-us/cli/azure/install-azure-cli).
- The latest version of the following extensions for Azure CLI:
    ```bash
    az extension add --upgrade --name azure-iot-ops
    az extension add --upgrade --name connectedk8s 
    ```
- Hardware requirements: Ensure that your machine has a minimum of 16-GB available RAM, 8 available vCPUs, and 52-GB free disk space reserved for Azure IoT Operations.
- If you're going to deploy Azure IoT Operations to a multi-node cluster with fault tolerance enabled, review the hardware and storage requirements in [Prepare Linux for Edge Volumes](https://review.learn.microsoft.com/en-us/azure/azure-arc/container-storage/prepare-linux-edge-volumes).


## Create an AKS EE cluster for AIO
The [AksEdgeQuickStartForAio.ps1](https://github.com/Azure/AKS-Edge/blob/main/tools/scripts/AksEdgeQuickStart/AksEdgeQuickStartForAio.ps1) script automates the process of creating and connecting a cluster, and is the recommended path for deploying Azure IoT Operations on AKS Edge Essentials.
1. Open an elevated PowerShell window and change the directory to a working folder.
1. Get the objectId of the Microsoft Entra ID application that the Azure Arc service uses in your tenant. Run the following command exactly as written, without changing the GUID value.
    ```azurecli
    az ad sp show --id bc313c14-388c-4e7d-a58e-70017303ee3b --query id -o tsv
    ```
1. Run the following commands, replacing the placeholder values with your information:

|Placeholder|Value  |
|---------|---------|
|SUBSCRIPTION_ID     |      The ID of your Azure subscription. If you don't know your subscription ID, see [Find your Azure subscription](https://review.learn.microsoft.com/en-us/azure/azure-portal/get-subscription-tenant-id#find-your-azure-subscription).   |
|TENANT_ID  |    The ID of your Microsoft Entra tenant. If you don't know your tenant ID, see [Find your Microsoft Entra tenant](https://review.learn.microsoft.com/en-us/azure/azure-portal/get-subscription-tenant-id#find-your-microsoft-entra-tenant).     |
|RESOURCE_GROUP_NAME     |   The name of an existing resource group or a name for a new resource group to be created.      |
|LOCATION     |      An Azure region close to you. For the list of currently supported Azure regions, see [Supported regions](https://review.learn.microsoft.com/en-us/azure/iot-operations/overview-iot-operations#supported-regions).   |
|CLUSTER_NAME     |    A name for the new cluster to be created.     |
|ARC_APP_OBJECT_ID     |  The object ID value that you retrieved in the previous step.       |

```powershell
$url = "https://raw.githubusercontent.com/Azure/AKS-Edge/main/tools/scripts/AksEdgeQuickStart/AksEdgeQuickStartForAio.ps1"
Invoke-WebRequest -Uri $url -OutFile .\AksEdgeQuickStartForAio.ps1
Unblock-File .\AksEdgeQuickStartForAio.ps1
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
.\AksEdgeQuickStartForAio.ps1 -SubscriptionId "<SUBSCRIPTION_ID>" -TenantId "<TENANT_ID>" -ResourceGroupName "<RESOURCE_GROUP_NAME>"  -Location "<LOCATION>"  -ClusterName "<CLUSTER_NAME>" -CustomLocationOid "<ARC_APP_OBJECT_ID>"
```
If there are any issues during deployment, including if your machine reboots as part of this process, run the whole set of commands again.
1. Run the following commands to check that the deployment was successful:
```powershell
Import-Module AksEdge
Get-AksEdgeDeploymentInfo
```
In the output of the Get-AksEdgeDeploymentInfo command, you should see that the cluster's Arc status is Connected.

## Verify your cluster
To verify that your cluster is ready for Azure IoT Operations deployment, you can use the [verify-host](https://review.learn.microsoft.com/en-us/cli/azure/iot/ops#az-iot-ops-verify-host) helper command in the Azure IoT Operations extension for Azure CLI. When run on the cluster host, this helper command checks connectivity to Azure Resource Manager and Microsoft Container Registry endpoints.
```azurecli
az iot ops verify-host
```

To verify that your Kubernetes cluster is Azure Arc-enabled, run the following command:
```bash
kubectl get deployments,pods -n azure-arc
```

The output looks like the following example:
```output
NAME                                         READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/clusterconnect-agent         1/1     1            1           10m
deployment.apps/extension-manager            1/1     1            1           10m
deployment.apps/clusteridentityoperator      1/1     1            1           10m
deployment.apps/controller-manager           1/1     1            1           10m
deployment.apps/flux-logs-agent              1/1     1            1           10m
deployment.apps/cluster-metadata-operator    1/1     1            1           10m
deployment.apps/extension-events-collector   1/1     1            1           10m
deployment.apps/config-agent                 1/1     1            1           10m
deployment.apps/kube-aad-proxy               1/1     1            1           10m
deployment.apps/resource-sync-agent          1/1     1            1           10m
deployment.apps/metrics-agent                1/1     1            1           10m

NAME                                              READY   STATUS    RESTARTS        AGE
pod/clusterconnect-agent-5948cdfb4c-vzfst         3/3     Running   0               10m
pod/extension-manager-65b8f7f4cb-tp7pp            3/3     Running   0               10m
pod/clusteridentityoperator-6d64fdb886-p5m25      2/2     Running   0               10m
pod/controller-manager-567c9647db-qkprs           2/2     Running   0               10m
pod/flux-logs-agent-7bf6f4bf8c-mr5df              1/1     Running   0               10m
pod/cluster-metadata-operator-7cc4c554d4-nck9z    2/2     Running   0               10m
pod/extension-events-collector-58dfb78cb5-vxbzq   2/2     Running   0               10m
pod/config-agent-7579f558d9-5jnwq                 2/2     Running   0               10m
pod/kube-aad-proxy-56d9f754d8-9gthm               2/2     Running   0               10m
pod/resource-sync-agent-769bb66b79-z9n46          2/2     Running   0               10m
pod/metrics-agent-6588f97dc-455j8                 2/2     Running   0               10m
```

## Next steps

- [Deploy Azure IoT Operations](https://review.learn.microsoft.com/en-us/azure/iot-operations/deploy-iot-ops/howto-deploy-iot-operations)
- [Uninstall AKS cluster](aks-edge-howto-uninstall.md)
