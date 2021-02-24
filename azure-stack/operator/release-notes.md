---
title: Azure Stack Hub release notes 
description: Release notes for Azure Stack Hub integrated systems, including updates and bug fixes.
author: sethmanheim

ms.topic: article
ms.date: 02/24/2021
ms.author: sethm
ms.reviewer: sranthar
ms.lastreviewed: 09/09/2020

# Intent: As an Azure Stack Hub user, I want to know what's new in the latest release so that I can plan my update.
# Keyword: Notdone: keyword noun phrase

---

# Azure Stack Hub release notes

This article describes the contents of Azure Stack Hub update packages. The update includes improvements and fixes for the latest release of Azure Stack Hub.

To access release notes for a different version, use the version selector dropdown above the table of contents on the left.

::: moniker range=">=azs-2005"
> [!IMPORTANT]  
> This update package is only for Azure Stack Hub integrated systems. Do not apply this update package to the Azure Stack Development Kit (ASDK).
::: moniker-end
::: moniker range="<azs-2005"
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
::: moniker range="azs-2102"
## 2102 build reference

The Azure Stack Hub 2102 update build number is **1.2102.xx.xx**.

### Update type

The Azure Stack Hub 2102 update build type is **Full**.

The 2102 update has had the following expected runtimes in our internal testing- 4 nodes: 8-20 hours, 8 nodes: 11-26 hours, 12 nodes: 14-32 hours, 16 nodes: 17-38 hours. Exact update runtimes typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware specifications. Runtimes that are shorter or longer than the expected value are not uncommon and do not require action by Azure Stack Hub operators unless the update fails. This runtime approximation is specific to the 2102 update and should not be compared to other Azure Stack Hub updates.

For more information about update build types, see [Manage updates in Azure Stack Hub](azure-stack-updates.md).

<!-- ## What's in this update -->

<!-- The current theme (if any) of this release. -->

### What's new

<!-- What's new, also net new experiences and features. -->

- The Azure Stack Hub infrastructure backup service now supports progressive backup. This feature helps reduce storage requirements on the external backup location, and changes the way files are organized on the external backup store. It is recommended that you not manipulate files under the backup root directory.
- Azure Stack Hub managed disks now support Azure Disk APIs version 2019-11-01, with a subset of the available features.
- The Azure Stack Hub administrator portal now shows GPU-related information, including capacity data. Note that this requires a GPU to be installed in the system.
- Users can now deploy all supported VM sizes, using Nvidia T4 via the Azure Stack Hub user portal.
- Azure Stack Hub operators can now configure multi-tenancy in Azure Stack Hub via the administrator portal. For more information, see [Configure multi-tenancy](enable-multitenancy.md).
- Azure Stack Hub operators can now configure a legal notice using the privileged endpoint. For more information, see [Configure Azure Stack Hub security controls](azure-stack-security-configuration.md#legal-notice-for-pep-sessions)
- During the update process, Granular Bitmap Repair (GBR), an optimization in the storage repair process, is introduced to repair out-of-sync data. Compared to the previous process, smaller segments are repaired, which leads to less repair time and a shorter overall update duration. GBR is enabled by default for all new deployments of 2102. For an update to 2102 from an earlier version (2008), GBR is enabled during the update. GBR enablement requires that all physical disks are in a healthy state, so an additional validation was added in the **UpdateReadiness** check. Patch & update will fail at a very early stage if the validation fails. At that point, a cloud admin must take action to resolve the disk problem before resuming the update. To follow up with the OEM, please check the [OEM contact information](azure-stack-update-oem.md#oem-contact-information).

### Improvements

- Increased the Network Controller log retention period, so the logs will be available for longer to help engineers in effective troubleshooting, even after an issue has been resolved.
- Improvements to preserve the Network Controller, Gateway VM, Load Balancer and Host Agent logs during an update.
- Improved the deletion logic for networking resources that are blocked by a failed provisioning state.
- Reduced the XRP memory to 14GB per VM and WAS memory to 10GB per VM. By avoiding the increase in total VM memory footprint, more tenant VMs are deployable.
- The log collection HTML report, which gives a snapshot of the files on the stamp and diagnostic share, now has a summarized view of the collected files, roles, resource providers and event information to better help understand the success and failure rate of the log collection process. 
- Added cmdlets [Set-AzSLegalNotice](../reference/pep-2002/set-azslegalnotice.md) and [Get-AzSLegalNotice](../reference/pep-2002/get-azslegalnotice.md) to the privileged endpoint (PEP) to retrieve and update the content of the login banner text after deployment.
- Added Webhooks feature to the Azure Container Registry on Azure Stack Hub Private Preview functionality. [Create Webhooks - CLI](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-webhook#create-webhook---azure-cli)

<!-- Changes and product improvements with tangible customer-facing value. -->

### Changes

- The Fabric Resource Provider APIs now expose information about GPUs if available in the scale unit.
- Azure Stack Hub operators can now change the GPU partitioning ratio via PowerShell (AMD only). Note that this requires all virtual machines to be deallocated.
- This build includes a new version of Azure Resource Manager.
- The Azure Stack Hub user portal now uses the full screen experience for load balancers, Network Security Groups, DNS zones, and disk and VM creation.
- In the 2102 release, the Windows Admin Center (WAC) is enabled on demand from an unlocked PEP session. By default, WAC is not enabled. To enable it, specify the `-EnableWac` flag; for example, `unlock-supportsession -EnableWac`.
- Proactive log collection now uses an improved algorithm, which captures logs during error conditions that aren't visible to an operator. This ensures that the correct diagnostic info is collected at the right time, without needing any operator interaction. In some cases, Microsoft support can begin troubleshooting and resolving problems sooner. Initial algorithm improvements focus on patch and update operations. Enabling proactive log collections is recommended, as more operations are optimized and the benefits increase.

### Fixes

- Fixed an issue in which internal DNS zones become out of sync during update, and cause the update to fail. This fix has been backported to 2008 and 2005 via hotfixes.
- Fixed an issue in which disk space was exhausted by logs on physical hosts, Network Controllers, Gateways and load balancers. This fix has been backported to 2008.
- Fixed an issue in which deletion of resource groups or virtual networks fails due to an orphaned resource in the Network Controller layer.

<!-- Product fixes that came up from customer deployments worth highlighting, especially if there is an SR/ICM associated to it. -->

## Security updates

For information about security updates in this update of Azure Stack Hub, see [Azure Stack Hub security updates](release-notes-security-updates.md).

## Hotfixes

Azure Stack Hub releases hotfixes on a regular basis. Starting with the 2005 release, when you update to a new major version (for example, 1.2005.x to 1.2008.x), the latest hotfixes (if any) in the new major version are installed automatically. From that point forward, if a hotfix is released for your build, you should install it.

> [!NOTE]
> Azure Stack Hub hotfix releases are cumulative; you only need to install the latest hotfix to get all fixes included in any previous hotfix releases for that version.

For more information, see our [servicing policy](azure-stack-servicing-policy.md).

Azure Stack Hub hotfixes are only applicable to Azure Stack Hub integrated systems; do not attempt to install hotfixes on the ASDK.

### Hotfix prerequisites: before applying the 2102 update

The 2102 release of Azure Stack Hub must be applied on the 2008 release with the following hotfixes:

- [Azure Stack Hub hotfix 1.2008.20.102](https://support.microsoft.com/help/4595075)

### After successfully applying the 2102 update

When you update to a new major version (for example, 1.2008.x to 1.2102.x), the latest hotfixes (if any) in the new major version are installed automatically. From that point forward, if a hotfix is released for your build, you should install it.

After the installation of 2102, if any 20210211 hotfixes are subsequently released, you should install them:

- No Azure Stack Hub hotfix available for 2102.
::: moniker-end

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
- Active Directory Federation Services (AD FS) now retrieves the new token signing certificate after the customer has rotated it on their own AD FS server. To take advantage of this new capability for already configured systems, the AD FS integration must be configured again. For more information, see [Integrate AD FS identity with your Azure Stack Hub datacenter](azure-stack-integrate-identity.md).
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

- The GPU capable VM sizes **NCas_v4 (NVIDIA T4)** have been replaced in this build with the VM sizes **NCasT4_v3**, to be consistent with Azure. Note that those are not visible in the portal yet, and can only be used via Azure Resource Manager templates.

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

> [!TIP]
> If you want to be notified about each hotfix release, subscribe to the [**RSS feed**](https://azurestackhubdocs.azurewebsites.net/xml/hotfixes.rss) to be notified about each hotfix release.

### After successfully applying the 2008 update

Because Azure Stack Hub hotfixes are cumulative, as a best practice you should install all hotfixes released for your build, to ensure the best update experience between major releases. When you update to a new major version (for example, 1.2005.x to 1.2008.x), the latest hotfixes (if any are available at the time of package download) in the new major version are installed automatically.

After the installation of 2008, if any 2008 hotfixes are subsequently released, you should install them:

- [Azure Stack Hub hotfix 1.2008.26.116](hotfix-1-2008-26-116.md)
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
- The user encryption setting that is required for hardware monitoring was changed from DES to AES to increase security. Please reach out to your hardware partner to learn how to change the setting in the base board management controller (BMC). After the change is made in the BMC, it may require you to run the command **Set-BmcCredential** again using the privileged endpoint. For more information, see [Rotate secrets in Azure Stack Hub](azure-stack-rotate-secrets.md)

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

- [Azure Stack Hub hotfix 1.2002.66.173](hotfix-1-2002-66-173.md)

### After successfully applying the 2005 update

Starting with the 2005 release, when you update to a new major version (for example, 1.2002.x to 1.2005.x), the latest hotfixes (if any) in the new major version are installed automatically.

After the installation of 2005, if any 2005 hotfixes are subsequently released, you should install them:

- [Azure Stack Hub hotfix 1.2005.30.102](hotfix-1-2005-30-102.md)
::: moniker-end

<!------------------------------------------------------------>
<!------------------- UNSUPPORTED VERSIONS ------------------->
<!------------------------------------------------------------>
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

::: moniker range="<azs-2005"
You can access older versions of Azure Stack Hub release notes in the table of contents on the left side, under [**Resources > Release notes archive**](./relnotearchive/release-notes-2002.md). These archived articles are provided for reference purposes only and do not imply support for these versions. For information about Azure Stack Hub support, see [Azure Stack Hub servicing policy](azure-stack-servicing-policy.md). For further assistance, contact Microsoft Customer Support Services.
::: moniker-end
