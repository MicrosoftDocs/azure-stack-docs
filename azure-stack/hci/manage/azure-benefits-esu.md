---
title: Extended Security Updates (ESU) on Azure Stack HCI
description: Learn how to get free extended security updates (ESUs) with Azure Benefits on Azure Stack HCI.
author: sethmanheim
ms.author: sethm
ms.topic: overview
ms.reviewer: jlei
ms.date: 02/14/2022
ms.lastreviewed: 02/14/2022

---

# Free Extended Security Updates (ESU) through Azure Stack HCI

>Applies to Azure Stack HCI, version 21H2 and later

The Extended Security Update (ESU) program enables you to get important security patches for legacy Microsoft products that are past the end of support. Getting ESU through Azure Stack HCI comes with additional benefits and implementation steps – this article explains the specifics for Azure Stack HCI.

To get general information about the ESU program, products that are covered, and support dates, see the [Product Lifecycle FAQ](/lifecycle/faq/extended-security-updates#esu-availability-and-end-dates).

## Benefits of getting ESU for VMs on Azure Stack HCI

There are several advantages to getting ESU through Azure, which extend to Azure Stack HCI:

- **Free of charge**: You can get ESUs through Azure Stack HCI for free.
- **Get an additional year of ESUs for Windows Server and SQL Server 2008 and 2008 R2**: On Azure and Azure Stack HCI only, ESUs for Windows Server and SQL Server 2008 and 2008 R2 will end on January 14, 2024 and July 12, 2023 respectively; a year longer than the usual three-year ESU programs.

## Tutorial: Get free ESUs through Azure Stack HCI

This tutorial walks you through how you can use [Azure Benefits](azure-benefits.md) to automatically unlock free ESUs on Azure Stack HCI. Azure Benefits is a feature on Azure Stack HCI that enables you to extend supported Azure-exclusive benefits to your cluster, including getting ESUs for free.

### Prerequisites

- Review and install the installation prerequisites section for ESUs in [Obtaining Extended Security Updates for eligible Windows devices](https://techcommunity.microsoft.com/t5/windows-it-pro-blog/obtaining-extended-security-updates-for-eligible-windows-devices/ba-p/1167091).
- Install the October 8th, 2021 SSU or later:
  - Windows 7 SP1 and Windows Server 2008 R2 SP1 (KB5006749)
  - Windows Server 2008 SP2 (KB5006750)

The following screen capture shows typical output when checking for required prerequisites using PowerShell. Your actual output may look different; this is example output that shows installed prerequisites:

:::image type="content" source="media/azure-benefits-esu/esu-prerequisites.png" alt-text="Screenshot that shows E S U prerequisites.":::

### Step 1: Turn on Azure Benefits on the host

Follow these instructions to turn on Azure Benefits on the host:

- Using Windows Admin Center: [turn on Azure Benefits using Windows Admin Center](azure-benefits.md#turn-on-azure-benefits-using-windows-admin-center).
- Using PowerShell: [turn on Azure Benefits using PowerShell](azure-benefits.md#turn-on-azure-benefits-using-powershell).

### Step 2: Turn on Azure Benefits on the VM

You must also turn on Azure Benefits on each VM that requires ESU. Follow these instructions:

- Using Windows Admin Center: [Manage access to Azure Benefits for your VMs - WAC](azure-benefits.md#manage-access-to-azure-benefits-for-your-vms---wac). Check that your ESU VMs (highlighted) are in the bottom table for **VMs with Azure Benefits**.
- Using PowerShell: [Manage access to Azure Benefits for your VMs - PowerShell](azure-benefits.md#manage-access-to-azure-benefits-for-your-vms---powershell).

### Step 3: Install Extended Security Updates

Once Azure Benefits is set up, you can install free Extended Security Updates for eligible VMs on your cluster. Install updates using your current method of preference; for example, Windows
Update, Windows Server Update Services (WSUS), Microsoft Update Catalog, or other. The following screenshot shows installation of security updates using Windows Update:

:::image type="content" source="media/azure-benefits-esu/control-panel.png" alt-text="Screenshot that shows the Control Panel." lightbox="media/azure-benefits-esu/control-panel.png":::

## FAQ

### Does my VM need to be connected to get ESUs?

No, you do not need internet connectivity to install ESUs, unless you are using an update method that requires internet connectivity to download ESU packages. Only the Azure Stack HCI host needs to maintain 30-day internet connectivity for Azure Benefits to remain active.

### Can I still use MAK keys to get ESUs for VMs on Azure Stack HCI?

Yes. If you have already bought MAK keys, you can still apply them with the instructions outlined in [Obtaining Extended Security Updates for eligible Windows devices](https://techcommunity.microsoft.com/t5/windows-it-pro-blog/obtaining-extended-security-updates-for-eligible-windows-devices/ba-p/1167091). However, MAK keys are not free -- consider switching to the Azure Benefits approach so that you can automatically get free ESUs through your Azure Stack HCI cluster going forward.

### Can I discover ESUs if I don't have Azure Benefits?

Yes. You can discover ESUs even if you don't have Azure Benefits, but for the installation, you will need to set up Azure Benefits (or MAK keys).

### Can I get ESUs through Azure Virtual Desktops (AVD) on Azure Stack HCI?

The operating systems currently supported for AVD on Azure Stack HCI are not yet eligible for ESUs. [See the list here](/azure/virtual-desktop/azure-stack-hci-faq#what-session-host-operating-system-images-does-this-feature-support-).

### Do I need to do anything to renew for Year 1/Year 2/Year 3, etc.?

No. Once you have set up Azure Benefits, you don't need to renew or do anything else.

## Next steps

[Product Lifecycle FAQ - Extended Security Updates](/lifecycle/faq/extended-security-updates#esu-availability-and-end-dates).
