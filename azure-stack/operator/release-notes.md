---
title: Azure Stack Hub release notes 
description: Release notes for Azure Stack Hub integrated systems, including updates and bug fixes.
author: sethmanheim

ms.topic: article
ms.date: 09/17/2020
ms.author: sethm
ms.reviewer: sranthar
ms.lastreviewed: 08/11/2020

# Intent: Notdone: As a < type of user >, I want < what? > so that < why? >
# Keyword: Notdone: keyword noun phrase

---

# Azure Stack Hub release notes

This article describes the contents of Azure Stack Hub update packages. The update includes improvements and fixes for the latest release of Azure Stack Hub.

To access release notes for a different version, use the version selector dropdown above the table of contents on the left.

::: moniker range=">=azs-1908"
> [!IMPORTANT]  
> This update package is only for Azure Stack Hub integrated systems. Do not apply this update package to the Azure Stack Development Kit (ASDK).
::: moniker-end
::: moniker range="<azs-1908"
> [!IMPORTANT]  
> If your Azure Stack Hub instance is behind by more than two updates, it's considered out of compliance. You must [update to at least the minimum supported version to receive support](azure-stack-servicing-policy.md#keep-your-system-under-support).
::: moniker-end

## Update planning

Before applying the update, make sure to review the following information:

- [Known issues](known-issues.md)
- [Security updates](release-notes-security-updates.md)
- [Checklist of activities before and after applying the update](release-notes-checklist.md)

For help with troubleshooting updates and the update process, see [Troubleshoot patch and update issues for Azure Stack Hub](azure-stack-troubleshooting.md).

## Download the update

You can download the Azure Stack Hub update package using [the Azure Stack Hub update downloader tool](https://aka.ms/azurestackupdatedownload).

<!---------------------------------------------------------->
<!------------------- SUPPORTED VERSIONS ------------------->
<!---------------------------------------------------------->
::: moniker range="azs-2005"
## 2005 build reference

The Azure Stack Hub 2005 update build number is **1.2005.6.53**.

> [!IMPORTANT]  
> With [the 2002 release](release-notes.md?view=azs-2002) of Azure Stack Hub and in support of our customers around the world who are responding to COVID-19 and who may be making important decisions about their Azure Stack Hub systems, Microsoft temporarily extended its support policy to include three previous update versions (N-3). With the 2005 release we are continuing this extension for an additional 45 days (to 25th September 2020). As a result, the newly released 2005 update and any one of the three previous update versions (2002, 1910, and 1908, or N-3) will be supported. After these 45 days (after 25th September 2020), we will return to our standard support policy, meaning the supported versions will then be 2005, 2002 and 1910, or N-2.

### Update type

The Azure Stack Hub 2005 update build type is **Full**.

The 2005 update package is larger in size compared to previous updates. The increased size results in longer download times. The update will remain in the **Preparing** state for a long time, and operators can expect this process to take longer than with previous updates. The 2005 update has had the following expected runtimes in our internal testing- 4 nodes: 13-20 hours, 8 nodes: 16-26 hours, 12 nodes: 19-32 hours, 16 nodes: 22-38 hours. Exact update runtimes typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware specifications. Runtimes that are shorter or longer than the expected value are not uncommon and do not require action by Azure Stack Hub operators unless the update fails. This runtime approximation is specific to the 2005 update and should not be compared to other Azure Stack Hub updates.

For more information about update build types, see [Manage updates in Azure Stack Hub](azure-stack-updates.md).

<!-- ## What's in this update -->

<!-- The current theme (if any) of this release. -->

### What's new

<!-- What's new, also net new experiences and features. -->
- This build offers support for 3 new GPU VM types: NCv3 (Nvidia V100), NVv4 (AMD MI25), and NCas_v4 (NVIDIA T4) VM sizes. VM deployments will be successful for those who have the right hardware and are onboarded to the Azure Stack Hub GPU preview program. If you are interested, sign up for the GPU preview program at https://aka.ms/azurestackhubgpupreview. For more information, [see](../user/gpu-vms-about.md).
- This release provides a new feature that enables an autonomous healing capability, which detects faults, assesses impact, and safely mitigates system issues. With this feature, we are working towards increased availability of the system without manual intervention. With release 2005 and later, customers will experience a reduction in the number of alerts. Any failure in this pipeline doesn't require action by Azure Stack Hub operators unless notified.
- There is a new option in the Azure Stack Hub admin portal for air-gapped/disconnected Azure Stack Hub customers, to save logs locally. You can store the logs in a local SMB share when Azure Stack Hub is disconnected from Azure.
- The Azure Stack Hub admin portal now blocks certain operations if a system operation is already in progress. For example, if an update is in progress, it is not possible to add a new scale unit node.
- This release provides more fabric consistency with Azure on VMs created pre-1910. In 1910, Microsoft announced that all newly created VMs will use the wireserver protocol, enabling customers to use the same WALA agent and Windows guest agent as Azure, making it easier to use Azure images on Azure Stack Hub. With this release, all VMs created earlier than 1910 are automatically migrated to use the wireserver protocol. This also brings more reliable VM creation, VM extension deployment, and improvements in steady state uptime.
- Azure Stack Hub storage now supports Azure Storage services APIs version 2019-02-02. For Azure client libraries, that is compatible with the new REST API version. For more information, see [Azure Stack Hub storage development tools](../user/azure-stack-storage-dev.md#azure-client-libraries).
- Azure Stack Hub now supports the latest version of [CreateUiDefinition (version 2)](/azure/azure-resource-manager/managed-applications/create-uidefinition-overview).
- New guidance for batched VM deployments. For more information [see this article](../operator/azure-stack-capacity-planning-compute.md).
- The Azure Stack Hub Marketplace CoreOS Container Linux item [is approaching its end-of-life](https://azure.microsoft.com/updates/flatcar-in-azure/). For more information, see [Migrating from CoreOS Container Linux](https://docs.flatcar-linux.org/os/migrate-from-container-linux/).

### Improvements

<!-- Changes and product improvements with tangible customer-facing value. -->

- Improvements to Storage infrastructure cluster service logs and events. Logs and events of Storage infrastructure cluster service will be kept for up to 14 days, for better diagnostics and troubleshooting.
- Improvements that increase reliability of starting and stopping Azure Stack Hub.
- Improvements that reduce the update runtime by using decentralization and removing dependencies. Compared to the 2002 update, the 4 nodes stamp update time is reduced from 15-42 hours to 13-20 hours. 8 nodes is reduced from 20-50 hours to 16-26 hours. 12 nodes is reduced from 20-60 hours to 19-32 hours. 16 nodes is reduced from 25-70 hours to 22-38 hours. Exact update runtimes typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware specifications.
- The update now fails early if there are certain unrecoverable errors.
- Improved resiliency of the update package while downloading from the internet.
- Improved resiliency of stop-deallocating a VM.
- Improved resiliency of the Network Controller Host Agent.
- Added additional fields to the CEF payload of the syslog messages to report the source IP and the account used to connect to the privileged endpoint and the recovery endpoint. See [Integrate Azure Stack Hub with monitoring solutions using syslog forwarding](azure-stack-integrate-security.md) for details.
- Added Windows Defender events (Event IDs 5001, 5010, 5012) to the list of events emitted via the syslog client.
- Added alerts in the Azure Stack Administrator portal for Windows Defender-related events, to report on Defender platform and signatures version inconsistencies and failure to take actions on detected malware.
- Added support for 4 Border Devices when integrating Azure Stack Hub into your datacenter.

### Changes

- Removed the actions to stop, shut down, and restart an infrastructure role instance from the admin portal. The corresponding APIs have also been removed in the Fabric Resource Provider. The following PowerShell cmdlets in the admin RM module and AZ preview for Azure Stack Hub no longer work: **Stop-AzsInfrastructureRoleInstance**, **Disable-InfrastructureRoleInstance**, and **Restart-InfrastructureRoleInstance**. These cmdlets will be removed from the next admin AZ module release for Azure Stack Hub.
- Azure Stack Hub 2005 now only supports [App Service on Azure Stack Hub 2020 (versions 87.x)](app-service-release-notes-2020-Q2.md).

### Fixes

<!-- Product fixes that came up from customer deployments worth highlighting, especially if there is an SR/ICM associated to it. -->

- Fixed an issue that could cause a repair scale unit node to fail because it could not find the path to the base OS image.
- Fixed an issue with scale-in and scale-out for the support infrastructure role that has a cascading effect on repairing scale unit nodes.
- Fixed an issue in which the .VHD extension (instead of .vhd) was not allowed when operators added their own images to the Azure Stack Hub administrator portal on **All services > Compute > VM Images > Add**.
- Fixed an issue in which a previous VM restart operation caused a subsequent unexpected restart after any other VM update operation (adding disks, tags, etc.).
- Fixed an issue in which creating a duplicate DNS zone caused the portal to stop responding. It should now show an appropriate error.
- Fixed an issue in which **Get-AzureStackLogs** was not collecting the required logs to troubleshoot networking issues. 
- Fixed an issue in which the portal allowed fewer NICs to be attached than what it actually allows. 
- Fixed code integrity policy to not emit violation events for certain internal software. This reduces noise in code integrity violation events emitted via syslog client.
- Fixed **Set-TLSPolicy** cmdlet to enforce new policy without requiring restart of the https service or the reboot of the host.
- Fixed an issue in which using a Linux NTP server erroneously generates alerts in the administration portal.  
- Fixed an issue where failover of Backup Controller service instance resulted in automatic backups getting disabled.
- Fixed an issue where internal secret rotation fails when infrastructure services do not have internet connectivity.
- Fixed an issue in which users could not view subscription permissions using the Azure Stack Hub portals.

## Security updates

For information about security updates in this update of Azure Stack Hub, see [Azure Stack Hub security updates](release-notes-security-updates.md).

## Hotfixes

Azure Stack Hub releases hotfixes on a regular basis. Starting with the 2005 release, when you update to a new major version (for example, 1.2002.x to 1.2005.x), the latest hotfixes (if any) in the new major version are installed automatically. From that point forward, if a hotfix is released for your build, you should install it.

> [!NOTE]
> Azure Stack Hub hotfix releases are cumulative; you only need to install the latest hotfix to get all fixes included in any previous hotfix releases for that version.

For more information, see our [servicing policy](azure-stack-servicing-policy.md).

Azure Stack Hub hotfixes are only applicable to Azure Stack Hub integrated systems; do not attempt to install hotfixes on the ASDK.

### Prerequisites: Before applying the 2005 update

The 2005 release of Azure Stack Hub must be applied on the 2002 release with the following hotfixes:

- [Azure Stack Hub hotfix 1.2002.53.144](https://support.microsoft.com/help/4574736)

### After successfully applying the 2005 update

Starting with the 2005 release, when you update to a new major version (for example, 1.2002.x to 1.2005.x), the latest hotfixes (if any) in the new major version are installed automatically.

After the installation of 2005, if any 2005 hotfixes are subsequently released, you should install them:

- [Azure Stack Hub hotfix 1.2005.13.68](https://support.microsoft.com/help/4583399)
::: moniker-end

::: moniker range="azs-2002"
## 2002 build reference

The Azure Stack Hub 2002 update build number is **1.2002.0.35**.

> [!IMPORTANT]  
> With the Azure Stack Hub 2002 update, Microsoft is temporarily extending our [Azure Stack Hub support policy statements](azure-stack-servicing-policy.md).  We are working with customers around the world who are responding to COVID-19 and who may be making important decisions about their Azure Stack Hub systems, how they are updated and managed, and as a result, ensuring their data center business operations continue to operate normally. In support of our customers, Microsoft is offering a temporary support policy change extension to include three previous update versions.  As a result, the newly released 2002 update and any one of the three previous update versions (e.g. 1910, 1908, and 1907) will be supported.

### Update type

The Azure Stack Hub 2002 update build type is **Full**.

The 2002 update package is larger in size compared to previous updates. The increased size results in longer download times. The update will remain in the **Preparing** state for a long time, and operators can expect this process to take longer than with previous updates. The 2002 update has had the following expected runtimes in our internal testing- 4 nodes: 15-42 hours, 8 nodes: 20-50 hours, 12 nodes: 20-60 hours, 16 nodes: 25-70 hours. Exact update runtimes typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware specifications. Runtimes that are shorter or longer than the expected value are not uncommon and do not require action by Azure Stack Hub operators unless the update fails. This runtime approximation is specific to the 2002 update and should not be compared to other Azure Stack Hub updates.

For more information about update build types, see [Manage updates in Azure Stack Hub](azure-stack-updates.md).

<!-- ## What's in this update -->

<!-- The current theme (if any) of this release. -->

### What's new

<!-- What's new, also net new experiences and features. -->

- A new version (1.8.1) of the Azure Stack Hub admin PowerShell modules based on AzureRM is available.
- A new version of the Azure Stack Hub admin REST API is available. You can find details about endpoints and breaking changes in the [API Reference](/rest/api/azure-stack/).
- New Azure PowerShell tenant modules will be released for Azure Stack Hub on April 15, 2020. The currently used Azure RM modules will continue to work, but will no longer be updated after build 2002.
- Added new warning alert on the Azure Stack Hub administrator portal to report on connectivity issues with the configured syslog server. Alert title is **The Syslog client encountered a networking issue while sending a Syslog message**.
- Added new warning alert on the Azure Stack Hub administrator portal to report on connectivity issues with the Network Time Protocol (NTP) server. Alert title is **Invalid Time Source on [node name]**.
- The [Java SDK](https://azure.microsoft.com/develop/java/) released new packages due to a breaking change in 2002 related to TLS restrictions. You must install the new Java SDK dependency. You can find the instructions at [Java and API version profiles](../user/azure-stack-version-profiles-java.md?view=azs-2002#java-and-api-version-profiles).
- A new version (1.0.5.10) of the System Center Operations Manager - Azure Stack Hub MP is available and required for all systems running 2002 due to breaking API changes. The API changes impact the backup and storage performance dashboards, and it is recommended that you first update all systems to 2002 before updating the MP.

### Improvements

<!-- Changes and product improvements with tangible customer-facing value. -->

- This update contains changes to the update process that significantly improve the performance of future full updates. These changes take effect with the next full update after the 2002 release, and specifically target improving the performance of the phase of a full update in which the host operating systems are updated. Improving the performance of host operating system updates significantly reduces the window of time in which tenant workloads are impacted during full updates.
- The Azure Stack Hub readiness checker tool now validates AD Graph integration using all TCP IP ports allocated to AD Graph.
- The offline syndication tool has been updated with reliability improvements. The tool is no longer available on GitHub, and has been [moved to the PowerShell Gallery](https://www.powershellgallery.com/packages/Azs.Syndication.Admin/). For more information, see [Download Marketplace items to Azure Stack Hub](azure-stack-download-azure-marketplace-item.md).
- A new monitoring capability is being introduced. The low disk space alert for physical hosts and infrastructure VMs will be auto-remediated by the platform and only if this action fails will the alert be visible in the Azure Stack Hub administrator portal, for the operator to take action.
- Improvements to [diagnostic log collection](./azure-stack-diagnostic-log-collection-overview.md?view=azs-2002). The new experience streamlines and simplifies diagnostic log collection by removing the need to configure a blob storage account in advance. The storage environment is preconfigured so that you can send logs before opening a support case, and spend less time on a support call.
- Time taken for both [Proactive Log Collection and the on-demand log collection](./azure-stack-diagnostic-log-collection-overview.md?view=azs-2002) has been reduced by 80%. Log collection time can take longer than this expected value but doesn't require action by Azure Stack Hub operators unless the log collection fails.
- The download progress of an Azure Stack Hub update package is now visible in the update blade after an update is initiated. This only applies to connected Azure Stack Hub systems that choose to [prepare update packages via automatic download](azure-stack-update-prepare-package.md#automatic-download-and-preparation-for-update-packages).
- Reliability improvements to the Network Controller Host agent.
- Introduced a new micro-service called DNS Orchestrator that improves the resiliency logic for the internal DNS services during patch and update.
- Added a new request validation to fail invalid blob URIs for the boot diagnostic storage account parameter while creating VMs.
- Added auto-remediation and logging improvements for Rdagent and Host agent - two services on the host that facilitate VM CRUD operations.
- Added a new feature to marketplace management that enables Microsoft to add attributes that block administrators from downloading marketplace products that are incompatible with their Azure Stack, due to various properties, such as the Azure Stack version or billing model. Only Microsoft can add these attributes. For more information, see [Use the portal to download marketplace items](azure-stack-download-azure-marketplace-item.md#use-the-portal-to-download-marketplace-items).

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

For information about security updates in this update of Azure Stack Hub, see [Azure Stack Hub security updates](release-notes-security-updates.md).

## Hotfixes

Azure Stack Hub releases hotfixes on a regular basis. Be sure to install the latest Azure Stack Hub hotfix for 1910 before updating Azure Stack Hub to 2002.

> [!NOTE]
> Azure Stack Hub hotfix releases are cumulative; you only need to install the latest hotfix to get all fixes included in any previous hotfix releases for that version.

Azure Stack Hub hotfixes are only applicable to Azure Stack Hub integrated systems; do not attempt to install hotfixes on the ASDK.

For more information about hotfixes, see the [Azure Stack Hub servicing policy](azure-stack-servicing-policy.md#hotfixes).

### Prerequisites: Before applying the 2002 update

The 2002 release of Azure Stack Hub must be applied on the 1910 release with the following hotfixes:

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack Hub hotfix 1.1910.63.186](https://support.microsoft.com/help/4574735)

### After successfully applying the 2002 update

After the installation of this update, install any applicable hotfixes.

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack Hub hotfix 1.2002.53.144](https://support.microsoft.com/help/4574736)
::: moniker-end

::: moniker range="azs-1910"
## 1910 build reference

The Azure Stack Hub 1910 update build number is **1.1910.0.58**.

### Update type

Starting with 1908, the underlying operating system on which Azure Stack Hub runs was updated to Windows Server 2019. This update enables core fundamental enhancements and the ability to bring additional capabilities to Azure Stack Hub.

The Azure Stack Hub 1910 update build type is **Express**.

The 1910 update package is larger in size compared to previous updates, which results in longer download times. The update will remain in the **Preparing** state for a long time and operators can expect this process to take longer than previous updates. The expected time for the 1910 update to complete is approximately 10 hours, regardless of the number of physical nodes in your Azure Stack Hub environment. Exact update runtimes typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware specifications. Runtimes lasting longer than the expected value aren't uncommon and don't require action by Azure Stack Hub operators unless the update fails. This runtime approximation is specific to the 1910 update and shouldn't be compared to other Azure Stack Hub updates.

For more information about update build types, see [Manage updates in Azure Stack Hub](azure-stack-updates.md).

<!-- ## What's in this update -->

<!-- The current theme (if any) of this release. -->

### What's new

<!-- What's new, also net new experiences and features. -->

- The administrator portal now shows the privileged endpoint IP addresses in the region properties menu for easier discovery. In addition, it shows the current configured time server and DNS forwarders. For more information, see [Use the privileged endpoint in Azure Stack Hub](azure-stack-privileged-endpoint.md).

- The Azure Stack Hub health and monitoring system can now raise alerts for various hardware components if an error happens. These alerts require additional configuration. For more information, see [Monitor Azure Stack Hub hardware components](azure-stack-hardware-monitoring.md).

- [Cloud-init support for Azure Stack Hub](/azure/virtual-machines/linux/using-cloud-init): Cloud-init is a widely used approach to customize a Linux VM as it boots for the first time. You can use cloud-init to install packages and write files, or to configure users and security. Because cloud-init is called during the initial boot process, there are no additional steps or required agents to apply your configuration. The Ubuntu images on the marketplace have been updated to support cloud-init for provisioning.

- Azure Stack Hub now supports all Windows Azure Linux Agent versions as Azure.

- A new version of Azure Stack Hub admin PowerShell modules is available. <!-- For more information, see -->

- New Azure PowerShell tenant modules were released for Azure Stack Hub on April 15, 2020. The currently used Azure RM modules will continue to work, but will no longer be updated after build 2002.

- Added the **Set-AzSDefenderManualUpdate** cmdlet in the privileged endpoint (PEP) to configure the manual update for Windows Defender definitions in the Azure Stack Hub infrastructure. For more information, see [Update Windows Defender Antivirus on Azure Stack Hub](azure-stack-security-av.md).

- Added the **Get-AzSDefenderManualUpdate** cmdlet in the privileged endpoint (PEP) to retrieve the configuration of the manual update for Windows Defender definitions in the Azure Stack Hub infrastructure. For more information, see [Update Windows Defender Antivirus on Azure Stack Hub](azure-stack-security-av.md).

- Added the **Set-AzSDnsForwarder** cmdlet in the privileged endpoint (PEP) to change the forwarder settings of the DNS servers in Azure Stack Hub. For more information about DNS configuration, see [Azure Stack Hub datacenter DNS integration](azure-stack-integrate-dns.md).

- Added the **Get-AzSDnsForwarder** cmdlet in the privileged endpoint (PEP) to retrieve the forwarder settings of the DNS servers in Azure Stack Hub. For more information about DNS configuration, see [Azure Stack Hub datacenter DNS integration](azure-stack-integrate-dns.md).

- Added support for management of **Kubernetes clusters** using the [AKS engine](../user/azure-stack-kubernetes-aks-engine-overview.md). Starting with this update, customers can deploy production Kubernetes clusters. The AKS engine enables users to:
  - Manage the life cycle of their Kubernetes clusters. They can create, update, and scale clusters.
  - Maintain their clusters using managed images produced by the AKS and the Azure Stack Hub teams.
  - Take advantage of an Azure Resource Manager-integrated Kubernetes cloud provider that builds clusters using native Azure resources.
  - Deploy and manage their clusters in connected or disconnected Azure Stack Hub stamps.
  - Use Azure hybrid features:
    - Integration with Azure Arc.
    - Integration with Azure Monitor for Containers.
  - Use Windows Containers with AKS engine.
  - Receive Microsoft Support and engineering support for their deployments.

### Improvements

<!-- Changes and product improvements with tangible customer-facing value. -->

- Azure Stack Hub has improved its ability to auto-remediate some patch and update issues that previously caused update failures or prevented operators from being able to initiate an Azure Stack Hub update. As a result, there are fewer tests included in the **Test-AzureStack -UpdateReadiness** group. For more information, see [Validate Azure Stack Hub system state](azure-stack-diagnostic-test.md#groups). The following three tests remain in the **UpdateReadiness** group:

  - **AzSInfraFileValidation**
  - **AzSActionPlanStatus**
  - **AzsStampBMCSummary**

- Added an auditing rule to report when an external device (for example, a USB key) is mounted to a node of the Azure Stack Hub infrastructure. The audit log is emitted via syslog and will be displayed as **Microsoft-Windows-Security-Auditing: 6416|Plug and Play Events**. For more information about how to configure the syslog client, see [Syslog forwarding](azure-stack-integrate-security.md).

- Azure Stack Hub is moving to 4096-bit RSA keys for the internal certificates. Running internal secret rotation will replace old 2048-bit certificates with 4096-bit long certificates. For more information about secret rotation in Azure Stack Hub, see [Rotate secrets in Azure Stack Hub](azure-stack-rotate-secrets.md).

- Upgrades to the complexity of cryptographic algorithms and key strength for several internal components to comply with the Committee on National Security Systems - Policy 15 (CNSSP-15), which provides best practices for the use of public standards for secure information sharing. Among the improvements, there's AES256 for Kerberos authentication and SHA384 for VPN encryption. For more information about CNSSP-15, see the [Committee on National Security Systems, Policies page](http://www.cnss.gov/CNSS/issuances/Policies.cfm).

- Because of the above upgrade, Azure Stack Hub now has new default values for IPsec/IKEv2 configurations. The new default values used on the Azure Stack Hub side are as follows:

   **IKE Phase 1 (Main Mode) parameters**

   | Property              | Value|
   |-|-|
   | IKE Version           | IKEv2 |
   |Diffie-Hellman Group   | ECP384 |
   | Authentication method | Pre-shared key |
   |Encryption & Hashing Algorithms | AES256, SHA384 |
   |SA Lifetime (Time)     | 28,800 seconds|

   **IKE Phase 2 (Quick Mode) parameters**

   | Property| Value|
   |-|-|
   |IKE Version |IKEv2 |
   |Encryption & Hashing Algorithms (Encryption)     | GCMAES256|
   |Encryption & Hashing Algorithms (Authentication) | GCMAES256|
   |SA Lifetime (Time)  | 27,000 seconds  |
   |SA Lifetime (Kilobytes) | 33,553,408     |
   |Perfect Forward Secrecy (PFS) | ECP384 |
   |Dead Peer Detection | Supported|

   These changes are reflected in the [default IPsec/IKE proposal](../user/azure-stack-vpn-gateway-settings.md#ipsecike-parameters) documentation as well.

- The infrastructure backup service improves logic that calculates desired free space for backups instead of relying on a fixed threshold. The service will use the size of a backup, retention policy, reserve, and current utilization of external storage location to determine if a warning needs to be raised to the operator.

### Changes

- When downloading marketplace items from Azure to Azure Stack Hub, there's a new user interface that enables you to specify a version of the item when multiple versions exist. The new UI is available in both connected and disconnected scenarios. For more information, see [Download marketplace items from Azure to Azure Stack Hub](azure-stack-download-azure-marketplace-item.md).  

- Starting with the 1910 release, the Azure Stack Hub system **requires** an additional /20 private internal IP space. See [Network integration planning for Azure Stack](azure-stack-network.md) for more information.
  
- The infrastructure backup service deletes partially uploaded backup data if the external storage location runs out of capacity during the upload procedure.  

- The infrastructure backup service adds identity service to the backup payload for AAD deployments.  

- The Azure Stack Hub PowerShell Module has been updated to version 1.8.0 for the 1910 release.<br>Changes include:
   - **New DRP Admin module**: The Deployment Resource Provider (DRP) enables orchestrated deployments of resource providers to Azure Stack Hub. These commands interact with the Azure Resource Manager layer to interact with DRP.
   - **BRP**: <br />
           - Support single role restore for Azures stack infrastructure backup. <br />
           - Add parameter `RoleName` to cmdlet `Restore-AzsBackup`.
   - **FRP**: Breaking changes for **Drive** and **Volume** resources with API version `2019-05-01`. The features are supported by Azure Stack Hub 1910 and later: <br />
            - The value of `ID`, `Name`, `HealthStatus`, and `OperationalStatus` have been changed. <br />
            - Supported new properties `FirmwareVersion`, `IsIndicationEnabled`, `Manufacturer`, and `StoragePool` for **Drive** resources. <br />
            - The properties `CanPool` and `CannotPoolReason` of **Drive** resources have been deprecated; use `OperationalStatus` instead.

### Fixes

<!-- Product fixes that came up from customer deployments worth highlighting, especially if there's an SR/ICM associated to it. -->

- Fixed an issue that prevented enforcing TLS 1.2 policy on environments deployed before the Azure Stack Hub 1904 release.
- Fixed an issue where an Ubuntu 18.04 VM created with SSH authorization enabled doesn't allow you to use the SSH keys to sign in.
- Removed **Reset Password** from the Virtual Machine Scale Set UI.
- Fixed an issue where deleting the load balancer from the portal didn't result in the deletion of the object in the infrastructure layer.
- Fixed an issue that showed an inaccurate percentage of the Gateway Pool utilization alert on the administrator portal.
<!-- Fixed an issue where adding more than one public IP on the same NIC on a Virtual Machine resulted in internet connectivity issues. Now, a NIC with two public IPs should work as expected.[This fix actually didn't go in 1910 due to build issues, commenting out until next build (2002) ] -->

## Security updates

For information about security updates in this update of Azure Stack Hub, see [Azure Stack Hub security updates](release-notes-security-updates.md).

The Qualys vulnerability report for this release can be downloaded from the [Qualys website](https://www.qualys.com/azure-stack/).

## Hotfixes

Azure Stack Hub releases hotfixes on a regular basis. Be sure to install the latest Azure Stack Hub hotfix for 1908 before updating Azure Stack Hub to 1910.

> [!NOTE]
> Azure Stack Hub hotfix releases are cumulative; you only need to install the latest hotfix to get all fixes included in any previous hotfix releases for that version.

Azure Stack Hub hotfixes are only applicable to Azure Stack Hub integrated systems; do not attempt to install hotfixes on the ASDK.

### Prerequisites: Before applying the 1910 update

The 1910 release of Azure Stack Hub must be applied on the 1908 release with the following hotfixes:

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack Hub hotfix 1.1908.51.133](https://support.microsoft.com/help/4574734)

### After successfully applying the 1910 update

After the installation of this update, install any applicable hotfixes. For more information, see our [servicing policy](azure-stack-servicing-policy.md).

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack Hub hotfix 1.1910.63.186](https://support.microsoft.com/help/4574735)
::: moniker-end

::: moniker range="azs-1908"
## 1908 build reference

The Azure Stack Hub 1908 update build number is **1.1908.4.33**.

### Update type

For 1908, the underlying operating system on which Azure Stack Hub runs has been updated to Windows Server 2019. This update enables core fundamental enhancements and the ability to bring additional capabilities to Azure Stack Hub.

The Azure Stack Hub 1908 update build type is **Full**. As a result, the 1908 update has a longer runtime than express updates like 1906 and 1907. Exact runtimes for full updates typically depend on the number of nodes that your Azure Stack Hub instance contains, the capacity used on your system by tenant workloads, your system's network connectivity (if connected to the internet), and your system hardware configuration. The 1908 update has had the following expected runtimes in our internal testing: 4 nodes - 42 hours, 8 nodes - 50 hours, 12 nodes - 60 hours, 16 nodes - 70 hours. Update runtimes lasting longer than these expected values aren't uncommon and don't require action by Azure Stack Hub operators unless the update fails.

For more information about update build types, see [Manage updates in Azure Stack Hub](azure-stack-updates.md).

- Exact update runtimes typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware configuration.
- Runtimes lasting longer than expected aren't uncommon and don't require action by Azure Stack Hub operators unless the update fails.
- This runtime approximation is specific to the 1908 update and shouldn't be compared to other Azure Stack Hub updates.

<!-- ## What's in this update -->

<!-- The current theme (if any) of this release. -->

### What's new

<!-- What's new, also net new experiences and features. -->

- For 1908, note that the underlying operating system on which Azure Stack Hub runs has been updated to Windows Server 2019. This update enables core fundamental enhancements and the ability to bring additional capabilities to Azure Stack Hub.
- All components of Azure Stack Hub infrastructure now operate in FIPS 140-2 mode.
- Azure Stack Hub operators can now remove portal user data. For more information, see [Clear portal user data from Azure Stack Hub](azure-stack-portal-clear.md).

### Improvements

<!-- Changes and product improvements with tangible customer-facing value. -->
- Improvements to data at rest encryption of Azure Stack Hub to persist secrets into the hardware Trusted Platform Module (TPM) of the physical nodes.

### Changes

- Hardware providers will be releasing OEM extension package 2.1 or later at the same time as Azure Stack Hub version 1908. The OEM extension package 2.1 or later is a prerequisite for Azure Stack Hub version 1908. For more information about how to download OEM extension package 2.1 or later, contact your system's hardware provider, and see the [OEM updates](azure-stack-update-oem.md#oem-contact-information) article.  

### Fixes

- Fixed an issue with compatibility with future Azure Stack Hub OEM updates and an issue with VM deployment using customer user images. This issue was found in 1907 and fixed in hotfix [KB4517473](https://support.microsoft.com/en-us/help/4517473/azure-stack-hotfix-1-1907-12-44)  
- Fixed an issue with OEM Firmware update and corrected misdiagnosis in Test-AzureStack for Fabric Ring Health. This issue was found in 1907 and fixed in hotfix [KB4515310](https://support.microsoft.com/en-us/help/4515310/azure-stack-hotfix-1-1907-7-35)
- Fixed an issue with OEM Firmware update process. This issue was found in 1907 and fixed in hotfix [KB4515650](https://support.microsoft.com/en-us/help/4515650/azure-stack-hotfix-1-1907-8-37)

<!-- Product fixes that came up from customer deployments worth highlighting, especially if there's an SR/ICM associated to it. -->

## Security updates

For information about security updates in this update of Azure Stack Hub, see [Azure Stack Hub security updates](release-notes-security-updates.md).

The Qualys vulnerability report for this release can be downloaded from the [Qualys website](https://www.qualys.com/azure-stack/).

## Download the update

You can download the Azure Stack Hub 1908 update package from [the Azure Stack Hub download page](https://aka.ms/azurestackupdatedownload).

## Hotfixes

Azure Stack Hub releases hotfixes on a regular basis. Be sure to install the latest Azure Stack Hub hotfix for 1907 before updating Azure Stack Hub to 1908.

Azure Stack Hub hotfixes are only applicable to Azure Stack Hub integrated systems; don't attempt to install hotfixes on the ASDK.

### Prerequisites: Before applying the 1908 update

The 1908 release of Azure Stack Hub must be applied on the 1907 release with the following hotfixes:

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack Hub hotfix 1.1907.29.80](https://support.microsoft.com/help/4555650)

The Azure Stack Hub 1908 Update requires **Azure Stack Hub OEM version 2.1 or later** from your system's hardware provider. OEM updates include driver and firmware updates to your Azure Stack Hub system hardware. For more information about applying OEM updates, see [Apply Azure Stack Hub original equipment manufacturer updates](azure-stack-update-oem.md)

### After successfully applying the 1908 update

After the installation of this update, install any applicable hotfixes. For more information, see our [servicing policy](azure-stack-servicing-policy.md).

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack Hub hotfix 1.1908.51.133](https://support.microsoft.com/help/4574734)
::: moniker-end

<!------------------------------------------------------------>
<!------------------- UNSUPPORTED VERSIONS ------------------->
<!------------------------------------------------------------>
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

::: moniker range="<azs-1908"
You can access [older versions of Azure Stack Hub release notes on the TechNet Gallery](https://aka.ms/azsarchivedrelnotes). These archived documents are provided for reference purposes only and do not imply support for these versions. For information about Azure Stack Hub support, see [Azure Stack Hub servicing policy](azure-stack-servicing-policy.md). For further assistance, contact Microsoft Customer Support Services.
::: moniker-end
