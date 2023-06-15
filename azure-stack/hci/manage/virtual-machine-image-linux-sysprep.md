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
ms.date: 06/15/2023
---

# Sysprep Ubuntu image for Azure Stack HCI virtual machines (preview)

[!INCLUDE [hci-applies-to-22h2-21h2](../../includes/hci-applies-to-22h2-21h2.md)]

This article describes how to prepare an Ubuntu image to create a virtual machine (VM) image for your Azure Stack HCI virtual machines. You can create VM images from this syspreped Linux image via the Azure CLI and then use these VM images to create Arc VMs on your Azure Stack HCI.

[!INCLUDE [hci-preview](../../includes/hci-preview.md)]

## Prerequisites

Before you begin, make sure that the following prerequisites are completed.

[!INCLUDE [hci-vm-image-prerequisites-marketplace](../../includes/hci-vm-image-prerequisites-marketplace.md)]


- Access to a client that can connect to your Azure Stack HCI cluster. This client should be:

    - Running PowerShell 5.0 or later.
    - Running the latest version of `az` CLI.
        - [Download the latest version of `az` CLI](/cli/azure/install-azure-cli-windows?tabs=azure-cli). Once you have installed `az` CLI, make sure to restart the system.
        -  If you have an older version of `az` CLI running, make sure to uninstall the older version first.

- [Download latest supported Ubuntu server image](https://ubuntu.com/download/server) on your local system.

## Workflow 

Follow these steps to sysprep an Ubuntu image and create VM image from that image: 

    - Create Ubuntu VM
    - Configure VM 
    - Clean up VM
    - Create VM image

The following sections provide detailed instructions for each step in the workflow.

## Create VM image from Ubuntu image

You'll create a VM image starting from an Azure Marketplace image and then use this image to deploy VMs on your Azure Stack HCI cluster.

Follow these steps to create a VM image using the Azure CLI.

### Step 1: Create an Ubuntu VM

Follow these steps to use the downloaded Ubuntu image to provision a VM:

1. Use the downloaded image to create a VM with the following specifications: 
    1. Provide a friendly name ubuntu-server for your VM. 
    1. Specify **Generation 2** for your VM as you are working with a VHDX image here.
    1. Make sure that the **Secure boot** is **Disabled**.
    See [Provision a VM using Hyper-V Manager]() for step-by-step instructions.
1. Select **Install operating system from a bootable image** option. Point to ISO that you downloaded earlier.

### Step 2: Configure VM

Follow these steps to configure the VM that you provisioned earlier:

1. Sign into the VM. Follow the steps in connect to a Linux VM.
1. To get and install the latest patches on your VM, run the following command: 

    ```azurecli
    `sudo apt update`
    ```
1. Install Azure cloud tools. The cloud tools would enable you to sync the local files and folders with the file and folders in the cloud. When the cloud tools are enabled, your VM would get an IP. This IP is required for the network interface.

    ```azurecli
    `sudo apt install linux-azure -y`
    ```
1. 
### Step 3: Clean up VM

Delete machine-specific files and data from your VM.

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

1. Sign in. Type:

    ```azurecli
    az login
    ```

1. Set your subscription.

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
    | `Resource_Group` | Resource group for Azure Stack HCI cluster that you'll associate with this image.        |
    | `Location`       | Location for your Azure Stack HCI cluster. For example, this could be `eastus`, `eastus2euap`. |
    | `OsType`         | Operating system associated with the source image. This can be Windows or Linux.           |


1. Use the VHDX of the VM to create a gallery image. This image can be used to deploy virtual machines.

    ```powershell
    $galleryImagePath = (Get-VMHardDiskDrive -VMName "ubuntu-server").Path 

    $galleryImageName = "ubuntu-server-ssvm" 

    az azurestackhci galleryimage create --subscription $subscription -g $resource_group --extended-location name=$customLocationID type="CustomLocation" --location $location --image-path $galleryImagePath --name $galleryImageName --debug --os-type 'Linux' 
    ```
    Here's a sample output:
    
    ```
    PS C:\Users\azcli> 

    ```


## List VM images

You need to view the list of VM images to choose an image to manage.

[!INCLUDE [hci-list-vm-image-azure-cli](../../includes/hci-list-vm-image-azure-cli.md)]


## View VM image properties

You may want to view the properties of VM images before you use the image to create a VM. Follow these steps to view the image properties:

[!INCLUDE [hci-view-vm-image-properties-azure-cli](../../includes/hci-view-vm-image-properties-azure-cli.md)]


## Delete VM image

You may want to delete a VM image if the download fails for some reason or if the image is no longer needed. Follow these steps to delete the VM images.

[!INCLUDE [hci-view-vm-image-properties-azure-cli](../../includes/hci-view-vm-image-properties-azure-cli.md)]


## Next steps

- [Create virtual networks](./create-virtual-networks.md)
