---
title: Troubleshoot deleted workload cluster resources can't be deleted
description: Learn how to troubleshoot when deleted workload cluster resources can't be deleted.
ms.topic: troubleshooting
author: sethmanheim
ms.author: sethm
ms.date: 12/12/2024
ms.reviewer: leslielin

---

# Can't fully delete AKS Arc cluster with PodDisruptionBudget (PDB) resources

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)], AKS Edge Essentials

When you delete an AKS Arc cluster that has [PodDisruptionBudget](https://kubernetes.io/docs/tasks/run-application/configure-pdb/) (PDB) resources, the deletion might fail to remove the PDB resources. By default, PDB is installed in the workload identity-enabled AKS Arc cluster.

## Workaround

Before you delete the AKS Arc cluster, access the AKS Arc cluster's **kubeconfig** and delete all PDBs:

1. Access the AKS Arc cluster:
  - When the AKS Arc cluster is in a **Connected** state

   ```azurecli
   az connectedk8s proxy -n $aks_cluster_name -g $resource_group_name 
   ```
   
   - When the AKS Arc cluster is in a **disconnected** state. To run this Azure CLI command, you need the **Microsoft.HybridContainerService/provisionedClusterInstances/listUserKubeconfig/action**, which is included in the **Azure Kubernetes Service Arc Cluster User** role permission:
   ```azurecli
   az aksarc get-credentials -g "$resource_group_name" -n $aks_cluster_name --file <file-name>
   ```
1. Verify PDB:

   ```bash
   kubectl get pdb -A 
   ```

1. Delete all PDBs. Here's an example of deleting a PDB generated from workload identity enablement:

    ```bash
    kubectl delete pdb azure-wi-webhook-controller-manager -n arc-workload-identity 
    ```

### [AKS on Azure Local](#tab/aks-on-azure-local)

4. Delete the AKS Arc cluster:

    ```azurecli
    az aksarc delete -n $aks_cluster_name -g $resource_group_name
    ```

### [AKS Edge Essentials](#tab/aks-edge-essentials)

4. Delete the AKS Arc cluster:

    ```azurecli
    az connectedk8s delete -n <cluster_name> -g <resource_group>
    ```

---

## Next steps

[Known issues in AKS enabled by Azure Arc](aks-known-issues.md)
