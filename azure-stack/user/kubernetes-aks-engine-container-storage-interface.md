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

As part of the Kubernetes community [effort](https://kubernetes.io/blog/2019/12/09/kubernetes-1-17-feature-csi-migration-beta/) to move in-tree volume providers to Container Storage Interface [CSI](https://kubernetes.io/blog/2019/01/15/container-storage-interface-ga/), we are making available the following two CSI drivers in Azure Stack: Azure Disk and NFS. Please find details on the following table:

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
-   AKS Engine version v0.60.1 and later.
-   Kubernetes version 1.18 and later.
-   Since the Controller server of CSI Drivers requires 2 replicas, a single node master pool is not recommended.
-   [Helm 3](https://helm.sh/docs/intro/install/)

## Install and Uninstall CSI Drivers

In this section, please follow the example commands to deploy a StatefulSet application consuming CSI Driver.

## Azure Disk CSI Driver

\# Install CSI Driver

helm repo add azuredisk-csi-driver https://raw.githubusercontent.com/kubernetes-sigs/azuredisk-csi-driver/master/charts

helm install azuredisk-csi-driver azuredisk-csi-driver/azuredisk-csi-driver --namespace kube-system --set cloud=AzureStackCloud --set controller.runOnMaster=true --version v1.0.0

\# Deploy Storage Class

kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/azuredisk-csi-driver/master/deploy/example/storageclass-azuredisk-csi-azurestack.yaml

\# Deploy example StatefulSet application

kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/azuredisk-csi-driver/master/deploy/example/statefulset.yaml

\# Validate volumes and applications

\# You should see a sequence of timestamps are persisted in the volume.

kubectl exec statefulset-azuredisk-0 -- tail /mnt/azuredisk/outfile

\# Delete example StatefulSet application

kubectl delete -f https://raw.githubusercontent.com/kubernetes-sigs/azuredisk-csi-driver/master/deploy/example/statefulset.yaml

\# Delete Storage Class

\# Before delete the Storage Class, please make sure Pods that consume the Storage Class have been terminated.

kubectl delete -f https://raw.githubusercontent.com/kubernetes-sigs/azuredisk-csi-driver/master/deploy/example/storageclass-azuredisk-csi-azurestack.yaml

\# Uninstall CSI Driver

helm uninstall azuredisk-csi-driver --namespace kube-system

helm repo remove azuredisk-csi-driver

## Azure Blob CSI Driver

\# Install CSI Driver

helm repo add blob-csi-driver https://raw.githubusercontent.com/kubernetes-sigs/blob-csi-driver/master/charts

helm install blob-csi-driver blob-csi-driver/blob-csi-driver --namespace kube-system --set cloud=AzureStackCloud --set controller.runOnMaster=true --version v1.0.0

\# Deploy Storage Class

kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/blob-csi-driver/master/deploy/example/storageclass-blobfuse.yaml

\# Deploy example StatefulSet application

kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/blob-csi-driver/master/deploy/example/statefulset.yaml

\# Validate volumes and applications

\# You should see a sequence of timestamps are persisted in the volume.

kubectl exec statefulset-blob-0 -- tail /mnt/blob/outfile

\# Delete example StatefulSet application

kubectl delete -f https://raw.githubusercontent.com/kubernetes-sigs/blob-csi-driver/master/deploy/example/statefulset.yaml

\# Delete Storage Class

\# Before delete the Storage Class, please make sure Pods that consume the Storage Class have been terminated.

kubectl delete -f https://raw.githubusercontent.com/kubernetes-sigs/blob-csi-driver/master/deploy/example/storageclass-blobfuse.yaml

\# Uninstall CSI Driver

helm uninstall blob-csi-driver --namespace kube-system

helm repo remove blob-csi-driver

## NFS CSI Driver

\# Install CSI Driver

helm repo add csi-driver-nfs https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/charts

helm install csi-driver-nfs csi-driver-nfs/csi-driver-nfs --namespace kube-system --set controller.runOnMaster=true --version v3.0.0

\# Deploy NFS Server. Please note that this NFS Server is just for validation, please set up and maintain your NFS Server properly for production.

kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/deploy/example/nfs-provisioner/nfs-server.yaml

\# Deploy Storage Class

kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/deploy/example/storageclass-nfs.yaml

\# Deploy example StatefulSet application

kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/deploy/example/statefulset.yaml

\# Validate volumes and applications

\# You should see a sequence of timestamps are persisted in the volume.

kubectl exec statefulset-nfs-0 -- tail /mnt/nfs/outfile

\# Delete example StatefulSet application

kubectl delete -f https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/deploy/example/statefulset.yaml

\# Delete Storage Class

\# Before delete the Storage Class, please make sure Pods that consume the Storage Class have been terminated.

kubectl delete -f https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/deploy/example/storageclass-nfs.yaml

\# Delete example NFS Server.

kubectl delete -f https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/deploy/example/nfs-provisioner/nfs-server.yaml

\# Uninstall CSI Driver

helm uninstall csi-driver-nfs --namespace kube-system

helm repo remove csi-driver-nfs

## Azure Disk CSI Driver Limitations on Azure Stack Hub

-   Azure Disk IOPS is capped at 2300, please read this [documentation](https://docs.microsoft.com/en-us/azure-stack/user/azure-stack-vm-sizes?view=azs-2008) for details.
-   Azure Stack Hub does not support shared disk, so parameter maxShares larger than 1 is not valid in a StorageClass.
-   Azure Stack only supports Standard Locally-redundant (Standard_LRS) and Premium Locally-redundant (Premium_LRS) Storage Account types, so only Standard_LRS and Premium_LRS are valid for parameter skuName in a StorageClass.
-   Azure Stack does not support incremental disk Snapshot, so only false is valid for parameter incremental in a VolumeSnapshotClass.
-   For Windows agent nodes, you will need to install Windows CSI Proxy, please refer to [Windows CSI Proxy](https://github.com/kubernetes-csi/csi-proxy). To enable the proxy via AKS Engine API model, please refer to [CSI Proxy for Windows](https://github.com/Azure/aks-engine/blob/master/docs/topics/csi-proxy-windows.md).

## Next steps

- Read about the [The AKS engine on Azure Stack Hub](azure-stack-kubernetes-aks-engine-overview.md)  
