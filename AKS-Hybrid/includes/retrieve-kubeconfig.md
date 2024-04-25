---
author: sethmanheim
ms.author: sethm
ms.service: azure-stack
ms.topic: include
ms.date: 03/20/2024
ms.lastreviewed: 01/22/2024
ms.reviewer: sulahiri

# Common content between AKS Arc and AKS on VMware

---

## Get admin certificate-based kubeconfig

An Arc-enabled Kubernetes cluster admin can retrieve the certificate-based admin kubeconfig using the following command. To run the Azure CLI command, you must have "contributor," "owner," and "Azure Kubernetes Service Hybrid Cluster Admin Role" permissions on the cluster. You must also have the **Microsoft.HybridContainerService/provisionedClusterInstances/listAdminKubeconfig/action** action on the cluster, which is pre-configured in the following built-in role.

```azurecli
az aksarc get-credentials --name 
                       --resource-group 
                       [--admin] 
                       [--context] 
                       [--file] 
                       [--overwrite-existing]
```

| Parameter          | Description                                                                                                                                          |
|--------------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
| `--name`           | Name of the Arc-enabled AKS instance.                                                                                                                |
| `--resource-group` | Name of the resource group.                                                                                                                          |
| `--admin`          | Cluster admin credentials.                                                                                                                           |
| `--context`        | If specified, overwrite the default context name. The `--admin` parameter takes precedence over `--context`.                                         |
| `--file`           | Kubernetes configuration file to update. The default is to add a new admin kubeconfig into the default kubeconfig path, which is **~\.kube\config**. |
| `--overwrite-existing` | Overwrites an existing cluster entry with the same name. The default value is `False`. |

For more information, see the documentation for [`az aksarc`](/cli/azure/aksarc#az-aksarc-get-credentials).
