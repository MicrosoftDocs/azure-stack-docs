---
title: Troubleshoot deleted workload cluster resources can't be deleted
description: Learn how to troubleshoot when deleted workload cluster resources can't be deleted.
ms.topic: troubleshooting
author: sethmanheim
ms.author: sethm
ms.date: 11/18/2024
ms.reviewer: leslielin

---

# Workload cluster with PodDisruptionBudget (PDB) resources can't be fully removed

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

When you delete a workload cluster that has [PodDisruptionBudget](https://kubernetes.io/docs/tasks/run-application/configure-pdb/) (PDB) resources, the deletion might fail to remove the PDB resources. By default, PDB is installed in the Workload Identity-enabled AKS Arc cluster.

## Workaround

Before you delete the AKS Arc cluster, access the target cluster's **kubeconfig** and delete the PDB:

1. Access the target cluster:

   ```azurecli
   az connectedk8s proxy -n $aks_cluster_name -g $resource_group_name 
   ```

1. Verify PDB:

   ```bash
   kubectl get pdb -A 
   ```

1. Delete PDB:

    ```bash
    kubectl delete pdb azure-wi-webhook-controller-manager -n arc-workload-identity 
    ```

1. Delete cluster:

    ```azurecli
    az aksarc delete -n $aks_cluster_name -g $resource_group_name
    ```

## Next steps

[Known issues in AKS enabled by Azure Arc](aks-known-issues.md)
