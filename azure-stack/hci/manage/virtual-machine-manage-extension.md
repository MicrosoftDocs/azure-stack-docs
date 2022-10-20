---
title: Manage VM Extensions on Arc-enabled VMs on Azure Stack HCI
description: Learn how to enable guest management and then install and manage extensions on Azure Arc-enabled VMs running on Azure Stack HCI via Azure portal and Azure CLI.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 10/20/2022
---

# Manage VM extensions on Azure Stack HCI virtual machines (preview)

> Applies to: Azure Stack HCI, version 22H2; Azure Stack HCI, version 21H2

Azure guest management on your Azure Arc-enabled VMs on Azure Stack HCI helps you with the post-deployment configurations, and management tasks such as governance, monitoring, updates and security features on your VMs. The VM extensions are useful for post-deployment configuration, software installation, or any other management task such as applying updates or running antivirus scans. This article describes how to install and manage VM extensions on Arc-enabled VMs running on your Azure Stack HCI cluster via the Azure portal and Azure Command Line Interface (CLI).


> [!IMPORTANT]
> This feature on Azure Stack HCI is currently in PREVIEW. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) before you deploy this solution.

## Supported VM extensions

The following VM extensions are supported on Azure Stack HCI VMs. 

### Supported extension on Windows

| Extension       | Publisher  | Type               |
|---------------------|--------------|------------|
| Custom Script Extension | Microsoft.Compute    ||

### Supported extension on Linux

| Extension       |Publisher | Type  |
|---------------------|--------------|------------|
| Custom Script Extension | Microsoft.Compute      ||

## Prerequisites

Before you install and manage VM extensions, make sure that the following prerequisites are completed.

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

You must verify that guest management is enabled on your VMs before you install VM extensions.

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

1. In the Azure portal of your Azure Stack HCI cluster resource, go to **Resources (Preview)** > **Virtual machines**.

1. From the list of the VMs displayed in the right-pane, select the VM where you’ll install the extension. 

1. In the **Overview** blade, under **Properties > Configuration**, verify that the **Guest management** shows as **Enabled**.

   :::image type="content" source="./media/virtual-machine-manage-extension/verify-guest-management-enablement-1.png" alt-text="Screenshot showing guest management as enabled in the selected Arc-enabled VM." lightbox="./media/virtual-machine-manage-extension/verify-guest-management-enablement-1.png":::

---

## Add VM extension

After the guest management enablement is verified, you can now add the VM extension.

### [Azure CLI](#tab/azurecli)

Follow these steps in Azure CLI to add a VM extension.

### [Azure portal](#tab/azureportal)

Follow these steps in Azure portal to add a VM extension.

1. In the Azure portal of your Azure Stack HCI cluster resource, go to **Resources (Preview) > Virtual machines**.

1. Select your VM and go to **Settings > Extensions**.
 
1. From the top of the command bar in the right-pane, select **+ Add**.

    :::image type="content" source="./media/virtual-machine-manage-extension/add-custom-script-extension-1.png" alt-text="Screenshot showing + Add selected to add an extension in the chosen Arc-enabled VM." lightbox="./media/virtual-machine-manage-extension/add-custom-script-extension-1.png":::

1. In the **Install extension**, choose from the available extensions. In this example, we will deploy the **Custom Script Extension for Windows - Azure arc**.

    :::image type="content" source="./media/virtual-machine-manage-extension/add-custom-script-extension-2.png" alt-text="Screenshot showing the Custom Script Extension selected in the chosen Arc-enabled VM." lightbox="./media/virtual-machine-manage-extension/add-custom-script-extension-2.png":::

1. Provide the parameters to configure the selected VM extension. 
    For example, if you choose Custom Script Extension, on the **Create** tab, input the following parameters.

    1. Provide a storage account for your extension. (Should this be a prerequisite? If so, need details.) Will this be for each VM extension you will install?
    1. Browse to the script file that you want to execute at runtime. (Are only PS scripts supported?)
    1. (Optional) Enter the arguments to execute with the script at runtime. (More info, are these the arguments that can be passed for the script?)
    1. Select **Review + Create**.

    :::image type="content" source="./media/virtual-machine-manage-extension/add-custom-script-extension-3.png" alt-text="Screenshot showing configuration of Custom Script Extension installation in the chosen Arc-enabled VM." lightbox="./media/virtual-machine-manage-extension/add-custom-script-extension-3.png":::

The extension may take a few minutes to install. After the extension is installed, the list refreshes to display the newly installed extension.

---


## List installed extensions

You can get a list of all the VM extensions installed on your Azure Stack HCI cluster.

### [Azure CLI](#tab/azurecli)

Follow these steps in Azure CLI to list the installed VM extensions.

### [Azure portal](#tab/azureportal)

Follow these steps in Azure portal to list the installed VM extensions.

---

## Delete VM extension

You may want to delete a VM extension if the installation fails for some reason or if the extension is no longer needed.

### [Azure CLI](#tab/azurecli)

Follow these steps in Azure CLI to remove a VM extension.

### [Azure portal](#tab/azureportal)

Follow these steps in Azure portal to remove a VM extension.

1. In the Azure portal of your Azure Stack HCI cluster resource, go to **Resources (Preview) > Virtual machines**.

1. Select your VM and select **Extensions**.
 
1. From the list of extensions on your VM, choose the extension you wish to remove. From the top command bar, select **Uninstall** to remove the extension.

    In this example, **Custom Script Extension for Windows - Azure arc** is selected.

    :::image type="content" source="./media/virtual-machine-manage-extension/uninstall-custom-script-extension-1.png" alt-text="Screenshot showing Uninstall selected for the chosen Arc-enabled VM." lightbox="./media/virtual-machine-manage-extension/uninstall-custom-script-extension-1.png":::

The extension should take a couple minutes for removal.  

---

## Next steps

Learn how to:

- Troubleshoot [VM extension issues](/azure/azure-arc/servers/troubleshoot-vm-extensions).