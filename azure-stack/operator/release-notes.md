---
title: Azure Stack Hub release notes
description: Release notes for Azure Stack Hub integrated systems, including updates and bug fixes.
author: sethmanheim
ms.topic: release-notes
ms.date: 09/22/2025
ms.author: sethm

# Intent: As an Azure Stack Hub operator, I want to know what's new in the latest release so that I can plan my update.
# Keyword: release notes what's new

---

# Azure Stack Hub release notes

This article describes the contents of Azure Stack Hub update packages. The update includes improvements and fixes for the latest release of Azure Stack Hub.

To access release notes for a different version, use the version selector dropdown above the table of contents on the left.

::: moniker range="azs-2311"
> [!IMPORTANT]  
> This update package requires an OEM package version of 2.3 or later. For more information, see the [OEM contact information](azure-stack-update-oem.md#oem-contact-information).

> [!IMPORTANT]
> The 2311 update introduces a change in the base host OS, updated to Windows Server 2022. Disconnected customers must obtain and update a SQL Server 2019 product key (PID). You must get the key before starting the update. To obtain this key, contact Microsoft support.
> If you start the update without this key, the update will fail shortly after starting, with a "Prepare of Role Cloud raised an exception" message, which advises you contact support. You can resume the update after applying the new key.
::: moniker-end
::: moniker range="<azs-2408"
> [!IMPORTANT]  
> If your Azure Stack Hub instance is behind by more than two updates, it's considered out of compliance. You must [update to at least the minimum supported version to receive support](azure-stack-servicing-policy.md#keep-your-system-under-support).
::: moniker-end

> [!IMPORTANT]
> The Microsoft Entra ID Graph API service is being retired. This retirement affects all Azure Stack Hub customers, and requires you to [run the script included in this article](graph-api-retirement.md) for all affected applications.

> [!IMPORTANT]  
> If your Azure Stack Hub instance does not have an active support contract with the hardware partner, it's considered out of compliance. You must [have an active support contract for the hardware to receive support](azure-stack-servicing-policy.md#keep-your-system-under-support).

## Update planning

Before applying the update, make sure to review the following information:

- [Checklist of activities before and after applying the update](release-notes-checklist.md)
- [Known issues](known-issues.md)
- [Hotfixes](#hotfixes)
- [Security updates](release-notes-security-updates.md)

For help with troubleshooting updates and the update process, see [Troubleshoot patch and update issues for Azure Stack Hub](azure-stack-troubleshooting.md).

## Download the update

You can download the Azure Stack Hub update package using [the Azure Stack Hub update downloader tool](https://aka.ms/azurestackupdatedownload).

<!---------------------------------------------------------->
<!------------------- SUPPORTED VERSIONS ------------------->
<!---------------------------------------------------------->
::: moniker range="azs-2506"
## 2506 build reference

The Azure Stack Hub 2506 update build number is **1.2506.0.15**.

### Update type

The Azure Stack Hub 2506 update build type is **Full**. This build contains only important security updates.

The 2506 update has the following expected runtimes based on our internal testing:

- 4 nodes: 8-28 hours
- 8 nodes: 11-30 hours
- 12 nodes: 14-34 hours
- 16 nodes: 17-40 hours

Exact update durations typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware specifications. Durations that are shorter or longer than the expected value are not uncommon and do not require action by Azure Stack Hub operators unless the update fails. This runtime approximation is specific to the 2506 update and should not be compared to other Azure Stack Hub updates.

For more information about update build types, see [Manage updates in Azure Stack Hub](azure-stack-updates.md).

### What's new

- The Microsoft Entra ID [Graph API service is being retired](https://techcommunity.microsoft.com/blog/microsoft-entra-blog/important-update-azure-ad-graph-api-retirement/4090534). For more information, see [Microsoft Entra ID Graph API retirement](graph-api-retirement.md).

<!-- ### Changes -->

<!-- ### Fixes  -->

## Security updates

For information about security updates in this update of Azure Stack Hub, see [Azure Stack Hub security updates](release-notes-security-updates.md).

## Hotfixes

Azure Stack Hub releases hotfixes regularly. Starting with the 2005 release, when you update to a new major version (for example, 1.2008.x to 1.2102.x), the latest hotfixes (if any) in the new major version are installed automatically. From that point forward, if a hotfix is released for your build, you should install it.

> [!NOTE]
> Azure Stack Hub hotfix releases are cumulative; you only need to install the latest hotfix to get all fixes included in any previous hotfix releases for that version.

For more information, see our [servicing policy](azure-stack-servicing-policy.md).

### Hotfix prerequisites: before applying the 2506 update

The 2506 release of Azure Stack Hub must be applied on the 2501 release with the following hotfix installed:

- [Azure Stack Hub hotfix 1.2501.1.47](hotfix-1-2501-1-47.md)

### After successfully applying the 2506 update

When you update to a new major version (for example, 1.2108.x to 1.2206.x), the latest hotfixes (if any) in the new major version are installed automatically. From that point forward, if a hotfix is released for your build, you should install it.

After the installation of 2506, if any hotfixes for 2506 are subsequently released, you should install them:

- [Azure Stack Hub hotfix 1.2506.2.24](hotfix-1-2506-2-24.md)
::: moniker-end

::: moniker range="azs-2501"
## 2501 build reference

The Azure Stack Hub 2501 update build number is **1.2501.0.21**.

### Update type

The Azure Stack Hub 2501 update build type is **Full**. This build contains only important security updates.

The 2501 update has the following expected runtimes based on our internal testing:

- 4 nodes: 8-28 hours
- 8 nodes: 11-30 hours
- 12 nodes: 14-34 hours
- 16 nodes: 17-40 hours

Exact update durations typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware specifications. Durations that are shorter or longer than the expected value are not uncommon and do not require action by Azure Stack Hub operators unless the update fails. This runtime approximation is specific to the 2501 update and should not be compared to other Azure Stack Hub updates.

For more information about update build types, see [Manage updates in Azure Stack Hub](azure-stack-updates.md).

### What's new

- The Microsoft Entra ID [Graph API service is being retired](https://techcommunity.microsoft.com/blog/microsoft-entra-blog/important-update-azure-ad-graph-api-retirement/4090534). For more information, see [Microsoft Entra ID Graph API retirement](graph-api-retirement.md).

<!-- ### Changes -->

### Fixes

- Fixed an issue in which the [**Deployments** blade under a subscription failed to load](known-issues.md?view=azs-2408&preserve-view=true#deployments-blade-under-subscription-fails-to-load).

## Security updates

For information about security updates in this update of Azure Stack Hub, see [Azure Stack Hub security updates](release-notes-security-updates.md).

## Hotfixes

Azure Stack Hub releases hotfixes regularly. Starting with the 2005 release, when you update to a new major version (for example, 1.2008.x to 1.2102.x), the latest hotfixes (if any) in the new major version are installed automatically. From that point forward, if a hotfix is released for your build, you should install it.

> [!NOTE]
> Azure Stack Hub hotfix releases are cumulative; you only need to install the latest hotfix to get all fixes included in any previous hotfix releases for that version.

For more information, see our [servicing policy](azure-stack-servicing-policy.md).

### Hotfix prerequisites: before applying the 2501 update

The 2501 release of Azure Stack Hub must be applied on the 2408 release with the following hotfix installed:

- [Azure Stack Hub hotfix 1.2408.1.50](hotfix-1-2408-1-50.md)

### After successfully applying the 2501 update

When you update to a new major version (for example, 1.2108.x to 1.2206.x), the latest hotfixes (if any) in the new major version are installed automatically. From that point forward, if a hotfix is released for your build, you should install it.

After the installation of 2501, if any hotfixes for 2501 are subsequently released, you should install them:

- [Azure Stack Hub hotfix 1.2501.1.47](hotfix-1-2501-1-47.md)
::: moniker-end

::: moniker range="azs-2408"
## 2408 build reference

The Azure Stack Hub 2408 update build number is **1.2408.0.19**.

### Update type

The Azure Stack Hub 2408 update build type is **Full**. This build contains only important security updates.

The 2408 update has the following expected runtimes based on our internal testing:

- 4 nodes: 8-28 hours
- 8 nodes: 11-30 hours
- 12 nodes: 14-34 hours
- 16 nodes: 17-40 hours

Exact update durations typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware specifications. Durations that are shorter or longer than the expected value are not uncommon and do not require action by Azure Stack Hub operators unless the update fails. This runtime approximation is specific to the 2408 update and should not be compared to other Azure Stack Hub updates.

For more information about update build types, see [Manage updates in Azure Stack Hub](azure-stack-updates.md).

### What's new

- With the 2408 update, we are introducing the ESv3 and DSv3 VM SKUs. These new SKUs are designed to provide higher IOPS for both OS and data disks. For more information, see [Azure Stack Hub VM SKUs](../user/azure-stack-vm-sizes.md).
- We are also introducing [two new VM SKUs to support the L40s GPUs](../user/gpu-vms-about.md#nc_l40s-v4).

<!-- ### Changes -->

<!-- ### Fixes -->

## Security updates

For information about security updates in this update of Azure Stack Hub, see [Azure Stack Hub security updates](release-notes-security-updates.md).

## Hotfixes

Azure Stack Hub releases hotfixes regularly. Starting with the 2005 release, when you update to a new major version (for example, 1.2008.x to 1.2102.x), the latest hotfixes (if any) in the new major version are installed automatically. From that point forward, if a hotfix is released for your build, you should install it.

> [!NOTE]
> Azure Stack Hub hotfix releases are cumulative; you only need to install the latest hotfix to get all fixes included in any previous hotfix releases for that version.

For more information, see our [servicing policy](azure-stack-servicing-policy.md).

### Hotfix prerequisites: before applying the 2408 update

The 2408 release of Azure Stack Hub must be applied on the 2406 release with the following hotfix installed:

- [Azure Stack Hub hotfix 1.2406.1.23](hotfix-1-2406-1-23.md)

### After successfully applying the 2408 update

When you update to a new major version (for example, 1.2108.x to 1.2206.x), the latest hotfixes (if any) in the new major version are installed automatically. From that point forward, if a hotfix is released for your build, you should install it.

After the installation of 2408, if any hotfixes for 2408 are subsequently released, you should install them:

- [Azure Stack Hub hotfix 1.2408.1.50](hotfix-1-2408-1-50.md)
::: moniker-end

<!------------------------------------------------------------>
<!------------------- UNSUPPORTED VERSIONS ------------------->
<!------------------------------------------------------------>
::: moniker range="azs-2406"
## 2406 archived release notes
::: moniker-end
::: moniker range="azs-2311"
## 2311 archived release notes
::: moniker-end
::: moniker range="azs-2306"
## 2306 archived release notes
::: moniker-end
::: moniker range="azs-2301"
## 2301 archived release notes
::: moniker-end
::: moniker range="azs-2206"
## 2206 archived release notes
::: moniker-end
::: moniker range="azs-2108"
## 2108 archived release notes
::: moniker-end
::: moniker range="azs-2102"
## 2102 archived release notes
::: moniker-end
::: moniker range="azs-2008"
## 2008 archived release notes
::: moniker-end
::: moniker range="azs-2005"
## 2005 archived release notes
::: moniker-end
::: moniker range="azs-2002"
## 2002 archived release notes
::: moniker-end
::: moniker range="azs-1910"
## 1910 archived release notes
::: moniker-end
::: moniker range="azs-1908"
## 1908 archived release notes
::: moniker-end
::: moniker range="azs-1907"
## 1907 archived release notes
::: moniker-end
::: moniker range="azs-1906"
## 1906 archived release notes
::: moniker-end
::: moniker range="azs-1905"
## 1905 archived release notes
::: moniker-end
::: moniker range="azs-1904"
## 1904 archived release notes
::: moniker-end
::: moniker range="azs-1903"
## 1903 archived release notes
::: moniker-end
::: moniker range="azs-1902"
## 1902 archived release notes
::: moniker-end
::: moniker range="azs-1901"
## 1901 archived release notes
::: moniker-end
::: moniker range="azs-1811"
## 1811 archived release notes
::: moniker-end
::: moniker range="azs-1809"
## 1809 archived release notes
::: moniker-end
::: moniker range="azs-1808"
## 1808 archived release notes
::: moniker-end
::: moniker range="azs-1807"
## 1807 archived release notes
::: moniker-end
::: moniker range="azs-1805"
## 1805 archived release notes
::: moniker-end
::: moniker range="azs-1804"
## 1804 archived release notes
::: moniker-end
::: moniker range="azs-1803"
## 1803 archived release notes
::: moniker-end
::: moniker range="azs-1802"
## 1802 archived release notes
::: moniker-end

::: moniker range="<azs-2408"
You can access older versions of Azure Stack Hub release notes in the table of contents on the left side, under [Resources > Release notes archive](./relnotearchive/release-notes.md). Select the desired archived version from the version selector dropdown in the upper left. These archived articles are provided for reference purposes only and do not imply support for these versions. For information about Azure Stack Hub support, see [Azure Stack Hub servicing policy](azure-stack-servicing-policy.md). For further assistance, contact Microsoft Customer Support Services.
::: moniker-end
