---
title: Use persistent volume in an AKS on Azure Stack HCI cluster
description: Use persistent storage in a Windows container and prepare Windows nodes for group Managed Service Accounts
author: v-susbo
ms.topic: how-to
ms.date: 11/19/2020
ms.author: v-susbo
ms.reviewer: 
---

# Use persistent volume in an AKS on Azure Stack HCI cluster

> Applies to: AKS on Azure Stack HCI, AKS runtime on Windows Server 2019 Datacenter

A persistent volume represents a piece of storage that has been provisioned for use with Kubernetes pods. A persistent volume can be used by one or more pods and is meant for long-term storage. It's also independent of pod or node lifecycle. In this section, you'll see how to create a persistent volume and how to use this volume in your Windows application. For more information, see [Persistent volumes in Kubernetes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/).

## Before you begin

Here's what you need to get started:

* A Kubernetes cluster with at least one Windows worker node.
* A kubeconfig file to access the Kubernetes cluster.

## Create a persistent volume claim

A persistent volume claim is used to automatically provision storage based on a storage class. To create a volume claim, first create a file named `pvc-akshci-csi.yaml` and copy in the following YAML definition. The claim requests a disk that is 10 GB in size with *ReadWriteOnce* access. The *default* storage class is specified as the storage class (vhdx).  

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
 name: pvc-akshci-csi
spec:
 accessModes:
 - ReadWriteOnce
 resources:
  requests:
   storage: 10Gi
```
Create the volume by running the following commands in an administrative PowerShell session on one of the servers in the Azure Stack HCI cluster (using a method such as [Enter-PSSession](/powershell/module/microsoft.powershell.core/enter-pssession) or Remote Desktop to connect to the server): 

```
kubectl create -f pvc-akshci-csi.yaml 
```
The following output will show that your persistent volume claim has been created successfully:

**Output:**
```
persistentvolumeclaim/pvc-akshci-csi created
```

## Use persistent volume

To use a persistent volume, create a file named winwebserver.yaml and copy in the following YAML definition. You will then create a pod with access to the persistent volume claim and vhdx. 

In the yaml definition below, *mountPath* is the path to mount a volume inside a container. After a successful pod creation, you will see the subdirectory *mnt* created in *C:\\* and the subdirectory *akshciscsi* created inside *mnt*.


```yaml
apiVersion: apps/v1 
kind: Deployment 
metadata: 
  labels: 
    app: win-webserver 
  name: win-webserver 
spec: 
  replicas: 1 
  selector: 
    matchLabels: 
      app: win-webserver 
  template: 
    metadata: 
      labels: 
        app: win-webserver 
      name: win-webserver 
    spec: 
     containers: 
      - name: windowswebserver 
        image: mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2019 
        ports:  
          - containerPort: 80    
        volumeMounts: 
            - name: akshciscsi 
              mountPath: "/mnt/akshciscsi" 
     volumes: 
        - name: akshciscsi 
          persistentVolumeClaim: 
            claimName:  pvc-akshci-csi 
     nodeSelector: 
      kubernetes.io/os: windows 
```

To create a pod with the above yaml definition, run:
```
Kubectl create -f winwebserver.yaml 
```
 
To make sure the pod is running, run the following command. Wait a few minutes until the pod is in a running state, since pulling the image takes time. 
```
kubectl get pods -o wide 
```
Once your pod is running, view the pod status by running the following command: 
```
kubectl.exe describe pod %podName% 
```

To verify your volume has been mounted in the pod, run the following command:
```
kubectl exec -it %podname% cmd.exe 
```

## Delete a persistent volume claim

Before deleting a persistent volume claim, you must delete the app deployment by running:
```
kubectl.exe delete deployments win-webserver
```

You can then delete a persistent volume claim by running:
```
kubectl.exe delete PersistentVolumeClaim pvc-akshci-csi
```

## Next steps
- [Deploy a Windows application on your Kubernetes cluster](./deploy-windows-application.md).
- [Connect your Kubernetes cluster to Azure Arc for Kubernetes](./connect-to-arc.md).
