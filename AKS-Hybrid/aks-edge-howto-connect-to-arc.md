---
title: Arc-connected AKS Edge Essentials
description: Connect your AKS Edge Essentials clusters to Arc
author: rcheeran
ms.author: rcheeran
ms.topic: how-to
ms.date: 10/06/2023
ms.custom: template-how-to
---

# Connect your AKS Edge Essentials cluster to Arc

This article describes how to connect your AKS Edge Essentials cluster to [Azure Arc](/azure/azure-arc/kubernetes/overview) so that you can monitor the health of your cluster on the Azure portal. If your cluster is connected to a proxy, you can use the scripts provided in the GitHub repo to connect your cluster to Arc [as described here.](./aks-edge-howto-more-configs.md)

## Prerequisites

- You need an Azure subscription with either the **Owner** role or a combination of **Contributor** and **User Access Administrator** roles. You can check your access level by navigating to your subscription on the Azure portal, selecting **Access control (IAM)** on the left-hand side of the Azure portal, and then selecting **View my access**. See [the Azure documentation](/azure/azure-resource-manager/management/manage-resource-groups-portal) for more information about managing resource groups.
- Enable all required resource providers in the Azure subscription, such as **Microsoft.HybridCompute**, **Microsoft.GuestConfiguration**, **Microsoft.HybridConnectivity**, **Microsoft.Kubernetes**, **Microsoft.ExtendedLocation**, and **Microsoft.KubernetesConfiguration**.
- Create and verify a resource group for AKS Edge Essentials Azure resources.

> [!NOTE]
> You need the **Contributor** role to be able to delete the resources within the resource group. Commands to disconnect from Arc will fail without this role assignment.

## Step 1: configure your machine

### Install dependencies

Run the following commands in an elevated PowerShell window to install the dependencies in PowerShell:

```PowerShell
Install-Module Az.Resources -Repository PSGallery -Force -AllowClobber -ErrorAction Stop  
Install-Module Az.Accounts -Repository PSGallery -Force -AllowClobber -ErrorAction Stop 
Install-Module Az.ConnectedKubernetes -Repository PSGallery -Force -AllowClobber -ErrorAction Stop  
```

## Step 2: configure your Azure environment

Provide details of your Azure subscription in the **aksedge-config.json** file under the `Arc` section as described in the following table. To successfully connect to Azure using Azure Arc-enabled kubernetes, you need a service principal with the built-in `Microsoft.Kubernetes connected cluster` role in order to access resources on Azure. If you already have the service principal ID and password, you can update all the fields in the **aksedge-config.json** file. If you need to create a service principal, you can [follow the steps here](/azure/aks/hybrid/system-requirements?tabs=allow-table#optional-create-a-new-service-principal).

| Attribute | Value type      |  Description |
| :------------ |:-----------|:--------|
|`ClusterName` | string | Provide a name for your cluster. The default value is `hostname_cluster`. |
|`Location` | string | The location of your resource group. Choose the location closest to your deployment. |
|`SubscriptionId` | GUID | Your subscription ID. In the Azure portal, select the subscription you're using and copy/paste the subscription ID string into the JSON. |
|`TenantId` | GUID | Your tenant ID. In the Azure portal, search Microsoft Entra ID, which should take you to the **Default Directory** page. From here, you can copy/paste the tenant ID string into the JSON. |
|`ResourceGroupName` | string | The name of the Azure resource group to host your Azure resources for AKS Edge Essentials. You can use an existing resource group, or if you add a new name, the system creates one for you. |
|`ClientId` | GUID | Provide the application ID of the Azure service principal to use as credentials. AKS Edge Essentials uses this service principal to connect your cluster to Arc. You can use the **App Registrations** page in the Microsoft Entra resource page on the Azure portal, to list and manage the service principals in a tenant.|
|`ClientSecret` | string | Provide the password for the service principal. |

> [!NOTE]
> You only need to perform this configuration once per Azure subscription. You don't need to repeat the procedure for each Kubernetes cluster.

## Step 3: connect your cluster to Arc

Run `Connect-AksEdgeArc` to install and connect the existing cluster to Arc-enabled Kubernetes:

```powershell
# Connect Arc-enabled kubernetes
Connect-AksEdgeArc -JsonConfigFilePath .\aksedge-config.json
```

> [!NOTE]
> This step can take up to 10 minutes and PowerShell may become stuck on **Establishing Azure Connected Kubernetes for `your cluster name`**. PowerShell outputs `True` and returns to the prompt when the process is complete.

:::image type="content" source="media/aks-edge/aks-edge-ps-arc-connection.png" alt-text="Screenshot showing PowerShell prompt while connecting to Arc." lightbox="media/aks-edge/aks-edge-ps-arc-connection.png":::

## Step 4: view AKS Edge Essentials resources in Azure

1. Once the process is complete, you can view your cluster in the Azure portal if you navigate to your resource group:

   :::image type="content" source="media/aks-edge/cluster-in-az-portal.png" alt-text="Screenshot showing the cluster in the Azure portal." lightbox="media/aks-edge/cluster-in-az-portal.png":::

2. On the left panel, select the **Namespaces** option, under **Kubernetes resources (preview)**:

   :::image type="content" source="media/aks-edge/kubernetes-resources-preview.png" alt-text="Kubernetes resources preview." lightbox="media/aks-edge/kubernetes-resources-preview.png":::

3. To view your Kubernetes resources, you need a bearer token.

   :::image type="content" source="media/aks-edge/bearer-token-required.png" alt-text="Screenshot showing the bearer token required page." lightbox="media/aks-edge/bearer-token-required.png":::

4. You can also run `Get-AksEdgeManagedServiceToken` to retrieve your service token.

   :::image type="content" source="media/aks-edge/bearer-token-in-portal.png" alt-text="Screenshot showing where to paste token in portal." lightbox="media/aks-edge/bearer-token-in-portal.png":::

5. Now you can view resources on your cluster. The **Workloads** option shows the pods running in your cluster.

   ```powershell
   kubectl get pods --all-namespaces
   ```

   :::image type="content" source="media/aks-edge/all-pods-in-arc.png" alt-text="Screenshot showing all pods in Arc." lightbox="media/aks-edge/all-pods-in-arc.png":::

## Disconnect from Arc

Run `Disconnect-AksEdgeArc` to disconnect from the Arc-enabled Kubernetes.

```powershell
# Disconnect Arc-enabled kubernetes
Disconnect-AksEdgeArc -JsonConfigFilePath .\aksedge-config.json
```

## Next steps

- [Overview](aks-edge-overview.md)
- [Connect host machine to Arc](aks-edge-howto-more-configs.md)
- [Uninstall AKS cluster](aks-edge-howto-uninstall.md)
