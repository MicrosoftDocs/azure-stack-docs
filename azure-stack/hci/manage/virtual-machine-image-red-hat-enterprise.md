---
title: Prepare Red Hat Enterprise Linux image for Azure Stack HCI VM via Azure CLI (preview)
description: Learn how to prepare a Red Hat Enterprise Linux image to create an Azure Stack HCI VM image (preview).
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.custom: devx-track-azurecli, linux-related-content
ms.date: 05/15/2024
#Customer intent: As a Senior Content Developer, I want to provide customers with content and steps to help them successfully use Red Hat Enterprise Linux to create images on Azure Stack HCI.
---

# Prepare a Red Hat Enterprise image for Azure Stack HCI virtual machines (preview)

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article describes how to prepare a Red Hat Enterprise Linux image to create a virtual machine (VM) on your Azure Stack HCI cluster. You use the Azure CLI for the VM image creation.

## Prerequisites

Before you begin, meet the following prerequisites:

- Have access to an Azure Stack HCI cluster. This cluster is deployed, registered, and connected to Azure Arc. Go to the **Overview** page in the Azure Stack HCI cluster resource. On the **Server** tab on the right pane, **Azure Arc** should appear as **Connected**.
- [Download the latest supported Red Hat Enterprise server image](https://developers.redhat.com/products/rhel/download#rhel-new-product-download-list-61451) on your Azure Stack HCI cluster. We support all Red Hat Enterprise Linux 7.x, 8.x, and 9.x versions. Here, we downloaded the *rhel-9.4-x86_64-boot.iso* file. You use this image to create a VM image.

## Workflow

To prepare a Red Hat Enterprise image and create a VM image:

1. [Create a Red Hat Enterprise VM](./virtual-machine-image-red-hat-enterprise.md#create-a-vm-image-from-a-red-hat-enterprise-image)
1. [Connect to a VM and install the Red Hat OS](./virtual-machine-image-red-hat-enterprise.md#step-2-connect-to-a-vm-and-install-the-red-hat-os)
1. [Configure the VM](./virtual-machine-image-red-hat-enterprise.md#step-3-configure-the-vm)
1. [Clean up the residual configuration](./virtual-machine-image-red-hat-enterprise.md#step-4-clean-up-the-residual-configuration)
1. [Create a Red Hat VM image](./virtual-machine-image-red-hat-enterprise.md#step-5-create-the-vm-image)

The following sections provide detailed instructions for each step in the workflow.

## Create a VM image from a Red Hat Enterprise image

> [!IMPORTANT]
> - Do not use an Azure Virtual Machine VHD disk to prepare the VM image for Azure Stack HCI.
> - We recommend that you prepare a Red Hat Enterprise image if you intend to enable guest management on the VMs.

Follow these steps on your Azure Stack HCI cluster to create a VM image by using the Azure CLI.

### Step 1: Create a Red Hat Enterprise VM

To use the downloaded Red Hat Enterprise image to provision a VM:

1. Use the downloaded image to create a VM with the following specifications:

    1. Provide a friendly name for your VM.

        :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-name-and-location.png" alt-text="Screenshot that shows the New Virtual Machine Wizard on the Specify Name and Location page." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-name-and-location.png":::

    1. Specify **Generation 2** for your VM as you're working with a VHDX image here.

        :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-generation.png" alt-text="Screenshot that shows the New Virtual Machine Wizard on the Specify Generation page." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-generation.png":::

    1. Select **Assign Memory** and then enter **4096** for **Startup memory**.

        :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-memory.png" alt-text="Screenshot that shows the New Virtual Machine Wizard on the Assign Memory page." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-memory.png":::

    1. Select **Configure Networking**. From the dropdown list, select the virtual switch that the VM uses for the connection.

        :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-configure-networking.png" alt-text="Screenshot that shows the New Virtual Machine Wizard on the Configure Networking page." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-configure-networking.png":::

    1. Accept the defaults on the **Connect Virtual Hard Disk** page.

        :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-connect-virtual-hard-disk.png" alt-text="Screenshot that shows the New Virtual Machine Wizard on the Virtual Hard Disk page." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-connect-virtual-hard-disk.png":::

    1. Select **Install Options** and then select **Install an operating system from a bootable image file**. Point to the ISO that you downloaded earlier.

        :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-iso-option.png" alt-text="Screenshot that shows the OS Installation Options screen." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-iso-option.png":::

    For step-by-step instructions, see [Provision a VM by using Hyper-V Manager](/windows-server/virtualization/hyper-v/get-started/create-a-virtual-machine-in-hyper-v?tabs=hyper-v-manager#create-a-virtual-machine).

1. Use the UEFI certificate to secure boot the VM.

    1. After the VM is created, it shows up in Hyper-V Manager. Select the VM, right-click it, and then select **Settings**.

    1. On the left pane, select the **Security** tab. Then under **Secure Boot**, from the template dropdown list, select **Microsoft UEFI Certificate Authority**.

    1. Select **OK** to save the changes.

    :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-microsoft-ufei-certificate-authority.png" alt-text="Screenshot that shows the UEFI Secure Boot enabled screen." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-microsoft-ufei-certificate-authority.png":::

1. Select the VM from Hyper-V Manager and then start the VM. The VM boots from the ISO image that you provided.

### Step 2: Connect to a VM and install the Red Hat OS

After the VM is running, follow these steps:

1. Select the VM from Hyper-V Manager, right-click it to open the menu, and then select **Connect**.

1. Select **Install Red Hat Enterprise Linux 9.4** from the boot menu.

1. Select the language and then select **Continue**.

    :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-select-language.png" alt-text="Screenshot that shows the Language select screen." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-select-language.png":::

1. On the **Installation Summary** page, you might see other actionable items.

    :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-installation-summary.png" alt-text="Screenshot that shows the Installation Summary with actionable items." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-installation-summary.png":::

1. Select **Connect to Red Hat** and create credentials. Select **Register** and then select **Done**.

    :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/connect-to-red-hat.png" alt-text="Screenshot that shows the Connect to Red Hat page." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/connect-to-red-hat.png":::

1. Select **Software Selection**, keep the defaults, and select **Done**.

    :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-software-selection-environment.png" alt-text="Screenshot that shows the Software Selection page." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-software-selection-environment.png":::

1. Select **Installation Destination** and then select **Done**.

    :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-intallation-destination.png" alt-text="Screenshot that shows the Installation Destination page." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-intallation-destination.png":::

1. Select **Network & Host Name**.

    :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-completed-installation-summary.png" alt-text="Screenshot that shows the completed Installation Summary page." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-completed-installation-summary.png":::

1. Enable the **ON** switch for the network interface and then select **Done**.

    :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-network-and-host-name.png" alt-text="Screenshot that shows the Network & Host Name page." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-network-and-host-name.png":::

1. Select **User setting** and set the root password. Enter a password, confirm the password, and select **Done**.

    :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-root-password.png" alt-text="Screenshot that shows the credentials page." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-root-password.png":::

1. Select **Begin Installation**.

    :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-begin-installation.png" alt-text="Screenshot that shows the Begin Installation button." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-begin-installation.png":::

1. After the installation is finished, select **Reboot System** to reboot the VM.

    :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-reboot-system.png" alt-text="Screenshot that shows the Reboot System button after installation." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-reboot-system.png":::

For step-by-step instructions, see [Provision a VM by using Hyper-V Manager](/windows-server/virtualization/hyper-v/get-started/create-a-virtual-machine-in-hyper-v?tabs=hyper-v-manager#create-a-virtual-machine).

### Step 3: Configure the VM

To configure the VM:

1. Connect and then sign in to the VM by using the root password that you created during the Red Hat Enterprise installation.

1. Make sure that `cloud-init` wasn't installed.

    ```bash
    Sudo yum list installed | grep cloud-init
    ```

1. Install the `cloud-init` tool and verify the version of `cloud-init` that was installed.

    ```bash
    Sudo yum install -y cloud-init
    cloud-init --version
    ```

    Here's example output:

    ```console
    [hcitest@localhost ~]$ sudo yum install -y cloud-init
    Installed:
    cloud-init-23.4-7.el9_4.noarch 
    dhcp-client-12:4.4.2-19.bl.el9.x86_64 
    dhcp-common-12:4.4.2-19.bl.el9.noarch 
    geolite2-city-20191217-6.el9.noarch 
    geolite2-country-20191217-6.el9.noarch 
    ipcalc-l.0.0-5.el9.x86_64 
    python3-attrs-20.3.0-7.el9.noarch 
    python3-babel-2.9.1-2.el9.noarch 
    python3-configob j-5.0.6-25.el9.noarch 
    python3-jinja2-2.11.3-5.el9.noarch 
    python3-j sonpatch-1.21-16.el9.noarch 
    python3-j sonpointer-2.0-4.el9.noarch 
    python3-j sonschema-3.2.0-13.el9.noarch 
    python3-markupsafe-l.1.1-12.el9.x86_64 
    python3-netifaces-0.10.6-15.el9.x86_64 
    python3-oauthlib-3.1.1-5.el9.noarch 
    python3-prettytable-0.7.2-27.el9.noarch 
    python3-pyrsistent-0.17.3-8.el9.x86_64 
    python3-pyserial-3.4-12.el9.noarch 
    python3-pytz-2021.1-5.el9.noarch
        
    Complete!
    [hcitest@localhost ~]$ cloud-init —version 
    /usr/bin/cloud-init 23.4-7.el9_4 
    ```

### Step 4: Clean up the residual configuration

Delete machine-specific files and data from your VM so that you can create a clean VM image without any history or default configurations. Follow these steps on your Azure Stack HCI cluster to clean up the residual configuration.

1. Clean `cloud-init` default configurations.

    ```bash
    sudo yum clean all
    sudo cloud-init clean
    ```

    Here's example output:

    ```console
    [hcitest@localhost ~]$ sudo yum clean all 
    Updating Subscription Management repositories.
    17 files removed
    [hcitest@localhost ~]$ sudo cloud-init clean
    ```

1. Clean up the logs and cache.

    ```bash
    sudo rm -rf /var/lib/cloud/ /var/log/* /tmp/*
    ```

1. Unregister the VM.

    ```bash
    sudo subscription-manager unregister
    sudo Subscription-manager clean
    ```

    Here's example output:

    ```console
    [hcitest@localhost ~]$ sudo subscription-manager unregister 
    Unregistering from: subscription.rhsm.redhat.com:443/subscription 
    System has been unregistered.
    [hcitest@localhost ~]$ sudo subscription-manager clean 
    All local data removed
    ```

1. Clean any host-specific details.

    ```bash
    sudo rm -f /etc/sysconfig/network-scripts/*
    sudo rm -f /etc/ssh/ssh_host*
    sudo rm /etc/lvm/devices/system.devices
    ```

1. Remove the bash history.

    ```bash
    sudo rm -f ~/.bash_history 
    export HISTSIZE=0
    exit
    ```

1. Shut down the VM. In Hyper-V Manager, go to **Action** > **Shut Down**.

1. Export a VHDX or copy the VHDX from your VM. You can use the following methods:
    - Copy the VHDX to a user storage on the cluster shared volume on your Azure Stack HCI.
    - Alternatively, copy the VHDX as a page blob to a container in an Azure Storage account.

    :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-export-vhdx.png" alt-text="Screenshot that shows exporting a virtual machine VHDX." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-export-vhdx.png":::

### Step 5: Create the VM image

[!INCLUDE [hci-create-a-vm-image](../../includes/hci-create-a-vm-image.md)]

## Related content

- [Create Azure Arc VMs](./manage-virtual-machines-in-azure-portal.md) on your Azure Stack HCI cluster.
