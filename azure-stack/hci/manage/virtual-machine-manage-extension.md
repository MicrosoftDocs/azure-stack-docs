---
title: Install, manage extensions on Arc-enabled VMs on Azure Stack HCI
description: Learn how to install and manage extensions on Azure Arc-enabled VMs running on Azure Stack HCI via Azure portal and Azure CLI.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 10/18/2022
---

# Install and manage extensions on Azure Stack HCI virtual machines (preview)

> Applies to: Azure Stack HCI, version 22H2; Azure Stack HCI, version 21H2

The Custom Script Extension downloads and runs scripts or commands on Azure Arc-enabled virtual machines (VMs) running on your Azure Stack HCI. This article describes how to install and manage custom script extensions on Arc-enabled VMs running on your Azure Stack HCI cluster via the Azure portal and Azure Command Line Interface (CLI). 

## About Custom Script Extension

The Custom Script Extension is useful for post-deployment configuration, software installation, or any other configuration or management task such as applying updates or running antivirus scan. You can download scripts from Azure Storage or another accessible internet location, or you can provide scripts or commands to the extension runtime.
The Custom Script Extension integrates with the Azure Resource Manager templates. You can also run it by using Azure CLI or via the Azure portal.


> [!IMPORTANT]
> This feature on Azure Stack HCI is currently in PREVIEW. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) before you deploy this solution.

## Supported OS for extension on Windows

The Custom Script Extension for Windows will run on the following operating systems (OS). Other versions may work but haven't been tested in-house on VMs running on Azure Stack HCI.

| Distribution        | Version |
|---------------------|---------|
| Windows Server 2022 | Core    |
| Windows Server 2019 | Core    |

## Prerequisites

Before you install and manage Custom Script Extension, make sure that the following prerequisites are completed.

### [Azure CLI](#tab/azurecli)

Before you begin, make sure that:

- You’ve access to an Arc-enabled Azure Stack HCI VM that has guest management enabled. Currently, guest management is supported only on Windows VMs. For more information on how to create an Arc-enabled VM, see [Deploy Arc-enabled VMs on your Azure Stack HCI cluster](./manage-virtual-machines-in-azure-portal.md). 

- You've access to a client that can connect to your Azure Stack HCI cluster. This client should be:

    - Running PowerShell 5.0 or later.
    - Running the latest version of `az` CLI.
        - [Download the latest version of `az` CLI](/cli/azure/install-azure-cli-windows?tabs=azure-cli). Once you have installed `az` CLI, make sure to restart the system.
        -  If you have an older version of `az` CLI running, make sure to uninstall the older version first.

### [Azure portal](#tab/azureportal)

Before you begin, make sure that:

- You’ve access to an Arc-enabled Azure Stack HCI VM that has guest management enabled. Currently, guest management is supported only on Windows VMs. For more information on how to create an Arc-enabled VM, see [Deploy Arc-enabled VMs on your Azure Stack HCI cluster](./manage-virtual-machines-in-azure-portal.md). 

---

## Verify guest management is enabled

Azure guest management on your Azure Arc-enabled VMs helps you with the post-deployment configurations, and management tasks such as governance, monitoring, updates and security features on your VMs. You must verify that guest management is enabled on your VMs before you install VM extensions.

### [Azure CLI](#tab/azurecli)

Follow these steps to verify that guest management is enabled using the Azure CLI.

### Set some parameters

1. Run PowerShell as an administrator.


1. Sign in. Type:

    ```azurecli
    az login
    ```

1. Set your subscription.

    ```azurecli
    az account set --subscription <Subscription ID>
    ```

1. Set parameters for your subscription, resource group, location, OS type for the image. Replace the parameters in `< >` with the appropriate values.

    ```azurecli
    $Subscription = "<Subscription ID>"
    $Resource_Group = "<Resource group>"
    $Location = "<Location for your Azure Stack HCI cluster>"
    $OsType = "<OS of source image>"
    ```
    
    The parameters are described in the following table:
    
    | Parameter      | Description                                                                                |
    |----------------|--------------------------------------------------------------------------------------------|
    | `Subscription`   | Resource group for Azure Stack HCI cluster that you'll associate with this image.        |
    | `Resource_Group` | Resource group for Azure Stack HCI cluster that you'll associate with this image.        |
    | `Location`       | Location for your Azure Stack HCI cluster. For example, this could be `eastus`, `eastus2euap`. |
    | `OsType`         | Operating system associated with the source image. This can be Windows or Linux.           |

    Here's a sample output:
    
    ```
    PS C:\Users\azcli> $subscription = "<Subscription ID>"
    PS C:\Users\azcli> $resource_group = "mkclus90-rg"
    PS C:\Users\azcli> $location = "eastus2euap"
    PS C:\Users\azcli> $osType = "Windows"
    ```


### [Azure portal](#tab/azureportal)

Follow these steps to verify that guest management is enabled using the Azure portal.

1. In the Azure portal of your Azure Stack HCI cluster resource, go to **Resources** > **Virtual machines**.

1. From the list of the VMs displayed in the right-pane, select the VM where you’ll install the extension. 

1. In the **Overview** blade, under **Properties > Configuration**, verify that the guest management shows as enabled. 

   :::image type="content" source="./media/manage-vm-resources/add-image-from-azure-marketplace.png" alt-text="Screenshot showing Add VM image from Azure Marketplace option." lightbox="./media/manage-vm-resources/add-image-from-azure-marketplace.png":::

---


## Add VM extension

After the guest management enablement is verified, you can now install the VM extension.

# [Azure CLI](#tab/azurecli)

Follow these steps in Azure CLI to add a VM extension.

# [Azure portal](#tab/azureportal)

Follow these steps in Azure portal to add a VM extension.

---

## Delete VM extension

You may want to delete a VM extension if the installation fails for some reason or if the extension is no longer needed.

# [Azure CLI](#tab/azurecli)

Follow these steps in Azure CLI to remove a VM extension.

# [Azure portal](#tab/azureportal)

Follow these steps in Azure portal to remove a VM extension.

---

## Next steps

Use VM images to [Create Arc-enabled VMs](./manage-virtual-machines-in-azure-portal.md).