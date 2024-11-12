---
title: Azure IoT Operations with AKS Edge Essentials
description: Learn how to run the quickstart script that creates an Arc-enabled AKS Edge Essentials Kubernetes cluster that can run Azure IoT Operations.
author: rcheeran
ms.author: rcheeran
ms.topic: how-to
ms.date: 10/23/2024
ms.custom: template-how-to
---

# Create and configure an AKS Edge Essentials cluster that can run Azure IoT Operations

Azure Kubernetes Service (AKS) Edge Essentials is one of the supported cluster platforms for [Azure IoT Operations](/azure/iot-operations/overview-iot-operations). You can use AKS Edge Essentials to create a Microsoft-managed Kubernetes cluster and deploy Azure IoT Operations on it as a workload. This article describes the steps to run a script that creates an AKS Edge Essentials Kubernetes cluster with the required configurations for Azure IoT Operations and then connects that cluster to Azure Arc.

> [!NOTE]
> Azure IoT Operations supports AKS Edge Essentials when deployed on single machine clusters. Deploying clusters on multiple machines is an experimental feature.

## Prerequisites for running the script

To run the script, you need the following prerequisites:

- An Azure subscription with either the **Owner** role or a combination of **Contributor** and **User Access Administrator** roles. You can check your access level by navigating to your subscription, selecting **Access control (IAM)** on the left-hand side of the Azure portal, and then selecting **View my access**. If you don't have an Azure subscription, [create one for free](https://azure.microsoft.com/free/?WT.mc_id=A261C142F) before you begin.
- Azure CLI version 2.64.0 or newer installed on your development machine. Use `az --version` to check your version and `az upgrade` to update if necessary. For more information, see [How to install the Azure CLI](/cli/azure/install-azure-cli).
- Install the latest version of the **connectedk8s** extension for Azure CLI:

   ```bash
   az extension add --upgrade --name connectedk8s 
   ```

- Hardware requirements: ensure that your machine has a minimum of 16-GB available RAM, 4 available vCPUs, and 52-GB free disk space reserved for Azure IoT Operations.

## Create an Arc-enabled cluster

The [AksEdgeQuickStartForAio.ps1](https://github.com/Azure/AKS-Edge/blob/main/tools/scripts/AksEdgeQuickStart/AksEdgeQuickStartForAio.ps1) script automates the process of creating and connecting a cluster, and is the recommended path for deploying Azure IoT Operations on AKS Edge Essentials. The script performs the following tasks:

- Downloads the latest [AKS Edge Essentials MSI from this repo](https://github.com/Azure/aks-edge).
- Installs AKS Edge Essentials, and deploys and creates a single machine Kubernetes cluster on your Windows machine.
- Connects to the Azure subscription, creates a resource group if it doesn't already exist, and connects the cluster to Arc to create an Arc-enabled Kubernetes cluster.
- Enables the custom location feature on the Arc-enabled Kubernetes cluster.
- Enables the workload identity federation feature on the Arc-enabled Kubernetes cluster.
- Deploys the local path provisioning.
- Configures firewall rules on the host Windows machine for the MQTT broker.
- On the Linux VM, which serves as the Kubernetes control plane node:
  - Configures the port proxy for the Kubernetes service default IP range of 10.96.0.0/28.
  - Configures the IP table rules:
    - `sudo iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 9110 -j ACCEPT`
    - `sudo iptables -A INPUT -p tcp --dport (10124, 8420, 2379, 50051) -j ACCEPT`

To run the quickstart script, perform the following steps:

1. Open an elevated PowerShell window and change the directory to a working folder.
1. Get the `objectId` of the Microsoft Entra ID application that the Azure Arc service uses in your tenant. Run the following command exactly as written, without changing the GUID value.

   ```azurecli
   az ad sp show --id bc313c14-388c-4e7d-a58e-70017303ee3b --query id -o tsv
   ```

1. Run the following commands, replacing the placeholder values with your information:

   ```powershell
   $url = "https://raw.githubusercontent.com/Azure/AKS-Edge/main/tools/scripts/AksEdgeQuickStart/AksEdgeQuickStartForAio.ps1"
   Invoke-WebRequest -Uri $url -OutFile .\AksEdgeQuickStartForAio.ps1
   Unblock-File .\AksEdgeQuickStartForAio.ps1
   Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
   .\AksEdgeQuickStartForAio.ps1 -SubscriptionId "<SUBSCRIPTION_ID>" -TenantId "<TENANT_ID>" -ResourceGroupName "<RESOURCE_GROUP_NAME>"  -Location "<LOCATION>"  -ClusterName "<CLUSTER_NAME>" -CustomLocationOid "<ARC_APP_OBJECT_ID>"
   ```

   |Placeholder|Value  |
   |---------|---------|
   |SUBSCRIPTION_ID     |      The ID of your Azure subscription. If you don't know your subscription ID, see [Find your Azure subscription](/azure/azure-portal/get-subscription-tenant-id#find-your-azure-subscription).   |
   |TENANT_ID  |    The ID of your Microsoft Entra tenant. If you don't know your tenant ID, see [Find your Microsoft Entra tenant](/azure/azure-portal/get-subscription-tenant-id#find-your-microsoft-entra-tenant).     |
   |RESOURCE_GROUP_NAME     |   The name of an existing resource group or a name for a new resource group to be created. If you use an existing resource group, it must be one that doesn't already have an Azure IoT Operations instance. Only one Azure IoT Operations instance is supported per resource group.     |
   |LOCATION     |      An Azure region close to you. For the list of Azure IoT Operations's supported Azure regions, see [Supported regions](/azure/iot-operations/overview-iot-operations#supported-regions).   |
   |CLUSTER_NAME     |    A name for the new cluster to be created.     |
   |ARC_APP_OBJECT_ID     |  The object ID value that you retrieved in step 2.       |

   If there are issues during deployment, like if your machine reboots as part of this process, run the set of commands again.

1. Run the following commands to check that the deployment was successful:

   ```powershell
   Import-Module AksEdge
   Get-AksEdgeDeploymentInfo
   ```

   In the output of the `Get-AksEdgeDeploymentInfo` command, you should see that the cluster's Arc status is **Connected**.

## Verify your cluster

To verify that your Kubernetes cluster is Azure Arc-enabled, run the following command:

```bash
kubectl get deployments,pods -n azure-arc
```

The output looks similar to the following example:

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

- [Deploy Azure IoT Operations](/azure/iot-operations/deploy-iot-ops/howto-deploy-iot-operations)
- [Uninstall AKS cluster](aks-edge-howto-uninstall.md)
