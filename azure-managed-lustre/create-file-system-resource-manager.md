---
title: Create an Azure Managed Lustre file system by using Azure Resource Manager templates
description: Learn how to use Azure Resource Manager templates with JSON or Bicep to create an Azure Managed Lustre file system. 
ms.topic: overview
ms.date: 08/16/2024
author: pauljewellmsft
ms.author: pauljewell
ms.lastreviewed: 08/16/2024
ms.reviewer: ronhogue

---

# Create an Azure Managed Lustre file system by using Azure Resource Manager templates

You can automate the creation of an Azure Managed Lustre file system by using [Azure Resource Manager (ARM) templates](/azure/azure-resource-manager/templates/). This article explains the basic procedure and gives examples of the files that you need.

This article gives examples of two different methods for creating ARM templates:

* Use JSON to create ARM templates directly. To learn more, see [JSON template syntax](/azure/azure-resource-manager/templates/syntax).
* Use [Bicep](/azure/azure-resource-manager/bicep/overview?tabs=bicep), which uses simpler syntax to supply the configuration details. When you deploy the template, the Bicep files are converted into ARM template files. To learn more, see [Bicep documentation](/azure/azure-resource-manager/bicep/).

To learn more about these options, see [Comparing JSON and Bicep for templates](/azure/azure-resource-manager/bicep/compare-template-syntax).

## Choose file system type and size

Before you write a template, you must make some decisions about your Azure Managed Lustre file system. To learn more about the configuration options, see the setup details in [Create an Azure Managed Lustre file system](create-file-system-portal.md).

When you use a template, specify a SKU to define the basic type of Azure Managed Lustre file system to create. The SKU represents a product tier. It sets system qualities such as the type of disks, the supported amount of storage, and the maximum throughput capacity. If you use the Azure portal to create your Azure Managed Lustre file system, you specify the system type indirectly by selecting its capabilities.

The following table shows the values for throughput and storage size in each supported SKU. These SKUs create a file system that uses durable SSD storage.

| SKU | Throughput per TiB storage | Storage minimum | Storage maximum | Increment |
|----------|-----------|-----------|-----------|-----------|
| AMLFS-Durable-Premium-40 | 40 MBps | 48 TB | 768 TB | 48 TB|
| AMLFS-Durable-Premium-125 | 125 MBps | 16 TB | 128 TB | 16 TB |
| AMLFS-Durable-Premium-250 | 250 MBps | 8 TB | 128 TB | 8 TB |
| AMLFS-Durable-Premium-500 | 500 MBps | 4 TB | 128 TB | 4 TB |

If you require storage values larger than the listed maximum, you can [open a support ticket](https://ms.portal.azure.com/#view/Microsoft_Azure_Support/HelpAndSupportBlade/~/overview) to explore options.

To check SKU capabilities, you can use the [workflow for creating a Managed Lustre file system by using the Azure portal](create-file-system-portal.md). SKU-specific settings are on the **Basics** tab under **File system details**.

## Create a template file

After you decide on configuration options, you can create a template file. The template file is a JSON or Bicep file that contains the configuration details for your Azure Managed Lustre file system.

### Template property values

To create an Azure Managed Lustre file system by using an ARM template, you need to include the following information in your template file. The exact syntax is different between Bicep and JSON, so consult the examples for the literal values.

#### File system

| Name | Description | Value |
| --- | --- | --- |
| type | The type of resource to create. | `Microsoft.StorageCache/amlFileSystems` |
| apiVersion | The version of the Azure Managed Lustre API to use. | Use the current API version, for example, `2024-03-01` |
| name | A unique name for the Azure Managed Lustre file system. | string (required) |
| location | The geo-location where the resource lives. Use the short name rather than the display name, for example, use `eastus` instead of `East US`. | string (required) |
| tags | Resource tags for the file system. | Dictionary of tag names and values; see [Tags in templates](/azure/azure-resource-manager/management/tag-resources#arm-templates) |
| sku | Performance SKU for the resource. | See [SKU name](#sku-name) |
| identity | The managed identity to use for the file system, if configured. | See [Identity](#identity) |
| properties | Properties for the file system. | See [Properties](#properties) |
| zones | Availability zones for resources. This field should only contain a single element in the array. | string[] |

#### Identity

| Name | Description | Value |
| --- | --- | --- |
| type | The type of identity used for the resource. | `None`, `UserAssigned` |
| userAssignedIdentities | A dictionary where each key is a user assigned identity resource ID, and each key's value is an empty dictionary. | See [template docs](/azure/templates/microsoft.storagecache/amlfilesystems#userassignedidentities-1) |

#### Properties

| Name | Description | Value |
| --- | --- | --- |
| encryptionSettings | The encryption settings for the file system. | See [Encryption settings](#encryption-settings) |
| filesystemSubnet | The subnet that the file system uses. | string (required) |
| hsm | The Blob Storage container settings for the file system. | See [HSM settings](#hsm-settings) |
| maintenanceWindow | Specifies day and time when system updates can occur. | See [Maintenance window](#maintenance-window) (required) |
| rootSquashSettings | Specifies root squash settings for the file system. | See [Root squash settings](#root-squash-settings) |
| storageCapacityTiB | The size of the file system, in TiB. To learn more about the allowable values for this field based on the SKU, see [Choose file system type and size](#choose-file-system-type-and-size).  | int (required) |

#### Encryption settings

| Name | Description | Value |
| --- | --- | --- |
| keyEncryptionKey | Specifies the location of the encryption key in Key Vault. | See [template docs](/azure/templates/microsoft.storagecache/amlfilesystems#amlfilesystemencryptionsettings) |

#### HSM settings

| Name | Description | Value |
| --- | --- | --- |
| container | Resource ID of storage container used for hydrating the namespace and archiving from the namespace. The resource provider must have permission to create SAS tokens on the storage account. | string (required) |
| importPrefix | Only blobs in the non-logging container that start with this path/prefix get imported into the cluster namespace. This is only used during initial creation of the Azure Managed Lustre file system. | string |
| importPrefixesInitial | Only blobs in the non-logging container that start with one of the paths/prefixes in this array get imported into the cluster namespace. This value is only used during initial creation of the Azure Managed Lustre file system and has '/' as the default value. | string[] |
| loggingContainer | Resource ID of storage container used for logging events and errors. Must be a separate container in the same storage account as the hydration and archive container. The resource provider must have permission to create SAS tokens on the storage account. | string (required) |

> [!NOTE]
> The `importPrefixesInitial` property allows you to specify multiple prefixes for importing data into the file system, while `importPrefix` allows you to specify a single prefix. The default value for both properties is `/`. If you define one of the properties, you can't define the other. If you define both properties, the deployment fails.
>
> To learn more, see [Import prefix](blob-integration.md#import-prefix).

#### Maintenance window

| Name | Description | Value |
| --- | --- | --- |
| dayOfWeek | Day of the week on which the maintenance window can occur. | `Sunday`, `Monday`, `Tuesday`, `Wednesday`, `Thursday`, `Friday`, `Saturday` |
| timeOfDayUTC | The time of day (in UTC) the maintenance window can occur. | string</br>Example: `22:30` |

The `timeOfDayUTC` property uses a 24-hour clock format. For example, `22:30` represents 10:30 PM. The pattern is `^([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$`.

#### Root squash settings

| Name | Description | Value |
| --- | --- | --- |
| mode | Squash mode of the AML file system. 'All': User and Group IDs on files are squashed to the provided values for all users on non-trusted systems. 'RootOnly': User and Group IDs on files are squashed to provided values for solely the root user on non-trusted systems. 'None': No squashing of User and Group IDs is performed for any users on any systems. | `All`, `None`, `RootOnly` |
| noSquashNidLists | Semicolon separated NID IP address list to be added to the TrustedSystems. | string |
| squashGID | Group ID to squash to. | int |
| squashUID | User ID to squash to. | int |

#### SKU name

| Name | Description | Value |
| --- | --- | --- |
| name | SKU name for the resource. | `AMLFS-Durable-Premium-40`, `AMLFS-Durable-Premium-125`, `AMLFS-Durable-Premium-250`, `AMLFS-Durable-Premium-500` |

## Deploy the file system by using the template

The following example steps use Azure CLI commands to create a new resource group and create an Azure Managed Lustre file system in it. The steps assume that you already [chose a file system type and size](#choose-file-system-type-and-size) and [created a template file](#create-a-template-file), as described earlier in this article. Also make sure that you meet all [prerequisites](amlfs-prerequisites.md).

1. Set your default subscription:

   ```azurecli
   az account set --subscription "<subscription-id>"
   az account show
   ```
  
1. Optionally, create a new resource group for your Azure Managed Lustre file system. If you want to use an existing resource group, skip this step and provide the name of the existing resource group when you run the template command.

   ```azurecli
   az group create --name <rg-name> --location <region-short-name>
   ```

   Your file system can use resources outside its own resource group, as long as they're in the same subscription.

1. Deploy the Azure Managed Lustre file system by using the template. The syntax depends on whether you're using JSON or Bicep files, along with the number of files.

   You can deploy both Bicep and JSON templates as single files or multiple files. For more information and to see the exact syntax for each option, see the [ARM template documentation](/azure/azure-resource-manager/templates).

   Example JSON command:

   ```azurecli
   az deployment group create \
     --name <example-deployment> \
     --resource-group <resource-group-name> \
     --template-file azlustre-template.json
   ```

   Example Bicep command:

   ```azurecli
   az deployment group create \
    --resource-group <ResourceGroupName> \
    --template-file azlustre.bicep
   ```

## JSON example

This section shows example contents for a JSON template file. You can remove optional parameters when creating your own ARM template.

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "resources": [
        {
            "type": "Microsoft.StorageCache/amlFilesystems",
            "apiVersion": "2024-03-01",
            "name": "amlfs-example",
            "location": "eastus",
            "tags": {
              "Dept": "ContosoAds"
            },
            "sku": {
              "name": "AMLFS-Durable-Premium-250"
            },
            "identity": {
              "type": "UserAssigned",
              "userAssignedIdentities": {
                "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/<rg-name>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<identity-name>": {}
              }
            },
            "properties": {
              "encryptionSettings": {
                "keyEncryptionKey": {
                  "keyUrl": "https://<keyvault-name>.vault.azure.net/keys/kvk/<key>",
                  "sourceVault": {
                    "id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/<rg-name>/providers/Microsoft.KeyVault/vaults/<keyvault-name>"
                  }
                }
              },
              "filesystemSubnet": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/<rg-name>/providers/Microsoft.Network/virtualNetworks/<vnet-name>/subnets/<subnet-name>",
              "hsm": {
                "settings": {
                  "container": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/<rg-name>/providers/Microsoft.Storage/storageAccounts/<storage-account-name>/blobServices/default/containers/<container-name>",
                  "loggingContainer": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/<rg-name>/providers/Microsoft.Storage/storageAccounts/<storage-account-name>/blobServices/default/containers/<logging-container-name>",
                  "importPrefixesInitial": [
                    "/"
                  ]
                }
              },
              "maintenanceWindow": {
                "dayOfWeek": "Saturday",
                "timeOfDayUTC": "22:00"
              },
              "rootSquashSettings": {
                "mode": "All",
                "noSquashNidLists": "10.0.0.[5-6]@tcp;10.0.1.2@tcp",
                "squashGID": "99",
                "squashUID": "99"
              },
              "storageCapacityTiB": "16"
            },
            "zones": [
              "1"
            ],
        }
    ],
    "outputs": {}
}
```

## Bicep example

This section shows example contents for a Bicep file. You can remove optional parameters when creating your own.

```bicep
resource filesystem 'Microsoft.StorageCache/amlFilesystems@2024-03-01' = {
  name: 'amlfs-example'
  location: 'eastus'
  tags: {
    Dept: 'ContosoAds'
  }
  sku: {
    name: 'AMLFS-Durable-Premium-250'
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/<rg-name>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<identity-name>': {}
    }
  }
  properties: {
    encryptionSettings: {
      keyEncryptionKey: {
        keyUrl: 'https://<keyvault-name>.vault.azure.net/keys/kvk/<key>'
        sourceVault: {
          id: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/<rg-name>/providers/Microsoft.KeyVault/vaults/<keyvault-name>'
        }
      }
    }
    filesystemSubnet: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/<rg-name>/providers/Microsoft.Network/virtualNetworks/<vnet-name>/subnets/<subnet-name>'
    hsm: {
      settings: {
        container: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/<rg-name>/providers/Microsoft.Storage/storageAccounts/<storage-account-name>/blobServices/default/containers/<container-name>'
        importPrefixesInitial: [
          '/'
        ]
        loggingContainer: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/<rg-name>/providers/Microsoft.Storage/storageAccounts/<storage-account-name>/blobServices/default/containers/<logging-container-name>'
      }
    }
    maintenanceWindow: {
      dayOfWeek: 'Saturday'
      timeOfDayUTC: '22:00'
    }
    rootSquashSettings: {
      mode: 'All'
      noSquashNidLists: '10.0.0.[5-6]@tcp;10.0.1.2@tcp'
      squashGID: 99
      squashUID: 99
    }
    storageCapacityTiB: 16
  }
  zones: [
    '1'
  ]
}
```

## Related content

* [Azure Managed Lustre overview](amlfs-overview.md)
