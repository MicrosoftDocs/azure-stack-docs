---
title: Azure Stack Hub 2002 release notes 
description: 2002 release notes for Azure Stack Hub integrated systems, including updates and bug fixes.
author: sethmanheim

ms.topic: article
ms.date: 02/04/2021
ms.author: sethm
ms.reviewer: sranthar
ms.lastreviewed: 09/09/2020
ROBOTS: NOINDEX

---

# Azure Stack Hub 2002 release notes

This article describes the contents of Azure Stack Hub update packages. The update includes improvements and fixes for the latest release of Azure Stack Hub.

> [!IMPORTANT]  
> This update package is only for Azure Stack Hub integrated systems. Do not apply this update package to the Azure Stack Development Kit (ASDK).

> [!IMPORTANT]  
> If your Azure Stack Hub instance is behind by more than two updates, it's considered out of compliance. You must [update to at least the minimum supported version to receive support](../azure-stack-servicing-policy.md#keep-your-system-under-support).

## Update planning

Before applying the update, make sure to review the following information:

- [Checklist of activities before and after applying the update](../release-notes-checklist.md)
- [Known issues](../known-issues.md)
- [Hotfixes](#hotfixes)
- [Security updates](../release-notes-security-updates.md)

For help with troubleshooting updates and the update process, see [Troubleshoot patch and update issues for Azure Stack Hub](../azure-stack-troubleshooting.md).

## Download the update

You can download the Azure Stack Hub update package using [the Azure Stack Hub update downloader tool](https://aka.ms/azurestackupdatedownload).

## 2002 build reference

The Azure Stack Hub 2002 update build number is **1.2002.0.35**.

> [!IMPORTANT]  
> With the Azure Stack Hub 2002 update, Microsoft is temporarily extending our [Azure Stack Hub support policy statements](../azure-stack-servicing-policy.md).  We are working with customers around the world who are responding to COVID-19 and who may be making important decisions about their Azure Stack Hub systems, how they are updated and managed, and as a result, ensuring their data center business operations continue to operate normally. In support of our customers, Microsoft is offering a temporary support policy change extension to include three previous update versions.  As a result, the newly released 2002 update and any one of the three previous update versions (e.g. 1910, 1908, and 1907) will be supported.

### Update type

The Azure Stack Hub 2002 update build type is **Full**.

The 2002 update package is larger in size compared to previous updates. The increased size results in longer download times. The update will remain in the **Preparing** state for a long time, and operators can expect this process to take longer than with previous updates. The 2002 update has had the following expected runtimes in our internal testing- 4 nodes: 15-42 hours, 8 nodes: 20-50 hours, 12 nodes: 20-60 hours, 16 nodes: 25-70 hours. Exact update runtimes typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware specifications. Runtimes that are shorter or longer than the expected value are not uncommon and do not require action by Azure Stack Hub operators unless the update fails. This runtime approximation is specific to the 2002 update and should not be compared to other Azure Stack Hub updates.

For more information about update build types, see [Manage updates in Azure Stack Hub](../azure-stack-updates.md).

<!-- ## What's in this update -->

<!-- The current theme (if any) of this release. -->

### What's new

<!-- What's new, also net new experiences and features. -->

- A new version (1.8.1) of the Azure Stack Hub admin PowerShell modules based on AzureRM is available.
- A new version of the Azure Stack Hub admin REST API is available. You can find details about endpoints and breaking changes in the [API Reference](/rest/api/azure-stack/).
- New Azure PowerShell tenant modules will be released for Azure Stack Hub on April 15, 2020. The currently used Azure RM modules will continue to work, but will no longer be updated after build 2002.
- Added new warning alert on the Azure Stack Hub administrator portal to report on connectivity issues with the configured syslog server. Alert title is **The Syslog client encountered a networking issue while sending a Syslog message**.
- Added new warning alert on the Azure Stack Hub administrator portal to report on connectivity issues with the Network Time Protocol (NTP) server. Alert title is **Invalid Time Source on [node name]**.
- The [Java SDK](https://azure.microsoft.com/develop/java/) released new packages due to a breaking change in 2002 related to TLS restrictions. You must install the new Java SDK dependency. You can find the instructions at [Java and API version profiles](../../user/azure-stack-version-profiles-java.md?view=azs-2002&preserve-view=true#java-and-api-version-profiles).
- A new version (1.0.5.10) of the System Center Operations Manager - Azure Stack Hub MP is available and required for all systems running 2002 due to breaking API changes. The API changes impact the backup and storage performance dashboards, and it is recommended that you first update all systems to 2002 before updating the MP.

### Improvements

<!-- Changes and product improvements with tangible customer-facing value. -->

- This update contains changes to the update process that significantly improve the performance of future full updates. These changes take effect with the next full update after the 2002 release, and specifically target improving the performance of the phase of a full update in which the host operating systems are updated. Improving the performance of host operating system updates significantly reduces the window of time in which tenant workloads are impacted during full updates.
- The Azure Stack Hub readiness checker tool now validates AD Graph integration using all TCP IP ports allocated to AD Graph.
- The offline syndication tool has been updated with reliability improvements. The tool is no longer available on GitHub, and has been [moved to the PowerShell Gallery](https://www.powershellgallery.com/packages/Azs.Syndication.Admin/). For more information, see [Download Marketplace items to Azure Stack Hub](../azure-stack-download-azure-marketplace-item.md).
- A new monitoring capability is being introduced. The low disk space alert for physical hosts and infrastructure VMs will be auto-remediated by the platform and only if this action fails will the alert be visible in the Azure Stack Hub administrator portal, for the operator to take action.
- Improvements to [diagnostic log collection](../diagnostic-log-collection.md?preserve-view=true&view=azs-2002). The new experience streamlines and simplifies diagnostic log collection by removing the need to configure a blob storage account in advance. The storage environment is preconfigured so that you can send logs before opening a support case, and spend less time on a support call.
- Time taken for both [Proactive Log Collection and the on-demand log collection](../diagnostic-log-collection.md?preserve-view=true&view=azs-2002) has been reduced by 80%. Log collection time can take longer than this expected value but doesn't require action by Azure Stack Hub operators unless the log collection fails.
- The download progress of an Azure Stack Hub update package is now visible in the update blade after an update is initiated. This only applies to connected Azure Stack Hub systems that choose to [prepare update packages via automatic download](../azure-stack-update-prepare-package.md#automatic-download-and-preparation-for-update-packages).
- Reliability improvements to the Network Controller Host agent.
- Introduced a new micro-service called DNS Orchestrator that improves the resiliency logic for the internal DNS services during patch and update.
- Added a new request validation to fail invalid blob URIs for the boot diagnostic storage account parameter while creating VMs.
- Added auto-remediation and logging improvements for Rdagent and Host agent - two services on the host that facilitate VM CRUD operations.
- Added a new feature to marketplace management that enables Microsoft to add attributes that block administrators from downloading marketplace products that are incompatible with their Azure Stack, due to various properties, such as the Azure Stack version or billing model. Only Microsoft can add these attributes. For more information, see [Use the portal to download marketplace items](../azure-stack-download-azure-marketplace-item.md#use-the-portal-to-download-marketplace-items).

### Changes

- The administrator portal now indicates if an operation is in progress, with an icon next to the Azure Stack region. When you hover over the icon, it displays the name of the operation. This enables you to identify running system background operations; for example, a backup job or a storage expansion which can run for several hours.

- The following administrator APIs have been deprecated:

  | Resource provider       | Resource              | Version            |
  |-------------------------|-----------------------|--------------------|
  | Microsoft.Storage.Admin | farms                 | 2015-12-01-preview |
  | Microsoft.Storage.Admin | farms/acquisitions    | 2015-12-01-preview |
  | Microsoft.Storage.Admin | farms/shares          | 2015-12-01-preview |
  | Microsoft.Storage.Admin | farms/storageaccounts | 2015-12-01-preview |

- The following administrator APIs have been replaced by a newer version (2018-09-01):

  | Resource provider      | Resource              | Version    |
  |------------------------|-----------------------|------------|
  | Microsoft.Backup.Admin | backupLocation         | 2016-05-01 |
  | Microsoft.Backup.Admin | backups                | 2016-05-01 |
  | Microsoft.Backup.Admin | operations             | 2016-05-01 |

- When creating a Windows VM using PowerShell, make sure to add the `provisionvmagent` flag if you want the VM to deploy extensions. Without this flag, the VM is created without the guest agent, removing the ability to deploy VM extensions:

   ```powershell
   $VirtualMachine = Set-AzureRmVMOperatingSystem `
     -VM $VirtualMachine `
     -Windows `
     -ComputerName "MainComputer" `
     -Credential $Credential -ProvisionVMAgent
  ```

### Fixes

<!-- Product fixes that came up from customer deployments worth highlighting, especially if there is an SR/ICM associated to it. -->

- Fixed an issue where adding more than one public IP on the same NIC on a Virtual Machine resulted in internet connectivity issues. Now, a NIC with two public IPs works as expected.
- Fixed an issue that caused the system to raise an alert indicating that the Azure AD home directory needs to be configured.
- Fixed an issue that caused an alert to not automatically close. The alert indicated that the Azure AD home directory must be configured, but did not close even after the issue was mitigated.
- Fixed an issue that caused updates to fail during the update preparation phase as a result of internal failures of the update resource provider.
- Fixed an issue causing add-on resource provider operations to fail after performing Azure Stack Hub secret rotation.
- Fixed an issue that was a common cause of Azure Stack Hub update failures due to memory pressure on the ERCS role.
- Fixed a bug in the update blade in which the update status showed as **Installing** instead of **Preparing** during the preparation phase of an Azure Stack Hub update.
- Fixed an issue where the RSC feature on the virtual switches was creating inconsistences and dropping the traffic flowing through a load balancer. The RSC feature is now disabled by default.
- Fixed an issue where multiple IP configurations on a NIC was causing traffic to be misrouted and prevented outbound connectivity. 
- Fixed an issue where the MAC address of a NIC was being cached, and assigning of that address to another resource was causing VM deployment failures.
- Fixed an issue where Windows VM images from the RETAIL channel could not have their license activated by AVMA.
- Fixed an issue where VMs would fail to be created if the number of virtual cores requested by the VM was equal to the node's physical cores. We now allow VMs to have virtual cores equal to or less than the node's physical cores.
- Fixed an issue where we do not allow the license type to be set to "null" to switch pay-as-you-go images to BYOL.
- Fixed an issue to allow extensions to be added to a VM scale set.

## Security updates

For information about security updates in this update of Azure Stack Hub, see [Azure Stack Hub security updates](../release-notes-security-updates.md).

## Hotfixes

Azure Stack Hub releases hotfixes on a regular basis. Be sure to install the latest Azure Stack Hub hotfix for 1910 before updating Azure Stack Hub to 2002.

> [!NOTE]
> Azure Stack Hub hotfix releases are cumulative; you only need to install the latest hotfix to get all fixes included in any previous hotfix releases for that version.

Azure Stack Hub hotfixes are only applicable to Azure Stack Hub integrated systems; do not attempt to install hotfixes on the ASDK.

For more information about hotfixes, see the [Azure Stack Hub servicing policy](../azure-stack-servicing-policy.md#hotfixes).

### Prerequisites: Before applying the 2002 update

The 2002 release of Azure Stack Hub must be applied on the 1910 release with the following hotfixes:

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack Hub hotfix 1.1910.84.230](https://support.microsoft.com/help/4592243)

### After successfully applying the 2002 update

After the installation of this update, install any applicable hotfixes.

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack Hub hotfix 1.2002.65.171](https://support.microsoft.com/topic/d743db84-df31-496b-b37c-6e5618b4cc8f)
