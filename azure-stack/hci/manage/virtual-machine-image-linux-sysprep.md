---
title: Sysprep Linux image for Azure Stack HCI VM via Azure CLI (preview)
description: Learn how to sysprep Linux images to create Azure Stack HCI VM image (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.custom:
  - devx-track-azurecli
ms.date: 06/28/2023
---

# Sysprep Ubuntu image for Azure Stack HCI virtual machines (preview)

[!INCLUDE [hci-applies-to-22h2-21h2](../../includes/hci-applies-to-22h2-21h2.md)]

This article describes how to prepare an Ubuntu image to create a virtual machine on your Azure Stack HCI cluster. You'll use Azure CLI for the VM image creation.

[!INCLUDE [hci-preview](../../includes/hci-preview.md)]

## Prerequisites

Before you begin, make sure that the following prerequisites are completed.

- You've access to an Azure Stack HCI cluster. This cluster is deployed, registered, and connected to Azure Arc. Go to the **Overview** page in the Azure Stack HCI cluster resource. On the **Server** tab in the right-pane, the **Azure Arc** should show as **Connected**.

- Access to a client that can connect to your Azure Stack HCI cluster. This client should be:

    - Running PowerShell 5.0 or later.
    - Running the latest version of `az` CLI.
        - [Download the latest version of `az` CLI](/cli/azure/install-azure-cli-windows?tabs=azure-cli). Once you have installed `az` CLI, make sure to restart the system.
        -  If you have an older version of `az` CLI running, make sure to uninstall the older version first.

- [Download latest supported Ubuntu server image](https://ubuntu.com/download/server) on your local system. You are required to sysprep gallery images for guest management for VMs created using Ubuntu images.

## Workflow 

Follow these steps to sysprep an Ubuntu image and create VM image from that image: 

1. [Create an Ubuntu VM](#step-1-create-an-ubuntu-vm).
1. [Configure the VM](#step-2-configure-vm). 
1. [Clean up the residual configuration](#step-3-clean-up-residual-configuration).
1. [Create an Ubuntu VM image](#step-4-create-vm-image).

The following sections provide detailed instructions for each step in the workflow.

## Create VM image from Ubuntu image

> [!IMPORTANT]
> We recommend that you sysprep an Ubuntu image if you intend to enable guest management on the VMs.

Follow these steps to create a VM image using the Azure CLI.

### Step 1: Create an Ubuntu VM

Follow these steps to use the downloaded Ubuntu image to provision a VM:

1. Use the downloaded image to create a VM with the following specifications: 
    1. Provide a friendly name for your VM. 
    
        :::image type="content" source="../manage/media/manage-vm-resources/ubuntu-virtual-machine-name.png" alt-text="Screenshot of the New virtual machine wizard on Specify name and location page." lightbox="../manage/media/manage-vm-resources/ubuntu-virtual-machine-name.png":::

    1. Specify **Generation 2** for your VM as you're working with a VHDX image here.

        :::image type="content" source="../manage/media/manage-vm-resources/ubuntu-virtual-machine-generation.png" alt-text="Screenshot of the New virtual machine wizard on Specify generation page." lightbox="../manage/media/manage-vm-resources/ubuntu-virtual-machine-generation.png":::
    
    1. Select **Install operating system from a bootable image** option. Point to ISO that you downloaded earlier.
    
        :::image type="content" source="../manage/media/manage-vm-resources/ubuntu-virtual-machine-iso-option.png" alt-text="Screenshot of the New virtual machine wizard on Installation options page." lightbox="../manage/media/manage-vm-resources/ubuntu-virtual-machine-iso-option.png":::

    See [Provision a VM using Hyper-V Manager](/windows-server/virtualization/hyper-v/get-started/create-a-virtual-machine-in-hyper-v?tabs=hyper-v-manager#create-a-virtual-machine) for step-by-step instructions.

1. Disable secure boot on the VM. 
    1. After the VM is created, it shows up in the Hyper-V manager. Select the virtual machine and right-click and then select **Settings**. 
    1. In the left pane, select the **Security** tab. Then under **Secure Boot**, uncheck **Enable Secure Boot**. 
    1. Apply the changes. On the next boot, the VM boots without the secure mode.

    :::image type="content" source="../manage/media/manage-vm-resources/ubuntu-virtual-machine-secure-boot-disabled.png" alt-text="Screenshot of the secure boot disabled for VM on Settings page." lightbox="../manage/media/manage-vm-resources/ubuntu-virtual-machine-secure-boot-disabled.png":::

### Step 2: Configure VM

Follow these steps to configure the VM that you provisioned earlier:

1. Sign into the VM. See steps in [Connect to a Linux VM](/azure/databox-online/azure-stack-edge-gpu-deploy-virtual-machine-portal#connect-to-a-linux-vm).
1. To download all the latest package lists from the repositories, run the following command:

    ```azurecli
    sudo apt update
    ```
1. Install [Azure tailored kernel](https://ubuntu.com/blog/microsoft-and-canonical-increase-velocity-with-azure-tailored-kernel). This is a required step for your VM to get an IP for the network interface.

    ```azurecli
    sudo apt install linux-azure -y
    ```
1. Install SSH server. Run the following command:

    ```azurecli
    sudo apt install openssh-server openssh-client -y
    ```

1. Configure passwordless sudo. Add the following at the end of `/etc/sudoers` file using `visudo`:

    ```azurecli
    ALL ALL=(ALL) NOPASSWD:ALL
    ```

### Step 3: Clean up residual configuration

Delete machine-specific files and data from your VM so that you can create a clean VM image without any history or default configurations.

1. Clean `cloud-init` default configurations.

    ```bash
    sudo rm -f /etc/cloud/cloud.cfg.d/50-curtin-networking.cfg /etc/cloud/cloud.cfg.d/curtin-preserve-sources.cfg /etc/cloud/cloud.cfg.d/99-installer.cfg /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg
    sudo rm -f /etc/cloud/ds-identify.cfg
    sudo rm -f /etc/netplan/*.yaml
    ```

1. Clean up logs and cache.

    ```bash
    sudo cloud-init clean --logs --seed
    sudo rm -rf /var/lib/cloud/ /var/log/* /tmp/*
    sudo apt-get clean
    ```

1. Remove bash history.

    ```bash
    rm -f ~/.bash_history 
    export HISTSIZE=0 
    logout
    ```

1. Shut down the virtual machine. In the Hyper-V Manager, go to **Action > Shut Down**.
    

### Step 4: Create VM image

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
    | `Location`       | Location for your Azure Stack HCI cluster. For example, this could be `eastus`, `eastus2euap`. |
    | `OsType`         | Operating system associated with the source image. This can be Windows or Linux.           |


1. Use the VHDX of the VM to create an Ubuntu gallery image. Use this Ubuntu VM image to create Arc virtual machines on your Azure Stack HCI.

    ```powershell
    $galleryImagePath = (Get-VMHardDiskDrive -VMName "myubuntuvm").Path 

    $galleryImageName = "ubuntu-server-ssvm" 

    az azurestackhci galleryimage create --subscription $subscription -g $resource_group --extended-location name=$customLocationID type="CustomLocation" --location $location --image-path $galleryImagePath --name $galleryImageName --debug --os-type 'Linux' 
    ```


## Next steps

- [Create Arc VMs](./manage-virtual-machines-in-azure-portal.md) on your Azure Stack HCI cluster.
