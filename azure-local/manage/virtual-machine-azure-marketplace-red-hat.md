---
title: Prepare Red Hat Enterprise Azure Marketplace Image for Azure Local VM Deployment
description: Learn how to prepare and export a Red Hat Enterprise Azure Marketplace VM image for use with Azure Local clusters.
ms.topic: how-to
author: ronmiab
ms.author: robess
ms.date: 08/26/2025
ai-usage: ai-assisted
ms.custom:
  - ai-gen-docs-bap
  - ai-gen-title
  - ai-seo-date:08/26/2025
  - ai-gen-description
---

# Prepare Red Hat Enterprise Azure Marketplace image for Azure Local VMs

This article explains how to prepare a Red Hat Enterprise Linux (RHEL) Azure Marketplace image for use with Azure Local virtual machines (VMs). By following these steps, you ensure your VM has the latest security updates, support, and integration features.

## Prerequisites

Before you begin, you must have:

- An active Azure subscription with permissions to set up and license a RHEL VM using Logical Volume Management (LVM), such as RHEL 7.6 or later.

- Access to the [Azure portal](https://portal.azure.com).

- An Azure Local cluster set up with a logical network and storage path for workloads. For more information, see [Create logical networks](../manage/create-logical-networks.md) and [Create storage paths](../manage/create-storage-path.md).

## Set up and prepare an Azure VM

To set up and prepare an Azure VM, follow these steps:

1. Sign in to the [Azure portal](https://portal.azure.com).

1. In the left pane, select **Virtual Machines**, next select **Create**, and then select **Virtual Machine**.

1. Browse the available images and choose your preferred RHEL LVM Gen2 version.

   :::image type="content" source="media/virtual-machine-azure-marketplace-red-hat-enterprise/vm-image-red-hat.png" alt-text="Screenshot of the Azure portal image selection page." lightbox="../manage/media/virtual-machine-azure-marketplace-red-hat-enterprise/vm-image-red-hat.png":::

1. Enter the required details in the wizard and finish setting up the Azure VM.

1. After the VM is deployed, go to the **VM overview** page, select the **Connect** option, and then select **Serial console**.

   :::image type="content" source="media/virtual-machine-azure-marketplace-red-hat-enterprise/connect-vm.png" alt-text="Screenshot of the Serial console sign in option in Azure portal." lightbox="../manage/media/virtual-machine-azure-marketplace-red-hat-enterprise/connect-vm.png":::

1. Connect to the VM with your credentials and run these commands:

    1. Sign in to the VM as the root user:

       ```bash
       sudo su
       ```

    1. Clean the `cloud-init` default configuration because it isn't relevant for Azure Local VMs.

        ```bash
        sudo yum clean all
        sudo cloud-init clean
        ```

        Example output:

        ```console
        [contosotest@localhost ~]$ sudo yum clean all
        Updating Subscription Management repositories.
        17 files removed
        [contosotest@localhost ~]$ sudo cloud-init clean
        ```

    1. Clean the `cloud-init` default configuration because it isn't relevant for Azure Local VMs.

       ```bash
       sudo rm -rf /var/lib/cloud/ /var/log/* /tmp/*
       ```

    1. Unregister `subscription-manager` and clean it up.

       ```bash
       sudo subscription-manager unregister
       sudo subscription-manager clean
       ```

       Example output:

       ```console
       [contosotest@localhost ~]$ sudo subscription-manager unregister
       Unregistering from: subscription.rhsm.redhat.com:443/subscription
       System has been unregistered.
       [contosotest@localhost ~]$ sudo subscription-manager
       ```

    1. Clean VM-specific details.

       ```bash
       sudo rm -f /etc/sysconfig/network-scripts/*
       sudo rm -f /etc/ssh/ssh_host*
       sudo rm /etc/lvm/devices/system.devices
       ```

## Change the data source of the VM image

To change the data source of the VM image, follow these steps

1. Change the directory to the following path and list the files to locate the data source file **91-azure_datasource.cfg**

   ```bash
   cd /etc/cloud/cloud.cfg.d/
   ls
   ```

   Example output:

   ```console
   [root@rhelsysprep cloud.cfg.d]# ls 
   05_logging.cfg  10-azure-kvp.cfg  91-azure_datasource.cfg  README
   ```

1. Open the `91-azure_datasource.cfg` file. Run this command:

   ```bash
   cat 91-azure_datasource.cfg
   ```

   Example output:

   ```console
   datasource_list: [ Azure ]
   datasource:
     Azure:
       apply network config: False
   ```

1. Open and update the *datasource_list* from **Azure** to **NoCloud**. Run this command:

   ```bash
   vi 91-azure_datasource.cfg
   ```

   1. To edit the file, press `i`.
   1. Remove the datasource and update the details from `datasource_list: [Azure]` to `datasource_list: [NoCloud]`
   1. Save the file by pressing the **Esc** key followed by `:x` and hit **Enter**.

      Example output:

      ```console
      datasource_list: [NoCloud]
      ~??
      ~
      ```

1. To check that the file was updated, run this command:

   ```bash
   cat 91-azure_datasource.cfg
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

   :::image type="content" source="media/virtual-machine-azure-marketplace-red-hat-enterprise/disks-name.png" alt-text="Screenshot of the OS disk details page." lightbox="../manage/media/virtual-machine-azure-marketplace-red-hat-enterprise/disks-name.png":::

1. Under **Settings**, select **Disk Export**, and then select **Generate URL** to generate a secure URL for the disk.

   :::image type="content" source="media/virtual-machine-azure-marketplace-red-hat-enterprise/disks-export.png" alt-text="Screenshot of the disk export option with secure URL generation." lightbox="../manage/media/virtual-machine-azure-marketplace-red-hat-enterprise/disks-export.png":::

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
