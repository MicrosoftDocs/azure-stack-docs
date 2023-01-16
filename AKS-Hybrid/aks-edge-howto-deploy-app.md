---
title: Deploy an application
description: This article describes how to deploy a containerized application to a Kubernetes cluster. 
author: rcheeran
ms.author: rcheeran
ms.topic: how-to
ms.date: 12/05/2022
ms.custom: template-how-to
---

# Deploy an application

This article describes how to deploy a containerized application on your Kubernetes cluster.

## Prerequisites

- Set up your [single machine Kubernetes](aks-edge-howto-single-node-deployment.md) or [full Kubernetes](aks-edge-howto-multi-node-deployment.md) cluster.

## Deploy a sample Linux application

### 1. Update the manifest file

This article uses a sample application that is a basic voting app consisting of a front and back end, which is based on Microsoft's azure-vote-front image. The container image for this application is hosted on Azure Container Registry (ACR). See [linux-sample.yaml](https://github.com/Azure/AKS-Edge/blob/main/samples/others/linux-sample.yaml) in the GitHub repo package for the deployment manifest. Note that in the YAML we specified a `nodeSelector` tag as **Linux**.

### 2. Deploy the application

To deploy your application, use the [kubectl apply][kubectl-apply] command. This command parses the manifest file and creates the defined Kubernetes objects. Specify the YAML manifest file, as shown in the following example:

```console
kubectl apply -f linux-sample.yaml
```

### 3. Verify the pods

Wait a few minutes for the pods to be in the **running** state.

```bash
kubectl get pods -o wide
```

![Screenshot of results showing linux pods running.](media/aks-edge/linux-pods-running.png)

### 3. Verify the services

To monitor progress, use the [kubectl get service][kubectl-get] command with the `--watch` argument.

```console
kubectl get services
```

![Screenshot of results showing linux services running.](media/aks-edge/linux-services-running.png)

Initially, the `EXTERNAL-IP` for the `azure-vote-front` service is shown as `pending`. When the `EXTERNAL-IP` address changes from `pending` to an actual public IP address, you can use the IP address assigned to the service.

> [!IMPORTANT]
> On single machine clusters, if you deployed your Kubernetes cluster without specifying a `-ServiceIPRangeSize`, you will not have allocated IPs for your workload services and you won't have an external IP address. In this case, find the IP address of your Linux VM (`Get-AksEdgeNodeAddr`).

```powershell
Get-AksEdgeNodeAddr -NodeType Linux
```

You can now append the external port to the VM's IP address (for example, **192.168.1.12:30432**).

### 5. Test your application

To see the application in action, open a web browser to the external IP address of your service:

![Screenshot showing Linux apps running](./media/aks-edge/linux-app-up.png)

If the application doesn't load, it might be due to an authorization problem with your image registry. To view the status of your containers, use the `kubectl get pods` command. If the container images can't be pulled, see [Authenticate with Azure Container Registry from Azure Kubernetes Service](/azure/aks/cluster-container-registry-integration?bc=/azure/container-registry/breadcrumb/toc.json&toc=/azure/container-registry/toc.json).

### 6. Remove application


To clean up, delete all resources using the following command:

```bash
kubectl delete -f linux-sample.yaml
```

## Deploy a sample Windows application to your cluster

This example runs a sample ASP.NET application based on [Microsoft's sample image](https://hub.docker.com/_/microsoft-dotnet-samples/). See [win-sample.yaml](https://github.com/Azure/AKS-Edge/blob/main/samples/others/win-sample.yaml) in the GitHub repo. Note that the YAML specifies the `nodeSelector` tag as **Windows**.

### 1. Deploy the application by specifying the name of your YAML manifest

Make sure you are in the directory of the YAML in a PowerShell window, and then run the following command:

```powershell
kubectl apply -f win-sample.yaml
```

### 2. Verify that the sample pod is running

It might take a while for the pod to reach the running status, depending on your internet connection. The ASP.NET image is quite large.

```powershell
kubectl get pods -o wide
```

![Screenshot showing Windows pods running.](media/aks-edge/win-pods-running.png)

### 3. Verify that the sample service is up

```powershell
kubectl get services
```

![Screenshot showing Windows services running.](media/aks-edge/win-svc-running.png)

Since this sample is deployed as a service of type **NodePort**, we can get the IP of the Kubernetes node that the application is running on, then append the port of the NodePort. Get the IP of the Kubernetes node using the following `Get-AksEdgeNodeAddr`command

```powershell
Get-AksEdgeNodeAddr -NodeType Windows
```

![Screenshot showing Windows cluster information.](media/aks-edge/win-cluster-info.png)

### 4. Check out your running Windows sample

Open a web browser and locate the NodePort to access your service:

![Screenshot showing Windows app running.](media/aks-edge/win-app-up.png)

### 5. Clean up

To clean up, delete all resources using:

```powershell
kubectl delete -f win-sample.yaml
```

## Deploying your own applications

The previous steps showed how you can deploy our sample applications. To deploy your own application:

- Package your application into a container image, and then upload the image to Azure Container Registry or in a container registry of your choice. Review these steps to [create a container image of your application](tutorial-kubernetes-prepare-application.md).
- AKS Edge Essentials enables mixed-OS clusters. Ensure your pods get scheduled on nodes with the corresponding OS. Add `nodeSelector` to your deployment files. This will tell Kubernetes to run your pods on nodes of a particular operating system (OS). If your cluster is single-OS, then you can skip this step; but for best practice, label each deployment file with node selectors:

    ```yaml
    nodeSelector:
        "kubernetes.io/os": linux
    ```

    ```yaml
    nodeSelector:
        "kubernetes.io/os": windows
    ```

## Next steps

- [Connect your cluster to Arc](aks-edge-howto-connect-to-arc.md)
- [Overview](aks-edge-overview.md)
- [Uninstall AKS cluster](aks-edge-howto-uninstall.md)

[kubectl-apply]: https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#apply
[kubectl-get]: https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#get
