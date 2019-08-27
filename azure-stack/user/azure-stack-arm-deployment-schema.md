---
title: Use Azure Resource Manager templates in Azure Stack | Microsoft Docs
description: Learn how to use Azure Resource Manager templates in Azure Stack to provision resources.
services: azure-stack
documentationcenter: ''
author: mattbriggs
manager: femila
editor: ''

ms.assetid: 2022dbe5-47fd-457d-9af3-6c01688171d7
ms.service: azure-stack

ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 08/27/2019
ms.author: sethm
ms.reviewer: sijuman
ms.lastreviewed: 08/27/2019

---

# Azure Stack deployment schema

You can use the deployment schema to coordinate resource providers, types, and API versions supported by Azure Stack. You can specify the API profile in the schema. In addition, the schema supports [IntelliSense](https://code.visualstudio.com/docs/editor/intellisense) in Visual Studio Code to autocomplete your type and API versions when creating an Azure Resource Manager templates.

This article describes the structural change of adopting a new schema of an Azure Resource Manager template. The template consists of JSON and expressions that you can use to construct values for your deployment. To learn more about the different sections of a template, please see: [Understand the structure and syntax of Azure Resource Manager templates](https://docs.microsoft.com/azure/azure-resource-manager/resource-group-authoring-templates). For more information on API Hybrid Profiles, see [Manage API version profiles in Azure Stack](azure-stack-version-profiles.md) 

## Prerequisites 

-   Familiarity with [Azure Resource Manager templates](https://docs.microsoft.com/azure/azure-resource-manager/) 
-   [Visual Studio Code](https://code.visualstudio.com/)
-   [Access to an Azure Stack environment](https://azure.microsoft.com/overview/azure-stack/how-to-buy/)
-   [Azure Stack ARM Quickstart templates](https://github.com/Azure/AzureStack-QuickStart-Templates)
    [Git](https://git-scm.com/) installed on your machine.
-   Familiarity with using [Git and GitHub in Visual Studio Code](https://code.visualstudio.com/Docs/editor/versioncontrol).
-   Resource Manager Tools extension. 

## Install resource manager tools extension

To install, use these steps:

1. Open Visual Studio Code. 
2. Press **CTRL+SHIFT+X** to open the Extensions pane 
3. Search for **Azure Resource Manager Tools**, and then select**Install**. 
4. Select**Reload**to finish the extension installation. 

## Change the deployment schema

1.  Open Visual Studio Code. 
1.  Open a bash prompt and navigate to a working directory on your machine.
1.  Clone the Azure Stack Quick Start repository.
    ```bash  
    git clone https://github.com/Azure/AzureStack-QuickStart-Templates.git
    cd cd AzureStack-QuickStart-Templates
    ```
1.  From Visual Studio Code, select **File > Open.** Select a file in the repository, such as `\101-vm-linux-create\azuredeploy.json`. Review the structure of the ARM template portion with the deployment schema that needs to be changed.

    ```JSON
      { 
      
        "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json\#", 
        "contentVersion": "1.0.0.0", 
        "apiProfile": "2018-03-01-hybrid", 
        "parameters": { }, 
        "variables": { 
          "networkSecurityGroupName": "myNSG"
        }, 
    ```

5.  The schema line will need to be changed to:  
    ```JSON  
    "id": "https://raw.githubusercontent.com/t-anba/azure-resource-manager-schemas/t-anba-AzsDeploymentTemplate-final/schemas/2019-04-01/deploymentTemplate.json#", 
    "$schema": "http://json-schema.org/draft-04/schema#", 
    ```
6.  Once this is complete, specify either the `2018-03-01-hybrid` profile or `2019-03-01-hybrid` profile. This is providing the user IntelliSense for the resource types that are supported by each profile.  

     [!Note] 
     Specifying a profile is not mandatory. When creating a resource, IntelliSense will still be provided, however two api-versions will be listed that are supported by Azure Stack. You can always override the IntelliSense by providing their own api-version, but this may not be supported by Azure Stack. 
1.  You can now add a resource such as a network security group or virtual machine and see auto-complete features be provided for resource providers, parameters, resource types, and API version.  

## Using the azure resource manager tools extension

In Visual Studio Code, you can install the Azure Resource Manager extension to provide language support for Azure Resource Manager deployment templates and template language expressions. It features ARM Template Outline view, colorization for template language expressions, peek, errors, and warnings. This extension can be used with the Azure Stack deployment schema, however, additional steps are needed until the private build fix below is pushed to the tool. To use the schema with the ARM tools extension, please follow the below steps.  

1.    Download Private Build  
    a.  &lt;&lt;azurerm-vscode-tools-0.6.1-alpha.relaxed-schema-rules.vsix&gt;&gt;
    b. ![/var/folders/xd/440h8ph93nv0p5wfnfsrc50h0000gn/T/com.microsoft.Word/Content.MSO/D77A8C94.tmp](media\azure-stack-arm-deployment-schema/media/image2.png){width="0.7166666666666667in" height="0.4625in"}

2.  Press F1  
3.  Extensions: Install from Visx  
4.  Find the vsix build  
5.  Coloration for deployment template should show. 

"As long as it points to a schema ending in deploymentTemplate.json, it will colorize."

## Creating the deployment schema 

To generate/ regenerate a resource provider schema you must: 

1.  Fork [https://github.com/Azure/azure-resource-manager-schemas](https://github.com/Azure/azure-resource-manager-schemas)  
2.  Create your own branch (git checkout -b &lt;branchName&gt;)  
3.  Please include the schema you are updating in the name (ie. MicrosoftCompute-2017-12-01)  
4.  Locate the azure-resource-manager-schemas folder.
5.  Run the following command:
    ```bash
    cd generator  
    Npm install  
    Npm run generate-single -- -ProviderNamespce Microsoft.MyProvider -ApiVersion 2019-04-01  
    ```

### Provide tests. Update tests for the generated schema

1.  Ex: [*https://github.com/Azure/azure-resource-manager-schemas/blob/master/tests/2019-04-01/Microsoft.Storage.tests.json*](https://github.com/Azure/azure-resource-manager-schemas/blob/master/tests/2019-04-01/Microsoft.Storage.tests.json)  

### Validate the schema

1. [https://github.com/Azure/azure-resource-manager-schemas\#running-the-full-suite](https://github.com/Azure/azure-resource-manager-schemas#running-the-full-suite)  

## Publish, commit, and push your branch
1. Create a PR: [*https://github.com/Azure/azure-resource-manager-schemas*](https://github.com/Azure/azure-resource-manager-schemas)  
1. Contact: Anthony Martin &lt;antmarti&gt; for PR approval  

> [!Note]  
> Doing multiple generations of different schemas (ie. Making a script to generate all the schemas instead of individually making a branch for each schema made) will not work. There will only be the most recently generated schema present, the rest will be deleted since upon each generation there is a refresh from master that autorest does. 

## Example generating microsoft web 2018 02 01 schema  

1.  Npm run generate-single -- -ProviderNamespce Microsoft.Web -ApiVersion 2018-02-01  
2.  Create test [*https://github.com/Azure/azure-resource-manager-schemas/pull/637/files\#diff-8f64421b13b95d55eb46cb0e57c6df25*](https://github.com/Azure/azure-resource-manager-schemas/pull/637/files#diff-8f64421b13b95d55eb46cb0e57c6df25) 
4.  Test to verify that a valid resource passes against the schema validation.  
5.  Test one resource type: 

```JSON
      {              
      ----- --- --- ---------------------------------------------------------------------------------------------------------------------------------------
      1                         "name": "web - certificates", 
      2                         "definition": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json\#/definitions/expression", 
      3                         "json": { 
      4                             "name": "certificatesName", 
      5                             "type": "Microsoft.Web/certificates", 
      6                             "location": "West Us", 
      7                             "apiVersion": "2018-02-01", 
      8                             "properties": {} 
      9                         } 
      10                    }, 
```



You must specify the ref value as the value for definition, the type value, and the apiVersion value. 

6.  Note: Define examples of the resource properties in the properties body. **(Anthony Martin can elaborate on this)** 
7.  Resource from generated schema:

    ```JSON
     "certificates": { 
    
           "type": "object", 
    
           "properties": { 
    
             "name": { 
    
               "type": "string", 
    
               "description": "Name of the App Service Environment." 
    
             }, 
    
             "type": { 
    
               "type": "string", 
    
               "enum": \[ 
    
                 "Microsoft.Web/certificates" 
    
               \] 
    
             }, 
    
             "apiVersion": { 
    
               "type": "string", 
    
               "enum": \[ 
    
                 "2018-02-01" 
    
               \] 
    
             }, 
    
             "kind": { 
    
               "type": "string", 
    
               "description": "Kind of resource." 
    
             }, 
    
             "location": { 
    
               "type": "string", 
    
               "description": "Resource Location." 
    
             }, 
    
             "tags": { 
    
               "oneOf": \[ 
    
                 { 
    
                   "type": "object", 
    
                   "additionalProperties": { 
    
                     "type": "string" 
    
                   } 
    
                 }, 
    
                 { 
    
                   "\$ref": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json\#/definitions/expression" 
    
                 } 
    
               \], 
    
               "description": "Resource tags." 
    
             }, 
    
             "properties": { 
    
               "oneOf": \[ 
    
                 { 
    
                   "\$ref": "\#/definitions/CertificateProperties" 
    
                 }, 
    
                 { 
    
                   "\$ref": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json\#/definitions/expression" 
    
                 } 
    
               \], 
    
               "description": "Certificate resource specific properties" 
    
             } 
    
           }, 
    
           "required": \[ 
    
             "name", 
    
             "type", 
    
             "apiVersion", 
    
             "location", 
    
             "properties" 
    
           \], 
    
           "description": "Microsoft.Web/certificates" 
    
         } `
    ```


8.  Reference the generated schema in any root schemas 

-   deploymentTemplates 
-   2014-04-01 
-   2015-01-01 
-   2019-03-01-hybrid 
-   2019-04-01 

9.  Validate the schema: [*https://github.com/Azure/azure-resource-manager-schemas\#running-the-full-suite*](https://github.com/Azure/azure-resource-manager-schemas#running-the-full-suite)

## Next steps

- Azure Stack Resource Manager