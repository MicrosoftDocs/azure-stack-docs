---
title: Manage node pools for a cluster
description: Learn how to manage multiple node pools in AKS enabled by Azure Arc.
ms.topic: how-to
ms.custom: devx-track-azurecli
ms.date: 01/31/2024
author: sethmanheim
ms.author: sethm 
ms.reviewer: rbaziwane
ms.lastreviewed: 01/30/2024
zone_pivot_groups: version-select
---

# Manage node pools for a cluster

In AKS enabled by Azure Arc, nodes of the same configuration are grouped together into *node pools*. These node pools contain the underlying VMs that run your applications. This article shows you how to create and manage node pools for a cluster in AKS Arc.

::: zone pivot="aks-23h2"
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

::: zone pivot="aks-22h2"
> [!NOTE]
> This feature enables higher control over how to create and manage multiple node pools. As a result, separate commands are required for create, update, and delete operations. Previously, cluster operations through [New-AksHciCluster](./reference/ps/new-akshcicluster.md) or [Set-AksHciCluster](./reference/ps/set-akshcicluster.md) were the only option to create or scale a cluster with one Windows node pool and one Linux node pool. This feature exposes a separate operation set for node pools that require the use of the node pool commands [New-AksHciNodePool](./reference/ps/new-akshcinodepool.md), [Set-AksHciNodePool](./reference/ps/set-akshcinodepool.md), [Get-AksHciNodePool](./reference/ps/get-akshcinodepool.md), and [Remove-AksHciNodePool](./reference/ps/remove-akshcinodepool.md) to execute operations on an individual node pool. 

## Before you begin

We recommend that you install version 1.1.6. If you already have the PowerShell module installed, run the following command to find the version:

```powershell
Get-Command -Module AksHci
```

If you need to update PowerShell, following the instructions in [Upgrade the AKS host](update-akshci-host-powershell.md).

## Create an AKS cluster

To get started, create an AKS cluster with a single node pool. The following example uses the [New-AksHciCluster](./reference/ps/new-akshcicluster.md) command to create a new Kubernetes cluster with one Linux node pool named *linuxnodepool*, which has 1 node. **If you already have a cluster deployed with an older version of AKS, and you wish to continue using your old deployment, you can skip this step. You can still use the new set of node pool commands to add more node pool to your existing cluster.**

```powershell
New-AksHciCluster -name mycluster -nodePoolName linuxnodepool -nodeCount 1 -osType linux
```

> [!NOTE]
> The old parameter set for `New-AksHciCluster` is still supported.

## Add a node pool

The cluster named `mycluster`*`, created in the previous step, has a single node pool. You can add a second node pool to the existing cluster using the [New-AksHciNodePool](./reference/ps/new-akshcinodepool.md) command. The following example creates a Windows node pool named **windowsnodepool** with one node. Make sure that the name of the node pool is not the same name as any existing node pool.

```powershell
New-AksHciNodePool -clusterName mycluster -name windowsnodepool -count 1 -osType Windows -osSku Windows2022
```

## Get configuration information of a node pool

To see the configuration information of your node pools, use the [Get-AksHciNodePool](./reference/ps/get-akshcinodepool.md) command.

```powershell
Get-AksHciNodePool -clusterName mycluster
```

Example output:

```output
ClusterName  : mycluster
NodePoolName : linuxnodepool
Version      : v1.20.7
OsType       : Linux
NodeCount    : 1
VmSize       : Standard_K8S3_v1
Phase        : Deployed

ClusterName  : mycluster
NodePoolName : windowsnodepool
Version      : v1.20.7
OsType       : Windows
NodeCount    : 1
VmSize       : Standard_K8S3_v1
Phase        : Deployed
```

To see the configuration information of one specific node pool, use the `-name` parameter in [Get-AksHciNodePool](./reference/ps/get-akshcinodepool.md).

```powershell
Get-AksHciNodePool -clusterName mycluster -name linuxnodepool
```

Example output:

```output
ClusterName  : mycluster
NodePoolName : linuxnodepool
Version      : v1.20.7
OsType       : Linux
NodeCount    : 1
VmSize       : Standard_K8S3_v1
Phase        : Deployed
```

```powershell
Get-AksHciNodePool -clusterName mycluster -name windowsnodepool
```

Example output:

```output
ClusterName  : mycluster
NodePoolName : windowsnodepool
Version      : v1.20.7
OsType       : Windows
NodeCount    : 1
VmSize       : Standard_K8S3_v1
Phase        : Deployed
```

> [!NOTE]
> If you use the new parameter sets in `New-AksHciCluster` to deploy a cluster and then run `Get-AksHciCluster` to get the cluster information, the fields `WindowsNodeCount` and `LinuxNodeCount` in the output will return `0`. To get the accurate number of nodes in each node pool, use the command `Get-AksHciNodePool` with the specified cluster name.

## Scale a node pool

You can scale the number of nodes up or down in a node pool.

To scale the number of nodes in a node pool, use the [Set-AksHciNodePool](./reference/ps/set-akshcinodepool.md) command. The following example scales the number of nodes to 3 in a node pool named `linuxnodepool` in the `mycluster` cluster.

```powershell
Set-AksHciNodePool -clusterName mycluster -name linuxnodepool -count 3
```

## Scale control plane nodes

Management of control plane nodes hasn't changed. The way in which they are created, scaled, and removed remains the same. You will still deploy control plane nodes with the [New-AksHciCluster](./reference/ps/new-akshcicluster.md) command with the parameters `controlPlaneNodeCount` and `controlPlaneVmSize` with the default values of 1 and Standard_A4_V2, respectively, if you don't provide any values.

You may need to scale the control plane nodes as the workload demand of your applications change. To scale the control plane nodes, use the [Set-AksHciCluster](./reference/ps/set-akshcicluster.md) command. The following example scales the control plane nodes to 3 in `mycluster` cluster, which was created in the previous steps.

```powershell
Set-AksHciCluster -name mycluster -controlPlaneNodeCount 3
```

## Delete a node pool

If you need to delete a node pool, use the [Remove-AksHciNodePool](./reference/ps/remove-akshcinodepool.md) command. The following example removes the node pool named `windowsnodepool` from the `mycluster` cluster.

```powershell
Remove-AksHciNodePool -clusterName mycluster -name windowsnodepool
```

## Specify a taint for a node pool

When creating a node pool, you can add taints to that node pool. When you add a taint, all nodes within that node pool also get that taint. For more information about taints and tolerations, see [Kubernetes Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/).

### Setting node pool taints

To create a node pool with a taint, use [New-AksHciNodePool](./reference/ps/new-akshcinodepool.md). Specify the name `taintnp`, and use the `-taints` parameter to specify `sku=gpu:noSchedule` for the taint.

```powershell
New-AksHciNodePool -clusterName mycluster -name taintnp -count 1 -osType linux -taints sku=gpu:NoSchedule
```

> [!NOTE]
> A taint can only be set for node pools during node pool creation.

Run the following command to make sure the node pool was successfully deployed with the specified taint.

```powershell
Get-AksHciNodePool -clusterName mycluster -name taintnp
```

**Output**
```
Status       : {Phase, Details}
ClusterName  : mycluster
NodePoolName : taintnp
Version      : v1.20.7-kvapkg.1
OsType       : Linux
NodeCount    : 1
VmSize       : Standard_K8S3_v1
Phase        : Deployed
Taints       : {sku=gpu:NoSchedule}
```

In the previous step, you applied the *sku=gpu:NoSchedule* taint when you created your node pool. The following basic example YAML manifest uses a toleration to allow the Kubernetes scheduler to run an NGINX pod on a node in that node pool.

Create a file named `nginx-toleration.yaml`, and copy the information in the following text.

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

Then, schedule the pod using the following command.

```powershell
kubectl apply -f nginx-toleration.yaml
```

To verify that the pod was deployed, run the following command:

```powershell
kubectl describe pod mypod
```

```Output
[...]
Tolerations:     node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                 node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
                 sku=gpu:NoSchedule
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  32s   default-scheduler  Successfully assigned default/mypod to moc-lk4iodl7h2y
  Normal  Pulling    30s   kubelet            Pulling image "mcr.microsoft.com/oss/nginx/nginx:1.15.9-alpine"
  Normal  Pulled     26s   kubelet            Successfully pulled image "mcr.microsoft.com/oss/nginx/nginx:1.15.9-alpine" in 4.529046457s
  Normal  Created    26s   kubelet            Created container mypod
  ```
::: zone-end

## Next steps

- [Review AKS on Azure Stack HCI 23H2 prerequisites](aks-hci-network-system-requirements.md)
- [What's new in AKS on Azure Stack HCI](aks-preview-overview.md)
