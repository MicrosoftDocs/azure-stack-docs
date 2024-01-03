---
title: Upgrade an Azure Kubernetes Service (AKS) cluster (preview)
description: Learn how to upgrade an Azure Kubernetes Service (AKS) cluster.
ms.topic: overview
ms.date: 11/28/2023
author: sethmanheim
ms.author: sethm 
ms.reviewer: rbaziwane
ms.lastreviewed: 11/28/2023

---

# Upgrade an Azure Kubernetes Service (AKS) cluster (preview)

As part of managing the application and cluster lifecycle, you might want to upgrade to the latest available version of Kubernetes. An upgrade involves either a move to a newer version of Kubernetes, applying operating system (OS) version updates (patching), or both. AKS Arc supports upgrading (or patching) nodes in a workload cluster with the latest OS and runtime updates.

All upgrades are executed in a continuous, rolling manner to ensure uninterrupted availability of workloads. When a new Kubernetes worker node with a newer build is brought into the cluster, resources are moved from the old node to the new node. Once this is completed successfully, the old node is decommissioned and removed from the cluster.

## Before you begin

If you're using the Azure CLI, this article requires Azure CLI version 2.34.1 or later. Run `az --version` to find the version. If you need to
install or upgrade CLI, see [Install Azure CLI](/cli/azure/install-azure-cli).

## Check for available upgrades

Check which Kubernetes releases are available for your cluster by using the following command:

```azurecli
az akshybrid get-upgrades --resource-group myResourceGroup --name myAKSCluster --output table
```

The following example output shows the current version as **1.24.11** and lists the available versions under `upgrades`:

```output
{  
  "agentPoolProfiles": [  
    {  
      "kubernetesVersion": "1.24.11",  
      "upgrades": [  
        {  
          "kubernetesVersion": "1.25.7"  
        }  
      ]  
    }  
  ],  
  "controlPlaneProfile": {  
    "kubernetesVersion": "1.24.11",  
    "name": "aksarc-testupgrade",  
    "osType": "Linux",  
    "upgrades": [  
      {  
        "kubernetesVersion": "1.25.7"  
      }  
    ]  
  },  
  ...  
  "provisioningState": "Succeeded",  
  ...  
}
```

## Upgrade the Kubernetes version

When you upgrade a supported AKS cluster, you can't skip Kubernetes minor versions. You must perform all upgrades sequentially by major version number. For example, upgrades from **1.24.x** to **1.25.x** or **1.25.x** to **1.26.x** are allowed. **1.24.x** to **1.26.x** isn't allowed.

> [!NOTE]
> If no patch is specified, the cluster automatically upgrades to the specified minor version's latest GA patch. For example, setting `--kubernetes-version` to **1.25** results in the cluster upgrading to **1.25.7**.

You can upgrade your cluster using the following command:

```azurecli
az akshybrid upgrade \
  --resource-group myResourceGroup \
  --name myAKSCluster \
  --kubernetes-version <KUBERNETES_VERSION>
```

Confirm the upgrade was successful by using the `show` command:

```azurecli
az akshybrid show --resource-group myResourceGroup --name myAKSCluster
```

The following example output shows that the cluster now runs **1.25.7**:

```output
{  
"extendedLocation": {  
  "name":
"/subscriptions/<subscription>/resourcegroups/<resource group>/providers/microsoft.extendedlocation/customlocations/<custom
location>",  
  "type": "CustomLocation"  
},  
"id": "/subscriptions/<subscription>/resourceGroups/<resource group>/providers/Microsoft.Kubernetes/connectedClusters/aksarc-testupgrade/providers/Microsoft.HybridContainerService/provisionedClusterInstances/default",  
"name": "default",  
"properties": {  
  "agentPoolProfiles": [  
    {  
    }  
  ],  
  "controlPlane": {  
    "availabilityZones": null,  
    "controlPlaneEndpoint": {  
      "hostIp": null,  
      "port": null  
    },  
    "count": 1,  
    "linuxProfile": {  
      "ssh": {  
        "publicKeys": null  
      }  
    },  
    "name": null,  
    "nodeImageVersion": null,  
    "osSku": "CBLMariner",  
    "osType": "Linux",  
    "vmSize": "Standard_A4_v2"  
  },  
  "kubernetesVersion": "1.25.7",  
...  
  "provisioningState": "Succeeded",  
  ...  
},  
....  
"type": "microsoft.hybridcontainerservice/provisionedclusterinstances"  
}
```

> [!IMPORTANT]
> When you perform an upgrade from an unsupported version that skips two or more minor versions, the upgrade cannot guarantee proper functionality. If your version is significantly out of date, we recommend you recreate your cluster instead.

## Update Operating System (OS) version

Updating worker nodes to a newer version of the node image without changing the Kubernetes version only works if the new image does not require a different Kubernetes version. Currently, AKS Arc does not support node-image-only updates across all the Kubernetes versions in support. If you need to update the node image, you must upgrade the cluster to the latest Kubernetes version to ensure that all node image updates are incorporated.

> [!IMPORTANT]
> When attempting to use the `node-image-only` flag, you receive a message indicating that this feature is not yet supported.

## Next steps

- [What's new in AKS on Azure Stack HCI](aks-preview-overview.md)
- [Create AKS clusters](aks-create-clusters-cli.md)
