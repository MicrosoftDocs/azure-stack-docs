---
title: Guest operating systems supported on Azure Stack Hub
titleSuffix: Azure Stack
description: Learn which guest operating systems can be used on Azure Stack Hub.
author: sethmanheim
ms.topic: feature-availability
ms.custom: linux-related-content
ms.date: 06/04/2026
ms.author: sethm
ms.reviewer: thoroet
ms.lastreviewed: 09/09/2021

# Intent: As an Azure Stack operator, I want to learnm which guest operating systems can be used on Azure Stack.
# Keyword: azure stack guest operating systems
---


# Guest operating systems supported on Azure Stack Hub

## Windows

Azure Stack Hub supports the Windows guest operating systems listed in the following table:

### [Azure Stack Hub 2108 or later](#tab/os1)

| Operating system | Description | Available in Azure Stack Hub Marketplace |
| --- | --- | --- |
| Windows Server 2025<sup>1</sup> | 64-bit | Datacenter, Datacenter core |
| Windows Server 2022 | 64-bit | Datacenter, Datacenter core |
| Windows Server, version 1709 | 64-bit | Core with containers |
| Windows Server 2019 | 64-bit |  Datacenter, Datacenter core, Datacenter with containers |
| Windows Server 2016 | 64-bit |  Datacenter, Datacenter core, Datacenter with containers |
| Windows Server 2012 R2 | 64-bit |  Datacenter |
| Windows Server 2012 | 64-bit |  Datacenter |
| Windows Server 2008 R2 SP1 | 64-bit |  Datacenter |
| Windows Server 2008 SP2 | 64-bit |  Bring your own image |
| Windows 10 <sup>2</sup> | 64-bit, Pro, and Enterprise | Bring your own image |

<sup>1</sup> Windows Server 2025 VM guest OS activation only supports MAK and KMS (not AVMA), which is [described in the readme.md file on GitHub](https://github.com/Azure/AzureStack-Tools/tree/master/Support/create-ws2025-image-from-azure#readme). Additionally, Windows Server 2025 requires the image to be added manually; that is, it isn't available for syndication using the **Add from Azure** experience in the admin portal.

<sup>2</sup> To deploy Windows 10 client operating systems on Azure Stack Hub, you must have [Windows per-user licensing](https://www.microsoft.com/licensing/product-licensing/windows10.aspx) or purchase through a [Qualified Multitenant Hoster (QMTH)](https://partner.microsoft.com/membership/cloud-solution-provider).

### [Azure Stack Hub 2102 or earlier](#tab/os2)

| Operating system | Description | Available in Azure Stack Hub Marketplace |
| --- | --- | --- |
| Windows Server, version 1709 | 64-bit | Core with containers |
| Windows Server 2019 | 64-bit |  Datacenter, Datacenter core, Datacenter with containers |
| Windows Server 2016 | 64-bit |  Datacenter, Datacenter core, Datacenter with containers |
| Windows Server 2012 R2 | 64-bit |  Datacenter |
| Windows Server 2012 | 64-bit |  Datacenter |
| Windows Server 2008 R2 SP1 | 64-bit |  Datacenter |
| Windows Server 2008 SP2 | 64-bit |  Bring your own image |
| Windows 10<sup>1</sup> | 64-bit, Pro, and Enterprise | Bring your own image |

<sup>1</sup> To deploy Windows 10 client operating systems on Azure Stack Hub, you must have [Windows per-user licensing](https://www.microsoft.com/licensing/product-licensing/windows10.aspx) or purchase through a [Qualified Multitenant Hoster (QMTH)](https://partner.microsoft.com/membership/cloud-solution-provider).

---

Marketplace images are available for pay-as-you-use or BYOL (EA/SPLA) licensing. Use of both on a single Azure Stack Hub instance isn't supported. During deployment, Azure Stack Hub injects a suitable version of the guest agent into the image.

Datacenter editions are available in Azure Stack Hub Marketplace for downloading; customers can bring their own server images including other editions. 

## Linux

Azure Stack Hub follows the same [Linux guest OS support model](#support-scope) as public Azure. All Linux distributions are welcome as guest operating systems, either deployed from the Azure Stack Hub Marketplace or uploaded as custom images.

### Endorsed distributions

Azure Stack Hub recognizes the same set of [endorsed Linux distributions as public Azure](/azure/virtual-machines/linux/endorsed-distros). Endorsed distributions are validated for the Azure platform by their publishers in partnership with Microsoft. Marketplace images of endorsed distributions include a preinstalled [Azure Linux Agent (WALinuxAgent)](https://github.com/Azure/WALinuxAgent) and are tested for compatibility with Azure Stack Hub.

Being an endorsed distribution or being available in the Marketplace doesn't imply a higher level of support. It indicates additional testing and reliability validation. Microsoft provides commercially reasonable support for all Linux distributions running on Azure Stack Hub, as described in [Support for Linux and open-source technology in Azure](/troubleshoot/azure/cloud-services/classic/support-linux-open-source-technology).

> [!NOTE]
> The Azure Stack Hub Marketplace might offer a subset of the endorsed distributions available in the public Azure Marketplace. Availability depends on the images syndicated by the Azure Stack Hub operator. For information about which images are currently available, contact your Azure Stack Hub operator or see [Azure Stack Hub Marketplace overview](/azure-stack/operator/azure-stack-marketplace).

### Custom images

You can bring any Linux distribution to Azure Stack Hub as a custom VM image, including distributions that aren't listed as endorsed. You should build custom images with the latest public version of the [Azure Linux Agent (WALinuxAgent)](https://github.com/Azure/WALinuxAgent). For minimum version requirements, see [Minimum supported Azure Linux Agent](/azure-stack/operator/azure-stack-linux#minimum-supported-azure-linux-agent).

When you upload a custom image, follow the guidance in [Add Linux images to Azure Stack Hub](/azure-stack/operator/azure-stack-linux).

[cloud-init](https://cloud-init.io/) is supported on Azure Stack Hub.

### Support scope

Microsoft provides commercially reasonable support for Linux running on Azure Stack Hub. The scope of support follows the same policies as public Azure:

- Microsoft supports the Azure platform and services. For distribution-specific issues, Microsoft might engage or defer to the distribution vendor.
- For endorsed Marketplace images, Microsoft provides first-level support. For distribution-specific issues beyond Microsoft's scope, customers might need to engage the distribution vendor directly.
- For custom or bring-your-own images, the distribution vendor is primarily responsible for OS-level support. Microsoft provides platform-level assistance.

For full details, see [Support for Linux and open-source technology in Azure](/troubleshoot/azure/cloud-services/classic/support-linux-open-source-technology).

### Red Hat Enterprise Linux

For information about Red Hat support on Azure Stack Hub, including Cloud Access (bring-your-own-subscription) and on-demand options, see [Red Hat and Azure Stack Hub: Frequently Asked Questions](https://access.redhat.com/articles/3413531).

## Next steps

For more information about Azure Stack Hub Marketplace, see the following articles:

- [Download marketplace items](azure-stack-download-azure-marketplace-item.md)  
- [Create and publish a marketplace item](azure-stack-create-and-publish-marketplace-item.md)
