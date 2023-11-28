---
title: Azure Arc VM management prerequisites (preview)
description: Learn about the prerequisites for deploying Azure Arc VM management (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 11/13/2023
---

# Azure Arc VM management prerequisites (preview)

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article lists the requirements and prerequisites for Azure Arc VM management. We recommend that you review the requirements and complete the prerequisites before you manage your Arc VMs. 

[!INCLUDE [hci-preview](../../includes/hci-preview.md)]


## Azure requirements

The Azure requirements include:

- To provision Arc VMs and VM resources such as virtual disks, logical network, network interfaces and VM images through the Azure portal, you  must have **Contributor** level access at the subscription level.

- Arc VM management infrastructure is supported only in East US and West Europe regions only. For Arc VM management on Azure Stack HCI, all entities must be registered, enabled or created in the same region.

    The entities include Azure Stack HCI cluster, Arc Resource Bridge, Custom Location, VM operator, virtual machines created from Arc and Azure Arc for Servers guest management. These entities can be in different or same resource groups as long as all resource groups are in the same region.


## Azure Command-Line Interface (CLI) requirements

You can connect to Azure Stack HCI system directly or you can access the cluster via a client. Depending on whether you are connecting to the cluster directly or via a client, the steps are different.

### Connect to the cluster directly

If you are accessing the Azure Stack HCI cluster directly, no steps are needed on your part.

During the cluster deployment, an Arc Resource Bridge is created and the Azure CLI extension `stack-hci-vm` is installed on the cluster. You can connect to and manage the cluster using the Azure CLI extension.


### Connect to the cluster via a client

If you are accessing the Azure Stack HCI system via a client, following requirements must be met:
 
- The latest version of Azure Command-Line Interface (CLI). You must install this version on the client that you are using to connect to your Azure Stack HCI cluster.

  - For installation instructions, see [Install Azure CLI](/cli/azure/install-azure-cli-windows). Once you have installed `az` CLI, make sure to restart the system.
  
    - If you're using a local installation, sign in to the Azure CLI by using the [az login](/cli/azure/reference-index#az-login) command. To finish the authentication process, follow the steps displayed in your terminal. For other sign-in options, see [Sign in with the Azure CLI](/cli/azure/authenticate-azure-cli).

    - Run [az version](/cli/azure/reference-index?#az-version) to find the version and dependent libraries that are installed. To upgrade to the latest version, run [az upgrade](/cli/azure/reference-index?#az-upgrade).

- The Azure Stack HCI extension `stack-hci-vm`. Run PowerShell as an administrator on your client and run the following command :

  ```PowerShell
  az extension add --name "stack-hci-vm"
  ```



## Next steps

- [Assign RBAC role for Arc VM management](./assign-vm-rbac-roles.md).
