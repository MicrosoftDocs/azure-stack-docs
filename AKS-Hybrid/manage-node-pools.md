---
title: Manage multiple node pools in AKS Arc (preview)
description: Learn how to manage multiple node pools in AKS enabled by Azure Arc.
ms.topic: how-to
ms.date: 12/12/2023
author: sethmanheim
ms.author: sethm 
ms.reviewer: rbaziwane
ms.lastreviewed: 12/11/2023

---

# Manage multiple node pools in AKS Arc

In AKS Arc, nodes of the same configuration are grouped together into *node pools*. These node pools contain the underlying VMs that run
your applications. This article shows you how to create and manage multiple node pools in an AKS cluster in AKS Arc.

## Create an AKS cluster

To get started, create an AKS cluster with a single node pool:

```azurecli
az akshybrid create -n <cluster name> -g <resource group> --custom-location <custom location Id> --vnet-ids <vnet id> --generate-ssh-keys --load-balancer-count <load balancer count>
```

## Add a node pool

You can add a node pool to an existing cluster using the `az akshybrid nodepool add` command. Make sure that the name of the node pool is not
the same name as any existing node pool.

```azurecli
az akshybrid nodepool add --name <node pool name> -g <resource group> --cluster-name <cluster name> --os-sku <Linux or Windows> --node-count <count> --node-vm-size <vm size>
```

## Get configuration information of a node pool

To see the configuration information of your node pools, use the `az akshybrid nodepool show` command.

```azurecli
az akshybrid nodepool show --cluster-name <cluster name> -n <node pool name> -g <resource group>
```

Example output:

```output
{
"availabilityZones": null,
"count": 1,
"extendedLocation": null,
"id":
"/subscriptions/&lt;subscription&gt;/resourceGroups/edgeci-registration-rr1s46r1710&lt;resource
group&gt;/providers/Microsoft.Kubernetes/connectedClusters/&lt;cluster
name&gt;/providers/Microsoft.HybridContainerService/provisionedClusterInstances/default/agentPools/&lt;nodepoolname&gt;",
"location": "westeurope",
"name": "nodepoolname",
"nodeImageVersion": null,
"osSku": "CBLMariner",
"osType": "Linux",
"provisioningState": "Succeeded",
"resourceGroup": "resourcegroup",
"status": {
  "errorMessage": null,
  "operationStatus": null,
  "readyReplicas": [
   {
    "count": 1,
    "vmSize": "Standard\_A4\_v2"
   }
  ]
},
"systemData": {
…
},
"tags": null,
"type":
"microsoft.hybridcontainerservice/provisionedclusterinstances/agentpools",
"vmSize": "Standard\_A4\_v2"
}
```

## Scale a node pool

You can scale the number of nodes up or down in a node pool.

To scale the number of nodes in a node pool, use the `az akshybrid nodepool scale` command. The following example scales the number of
nodes to 2 in a node pool named `nodepool1`:

```azurecli
az akshybrid nodepool scale --cluster-name <cluster name> -n nodepool1 -g <resource group> --node-count 2 --yes
```

## Delete a node pool

If you need to delete a node pool, use the `az akshybrid nodepool delete` command:

```azurecli
az akshybrid nodepool delete --cluster-name <cluster name> -n <node pool name> -g <resource group> --yes
```

## Next steps

- [Review AKS on Azure Stack HCI 23H2 prerequisites](aks-hci-network-system-requirements.md)
- [What's new in AKS on Azure Stack HCI](aks-preview-overview.md)
