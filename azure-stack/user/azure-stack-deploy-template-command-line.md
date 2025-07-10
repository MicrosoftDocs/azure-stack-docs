---
title: Deploy a template with the command line in Azure Stack Hub 
description: Learn how to use the Azure cross-platform command-line interface (CLI) to deploy templates to Azure Stack Hub.
author: sethmanheim

ms.topic: install-set-up-deploy
ms.date: 2/1/2021
ms.author: sethm
ms.reviewer: unknown
ms.lastreviewed: 05/09/2019

# Intent: As an Azure Stack user, I want to deploy a template using the command line in Azure Stack so I can manage resources efficiently.
# Keyword: deploy template command line

---

# Deploy a template with the command line in Azure Stack Hub

You can use the Azure command-line interface (CLI) to deploy Azure Resource Manager templates in Azure Stack Hub. Azure Resource Manager templates deploy and set up resources for your app in a single, coordinated action.

## Deploy template

1. Browse the [AzureStack-QuickStart-Templates repo](https://aka.ms/AzureStackGitHub) and find the **101-create-storage-account** template. Save the template (`azuredeploy.json`) and parameter files `(azuredeploy.parameters.json`) to a location on your local drive such `C:\templates\`
2. Navigate to the folder into which you downloaded the files. 
3. [Install and connect](azure-stack-version-profiles-azurecli2.md) to Azure Stack Hub with Azure CLI.
4. Update the region and location in the following command. Use `local` for the location parameter if you are using the ASDK. To deploy the template:
    ```azurecli
    az group create --name testDeploy --location local
    az deployment group create --resource-group testDeploy --template-file ./azuredeploy.json --parameters ./azuredeploy.parameters.json
    ```

This command deploys the template to the resource group **testDeploy** in your Azure Stack Hub instance.

## Validate template deployment

To review the resource group and storage account, run the following CLI commands:

```azurecli
az group list
az storage account list
```

## Next steps

Learn how to [deploy templates using PowerShell](azure-stack-deploy-template-powershell.md).
