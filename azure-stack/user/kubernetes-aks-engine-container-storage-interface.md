---
title: Add container storage to Kubernetes in Azure Stack Hub 
description: Learn how to add container storage to Kubernetes in Azure Stack Hub.
author: sethmanheim

ms.topic: how-to
ms.date: 12/21/2022
ms.author: sethm
ms.reviewer: waltero
ms.lastreviewed: 3/4/2021

# Intent: As an Azure Stack Hub user, I would like add storage to a Kubernetes cluster using AKS engine so that I can store persistent data.
# Keywords: storage AKS engine Kubernetes

---

# Add container storage to Kubernetes in Azure Stack Hub

As part of the Kubernetes community effort ([Kubernetes in-tree to CSI volume migration](https://kubernetes.io/blog/2019/12/09/kubernetes-1-17-feature-csi-migration-beta/)) to move in-tree volume providers to Container Storage Interface [CSI](https://kubernetes.io/blog/2019/01/15/container-storage-interface-ga/), you can find the following CSI driver in Azure Stack: Azure Disk.

|   **Details**                    | **Azure Disk CSI Driver**                                                                                                    | 
|-----------------------|------------------------------------------------------------------------------------------------------------------------------|
| Project Repository    | [azuredisk-csi-driver](https://github.com/kubernetes-sigs/azuredisk-csi-driver)                                              | 
| CSI Driver Version    | v1.0.0+                                                                                                                      | 
| Access Mode           | ReadWriteOnce                                                                                                                |
| Windows Agent Node    | Support                                                                                                                      |
| Dynamic Provisioning  | Support                                                                                                                      | 
| Considerations        | [Azure Disk CSI Driver Limitations](https://github.com/kubernetes-sigs/azuredisk-csi-driver/blob/master/docs/limitations.md) | 
| Slack Support Channel | [\#provider-azure](https://kubernetes.slack.com/archives/C5HJXTT9Q)                                                          | 

In AKSe versions v0.75.3 and above, Azure Disk CSI driver works for both Linux and Windows nodes, through [azuredisk-csi-driver addon](https://github.com/Azure/aks-engine-azurestack/blob/master/docs/topics/azure-stack.md#volume-provisioners) or [helm charts](https://github.com/Azure/aks-engine-azurestack/blob/master/docs/topics/azure-stack.md#1-install-azure-disk-csi-driver-manually). In disconnected environments, only [azuredisk-csi-driver addon](https://github.com/Azure/aks-engine-azurestack/blob/master/docs/topics/azure-stack.md#volume-provisioners) is supported. 

## Requirements

-   Azure Stack build 2011 and later.
-   AKS engine version v0.60.1 and later.
-   Kubernetes version 1.18 and later.
-   Since the Controller server of CSI Drivers requires two replicas, a single node master pool isn't recommended.
-   [Helm 3](https://helm.sh/docs/intro/install/)

## Install and uninstall CSI drivers

In this section, follow the example commands to deploy a stateful set application consuming CSI Driver.

## Azure disk CSI driver

### Install CSI driver

```bash  
DRIVER_VERSION=v1.10.0
helm repo add azuredisk-csi-driver https://raw.githubusercontent.com/kubernetes-sigs/azuredisk-csi-driver/master/charts
helm install azuredisk-csi-driver azuredisk-csi-driver/azuredisk-csi-driver \
  --namespace kube-system \
  --set cloud=AzureStackCloud \
  --set controller.runOnMaster=true \
  --version ${DRIVER_VERSION}

```
### Deploy storage class

```bash  
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/azuredisk-csi-driver/master/deploy/example/storageclass-azuredisk-csi-azurestack.yaml
```

### Deploy example stateful set application

```bash  
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/azuredisk-csi-driver/master/deploy/example/statefulset.yaml
```

### Validate volumes and applications

You should see a sequence of timestamps are persisted in the volume.

```bash  
kubectl exec statefulset-azuredisk-0 -- tail /mnt/azuredisk/outfile
```

### Delete example stateful set application

```bash  
kubectl delete -f https://raw.githubusercontent.com/kubernetes-sigs/azuredisk-csi-driver/master/deploy/example/statefulset.yaml
```

### Delete storage class

Before you delete the Storage Class,  make sure Pods that consume the Storage Class have been terminated.

```bash  
kubectl delete -f https://raw.githubusercontent.com/kubernetes-sigs/azuredisk-csi-driver/master/deploy/example/storageclass-azuredisk-csi-azurestack.yaml
```

### Uninstall CSI driver

```bash  
helm uninstall azuredisk-csi-driver --namespace kube-system
helm repo remove azuredisk-csi-driver
```

## Azure Disk CSI Driver limitations on Azure Stack Hub

-   Azure Disk IOPS is capped at 2300. For details, see [VM sizes supported in Azure Stack Hub](azure-stack-vm-sizes.md).
-   Azure Stack Hub doesn't support shared disks, so a `maxShares` value greater than 1 isn't valid in a StorageClass.
-   Azure Stack Hub only supports standard locally redundant (Standard_LRS) and Premium Locally redundant (Premium_LRS) Storage Account types, so only `Standard_LRS` and `Premium_LRS` are valid for the `skuName` parameter in a `StorageClass`.
-   Azure Stack Hub doesn't support incremental disk snapshot, so only false is valid for parameter `incremental` in a `VolumeSnapshotClass`.
-   For Windows agent nodes, you need to install Windows CSI Proxy. For details, see [Windows CSI Proxy](https://github.com/kubernetes-csi/csi-proxy). To enable the proxy via AKS engine API model, see [CSI Proxy for Windows](https://github.com/Azure/aks-engine/blob/master/docs/topics/csi-proxy-windows.md).

## Next steps

- Read about [AKS engine on Azure Stack Hub](azure-stack-kubernetes-aks-engine-overview.md)  
