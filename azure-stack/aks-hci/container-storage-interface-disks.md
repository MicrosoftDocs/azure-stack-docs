---
title: Use the AKS on Azure Stack HCI disk Container Storage Interface (CSI) drivers
description: Learn how to use the AKS on Azure Stack HCI disk Container Storage Interface (CSI) drivers.
author: v-susbo
ms.topic: how-to
ms.date: 04/16/2021
ms.author: v-susbo
ms.reviewer: 
---

# Use the AKS on Azure Stack HCI disk Container Storage Interface (CSI) drivers
The AKS on Azure Stack HCI disk and file Container Storage Interface (CSI) drivers are [CSI specification](https://github.com/container-storage-interface/spec/blob/master/spec.md)-compliant drivers used by AKS on Azure Stack HCI.

The CSI is a standard for exposing arbitrary block and file storage systems to containerized workloads on Kubernetes. By adopting and using CSI, AKS on Azure Stack HCI can write, deploy, and iterate plug-ins to expose new storage systems or improve existing ones in Kubernetes without having to touch the core Kubernetes code and wait for its release cycles.

The CSI storage driver support on AKS on Azure Stack HCI allows you to use:

- AKS on Azure Stack HCI disks, which you can use to create a Kubernetes *DataDisk* resource. These are mounted as *ReadWriteOnce*, so they're only available to a single pod at a time. For storage volumes that can be accessed by multiple pods simultaneously, use [AKS on Azure Stack HCI files](./container-storage-interface-files.md).

- AKS on Azure Stack HCI files, which you can use to mount an SMB or NFS share to pods. These are mounted as *ReadWriteMany*, so you can share data across multiple nodes and pods. They can also be mounted as *ReadWriteOnce* based on the PVC specification.

## Dynamically create disk persistent volumes by using the built-in storage class
A storage class is used to define how a unit of storage is dynamically created with a persistent volume. For more information on how to use storage classes, see [Kubernetes storage classes](https://kubernetes.io/docs/concepts/storage/storage-classes/). 

In AKS on Azure Stack HCI, the `default` storage class is created by default and uses CSV to create VHDX-backed volumes. The reclaim policy ensures that the underlying VHDX is deleted when the persistent volume that used it is deleted. The storage class also configures the persistent volumes to be expandable, so you just need to edit the persistent volume claim with the new size.

To leverage this storage class, create a [PVC](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) and a respective pod that references and uses them. A PVC is used to automatically provision storage based on a storage class. A PVC can use one of the pre-created storage classes or a user-defined storage class to create a VHDX of the desired size. When you create a pod definition, the PVC is specified to request the desired storage.

## Create a custom storage class for an AKS on Azure Stack HCI disk

The default storage class suits the most common scenarios, but not all. For some cases, you might want to have your own storage class that stores PVs at a particular location mapped to a particular performance tier.

> [!NOTE]
> If you have Linux workloads (pods) that specify [Security Context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) `fsGroup`, you must create and use a custom StorageClass that includes the parameter `fsType: ext4`

The default storage class stores PVs at the `-imageDir` location specified during AKS host deployment. If you create a custom storage class, you can specify the location where you want to store PVs. If the underlying infrastructure is Azure Stack HCI, this new location could be a volume that’s backed by high-performing SSDs/NVMe or an cost-optimized volume backed by HDDs, for example.

Creating a custom storage class is a two-step process:

1. Create a new storage container using the following [New-AksHciStorageContainer](new-akshcistoragecontainer.md) PowerShell command:

	```powershell
   New-AksHciStorageContainer -Name <e.g. customStorageContainer> -Path <shared storage path>
   ```
   
   Check whether the new storage container is created by running the following [Get-AksHciStorageContainer](get-akshcistoragecontainer.md) PowerShell command:

   ```powershell
	Get-AksHciStorageContainer -Name "customStorageContainer"
   ```

2. Create a new custom storage class using the new storage container. 
   1. To do this, create a file named `sc-aks-hci-disk-custom.yaml`, and then copy the manifest from the YAML file below. The storage class is the same as the default storage class except with the new `container`. For `group` and `hostname`, query the default storage class by running `kubectl get storageclass default -o yaml`, and then use the values that are specified.

```yaml
       kind: StorageClass
       apiVersion: storage.k8s.io/v1
       metadata:
        name: aks-hci-disk-custom
       provisioner: disk.csi.akshci.com
       parameters:
       	blocksize: "33554432"
        container: customStorageContainer
        dynamic: "true"
        group: <e.g clustergroup-akshci>    # same as default storageclass
        hostname: <e.g. ca-a858c18c.ntprod.contoso.com> # same as default storageclass
        logicalsectorsize: "4096"
        physicalsectorsize: "4096"
        port: "55000"
	fsType: ext4	# refer to the Note above to determine when to include this parameter
       allowVolumeExpansion: true
       reclaimPolicy: Delete
       volumeBindingMode: Immediate
```
   2. Create the storage class with the [kubectl apply](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#apply/) command and specify your `sc-aks-hci-disk-custom.yaml` file: 
  
      ```console
       $ kubectl apply -f sc-aks-hci-disk-custom.yaml
       storageclass.storage.k8s.io/aks-hci-disk-custom created
      ``` 

## Next steps

[Use the file Container Storage Interface drivers](./container-storage-interface-files.md)
