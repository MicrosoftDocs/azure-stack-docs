---
title: Guest operating systems supported on Azure Stack Hub
titleSuffix: Azure Stack
description: Learn which guest operating systems can be used on Azure Stack Hub.
author: sethmanheim
ms.topic: article
ms.date: 09/09/2021
ms.author: sethm
ms.reviewer: thoroet
ms.lastreviewed: 09/09/2021

# Intent: As an Azure Stack operator, I want to learnm which guest operating systems can be used on Azure Stack.
# Keyword: azure stack guest operating systems

---


# Guest operating systems supported on Azure Stack Hub

## Windows

Azure Stack Hub supports the Windows guest operating systems listed in the following table:

| Operating system | Description | Available in Azure Stack Hub Marketplace |
| --- | --- | --- |
| Windows Server, version 1709 | 64-bit | Core with containers |
| Windows Server 2019 | 64-bit |  Datacenter, Datacenter core, Datacenter with containers |
| Windows Server 2016 | 64-bit |  Datacenter, Datacenter core, Datacenter with containers |
| Windows Server 2012 R2 | 64-bit |  Datacenter |
| Windows Server 2012 | 64-bit |  Datacenter |
| Windows Server 2008 R2 SP1 | 64-bit |  Datacenter |
| Windows Server 2008 SP2 | 64-bit |  Bring your own image |
| Windows 10 *(see note 1)* | 64-bit, Pro, and Enterprise | Bring your own image |

> [!NOTE]
> To deploy Windows 10 client operating systems on Azure Stack Hub, you must have [Windows per-user licensing](https://www.microsoft.com/licensing/product-licensing/windows10.aspx) or purchase through a [Qualified Multitenant Hoster (QMTH)](https://partner.microsoft.com/membership/cloud-solution-provider).

Marketplace images are available for pay-as-you-use or BYOL (EA/SPLA) licensing. Use of both on a single Azure Stack Hub instance isn't supported. During deployment, Azure Stack Hub injects a suitable version of the guest agent into the image.

Datacenter editions are available in Azure Stack Hub Marketplace for downloading; customers can bring their own server images including other editions. Windows client images aren't available in Azure Stack Hub Marketplace.

## Linux

Linux distributions listed as available in Azure Stack Hub Marketplace include the necessary Windows Azure Linux Agent (WALA). If you bring your own image to Azure Stack, follow the guidelines in [Add Linux images to Azure Stack](azure-stack-linux.md).

> [!NOTE]  
> Custom images should be built with the latest public WALA version. For the minimum supported Azure Linux agent see [Minimum supported Azure Linux Agent](azure-stack-linux.md#minimum-supported-azure-linux-agent). 
>
> [cloud-init](https://cloud-init.io/) is supported.

| Distribution | Description | Publisher | Azure Stack Hub Marketplace |
| --- | --- | --- | --- |
| CentOS-based 8.0 | 64-bit | Rogue Wave | Yes |
| CentOS-based 7.8 | 64-bit | Rogue Wave | Yes |
| CentOS-based 7.7 LVM | 64-bit | Rogue Wave | Yes |
| CentOS-based 7.7 | 64-bit | Rogue Wave | Yes |
| CentOS-based 7.6 | 64-bit | Rogue Wave | Yes |
| CentOS-based 7.5 | 64-bit | Rogue Wave | Yes |
| CentOS-based 7.5 LVM | 64-bit | Rogue Wave | Yes |
| CentOS-based 7.4 | 64-bit | Rogue Wave | Yes |
| CentOS-based 7.3 | 64-bit | Rogue Wave | Yes |
| CentOS-based 6.9 | 64-bit | Rogue Wave | Yes |
| CentOS-based 6.10 | 64-bit | Rogue Wave | Yes |
| ClearLinux | 64-bit | ClearLinux.org | Yes |
| Debian 8 "Jessie" | 64-bit | credativ |  Yes |
| Debian 9 "Stretch" | 64-bit | credativ | Yes |
| Oracle Linux | 64-bit | Oracle | Yes |
| Red Hat Enterprise Linux 7.1 (and later) | 64-bit | Red Hat | Bring your own image |
| SLES 11SP4 | 64-bit | SUSE | Yes |
| SLES 12SP3 | 64-bit | SUSE | Yes |
| Ubuntu 14.04-LTS | 64-bit | Canonical | Yes |
| Ubuntu 16.04-LTS | 64-bit | Canonical | Yes |
| Ubuntu 18.04-LTS | 64-bit | Canonical | Yes |
| Ubuntu Server 20.04 LTS | 64-bit | Canonical | Yes |

For Red Hat Enterprise Linux support information, see [Red Hat and Azure Stack Hub: Frequently Asked Questions](https://access.redhat.com/articles/3413531).

## Next steps

For more information about Azure Stack Hub Marketplace, see the following articles:

- [Download marketplace items](azure-stack-download-azure-marketplace-item.md)  
- [Create and publish a marketplace item](azure-stack-create-and-publish-marketplace-item.md)
