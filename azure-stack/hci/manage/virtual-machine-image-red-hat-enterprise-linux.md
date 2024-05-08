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

Before you begin, make sure that the following prerequisites are completed.

- You have access to an Azure Stack HCI cluster. This cluster is deployed, registered, and connected to Azure Arc. Go to the **Overview** page in the Azure Stack HCI cluster resource. On the **Server** tab in the right-pane, the **Azure Arc** should show as **Connected**.

- You have downloaded latest supported [Red Hat Enterprise server image](https://developers.redhat.com/products/rhel/download#rhel-new-product-download-list-61451) on your Azure Stack HCI cluster. The supported OS versions are Red Hat Enterprise Linux 9.4, 8.9.0, and 7.9.0. Here we have downloaded the rhel-9.4-x86_64-boot.iso file. You'll use this to create a VM image.

## Workflow

Prepare a Red Hat Enterprise image and use it to create a VM image following these steps:

1. [Create a Red Hat Enterprise VM](./virtual-machine-image-red-hat-enterprise-linux.md#create-vm-image-from-red-hat-enterprise-image).
2. [Connect VM and install Red Hat OS](./virtual-machine-image-red-hat-enterprise-linux.md#step-2-connect-vm-and-install-red-hat-os).
3. [Register Red Hat Enterprise](./virtual-machine-image-red-hat-enterprise-linux.md#step-3-register-red-hat-enterprise)
4. [Configure the VM](./virtual-machine-image-red-hat-enterprise-linux.md#step-4-configure-the-vm).
5. [Clean up residual configuration](./virtual-machine-image-red-hat-enterprise-linux.md#step-4-clean-up-residual-configuration).
6. [Create the VHD and deploy the VM](./virtual-machine-image-red-hat-enterprise-linux.md#step-5-create-the-vhd-and-deploy-the-vm).

The following sections provide detailed instructions for each step in the workflow.

## Create VM image from Red Hat Enterprise image

> [!IMPORTANT]
> We recommend that you prepare a Red Hat Enterprise image if you intend to enable guest management on the VMs.

Follow these steps on your Azure Stack HCI cluster to create a VM image using the Azure CLI.

### Step 1: Create a Red Hat Enterprise VM

Follow these steps to use the downloaded Red Hat Enterprise image to provision a VM:

1. Use the downloaded image to create a VM with the following specifications:

    1. Provide a friendly name for your VM.

        :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-name-and-location.png" alt-text="Screenshot of the new Virtual Machine wizard on Specify name and location page." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-name-and-location.png":::

    2. Specify **Generation 2** for your VM as you're working with a VHDX image here. <!--is the VHDX statement valid here?-->
        :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-generation.png" alt-text="Screenshot of the Virtual Machine wizard on Generation page." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-generation.png":::

    3. Select **Assign Memory**, then enter `4096` for Startup memory.

        :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-memory.png" alt-text="Screenshot of the Virtual Machine wizard on Assign memory page." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-memory.png":::

    4. Select **Configure Networking**, then from the dropdown list select the virtual switch that the VM will use for the connection.

        :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-configure-networking.png" alt-text="Screenshot of the Virtual Machine wizard on Configure Networking page." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-configure-networking.png":::

    5. Accept the defaults on the **Connect Virtual Hard Disk** page.

        :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-connect-virtual-hard-disk.png" alt-text="Screenshot of the Virtual Machine wizard on Virtual Hard Disk page." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-connect-virtual-hard-disk.png":::

    6. Select **Install Options**, then select the **Install an operating system from a bootable image file** option. Point to the ISO that you downloaded earlier.

        :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-iso-option.png" alt-text="Screenshot of the OS Installation Options screen." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-iso-option.png":::

    See [Provision a VM using Hyper-V Manager](/windows-server/virtualization/hyper-v/get-started/create-a-virtual-machine-in-hyper-v?tabs=hyper-v-manager#create-a-virtual-machine) for step-by-step instructions.

2. Use the UEFI certificate to Secure Boot the VM.

    1. After the VM is created, it shows up in the Hyper-V manager. Select the virtual machine and right-click and then select **Settings**.

    2. In the left pane, select the **Security** tab. Then under **Secure Boot**, from the Template dropdown list, select **Microsoft UEFI Certificate Authority**.

    3. Select OK to save the changes.

    :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-microsoft-ufei-certificate-authority.png" alt-text="Screenshot of UEFI Secure Boot enabled screen." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-microsoft-ufei-certificate-authority.png":::

3. Select the VM from the Hyper-V Manager and then start the VM. The VM will boot from the ISO image that you provided.

### Step 2: Connect VM and install Red Hat OS

Once the VM is running, follow these steps:

1. Select the VM from the Hyper-V Manager, right-click to invoke the context menu and then select **Connect**.

2. Select the **Install Red Hat Enterprise Linux 9.4** option from the boot menu.

3. Select the language and then select **Continue**.

    :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-select-language.png" alt-text="Screenshot of the Language select screen." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-select-language.png":::

4. On the **Installation Summary** page you may see other actionable items.

    :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-installation-summary.png" alt-text="Screenshot of the Installation Summary with actionable items." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-installation-summary.png":::

5. Select **Connect to Red Hat**, create credentials, select **Register**, and then select **Done**.

    :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/connect-to-red-hat.png" alt-text="Screenshot of the Connect to Red Hat page." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/connect-to-red-hat.png":::

6. Select **Software Selection**, keep the defaults, and select **Done**.

    :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-software-selection-environment.png" alt-text="Screenshot of the Software Selection page." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-software-selection-environment.png":::

7. Select the **Installation Destination** and then select **Done**.

    :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-intallation-destination.png" alt-text="Screenshot of the Installation Destination page." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-virtual-machine-intallation-destination.png":::

8. Select the **Network & Host Name**.

    :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-completed-installation-summary.png" alt-text="Screenshot of the completed Installation Summary page." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-completed-installation-summary.png":::

9. Verify the **Ethernet** connection is **ON** and the host name is correct. Then select **Done**.

    :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-network-and-host-name.png" alt-text="Screenshot of the Network and Host Name page." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-network-and-host-name.png":::

10. Select **User setting** and set the root password. Enter a password, confirm the password, and select **Done**.

    :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-root-password.png" alt-text="Screenshot of the User Settings credentials page." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-root-password.png":::

11. Select **Begin Installation**.

12. Once the installation is complete, select **Reboot System**.

See [Provision a VM using Hyper-V Manager](/windows-server/virtualization/hyper-v/get-started/create-a-virtual-machine-in-hyper-v?tabs=hyper-v-manager#create-a-virtual-machine) for step-by-step instructions.

### Step 3: Register Red Hat Enterprise

 Register Red Hat Enterprise following these steps:

1. Sign into the VM.

2. To register Red Hat Enterprise, run the following command. You'll be prompted to enter your RHEL login credentials.

> [!NOTE]
> When typing your password you may not see any characters. Once you've finished typing your credentials, hit Enter.

    ```azurecli
    Sudo subscription-manager register
    ```

    ```console
        [hcitest@localhost ~]$ sudo subscription-manager register 
        Registering to: subscription.rhsm.redhat.com:443/subscription 
        Username : hcitest 
        Password :
        The system has been registered with ID: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx 
        The registered system name is: localhost.localdomain 
    ```

### Step 4: Configure the VM

Follow these steps to configure the VM:

1. Connect and then sign into the VM using the root password that you created during the Red Hat Enterprise installation.

2. Make sure that `cloud-init` was not installed

    ```azurecli
    Sudo yum list installed | grep cloud-init
    ```

3. Install the `cloud-init` tool and verify the installed version.

    ```azurecli
    Sudo yum install -y cloud-init
    cloud-init --version
    ```

    ```console
    [hcitest@localhost ~]$ sudo subscription-manager register
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

### Step 5: Clean up residual configuration

Delete machine-specific files and data from your VM so that you can create a clean VM image without any history or default configurations. Follow these steps on your Azure Stack HCI cluster to clean up the residual configuration:

1. Clean `cloud-init` default configurations.

    ```bash
    sudo yum clean all
    sudo cloud-init clean
    ```

2. Clean up logs and cache.

    ```bash
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

    ```console
        [hcitest@localhost ~]$ sudo yum clean all 
        Updating Subscription Management repositories.
        17 files removed
        [hcitest@localhost ~]$ sudo cloud-init clean
        [hcitest@localhost ~]$ sudo rm -rf /var/lib/cloud/ /var/log/* /tmp/* 
        [hcitest@localhost ~]$ sudo subscription-manager unregister 
        Unregistering from: subscription.rhsm.redhat.com:443/subscription 
        System has been unregistered.
        [hcitest@localhost ~]$ sudo subscription-manager clean 
        All local data removed
        [hcitest@localhost ~]$ sudo rm -f /etc/sysconfig/network-scripts/* 
        [hcitest@localhost ~]$ sudo rm -f /etc/ssh/ssh_host*
        [hcitest@localhost ~]$ sudo rm /etc/lvm/devices/system.devices
        [hcitest@localhost ~]$ sudo rm -f ~/.bash_history 
        [hcitest@localhost ~]$ export HISTSIZE=0
        [hcitest@localhost ~]$ exit
    ```

5. Shut down the virtual machine. In the Hyper-V Manager, go to **Action > Shut Down**.

6. Export a VHD or copy the VHD from your VM. Copy the VHD to a user storage on the cluster shared volume on your Azure Stack HCI. Alternatively, you can copy the VHDX as a page blob to an Azure Storage account.

    :::image type="content" source="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-export-vhdx.png" alt-text="Screenshot of exporting a Virtual Machine VHDX." lightbox="../manage/media/virtual-machine-image-red-hat-enterprise/red-hat-export-vhdx.png":::

### Step 6: Create the VHD and deploy the VM

[!INCLUDE [hci-create-a-vm-image](../../includes/hci-create-a-vm-image.md)]
