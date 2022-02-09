---
title: Extended Security Updates (ESU) on Azure Stack HCI
description: Learn how to get free extended security updates (ESUs) with Azure Benefits on Azure Stack HCI.
author: sethmanheim
ms.author: sethm
ms.topic: overview
ms.reviewer: jlei
ms.date: 02/09/2022
ms.lastreviewed: 02/09/2022

---

# Extended security updates (ESU) on Azure Stack HCI

>Applies to Azure Stack HCI, version 21H2 and later

The Extended Security Update (ESU) program enables you to get important security patches for legacy Microsoft products that are past the end of support.

To get general information about the ESU program, products that are covered, and support dates, see the [Product Lifecycle FAQ](/lifecycle/faq/extended-security-updates#esu-availability-and-end-dates).

If you are already familiar with the ESU program, this article explains Azure Stack HCI-specific benefits and implementation.

## Benefits of getting ESU on Azure Stack HCI

There are multiple advantages to running ESU on Azure, and these benefits extend to Azure Stack HCI as well:

- **Free of charge**: You can run ESUs on-premises on Azure Stack HCI for free.
- **Get an additional year of ESU for Windows Server and SQL Server 2008 and 2008 R2**: On Azure and Azure Stack HCI only, ESUs for Windows Server and SQL Server 2008 and 2008 R2 will end on January 14, 2024 and July 12, 2023 respectively; a year longer than the usual three-year ESU programs.

## Tutorial: Get free ESUs automatically on Azure Stack HCI

This tutorial walks you through how you can use [Azure Benefits](azure-benefits.md) to automatically unlock free ESUs on Azure Stack HCI.

### Prerequisites

- Review and install the installation prerequisites section for ESUs in [Obtaining Extended Security Updates for eligible Windows devices](https://techcommunity.microsoft.com/t5/windows-it-pro-blog/obtaining-extended-security-updates-for-eligible-windows-devices/ba-p/1167091).
- Install the October 8th, 2021 SSU or later:
  - Windows 7 SP1 and Windows Server 2008 R2 SP1 (KB5006749)
  - Windows Server 2008 SP2 (KB5006750)

The following screen shot shows typical output when checking for required prerequisites using PowerShell. Your actual output may look different; this is only an example of output that shows currently installed security patches:

:::image type="content" source="media/azure-benefits-esu/esu-prerequisites.png" alt-text="ESU prerequisites":::

### Step 1: Turn on Azure Benefits on the host

[Azure Benefits](azure-benefits.md) is a feature on Azure Stack HCI that enables you to extend supported Azure-exclusive benefits to your cluster, including getting ESUs for
free.

To turn on Azure Benefits on the host:

- Follow the instructions to [turn on Azure Benefits using Windows Admin Center](azure-benefits.md#turn-on-azure-benefits-using-windows-admin-center):

  :::image type="content" source="media/azure-benefits-esu/benefits-windows-admin-center.png" alt-text="Benefits on Windows Admin Center ":::

- Follow the instructions to [turn on Azure Benefits using PowerShell](azure-benefits.md#turn-on-azure-benefits-using-powershell).

### Step 2: Turn on Azure Benefits on the VM

To turn on Azure Benefits on each VM that requires ESU:

- Follow these instructions for Windows Admin Center: [Manage access to Azure Benefits for your VMs - WAC](azure-benefits.md#manage-access-to-azure-benefits-for-your-vms---wac). Check that your ESU VMs (highlighted) are in the bottom table for **VMs with Azure Benefits**:

  :::image type="content" source="media/azure-benefits-esu/benefits-virtual-machines.png" alt-text="Virtual machines":::

- Follow these instructions for PowerShell: [Manage access to Azure Benefits for your VMs - PowerShell](azure-benefits.md#manage-access-to-azure-benefits-for-your-vms---powershell).

### Step 3: Install extended security update

Once Azure Benefits is set up, you can automatically install free Extended Security Updates on your cluster. Install using your current method of preference; for example, Windows
Update, Windows Server Update Services (WSUS), Microsoft Update Catalog, or other. This functionality will be enabled until the ESU end date for the product. The following screen shot shows installation of security updates using Windows Update:

:::image type="content" source="media/azure-benefits-esu/control-panel.png" alt-text="Control Panel":::

## FAQ

### Does my ESU VM need to be connected to the internet for Azure Stack HCI?

No, you do not need internet connectivity to *install* ESUs; only the Azure Stack HCI host requires you to have 30-day internet connectivity for Azure Benefits to remain active. Depending on your update method of preference, per existing requirements, you may need internet connectivity to discover and download ESU packages.

### Can I still get ESUs on Azure Stack HCI using MAK keys?

Yes. If you have already bought MAK keys, you can still apply them with the instructions outlined [here](https://techcommunity.microsoft.com/t5/windows-it-pro-blog/obtaining-extended-security-updates-for-eligible-windows-devices/ba-p/1167091). However, MAK keys are not free -- consider switching to the Azure Benefits approach so that you automatically get free ESUs for your Azure Stack HCI cluster going forward.

### Can I discover ESUs if I don't have Azure Benefits?

Yes. You can discover ESUs even if you don't have Azure Benefits, but for installation you will need to set up Azure Benefits (or MAK keys).

### Can I get ESUs through Azure Virtual Desktops (AVD) on Azure Stack HCI?

The operating systems currently supported for AVD on Azure Stack HCI are not yet eligible for ESUs. [See the list here](/virtual-desktop/azure-stack-hci-faq#what-session-host-operating-system-images-does-this-feature-support-).

## Next steps

[Product Lifecycle FAQ - Extended Security Updates](/lifecycle/faq/extended-security-updates#esu-availability-and-end-dates).
