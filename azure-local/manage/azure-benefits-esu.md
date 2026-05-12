---
title: Extended Security Updates (ESU) on Azure Local
description: Learn how to get extended security updates (ESUs) on Azure Local.
author: ronmiab
ms.author: robess
ms.topic: overview
ms.reviewer: jlei
ms.date: 05/01/2026
ms.lastreviewed: 02/23/2024
ms.service: azure-local
ms.subservice: hyperconverged
---

# Extended Security Updates (ESU) on Azure Local

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2-22h2.md)]

The Extended Security Update (ESU) program allows you to get important security patches for legacy Microsoft products that are past the end of support. Getting ESU through Azure Local comes with additional benefits and implementation steps. This article explains the specifics for Azure Local.

For general information about the ESU program, products that are covered, and support dates, see the [Product Lifecycle FAQ](/lifecycle/faq/extended-security-updates#esu-availability-and-end-dates). For detailed steps to set up legacy OS support, see [Azure verification for VMs](../deploy/azure-verification.md#legacy-os-support).

> [!NOTE]
> Beginning April 1, 2026, Microsoft is introducing a standardized pricing approach for Extended Security Updates so that customers pay the same list price regardless of deployment location (Azure, on-premises, or other public clouds), and purchasing channel. See the FAQ section for further details on how this change applies to Azure Local.

## FAQ

### What ESU products does this cover?

ESU covers Windows Server and Windows client products under the ESU program. For more information, see the [product lifecycle FAQ](/lifecycle/faq/extended-security-updates#esu-availability-and-end-dates).

### Which ESU products will remain free on Azure Local?

All existing ESU products, including Windows Server 2012, Windows 10 version 22H2, and SQL Server 2014, remain free on Azure Local. You can get these products through Azure verification for VMs by following the instructions in this article.

### How can I get ESUs under the new pricing model?

Details on ESU pricing and availability will be made available in the next few months, and this article will be updated. 

### Does my VM need to be connected to get ESUs?

No, you don't need internet connectivity to install ESUs, unless you're using an update method that requires internet connectivity to download ESU packages. Only the Azure Local host needs to maintain 30-day internet connectivity for Azure VM verification to remain active.

### Can I use MAK keys to get ESUs for VMs on Azure Local?

Yes. If you already bought MAK keys, you can apply them by following the instructions in [Obtaining Extended Security Updates for eligible Windows devices](https://techcommunity.microsoft.com/t5/windows-it-pro-blog/obtaining-extended-security-updates-for-eligible-windows-devices/ba-p/1167091).

### Can I discover ESUs if I don't have Azure verification for VMs?

Yes. You can discover ESUs even if you don't have Azure VM verification. For the installation, you must set up Azure verification for VMs (or MAK keys).

### Can I get ESUs through Azure Virtual Desktops (AVD) on Azure Local?

Yes. All Azure Virtual Desktop session hosts running Windows 10, version 22H2 are entitled to Windows 10 Extended Security Updates (ESU) at no extra cost. For more information, see the [Extended Security Updates (ESU) program for Windows 10](/windows/whats-new/extended-security-updates). 

### Do I need to do anything to renew for Year 1, Year 2, Year 3...?

No. Once you set up Azure verification for VMs, you don't need to renew or do anything else.

## Next steps

- [Product Lifecycle FAQ - Extended Security Updates](/lifecycle/faq/extended-security-updates#esu-availability-and-end-dates).
