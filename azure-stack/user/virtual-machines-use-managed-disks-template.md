---
title: Use Resource Manager templates for managed disks in Azure Stack Hub
description: Learn about the differences between managed and unmanaged disks when using Azure Resource Manager templates.
author: sethmanheim
ms.author: sethm
ms.date: 8/25/2020
ms.topic: conceptual
ms.reviewer: wellsluo
ms.lastreviewed: 8/25/2020
---


# Use VM managed disks templates

This article describes the differences between managed and unmanaged disks when using Azure Resource Manager templates to provision virtual machines in Azure Stack Hub. The examples help you to convert existing templates that use unmanaged disks to managed disks.

## Unmanaged disks template formatting

To begin, let's take a look at how unmanaged disks are deployed. When creating unmanaged disks, you need a storage account to hold the VHD files. You can create a new storage account or use one that already exists. Create a new storage account resource in the resources block of the template, as follows:

```json
{
    "type": "Microsoft.Storage/storageAccounts",
    "apiVersion": "2017-10-01",
    "name": "[variables('storageAccountName')]",
    "location": "[resourceGroup().location]",
    "sku": {
        "name": "Standard_LRS"
    },
    "kind": "Storage"
}
```

Within the virtual machine object, add a dependency on the storage account to ensure that it's created before the virtual machine. Within the `storageProfile` section, specify the full URI of the VHD location, which references the storage account and is needed for the OS disk and any data disks. The following example creates one OS disk from image and one empty data disk with a 1023GB size:

```json
{
    "type": "Microsoft.Compute/virtualMachines",
    "apiVersion": "2017-12-01",
    "name": "[variables('vmName')]",
    "location": "[resourceGroup().location]",
    "dependsOn": [
    "[resourceId('Microsoft.Storage/storageAccounts/', variables('storageAccountName'))]",
    "[resourceId('Microsoft.Network/networkInterfaces/', variables('nicName'))]"
    ],
    "properties": {
        "hardwareProfile": {...},
        "osProfile": {...},
        "storageProfile": {
            "imageReference": {
                "publisher": "MicrosoftWindowsServer",
                "offer": "WindowsServer",
                "sku": "[parameters('windowsOSVersion')]",
                "version": "latest"
            },
            "osDisk": {
                "name": "osdisk",
                "vhd": {
                    "uri": "[concat(reference(resourceId('Microsoft.Storage/storageAccounts/', variables('storageAccountName'))).primaryEndpoints.blob, 'vhds/osdisk.vhd')]"
                },
                "caching": "ReadWrite",
                "createOption": "FromImage"
            },
            "dataDisks": [
                {
                    "name": "datadisk1",
                    "diskSizeGB": 1023,
                    "lun": 0,
                    "vhd": {
                        "uri": "[concat(reference(resourceId('Microsoft.Storage/storageAccounts/', variables('storageAccountName'))).primaryEndpoints.blob, 'vhds/datadisk1.vhd')]"
                    },
                    "createOption": "Empty"
                }
            ]
        },
        "networkProfile": {...},
        "diagnosticsProfile": {...}
    }
}
```

## Managed disks template formatting

With Azure managed disks, the disk becomes a top-level resource and no longer requires a storage account to be created by the user. Managed disks were first introduced in the `2017-03-30` API version. The following sections walk through the default settings and explain how to further customize your disks.

### Default managed disk settings

To create a VM with managed disks, you no longer need to create the storage account resource. In the template example below, there are some differences from the previous unmanaged disk examples:

- The `apiVersion` is a version for a "virtualMachines" resource type which supports managed disks.
- `osDisk` and `dataDisks` no longer refer to a specific URI for the VHD.
- When deploying without specifying additional properties, the disk uses a storage type based on the size of the VM. For example, if you are using a VM size that supports premium storage (sizes with "s" in their name such as Standard_DS2_v2), then premium disks will be configured by default. You can change this by using the sku setting of the disk to specify a storage type.
- If no name for the disk is specified, it takes the format of `<VMName>_OsDisk_1_<randomstring>` for the OS disk and `<VMName>_disk<#>_<randomstring>` for each data disk.
  - If a VM is being created from a custom image, then the default settings for storage account type and disk name are retrieved from the disk properties defined in the custom image resource. These can be overridden by specifying values for these in the template.
- By default, disk caching is **read/write** for the OS disk and **None** for data disks.
- In the following example, there is still a storage account dependency, though this is only for storage of diagnostics and is not needed for disk storage:

```json
{
    "type": "Microsoft.Compute/virtualMachines",
    "apiVersion": "2017-12-01",
    "name": "[variables('vmName')]",
    "location": "[resourceGroup().location]",
    "dependsOn": [
        "[resourceId('Microsoft.Storage/storageAccounts/', variables('storageAccountName'))]",
        "[resourceId('Microsoft.Network/networkInterfaces/', variables('nicName'))]"
    ],
    "properties": {
        "hardwareProfile": {...},
        "osProfile": {...},
        "storageProfile": {
            "imageReference": {
                "publisher": "MicrosoftWindowsServer",
                "offer": "WindowsServer",
                "sku": "[parameters('windowsOSVersion')]",
                "version": "latest"
            },
            "osDisk": {
                "createOption": "FromImage"
            },
            "dataDisks": [
                {
                    "diskSizeGB": 1023,
                    "lun": 0,
                    "createOption": "Empty"
                }
            ]
        },
        "networkProfile": {...},
        "diagnosticsProfile": {...}
    }
}
```

### Use a top-level managed disk resource

As an alternative to specifying the disk configuration in the virtual machine object, you can create a top-level disk resource and attach it as part of the virtual machine creation. Be sure to use `2017-03-30` as the `disks` resource API version. For example, you can create a disk resource as follows to use as a data disk. In this example, `vmName` is used as part of the disk name:

```json
{
    "type": "Microsoft.Compute/disks",
    "apiVersion": "2017-03-30",
    "name": "[concat(variables('vmName'),'-datadisk1')]",
    "location": "[resourceGroup().location]",
    "sku": {
        "name": "Standard_LRS"
    },
    "properties": {
        "creationData": {
            "createOption": "Empty"
        },
        "diskSizeGB": 1023
    }
}
```

Within the VM object, reference the disk object to be attached. Specifying the resource ID of the managed disk created in the `managedDisk` property allows the attachment of the disk as the VM is created. The `apiVersion` for the VM resource is set to `2017-12-01`. A dependency on the disk resource is added to ensure it's successfully created before VM creation:

```json
{
    "type": "Microsoft.Compute/virtualMachines",
    "apiVersion": "2017-12-01",
    "name": "[variables('vmName')]",
    "location": "[resourceGroup().location]",
    "dependsOn": [
        "[resourceId('Microsoft.Storage/storageAccounts/', variables('storageAccountName'))]",
        "[resourceId('Microsoft.Network/networkInterfaces/', variables('nicName'))]",
        "[resourceId('Microsoft.Compute/disks/', concat(variables('vmName'),'-datadisk1'))]"
    ],
    "properties": {
        "hardwareProfile": {...},
        "osProfile": {...},
        "storageProfile": {
            "imageReference": {
                "publisher": "MicrosoftWindowsServer",
                "offer": "WindowsServer",
                "sku": "[parameters('windowsOSVersion')]",
                "version": "latest"
            },
            "osDisk": {
                "createOption": "FromImage"
            },
            "dataDisks": [
                {
                    "lun": 0,
                    "name": "[concat(variables('vmName'),'-datadisk1')]",
                    "createOption": "attach",
                    "managedDisk": {
                        "id": "[resourceId('Microsoft.Compute/disks/', concat(variables('vmName'),'-datadisk1'))]"
                    }
                }
            ]
        },
        "networkProfile": {...},
        "diagnosticsProfile": {...}
    }
}
```

### Create managed availability sets with VMs using managed disks

To create managed availability sets with VMs using managed disks, add the `sku` object to the availability set resource and set the `name` property to `Aligned`. This property ensures that the disks for each VM are sufficiently isolated from each other to avoid single points of failure. Also note that the `apiVersion` for the availability set resource is set to `2017-12-01`:

```json
{
    "type": "Microsoft.Compute/availabilitySets",
    "apiVersion": "2017-12-01",
    "location": "[resourceGroup().location]",
    "name": "[variables('avSetName')]",
    "properties": {
        "PlatformUpdateDomainCount": 1,
        "PlatformFaultDomainCount": 2
    },
    "sku": {
        "name": "Aligned"
    }
}
```

## Next steps

<!--
* For full templates that use managed disks visit the following Azure Quickstart Repo links.
    * [Windows VM with managed disk](https://github.com/Azure/azure-quickstart-templates/tree/master/101-vm-simple-windows)
    * [Linux VM with managed disk](https://github.com/Azure/azure-quickstart-templates/tree/master/101-vm-simple-linux)
-->

- See [Azure Stack Hub managed disks](azure-stack-managed-disk-considerations.md) to learn more about managed disks.
- Review the template reference documentation for virtual machine resources at the [Microsoft.Compute/virtualMachines template reference](/azure/templates/microsoft.compute/2017-12-01/virtualmachines).
- Review the template reference documentation for disk resources at the [Microsoft.Compute/disks template reference](/azure/templates/microsoft.compute/2017-03-30/disks) document.
