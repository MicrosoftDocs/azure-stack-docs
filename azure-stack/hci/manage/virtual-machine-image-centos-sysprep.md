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
ms.date: 04/24/2024
---

# Prepare CentOS Linux image for Azure Stack HCI virtual machines

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article describes how to prepare an CentOS Linux image to create a virtual machine on your Azure Stack HCI cluster. You'll use Azure CLI for the VM image creation.

## Prerequisites

Before you begin, make sure that the following prerequisites are completed.

- You've access to an Azure Stack HCI cluster. This cluster is deployed, registered, and connected to Azure Arc. Go to the **Overview** page in the Azure Stack HCI cluster resource. On the **Server** tab in the right-pane, the **Azure Arc** should show as **Connected**.

- You've [downloaded the latest supported Centos ISO image](http://repo1.sea.innoscale.net/centos/7.9.2009/isos/x86_64/) on your Azure Stack HCI cluster. Use the *CentOS-7-x86_64-Everything-2207-02.iso* file for download. You will prepare this image to create a VM image.

## Workflow

Follow these steps to prepare an CentOS image and create a VM image from that image:

1. [Create an CentOS VM](#step-1-create-an-centos-vm).
1. [Configure the VM](#step-2-configure-vm).
1. [Clean up the residual configuration](#step-3-clean-up-residual-configuration).
1. [Create an CentOS VM image](#step-4-create-vm-image).
1. [Create the VHD](#step-5-create-the-vhd).
1. [Deploy the VM](#step-6-deploy-the-vm).
1. [Validate deployment](#step-7-validate-deployment).

The following sections provide detailed instructions for each step in the workflow.

## Create VM image from CentOS image

> [!IMPORTANT]
> We recommend that you prepare an CentOS image if you intend to enable guest management on the VMs.

Follow these steps on your Azure Stack HCI cluster to create a VM image using the Azure CLI.

### Step 1: Create a CentOS VM

Follow these steps to use the downloaded CentOS image to provision a VM:

1. Use the downloaded image to create a VM with the following specifications: 
    1. Provide a friendly name for your VM. 
    
        :::image type="content" source="../manage/media/virtual-machine-image-centos-sysprep/centos-virtual-machine-name.png" alt-text="Screenshot of the New virtual machine wizard on Specify name and location page." lightbox="../manage/media/virtual-machine-image-centos-sysprep/centos-virtual-machine-name.png":::

    1. Specify **Generation 2** for your VM as you're working with a VHDX image here.

        :::image type="content" source="../manage/media/virtual-machine-image-centos-sysprep/centos-virtual-machine-generation.png" alt-text="Screenshot of the New virtual machine wizard on Specify generation page." lightbox="../manage/media/virtual-machine-image-centos-sysprep/centos-virtual-machine-generation.png":::
    
    1. Select **Install operating system from a bootable image** option. Point to ISO that you downloaded earlier.
    
        :::image type="content" source="../manage/media/virtual-machine-image-centos-sysprep/centos-virtual-machine-iso-option.png" alt-text="Screenshot of the New virtual machine wizard on Installation options page." lightbox="../manage/media/virtual-machine-image-centos-sysprep/centos-virtual-machine-iso-option.png":::

    See [Provision a VM using Hyper-V Manager](/windows-server/virtualization/hyper-v/get-started/create-a-virtual-machine-in-hyper-v?tabs=hyper-v-manager#create-a-virtual-machine) for step-by-step instructions.

1. Select **Assign Memory**, then enter `4096` for **Startup memory**:

    :::image type="content" source="../manage/media/virtual-machine-image-centos-sysprep/centos-virtual-machine-assign-memory.png" alt-text="Screenshot of the assign memory on Settings page." lightbox="../manage/media/virtual-machine-image-centos-sysprep/centos-virtual-machine-assign-memory.png":::

1. Disable secure boot on the VM.
    1. After the VM is created, it shows up in the Hyper-V manager. Select the virtual machine and right-click and then select **Settings**.
    1. In the left pane, select the **Security** tab. Then under **Secure Boot**, uncheck **Enable Secure Boot**.
    1. Apply the changes. On the next boot, the VM boots without the secure mode.

    :::image type="content" source="../manage/media/virtual-machine-image-centos-sysprep/centos-virtual-machine-secure-boot-disabled.png" alt-text="Screenshot of the secure boot disabled for VM on Settings page." lightbox="../manage/media/virtual-machine-image-centos-sysprep/centos-virtual-machine-secure-boot-disabled.png":::

Here are several example screenshots of CentOS installation pages:

:::image type="content" source="../manage/media/virtual-machine-image-centos-sysprep/centos-1.png" alt-text="Screenshot of CentOS management page 1." lightbox="../manage/media/virtual-machine-image-centos-sysprep/centos-1.png":::

:::image type="content" source="../manage/media/virtual-machine-image-centos-sysprep/centos-2.png" alt-text="Screenshot of CentOS management page 2." lightbox="../manage/media/virtual-machine-image-centos-sysprep/centos-2.png":::

:::image type="content" source="../manage/media/virtual-machine-image-centos-sysprep/centos-3.png" alt-text="Screenshot of CentOS management page 3." lightbox="../manage/media/virtual-machine-image-centos-sysprep/centos-3.png":::

### Step 2: Configure VM

Follow these steps on your Azure Stack HCI cluster to configure the VM that you provisioned earlier:

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

Delete machine-specific files and data from your VM so that you can create a clean VM image without any history or default configurations. Follow these steps on your Azure Stack HCI cluster to clean up the residual configuration:

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

Follow these steps on your Azure Stack HCI cluster to create the VM image:

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


1. Use the VHDX of the VM to create a CentOS gallery image. Use this CentOS VM image to create Arc virtual machines on your Azure Stack HCI.

    ```powershell
    $ImagePath = (Get-VMHardDiskDrive -VMName "mycentosvm").Path 

    $ImageName = "centos-server-ssvm" 

    az stack-hci-vm image create --subscription $subscription -g $resource_group --custom-location $CustomLocation --location $location --image-path $ImagePath --name $ImageName --debug --os-type 'Linux' 
    ```

1. Validate that the image is created. Here is example code and output for validation:

    :::image type="content" source="../manage/media/virtual-machine-image-centos-sysprep/validation-1.png" alt-text="Screenshot of example output for validation 1." lightbox="../manage/media/virtual-machine-image-centos-sysprep/validation-1.png":::

    :::image type="content" source="../manage/media/virtual-machine-image-centos-sysprep/validation-2.png" alt-text="Screenshot of example output for validation 2." lightbox="../manage/media/virtual-machine-image-centos-sysprep/validation-2.png":::

### Step 5: Create the VHD

Export a VHD or copy the VHD from your VM. Run the following command to obtain the path:

```powershell
Get-VMHardDiskDrive -VMName "centos7-3"
```

Where in this example the path would be: *<Get-VMHardDiskDrive -VMName "centos7-3">.Path*


### Step 6: Deploy the VM

1. To get `the CustomLocationId` needed for the next step, run the following command and make note of the value:

    ```azurecli
    az customlocation list --resource-group $resourceGroup
    ```

1. Run the following commands to create the VM image, create a NIC, and then create the VM:
 
   ```azurecli
    $location = "westeurope"
    az stack-hci-vm image create --subscription $subscription -g $resourcegroup --custom-location $CustomLocationId --location $location --image-path "C:\ClusterStorage\Infrastructure_1\centos7.vhdx" --name $ImageName --os-type 'Linux'
 
    az stack-hci-vm  network nic create --name $nicName --resource-group $resourcegroup --custom-location $CustomLocationId --location $location --ip-address $ipaddress --subnet-id $logicalnetwork
 
    az stack-hci-vm  create --name $vmName -g $resourcegroup `--admin-username admin --admin-password password`
    --computer-name $vmName `
          --image $img.Id --location $location `
    --authentication-type all --nics $vmNic --custom-location $clid  `--hardware-profile memory-mb="1024" processors="1" vm-size="Custom"
    ```

### Step 7: Validate deployment

Validate your VM deployment from a ssh console (Example: `ssh -l admin 192.168.200.23`), and then run the following command from the VM to get status output:

```azurecli
sudo systemctl status mocguestagent
```

**Example status output:**
:::image type="content" source="../manage/media/virtual-machine-image-centos-sysprep/validation-3.png" alt-text="Screenshot of example output for validation." lightbox="../manage/media/virtual-machine-image-centos-sysprep/centos-virtual-machine-secure-boot-disabled.png":::

## Next steps

- [Create Arc VMs](./manage-virtual-machines-in-azure-portal.md) on your Azure Stack HCI cluster.
