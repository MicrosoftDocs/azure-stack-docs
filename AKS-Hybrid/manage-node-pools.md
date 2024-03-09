---
title: Manage node pools for a cluster (AKS on Azure Stack HCI 23H2)
description: Learn how to manage multiple node pools in AKS enabled by Azure Arc (AKS on Azure Stack HCI 23H2).
ms.topic: how-to
ms.custom: devx-track-azurecli
ms.date: 01/31/2024
author: sethmanheim
ms.author: sethm 
ms.reviewer: rbaziwane
ms.lastreviewed: 01/30/2024

---

# Manage node pools for a cluster (AKS on Azure Stack HCI 23H2)

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

> [!NOTE]
> For information about managing node pools in AKS on Azure Stack HCI 22H2, see [Manage node pools](manage-node-pools-22h2.md).

In AKS enabled by Azure Arc, nodes of the same configuration are grouped together into *node pools*. These node pools contain the underlying VMs that run your applications. This article shows you how to create and manage node pools for a cluster in AKS Arc.

## Create a Kubernetes cluster

To get started, create a Kubernetes cluster with a single node pool:

```azurecli
az aksarc create -n <cluster name> -g <resource group> --custom-location <custom location Id> --vnet-ids <vnet id> --generate-ssh-keys --load-balancer-count <load balancer count>
```

## Add a node pool

You can add a node pool to an existing cluster using the [`az aksarc nodepool add`](/cli/azure/aksarc/nodepool#az-aksarc-nodepool-add) command. Make sure that the name of the node pool is not the same name as an existing node pool:

```azurecli
az aksarc nodepool add --name <node pool name> -g <resource group> --cluster-name <cluster name> --os-sku <Linux or Windows> --node-count <count> --node-vm-size <vm size>
```

## Get configuration information for a node pool

To see the configuration of your node pools, use the [`az aksarc nodepool show`](/cli/azure/aksarc/nodepool#az-aksarc-nodepool-show) command:

```azurecli
az aksarc nodepool show --cluster-name <cluster name> -n <node pool name> -g <resource group>
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

## Specify maximum pods deployed to a node pool

You can configure the maximum pods deployable to a node at cluster creation time, or when creating new node pools. If you don't specify `maxPods` when you create node pools, your node pool is deployed with a default value of a maximum 110 pods:

```azurecli
az aksarc nodepool add --cluster-name <cluster name> -n <node pool name> -g <resource group> --max-pods 50 --yes
```

## Scale a node pool

You can scale the number of nodes up or down in a node pool.

To scale the number of nodes in a node pool, use the [`az aksarc nodepool scale`](/cli/azure/aksarc/nodepool#az-aksarc-nodepool-scale) command. The following example scales the number of
nodes to 2 in a node pool named `nodepool1`:

```azurecli
az aksarc nodepool scale --cluster-name <cluster name> -n nodepool1 -g <resource group> --node-count 2 --yes
```

## Delete a node pool

If you need to delete a node pool, use the [`az aksarc nodepool delete`](/cli/azure/aksarc/nodepool#az-aksarc-nodepool-delete) command:

```azurecli
az aksarc nodepool delete --cluster-name <cluster name> -n <node pool name> -g <resource group> --yes
```

## Specify a taint or label for a node pool

When you create a node pool, you can add taints or labels to it. When you add a taint or label, all nodes within that node pool also get that taint, or label.

> [!IMPORTANT]
> You should add taints or labels to nodes for the entire node pool using `az aksarc nodepool`. We don't recommend using `kubectl` to apply taints or labels to individual nodes in a node pool.

### Set node pool taints

1. Create a node pool with a taint using the [`az aksarc nodepool add`](/cli/azure/aksarc/nodepool#az-aksarc-nodepool-add) command. Specify the name `taintnp` and use the `--node-taints` parameter to specify `sku=gpu:NoSchedule` for the taint:

    ```azurecli
    az aksarc nodepool add \
        --resource-group myResourceGroup \
        --cluster-name myAKSCluster \
        --name taintnp \
        --node-count 1 \
        --node-taints sku=gpu:NoSchedule \
        --no-wait
    ```

1. Check the status of the node pool using the [`az aksarc nodepool list`](/cli/azure/aksarc/nodepool#az-aksarc-nodepool-list) command:

    ```azurecli
    az aksarc nodepool list -g myResourceGroup --cluster-name myAKSCluster
    ```

    The following example output shows that the `taintnp` node pool creates nodes with the specified `nodeTaints`:

    ```output
    [
      {
        ...
        "count": 1,
        ...
        "name": "taintnp",
        ...
        "provisioningState": "Succeeded",
        ...
        "nodeTaints":  [
          "sku=gpu:NoSchedule"
        ],
        ...
      },
     ...
    ]
    ```

The taint information is visible in Kubernetes for handling scheduling rules for nodes. The Kubernetes scheduler can use taints and tolerations to restrict which workloads can run on nodes.

- A *taint* is applied to a node that indicates only specific pods can be scheduled on them.
- A *toleration* is then applied to a pod that allows them to "tolerate" a node's taint.

### Set node pool tolerations

In the previous step, you applied the `sku=gpu:NoSchedule` taint when you created the node pool. The following example YAML manifest uses a toleration to allow the Kubernetes scheduler to run an NGINX pod on a node in that node pool:

1. Create a file named **nginx-toleration.yaml** and copy/paste the following example YAML:

    ```yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: mypod
    spec:
      containers:
      - image: mcr.microsoft.com/oss/nginx/nginx:1.15.9-alpine
        name: mypod
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 1
            memory: 2G
      tolerations:
      - key: "sku"
        operator: "Equal"
        value: "gpu"
        effect: "NoSchedule"
    ```

1. Schedule the pod using the `kubectl apply` command:

    ```azurecli
    kubectl apply -f nginx-toleration.yaml
    ```

    It takes a few seconds to schedule the pod and pull the NGINX image.

1. Check the status using the [`kubectl describe pod`](https://kubernetes.io/docs/reference/kubectl/generated/kubectl_describe/) command:

    ```azurecli
    kubectl describe pod mypod
    ```

    The following condensed example output shows that the `sku=gpu:NoSchedule` toleration is applied. In the **Events** section, the scheduler assigned the pod to the `moc-lbeof1gn6x3` node:

    ```output
    [...]
    Tolerations:     node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                     node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
                     sku=gpu:NoSchedule
    Events:
      Type    Reason     Age    From                Message
      ----    ------     ----   ----                -------
      Normal  Scheduled  54s  default-scheduler   Successfully assigned default/mypod to moc-lbeof1gn6x3
      Normal  Pulling    53s  kubelet             Pulling image "mcr.microsoft.com/oss/nginx/nginx:1.15.9-alpine"
      Normal  Pulled     48s  kubelet             Successfully pulled image "mcr.microsoft.com/oss/nginx/nginx:1.15.9-alpine" in 3.025148695s (3.025157609s including waiting)
      Normal  Created    48s  kubelet             Created container
      Normal  Started    48s  kubelet             Started container
    ```

    Only pods that have this toleration applied can be scheduled on nodes in `taintnp`. Any other pods are scheduled in the **nodepool1** node pool. If you create more node pools, you can use taints and tolerations to limit what pods can be scheduled on those node resources.

### Setting node pool labels

For more information, see [Use labels in an Azure Arc enabled AKS cluster](cluster-labels.md).
::: zone-end

## Next steps

- [Manage node pools (AKS on Azure Stack HCI 22H2)](manage-node-pools-22h2.md)
- [Review AKS on Azure Stack HCI 23H2 prerequisites](aks-hci-network-system-requirements.md)
- [What's new in AKS on Azure Stack HCI](/azure-stack/hci/whats-new)
