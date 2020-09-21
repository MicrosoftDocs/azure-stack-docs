---
title: Use persistent storage and configure GMSA support in a Windows container
description: Use persistent storage and configure GMSA support in a Windows container
author: abha
ms.topic: how-to
ms.date: 09/21/2020
ms.author: abha
ms.reviewer: 
---

# Use persistent storage in a Windows container

## Overview

A persistent volume represents a piece of storage that has been provisioned for use with Kubernetes pods. A persistent volume can be used by one or more pods and is meant for long-term storage. It is also independent of pod or node lifecycle.  In this section, you'll see how to create a persistent volume and how to use this volume in your Windows application.

## Before you begin

Verify you've the following requirements ready:

* A Kubernetes cluster with atleast 1 Windows worker node.
* A kubeconfig file to access the Kubernetes cluster.
* Run the commands in this document in a PowerShell administrative window.

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
Create the volume by running the following command: 

```PowerShell
kubectl create -f pvc-akshci-csi.yaml 
```
The following output will show that your pvc has been created successfully:

**Output:**
```PowerShell
persistentvolumeclaim/pvc-akshci-csi created
```

## Use persistent volume

To use a pvc, create a file named winwebserver.yaml and copy in the following YAML definition. You will then create a pod with access to the persistent volume claim and vhdx. 

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

```PowerShell
Kubectl create -f winwebserver.yaml 
```

To make sure the pod is running, run the following command. Wait a few minutes until the pod is in a running state, since pulling the image takes time.

```PowerShell
kubectl get pods -o wide 
```
Once your pod is running, view  the pod status by running the following command: 

```PowerShell
kubectl.exe describe pod %podName% 
```

To verify your volume has been mounted in the pod, run the following command:

```PowerShell
kubectl exec -it %podname% cmd.exe 
```

## Delete a persistent volume claim

Before deleting a persistent volume claim, you've to delete the app deployment by running:

```PowerShell
kubectl.exe delete deployments win-webserver
```

You can then delete a persistent volume claim by running:

```PowerShell
kubectl.exe delete PersistentVolumeClaim pvc-akshci-csi
```

## Configure GMSA support on Windows nodes

Group Managed Service Accounts are a specific type of Active Directory account that provides automatic password management, simplified service principal name (SPN) management, and the ability to delegate the management to other administrators across multiple servers. To configure Group Managed Service Accounts (GMSA) for Pods and containers that will run on your Windows nodes, you first have to join your Windows nodes to an Active Directory domain.

To enable GMSA support, your Kubernetes cluster name has to be fewer than 4 characters. This is because the maximum supported length for a domain joined server name is 15 characters, and the AKS on Azure Stack HCI Kubernetes cluster naming convention for a worker node adds a few pre-defined characters to a node name.

To join your Windows worker nodes to a domain, log in to a Windows worker node, by running `kubectl get` and noting the `EXTERNAL-IP` value.

```PowerShell
kubectl get nodes -o wide
``` 

You can then SSH into the node using `ssh Administrator@ip`. 

After you've successfully logged in to your Windows worker node, run the following PowerShell command to domain join the node. You'll be prompted to enter your **domain administrator account** credentials. You can also use elevated user credentials that have been given rights to join computers to the given domain. You'll then need to reboot your Windows worker node.

```PowerShell
add-computer --domainame "YourDomainName" -restart
```

Once all Windows worker nodes have been joined to a domain, follow the steps detailed at [configuring GMSA](https://kubernetes.io/docs/tasks/configure-pod-container/configure-gmsa) to apply the Kubernetes GMSA custom resource definitions and webhooks on your Kubernetes cluster.

For more information on Windows container with GMSA, refer [Windows containers and gMSA](https://docs.microsoft.com/virtualization/windowscontainers/manage-containers/manage-serviceaccounts). 

## Next Steps
- [Deploy a Windows application on your Kubernetes cluster](./deploy-windows-application.md).
- [Connect your Kubernetes cluster to Azure Arc for Kubernetes](./connect-to-arc.md).
