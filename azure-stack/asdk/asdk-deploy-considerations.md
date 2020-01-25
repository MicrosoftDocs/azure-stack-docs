---
title: ASDK requirements and considerations | Microsoft Docs
description: Learn about the hardware, software, and environment requirements for Azure Stack Development Kit (ASDK).
author: justinha

ms.service: azure-stack
ms.topic: article
ms.date: 05/13/2019
ms.author: justinha
ms.reviewer: misainat
ms.lastreviewed: 05/13/2019


---

# ASDK requirements and considerations

Before you deploy the Azure Stack Development Kit (ASDK), make sure your ASDK host computer meets the requirements described in this article.

## Hardware

| Component | Minimum | Recommended |
| --- | --- | --- |
| Disk drives: Operating System |1 operating system disk with minimum of 200 GB available for system partition (SSD or HDD). |1 OS disk with minimum of 200 GB available for system partition (SSD or HDD). |
| Disk drives: General development kit data<sup>*</sup>  |4 disks. Each disk provides a minimum of 240 GB of capacity (SSD or HDD). All available disks are used. |4 disks. Each disk provides a minimum of 400 GB of capacity (SSD or HDD). All available disks are used. |
| Compute: CPU |Dual-Socket: 16 Physical Cores (total). |Dual-Socket: 20 Physical Cores (total). |
| Compute: Memory |192-GB RAM. |256-GB RAM. |
| Compute: BIOS |Hyper-V Enabled (with SLAT support). |Hyper-V Enabled (with SLAT support). |
| Network: NIC |Windows Server 2012 R2 Certification. No specialized features required. | Windows Server 2012 R2 Certification. No specialized features required. |
| HW logo certification |[Certified for Windows Server 2012 R2](https://windowsservercatalog.com/results.aspx?&chtext=&cstext=&csttext=&chbtext=&bCatID=1333&cpID=0&avc=79&ava=0&avq=0&OR=1&PGS=25&ready=0). |[Certified for Windows Server 2016](https://windowsservercatalog.com/results.aspx?&chtext=&cstext=&csttext=&chbtext=&bCatID=1333&cpID=0&avc=79&ava=0&avq=0&OR=1&PGS=25&ready=0). |

<sup>*</sup> You need more than this recommended capacity if you plan on adding many of the [marketplace items](../operator/azure-stack-create-and-publish-marketplace-item.md) from Azure.

### Hardware notes

**Data disk drive configuration:** All data drives must be of the same type (all SAS, all SATA, or all NVMe) and capacity. If SAS disk drives are used, the disk drives must be attached via a single path (no MPIO, multi-path support is provided).

**HBA configuration options**

* (Preferred) Simple HBA.
* RAID HBA - Adapter must be configured in "pass through" mode.
* RAID HBA - Disks should be configured as Single-Disk, RAID-0.

**Supported bus and media type combinations**

* SATA HDD
* SAS HDD
* RAID HDD
* RAID SSD (If the media type is unspecified/unknown<sup>*</sup>)
* SATA SSD + SATA HDD
* SAS SSD + SAS HDD
* NVMe

<sup>*</sup> RAID controllers without pass-through capability can't recognize the media type. Such controllers mark both HDD and SSD as Unspecified. In that case, the SSD is used as persistent storage instead of caching devices. Therefore, you can deploy the ASDK on those SSDs.

**Example HBAs**: LSI 9207-8i, LSI-9300-8i, or LSI-9265-8i in pass-through mode.

Sample OEM configurations are available.

### Storage resiliency for the ASDK

As a single node system, the ASDK isn't designed for validating production redundancy of an Azure Stack integrated system. However, you can increase the level of the underlying storage redundancy of the ASDK through the optimal mix of HDD and SSD drives. You can deploy a two-way mirror configuration, similar to a RAID1, rather than a simple resiliency configuration, which is similar to a RAID0. Use enough capacity, type, and number of drives for the underlying Storage Spaces Direct configuration.

To use a two-way mirror configuration for storage resiliency:

- You need HDD capacity in the system of greater than two terabytes.
- If you don't have SSDs in your ASDK, you need at least eight HDDs for a two-way mirror configuration.
- If you have SSDs in your ASDK, along with HDDs, you need at least five HDDs. However, six HHDs are recommended. For six HDDs, it's also recommended to have at least three corresponding SSDs in the system so that you have one cache disk (SSD) to serve two capacity drives (HDD).

Example two-way mirror configuration:

- Eight HDDs
- Three SSD / six HDD
- Four SSD / eight HDD

## Operating system
|  | **Requirements** |
| --- | --- |
| **OS Version** |Windows Server 2016 or later. The operating system version isn't critical before the deployment starts because you boot the host computer into the VHD that's included in the Azure Stack installation. The operating system and all required patches are already integrated into the image. Don't use any keys to activate any Windows Server instances used in the ASDK. |

> [!TIP]
> After installing the operating system, you can use the [Deployment Checker for Azure Stack](https://gallery.technet.microsoft.com/Deployment-Checker-for-50e0f51b) to confirm that your hardware meets all the requirements.

## Account requirements
Typically, you deploy the ASDK with internet connectivity, where you can connect to Microsoft Azure. In this case, you must configure an Azure Active Directory (Azure AD) account to deploy the ASDK.

If your environment isn't connected to the internet, or you don't want to use Azure AD, you can deploy Azure Stack by using Active Directory Federation Services (AD FS). The ASDK includes its own AD FS and Active Directory Domain Services instances. If you deploy by using this option, you don't have to set up accounts ahead of time.

> [!NOTE]
> If you deploy by using the AD FS option, you must redeploy Azure Stack to switch to Azure AD.

### Azure Active Directory accounts
To deploy Azure Stack by using an Azure AD account, you must prepare an Azure AD account before you run the deployment PowerShell script. This account becomes the Global Admin for the Azure AD tenant. It's used to provision and delegate apps and service principals for all Azure Stack services that interact with Azure AD and Graph API. It's also used as the owner of the default provider subscription (which you can later change). You can sign in to your Azure Stack system's administrator portal by using this account.

1. Create an Azure AD account that is the directory admin for at least one Azure AD. If you already have one, you can use that. Otherwise, you can create one for free at [https://azure.microsoft.com/free/](https://azure.microsoft.com/free/) (in China, visit <https://go.microsoft.com/fwlink/?LinkID=717821> instead). If you plan to later [register Azure Stack with Azure](asdk-register.md), you must also have a subscription in this newly created account.
   
    Save these credentials for use as the service admin. This account can configure and manage resource clouds, user accounts, tenant plans, quotas, and pricing. In the portal, they can create website clouds, VM private clouds, create plans, and manage user subscriptions.
1. Create at least one test user account in your Azure AD so that you can sign in to the ASDK as a tenant.
   
   | **Azure Active Directory account** | **Supported?** |
   | --- | --- |
   | Work or school account with valid global Azure subscription |Yes |
   | Microsoft Account with valid global Azure subscription |Yes |
   | Work or school account with valid China Azure subscription |Yes |
   | Work or school account with valid US Government Azure subscription |Yes |

After deployment, Azure AD global admin permission isn't required. However, some operations may require the global admin credential. Examples of such operations include a resource provider installer script or a new feature requiring a permission to be granted. You can either temporarily reinstate the account's global admin permissions or use a separate global admin account that's an owner of the *default provider subscription*.

## Network
### Switch
One available port on a switch for the ASDK  machine.  

The ASDK machine supports connecting to a switch access port or trunk port. No specialized features are required on the switch. If you're using a trunk port or if you need to configure a VLAN ID, you have to provide the VLAN ID as a deployment parameter.

### Subnet
Don't connect the ASDK machine to the following subnets:

* 192.168.200.0/24
* 192.168.100.0/27
* 192.168.101.0/26
* 192.168.102.0/24
* 192.168.103.0/25
* 192.168.104.0/25

These subnets are reserved for the internal networks within the ASDK environment.

### IPv4/IPv6
Only IPv4 is supported. You can't create IPv6 networks.

### DHCP
Make sure there's a DHCP server available on the network that the NIC connects to. If DHCP isn't available, you must prepare an additional static IPv4 network besides the one used by host. You must provide that IP address and gateway as a deployment parameter.

### Internet access
Azure Stack requires access to the internet, either directly or through a transparent proxy. Azure Stack doesn't support the configuration of a web proxy to enable internet access. Both the host IP and the new IP assigned to the AzS-BGPNAT01 (by DHCP or static IP) must be able to access the internet. Ports 80 and 443 are used under the graph.windows.net and login.microsoftonline.com domains.


## Next steps

- [Download the ASDK deployment package](asdk-download.md).
- To learn more about Storage Spaces Direct, see [Storage Spaces Direct overview](https://docs.microsoft.com/windows-server/storage/storage-spaces/storage-spaces-direct-overview).

