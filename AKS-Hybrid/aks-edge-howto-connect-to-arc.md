---
title: Arc-connected AKS Edge Essentials
description: Connect your AKS Edge Essentials clusters to Arc
author: rcheeran
ms.author: rcheeran
ms.topic: how-to
ms.date: 12/05/2022
ms.custom: template-how-to
---

# Connect your AKS Edge Essentials cluster to Arc

This article describes how to connect your AKS Edge Essentials cluster to [Azure Arc](/azure/azure-arc/kubernetes/overview) so that you can monitor the health of your cluster on the Azure portal. If your cluster is connected to a proxy, you can use the scripts provided in the Github repo to connect your cluster to Arc as described [here.](./aks-edge-howto-more-configs.md)

## Prerequisites

* You need an Azure subscription with either the **Owner** role or a combination of **Contributor** and **User Access Administrator** roles. You can check your access level by navigating to your subscription, select **Access control (IAM)** on the left-hand side of the Azure portal, and then select **View my access**. Read the [Azure documentation](/azure/azure-resource-manager/management/manage-resource-groups-portal) for more information about managing resource groups.
* Enable all required resource providers in the Azure subscription such as **Microsoft.HybridCompute**, **Microsoft.GuestConfiguration**, **Microsoft.HybridConnectivity**, **Microsoft.Kubernetes**, and **Microsoft.KubernetesConfiguration**.
* Create and verify a resource group for AKS Edge Essentials Azure resources.

> [!NOTE]
> You will need the **Contributor** role to be able to delete the resources within the resource group. Commands to disconnect from Arc will fail without this role assignment.

## Step 1. Configure your machine

### Install dependencies

Then run the following commands in an elevated PowerShell window to install the dependencies in PowerShell:

```PowerShell
Install-Module Az.Resources -Repository PSGallery -Force -AllowClobber -ErrorAction Stop  
Install-Module Az.Accounts -Repository PSGallery -Force -AllowClobber -ErrorAction Stop 
Install-Module Az.ConnectedKubernetes -Repository PSGallery -Force -AllowClobber -ErrorAction Stop  
```

> [!NOTE]
> For connecting to Arc, you must install a helm version that is greater than v3.0 but less than v3.7. We recommend installing version 3.6.3.

```PowerShell
#download helm from web
Invoke-WebRequest -Uri "https://get.helm.sh/helm-v3.6.3-windows-amd64.zip" -OutFile ".\helm-v3.6.3-windows-amd64.zip"
```

```PowerShell
#Unzip to a local directory
Expand-Archive "helm-v3.6.3-windows-amd64.zip" C:\helm
#set helm in the env Path
$env:Path = "C:\helm\windows-amd64;$env:Path"
```

## Step 2. Configure your Azure environment

Provide details of your Azure subscription in the **aksedge-config.json** file under the `Arc` section as described in the table below. To successfully connect to Azure using Azure Arc-enabled kubernetes, you need a Service Principal that provides role-based access to resources on Azure. If you already have the service principal ID and password, you can update all the fields in the **aksedge-config.json** file. If you need to create a service principal you can follow the steps [here.](/azure/active-directory/develop/howto-create-service-principal-portal)

| Attribute | Value type      |  Description |
| :------------ |:-----------|:--------|
|`ClusterName` | string | Provide a name of your cluster. By default, the `hostname_cluster` is the name used |
|`Location` | string | The location in which to create your resource group. Choose the location closest to your deployment. |
| `SubscriptionId` | string | Your subscription ID. In the Azure portal, click on the subscription you're using and copy/paste the subscription ID string into the JSON. |
| `TenantId` | string | Your tenant ID. In the Azure portal, search Azure Active Directory, which should take you to the Default Directory page. From here, you can copy/paste the tenant ID string into the JSON. |
|`ResourceGroupName` | string | The name of the Azure resource group to host your Azure resources for AKS Edge. You can use an existing resource group, or if you add a new name, the system creates one for you. |
|`ClientId` | string | The name of the Azure Service Principal to use as credentials. AKS uses this service principal to connect your cluster to Arc. You can use an existing service principal or if you add a new name, the system creates one for you in the next step. |
|`ClientSecret` | string | The name of the Azure Service Principal to use as credentials. AKS uses this service principal to connect your cluster to Arc. You can use an existing service principal or if you add a new name, the system creates one for you in the next step. |

> [!NOTE]
> This procedure is required to be done only once per Azure subscription and doesn't need to be repeated for each Kubernetes cluster.
I

## Step 3. Connect your cluster to Arc

1. Run `Connect-AksEdgeArc` to install and connect the existing cluster to Arc-enabled Kubernetes.

   ```powershell
   # Connect Arc-enabled server and Arc-enabled kubernetes
   Connect-AksEdgeArc -JsonConfigFilePath ./aksedge-config.json
   ```

    > [!NOTE]
    > This step can take up to 10 minutes and PowerShell may be stuck on "Establishing Azure Connected Kubernetes for `your cluster name`". The PowerShell will output `True` and return to the prompt when the process is completed.

    ![Screenshot showing PowerShell prompt while connecting to Arc](media/aks-edge/aks-edge-ps-arc-connection.png)

## Step 4. View AKS Edge resources in Azure

1. Once the process is complete, you can view your cluster in your Azure portal if you navigate to your resource group.

   ![Screenshot showing the cluster in azure portal](media/aks-edge/cluster-in-az-portal.png)

2. On the left panel, select the **Namespaces** blade under **Kubernetes resources (preview)**.

   ![Kubernetes resources preview.](media/aks-edge/kubernetes-resources-preview.png)

3. To view your Kubernetes resources, you need a bearer token.

   ![Screenshot showing the bearer token required page.](media/aks-edge/bearer-token-required.png)

4. You can also run `Get-AksEdgeManagedServiceToken` to retrieve your service token.

   ![Screenshot showing where to paste token in portal.](media/aks-edge/bearer-token-in-portal.png)

5. Now you can view resources on your cluster. This is the **Workloads** blade, showing the same as:

    ```powershell
    kubectl get pods --all-namespaces
    ```

    ![Screenshot showing all pods in Arc.](media/aks-edge/all-pods-in-arc.png)

## Disconnect from Arc

Run `Disconnect-AksEdgeArc` to disconnect from the Arc-enabled Kubernetes.

   ```powershell
   # Disconnect Arc-enabled server and Arc-enabled kubernetes
   Disconnect-AksEdgeArc -JsonConfigFilePath AksEdgeDeployConfigTemplate.json
   ```

## Connect host machine to Arc

1. You can connect your host machine to Azure using Arc for Servers. You can follow steps 1-3 mentioned [here.](./aks-edge-howto-more-configs.md)

1. You can connect the host machine using `Connect-AideArcServer` for Arc-enabled servers:

   ```powershell
   # Connect Arc-enabled server
   Connect-AideArcServer
   ```

1. To disconnect the host machine from Arc, using `Disconnect-AideArcServer` for Arc-enabled servers:

   ```powershell
   # Disconnect Arc-enabled server
   Disconnect-AideArcServer
   ```

For a complete clean-up, through the Azure portal, delete the service principal and resource group you created for this example.

## Next steps

* [Overview](aks-edge-overview.md)
* [Uninstall AKS cluster](aks-edge-howto-uninstall.md)
