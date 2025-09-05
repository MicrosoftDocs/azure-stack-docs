---
title: Prepare Ubuntu Azure Marketplace Image for Azure Local VM Deployment
description: Learn how to prepare and export a Ubuntu Azure Marketplace VM image for use with Azure Local clusters.
ms.topic: how-to
author: ronmiab
ms.author: robess
ms.date: 09/04/2025
ai-usage: ai-assisted
ms.custom:
  - ai-gen-docs-bap
  - ai-gen-title
  - ai-seo-date:09/04/2025
  - ai-gen-description
---

# Prepare Ubuntu Azure Marketplace image for Azure Local VMs

This article explains how to prepare an Ubuntu Azure Marketplace image for use with Azure Local virtual machines (VMs). By following these steps, you ensure your VM has the latest security updates, support, and integration features.

## Prerequisites

- An active Azure subscription with permissions to set up and license a Ubuntu VM using Logical Volume Management (LVM), such as Ubuntu 22.04 or later.

- Access to the [Azure portal](https://portal.azure.com).

- An Azure Local cluster set up with a logical network and storage path for workloads. For more information, see [Create logical networks](../manage/create-logical-networks.md) and [Create storage paths](../manage/create-storage-path.md).

## Set up and prepare an Azure VM

To set up and prepare an Azure VM, follow these steps:

1. Sign in to the [Azure portal](https://portal.azure.com).

1. In the left pane, select **Virtual Machines**, next select **Create**, and then select **Virtual Machine**.

1. Browse the available images and choose your preferred Ubuntu version.

   :::image type="content" source="media/virtual-machine-azure-marketplace-ubuntu/vm-image-ubuntu.png" alt-text="Screenshot of the Azure portal image selection page." lightbox="../manage/media/virtual-machine-azure-marketplace-ubuntu/vm-image-ubuntu.png":::

1. Enter the required details in the wizard and finish setting up the Azure VM.

1. After the VM is deployed, go to the **VM overview** page, select the **Connect** option, and then select **Serial console**.

   :::image type="content" source="media/virtual-machine-azure-marketplace-ubuntu/connect-vm.png" alt-text="Screenshot of the Serial console sign in option in Azure portal." lightbox="../manage/media/virtual-machine-azure-marketplace-ubuntu/connect-vm.png":::

1. Connect to the VM with your credentials and run these commands:

   1. Sign in to the VM as the root user:

        ```bash
        sudo su
        ```

   1. Clean the `cloud-init` default configuration because it isn't relevant for Azure Local VMs.

        ```bash
        sudo cloud-init clean
        sudo rm -rf /var/lib/cloud/ /var/log/* /tmp/*
        ```

   1. Clean VM-specific SSH host keys.

        ```bash
        sudo rm -f /etc/ssh/ssh_host*
        ```

## Change the data source of the VM image

To change the data source of the VM image, follow these steps:

1. Change the directory to the following path and list the files to locate the data source file `90_dpkg.cfg`.Run these commands:

     ```bash
     cd /etc/cloud/cloud.cfg.d/
     ls
     ```

     Example output:

     ```console
     azureuser@ubuntu-image:/etc/cloud/cloud.cfg.d$ ls
     05_logging.cfg  10-azure-kvp.cfg  90-azure.cfg  90_dpkg.cfg
     ```

1. Open the `90_dpkg.cfg` file. Run this command:

     ```bash
     cat 90_dpkg.cfg
     ```

     Example output:

     ```console
     azureuser@ubuntu-image:/etc/cloud/cloud.cfg.d$ cat 90_dpkg.cfg
     # to update this file, run dpkg-reconfigure cloud-init
     datasource_list: [ Azure ]
     ```

1. Open and update the *datasource_list* from **Azure** to **NoCloud**. Run this command:

     ```bash
     sudo dpkg-reconfigure cloud-init
     ```

     Example output:

    ┌───────────────────────────── Configuring cloud-init ──────────────────────────────┐
    │ Cloud-init supports searching different "Data Sources" for information            │
    │ that it uses to configure a cloud instance.                                      │
    │                                                                                  │
    │ Warning: Only select 'Ec2' if this system will be run on a system with           │
    │ the EC2 metadata service present. Doing so incorrectly will result in a          │
    │ substantial timeout on boot.                                                     │
    │                                                                                  │
    │ Which data sources should be searched?                                           │
    │                                                                                  │
    │ [ ] NoCloud: Reads info from /var/lib/cloud/seed only                            │
    │ [ ] ConfigDrive: Reads data from Openstack Config Drive                          │
    │ [ ] OpenNebula: read from OpenNebula context disk                                │
    │ [ ] DigitalOcean: reads data from Droplet datasource                             │
    │ [*] Azure: read from MS Azure cdrom. Requires walinux-agent                      │
    │                                                                                  │
    │                                     <Ok>                                         │
    │                                                                                  │
    └──────────────────────────────────────────────────────────────────────────────────┘

     1. Toggle the **(*)** by pressing spacebar to activate **NoCloud** and remove Azure.

     1. Save the file by pressing **Enter**.

     Example output:

     :::image type="content" source="media/virtual-machine-azure-marketplace-ubuntu/no-cloud-output.png" alt-text="Screenshot of the NoCloud update output." lightbox="../manage/media/virtual-machine-azure-marketplace-ubuntu/no-cloud-output.png":::

1. To check that the file was updated, run this command:

     ```bash
     cat 90_dpkg.cfg
     ```

     Example output:

     ```console
     azureuser@ubuntu-image:/etc/cloud/cloud.cfg.d$ cat 90_dpkg.cfg
     # to update this file, run dpkg-reconfigure cloud-init
     datasource_list: [ NoCloud ]
     ```

1. Remove the bash history. Run these commands:

     ```bash
     sudo rm -f ~/.bash_history
     export HISTSIZE=0
     exit
     ```

1. Stop the Azure VM as the configuration changes are now complete.

## Export an Azure VM OS disk to a VHD on the Azure Local cluster

To export an Azure VM OS disk to a VHD on the Azure Local cluster, follow these steps:

1. In the Azure portal for your Azure Local resource, go to the **VM overview**. Under the **Settings** option, select **Disks**, and select the **Disks name** link.

   :::image type="content" source="media/virtual-machine-azure-marketplace-ubuntu/disk-name.png" alt-text="Screenshot of the OS disk details page." lightbox="../manage/media/virtual-machine-azure-marketplace-ubuntu/disk-name.png":::

1. Under **Settings**, select **Disk Export**, and then select **Generate URL** to generate a secure URL for the disk.

   :::image type="content" source="media/virtual-machine-azure-marketplace-ubuntu/disks-export.png" alt-text="Screenshot of the disk export option with secure URL generation." lightbox="../manage/media/virtual-machine-azure-marketplace-ubuntu/disks-export.png":::

1. Copy the generated secure URL link for the next step.

## Create an Azure Local image

To create an Azure Local image using the SAS token, run this command:

```azurecli
$rg = "<resource-group>"
$cl = "/subscriptions/<sub>/resourcegroups/$rg/providers/microsoft.extendedlocation/customlocations/<customlocation-name>"
$sas = '"https://EXAMPLE.blob.storage.azure.net/EXAMPLE/abcd<sas-token>"'

az stack-hci-vm image create -g $rg --custom-location $cl --name "<IMAGE-NAME>" --os-type "Linux" --image-path $sas
```

## Create an Azure Local VM

To create an Azure Local VM using the Azure Local VM image you created, follow the steps in [Create Azure Local virtual machines enabled by Azure Arc](../manage/create-arc-virtual-machines.md).
