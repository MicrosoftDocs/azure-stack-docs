---
title: 'Quickstart: Create an Azure Lustre file system using Terraform'
description: In this quickstart, you create an Azure Lustre file system using Terraform.
services: azure-stack
author: pauljewellmsft
ms.service: azure-stack
ms.topic: quickstart
ms.custom: devx-track-terraform
ms.date: 10/18/2023
ms.author: pauljewell
content_well_notification: 
  - AI-contribution
---

# Quickstart: Create an Azure Lustre file system using Terraform

In this quickstart, you use Terraform to create an [Azure Lustre](amlfs-overview.md) file system.

[!INCLUDE [About Terraform](../../azure-dev-docs-pr/articles/terraform/includes/abstract.md)]

In this article, you learn how to:

> [!div class="checklist"]
> * Create a random value (to be used in the resource group name) using [random_pet](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet)
> * Create an Azure resource group using [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)
> * Create an Azure Virtual Network using [azurerm_virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network)
> * Create an Azure subnet using [azurerm_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet)
> * Create a random value (to be used as the Azure Lustre file system name) using [random_string](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string)
> * Create an Azure Lustre file system using [azurerm_managed_lustre_file_system](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_lustre_file_system)

## Prerequisites

- [Install and configure Terraform](/azure/developer/terraform/quickstart-configure)

## Implement the Terraform code

> [!NOTE]
> The sample code for this article is located in the [Azure Terraform GitHub repo](https://github.com/Azure/terraform/tree/master/quickstart/101-managed-lustre-create-filesystem). You can view the log file containing the [test results from current and previous versions of Terraform](https://github.com/Azure/terraform/tree/master/quickstart/101-managed-lustre-create-filesystem/TestRecord.md).
>
> See more [articles and sample code showing how to use Terraform to manage Azure resources](/azure/terraform)

1. Create a directory in which to test the sample Terraform code and make it the current directory.

1. Create a file named `providers.tf` and insert the following code:

    :::code language="Terraform" source="../terraform_samples/quickstart/101-managed-lustre-create-filesystem/providers.tf":::

1. Create a file named `main.tf` and insert the following code:

    :::code language="Terraform" source="../terraform_samples/quickstart/101-managed-lustre-create-filesystem/main.tf":::

1. Create a file named `variables.tf` and insert the following code:

    :::code language="Terraform" source="../terraform_samples/quickstart/101-managed-lustre-create-filesystem/variables.tf":::

1. Create a file named `outputs.tf` and insert the following code:

    :::code language="Terraform" source="../terraform_samples/quickstart/101-managed-lustre-create-filesystem/outputs.tf":::

## Initialize Terraform

[!INCLUDE [terraform-init.md](~/azure-dev-docs-pr/articles/terraform/includes/terraform-init.md)]

## Create a Terraform execution plan

[!INCLUDE [terraform-plan.md](../azure-dev-docs-pr/articles/terraform/includes/terraform-plan.md)]

## Apply a Terraform execution plan

[!INCLUDE [terraform-apply-plan.md](../../azure-dev-docs-pr/articles/terraform/includes/terraform-apply-plan.md)]

## Verify the results

#### [Azure CLI](#tab/azure-cli)

1. Get the Azure resource group name.

    ```console
    resource_group_name=$(terraform output -raw resource_group_name)
    ```

1. Get the Azure Lustre file system name.

    ```console
    lustre_file_system_name=$(terraform output -raw azurerm_managed_lustre_file_system)
    ```

1. Run [az amlfs show](/cli/azure/amlfs#az-amlfs-show) to display the Lustre file system name.

    ```azurecli
    az amlfs show -n $lustre_file_system_name -g $resource_group_name
    ```

#### [Azure PowerShell](#tab/azure-powershell)

1. Get the Azure resource group name.

    ```console
    $resource_group_name=$(terraform output -raw resource_group_name)
    ```

1. Get the Azure Lustre file system name.

    ```console
    $lustre_file_system_name=$(terraform output -raw azurerm_managed_lustre_file_system)
    ```

1. Run [Get-AzStorageCacheAmlFileSystem](/powershell/module/az.storagecache/get-azstoragecacheamlfilesystem) to display the Lustre file system name.

    
    Get-AzStorageCacheAmlFileSystem -ResourceGroupName $resource_group_name -Name $lustre_file_system_name
    ```

---

## Clean up resources

[!INCLUDE [terraform-plan-destroy.md](../../azure-dev-docs-pr/articles/terraform/includes/terraform-plan-destroy.md)]

## Troubleshoot Terraform on Azure

[Troubleshoot common problems when using Terraform on Azure](/azure/developer/terraform/troubleshoot)

## Next steps

Next, you can monitor the Azure Firewall logs.

> [!div class="nextstepaction"]
> [Learn about Azure Lustre](amlfs-overview.md)
