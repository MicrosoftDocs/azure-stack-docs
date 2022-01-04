---
title: Tutorial - Scale an application in Azure Kubernetes Service on Azure Stack HCI
description: In this tutorial, learn how to scale nodes and pods in Kubernetes
services: container-service
ms.topic: tutorial
ms.date: 04/13/2021
ms.author: jeguan
author: jeguan
---

# Tutorial: Scale applications in Azure Kubernetes Service on Azure Stack HCI

If you've followed the tutorials, you have a working Kubernetes cluster in AKS on Azure Stack HCI and you deployed the sample Azure Voting app. In this tutorial, part five of seven, you scale out the pods in the app. You learn how to:

> [!div class="checklist"]
> * Scale the Kubernetes nodes
> * Manually scale Kubernetes pods that run your application

In later tutorials, the Azure Vote application is updated to a new version.

## Before you begin

In previous tutorials, an application was packaged into a container image. This image was uploaded to Azure Container Registry, and you created an AKS on Azure Stack HCI cluster. The application was then deployed to the AKS cluster. If you haven't done these steps, and would like to follow along, start with [Tutorial 1 – Create container images](tutorial-kubernetes-prepare-application.md).


## Manually scale pods

When the Azure Vote front-end and Redis instance were deployed in previous tutorials, a single replica was created. To see the number and state of pods in your cluster, use the [kubectl get][kubectl-get] command as follows:

```console
kubectl get pods
```

The following example output shows one front-end pod and one back-end pod:

```output
NAME                               READY     STATUS    RESTARTS   AGE
azure-vote-back-2549686872-4d2r5   1/1       Running   0          31m
azure-vote-front-848767080-tf34m   1/1       Running   0          31m
```

To manually change the number of pods in the *azure-vote-front* deployment, use the [kubectl scale][kubectl-scale] command. The following example increases the number of front-end pods to *5*:

```console
kubectl scale --replicas=5 deployment/azure-vote-front
```

Run [kubectl get pods][kubectl-get] again to verify that the command successfully created the additional pods. After a minute or so, the pods are available in your cluster:

```console
kubectl get pods

                                    READY     STATUS    RESTARTS   AGE
azure-vote-back-2606967446-nmpcf    1/1       Running   0          15m
azure-vote-front-3309479140-2hfh0   1/1       Running   0          3m
azure-vote-front-3309479140-bzt05   1/1       Running   0          3m
azure-vote-front-3309479140-fvcvm   1/1       Running   0          3m
azure-vote-front-3309479140-hrbf2   1/1       Running   0          15m
azure-vote-front-3309479140-qphz8   1/1       Running   0          3m
```

## Scale the worker nodes in the node pool

If you created your Kubernetes cluster using the commands in the previous tutorial, your deployment has a cluster called *mycluster* with one Linux node pool called *linuxnodepool* with a node count of 1. 

Use the [Set-AksHciNodePool](./reference/ps/set-akshcinodepool.md) command to scale the node pool. The following example scales the node pool from 1 to 3 Linux nodes.

```powershell
Set-AksHciNodePool -clusterName mycluster -name linuxnodepool -count 3
``` 

If you want to scale the control plane nodes, use the [Set-AksHciCluster](./reference/ps/set-akshcicluster.md) command.

> [!NOTE]
> In previous versions of AKS on Azure Stack HCI, the [Set-AksHciCluster](/azure-stack/aks-hci/reference/ps/set-akshcicluster) command was also used to scale worker nodes. AKS on Azure Stack HCI is introducing node pools in workload clusters now, so this command can only be used to scale worker nodes if your cluster was created with the old parameter set in [New-AksHciCluster](/azure-stack/aks-hci/reference/ps/new-akshcicluster). To scale worker nodes in a node pool, use the [Set-AksHciNodePool](/azure-stack/aks-hci/reference/ps/set-akshcinodepool) command.

Run the following command to confirm that scaling was successful.

```powershell
Get-AksHciNodePool -clusterName mycluster
```

**Output**
```
ClusterName  : mycluster
NodePoolName : linuxnodepool
Version      : v1.20.7
OsType       : Linux
NodeCount    : 3
VmSize       : Standard_K8S3_v1
Phase        : Deployed
```

## Next steps

In this tutorial, you used different scaling features in your AKS on Azure Stack HCI cluster. You learned how to:

> [!div class="checklist"]
> * Manually scale Kubernetes pods that run your application
> * Manually scale the Kubernetes nodes

Advance to the next tutorial to learn how to update application in Kubrnetes.

> [!div class="nextstepaction"]
> [Update an application in Kubernetes](./tutorial-kubernetes-app-update.md)

<!-- LINKS - external -->
[kubectl-autoscale]: https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#autoscale
[kubectl-get]: https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#get
[kubectl-scale]: https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#scale
[kubernetes-hpa]: https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/
[metrics-server-github]: https://github.com/kubernetes-sigs/metrics-server/blob/master/README.md#deployment
[metrics-server]: https://kubernetes.io/docs/tasks/debug-application-cluster/resource-metrics-pipeline/#metrics-server

<!-- LINKS - internal -->