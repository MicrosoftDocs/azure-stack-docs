---
title: Use PowerShell for cluster autoscaling in Azure Kubernetes Services (AKS) on Azure Stack HCI
description: Learn how to use PowerShell for cluster autoscaling in Azure Kubernetes Services (AKS) on Azure Stack HCI.
ms.topic: how-to
author: mattbriggs
ms.author: mabrigg 
ms.lastreviewed: 05/31/2022
ms.reviewer: mikek
ms.date: 05/31/2022

# Intent: As a Kubernetes user, I want to use cluster autoscaler to grow my nodes to keep up with application demand.
# Keyword: cluster autoscaling Kubernetes

---

# Use PowerShell for cluster autoscaling

You can use PowerShell to enable the autoscaler and to manage  automatic scaling of node pools in your target clusters. You can use PowerShell to configure and manage cluster autoscaling.

> [!IMPORTANT]
> Cluster autoscaler is currently in PREVIEW.
> See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

## Create a new AksHciAutoScalerConfig object

Create a new **AksHciAutoScalerConfig** object to pass into the `New-AksHciCluster` or `Set-AksHciCluster` commands.

```powershell 
New-AksHciAutoScalerProfile -Name asp1 -AutoScalerProfileConfig @{ "min-node-count"=2; "max-node-count"=7; 'scale-down-unneeded-time'='1m'}
```

You can provide the **autoscalerconfig** object when creating your cluster. The object contains the parameters for your autoscaler. For more information about the parameters. See [How to use the autoscaler profiles](work-with-autoscaler-profiles.md).

## Change an existing AksHciAutoScalerConfig profile object

Change an existing **AksHciAutoScalerConfig profile** object. Clusters using this object will be updated to use the new parameters. 

```powershell 
Set-AksHciAutoScalerProfile -name myProfile -autoScalerProfileConfig @{ "max-node-count"=5; "min-node-count"=2 }
```

You can update the **autoscalerconfig** object. The object contains the parameters for your autoscaler. For more information about the parameters. See [How to use the autoscaler profiles](work-with-autoscaler-profiles.md).

## Enable autoscaling for new clusters

Set `New-AksHciCluster` and all newly created node pools will have autoscaling enabled upon creation.

```powershell 
New-AksHciCluster -name mycluster -enableAutoScaler -autoScalerProfileName myAutoScalerProfile
```

## Enable autoscaling on an existing cluster

Set `enableAutoScaler` on an existing cluster using `Set-AksHciCluster` and all additionally created node pools will have autoscaling enabled. You must enable autoScaling for existing node pools using `Set-AksHcinode pool`.

```powershell 
Set-AksHciCluster -Name <string> [-enableAutoScaler <boolean>] [-autoScalerProfileName <String>] 
```

## Disable autoscaling

Set `enableAutoScaler` to false on an existing cluster using `Set-AksHciCluster` to disable autoscaling on all existing and newly created node pools.

```powershell 
Set-AksHciCluster -Name <string> -enableAutoScaler $false
```
## Making effective use of the horizontal autoscaler

Now that the cluster and node pool are configured to automatically scale we have to configure a workload to also scale in a way that makes use of the autoscaler capabilities. 
There are two main ways to do that. 

* The Kubernetes horizontal pod autoscaler. Which scales the pods of an application deployment based on load characteristics to the available nodes in the Kubernetes cluster. If there are no more nodes to schedule to the horizontal autoscaler will instantiate a new node for the pods to be scheduled to. If the load goes down the nodes will get scaled back again.
* The Kubernetes Node anti affinity rules. These rules for a Kubernetes Deployment define that a set of Pods in the deployment can't be scaled on the same node and a different node is required to scale the workload. In combination with either load characteristics or number of target pods for the application instances tha horizontal auto scaler will instantiate new nodes in the node pool to satisfy the requests and based on demand also scale the node pool back again when the demand subsides.

Lets look at some examples:

### Horizontal Pod Autoscaler

Prerequisites:

* AKS on Azure Stack HCI is installed
* Target Cluster is installed and connected to Azure
* One Linux Node Pool is deployed with at least one Linux Worker node active
* Horizontal Node Autoscaler is enabled on the target cluster and the Linux node pool per the documentation above.

We'll make use of the [Kubernetes Horizontal Pod Autoscaler Walkthrough Example](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/) to showcase the Horizontal Node Autoscaler.

For the horizontal pod autoscaler to work you'll need to deploy the metrics server component in your target cluster.
This is documented in detail in the [Kubernetes Metrics Server Documentation](https://github.com/kubernetes-sigs/metrics-server#deployment).

Use the following steps to deploy the metrics server to a target cluster called 'mycluster':

```powershell
Get-AksHciCredential -name mycluster
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

Once the Kubernetes Metrics Server is deployed, you'll next deploy an application to the node pool that you can use to scale. We'll use a test application from the Kubernetes community website for this.

```powershell  
kubectl apply -f https://k8s.io/examples/application/php-apache.yaml
deployment.apps/php-apache created
service/php-apache created
```

This will create a deployment of an Apache web server based PHP application that will return an OK message to a calling client.

Next we'll configure the horizontal pod autoscaler to schedule a new pod when the CPU usage of the current pod reaches 50% and scale from 1 to 50 pods.

```powershell
kubectl autoscale deployment php-apache --cpu-percent=50 --min=1 --max=10
horizontalpodautoscaler.autoscaling/php-apache autoscaled
```

You can check the current status of the newly made HorizontalPodAutoscaler, by running:

```powershell

kubectl get hpa
NAME         REFERENCE                     TARGET    MINPODS   MAXPODS   REPLICAS   AGE
php-apache   Deployment/php-apache/scale   0% / 50%  1         10        1          18s
```

Now last but not least lets increase the load on the web server to see it scale out. Open a new PowerShell Window and run the following command:

```powershell
kubectl run -i --tty load-generator --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://php-apache; done"
```

If you go back to the other window and run the below, within a short period you should see the number of pods change from the below to 

```powershell
kubectl get hpa php-apache --watch

NAME         REFERENCE                     TARGET      MINPODS   MAXPODS   REPLICAS   AGE
php-apache   Deployment/php-apache/scale   305% / 50%  1         10        1          3m
```
within a short period you should see the number of pods change from the below to 

```powershell
NAME         REFERENCE                     TARGET      MINPODS   MAXPODS   REPLICAS   AGE
php-apache   Deployment/php-apache/scale   305% / 50%  1         10        7          3m
```

Now this still might not be enough to trigger the node autoscaler because all of these pods might fit on one node of course. You might have to open a few more PowerShell windows and run more of the load generator commands. Make sure to change the name of the pod you're creating every time you're running the command that is: from load-generator to load-generator-2 

```powershell
kubectl run -i --tty load-generator-2 --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://php-apache; done"
```

then check the number of nodes instantiated with the following command.

```powershell
kubectl get nodes
NAME              STATUS   ROLES                  AGE    VERSION
moc-laondkmydzp   Ready    control-plane,master   3d4h   v1.22.4
moc-lorl6k76q01   Ready    <none>                 3d4h   v1.22.4
moc-lorl4323d02   Ready    <none>                   9m   v1.22.4
moc-lorl43bc3c3   Ready    <none>                   2m   v1.22.4
```

To see the scale down. Use CTRL-C to end the load generator pods and close the PowerShell Windows associated with them. After approximately 30 minutes you should see the number of pods go down and 30 minutes later the nodes will get deprovisioned as well.

To read more about the Kubernetes horizontal pod autoscaler, see [Horizontal Pod Autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/).

### Node affinity rules

You can use Node affinity rules to enable the Kubernetes Scheduler to run pods only on a specific set of nodes in a cluster or node pool based on certain characteristics of the node. The same rules can also be used to ensure that only one instance of a given pod runs per node to show the function of the horizontal node auto scaler.

Prerequisites:

* AKS on Azure Stack HCI is installed
* Target Cluster is installed and connected to Azure
* One Linux Node Pool is deployed with at least one Linux Worker node active
* Horizontal Node Autoscaler is enabled on the target cluster and the Linux node pool per the documentation above.

Create a YAML file with the following content and save it as node-anti-affinity.yaml to a local folder.

``` yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-cache
spec:
  selector:
    matchLabels:
      app: store
  replicas: 4
  template:
    metadata:
      labels:
        app: store
    spec:
      nodeSelector:
        kubernetes.io/os: linux
      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchExpressions:
              - key: app
                operator: In
                values:
                - store
            topologyKey: "kubernetes.io/hostname"
      containers:
      - name: redis-server
        image: redis:3.2-alpine
```

Open a PowerShell Window and load the credentials for your target cluster. In our case, it's named 'mycluster'.

```powershell
Get-AksHciCredential -name mycluster
```

Now apply the YAML file from before to the target cluster

```powershell
kubectl apply -f node-anti-affinity.yaml
```

After a few minutes you can use the following command to check for the new nodes to come online 

```powershell
kubectl get nodes
NAME              STATUS   ROLES                  AGE    VERSION
moc-laondkmydzp   Ready    control-plane,master   3d4h   v1.22.4
moc-lorl6k76q01   Ready    <none>                 3d4h   v1.22.4
moc-lorl4323d02   Ready    <none>                   9m   v1.22.4
moc-lorl43bc3c3   Ready    <none>                   9m   v1.22.4
moc-lorl44ef56c   Ready    <none>                   9m   v1.22.4
```

To remove the node, delete the deployment of the redis server with

```powershell
kubectl delete -f node-anti-affinity.yaml
```

To learn more about Kubernetes pod affinity rules, see [Assigning Pods to Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node).

## Troubleshoot horizontal autoscaler

When the horizontal autoscaler is enabled for a target cluster, a new Kubernetes deployment will be created in the management cluster called `<cluster_name>-cluster-autoscaler`. This deployment monitors the target cluster to ensure there are enough worker nodes to schedule pods. Here are different ways to debug autoscaler related issues:

The cluster autoscaler pods running on the management cluster log useful information about how it's making scaling decisions, the number of nodes that it needs to bring up or remove, and any general errors that it may experience. Run this command to access the logs:

```powershell 
kubectl --kubeconfig $(Get-AksHciConfig).Kva.kubeconfig logs -l app=<cluster_name>-cluster-autoscaler
```

Cloud operator logs Kubernetes events in the management cluster, which can be helpful to understand when autoscaler has been enabled or disabled for a cluster and a node pool. These can be viewed by running:

```powershell 
kubectl --kubeconfig $(Get-AksHciConfig).Kva.kubeconfig get events
```
The cluster autoscaler deployment creates a `configmap` in the target cluster that it manages. This `configmap` holds information about the autoscaler's status at the cluster wide level and per node pool. Run this command against the target cluster to view the status:

> [!NOTE] 
> Ensure you have run `Get-AksHciCredentials -Name <clustername>` to retrieve the `kubeconfig` information to access the target cluster in question.

```powershell 
kubectl --kubeconfig ~\.kube\config get configmap cluster-autoscaler-status -o yaml
```

The cluster autoscaler logs events on the cluster autoscaler status configmap when it scales a cluster's node pool. These can be viewed by running this command against the target cluster:
 
```powershell
kubectl --kubeconfig ~\.kube\config describe configmap cluster-autoscaler-status
```

The cluster autoscaler emits events on pods in the target cluster when it makes a scaling decision if the pod can't be scheduled. Run this command to view the events on a pod:

```powershell
kubectl --kubeconfig ~\.kube\config describe pod <pod_name>
```

## PowerShell reference

You can review the reference for the PowerShell cmdlets that support cluster autoscaling: 

 - [Get-AksHciAutoScalerProfile](./reference/ps/get-akshciautoscalerprofile.md)
 - [Get-AksHciCluster for AKS](./reference/ps/get-akshcicluster.md)
 - [Get-AksHciNodePool for AKS](./reference/ps/get-akshcinodepool.md)
 - [New-AksHciAutoScalerProfile](./reference/ps/new-akshciautoscalerprofile.md)
 - [New-AksHciCluster](./reference/ps/new-akshcicluster.md)
 - [New-AksHciNodePool](./reference/ps/new-akshcinodepool.md)
 - [Remove-AksHciAutoScalerProfile](./reference/ps/remove-akshciautoscalerprofile.md)
 - [Set-AksHciAutoScalerProfile](./reference/ps/set-akshciautoscalerprofile.md)
 - [Set-AksHciCluster](./reference/ps/set-akshcicluster.md)
 - [Set-AksHciNodePool](./reference/ps/set-akshcinodepool.md)

## Next steps
- [Learn about the autoscaler profiles](work-with-autoscaler-profiles.md)
- [Learn about cluster autoscaling](concepts-cluster-autoscaling.md)