---
title: Deploy with Visual Studio Code to Azure Stack Hub 
description: As a user, I want to create an Azure Resource Manager template in Visual Studio Code and use the deployment schema to prepare a template that is compatible with my version of Azure Stack Hub.
author: mattbriggs
ms.topic: article
ms.date: 1/22/2020
ms.author: mabrigg
ms.reviewer: sijuman
ms.lastreviewed: 09/30/2019

# Intent: Notdone: As a < type of user >, I want < what? > so that < why? >
# Keyword: Notdone: keyword noun phrase

---


# Deploy with Visual Studio Code to Azure Stack Hub

You can use Visual Studio Code and the Azure Resource Manager Tools extension to create and edit Azure Resource Manager templates that will work with your version of Azure Stack Hub. You can create Resource Manager templates in Visual Studio Code without the extension, but the extension provides autocomplete options that simplify template development. In addition, you can specify a deployment schema that will help you understand the resources available on Azure Stack Hub.

In this article, you will deploy a Windows virtual machine.

## Concepts for Azure Stack Hub Resource Manager

### Azure Stack Hub Resource Manager

To understand the concepts associated with deploying and managing your Azure solutions in Azure Stack Hub, see [Use Azure Resource Manager templates in Azure Stack Hub](azure-stack-arm-templates.md).

### API Profiles
To understand the concepts associated with coordinating resource providers on Azure Stack Hub see [Manage API version profiles in Azure Stack Hub](azure-stack-version-profiles.md).

### The deployment schema

The Azure Stack Hub deployment schema supports hybrid profiles through Azure Resource Manager templates in Visual Studio Code. You can change one line in the JSON template to reference the schema, and then you can then use IntelliSense to review Azure compatible resource. With the schema, review the resource providers, types, and API versions supported within your version of Azure Stack Hub. The schema depends on the API profile to retrieve the specific versions of the API endpoints in the resource providers supported in your version of Azure Stack Hub. You can use the word completion for type and apiVersion, and then you will be limited to the apiVersion and resource types available to the API profile.

## Prerequisites

- [Visual Studio Code](https://code.visualstudio.com/)
- Access to Azure Stack Hub
- [Azure Stack Hub PowerShell installed](https://docs.microsoft.com/azure-stack/operator/azure-stack-powershell-install?toc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure-stack%2Fuser%2FTOC.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure-stack%2Fbreadcrumb%2Ftoc.json) on a machine that reaches the management endpoints

## Install Resource Manager Tools extension

To install the Resource Manager Tools extension, use these steps:

1. Open Visual Studio Code.
2. Press CTRL+SHIFT+X to open the Extensions pane
3. Search for `Azure Resource Manager Tools`, and then select **Install**.
4. Select **Reload** to finish the extension installation.

## Get a template

Instead of creating a template from scratch, you open a template from the AzureStack-QuickStart-Templates (https://github.com/Azure/AzureStack-QuickStart-Templates). AzureStack-QuickStart-Templates is a repository for Resource Manager templates that deploy resources to Azure Stack Hub. 

The template in this article called `101-vm-windows-create`. The template defines a basic deployment of a Windows VM to Azure Stack Hub.  This template also deploys a virtual network (with DNS), network security group, and a network interface.

1. Open Visual Studio Code and navigate to a working folder on your machine.
2. Open the Git bash terminal in Visual Studio Code.
3. Run the following command to retrieve the Azure Stack Hub Quickstart repository.
    ```bash  
    Git clone https://github.com/Azure/AzureStack-QuickStart-Templates.git
    ```
4. Open the directory containing the repository.
    ```bash  
    CD AzureStack-QuickStart-Templates
    ```
5. Select **Open** to open the file at `/101-vm-windows-create/azuredeploy.json` in the repository.
6. Save the file into your own workspace, or if you have created a branch of the repository you can work in place.
7. With the file still open, change the `$Schema` field to `https://schema.management.azure.com/schemas/2019-03-01-hybrid/deploymentTemplate.json#`.
8. You can check that the deployment schema works by clearing the value of the apiProfile field.
    ```JSON  
    "apiProfile": ""
    ```
9. Place your cursor between the empty quotes, and press CTRL+SPACEBAR. You can choose from the valid API profiles in the deployment schema for Azure Stack Hub. You can perform this operation with each of the resource providers in the template.

    ![Azure Stack Hub Resource Manager Deployment Schema](./media/azure-stack-resource-manager-deploy-template-vscode/azure-stack-resource-manager-vscode-schema.png)

10. When you ready, you can deploy your template using PowerShell. Follow the instructions at [Deploy with PowerShell](azure-stack-deploy-template-powershell.md). Specify the location of the template in the script.
11. After you have deployed your Windows VM, navigate to the Azure Stack Hub portal, and find the resource group. If you want to clear the result of this exercise from your Azure Stack Hub, delete the resource group.

## Next steps

- Learn more about [Azure Stack Hub Resource Manager templates](azure-stack-arm-templates.md).  
- Learn more about [API Profiles in Azure Stack Hub](azure-stack-version-profiles.md).