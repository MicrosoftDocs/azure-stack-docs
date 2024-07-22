---
title: Create an Azure Managed Lustre file system using Azure Resource Manager templates
description: Use Azure Resource Manager templates with JSON or Bicep to create an Azure Managed Lustre file system. 
ms.topic: overview
ms.date: 02/23/2024
author: pauljewellmsft
ms.author: pauljewell
ms.lastreviewed: 02/21/2023
ms.reviewer: mayabishop

---

# Create an Azure Managed Lustre file system using Azure Resource Manager templates

You can automate Azure Managed Lustre file system creation by using Azure Resource Manager templates. This article explains the basic procedure and gives examples of the files you need.

For more information about the templates, see [Azure Resource Manager templates](/azure/azure-resource-manager/templates/).

This article gives examples of two different methods for creating Azure Resource Manager templates:

* Use JSON to create Azure Resource Manager templates directly. See [JSON template syntax](/azure/azure-resource-manager/templates/syntax).
* Use [Bicep](/azure/azure-resource-manager/bicep/overview?tabs=bicep), which uses simpler syntax to supply the configuration details. When you deploy the template, the Bicep files are converted into Azure Resource Manager template files. See the [Bicep documentation](/azure/azure-resource-manager/bicep/).

To learn more about your options, see [Comparing JSON and Bicep for templates](/azure/azure-resource-manager/bicep/compare-template-syntax).

## Choose file system type and size

Before you write a template, you must make some decisions about your Azure Managed Lustre file system. To learn more about the configuration options, see the setup details at [Create an Azure Managed Lustre file system](create-file-system-portal.md).

When you use a template, specify a **SKU name** to define the basic type of Azure Managed Lustre system to create. If you use the Azure portal to create your Azure Managed Lustre, you specify the system type indirectly by selecting its capabilities.

In Azure, the term **SKU** defines a set of features for the resource being created. For an Azure Managed Lustre file system, the SKU sets system properties such as the type of disks used, the amount of storage supported, and the maximum throughput capacity.

Currently, the following SKUs are supported:

* AMLFS-Durable-Premium-40
* AMLFS-Durable-Premium-125
* AMLFS-Durable-Premium-250
* AMLFS-Durable-Premium-500

These SKUs create a file system that uses durable SSD storage. The following table shows the throughput and storage size values for each SKU:

| SKU | Throughput per TiB storage | Storage Min | Storage Max<sup>1</sup> | Increment |
|----------|-----------|-----------|-----------|-----------|
| AMLFS-Durable-Premium-40 | 40 MB/second | 48 TB | 768 TB | 48 TB|
| AMLFS-Durable-Premium-125 | 125 MB/second | 16 TB | 128 TB | 16 TB |
| AMLFS-Durable-Premium-250 | 250 MB/second | 8 TB | 128 TB | 8 TB |
| AMLFS-Durable-Premium-500 | 500 MB/second | 4 TB | 128 TB | 4 TB |

<sup>1</sup> If you require storage values larger than the listed maximum, you can [open a support ticket](https://ms.portal.azure.com/#view/Microsoft_Azure_Support/HelpAndSupportBlade/~/overview) to explore options.

You can use the [create workflow](create-file-system-portal.md) in Azure portal to check SKU capabilities. SKU-specific settings are on the **Basics** tab under **File system details**.

> [!TIP]
> See [Required information](#required-information) for a command you can use to check the available SKU names.

## Create a template file

Once you decide on configuration options, you can create a template file. The template file is a JSON or Bicep file that contains the configuration details for your Azure Managed Lustre file system. This section explains the property values you can use to configure your file system for deployment.

For example files that contain all possible configuration options, see [Sample JSON files](#sample-json-files) and [Sample Bicep file](#sample-bicep-file).

### Property values

This section describes the information you need to include in your Azure Resource Manager template files to create an Azure Managed Lustre file system. The exact syntax is different between Bicep and JSON, so consult the examples for the literal values.

#### File system

| Name | Description | Value |
| --- | --- | --- |
| type | The type of resource to create. | `Microsoft.StorageCache/amlFileSystems` |
| apiVersion | The version of the Azure Managed Lustre API to use. | Use the current API version, for example, `2024-03-01` |
| name | A unique name for the Azure Managed Lustre file system. | string (required) |
| location | The geo-location where the resource live. Use the short name rather than the display name, for example, use `eastus` instead of `East US`. | string (required) |
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
| storageCapacityTiB | The size of the file system, in TiB. | int (required) |

#### Encryption settings

| Name | Description | Value |
| --- | --- | --- |
| keyEncryptionKey | Specifies the location of the encryption key in Key Vault. | See [template docs](/azure/templates/microsoft.storagecache/amlfilesystems#amlfilesystemencryptionsettings-1) |

#### HSM settings

| Name | Description | Value |
| --- | --- | --- |
| container | Resource ID of storage container used for hydrating the namespace and archiving from the namespace. The resource provider must have permission to create SAS tokens on the storage account. | string (required) |
| importPrefix | Only blobs in the non-logging container that start with this path/prefix get imported into the cluster namespace. This is only used during initial creation of the AML file system. It automatically creates an import job resource that can be deleted. | string |
| importPrefixesInitial | Only blobs in the non-logging container that start with one of the paths/prefixes in this array get imported into the cluster namespace. This is only used during initial creation of the AML file system and has '/' as the default value. It automatically creates an import job resource that can be deleted. | string[] |
| loggingContainer | Resource ID of storage container used for logging events and errors. Must be a separate container in the same storage account as the hydration and archive container. The resource provider must have permission to create SAS tokens on the storage account. | string (required) |

#### Maintenance window

| Name | Description | Value |
| --- | --- | --- |
| dayOfWeek | Day of the week on which the maintenance window can occur. | `Sunday`, `Monday`, `Tuesday`, `Wednesday`, `Thursday`, `Friday`, `Saturday` |
| timeOfDayUTC | The time of day (in UTC) the maintenance window can occur. | string</br>Pattern = `^([0-9]&#124;0[0-9]&#124;1[0-9]&#124;2[0-3]):[0-5][0-9]$` |

#### Root squash settings

| Name | Description | Value |
| --- | --- | --- |
| mode | Squash mode of the AML file system. 'All': User and Group IDs on files will be squashed to the provided values for all users on non-trusted systems. 'RootOnly': User and Group IDs on files will be squashed to provided values for solely the root user on non-trusted systems. 'None': No squashing of User and Group IDs is performed for any users on any systems. | `All`, `None`, `RootOnly` |
| noSquashNidLists | Semicolon separated NID IP address list(s) to be added to the TrustedSystems. | string |
| squashGID | Group ID to squash to. | int |
| squashUID | User ID to squash to. | int |

#### SKU name

| Name | Description | Value |
| --- | --- | --- |
| name | SKU name for the resource. | `AMLFS-Durable-Premium-40`, `AMLFS-Durable-Premium-125`, `AMLFS-Durable-Premium-250`, `AMLFS-Durable-Premium-500` |

## Deploy the file system using the template

The following example steps use Azure CLI commands to create a new resource group and create an Azure Managed Lustre file system.

Before you deploy, make sure you complete the following steps:

* [Choose a file system type and size](#choose-file-system-type-and-size)
* [Create a template file](#create-a-template-file)
* Ensure that all [prerequisites](amlfs-prerequisites.md) are met.

Follow these steps to deploy the file system using the template:

1. Set your default subscription:

   ```azurecli
   az account set --subscription "<SubscriptionID>"
   az account show
   ```
  
1. Optionally, create a new resource group for your Azure Managed Lustre file system. If you want to use an existing resource group, skip this step and provide the name of the existing resource group when you execute the template command.

   ```azurecli
   az group create --name <ResourceGroupName> --location <RegionShortname>
   ```

   Your file system can use resources outside of its own resource group as long as they are in the same subscription.

1. Deploy the Azure Managed Lustre file system by using the template. The syntax is different depending on whether you're using JSON or Bicep files, and the number of files you use.

   You can deploy both Bicep and JSON templates as single files or multiple files. For more information and to see the exact syntax for each option, see the [Azure Resource Manager templates documentation](/azure/azure-resource-manager/templates).

   Example JSON command:

   ```azurecli
   az deployment group create \
     --name <ExampleDeployment> \
     --resource-group <ResourceGroupName> \
     --template-file azlustre-template.json \
     --parameters @azlustre-parameters.json
   ```

   Example Bicep command:

   ```azurecli
   az deployment group create \
    --resource-group <ResourceGroupName> \
    --template-file azlustre.bicep
   ```

## JSON example

This section shows sample contents for a template file and a separate parameters file. These files contain all possible configuration options. You can remove optional parameters when creating your own Azure Resource Manager template.

### Template file

This section shows example contents of a template file:

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "location": {
            "type": "String"
        },
        "apiVersion": {
            "type": "String"
        },
        "fileSystemName": {
            "type": "String"
        },
        "availabilityZone": {
            "type": "Array"
        },
        "subnetId": {
            "type": "String"
        },
        "storageCapacityTiB": {
            "type": "Int"
        },
        "container": {
            "type": "String"
        },
        "loggingContainer": {
            "type": "String"
        },
        "importPrefix": {
            "type": "String"
        },
        "dayOfWeek": {
            "type": "String"
        },
        "timeOfDay": {
            "type": "String"
        },
        "encryptionKeyUrl": {
            "type": "String"
        },
        "encryptionVault": {
            "type": "String"
        }
    },
    "resources": [
        {
            "type": "Microsoft.StorageCache/amlFileSystems",
            "apiVersion": "[parameters('apiVersion')]",
            "name": "[parameters('fileSystemName')]",
            "location": "[parameters('location')]",
            "tags": {
                "MyTagName": "TagValue"
            },
            "sku": {
                "name": "AMLFS-Durable-Premium-250"
            },
            "identity": {
                "type": "UserAssigned",
                "userAssignedIdentities": {
                    "/subscriptions/<subscription_id>/resourcegroups/<identity_resource_group>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<name_of_identity>": {}
                }
            },
            "properties": {
                "storageCapacityTiB": "[parameters('storageCapacityTiB')]",
                "zones": "[parameters('availabilityZone')]",
                "filesystemSubnet": "[parameters('subnetId')]",
                "hsm": {
                    "settings": {
                        "container": "[parameters('container')]",
                        "loggingContainer": "[parameters('loggingContainer')]",
                        "importPrefix": "[parameters('importPrefix')]"
                    }
                },
                "maintenanceWindow": {
                    "dayOfWeek": "[parameters('dayOfWeek')]",
                    "timeOfDay": "[parameters('timeOfDay')]"
                },
                "encryptionSettings": {
                    "keyEncryptionKey": {
                        "keyUrl": "[parameters('encryptionKeyUrl')]",
                        "sourceVault": {
                            "id": "[parameters('encryptionVault')]"
                        }
                    }
                }
            }
        }
    ],
    "outputs": {}
}
```

### Parameters file

This section shows example contents of a parameters file:

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "location": {
            "value": "eastus"
        },
        "apiVersion": {
            "value": "2023-05-01"
        },
        "fileSystemName": {
            "value": "amlfs-example"
        },
        "availabilityZone": {
            "value": [
                "1"
            ]
        },
        "subnetId": {
            "value": "/subscriptions/<subscription_id>/resourceGroups/<vnet_resource_group>/providers/Microsoft.Network/virtualNetworks/<vnet>/subnets/<subnet>"
        },
        "storageCapacityTiB": {
            "value": 4
        },
        "container": {
            "value": "/subscriptions/<subscription_id>/resourceGroups/<storage_account_resource_group>/providers/Microsoft.Storage/storageAccounts/<storage_account_name>/blobServices/default/containers/<container_name>"
        },
        "loggingContainer": {
            "value": "/subscriptions/<subscription_id>/resourceGroups/<storage_account_resource_group>/providers/Microsoft.Storage/storageAccounts/<storage_account_name>/blobServices/default/containers/<log_container_name>"
        },
        "importPrefix": {
            "value": ""
        },
        "dayOfWeek": {
            "value": "Saturday"
        },
        "timeOfDay": {
            "value": "16:45"
        },
        "encryptionKeyUrl": {
            "value": "<encryption_key_URL>"
        },
        "encryptionVault": {
            "value": "/subscriptions/<subscription_id>/resourceGroups/<keyvault_resource_group>/providers/Microsoft.KeyVault/vaults/<keyvault_name>"
        }
    }
}
```

## Bicep example

This example includes all of the possible values in an Azure Managed Lustre template. When creating your template, remove any optional values you don't need.

```bicep
resource fileSystem 'Microsoft.StorageCache/amlFileSystems@2023-05-01' = {
  name: 'fileSystemName'
  location: 'eastus'
  tags: {
    'test-tag': 'test'
  }
  sku: {
    name: 'AMLFS-Durable-Premium-250'
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '/subscriptions/<subscription_id>/resourcegroups/<identity_resource_group>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<name_of_identity>': {
      }
    }
  }
  properties: {
    storageCapacityTiB: 8
    zones: [ 1 ]
    filesystemSubnet: '/subscriptions/<subscription_id>/resourceGroups/<vnet_resource_group>/providers/Microsoft.Network/virtualNetworks/<vnet>/subnets/<subnet>'
    hsm: {
      settings: {
        container: '/subscriptions/<subscription_id>/resourceGroups/<storage_account_resource_group>/providers/Microsoft.Storage/storageAccounts/<storage_account_name>/blobServices/default/containers/<container_name>'
        loggingContainer: '/subscriptions/<subscription_id>/resourceGroups/<storage_account_resource_group>/providers/Microsoft.Storage/storageAccounts/<storage_account_name>/blobServices/default/containers/<log_container_name>'
        importPrefix: ''
      }
    }
    maintenanceWindow: {
      dayOfWeek: 'Friday'
      timeOfDay: '21:00'
    }
    encryptionSettings: {
      keyEncryptionKey: {
        keyUrl: '<encryption_key_URL>'
        sourceVault: {
          id: '/subscriptions/<subscription_id>/resourceGroups/<keyvault_resource_group>/providers/Microsoft.KeyVault/vaults/<keyvault_name>'
        }
      }
    }
  }
}
```

## Next steps

* [Azure Managed Lustre File System overview](amlfs-overview.md)
