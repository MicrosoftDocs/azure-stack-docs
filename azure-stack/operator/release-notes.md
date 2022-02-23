---
title: Azure Stack Hub release notes
description: Release notes for Azure Stack Hub integrated systems, including updates and bug fixes.
author: sethmanheim
ms.topic: article
ms.date: 01/27/2022
ms.author: sethm
ms.reviewer: niy
ms.lastreviewed: 09/09/2020

# Intent: As an Azure Stack Hub operator, I want to know what's new in the latest release so that I can plan my update.
# Keyword: release notes what's new

---

# Azure Stack Hub release notes

This article describes the contents of Azure Stack Hub update packages. The update includes improvements and fixes for the latest release of Azure Stack Hub.

To access release notes for a different version, use the version selector dropdown above the table of contents on the left.

::: moniker range=">=azs-2008"
> [!IMPORTANT]  
> This update package is only for Azure Stack Hub integrated systems. Do not apply this update package to the Azure Stack Development Kit (ASDK).
::: moniker-end
::: moniker range="<azs-2008"
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
- Windows Server 2022 is now supported as a guest operating system.
- Starting with this version, if proactive log collection is disabled, logs are captured and stored locally for proactive failure events. The local logs can only be accessed by Microsoft in the context of a support case. New alerts have been added to the proactive log collection **Alert** library.
- Two new services, [Azure Kubernetes Service](../user/aks-overview.md) and [Azure Container Registry](../user/container-registry-overview.md), are available in public preview with this release.
- [**AzureStack** module 2.2.0](/powershell/azure/azure-stack/overview?view=azurestackps-2.2.0&preserve-view=true) is released to align with Azure Stack Hub version 2108. The version update includes changes in compute administrator module and new modules `Azs.ContainerRegistry.Admin` and `Azs.ContainerService.Admin`. For more information, see the [change log](https://github.com/Azure/azurestack-powershell/blob/release-2108/src/changelog.md).
- With this release, telemetry data is uploaded to an Azure Storage account that's managed and controlled by Microsoft. Azure Stack Hub telemetry service connects to `https://*.blob.core.windows.net/` and `https://azsdiagprdwestusfrontend.westus.cloudapp.azure.com/` for a successful telemetry data upload to Microsoft. Port 443 (HTTPS) must be opened. For more information, see [Azure Stack Hub telemetry](azure-stack-telemetry.md).
- This release includes a public preview of remote support, which enables a Microsoft support professional to solve your support case faster by permitting access to your device remotely, so that support engineers can perform limited troubleshooting and repair. You can enable this feature by granting consent, while controlling the access level and duration of access. Support can only access your device after a support request has been submitted. For more information, see [Remote support for Azure Stack Hub](remote-support.md).

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

For more information, see our [servicing policy](azure-stack-servicing-policy.md).

Azure Stack Hub hotfixes are only applicable to Azure Stack Hub integrated systems; do not attempt to install hotfixes on the ASDK.

### Hotfix prerequisites: before applying the 2108 update

The 2108 release of Azure Stack Hub must be applied on the 2102 release with the following hotfixes:

- [Azure Stack Hub hotfix 1.2102.30.118](hotfix-1-2102-30-118.md)

### After successfully applying the 2108 update

When you update to a new major version (for example, 1.2102.x to 1.2108.x), the latest hotfixes (if any) in the new major version are installed automatically. From that point forward, if a hotfix is released for your build, you should install it.

After the installation of 2108, if any hotfixes for 2108 are subsequently released, you should install them:

- [Azure Stack Hub hotfix 1.2108.2.73](hotfix-1-2108-2-73.md)
::: moniker-end

::: moniker range="azs-2102"
## 2102 build reference

The latest Azure Stack Hub 2102 update build number is **1.2102.30.97**. For updated build and hotfix information, see the [Hotfixes](#hotfixes) section.

### Update type

The Azure Stack Hub 2102 update build type is **Full**.

The 2102 update has the following expected runtimes based on our internal testing:

- 4 nodes: 8-20 hours
- 8 nodes: 11-26 hours
- 12 nodes: 14-32 hours
- 16 nodes: 17-38 hours

Exact update durations typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware specifications. Durations that are shorter or longer than the expected value are not uncommon and do not require action by Azure Stack Hub operators unless the update fails. This runtime approximation is specific to the 2102 update and should not be compared to other Azure Stack Hub updates.

For more information about update build types, see [Manage updates in Azure Stack Hub](azure-stack-updates.md).

### What's new

- The Azure Stack Hub infrastructure backup service now supports progressive backup. This feature helps reduce storage requirements on the external backup location, and changes the way files are organized on the external backup store. It is recommended that you do not manipulate files under the backup root directory.
- Azure Stack Hub managed disks now support Azure Disk APIs version **2019-07-01**, with a subset of the available features.
- Azure Stack Hub Storage now supports Azure Storage services management APIs version **2019-06-01**, with a subset of total available features.
- The Azure Stack Hub administrator portal now shows GPU-related information, including capacity data. This requires a GPU to be installed in the system.
- Users can now deploy all supported VM sizes, using Nvidia T4 via the Azure Stack Hub user portal.
- Azure Stack Hub operators can now configure multi-tenancy in Azure Stack Hub via the administrator portal. For more information, see [Configure multi-tenancy](enable-multitenancy.md).
- Azure Stack Hub operators can now configure a legal notice using the privileged endpoint. For more information, see [Configure Azure Stack Hub security controls](azure-stack-security-configuration.md#legal-notice-for-pep-sessions).
- During the update process, Granular Bitmap Repair (GBR), an optimization in the storage repair process, is introduced to repair out-of-sync data. Compared to the previous process, smaller segments are repaired, which leads to less repair time and a shorter overall update duration. GBR is enabled by default for all new deployments of 2102. For an update to 2102 from an earlier version (2008), GBR is enabled during the update. GBR requires that all physical disks are in a healthy state, so an extra validation was added in the **UpdateReadiness** check. Patch & update will fail at an early stage if the validation fails. At that point, a cloud admin must take action to resolve the disk problem before resuming the update. To follow up with the OEM, check the [OEM contact information](azure-stack-update-oem.md#oem-contact-information).
- Azure Stack Hub now supports new Dv3, Ev3, and SQL-specific D-series VM sizes.
- Azure Stack Hub now supports adding GPUs to any existing system. To add a GPU, execute **stop-azurestack**, run through the process of **stop-azurestack**, add GPUs, and then run **start-azurestack** until completion. If the system already had GPUs, then any previously created GPU VMs must be **stop-deallocated** and then re-started.
- Reduced OEM update time using the live update process.
- The AKS engine on Azure Stack Hub added the following new features. For details, see the release notes under the [AKS engine documentation](../user/azure-stack-kubernetes-aks-engine-overview.md):

  - General availability of Ubuntu 18.04.
  - Support for Kubernetes 1.17.17 and 1.18.15.
  - Certificate rotation command public preview.
  - CSI Driver Azure Disks public preview.
  - CSI Driver NFS public preview.
  - CSI Driver for Azure Blobs private preview.
  - T4 Nvidia GPU support private preview.
  - Azure Active Directory integration private preview.

### Improvements

- Increased the Network Controller log retention period, so the logs will be available for longer to help engineers in effective troubleshooting, even after an issue has been resolved.
- Improvements to preserve the Network Controller, Gateway VM, Load Balancer, and Host Agent logs during an update.
- Improved the deletion logic for networking resources that are blocked by a failed provisioning state.
- Reduced the XRP memory to 14 GB per VM and WAS memory to 10 GB per VM. By avoiding the increase in total VM memory footprint, more tenant VMs are deployable.
- The log collection HTML report, which gives a snapshot of the files on the stamp and diagnostic share, now has a summarized view of the collected files, roles, resource providers, and event information to better help understand the success and failure rate of the log collection process. 
- Added PowerShell cmdlets [Set-AzSLegalNotice](../reference/pep/set-azslegalnotice.md) and [Get-AzSLegalNotice](../reference/pep/get-azslegalnotice.md) to the privileged endpoint (PEP) to retrieve and update the content of the login banner text after deployment.
- Removed Active Directory Certificate Services (ADCS) and the CA VM entirely from Azure Stack Hub. This reduces the infrastructure footprint and saves up to 2 hours of update time.

### Changes

- The Fabric Resource Provider APIs now expose information about GPUs if available in the scale unit.
- Azure Stack Hub operators can now change the GPU partitioning ratio via PowerShell (AMD only). This requires all virtual machines to be deallocated.
- This build includes a new version of Azure Resource Manager.
- The Azure Stack Hub user portal now uses the full screen experience for load balancers, Network Security Groups, DNS zones, and disk and VM creation.
- In the 2102 release, the Windows Admin Center (WAC) is enabled on demand from an unlocked PEP session. By default, WAC is not enabled. To enable it, specify the `-EnableWac` flag; for example, `unlock-supportsession -EnableWac`.
- Proactive log collection now uses an improved algorithm, which captures logs during error conditions that aren't visible to an operator. This algorithm ensures that the correct diagnostic info is collected at the right time, without requiring any operator interaction. In some cases, Microsoft support can begin troubleshooting and resolving problems sooner. Initial algorithm improvements focus on patch and update operations. Enabling proactive log collections is recommended, as more operations are optimized and the benefits increase.
- There is a temporary increase of 10 GB of memory used by the Azure Stack Hub infrastructure.

### Fixes

- Fixed an issue in which internal DNS zones became out of sync during update, and caused the update to fail. This fix has been backported to 2008 and 2005 via hotfixes.
- Fixed an issue in which disk space was exhausted by logs on physical hosts, Network Controllers, Gateways and load balancers. This fix has been backported to 2008.
- Fixed an issue in which deletion of resource groups or virtual networks failed due to an orphaned resource in the Network Controller layer.
- Removed the **ND6s_dev** size from the VM size picker, as it is an unsupported VM size.
- Fixed an issue in which performing **Stop-Deallocate** on a VM results in an MTU configuration on the VM to be removed. This behavior was inconsistent with Azure.

## Security updates

For information about security updates in this update of Azure Stack Hub, see [Azure Stack Hub security updates](release-notes-security-updates.md).

## Hotfixes

Azure Stack Hub releases hotfixes regularly. Starting with the 2005 release, when you update to a new major version (for example, 1.2005.x to 1.2008.x), the latest hotfixes (if any) in the new major version are installed automatically. From that point forward, if a hotfix is released for your build, you should install it.

For more information, see our [servicing policy](azure-stack-servicing-policy.md).

Azure Stack Hub hotfixes are only applicable to Azure Stack Hub integrated systems; do not attempt to install hotfixes on the ASDK.

> [!NOTE]
> Azure Stack Hub hotfix releases are cumulative; you only need to install the latest hotfix to get all fixes included in any previous hotfix releases for that version.

### Hotfix prerequisites: before applying the 2102 update

The 2102 release of Azure Stack Hub must be applied on the 2008 release with the following hotfixes:

- [Azure Stack Hub hotfix 1.2008.40.156](hotfix-1-2008-40-156.md)

### After successfully applying the 2102 update

When you update to a new major version (for example, 1.2008.x to 1.2102.x), the latest hotfixes (if any) in the new major version are installed automatically. From that point forward, if a hotfix is released for your build, you should install it.

After the installation of 2102, if any hotfixes for 2102 are subsequently released, you should install them:

- [Azure Stack Hub hotfix 1.2102.30.118](hotfix-1-2102-30-118.md)
::: moniker-end

::: moniker range="azs-2008"
## 2008 build reference

The latest Azure Stack Hub 2008 update build number is **1.2008.40.149**. For updated build and hotfix information, see the [Hotfixes](#hotfixes-1) section.

### Update type

The Azure Stack Hub 2008 update build type is **Full**.

The 2008 update package is larger in size compared to previous updates. The increased size results in longer download times. The update will remain in the **Preparing** state for a long time, and operators can expect this process to take longer than with previous updates. The 2008 update has had the following expected runtimes in our internal testing- 4 nodes: 13-20 hours, 8 nodes: 16-26 hours, 12 nodes: 19-32 hours, 16 nodes: 22-38 hours. Exact update runtimes typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware specifications. Runtimes that are shorter or longer than the expected value are not uncommon and do not require action by Azure Stack Hub operators unless the update fails. This runtime approximation is specific to the 2008 update and should not be compared to other Azure Stack Hub updates.

For more information about update build types, see [Manage updates in Azure Stack Hub](azure-stack-updates.md).

### What's new

- Azure Stack Hub now supports VNET peering, which gives the ability to connect VNETs without a Network Virtual Appliance (NVA). For more information, see the [new VNET peering documentation](../user/virtual-network-peering.md).
- Azure Stack Hub blob storage now enables users to use an immutable blob. By setting immutable policies on a container, you can store business-critical data objects in a WORM (Write Once, Read Many) state. In this release, immutable policies can only be set through the REST API or client SDKs. Append blob writes are also not possible in this release. For more information about immutable blobs, see [Store business-critical blob data with immutable storage](/azure/storage/blobs/storage-blob-immutable-storage).
- Azure Stack Hub Storage now supports Azure Storage services APIs version **2019-07-07**. For Azure client libraries that is compatible with the new REST API version, see [Azure Stack Hub storage development tools](../user/azure-stack-storage-dev.md#azure-client-libraries). For Azure Storage services management APIs, **2018-02-01** has been add of support, with a subset of total available features.
- Azure Stack Hub compute now supports Azure Compute APIs version **2020-06-01**, with a subset of total available features.
- Azure Stack Hub managed disks now support Azure Disk APIs version **2019-03-01**, with a subset of the available features.
- Preview of Windows Admin Center that can now connect to Azure Stack Hub to provide in-depth insights into the infrastructure during support operations (break-glass required).
- Ability to add login banner to the privileged endpoint (PEP) at deployment time.
- Released more **Exclusive Operations** banners, which improve the visibility of operations that are currently happening on the system, and disable users from initiating (and later failing) any other exclusive operation.
- Introduced two new banners in each Azure Stack Hub Marketplace item's product page. If there is a Marketplace download failure, operators can view error details and attempt recommended steps to resolve the issue.
- Released a rating tool for customers to provide feedback. This will enable Azure Stack Hub to measure and optimize the customer experience.
- This release of Azure Stack Hub includes a private preview of Azure Kubernetes Service (AKS) and Azure Container Registry (ACR). The purpose of the private preview is to collect feedback about the quality, features, and user experience of AKS and ACR on Azure Stack Hub.
- This release includes a public preview of Azure CNI and Windows Containers using [AKS Engine v0.55.4](../user/kubernetes-aks-engine-release-notes.md). For an example of how to use them in your API model, [see this example on GitHub](https://raw.githubusercontent.com/Azure/aks-engine/master/examples/azure-stack/kubernetes-windows.json).
- There is now support for [Istio 1.3 deployment](https://github.com/Azure/aks-engine/tree/master/examples/service-mesh) on clusters deployed by [AKS Engine v0.55.4](../user/kubernetes-aks-engine-release-notes.md). For more information, [see the instructions here](../user/kubernetes-aks-engine-service-account.md).
- There is now support for deployment of [private clusters](https://github.com/Azure/aks-engine/blob/master/docs/topics/features.md#private-cluster) using [AKS Engine v0.55.4](../user/kubernetes-aks-engine-release-notes.md).
- This release includes support for [sourcing Kubernetes configuration secrets](https://github.com/Azure/aks-engine/blob/master/docs/topics/keyvault-secrets.md#use-key-vault-as-the-source-of-cluster-configuration-secrets) from Azure and Azure Stack Hub Key Vault instances.

### Improvements

- Implemented internal monitoring for Network Controller and SLB host agents, so the services are auto-remediated if they ever enter into a stopped state.
- Active Directory Federation Services (AD FS) now retrieves the new token signing certificate after the customer has rotated it on their own AD FS server. To take advantage of this new capability for already configured systems, the AD FS integration must be configured again. For more information, see [Integrate AD FS identity with your Azure Stack Hub datacenter](azure-stack-integrate-identity.md).
- Changes to the startup and shutdown process on infrastructure role instances and their dependencies on scale unit nodes. These changes increase the reliability for Azure Stack Hub startup and shutdown.
- The **AzSScenarios** suite of the **Test-AzureStack** validation tool has been updated to enable Cloud Service Providers to run this suite successfully with multi-factor authentication enforced on all customer accounts.
- Improved alert reliability by adding suppression logic for 29 customer facing alerts during lifecycle operations.
- You can now view a detailed log collection HTML report that provides details on the roles, duration, and status of the log collection. The purpose of this report is to help users provide a summary of the logs collected. Microsoft Customer Support Services can then quickly assess the report to evaluate the log data, and help to troubleshoot and mitigate system issues.
- The infrastructure fault detection coverage has been expanded with the addition of 7 new monitors across user scenarios such as CPU utilization and memory consumption, which helps to increase the reliability of fault detection.

### Changes

- The **supportHttpsTrafficOnly** storage account resource type property in SRP API version **2016-01-01** and **2016-05-01** has been enabled, but this property is not supported in Azure Stack Hub.
- Raised volume capacity utilization alert threshold from 80% (warning) and 90% (critical) to 90% (warning) and 95% (critical). For more information, see [Storage space alerts](azure-stack-manage-storage-shares.md#storage-space-alerts)
- The AD Graph configuration steps change with this release. For more information, see [Integrate AD FS identity with your Azure Stack Hub datacenter](azure-stack-integrate-identity.md).
- To align to the current best practices defined for Windows Server 2019, Azure Stack Hub is changing to use an additional traffic class or priority to further separate server-to-server communication in support of the Failover Clustering control communication. The result of these changes provides better resiliency for Failover Cluster communication. This traffic class and bandwidth reservation configuration is accomplished by a change on the top-of-rack (ToR) switches of the Azure Stack Hub solution and on the host or servers of Azure Stack Hub.

  These changes are added at the host level of an Azure Stack Hub system. Contact your OEM to make the change at the top-of-rack (ToR) network switches. This ToR change can be performed either prior to updating to the 2008 release or after updating to 2008. For more information, see the [Network Integration documentation](azure-stack-network.md).

- The GPU capable VM sizes **NCas_v4 (NVIDIA T4)** have been replaced in this build with the VM sizes **NCasT4_v3**, to be consistent with Azure. Those are not visible in the portal yet, and can only be used via Azure Resource Manager templates.

### Fixes

- Fixed an issue in which deleting an NSG of a NIC that is not attached to a running VM failed.
- Fixed an issue in which modifying the **IdleTimeoutInMinutes** value for a public IP that is associated to a load balancer put the public IP in a failed state.
- Fixed the **Get-AzsDisk** cmdlet to return the correct **Attached** status, instead of **OnlineMigration**, for attached managed disks.

## Security updates

For information about security updates in this update of Azure Stack Hub, see [Azure Stack Hub security updates](release-notes-security-updates.md).

## Hotfixes

Azure Stack Hub releases hotfixes regularly. Make sure you install the latest 2005 hotfix before updating to 2008. Also, starting with the 2005 release, when you update to a new major version (for example, 1.2005.x to 1.2008.x), the latest hotfixes (if any are available at the time of package download) in the new major version are installed automatically. Your 2008 installation is then current with all hotfixes. From that point forward, if a hotfix is released for 2008, you should install it.

> [!NOTE]
> Azure Stack Hub hotfix releases are cumulative; you only need to install the latest hotfix to get all fixes included in any previous hotfix releases for that version.

For more information, see our [servicing policy](azure-stack-servicing-policy.md).

Azure Stack Hub hotfixes are only applicable to Azure Stack Hub integrated systems; do not attempt to install hotfixes on the ASDK.

> [!TIP]
> If you want to be notified about each hotfix release, subscribe to the [**RSS feed**](https://azurestackhubdocs.azurewebsites.net/xml/hotfixes.rss) to be notified about each hotfix release.

### After successfully applying the 2008 update

Because Azure Stack Hub hotfixes are cumulative, as a best practice you should install all hotfixes released for your build, to ensure the best update experience between major releases. When you update to a new major version (for example, 1.2005.x to 1.2008.x), the latest hotfixes (if any are available at the time of package download) in the new major version are installed automatically.

After the installation of 2008, if any 2008 hotfixes are subsequently released, you should install them:

- [Azure Stack Hub hotfix 1.2008.40.156](hotfix-1-2008-40-156.md)
::: moniker-end

<!------------------------------------------------------------>
<!------------------- UNSUPPORTED VERSIONS ------------------->
<!------------------------------------------------------------>
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

::: moniker range="<azs-2008"
You can access older versions of Azure Stack Hub release notes in the table of contents on the left side, under [Resources > Release notes archive](./relnotearchive/release-notes.md). Select the desired archived version from the version selector dropdown in the upper left. These archived articles are provided for reference purposes only and do not imply support for these versions. For information about Azure Stack Hub support, see [Azure Stack Hub servicing policy](azure-stack-servicing-policy.md). For further assistance, contact Microsoft Customer Support Services.
::: moniker-end
