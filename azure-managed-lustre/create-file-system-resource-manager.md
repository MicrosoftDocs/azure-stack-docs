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

In Azure, the term **SKU** defines a set of features for the resource being created. For an Azure Managed Lustre file system, the SKU sets system qualities such as the type of disks used, the amount of storage supported, and the maximum throughput capacity.

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

Once you decide on configuration options, you can create a template file. The template file is a JSON or Bicep file that contains the configuration details for your Azure Managed Lustre file system. This section explains the [required](#required-information) and [optional](#optional-information) information to include in your template file.

For example files that contain all possible configuration options, see [Sample JSON files](#sample-json-files) and [Sample Bicep file](#sample-bicep-file).

### Required information

This section explains the information you need to include in your Azure Resource Manager template files to create an Azure Managed Lustre file system. The exact syntax is different between Bicep and JSON, so consult the examples for each language type for the literal values.

* **Resource type to create** - This value tells Azure Resource Manager that you're creating an Azure Managed Lustre file system by passing a combination of the value `Microsoft.StorageCache/amlFileSystems` and the API version.

  There are several ways to create the resource type:

  * In this article's JSON example, the resource type value is passed literally in the **template.json** file, but the API version value is read from the **parameters.json** file.
  * In the Bicep example, the resource type and API version are passed together at the beginning of the template file.

* **API version** - The version of Azure Managed Lustre to create.

  To find the current API version:

  ```azurecli
  az provider show --namespace Microsoft.StorageCache --query "resourceTypes[?resourceType=='amlFilesystems'].apiVersions" --out table
  ```

* **SKU name** - The performance model for the file system, either `AMLFS-Durable-Premium-125` or `AMLFS-Durable-Premium-250`.

  Use the following command to find available SKUs (use the current API version):

  ```azurecli
  az rest --url https://management.azure.com/subscriptions/<subscription_id>/providers/Microsoft.StorageCache/skus/?api-version=<version> | jq '.value[].name' | grep AMLFS| uniq
  ```

* **Location** - The name of the Azure region where the file system is created.

  To find the regions and availability zones where Azure Managed Lustre is supported:
  
  ```azurecli
  az provider show --namespace Microsoft.StorageCache --query "resourceTypes[?resourceType=='amlFilesystems'].zoneMappings[].{location: location, zones: to_string(zones)}" --out table
  ```

  > [!NOTE]
  > This command outputs the display names of Azure regions; you should use the shorter `name` value (for example, use "eastus" instead of "East US").
  
  This command returns the short name from the display name. West US is an example; this command returns `westus`:

  ```azurecli
  az account list-locations --query "[?displayName=='West US'].name" --output tsv
  ```

* **Availability zone** - The availability zone to use within the Azure region.

  Use the previous command in **Location** to find availability zones. Specify a single availability zone for your system.

* **File system name** - The user-visible name for this Azure Managed Lustre file system.

* **File system subnet** - The subnet that the file system uses. Provide the subnet URI; for example, `/subscriptions/<SubscriptionID>/resourceGroups/<VnetResourceGroupName>/providers/Microsoft.Network/virtualNetworks/<VnetName>/subnets/<SubnetName>`.

* **Storage capacity** - The size of your Azure Managed Lustre cluster, in TiB. Values depend on the SKU. For more information, see  [Choose file system type and size](#choose-file-system-type-and-size).

* **Maintenance period** - Requires two values that set the maintenance period. These values define a 30-minute period weekly during which system updates can be done.

  * Day of the week (for example, `Sunday`)
  * Time of day (UTC) (for example, `22:00`)

### Optional information

The parameters in this section are either optional, or required only if you're using specific features.

* **Tags** - Use this option if you want to set Azure resource metadata tags.

* **Blob integration settings** - Supply these values to use an integrated Blob Storage container with this system. For more information, see [Blob integration](create-file-system-portal.md#blob-integration).

  * **Container** - The resource ID of the blob container to use for Lustre hierarchical storage management (HSM).
  * **Logging container** - The resource ID of a different container to hold import and export logs.
  * **Import prefix** (optional) - If this value is provided, only blobs beginning with the import prefix string are imported into the Azure Managed Lustre File System. If you don't provide it, the default value is `/`, which specifies that all blobs in the container are imported.

* **Customer-managed key settings** - Supply these values if you want to use an Azure Key Vault to control the encryption keys that are used to encrypt your data in the Azure Managed Lustre system. By default, data is encrypted using Microsoft-managed encryption keys.

  * **Identity type** - set this to `UserAssigned` to turn on customer-managed keys.
  * **Encryption Key Vault** - The resource ID of the Azure Key Vault that stores the encryption keys.
  * **Encryption key URL** - The identifier for the key to use to encrypt your data.
  * **Managed identity** - A user-assigned managed identity that the Azure Managed Lustre file system uses to access the Azure Key Vault. For more information, see [Use customer-managed encryption keys](customer-managed-encryption-keys.md).

## Deploy the file system using the template

These example steps use Azure CLI commands to create a new resource group and create an Azure Managed Lustre file system in it.

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

## Sample JSON files

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

## Sample Bicep file

This example includes all of the possible values in an Azure Managed Lustre template. When creating your template, remove any optional values, you don't want.

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
