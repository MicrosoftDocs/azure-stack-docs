---
title: Use Container Storage Interface (CSI) disk drivers in AKS enabled by Azure Arc
description: Learn how to use Container Storage Interface (CSI) drivers to manage disks in AKS enabled by Arc.
author: sethmanheim
ms.topic: how-to
ms.date: 03/14/2024
ms.author: sethm
ms.lastreviewed: 01/14/2022
ms.reviewer: abha
# Intent: As an IT Pro, I want to learn how to use Container Storage Interface (CSI) drivers in AKS Arc.
# Keyword: container storage interface drivers, CSI drivers
---

# Use Container Storage Interface (CSI) disk drivers in AKS enabled by Azure Arc

[!INCLUDE [applies-to-azure stack-hci-and-windows-server-skus](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)], AKS on Azure Stack HCI 23H2

This article describes how to use Container Storage Interface (CSI) built-in storage classes to dynamically create disk persistent volumes and create custom storage classes in AKS enabled by Arc.

## Overview of CSI in AKS enabled by Arc

[!INCLUDE [csi-in-aks-hybrid-overview](includes/csi-in-aks-hybrid-overview.md)]

## Dynamically create disk persistent volumes using built-in storage class

A *storage class* is used to define how a unit of storage is dynamically created with a persistent volume. For more information on how to use storage classes, see [Kubernetes storage classes](https://kubernetes.io/docs/concepts/storage/storage-classes/). 

In AKS Arc, the **default** storage class is created by default and uses CSI to create VHDX-backed volumes. The reclaim policy ensures that the underlying VHDX is deleted when the persistent volume that used it is deleted. The storage class also configures the persistent volumes to be expandable; you just need to edit the persistent volume claim with the new size.

To leverage this storage class, create a [PVC](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) and a respective pod that references and uses it. A PVC is used to automatically provision storage based on a storage class. A PVC can use one of the pre-created storage classes or a user-defined storage class to create a VHDX of the desired size. When you create a pod definition, the PVC is specified to request the desired storage.

## Create custom storage class for disks

The default storage class is suitable for most common scenarios. However, in some cases, you may want to create your own storage class that stores PVs at a particular location mapped to a specific performance tier.

If you have Linux workloads (pods), you must create a custom storage class with the parameter `fsType: ext4`. This requirement applies to Kubernetes versions 1.19 and 1.20 or later. The following example shows a custom storage class definition with `fsType` parameter defined:

```YAML
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: aks-hci-disk-custom
parameters:
  blocksize: "33554432"
  container: SqlStorageContainer
  dynamic: "true"
  group: clustergroup-summertime
  hostname: TESTPATCHING-91.sys-sqlsvr.local
  logicalsectorsize: "4096"
  physicalsectorsize: "4096"
  port: "55000"
  fsType: ext4
provisioner: disk.csi.akshci.com
reclaimPolicy: Delete
volumeBindingMode: Immediate
allowVolumeExpansion: true  
```

If you create a custom storage class, you can specify the location where you want to store PVs. If the underlying infrastructure is Azure Stack HCI, this new location could be a volume that's backed by high-performing SSDs/NVMe or a cost-optimized volume backed by HDDs.

Creating a custom storage class is a two-step process:

### [AKS on Azure Stack HCI 23H2](#tab/23H2)

1. Create a new storage path using the `stack-hci-vm storagepath` cmdlets to create, show, and list the storage paths on your Azure Stack HCI cluster. For more information about storage path creation, see [storage path](/azure-stack/hci/manage/create-storage-path).

   For `$path`, create a storage path named `$storagepathname`; for example, **C:\ClusterStorage\test-storagepath**:

   ```azurecli
   az stack-hci-vm storagepath create --resource-group $resource_group --custom-location $customLocationID --name $storagepathname --path $path
   ```

   Get the storage path resource ID:

   ```azurecli
   $storagepathID = az stack-hci-vm storagepath show --name $storagepathname --resource-group $resource_group --query "id" -o tsv 
   ```
2. Create a new custom storage class using the new storage path.

   1. Create a file named **sc-aks-hci-disk-custom.yaml**, and then copy the manifest from the following YAML file. The storage class is the same as the default storage class except with the new `container`. Use the `storage path ID` created in the previous step for `container`. For `group` and `hostname`, query the default storage class by running `kubectl get storageclass default -o yaml`, and then use the values that are specified:

      ```yaml
      kind: StorageClass
      apiVersion: storage.k8s.io/v1
      metadata:
       name: aks-hci-disk-custom
      provisioner: disk.csi.akshci.com
      parameters:
       blocksize: "33554432"
       container: <storage path ID>
       dynamic: "true"
       group: <e.g clustergroup-akshci> # same as the default storageclass
       hostname: <e.g. ca-a858c18c.ntprod.contoso.com> # same as the default storageclass
       logicalsectorsize: "4096"
       physicalsectorsize: "4096"
       port: "55000"
       fsType: ext4 # refer to the note above to determine when to include this parameter
      allowVolumeExpansion: true
      reclaimPolicy: Delete
      volumeBindingMode: Immediate
      ```

   2. Create the storage class with the [kubectl apply](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#apply/) command and specify your **sc-aks-hci-disk-custom.yaml** file: 
  
      ```console
       $ kubectl apply -f sc-aks-hci-disk-custom.yaml
       storageclass.storage.k8s.io/aks-hci-disk-custom created
      ```

### [AKS on Azure Stack HCI 22H2](#tab/22H2)

1. Create a new storage container using the following [New-AksHciStorageContainer](./reference/ps/new-akshcistoragecontainer.md) PowerShell command:

   ```powershell
   New-AksHciStorageContainer -Name <e.g. customStorageContainer> -Path <shared storage path>
   ```

   Check whether the new storage container is created by running the following [Get-AksHciStorageContainer](./reference/ps/get-akshcistoragecontainer.md) PowerShell command:

   ```powershell
   Get-AksHciStorageContainer -Name "customStorageContainer"
   ```

2. Create a new custom storage class using the new storage path.

   1. Create a file named **sc-aks-hci-disk-custom.yaml**, and then copy the manifest from the following YAML file. The storage class is the same as the default storage class except with the new `container`. Use the `storage container name` created in the previous step for `container`. For `group` and `hostname`, query the default storage class by running `kubectl get storageclass default -o yaml`, and then use the values that are specified:

      ```yaml
      kind: StorageClass
      apiVersion: storage.k8s.io/v1
      metadata:
       name: aks-hci-disk-custom
      provisioner: disk.csi.akshci.com
      parameters:
       blocksize: "33554432"
       container: <storage container name>
       dynamic: "true"
       group: <e.g clustergroup-akshci> # same as the default storageclass
       hostname: <e.g. ca-a858c18c.ntprod.contoso.com> # same as the default storageclass
       logicalsectorsize: "4096"
       physicalsectorsize: "4096"
       port: "55000"
       fsType: ext4 # refer to the note above to determine when to include this parameter
      allowVolumeExpansion: true
      reclaimPolicy: Delete
      volumeBindingMode: Immediate
      ```

   2. Create the storage class with the [kubectl apply](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#apply/) command and specify your **sc-aks-hci-disk-custom.yaml** file: 
  
      ```console
       $ kubectl apply -f sc-aks-hci-disk-custom.yaml
       storageclass.storage.k8s.io/aks-hci-disk-custom created
      ```

   ---

## Next steps

- [Use the file Container Storage Interface drivers](container-storage-interface-files.md)
