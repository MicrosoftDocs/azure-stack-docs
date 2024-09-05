---
title: Azure Arc VM management prerequisites
description: Learn about the prerequisites for deploying Azure Arc VM management.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 08/23/2024
---

# Azure Arc VM management prerequisites

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article lists the requirements and prerequisites for Azure Arc VM management. We recommend that you review the requirements and complete the prerequisites before you manage your Arc VMs. 

## Azure requirements

The Azure requirements include:

- To provision Arc VMs and VM resources such as virtual disks, logical network, network interfaces, and VM images through the Azure portal, you must have access to an Azure subscription with the appropriate RBAC role and permissions assigned. For more information, see [RBAC roles for Azure Stack HCI Arc VM management](./assign-vm-rbac-roles.md#about-builtin-rbac-roles).

- Arc VM management infrastructure is supported in the regions documented in the [Azure requirements](../concepts//system-requirements-23h2.md#azure-requirements). For Arc VM management on Azure Stack HCI, all entities must be registered, enabled, or created in the same region.

  The entities include Azure Stack HCI cluster, Arc Resource Bridge, Custom Location, VM operator, virtual machines created from Arc and Azure Arc for Servers guest management. These entities can be in different or same resource groups as long as all resource groups are in the same region.


## Azure Stack HCI cluster requirements

- You have access to an Azure Stack HCI system that is deployed, has an Arc Resource Bridge and a custom location.

  - Go to the **Overview > Server** page in the Azure Stack HCI system resource. Verify that **Azure Arc** shows as **Connected**. You should also see a custom location and an Arc Resource Bridge for your cluster.
    
       :::image type="content" source="./media/azure-arc-vm-management-prerequisites/azure-arc-connected.png" alt-text="Screenshot of the Overview page in the Azure Stack HCI cluster resource showing Azure Arc as connected." lightbox="./media/azure-arc-vm-management-prerequisites/azure-arc-connected.png":::

## Arc VM image requirements

For Arc VM images to be used on Azure Stack HCI, make sure to satisfy the following requirements:

- Use only the English (en-us) language VHDs to create VM images.
- Do not use Azure Virtual machine VHD disk to create VM images.

## Azure Command-Line Interface (CLI) requirements

Skip this section if not using Azure CLI to provision and manage Arc VMs and VM resources.

You can connect to Azure Stack HCI system directly or you can access the cluster remotely. Depending on whether you're connecting to the cluster directly or remotely, the steps are different.

For information on Azure CLI commands for Azure Stack HCI VMs, see [az stack-hci-vm](/cli/azure/stack-hci-vm).

### Connect to the cluster directly

If you're accessing the Azure Stack HCI cluster directly, no steps are needed on your part.

During the cluster deployment, an Arc Resource Bridge is created and the Azure CLI extension `stack-hci-vm` is installed on the cluster. You can connect to and manage the cluster using the Azure CLI extension.

### Connect to the cluster remotely

If you're accessing the Azure Stack HCI system remotely, the following requirements must be met:
 
- The latest version of Azure Command-Line Interface (CLI). You must install this version on the client that you're using to connect to your Azure Stack HCI cluster.

  - For installation instructions, see [Install Azure CLI](/cli/azure/install-azure-cli-windows). Once you have installed `az` CLI, make sure to restart the system.
  
    - If you're using a local installation, sign in to the Azure CLI by using the [az login](/cli/azure/reference-index#az-login) command. To finish the authentication process, follow the steps displayed in your terminal. For other sign-in options, see [Sign in with the Azure CLI](/cli/azure/authenticate-azure-cli).

    - Run [az version](/cli/azure/reference-index?#az-version) to find the version and dependent libraries that are installed. To upgrade to the latest version, run [az upgrade](/cli/azure/reference-index?#az-upgrade).

- The Azure Stack HCI extension `stack-hci-vm`. Run PowerShell as an administrator on your client and run the following command:

  ```PowerShell
  az extension add --name "stack-hci-vm"
  ```



## Next steps

- [Assign RBAC role for Arc VM management](./assign-vm-rbac-roles.md).
