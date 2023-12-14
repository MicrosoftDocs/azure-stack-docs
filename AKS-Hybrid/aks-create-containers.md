---
title: Create Windows Server containers (preview)
description: Learn how to create Windows Server containers in Azure Stack HCI.
ms.topic: how-to
author: sethmanheim
ms.date: 11/27/2023
ms.author: sethm 
ms.lastreviewed: 11/27/2023
ms.reviewer: guanghu

---

# Create Windows Server containers (preview)

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

In this article, you use Azure CLI to deploy a nodepool to an existing AKS cluster that runs Windows Server containers. You also deploy an
ASP.NET sample application in a Windows Server container to the cluster.

## Prerequisites

Create an AKS cluster following the instructions in [How to create AKS clusters](aks-create-clusters-cli.md).

## Add a nodepool

By default, a Kubernetes cluster is created with a nodepool that can run Linux containers. You must add another nodepool that can run Windows Server containers alongside the Linux nodepool.

Add a nodepool with Windows container hosts using the `az aks nodepool add` command with the parameter `--os-type Windows`. If the operating system SKU isn't specified, the nodepool is set to the default OS based on the Kubernetes version of the cluster. Windows Server 2022 is the default operating system for Kubernetes versions 1.25.0 and higher. Windows Server 2019 is the default OS for earlier versions.

- To use Windows Server 2019, specify the following parameters:
  - `os-type` set to `Windows`.
  - `os-sku` set to `Windows2019`.
- To use Windows Server 2022, specify the following parameters:
  - `os-type` set to `Windows`.
  - `os-sku` set to `Windows2022` (optional).

The following command creates a new nodepool named `$mynodepool` and adds it to `$myAKSCluster` with one Windows 2019 node.

```azurecli
az akshybrid nodepool add --resource-group $myResourceGroup --cluster-name $myAKSCluster --name $mynodepool --node-count 1 --os-type Windows --os-sku Windows2019
```

## Connect to the AKS cluster

Now you can connect to your Kubernetes cluster by running the `az connectedk8s proxy` command from your local machine. Make sure you sign in to Azure before running this command. If you have multiple Azure subscriptions, select the appropriate subscription ID using the [az account set](/cli/azure/account#az-account-set) command.

This command downloads the kubeconfig of your Kubernetes cluster to your local machine and opens a proxy connection channel to your on-premises Kubernetes cluster. The channel is open for as long as this command runs. Let this command run for as long as you want to access your cluster. If the command times out, close the CLI window, open a new one, then run the command again.

You must have Contributor permissions on the resource group that hosts the AKS cluster in order to run the following command successfully:

```azurecli
az connectedk8s proxy --name $aksclustername --resource-group $resource_group --file .\aks-arc-kube-config
```

Expected output:

```output
Proxy is listening on port 47011
Merged "aks-workload" as current context in .\aks-arc-kube-config
Start sending kubectl requests on 'aks-workload' context using kubeconfig at .\aks-arc-kube-config
Press Ctrl+C to close proxy.
```

Keep this session running and connect to your Kubernetes cluster from a different terminal/command prompt. Verify that you can connect to your Kubernetes cluster by running the kubectl get command. This command returns a list of the cluster nodes:

```azurecli
kubectl get node -A --kubeconfig .\aks-arc-kube-config
```

The following output example shows the node created in the previous steps. Make sure the node status is **Ready**:

```output
NAME             STATUS ROLES                AGE VERSION
moc-l0ttdmaioew  Ready  control-plane,master 34m v1.24.11
moc-ls38tngowsl  Ready  <none>               32m v1.24.11
```

## Deploy the application

A [Kubernetes manifest file](kubernetes-concepts.md#deployments) defines a cluster's desired state, such as which container images to run.

You can use a YAML manifest to create all the objects needed to run the ASP.NET sample application in a Windows Server container. This manifest includes a [Kubernetes deployment](kubernetes-concepts.md#deployments) for the ASP.NET sample application and a Kubernetes service to access the application from the internet.

The ASP.NET sample application is provided as part of the [.NET Framework samples](https://hub.docker.com/_/microsoft-dotnet-framework-samples/) and runs in a Windows Server container. AKS requires Windows Server containers to be based on images of Windows Server 2019 or greater. The Kubernetes manifest file must also define a [node selector](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/) to ensure your ASP.NET sample application's pods are scheduled on a node that can run Windows Server containers.

1. Create a file named **sample.yaml** and copy in the following YAML definition:

   ```yml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: sample
     labels:
       app: sample
   spec:
     replicas: 1
     template:
       metadata:
         name: sample
         labels:
           app: sample
       spec:
         nodeSelector:
           "kubernetes.io/os": windows
         containers:
         - name: sample
           image: mcr.microsoft.com/dotnet/framework/samples:aspnetapp
           resources:
             limits:
               cpu: 1
               memory: 800M
           ports:
             - containerPort: 80
     selector:
       matchLabels:
         app: sample
   ---
   apiVersion: v1
   kind: Service
   metadata:
     name: sample
   spec:
     type: LoadBalancer
     ports:
     - protocol: TCP
       port: 80
     selector:
       app: sample
   ```

   For a breakdown of YAML manifest files, see [Deployments and YAML manifests](/azure/aks/concepts-clusters-workloads#deployments-and-yaml-manifests).

1. Deploy the application using the [kubectl apply](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#apply) command and specify the name of your YAML manifest:

   ```azurecli
   kubectl apply -f sample.yaml --kubeconfig .\\aks-arc-kube-config
   ```

The following example output shows the deployment and service created successfully:

```output
deployment.apps/sample created
service/sample created
```

## Test the application

When the application runs, a Kubernetes service exposes the application front end to the internet. This process can take a few minutes to complete. Occasionally, the service can take longer than a few minutes to provision. Allow up to 10 minutes for provisioning.

1. Monitor progress using the [kubectl get service](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#get) command with the `--watch` argument.

   ```azurecli
   kubectl get service sample --watch --kubeconfig .\aks-arc-kube-config
   ```

   Initially, the output shows the **EXTERNAL-IP** for the sample service as **pending**:

   ```output
   NAME   TYPE         CLUSTER-IP EXTERNAL-IP PORT(S)      AGE
   sample LoadBalancer 10.0.37.27 <pending>   80:30572/TCP 6s
   ```

   When the **EXTERNAL-IP** address changes from **pending** to an IP address, use CTRL-C to stop the kubectl watch process. The following example output shows a valid public IP address assigned to the service:

   ```output
   sample LoadBalancer 10.0.37.27 52.179.23.131 80:30572/TCP 2m
   ```

1. See the sample app in action by opening a web browser to the external IP address and port of the **sample** service.

   :::image type="content" source="media/aks-create-containers/sample-app.png" alt-text="Screenshot showing ASP.NET sample application." lightbox="media/aks-create-containers/sample-app.png":::

   If you receive a connection timeout when trying to load the page, you should verify that the sample app is ready using the `kubectl get pods --watch` command. Sometimes, the Windows container isn't started by the time your external IP address is available.

## Delete nodepool

Delete the nodepool using the [`az akshybrid nodepool delete`](/cli/azure/group#az_group_delete) command.

```azurecli
az akshybrid nodepool delete -g $myResourceGroup --cluster-name $myAKSCluster --name $mynodepool --no-wait
```

## Next steps

In this article, you deployed a Windows nodepool to an existing AKS cluster and deployed an ASP.NET sample application in a Windows Server
container to it.

For more information about AKS, and a walkthrough of a complete code deployment example, continue to the following tutorial.
