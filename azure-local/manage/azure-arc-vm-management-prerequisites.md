---
title: Azure Arc VM management prerequisites
description: Learn about the prerequisites for deploying Azure Arc VM management for Azure Local.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack-hci
ms.date: 11/06/2024
---

# Azure Arc VM management prerequisites

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article lists the requirements and prerequisites for Azure Arc VM management on Azure Local. We recommend that you review the requirements and complete the prerequisites before you manage your Arc VMs.

## Azure requirements

The Azure requirements include:

- To provision Arc VMs and VM resources such as virtual disks, logical network, network interfaces, and VM images through the Azure portal, you must have access to an Azure subscription with the appropriate RBAC role and permissions assigned. For more information, see [RBAC roles for Azure Local Arc VM management](./assign-vm-rbac-roles.md#about-builtin-rbac-roles).

- Arc VM management infrastructure is supported in the regions documented in the [Azure requirements](../concepts//system-requirements-23h2.md#azure-requirements). For Arc VM management on Azure Local, all entities must be registered, enabled, or created in the same region.

  The entities include your Azure Local instance, Arc Resource Bridge, Custom Location, VM operator, virtual machines created from Arc and Azure Arc for Servers guest management. These entities can be in different or same resource groups as long as all resource groups are in the same region.


## Azure Local requirements

- You have access to an Azure Local instance that is deployed, has an Arc Resource Bridge, and a custom location.

  - Go to the **Overview > Server** page in the Azure Local resource. Verify that **Azure Arc** shows as **Connected**. You should also see a custom location and an Arc Resource Bridge for your system.
    
      :::image type="content" source="./media/azure-arc-vm-management-prerequisites/azure-arc-connected.png" alt-text="Screenshot of the Overview page in the Azure Local resource showing Azure Arc as connected." lightbox="./media/azure-arc-vm-management-prerequisites/azure-arc-connected.png":::

## Arc VM image requirements

For Arc VM images to be used on Azure Local, make sure to satisfy the following requirements:

- Use only the English (en-us) language VHDs to create VM images.
- Do not use Azure Virtual machine VHD disk to create VM images.

## Azure Command-Line Interface (CLI) requirements

Skip this section if not using Azure CLI to provision and manage Arc VMs and VM resources.

You can connect to your Azure Local system directly or you can access the system remotely. Depending on whether you're connecting to the system directly or remotely, the steps are different.

For information on Azure CLI commands for Azure Local VMs, see [az stack-hci-vm](/cli/azure/stack-hci-vm).

### Connect to the system directly

If you're accessing your Azure Local directly, no steps are needed on your part.

During the system deployment, an Arc Resource Bridge is created and the Azure CLI extension `stack-hci-vm` is installed on the system. You can connect to and manage the system using the Azure CLI extension.

### Connect to the system remotely

If you're accessing your Azure Local remotely, the following requirements must be met:
 
- The latest version of Azure Command-Line Interface (CLI). You must install this version on the client that you're using to connect to your Azure Local.

  - For installation instructions, see [Install Azure CLI](/cli/azure/install-azure-cli-windows). Once you have installed `az` CLI, make sure to restart the system.
  
    - If you're using a local installation, sign in to the Azure CLI by using the [az login](/cli/azure/reference-index#az-login) command. To finish the authentication process, follow the steps displayed in your terminal. For other sign-in options, see [Sign in with the Azure CLI](/cli/azure/authenticate-azure-cli).

    - Run [az version](/cli/azure/reference-index?#az-version) to find the version and dependent libraries that are installed. To upgrade to the latest version, run [az upgrade](/cli/azure/reference-index?#az-upgrade).

- The Azure Local extension `stack-hci-vm`.

    1. In the Azure portal, go to your Azure Local resource and then go to **Operations > Updates**. In the right pane, note the **Current version** that your system is running.
  
        :::image type="content" source="./media/azure-arc-vm-management-prerequisites/identify-software-version-1.png" alt-text="Screenshot of the Updates page in the Azure Local resource showing current software version." lightbox="./media/azure-arc-vm-management-prerequisites/identify-software-version-1.png":::

    1. Match the **Current version** from the Azure portal to **Release build in** the [Arc VM release tracking table](https://aka.ms/arcvm-rel). Then identify the corresponding `stack-hci-vm extension` version from the table. You'll install this version on the client that you are using to connect to your Azure Local.
    
    1. Check if there is a version of the extension installed on the client. Run the following command:
  
        ```azurecli
        az extension list --output table
        ```

    1. If there is an older version installed, remove it and install the new version. Run the following command:
  
        ```azurecli
        az extension remove --name "stack-hci-vm"
        ```

    1. To install the extension, run the following command:
      
        ```azurecli
        az extension add --name "stack-hci-vm" --version "<version>"
        ```

    1. To verify that the extension is installed, use the `list` command again.


## Next steps

- [Assign RBAC role for Arc VM management](./assign-vm-rbac-roles.md).