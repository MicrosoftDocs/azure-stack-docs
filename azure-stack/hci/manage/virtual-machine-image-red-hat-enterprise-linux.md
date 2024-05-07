---
title: Prepare a Red Hat Enterprise Linux image for Azure Stack HCI VM
description: Learn how to prepare images using Red Hat Enterprise Linux to create an Azure Stack HCI VM image.
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.custom:
  - devx-track-azurecli
ms.date: 04/02/2024
#Customer intent: As a Senior Content Developer, I want to provide customers with content and steps to help them successfully use Red Hat Enterprise Linux to create images on Azure Stack HCI.
---

# Prepare Red Hat Enterprise image for Azure Stack HCI virtual machines

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article describes how to prepare a Red Hat Enterprise image to create a virtual machine on your Azure Stack HCI cluster. You'll use Azure CLI for the VM image creation.

## Prerequisites

Before you begin, the following prerequisites must be completed. Make sure you have:

- Access to an Azure Stack HCI cluster. This cluster is deployed, registered, and connected to Azure Arc. Go to the **Overview** page in the Azure Stack HCI cluster resource. On the **Server** tab in the right-pane, the Azure Arc should show as **Connected**.

- [Downloaded latest supported Red Hat Enterprise server image](https://developers.redhat.com/products/rhel/download#rhel-new-product-download-list-61451) on your Azure Stack HCI cluster. The supported OS versions are Red Hat Enterprise Linux 9.3, 8.9.0, and 7.9.0. This image is used to create a VM image.

## Workflow

Prepare a Red Hat Enterprise image and use it to create a VM image following these steps:

1. [Create a Red Hat Enterprise VM](./virtual-machine-image-red-hat-enterprise-linux.md#create-vm-image-from-red-hat-enterprise-image).
1. [Configure the VM](./virtual-machine-image-red-hat-enterprise-linux.md#step-2-configure-the-vm).
1. [Clean up the residual configuration](./virtual-machine-image-red-hat-enterprise-linux.md#step-3-clean-up-residual-configuration).
1. [Create a Red Hat Enterprise VM image](./virtual-machine-image-red-hat-enterprise-linux.md#step-4-create-the-vhd-and-deploy-the-vm).

The next sections provide detailed instructions for each step in the workflow.

## Create VM image from Red Hat Enterprise image

Use Azure CLI to create a VM image on your Azure Stack HCI cluster following these steps:

### Step 1: Create a Red Hat Enterprise VM

Use the downloaded Red Hat Enterprise image to create a VM following these steps:

1. Use the downloaded image to create a VM with the following specifications:

    1. Provide a friendly name for your VM.

        :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/virtual-machine-name-and-location.png" alt-text="Screenshot of the New virtual machine wizard on Specify name and location page." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/virtual-machine-name-and-location.png":::

    2. Specify Generation 2 for your VM as you're working with a VHDX image here. <!--is the VHDX statement valid here?-->

        :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/virtual-machine-generation.png" alt-text="Screenshot of the New virtual machine wizard on Specify generation page." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/virtual-machine-generation.png":::

    3. Assign the necessary amount of memory. To improve performance, specify more than the minimum amount recommended for the operating system.

        :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/virtual-machine-memory.png" alt-text="Screenshot of the New virtual machine wizard on Assign memory page." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/virtual-machine-memory.png":::

    4. Select Install operating system from a bootable image option. Point to the ISO that you downloaded earlier.

        :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-iso-option.png" alt-text="Screenshot of the OS Installation Options screen." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-iso-option.png":::

        See [Provision a VM using Hyper-V Manager](/windows-server/virtualization/hyper-v/get-started/create-a-virtual-machine-in-hyper-v?tabs=hyper-v-manager#create-a-virtual-machine) for step-by-step instructions.

    5. Review the installation summary

        :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/installation-summary.png" alt-text="Screenshot of the New virtual machine wizard on Installation Summary page." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/installation-summary.png":::

    6. Verify the Ethernet connection is on and the host name is correct.

        :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/network-and-host-name.png" alt-text="Screenshot of the New virtual machine wizard on Network and Host Name page." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/network-and-host-name.png":::

### Step 2: Register Red Hat Enterprise and install the OS

Use Azure CLI to register Red Hat Enteprise and install the OS folling these steps:

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

    Here's an example of Red Hat Enterprise version 7.9 installed.

    :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/rhel-7-9.png" alt-text="Screenshot of Red Hat version 7.9 installed." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/rhel-7-9.png":::
    
    Here's an example of Red Hat Enterprise version 8.9 installed.

    :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/rhel-8-9.png" alt-text="Screenshot of Red Hat version 8.9 installed." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/rhel-8-9.png":::

    Here's an example of Red Hat Enterprise version 9.3 installed.

    :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/rhel-9-3.png" alt-text="Screenshot of Red Hat version 9.3 installed." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/rhel-9-3.png":::

6. To update all of the distribution packages that are installed, run this command:

    ```azurecli
    cloud-init --version
    ```

### Step 3: Configure the VM

Configure the VM that you provisioned earlier following these steps on your Azure Stack HCI cluster:

<!--add content here-->

### Step 4: Clean up residual configuration

Delete machine-specific files and data from your VM so that you can create a clean VM image without any history or default configurations. Follow these steps on your Azure Stack HCI cluster to clean up the residual configuration:

1. Clean up logs and cache.

    ```bash
    sudo yum clean all
    sudo cloud-init clean
    sudo rm -rf /var/lib/cloud/ /var/log/* /tmp/*
    ```

2. Unregister the VM.

    ```bash
    Sudo subscription-manager unregister
    Sudo Subscription-manager clean
    Sudo rm -f /etc/sysconfig/network-scripts/*
    Sudo rm -f /etc/ssh/ssh_host*
    Sudo rm /etc/lvm/devices/system.devices
    ```

3. Remove bash history.

    ```bash
    sudo rm -f ~/.bash_history 
    export HISTSIZE=0
    logout
    ```

### Step 5: Create the VHD and deploy the VM

<!--what content is needed following this, I can't determine based on the one note.-->
