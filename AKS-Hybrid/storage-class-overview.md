---

title: Storage Classes and Container Storage Interface (CSI) (preview)
description: Learn about Storage Classes and the Container Storage Interface (CSI) in AKS enabled by Arc.
author: sethmanheim
ms.author: sethm
ms.date: 11/07/2024
ms.topic: conceptual

---

# Storage Classes and Container Storage Interface (preview)

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

Storage is key to most applications. Kubernetes uses *storage classes* to describe classes (types) of storage. Pods use storage classes to request storage, and when the pod is up and running, volumes of requested storage classes are mounted to the pod so that the pod can access their contents. Implementation details, including how the volumes are provisioned and mounted, and how the files are stored, are handled by storage addons to the storage class.

*Container Storage Interface (CSI)* is the interface that Kubernetes uses to handle different storage classes. Different storage types provide storage addons (also known as CSI drivers) that implement the CSI for specific storage classes.

The following diagram shows the relationships among pods, volumes, storage classes, storage addons, and actual storage infrastructures:

:::image type="content" source="media/storage-class-overview/pods-storage-classes.png" alt-text="Diagram showing relationships among pods, volumes, storage classes, storage addons, and actual storage infrastructures." lightbox="media/storage-class-overview/pods-storage-classes.png":::

## Create storage classes on top of existing storage

By default, a new Kubernetes cluster only supports the local disk storage class, which stores data in a local disk. This class has limitations and can't be directly used in most production scenarios. For example, local disk volumes can only support `ReadWriteOnce` access mode, meaning the volumes can only be accessed by one pod at a time. However, [SQL Managed Instance enabled by Azure Arc](/azure/azure-arc/data/managed-instance-overview) requires [its backup volume to support the ReadWriteMany(RWX) access mode](/azure/azure-arc/data/create-sql-managed-instance?tabs=directly-connected-mode#create-an-azure-arc-enabled-sql-managed-instance), meaning the volume should support simultaneous reads and writes from multiple pods.

Storage is important for any running systems, so most companies might have already set up storage infrastructures for existing systems. The Arc storage service provides a unified experience for creating storage classes on top of existing storage. With the Arc Storage Class service, cluster administrators only need to specify the name and type of the storage class to be created, and Arc Storage Class installs storage classes and their respective CSI components into their clusters. The installed components are managed by Azure, so updates are automatically installed and security vulnerabilities are automatically fixed.

### Scenario 1: Connect to existing NAS

You might be already using network-attached storage (NAS) for storage pool and high availability capabilities. By default, Kubernetes can't use NAS for storage. With the Arc Storage Class service, you can easily create an NFS storage class that connects to your existing NAS using the standard NFS protocol that NAS devices should support. You can also create multiple NFS storage classes to connect to different NAS devices.

### Scenario 2: Connect to existing Windows Server clusters

If your company runs Windows Server clusters like HCI, these clusters usually use SMB drives for storage. Arc Storage Class provides SMB storage classes so these existing clusters can be easily used by your new Arc-connected Kubernetes cluster.

## Next steps

- [Create and use storage classes (preview)](create-storage-classes.md)
