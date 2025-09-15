---
title: Prepare CentOS Linux image via Azure CLI for Azure Local VMs enabled by Azure Arc (preview)
description: Learn how to prepare CentOS Linux images to create an Azure Local VM image (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 03/21/2025
ms.custom:
  - devx-track-azurecli
  - linux-related-content
  - sfi-image-nochange
---

# Prepare a CentOS Linux image for Azure Local VMs enabled by Azure Arc (preview)

> [!CAUTION]
> This article references CentOS, a Linux distribution that's reached end-of-life (EOL). Consider your use of CentOS and plan accordingly. For more information, see [CentOS end-of-life guidance](/azure/virtual-machines/workloads/centos/centos-end-of-life).

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to use Azure CLI to prepare a CentOS Linux image and create an Azure Local virtual machine (VM).

## Prerequisites

- Have access to an Azure Local instance that is deployed, registered, and connected to Azure Arc. Go to the **Overview** page in the Azure Local resource. On the **Server** tab on the right pane, **Azure Arc** should appear as **Connected**.
- [Download the latest supported ISO image](https://mirrors.vcea.wsu.edu/centos/7.9.2009/isos/x86_64/) on your Azure Local instance. Here, we downloaded the *CentOS-7-x86_64-Everything-2207-02.iso* file.

## Workflow

To prepare a CentOS image and create an Azure Local VM image from it:

1. [Create a CentOS VM](#step-1-create-a-centos-vm)
1. [Connect to a VM and install CentOS](#step-2-connect-to-a-vm-and-install-centos)
1. [Configure the VM](#step-3-configure-the-vm)
1. [Clean up the residual configuration](#step-4-clean-up-the-residual-configuration)
1. [Create a CentOS VM image](#step-5-create-a-vm-image)

The following sections provide detailed instructions for each step in the workflow.

## Create a VM image from a CentOS image

> [!IMPORTANT]
>
> - Do not use a virtual hard disk from an Azure VM to prepare the Azure Local VM image.
> - We recommend that you prepare a CentOS image if you intend to enable guest management on the VMs.

### Step 1: Create a CentOS VM

Follow these steps to provision a VM using the downloaded CentOS image.

1. Set up the VM with the following specifications:
    1. Provide a friendly name for your VM.

        :::image type="content" source="../manage/media/virtual-machine-image-centos/centos-virtual-machine-name.png" alt-text="Screenshot that shows the New Virtual Machine Wizard on the Specify Name and Location page." lightbox="../manage/media/virtual-machine-image-centos/centos-virtual-machine-name.png":::

    1. Specify **Generation 2** for your VM as you're working with a virtual hard disk v2 (VHDX) image here.

        :::image type="content" source="../manage/media/virtual-machine-image-centos/centos-virtual-machine-generation.png" alt-text="Screenshot that shows the New Virtual Machine Wizard on the Specify Generation page." lightbox="../manage/media/virtual-machine-image-centos/centos-virtual-machine-generation.png":::

    1. Assign **4096** for **Startup memory**.

        :::image type="content" source="../manage/media/virtual-machine-image-centos/centos-virtual-machine-assign-memory.png" alt-text="Screenshot that shows the Assign Memory page." lightbox="../manage/media/virtual-machine-image-centos/centos-virtual-machine-assign-memory.png":::

    1. Select the virtual network switch that the VM uses for connection.

        :::image type="content" source="../manage/media/virtual-machine-image-centos/centos-virtual-machine-configure-networking.png" alt-text="Screenshot that shows the Configure Networking page." lightbox="../manage/media/virtual-machine-image-centos/centos-virtual-machine-configure-networking.png":::

    1. Accept the defaults on the **Connect Virtual Hard Disk** page.

        :::image type="content" source="../manage/media/virtual-machine-image-centos/centos-virtual-machine-connect-virtual-hard-disk.png" alt-text="Screenshot that shows the New Virtual Machine Wizard on the Connect Virtual Hard Disk page." lightbox="../manage/media/virtual-machine-image-centos/centos-virtual-machine-connect-virtual-hard-disk.png":::

    1. Select **Install operating system from a bootable image**. Point to the ISO that you downloaded earlier.

        :::image type="content" source="../manage/media/virtual-machine-image-centos/centos-virtual-machine-iso-option.png" alt-text="Screenshot that shows the New Virtual Machine Wizard on the Installation Options page." lightbox="../manage/media/virtual-machine-image-centos/centos-virtual-machine-iso-option.png":::

    For step-by-step instructions, see [Provision a VM by using Hyper-V Manager](/windows-server/virtualization/hyper-v/get-started/create-a-virtual-machine-in-hyper-v?tabs=hyper-v-manager#create-a-virtual-machine).

1. Use the Unified Extensible Firmware Interface (UEFI) certificate to secure boot the VM:

    1. After the VM is created, it shows up in Hyper-V Manager. Select the VM, right-click it, and then select **Settings**.
    1. On the left pane, select the **Security** tab. Then under **Secure Boot**, from the **Template** dropdown list, select **Microsoft UEFI Certificate Authority**.
    1. Select **OK** to save the changes.

    :::image type="content" source="../manage/media/virtual-machine-image-centos/centos-virtual-machine-microsoft-ufei-certificate-authority.png" alt-text="Screenshot that shows Secure Boot disabled for the VM on the Settings page." lightbox="../manage/media/virtual-machine-image-centos/centos-virtual-machine-microsoft-ufei-certificate-authority.png":::

1. Select the VM from Hyper-V Manager and then start the VM. The VM boots from the ISO image that you provided.

### Step 2: Connect to a VM and install CentOS

After the VM is running, follow these steps:

1. Select the VM from Hyper-V Manager. Right-click it, and on the menu that opens, select **Connect**.

1. Select the **Install CentOS 7** option from the boot menu.

1. Select the language and then select **Continue**.

    :::image type="content" source="../manage/media/virtual-machine-image-centos/centos-virtual-machine-select-language.png" alt-text="Screenshot that shows selecting a language during CentOS installation." lightbox="../manage/media/virtual-machine-image-centos/centos-virtual-machine-select-language.png":::

1. Select the installation destination and then select **Done**.

    :::image type="content" source="../manage/media/virtual-machine-image-centos/centos-virtual-machine-select-installation-destination.png" alt-text="Screenshot that shows the installation destination during CentOS installation." lightbox="../manage/media/virtual-machine-image-centos/centos-virtual-machine-select-installation-destination.png":::

1. Select **Network & Host Name**.

    :::image type="content" source="../manage/media/virtual-machine-image-centos/centos-virtual-machine-select-network-and-hostname.png" alt-text="Screenshot that shows selecting the network and hostname during CentOS installation." lightbox="../manage/media/virtual-machine-image-centos/centos-virtual-machine-select-network-and-hostname.png":::

1. Enable the **ON** switch for the network interface and then select **Done**.

    :::image type="content" source="../manage/media/virtual-machine-image-centos/centos-virtual-machine-switch-network-interface.png" alt-text="Screenshot that shows enabling the network interface during CentOS installation." lightbox="../manage/media/virtual-machine-image-centos/centos-virtual-machine-switch-network-interface.png":::

1. Select **User setting** and set the root password. Enter a password, confirm the password, and select **Done**.

    :::image type="content" source="../manage/media/virtual-machine-image-centos/centos-virtual-machine-set-root-password.png" alt-text="Screenshot that shows setting the root password during CentOS installation." lightbox="../manage/media/virtual-machine-image-centos/centos-virtual-machine-set-root-password.png":::

1. Select **Finish configuration**.

    :::image type="content" source="../manage/media/virtual-machine-image-centos/centos-virtual-machine-finish-configuration.png" alt-text="Screenshot that shows selecting Finish configuration during CentOS installation." lightbox="../manage/media/virtual-machine-image-centos/centos-virtual-machine-finish-configuration.png":::

1. Select **Begin Installation**. After the installation is complete, select **Reboot** to reboot the VM.

    :::image type="content" source="../manage/media/virtual-machine-image-centos/centos-virtual-machine-reboot.png" alt-text="Screenshot that shows selecting Reboot during CentOS installation." lightbox="../manage/media/virtual-machine-image-centos/centos-virtual-machine-reboot.png":::

### Step 3: Configure the VM

To configure the VM:

1. Connect and then sign in to the VM by using the root password that you created during the CentOS installation.
1. Make sure that `cloud-init` wasn't installed.

    ```bash
    sudo yum list installed | grep cloud-init
    ```

1. Install `cloud-init` and verify the version of the `cloud-init` installed.

    ```bash
    sudo yum install cloud-init
    cloud-init --version
    ```

### Step 4: Clean up the residual configuration

Delete machine-specific files and data from your VM so that you can create a clean VM image without any history or default configurations. To clean up the residual configuration, follow these steps on your Azure Local:

1. Clean the `cloud-init` default configurations.

    ```bash
    sudo yum clean all
    sudo cloud-init clean
    ```

1. Clean up the logs and cache.

    ```bash
    sudo rm -rf /var/lib/cloud/ /var/log/* /tmp/*
    ```

1. Remove the bash history.

    ```bash
    rm -f ~/.bash_history 
    export HISTSIZE=0 
    logout
    ```

1. Shut down the VM. In Hyper-V Manager, go to **Action** > **Shut Down**.
1. Export a VHDX or copy the VHDX from your VM. You can use the following methods:
    - Copy the VHDX to user storage on the cluster shared volume on your Azure Local.
    - Alternatively, copy the VHDX as a page blob to a container in an Azure Storage account.

### Step 5: Create a VM image

[!INCLUDE [hci-create-a-vm-image](../includes/hci-create-a-vm-image.md)]

## Related content

- [Create Azure Local VMs](./manage-virtual-machines-in-azure-portal.md) on your Azure Local instance.
