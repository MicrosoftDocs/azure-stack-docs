---
title: Azure Stack Hub release notes
description: Release notes for Azure Stack Hub integrated systems, including updates and bug fixes.
author: sethmanheim
ms.topic: article
ms.date: 12/01/2022
ms.author: sethm
ms.reviewer: thoroet
ms.lastreviewed: 09/09/2020

# Intent: As an Azure Stack Hub operator, I want to know what's new in the latest release so that I can plan my update.
# Keyword: release notes what's new

---

# Azure Stack Hub release notes

This article describes the contents of Azure Stack Hub update packages. The update includes improvements and fixes for the latest release of Azure Stack Hub.

To access release notes for a different version, use the version selector dropdown above the table of contents on the left.

::: moniker range=">=azs-2108"
> [!IMPORTANT]  
> This update package is only for Azure Stack Hub integrated systems. Do not apply this update package to the Azure Stack Development Kit (ASDK).
::: moniker-end
::: moniker range="<azs-2108"
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
::: moniker range="azs-2210"
## 2210 build reference

The Azure Stack Hub 2210 update build number is **1.2210.x.xx**.

### Update type

The Azure Stack Hub 2210 update build type is **Full**.

The 2210 update has the following expected runtimes based on our internal testing:

- 4 nodes: 8-28 hours
- 8 nodes: 11-30 hours
- 12 nodes: 14-34 hours
- 16 nodes: 17-40 hours

Exact update durations typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware specifications. Durations that are shorter or longer than the expected value are not uncommon and do not require action by Azure Stack Hub operators unless the update fails. This runtime approximation is specific to the 2210 update and should not be compared to other Azure Stack Hub updates.

For more information about update build types, see [Manage updates in Azure Stack Hub](azure-stack-updates.md).

### What's new

- Starting with Azure Stack Hub 2210, [Emergency VM Access (EVA)](../user/emergency-vm-access.md) is released to general availability.
- Public preview release of the [VPN FastPath](azure-stack-vpn-fast-path-operators.md) with new VPN Gateway SKUs.
- New [VPN FastPath documentation for ASH operators](azure-stack-vpn-fast-path-operators.md) and [ASH users](../user/azure-stack-vpn-fast-path-user.md).
- Added new VM size **Standard_E20_v3** to support larger database workloads that require more than 112 GB of memory.
- Added support for NVIDIA A100 Tensor GPU. Validate with your OEM if your hardware can support the GPU requirements.
- Added new VM series for A100. For more details, see [GPUs on Azure Stack Hub](../user/gpu-vms-about.md#nc-a100-v4).

<!-- ### Improvements -->

### Changes

- New content here.

### Fixes

- New content here.

## Security updates

For information about security updates in this update of Azure Stack Hub, see [Azure Stack Hub security updates](release-notes-security-updates.md).

## Hotfixes

Azure Stack Hub releases hotfixes regularly. Starting with the 2005 release, when you update to a new major version (for example, 1.2008.x to 1.2102.x), the latest hotfixes (if any) in the new major version are installed automatically. From that point forward, if a hotfix is released for your build, you should install it.

> [!NOTE]
> Azure Stack Hub hotfix releases are cumulative; you only need to install the latest hotfix to get all fixes included in any previous hotfix releases for that version.

For more information, see our [servicing policy](azure-stack-servicing-policy.md).

Azure Stack Hub hotfixes are only applicable to Azure Stack Hub integrated systems; do not attempt to install hotfixes on the ASDK.

### Hotfix prerequisites: before applying the 2210 update

The 2210 release of Azure Stack Hub must be applied on the 2206 release with the following hotfixes:

- [Azure Stack Hub hotfix 1.2206.2.38](hotfix-1-2206-2-38.md)

### After successfully applying the 2210 update

When you update to a new major version (for example, 1.2108.x to 1.2206.x), the latest hotfixes (if any) in the new major version are installed automatically. From that point forward, if a hotfix is released for your build, you should install it.

After the installation of 2210, if any hotfixes for 2210 are subsequently released, you should install them:

- No Azure Stack Hub hotfix for 2210.
::: moniker-end

::: moniker range="azs-2206"
## 2206 build reference

The Azure Stack Hub 2206 update build number is **1.2206.1.24**.

### Update type

The Azure Stack Hub 2206 update build type is **Full**.

The 2206 update has the following expected runtimes based on our internal testing:

- 4 nodes: 8-28 hours
- 8 nodes: 11-30 hours
- 12 nodes: 14-34 hours
- 16 nodes: 17-40 hours

Exact update durations typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware specifications. Durations that are shorter or longer than the expected value are not uncommon and do not require action by Azure Stack Hub operators unless the update fails. This runtime approximation is specific to the 2206 update and should not be compared to other Azure Stack Hub updates.

For more information about update build types, see [Manage updates in Azure Stack Hub](azure-stack-updates.md).

### What's new

- European Union-based customers can now choose to have all their data stored and processed inside the European Union boundary. For more information, see [EU Schrems II initiative for Azure Stack Hub](azure-stack-security-foundations.md#eu-schrems-ii-initiative-for-azure-stack-hub).
- Azure Stack Hub now supports retrieving BitLocker keys for data encryption at rest. For more information, see [Retrieving BitLocker recovery keys](azure-stack-security-bitlocker.md#retrieving-bitlocker-recovery-keys).

<!-- ### Improvements -->

### Changes

- SQL RP V2 and MySQL RP V2 are only available to subscriptions that have been granted access. If you are still using SQL RP V1 and MySQL RP V1, it is strongly recommended that you [open a support case](azure-stack-help-and-support-overview.md) to go through the upgrade process before you upgrading to ASH 2206.
- This release provides support for Azure Stack Hub root certificate rotation. Previously, secret rotation did not rotate the root. You will be able to rotate the root certificate after installing the update. To do so, [perform internal secret rotation](azure-stack-rotate-secrets.md#rotate-internal-secrets) on or before the next time you are notified via expiration alerts. Failure to rotate the root certificate and/or perform internal secret rotation might result in your stamp becoming unrecoverable.

### Fixes

- Fix to improve SLB throughput.
- Fixed an issue that prevented access to the storage subsystem when scale unit nodes are rebooted.

## Security updates

For information about security updates in this update of Azure Stack Hub, see [Azure Stack Hub security updates](release-notes-security-updates.md).

## Hotfixes

Azure Stack Hub releases hotfixes regularly. Starting with the 2005 release, when you update to a new major version (for example, 1.2008.x to 1.2102.x), the latest hotfixes (if any) in the new major version are installed automatically. From that point forward, if a hotfix is released for your build, you should install it.

> [!NOTE]
> Azure Stack Hub hotfix releases are cumulative; you only need to install the latest hotfix to get all fixes included in any previous hotfix releases for that version.

For more information, see our [servicing policy](azure-stack-servicing-policy.md).

Azure Stack Hub hotfixes are only applicable to Azure Stack Hub integrated systems; do not attempt to install hotfixes on the ASDK.

### Hotfix prerequisites: before applying the 2206 update

The 2206 release of Azure Stack Hub must be applied on the 2108 release with the following hotfixes:

- [Azure Stack Hub hotfix 1.2108.2.127](hotfix-1-2108-2-127.md)

### After successfully applying the 2206 update

When you update to a new major version (for example, 1.2102.x to 1.2108.x), the latest hotfixes (if any) in the new major version are installed automatically. From that point forward, if a hotfix is released for your build, you should install it.

After the installation of 2206, if any hotfixes for 2206 are subsequently released, you should install them:

- [Azure Stack Hub hotfix 1.2206.2.52](hotfix-1-2206-2-52.md)
::: moniker-end

::: moniker range="azs-2108"
## 2108 build reference

The latest Azure Stack Hub 2108 update build number is **1.2108.2.65**. For updated build and hotfix information, see the [Hotfixes](#hotfixes) section.

### Update type

The Azure Stack Hub 2108 update build type is **Full**.

The 2108 update has the following expected runtimes based on our internal testing:

- 4 nodes: 8-28 hours
- 8 nodes: 11-30 hours
- 12 nodes: 14-34 hours
- 16 nodes: 17-40 hours

Exact update durations typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware specifications. Durations that are shorter or longer than the expected value are not uncommon and do not require action by Azure Stack Hub operators unless the update fails. This runtime approximation is specific to the 2108 update and should not be compared to other Azure Stack Hub updates.

For more information about update build types, see [Manage updates in Azure Stack Hub](azure-stack-updates.md).

### What's new

- Azure Stack Hub operators can now configure GPU quotas for VMs.
- [Emergency VM Access](../user/emergency-vm-access.md) is now available in Azure Stack Hub without contacting Microsoft Support.
- Windows Server 2022 is now supported as a guest operating system. Windows Server 2022 VMs must be manually activated using [Automatic Virtual Machine Activation](/windows-server/get-started/automatic-vm-activation) in Windows Server on Azure Stack Hub running version 2108 or later. It cannot be activated on previous versions.
- Starting with this version, if proactive log collection is disabled, logs are captured and stored locally for proactive failure events. The local logs can only be accessed by Microsoft in the context of a support case. New alerts have been added to the proactive log collection **Alert** library.
- Two new services, [Azure Kubernetes Service](../user/aks-overview.md) and [Azure Container Registry](../user/container-registry-overview.md), are available in public preview with this release.
- [**AzureStack** module 2.2.0](/powershell/azure/azure-stack/overview?view=azurestackps-2.2.0&preserve-view=true) is released to align with Azure Stack Hub version 2108. The version update includes changes in compute administrator module and new modules `Azs.ContainerRegistry.Admin` and `Azs.ContainerService.Admin`. For more information, see the [change log](https://github.com/Azure/azurestack-powershell/blob/release-2108/src/changelog.md).
- With this release, telemetry data is uploaded to an Azure Storage account that's managed and controlled by Microsoft. Azure Stack Hub telemetry service connects to `https://*.blob.core.windows.net/` and `https://azsdiagprdwestusfrontend.westus.cloudapp.azure.com/` for a successful telemetry data upload to Microsoft. Port 443 (HTTPS) must be opened. For more information, see [Azure Stack Hub telemetry](azure-stack-telemetry.md).
- This release includes a public preview of remote support, which enables a Microsoft support professional to solve your support case faster by permitting access to your device remotely and performing limited troubleshooting and repair. You can enable this feature by granting consent, while controlling the access level and duration of access. Support can only access your device after a support request has been submitted. For more information, see [Remote support for Azure Stack Hub](remote-support.md).

### Improvements

- When the external SMB share is almost full, the alert description has been adjusted to align with progressive backup.
- To prevent upload failures, the number of parallel infrastructure backup repository uploads to the external SMB share is now limited.
- Replaced **Node-Inaccessible-for-vm-placement** alert with alerts to distinguish between **host-unresponsive** scenarios and **hostagent-service-on-node-unresponsive** scenarios.
- App Service now has the ability to discover the default NAT IP for outbound connections.

### Changes

- Before starting the 2108 update, you must stop (deallocate) all virtual machines that use a GPU, to ensure the update can complete successfully. This applies to AMD and NVIDIA GPUs, as the underlying implementation changes to no pooled resources.
- SQL RP and MySQL RP are only available to subscriptions that have been granted access. If you want to start using these resource providers, or need to upgrade from a previous version, [open a support case](azure-stack-help-and-support-overview.md), and Microsoft support engineers can help you with the deployment or upgrade process.
- **Set-AzSLegalNotice** now triggers the appearance of a new screen that contains the caption and the text that were set when running the command. This screen appears every time a new instance of the portal is created.

### Fixes

- Fixed an issue in which one repository failure when uploading to the external SMB share caused the entire infrastructure backup to fail.
- Fixed an issue that caused N series VMs with multiple GPUs to fail creation.
- Fixed an issue in which uninstalling a VM extension nulls out protected settings for existing VM extensions.
- Fixed an issue that caused internal load balancers to use external IPs.
- Fixed an issue downloading serial logs from the portal.

## Security updates

For information about security updates in this update of Azure Stack Hub, see [Azure Stack Hub security updates](release-notes-security-updates.md).

## Hotfixes

Azure Stack Hub releases hotfixes regularly. Starting with the 2005 release, when you update to a new major version (for example, 1.2005.x to 1.2008.x), the latest hotfixes (if any) in the new major version are installed automatically. From that point forward, if a hotfix is released for your build, you should install it.

> [!NOTE]
> Azure Stack Hub hotfix releases are cumulative; you only need to install the latest hotfix to get all fixes included in any previous hotfix releases for that version.

For more information about hotfixes, see our [servicing policy](azure-stack-servicing-policy.md).

Azure Stack Hub hotfixes are only applicable to Azure Stack Hub integrated systems; do not attempt to install hotfixes on the ASDK.

### Hotfix prerequisites: before applying the 2108 update

The 2108 release of Azure Stack Hub must be applied on the 2102 release with the following hotfixes:

- [Azure Stack Hub hotfix 1.2102.31.152](hotfix-1-2102-31-152.md)

### After successfully applying the 2108 update

When you update to a new major version (for example, 1.2102.x to 1.2108.x), the latest hotfixes (if any) in the new major version are installed automatically. From that point forward, if a hotfix is released for your build, you should install it.

After the installation of 2108, if any hotfixes for 2108 are subsequently released, you should install them:

- [Azure Stack Hub hotfix 1.2108.2.127](hotfix-1-2108-2-127.md)
::: moniker-end

<!------------------------------------------------------------>
<!------------------- UNSUPPORTED VERSIONS ------------------->
<!------------------------------------------------------------>
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

::: moniker range="<azs-2108"
You can access older versions of Azure Stack Hub release notes in the table of contents on the left side, under [Resources > Release notes archive](./relnotearchive/release-notes.md). Select the desired archived version from the version selector dropdown in the upper left. These archived articles are provided for reference purposes only and do not imply support for these versions. For information about Azure Stack Hub support, see [Azure Stack Hub servicing policy](azure-stack-servicing-policy.md). For further assistance, contact Microsoft Customer Support Services.
::: moniker-end
