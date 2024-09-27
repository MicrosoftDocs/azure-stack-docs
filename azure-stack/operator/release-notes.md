---
title: Azure Stack Hub release notes
description: Release notes for Azure Stack Hub integrated systems, including updates and bug fixes.
author: sethmanheim
ms.topic: article
ms.date: 09/24/2024
ms.author: sethm
ms.reviewer: rtiberiu
ms.lastreviewed: 04/22/2024

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
> [!IMPORTANT]  
> This update package is only for Azure Stack Hub integrated systems. Do not apply this update package to the Azure Stack Development Kit (ASDK).
::: moniker range="<azs-2311"
> [!IMPORTANT]  
> If your Azure Stack Hub instance is behind by more than two updates, it's considered out of compliance. You must [update to at least the minimum supported version to receive support](azure-stack-servicing-policy.md#keep-your-system-under-support).
::: moniker-end

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
::: moniker range="azs-2406"
## 2406 build reference

The Azure Stack Hub 2406 update build number is **1.2406.0.8**.

### Update type

The Azure Stack Hub 2406 update build type is **Full**. This build contains only important security updates.

The 2406 update has the following expected runtimes based on our internal testing:

- 4 nodes: 8-28 hours
- 8 nodes: 11-30 hours
- 12 nodes: 14-34 hours
- 16 nodes: 17-40 hours

Exact update durations typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware specifications. Durations that are shorter or longer than the expected value are not uncommon and do not require action by Azure Stack Hub operators unless the update fails. This runtime approximation is specific to the 2406 update and should not be compared to other Azure Stack Hub updates.

For more information about update build types, see [Manage updates in Azure Stack Hub](azure-stack-updates.md).

### What's new

- With 2406 we are announcing the general availability of the [Azure Stack Hub Standard Load Balancer](../user/standard-load-balancer-considerations.md). The Standard Load Balancer enables several new load balancing scenarios such as: standalone VMs in backend pools, HTTPs probes, high-availability ports, and TCP Reset on idle.
- With 2406 we are announcing the general availability of [Azure Container Registry](container-registries-overview.md). Azure Container Registry is a private, secure, and close-to-compute registry for Windows container images, Linux container images, Helm charts, and other OCI artifacts. At no extra cost, it enables both connected and disconnected customers to quickly and reliably store, deploy, and manage container workloads through the user portal, PowerShell, Azure CLI, and/or Docker CLI. It also enables those customers to assign role-based access control (RBAC) and to create webhooks. Container Registry is now fully supported and fully integrated with other components of Azure Stack Hub, such as the Azure Kubernetes Service (AKS) engine. To install Container Registry, [follow the instructions here](container-registries-install.md).
- With 2406 we are announcing the general availability of [Azure Site Recovery](azure-site-recovery-overview.md). Azure Site Recovery on Azure Stack Hub helps to ensure business continuity by replicating virtual machine (VM) workloads from a primary site to a secondary location. The GA version has a simplified deployment (no dependency services). Note that the transition from preview versions to GA requires a full reinstallation of the Azure Site Recovery solution (no upgrade path is be possible).

<!-- ### Improvements -->

### Changes

- Starting with Azure Stack Hub 2311, we are not releasing updated Azure Stack Development Kit (ASDK) versions. This decision is due to modifications to internal services that would lead to substantial complexity for the ASDK. The [currently released ASDK version](../asdk/asdk-release-notes.md) remains suitable for operational, testing, or training purposes, including for the [Azure Stack Hub Foundation Core scripts](https://aka.ms/azshasdk) used for [Azure-Stack-Hub-Foundation-Core](https://github.com/Azure-Samples/Azure-Stack-Hub-Foundation-Core/tree/master/ASF-Training).

<!-- ### Fixes -->

## Security updates

For information about security updates in this update of Azure Stack Hub, see [Azure Stack Hub security updates](release-notes-security-updates.md).

## Hotfixes

Azure Stack Hub releases hotfixes regularly. Starting with the 2005 release, when you update to a new major version (for example, 1.2008.x to 1.2102.x), the latest hotfixes (if any) in the new major version are installed automatically. From that point forward, if a hotfix is released for your build, you should install it.

> [!NOTE]
> Azure Stack Hub hotfix releases are cumulative; you only need to install the latest hotfix to get all fixes included in any previous hotfix releases for that version.

For more information, see our [servicing policy](azure-stack-servicing-policy.md).

Azure Stack Hub hotfixes are only applicable to Azure Stack Hub integrated systems; do not attempt to install hotfixes on the ASDK.

### Hotfix prerequisites: before applying the 2406 update

The 2406 release of Azure Stack Hub must be applied on the 2311 release with the following hotfix installed:

- [Azure Stack Hub hotfix 1.2311.3.62](hotfix-1-2311-3-62.md)

### After successfully applying the 2406 update

When you update to a new major version (for example, 1.2108.x to 1.2206.x), the latest hotfixes (if any) in the new major version are installed automatically. From that point forward, if a hotfix is released for your build, you should install it.

After the installation of 2406, if any hotfixes for 2406 are subsequently released, you should install them:

- [Azure Stack Hub hotfix 1.2406.1.15](hotfix-1-2406-1-15.md)
::: moniker-end

::: moniker range="azs-2311"
## 2311 build reference

The Azure Stack Hub 2311 update build number is **1.2311.1.22**.

### Update type

The Azure Stack Hub 2311 update build type is **Full**. This build contains only important security updates.

The 2311 update has the following expected runtimes based on our internal testing:

- 4 nodes: 36-50 hours
- 8 nodes: 36-50 hours
- 12 nodes: 50-80 hours
- 16 nodes: 50-90 hours

> [!IMPORTANT]
> Disconnected environments have additional prerequisite steps, which might increase this duration. See the following section for required steps to obtain and update a SQL Server 2019 product key (PID).

Exact update durations typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware specifications. Durations that are shorter or longer than the expected value are not uncommon and do not require action by Azure Stack Hub operators unless the update fails. This runtime approximation is specific to the 2311 update and should not be compared to other Azure Stack Hub updates.

For more information about update build types, see [Manage updates in Azure Stack Hub](azure-stack-updates.md).

### What's new

- The [VPN Fast Path for operators](azure-stack-vpn-fast-path-operators.md) feature, [and for users](../user/azure-stack-vpn-fast-path-user.md), is now generally available. The new VPN SKUs enable scenarios in which higher network throughput is necessary. See the documentation for more information about this feature.
- With 2311 we are announcing the public preview of the [Azure Stack Hub Standard Load Balancer](../user/standard-load-balancer-considerations.md). This feature enables several scenarios: allowing standalone VMs to be in a backend pool, HTTPS probes, high-availability ports, and TCP reset on idle.
- Azure Site Recovery is currently in [public preview](azure-site-recovery-overview.md), which features a simplified deployment process that only requires one dependency. We aim to further streamline this solution by the time of our general availability launch in early 2024, at which point we plan to eliminate all dependencies except for the Site Recovery resource provider itself. In the meantime, we encourage you to test and provide feedback on the public preview to help us enhance the GA version. Be aware that the transition from preview to GA will require a full reinstallation of the Azure Site Recovery solution (no update or upgrade path will be possible).

<!-- ### Improvements -->

### Changes

- 2311 introduces a change in the base host OS, updated to Windows Server 2022, in order to simplify future updates and security fixes. This change is part of the fabric. Azure Stack Hub environments that have outbound connectivity do not require any additional changes, and the update is installed directly.

  > [!IMPORTANT]
  > Disconnected customers must obtain and update a SQL Server 2019 product key (PID). You must get the key before starting the update. To obtain this key, contact Microsoft support.
  > If you start the update without this key, the update will fail shortly after starting, with a "Preparation of Role Cloud raised an exception" message, which advises you contact support. You can resume the update after applying the new key.
  
- Starting with Azure Stack Hub 2311, we are not releasing new Azure Stack Development Kit (ASDK) versions. This decision is due to modifications to internal services that would lead to substantial complexity for the ASDK. The [currently released ASDK version](../asdk/asdk-release-notes.md) remains suitable for operational, testing, or training purposes, including for the [Azure Stack Hub Foundation Core scripts](https://aka.ms/azshasdk) used for [Azure-Stack-Hub-Foundation-Core](https://github.com/Azure-Samples/Azure-Stack-Hub-Foundation-Core/tree/master/ASF-Training).

<!-- ### Fixes -->

## Security updates

For information about security updates in this update of Azure Stack Hub, see [Azure Stack Hub security updates](release-notes-security-updates.md).

## Hotfixes

Azure Stack Hub releases hotfixes regularly. Starting with the 2005 release, when you update to a new major version (for example, 1.2008.x to 1.2102.x), the latest hotfixes (if any) in the new major version are installed automatically. From that point forward, if a hotfix is released for your build, you should install it.

> [!NOTE]
> Azure Stack Hub hotfix releases are cumulative; you only need to install the latest hotfix to get all fixes included in any previous hotfix releases for that version.

For more information, see our [servicing policy](azure-stack-servicing-policy.md).

Azure Stack Hub hotfixes are only applicable to Azure Stack Hub integrated systems; do not attempt to install hotfixes on the ASDK.

### Hotfix prerequisites: before applying the 2311 update

The 2311 release of Azure Stack Hub must be applied on the 2306 release with the following hotfix installed:

- [Azure Stack Hub hotfix 1.2306.4.102](hotfix-1-2306-4-102.md)

### After successfully applying the 2311 update

When you update to a new major version (for example, 1.2108.x to 1.2206.x), the latest hotfixes (if any) in the new major version are installed automatically. From that point forward, if a hotfix is released for your build, you should install it.

After the installation of 2311, if any hotfixes for 2311 are subsequently released, you should install them:

- [Azure Stack Hub hotfix 1.2311.3.62](hotfix-1-2311-3-62.md)
::: moniker-end

::: moniker range="azs-2306"
## 2306 build reference

The Azure Stack Hub 2306 update build number is **1.2306.2.47**.

### Update type

The Azure Stack Hub 2306 update build type is **Full**. This build contains only important security updates.

The 2306 update has the following expected runtimes based on our internal testing:

- 4 nodes: 8-28 hours
- 8 nodes: 11-30 hours
- 12 nodes: 14-34 hours
- 16 nodes: 17-40 hours

Exact update durations typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware specifications. Durations that are shorter or longer than the expected value are not uncommon and do not require action by Azure Stack Hub operators unless the update fails. This runtime approximation is specific to the 2306 update and should not be compared to other Azure Stack Hub updates.

For more information about update build types, see [Manage updates in Azure Stack Hub](azure-stack-updates.md).

### What's new

- This build contains important [security updates](#security-updates). There are no other major feature additions.

<!-- ### Improvements -->

### Changes

- The Azure Stack Hub 2306 release is the last major update that can be installed on integrated systems that are based on Intel's Broadwell CPU platform. The 2311 (and later) releases are based on a Windows Server 2022 code base which is [not supported on the Broadwell platform by Intel](https://www.intel.com/content/www/us/en/support/articles/000022396/processors.html). For any CPU processor family or hardware-related questions, contact your [hardware OEM partner](azure-stack-update-oem.md#oem-contact-information).
- This build contains these important [security updates](#security-updates).

<!-- ### Fixes -->

## Security updates

For information about security updates in this update of Azure Stack Hub, see [Azure Stack Hub security updates](release-notes-security-updates.md).

## Hotfixes

Azure Stack Hub releases hotfixes regularly. Starting with the 2005 release, when you update to a new major version (for example, 1.2008.x to 1.2102.x), the latest hotfixes (if any) in the new major version are installed automatically. From that point forward, if a hotfix is released for your build, you should install it.

> [!NOTE]
> Azure Stack Hub hotfix releases are cumulative; you only need to install the latest hotfix to get all fixes included in any previous hotfix releases for that version.

For more information, see our [servicing policy](azure-stack-servicing-policy.md).

Azure Stack Hub hotfixes are only applicable to Azure Stack Hub integrated systems; do not attempt to install hotfixes on the ASDK.

### Hotfix prerequisites: before applying the 2306 update

The 2306 release of Azure Stack Hub must be applied on the 2301 release with the following hotfix installed:

- [Azure Stack Hub hotfix 1.2301.3.97](hotfix-1-2301-3-97.md)

### After successfully applying the 2306 update

When you update to a new major version (for example, 1.2108.x to 1.2206.x), the latest hotfixes (if any) in the new major version are installed automatically. From that point forward, if a hotfix is released for your build, you should install it.

After the installation of 2306, if any hotfixes for 2306 are subsequently released, you should install them:

- [Azure Stack Hub hotfix 1.2306.4.102](hotfix-1-2306-4-102.md)
::: moniker-end

<!------------------------------------------------------------>
<!------------------- UNSUPPORTED VERSIONS ------------------->
<!------------------------------------------------------------>
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

::: moniker range="<azs-2306"
You can access older versions of Azure Stack Hub release notes in the table of contents on the left side, under [Resources > Release notes archive](./relnotearchive/release-notes.md). Select the desired archived version from the version selector dropdown in the upper left. These archived articles are provided for reference purposes only and do not imply support for these versions. For information about Azure Stack Hub support, see [Azure Stack Hub servicing policy](azure-stack-servicing-policy.md). For further assistance, contact Microsoft Customer Support Services.
::: moniker-end
