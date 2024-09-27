---
title: Prepare SUSE Linux image for Azure Stack HCI VM via Azure CLI (preview)
description: Learn how to prepare SUSE Linux images to create an Azure Stack HCI VM image (preview) by using Azure CLI.
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.custom:
  - devx-track-azurecli
ms.date: 08/01/2024
#Customer intent: As a Senior Content Developer, I want to provide customers with content and steps to help them successfully use SUSE Linux to create images on Azure Stack HCI.
---

# Prepare SUSE Linux image for Azure Stack HCI virtual machines (preview)

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article describes how to use a SUSE Linux image to create a virtual machine (VM) on your Azure Stack HCI cluster. You use Azure CLI for the VM image creation.

## Prerequisites

Before you begin, meet the following prerequisites:

- Have access to an Azure Stack HCI cluster. This cluster is deployed, registered, and connected to Azure Arc. Go to the **Overview** page in the Azure Stack HCI cluster resource. On the **Server** tab in the right-pane, the **Azure Arc** should show as **Connected**.

- [Download the SUSE QCOW2](https://download.opensuse.org/repositories/Cloud:/Images:/Leap_15.6/images/openSUSE-Leap-15.6.x86_64-NoCloud.qcow2) image file to your local system. Alternatively, you can run the following PowerShell command to download the image:

    ```powershell
    PS C:\temp\images> wget "https://download.opensuse.org/repositories/Cloud:/Images:/Leap_15.6/images/openSUSE-Leap-15.6.x86_64-NoCloud.qcow2" -OutFile c:\temp\images\openSUSE-Leap-15.6.x86_64-NoCloud.qcow
    ```

## Workflow

To convert the QCOW2 image to VHDX and create a VM image from the VHDX image.

1. [Convert QCOW2 to VHDX](#step-1-convert-qcow2-to-vhdx).
2. [Create a SUSE VM image](#step-2-create-a-suse-vm-image).

> [!IMPORTANT]
> Do not use an Azure Virtual Machine VHD disk to prepare the VM image for Azure Stack HCI.

The following sections provide detailed instructions for each step in the workflow.

## Step 1: Convert QCOW2 to VHDX

After the QCOW2 image is downloaded, use the **QEMU disk image utility for Windows** tool to convert the image to VHDX.

The QEMU disk image utility for Windows tool is used to convert, create, and consistently check various virtual disk formats. It's compatible with Hyper-V and other solutions and is optimized for Windows Server (x64).

Follow these steps to download the tool and convert the QCOW2 image file to VHDX.

1. Download the [QEMU disk image utility for Windows](https://cloudbase.it/qemu-img-windows/) tool by clicking the **Download binaries** button for file. Alternatively, you can run the following PowerShell command to download the tool:

    ```powershell
    PS C:\temp\tool> wget https://cloudbase.it/downloads/qemu-img-win-x64-2_3_0.zip -OutFile C:\temp\tool\qemu-img-win-x64-2_3_0.zip
    ```

2. After the tool is downloaded, extract the files from the zip by running this command:

    ```powershell
    PS C:\temp\tool
    Expand-Archive 'c:\temp\tool\qemu-img-win-x64-2_3_0.zip'
    ```

    Here's an example:

    :::image type="content" source="../manage/media/virtual-machine-image-suse/suse-qemu-extracted-zip.png" alt-text="Screenshot that shows the downloaded QEMU Disk Utility tool." lightbox="../manage/media/virtual-machine-image-suse/suse-qemu-extracted-zip.png":::

3. Then using the QEMU tool, convert and save the QCOW2 to VHDX by running this command:

    ```PowerShell
    PS C:\temp\tool\qemu-img-win-x64-2_3_0> ./qemu-img.exe convert c:\temp\images\openSUSE-Leap-15.6.x86_64-NoCloud.qcow2 -O vhdx -o subformat=dynamic c:\temp\images\openSUSE-Leap-15.6.x86_64-NoCloud.vhdx
    PS C:\temp\tool\qemu-img-win-x64-2_3_0>
    ```

    Here's an example:

    :::image type="content" source="../manage/media/virtual-machine-image-suse/suse-qcow-2-to-vhdx.png" alt-text="Screenshot that shows the original QCOW2 image and the new VHDX image." lightbox="../manage/media/virtual-machine-image-suse/suse-qcow-2-to-vhdx.png":::

Now, you're ready to create your VM image.

## Step 2: Create a SUSE VM image

[!INCLUDE [hci-create-a-vm-image](../../includes/hci-create-a-vm-image.md)]

## Related content

- [Create logical networks for Azure Stack HCI](../manage/create-logical-networks.md) on your Azure Stack HCI cluster.