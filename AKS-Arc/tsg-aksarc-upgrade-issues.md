---
title: Troubleshoot the issue where the cluster is stuck in Upgrading state
description: Learn how to troubleshoot and mitigate the issue when an AKS enabled by Arc cluster is stuck in 'Upgrading' state.
ms.topic: troubleshooting
author: rcheeran
ms.author: rcheeran
ms.date: 06/25/2025
ms.reviewer: abha

---

# Troubleshoot the issue when the AKS Arc cluster is stuck in 'Upgrading' state

This article describes how to fix the issue when your Azure Kubernetes Service enabled by Arc (AKS Arc) cluster is stuck in 'Upgrading' state. This issue typically occurs after updating Azure Local to version 2503 or 2504 and when you try to upgrade the Kubernetes version on your cluster.

## Symptoms

When you try to upgrade an AKS Arc cluster, you notice that the **Current state** property of the cluster remains in the 'Upgrading' state.

```output
az aksarc upgrade --name "cluster-name" --resource-group "rg-name"

===> Kubernetes may be unavailable during cluster upgrades.
 Are you sure you want to perform this operation? (y/N): y
The cluster is on version 1.28.9 and is not in a failed state. 

===> This will upgrade the control plane AND all nodepools to version 1.30.4. Continue? (y/N): y
Upgrading the AKSArc cluster. This operation might take a while...
{
  "extendedLocation": {
    "name": "/subscriptions/resourceGroups/Bellevue/providers/Microsoft.ExtendedLocation/customLocations/bel-CL",
    "type": "CustomLocation"
  },
  "id": "/subscriptions/fbaf508b-cb61-4383-9cda-a42bfa0c7bc9/resourceGroups/Bellevue/providers/Microsoft.Kubernetes/ConnectedClusters/Bel-cluster/providers/Microsoft.HybridContainerService/ProvisionedClusterInstances/default",
  "name": "default",
  "properties": {
 "kubernetesVersion": "1.30.4",
 "provisioningState": "Succeeded",
 "currentState": "Upgrading",
    "errorMessage": null,
    "operationStatus": null
    "agentPoolProfiles": [
      {
        ...
```

## Possible causes and follow-ups

- The root cause is a recent change introduced in Azure Local version 2503. Under certain conditions, if there are transient or intermittent failures during the Kubernetes upgrade process, they're not correctly detected or recovered from. This can cause the cluster state to stay stuck in the 'Upgrading' state.
- You hit this issue if the AKS Arc extension on your custom location - the `hybridaksextension` extension's version is 2.1.211 or 2.1.223. You can run the following command to check the extension version on your cluster:

```azurecli
az login --use-device-code --tenant <Azure tenant ID> 
az account set -s <subscription ID> 
$res=get-archcimgmt
az k8s-extension show -g $res.HybridaksExtension.resourceGroup -c $res.ResourceBridge.name --cluster-type appliances --name hybridaksextension
```

## Mitigation

This issue can be resolved by invoking the AKS Arc update command. The `update` command retriggers the upgrade flow. You can invoke the `aksarc update` command with placeholder parameters, which do not impact the state of the cluster. So in this case, you could invoke the update call to enable NFS or SMB drivers if those features aren't already enabled. First, check if any of the storage drivers are already enabled:

```azurecli
az login --use-device-code --tenant <Azure tenant ID> 
az account set -s <subscription ID> 
az aksarc show -g <resource_group_name> -n <cluster_name>
```

Check the storage profile section:

```json
"storageProfile": {  
     "nfsCsiDriver": {  
       "enabled": false
     },  
     "smbCsiDriver": {  

       "enabled": true  
     }  
   }
```

If one of the drivers is disabled, you can enable it using the following command:

```azurecli
az aksarc update --enable-smb-driver -g <resource_group_name> -n <cluster_name>
az aksarc update --enable-nfs-driver -g <resource_group_name> -n <cluster_name>
```

Running the `aksarc update` command should resolve the issue and the `Current state` parameter of the cluster should now show as 'Succeeded'. Once the status is updated, if you don't want to retain the drivers as enabled, you can revert this action by running the following command

```azurecli
az aksarc update --disable-smb-driver -g <resource_group_name> -n <cluster_name>
az aksarc update --disable-nfs-driver -g <resource_group_name> -n <cluster_name>
```

If both drivers are already enabled on your cluster, you can disable the one that is not in use. If you require both drivers to remain enabled, contact Microsoft Support for further assistance.

## Verification

Run the following command and check that the **Current State** parameter in the JSON output is set to 'Succeeded' to confirm the K8s version upgrade is complete.

```azurecli
az aksarc show -g <resource_group> -n <cluster_name>

```

## Contact Microsoft Support

If the problem persists, collect the following information before [creating a support request](aks-troubleshoot.md#open-a-support-request). Collect [AKS cluster logs](get-on-demand-logs.md) before creating the support request.

## Next steps

- [Use the diagnostic checker tool to identify common environment issues](aks-arc-diagnostic-checker.md)
- [Review AKS on Azure Local architecture](cluster-architecture.md)
