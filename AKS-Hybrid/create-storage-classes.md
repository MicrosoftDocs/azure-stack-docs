---

title: Create and use storage classes in AKS enabled by Arc (preview)
description: Learn how to create and use storage classes in AKS enabled by Arc.
author: sethmanheim
ms.author: sethm
ms.date: 10/10/2024
ms.topic: conceptual
ms.custom: references_regions

---

# Create and use storage classes (preview)

This article describes how to create and use storage classes in AKS enabled by Arc.

## Prerequisites

Storage classes in AKS enabled by Azure Arc are supported in the following regions:

- eastus2euap (canary)
- eastus
- eastus2
- westus
- westus2

During the preview, it's recommended that you have an AKS Arc cluster in order to use this feature. If you don't have an AKS Arc cluster, you can also try this feature with any Arc-connected cluster. The following commands create an AKS instance and a connected cluster on top of it using Azure CLI:

```azurecli
$rg = "<rg>"
$location = "eastus2euap"
$aksName = "testcanaryaks3"
$arcName = "$aksName-arc"

az aks create --location $location --resource-group $rg --name $aksName --os-sku AzureLinux
az aks get-credentials --name $aksName --resource-group $rg 
az connectedk8s connect --name $arcName --resource-group $rg --location $location
```

To use the feature with Azure CLI, you must also have Azure CLI installed and set up on your machine, and install the `k8s-runtime` extension via the following command:

```azurecli
az extension add --name k8s-runtime
```

## Azure portal

During the preview, our publicly available portal extension only targets provisioned clusters and is behind the feature flag `managedstorageclass` of the `Microsoft_Azure_HybridCompute` extension. [Use this link to show the link for provisioned clusters](https://portal.azure.com/?Microsoft_Azure_HybridCompute_managedstorageclass=true). The example in this article uses a provisioned cluster for demonstration purposes.

If you have other connected clusters, you can [use this link to access the cluster](https://ms.portal.azure.com/?microsoft_azure_managedstorageclass_assettypeoptions=%7B%22ConnectedClusterWithStorageClassPlus%22%3A%7B%22options%22%3A%22%22%7D%7D&microsoft_azure_managedstorageclass=stagepreview&feature.canmodifyextensions=true&microsoft_azure_hybridcompute_assettypeoptions=%7B%22ConnectedClusters%22%3A%7B%22options%22%3A%22HideAssetType%2CHideInstances%22%7D%7D#home). This link overrides the original connected cluster blade with our custom blade, with a link to the Storage Class feature for all connected clusters.

### Enable the service

Select your cluster, then select **Storage classes (preview)** from menu to enter the UI. Select **Enable service** to enable the service in your cluster.

:::image type="content" source="media/create-storage-classes/enable-service.png" alt-text="Screenshot showing enable storage classes service on portal." lightbox="media/create-storage-classes/enable-service.png":::

It might take a few minutes to enable the service in your cluster.

:::image type="content" source="media/create-storage-classes/portal-enabling-service.png" alt-text="Screenshot showing portal enabling storage class service." lightbox="media/create-storage-classes/portal-enabling-service.png":::

When it's ready, the UI looks similar to the following screenshot. Your storage classes and their detected attributes are uploaded to the cloud when they're ready.

:::image type="content" source="media/create-storage-classes/storage-classes-summary.png" alt-text="Screenshot showing summary of storage classes on portal." lightbox="media/create-storage-classes/storage-classes-summary.png":::

## Azure CLI

To enable the service in your connected cluster, you must first get the resource ID for your connected cluster. Run the following command:

```powershell
az k8s-runtime storage-class enable --resource-uri <connected cluster resource id>
```

## List all storage classes in the cloud

This section describes how to list all storage classes in the cloud using the portal, or CLI.

### Azure portal

The previous UI shows all the storage classes in your connected cluster that are already synchronized to the cloud.

### Azure CLI

You can get all storage class resources of an Arc-connected cluster using Azure CLI:

```azurecli
az k8s-runtime storage-class list --resource-uri <connecter cluster resource id>
```

## Create a storage class

This section describes how to create a storage class using the portal, or CLI.

### NFS

#### Azure portal

When the service is ready, the **Create** button on the action bar becomes available. Select it, and a new blade to create a new storage class is displayed.

:::image type="content" source="media/create-storage-classes/create-storage-class-portal.png" alt-text="Screenshot of portal blade showing create storage class." lightbox="media/create-storage-classes/create-storage-class-portal.png":::

To create an NFS storage class, select **NFS** from the **Type** dropdown under the **Storage Class Type** section, and then input the NFS source with format `<address>:<share>`. If you want to use the same directory for all persistent volumes provisioned for this storage class, input a subdirectory under the share in the **Sub Directory** textbox. If it's left empty, a new subdirectory under the share is created for each provisioned persistent volume.

:::image type="content" source="media/create-storage-classes/create-storage-class-nfs.png" alt-text="Screenshot of portal blade showing create NFS storage class." lightbox="media/create-storage-classes/create-storage-class-nfs.png":::

If your AKS Arc instance doesn't have the built-in NFS CSI feature enabled, an error message is displayed, and you are unable to create an NFS storage class. [Follow these instructions](https://aka.ms/aks-arc-nfs-csi) to enable NFS CSI in your cluster, and then create the storage class again.

:::image type="content" source="media/create-storage-classes/create-storage-class-no-csi-nfs.png" alt-text="Screenshot of portal showing error when CSI not enabled." lightbox="media/create-storage-classes/create-storage-class-no-csi-nfs.png":::

After you complete the form in the **Basics** tab, you can optionally specify advanced options under the **Advanced** tab.

:::image type="content" source="media/create-storage-classes/nfs-advanced-properties.png" alt-text="Screenshot of portal showing storage class advanced properties." lightbox="media/create-storage-classes/nfs-advanced-properties.png":::

Select **Review + Create** at the bottom of the tab, wait for validation to complete, review the configuration for the storage class, and then select **Create** to create it.

:::image type="content" source="media/create-storage-classes/create-storage-class-summary.png" alt-text="Screenshot of portal showing summary of create storage class." lightbox="media/create-storage-classes/create-storage-class-summary.png":::

After the Azure Resource Manager deployment completes, a new storage class with specified name is created in the cluster.

:::image type="content" source="media/create-kubernetes-cluster/deployment-complete.png" alt-text="Screenshot of portal showing completed deployment." lightbox="media/create-kubernetes-cluster/deployment-complete.png":::

:::image type="content" source="media/create-storage-classes/storage-summary.png" alt-text="Screenshot of portal showing storage summary":::

#### Azure CLI

You can create a new SMB storage class using Azure CLI:

```azurecli
az k8s-runtime storage-class create `
    --resource-uri <connected cluster resource id> `
    --storage-class-name nfs-test `
    --type-properties nfs.server="<server address>" `
    --type-properties nfs.share="<share>" `
    --type-properties nfs.subDir="/subdir"
```

### SMB

#### Azure portal

Select **SMB** in the **Type** dropdown under the **Storage Class Type** section, and then input the required information:

:::image type="content" source="media/create-storage-classes/create-smb.png" alt-text="Screenshot of portal showing create SMB storage class." lightbox="media/create-storage-classes/create-smb.png":::

If your AKS Arc instance doesn't have the built-in NFS CSI feature enabled, an error message is displayed, and you are unable to create an NFS storage class. [Follow these instructions](https://aka.ms/aks-arc-nfs-csi) to enable NFS CSI in your cluster, and then create the storage class again.

:::image type="content" source="media/create-storage-classes/create-storage-class-no-csi-smb.png" alt-text="Screenshot of portal showing SMB error when CSI not enabled." lightbox="media/create-storage-classes/create-storage-class-no-csi-smb.png":::

#### Azure CLI

You can create an SMB storage class using Azure CLI:

```azurecli
az k8s-runtime storage-class create `
    --resource-uri <connected cluster resource id> `
    --storage-class-name smb-test `
    --type-properties smb.source="<server address>" `
    --type-properties smb.subDir="/subdir"
```

### AksArcDisk

#### Azure portal

You can create [a storage class for a custom disk](https://aka.ms/aks-arc-custom-disk-storage-class) for AKS Arc. This type is only available for AKS Arc. A storage path is required for this type of storage class. You can select one with the provided selector, or input the storage path resource ID directly:

:::image type="content" source="media/create-storage-classes/create-storage-class-aks-arc-disk.png" alt-text="Screenshot of portal showing create custom disk storage class." lightbox="media/create-storage-classes/create-storage-class-aks-arc-disk.png":::

:::image type="content" source="media/create-storage-classes/custom-disk-properties.png" alt-text="Screenshot of portal showing custom disk properties." lightbox="media/create-storage-classes/custom-disk-properties.png":::

#### Azure CLI

You can create a storage class for a custom disk using Azure CLI:

```azurecli
az k8s-runtime storage-class create `
    --resource-uri <connected cluster resource id> `
    --storage-class-name smb-test `
    --type-properties aksarcdisk.storagePathId="<resource id for the storage path>" `
    --type-properties aksarcdisk.fsType=ext4
```

## Update a storage class

You can update some properties of a storage class using Azure CLI. Consider the following::

- You can't change a storage class from one type to another type.
- Changing most properties of a storage class results in deleting the original and re-creating a new one. However, updating some properties will not delete the original. These properties are called *in-place updatable*. To understand what properties you can update in-place, see the tables in the Reference section.
- When you set the key name in `--type-properties`, use the property name directly without the `<storage class type>.` prefix. Properties that are not part of the storage class type are ignored.

```azurecli
az k8s-runtime storage-class update `
    --resource-uri <connected cluster resource id> `
    --storage-class-name nfs-test `
    --type-properties server=172.23.1.4
```

## Delete a storage class

You can delete a storage class using the Azure portal or Azure CLI.

### Azure portal

To delete storage classes from a cluster using the portal, select the storage classes to delete, then select **Delete** and confirm the action.

:::image type="content" source="media/create-storage-classes/delete-portal.png" alt-text="Screenshot of portal showing delete storage classes." lightbox="media/create-storage-classes/delete-portal.png":::

:::image type="content" source="media/create-storage-classes/delete-confirm.png" alt-text="Screenshot of portal showing storage class delete confirmation." lightbox="media/create-storage-classes/delete-confirm.png":::

### Azure CLI

You can delete a storage class using Azure CLI:

```azurecli
az k8s-runtime storage-class delete --resource-uri <connected resource id> --storage-class-name <storage class name>
```

## Disable Storage Class service

You can disable the Storage Class service using Azure CLI:

```azurecli
az k8s-runtime storage-class disable --resource-uri <resource uri>
```

## Reference

To specify a property when you create a storage class using Azure CLI, you must pass the `<storage class name type in lower cases>.<property name>=<property name>` value to a `--type-properties` command line parameter. You can pass multiple `--type-properties` command line parameters. It's not necessary to pass the `type` property to the CLI. For example, to set the `server` property in an NFS storage class, pass the `--type-properties nfs.server={server address}` value.

When a storage class is updated, if all the properties that changed are updatable in-place (see the **In-place update** column in the following tables), the storage class isn't recreated. If any properties to update are not updatable in-place, the storage class is deleted and re-created.

### NFS

| Property | Type | In-place update | Description |
| -- | -- | -- | -- |
| `type` | `"NFS"` | N/A | Specify this is an NFS type. |
| `server` | `string` | No | NFS server address. |
| `share` | `string` | No | NFS share. |
| `subDir` | `string \| undefined` | No | Subdirectory under `share`. If the subdirectory doesn't exist, the driver creates it. |
| `mountPermissions` | `string \| undefined` | No | Mounted folder permissions. Default is 0. If set as non-zero, the driver performs `chmod` after mount. |
| `onDelete` | `"Delete" \| "Retain"` | No | The action to take when an NFS volume is deleted. Default is `Delete`. |

### SMB

| Property  | Type | In-place update | Description |
| -- | -- | -- | -- |
| `type` | `"SMB"` | N/A | Specify this is an SMB type. |
| `source` | `string` | No |  SMB server source. |
| `subDir` | `string \| undefined` | No | Subdirectory under share. If the subdirectory doesn't exist, the driver creates it. |
| `username` | `string \| undefined` | **Yes** | Server username. |
| `password` | `string \| undefined` (secret) | **Yes** | Server password. |
| `domain` | `string \| undefined` | **Yes** | Server domain. |

### AksArcDisk (only for AKS Arc clusters)

You can create a storage class that uses custom disks. This process is only for AKS Arc clusters. See [Create custom storage class for disks](container-storage-interface-disks.md?tabs=23H2#create-custom-storage-class-for-disks).

| Property  | type | In-place update | description |
| -- | -- | -- | -- | 
| `type` | `"AksArcDisk"` | N/A | Specify this is the AksArcDisk type. |
| `storagePathId` | `string` | No | The resource ID for the storage path. |
| `fsType` | `string \| undefined` | No | `fsType` parameters for the storage class. If the storage class contains Linux workloads, set it to `ext4`. Otherwise, leave it undefined. |

## Other features

### Get attribute detection results

Current detections include:

| Attribute | Azure property | Annotation key | Values | Description |
| -- | -- | -- | -- | --
| Performance | `performance` | `performance` | `"Ultra" \| "Premium" \| "Standard" \| "NotAvailable"` | The performance of the storage class. |
| Failover speed | `failoverSpeed` | `failover` | `"Slow" \| "Fast" \| "Super" \| "NotAvailable"` | How fast a pod using a volume of the storage class can recover when the pod is migrated to another node. |
| Access mode | `accssModes` | `accessModes` | Array of `"ReadWriteOnce" \| "ReadWriteMany" \| "ReadOnlyMany"`.  | If a storage class supports an access mode, a volume of the storage class can be bound to the PVC if PVC specifies its `spec.accessModes` to the access mode. |

You can see the attribute detection results of a storage class in the cloud as described in the next section. If any detection failed or timed out, the property isn't available.

#### Azure portal

The attribute detection results are available in the list, using the following methods.

### REST CLI

```azurecli
> az rest --method get `
>>     --resource https://management.azure.com `
>>     --uri "https://eastus2euap.management.azure.com/subscriptions/$sub/resourceGroups/$rg/providers/Microsoft.Kubernetes/connectedClusters/$arcName/providers/Microsoft.KubernetesRuntime/storageClasses/${scName}?api-version=2023-10-01-preview"
{
  "id": "/subscriptions/<sub id>/resourceGroups/<rg>/providers/Microsoft.Kubernetes/ConnectedClusters/<arcName>/providers/Microsoft.KubernetesRuntime/storageClasses/<scName>",
  "name": "<scName>",
  "properties": {
    "allowVolumeExpansion": "Allow",
    "failoverSpeed": "Super",
    "performance": "Standard",
    "provisioner": "blob.csi.azure.com",
    "provisioningState": "Succeeded",
    "typeProperties": {
      "azureStorageAccountName": "<azure storage account name>",
      "type": "Blob"
    },
    "volumeBindingMode": "WaitForFirstConsumer"
  },
  "systemData": {
    "createdAt": "2023-12-26T05:54:50.0087086Z",
    "createdBy": "3549f238-d80b-4764-af69-14f5b1ae1ff7",
    "createdByType": "Application",
    "lastModifiedAt": "2023-12-26T06:08:14.0742639Z",
    "lastModifiedBy": "3549f238-d80b-4764-af69-14f5b1ae1ff7",
    "lastModifiedByType": "Application"
  },
  "type": "microsoft.kubernetesruntime/storageclasses"
}
```

The result is also available in the `metadata.annotations` field of the storage class. To see the annotations of a storage class using `kubectl`, run the following command. If a detection fails or times out, the annotation is missing:

```powershell
# needs jq to be installed
> kubectl get sc $scName -o jsonpath='{.metadata.annotations}' | jq 
{
  "arcsc.microsoft.com/created-by-azure": "true",
  "arcsc.microsoft.com/failover": "Super",
  "arcsc.microsoft.com/last-push": "{\"time\":\"2024-01-05T08:42:08Z\",\"properties\":{\"allowVolumeExpansion\":null,\"mountOptions\":null,\"provisioner\":\"blob.csi.azure.com\",\"volumeBindingMode\":\"WaitForFirstConsumer\",\"accessModes\":null,\"dataResilience\":null,\"failoverSpeed\":\"Super\",\"limitations\":null,\"performance\":null,\"priority\":null}}",
  "arcsc.microsoft.com/performance": "NotAvailable"
}
```

## Requirement-based PVC storage class selection

When you create a Persistent Volume Claim (PVC), you can add the following annotations to the PVC, and the operator updates the storage class of the PVC with a storage class that has a capability equal to and higher than the level the annotation specifies.

| Annotation | Acceptable values (ordered) |
| -- | -- |
| `arcsc.microsoft.com/require-performance` | `Standard`, `Premium`, `Ultra` |
| `arcsc.microsoft.com/require-failover` | `Slow`, `Fast`, `Super` |

This feature also considers **access modes**. If the PVC specifies `spec.accessModes`, the service only chooses storage classes that either support all of the PVC's `spec.accessModes`, or didn't have their supported access modes detected.

For example, the following YAML code creates a PVC that requires a storage class that has at least the `Standard` performance level, and supports the `ReadWriteOnce` access mode.

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mypvc
  namespace: tst
  annotations:
    arcsc.microsoft.com/require-performance: Standard
spec:
  resources:
    requests:
      storage: 10G
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
```

If there are multiple storage classes that match the criteria, the priority indicated by the `arcsc.microsoft.com/priority` annotation is used, and the one with the highest priority wins. If the annotation value doesn't exist or is not a valid `int64` value, the priority is `0`. If there are multiple matching storage classes with the same priority, the names of the storage classes are sorted alphabetically, and the first one wins.

If there are no storage classes that match the criteria, the PVC creation is rejected, and generates an error message:

```output
Error from server: error when creating ".\\requirements.yaml": admission webhook "mpvc.kb.io" denied the request: No storage class found for specified requirement annotations
```

## Next steps

[Storage class overview](storage-class-overview.md)
