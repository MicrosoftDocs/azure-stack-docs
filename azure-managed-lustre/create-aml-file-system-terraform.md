---
title: Create an Azure Managed Lustre file system by using Terraform
description: Learn how to create an Azure Managed Lustre file system by using Terraform.
services: azure-stack
author: pauljewellmsft
ms.service: azure-stack
ms.topic: how-to
ms.custom: devx-track-terraform
ms.date: 10/25/2023
ms.author: pauljewell
content_well_notification: 
  - AI-contribution
ai-usage: ai-assisted
---

# Create an Azure Managed Lustre file system by using Terraform

In this article, you use Terraform to create an [Azure Managed Lustre](amlfs-overview.md) file system.

[!INCLUDE [About Terraform](../azure-dev-docs-pr/articles/terraform/includes/abstract.md)]

In this article, you learn how to:

> [!div class="checklist"]
>
> * Create a random value (to be used in the resource group name) by using [random_pet](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet).
> * Create an Azure resource group by using [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group).
> * Create an Azure virtual network by using [azurerm_virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network).
> * Create an Azure subnet by using [azurerm_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet).
> * Create a random value (to be used as the Managed Lustre file system name) by using [random_string](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string).
> * Create a Managed Lustre file system by using [azurerm_managed_lustre_file_system](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_lustre_file_system).

> [!NOTE]
> The code examples in this article use the [random_pet](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) and [random_string](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) resources to generate unique values for the resource group name and the Managed Lustre file system name. You can replace these values with your own resource names in the `variables.tf` and `main.tf` files.

## Prerequisites

* [Install and configure Terraform](/azure/developer/terraform/quickstart-configure)

## Implement the Terraform code

> [!NOTE]
> The sample code for this article comes from the [Azure Terraform GitHub repo](https://github.com/Azure/terraform/tree/master/quickstart/101-managed-lustre-create-filesystem). You can view the log file that contains the [test results from current and previous versions of Terraform](https://github.com/Azure/terraform/tree/master/quickstart/101-managed-lustre-create-filesystem/TestRecord.md).
>
> For more articles and sample code that show how to use Terraform to manage Azure resources, see the [main page for Terraform on Azure documentation](/azure/terraform).

1. Create a directory in which to test the sample Terraform code, and make it the current directory.

1. Create a file named `providers.tf` and insert the following code:

    :::code language="Terraform" source="../terraform_samples/quickstart/101-managed-lustre-create-filesystem/providers.tf":::

1. Create a file named `main.tf` and insert the following code:

    :::code language="Terraform" source="../terraform_samples/quickstart/101-managed-lustre-create-filesystem/main.tf":::

1. Create a file named `variables.tf` and insert the following code:

    :::code language="Terraform" source="../terraform_samples/quickstart/101-managed-lustre-create-filesystem/variables.tf":::

1. Create a file named `outputs.tf` and insert the following code:

    :::code language="Terraform" source="../terraform_samples/quickstart/101-managed-lustre-create-filesystem/outputs.tf":::

## Initialize Terraform

[!INCLUDE [terraform-init.md](../azure-dev-docs-pr/articles/terraform/includes/terraform-init.md)]

## Create a Terraform execution plan

[!INCLUDE [terraform-plan.md](../azure-dev-docs-pr/articles/terraform/includes/terraform-plan.md)]

## Apply a Terraform execution plan

[!INCLUDE [terraform-apply-plan.md](../azure-dev-docs-pr/articles/terraform/includes/terraform-apply-plan.md)]

## Verify the results

#### [Azure CLI](#tab/azure-cli)

1. Get the name of the Azure resource group:

    ```console
    resource_group_name=$(terraform output -raw resource_group_name)
    ```

1. Get the name of the Managed Lustre file system:

    ```console
    managed_lustre_file_system_name=$(terraform output -raw managed_lustre_file_system_name)
    ```

1. Run [az amlfs show](/cli/azure/amlfs#az-amlfs-show) to display the name of the Managed Lustre file system:

    ```azurecli
    az amlfs show --resource-group $resource_group_name \
                  --name $managed_lustre_file_system_name \
        
    ```

#### [Azure PowerShell](#tab/azure-powershell)

1. Get the name of the Azure resource group:

    ```console
    $resource_group_name=$(terraform output -raw resource_group_name)
    ```

1. Get the name of the Managed Lustre file system:

    ```console
    $managed_lustre_file_system_name=$(terraform output -raw managed_lustre_file_system_name)
    ```

1. Run [Get-AzStorageCacheAmlFileSystem](/powershell/module/az.storagecache/get-azstoragecacheamlfilesystem) to display the name of the Managed Lustre file system:

    ```azurepowershell
    Get-AzStorageCacheAmlFileSystem -ResourceGroupName $resource_group_name `
                                    -Name $managed_lustre_file_system_name
    ```

---

## Clean up resources

[!INCLUDE [terraform-plan-destroy.md](../azure-dev-docs-pr/articles/terraform/includes/terraform-plan-destroy.md)]

## Troubleshoot Terraform on Azure

See [Troubleshoot common problems when using Terraform on Azure](/azure/developer/terraform/troubleshoot).

## Related content

* [Azure Managed Lustre overview](amlfs-overview.md)
