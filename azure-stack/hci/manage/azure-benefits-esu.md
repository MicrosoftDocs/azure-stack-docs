---
title: Extended Security Updates (ESU) on Azure Stack HCI
description: Learn how to get free extended security updates (ESUs) with Azure VM verification on Azure Stack HCI.
author: sethmanheim
ms.author: sethm
ms.topic: overview
ms.reviewer: jlei
ms.date: 06/07/2024
ms.lastreviewed: 02/23/2024

---

# Free Extended Security Updates (ESU) through Azure Stack HCI

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2-22h2.md)]

The Extended Security Update (ESU) program enables you to get important security patches for legacy Microsoft products that are past the end of support. Getting ESU through Azure Stack HCI comes with additional benefits and implementation steps. This article explains the specifics for Azure Stack HCI.

To get general information about the ESU program, products that are covered, and support dates, see the [Product Lifecycle FAQ](/lifecycle/faq/extended-security-updates#esu-availability-and-end-dates). For detailed steps to set up legacy OS support, see [Azure verification for VMs](../deploy/azure-verification.md#legacy-os-support).

> [!NOTE]
> Azure Stack HCI customers can obtain ESUs at no cost through Azure verification for VMs by following the instructions in this article. If you have an Arc-enabled server that is not Azure Stack HCI, you should consider obtaining ESU licenses through Arc. For more information, see [Deliver Extended Security Updates](/azure/azure-arc/servers/deliver-extended-security-updates) (through Arc).

## FAQ

### What ESU products does this cover?

ESU covers Windows Server and Windows client products under the ESU program. For more information, see the [product lifecycle FAQ](/lifecycle/faq/extended-security-updates#esu-availability-and-end-dates).

### Does this cover ESUs for Windows Server 2012?

Yes it does.

### Does my VM need to be connected to get ESUs?

No, you don't need internet connectivity to install ESUs, unless you're using an update method that requires internet connectivity to download ESU packages. Only the Azure Stack HCI host needs to maintain 30-day internet connectivity for Azure VM verification to remain active.

### Can I still use MAK keys to get ESUs for VMs on Azure Stack HCI?

Yes. If you have already bought MAK keys, you can still apply them with the instructions outlined in [Obtaining Extended Security Updates for eligible Windows devices](https://techcommunity.microsoft.com/t5/windows-it-pro-blog/obtaining-extended-security-updates-for-eligible-windows-devices/ba-p/1167091). However, MAK keys aren't free. Consider switching to the Azure verification for VMs approach so that you can automatically get free ESUs through your Azure Stack HCI cluster going forward.

### Can I discover ESUs if I don't have Azure verification for VMs?

Yes. You can discover ESUs even if you don't have Azure VM verification. For the installation, you must set up Azure verification for VMs (or MAK keys).

### Can I get ESUs through Azure Virtual Desktops (AVD) on Azure Stack HCI?

The operating systems currently supported for AVD on Azure Stack HCI aren't yet eligible for ESUs. [See the list here](/azure/virtual-desktop/azure-stack-hci-faq#what-session-host-operating-system-images-does-this-feature-support-).

### Do I need to do anything to renew for Year 1/Year 2/Year 3, etc.?

No. Once you set up Azure verification for VMs, you don't need to renew or do anything else.

## Next steps

- [Product Lifecycle FAQ - Extended Security Updates](/lifecycle/faq/extended-security-updates#esu-availability-and-end-dates).
