---
title: Create storage path for Azure Stack HCI virtual machines images (preview)
description: Learn how to create storage path for use with VM images for your Azure Stack HCI cluster.(preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 10/10/2023
---

# Create storage path for Azure Stack HCI (preview)

> Applies to: Azure Stack HCI, versions 23H2 (preview)

This article describes how to create storage path for VM images used on your Azure Stack HCI cluster. Storage paths are an Azure resource and are used to provide a path to store VM images, working directories, and other important configuration files on your cluster. You can create a storage path using the Azure CLI.


[!INCLUDE [hci-preview](../../includes/hci-preview.md)]

## About storage path

You may need to provide the storage path for the image store for VM images and a cloud store for configuration files. The storage paths should point to cluster shared volumes that can be accessed by all the servers on your cluster. We recommend that you create a separate cluster shared volume for storing the VM images.

The available space in the cluster shared volume determines the size of the store available at the storage path. For example, if the storage path is `C:\ClusterStorage\Volume01` and the `volume01` is 4 TB, then the size of the storage path is the available space on `Volume01`.
  
## Prerequisites

Before you begin, make sure to complete the following prerequisites:

1. Make sure that you have access to an Azure Stack HCI cluster that is deployed and registered. During the deployment, an Arc Resource Bridge and a custom location are also created. 
    
    Go to the resource group in Azure. You can see the custom location and Azure Arc Resource Bridge created for the Azure Stack HCI cluster. Make a note of the subscription, resource group, and the custom location as you use these later in this scenario.

1. Make sure that a cluster shared volume exists on your Azure Stack HCI cluster that is accessible from all the servers in the cluster. The storage path that you intend to provide on a cluster shared volume should have sufficient space for storing VM images.

    You can create storage paths only within cluster shared volumes that are available in the cluster. For more information, see [Create a cluster shared volume](/windows-server/failover-clustering/failover-cluster-csvs#add-a-disk-to-csv-on-a-failover-cluster).


## Create a storage path on your cluster

You can use the `stack-hci-vm storagepath` cmdlets to create, show, and list the storage paths on your Azure Stack HCI cluster.

### Review parameters used to create a storage path

The following parameters are *required* when you create a storage path:

| Parameter | Description |
| ----- | ----------- |
| **name** | Name of the storage path that you create for your Azure Stack HCI cluster. Make sure to provide a name that follows the [Rules for Azure resources.](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-networking) You can't rename a storage path after it's created. |
| **resource-group** |Name of the resource group where you create the storage path. For ease of management, we recommend that you use the same resource group as your Azure Stack HCI cluster. |
| **subscription** |Name or ID of the subscription where your Azure Stack HCI is deployed. This could also be another subscription you use for storage path on your Azure Stack HCI cluster. |
| **CustomLocationID** |Name or ID of the custom location associated with your Azure Stack HCI cluster where you're creating this storage path. |
| **path** | Path on a disk to create storage path. The selected path should have sufficient space available for storing your VM image. |


You could also use the following *optional* parameters:

| Parameter | Description |
| ----- | ----------- |
| **location** | Azure regions as specified by `az locations`. |


### Create a storage path

Follow these steps on one of the servers of your Azure Stack HCI cluster to create a storage path:

1. Connect to one of the servers of your Azure Stack HCI cluster via Remote Desktop Protocol. 

1. Run PowerShell as an administrator.

1. Sign in. Type:

    ```azurecli
    az login --use-device-code
    ```
       
1. Set your subscription. Replace the parameter in `< >`` with the appropriate value.

    ```azurecli 
    az account set --subscription <Subscription ID>
    ```

1. Set parameters for your subscription, resource group, location, OS type for the image. Replace the `< >` with the appropriate values.

    ```azurecli
    $storagepathname="<Storage path name>"
    $path="<Path on the disk to cluster shared volume>"
    $subscription="<Subscription ID>"
    $resourcegroup="<Resource group name>"
    $customloc_name="<Custom location of your Azure Stack HCI cluster>"
    $location="<Azure region where the cluster is deployed>"
    ```

1. Create a storage path `test-storagepath` at the following path: `C:\ClusterStorage\test-storagepath`. Run the following cmdlet:
 
    ```azurecli
    az stack-hci-vm storagepath create --resource-group $resourcegroup --custom-location $customLocationID --name $storagepathname --path $path
    ```
    For more information on this cmdlet, see [az stack-hci-vm storagepath create](../index.yml).

    Here's a sample output:

    ```console
    PS C:\windows\system32> $storagepathname="test-storagepath"
    PS C:\windows\system32> $path="C:\ClusterStorage\Volume01"
    PS C:\windows\system32> $subscription="<Subscription ID>"
    PS C:\windows\system32> $resourcegroup="hcirg"
    PS C:\windows\system32> $customLocationID="/subscriptions/<Subscription ID>/resourceGroups/hcirg/providers/Microsoft.ExtendedLocation/customLocations/mytest-cl"

    PS C:\windows\system32> az stack-hci-vm storagepath create --name $storagepathname -g $resourcegroup --custom-location $customLocationID --path $path
    Command group 'stack-hci-vm' is experimental and under development. Reference and support levels: https://aka.ms/CLI_refstatus
    {
      "extendedLocation": {
        "name": "/subscriptions/<Subscription ID>/resourceGroups/hcirg/providers/Microsoft.ExtendedLocation/customLocations/mytest-cl",
        "type": "CustomLocation"
      },
      "id": "/subscriptions/<Subscription ID>/resourceGroups/hcirg/providers/Microsoft.AzureStackHCI/storagecontainers/test-storagepath",
      "location": "eastus2euap",
      "name": "test-storagepath",
      "properties": {
        "path": "C:\\ClusterStorage\\Volume01",
        "provisioningState": "Succeeded",
        "status": {
          "availableSizeMB": 36761,
          "containerSizeMB": 243097
        }
      },
      "resourceGroup": "hcirg",
      "systemData": {
        "createdAt": "2023-10-06T04:45:30.458242+00:00",
        "createdBy": "guspinto@contoso.com",
        "createdByType": "User",
        "lastModifiedAt": "2023-10-06T04:45:57.386895+00:00",
        "lastModifiedBy": "319f651f-7ddb-4fc6-9857-7aef9250bd05",
        "lastModifiedByType": "Application"
      },
      "tags": null,
      "type": "microsoft.azurestackhci/storagecontainers"
    }
    ```


Once the storage path creation is complete, you're ready to create virtual machine images.



### Delete a storage path

If a storage path is not required, you can delete it. To delete a storage path, first remove the associated workloads and then run the following command to delete the storage path:

```azurecli
az stack-hci-vm storagepath delete --resource-group "<resource group name>" --name "<storagepath name>" --yes
```

To verify that a storage path is actually deleted, run the following command:

```azurecli
az stack-hci-vm storagepath show --resource-group "<resource group name>" --name "<storagepath name>" 
```

You'll receive a notification that the storage path doesn't exist.

To delete a volume, first remove the associated workloads, then remove the storage paths, and then delete the volume.

If there's insufficient space at the storage path, then the VM provisioning using that storage path would fail. You may need to expand the volume associated with the storage path. For more information, see [Expand the volume](./manage-volumes.md#expand-volumes).

## Next steps

- [Create VM image using the Azure Marketplace](./virtual-machine-image-azure-marketplace.md).
- [Create VM image using an image in Azure Storage account](./virtual-machine-image-storage-account.md).
- [Create VM image using an image in local file share](./virtual-machine-image-local-share.md).