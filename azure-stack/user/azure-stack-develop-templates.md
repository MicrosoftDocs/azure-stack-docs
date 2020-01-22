---
title: Develop templates for Azure Stack Hub | Microsoft Docs
description: Learn how to develop Azure Resource Manager templates for app portability between Azure and Azure Stack Hub.
services: azure-stack
documentationcenter: ''
author: mattbriggs
manager: femila
editor: ''

ms.assetid: 8a5bc713-6f51-49c8-aeed-6ced0145e07b
ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 1/22/2020
ms.author: mabrigg
ms.reviewer: unknown
ms.lastreviewed: 05/21/2019

---

# Develop templates for Azure Stack Hub with Azure Resource Manager

As you develop your app, it is important to have template portability between Azure and Azure Stack Hub. This article provides considerations for developing [Azure Resource Manager templates](https://download.microsoft.com/download/E/A/4/EA4017B5-F2ED-449A-897E-BD92E42479CE/Getting_Started_With_Azure_Resource_Manager_white_paper_EN_US.pdf). With these templates, you can prototype your app and test deployment in Azure without access to an Azure Stack Hub environment.

## Resource provider availability

The template you plan to deploy must only use Microsoft Azure services that are already available, or in preview, in Azure Stack Hub.

## Public namespaces

Because Azure Stack Hub is hosted in your datacenter, it has different service endpoint namespaces than the Azure public cloud. As a result, hard-coded public endpoints in Azure Resource Manager templates fail when you try to deploy them to Azure Stack Hub. You can dynamically build service endpoints using the `reference` and `concatenate` functions to retrieve values from the resource provider during deployment. For example, instead of hard-coding `blob.core.windows.net` in your template, retrieve the [primaryEndpoints.blob](https://github.com/Azure/AzureStack-QuickStart-Templates/blob/master/101-vm-windows-create/azuredeploy.json#L175) to dynamically set the *osDisk.URI* endpoint:

```json
"osDisk": {"name": "osdisk","vhd": {"uri":
"[concat(reference(concat('Microsoft.Storage/storageAccounts/', variables('storageAccountName')), '2015-06-15').primaryEndpoints.blob, variables('vmStorageAccountContainerName'),
 '/',variables('OSDiskName'),'.vhd')]"}}
```

## API versioning

Azure service versions may differ between Azure and Azure Stack Hub. Each resource requires the **apiVersion** attribute, which defines the capabilities offered. To ensure API version compatibility in Azure Stack Hub, the following API versions are valid for each resource provider:

| Resource Provider | apiVersion |
| --- | --- |
| Compute |**2015-06-15** |
| Network |**2015-06-15**, **2015-05-01-preview** |
| Storage |**2016-01-01**, **2015-06-15**, **2015-05-01-preview** |
| KeyVault | **2015-06-01** |
| App Service |**2015-08-01** |

## Template functions

Azure Resource Manager [functions](/azure/azure-resource-manager/resource-group-template-functions) provide the capabilities required to build dynamic templates. As an example, you can use functions for tasks such as:

* Concatenating or trimming strings.
* Referencing values from other resources.
* Iterating on resources to deploy multiple instances.

These functions are not available in Azure Stack Hub:

* Skip
* Take

## Resource location

Azure Resource Manager templates use a `location` attribute to place resources during deployment. In Azure, locations refer to a region such as West US or South America. In Azure Stack Hub, locations are different because Azure Stack Hub is in your datacenter. To ensure templates are transferable between Azure and Azure Stack Hub, you should reference the resource group location as you deploy individual resources. You can do this using `[resourceGroup().Location]` to ensure all resources inherit the resource group location. The following code is an example of using this function while deploying a storage account:

```json
"resources": [
{
  "name": "[variables('storageAccountName')]",
  "type": "Microsoft.Storage/storageAccounts",
  "apiVersion": "[variables('apiVersionStorage')]",
  "location": "[resourceGroup().location]",
  "comments": "This storage account is used to store the VM disks",
  "properties": {
  "accountType": "Standard_GRS"
  }
}
]
```

## Next steps

* [Deploy templates with PowerShell](azure-stack-deploy-template-powershell.md)
* [Deploy templates with Azure CLI](azure-stack-deploy-template-command-line.md)
* [Deploy templates with Visual Studio](azure-stack-deploy-template-visual-studio.md)
