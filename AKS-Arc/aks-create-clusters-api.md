---
title: Create Kubernetes clusters using REST APIs
description: Learn how to create Kubernetes clusters in Azure Local using REST API for the Hybrid Container Service.
ms.topic: how-to
author: rcheeran
ms.date: 06/19/2025
ms.author: rcheeran 
ms.lastreviewed: 06/19/2025
ms.reviewer: rjaini
---

# Create Kubernetes clusters using the REST API

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

This article describes how to create a Kubernetes clusters on Azure Local using the REST API. The Azure Resource type for [AKS Arc provisioned clusters](/azure/templates/microsoft.hybridcontainerservice/provisionedclusterinstances?pivots=deployment-language-arm-template) is **"Microsoft.HybridContainerService/provisionedClusterInstances"**. This is an extension of the [Connected cluster](/azure/templates/microsoft.kubernetes/connectedclusters?pivots=deployment-language-arm-template) resource type **"Microsoft.Kubernetes/connectedClusters"**. Due to this dependency, you would need to first create a Connected cluster resource before creating an AKS Arc resource.

## Before you begin

Before you begin, make sure you have the following details from your on-premises infrastructure administrator:

- **Azure subscription ID** - The Azure subscription ID where Azure Local is used for deployment and registration.
- **Custom Location ID** - Azure Resource Manager ID of the custom location. The custom location is configured during the Azure Local cluster deployment. Your infrastructure admin should give you the Resource Manager ID of the custom location. This parameter is required in order to create Kubernetes clusters. You can also get the Resource Manager ID using `az customlocation show --name "<custom location name>" --resource-group <azure resource group> --query "id" -o tsv`, if the infrastructure admin provides a custom location name and resource group name.
- **Network ID** - Azure Resource Manager ID of the Azure Local logical network created following [these steps](aks-networks.md). Your admin should give you the ID of the logical network. This parameter is required in order to create Kubernetes clusters. You can also get the Azure Resource Manager ID using `az stack-hci-vm network lnet show --name "<lnet name>" --resource-group <azure resource group> --query "id" -o tsv` if you know the resource group in which the logical network was created.
- **Create an SSH key pair** - Create an SSH key pair in Azure and store the private key file for troubleshooting and log collection purposes. For detailed instructions, see [Create and store SSH keys with the Azure CLI](/azure/virtual-machines/ssh-keys-azure-cli), or in the [Azure portal](/azure/virtual-machines/ssh-keys-portal).
- To connect to the Kubernetes cluster from anywhere, create a Microsoft Entra group and add members to it. All the members in the Microsoft Entra group have cluster administrator access to the cluster. Make sure to add yourself as a member to the Microsoft Entra group. If you don't add yourself, you cannot access the Kubernetes cluster using kubectl. For more information about creating Microsoft Entra groups and adding users, see [Manage Microsoft Entra groups and group membership](/entra/fundamentals/how-to-manage-groups).

## Step 1: Create a Connected cluster resource

Refer to the API definition for [Connected clusters](/rest/api/hybridkubernetes/connected-cluster/create) and create PUT request with the **`kind`** property set as 'ProvisionedCluster'. Here is a sample PUT request to create a Connected cluster resource using the REST API:

```http
PUT https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Kubernetes/connectedClusters/{connectedClusterName}?api-version=2024-01-01
Content-Type: application/json
Authorization: Bearer <access_token>

{
    "location": "<region>",
    "identity": {
        "type": "SystemAssigned"
    },
    "kind": "ProvisionedCluster",
    "properties": {
        "agentPublicKeyCertificate": "",
        "azureHybridBenefit": "NotApplicable",
        "distribution": "AKS",
        "distributionVersion": "1.0",
        "aadProfile": {
          "enableAzureRBAC": true,
          "adminGroupObjectIDs": [
            "<entra-group-id>"
          ],
          "tenantID": "<tenant-id>"
    },
  }
}
```

Replace all placeholder values with your actual details. For more information, see the [Connected cluster API documentation](/rest/api/hybridkubernetes/connected-cluster/create).

## Step 2: Create a Provisioned cluster resource

Refer to the API definition for [Provisioned clusters](/rest/api/hybridcontainer/provisioned-cluster-instances/create-or-update). In this PUT call, pass the  Azure Resource Manager identifier created in the previous step as the URI parameter. Here is a sample HTTP PUT request to create a Provisioned cluster resource with only the required parameters:

```http
PUT https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.HybridContainerService/provisionedClusterInstances/{clusterName}?api-version=2024-01-01-preview
Content-Type: application/json
Authorization: Bearer <access_token>

{
  "extendedLocation": {
    "type": "CustomLocation",
    "name": "<ARM ID of Custom Location>"
  },
  "properties": {
    "controlPlane": {
      "count": 1,
      "vmSize": "Standard_A4_v2"
    },
    "agentPoolProfiles": [
      {
        "name": "default-nodepool-1",
        "count": 1,
        "vmSize": "Standard_A4_v2",
        "osType": "Linux",
      }
    ],
    "linuxProfile": {
      "ssh": {
        "publicKeys": [
          {
            "keyData": "<SSH public key>"
          }
        ]
      }
    },
    "cloudProviderProfile": {
      "infraNetworkProfile": {
        "vnetSubnetIds": [
          "<ARM ID of logical network>"
        ]
      }
    },
  }
}

```

Replace the placeholder values with your actual details. For more information, see the [Provisioned cluster API documentation](/rest/api/hybridcontainer/provisioned-cluster-instances/create-or-update).

## Connect to the Kubernetes cluster

Now you can connect to your Kubernetes cluster by running the `az connectedk8s proxy` command from your development machine. Make sure you sign in to Azure before running this command. If you have multiple Azure subscriptions, select the appropriate subscription ID using the [az account set](/cli/azure/account#az-account-set) command.

This command downloads the kubeconfig of your Kubernetes cluster to your development machine and opens a proxy connection channel to your on-premises Kubernetes cluster. The channel is open for as long as the command runs. Let this command run for as long as you want to access your cluster. If it times out, close the CLI window, open a fresh one, then run the command again.

You must have Contributor permissions on the resource group that hosts the Kubernetes cluster in order to run the following command successfully:

```azurecli
az connectedk8s proxy --name $aksclustername --resource-group $resource_group --file .\aks-arc-kube-config
```

Expected output:

```output
Proxy is listening on port 47011
Merged "aks-workload" as current context in .\\aks-arc-kube-config
Start sending kubectl requests on 'aks-workload' context using
kubeconfig at .\\aks-arc-kube-config
Press Ctrl+C to close proxy.
```

Keep this session running and connect to your Kubernetes cluster from a different terminal/command prompt. Verify that you can connect to your Kubernetes cluster by running the kubectl get command. This command returns a list of the cluster nodes:

```azurecli
kubectl get node -A --kubeconfig .\aks-arc-kube-config
```

The following output example shows the node created in the previous steps. Make sure the node status is **Ready**:

```output
NAME             STATUS ROLES                AGE VERSION
moc-l0ttdmaioew  Ready  control-plane,master 34m v1.24.11
moc-ls38tngowsl  Ready  <none>               32m v1.24.11
```

## Next steps

-[AKS Arc overview](overview.md)
