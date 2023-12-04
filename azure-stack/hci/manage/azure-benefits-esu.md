---
title: Extended Security Updates (ESU) on Azure Stack HCI
description: Learn how to get free extended security updates (ESUs) with Azure VM verification on Azure Stack HCI.
author: sethmanheim
ms.author: sethm
ms.topic: overview
ms.reviewer: jlei
ms.date: 12/04/2023
ms.lastreviewed: 12/04/2023

---

# Free Extended Security Updates (ESU) through Azure Stack HCI

> Applies to Azure Stack HCI, version 21H2, 22H2, 23H2 (preview), and later.

The Extended Security Update (ESU) program enables you to get important security patches for legacy Microsoft products that are past the end of support. Getting ESU through Azure Stack HCI comes with additional benefits and implementation steps – this article explains the specifics for Azure Stack HCI.

To get general information about the ESU program, products that are covered, and support dates, see the [Product Lifecycle FAQ](/lifecycle/faq/extended-security-updates#esu-availability-and-end-dates).

> [!NOTE]
> Azure Stack HCI customers can obtain ESUs at no cost through Azure verification for VMs by following the instructions in this article. If you have an Arc-enabled server that is not Azure Stack HCI, you should consider obtaining ESU licenses through Arc. For more information, see [Deliver Extended Security Updates](/azure/azure-arc/servers/deliver-extended-security-updates) (through Arc).

## Benefits of getting ESU for VMs on Azure Stack HCI

There are several advantages to getting ESU through Azure, which extend to Azure Stack HCI:

- **Free of charge**: You can get ESUs through Azure Stack HCI for free.
- **Get an additional year of ESUs for Windows Server**: On Azure and Azure Stack HCI only, ESUs for Windows Server will end on January 14, 2024 and July 12, 2023 respectively; a year longer than the usual three-year ESU programs.

## Tutorial: Get free ESUs through Azure Stack HCI

This tutorial walks you through how you can use [Azure verification for VMs](../deploy/azure-verification.md) to automatically unlock free ESUs on Azure Stack HCI. Azure verification is a feature on Azure Stack HCI that enables you to extend supported Azure-exclusive benefits to your cluster, including getting ESUs for free.

> [!NOTE]
> The steps in this tutorial apply to Azure Stack HCI version 23H2 and later only. If you're using version 22H2 and earlier, see the documentation for [Azure Benefits (22H2 and earlier)](azure-benefits.md).

### Prerequisites

#### [Windows Server 2012/2012 R2](#tab/windows-server-2012)

- Review and install the installation prerequisites section for [ESUs in KB5031043: Procedure to continue receiving security updates after extended support has ended on October 10, 2023 - Microsoft Support](https://support.microsoft.com/topic/kb5031043-procedure-to-continue-receiving-security-updates-after-extended-support-has-ended-on-october-10-2023-c1a20132-e34c-402d-96ca-1e785ed51d45).
- Install the August 8th, 2023 SSU or later:
  - Windows Server 2012 R2 (KB5029368)
  - Windows Server 2012 (KB5029369)

#### [Windows Server 2008/2008 R2](#tab/windows-server-2008)

- Review and install the installation prerequisites section for ESUs in [Obtaining Extended Security Updates for eligible Windows devices](https://techcommunity.microsoft.com/t5/windows-it-pro-blog/obtaining-extended-security-updates-for-eligible-windows-devices/ba-p/1167091).
- Install the October 8th, 2021 SSU or later:
  - Windows 7 SP1 and Windows Server 2008 R2 SP1 (KB5006749)
  - Windows Server 2008 SP2 (KB5006750)

The following image shows typical output when checking for required prerequisites using PowerShell. Your actual output might look different; this image is example output that shows installed prerequisites:

:::image type="content" source="media/azure-benefits-esu/esu-prerequisites.png" alt-text="Screenshot that shows E S U prerequisites.":::

---

### Step 1: Turn on legacy OS support for Azure VM verification

Follow these instructions to turn on legacy OS support for Azure VM verification:

- Using Windows Admin Center: [Manage legacy OS support using Windows Admin Center](../deploy/azure-verification.md?tabs=wac#1-turn-on-legacy-os-support-on-the-host).
- Using PowerShell: [Manage legacy OS support using PowerShell](../deploy/azure-verification.md?tabs=azure-ps#1-turn-on-legacy-os-support-on-the-host-1).

### Step 2: Enable access for new VMs

You must also enable legacy OS support access for each VM that requires ESU. Follow these instructions:

- Using Windows Admin Center: [Manage legacy OS support access for your VMs - Windows Admin Center](../deploy/azure-verification.md?tabs=wac#2-enable-access-for-new-vms). Check that your ESU VMs appear as **Active** in the **VM** tab.
- Using PowerShell: [Manage legacy OS support access for your VMs - PowerShell](../deploy/azure-verification.md?tabs=azure-ps#2-enable-access-for-vms).

### Step 3: Install Extended Security Updates

Once legacy OS support is set up, you can install free Extended Security Updates for eligible VMs on your cluster. Install updates using your current method of preference; for example, Windows
Update, Windows Server Update Services (WSUS), Microsoft Update Catalog, or other. The following screenshot shows installation of security updates using Windows Update:

:::image type="content" source="media/azure-benefits-esu/control-panel.png" alt-text="Screenshot that shows the Control Panel." lightbox="media/azure-benefits-esu/control-panel.png":::

## FAQ

### What ESU products does this cover?

ESU covers Windows Server and Windows client products under the ESU program. For more information, see the [product lifecycle FAQ](/lifecycle/faq/extended-security-updates#esu-availability-and-end-dates).

### Does this cover ESUs for Windows Server 2012?

Yes it does.

### Does my VM need to be connected to get ESUs?

No, you don't need internet connectivity to install ESUs, unless you're using an update method that requires internet connectivity to download ESU packages. Only the Azure Stack HCI host needs to maintain 30-day internet connectivity for Azure VM verification to remain active.

### Can I still use MAK keys to get ESUs for VMs on Azure Stack HCI?

Yes. If you have already bought MAK keys, you can still apply them with the instructions outlined in [Obtaining Extended Security Updates for eligible Windows devices](https://techcommunity.microsoft.com/t5/windows-it-pro-blog/obtaining-extended-security-updates-for-eligible-windows-devices/ba-p/1167091). However, MAK keys are not free. Consider switching to the Azure verification for VMs approach so that you can automatically get free ESUs through your Azure Stack HCI cluster going forward.

### Can I discover ESUs if I don't have Azure verification for VMs?

Yes. You can discover ESUs even if you don't have Azure VM verification. For the installation, you must set up Azure verification for VMs (or MAK keys).

### Can I get ESUs through Azure Virtual Desktops (AVD) on Azure Stack HCI?

The operating systems currently supported for AVD on Azure Stack HCI are not yet eligible for ESUs. [See the list here](/azure/virtual-desktop/azure-stack-hci-faq#what-session-host-operating-system-images-does-this-feature-support-).

### Do I need to do anything to renew for Year 1/Year 2/Year 3, etc.?

No. Once you have set up Azure verification for VMs, you don't need to renew or do anything else.

## Next steps

[Product Lifecycle FAQ - Extended Security Updates](/lifecycle/faq/extended-security-updates#esu-availability-and-end-dates).
