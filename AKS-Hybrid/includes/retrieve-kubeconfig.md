---
author: sethmanheim
ms.author: sethm
ms.service: azure-stack
ms.topic: include
ms.date: 05/20/2024
ms.lastreviewed: 01/22/2024
ms.reviewer: sulahiri

# Common content between AKS Arc and AKS on VMware

---

## Get certificate-based admin kubeconfig

An AKS, enabled by Azure Arc cluster administrator can retrieve the certificate-based admin kubeconfig using the following command. 

### Before you begin
- You need the Azure CLI installed and configured. If you need to install or upgrade, see [Install Azure CLI](/cli/azure/install-azure-cli). You also need `kubectl`.
- Install the latest version of the `aksarc` Azure CLI extension:

  ```azurecli
  az extension add --name aksarc
  ```

  If you've already installed the `aksarc` extension, update the extension to the latest version:

  ```azurecli
  az extension update --name aksarc
  ```
  
- To run the Azure CLI command, you must have the `Azure Kubernetes Service Arc Cluster Admin` role, or **Microsoft.HybridContainerService/provisionedClusterInstances/listAdminKubeconfig/action** action on the Kubernetes cluster.
- In order to retrieve, and use the certificate based admin Kubeconfig, you need to have direct line of sight to your AKS cluster. Run the following commands on the physical machine, or a jumbox that has access to the physical machines on which your AKS cluster is running.

### Retrieve the certificate-based admin kubeconfig using Az CLI

You can retrive the kubeconfig of your AKS cluster using the [`az aksarc get-credentials`][/cli/azure/aksarc#az-aksarc-get-credentials] command.

```azurecli
az aksarc get-credentials --resource-group myResourceGroup --name myAKSCluster --admin
```

Now, you can use `kubectl` to manage your Kubernetes cluster. For example, you can list the nodes in your cluster using `kubectl get nodes`. 

```azurecli
kubectl get nodes
```

Expected output:

```output
NAME             STATUS ROLES                AGE VERSION
moc-l0ttdmaioew  Ready  control-plane,master 34m v1.24.11
moc-ls38tngowsl  Ready  <none>               32m v1.24.11
```
  
