---

title: Create and use storage classes in AKS enabled by Arc (preview)
description: Learn how to create and use storage classes in AKS enabled by Arc.
author: sethmanheim
ms.author: sethm
ms.date: 11/12/2024
ms.topic: conceptual
ms.custom: references_regions

---

# Create and use storage classes (preview)

This article describes how to create and use Azure Arc-enabled storage classes for AKS on Azure Stack HCI 23H2.

## Prerequisites

To use the storage classes feature, you must have an AKS Arc cluster running, in the following currently available regions:

- East US (eastus)
- West Europe (westeurope)
- Australia East (australiaeast)
- Southeast Asia (southeastasia)
- Central India (centralindia)
- Canada Central (canadacentral)
- Japan East (japaneast)
- South Central US (southcentralus)

If you want to use the storage classes feature with Azure CLI, you must also have Azure CLI installed and set up on your machine, and install the `k8s-runtime` extension using the following command:

```azurecli
az extension add --name k8s-runtime
```

## [Azure portal](#tab/portal)

During the preview, our publicly available portal extension only targets AKS Arc clusters and is behind the feature flag `managedstorageclass` of the `Microsoft_Azure_HybridCompute` portal extension. [Visit this Azure portal link](https://portal.azure.com/?Microsoft_Azure_HybridCompute_managedstorageclass=true) to open the portal and navigate to your AKS Arc cluster resource.

### Enable the service

Select your cluster, then select **Storage classes (preview)** from menu to enter the UI. Select **Enable service** to enable the service in your cluster.

:::image type="content" source="media/create-storage-classes/enable-service.png" alt-text="Screenshot showing enable storage classes service on portal." lightbox="media/create-storage-classes/enable-service.png":::

It might take a few minutes to enable the service in your cluster. When it's ready, the UI looks similar to the following screenshot. Your storage classes are uploaded to the cloud:

:::image type="content" source="media/create-storage-classes/storage-classes-summary.png" alt-text="Screenshot showing summary of storage classes on portal." lightbox="media/create-storage-classes/storage-classes-summary.png":::

## [Azure CLI](#tab/cli)

To enable the service in your connected cluster, you must first get the resource ID for your connected cluster. Run the following command:

```azurecli
az k8s-runtime storage-class enable --resource-uri <connected cluster resource id>
```

---

## List all storage classes in the cloud

This section describes how to list all storage classes in the cloud using the portal, or CLI.

### [Azure portal](#tab/portal)

The previous UI shows all the storage classes in your connected cluster that are already synchronized to the cloud.

### [Azure CLI](#tab/cli)

You can get all storage class resources of an Arc-connected cluster using Azure CLI:

```azurecli
az k8s-runtime storage-class list --resource-uri <connecter cluster resource id>
```

---

## Create a storage class

This section describes how to create a storage class using the Azure portal, or Azure CLI.

### NFS

#### [Azure portal](#tab/portal)

When the service is ready, the **Create** button on the action bar becomes available. Select it, and a new blade to create a new storage class is displayed.

:::image type="content" source="media/create-storage-classes/create-storage-class-portal.png" alt-text="Screenshot of portal blade showing create storage class." lightbox="media/create-storage-classes/create-storage-class-portal.png":::

To create an NFS storage class, select **NFS** from the **Type** dropdown under the **Storage Class Type** section, and then input the NFS source with format `<address>:<share>`. If you want to use the same directory for all persistent volumes provisioned for this storage class, input a subdirectory under the share in the **Sub Directory** textbox. If it's left empty, a new subdirectory under the share is created for each provisioned persistent volume.

:::image type="content" source="media/create-storage-classes/create-storage-class-nfs.png" alt-text="Screenshot of portal blade showing create NFS storage class." lightbox="media/create-storage-classes/create-storage-class-nfs.png":::

If your AKS Arc instance doesn't have the built-in NFS CSI feature enabled, an error message is displayed, and you're unable to create an NFS storage class. [Follow these instructions](https://aka.ms/aks-arc-nfs-csi) to enable NFS CSI in your cluster, and then create the storage class again.

:::image type="content" source="media/create-storage-classes/create-storage-class-no-csi-nfs.png" alt-text="Screenshot of portal showing error when CSI not enabled." lightbox="media/create-storage-classes/create-storage-class-no-csi-nfs.png":::

After you complete the form in the **Basics** tab, you can optionally specify advanced options under the **Advanced** tab.

Select **Review + Create** at the bottom of the tab, wait for validation to complete, review the configuration for the storage class, and then select **Create** to create it.

After the Azure Resource Manager deployment completes, a new storage class with specified name is created in the cluster.

:::image type="content" source="media/create-storage-classes/storage-summary.png" alt-text="Screenshot of portal showing storage summary.":::

#### [Azure CLI](#tab/cli)

You can create a new SMB storage class using Azure CLI:

```azurecli
az k8s-runtime storage-class create `
    --resource-uri <connected cluster resource id> `
    --storage-class-name nfs-test `
    --type-properties nfs.server="<server address>" `
    --type-properties nfs.share="<share>" `
    --type-properties nfs.subDir="/subdir"
```

---

### SMB

#### [Azure portal](#tab/portal)

Select **SMB** in the **Type** dropdown under the **Storage Class Type** section, and then input the required information:

:::image type="content" source="media/create-storage-classes/create-smb.png" alt-text="Screenshot of portal showing create SMB storage class." lightbox="media/create-storage-classes/create-smb.png":::

If your AKS Arc instance doesn't have the built-in NFS CSI feature enabled, an error message is displayed, and you're unable to create an NFS storage class. [Follow these instructions](https://aka.ms/aks-arc-nfs-csi) to enable NFS CSI in your cluster, and then create the storage class again.

#### [Azure CLI](#tab/cli)

You can create an SMB storage class using Azure CLI:

```azurecli
az k8s-runtime storage-class create `
    --resource-uri <connected cluster resource id> `
    --storage-class-name smb-test `
    --type-properties smb.source="<server address>" `
    --type-properties smb.subDir="/subdir"
```

---

### AksArcDisk

#### [Azure portal](#tab/portal)

You can create [a storage class for a custom disk](https://aka.ms/aks-arc-custom-disk-storage-class) for AKS Arc. This type is only available for AKS Arc. A storage path is required for this type of storage class. You can select one with the provided selector, or input the storage path resource ID directly:

:::image type="content" source="media/create-storage-classes/create-storage-class-aks-arc-disk.png" alt-text="Screenshot of portal showing create custom disk storage class." lightbox="media/create-storage-classes/create-storage-class-aks-arc-disk.png":::

#### [Azure CLI](#tab/cli)

You can create a storage class for a custom disk using Azure CLI:

```azurecli
az k8s-runtime storage-class create `
    --resource-uri <connected cluster resource id> `
    --storage-class-name smb-test `
    --type-properties aksarcdisk.storagePathId="<resource id for the storage path>" `
    --type-properties aksarcdisk.fsType=ext4
```

---

## Update a storage class

You can update some properties of a storage class using Azure CLI. See the following considerations when updating a storage class:

- You can't change a storage class from one type to another type.
- Changing most properties of a storage class results in deleting the original and re-creating a new one. However, updating some properties doesn't delete the original. These properties are called *in-place updatable*. To understand what properties you can update in-place, see the tables in the Reference section.
- When you set the key name in `--type-properties`, use the property name directly without the `<storage class type>.` prefix. Properties that aren't part of the storage class type are ignored.

```azurecli
az k8s-runtime storage-class update `
    --resource-uri <connected cluster resource id> `
    --storage-class-name nfs-test `
    --type-properties server=172.23.1.4
```

## Delete a storage class

You can delete a storage class using the Azure portal or Azure CLI.

### [Azure portal](#tab/portal)

To delete storage classes from a cluster using the portal, select the storage classes to delete, then select **Delete** and confirm the action.

:::image type="content" source="media/create-storage-classes/delete-portal.png" alt-text="Screenshot of portal showing delete storage classes." lightbox="media/create-storage-classes/delete-portal.png":::

### [Azure CLI](#tab/cli)

You can delete a storage class using Azure CLI:

```azurecli
az k8s-runtime storage-class delete --resource-uri <connected resource id> --storage-class-name <storage class name>
```

---

## Disable Storage Class service

You can disable the Storage Class service using Azure CLI:

```azurecli
az k8s-runtime storage-class disable --resource-uri <resource uri>
```

## Reference

To specify a property when you create a storage class using Azure CLI, you must pass the `<storage class name type in lower cases>.<property name>=<property name>` value to a `--type-properties` command line parameter. You can pass multiple `--type-properties` command line parameters. It's not necessary to pass the `type` property to the CLI. For example, to set the `server` property in an NFS storage class, pass the `--type-properties nfs.server={server address}` value.

When a storage class is updated, if all the properties that changed are updatable in-place (see the **In-place update** column in the following tables), the storage class isn't recreated. If any properties to update aren't updatable in-place, the storage class is deleted and re-created.

### NFS

| Property | Type | In-place update | Description |
| -- | -- | -- | -- |
| `type` | `NFS` | N/A | Specify this is an NFS type. |
| `server` | `string` | No | NFS server address. |
| `share` | `string` | No | NFS share. |
| `subDir` | `string` \| `undefined` | No | Subdirectory under `share`. If the subdirectory doesn't exist, the driver creates it. |
| `mountPermissions` | `string` \| `undefined` | No | Mounted folder permissions. Default is 0. If set as nonzero, the driver performs `chmod` after mount. |
| `onDelete` | `Delete` \| `Retain` | No | The action to take when an NFS volume is deleted. Default is `Delete`. |

### SMB

| Property  | Type | In-place update | Description |
| -- | -- | -- | -- |
| `type` | `SMB` | N/A | Specify this is an SMB type. |
| `source` | `string` | No |  SMB server source. |
| `subDir` | `string` \| `undefined` | No | Subdirectory under share. If the subdirectory doesn't exist, the driver creates it. |
| `username` | `string` \| `undefined` | **Yes** | Server username. |
| `password` | `string` \| `undefined` (secret) | **Yes** | Server password. |
| `domain` | `string` \| `undefined` | **Yes** | Server domain. |

### AksArcDisk

You can create a storage class that uses custom disks. This process is only for AKS Arc clusters. See [Create custom storage class for disks](container-storage-interface-disks.md?tabs=23H2#create-custom-storage-class-for-disks).

| Property  | type | In-place update | description |
| -- | -- | -- | -- |
| `type` | `AksArcDisk` | N/A | Specify this is the AksArcDisk type. |
| `storagePathId` | `string` | No | The resource ID for the storage path. |
| `fsType` | `string` \| `undefined` | No | `fsType` parameters for the storage class. If the storage class contains Linux workloads, set it to `ext4`. Otherwise, leave it undefined. |

## Next steps

[Storage class overview](storage-class-overview.md)
