---
title: Concepts - Storage options for applications in AKS on Azure Stack HCI
description: Storage options for applications in AKS on Azure Stack HCI.
author: v-susbo
ms.topic: conceptual
ms.date: 04/16/2021
ms.author: v-susbo
ms.reviewer: 
---

# Storage options for applications in AKS on Azure Stack HCI

Applications that run in AKS on Azure Stack HCI may need to store and retrieve data. For some application workloads, this data storage can use local, fast storage on the node that is no longer needed when the pods are deleted. Other application workloads may require storage that persists on more regular data volumes. Multiple pods may need to share the same data volumes or reattach data volumes if the pod is rescheduled on a different node. Finally, you may need to inject sensitive data or application configuration information into pods. 

![Architectural storage image showing a cluster master and node](media/storage-architecture.png)

This article introduces the core concepts that provide storage to your applications in AKS on Azure Stack HCI. 
- Volumes 
- Persistent volumes 
- Storage classes 
- Persistent volume claims 

## Volumes
Applications often need to be able to store and retrieve data. As Kubernetes typically treats individual pods as ephemeral, disposable resources, different approaches are available for applications to use and persist data as necessary. A volume represents a way to store, retrieve, and persist data across pods and through the application lifecycle. 

In Kubernetes, volumes can represent more than just a traditional disk where information can be stored and retrieved. Kubernetes volumes can also be used as a way to inject data into a pod for use by the containers. Common additional volume types in Kubernetes include: 

- emptyDir - This volume is commonly used as temporary space for a pod. All containers within a pod can access the data on the volume. Data written to this volume type persists only for the lifespan of the pod - when the pod is deleted, the volume is deleted. This volume typically uses the underlying local node disk storage, though it can also exist only in the node's memory. 

- secret - This volume is used to inject sensitive data into pods, such as passwords. You first create a Secret using the Kubernetes API. When you define your pod or deployment, a specific Secret can be requested. Secrets are only provided to nodes that have a scheduled pod that requires it, and the Secret is stored in tmpfs, not written to disk. When the last pod on a node that requires a Secret is deleted, the Secret is deleted from the node's tmpfs. Secrets are stored within a given namespace and can only be accessed by pods within the same namespace. 

- configMap - This volume type is used to inject key-value pair properties into pods, such as application configuration information. Rather than defining application configuration information within a container image, you can define it as a Kubernetes resource that can be easily updated and applied to new instances of pods as they are deployed. Like using a Secret, you first create a ConfigMap using the Kubernetes API. This ConfigMap can then be requested when you define a pod or deployment. ConfigMaps are stored within a given namespace and can only be accessed by pods within the same namespace. 

## Persistent volumes
Volumes that are defined and created as part of the pod lifecycle only exist until the pod is deleted. Pods often expect their storage to remain if a pod is rescheduled on a different host during a maintenance event, especially in StatefulSets. A persistent volume (PV) is a storage resource created and managed by the Kubernetes API that can exist beyond the lifetime of an individual pod. 

You can use AKS on Azure Stack HCI Disk volumes backed by VHDX that are mounted as ReadWriteOnce and are accessible to a single node at a time. Or you can use AKS on Azure Stack HCI Files volumes backed by SMB or NFS file shares. These are mounted as ReadWriteMany and are available to multiple nodes concurrently. 

A PersistentVolume can be statically created by a cluster administrator, or dynamically created by the Kubernetes API server. If a pod is scheduled and requests storage that is not currently available, Kubernetes can create the underlying VHDX and attach it to the pod. Dynamic provisioning uses a StorageClass to identify what type of storage needs to be created. 

## Storage classes
To define different tiers (and location) of storage you can create a StorageClass. The StorageClass also defines the reclaimPolicy. This reclaimPolicy controls the behavior of the underlying storage resource when the pod is deleted and the persistent volume may no longer be required. The underlying storage resource can be deleted or retained for use with a future pod. 

In AKS on Azure Stack HCI, the `default` storage class is automatically created and uses CSV to create VHDX-backed volumes. The reclaim policy ensures that the underlying VHDX is deleted when the persistent volume that used it is deleted. The storage class also configures the persistent volumes to be expandable, so you just need to edit the persistent volume claim with the new size. 

If no StorageClass is specified for a persistent volume, the default StorageClass is used. Take care when requesting persistent volumes so that they use the appropriate storage you need. You can create a StorageClass for additional needs. 

## Persistent volume claims 
A PersistentVolumeClaim requests either ReadWriteOnce or ReadWriteMany storage of a particular StorageClass and size. The Kubernetes API server can dynamically provision the underlying storage resource in AKS on Azure Stack HCI if there is no existing resource to fulfill the claim based on the defined StorageClass. The pod definition includes the volume mount once the volume has been connected to the pod. 

A PersistentVolume is bound to a PersistentVolumeClaim once an available storage resource has been assigned to the pod requesting it. There is a 1:1 mapping of persistent volumes to claims. 

The following example YAML manifest shows a persistent volume claim that uses the _default_ StorageClass and requests a Disk 5Gi in size: 

```yml
apiVersion: v1 
kind: PersistentVolumeClaim 
metadata: 
  name: aks-hci-vhdx 
spec: 
  accessModes: 
  - ReadWriteOnce 
  storageClassName: default 
  resources: 
    requests: 
      storage: 5Gi 
```

When you create a pod definition, the persistent volume claim is specified to request the desired storage. You also then specify the volumeMount for your applications to read and write data. The following example YAML manifest shows how the previous persistent volume claim can be used to mount a volume at `/mnt/aks-hci`: 

```yaml
kind: Pod 
apiVersion: v1 
metadata: 
  name: nginx 
spec: 
  containers: 
    - name: myfrontend 
      image: mcr.microsoft.com/oss/nginx/nginx:1.15.5-alpine 
      volumeMounts: 
      - mountPath: "/mnt/aks-hci" 
        name: volume 
  volumes: 
    - name: volume 
      persistentVolumeClaim: 
        claimName: aks-hci-vhdx 
```

For mounting a volume in a Windows container, specify the drive letter and path. 

Here's an example:

```yaml
volumeMounts: 
        - mountPath: "d:" 
          name: volume 
        - mountPath: "c:\k" 
          name: k-dir 
```

## Next steps

- [Use the AKS on Azure Stack HCI disk Container Storage Interface (CSI) drivers](./container-storage-interface-disks.md)
- [Use the AKS on Azure Stack HCI files Container Storage Interface (CSI) drivers](./container-storage-interface-files.md)
