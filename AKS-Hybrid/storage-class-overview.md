---

title: Storage Class and Container Storage Interface (CSI) (preview)
description: Learn about Storage Class and the Container Storage Interface (CSI) in AKS enabled by Arc.
author: sethmanheim
ms.author: sethm
ms.date: 10/10/2024
ms.topic: conceptual

---

# Storage Class and Container Storage Interface (preview)

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]
[!INCLUDE [aks-hybrid-applies-to-azure-stack-hci-windows-server-sku](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)]

Storage is key to most applications. Kubernetes uses a *storage class* to describe classes (types) of storage. Pods use storage class to request storage, and when the pod is up and running, volumes of requested storage class are mounted to the pod so that the pod can access their contents. Implementation details, including how the volumes are provisioned and mounted, and how the files are stored, are handled by storage addons to the storage class.

*Container Storage Interface (CSI)* is the interface that Kubernetes uses to handle different storage classes. Different storage types provide storage addons that implement the CSI for specific storage classes.

The following diagram shows the relationships among pods, volumes, storage classes, storage addons and actual storage infrastructures:

:::image type="content" source="media/storage-class-overview/pods-storage-classes.png" alt-text="Diagram showing relationships among pods, volumes, storage classes, storage addons and actual storage infrastructures." lightbox="media/storage-class-overview/pods-storage-classes.png":::

## Create storage classes on top of existing storage

By default, a new Kubernetes cluster only supports the local disk storage class, which stores data in a local disk. This class has limitations and can't be directly used in most production scenarios. For example, local disk volumes can only support `ReadWriteOnce` access mode, meaning the volumes can only be accessed by one pod at a time. However, [SQL Managed Instance enabled by Azure Arc](/azure/azure-arc/data/managed-instance-overview) requires [its backup volume to support the ReadWriteMany(RWX) access mode](/azure/azure-arc/data/create-sql-managed-instance?tabs=directly-connected-mode#create-an-azure-arc-enabled-sql-managed-instance), meaning the volume should support simultaneous reads and writes from multiple pods.

Storage is important for any running systems, so most companies might have already set up storage infrastructures for existing systems. The Arc storage service provides a unified experience for creating storage classes on top of existing storage. With the Arc Storage Class service, cluster administrators only need to specify the name and type of the storage class to be created, and Arc Storage Class installs storage classes and their respective CSI components into their clusters. The installed components are managed by Azure, so updates are automatically installed and security vulnerabilities are automatically fixed.

:::image type="content" source="media/storage-class-overview/create-storage-class.gif" alt-text="Screenshot showing to to create a storage class on Azure portal.":::

### Scenario 1: Connect to existing NAS

You might be already using network-attached storage (NAS) for storage pool and high availability capabilities. By default, Kubernetes can't use NAS for storage. With the Arc Storage Class service, you can easily create an NFS storage class that connects to your existing NAS using the standard NFS protocol that NAS devices should support. You can also create multiple NFS storage classes to connect to different NAS devices.

### Scenario 2: Connect to existing Windows Server clusters

If your company runs Windows Server clusters like HCI, these clusters usually use SMB drives for storage. Arc Storage Class provides SMB storage classes so these existing clusters can be easily used by your new Arc-connected Kubernetes cluster.

### Scenario 3: Use Azure Storage to expand storage

Azure Storage (blobs) are a good way to get large amounts of storage without the cost of building and maintaining new infrastructure. To adopt Azure blobs in your cluster, the only thing you need to do is create an account on Azure, and then create an Azure blobs storage class with the Arc Storage Class service. The files are stored and managed by Azure blobs, and you only pay for how much you actually used.

### Scenario 4: Extend capabilities on existing storage classes

Arc Storage Class also provides software solutions to extend capabilities on existing storage classes. For example, most existing storage solutions don't provide RWX capabilities, but a volume supporting RWX is required for SQL Managed Instance enabled by Azure. The Arc Storage Class service can create a new RWX supported storage class on top of an arbitrary existing storage class, so that you can use existing storage classes on scenarios that require RWX capabilities, even though the underlying storage class itself doesn't support RWX.

## Describe and detect storage class capabilities

Different storage types have different capabilities (attributes), such as performance, failover speed (how fast a pod using the storage class can recover when the pod is migrated to another node), and access modes (whether the volume can be read or written by multiple nodes simultaneously). These characteristics are important when choosing the right storage class for an application. For example, frequently accessed data should be in a volume with better performance. Unfortunately, there is not a standard mechanism in Kubernetes to express or detect these characteristics. As a result, storage class selection has to be done manually, which can be repetitive, time wasting and error prone.

The Arc Storage Class service provides a way to describe and detect the capability attributes of storage classes. We defined standardized keys and values that describe different capability attributes of storage classes. When the Arc Storage Service is enabled on a cluster, the service automatically runs attribute detection scripts on all storage classes in the cluster and, when it's finished, writes the results with these standardized keys and values. If some attributes fail to be detected or can't be detected automatically, you can also manually define attributes.

:::image type="content" source="media/storage-class-overview/attributes.png" alt-text="Screenthot showing storage attributes." lightbox="media/storage-class-overview/attributes.png":::

With the attributes detected and recorded, the process to decide which storage class to use in an application can also be simplified. Instead of specifically choosing which storage class to use, you can list only the requirements for storage class attributes, and our service automatically chooses a storage class that matches these requirements.

## Automatically configure storage for Arc services

You can deploy Azure Arc enabled services to your Arc connected Kubernetes clusters. To ensure flexibility in the deployment, the service usually uses the storage classes that are already on the cluster. But Azure Arc services cannot directly access the storage classes in user cluster and have no knowledge of the capabilities of the storage classes, so deciding what storage class should be used for storage is left to the user.

The Arc Storage Class service provides an inventory of storage classes on the cloud, synchronized with user cluster information. The Arc Storage Class service synchronizes the storage class information between the cloud and the cluster side, including basic Kubernetes information (names, provisioners, and so on) and capability attributes that are automatically detected or manually defined. Therefore, Azure Arc services can get access to the storage classes and their capability attributes and can help you query and filter the right storage classes when the service is created.

For example, creating a [SQL Managed Instance enabled by Azure Arc](/azure/azure-arc/data/managed-instance-overview) requires you to select four different storage classes for different usage (data, data-logs, logs, and backups). To simplify the process, SQL Managed Instance enabled by Azure Arc provides templates that automatically select storage classes for several common Kubernetes cluster configurations, but it's not flexible or helpful enough for other cluster configurations. With Arc Storage Class, the Arc service can help you with any cluster configuration query, and can recommend storage classes for each scenario automatically, completely eliminating the need for predefined templates.

:::image type="content" source="media/storage-class-overview/recommendations.png" alt-text="Screenshot showing storage class recommendations." lightbox="media/storage-class-overview/recommendations.png":::

## Platform neutral

The Storage Class service is available on any Kubernetes distributions, including Azure Kubernetes Service and AKS on HCI.

## Next steps

- TBD
