---
title: External Storage on AKS Edge Essentials
description: Learn how to use Local Path Provisioner on AKS Edge Essentials.
author: fcabrera
ms.author: fcabrera
ms.topic: how-to
ms.date: 11/17/2022
ms.custom: template-how-to
---

# External storage on Azure Kubernetes Service Edge Essentials

Persistent storage solutions allow you to store application data external from the pod running your application, and allow you to maintain application data, even if the application's pod fails. It's possible to use [Local Path Provisioner](./aks-lite-howto-use-storage-local-path.md) for local storage, however storage will depend on the node's availability. It's possible to decouple storage availability from nodes lifecycle by using external storage providers. 

In this guide, you'll learn how to set up an NFS provider and deploy a sample container on your AKS Edge Essentials cluster. 

- For more information about NFS plugin, please see [nfs-subdir-external-provisioner](https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner).

## Step 1: Get connection information for your NFS server

First, ensure your NFS server is accessible from your AKS Edge Essentials cluster and get the information you need to connect to it. The information should include the NFS server hostname and exported share path. If the NFS server has authentication mechanisms, make sure to get that information also. 

## Step 2: Download resources 

Second, you'll need to get the resource templates. To setup the provisioner you need to download a set of YAML template files, edit them to add your NFS server's connection information and then apply each deployment file. 

>[!INFO] The NFS sample used is based on the [nfs-subdir-external-provisioner](https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner) sample code and adjusted for AKS EE virtual machine. 

1. Download the latest *Source code (zip)* from [AKS-Edge](https://github.com/Azure/AKS-Edge).

2. Extract the *tgz* to a desired folder.

3. Open an elevated PowerShell session.

4. Move to the nfs sample directory: *AKS-Edge* -> *samples* -> *storage* -> *nfs*

5. Using the `dir` cmd, check that the *nfs* folder has the following files

    ```bash
        Directory: C:\Users\aks-edge\nfs-subdir-external-provisioner\deploy

    Mode                 LastWriteTime         Length Name
    ----                 -------------         ------ ----
    -a----        11/29/2022  10:10 AM            246 class.yaml
    -a----        11/29/2022  10:10 AM           1064 deployment.yaml
    -a----        11/29/2022  10:10 AM           1900 rbac.yaml
    -a----        11/29/2022  10:10 AM            190 test-claim.yaml
    -a----        11/29/2022  10:10 AM            401 test-pod.yaml
    ```

## Step 3: Setup authorization

AKS Edge Essential cluster has the default RBAC enabled, so no other RBAC needs to be configured. However, if you are in a namespace/project other than *default* edit *deploy/rbac.yaml* before deploying the templated. In your admin PowerShell window, run the following cmdlet: 

```powershell
kubectl create -f .\deploy\rbac.yaml
```

## Step 4: Configure the NFS subdir external provisioner

Next you must edit the NFS provisioner's deployment file to add connection information for your NFS server. Edit *deploy/deployment.yaml* and replace the two occurences of with your server's hostname, adn the two ocurrences of the NFS path. 

1. Replace the server hostname *VALUE* under *name: NFS_SERVER*
1. Replace the server hostname *server* under *volumes* -> *nfs* 
1. Replace the server hostname *VALUE* under *name: NFS_PATH*
1. Replace the server hostname *path* under *volumes* -> *nfs* 
1. Open an elevated PowerShell window
1. Deploy the *deploy/deployment.yaml* file
    ```powershell
    kubectl create -f .\class.yaml
    kubectl create -f .\deployment.yaml
    kubectl create -f .\test-claim.yaml
    kubectl create -f .\test-pod.yaml
    ```

If everything is running and correctly attached, you should see something like the following:

First, you should see the PV has been created:

```bash
PS C:\WINDOWS\system32> kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                STORAGECLASS   REASON   AGE
pvc-72dd0e5a-1064-424d-b534-d414b6693aaa   1Mi        RWX            Delete           Bound    default/test-claim   nfs-client              20s
```

Next, you should see the PVC has been bound:

```bash
PS C:\WINDOWS\system32> kubectl get pvc
NAME         STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
test-claim   Bound    pvc-72dd0e5a-1064-424d-b534-d414b6693aaa   1Mi        RWX            nfs-client     25s
```

Finally, you should see the *test-pod* and the *nfs-client-provisioner*.

```bash
PS C:\WINDOWS\system32> kubectl get pod
NAME                                      READY   STATUS      RESTARTS   AGE
nfs-client-provisioner-696845f854-wz5cp   1/1     Running     0          2m
test-pod                                  1/1     Running     0          2m
```

## Step 4: Test persistent storage

A final test is to make sure that the storage is persistent in the NFS connected drive.

Start by writing something to the pod. In your admin PowerShell window, run the following cmdlet: 

```powershell
kubectl exec volume-test -- sh -c "echo Hello AKS Edge! > /data/Test-NFS.txt"
```

Now, go to your NFS shared drive, and check for a file named *Test-NFS.txt*. Open the file, and you should see a line that says *Hello AKS Edge!*.

Finally, delete the pod to simulate a pod failing, or even a deployment being removed.:

```powershell
kubectl delete -f .\test-pod.yaml
```

Check that the pod was removed and then deploy the *test-pod* pod again:

```powershell
kubectl apply -f .\test-pod.yaml
```

Finally, read the content of the file that was previously written. If everything runs successfully, you should see the **Hello AKS Edge!** message. 

```bash
PS C:\WINDOWS\system32> kubectl exec volume-test -- sh -c "cat /data/test"
Hello AKS Edge!
```

## Step 5: Clean up deployments

Once you're finished with NFS storage, go to PowerShell and clean up your workspace by running:

    ```powershell
    kubectl delete -f .\test-pod.yaml
    kubectl delete -f .\test-claim.yaml
    kubectl delete -f .\deployment.yaml
    kubectl delete -f .\class.yaml
    ```

## Next steps

- [Overview](aks-lite-overview.md)
- [Uninstall AKS cluster](aks-lite-howto-uninstall.md)