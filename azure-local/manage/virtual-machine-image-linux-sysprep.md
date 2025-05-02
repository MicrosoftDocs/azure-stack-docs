---
title: Prepare Ubuntu image via Azure CLI for Azure Local VMs enabled by Azure Arc
description: Learn how to prepare Ubuntu images to create an Azure Local VM image by using Azure CLI.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.custom: devx-track-azurecli, linux-related-content
ms.date: 03/21/2025
---

# Prepare an Ubuntu image for Azure Local VMs enabled by Azure Arc

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to use Azure CLI to prepare an Ubuntu image and create an Azure Local virtual machine (VM).

## Prerequisites

- Have access to an Azure Local instance. This system is deployed, registered, and connected to Azure Arc. Go to the **Overview** page in the Azure Local resource. On the **Server** tab on the right pane, **Azure Arc** should appear as **Connected**.
- [Download the latest supported Ubuntu server image](https://ubuntu.com/download/server) on your Azure Local system. The supported OS versions are *Ubuntu 20.04*, *22.04*, and *24.04 LTS*.

## Workflow

To prepare an Ubuntu image and create an Azure Local VM image from it:

1. [Create an Ubuntu VM](#step-1-create-an-ubuntu-vm)
1. [Configure the VM](#step-2-configure-the-vm)
1. [Clean up the residual configuration](#step-3-clean-up-the-residual-configuration)
1. [Create an Ubuntu VM image](#step-4-create-the-vm-image)

The following sections provide detailed instructions for each step in the workflow.

## Create a VM image from an Ubuntu image

> [!IMPORTANT]
>
> - Do not use a virtual hard disk from an Azure VM to prepare the Azure Local VM image.
> - We recommend that you prepare an Ubuntu image if you intend to enable guest management on the VMs.

### Step 1: Create an Ubuntu VM

Follow these steps to provision a VM using the downloaded Ubuntu image.

1. Set up the VM with the following specifications:
    1. Provide a friendly name for your VM.

        :::image type="content" source="../manage/media/virtual-machine-image-linux-sysprep/ubuntu-virtual-machine-name.png" alt-text="Screenshot that shows the New Virtual Machine Wizard on the Specify Name and Location page." lightbox="../manage/media/virtual-machine-image-linux-sysprep/ubuntu-virtual-machine-name.png":::

    1. Specify **Generation 2** for your VM as you're working with a virtual hard disk extended image here.

        :::image type="content" source="../manage/media/virtual-machine-image-linux-sysprep/ubuntu-virtual-machine-generation.png" alt-text="Screenshot that shows the New Virtual Machine Wizard on the Specify Generation page." lightbox="../manage/media/virtual-machine-image-linux-sysprep/ubuntu-virtual-machine-generation.png":::

    1. Select **Install operating system from a bootable image**. Point to the ISO that you downloaded earlier.

        :::image type="content" source="../manage/media/virtual-machine-image-linux-sysprep/ubuntu-virtual-machine-iso-option.png" alt-text="Screenshot that shows the New Virtual Machine Wizard on the Installation Options page." lightbox="../manage/media/virtual-machine-image-linux-sysprep/ubuntu-virtual-machine-iso-option.png":::

    For step-by-step instructions, see [Provision a VM by using Hyper-V Manager](/windows-server/virtualization/hyper-v/get-started/create-a-virtual-machine-in-hyper-v?tabs=hyper-v-manager#create-a-virtual-machine).

1. Use the UEFI certificate to secure boot the VM.
    1. After the VM is created, it shows up in Hyper-V Manager. Select the VM, right-click it, and then select **Settings**.
    1. On the left pane, select the **Security** tab. Then under **Secure Boot**, from the **Template** dropdown list, select **Microsoft UEFI Certificate Authority**.
    1. Select **OK** to save the changes.

     :::image type="content" source="../manage/media/virtual-machine-image-linux-sysprep/ubuntu-virtual-machine-secure-boot-the-vm.png" alt-text="Screenshot that shows the Secure Boot options for the VM on the Settings page." lightbox="../manage/media/virtual-machine-image-linux-sysprep/ubuntu-virtual-machine-secure-boot-the-vm.png":::

### Step 2: Configure the VM

Follow these steps on your Azure Local to configure the VM that you provisioned earlier:

1. Sign in to the VM. See the steps in [Connect to a Linux VM](/azure/databox-online/azure-stack-edge-gpu-deploy-virtual-machine-portal#connect-to-a-linux-vm).
1. To download all the latest package lists from the repositories, run the following command:

    ```azurecli
    sudo apt update
    ```

1. Install the [Azure tailored kernel](https://ubuntu.com/blog/microsoft-and-canonical-increase-velocity-with-azure-tailored-kernel). This step is required for your VM to get an IP for the network interface.

    ```azurecli
    sudo apt install linux-azure -y
    ```

1. Install the SSH server. Run the following command:

    ```azurecli
    sudo apt install openssh-server openssh-client -y
    ```

1. Configure passwordless sudo. Add the following command at the end of the `/etc/sudoers` file by using `visudo`:

    ```azurecli
    ALL ALL=(ALL) NOPASSWD:ALL
    ```

### Step 3: Clean up the residual configuration

Delete machine-specific files and data from your VM so that you can create a clean VM image without any history or default configurations. Follow these steps on your Azure Local to clean up the residual configuration.

> [!NOTE]
> Depending on the version of Ubuntu you are using, some of these files may not exist.

1. Clean `cloud-init` default configurations.

    ```bash
    sudo rm -f /etc/cloud/cloud.cfg.d/50-curtin-networking.cfg /etc/cloud/cloud.cfg.d/curtin-preserve-sources.cfg /etc/cloud/cloud.cfg.d/99-installer.cfg /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg
    sudo rm -f /etc/cloud/ds-identify.cfg
    sudo rm -f /etc/netplan/*.yaml
    ```

1. Clean up the logs and cache.

    ```bash
    sudo cloud-init clean --logs --seed
    sudo rm -rf /var/lib/cloud/ /var/log/* /tmp/*
    sudo apt-get clean
    ```

1. Remove the bash history.

    ```bash
    rm -f ~/.bash_history 
    export HISTSIZE=0 
    logout
    ```

1. Shut down the VM. In Hyper-V Manager, go to **Action** > **Shut Down**.

### Step 4: Create the VM image

[!INCLUDE [hci-create-a-vm-image](../includes/hci-create-a-vm-image.md)]

## Related content

- [Create Azure Local VMs](./manage-virtual-machines-in-azure-portal.md) on your Azure Local instance.
