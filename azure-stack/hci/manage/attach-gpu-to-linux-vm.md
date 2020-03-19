---
title: Attaching a GPU to a Linux VM in Azure Stack HCI
description: How to use a GPU with AI workloads running in an Ubuntu Linux VM on Azure Stack HCI.
author: khdownie
ms.author: v-kedow
ms.topic: article
ms.date: 03/19/2020
---

# Attaching a GPU to an Ubuntu Linux VM on Azure Stack HCI

> Applies to: Windows Server 2019

This topic provides step-by-step instructions to configure an NVIDIA graphics processing unit (GPU) with Azure Stack HCI using Discrete Device Assignment (DDA) technology for an Ubuntu VM.
This document assumes you have the Azure Stack HCI cluster deployed and VMs installed.

## Install and configure NVIDIA GPU with DDA

Install the NVIDIA GPU physically into the server, following OEM instructions and BIOS recommendations.

### Configure the Azure Stack HCI node

Choose the server node(s) in your Azure Stack HCI cluster to install NVIDIA GPUs. Once the server boots up:

1. Login as Administrator to the Azure Stack HCI node with the NVIDIA GPU installed.
2. Open **Device Manager** and navigate to the *other devices* section. You should see a device listed as "3D Video Controller" or "PCI Express Graphics Processing Unit."
3. Right-click on "3D Video Controller" or "PCI Express Graphics Processing Unit" to bring up the **Properties** page. Click **Details**. From the dropdown under **Property**, select "Location paths."
4. Note the value with string PCIRoot as highlighted in the screen shot below. Right-click on **Value** and copy/save it.
    ![Location Path Screenshot](media/attach-gpu-to-linux-vm/pciroot.png)
5. Open Windows PowerShell with elevated privileges and execute the cmdlet below to dismount the GPU device for DDA to VM. Replace the LocationPath value for your device obtained in step 4.
    ```PowerShell
    Dismount-VMHostAssignableDevice -LocationPath "PCIROOT(16)#PCI(0000)#PCI(0000)" -force
    ```
6. Confirm the device is listed under system devices in device manager as Dismounted.
    > [!div class="mx-imgBorder"]
    > ![Dismounted Device Screenshot](media/attach-gpu-to-linux-vm/dismounted.png)

### Create and configure an Ubuntu virtual machine

1. Download Ubuntu desktop release 18.04.02.
2. Open Hyper-V Manager on the node of the system with the GPU installed.
   > [!NOTE]
   > DDA does not support failover, and [here's why](/windows-server/virtualization/hyper-v/plan/plan-for-deploying-devices-using-discrete-device-assignment). This is a virtual machine limitation with DDA. Therefore, we recommend using Hyper-V manager to deploy the VM on the node instead of Failover Cluster Manager. Use of Failover Cluster Manager with DDA will fail with an error message indicating that the VM has a device that doesn't support high availability.
3. Using the Ubuntu ISO downloaded in step 1 of this section, create a new virtual machine using the New Virtual Machine Wizard to create a Ubuntu Gen 1 VM with 2GB of memory and a network card attached to it.
4. Assign the Dismounted GPU device to the VM using commands below.


## Next steps

For more, see also:

- [Planning volumes in Storage Spaces Direct](/windows-server/storage/storage-spaces/plan-volumes)
- [Extending volumes in Storage Spaces Direct](/windows-server/storage/storage-spaces/resize-volumes)
- [Deleting volumes in Storage Spaces Direct](/windows-server/storage/storage-spaces/delete-volumes)