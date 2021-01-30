---
title: Azure Stack Hub release notes 
description: Release notes for Azure Stack Hub integrated systems, including updates and bug fixes.
author: sethmanheim

ms.topic: article
ms.date: 01/29/2021
ms.author: sethm
ms.reviewer: sranthar
ms.lastreviewed: 09/09/2020

# Intent: As an Azure Stack Hub user, I want to know what's new in the latest release so that I can plan my update.
# Keyword: Notdone: keyword noun phrase

---

# Azure Stack Hub release notes

This article describes the contents of Azure Stack Hub update packages. The update includes improvements and fixes for the latest release of Azure Stack Hub.

To access release notes for a different version, use the version selector dropdown above the table of contents on the left.

::: moniker range=">=azs-2002"
> [!IMPORTANT]  
> This update package is only for Azure Stack Hub integrated systems. Do not apply this update package to the Azure Stack Development Kit (ASDK).
::: moniker-end
::: moniker range="<azs-2002"
> [!IMPORTANT]  
> If your Azure Stack Hub instance is behind by more than two updates, it's considered out of compliance. You must [update to at least the minimum supported version to receive support](azure-stack-servicing-policy.md#keep-your-system-under-support).
::: moniker-end

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
::: moniker range="azs-2008"
## 2008 build reference

The Azure Stack Hub 2008 update build number is **1.2008.13.88**.

### Update type

The Azure Stack Hub 2008 update build type is **Full**.

The 2008 update package is larger in size compared to previous updates. The increased size results in longer download times. The update will remain in the **Preparing** state for a long time, and operators can expect this process to take longer than with previous updates. The 2008 update has had the following expected runtimes in our internal testing- 4 nodes: 13-20 hours, 8 nodes: 16-26 hours, 12 nodes: 19-32 hours, 16 nodes: 22-38 hours. Exact update runtimes typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware specifications. Runtimes that are shorter or longer than the expected value are not uncommon and do not require action by Azure Stack Hub operators unless the update fails. This runtime approximation is specific to the 2008 update and should not be compared to other Azure Stack Hub updates.

For more information about update build types, see [Manage updates in Azure Stack Hub](azure-stack-updates.md).

<!-- ## What's in this update -->

<!-- The current theme (if any) of this release. -->

### What's new

<!-- What's new, also net new experiences and features. -->
- Azure Stack Hub now supports VNET peering, which gives the ability to connect VNETs without a Network Virtual Appliance (NVA). For more information, see the [new VNET peering documentation](../user/virtual-network-peering.md).
- Azure Stack Hub blob storage now enables users to use an immutable blob. By setting immutable policies on a container, you can store business-critical data objects in a WORM (Write Once, Read Many) state. In this release, immutable policies can only be set through the REST API or client SDKs. Append blob writes are also not possible in this release. For more information about immutable blobs, see [Store business-critical blob data with immutable storage](/azure/storage/blobs/storage-blob-immutable-storage).
- Azure Stack Hub Storage now supports Azure Storage services APIs version **2019-07-07**. For Azure client libraries that is compatible with the new REST API version, see [Azure Stack Hub storage development tools](../user/azure-stack-storage-dev.md#azure-client-libraries). For Azure Storage services management APIs, **2018-02-01** has been add of support, with a subset of total available features.
- Azure Stack Hub compute now supports Azure Compute APIs version **2020-06-01**, with a subset of total available features.
- Azure Stack Hub managed disks now support Azure Disk APIs version **2019-03-01**, with a subset of the available features.
- Preview of Windows Admin Center that can now connect to Azure Stack Hub to provide in-depth insights into the infrastructure during support operations (break-glass required).
- Ability to add login banner to the privileged endpoint (PEP) at deployment time.
- Released more **Exclusive Operations** banners, which improve the visibility of operations that are currently happening on the system, and disable users from initiating (and subsequently failing) any other exclusive operation.
- Introduced two new banners in each Azure Stack Hub Marketplace item's product page. If there is a Marketplace download failure, operators can view error details and attempt recommended steps to resolve the issue.
- Released a rating tool for customers to provide feedback. This will enable Azure Stack Hub to measure and optimize the customer experience.
- This release of Azure Stack Hub includes a private preview of Azure Kubernetes Service (AKS) and Azure Container Registry (ACR). The purpose of the private preview is to collect feedback about the quality, features, and user experience of AKS and ACR on Azure Stack Hub.
- This release includes a public preview of Azure CNI and Windows Containers using [AKS Engine v0.55.4](../user/kubernetes-aks-engine-release-notes.md). For an example of how to use them in your API model, [see this example on GitHub](https://raw.githubusercontent.com/Azure/aks-engine/master/examples/azure-stack/kubernetes-windows.json).
- There is now support for [Istio 1.3 deployment](https://github.com/Azure/aks-engine/tree/master/examples/service-mesh) on clusters deployed by [AKS Engine v0.55.4](../user/kubernetes-aks-engine-release-notes.md). For more information, [see the instructions here](../user/kubernetes-aks-engine-service-account.md).
- There is now support for deployment of [private clusters](https://github.com/Azure/aks-engine/blob/master/docs/topics/features.md#private-cluster) using [AKS Engine v0.55.4](../user/kubernetes-aks-engine-release-notes.md).
- This release includes support for [sourcing Kubernetes configuration secrets](https://github.com/Azure/aks-engine/blob/master/docs/topics/keyvault-secrets.md#use-key-vault-as-the-source-of-cluster-configuration-secrets) from Azure and Azure Stack Hub Key Vault instances.

### Improvements

<!-- Changes and product improvements with tangible customer-facing value. -->
- Implemented internal monitoring for Network Controller and SLB host agents, so the services are auto-remediated if they ever enter into a stopped state.
- Active Directory Federation Services (AD FS) now retrieves the new token signing certificate afer the customer has rotated it on their own AD FS server. To take advantage of this new capability for already configured systems, the AD FS integration must be configured again. For more information, see [Integrate AD FS identity with your Azure Stack Hub datacenter](azure-stack-integrate-identity.md).
- Changes to the startup and shutdown process on infrastructure role instances and their dependencies on scale unit nodes. This increases the reliability for Azure Stack Hub startup and shutdown.
- The **AzSScenarios** suite of the **Test-AzureStack** validation tool has been updated to enable Cloud Service Providers to run this suite successfully with multi-factor authentication enforced on all customer accounts.
- Improved alert reliability by adding suppression logic for 29 customer facing alerts during lifecycle operations.
- You can now view a detailed log collection HTML report which provides details on the roles, duration, and status of the log collection. The purpose of this report is to help users provide a summary of the logs collected. Microsoft Customer Support Services can then quickly assess the report to evaluate the log data, and help to troubleshoot and mitigate system issues.
- The infrastructure fault detection coverage has been expanded with the addition of 7 new monitors across user scenarios such as CPU utilization and memory consumption, which helps to increase the reliability of fault detection.

### Changes

- The **supportHttpsTrafficOnly** storage account resource type property in SRP API version **2016-01-01** and **2016-05-01** has been enabled, but this property is not supported in Azure Stack Hub.
- Raised volume capacity utilization alert threshold from 80% (warning) and 90% (critical) to 90% (warning) and 95% (critical). For more information, see [Storage space alerts](azure-stack-manage-storage-shares.md#storage-space-alerts)
- The AD Graph configuration steps change with this release. For more information, see [Integrate AD FS identity with your Azure Stack Hub datacenter](azure-stack-integrate-identity.md).
- To align to the current best practices defined for Windows Server 2019, Azure Stack Hub is changing to utilize an additional traffic class or priority to further separate server to server communication in support of the Failover Clustering control communication. The result of these changes provides better resiliency for Failover Cluster communication. This traffic class and bandwidth reservation configuration is accomplished by a change on the top-of-rack (ToR) switches of the Azure Stack Hub solution and on the host or servers of Azure Stack Hub.

  Note that these changes are added at the host level of an Azure Stack Hub system. Please contact your OEM to arrange making the required changes at the top-of-rack (ToR) network switches. This ToR change can be performed either prior to updating to the 2008 release or after updating to 2008. For more information, see the [Network Integration documentation](azure-stack-network.md).

- The GPU capable VM sizes **NCas_v4 (NVIDIA T4)** have been replaced in this build with the VM sizes **NCasT4_v3**, to be consistent with Azure. Note that those are not visible in the portal yet, and can only be used via Azure Resouce Manager templates.

### Fixes

<!-- Product fixes that came up from customer deployments worth highlighting, especially if there is an SR/ICM associated to it. -->
- Fixed an issue in which deleting an NSG of a NIC that is not attached to a running VM failed.
- Fixed an issue in which modifying the **IdleTimeoutInMinutes** value for a public IP that is associated to a load balancer put the public IP in a failed state.
- Fixed the **Get-AzsDisk** cmdlet to return the correct **Attached** status, instead of **OnlineMigration**, for attached managed disks.

## Security updates

For information about security updates in this update of Azure Stack Hub, see [Azure Stack Hub security updates](release-notes-security-updates.md).

## Hotfixes

Azure Stack Hub releases hotfixes on a regular basis. Make sure you install the latest 2005 hotfix before updating to 2008. Also, starting with the 2005 release, when you update to a new major version (for example, 1.2005.x to 1.2008.x), the latest hotfixes (if any are available at the time of package download) in the new major version are installed automatically. Your 2008 installation is then current with all hotfixes. From that point forward, if a hotfix is released for 2008, you should install it.

> [!NOTE]
> Azure Stack Hub hotfix releases are cumulative; you only need to install the latest hotfix to get all fixes included in any previous hotfix releases for that version.

For more information, see our [servicing policy](azure-stack-servicing-policy.md).

Azure Stack Hub hotfixes are only applicable to Azure Stack Hub integrated systems; do not attempt to install hotfixes on the ASDK.

### After successfully applying the 2008 update

Because Azure Stack Hub hotfixes are cumulative, as a best practice you should install all hotfixes released for your build, to ensure the best update experience between major releases. When you update to a new major version (for example, 1.2005.x to 1.2008.x), the latest hotfixes (if any are available at the time of package download) in the new major version are installed automatically.

After the installation of 2008, if any 2008 hotfixes are subsequently released, you should install them:

- [Azure Stack Hub hotfix 1.2008.23.108](https://support.microsoft.com/topic/c0d203fd-7585-4c8d-8ea5-ae13897e352e)
::: moniker-end

::: moniker range="azs-2005"
## 2005 build reference

The Azure Stack Hub 2005 update build number is **1.2005.6.53**.

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
- The user encryption setting that is required for hardware monitoring was changed from DES to AES to increase security. Please reach out to your hardware partner to learn how to change the setting in the base board management controller (BMC). After the change is made in the BMC, it may require you to run the command **Set-BmcCredential** again using the priviledged endpoint. For more information, see [Rotate secrets in Azure Stack Hub](azure-stack-rotate-secrets.md)

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

- [Azure Stack Hub hotfix 1.2002.65.171](https://support.microsoft.com/topic/d743db84-df31-496b-b37c-6e5618b4cc8f)

### After successfully applying the 2005 update

Starting with the 2005 release, when you update to a new major version (for example, 1.2002.x to 1.2005.x), the latest hotfixes (if any) in the new major version are installed automatically.

After the installation of 2005, if any 2005 hotfixes are subsequently released, you should install them:

- [Azure Stack Hub hotfix 1.2005.28.98](https://support.microsoft.com/topic/ecf727b1-3dc1-4070-ace8-1291cc437389)
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
- The [Java SDK](https://azure.microsoft.com/develop/java/) released new packages due to a breaking change in 2002 related to TLS restrictions. You must install the new Java SDK dependency. You can find the instructions at [Java and API version profiles](../user/azure-stack-version-profiles-java.md?view=azs-2002&preserve-view=true#java-and-api-version-profiles).
- A new version (1.0.5.10) of the System Center Operations Manager - Azure Stack Hub MP is available and required for all systems running 2002 due to breaking API changes. The API changes impact the backup and storage performance dashboards, and it is recommended that you first update all systems to 2002 before updating the MP.

### Improvements

<!-- Changes and product improvements with tangible customer-facing value. -->

- This update contains changes to the update process that significantly improve the performance of future full updates. These changes take effect with the next full update after the 2002 release, and specifically target improving the performance of the phase of a full update in which the host operating systems are updated. Improving the performance of host operating system updates significantly reduces the window of time in which tenant workloads are impacted during full updates.
- The Azure Stack Hub readiness checker tool now validates AD Graph integration using all TCP IP ports allocated to AD Graph.
- The offline syndication tool has been updated with reliability improvements. The tool is no longer available on GitHub, and has been [moved to the PowerShell Gallery](https://www.powershellgallery.com/packages/Azs.Syndication.Admin/). For more information, see [Download Marketplace items to Azure Stack Hub](azure-stack-download-azure-marketplace-item.md).
- A new monitoring capability is being introduced. The low disk space alert for physical hosts and infrastructure VMs will be auto-remediated by the platform and only if this action fails will the alert be visible in the Azure Stack Hub administrator portal, for the operator to take action.
- Improvements to [diagnostic log collection](./diagnostic-log-collection.md?preserve-view=true&view=azs-2002). The new experience streamlines and simplifies diagnostic log collection by removing the need to configure a blob storage account in advance. The storage environment is preconfigured so that you can send logs before opening a support case, and spend less time on a support call.
- Time taken for both [Proactive Log Collection and the on-demand log collection](./diagnostic-log-collection.md?preserve-view=true&view=azs-2002) has been reduced by 80%. Log collection time can take longer than this expected value but doesn't require action by Azure Stack Hub operators unless the log collection fails.
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
- [Azure Stack Hub hotfix 1.1910.84.230](https://support.microsoft.com/help/4592243)

### After successfully applying the 2002 update

After the installation of this update, install any applicable hotfixes.

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack Hub hotfix 1.2002.65.171](https://support.microsoft.com/topic/d743db84-df31-496b-b37c-6e5618b4cc8f)
::: moniker-end

<!------------------------------------------------------------>
<!------------------- UNSUPPORTED VERSIONS ------------------->
<!------------------------------------------------------------>
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

::: moniker range="<azs-2002"
You can access [older versions of Azure Stack Hub release notes on the TechNet Gallery](https://aka.ms/azsarchivedrelnotes). These archived documents are provided for reference purposes only and do not imply support for these versions. For information about Azure Stack Hub support, see [Azure Stack Hub servicing policy](azure-stack-servicing-policy.md). For further assistance, contact Microsoft Customer Support Services.
::: moniker-end