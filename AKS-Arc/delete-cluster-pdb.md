---
title: Troubleshoot deleted workload cluster resources can't be deleted
description: Learn how to troubleshoot when deleted workload cluster resources can't be deleted.
ms.topic: troubleshooting
author: sethmanheim
ms.author: sethm
ms.date: 04/01/2025
ms.reviewer: leslielin

---

# Can't fully delete AKS Arc cluster with PodDisruptionBudget (PDB) resources

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)], AKS Edge Essentials

When you delete an AKS Arc cluster that has [PodDisruptionBudget](https://kubernetes.io/docs/tasks/run-application/configure-pdb/) (PDB) resources, the deletion might fail to remove the PDB resources. By default, PDB is installed in the workload identity-enabled AKS Arc cluster.

## Mitigation

This issue was fixed in [AKS on Azure Local, version 2503](aks-whats-new-23h2.md#release-2503).

- **For deleting an AKS cluster** with a PodDisruptionBudget: If you're on an older build, please update to Azure Local, version 2503. Once you update to 2503, you can retry deleting the AKS cluster. File a support case if you're on the 2503 release and your AKS cluster is not deleted after at least one retry.
- **For deleting a nodepool** with a PodDisruptionBudget: By design, the nodepool isn't deleted if a PodDisruptionBudget exists, to protect applications. Use the following workaround to delete the PDB resources and then retry deleting the nodepool.


## Workaround for AKS Edge Essentials and older versions of AKS on Azure Local

Before you delete the AKS Arc cluster, access the AKS Arc cluster's **kubeconfig** and delete all PDBs:

1. Access the AKS Arc cluster according to its connectivity state:

   - When the AKS Arc cluster is in a **Connected** state, run the [`az connectedk8s proxy`](/cli/azure/connectedk8s#az-connectedk8s-proxy) command

     ```azurecli
     az connectedk8s proxy -n $aks_cluster_name -g $resource_group_name 
     ```
   
   - When the AKS Arc cluster is in a **disconnected** state, run the [`az aksarc get-credentials`](/cli/azure/aksarc#az-aksarc-get-credentials) command with permission to perform the **Microsoft.HybridContainerService/provisionedClusterInstances/listAdminKubeconfig/action** action, which is included in the **Azure Kubernetes Service Arc Cluster Admin** role permission. For more information, see [Retrieve certificate-based admin kubeconfig in AKS Arc](retrieve-admin-kubeconfig.md#retrieve-the-certificate-based-admin-kubeconfig-using-az-cli).

     ```azurecli
     az aksarc get-credentials -n $aks_cluster_name -g $resource_group_name --admin
     ```

1. Verify PDB:

   ```bash
   kubectl get pdb -A 
   ```

1. Delete all PDBs. The following command is an example of deleting a PDB generated from workload identity enablement:

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
