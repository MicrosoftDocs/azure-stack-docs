---
title: Azure Stack Windows Server related FAQs | Microsoft Docs
description: List of Azure Stack Marketplace FAQs for Windows Server
services: azure-stack
documentationcenter: ''
author: sethmanheim
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: tzl
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 12/16/2019
ms.author: sethm
ms.reviewer: avishwan
ms.lastreviewed: 12/16/2019

---

# Windows Server in Azure Stack marketplace FAQ

This article answers some frequently asked questions about Windows Server images in the [Azure Stack Hub marketplace](azure-stack-marketplace.md).

## What are the licensing options for Windows Server Marketplace images on Azure Stack?

Users of the Azure Stack Hub ruggedized and MDC are entitled to free usage of Windows Server as a guest operating system.

Microsoft offers two versions of Windows Server images through the Azure Stack marketplace. Only one version of this image can be used in any given Azure Stack environment at the same time.

- **Pay as you use**: These images should not be used on Azure Stack Hub ruggedized or MDC.

- **Bring Your Own License (BYOL)**: These images can be used on Azure Stack Hub ruggedized and MDC.

## What about other VMs that use Windows Server, such as SQL Server?

The Windows Server software license only applies to the Windows operating system, not to layered products such as SQL, which require you to bring your own license.

## How do I update to a newer Windows image?

First, determine if any Azure Resource Manager templates refer to specific versions. If so, update those templates, or keep older image versions. It is best to use **version: latest**.

Next, if any virtual machine scale sets refer to a specific version, you should think about whether these will be scaled later, and decide whether to keep older versions. If neither of these conditions apply, delete older images in the marketplace before downloading newer ones. Use marketplace management to delete them if that is how the original was downloaded. Then download the newer version.

## What if I downloaded the wrong version to offer my tenants/users?

Delete the incorrect version first through marketplace management. Wait for it to complete (look at the notifications for completion, not the **Marketplace Management** blade). Then download the correct version.

If you download both versions of the image, only the latest version is visible to end customers in the marketplace gallery.

## Activation

To activate a Windows Server virtual machine on Azure Stack, the following condition must be true:

- Windows Server 2012 R2 and Windows Server 2016 must use [Automatic Virtual Machine Activation](/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/dn303421(v=ws.11)). Key Management Service (KMS) and other activation services are not supported on Azure Stack.

## How can I verify that my virtual machine is activated?

Run the following command from an elevated command prompt:

```shell
slmgr /dlv
```

If it is correctly activated, you will see this clearly indicated and the host name displayed in the slmgr output. Do not depend on watermarks on the display as they might not be up to date, or are showing from a different virtual machine behind yours.

## My VM is not set up to use AVMA, how can I fix it?

Run the following command from an elevated command prompt:

```shell
slmgr /ipk <AVMA key>
```

See the [Automatic Virtual Machine Activation](/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/dn303421(v=ws.11)) article for the keys to use for your image.

## I create my own Windows Server images, how can I make sure they use AVMA?

It is recommended that you execute the `slmgr /ipk` command with the appropriate key before you run the `sysprep` command. Or, include the AVMA key in any Unattend.exe setup file.

## I am trying to use my Windows Server 2016 image created on Azure and it is not activating or using KMS activation.

Run the `slmgr /ipk` command. Azure images may not correctly fall back to AVMA, but if they can reach the Azure KMS system, they will activate. It is recommended that you ensure these VMs are set to use AVMA.

## I have performed all of these steps but my virtual machines are still not activating.

Contact Microsoft support to verify that the correct BIOS markers were installed.

## What about earlier versions of Windows Server?

[Automatic Virtual Machine Activation](/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/dn303421(v=ws.11)) is not supported in versions of Windows Server earlier than 2012 R2. You must activate the VMs manually using MAK keys.

## Next steps

For more information, see the following articles:

- [Azure Stack Marketplace overview](azure-stack-marketplace.md)
- [Download marketplace items from Azure to Azure Stack](azure-stack-download-azure-marketplace-item.md)
