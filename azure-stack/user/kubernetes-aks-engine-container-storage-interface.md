---
title: Deploy Kubernetes cluster to custom virtual network on Azure Stack Hub  
description: Learn how to deploy a Kubernetes cluster to a custom virtual network on Azure Stack Hub.
author: mattbriggs

ms.topic: how-to
ms.date: 3/1/2021
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 3/1/2021

# Intent: As an Azure Stack Hub user, I would like add storage to a Kubernetes cluster using the AKS engine so that I can store persistent data.
# Keywords: storage AKS engine Kubernetes

---

# Add container storage to Kubernetes in Azure Stack Hub

> [!IMPORTANT]  
> This feature is currently in public preview.
> This preview version is provided without a service level agreement, and it's not recommended for production workloads. Certain features might not be supported or might have constrained capabilities. 
> For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

As part of the Kubernetes community effort ([Kubernetes in-tree to CSI volume migration](https://kubernetes.io/blog/2019/12/09/kubernetes-1-17-feature-csi-migration-beta/)) to move in-tree volume providers to Container Storage Interface [CSI](https://kubernetes.io/blog/2019/01/15/container-storage-interface-ga/), you can find the following two CSI drivers in Azure Stack: Azure Disk and NFS.

|                       | **Azure Disk CSI Driver**                                                                                                    | **NFS CSI Driver**                                                       |
|-----------------------|------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------|
| Project Repository    | [azuredisk-csi-driver](https://github.com/kubernetes-sigs/azuredisk-csi-driver)                                              | [csi-driver-nfs](https://github.com/kubernetes-csi/csi-driver-nfs)       |
| CSI Driver Version    | v1.0.0+                                                                                                                      | v3.0.0+                                                                  |
| Access Mode           | ReadWriteOnce                                                                                                                | ReadWriteOnce ReadOnlyMany ReadWriteMany                                 |
| Windows Agent Node    | Support                                                                                                                      | Not support                                                              |
| Dynamic Provisioning  | Support                                                                                                                      | Support                                                                  |
| Considerations        | [Azure Disk CSI Driver Limitations](https://github.com/kubernetes-sigs/azuredisk-csi-driver/blob/master/docs/limitations.md) | Users will be responsible for setting up and maintaining the NFS server. |
| Slack Support Channel | [\#provider-azure](https://kubernetes.slack.com/archives/C5HJXTT9Q)                                                          | [\#sig-storage](https://kubernetes.slack.com/archives/C09QZFCE5)         |

Currently, disconnected environments do not support CSI Drivers.

## Requirements

-   Azure Stack build 2011 and later.
-   AKS engine version v0.60.1 and later.
-   Kubernetes version 1.18 and later.
-   Since the Controller server of CSI Drivers requires two replicas, a single node master pool is not recommended.
-   [Helm 3](https://helm.sh/docs/intro/install/)

## Install and uninstall csi drivers

In this section, follow the example commands to deploy a statefulset application consuming CSI Driver.

## Azure Disk CSI Driver

### Install CSI Driver

```bash  
helm repo add azuredisk-csi-driver https://raw.githubusercontent.com/kubernetes-sigs/azuredisk-csi-driver/master/charts
helm install azuredisk-csi-driver azuredisk-csi-driver/azuredisk-csi-driver --namespace kube-system --set cloud=AzureStackCloud --set controller.runOnMaster=true --version v1.0.0

```
### Deploy Storage Class

```bash  
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/azuredisk-csi-driver/master/deploy/example/storageclass-azuredisk-csi-azurestack.yaml
```

### Deploy example statefulset application

```bash  
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/azuredisk-csi-driver/master/deploy/example/statefulset.yaml
```

### Validate volumes and applications

You should see a sequence of timestamps are persisted in the volume.

```bash  
kubectl exec statefulset-azuredisk-0 -- tail /mnt/azuredisk/outfile
```

### Delete example statefulset application

```bash  
kubectl delete -f https://raw.githubusercontent.com/kubernetes-sigs/azuredisk-csi-driver/master/deploy/example/statefulset.yaml
```

### Delete Storage Class

Before you delete the Storage Class,  make sure Pods that consume the Storage Class have been terminated.

```bash  
kubectl delete -f https://raw.githubusercontent.com/kubernetes-sigs/azuredisk-csi-driver/master/deploy/example/storageclass-azuredisk-csi-azurestack.yaml
```

### Uninstall CSI Driver

```bash  
helm uninstall azuredisk-csi-driver --namespace kube-system
helm repo remove azuredisk-csi-driver
```

## NFS CSI Driver

### Install CSI Driver

```bash  
helm repo add csi-driver-nfs https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/charts
helm install csi-driver-nfs csi-driver-nfs/csi-driver-nfs --namespace kube-system --set controller.runOnMaster=true --version v3.0.0
```

### Deploy NFS Server. 

> [!NOTE]  
> The NFS Server is just for validation, set up and maintain your NFS Server properly for production.

```bash  
set up and maintain your NFS Server properly for production.
kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/deploy/example/nfs-provisioner/nfs-server.yaml

```

### Deploy Storage Class

```bash  
kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/deploy/example/storageclass-nfs.yaml
```

### Deploy example statefulset application

```bash  
kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/deploy/example/statefulset.yaml
```

### Validate volumes and applications

You should see a sequence of timestamps are persisted in the volume.

```bash  
kubectl exec statefulset-nfs-0 -- tail /mnt/nfs/outfile
```

### Delete example statefulset application

```bash  
kubectl delete -f https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/deploy/example/nfs-provisioner/nfs-server.yaml
```

### Delete Storage Class

Before you delete the Storage Class,  make sure Pods that consume the Storage Class have been terminated.

```bash  
kubectl delete -f https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/deploy/example/storageclass-nfs.yaml
```
### Delete example NFS Server.

```bash  
kubectl delete -f https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/deploy/example/nfs-provisioner/nfs-server.yaml
```

### Uninstall CSI Driver

```bash  
helm uninstall csi-driver-nfs --namespace kube-system
helm repo remove csi-driver-nfs
```
## Azure Disk CSI Driver Limitations on Azure Stack Hub

-   Azure Disk IOPS is capped at 2300,  read [VM sizes supported in Azure Stack Hub](azure-stack-vm-sizes.md) for details.
-   Azure Stack Hub doesn't support shared disk, so parameter `maxShares` larger than 1 is not valid in a StorageClass.
-   Azure Stack Hub only supports standard locally redundant (Standard_LRS) and Premium Locally redundant (Premium_LRS) Storage Account types, so only Standard_LRS and Premium_LRS are valid for parameter `skuName` in a `StorageClass`.
-   Azure Stack Hub doesn't support incremental disk snapshot, so only false is valid for parameter `incremental` in a `VolumeSnapshotClass`.
-   For Windows agent nodes, you will need to install Windows CSI Proxy,  refer to [Windows CSI Proxy](https://github.com/kubernetes-csi/csi-proxy). To enable the proxy via AKS engine API model,  refer to [CSI Proxy for Windows](https://github.com/Azure/aks-engine/blob/master/docs/topics/csi-proxy-windows.md).

## Next steps

- Read about the [The AKS engine on Azure Stack Hub](azure-stack-kubernetes-aks-engine-overview.md)  
