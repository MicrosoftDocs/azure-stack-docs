---
title: Prepare CentOS Linux image for Azure Stack HCI VM via Azure CLI 
description: Learn how to prepare CentOS Linux images to create Azure Stack HCI VM image.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.custom:
  - devx-track-azurecli
ms.date: 04/29/2024
---

# Prepare CentOS Linux image for Azure Stack HCI virtual machines

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article describes how to prepare a CentOS Linux image to create a virtual machine on your Azure Stack HCI cluster. You use Azure CLI for the VM image creation.

## Prerequisites

Before you begin, make sure that the following prerequisites are completed.

- You have access to an Azure Stack HCI cluster. This cluster is deployed, registered, and connected to Azure Arc. Go to the **Overview** page in the Azure Stack HCI cluster resource. On the **Server** tab in the right-pane, the **Azure Arc** should show as **Connected**.

- You have [downloaded the latest supported ISO image](http://repo1.sea.innoscale.net/centos/7.9.2009/isos/x86_64/) on your Azure Stack HCI cluster. Here, we downloaded the *CentOS-7-x86_64-Everything-2207-02.iso* file. You'll use this image to create a VM image.

## Workflow

Follow these steps to prepare a CentOS image and create a VM image from that image:

1. [Create a CentOS VM](#step-1-create-a-centos-vm).
1. [Connect to VM and install CentOS](#step-2-connect-to-vm-and-install-centos).
1. [Configure VM](#step-3-configure-vm).
1. [Clean up the residual configuration](#step-4-clean-up-residual-configuration).
1. [Create a CentOS VM image](#step-5-create-vm-image).


The following sections provide detailed instructions for each step in the workflow.

## Create VM image from CentOS image

> [!IMPORTANT]
> We recommend that you prepare a CentOS image if you intend to enable guest management on the VMs.

Follow these steps on your Azure Stack HCI cluster to create a VM image using the Azure CLI.

### Step 1: Create a CentOS VM

Follow these steps to use the downloaded CentOS image to provision a VM:

1. Use the downloaded image to create a VM with the following specifications:
    1. Provide a friendly name for your VM.
    
        :::image type="content" source="../manage/media/virtual-machine-image-centos/centos-virtual-machine-name.png" alt-text="Screenshot of the New virtual machine wizard on Specify name and location page." lightbox="../manage/media/virtual-machine-image-centos/centos-virtual-machine-name.png":::

    1. Specify **Generation 2** for your VM as you're working with a VHDX image here.

        :::image type="content" source="../manage/media/virtual-machine-image-centos/centos-virtual-machine-generation.png" alt-text="Screenshot of the New virtual machine wizard on Specify generation page." lightbox="../manage/media/virtual-machine-image-centos/centos-virtual-machine-generation.png":::
    
    1. Assign `4096` for **Startup memory**:
    
        :::image type="content" source="../manage/media/virtual-machine-image-centos/centos-virtual-machine-assign-memory.png" alt-text="Screenshot of the assign memory on Settings page." lightbox="../manage/media/virtual-machine-image-centos/centos-virtual-machine-assign-memory.png":::

    1. Select the virtual network switch that the VM will use for connection.

        :::image type="content" source="../manage/media/virtual-machine-image-centos/centos-virtual-machine-configure-networking.png" alt-text="Screenshot of the Configure networking page." lightbox="../manage/media/virtual-machine-image-centos/centos-virtual-machine-configure-networking.png":::
    
    1. Accept the defaults on the **Connect Virtual Hard Disk** page.

        :::image type="content" source="../manage/media/virtual-machine-image-centos/centos-virtual-machine-connect-virtual-hard-disk.png" alt-text="Screenshot of the New virtual machine wizard on Connect virtual hard disk page." lightbox="../manage/media/virtual-machine-image-centos/centos-virtual-machine-connect-virtual-hard-disk.png":::

    1. Select **Install operating system from a bootable image** option. Point to the ISO that you downloaded earlier.
    
        :::image type="content" source="../manage/media/virtual-machine-image-centos/centos-virtual-machine-iso-option.png" alt-text="Screenshot of the New virtual machine wizard on Installation options page." lightbox="../manage/media/virtual-machine-image-centos/centos-virtual-machine-iso-option.png":::

    See [Provision a VM using Hyper-V Manager](/windows-server/virtualization/hyper-v/get-started/create-a-virtual-machine-in-hyper-v?tabs=hyper-v-manager#create-a-virtual-machine) for step-by-step instructions.


1. Use the UEFI certificate to Secure Boot the VM.
    1. After the VM is created, it shows up in the Hyper-V manager. Select the virtual machine and right-click and then select **Settings**.
    1. In the left pane, select the **Security** tab. Then under **Secure Boot**, from the **Template** dropdown list, select **Microsoft UEFI Certificate Authority**.
    1. Select **OK** to save the changes.

    :::image type="content" source="../manage/media/virtual-machine-image-centos/centos-virtual-machine-microsoft-ufei-certificate-authority.png" alt-text="Screenshot of the secure boot disabled for VM on Settings page." lightbox="../manage/media/virtual-machine-image-centos/centos-virtual-machine-microsoft-ufei-certificate-authority.png":::

1. Select the VM from the Hyper-V Manager and then start the VM. The VM will boot from the ISO image that you provided.

### Step 2: Connect to VM and install CentOS

Once the VM is running, follow these steps:

1. Select the VM from the Hyper-V Manager, right-click to invoke the context menu and then select **Connect**.

1. Select the **Install CentOS 7** option from the boot menu.

1. Select the language and then select **Continue**.

    :::image type="content" source="../manage/media/virtual-machine-image-centos/centos-virtual-machine-select-language.png" alt-text="Screenshot of the select language during CentOS installation." lightbox="../manage/media/virtual-machine-image-centos/centos-virtual-machine-select-language.png":::

1. Select the installation destination and then select **Done**.

    :::image type="content" source="../manage/media/virtual-machine-image-centos/centos-virtual-machine-select-installation-destination.png" alt-text="Screenshot of the installation destination during CentOS installation." lightbox="../manage/media/virtual-machine-image-centos/centos-virtual-machine-select-installation-destination.png":::

1. Select the **Network & host name**.

    :::image type="content" source="../manage/media/virtual-machine-image-centos/centos-virtual-machine-select-network-and-hostname.png" alt-text="Screenshot of the select network and hostname during CentOS installation." lightbox="../manage/media/virtual-machine-image-centos/centos-virtual-machine-select-network-and-hostname.png":::

    Enable the ON switch for the network interface and then select **Done**.

    :::image type="content" source="../manage/media/virtual-machine-image-centos/centos-virtual-machine-switch-network-interface.png" alt-text="Screenshot of the enable network interface during CentOS installation." lightbox="../manage/media/virtual-machine-image-centos/centos-virtual-machine-switch-network-interface.png":::

1. Select **User setting** and set the root password. Enter a password, confirm the password, and select **Done**.

    :::image type="content" source="../manage/media/virtual-machine-image-centos/centos-virtual-machine-set-root-password.png" alt-text="Screenshot of the set root password during CentOS installation." lightbox="../manage/media/virtual-machine-image-centos/centos-virtual-machine-set-root-password.png":::

1. Select **Finish configuration**.

    :::image type="content" source="../manage/media/virtual-machine-image-centos/centos-virtual-machine-finish-configuration.png" alt-text="Screenshot of the select finish configuration during CentOS installation." lightbox="../manage/media/virtual-machine-image-centos/centos-virtual-machine-finish-configuration.png":::

1. Select **Begin Installation**. Once the installation is complete, **Reboot** the VM.

    :::image type="content" source="../manage/media/virtual-machine-image-centos/centos-virtual-machine-reboot.png" alt-text="Screenshot of the begin installation during CentOS installation." lightbox="../manage/media/virtual-machine-image-centos/centos-virtual-machine-reboot.png":::

### Step 3: Configure VM

Follow these steps to configure the VM:

1. Connect and then sign into the VM using the root password that you created during the CentOS installation.
1. Make sure that `cloud-init` was not installed.

    ```bash
    sudo yum list installed | grep cloud-init
    ```

1. Install `cloud-init` and verify the version of the `cloud-init` installed.

    ```bash
    sudo yum install cloud-init
    cloud-init --version
    ```

### Step 4: Clean up residual configuration

Delete machine-specific files and data from your VM so that you can create a clean VM image without any history or default configurations. Follow these steps on your Azure Stack HCI cluster to clean up the residual configuration:

1. Clean `cloud-init` default configurations. 

    ```bash
    sudo yum clean all
    sudo cloud-init clean
    ```

1. Clean up logs and cache.

    ```bash
    sudo rm -rf /var/lib/cloud/ /var/log/* /tmp/*
    ```

1. Remove bash history.

    ```bash
    rm -f ~/.bash_history 
    export HISTSIZE=0 
    logout
    ```

1. Shut down the virtual machine. In the Hyper-V Manager, go to **Action > Shut Down**.
1. Export a VHDX or copy the VHDX from your VM. You can use the following methods:
    - Copy the VHDX as a page blob to a container in Azure Storage account.
    - Alternatively, copy the VHDX to user storage on the cluster shared volume on your Azure Stack HCI.  

### Step 5: Create VM image

Follow these steps on your Azure Stack HCI cluster to create the VM image:

<!--update this as az cli link was added[!INCLUDE [hci-create-a-vm-image](../../includes/hci-create-a-vm-image.md)]-->

1. Run PowerShell as an administrator.

1. Sign in. Run the following cmdlet:

    ```azurecli
    az login
    ```

1. Set your subscription. Run the following cmdlet:

    ```azurecli
    az account set --subscription <Subscription ID>
    ```

1. Set parameters for your subscription, resource group, custom location, location, OS type for the image, name of the image and the path where the image is located. Replace the parameters in `< >` with the appropriate values.

    ```azurecli
    $Subscription = "<Subscription ID>"
    $Resource_Group = "<Resource group>"
    $CustomLocation = "<Custom location>"
    $Location = "<Location for your Azure Stack HCI cluster>"
    $OsType = "<OS of source image>"
    ```
    
    The parameters are described in the following table:
    
    | Parameter      | Description                                                                                |
    |----------------|--------------------------------------------------------------------------------------------|
    | `Subscription`   | Subscription associated with your Azure Stack HCI cluster.        |
    | `Resource_Group` | Resource group for Azure Stack HCI cluster that you associate with this image.        |
    | `Location`       | Location for your Azure Stack HCI cluster. For example, this could be `eastus`, `westreurope`. |
    | `OsType`         | Operating system associated with the source image. This can be Windows or Linux.           |


1. Use the VHDX of the VM to create a gallery image. Use this VM image to create Arc virtual machines on your Azure Stack HCI.

    Make sure to copy the VHDX in user storage in the cluster shared volume of your Azure Stack HCI. For exmaple, the path could look like: `C:\ClusterStorage\UserStorage_1\linuxvhdx`.

    ```powershell
    $ImagePath = "Path to user storage in CSV" 

    $ImageName = "mylinuxvmimg" 

    az stack-hci-vm image create --subscription $subscription -g $resource_group --custom-location $CustomLocation --location $location --image-path $ImagePath --name $ImageName --debug --os-type 'Linux' 
    ```

    For more information, see [Create a VM image using Azure CLI](./virtual-machine-image-local-share.md#azure-cli).
1. Validate that the image is created.

## Next steps

- [Create Arc VMs](./manage-virtual-machines-in-azure-portal.md) on your Azure Stack HCI cluster.
