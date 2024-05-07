---
title: Prepare a Red Hat Enterprise Linux image for Azure Stack HCI virtual machines
description: Learn how to prepare a Red Hat Enterprise Linux image for an Azure Stack HCI virtual machine.
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.custom:
  - devx-track-azurecli
ms.date: 05/07/2024
#Customer intent: As a Senior Content Developer, I want to provide customers with content and steps to help them successfully use Red Hat Enterprise Linux to create images on Azure Stack HCI.
---

# Prepare Red Hat Enterprise image for Azure Stack HCI virtual machines

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article describes how to prepare a Red Hat Enterprise Linux image to create a virtual machine on your Azure Stack HCI cluster. You'll use Azure CLI for the VM image creation.

## Prerequisites

Before you begin, the following prerequisites must be completed. Make sure you have:

- Access to an Azure Stack HCI cluster. This cluster is deployed, registered, and connected to Azure Arc. Go to the **Overview** page in the Azure Stack HCI cluster resource. On the **Server** tab in the right-pane, the **Azure Arc** should show as **Connected**.

- [Downloaded latest supported Red Hat Enterprise server image](https://developers.redhat.com/products/rhel/download#rhel-new-product-download-list-61451) on your Azure Stack HCI cluster. The supported OS versions are Red Hat Enterprise Linux 9.3, 8.9.0, and 7.9.0. You'll use this to create a VM image.

## Workflow

Prepare a Red Hat Enterprise image and use it to create a VM image following these steps:

1. [Create a Red Hat Enterprise VM](./virtual-machine-image-red-hat-enterprise-linux.md#create-vm-image-from-red-hat-enterprise-image).
2. [Configure the VM](./virtual-machine-image-red-hat-enterprise-linux.md#step-2-configure-the-vm).
3. [Clean up the residual configuration](./virtual-machine-image-red-hat-enterprise-linux.md#step-3-clean-up-residual-configuration).
4. [Create a Red Hat Enterprise VM image](./virtual-machine-image-red-hat-enterprise-linux.md#step-4-create-the-vhd-and-deploy-the-vm).

The following sections provide detailed instructions for each step in the workflow.

## Create VM image from Red Hat Enterprise image

> [!IMPORTANT]
> We recommend that you prepare a Red Hat Enterprise image if you intend to enable guest management on the VMs.

Follow these steps on your Azure Stack HCI cluster to create a VM image using the Azure CLI.

### Step 1: Create a Red Hat Enterprise VM

Follow these steps to use the downloaded Red Hat Enterprise image to provision a VM:

1. Use the downloaded image to create a VM with the following specifications:

    1. Provide a friendly name for your VM.

        :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/virtual-machine-name-and-location.png" alt-text="Screenshot of the New virtual machine wizard on Specify name and location page." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/virtual-machine-name-and-location.png":::

    2. Specify **Generation 2** for your VM as you're working with a VHDX image here. <!--is the VHDX statement valid here?-->
        :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/virtual-machine-generation.png" alt-text="Screenshot of the New virtual machine wizard on Specify generation page." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/virtual-machine-generation.png":::

    3. Select **Assign Memory**, then enter `4096` for Startup memory.

        :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/virtual-machine-memory.png" alt-text="Screenshot of the New virtual machine wizard on Assign memory page." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/virtual-machine-memory.png":::

    4. Select **Install Options**, then select the **Install an operating system from a bootable image file** option. Point to the ISO that you downloaded earlier.

        :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-iso-option.png" alt-text="Screenshot of the OS Installation Options screen." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-iso-option.png":::

    5. Select the **Network & Host Name**.
        :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/installation-summary.png" alt-text="Screenshot of the New virtual machine wizard on Installation Summary page." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/installation-summary.png":::

    6. Verify the **Ethernet** connection is **ON** and the host name is correct. Then select **Done**.

        :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/network-and-host-name.png" alt-text="Screenshot of the New virtual machine wizard on Network and Host Name page." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/network-and-host-name.png":::

    See [Provision a VM using Hyper-V Manager](/windows-server/virtualization/hyper-v/get-started/create-a-virtual-machine-in-hyper-v?tabs=hyper-v-manager#create-a-virtual-machine) for step-by-step instructions.

### Step 2: Register Red Hat Enterprise and install the OS

 Register Red Hat Enterprise and install the OS following these steps:

1. Sign into the VM.

2. To register Red Hat Enterprise, run the following command:

    ```azurecli
    Sudo subscription-manager register
    ```

3. Check for software packages and the `cloud-init` tool on your system.

    ```azurecli
    Sudo yum list installed | grep cloud-init
    ```

4. Install the cloud-init tool.

    ```azurecli
    Sudo yum install -y cloud-init
    ```

5. Check the installed Red Hat version.

    ```azurecli
    cloud-init --version
    ```

6. To update all of the distribution packages that are installed, run this command:

    ```azurecli
    cloud-init --version
    ```

### Step 3: Configure the VM

Configure the VM that you provisioned earlier following these steps on your Azure Stack HCI cluster:

<!--add content here-->

### Step 4: Clean up residual configuration

Delete machine-specific files and data from your VM so that you can create a clean VM image without any history or default configurations. Follow these steps on your Azure Stack HCI cluster to clean up the residual configuration:

1. Clean `cloud-init` default configurations.

    ```bash
    sudo yum clean all
    sudo cloud-init clean
    ```

2. Clean up logs and cache.

    ```bash
    sudo cloud-init clean --logs --seed
    sudo rm -rf /var/lib/cloud/ /var/log/* /tmp/*
    ```

3. Unregister the VM.

    ```bash
    sudo subscription-manager unregister
    sudo Subscription-manager clean
    sudo rm -f /etc/sysconfig/network-scripts/*
    sudo rm -f /etc/ssh/ssh_host*
    sudo rm /etc/lvm/devices/system.devices
    ```

4. Remove bash history.

    ```bash
    sudo rm -f ~/.bash_history 
    export HISTSIZE=0
    logout
    ```

5. Shut down the virtual machine. In the Hyper-V Manager, go to **Action > Shut Down**.

6. Export a VHD or copy the VHD from your VM. Copy the VHD to a user storage on the cluster shared volume on your Azure Stack HCI. Alternatively, you can copy the VHDX as a page blob to an Azure Storage account.

### Step 5: Create the VHD and deploy the VM

[!INCLUDE [hci-create-a-vm-image](../../includes/hci-create-a-vm-image.md)]
