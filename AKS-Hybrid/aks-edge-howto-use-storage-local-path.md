---
title: Local Path Provisioner on AKS Edge
description: Learn how to use Local Path Provisioner on AKS Edge.
author: fcabrera
ms.author: fcabrera
ms.topic: how-to
ms.date: 12/05/2022
ms.custom: template-how-to
---

# Local Path Provisioner on Azure Kubernetes Service Edge

Applications running in Azure Kubernetes Service (AKS) Edge may need to store and retrieve data. Persistent storage solutions allow you to store application data external from the pod running your application, and allow you to maintain application data, even if the application's pod fails.

The [Local Path Provisioner](https://github.com/rancher/local-path-provisioner) provides a way for Kubernetes users to use the local storage in each node by enabling the ability to create persistent volume claims using local storage on the respective node.

In this guide, you'll learn how to set up Local Path Provisioner storage and deploy a sample container on your AKS Edge cluster. For more information, please see [the official local-path documentation](https://github.com/rancher/local-path-provisioner/blob/master/README.md#usage).

## Step 1: Install prerequisites

In your admin PowerShell window, run the following cmdlet: 

```powershell
kubectl apply -f https://raw.githubusercontent.com/Azure/AKS-Edge/main/samples/storage/local-path-provisioner/local-path-storage.yaml
```

> [!WARNING]
> [Local-Path-Provisioner](https://github.com/rancher/local-path-provisioner) and [Busybox](https://hub.docker.com/r/rancher/busybox) images are not maintained by Microsoft and are pulled from [Rancher Labs](https://hub.docker.com/u/rancher) repository.  

Once deployment is finished, make sure that the **local-path** storage class is available on your node by running the following cmdlet: 

```powershell
kubectl get StorageClass
```

If everything is correctly configured, you should see similar output:

```shell
NAME                   PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
local-path (default)   rancher.io/local-path   Delete          WaitForFirstConsumer   false                  21h
```

## Step 2: Create a Persistent Volume Claim (PVC)

Second step is to create a persistent volume claim (PVC). There are multiple configurations available, but in this tutorial we'll create a PVC with **ReadWriteOnce** access mode and request **128MB** of storage. In your admin PowerShell window, run the following cmdlet. 

```powershell
kubectl apply -f https://raw.githubusercontent.com/Azure/AKS-Edge/main/samples/storage/local-path-provisioner/pvc.yaml
```

## Step 3: Deploy sample pod and verify resources

This step will deploy a sample pod that bounds to the PVC defined in the previous step. To deploy the sample pod, in your admin PowerShell window, run the following cmdlet. 

```powershell
kubectl apply -f https://raw.githubusercontent.com/Azure/AKS-Edge/main/samples/storage/local-path-provisioner/pod.yaml
```

If everything is running and correctly attached, you should see something like the following:

First, you should see the PV has been created:

```shell
PS C:\WINDOWS\system32> kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                    STORAGECLASS   REASON   AGE
pvc-0f217d0e-1d07-4d9e-91da-6b83534180b9   128Mi      RWO            Delete           Bound    default/local-path-pvc   local-path              16s
```

Next, you should see the PVC has been bound:

```shell
PS C:\WINDOWS\system32> kubectl get pvc
NAME             STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
local-path-pvc   Bound    pvc-0f217d0e-1d07-4d9e-91da-6b83534180b9   128Mi      RWO            local-path     118s
```

Finally, you should see the sample pod running:

```shell
PS C:\WINDOWS\system32> kubectl get pod
NAME          READY   STATUS    RESTARTS   AGE
volume-test   1/1     Running   0          2m24s
```

## Step 4: Test persistent storage

A final test is to make sure that the storage is persistent, and that data will be maintained, even if the application's pod fails.

Start by writing something to the pod. In your admin PowerShell window, run the following cmdlet: 

```powershell
kubectl exec volume-test -- sh -c "echo Hello AKS Edge! > /data/test"
```

Now delete the pod to simulate a pod failing, or even a deployment being removed:

```powershell
kubectl delete -f https://raw.githubusercontent.com/Azure/AKS-Edge/main/samples/storage/local-path-provisioner/pod.yaml
```

Check that the pod was removed and then deploy the **volume-test** pod again:

```powershell
kubectl apply -f https://raw.githubusercontent.com/Azure/AKS-Edge/main/samples/storage/local-path-provisioner/pod.yaml
```

Finally, read the content of the file that was previously written. If everything runs successfully, you should see the **Hello AKS Edge!** message. 

```shell
PS C:\WINDOWS\system32> kubectl exec volume-test -- sh -c "cat /data/test"
Hello AKS Edge!
```

## Step 5: Clean up deployments

Once you're finished with Local Path Provisioner, go to PowerShell and clean up your workspace by running:

```powershell
kubectl delete -f https://raw.githubusercontent.com/Azure/AKS-Edge/main/samples/storage/local-path-provisioner/pod.yaml
kubectl delete -f https://raw.githubusercontent.com/Azure/AKS-Edge/main/samples/storage/local-path-provisioner/pvc.yaml
```

## Next steps

- [AKS Edge Essentials overview](aks-edge-overview.md)
- [Uninstall AKS cluster](aks-edge-howto-uninstall.md)
