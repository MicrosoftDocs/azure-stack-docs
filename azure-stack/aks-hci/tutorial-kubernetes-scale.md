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

In previous tutorials, an application was packaged into a container image. This image was uploaded to Azure Container Registry, and you created an AKS on Azure Stack HCI cluster. The application was then deployed to the AKS cluster. If you haven't done these steps, and would like to follow along, start with [Tutorial 1 – Create container images](tutorial-kubernetes-prepare-app.md).


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

## Manually scale Azure Kubernetes Service on Azure Stack HCI nodes

If you created your Kubernetes cluster using the commands in the previous tutorial, it has one Linux node. You can adjust the number of nodes manually if you plan more or fewer container workloads on your cluster.

The following example increases the number of Linux nodes to three and Windows nodes to one in the Kubernetes cluster named *mycluster*. The command takes a couple of minutes to complete. You must scale control plane nodes and worker nodes separately. 

```powershell
Set-AksHciCluster -name mycluster -linuxNodeCount 3 -windowsNodeCount 1
```

Run the following command to confirm that scaling was succesful.

```powershell
Get-AksHciCluster -name mycluster
```

**Output**
```
Name            : mycluster
Version         : v1.18.14
Control Planes  : 1
Linux Workers   : 3
Windows Workers : 1
Phase           : provisioned
Ready           : True
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
