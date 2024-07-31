---
title: Create an Azure Managed Lustre file system by using Azure Resource Manager templates
description: Learn how to use Azure Resource Manager templates with JSON or Bicep to create an Azure Managed Lustre file system. 
ms.topic: overview
ms.date: 02/23/2024
author: pauljewellmsft
ms.author: pauljewell
ms.lastreviewed: 02/21/2023
ms.reviewer: mayabishop

---

# Create an Azure Managed Lustre file system by using Azure Resource Manager templates

You can automate the creation of an Azure Managed Lustre file system by using [Azure Resource Manager templates (ARM templates)](/azure/azure-resource-manager/templates/). This article explains the basic procedure and gives examples of the files that you need.

This article gives examples of two methods for creating ARM templates:

* Use JSON to create ARM templates directly. For more information, see [Understand the structure and syntax of ARM templates](/azure/azure-resource-manager/templates/syntax).
* Use Bicep, which uses simpler syntax to supply the configuration details. When you deploy the template, the Bicep files are converted into ARM template files. For more information, see the [Bicep documentation](/azure/azure-resource-manager/bicep/).

To learn more about your options, see [Comparing JSON and Bicep for templates](/azure/azure-resource-manager/bicep/compare-template-syntax).

## Choose file system type and size

Before you write a template, you must make some decisions about your Azure Managed Lustre file system. To learn more about the configuration options, see the setup details in [Create an Azure Managed Lustre file system](create-file-system-portal.md).

When you use a template, specify a *SKU* name to define the basic type of Azure Managed Lustre file system to create. The SKU represents a product tier. It sets system qualities such as the type of disks, the supported amount of storage, and the maximum throughput capacity. If you use the Azure portal to create your Azure Managed Lustre file system, you specify the system type indirectly by selecting its capabilities.

The following table shows the values for throughput and storage size in each supported SKU. These SKUs create a file system that uses durable SSD storage.

| SKU | Throughput per TiB storage | Storage minimum | Storage maximum | Increment |
|----------|-----------|-----------|-----------|-----------|
| AMLFS-Durable-Premium-40 | 40 MBps | 48 TB | 768 TB | 48 TB|
| AMLFS-Durable-Premium-125 | 125 MBps | 16 TB | 128 TB | 16 TB |
| AMLFS-Durable-Premium-250 | 250 MBps | 8 TB | 128 TB | 8 TB |
| AMLFS-Durable-Premium-500 | 500 MBps | 4 TB | 128 TB | 4 TB |

If you require storage values larger than the listed maximum, you can [open a support ticket](https://ms.portal.azure.com/#view/Microsoft_Azure_Support/HelpAndSupportBlade/~/overview) to explore options.

To check SKU capabilities, you can use the [workflow for creating a Managed Lustre file system by using the Azure portal](create-file-system-portal.md). SKU-specific settings are on the **Basics** tab under **File system details**.

> [!TIP]
> For a command that you can use to check the available SKU names, see the [Required information](#required-information) section of this article.

## Create a template file

After you decide on configuration options, you can create a template file. The template file is a JSON or Bicep file that contains the configuration details for your Azure Managed Lustre file system.

### Required information

To create an Azure Managed Lustre file system by using an ARM template, you need to include the following information in your template file. The exact syntax is different between Bicep and JSON, so consult the examples for each language type for the literal values.

* **Resource type to create**: This value tells Azure Resource Manager that you're creating an Azure Managed Lustre file system by passing a combination of the value `Microsoft.StorageCache/amlFileSystems` and the API version.

  There are multiple ways to create the resource type:

  * In this article's [JSON example](#example-json-files), the resource type value is passed literally in the *template.json* file, but the API version value is read from the *parameters.json* file.
  * In this article's [Bicep example](#example-bicep-file), the resource type and API version are passed together at the beginning of the template file.

* **API version**: The version of Azure Managed Lustre API for the file system that you want to create.

  To find the current API version, use this command:

  ```azurecli
  az provider show --namespace Microsoft.StorageCache --query "resourceTypes[?resourceType=='amlFilesystems'].apiVersions" --out table
  ```

* **SKU name**: The performance model for the file system, either `AMLFS-Durable-Premium-125` or `AMLFS-Durable-Premium-250`.

  To find available SKUs, use the following command. Include the current API version.

  ```azurecli
  az rest --url https://management.azure.com/subscriptions/<subscription_id>/providers/Microsoft.StorageCache/skus/?api-version=<version> | jq '.value[].name' | grep AMLFS| uniq
  ```

* **Location**: The name of the Azure region for the file system.

  To find the regions and availability zones where Azure Managed Lustre is supported, use this command:
  
  ```azurecli
  az provider show --namespace Microsoft.StorageCache --query "resourceTypes[?resourceType=='amlFilesystems'].zoneMappings[].{location: location, zones: to_string(zones)}" --out table
  ```

  The output for this command lists the display names of Azure regions. You should use the shorter `name` value (for example, use `eastus` instead of `East US`).
  
  The following command returns the short name from the display name. This example uses `West US` as the display name and returns `westus`.

  ```azurecli
  az account list-locations --query "[?displayName=='West US'].name" --output tsv
  ```

* **Availability zone**: The availability zone to use within the Azure region.

  To find availability zones, use the previous command in **Location**. Specify a single availability zone for your system.

* **File system name**: The user-visible name for this Azure Managed Lustre file system.

* **File system subnet**: The subnet that the file system uses. Provide the subnet URI; for example, `/subscriptions/<SubscriptionID>/resourceGroups/<VnetResourceGroupName>/providers/Microsoft.Network/virtualNetworks/<VnetName>/subnets/<SubnetName>`.

* **Storage capacity**: The size of your Azure Managed Lustre cluster, in tebibytes. Values depend on the SKU, as shown in the earlier section [Choose file system type and size](#choose-file-system-type-and-size).

* **Maintenance period**: Two values that define a weekly 30-minute period for system updates:

  * Day of the week (for example, `Sunday`)
  * Time of day in UTC (for example, `22:00`)

### Optional information

The following parameters are optional or are required only if you're using specific features:

* **Tags**: Use this option if you want to set Azure resource metadata tags.

* **Blob integration settings**: Supply these values to use an integrated Azure Blob Storage container with this file system. For more information, see [Blob integration](create-file-system-portal.md#blob-integration).

  * **Container**: The resource ID of the blob container to use for [Lustre Hierarchical Storage Management (HSM)](https://doc.lustre.org/lustre_manual.xhtml#lustrehsm).
  * **Logging container**: The resource ID of a separate container to hold import and export logs. The logging container must be in the same storage account as the data container.
  * **Import prefix** (optional): If you provide this value, only blobs that begin with the import prefix string are imported into the Azure Managed Lustre file system. If you don't provide it, the default value is a slash (`/`), which specifies that all blobs in the container are imported.

* **Customer-managed key settings**: Supply these values if you want to use Azure Key Vault to control the encryption keys that are used to encrypt your data in the Azure Managed Lustre file system. By default, data is encrypted through Microsoft-managed encryption keys.

  * **Identity type**: The identity for management of encryption keys. Set it to `UserAssigned` to turn on customer-managed keys.
  * **Encryption Key Vault**: The resource ID of the key vault that stores the encryption keys.
  * **Encryption key URL**: The identifier for the key to use to encrypt your data.
  * **Managed identity**: A user-assigned managed identity that the Azure Managed Lustre file system uses to access the key vault.
  
  For more information, see [Use customer-managed encryption keys](customer-managed-encryption-keys.md).

## Deploy the file system by using the template

The following example steps use Azure CLI commands to create a new resource group and create an Azure Managed Lustre file system in it. The steps assume that you already [chose a file system type and size](#choose-file-system-type-and-size) and [created a template file](#create-a-template-file), as described earlier in this article. Also make sure that you meet all [prerequisites](amlfs-prerequisites.md).

1. Set your default subscription:

   ```azurecli
   az account set --subscription "<SubscriptionID>"
   az account show
   ```
  
1. Optionally, create a new resource group for your Azure Managed Lustre file system. If you want to use an existing resource group, skip this step and provide the name of the existing resource group when you run the template command.

   ```azurecli
   az group create --name <ResourceGroupName> --location <RegionShortname>
   ```

   Your file system can use resources outside its own resource group, as long as they're in the same subscription.

1. Deploy the Azure Managed Lustre file system by using the template. The syntax depends on whether you're using JSON or Bicep files, along with the number of files.

   You can deploy both Bicep and JSON templates as single files or multiple files. For more information and to see the exact syntax for each option, see the [ARM template documentation](/azure/azure-resource-manager/templates).

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

## Example JSON files

This section shows example contents for a template file and a separate parameters file. These files contain all possible configuration options. You can remove optional parameters when creating your own ARM template.

### Example contents of a template file

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

### Example contents of a parameters file

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

## Example Bicep file

This example includes all of the possible values in an Azure Managed Lustre template. When you create your template, remove any optional values that you don't want.

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

## Related content

* [Azure Managed Lustre overview](amlfs-overview.md)
