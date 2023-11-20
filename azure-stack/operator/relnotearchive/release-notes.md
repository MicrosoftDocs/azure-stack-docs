---
title: Azure Stack Hub archived release notes 
description: Archived release notes for Azure Stack Hub integrated systems, including updates and bug fixes.
author: sethmanheim

ms.topic: article
ms.date: 05/25/2023
ms.author: sethm
ms.reviewer: thoroet
ms.lastreviewed: 09/09/2020
ROBOTS: NOINDEX
---

# Azure Stack Hub archived release notes

This article describes the contents of Azure Stack Hub update packages. The update includes improvements and fixes for this release of Azure Stack Hub.

To access release notes for a different archived version, use the version selector dropdown above the table of contents on the left.

<!---------------------------------------------------------->
<!------------------- SUPPORTED VERSIONS ------------------->
<!---------------------------------------------------------->

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

For more information about update build types, see [Manage updates in Azure Stack Hub](../azure-stack-updates.md).

### What's new

- This release includes a public preview of remote support, which enables a Microsoft support professional to solve your support case faster by permitting access to your device remotely and performing limited troubleshooting and repair. You can enable this feature by granting consent, while controlling the access level and duration of access. Support can only access your device after a support request has been submitted. For more information, see [Remote support for Azure Stack Hub](../remote-support.md).
- The Azure Stack Hub infrastructure backup service now supports progressive backup. This feature helps reduce storage requirements on the external backup location, and changes the way files are organized on the external backup store. It is recommended that you do not manipulate files under the backup root directory.
- Azure Stack Hub managed disks now support Azure Disk APIs version **2019-07-01**, with a subset of the available features.
- Azure Stack Hub Storage now supports Azure Storage services management APIs version **2019-06-01**, with a subset of total available features.
- The Azure Stack Hub administrator portal now shows GPU-related information, including capacity data. This requires a GPU to be installed in the system.
- Users can now deploy all supported VM sizes, using Nvidia T4 via the Azure Stack Hub user portal.
- Azure Stack Hub operators can now configure multi-tenancy in Azure Stack Hub via the administrator portal. For more information, see [Configure multi-tenancy](../enable-multitenancy.md).
- Azure Stack Hub operators can now configure a legal notice using the privileged endpoint. For more information, see [Configure Azure Stack Hub security controls](../azure-stack-security-configuration.md#legal-notice-for-pep-sessions).
- During the update process, Granular Bitmap Repair (GBR), an optimization in the storage repair process, is introduced to repair out-of-sync data. Compared to the previous process, smaller segments are repaired, which leads to less repair time and a shorter overall update duration. GBR is enabled by default for all new deployments of 2102. For an update to 2102 from an earlier version (2008), GBR is enabled during the update. GBR requires that all physical disks are in a healthy state, so an extra validation was added in the **UpdateReadiness** check. Patch & update will fail at an early stage if the validation fails. At that point, a cloud admin must take action to resolve the disk problem before resuming the update. To follow up with the OEM, check the [OEM contact information](../azure-stack-update-oem.md#oem-contact-information).
- Azure Stack Hub now supports new Dv3, Ev3, and SQL-specific D-series VM sizes.
- Azure Stack Hub now supports adding GPUs to any existing system. To add a GPU, execute **stop-azurestack**, run through the process of **stop-azurestack**, add GPUs, and then run **start-azurestack** until completion. If the system already had GPUs, then any previously created GPU VMs must be **stop-deallocated** and then re-started.
- Reduced OEM update time using the live update process.
- The AKS engine on Azure Stack Hub added the following new features. For details, see the release notes under the [AKS engine documentation](../../user/azure-stack-kubernetes-aks-engine-overview.md):

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
- Added PowerShell cmdlets [Set-AzSLegalNotice](../../reference/pep/set-azslegalnotice.md) and [Get-AzSLegalNotice](../../reference/pep/get-azslegalnotice.md) to the privileged endpoint (PEP) to retrieve and update the content of the login banner text after deployment.
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

For information about security updates in this update of Azure Stack Hub, see [Azure Stack Hub security updates](../release-notes-security-updates.md).

## Hotfixes

Azure Stack Hub releases hotfixes regularly. Starting with the 2005 release, when you update to a new major version (for example, 1.2005.x to 1.2008.x), the latest hotfixes (if any) in the new major version are installed automatically. From that point forward, if a hotfix is released for your build, you should install it.

For more information, see our [servicing policy](../azure-stack-servicing-policy.md).

Azure Stack Hub hotfixes are only applicable to Azure Stack Hub integrated systems; do not attempt to install hotfixes on the ASDK.

> [!NOTE]
> Azure Stack Hub hotfix releases are cumulative; you only need to install the latest hotfix to get all fixes included in any previous hotfix releases for that version.

### Hotfix prerequisites: before applying the 2102 update

The 2102 release of Azure Stack Hub must be applied on the 2008 release with the following hotfixes:

- [Azure Stack Hub hotfix 1.2008.41.161](../hotfix-1-2008-41-161.md)

### After successfully applying the 2102 update

When you update to a new major version (for example, 1.2008.x to 1.2102.x), the latest hotfixes (if any) in the new major version are installed automatically. From that point forward, if a hotfix is released for your build, you should install it.

After the installation of 2102, if any hotfixes for 2102 are subsequently released, you should install them:

- [Azure Stack Hub hotfix 1.2102.30.148](../hotfix-1-2102-30-148.md)
::: moniker-end

::: moniker range=">azs-2108"
## Release notes for supported versions

Release notes for supported versions of Azure Stack Hub can be found under [Overview > Release notes](../release-notes.md)
::: moniker-end

<!------------------------------------------------------------>
<!------------------- UNSUPPORTED VERSIONS ------------------->
<!------------------------------------------------------------>
::: moniker range="<=azs-2108"
> [!IMPORTANT]  
> This update package is only for Azure Stack Hub integrated systems. Do not apply this update package to the Azure Stack Development Kit (ASDK).

> [!IMPORTANT]  
> If your Azure Stack Hub instance is behind by more than two updates, it's considered out of compliance. You must [update to at least the minimum supported version to receive support](../azure-stack-servicing-policy.md#keep-your-system-under-support).
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

For more information about update build types, see [Manage updates in Azure Stack Hub](../azure-stack-updates.md).

### What's new

- Azure Stack Hub operators can now configure GPU quotas for VMs.
- [Emergency VM Access](../../user/emergency-vm-access.md) is now available in Azure Stack Hub without contacting Microsoft Support.
- Windows Server 2022 is now supported as a guest operating system. Windows Server 2022 VMs must be manually activated using [Automatic Virtual Machine Activation](/windows-server/get-started/automatic-vm-activation) in Windows Server on Azure Stack Hub running version 2108 or later. It cannot be activated on previous versions.
- Starting with this version, if proactive log collection is disabled, logs are captured and stored locally for proactive failure events. The local logs can only be accessed by Microsoft in the context of a support case. New alerts have been added to the proactive log collection **Alert** library.
- Two new services, [Azure Kubernetes Service](../../user/aks-overview.md) and [Azure Container Registry](../../user/container-registry-overview.md), are available in public preview with this release.
- [**AzureStack** module 2.2.0](/azure-stack/operator?view=azurestackps-2.2.0&preserve-view=true) is released to align with Azure Stack Hub version 2108. The version update includes changes in compute administrator module and new modules `Azs.ContainerRegistry.Admin` and `Azs.ContainerService.Admin`. For more information, see the [change log](https://github.com/Azure/azurestack-powershell/blob/release-2108/src/changelog.md).
- With this release, telemetry data is uploaded to an Azure Storage account that's managed and controlled by Microsoft. Azure Stack Hub telemetry service connects to `https://*.blob.core.windows.net/` and `https://azsdiagprdwestusfrontend.westus.cloudapp.azure.com/` for a successful telemetry data upload to Microsoft. Port 443 (HTTPS) must be opened. For more information, see [Azure Stack Hub telemetry](../azure-stack-telemetry.md).
- This release includes a public preview of remote support, which enables a Microsoft support professional to solve your support case faster by permitting access to your device remotely and performing limited troubleshooting and repair. You can enable this feature by granting consent, while controlling the access level and duration of access. Support can only access your device after a support request has been submitted. For more information, see [Remote support for Azure Stack Hub](../remote-support.md).

### Improvements

- When the external SMB share is almost full, the alert description has been adjusted to align with progressive backup.
- To prevent upload failures, the number of parallel infrastructure backup repository uploads to the external SMB share is now limited.
- Replaced **Node-Inaccessible-for-vm-placement** alert with alerts to distinguish between **host-unresponsive** scenarios and **hostagent-service-on-node-unresponsive** scenarios.
- App Service now has the ability to discover the default NAT IP for outbound connections.

### Changes

- Before starting the 2108 update, you must stop (deallocate) all virtual machines that use a GPU, to ensure the update can complete successfully. This applies to AMD and NVIDIA GPUs, as the underlying implementation changes to no pooled resources.
- SQL RP and MySQL RP are only available to subscriptions that have been granted access. If you want to start using these resource providers, or need to upgrade from a previous version, [open a support case](../azure-stack-help-and-support-overview.md), and Microsoft support engineers can help you with the deployment or upgrade process.
- **Set-AzSLegalNotice** now triggers the appearance of a new screen that contains the caption and the text that were set when running the command. This screen appears every time a new instance of the portal is created.

### Fixes

- Fixed an issue in which one repository failure when uploading to the external SMB share caused the entire infrastructure backup to fail.
- Fixed an issue that caused N series VMs with multiple GPUs to fail creation.
- Fixed an issue in which uninstalling a VM extension nulls out protected settings for existing VM extensions.
- Fixed an issue that caused internal load balancers to use external IPs.
- Fixed an issue downloading serial logs from the portal.

## Security updates

For information about security updates in this update of Azure Stack Hub, see [Azure Stack Hub security updates](../release-notes-security-updates.md).

## Hotfixes

Azure Stack Hub releases hotfixes regularly. Starting with the 2005 release, when you update to a new major version (for example, 1.2005.x to 1.2008.x), the latest hotfixes (if any) in the new major version are installed automatically. From that point forward, if a hotfix is released for your build, you should install it.

> [!NOTE]
> Azure Stack Hub hotfix releases are cumulative; you only need to install the latest hotfix to get all fixes included in any previous hotfix releases for that version.

For more information about hotfixes, see our [servicing policy](../azure-stack-servicing-policy.md).

Azure Stack Hub hotfixes are only applicable to Azure Stack Hub integrated systems; do not attempt to install hotfixes on the ASDK.

### Hotfix prerequisites: before applying the 2108 update

The 2108 release of Azure Stack Hub must be applied on the 2102 release with the following hotfixes:

- [Azure Stack Hub hotfix 1.2102.31.153](../hotfix-1-2102-31-153.md)

### After successfully applying the 2108 update

When you update to a new major version (for example, 1.2102.x to 1.2108.x), the latest hotfixes (if any) in the new major version are installed automatically. From that point forward, if a hotfix is released for your build, you should install it.

After the installation of 2108, if any hotfixes for 2108 are subsequently released, you should install them:

- [Azure Stack Hub hotfix 1.2108.2.130](../hotfix-1-2108-2-130.md)
::: moniker-end

::: moniker range="azs-2008"
## 2008 build reference

The latest Azure Stack Hub 2008 update build number is **1.2008.40.149**. For updated build and hotfix information, see the [Hotfixes](#hotfixes-1) section.

### Update type

The Azure Stack Hub 2008 update build type is **Full**.

The 2008 update package is larger in size compared to previous updates. The increased size results in longer download times. The update will remain in the **Preparing** state for a long time, and operators can expect this process to take longer than with previous updates. The 2008 update has had the following expected runtimes in our internal testing- 4 nodes: 13-20 hours, 8 nodes: 16-26 hours, 12 nodes: 19-32 hours, 16 nodes: 22-38 hours. Exact update runtimes typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware specifications. Runtimes that are shorter or longer than the expected value are not uncommon and do not require action by Azure Stack Hub operators unless the update fails. This runtime approximation is specific to the 2008 update and should not be compared to other Azure Stack Hub updates.

For more information about update build types, see [Manage updates in Azure Stack Hub](../azure-stack-updates.md).

### What's new

- Azure Stack Hub now supports VNET peering, which gives the ability to connect VNETs without a Network Virtual Appliance (NVA). For more information, see the [new VNET peering documentation](../../user/virtual-network-peering.md).
- Azure Stack Hub blob storage now enables users to use an immutable blob. By setting immutable policies on a container, you can store business-critical data objects in a WORM (Write Once, Read Many) state. In this release, immutable policies can only be set through the REST API or client SDKs. Append blob writes are also not possible in this release. For more information about immutable blobs, see [Store business-critical blob data with immutable storage](/azure/storage/blobs/storage-blob-immutable-storage).
- Azure Stack Hub Storage now supports Azure Storage services APIs version **2019-07-07**. For Azure client libraries that is compatible with the new REST API version, see [Azure Stack Hub storage development tools](../../user/azure-stack-storage-dev.md#azure-client-libraries). For Azure Storage services management APIs, **2018-02-01** has been add of support, with a subset of total available features.
- Azure Stack Hub compute now supports Azure Compute APIs version **2020-06-01**, with a subset of total available features.
- Azure Stack Hub managed disks now support Azure Disk APIs version **2019-03-01**, with a subset of the available features.
- Preview of Windows Admin Center that can now connect to Azure Stack Hub to provide in-depth insights into the infrastructure during support operations (break-glass required).
- Ability to add login banner to the privileged endpoint (PEP) at deployment time.
- Released more **Exclusive Operations** banners, which improve the visibility of operations that are currently happening on the system, and disable users from initiating (and later failing) any other exclusive operation.
- Introduced two new banners in each Azure Stack Hub Marketplace item's product page. If there is a Marketplace download failure, operators can view error details and attempt recommended steps to resolve the issue.
- Released a rating tool for customers to provide feedback. This will enable Azure Stack Hub to measure and optimize the customer experience.
- This release of Azure Stack Hub includes a private preview of Azure Kubernetes Service (AKS) and Azure Container Registry (ACR). The purpose of the private preview is to collect feedback about the quality, features, and user experience of AKS and ACR on Azure Stack Hub.
- This release includes a public preview of Azure CNI and Windows Containers using [AKS Engine v0.55.4](../../user/kubernetes-aks-engine-release-notes.md). For an example of how to use them in your API model, [see this example on GitHub](https://raw.githubusercontent.com/Azure/aks-engine/master/examples/azure-stack/kubernetes-windows.json).
- There is now support for [Istio 1.3 deployment](https://github.com/Azure/aks-engine/tree/master/examples/service-mesh) on clusters deployed by [AKS Engine v0.55.4](../../user/kubernetes-aks-engine-release-notes.md). For more information, [see the instructions here](../../user/kubernetes-aks-engine-service-account.md).
- There is now support for deployment of [private clusters](https://github.com/Azure/aks-engine/blob/master/docs/topics/features.md#private-cluster) using [AKS Engine v0.55.4](../../user/kubernetes-aks-engine-release-notes.md).
- This release includes support for [sourcing Kubernetes configuration secrets](https://github.com/Azure/aks-engine/blob/master/docs/topics/keyvault-secrets.md#use-key-vault-as-the-source-of-cluster-configuration-secrets) from Azure and Azure Stack Hub Key Vault instances.

### Improvements

- Implemented internal monitoring for Network Controller and SLB host agents, so the services are auto-remediated if they ever enter into a stopped state.
- Active Directory Federation Services (AD FS) now retrieves the new token signing certificate after the customer has rotated it on their own AD FS server. To take advantage of this new capability for already configured systems, the AD FS integration must be configured again. For more information, see [Integrate AD FS identity with your Azure Stack Hub datacenter](../azure-stack-integrate-identity.md).
- Changes to the startup and shutdown process on infrastructure role instances and their dependencies on scale unit nodes. These changes increase the reliability for Azure Stack Hub startup and shutdown.
- The **AzSScenarios** suite of the **Test-AzureStack** validation tool has been updated to enable Cloud Service Providers to run this suite successfully with multi-factor authentication enforced on all customer accounts.
- Improved alert reliability by adding suppression logic for 29 customer facing alerts during lifecycle operations.
- You can now view a detailed log collection HTML report that provides details on the roles, duration, and status of the log collection. The purpose of this report is to help users provide a summary of the logs collected. Microsoft Customer Support Services can then quickly assess the report to evaluate the log data, and help to troubleshoot and mitigate system issues.
- The infrastructure fault detection coverage has been expanded with the addition of 7 new monitors across user scenarios such as CPU utilization and memory consumption, which helps to increase the reliability of fault detection.

### Changes

- The **supportHttpsTrafficOnly** storage account resource type property in SRP API version **2016-01-01** and **2016-05-01** has been enabled, but this property is not supported in Azure Stack Hub.
- Raised volume capacity utilization alert threshold from 80% (warning) and 90% (critical) to 90% (warning) and 95% (critical). For more information, see [Storage space alerts](../azure-stack-manage-storage-shares.md#storage-space-alerts)
- The AD Graph configuration steps change with this release. For more information, see [Integrate AD FS identity with your Azure Stack Hub datacenter](../azure-stack-integrate-identity.md).
- To align to the current best practices defined for Windows Server 2019, Azure Stack Hub is changing to use an additional traffic class or priority to further separate server-to-server communication in support of the Failover Clustering control communication. The result of these changes provides better resiliency for Failover Cluster communication. This traffic class and bandwidth reservation configuration is accomplished by a change on the top-of-rack (ToR) switches of the Azure Stack Hub solution and on the host or servers of Azure Stack Hub.

  These changes are added at the host level of an Azure Stack Hub system. Contact your OEM to make the change at the top-of-rack (ToR) network switches. This ToR change can be performed either prior to updating to the 2008 release or after updating to 2008. For more information, see the [Network Integration documentation](../azure-stack-network.md).

- The GPU capable VM sizes **NCas_v4 (NVIDIA T4)** have been replaced in this build with the VM sizes **NCasT4_v3**, to be consistent with Azure. Those are not visible in the portal yet, and can only be used via Azure Resource Manager templates.

### Fixes

- Fixed an issue in which deleting an NSG of a NIC that is not attached to a running VM failed.
- Fixed an issue in which modifying the **IdleTimeoutInMinutes** value for a public IP that is associated to a load balancer put the public IP in a failed state.
- Fixed the **Get-AzsDisk** cmdlet to return the correct **Attached** status, instead of **OnlineMigration**, for attached managed disks.

## Security updates

For information about security updates in this update of Azure Stack Hub, see [Azure Stack Hub security updates](../release-notes-security-updates.md).

## Hotfixes

Azure Stack Hub releases hotfixes regularly. Make sure you install the latest 2005 hotfix before updating to 2008. Also, starting with the 2005 release, when you update to a new major version (for example, 1.2005.x to 1.2008.x), the latest hotfixes (if any are available at the time of package download) in the new major version are installed automatically. Your 2008 installation is then current with all hotfixes. From that point forward, if a hotfix is released for 2008, you should install it.

> [!NOTE]
> Azure Stack Hub hotfix releases are cumulative; you only need to install the latest hotfix to get all fixes included in any previous hotfix releases for that version.

For more information, see our [servicing policy](../azure-stack-servicing-policy.md).

Azure Stack Hub hotfixes are only applicable to Azure Stack Hub integrated systems; do not attempt to install hotfixes on the ASDK.

> [!TIP]
> If you want to be notified about each hotfix release, subscribe to the [**RSS feed**](https://azurestackhubdocs.azurewebsites.net/xml/hotfixes.rss) to be notified about each hotfix release.

### After successfully applying the 2008 update

Because Azure Stack Hub hotfixes are cumulative, as a best practice you should install all hotfixes released for your build, to ensure the best update experience between major releases. When you update to a new major version (for example, 1.2005.x to 1.2008.x), the latest hotfixes (if any are available at the time of package download) in the new major version are installed automatically.

After the installation of 2008, if any 2008 hotfixes are subsequently released, you should install them:

- [Azure Stack Hub hotfix 1.2008.40.154](../hotfix-1-2008-40-154.md)
::: moniker-end

::: moniker range="azs-2005"
## 2005 archived release notes

The Azure Stack Hub 2005 update build number is **1.2005.6.53**.

### Update type

The Azure Stack Hub 2005 update build type is **Full**.

The 2005 update package is larger in size compared to previous updates. The increased size results in longer download times. The update will remain in the **Preparing** state for a long time, and operators can expect this process to take longer than with previous updates. The 2005 update has had the following expected runtimes in our internal testing- 4 nodes: 13-20 hours, 8 nodes: 16-26 hours, 12 nodes: 19-32 hours, 16 nodes: 22-38 hours. Exact update runtimes typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware specifications. Runtimes that are shorter or longer than the expected value are not uncommon and do not require action by Azure Stack Hub operators unless the update fails. This runtime approximation is specific to the 2005 update and should not be compared to other Azure Stack Hub updates.

For more information about update build types, see [Manage updates in Azure Stack Hub](../azure-stack-updates.md).

### What's new

- This build offers support for 3 new GPU VM types: NCv3 (Nvidia V100), NVv4 (AMD MI25), and NCas_v4 (NVIDIA T4) VM sizes. VM deployments will be successful for those who have the right hardware and are onboarded to the Azure Stack Hub GPU preview program. If you are interested, sign up for the GPU preview program at https://aka.ms/azurestackhubgpupreview. For more information, [see](../../user/gpu-vms-about.md).
- This release provides a new feature that enables an autonomous healing capability, which detects faults, assesses impact, and safely mitigates system issues. With this feature, we are working towards increased availability of the system without manual intervention. With release 2005 and later, customers will experience a reduction in the number of alerts. Any failure in this pipeline doesn't require action by Azure Stack Hub operators unless notified.
- There is a new option in the Azure Stack Hub admin portal for air-gapped/disconnected Azure Stack Hub customers, to save logs locally. You can store the logs in a local SMB share when Azure Stack Hub is disconnected from Azure.
- The Azure Stack Hub admin portal now blocks certain operations if a system operation is already in progress. For example, if an update is in progress, it is not possible to add a new scale unit node.
- This release provides more fabric consistency with Azure on VMs created pre-1910. In 1910, Microsoft announced that all newly created VMs will use the wireserver protocol, enabling customers to use the same WALA agent and Windows guest agent as Azure, making it easier to use Azure images on Azure Stack Hub. With this release, all VMs created earlier than 1910 are automatically migrated to use the wireserver protocol. This also brings more reliable VM creation, VM extension deployment, and improvements in steady state uptime.
- Azure Stack Hub storage now supports Azure Storage services APIs version 2019-02-02. For Azure client libraries, that is compatible with the new REST API version. For more information, see [Azure Stack Hub storage development tools](../../user/azure-stack-storage-dev.md#azure-client-libraries).
- Azure Stack Hub now supports the latest version of [CreateUiDefinition (version 2)](/azure/azure-resource-manager/managed-applications/create-uidefinition-overview).
- New guidance for batched VM deployments. For more information, [see this article](../azure-stack-capacity-planning-compute.md).
- The Azure Stack Hub Marketplace CoreOS Container Linux item [is approaching its end-of-life](https://azure.microsoft.com/updates/flatcar-in-azure/). For more information, see [Migrating from CoreOS Container Linux](https://www.flatcar.org/docs/latest/migrating-from-coreos/).

### Improvements

- Improvements to Storage infrastructure cluster service logs and events. Logs and events of Storage infrastructure cluster service will be kept for up to 14 days, for better diagnostics and troubleshooting.
- Improvements that increase reliability of starting and stopping Azure Stack Hub.
- Improvements that reduce the update runtime by using decentralization and removing dependencies. Compared to the 2002 update, the 4 nodes stamp update time is reduced from 15-42 hours to 13-20 hours. 8 nodes is reduced from 20-50 hours to 16-26 hours. 12 nodes is reduced from 20-60 hours to 19-32 hours. 16 nodes is reduced from 25-70 hours to 22-38 hours. Exact update runtimes typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware specifications.
- The update now fails early if there are certain unrecoverable errors.
- Improved resiliency of the update package while downloading from the internet.
- Improved resiliency of stop-deallocating a VM.
- Improved resiliency of the Network Controller Host Agent.
- Added more fields to the CEF payload of the syslog messages to report the source IP and the account used to connect to the privileged endpoint and the recovery endpoint. See [Integrate Azure Stack Hub with monitoring solutions using syslog forwarding](../azure-stack-integrate-security.md) for details.
- Added Windows Defender events (Event IDs 5001, 5010, 5012) to the list of events emitted via the syslog client.
- Added alerts in the Azure Stack Administrator portal for Windows Defender-related events, to report on Defender platform and signatures version inconsistencies and failure to take actions on detected malware.
- Added support for 4 Border Devices when integrating Azure Stack Hub into your datacenter.

### Changes

- Removed the actions to stop, shut down, and restart an infrastructure role instance from the admin portal. The corresponding APIs have also been removed in the Fabric Resource Provider. The following PowerShell cmdlets in the admin RM module and AZ preview for Azure Stack Hub no longer work: **Stop-AzsInfrastructureRoleInstance**, **Disable-InfrastructureRoleInstance**, and **Restart-InfrastructureRoleInstance**. These cmdlets will be removed from the next admin AZ module release for Azure Stack Hub.
- Azure Stack Hub 2005 now only supports [App Service on Azure Stack Hub 2020 (versions 87.x)](../app-service-release-notes-2020-Q2.md).
- The user encryption setting that is required for hardware monitoring was changed from DES to AES to increase security. Please reach out to your hardware partner to learn how to change the setting in the base board management controller (BMC). After the change is made in the BMC, it may require you to run the command **Set-BmcCredential** again using the privileged endpoint. For more information, see [Rotate secrets in Azure Stack Hub](../azure-stack-rotate-secrets.md)

### Fixes

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

For information about security updates in this update of Azure Stack Hub, see [Azure Stack Hub security updates](../release-notes-security-updates.md).

## Hotfixes

Azure Stack Hub releases hotfixes regularly. Starting with the 2005 release, when you update to a new major version (for example, 1.2002.x to 1.2005.x), the latest hotfixes (if any) in the new major version are installed automatically. From that point forward, if a hotfix is released for your build, you should install it.

> [!NOTE]
> Azure Stack Hub hotfix releases are cumulative; you only need to install the latest hotfix to get all fixes included in any previous hotfix releases for that version.

For more information, see our [servicing policy](../azure-stack-servicing-policy.md).

Azure Stack Hub hotfixes are only applicable to Azure Stack Hub integrated systems; do not attempt to install hotfixes on the ASDK.

### Prerequisites: Before applying the 2005 update

The 2005 release of Azure Stack Hub must be applied on the 2002 release with the following hotfixes:

- [Azure Stack Hub hotfix 1.2002.66.173](../hotfix-1-2002-67-175.md)

### After successfully applying the 2005 update

Starting with the 2005 release, when you update to a new major version (for example, 1.2002.x to 1.2005.x), the latest hotfixes (if any) in the new major version are installed automatically.

After the installation of 2005, if any 2005 hotfixes are subsequently released, you should install them:

- [Azure Stack Hub hotfix 1.2005.35.112](../hotfix-1-2005-35-112.md)
::: moniker-end

::: moniker range="azs-2002"
## 2002 archived release notes

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
- [Azure Stack Hub hotfix 1.2002.68.177](../hotfix-1-2002-69-179.md)
::: moniker-end

::: moniker range="azs-1910"
## 1910 archived release notes
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

## 1910 build reference

The Azure Stack Hub 1910 update build number is **1.1910.0.58**.

### Update type

Starting with 1908, the underlying operating system on which Azure Stack Hub runs was updated to Windows Server 2019. This update enables core fundamental enhancements and the ability to bring additional capabilities to Azure Stack Hub.

The Azure Stack Hub 1910 update build type is **Express**.

The 1910 update package is larger in size compared to previous updates, which results in longer download times. The update will remain in the **Preparing** state for a long time and operators can expect this process to take longer than previous updates. The expected time for the 1910 update to complete is approximately 10 hours, regardless of the number of physical nodes in your Azure Stack Hub environment. Exact update runtimes typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware specifications. Runtimes lasting longer than the expected value aren't uncommon and don't require action by Azure Stack Hub operators unless the update fails. This runtime approximation is specific to the 1910 update and shouldn't be compared to other Azure Stack Hub updates.

For more information about update build types, see [Manage updates in Azure Stack Hub](../azure-stack-updates.md).

<!-- ## What's in this update -->

<!-- The current theme (if any) of this release. -->

### What's new

<!-- What's new, also net new experiences and features. -->

- The administrator portal now shows the privileged endpoint IP addresses in the region properties menu for easier discovery. In addition, it shows the current configured time server and DNS forwarders. For more information, see [Use the privileged endpoint in Azure Stack Hub](../azure-stack-privileged-endpoint.md).

- The Azure Stack Hub health and monitoring system can now raise alerts for various hardware components if an error happens. These alerts require additional configuration. For more information, see [Monitor Azure Stack Hub hardware components](../azure-stack-hardware-monitoring.md).

- [Cloud-init support for Azure Stack Hub](/azure/virtual-machines/linux/using-cloud-init): Cloud-init is a widely used approach to customize a Linux VM as it boots for the first time. You can use cloud-init to install packages and write files, or to configure users and security. Because cloud-init is called during the initial boot process, there are no additional steps or required agents to apply your configuration. The Ubuntu images on the marketplace have been updated to support cloud-init for provisioning.

- Azure Stack Hub now supports all Windows Azure Linux Agent versions as Azure.

- A new version of Azure Stack Hub admin PowerShell modules is available. <!-- For more information, see -->

- New Azure PowerShell tenant modules were released for Azure Stack Hub on April 15, 2020. The currently used Azure RM modules will continue to work, but will no longer be updated after build 2002.

- Added the **Set-AzSDefenderManualUpdate** cmdlet in the privileged endpoint (PEP) to configure the manual update for Windows Defender definitions in the Azure Stack Hub infrastructure. For more information, see [Update Windows Defender Antivirus on Azure Stack Hub](../azure-stack-security-av.md).

- Added the **Set-AzSDnsForwarder** cmdlet in the privileged endpoint (PEP) to change the forwarder settings of the DNS servers in Azure Stack Hub. For more information about DNS configuration, see [Azure Stack Hub datacenter DNS integration](../azure-stack-integrate-dns.md).

- Added support for management of **Kubernetes clusters** using the [AKS engine](../../user/azure-stack-kubernetes-aks-engine-overview.md). Starting with this update, customers can deploy production Kubernetes clusters. The AKS engine enables users to:
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

- Azure Stack Hub has improved its ability to auto-remediate some patch and update issues that previously caused update failures or prevented operators from being able to initiate an Azure Stack Hub update. As a result, there are fewer tests included in the **Test-AzureStack -UpdateReadiness** group. For more information, see [Validate Azure Stack Hub system state](../azure-stack-diagnostic-test.md#groups). The following three tests remain in the **UpdateReadiness** group:

  - **AzSInfraFileValidation**
  - **AzSActionPlanStatus**
  - **AzsStampBMCSummary**

- Added an auditing rule to report when an external device (for example, a USB key) is mounted to a node of the Azure Stack Hub infrastructure. The audit log is emitted via syslog and will be displayed as **Microsoft-Windows-Security-Auditing: 6416|Plug and Play Events**. For more information about how to configure the syslog client, see [Syslog forwarding](../azure-stack-integrate-security.md).

- Azure Stack Hub is moving to 4096-bit RSA keys for the internal certificates. Running internal secret rotation will replace old 2048-bit certificates with 4096-bit long certificates. For more information about secret rotation in Azure Stack Hub, see [Rotate secrets in Azure Stack Hub](../azure-stack-rotate-secrets.md).

- Upgrades to the complexity of cryptographic algorithms and key strength for several internal components to comply with the Committee on National Security Systems - Policy 15 (CNSSP-15), which provides best practices for the use of public standards for secure information sharing. Among the improvements, there's AES256 for Kerberos authentication and SHA384 for VPN encryption. For more information about CNSSP-15, see the [Committee on National Security Systems, Policies page](https://csrc.nist.gov/glossary/term/Committee_on_National_Security_Systems_Policy).

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

   These changes are reflected in the [default IPsec/IKE proposal](../../user/azure-stack-vpn-gateway-settings.md#ipsecike-parameters) documentation as well.

- The infrastructure backup service improves logic that calculates desired free space for backups instead of relying on a fixed threshold. The service will use the size of a backup, retention policy, reserve, and current utilization of external storage location to determine if a warning needs to be raised to the operator.

### Changes

- When downloading marketplace items from Azure to Azure Stack Hub, there's a new user interface that enables you to specify a version of the item when multiple versions exist. The new UI is available in both connected and disconnected scenarios. For more information, see [Download marketplace items from Azure to Azure Stack Hub](../azure-stack-download-azure-marketplace-item.md).  

- Starting with the 1910 release, the Azure Stack Hub system **requires** an additional /20 private internal IP space. See [Network integration planning for Azure Stack](../azure-stack-network.md) for more information.
  
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

For information about security updates in this update of Azure Stack Hub, see [Azure Stack Hub security updates](../release-notes-security-updates.md).

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

After the installation of this update, install any applicable hotfixes. For more information, see our [servicing policy](../azure-stack-servicing-policy.md).

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack Hub hotfix 1.1910.63.186](https://support.microsoft.com/help/4574735)
::: moniker-end

::: moniker range="azs-1908"
## 1908 archived release notes
*Applies to: Azure Stack integrated systems*

This article describes the contents of Azure Stack update packages. The update includes what's new improvements, and fixes for this release of Azure Stack.

To access release notes for a different version, use the version selector dropdown above the table of contents on the left.

> [!IMPORTANT]  
> This update package is only for Azure Stack integrated systems. Do not apply this update package to the Azure Stack Development Kit.

> [!IMPORTANT]  
> If your Azure Stack instance is behind by more than two updates, it's considered out of compliance. You must [update to at least the minimum supported version to receive support](../azure-stack-servicing-policy.md#keep-your-system-under-support).

## Update planning

Before applying the update, make sure to review the following information:

- [Known issues](./known-issues.md?view=azs-1908&preserve-view=true)
- [Security updates](../release-notes-security-updates.md)
- [Checklist of activities before and after applying the update](../release-notes-checklist.md)

For help with troubleshooting updates and the update process, see [Troubleshoot patch and update issues for Azure Stack](../azure-stack-troubleshooting.md).

## 1908 build reference

The Azure Stack 1908 update build number is **1.1908.4.33**.

### Update type

For 1908, the underlying operating system on which Azure Stack runs has been updated to Windows Server 2019. This enables core fundamental enhancements, as well as the ability to bring additional capabilities to Azure Stack in the near future.

The Azure Stack 1908 update build type is **Full**. As a result, the 1908 update has a longer runtime than express updates like 1906 and 1907. Exact runtimes for full updates typically depend on the number of nodes that your Azure Stack instance contains, the capacity used on your system by tenant workloads, your system's network connectivity (if connected to the internet), and your system hardware configuration. The 1908 update has had the following expected runtimes in our internal testing: 4 nodes - 42 hours, 8 nodes - 50 hours, 12 nodes - 60 hours, 16 nodes - 70 hours. Update runtimes lasting longer than these expected values are not uncommon and do not require action by Azure Stack operators unless the update fails.

For more information about update build types, see [Manage updates in Azure Stack](../azure-stack-updates.md).

- Exact update runtimes typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware configuration.
- Runtimes lasting longer than expected are not uncommon and do not require action by Azure Stack operators unless the update fails.
- This runtime approximation is specific to the 1908 update and should not be compared to other Azure Stack updates.

<!-- ## What's in this update -->

<!-- The current theme (if any) of this release. -->

### What's new

<!-- What's new, also net new experiences and features. -->

- For 1908, note that the underlying operating system on which Azure Stack runs has been updated to Windows Server 2019. This enables core fundamental enhancements, as well as the ability to bring additional capabilities to Azure Stack in the near future.
- All components of Azure Stack infrastructure now operate in FIPS 140-2 mode.
- Azure Stack operators can now remove portal user data. For more information, see [Clear portal user data from Azure Stack](../azure-stack-portal-clear.md).

### Improvements

<!-- Changes and product improvements with tangible customer-facing value. -->
- Improvements to data at rest encryption of Azure Stack to persist secrets into the hardware Trusted Platform Module (TPM) of the physical nodes.

### Changes

- Hardware providers will be releasing OEM extension package 2.1 or later at the same time as Azure Stack version 1908. The OEM extension package 2.1 or later is a prerequisite for Azure Stack version 1908. For more information about how to download OEM extension package 2.1 or later, contact your system's hardware provider, and see the [OEM updates](../azure-stack-update-oem.md#oem-contact-information) article.  

### Fixes

- Fixed an issue with compatibility with future Azure Stack OEM updates and an issue with VM deployment using customer user images. This issue was found in 1907 and fixed in hotfix [KB4517473](https://support.microsoft.com/en-us/help/4517473/azure-stack-hotfix-1-1907-12-44)  
- Fixed an issue with OEM Firmware update and corrected misdiagnosis in Test-AzureStack for Fabric Ring Health. This issue was found in 1907 and fixed in hotfix [KB4515310](https://support.microsoft.com/en-us/help/4515310/azure-stack-hotfix-1-1907-7-35)
- Fixed an issue with OEM Firmware update process. This issue was found in 1907 and fixed in hotfix [KB4515650](https://support.microsoft.com/en-us/help/4515650/azure-stack-hotfix-1-1907-8-37)

<!-- Product fixes that came up from customer deployments worth highlighting, especially if there is an SR/ICM associated to it. -->

## Security updates

For information about security updates in this update of Azure Stack, see [Azure Stack security updates](../release-notes-security-updates.md).

## <a name="download-the-update-1908"></a>Download the update

You can download the Azure Stack 1908 update package from [the Azure Stack download page](https://aka.ms/azurestackupdatedownload).

## Hotfixes

Azure Stack releases hotfixes on a regular basis. Be sure to install the latest Azure Stack hotfix for 1907 before updating Azure Stack to 1908.

Azure Stack hotfixes are only applicable to Azure Stack integrated systems; do not attempt to install hotfixes on the ASDK.

### Prerequisites: Before applying the 1908 update

The 1908 release of Azure Stack must be applied on the 1907 release with the following hotfixes:

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack hotfix 1.1907.17.54](https://support.microsoft.com/help/4523826)

The Azure Stack 1908 Update requires **Azure Stack OEM version 2.1 or later** from your system's hardware provider. OEM updates include driver and firmware updates to your Azure Stack system hardware. For more information about applying OEM updates, see [Apply Azure Stack original equipment manufacturer updates](../azure-stack-update-oem.md)

### After successfully applying the 1908 update

After the installation of this update, install any applicable hotfixes. For more information, see our [servicing policy](../azure-stack-servicing-policy.md).

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack hotfix 1.1908.6.37](https://support.microsoft.com/help/4527372)
::: moniker-end

::: moniker range="azs-1907"
## 1907 archived release notes
This article describes the contents of Azure Stack update packages. The update includes what's new improvements, and fixes for this release of Azure Stack.

To access release notes for a different version, use the version selector dropdown above the table of contents on the left.

> [!IMPORTANT]  
> This update package is only for Azure Stack integrated systems. Do not apply this update package to the Azure Stack Development Kit.

> [!IMPORTANT]  
> If your Azure Stack instance is behind by more than two updates, it's considered out of compliance. You must [update to at least the minimum supported version to receive support](../azure-stack-servicing-policy.md#keep-your-system-under-support).

## Update planning

Before applying the update, make sure to review the following information:

- [Known issues](./known-issues.md?view=azs-1907&preserve-view=true)
- [Security updates](../release-notes-security-updates.md)
- [Checklist of activities before and after applying the update](../release-notes-checklist.md)

For help with troubleshooting updates and the update process, see [Troubleshoot patch and update issues for Azure Stack](../azure-stack-troubleshooting.md).

## 1907 build reference

The Azure Stack 1907 update build number is **1.1907.0.20**.

### Update type

The Azure Stack 1907 update build type is **Express**. For more information about update build types, see the [Manage updates in Azure Stack](../azure-stack-updates.md) article. Based on internal testing, the expected time it takes for the 1907 update to complete is approximately 13 hours.

- Exact update runtimes typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware configuration.
- Runtimes lasting longer than expected are not uncommon and do not require action by Azure Stack operators unless the update fails.
- This runtime approximation is specific to the 1907 update and should not be compared to other Azure Stack updates.

## What's in this update

<!-- The current theme (if any) of this release. -->

### What's new

<!-- What's new, also net new experiences and features. -->

- General availability release of the Azure Stack diagnostic log collection service to facilitate and improve diagnostic log collection. The Azure Stack diagnostic log collection service provides a simplified way to collect and share diagnostic logs with Microsoft Customer Support Services (CSS). This diagnostic log collection service provides a new user experience in the Azure Stack administrator portal that enables operators to set up the automatic upload of diagnostic logs to a storage blob when certain critical alerts are raised, or to perform the same operation on demand. For more information, see the [Diagnostic log collection](../diagnostic-log-collection.md) article.

- General availability release of the Azure Stack network infrastructure validation as a part of the Azure Stack validation tool **Test-AzureStack**. Azure Stack network infrastructure will be a part of **Test-AzureStack**, to identify if a failure occurs on the network infrastructure of Azure Stack. The test checks connectivity of the network infrastructure by bypassing the Azure Stack software-defined network. It demonstrates connectivity from a public VIP to the configured DNS forwarders, NTP servers, and identity endpoints. In addition, it checks for connectivity to Azure when using Azure AD as the identity provider, or the federated server when using ADFS. For more information, see the [Azure Stack validation tool](../azure-stack-diagnostic-test.md) article.

- Added an internal secret rotation procedure to rotate internal SQL TLS certificates as required during a system update.

### Improvements

<!-- Changes and product improvements with tangible customer-facing value. -->

- The Azure Stack update blade now displays a **Last Step Completed** time for active updates. This can be seen by going to the update blade and clicking on a running update. **Last Step Completed** is then available in the **Update run details** section.

- Improvements to **Start-AzureStack** and **Stop-AzureStack** operator actions. The time to start Azure Stack has been reduced by an average of 50%. The time to shut down Azure Stack has been reduced by an average of 30%. The average startup and shutdown times remain the same as the number of nodes increases in a scale-unit.

- Improved error handling for the disconnected Marketplace tool. If a download fails or partially succeeds when using **Export-AzSOfflineMarketplaceItem**, a detailed error message is displayed with more details about the error and mitigation steps, if any.

- Improved the performance of managed disk creation from a large page blob/snapshot. Previously, it triggered a timeout when creating a large disk.  

<!-- https://icm.ad.msft.net/imp/v3/incidents/details/127669774/home -->
- Improved virtual disk health check before shutting down a node to avoid unexpected virtual disk detaching.

- Improved storage of internal logs for administrator operations. This results in improved performance and reliability during administrator operations by minimizing the memory and storage consumption of internal log processes. You might also notice improved page load times of the update blade in the administrator portal. As part of this improvement, update logs older than 6 months will no longer be available in the system. If you require logs for these updates, be sure to [Download the summary](../azure-stack-apply-updates.md) for all update runs older than 6 months before performing the 1907 update.

### Changes

- Azure Stack version 1907 contains a warning alert that instructs operators to be sure to update their system's OEM package to version 2.1 or later before updating to version 1908. For more information about how to apply Azure Stack OEM updates, see [Apply an Azure Stack original equipment manufacturer update](../azure-stack-update-oem.md).

- Added a new outbound rule (HTTPS) to enable communication for Azure Stack diagnostic log collection service. For more information, see [Azure Stack datacenter integration - Publish endpoints](../azure-stack-integrate-endpoints.md#ports-and-urls-outbound).

- The infrastructure backup service now deletes partially uploaded backups if the external storage location runs out of capacity.

- Infrastructure backups no longer include a backup of domain services data. This only applies to systems using Azure Active Directory as the identity provider.

- We now validate that an image being ingested into the **Compute -> VM images** blade is of type page blob.

### Fixes

<!-- Product fixes that came up from customer deployments worth highlighting, especially if there is an SR/ICM associated to it. -->
- Fixed an issue in which the publisher, offer, and SKU were treated as case sensitive in a Resource Manager template: the image was not fetched for deployment unless the image parameters were the same case as that of the publisher, offer, and SKU.

<!-- https://icm.ad.msft.net/imp/v3/incidents/details/129536438/home -->
- Fixed an issue with backups failing with a **PartialSucceeded** error message, due to timeouts during backup of storage service metadata.  

- Fixed an issue in which deleting user subscriptions resulted in orphaned resources.

- Fixed an issue in which the description field was not saved when creating an offer.

- Fixed an issue in which a user with **Read only** permissions was able to create, edit, and delete resources. Now the user is only able to create resources when the **Contributor** permission is assigned. 

<!-- https://icm.ad.msft.net/imp/v3/incidents/details/127772311/home -->
- Fixed an issue in which the update fails due to a DLL file locked by the WMI provider host.

- Fixed an issue in the update service that prevented available updates from displaying in the update tile or resource provider. This issue was found in 1906 and fixed in hotfix [KB4511282](https://support.microsoft.com/help/4511282/).

- Fixed an issue that could cause updates to fail due to the management plane becoming unhealthy due to a bad configuration. This issue was found in 1906 and fixed in hotfix [KB4512794](https://support.microsoft.com/help/4512794/).

- Fixed an issue that prevented users from completing deployment of 3rd party images from the marketplace. This issue was found in 1906 and fixed in hotfix [KB4511259](https://support.microsoft.com/help/4511259/).

- Fixed an issue that could cause VM creation from managed images to fail due to our user image manager service crashing. This issue was found in 1906 and fixed in hotfix [KB4512794](https://support.microsoft.com/help/4512794/)

- Fixed an issue in which VM CRUD operations could fail due to the app gateway cache not being refreshed as expected. This issue was found in 1906 and fixed in hotfix [KB4513119](https://support.microsoft.com/en-us/help/4513119/)

- Fixed an issue in the health resource provider which impacted the availability of the region and alert blades in the administrator portal. This issue was found in 1906 and fixed in hotfix [KB4512794](https://support.microsoft.com/help/4512794).

## Security updates

For information about security updates in this update of Azure Stack, see [Azure Stack security updates](../release-notes-security-updates.md).

## Download the update

You can download the Azure Stack 1907 update package from [the Azure Stack download page](https://aka.ms/azurestackupdatedownload).

## Hotfixes

Azure Stack releases hotfixes on a regular basis. Be sure to install the latest Azure Stack hotfix for 1906 before updating Azure Stack to 1907.

Azure Stack hotfixes are only applicable to Azure Stack integrated systems; do not attempt to install hotfixes on the ASDK.

### Before applying the 1907 update

The 1907 release of Azure Stack must be applied on the 1906 release with the following hotfixes:

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack hotfix 1.1906.15.60](https://support.microsoft.com/help/4524559)

### After successfully applying the 1907 update

After the installation of this update, install any applicable hotfixes. For more information, see our [servicing policy](../azure-stack-servicing-policy.md).

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack hotfix 1.1907.17.54](https://support.microsoft.com/help/4523826)
::: moniker-end

::: moniker range="azs-1906"
## 1906 archived release notes
This article describes the contents of Azure Stack update packages. The update includes what's new improvements, and fixes for this release of Azure Stack.

To access release notes for a different version, use the version selector dropdown above the table of contents on the left.

> [!IMPORTANT]  
> This update package is only for Azure Stack integrated systems. Do not apply this update package to the Azure Stack Development Kit.

> [!IMPORTANT]  
> If your Azure Stack instance is behind by more than two updates, it's considered out of compliance. You must [update to at least the minimum supported version to receive support](../azure-stack-servicing-policy.md#keep-your-system-under-support).

## Update planning

Before applying the update, make sure to review the following information:

- [Known issues](./known-issues.md?view=azs-1906&preserve-view=true)
- [Security updates](../release-notes-security-updates.md)
- [Checklist of activities before and after applying the update](../release-notes-checklist.md)

For help with troubleshooting updates and the update process, see [Troubleshoot patch and update issues for Azure Stack](../azure-stack-troubleshooting.md).

## 1906 build reference

The Azure Stack 1906 update build number is **1.1906.0.30**.

### Update type

The Azure Stack 1906 update build type is **Express**. For more information about update build types, see the [Manage updates in Azure Stack](../azure-stack-updates.md) article. The expected time it takes for the 1906 update to complete is approximately 10 hours, regardless of the number of physical nodes in your Azure Stack environment. Exact update runtimes will typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware specifications. Runtimes lasting longer than the expected value are not uncommon and do not require action by Azure Stack operators unless the update fails. This runtime approximation is specific to the 1906 update and should not be compared to other Azure Stack updates.

## What's in this update

<!-- The current theme (if any) of this release. -->

<!-- What's new, also net new experiences and features. -->

- Added a **Set-TLSPolicy** cmdlet in the privileged endpoint (PEP) to force TLS 1.2 on all the endpoints. For more information, see [Azure Stack security controls](../azure-stack-security-configuration.md).

- Added a **Get-TLSPolicy** cmdlet in the privileged endpoint (PEP) to retrieve the applied TLS policy. For more information, see [Azure Stack security controls](../azure-stack-security-configuration.md).

- Added an internal secret rotation procedure to rotate internal TLS certificates as required during a system update.

- Added a safeguard to prevent expiration of internal secrets by forcing internal secrets rotation in case a critical alert on expiring secrets is ignored. This should not be relied on as a regular operating procedure. Secrets rotation should be planned during a maintenance window. For more information, see [Azure Stack secret rotation](../azure-stack-rotate-secrets.md).

- Visual Studio Code is now supported with Azure Stack deployment using AD FS.

### Improvements

<!-- Changes and product improvements with tangible customer-facing value. -->

- The **Get-GraphApplication** cmdlet in the privileged endpoint now displays the thumbprint of the currently used certificate. This improves the certificate management for service principals when Azure Stack is deployed with AD FS.

- New health monitoring rules have been added to validate the availability of AD Graph and AD FS, including the ability to raise alerts.

- Improvements to the reliability of the backup resource provider when the infrastructure backup service moves to another instance.

- Performance optimization of external secret rotation procedure to provide a uniform execution time to facilitate scheduling of maintenance window.

- The **Test-AzureStack** cmdlet now reports on internal secrets that are about to expire (critical alerts).

- A new parameter is available for the **Register-CustomAdfs** cmdlet in the privileged endpoint that enables skipping the certificate revocation list checking when configuring the federation trust for AD FS.

- The 1906 release introduces greater visibility into update progress, so you can be assured that updates are not pausing. This results in an increase in the total number of update steps shown to operators in the **Update** blade. You might also notice more update steps happening in parallel than in previous updates.

#### Networking updates

- Updated lease time set in DHCP responder to be consistent with Azure.

- Improved retry rates to the resource provider in the scenario of failed deployment of resources.

- Removed the **Standard** SKU option from both the load balancer and public IP, as that is currently not supported.

### Changes

- Creating a storage account experience is now consistent with Azure.

- Changed alert triggers for expiration of internal secrets:
  - Warning alerts are now raised 90 days prior to the expiration of secrets.
  - Critical alerts are now raised 30 days prior to the expiration of secrets.

- Updated strings in infrastructure backup resource provider for consistent terminology.

### Fixes

<!-- Product fixes that came up from customer deployments worth highlighting, especially if there is an SR/ICM associated to it. -->

- Fixed an issue where resizing a managed disk VM failed with an **Internal Operation Error**.

- Fixed an issue where a failed user image creation puts the service that manages images is in a bad state; this blocks deletion of the failed image and creation of new images. This is also fixed in the 1905 hotfix.

- Active alerts on expiring internal secrets are now automatically closed after successful execution of internal secret rotation.

- Fixed an issue in which the update duration in the update history tab would trim the first digit if the update was running for more than 99 hours.

- The **Update** blade includes a **Resume** option for failed updates.

- In the administrator and user portals, fixed the issue in marketplace in which the Docker extension was incorrectly returned from search but no further action could be taken, as it is not available in Azure Stack.

- Fixed an issue in template deployment UI that does not populate parameters if the template name begins with '_' underscore.

- Fixed an issue where the virtual machine scale set creation experience provides CentOS-based 7.2 as an option for deployment. CentOS 7.2 is not available on Azure Stack. We now provide Centos 7.5 as our option for deployment

- You can now remove a scale set from the **Virtual machine scale sets** blade.

## Security updates

For information about security updates in this update of Azure Stack, see [Azure Stack security updates](../release-notes-security-updates.md).

## Download the update

You can download the Azure Stack 1906 update package from [the Azure Stack download page](https://aka.ms/azurestackupdatedownload).

## Hotfixes

Azure Stack releases hotfixes on a regular basis. Be sure to install the latest Azure Stack hotfix for 1905 before updating Azure Stack to 1906. After updating, install any [available hotfixes for 1906](#after-successfully-applying-the-1906-update).

Azure Stack hotfixes are only applicable to Azure Stack integrated systems; do not attempt to install hotfixes on the ASDK.

### Before applying the 1906 update

The 1906 release of Azure Stack must be applied on the 1905 release with the following hotfixes:

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack hotfix 1.1905.3.48](https://support.microsoft.com/help/4510078)

### After successfully applying the 1906 update

After the installation of this update, install any applicable hotfixes. For more information, see our [servicing policy](../azure-stack-servicing-policy.md).

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack hotfix 1.1906.15.60](https://support.microsoft.com/help/4524559)

## Next steps

- For an overview of the update management in Azure Stack, see [Manage updates in Azure Stack overview](../azure-stack-updates.md).  
- For more information about how to apply updates with Azure Stack, see [Apply updates in Azure Stack](../azure-stack-apply-updates.md).
- To review the servicing policy for Azure Stack integrated systems, and what you must do to keep your system in a supported state, see [Azure Stack servicing policy](../azure-stack-servicing-policy.md).  
- To use the Privileged End Point (PEP) to monitor and resume updates, see [Monitor updates in Azure Stack using the privileged endpoint](../azure-stack-monitor-update.md).
::: moniker-end

::: moniker range="azs-1905"
## 1905 archived release notes
*Applies to: Azure Stack integrated systems*

This article describes the contents of the 1905 update package. The update includes what's new improvements, and fixes for this release of Azure Stack. This article contains the following information:

- [Description of what's new, improvements, fixes, and security updates](#whats-in-this-update)
- [Update planning](#update-planning)

> [!IMPORTANT]  
> This update package is only for Azure Stack integrated systems. Do not apply this update package to the Azure Stack Development Kit.

## Build reference

The Azure Stack 1905 update build number is **1.1905.0.40**.

### Update type

The Azure Stack 1905 update build type is **Full**. As a result, the 1905 update has a longer runtime than express updates like 1903 and 1904. Exact runtimes for full updates typically depend on the number of nodes that your Azure Stack instance contains, the capacity used on your system by tenant workloads, your system's network connectivity (if connected to the internet), and your system hardware configuration. The 1905 update has had the following expected runtimes in our internal testing: 4 nodes - 35 hours, 8 nodes - 45 hours, 12 nodes - 55 hours, 16 nodes - 70 hours. 1905 runtimes lasting longer than these expected values are not uncommon and do not require action by Azure Stack operators unless the update fails. For more information about update build types, see [Manage updates in Azure Stack](../azure-stack-updates.md).

## What's in this update

<!-- The current theme (if any) of this release. -->

<!-- What's new, also net new experiences and features. -->

- With this update, the update engine in Azure Stack can update the firmware of scale unit nodes. This requires a compliant update package from the hardware partners. Reach out to your hardware partner for details about availability.

- Windows Server 2019 is now supported and available to syndicate through the Azure Stack Marketplace.
With this update, Windows Server 2019 can now be successfully activated on a 2016 host.

- A new [Azure Account Visual Studio Code extension](../../user/azure-stack-dev-start-vscode-azure.md) allows developers to target Azure Stack by logging in and viewing subscriptions, as well as a number of other services. The Azure Account extension works on both Azure Active Directory (Azure AD) and AD FS environments, and only requires a small change in Visual Studio Code user settings. Visual Studio Code requires a service principal to be given permission in order to run on this environment. To do so, import the identity script and run the cmdlets specified in [Multi-tenancy in Azure Stack](../enable-multitenancy.md). This requires an update to the home directory, and registration of the Guest tenant directory for each directory. An alert is displayed after updating to 1905 or later, to update the home directory tenant for which the Visual Studio Code service principal is included. 

### Improvements

<!-- Changes and product improvements with tangible customer-facing value. -->
- As a part of enforcing TLS 1.2 on Azure Stack, the following extensions have been updated to these versions:

  - microsoft.customscriptextension-arm-1.9.3
  - microsoft.iaasdiagnostics-1.12.2.2
  - microsoft.antimalware-windows-arm-1.5.5.9
  - microsoft.dsc-arm-2.77.0.0
  - microsoft.vmaccessforlinux-1.5.2

  Please download these versions of the extensions immediately, so that new deployments of the extension do not fail when TLS 1.2 is enforced in a future release. Always set **autoUpgradeMinorVersion=true** so that minor version updates to extensions (for example, 1.8 to 1.9) are automatically performed.

- A new **Help and Support Overview** in the Azure Stack portal makes it easier for operators to check their support options, get expert help, and learn more about Azure Stack. On integrated systems, creating a support request will preselect Azure Stack service. We highly recommend that customers use this experience to submit tickets rather than using the global Azure portal. For more information, see [Azure Stack Help and Support](../azure-stack-help-and-support-overview.md).

- When multiple Azure Active Directories are onboarded (through [this process](../enable-multitenancy.md)), it is possible to neglect rerunning the script when certain updates occur, or when changes to the Azure AD Service Principal authorization cause rights to be missing. This can cause various issues, from blocked access for certain features, to more discrete failures which are hard to trace back to the original issue. To prevent this, 1905 introduces a new feature that checks for these permissions and creates an alert when certain configuration issues are found. This validation runs every hour, and displays the remediation actions required to fix the issue. The alert closes once all the tenants are in a healthy state.

- Improved reliability of infrastructure backup operations during service failover.

- A new version of the [Azure Stack Nagios plugin](../azure-stack-integrate-monitor.md#integrate-with-nagios) is available that uses the [Azure Active Directory Authentication Libraries](/azure/active-directory/develop/active-directory-authentication-libraries) (ADAL) for authentication. The plugin now also supports Azure AD and Active Directory Federation Services (AD FS) deployments of Azure Stack. For more information, see the [Nagios plugin exchange](https://exchange.nagios.org/directory/Plugins/Cloud/Monitoring-AzureStack-Alerts/details) site.

- A new hybrid profile **2019-03-01-Hybrid** was released that supports all the latest features in Azure Stack. Both Azure PowerShell and Azure CLI support the **2019-03-01-Hybrid** profile. The .NET, Ruby, Node.js, Go, and Python SDKs have published packages that support the **2019-03-01-Hybrid** profile. The respective documentation and some samples have been updated to reflect the changes.

- The [Node.js SDK](https://www.npmjs.com/search?q=2019-03-01-hybrid) now supports API profiles. Packages that support the **2019-03-01-Hybrid** profile are published.

- The 1905 Azure Stack update adds two new infrastructure roles to improve platform reliability and supportability:

  - **Infrastructure ring**: In the future, the infrastructure ring will host containerized versions of existing infrastructure roles – for example, xrp - that currently require their own designated infrastructure VMs. This will improve platform reliability and reduce the number of infrastructure VMs that Azure Stack requires. This subsequently reduces the overall resource consumption of Azure Stack's infrastructure roles in the future.
  - **Support ring**: In the future, the support ring will be used to handle enhanced support scenarios for customers.  

  In addition, we added an extra instance of the domain controller VM for improved availability of this role.

  These changes will increase the resource consumption of Azure Stack infrastructure in the following ways:
  
    | Azure Stack SKU | Increase in Compute Consumption | Increase in Memory Consumption |
    | -- | -- | -- |
    |4 Nodes|22 vCPU|28 GB|
    |8 Nodes|38 vCPU|44 GB|
    |12 Nodes|54 vCPU|60 GB|
    |16 Nodes|70 vCPU|76 GB|
  
### Changes

- To increase reliability and availability during planned and unplanned maintenance scenarios, Azure Stack adds an additional infrastructure role instance for domain services.

- With this update, during repair and add node operations, the hardware is validated to ensure homogenous scale unit nodes within a scale unit.

- If scheduled backups are failing to complete and the defined retention period is exceeded, the infrastructure backup controller will ensure at least one successful backup is retained. 

### Fixes

<!-- Product fixes that came up from customer deployments worth highlighting, especially if there is an SR/ICM associated to it. -->

- Fixed an issue in which a **Compute host agent** warning appeared after restarting a node in the scale unit.

- Fixed issues in marketplace management in the administrator portal which showed incorrect results when filters were applied, and showed duplicate publisher names in the publisher filter. Also made performance improvements to display results faster.

- Fixed issue in the available backup blade that listed a new available backup before it completed upload to the external storage location. Now the available backup will show in the list after it is successfully uploaded to the storage location. 

<!-- ICM: 114819337; Task: 4408136 -->
- Fixed issue with retrieving recovery keys during backup operation. 

<!-- Bug: 4525587 -->
- Fixed issue with OEM update displaying version as 'undefined' in operator portal.

### Security updates

For information about security updates in this update of Azure Stack, see [Azure Stack security updates](../release-notes-security-updates.md).

## Update planning

Before applying the update, make sure to review the following information:

- [Known issues](./known-issues.md?view=azs-1905&preserve-view=true)
- [Security updates](../release-notes-security-updates.md)
- [Checklist of activities before and after applying the update](../release-notes-checklist.md)

## Download the update

You can download the Azure Stack 1905 update package from [the Azure Stack download page](https://aka.ms/azurestackupdatedownload). When using the downloader tool, be sure to use the latest version and not a cached copy from your downloads directory.

## Hotfixes

Azure Stack releases hotfixes on a regular basis. Be sure to install the latest Azure Stack hotfix for 1904 before updating Azure Stack to 1905.

Azure Stack hotfixes are only applicable to Azure Stack integrated systems; do not attempt to install hotfixes on the ASDK.

### Before applying the 1905 update

The 1905 release of Azure Stack must be applied on the 1904 release with the following hotfixes:

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack hotfix 1.1904.4.45](https://support.microsoft.com/help/4505688)

### After successfully applying the 1905 update

After the installation of this update, install any applicable hotfixes. For more information, see our [servicing policy](../azure-stack-servicing-policy.md).

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack hotfix 1.1905.3.48](https://support.microsoft.com/help/4510078)

## Automatic update notifications

Customers with systems that can access the internet from the infrastructure network will see the **Update available** message in the operator portal. Systems without internet access can download and import the .zip file with the corresponding .xml.

## Next steps

- For an overview of the update management in Azure Stack, see [Manage updates in Azure Stack overview](../azure-stack-updates.md).  
- For more information about how to apply updates with Azure Stack, see [Apply updates in Azure Stack](../azure-stack-apply-updates.md).
- To review the servicing policy for Azure Stack integrated systems, and what you must do to keep your system in a supported state, see [Azure Stack servicing policy](../azure-stack-servicing-policy.md).  
- To use the Privileged End Point (PEP) to monitor and resume updates, see [Monitor updates in Azure Stack using the privileged endpoint](../azure-stack-monitor-update.md).  
::: moniker-end

::: moniker range="azs-1904"
## 1904 archived release notes
*Applies to: Azure Stack integrated systems*

This article describes the contents of the 1904 update package. The update includes what's new improvements, and fixes for this release of Azure Stack. This article contains the following information:

> [!IMPORTANT]  
> This update package is only for Azure Stack integrated systems. Do not apply this update package to the Azure Stack Development Kit.

## Build reference

The Azure Stack 1904 update build number is **1.1904.0.36**.

### Update type

The Azure Stack 1904 update build type is **Express**. For more information about update build types, see the [Manage updates in Azure Stack](../azure-stack-updates.md) article. The expected time it takes for the 1904 update to complete is approximately 16 hours, but exact times can vary. This runtime approximation is specific to the 1904 update and should not be compared to other Azure Stack updates.

## What's in this update

<!-- The current theme (if any) of this release. -->

<!-- What's new, also net new experiences and features. -->

### Improvements

<!-- Changes and product improvements with tangible customer-facing value. -->

- Significant improvements have been made to the Software Defined Networking (SDN) Stack in 1904. These improvements increase the overall servicing and reliability of the SDN stack in Azure Stack.

- Added a notification in the administrator portal, when the currently logged in user does not have the necessary permissions, which enables the dashboard to load properly. It also contains a link to the documentation that explains which accounts have the appropriate permissions, depending on the identity provider used during deployment.

- Added improvements to VM resiliency and uptime, which resolves the scenario in which all VMs go offline if the storage volume containing the VM configuration files goes offline.

<!-- 1901,2,3 related hotfix -->
- Added optimization to the number of VMs evacuated concurrently and placed a cap on bandwidth consumed, to address VM brownouts or blackouts if the network is under heavy load. This change increases VM uptime when a system is updating.

<!-- 1901,2,3 related hotfix -->
- Improved resource throttling when a system is running at scale to protect against internal processes exhausting platform resources, resulting in failed operations in the portal.

- Improved filtering capabilities enable operators to apply multiple filters at the same time. You can only sort on the **Name** column in the new user interface.

- Improvements to the process of deleting offers, plans, quotas, and subscriptions. You can now successfully delete offers, quotas, plans, and subscriptions from the Administrator portal if the object you want to delete has no dependencies. For more information, see [this article](../azure-stack-delete-offer.md).  

<!-- this applies to bug 3725384 and bug #4225643 -->
- Improved syslog message volume by filtering out unnecessary events and providing a configuration parameter to select desired severity level for forwarded messages. For more information about how to configure the severity level, see [Azure Stack datacenter integration - syslog forwarding](../azure-stack-integrate-security.md).

<!--this applied to Bug 1473487 -->
- Added a new capability to the **Get-AzureStackLog** cmdlet by incorporating an additional parameter, `-OutputSASUri`. You can now collect Azure Stack logs from your environment and store them in the specified Azure Storage blob container. For more information, see [Azure Stack diagnostics](../diagnostic-log-collection.md).

- Added a new memory check in the **Test-AzureStack** `UpdateReadiness` group, which checks to see if you have enough memory available on the stack for the update to complete successfully.

<!-- Bug/Task 4311058 -->
- Improvements to **Test-AzureStack** for evaluating Service Fabric health.

<!-- feature: 2976966 -->
- Improvements to hardware updates, which reduces the time it takes to complete drive firmware update to 2-4 hours. The update engine dynamically determines which portions of the update need to execute, based on content in the package.

<!-- Feature 3906611 -->
- Added robust operation prechecks to prevent disruptive infrastructure role instance operations that affect availability.

<!-- Feature 3780326 -->
- Improvements to idempotency of infrastructure backup action plan.

<!--Bug/Task 3139609 -->
- Improvements to Azure Stack log collection. These improvements reduce the time it takes to retrieve the set of logs. Also, the [Get-AzureStackLog](../diagnostic-log-collection.md#send-logs-now-with-powershell) cmdlet no longer generates default logs for the OEM role. You must execute the [Invoke-AzureStackOnDemandLog](../diagnostic-log-collection.md#send-logs-now-with-powershell) cmdlet, specifying the role to retrieve the OEM logs. For more information , see [Azure Stack diagnostics](../diagnostic-log-collection.md#view-log-collection).

- Azure Stack now monitors the federation data URL provided for datacenter integration with ADFS. This improves reliability during secret rotation of the customer ADFS instance or farm.

### Changes

<!-- Feature 3906611 -->
- Removed the option for Azure Stack operators to shut down infrastructure role instances in the administrator portal. The restart functionality ensures a clean shutdown attempt before restarting the infrastructure role instance. For advanced scenarios, the API and PowerShell functionality remains available.

<!-- Feature ## 4199257 -->
- There is a new Marketplace management experience, with separate screens for Marketplace images and resource providers. For now, the **Resource providers** window is empty, but in future releases new PaaS service offerings will appear and be managed in the **Resource providers** window.

<!-- Feature ## 4199257 -->
- Changes to the update experience in the operator portal. There is a new grid for resource provider updates. The ability to update resource providers is not available yet.

<!-- Task ## 3748423  -->
- Changes to the update installation experience in the operator portal. To help Azure Stack operators respond appropriately to an update issue, the portal now provides more specific recommendations based on the health of the scale unit, as derived automatically by running **Test-AzureStack** and parsing the results. Based on the result, it will inform the operator to take one of two actions:

  - A "soft" warning alert is displayed in the portal that reads "The most recent update needs attention. Microsoft recommends opening a service request during normal business hours. As part of the update process, Test-AzureStack is performed, and based on the output we generate the most appropriate alert. In this case, Test-AzureStack passed."

  - A "hard" critical alert is displayed in the portal that reads, "The most recent update failed. Microsoft recommends opening a service request as soon as possible. As part of the update process, Test-AzureStack is performed, and based on the output we generate the most appropriate alert. In this case, Test-AzureStack also failed."

- Updated Azure Linux Agent version 2.2.38.0. This support allows customers to maintain consistent Linux images between Azure and Azure Stack.

- Changes to the update logs in the operator portal. Requests to retrieve successful update logs are no longer available. Failed update logs, because they are actionable for diagnostics, are still available for download.

### Fixes

<!-- Product fixes that came up from customer deployments worth highlighting, especially if there is an SR/ICM associated to it. -->

- Fixed an issue in which the syslog configuration was not persisted through an update cycle, causing the syslog client to lose its configuration, and the syslog messages to stop being forwarded. Syslog configuration is now preserved.

- Fixed an issue in CRP that blocked deallocation of VMs. Previously, if a VM contained multiple large managed disks, deallocating the VM might have failed with a timeout error.

- Fixed issue with Windows Defender engine impacting access to scale-unit storage.

- Fixed a user portal issue in which the Access Policy window for blob storage accounts failed to load.

- Fixed an issue in both administrator and user portals, in which erroneous notifications about the global Azure portal were displayed.

- Fixed a user portal issue in which selecting the **Feedback** tile caused an empty browser tab to open.

- Fixed a portal issue in which changing a static IP address for an IP configuration that was bound to a network adapter attached to a VM instance, caused an error message to be displayed.

- Fixed a user portal issue in which attempting to **Attach Network Interface** to an existing VM via the **Networking** window caused the operation to fail with an error message.

- Fixed an issue in which Azure Stack did not support attaching more than 4 Network Interfaces (NICs) to a VM instance.

- Fixed a portal issue in which adding an inbound security rule and selecting **Service Tag** as the source, displayed several options that are not available for Azure Stack.

- Fixed the issue in which Network Security Groups (NSGs) did not work in Azure Stack in the same way as global Azure.

- Fixed an issue in Marketplace management, which hides all downloaded products if registration expires or is removed.

- Fixed an issue in which issuing a **Set-AzureRmVirtualNetworkGatewayConnection** command in PowerShell to an existing virtual network gateway connection failed with the error message **Invalid shared key configured...**.

- Fixed an issue that caused the Network Resource Provider (NRP) to be out of sync with the network controller, resulting in duplicate resources being requested. In some cases, this resulted in leaving the parent resource in an error state.

- Fixed an issue in which if a user that was assigned a contributor role to a subscription, but was not explicitly given read permissions, an error was generated that read **...The client 'somelogonaccount@domain.com' with object ID {GUID} does not have authorization to perform action...** when attempting to save a change to a resource.

- Fixed an issue in which the marketplace management screen was empty if the offline syndication tool was used to upload images, and any one of them was missing the icon URI(s).

- Fixed an issue which prevented products that failed to download from being deleted in marketplace management.

### Security updates

This update of Azure Stack does not include security updates to the underlying operating system which hosts Azure Stack.

## Update planning

Before applying the update, make sure to review the following information:

- [Known issues](./known-issues.md?view=azs-1904&preserve-view=true)
- [Security updates](../release-notes-security-updates.md)
- [Checklist of activities before and after applying the update](../release-notes-checklist.md)

> [!NOTE]
> Make sure to use the latest version of the [Azure Stack Capacity Planner](https://aka.ms/azstackcapacityplanner) tool to perform your workload planning and sizing. The latest version contains bug fixes and provides new features that are released with each Azure Stack update.

## Download the update

You can download the Azure Stack 1904 update package from [the Azure Stack download page](https://aka.ms/azurestackupdatedownload).

## Hotfixes

Azure Stack releases hotfixes on a regular basis. Be sure to install the latest Azure Stack hotfix for 1903 before updating Azure Stack to 1904.

Azure Stack hotfixes are only applicable to Azure Stack integrated systems; do not attempt to install hotfixes on the ASDK.

### Before applying the 1904 update

The 1904 release of Azure Stack must be applied on the 1903 release with the following hotfixes:

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack hotfix 1.1903.2.39](https://support.microsoft.com/help/4500638)

### After successfully applying the 1904 update

After the installation of this update, install any applicable hotfixes. For more information, see our [Servicing Policy](../azure-stack-servicing-policy.md).

- [Azure Stack hotfix 1.1904.4.45](https://support.microsoft.com/help/4505688)

## Automatic update notifications

Customers with systems that can access the internet from the infrastructure network will see the **Update available** message in the operator portal. Systems without internet access can download and import the .zip file with the corresponding .xml.

## Next steps

- For an overview of the update management in Azure Stack, see [Manage updates in Azure Stack overview](../azure-stack-updates.md).  
- For more information about how to apply updates with Azure Stack, see [Apply updates in Azure Stack](../azure-stack-apply-updates.md).
- To review the servicing policy for Azure Stack integrated systems, and what you must do to keep your system in a supported state, see [Azure Stack servicing policy](../azure-stack-servicing-policy.md).  
- To use the Privileged End Point (PEP) to monitor and resume updates, see [Monitor updates in Azure Stack using the privileged endpoint](../azure-stack-monitor-update.md).
::: moniker-end

::: moniker range="azs-1903"
## 1903 archived release notes
*Applies to: Azure Stack integrated systems*

This article describes the contents of the 1903 update package. The update includes improvements, fixes, and new features for this version of Azure Stack. This article also describes known issues in this release, and includes a link to download the update. Known issues are divided into issues directly related to the update process, and issues with the build (post-installation).

> [!IMPORTANT]
> This update package is only for Azure Stack integrated systems. Do not apply this update package to the Azure Stack Development Kit.

## Build reference

The Azure Stack 1903 update build number is **1.1903.0.35**.

### Update type

The Azure Stack 1903 update build type is **Express**. For more information about update build types, see the [Manage updates in Azure Stack](../azure-stack-updates.md) article. The expected time it takes for the 1903 update to complete is approximately 16 hours, but exact times can vary. This runtime approximation is specific to the 1903 update and should not be compared to other Azure Stack updates.

> [!IMPORTANT]
> The 1903 payload does not include an ASDK release.

## Hotfixes

Azure Stack releases hotfixes on a regular basis. Be sure to install the latest Azure Stack hotfix for 1902 before updating Azure Stack to 1903.

Azure Stack hotfixes are only applicable to Azure Stack integrated systems; do not attempt to install hotfixes on the ASDK.

### Azure Stack hotfixes

- **1902**: [KB 4500637 - Azure Stack hotfix 1.1902.3.75](https://support.microsoft.com/help/4500637)
- **1903**: [KB 4500638 - Azure Stack hotfix 1.1903.2.39](https://support.microsoft.com/help/4500638)

## Improvements

- Fixed a bug in networking that prevented changes to the **idle timeout (minutes)** value of a **Public IP Address** from taking effect. Previously, changes to this value were ignored, so that regardless of any changes you made, the value would default to 4 minutes. This setting controls how many minutes to keep a TCP connection open without relying on clients to send keep-alive messages. Note this bug only affected instance level public IPs, not public IPs assigned to a load balancer.

- Improvements to the reliability of the update engine, including auto-remediation of common issues so that updates apply without interruption.

- Improvements to the detection and remediation of low disk space conditions.

- Azure Stack now supports Windows Azure Linux agents greater than version 2.2.35. This support allows customers to maintain consistent Linux images between Azure and Azure Stack. It was added as part of the 1901 and 1902 hotfixes.

### Secret management

- Azure Stack now supports rotation of the root certificate used by certificates for external secret rotation. For more information, [see this article](../azure-stack-rotate-secrets.md).

- 1903 contains performance improvements for secret rotation that reduce the time that it takes to execute internal secret rotation.

## Prerequisites

> [!IMPORTANT]
> Install the latest Azure Stack hotfix for 1902 (if any) before updating to 1903.

- Make sure to use the latest version of the [Azure Stack capacity planner](https://aka.ms/azstackcapacityplanner) to do your workload planning and sizing. The latest version contains bug fixes and provides new features that are released with each Azure Stack update.

- Before you start installation of this update, run [Test-AzureStack](../azure-stack-diagnostic-test.md) with the following parameter to validate the status of your Azure Stack and resolve any operational issues found, including all warnings and failures. Also review active alerts, and resolve any that require action:

    ```powershell
   Test-AzureStack -Group UpdateReadiness
    ```

- When Azure Stack is managed by System Center Operations Manager, make sure to update the [Management Pack for Microsoft Azure Stack](https://www.microsoft.com/download/details.aspx?id=55184) to version 1.0.3.11 before applying 1903.

- The package format for the Azure Stack update has changed from **.bin/.exe/.xml** to **.zip/.xml** starting with the 1902 release. Customers with connected Azure Stack scale units will see the **Update available** message in the portal. Customers that are not connected can now simply download and import the .zip file with the corresponding .xml.

<!-- ## New features -->

<!-- ## Fixed issues -->

<!-- ## Common vulnerabilities and exposures -->

## Known issues with the update process

- When attempting to install an Azure Stack update, the status for the update might fail and change state to **PreparationFailed**. This is caused by the update resource provider (URP) being unable to properly transfer the files from the storage container to an internal infrastructure share for processing. Starting with version 1901 (1.1901.0.95), you can work around this issue by clicking **Update now** again (not **Resume**). The URP then cleans up the files from the previous attempt, and starts the download again.

- When you run [Test-AzureStack](../azure-stack-diagnostic-test.md), a warning message from the Baseboard Management Controller (BMC) is displayed. You can safely ignore this warning.

<!-- 2468613 - IS -->
- During installation of this update, you might see alerts with the title **Error - Template for FaultType UserAccounts. New is missing.** You can safely ignore these alerts. The alerts close automatically after the installation of this update completes.

## Post-update steps

- After the installation of this update, install any applicable hotfixes. For more information, see [Hotfixes](#hotfixes), as well as our [Servicing Policy](../azure-stack-servicing-policy.md).

- Retrieve the data at rest encryption keys and securely store them outside of your Azure Stack deployment. Follow the [instructions on how to retrieve the keys](../azure-stack-security-bitlocker.md).

## Known issues (post-installation)

The following are post-installation known issues for this build version.

### Portal

- In the user portal dashboard, when you try to click on the **Feedback** tile, an empty browser tab opens. As a workaround, you can use [Azure Stack User Voice](https://aka.ms/azurestackuservoice) to file a user voice request.

<!-- 2930820 - IS ASDK -->
- In both the administrator and user portals, if you search for "Docker," the item is incorrectly returned. It is not available in Azure Stack. If you try to create it, a blade with an error indication is displayed.

<!-- 2931230 - IS  ASDK -->
- Plans that are added to a user subscription as an add-on plan cannot be deleted, even when you remove the plan from the user subscription. The plan will remain until the subscriptions that reference the add-on plan are also deleted.

<!-- TBD - IS ASDK -->
- The two administrative subscription types that were introduced with version 1804 should not be used. The subscription types are **Metering subscription**, and **Consumption subscription**. These subscription types are visible in new Azure Stack environments beginning with version 1804 but are not yet ready for use. You should continue to use the **Default Provider** subscription type.

<!-- 3557860 - IS ASDK -->
- Deleting user subscriptions results in orphaned resources. As a workaround, first delete user resources or the entire resource group, and then delete the user subscriptions.

<!-- 1663805 - IS ASDK --> 
- You cannot view permissions to your subscription using the Azure Stack portals. As a workaround, use [PowerShell to verify permissions](/powershell/module/azurerm.resources/get-azurermroleassignment).

<!-- Daniel 3/28 -->
- In the user portal, when you navigate to a blob within a storage account and try to open **Access Policy** from the navigation tree, the subsequent window fails to load. To work around this issue, the following PowerShell cmdlets enable creating, retrieving, setting and deleting access policies, respectively:

  - [New-AzureStorageContainerStoredAccessPolicy](/powershell/module/azure.storage/new-azurestoragecontainerstoredaccesspolicy)
  - [Get-AzureStorageContainerStoredAccessPolicy](/powershell/module/azure.storage/get-azurestoragecontainerstoredaccesspolicy)
  - [Set-AzureStorageContainerStoredAccessPolicy](/powershell/module/azure.storage/set-azurestoragecontainerstoredaccesspolicy)
  - [Remove-AzureStorageContainerStoredAccessPolicy](/powershell/module/azure.storage/remove-azurestoragecontainerstoredaccesspolicy)

  
<!-- Daniel 3/28 -->
- In the user portal, when you try to upload a blob using the **OAuth(preview)** option, the task fails with an error message. To work around this issue, upload the blob using the **SAS** option.

- When logged into the Azure Stack portals you might see notifications about the global Azure portal. You can safely ignore these notifications, as they do not currently apply to Azure Stack (for example, "1 new update - The following updates are now available: Azure portal April 2019 update").

- In the user portal dashboard, when you select the **Feedback** tile, an empty browser tab opens. As a workaround, you can use [Azure Stack User Voice](https://aka.ms/azurestackuservoice) to file a User Voice request.

<!-- ### Health and monitoring -->

### Compute

- When creating a new Windows Virtual Machine (VM), the following error may be displayed:

   `'Failed to start virtual machine 'vm-name'. Error: Failed to update serial output settings for VM 'vm-name'`

   The error occurs if you enable boot diagnostics on a VM but delete your boot diagnostics storage account. To work around this issue, recreate the storage account with the same name as you used previously.

<!-- 2967447 - IS, ASDK, to be fixed in 1902 -->
- The Virtual Machine Scale Set creation experience provides CentOS-based 7.2 as an option for deployment. Because that image is not available on Azure Stack Marketplace, either select another operating system for your deployment, or use an Azure Resource Manager template specifying another CentOS image that has been downloaded prior to deployment from the marketplace by the operator.

<!-- TBD - IS ASDK -->
- After applying the 1903 update, you might encounter the following issues when deploying VMs with Managed Disks:

   - If the subscription was created before the 1808 update, deploying a VM with Managed Disks might fail with an internal error message. To resolve the error, follow these steps for each subscription:
      1. In the Tenant portal, go to **Subscriptions** and find the subscription. Select **Resource Providers**, then select **Microsoft.Compute**, and then click **Re-register**.
      2. Under the same subscription, go to **Access Control (IAM)**, and verify that **Azure Stack - Managed Disk** is listed.
   - If you have configured a multi-tenant environment, deploying VMs in a subscription associated with a guest directory might fail with an internal error message. To resolve the error, follow these steps in [this article](../enable-multitenancy.md#register-a-guest-directory) to reconfigure each of your guest directories.

- An Ubuntu 18.04 VM created with SSH authorization enabled will not allow you to use the SSH keys to sign in. As a workaround, use VM access for the Linux extension to implement SSH keys after provisioning, or use password-based authentication.

- If you do not have a Hardware Lifecycle Host (HLH): before build 1902, you had to set group policy **Computer Configuration\Windows Settings\Security Settings\Local Policies\Security Options** to **Send LM & NTLM - use NTLMv2 session security if negotiated**. Since build 1902, you must leave it as **Not Defined** or set it to **Send NTLMv2 response only** (which is the default value). Otherwise, you won't be able to establish a PowerShell remote session and you will see an **Access is denied** error:

   ```powershell
   $Session = New-PSSession -ComputerName x.x.x.x -ConfigurationName PrivilegedEndpoint -Credential $Cred
   New-PSSession : [x.x.x.x] Connecting to remote server x.x.x.x failed with the following error message : Access is denied. For more information, see the
   about_Remote_Troubleshooting Help topic.
   At line:1 char:12
   + $Session = New-PSSession -ComputerName x.x.x.x -ConfigurationNa ...
   +            ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      + CategoryInfo          : OpenError: (System.Manageme....RemoteRunspace:RemoteRunspace) [New-PSSession], PSRemotingTransportException
      + FullyQualifiedErrorId : AccessDenied,PSSessionOpenFailed
   ```

- You cannot remove a scale set from the **Virtual Machine Scale Sets** blade. As a workaround, select the scale set that you want to remove, then click the **Delete** button from the **Overview** pane.

- Creating VMs in an availability set of 3 fault domains and creating a virtual machine scale set instance fails with a **FabricVmPlacementErrorUnsupportedFaultDomainSize** error during the update process on a 4-node Azure Stack environment. You can create single VMs in an availability set with 2 fault domains successfully. However, scale set instance creation is still not available during the update process on a 4-node Azure Stack.

### Networking

<!-- 3239127 - IS, ASDK -->
- In the Azure Stack portal, when you change a static IP address for an IP configuration that is bound to a network adapter attached to a VM instance, you will see a warning message that states

    `The virtual machine associated with this network interface will be restarted to utilize the new private IP address...`

    You can safely ignore this message; the IP address will be changed even if the VM instance does not restart.

<!-- 3632798 - IS, ASDK -->
- In the portal, if you add an inbound security rule and select **Service Tag** as the source, several options are displayed in the **Source Tag** list that are not available for Azure Stack. The only options that are valid in Azure Stack are as follows:

  - **Internet**
  - **VirtualNetwork**
  - **AzureLoadBalancer**

  The other options are not supported as source tags in Azure Stack. Similarly, if you add an outbound security rule and select **Service Tag** as the destination, the same list of options for **Source Tag** is displayed. The only valid options are the same as for **Source Tag**, as described in the previous list.

- Network security groups (NSGs) do not work in Azure Stack in the same way as global Azure. In Azure, you can set multiple ports on one NSG rule (using the portal, PowerShell, and Resource Manager templates). In Azure Stack however, you cannot set multiple ports on one NSG rule via the portal. To work around this issue, use a Resource Manager template or PowerShell to set these additional rules.

<!-- 3203799 - IS, ASDK -->
- Azure Stack does not support attaching more than 4 Network Interfaces (NICs) to a VM instance today, regardless of the instance size.

<!-- ### SQL and MySQL-->

### App Service

<!-- 2352906 - IS ASDK -->
- Tenants must register the storage resource provider before creating their first Azure Function in the subscription.
- Some tenant portal user experiences are broken due to an incompatibility with the portal framework in 1903; principally, the UX for deployment slots, testing in production and site extensions. To work around this issue, use the [Azure App Service PowerShell module](/azure/app-service/deploy-staging-slots#automate-with-powershell) or the [Azure CLI](/cli/azure/webapp/deployment/slot). The portal experience will be restored in the upcoming release of Azure App Service on Azure Stack 1.6 (Update 6).

<!-- ### Usage -->


<!-- #### Identity -->
<!-- #### Marketplace -->

### Syslog

- The syslog configuration is not persisted through an update cycle, causing the syslog client to lose its configuration, and the syslog messages to stop being forwarded. This issue applies to all versions of Azure Stack since the GA of the syslog client (1809). To work around this issue, reconfigure the syslog client after applying an Azure Stack update.

## Download the update

You can download the Azure Stack 1903 update package from [here](https://aka.ms/azurestackupdatedownload).

In connected scenarios only, Azure Stack deployments periodically check a secured endpoint and automatically notify you if an update is available for your cloud. For more information, see [managing updates for Azure Stack](../azure-stack-updates.md#how-to-know-an-update-is-available).

## Next steps

- For an overview of the update management in Azure Stack, see [Manage updates in Azure Stack overview](../azure-stack-updates.md).
- For more information about how to apply updates with Azure Stack, see [Apply updates in Azure Stack](../azure-stack-apply-updates.md).
- To review the servicing policy for Azure Stack integrated systems, and what you must do to keep your system in a supported state, see [Azure Stack servicing policy](../azure-stack-servicing-policy.md).
- To use the Privileged End Point (PEP) to monitor and resume updates, see [Monitor updates in Azure Stack using the privileged endpoint](../azure-stack-monitor-update.md).
::: moniker-end

::: moniker range="azs-1902"
## 1902 archived release notes
*Applies to: Azure Stack integrated systems*

This article describes the contents of the 1902 update package. The update includes improvements, fixes, and new features for this version of Azure Stack. This article also describes known issues in this release, and includes a link to download the update. Known issues are divided into issues directly related to the update process, and issues with the build (post-installation).

> [!IMPORTANT]  
> This update package is only for Azure Stack integrated systems. Do not apply this update package to the Azure Stack Development Kit.

## Build reference

The Azure Stack 1902 update build number is **1.1902.0.69**.

### Update type

The Azure Stack 1902 update build type is **Full**. For more information about update build types, see the [Manage updates in Azure Stack](../azure-stack-updates.md) article.

## Hotfixes

Azure Stack releases hotfixes on a regular basis. Be sure to install the [latest Azure Stack hotfix](#azure-stack-hotfixes) for 1901 before updating Azure Stack to 1902.

Azure Stack hotfixes are only applicable to Azure Stack integrated systems; do not attempt to install hotfixes on the ASDK.

### Azure Stack hotfixes

- **1901**: [KB 4500636 - Azure Stack hotfix 1.1901.5.109](https://support.microsoft.com/help/4500636)
- **1902**: [KB 4500637 - Azure Stack hotfix 1.1902.3.75](https://support.microsoft.com/help/4500637)

## Prerequisites

> [!IMPORTANT]
> You can install 1902 directly from either the **1.1901.0.95** or **1.1901.0.99** release, without first installing any 1901 hotfix. However, if you have installed the older **1901.2.103** hotfix, you must install the newer [1901.3.105 hotfix](https://support.microsoft.com/help/4495662) before proceeding to 1902.

- Before you start installation of this update, run [Test-AzureStack](../azure-stack-diagnostic-test.md) with the following parameters to validate the status of your Azure Stack and resolve any operational issues found, including all warnings and failures. Also review active alerts, and resolve any that require action:

    ```powershell
    Test-AzureStack -Include AzsDefenderSummary, AzsHostingInfraSummary, AzsHostingInfraUtilization, AzsInfraCapacity, AzsInfraRoleSummary, AzsPortalAPISummary, AzsSFRoleSummary, AzsStampBMCSummary, AzsHostingServiceCertificates
    ```

  If the `AzsControlPlane` parameter is included when **Test-AzureStack** is executed, you will see the following failure in the **Test-AzureStack** output: **FAIL Azure Stack Control Plane Websites Summary**. You can safely ignore this specific error.

- When Azure Stack is managed by System Center Operations Manager, make sure to update the [Management Pack for Microsoft Azure Stack](https://www.microsoft.com/download/details.aspx?id=55184) to version 1.0.3.11 before applying 1902.

- The package format for the Azure Stack update has changed from **.bin/.exe/.xml** to **.zip/.xml** starting with the 1902 release. Customers with connected Azure Stack scale units will see the **Update available** message in the portal. Customers that are not connected can now simply download and import the .zip file with the corresponding .xml.

<!-- ## New features -->

<!-- ## Fixed issues -->

## Improvements

- The 1902 build introduces a new user interface on the Azure Stack Administrator portal for creating plans, offers, quotas, and add-on plans. For more information, including screenshots, see [Create plans, offers, and quotas](../azure-stack-create-plan.md).

<!-- 1460884    Hotfix: Adding StorageController service permission to talk to ClusterOrchestrator    Add node -->
- Improvements to the reliability of capacity expansion during an add node operation when switching the scale unit state from "Expanding storage" to "Running".

<!--
1426197    3852583: Increase Global VM script mutex wait time to accommodate enclosed operation timeout    PNU
1399240    3322580: [PNU] Optimize the DSC resource execution on the Host    PNU
1398846    Bug 3751038: ECEClient.psm1 should provide cmdlet to resume action plan instance    PNU
1398818    3685138, 3734779: ECE exception logging, VirtualMachine ConfigurePending should take node name from execution context    PNU
1381018    [1902] 3610787 - Infra VM creation should fail if the ClusterGroup already exists    PNU
-->
- To improve package integrity and security, as well as easier management for offline ingestion, Microsoft has changed the format of the Update package from .exe and .bin files to a .zip file. The new format adds additional reliability of the unpacking process that at times, can cause the preparation of the update to stall. The same package format also applies to update packages from your OEM.
- To improve the Azure Stack operator experience when running Test-AzureStack, operators can now simply use, "Test-AzureStack -Group UpdateReadiness" as opposed to passing ten additional parameters after an Include statement.

  ```powershell
    Test-AzureStack -Group UpdateReadiness  
  ```  
  
- To improve on the overall reliability and availability of core infrastructure services during the update process, the native Update resource provider as part of the update action plan will detect and invoke automatic global remediations as-needed. Global remediation "repair" workflows include:

  - Checking for infrastructure virtual machines that are in a non-optimal state and attempt to repair them as-needed.
  - Check for SQL service issues as part of the control plan and attempt to repair them as-needed.
  - Check the state of the Software Load Balancer (SLB) service as part of the Network Controller (NC) and attempt to repair them as-needed.
  - Check the state of the Network Controller (NC) service and attempt to repair it as needed
  - Check the state of the Emergency Recovery Console Service (ERCS) service fabric nodes and repair them as needed.
  - Check the state of the infrastructure role and repair as needed.
  - Check the state of the Azure Consistent Storage (ACS) service fabric nodes and repair them as needed.

<!-- 
1426690    [SOLNET] 3895478-Get-AzureStackLog_Output got terminated in the middle of network log    Diagnostics
1396607    3796092: Move Blob services log from Storage role to ACSBlob role to reduce the log size of Storage    Diagnostics
1404529    3835749: Enable Group Policy Diagnostic Logs    Diagnostics
1436561    Bug 3949187: [Bug Fix] Remove AzsStorageSvcsSummary test from SecretRotationReadiness Test-AzureStack flag    Diagnostics
1404512    3849946: Get-AzureStackLog should collect all child folders from c:\Windows\Debug    Diagnostics 
-->
- Improvements to Azure Stack diagnostic tools to improve log collection reliability and performance. Additional logging for networking and identity services. 

<!-- 1384958    Adding a Test-AzureStack group for Secret Rotation    Diagnostics -->
- Improvements to the reliability of Test-AzureStack for secret rotation readiness test.

<!-- 1404751    3617292: Graph: Remove dependency on ADWS.    Identity -->
- Improvements to increase AD Graph reliability when communicating with customer's Active Directory environment

<!-- 1391444    [ISE] Telemetry for Hardware Inventory - Fill gap for hardware inventory info    System info -->
- Improvements hardware inventory collection in Get-AzureStackStampInformation.

- To improve reliability of operations running on ERCS infrastructure, the memory for each ERCS instance increases from 8 GB to 12 GB. On an Azure Stack integrated systems installation, this results in a 12 GB increase overall.

<!-- 110303935 IcM Reported by HKEX -->
- 1902 fixes an issue in the Network Controllers VSwitch Service, in which all VMs on a specific node went offline.  The issue caused it to get stuck in a primary loss state, where the primary cannot be contacted but the role has not been failed over to another, healthy instance, which could only be resolved by contacting Microsoft support services.

> [!IMPORTANT]
> To make sure the patch and update process results in the least amount of tenant downtime, make sure your Azure Stack stamp has more than 12 GB of available space in the **Capacity** blade. You can see this memory increase reflected in the **Capacity** blade after a successful installation of the update.

## Common vulnerabilities and exposures

This update installs the following security updates:  
- [ADV190005](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/ADV190006)
- [CVE-2019-0595](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0595)
- [CVE-2019-0596](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0596)
- [CVE-2019-0597](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0597)
- [CVE-2019-0598](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0598)
- [CVE-2019-0599](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0599)
- [CVE-2019-0600](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0600)
- [CVE-2019-0601](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0601)
- [CVE-2019-0602](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0602)
- [CVE-2019-0615](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0615)
- [CVE-2019-0616](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0616)
- [CVE-2019-0618](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0618)
- [CVE-2019-0619](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0619)
- [CVE-2019-0621](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0621)
- [CVE-2019-0623](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0623)
- [CVE-2019-0625](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0625)
- [CVE-2019-0626](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0626)
- [CVE-2019-0627](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0627)
- [CVE-2019-0628](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0628)
- [CVE-2019-0630](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0630)
- [CVE-2019-0631](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0631)
- [CVE-2019-0632](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0632)
- [CVE-2019-0633](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0633)
- [CVE-2019-0635](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0635)
- [CVE-2019-0636](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0636)
- [CVE-2019-0656](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0656)
- [CVE-2019-0659](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0659)
- [CVE-2019-0660](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0660)
- [CVE-2019-0662](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0662)
- [CVE-2019-0663](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0663)

For more information about these vulnerabilities, click on the preceding links, or see Microsoft Knowledge Base articles [4487006](https://support.microsoft.com/en-us/help/4487006).

## Known issues with the update process

- When attempting to install an Azure Stack update, the status for the update might fail and change state to **PreparationFailed**. This is caused by the update resource provider (URP) being unable to properly transfer the files from the storage container to an internal infrastructure share for processing. Starting with version 1901 (1.1901.0.95), you can work around this issue by clicking **Update now** again (not **Resume**). The URP then cleans up the files from the previous attempt, and starts the download again.

- When you run [Test-AzureStack](../azure-stack-diagnostic-test.md), a warning message from the Baseboard Management Controller (BMC) is displayed. You can safely ignore this warning.

- <!-- 2468613 - IS --> During installation of this update, you might see alerts with the title `Error - Template for FaultType UserAccounts.New is missing.`  You can safely ignore these alerts. The alerts close automatically after the installation of this update completes.

## Post-update steps

- After the installation of this update, install any applicable hotfixes. For more information, see [Hotfixes](#hotfixes), as well as our [Servicing Policy](../azure-stack-servicing-policy.md).  

- Retrieve the data at rest encryption keys and securely store them outside of your Azure Stack deployment. Follow the [instructions on how to retrieve the keys](../azure-stack-security-bitlocker.md).

## Known issues (post-installation)

The following are post-installation known issues for this build version.

### Portal

<!-- 2930820 - IS ASDK --> 
- In both the administrator and user portals, if you search for "Docker," the item is incorrectly returned. It is not available in Azure Stack. If you try to create it, a blade with an error indication is displayed. 

<!-- 2931230 - IS  ASDK --> 
- Plans that are added to a user subscription as an add-on plan cannot be deleted, even when you remove the plan from the user subscription. The plan will remain until the subscriptions that reference the add-on plan are also deleted. 

<!-- TBD - IS ASDK --> 
- The two administrative subscription types that were introduced with version 1804 should not be used. The subscription types are **Metering subscription**, and **Consumption subscription**. These subscription types are visible in new Azure Stack environments beginning with version 1804 but are not yet ready for use. You should continue to use the **Default Provider** subscription type.

<!-- 3557860 - IS ASDK --> 
- Deleting user subscriptions results in orphaned resources. As a workaround, first delete user resources or the entire resource group, and then delete the user subscriptions.

<!-- 1663805 - IS ASDK --> 
- You cannot view permissions to your subscription using the Azure Stack portals. As a workaround, use [PowerShell to verify permissions](/powershell/module/azs.subscriptions.admin/get-azssubscriptionplan).

<!-- Daniel 3/28 -->
- In the user portal, when you navigate to a blob within a storage account and try to open **Access Policy** from the navigation tree, the subsequent window fails to load. To work around this issue, the following PowerShell cmdlets enable creating, retrieving, setting and deleting access policies, respectively:

  - [New-AzureStorageContainerStoredAccessPolicy](/powershell/module/azure.storage/new-azurestoragecontainerstoredaccesspolicy)
  - [Get-AzureStorageContainerStoredAccessPolicy](/powershell/module/azure.storage/get-azurestoragecontainerstoredaccesspolicy)
  - [Set-AzureStorageContainerStoredAccessPolicy](/powershell/module/azure.storage/set-azurestoragecontainerstoredaccesspolicy)
  - [Remove-AzureStorageContainerStoredAccessPolicy](/powershell/module/azure.storage/remove-azurestoragecontainerstoredaccesspolicy)

<!-- ### Health and monitoring -->

### Compute

- When creating a new Windows Virtual Machine (VM), the following error may be displayed:

   `'Failed to start virtual machine 'vm-name'. Error: Failed to update serial output settings for VM 'vm-name'`

   The error occurs if you enable boot diagnostics on a VM but delete your boot diagnostics storage account. To work around this issue, recreate the storage account with the same name as you used previously.

<!-- 2967447 - IS, ASDK, to be fixed in 1902 -->
- The virtual machine scale set creation experience provides CentOS-based 7.2 as an option for deployment. Because that image is not available on Azure Stack, either select another operating system for your deployment, or use an Azure Resource Manager template specifying another CentOS image that has been downloaded prior to deployment from the marketplace by the operator.  

<!-- TBD - IS ASDK --> 
- After applying the 1902 update, you might encounter the following issues when deploying VMs with Managed Disks:

   - If the subscription was created before the 1808 update, deploying a VM with Managed Disks might fail with an internal error message. To resolve the error, follow these steps for each subscription:
      1. In the Tenant portal, go to **Subscriptions** and find the subscription. Select **Resource Providers**, then select **Microsoft.Compute**, and then click **Re-register**.
      2. Under the same subscription, go to **Access Control (IAM)**, and verify that **Azure Stack - Managed Disk** is listed.
   - If you have configured a multi-tenant environment, deploying VMs in a subscription associated with a guest directory might fail with an internal error message. To resolve the error, follow these steps in [this article](../enable-multitenancy.md#register-a-guest-directory) to reconfigure each of your guest directories.

- An Ubuntu 18.04 VM created with SSH authorization enabled will not allow you to use the SSH keys to log in. As a workaround, use VM access for the Linux extension to implement SSH keys after provisioning, or use password-based authentication.

- You cannot remove a scale set from the **Virtual Machine Scale Sets** blade. As a workaround, select the scale set that you want to remove, then click the **Delete** button from the **Overview** pane.

- Creating VMs in an availability set of 3 fault domains and creating a virtual machine scale set instance fails with a **FabricVmPlacementErrorUnsupportedFaultDomainSize** error during the update process on a 4-node Azure Stack environment. You can create single VMs in an availability set with 2 fault domains successfully. However, scale set instance creation is still not available during the update process on a 4-node Azure Stack.

### Networking  

<!-- 3239127 - IS, ASDK -->
- In the Azure Stack portal, when you change a static IP address for an IP configuration that is bound to a network adapter attached to a VM instance, you will see a warning message that states 

    `The virtual machine associated with this network interface will be restarted to utilize the new private IP address...`.

    You can safely ignore this message; the IP address will be changed even if the VM instance does not restart.

<!-- 3632798 - IS, ASDK -->
- In the portal, if you add an inbound security rule and select **Service Tag** as the source, several options are displayed in the **Source Tag** list that are not available for Azure Stack. The only options that are valid in Azure Stack are as follows:

  - **Internet**
  - **VirtualNetwork**
  - **AzureLoadBalancer**
  
  The other options are not supported as source tags in Azure Stack. Similarly, if you add an outbound security rule and select **Service Tag** as the destination, the same list of options for **Source Tag** is displayed. The only valid options are the same as for **Source Tag**, as described in the previous list.

- Network security groups (NSGs) do not work in Azure Stack in the same way as global Azure. In Azure, you can set multiple ports on one NSG rule (using the portal, PowerShell, and Resource Manager templates). In Azure Stack however, you cannot set multiple ports on one NSG rule via the portal. To work around this issue, use a Resource Manager template or PowerShell to set these additional rules.

<!-- 3203799 - IS, ASDK -->
- Azure Stack does not support attaching more than 4 Network Interfaces (NICs) to a VM instance today, regardless of the instance size.

- In the user portal, if you attempt to add a **Backend Pool** to a **Load Balancer**, the operation fails with the error message **Failed to update Load Balancer....**  To work around this issue, use PowerShell, CLI, or an Azure Resource Manager template to associate the backend pool with a load balancer resource.

- In the user portal, if you attempt to create an **Inbound NAT Rule** for a **Load Balancer**, the operation fails with the error message **Failed to update Load Balancer....**  To work around this issue, use PowerShell, CLI, or an Azure Resource Manager template to associate the backend pool with a load balancer resource.

- In the user portal, the **Create Load Balancer** window shows an option to create a **Standard** load balancer SKU. This option is not supported in Azure Stack.

<!-- ### SQL and MySQL-->

### App Service

<!-- 2352906 - IS ASDK --> 
- You must register the storage resource provider before you create your first Azure Function in the subscription.


<!-- ### Usage -->

 
<!-- #### Identity -->
<!-- #### Marketplace -->

### Syslog 

- The syslog configuration is not persisted through an update cycle, causing the syslog client to lose its configuration, and the syslog messages to stop being forwarded. This issue applies to all versions of Azure Stack since the GA of the syslog client (1809). To work around this issue, reconfigure the syslog client after applying an Azure Stack update.

## Download the update

You can download the Azure Stack 1902 update package from [here](https://aka.ms/azurestackupdatedownload). 

In connected scenarios only, Azure Stack deployments periodically check a secured endpoint and automatically notify you if an update is available for your cloud. For more information, see [managing updates for Azure Stack](../azure-stack-updates.md#how-to-know-an-update-is-available).

## Next steps

- For an overview of the update management in Azure Stack, see [Manage updates in Azure Stack overview](../azure-stack-updates.md).  
- For more information about how to apply updates with Azure Stack, see [Apply updates in Azure Stack](../azure-stack-apply-updates.md).
- To review the servicing policy for Azure Stack integrated systems, and what you must do to keep your system in a supported state, see [Azure Stack servicing policy](../azure-stack-servicing-policy.md).  
- To use the Privileged End Point (PEP) to monitor and resume updates, see [Monitor updates in Azure Stack using the privileged endpoint](../azure-stack-monitor-update.md).  
::: moniker-end

::: moniker range="azs-1901"
## 1901 archived release notes
*Applies to: Azure Stack integrated systems*

This article describes the contents of the 1901 update package. The update includes improvements, fixes, and new features for this version of Azure Stack. This article also describes known issues in this release, and includes a link to download the update. Known issues are divided into issues directly related to the update process, and issues with the build (post-installation).

> [!IMPORTANT]  
> This update package is only for Azure Stack integrated systems. Do not apply this update package to the Azure Stack Development Kit.

## Build reference

The Azure Stack 1901 update build number is **1.1901.0.95** or **1.1901.0.99** after February 26th, 2019. See the following note:

> [!IMPORTANT]  
> Microsoft has discovered an issue that can impact customers updating from 1811 (1.1811.0.101) to 1901, and has released an updated 1901 package to address the  issue: build 1.1901.0.99, updated from 1.1901.0.95. Customers that have already updated to 1.1901.0.95 do not need to take further action.
>
> Connected customers that are on 1811 will automatically see the new 1901 (1.1901.0.99) package available in the Administrator portal, and should install it when ready. Disconnected customers can download and import the new 1901 package using the same process [described here](../azure-stack-apply-updates.md).
>
> Customers with either version of 1901 will not be impacted when installing the next full or hotfix package.

## Hotfixes

Azure Stack releases hotfixes on a regular basis. Be sure to install the [latest Azure Stack hotfix](#azure-stack-hotfixes) for 1811 before updating Azure Stack to 1901.

Azure Stack hotfixes are only applicable to Azure Stack integrated systems; do not attempt to install hotfixes on the ASDK.

### Azure Stack hotfixes

If you already have 1901 and you have not installed any hotfixes yet, you can install 1902 directly, without first installing the 1901 hotfix.

- **1811**: No current hotfix available.
- **1901**: [KB 4500636 - Azure Stack hotfix 1.1901.5.109](https://support.microsoft.com/help/4500636)

## Prerequisites

> [!IMPORTANT]
> Install the [latest Azure Stack hotfix](#azure-stack-hotfixes) for 1811 (if any) before updating to 1901. If you already have 1901 and you have not installed any hotfixes yet, you can install 1902 directly, without first installing the 1901 hotfix.

- Before you start installation of this update, run [Test-AzureStack](../azure-stack-diagnostic-test.md) with the following parameters to validate the status of your Azure Stack and resolve any operational issues found, including all warnings and failures. Also review active alerts, and resolve any that require action:

    ```powershell
    Test-AzureStack -Include AzsControlPlane, AzsDefenderSummary, AzsHostingInfraSummary, AzsHostingInfraUtilization, AzsInfraCapacity, AzsInfraRoleSummary, AzsPortalAPISummary, AzsSFRoleSummary, AzsStampBMCSummary, AzsHostingServiceCertificates
    ```

- When Azure Stack is managed by System Center Operations Manager, be sure to update the Management Pack for Microsoft Azure Stack to version 1.0.3.11 before applying 1901.

## New features

This update includes the following new features and improvements for Azure Stack:

- Managed images on Azure Stack enable you to create a managed image object on a generalized VM (both unmanaged and managed) that can only create managed disk VMs going forward. For more information, see [Azure Stack Managed Disks](../../user/azure-stack-managed-disk-considerations.md#managed-images).

- **AzureRm 2.4.0**
   * **AzureRm.Profile**  
         Bug fix - `Import-AzureRmContext` to deserialize the saved token correctly.  
   * **AzureRm.Resources**  
         Bug fix - `Get-AzureRmResource` to query case insensitively by resource type.  
   * **Azure.Storage**  
         AzureRm rollup module now includes the already published version 4.5.0 supporting the **api-version 2017-07-29**.  
   * **AzureRm.Storage**  
         AzureRm rollup module now includes the already published version 5.0.4 supporting the **api-version 2017-10-01**.  
   * **AzureRm.Compute**  
         Added simple parameter sets in `New-AzureRmVM` and `New-AzureRmVmss`, `-Image` parameter supports specifying user images.  
   * **AzureRm.Insights**  
         AzureRm rollup module now includes the already published version 5.1.5 supporting the **api-version 2018-01-01** for metrics, metric definitions resource types.

- **AzureStack 1.7.1**
   This a breaking change release. For details on the breaking changes, refer to https://aka.ms/azspshmigration171
   * **Azs.Backup.Admin Module**  
         Breaking change: Backup changes to cert-based encryption mode. Support for symmetric keys is deprecated.  
   * **Azs.Fabric.Admin Module**  
         `Get-AzsInfrastructureVolume` has been deprecated. Use the new cmdlet `Get-AzsVolume`.  
         `Get-AzsStorageSystem` has been deprecated.  Use the new cmdlet `Get-AzsStorageSubSystem`.  
         `Get-AzsStoragePool` has been deprecated. The `StorageSubSystem` object contains the capacity property.  
   * **Azs.Compute.Admin Module**  
         Bug fix - `Add-AzsPlatformImage`, `Get-AzsPlatformImage`: Calling `ConvertTo-PlatformImageObject` only in the success path.  
         BugFix - `Add-AzsVmExtension`, `Get-AzsVmExtension`: Calling ConvertTo-VmExtensionObject only in the success path.  
   * **Azs.Storage.Admin Module**  
         Bug fix - New Storage Quota uses defaults if none provided.

To review the reference for the updated modules, see [Azure Stack Module Reference](/azure-stack/operator?preserve-view=true&view=azurestackps-1.6.0&viewFallbackFrom=azurestackps-1.7.0).

## Fixed issues

- Fixed an issue in which the portal showed an option to create policy-based VPN gateways, which are not supported in Azure Stack. This option has been removed from the portal.

<!-- 16523695 - IS, ASDK -->
- Fixed an issue in which after updating your DNS Settings for your Virtual Network from **Use Azure Stack DNS** to **Custom DNS**, the instances were not updated with the new setting.

- <!-- 3235634 - IS, ASDK -->
  Fixed an issue in which deploying VMs with sizes containing a **v2** suffix; for example, **Standard_A2_v2**, required specifying the suffix as **Standard_A2_v2** (lowercase v). As with global Azure, you can now use **Standard_A2_V2** (uppercase V).

<!--  2795678 - IS, ASDK --> 
- Fixed an issue that produced a warning when you used the portal to create virtual machines (VMs) in a premium VM size (DS,Ds_v2,FS,FSv2). The VM was created in a standard storage account. Although this did not affect functionally, IOPs, or billing, the warning has been fixed.

<!-- 1264761 - IS ASDK -->  
- Fixed an issue with the **Health controller** component that was generating the following alerts. The alerts could be safely ignored:

    - Alert #1:
       - NAME:  Infrastructure role unhealthy
       - SEVERITY: Warning
       - COMPONENT: Health controller
       - DESCRIPTION: The health controller Heartbeat Scanner is unavailable. This may affect health reports and metrics.  

    - Alert #2:
       - NAME:  Infrastructure role unhealthy
       - SEVERITY: Warning
       - COMPONENT: Health controller
       - DESCRIPTION: The health controller Fault Scanner is unavailable. This may affect health reports and metrics.


<!-- 3507629 - IS, ASDK --> 
- Fixed an issue when setting the value of Managed Disks quotas under [compute quota types](../azure-stack-quota-types.md#compute-quota-types) to 0, it is equivalent to the default value of 2048 GiB. The zero quota value now is respected.

<!-- 2724873 - IS --> 
- Fixed an issue when using the PowerShell cmdlets **Start-AzsScaleUnitNode** or  **Stop-AzsScaleUnitNode** to manage scale units, in which the first attempt to start or stop the scale unit might fail.

<!-- 2724961- IS ASDK --> 
- Fixed an issue in which you registered the **Microsoft.Insight** resource provider in the subscription settings, and created a Windows VM with Guest OS Diagnostic enabled, but the CPU Percentage chart in the VM overview page did not show metrics data. The data now correctly displays.

- Fixed an issue in which running the **Get-AzureStackLog** cmdlet failed after running **Test-AzureStack** in the same privileged endpoint (PEP) session. You can now use the same PEP session in which you executed **Test-AzureStack**.

<!-- bug 3615401, IS -->
- Fixed issue with automatic backups where the scheduler service would go into disabled state unexpectedly. 

<!--2850083, IS ASDK -->
- Removed the **Reset Gateway** button from the Azure Stack portal, which threw an error if the button was clicked. This button serves no function in Azure Stack, as Azure Stack has a multi-tenant gateway rather than dedicated VM instances for each tenant VPN Gateway, so it was removed to prevent confusion. 

<!-- 3209594, IS ASDK -->
- Removed the **Effective Security Rules** link from the **Networking Properties** blade as this feature is not supported in Azure Stack. Having the link present gave the impression that this feature was supported but not working. To alleviate confusion, we removed the link.

<!-- 3139614 | IS -->
- Fixed an issue in which after an update was applied to Azure Stack from an OEM, the **Update available** notification did not appear in the Azure Stack administrator portal.

## Changes

<!-- 3083238 IS -->
- Security enhancements in this update result in an increase in the backup size of the directory service role. For updated sizing guidance for the external storage location, see the [infrastructure backup documentation../azure-stack-backup-reference.md#storage-location-sizing). This change results in a longer time to complete the backup due to the larger size data transfer. This change impacts integrated systems. 

- Starting in January 2019, you can deploy Kubernetes clusters on Active Directory Federated Services (AD FS) registered, connected Azure Stack stamps (internet access is required). Follow the instructions [here](../azure-stack-solution-template-kubernetes-cluster-add.md) to download the new Kubernetes Marketplace item. Follow the instructions [here](../../user/azure-stack-solution-template-kubernetes-adfs.md) to deploy a Kubernetes cluster. Note the new parameters for indicating whether the target system is ADD or AD FS registered. If it is AD FS, new fields are available to enter the Key Vault parameters in which the deployment certificate is stored.

   Note that even with AD FS support, the deployment of Kubernetes clusters requires internet access.

- After installing updates or hotfixes to Azure Stack, new features may be introduced which require new permissions to be granted to one or more identity applications. Granting these permissions requires administrative access to the home directory, and so it cannot be done automatically. For example:

   ```powershell
   $adminResourceManagerEndpoint = "https://adminmanagement.<region>.<domain>"
   $homeDirectoryTenantName = "<homeDirectoryTenant>.onmicrosoft.com" # This is the primary tenant Azure Stack is registered to

   Update-AzsHomeDirectoryTenant -AdminResourceManagerEndpoint $adminResourceManagerEndpoint `
     -DirectoryTenantName $homeDirectoryTenantName -Verbose
   ```

- There is a new consideration for accurately planning Azure Stack capacity. With the 1901 update, there is now a limit on the total number of Virtual Machines that can be created.  This limit is intended to be temporary to avoid solution instability. The source of the stability issue at higher numbers of VMs is being addressed but a specific timeline for remediation has not yet been determined. With the 1901 update, there is now a per server limit of 60 VMs with a total solution limit of 700.  For example, an 8 server Azure Stack VM limit would be 480 (8 * 60).  For a 12 to 16 server Azure Stack solution the limit would be 700. This limit has been created keeping all the compute capacity considerations in mind such as the resiliency reserve and the CPU virtual to physical ratio that an operator would like to maintain on the stamp. For more information, see the new release of the capacity planner.  
In the event that the VM scale limit has been reached, the following error codes would be returned as a result: VMsPerScaleUnitLimitExceeded, VMsPerScaleUnitNodeLimitExceeded. 
 

- The Compute API version has increased to 2017-12-01.

- Infrastructure backup now requires a certificate with a public key only (.CER) for encryption of backup data. Symmetric encryption key support is deprecated starting in 1901. If infrastructure backup is configured before updating to 1901, the encryption keys will remain in place. You will have at least 2 more updates with backwards compatibility support to update backup settings. For more information, see [Azure Stack infrastructure backup best practices](../azure-stack-backup-best-practices.md).

## Common vulnerabilities and exposures

This update installs the following security updates:  

- [CVE-2018-8477](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2018-8477)
- [CVE-2018-8514](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2018-8514)
- [CVE-2018-8580](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2018-8580)
- [CVE-2018-8595](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2018-8595)
- [CVE-2018-8596](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2018-8596)
- [CVE-2018-8598](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2018-8598)
- [CVE-2018-8621](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2018-8621)
- [CVE-2018-8622](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2018-8622)
- [CVE-2018-8627](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2018-8627)
- [CVE-2018-8637](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2018-8637)
- [CVE-2018-8638](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2018-8638)
- [ADV190001](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/ADV190001)
- [CVE-2019-0536](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0536)
- [CVE-2019-0537](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0537)
- [CVE-2019-0545](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0545)
- [CVE-2019-0549](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0549)
- [CVE-2019-0553](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0553)
- [CVE-2019-0554](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0554)
- [CVE-2019-0559](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0559)
- [CVE-2019-0560](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0560)
- [CVE-2019-0561](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0561)
- [CVE-2019-0569](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0569)
- [CVE-2019-0585](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0585)
- [CVE-2019-0588](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2019-0588)


For more information about these vulnerabilities, click on the preceding links, or see Microsoft Knowledge Base articles [4480977](https://support.microsoft.com/en-us/help/4480977).

## Known issues with the update process

- When attempting to install an Azure Stack update, the status for the update might fail and change state to **PreparationFailed**. This is caused by the update resource provider (URP) being unable to properly transfer the files from the storage container to an internal infrastructure share for processing. Starting with version 1901 (1.1901.0.95), you can work around this issue by clicking **Update now** again (not **Resume**). The URP then cleans up the files from the previous attempt, and starts the download again.

- When running [Test-AzureStack](../azure-stack-diagnostic-test.md), if either the **AzsInfraRoleSummary** or the **AzsPortalApiSummary** test fails, you are prompted to run **Test-AzureStack** with the `-Repair` flag.  If you run this command, it fails with the following error message:  `Unexpected exception getting Azure Stack health status. Cannot bind argument to parameter 'TestResult' because it is null.`

- When you run [Test-AzureStack](../azure-stack-diagnostic-test.md), a warning message from the Baseboard Management Controller (BMC) is displayed. You can safely ignore this warning.

- <!-- 2468613 - IS --> During installation of this update, you might see alerts with the title `Error - Template for FaultType UserAccounts.New is missing.`  You can safely ignore these alerts. The alerts close automatically after the installation of this update completes.

## Post-update steps

- After the installation of this update, install any applicable hotfixes. For more information, see [Hotfixes](#hotfixes), as well as our [Servicing Policy](../azure-stack-servicing-policy.md).  

- Retrieve the data at rest encryption keys and securely store them outside of your Azure Stack deployment. Follow the [instructions on how to retrieve the keys](../azure-stack-security-bitlocker.md).

## Known issues (post-installation)

The following are post-installation known issues for this build version.

### Portal

<!-- 2930820 - IS ASDK --> 
- In both the administrator and user portals, if you search for "Docker," the item is incorrectly returned. It is not available in Azure Stack. If you try to create it, a blade with an error indication is displayed. 

<!-- 2931230 - IS  ASDK --> 
- Plans that are added to a user subscription as an add-on plan cannot be deleted, even when you remove the plan from the user subscription. The plan will remain until the subscriptions that reference the add-on plan are also deleted. 

<!-- TBD - IS ASDK --> 
- The two administrative subscription types that were introduced with version 1804 should not be used. The subscription types are **Metering subscription**, and **Consumption subscription**. These subscription types are visible in new Azure Stack environments beginning with version 1804 but are not yet ready for use. You should continue to use the **Default Provider** subscription type.

<!-- 3557860 - IS ASDK --> 
- Deleting user subscriptions results in orphaned resources. As a workaround, first delete user resources or the entire resource group, and then delete the user subscriptions.

<!-- 1663805 - IS ASDK --> 
- You cannot view permissions to your subscription using the Azure Stack portals. As a workaround, use [PowerShell to verify permissions](/powershell/module/azs.subscriptions.admin/get-azssubscriptionplan).

<!-- ### Health and monitoring -->

### Compute

- When creating a new Windows Virtual Machine (VM), the following error may be displayed:

   `'Failed to start virtual machine 'vm-name'. Error: Failed to update serial output settings for VM 'vm-name'`

   The error occurs if you enable boot diagnostics on a VM but delete your boot diagnostics storage account. To work around this issue, recreate the storage account with the same name as you used previously.

<!-- 2967447 - IS, ASDK, to be fixed in 1902 -->
- The virtual machine scale set (VMSS) creation experience provides CentOS-based 7.2 as an option for deployment. Because that image is not available on Azure Stack, either select another operating system for your deployment, or use an Azure Resource Manager template specifying another CentOS image that has been downloaded prior to deployment from the marketplace by the operator.  

<!-- TBD - IS ASDK --> 
- After applying the 1901 update, you might encounter the following issues when deploying VMs with Managed Disks:

   - If the subscription was created before the 1808 update, deploying a VM with Managed Disks might fail with an internal error message. To resolve the error, follow these steps for each subscription:
      1. In the Tenant portal, go to **Subscriptions** and find the subscription. Select **Resource Providers**, then select **Microsoft.Compute**, and then click **Re-register**.
      2. Under the same subscription, go to **Access Control (IAM)**, and verify that **AzureStack-DiskRP-Client** is listed.
   - If you have configured a multi-tenant environment, deploying VMs in a subscription associated with a guest directory might fail with an internal error message. To resolve the error, follow these steps in [this article](../enable-multitenancy.md#register-a-guest-directory) to reconfigure each of your guest directories.

- An Ubuntu 18.04 VM created with SSH authorization enabled will not allow you to use the SSH keys to log in. As a workaround, use VM access for the Linux extension to implement SSH keys after provisioning, or use password-based authentication.

- You cannot remove a scale set from the **Virtual Machine Scale Sets** blade. As a workaround, select the scale set that you want to remove, then click the **Delete** button from the **Overview** pane.

### Networking  

<!-- 3239127 - IS, ASDK -->
- In the Azure Stack portal, when you change a static IP address for an IP configuration that is bound to a network adapter attached to a VM instance, you will see a warning message that states 

    `The virtual machine associated with this network interface will be restarted to utilize the new private IP address...`.

    You can safely ignore this message; the IP address will be changed even if the VM instance does not restart.

<!-- 3632798 - IS, ASDK -->
- In the portal, if you add an inbound security rule and select **Service Tag** as the source, several options are displayed in the **Source Tag** list that are not available for Azure Stack. The only options that are valid in Azure Stack are as follows:

  - **Internet**
  - **VirtualNetwork**
  - **AzureLoadBalancer**
  
    The other options are not supported as source tags in Azure Stack. Similarly, if you add an outbound security rule and select **Service Tag** as the destination, the same list of options for **Source Tag** is displayed. The only valid options are the same as for **Source Tag**, as described in the previous list.

- Network security groups (NSGs) do not work in Azure Stack in the same way as global Azure. In Azure, you can set multiple ports on one NSG rule (using the portal, PowerShell, and Resource Manager templates). In Azure Stack however, you cannot set multiple ports on one NSG rule via the portal. To work around this issue, use a Resource Manager template or PowerShell to set these additional rules.

<!-- 3203799 - IS, ASDK -->
- Azure Stack does not support attaching more than 4 Network Interfaces (NICs) to a VM instances today, regardless of the instance size.

<!-- ### SQL and MySQL-->

### App Service

<!-- 2352906 - IS ASDK --> 
- You must register the storage resource provider before you create your first Azure Function in the subscription.


<!-- ### Usage -->

 
<!-- #### Identity -->
<!-- #### Marketplace -->

### Syslog

- The syslog configuration is not persisted through an update cycle, causing the syslog client to lose its configuration, and the syslog messages to stop being forwarded. This issue applies to all versions of Azure Stack since the GA of the syslog client (1809). To work around this issue, reconfigure the syslog client after applying an Azure Stack update.

## Download the update

You can download the Azure Stack 1901 update package from [here](https://aka.ms/azurestackupdatedownload). 

In connected scenarios only, Azure Stack deployments periodically check a secured endpoint and automatically notify you if an update is available for your cloud. For more information, see [managing updates for Azure Stack](../azure-stack-updates.md#how-to-know-an-update-is-available).

## Next steps

- For an overview of the update management in Azure Stack, see [Manage updates in Azure Stack overview](../azure-stack-updates.md).  
- For more information about how to apply updates with Azure Stack, see [Apply updates in Azure Stack](../azure-stack-apply-updates.md).
- To review the servicing policy for Azure Stack integrated systems, and what you must do to keep your system in a supported state, see [Azure Stack servicing policy](../azure-stack-servicing-policy.md).  
- To use the Privileged End Point (PEP) to monitor and resume updates, see [Monitor updates in Azure Stack using the privileged endpoint](../azure-stack-monitor-update.md).
::: moniker-end

::: moniker range="azs-1811"
## 1811 archived release notes
*Applies to: Azure Stack integrated systems*

This article describes the contents of the 1811 update package. The update package includes improvements, fixes, and new features for this version of Azure Stack. This article also describes known issues in this release, and includes a link so you can download the update. Known issues are divided into issues directly related to the update process, and issues with the build (post-installation).

> [!IMPORTANT]  
> This update package is only for Azure Stack integrated systems. Do not apply this update package to the Azure Stack Development Kit.

## Build reference

The Azure Stack 1811 update build number is **1.1811.0.101**.

## Hotfixes

Azure Stack releases hotfixes on a regular basis. Be sure to install the [latest Azure Stack hotfix](#azure-stack-hotfixes) for 1809 before updating Azure Stack to 1811.

### Azure Stack hotfixes

- **1809**: [KB 4481548 – Azure Stack hotfix 1.1809.12.114](https://support.microsoft.com/help/4481548/)
- **1811**: No current hotfix available.

## Prerequisites

> [!IMPORTANT]
> During installation of the 1811 update, you must ensure that all instances of the administrator portal are closed. The user portal can remain open, but the admin portal must be closed.

- Get your Azure Stack deployment ready for the Azure Stack extension host. Prepare your system using the following guidance: [Prepare for extension host for Azure Stack](../azure-stack-extension-host-prepare.md). 
 
- Install the [latest Azure Stack hotfix](#azure-stack-hotfixes) for 1809 before updating to 1811.

- Before you start installation of this update, run [Test-AzureStack](../azure-stack-diagnostic-test.md) with the following parameters to validate the status of your Azure Stack and resolve any operational issues found, including all warnings and failures. Also review active alerts, and resolve any that require action.  

    ```powershell
    Test-AzureStack -Include AzsControlPlane, AzsDefenderSummary, AzsHostingInfraSummary, AzsHostingInfraUtilization, AzsInfraCapacity, AzsInfraRoleSummary, AzsPortalAPISummary, AzsSFRoleSummary, AzsStampBMCSummary, AzsHostingServiceCertificates
    ```

    If you do not have the extension host requirements met, the `Test-AzureStack` output displays the following message:
  
    `To proceed with installation of the 1811 update, you will need to import the SSL certificates required for Extension Host, which simplifies network integration and increases the security posture of Azure Stack. Refer to this link to prepare for Extension Host: https://learn.microsoft.com/azure-stack/operator/azure-stack-extension-host-prepare`

- The Azure Stack 1811 update requires that you have properly imported the mandatory extension host certificates into your Azure Stack environment. To proceed with installation of the 1811 update, you must import the SSL certificates required for the extension host. To import the certificates, see [this section](../azure-stack-extension-host-prepare.md#import-extension-host-certificates).

    If you ignore every warning and still choose to install the 1811 update, the update will fail in approximately 1 hour with the following message:

    `The required SSL certificates for the Extension Host have not been found. The Azure Stack update will halt. Refer to this link to prepare for Extension Host: https://learn.microsoft.com/azure-stack/operator/azure-stack-extension-host-prepare, then resume the update. Exception: The Certificate path does not exist: [certificate path here]`

    Once you have properly imported the mandatory extension host certificates, you can resume the 1811 update from the Administrator portal. While Microsoft advises Azure Stack operators to schedule a maintenance window during the update process, a failure due to the missing extension host certificates should not impact existing workloads or services.  

    During the installation of this update, the Azure Stack user portal is unavailable while the extension host is being configured. The configuration of the extension host can take up to 5 hours. During that time, you can check the status of an update, or resume a failed update installation using [Azure Stack Administrator PowerShell or the privileged endpoint](../azure-stack-monitor-update.md).

- When Azure Stack is managed by System Center Operations Manager, be sure to update the Management Pack for Microsoft Azure Stack to version 1.0.3.11 before applying 1811.

## New features

This update includes the following new features and improvements for Azure Stack:

- With this release, the [extension host](../azure-stack-extension-host-prepare.md) is enabled. The extension host simplifies network integration and improves the security posture of Azure Stack.

- Added support for device authentication with Active Directory Federated Services (AD FS), when using Azure CLI in particular. For more information, see [Use API version profiles with Azure CLI in Azure Stack](../../user/azure-stack-version-profiles-azurecli2.md)

- Added support for Service Principals using a client secret with Active Directory Federated Services (AD FS). For more information, see [Create service principal for AD FS](../give-app-access-to-resources.md#manage-an-azure-ad-app).

- This release adds support for the following Azure Storage Service API versions: **2017-07-29**, **2017-11-09**. Support is also added for the following Azure Storage Resource Provider API versions: **2016-05-01**, **2016-12-01**, **2017-06-01**, and **2017-10-01**. For more information, see [Azure Stack storage: Differences and considerations](../../user/azure-stack-acs-differences.md).

- Added new privileged endpoint commands to update and remove service principles for ADFS. For more information, see [Create service principal for AD FS](../give-app-access-to-resources.md#manage-an-azure-ad-app).

- Added new Scale Unit Node operations that allow an Azure Stack operator to start, stop, and shut down a scale unit node. For more information, see [Scale unit node actions in Azure Stack](../azure-stack-node-actions.md).

- Added a new region properties blade that displays registration details of the environment. You can view this information by clicking the **Region Management** tile on the default dashboard in the administrator portal, and then selecting **Properties**.

- Added a new privileged endpoint command to update the BMC credential with user name and password, used to communicate with the physical machines. For more information, see [Update the baseboard management controller \(BMC) credential](../azure-stack-rotate-secrets.md).

- Added the ability to access the Azure roadmap though the help and support icon (question mark) in the upper right corner of the administrator and user portals, similar to the way it is available in the Azure portal.

- Added an improved Marketplace management experience for disconnected users. The upload process to publish a Marketplace item in a disconnected environment is simplified to one step, instead of uploading the image and the Marketplace package separately. The uploaded product will also be visible in the Marketplace management blade.

- This release reduces the required maintenance window for secret rotation by adding the ability to rotate only external certificates during [Azure Stack secret rotation](../azure-stack-rotate-secrets.md).

- [Azure Stack PowerShell](../azure-stack-powershell-install.md) has been updated to version 1.6.0. The update includes support for the new storage-related features in Azure Stack. For more information, see the release notes for the [Azure Stack Administration Module 1.6.0 in the PowerShell Gallery](https://www.powershellgallery.com/packages/AzureStack/1.6.0) For information about updating or installing Azure Stack PowerShell, see [Install PowerShell for Azure Stack](../azure-stack-powershell-install.md).

- Managed Disks is now enabled by default when creating virtual machines using the Azure Stack portal. See the [known issues](#known-issues-post-installation) section for the additional steps required for Managed Disks to avoid VM creation failures.

- This release introduces alert **Repair** actions for the Azure Stack operator. Some alerts in 1811 provide a **Repair** button in the alert that you can select to resolve the issue. For more information, see [Monitor health and alerts in Azure Stack](../azure-stack-monitor-health.md).

- Updates to the update experience in Azure Stack. The update enhancements include: 
  - Tabs that split the Updates from Update history for better tracking updates in progress and completed updates.
  - Enhanced state visualizations in the essentials section with new icons and layout for Current and OEM versions as well as Last updated date.
  - **View** link for the Release notes column takes the user directly to the documentation specific to that update rather than the generic update page.
  - The **Update history** tab used to determine run times for each of the updates as well as enhanced filtering capabilities.  
  - Azure Stack scale units that are connected will still automatically receive **Update available** as they become available.
  - Azure Stack scale units that are not connected can import the updates just like before. 
  - There are no changes in the process to download the JSON logs from the portal. Azure Stack operators will see expanding steps expressing progress.

    For more information, see [Apply updates in Azure Stack](../azure-stack-apply-updates.md).


## Fixed issues

<!-- TBD - IS ASDK --> 
- Fixed an issue in which the public IP address usage meter data showed the same **EventDateTime** value for each record instead of the **TimeDate** stamp that shows when the record was created. You can now use this data to perform accurate accounting of public IP address usage.

<!-- 3099544 – IS, ASDK --> 
- Fixed an issue that occurred when creating a new virtual machine (VM) using the Azure Stack portal. Selecting the VM size caused the **USD/Month** column to display an **Unavailable** message. This column no longer appears; displaying the VM pricing column is not supported in Azure Stack.

<!-- 2930718 - IS ASDK --> 
- Fixed an issue in which the administrator portal, when accessing the details of any user subscription, after closing the blade and clicking on **Recent**, the user subscription name did not appear. The user subscription name now appears.

<!-- 3060156 - IS ASDK --> 
- Fixed an issue in both the administrator and user portals: clicking on the portal settings and selecting **Delete all settings and private dashboards** did not work as expected and an error notification was displayed. This option now works correctly.

<!-- 2930799 - IS ASDK --> 
- Fixed an issue in both the administrator and user portals: under **All services**, the asset **DDoS protection plans** was incorrectly listed. It is not available in Azure Stack. The listing has been removed.
 
<!--2760466 – IS  ASDK --> 
- Fixed an issue that occurred when you installed a new Azure Stack environment, in which the alert that indicates **Activation Required** did not display. It now correctly displays.

<!--1236441 – IS  ASDK --> 
- Fixed an issue that prevented applying RBAC policies to a user group when using ADFS.

<!--3463840 - IS, ASDK --> 
- Fixed an issue with infrastructure backups failing due to an inaccessible file server from the public VIP network. This fix moves the infrastructure backup service back to the public infrastructure network. If you applied the  latest [Azure Stack hotfix for 1809](#azure-stack-hotfixes) that addresses this issue, the 1811 update will not make any further modifications. 

<!-- 2967387 – IS, ASDK --> 
- Fixed an issue in which the account you used to sign in to the Azure Stack admin or user portal displayed as **Unidentified user**. This message was displayed when the account did not have either a **First** or **Last** name specified.   

<!--  2873083 - IS ASDK --> 
- Fixed an issue in which using the portal to create a virtual machine scale set (VMSS) caused the **instance size** dropdown to not load correctly when using Internet Explorer. This browser now works correctly.  

<!-- 3190553 - IS ASDK -->
- Fixed an issue that generated noisy alerts indicating that an Infrastructure Role Instance was unavailable or Scale Unit Node was offline.

<!-- 2724961 - IS ASDK -->
- Fixed an issue in which the VM overview page cannot correctly show the VM metrics chart. 

## Changes

- A new way to view and edit the quotas in a plan is introduced in 1811. For more information, see [View an existing quota](../azure-stack-quota-types.md#view-an-existing-quota).

<!-- 3083238 IS -->
- Security enhancements in this update result in an increase in the backup size of the directory service role. For updated sizing guidance for the external storage location, see the [infrastructure backup documentation](../azure-stack-backup-reference.md#storage-location-sizing). This change results in a longer time to complete the backup due to the larger size data transfer. This change impacts integrated systems. 

- The existing PEP cmdlet to retrieve the BitLocker recovery keys is renamed in 1811, from Get-AzsCsvsRecoveryKeys to Get-AzsRecoveryKeys. For more information on how to retrieve the BitLocker recovery keys, see [instructions on how to retrieve the keys](../azure-stack-security-bitlocker.md).

## Common vulnerabilities and exposures

This update installs the following security updates:  

- [CVE-2018-8256](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8256)
- [CVE-2018-8407](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8407)
- [CVE-2018-8408](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8408)
- [CVE-2018-8415](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8415)
- [CVE-2018-8417](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8417)
- [CVE-2018-8450](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8450)
- [CVE-2018-8471](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8471)
- [CVE-2018-8476](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8476)
- [CVE-2018-8485](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8485)
- [CVE-2018-8544](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8544)
- [CVE-2018-8547](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8547)
- [CVE-2018-8549](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8549)
- [CVE-2018-8550](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8550)
- [CVE-2018-8553](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8553)
- [CVE-2018-8561](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8561)
- [CVE-2018-8562](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8562)
- [CVE-2018-8565](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8565)
- [CVE-2018-8566](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8566)
- [CVE-2018-8584](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8584)

For more information about these vulnerabilities, click on the preceding links, or see Microsoft Knowledge Base articles [4478877](https://support.microsoft.com/help/4478877).

## Known issues with the update process

- When you run the **Get-AzureStackLog** PowerShell cmdlet after running **Test-AzureStack** in the same privileged endpoint (PEP) session, **Get-AzureStackLog** fails. To work around this issue, close the PEP session in which you executed **Test-AzureStack**, and then open a new session to run **Get-AzureStackLog**.

- During installation of the 1811 update, ensure that all instances of the administrator portal are closed during this time. The user portal can remain open, but the admin portal must be closed.

- When running [Test-AzureStack](../azure-stack-diagnostic-test.md), if either the **AzsInfraRoleSummary** or the **AzsPortalApiSummary** test fails, you are prompted to run **Test-AzureStack** with the `-Repair` flag.  If you run this command, it fails with the following error message:  `Unexpected exception getting Azure Stack health status. Cannot bind argument to parameter 'TestResult' because it is null.`  This issue will be fixed in a future release.

- During installation of the 1811 update, the Azure Stack use portal is unavailable while the extension host is being configured. The configuration of the extension host can take up to 5 hours. During that time, you can check the status of an update, or resume a failed update installation using [Azure Stack Administrator PowerShell or the privileged endpoint](../azure-stack-monitor-update.md). 

- During installation of the 1811 update, the user portal dashboard might not be available, and customizations can be lost. You can restore the dashboard to the default setting after the update completes by opening the portal settings and selecting **Restore default settings**.

- When you run [Test-AzureStack](../azure-stack-diagnostic-test.md), a warning message from the Baseboard Management Controller (BMC) is displayed. You can safely ignore this warning.

- <!-- 2468613 - IS --> During installation of this update, you might see alerts with the title `Error – Template for FaultType UserAccounts.New is missing.`  You can safely ignore these alerts. The alerts close automatically after the installation of this update completes.

- <!-- 3139614 | IS --> If you've applied an update to Azure Stack from your OEM, the **Update available** notification may not appear in the Azure Stack administrator portal. To install the Microsoft update, download and import it manually using the instructions located here [Apply updates in Azure Stack](../azure-stack-apply-updates.md).

## Post-update steps

- After the installation of this update, install any applicable hotfixes. For more information, see [Hotfixes](#hotfixes), as well as our [Servicing Policy](../azure-stack-servicing-policy.md).  

- Retrieve the data at rest encryption keys and securely store them outside of your Azure Stack deployment. Follow the [instructions on how to retrieve the keys](../azure-stack-security-bitlocker.md).

## Known issues (post-installation)

The following are post-installation known issues for this build version.

### Portal

<!-- 2930820 - IS ASDK --> 
- In both the administrator and user portals, if you search for "Docker," the item is incorrectly returned. It is not available in Azure Stack. If you try to create it, a blade with an error indication is displayed. 

<!-- 2931230 – IS  ASDK --> 
- Plans that are added to a user subscription as an add-on plan cannot be deleted, even when you remove the plan from the user subscription. The plan will remain until the subscriptions that reference the add-on plan are also deleted. 

<!-- TBD - IS ASDK --> 
- The two administrative subscription types that were introduced with version 1804 should not be used. The subscription types are **Metering subscription**, and **Consumption subscription**. These subscription types are visible in new Azure Stack environments beginning with version 1804 but are not yet ready for use. You should continue to use the **Default Provider** subscription type.

<!-- TBD - IS ASDK --> 
- Deleting user subscriptions results in orphaned resources. As a workaround, first delete user resources or the entire resource group, and then delete the user subscriptions.

<!-- TBD - IS ASDK --> 
- You cannot view permissions to your subscription using the Azure Stack portals. As a workaround, use [PowerShell to verify permissions](/powershell/module/azs.subscriptions.admin/get-azssubscriptionplan).

### Health and monitoring

<!-- 1264761 - IS ASDK -->  
- You might see alerts for the **Health controller** component that have the following details:  

  - Alert #1:
     - NAME:  Infrastructure role unhealthy
     - SEVERITY: Warning
     - COMPONENT: Health controller
     - DESCRIPTION: The health controller Heartbeat Scanner is unavailable. This may affect health reports and metrics.  

  - Alert #2:
     - NAME:  Infrastructure role unhealthy
     - SEVERITY: Warning
     - COMPONENT: Health controller
     - DESCRIPTION: The health controller Fault Scanner is unavailable. This may affect health reports and metrics.

    Both alerts can be safely ignored. They will close automatically over time.  

### Compute

- When creating a new Windows Virtual Machine (VM), the **Settings** blade requires that you select a public inbound port in order to proceed. In 1811, this setting is required, but has no effect. This is because the feature depends on Azure Firewall, which is not implemented in Azure Stack. You can select **No Public Inbound Ports**, or any of the other options to proceed with VM creation. The setting will have no effect.

- When creating a new Windows Virtual Machine (VM), the following error may be displayed:

   `'Failed to start virtual machine 'vm-name'. Error: Failed to update serial output settings for VM 'vm-name'`

   The error occurs if you enable boot diagnostics on a VM but delete your boot diagnostics storage account. To work around this issue, recreate the storage account with the same name as you used previously.

- When creating a [Dv2 series VM](../../user/azure-stack-vm-considerations.md#vm-sizes), D11-14v2 VMs allow you to create 4, 8, 16, and 32 data disks respectively. However, the create VM pane shows 8, 16, 32, and 64 data disks.

- Usage records on Azure Stack may contain unexpected capitalization; for example:

   `{"Microsoft.Resources":{"resourceUri":"/subscriptions/<subid>/resourceGroups/ANDREWRG/providers/Microsoft.Compute/
   virtualMachines/andrewVM0002","location":"twm","tags":"null","additionalInfo":
   "{\"ServiceType\":\"Standard_DS3_v2\",\"ImageType\":\"Windows_Server\"}"}}`

   In this example, the name of the resource group should be **AndrewRG**. You can safely ignore this inconsistency.

<!-- 3235634 – IS, ASDK -->
- To deploy VMs with sizes containing a **v2** suffix; for example, **Standard_A2_v2**, specify the suffix as **Standard_A2_v2** (lowercase v). Do not use **Standard_A2_V2** (uppercase V). This works in global Azure and is an inconsistency on Azure Stack.

<!-- 2869209 – IS, ASDK --> 
- When using the [**Add-AzsPlatformImage** cmdlet](/powershell/module/azs.compute.admin/add-azsplatformimage), you must use the **-OsUri** parameter as the storage account URI where the disk is uploaded. If you use the local path of the disk, the cmdlet fails with the following error: 

    `Long running operation failed with status 'Failed'`

<!--  2795678 – IS, ASDK --> 
- When you use the portal to create virtual machines (VMs) in a premium VM size (DS,Ds_v2,FS,FSv2), the VM is created in a standard storage account. Creation in a standard storage account does not affect functionally, IOPs, or billing. You can safely ignore the warning that says: 

    `You've chosen to use a standard disk on a size that supports premium disks. This could impact operating system performance and is not recommended. Consider using premium storage (SSD) instead.`

<!-- 2967447 - IS, ASDK --> 
- The virtual machine scale set (VMSS) creation experience provides CentOS-based 7.2 as an option for deployment. Because that image is not available on Azure Stack, either select another operating system for your deployment, or use an Azure Resource Manager template specifying another CentOS image that has been downloaded prior to deployment from the marketplace by the operator.  

<!-- 2724873 - IS --> 
- When using the PowerShell cmdlets **Start-AzsScaleUnitNode** or  **Stop-AzsScaleunitNode** to manage scale units, the first attempt to start or stop the scale unit might fail. If the cmdlet fails on the first run, run the cmdlet a second time. The second run should successfully complete the operation. 

<!-- TBD - IS ASDK --> 
- If provisioning an extension on a VM deployment takes too long, let the provisioning time-out instead of trying to stop the process to deallocate or delete the VM.  

<!-- 1662991 IS ASDK --> 
- Linux VM diagnostics is not supported in Azure Stack. When you deploy a Linux VM with VM diagnostics enabled, the deployment fails. The deployment also fails if you enable the Linux VM basic metrics through diagnostic settings.  

<!-- 3507629 - IS, ASDK --> 
- Managed Disks creates two new [compute quota types](../azure-stack-quota-types.md#compute-quota-types) to limit the maximum capacity of managed disks that can be provisioned. By default, 2048 GiB is allocated for each managed disks quota type. However, you may encounter the following issues:

   - For quotas created before the 1808 update, the Managed Disks quota will show 0 values in the Administrator portal, although 2048 GiB is allocated. You can increase or decrease the value based on your actual needs, and the newly set quota value overrides the 2048 GiB default.
   - If you update the quota value to 0, it is equivalent to the default value of 2048 GiB. As a workaround, set the quota value to 1.

<!-- TBD - IS ASDK --> 
- After applying the 1811 update, you might encounter the following issues when deploying VMs with Managed Disks:

   - If the subscription was created before the 1808 update, deploying a VM with Managed Disks might fail with an internal error message. To resolve the error, follow these steps for each subscription:
      1. In the Tenant portal, go to **Subscriptions** and find the subscription. Select **Resource Providers**, then select **Microsoft.Compute**, and then click **Re-register**.
      2. Under the same subscription, go to **Access Control (IAM)**, and verify that the **AzureStack-DiskRP-Client** role is listed.
   - If you have configured a multi-tenant environment, deploying VMs in a subscription associated with a guest directory might fail with an internal error message. To resolve the error, follow these steps in [this article](../enable-multitenancy.md#register-a-guest-directory) to reconfigure each of your guest directories.

- An Ubuntu 18.04 VM created with SSH authorization enabled will not allow you to use the SSH keys to log in. As a workaround, use VM access for the Linux extension to implement SSH keys after provisioning, or use password-based authentication.

### Networking  

<!-- 1766332 - IS ASDK --> 
- Under **Networking**, if you click **Create VPN Gateway** to set up a VPN connection, **Policy Based** is listed as a VPN type. Do not select this option. Only the **Route Based** option is supported in Azure Stack.

<!-- 1902460 - IS ASDK --> 
- Azure Stack supports a single *local network gateway* per IP address. This is true across all tenant subscriptions. After the creation of the first local network gateway connection, subsequent attempts to create a local network gateway resource with the same IP address are rejected.

<!-- 16309153 - IS ASDK --> 
- On a virtual network that was created with a DNS server setting of **Automatic**, changing to a custom DNS server fails. The updated settings are not pushed to VMs in that Vnet.

<!-- 2529607 - IS ASDK --> 
- During Azure Stack *Secret Rotation*, there is a period in which public IP addresses are unreachable for two to five minutes.

<!-- 2664148 - IS ASDK --> 
- In scenarios where the tenant is accessing virtual machines by using a S2S VPN tunnel, they might encounter a scenario where connection attempts fail if the on-premises subnet was added to the local network gateway after the gateway was already created. 

- In the Azure Stack portal, when you change a static IP address for an IP configuration that is bound to a network adapter attached to a VM instance, you will see a warning message that states 

    `The virtual machine associated with this network interface will be restarted to utilize the new private IP address...`. 

    You can safely ignore this message; the IP address will be changed even if the VM instance does not restart.

- In the portal, on the **Networking Properties** blade there is a link for **Effective Security Rules** for each network adapter. If you select this link, a new blade opens that shows the error message `Not Found.` This error occurs because Azure Stack does not yet support **Effective Security Rules**.

- In the portal, if you add an inbound security rule and select **Service Tag** as the source, several options are displayed in the **Source Tag** list that are not available for Azure Stack. The only options that are valid in Azure Stack are as follows:

  - **Internet**
  - **VirtualNetwork**
  - **AzureLoadBalancer**
  
    The other options are not supported as source tags in Azure Stack. Similarly, if you add an outbound security rule and select **Service Tag** as the destination, the same list of options for **Source Tag** is displayed. The only valid options are the same as for **Source Tag**, as described in the previous list.

- The **New-AzureRmIpSecPolicy** PowerShell cmdlet does not support setting **DHGroup24** for the `DHGroup` parameter.

- Network security groups (NSGs) do not work in Azure Stack in the same way as global Azure. In Azure, you can set multiple ports on one NSG rule (using the portal, PowerShell, and Resource Manager templates). In Azure Stack, you cannot set multiple ports on one NSG rule via the portal. To work around this issue, use a Resource Manager template to set these additional rules.

### Infrastructure backup

<!--scheduler config lost, bug 3615401, new issue in 1811,  hectorl-->
<!-- TSG: https://www.csssupportwiki.com/index.php/Azure_Stack/KI/Backup_scheduler_configuration_lost --> 
- After enabling automatic backups, the scheduler service goes into disabled state unexpectedly. The backup controller service will detect that automatic backups are disabled and raise a warning in the administrator portal. This warning is expected when automatic backups are disabled. 
    - Cause: This issue is due to a bug in the service that results in loss of scheduler configuration. This bug does not change the storage location, user name, password, or encryption key.   
    - Remediation: To mitigate this issue, open the backup controller settings blade in the Infrastructure Backup resource provider and select **Enable Automatic Backups**. Make sure to set the desired frequency and retention period.
    - Occurrence: Low 

<!-- ### SQL and MySQL-->

### App Service

<!-- 2352906 - IS ASDK --> 
- You must register the storage resource provider before you create your first Azure Function in the subscription.


<!-- ### Usage -->

 
<!-- #### Identity -->
<!-- #### Marketplace -->

### Syslog

- The syslog configuration is not persisted through an update cycle, causing the syslog client to lose its configuration, and the syslog messages to stop being forwarded. This issue applies to all versions of Azure Stack since the GA of the syslog client (1809). To work around this issue, reconfigure the syslog client after applying an Azure Stack update.

## Download the update

You can download the Azure Stack 1811 update package from [here](https://aka.ms/azurestackupdatedownload). 

In connected scenarios only, Azure Stack deployments periodically check a secured endpoint and automatically notify you if an update is available for your cloud. For more information, see [managing updates for Azure Stack](../azure-stack-updates.md#how-to-know-an-update-is-available).

## Next steps

- To review the servicing policy for Azure Stack integrated systems, and what you must do to keep your system in a supported state, see [Azure Stack servicing policy](../azure-stack-servicing-policy.md).  
- To use the Privileged End Point (PEP) to monitor and resume updates, see [Monitor updates in Azure Stack using the privileged endpoint](../azure-stack-monitor-update.md).  
- For an overview of the update management in Azure Stack, see [Manage updates in Azure Stack overview](../azure-stack-updates.md).  
- For more information about how to apply updates with Azure Stack, see [Apply updates in Azure Stack](../azure-stack-apply-updates.md).  
::: moniker-end

::: moniker range="azs-1809"
## 1809 archived release notes
*Applies to: Azure Stack integrated systems*

This article describes the contents of the 1809 update package. The update package includes improvements, fixes, and known issues for this version of Azure Stack. This article also includes a link so you can download the update. Known issues are divided into issues directly related to the update process and issues with the build (post-installation).

> [!IMPORTANT]  
> This update package is only for Azure Stack integrated systems. Do not apply this update package to the Azure Stack Development Kit.

## Build reference

The Azure Stack 1809 update build number is **1.1809.0.90**.  

### New features

This update includes the following improvements for Azure Stack:

- With this release, Azure Stack integrated systems supports configurations of 4-16 nodes. You can use the [Azure Stack Capacity Planner](https://aka.ms/azstackcapacityplanner) to help in your planning for Azure Stack capacity and configuration.

<!--  2712869   | IS  ASDK --> 
- **Azure Stack syslog client (General Availability)**:  This client allows the forwarding of audits, alerts, and security logs related to the Azure Stack infrastructure to a syslog server or security information and event management (SIEM) software external to Azure Stack. The syslog client now supports specifying the port on which the syslog server is listening.

   With this release, the syslog client is generally available, and it can be used in production environments.

   For more information, see [Azure Stack syslog forwarding](../azure-stack-integrate-security.md).

- You can now [move the registration resource](../azure-stack-registration.md#move-a-registration-resource) on Azure between resource groups without having to re-register. Cloud Solution Providers (CSPs) can also move the registration resource between subscriptions, as long as both the new and old subscriptions are mapped to the same CSP partner ID. This does not impact the existing customer tenant mappings. 

- Added support for assigning multiple IP addresses per network interface.  For more details see [Assign multiple IP addresses to virtual machines using PowerShell](/azure/virtual-network/virtual-network-multiple-ip-addresses-powershell).

### Fixed issues

<!-- TBD - IS ASDK -->
- On the portal, the memory chart reporting free/used capacity is now accurate. You can now more reliably predict how many VMs you are able to create.

<!-- TBD - IS ASDK --> 
- Fixed an issue in which you created virtual machines on the Azure Stack user portal, and the portal displayed an incorrect number of data disks that can attach to a DS series VM. DS series VMs can accommodate as many data disks as the Azure configuration.

- The following managed disk issues are fixed in 1809, and are also fixed in the 1808 [Azure Stack Hotfix 1.1808.9.117](https://support.microsoft.com/help/4481066/): 

   <!--  2966665 IS, ASDK --> 
  - Fixed the issue in which attaching SSD data disks to premium size managed disk virtual machines  (DS, DSv2, Fs, Fs_V2) failed with an error:  *Failed to update disks for the virtual machine vmname Error: Requested operation cannot be performed because storage account type Premium_LRS is not supported for VM size Standard_DS/Ds_V2/FS/Fs_v2)*. 
   
  - Creating a managed disk VM by using **createOption**: **Attach** fails with the following error: *Long running operation failed with status 'Failed'. Additional Info:'An internal execution error occurred.'*
    ErrorCode: InternalExecutionError
    ErrorMessage: An internal execution error occurred.
   
    This issue has now been fixed.

- <!-- 2702741 -  IS, ASDK --> Fixed issue in which public IPs that were deployed by using the Dynamic allocation method were not guaranteed to be preserved after a Stop-Deallocate is issued. They are now preserved.

- <!-- 3078022 - IS, ASDK --> If a VM was stop-deallocated before 1808 it could not be re-allocated after the 1808 update.  This issue is fixed in 1809. Instances that were in this state and could not be started can be started in 1809 with this fix. The fix also prevents this issue from reoccurring.

### Changes

<!-- 2635202 - IS, ASDK -->
- Infrastructure backup service moves from the [public infrastructure network](/azure/azure-stack/azure-stack-network) to the [public VIP network](/azure/azure-stack/azure-stack-network#public-vip-network). Customers will need to ensure the service has access the backup storage location from the public VIP network.  

> [!IMPORTANT]  
> If you have a firewall that does not allow connections from the public VIP network to the file server, this change will cause infrastructure backups to fail with "Error 53 The network path was not found." This is a breaking change that has no reasonable workaround. Based on customer feedback, Microsoft will revert this change in a hotfix. 
Please review the [post update steps section](#post-update-steps) for more information on available hotfixes for 1809. Once the hotfix is available, make sure to apply it after updating to 1809 only if your network policies do not allow the public VIP network to access infrastructure resources. 
in 1811, this change will be applied to all systems. If you applied the hotfix in 1809, there is no further action required.  

### Common vulnerabilities and exposures

This update installs the following security updates:  

- [ADV180022](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/ADV180022)
- [CVE-2018-0965](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-0965)
- [CVE-2018-8271](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8271)
- [CVE-2018-8320](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8320)
- [CVE-2018-8330](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8330)
- [CVE-2018-8332](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8332)
- [CVE-2018-8333](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8333)
- [CVE-2018-8335](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8335)
- [CVE-2018-8392](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8392)
- [CVE-2018-8393](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8393)
- [CVE-2018-8410](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8410)
- [CVE-2018-8411](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8411)
- [CVE-2018-8413](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8413)
- [CVE-2018-8419](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8419)
- [CVE-2018-8420](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8420)
- [CVE-2018-8423](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8423)
- [CVE-2018-8424](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8424)
- [CVE-2018-8433](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8433)
- [CVE-2018-8434](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8434)
- [CVE-2018-8435](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8435)
- [CVE-2018-8438](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8438)
- [CVE-2018-8439](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8439)
- [CVE-2018-8440](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8440)
- [CVE-2018-8442](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8442)
- [CVE-2018-8443](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8443)
- [CVE-2018-8446](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8446)
- [CVE-2018-8449](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8449)
- [CVE-2018-8453](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8453)
- [CVE-2018-8455](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8455)
- [CVE-2018-8462](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8462)
- [CVE-2018-8468](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8468)
- [CVE-2018-8472](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8472)
- [CVE-2018-8475](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8475)
- [CVE-2018-8481](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8481)
- [CVE-2018-8482](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8482)
- [CVE-2018-8484](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8484)
- [CVE-2018-8486](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8486)
- [CVE-2018-8489](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8489)
- [CVE-2018-8490](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8490)
- [CVE-2018-8492](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8492)
- [CVE-2018-8493](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8493)
- [CVE-2018-8494](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8494)
- [CVE-2018-8495](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8495)
- [CVE-2018-8497](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8497)

For more information about these vulnerabilities, click on the preceding links, or see Microsoft Knowledge Base articles [4457131](https://support.microsoft.com/help/4457131) and [4462917](https://support.microsoft.com/help/4462917).

### Prerequisites

- Install the latest Azure Stack Hotfix for 1808 before applying 1809. For more information, see [KB 4481066 - Azure Stack Hotfix Azure Stack Hotfix 1.1808.9.117](https://support.microsoft.com/help/4481066/). While Microsoft recommends the latest Hotfix available, the minimum version required to install 1809 is 1.1808.5.110.

- Before you start installation of this update, run [Test-AzureStack](../azure-stack-diagnostic-test.md) with the following parameters to validate the status of your Azure Stack and resolve any operational issues found, including all warnings and failures. Also review active alerts, and resolve any that require action.  

  ```powershell
  Test-AzureStack -Include AzsControlPlane, AzsDefenderSummary, AzsHostingInfraSummary, AzsHostingInfraUtilization, AzsInfraCapacity, AzsInfraRoleSummary, AzsPortalAPISummary, AzsSFRoleSummary, AzsStampBMCSummary
  ```

- When Azure Stack is managed by System Center Operations Manager, be sure to update the Management Pack for Microsoft Azure Stack to version 1.0.3.11 before applying 1809.

### Known issues with the update process

- When you run [Test-AzureStack](../azure-stack-diagnostic-test.md) after the 1809 update, a warning message from the Baseboard Management Controller (BMC) is displayed. You can safely ignore this warning.

<!-- 2468613 - IS --> 
- During installation of this update, you might see alerts with the title *Error - Template for FaultType UserAccounts.New is missing.*  You can safely ignore these alerts. These alerts will close automatically after installation of this update completes.

   <!-- 2489559 - IS --> 
- Do not attempt to create virtual machines during the installation of this update. For more information about managing updates, see [Manage updates in Azure Stack overview](../azure-stack-updates.md).
   <!-- 3139614 | IS -->
- If you've applied an update to Azure Stack from your OEM, the **Update available** notification may not appear in the Azure Stack Admin portal. To install the Microsoft update, download and import it manually using the instructions located here [Apply updates in Azure Stack](../azure-stack-apply-updates.md).

### Post-update steps

> [!Important]  
> Get your Azure Stack deployment ready for extension host which is enabled by the next update package. Prepare your system using the following guidance, [Prepare for extension host for Azure Stack](../azure-stack-extension-host-prepare.md).

After the installation of this update, install any applicable Hotfixes. For more information view the following knowledge base articles, as well as our [Servicing Policy](../azure-stack-servicing-policy.md).  
- [KB 4481548 - Azure Stack Hotfix Azure Stack Hotfix 1.1809.12.114](https://support.microsoft.com/help/4481548/)  

## Known issues (post-installation)

The following are post-installation known issues for this build version.

### Portal

- The Azure Stack technical documentation focuses on the latest release. Due to portal changes between releases, what you see when using the Azure Stack portals might vary from what you see in the documentation.

<!-- 2930718 - IS ASDK --> 
- In the administrator portal, when accessing the details of any user subscription, after closing the blade and clicking on **Recent**, the user subscription name does not appear.

<!-- 3060156 - IS ASDK --> 
- In both the administrator and user portals, clicking on the portal settings and selecting **Delete all settings and private dashboards** does not work as expected. An error notification is displayed. 

<!-- 2930799 - IS ASDK --> 
- In both the administrator and user portals, under **All services**, the asset **DDoS protection plans** is incorrectly listed. It is not available in Azure Stack. If you try to create it, an error is displayed stating that the portal could not create the marketplace item. 

<!-- 2930820 - IS ASDK --> 
- In both the administrator and user portals, if you search for "Docker," the item is incorrectly returned. It is not available in Azure Stack. If you try to create it, a blade with an error indication is displayed. 

<!-- 2967387 - IS, ASDK --> 
- The account you use to sign in to the Azure Stack admin or user portal displays as **Unidentified user**. This message is displayed when the account does not have either a *First* or *Last* name specified. To work around this issue, edit the user account to provide either the First or Last name. You must then sign out and then sign back in to the portal.  

<!--  2873083 - IS ASDK --> 
-  When you use the portal to create a virtual machine scale set (VMSS), the *instance size* dropdown doesn't load correctly when you use Internet Explorer. To work around this problem, use another browser while using the portal to create a VMSS.  

<!-- 2931230 - IS  ASDK --> 
- Plans that are added to a user subscription as an add-on plan cannot be deleted, even when you remove the plan from the user subscription. The plan will remain until the subscriptions that reference the add-on plan are also deleted. 

<!--2760466 - IS  ASDK --> 
- When you install a new Azure Stack environment that runs this version, the alert that indicates *Activation Required* might not display. [Activation](../azure-stack-registration.md) is required before you can use marketplace syndication.  

<!-- TBD - IS ASDK --> 
- The two administrative subscription types that were introduced with version 1804 should not be used. The subscription types are **Metering subscription**, and **Consumption subscription**. These subscription types are visible in new Azure Stack environments beginning with version 1804 but are not yet ready for use. You should continue to use the **Default Provider** subscription type.

<!-- TBD - IS ASDK --> 
- Deleting user subscriptions results in orphaned resources. As a workaround, first delete user resources or the entire resource group, and then delete user subscriptions.

<!-- TBD - IS ASDK --> 
- You cannot view permissions to your subscription using the Azure Stack portals. As a workaround, use PowerShell to verify permissions.


### Health and monitoring

<!-- TBD - IS -->
- You might see the following alerts repeatedly appear and then disappear on your Azure Stack system:
   - *Infrastructure role instance unavailable*
   - *Scale unit node is offline*
   
  Run the [Test-AzureStack](../azure-stack-diagnostic-test.md) cmdlet to verify the health of the infrastructure role instances and scale unit nodes. If no issues are detected by [Test-AzureStack](../azure-stack-diagnostic-test.md), you can ignore these alerts. If an issue is detected, you can attempt to start the infrastructure role instance or node using the admin portal or PowerShell.

  This issue is fixed in the latest [1809 hotfix release](https://support.microsoft.com/help/4481548/), so be sure to install this hotfix if you're experiencing the issue. 

<!-- 1264761 - IS ASDK -->  
- You might see alerts for the **Health controller** component that have the following details:  

   Alert #1:
   - NAME:  Infrastructure role unhealthy
   - SEVERITY: Warning
   - COMPONENT: Health controller
   - DESCRIPTION: The health controller Heartbeat Scanner is unavailable. This may affect health reports and metrics.  

  Alert #2:
   - NAME:  Infrastructure role unhealthy
   - SEVERITY: Warning
   - COMPONENT: Health controller
   - DESCRIPTION: The health controller Fault Scanner is unavailable. This may affect health reports and metrics.

  Both alerts can be safely ignored and they'll close automatically over time.  


<!-- 2812138 | IS --> 
- You might see an alert for the **Storage** component that has the following details:

   - NAME: Storage service internal communication error  
   - SEVERITY: Critical  
   - COMPONENT: Storage  
   - DESCRIPTION: Storage service internal communication error occurred when sending requests to the following nodes.  

    The alert can be safely ignored, but you need to close the alert manually.

<!-- 2368581 - IS, ASDK --> 
- An Azure Stack operator, if you receive a low memory alert and tenant virtual machines fail to deploy with a **Fabric VM creation error**, it is possible that the Azure Stack stamp is out of available memory. Use the [Azure Stack Capacity Planner](https://gallery.technet.microsoft.com/Azure-Stack-Capacity-24ccd822) to best understand the capacity available for your workloads.

### Compute

- When creating a [Dv2 series VM](../../user/azure-stack-vm-considerations.md#vm-sizes), D11-14v2 VMs allow you to create 4, 8, 16, and 32 data disks respectively. However, the create VM pane shows 8, 16, 32, and 64 data disks.

<!-- 3235634 - IS, ASDK -->
- To deploy VMs with sizes containing a **v2** suffix; for example, **Standard_A2_v2**, please specify the suffix as **Standard_A2_v2** (lowercase v). Do not use **Standard_A2_V2** (uppercase V). This works in global Azure and is an inconsistency on Azure Stack.

<!-- 3099544 - IS, ASDK --> 
- When you create a new virtual machine (VM) using the Azure Stack portal, and you select the VM size, the USD/Month column is displayed with an **Unavailable** message. This column should not appear; displaying the VM pricing column is not supported in Azure Stack.

<!-- 2869209 - IS, ASDK --> 
- When using the [**Add-AzsPlatformImage** cmdlet](/powershell/module/azs.compute.admin/add-azsplatformimage?preserve-view=true&view=azurestackps-1.4.0), you must use the **-OsUri** parameter as the storage account URI where the disk is uploaded. If you use the local path of the disk, the cmdlet fails with the following error: *Long running operation failed with status 'Failed'*. 

<!--  2795678 - IS, ASDK --> 
- When you use the portal to create virtual machines (VM) in a premium VM size (DS,Ds_v2,FS,FSv2), the VM is created in a standard storage account. Creation in a standard storage account does not affect functionally, IOPs, or billing. 

   You can safely ignore the warning that says: *You've chosen to use a standard disk on a size that supports premium disks. This could impact operating system performance and is not recommended. Consider using premium storage (SSD) instead.*

<!-- 2967447 - IS, ASDK --> 
- The virtual machine scale set (VMSS) creation experience provides CentOS-based 7.2 as an option for deployment. Because that image is not available on Azure Stack, either select another OS for your deployment or use an Azure Resource Manager template specifying another CentOS image that has been downloaded prior to deployment from the marketplace by the operator.  

<!-- 2724873 - IS --> 
- When using the PowerShell cmdlets **Start-AzsScaleUnitNode** or  **Stop-AzsScaleunitNode** to manage scale units, the first attempt to start or stop the scale unit might fail. If the cmdlet fails on the first run, run the cmdlet a second time. The second run should succeed to complete the operation. 

<!-- TBD - IS ASDK --> 
- If provisioning an extension on a VM deployment takes too long, users should let the provisioning time-out instead of trying to stop the process to deallocate or delete the VM.  

<!-- 1662991 IS ASDK --> 
- Linux VM diagnostics is not supported in Azure Stack. When you deploy a Linux VM with VM diagnostics enabled, the deployment fails. The deployment also fails if you enable the Linux VM basic metrics through diagnostic settings.  

<!-- 2724961- IS ASDK --> 
- When you register the **Microsoft.Insight** resource provider in Subscription settings, and create a Windows VM with Guest OS Diagnostic enabled, the CPU Percentage chart in the VM overview page doesn't show metrics data.

   To find metrics data, such as the CPU Percentage chart for the VM, go to the Metrics window and show all the supported Windows VM guest metrics.

<!-- 3507629 - IS, ASDK --> 
- Managed Disks creates two new [compute quota types](../azure-stack-quota-types.md#compute-quota-types) to limit the maximum capacity of managed disks that can be provisioned. By default, 2048 GiB is allocated for each managed disks quota type. However, you may encounter the following issues:

   - For quotas created before the 1808 update, the Managed Disks quota will show 0 values in the Administrator portal, although 2048 GiB is allocated. You can increase or decrease the value based on your actual needs, and the newly set quota value overrides the 2048 GiB default.
   - If you update the quota value to 0, it is equivalent to the default value of 2048 GiB. As a workaround, set the quota value to 1.

<!-- TBD - IS ASDK --> 
- After applying the 1809 update, you might encounter the following issues when deploying VMs with Managed Disks:

  - If the subscription was created before the 1808 update, deploying a VM with Managed Disks might fail with an internal error message. To resolve the error, follow these steps for each subscription:
     1. In the Tenant portal, go to **Subscriptions** and find the subscription. Click **Resource Providers**, then click **Microsoft.Compute**, and then click **Re-register**.
     2. Under the same subscription, go to **Access Control (IAM)**, and verify that the **AzureStack-DiskRP-Client** role is listed.
  - If you have configured a multi-tenant environment, deploying VMs in a subscription associated with a guest directory might fail with an internal error message. To resolve the error, follow these steps in [this article](../enable-multitenancy.md#register-a-guest-directory) to reconfigure each of your guest directories.

- A Ubuntu 18.04 VM created with SSH authorization enabled will not allow you to use the SSH keys to log in. As a workaround, please use VM access for the Linux extension to implement SSH keys after provisioning, or use password-based authentication.

### Networking  

<!-- 1766332 - IS ASDK --> 
- Under **Networking**, if you click **Create VPN Gateway** to set up a VPN connection, **Policy Based** is listed as a VPN type. Do not select this option. Only the **Route Based** option is supported in Azure Stack.

<!-- 1902460 - IS ASDK --> 
- Azure Stack supports a single *local network gateway* per IP address. This is true across all tenant subscriptions. After the creation of the first local network gateway connection, subsequent attempts to create a local network gateway resource with the same IP address are blocked.

<!-- 16309153 - IS ASDK --> 
- On a Virtual Network that was created with a DNS Server setting of *Automatic*, changing to a custom DNS Server fails. The updated settings are not pushed to VMs in that Vnet.

<!-- 2529607 - IS ASDK --> 
- During Azure Stack *Secret Rotation*, there is a period in which Public IP Addresses are unreachable for two to five minutes.

<!-- 2664148 - IS ASDK --> 
-    In scenarios where the tenant is accessing their virtual machines by using a S2S VPN tunnel, they might encounter a scenario where connection attempts fail if the on-premises subnet was added to the Local Network Gateway after gateway was already created. 


<!-- ### SQL and MySQL-->


### App Service

<!-- 2352906 - IS ASDK --> 
- Users must register the storage resource provider before they create their first Azure Function in the subscription.


### Usage  

<!-- TBD - IS ASDK --> 
- The public IP address usage meter data shows the same *EventDateTime* value for each record instead of the *TimeDate* stamp that shows when the record was created. Currently, you cannot use this data to perform accurate accounting of public IP address usage.


<!-- #### Identity -->
<!-- #### Marketplace -->


## Download the update

You can download the Azure Stack 1809 update package from [here](https://aka.ms/azurestackupdatedownload).
  

## Next steps

- To review the servicing policy for Azure Stack integrated systems, and what you must do to keep your system in a supported state, see [Azure Stack servicing policy](../azure-stack-servicing-policy.md).  
- To use the Privileged End Point (PEP) to monitor and resume updates, see [Monitor updates in Azure Stack using the privileged endpoint](../azure-stack-monitor-update.md).  
- For an overview of the update management in Azure Stack, see [Manage updates in Azure Stack overview](../azure-stack-updates.md).  
- For more information about how to apply updates with Azure Stack, see [Apply updates in Azure Stack](../azure-stack-apply-updates.md).
::: moniker-end

::: moniker range="azs-1808"
## 1808 archived release notes
*Applies to: Azure Stack integrated systems*

This article describes the contents of the 1808 update package. The update package includes improvements, fixes, and known issues for this version of Azure Stack. This article also includes a link so you can download the update. Known issues are divided into issues directly related to the update process and issues with the build (post-installation).

> [!IMPORTANT]  
> This update package is only for Azure Stack integrated systems. Do not apply this update package to the Azure Stack Development Kit.

## Build reference

The Azure Stack 1808 update build number is **1.1808.0.97**.  

### New features

This update includes the following improvements for Azure Stack.

<!--  2682594   | IS  --> 
- **All Azure Stack environments now use the Coordinated Universal Time (UTC) time zone format.**  All log data and related information now displays in UTC format. If you update from a previous version that was not installed using UTC, your environment is updated to use UTC. 

<!-- 2437250  | IS  ASDK --> 
- **Managed Disks are supported.** You can now use Managed Disks in Azure Stack virtual machines and virtual machine scale sets. For more information, see [Azure Stack Managed Disks: Differences and considerations](../../user/azure-stack-managed-disk-considerations.md).

<!-- 2563799  | IS  ASDK --> 
- **Azure Monitor**. Like Azure Monitor on Azure, Azure Monitor on Azure Stack provides base-level infrastructure metrics and logs for most services. For more information, see [Azure Monitor on Azure Stack](../../user/azure-stack-metrics-azure-data.md).

<!-- 2487932| IS --> 
- **Prepare for the extension host**. You can use the extension host to help secure Azure Stack by reducing the number of required TCP/IP ports. With the 1808 update, you can prepare, get your Azure Stack ready for extension host. For more information, see [Prepare for extension host for Azure Stack](../azure-stack-extension-host-prepare.md).

<!-- IS --> 
- **Gallery items for Virtual Machine Scale Sets are now built-in**. The Virtual Machine Scale Set gallery item is now made available in the user and administrator portals without having to download it.  If you upgrade to 1808 it is available upon completion of upgrade.  

<!-- IS, ASDK --> 
- **Virtual machine scale set scaling**. You can use the portal to [scale a virtual machine scale set](../azure-stack-compute-add-scalesets.md#scale-a-virtual-machine-scale-set) (VMSS).    

<!-- 2489570 | IS ASDK--> 
- **Support for custom IPSec/IKE policy configurations** for [VPN gateways in Azure Stack](../../user/azure-stack-vpn-gateway-about-vpn-gateways.md).

<!-- | IS ASDK--> 
- **Kubernetes marketplace item**. You can now deploy Kubernetes clusters using the [Kubernetes Marketplace item](../azure-stack-solution-template-kubernetes-cluster-add.md). Users can select the Kubernetes item and fill out a few parameters to deploy a Kubernetes cluster to Azure Stack. The purpose of the templates is to make it simple to users to setup dev/test Kubernetes deployments in a few steps.

<!-- | IS ASDK--> 
- **Blockchain templates**. You can now execute [Ethereum consortium deployments](../../user/azure-stack-ethereum.md) on Azure Stack. You can find three new templates in the [Azure Stack Quick Start Templates](https://github.com/Azure/AzureStack-QuickStart-Templates). They allow the user to deploy and configure a multi-member consortium Ethereum network with minimal Azure and Ethereum knowledge. The purpose of the templates is to make it simple to users to setup dev/test Blockchain deployments in a few steps.

<!-- | IS ASDK--> 
- **The API version profile 2017-03-09-profile has been updated to 2018-03-01-hybrid**. API profiles specify the Azure resource provider and the API version for Azure REST endpoints. For more information about profiles, see [Manage API version profiles in Azure Stack](../../user/azure-stack-version-profiles.md).

 ### Fixed issues
<!-- IS ASDK--> 
- We fixed the issue for creating an availability set in the portal which resulted in the set having a fault domain and update domain of 1. 

<!-- IS ASDK --> 
- Settings to scale virtual machine scale sets are now available in the portal.  

<!-- 2494144- IS, ASDK --> 
- The issue that prevented some F-series virtual machine sizes from appearing when selecting a VM size for deployment is now resolved. 

<!-- IS, ASDK --> 
- Improvements for performance when creating virtual machines, and more optimized use of underlying storage.

- **Various fixes** for performance, stability, security, and the operating system that is used by Azure Stack.


### Changes
<!-- 1697698  | IS, ASDK --> 
- *Quickstart tutorials* in the User portal dashboard now link to relevant articles in the on-line Azure Stack documentation.

<!-- 2515955   | IS ,ASDK--> 
- *All services* replaces *More services* in the Azure Stack admin and user portals. You can now use *All services* as an alternative to navigate in the Azure Stack portals the same way you do in the Azure portals.

<!-- TBD | IS, ASDK --> 
- *+ Create a resource* replaces *+ New* in the Azure Stack admin and user portals.  You can now use *+ Create a resource* as an alternative to navigate in the Azure Stack portals the same way you do in the Azure portals.  

<!--  TBD | IS, ASDK --> 
- *Basic A* virtual machine sizes are retired for [creating virtual machine scale sets](../azure-stack-compute-add-scalesets.md) (VMSS) through the portal. To create a VMSS with this size, use PowerShell or a template.  

### Common Vulnerabilities and Exposures

This update installs the following updates:  

- [CVE-2018-0952](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-0952)
- [CVE-2018-8200](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8200)
- [CVE-2018-8204](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8204)
- [CVE-2018-8253](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8253)
- [CVE-2018-8339](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8339)
- [CVE-2018-8340](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8340)
- [CVE-2018-8341](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8341)
- [CVE-2018-8343](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8343)
- [CVE-2018-8344](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8344)
- [CVE-2018-8345](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8345)
- [CVE-2018-8347](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8347)
- [CVE-2018-8348](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8348)
- [CVE-2018-8349](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8349)
- [CVE-2018-8394](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8394)
- [CVE-2018-8398](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8398)
- [CVE-2018-8401](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8401)
- [CVE-2018-8404](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8404)
- [CVE-2018-8405](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8405)
- [CVE-2018-8406](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2018-8406)  

For more information about these vulnerabilities, click on the preceding links, or see Microsoft Knowledge Base article [4343887](https://support.microsoft.com/help/4343887).

This update also contains the mitigation for the speculative execution side channel vulnerability known as L1 Terminal Fault (L1TF), described in the [Microsoft Security Advisory ADV180018](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/ADV180018).  

### Prerequisites

- Install the Azure Stack 1807 update before you apply the Azure Stack 1808 update. 
- Before you start installation of this update, run [Test-AzureStack](../azure-stack-diagnostic-test.md) with the following parameters to validate the status of your Azure Stack and resolve any operational issues found, including all warnings and failures. Also review active alerts, and resolve any that require action.  

  ```PowerShell
  Test-AzureStack -Include AzsControlPlane, AzsDefenderSummary, AzsHostingInfraSummary, AzsHostingInfraUtilization, AzsInfraCapacity, AzsInfraRoleSummary, AzsPortalAPISummary, AzsSFRoleSummary, AzsStampBMCSummary
  ```   

### Known issues with the update process

- When you run [Test-AzureStack](../azure-stack-diagnostic-test.md) after the 1808 update, a warning message from the Baseboard Management Controller (BMC) is displayed. You can safely ignore this warning.

<!-- 2468613 - IS --> 
- During installation of this update, you might see alerts with the title *Error Template for FaultType UserAccounts.New is missing.*  You can safely ignore these alerts. These alerts will close automatically after installation of this update completes.

<!-- 2489559 - IS --> 
- Do not attempt to create virtual machines during the installation of this update. For more information about managing updates, see [Manage updates in Azure Stack overview](../azure-stack-updates.md).

<!-- 2830461 - IS --> 
- In certain circumstances when an update requires attention, the corresponding alert may not be generated. The accurate status will still be reflected in the portal and is not impacted.

### Post-update steps
After the installation of this update, install any applicable Hotfixes. For more information view the following knowledge base articles, as well as our [Servicing Policy](../azure-stack-servicing-policy.md). 
- [KB 4465859 Azure Stack Hotfix Azure Stack Hotfix 1.1808.2.104](https://support.microsoft.com/help/4465859/)

## Known issues (post-installation)

The following are post-installation known issues for this build version.

### Portal

- The Azure Stack technical documentation focuses on the latest release. Due to portal changes between releases, what you see when using the Azure Stack portals might vary from what you see in the documentation. 

<!-- TBD - IS ASDK --> 
- You might see a blank dashboard in the portal. To recover the dashboard, click **Edit Dashboard**, then right click and select **Reset to default state**.

<!-- 2930718 - IS ASDK --> 
- In the administrator portal, when accessing the details of any user subscription, after closing the blade and clicking on **Recent**, the user subscription name does not appear.

<!-- 3060156 - IS ASDK --> 
- In both the administrator and user portals, clicking on the portal settings and selecting **Delete all settings and private dashboards** does not work as expected. An error notification is displayed. 

<!-- 2930799 - IS ASDK --> 
- In both the administrator and user portals, under **All services**, the asset **DDoS protection plans** is incorrectly listed. It is not actually available in Azure Stack. If you try to create it, an error is displayed stating that the portal could not create the marketplace item. 

<!-- 2930820 - IS ASDK --> 
- In both the administrator and user portals, if you search for "Docker," the item is incorrectly returned. It is not actually available in Azure Stack. If you try to create it, a blade with an error indication is displayed. 

<!-- 2967387 IS, ASDK --> 
- The account you use to sign in to the Azure Stack admin or user portal displays as **Unidentified user**. This occurs when the account does not have either a *First* or *Last* name specified. To work around this issue, edit the user account to provide either the First or Last name. You must then sign out and then sign back in to the portal. 

<!--  2873083 - IS ASDK --> 
-  When you use the portal to create a virtual machine scale set (VMSS), the *instance size* dropdown doesn't load correctly when you use Internet Explorer. To work around this problem, use another browser while using the portal to create a VMSS.  

<!-- 2931230 IS  ASDK --> 
- Plans that are added to a user subscription as an add-on plan cannot be deleted, even when you remove the plan from the user subscription. The plan will remain until the subscriptions that reference the add-on plan are also deleted. 

<!--2760466 IS  ASDK --> 
- When you install a new Azure Stack environment that runs this version, the alert that indicates *Activation Required* might not display. [Activation](../azure-stack-registration.md) is required before you can use marketplace syndication.  

<!-- TBD - IS ASDK --> 
- The two administrative subscription types that were introduced with version 1804 should not be used. The subscription types are **Metering subscription**, and **Consumption subscription**. These subscription types are visible in new Azure Stack environments beginning with version 1804 but are not yet ready for use. You should continue to use the **Default Provider** subscription type.

<!-- TBD - IS ASDK --> 
- Deleting user subscriptions results in orphaned resources. As a workaround, first delete user resources or the entire resource group, and then delete user subscriptions.

<!-- TBD - IS ASDK --> 
- You cannot view permissions to your subscription using the Azure Stack portals. As a workaround, use PowerShell to verify permissions.


### Health and monitoring
<!-- 1264761 - IS ASDK --> 
- You might see alerts for the **Health controller** component that have the following details:  

   Alert #1:
   - NAME:  Infrastructure role unhealthy
   - SEVERITY: Warning
   - COMPONENT: Health controller
   - DESCRIPTION: The health controller Heartbeat Scanner is unavailable. This may affect health reports and metrics.  

  Alert #2:
   - NAME:  Infrastructure role unhealthy
   - SEVERITY: Warning
   - COMPONENT: Health controller
   - DESCRIPTION: The health controller Fault Scanner is unavailable. This may affect health reports and metrics.

  Both alerts can be safely ignored and they'll close automatically over time.  


<!-- 2812138 | IS --> 
- You might see an alert for **Storage** component that have the following details:

   - NAME: Storage service internal communication error  
   - SEVERITY: Critical  
   - COMPONENT: Storage  
   - DESCRIPTION: Storage service internal communication error occurred when sending requests to the following nodes.  

    The alert can be safely ignored, but you need to close the alert manually.

<!-- 2368581 - IS. ASDK --> 
- An Azure Stack operator, if you receive a low memory alert and tenant virtual machines fail to deploy with a **Fabric VM creation error**, it is possible that the Azure Stack stamp is out of available memory. Use the [Azure Stack Capacity Planner](https://gallery.technet.microsoft.com/Azure-Stack-Capacity-24ccd822) to best understand the capacity available for your workloads.


### Compute

<!-- 3099544 IS, ASDK --> 
- When you create a new virtual machine (VM) using the Azure Stack portal, and you select the VM size, the USD/Month column is displayed with an **Unavailable** message. This column should not appear; displaying the VM pricing column is not supported in Azure Stack.

<!-- 3090289 IS, ASDK --> 
- After applying the 1808 update, you may encounter the following issues when deploying VMs with Managed Disks:

   1. If the subscription was created before the 1808 update, deploying VM with Managed Disks may fail with an internal error message. To resolve the error, follow these steps for each subscription:
      1. In the Tenant portal, go to **Subscriptions** and find the subscription. Click **Resource Providers**, then click **Microsoft.Compute**, and then click **Re-register**.
      2. Under the same subscription, go to **Access Control (IAM)**, and verify that **Azure Stack Managed Disk** is listed.
   2. If you have configured a multi-tenant environment, deploying VMs in a subscription associated with a guest directory may fail with an internal error message. To resolve the error, follow these steps:
      1. Apply the [1808 Azure Stack Hotfix](https://support.microsoft.com/help/4465859).
      2. Follow the steps in [this article](../enable-multitenancy.md#register-a-guest-directory) to reconfigure each of your guest directories.

<!-- 2869209 IS, ASDK --> 
- When using the [**Add-AzsPlatformImage** cmdlet](/powershell/module/azs.compute.admin/add-azsplatformimage?preserve-view=true&view=azurestackps-1.4.0), you must use the **-OsUri** parameter as the storage account URI where the disk is uploaded. If you use the local path of the disk, the cmdlet fails with the following error: *Long running operation failed with status Failed*. 

<!--  2966665 IS, ASDK --> 
- Attaching SSD data disks to premium size managed disk virtual machines  (DS, DSv2, Fs, Fs_V2) fails with an error:  *Failed to update disks for the virtual machine vmname Error: Requested operation cannot be performed because storage account type Premium_LRS is not supported for VM size Standard_DS/Ds_V2/FS/Fs_v2)*

   To work around this issue, use *Standard_LRS* data disks instead of *Premium_LRS disks*. Use of *Standard_LRS* data disks doesn't change IOPs or the billing cost. 

<!--  2795678 IS, ASDK --> 
- When you use the portal to create virtual machines (VM) in a premium VM size (DS,Ds_v2,FS,FSv2), the VM is created in a standard storage account. Creation in a standard storage account does not affect functionally, IOPs, or billing. 

   You can safely ignore the warning that says: *You've chosen to use a standard disk on a size that supports premium disks. This could impact operating system performance and is not recommended. Consider using premium storage (SSD) instead.*

<!-- 2967447 - IS, ASDK --> 
- The virtual machine scale set (VMSS) create experience provides CentOS-based 7.2 as an option for deployment. Because that image is not available on Azure Stack, either select another OS for your deployment or use an Azure Resource Manager template specifying another CentOS image which has been downloaded prior to deployment from the marketplace by the operator.  

<!-- 2724873 - IS --> 
- When using the PowerShell cmdlets **Start-AzsScaleUnitNode** or  **Stop-AzsScaleunitNode** to manage scale units, the first attempt to start or stop the scale unit might fail. If the cmdlet fails on the first run, run the cmdlet a second time. The second run should succeed to complete the operation. 

<!-- TBD - IS ASDK --> 
- When you create virtual machines on the Azure Stack user portal, the portal displays an incorrect number of data disks that can attach to a DS series VM. DS series VMs can accommodate as many data disks as the Azure configuration.

<!-- TBD - IS ASDK --> 
- If provisioning an extension on a VM deployment takes too long, users should let the provisioning time-out instead of trying to stop the process to deallocate or delete the VM.  

<!-- 1662991 IS ASDK --> 
- Linux VM diagnostics is not supported in Azure Stack. When you deploy a Linux VM with VM diagnostics enabled, the deployment fails. The deployment also fails if you enable the Linux VM basic metrics through diagnostic settings.  

<!-- 2724961- IS ASDK --> 
- When you register the **Microsoft.Insight** resource provider in Subscription settings, and create a Windows VM with Guest OS Diagnostic enabled, the CPU Percentage chart in the VM overview page will not be able to show metric data.

   To find the CPU Percentage chart for the VM, go to the **Metrics** blade and show all the supported Windows VM guest metrics.



### Networking  

<!-- 1766332 - IS ASDK --> 
- Under **Networking**, if you click **Create VPN Gateway** to set up a VPN connection, **Policy Based** is listed as a VPN type. Do not select this option. Only the **Route Based** option is supported in Azure Stack.

<!-- 1902460 - IS ASDK --> 
- Azure Stack supports a single *local network gateway* per IP address. This is true across all tenant subscriptions. After the creation of the first local network gateway connection, subsequent attempts to create a local network gateway resource with the same IP address are blocked.

<!-- 16309153 - IS ASDK --> 
- On a Virtual Network that was created with a DNS Server setting of *Automatic*, changing to a custom DNS Server fails. The updated settings are not pushed to VMs in that Vnet.

<!-- 2702741 -  IS ASDK --> 
- Public IPs that are deployed by using the Dynamic allocation method are not guaranteed to be preserved after a Stop-Deallocate is issued.

<!-- 2529607 - IS ASDK --> 
- During Azure Stack *Secret Rotation*, there is a period in which Public IP Addresses are unreachable for two to five minutes.

<!-- 2664148 - IS ASDK --> 
- In scenarios where the tenant is accessing their virtual machines by using a S2S VPN tunnel, they might encounter a scenario where connection attempts fail if the on-premise subnet was added to the Local Network Gateway after gateway was already created. 


<!-- ### SQL and MySQL-->


### App Service

<!-- 2352906 - IS ASDK --> 
- Users must register the storage resource provider before they create their first Azure Function in the subscription.

<!-- 2489178 - IS ASDK --> 
- In order to scale out infrastructure (workers, management, front-end roles), you must use PowerShell as described in the release notes for Compute.



### Usage  
<!-- TBD - IS ASDK --> 
- Usage Public IP address usage meter data shows the same *EventDateTime* value for each record instead of the *TimeDate* stamp that shows when the record was created. Currently, you can't use this data to perform accurate accounting of public IP address usage.


<!-- #### Identity -->
<!-- #### Marketplace -->


## Download the update
You can download the Azure Stack 1808 update package from [here](https://aka.ms/azurestackupdatedownload).
  

## Next steps
- To review the servicing policy for Azure Stack integrated systems, and what you must do to keep your system in a supported state, see [Azure Stack servicing policy](../azure-stack-servicing-policy.md).  
- To use the Privileged End Point (PEP) to monitor and resume updates, see [Monitor updates in Azure Stack using the privileged endpoint](../azure-stack-monitor-update.md).  
- For an overview of the update management in Azure Stack, see [Manage updates in Azure Stack overview](../azure-stack-updates.md).  
- For more information about how to apply updates with Azure Stack, see [Apply updates in Azure Stack](../azure-stack-apply-updates.md).
::: moniker-end

::: moniker range="azs-1807"
## 1807 archived release notes
*Applies to: Azure Stack integrated systems*

This article describes the contents of the 1807 update package. This update includes improvements, fixes, and known issues for this version of Azure Stack, and where to download the update. Known issues are divided into issues directly related to the update process and issues with the build (post-installation).

> [!IMPORTANT]  
> This update package is only for Azure Stack integrated systems. Do not apply this update package to the Azure Stack Development Kit.

## Build reference

The Azure Stack 1807 update build number is **1.1807.0.76**.  

### New features

This update includes the following improvements for Azure Stack.

<!-- 1658937 | ASDK, IS --> 
- **Start backups on a pre-defined schedule** - As an appliance, Azure Stack can now automatically trigger infrastructure backups periodically to eliminate human intervention. Azure Stack will also automatically clean up the external share for backups that are older than the defined retention period. For more information, see [Enable Backup for Azure Stack with PowerShell](../azure-stack-backup-enable-backup-powershell.md).

<!-- 2496385 | ASDK, IS -->  
- **Added data transfer time into the total backup time.** For more information, see [Enable Backup for Azure Stack with PowerShell](../azure-stack-backup-enable-backup-powershell.md).

<!-- 1702130 | ASDK, IS -->  
- **Backup external capacity now shows the correct capacity of the external share.** (Previously this was hard-code to 10 GB.) For more information, see [Enable Backup for Azure Stack with PowerShell](../azure-stack-backup-enable-backup-powershell.md).

<!-- 2508488 |  IS   -->
- **Expand capacity** by [adding additional scale unit nodes](../azure-stack-add-scale-node.md).

<!-- 2753130 |  IS, ASDK   -->  
- **Azure Resource Manager templates now support the condition element** - You can now deploy a resource in an Azure Resource Manger template using a condition. You can design your template to deploy a resource based on a condition, such as evaluating if a parameter value is present. For information about using a template as a condition, see [Conditionally deploy a resource](/azure/architecture/guide/azure-resource-manager/advanced-templates/conditional-deploy) and [Variables section of Azure Resource Manager templates](/azure/azure-resource-manager/resource-manager-templates-variables) in the Azure documentation. 

   You can also use templates to [deploy resources to more than one subscription or resource group](/azure/azure-resource-manager/resource-manager-cross-resource-group-deployment).  

<!--2753073 | IS, ASDK -->  
- **The Microsoft.Network API resource version support has been updated** to include support for API version 2017-10-01 from 2015-06-15 for Azure Stack network resources.  Support for resource versions between 2017-10-01 and 2015-06-15 is not included in this release.  Please refer to [Considerations for Azure Stack networking](../../user/azure-stack-network-differences.md) for functionality differences.

<!-- 2272116 | IS, ASDK   -->  
- **Azure Stack has added support for reverse DNS lookups for externally facing Azure Stack infrastructure endpoints** (that is for portal, adminportal, management, and adminmanagement). This allows Azure Stack external endpoint names to be resolved from an IP address.

<!-- 2780899 |  IS, ASDK   --> 
- **Azure Stack now supports adding additional network interfaces to an existing VM.**  This functionality is available by using the portal, PowerShell, and CLI. For more information, see [Add or remove network interfaces](/azure/virtual-network/virtual-network-network-interface-vm) in the Azure documentation. 

<!-- 2222444 | IS, ASDK   -->  
- **Improvements in accuracy and resiliency have been made to networking usage meters**.  Network usage meters are now more accurate and take into account suspended subscriptions, outage periods and race conditions.

<!-- 2753080 | IS -->  
- **Update available notification.** Connected Azure Stack deployments will now periodically check a secured endpoint and determine if an update is available for your cloud. This notification appears in the Update tile, as it would after manually checking for and importing a new update. Read more about [managing updates for Azure Stack](../azure-stack-updates.md).

<!-- 2297790 | IS, ASDK -->  
- **Improvements to the Azure Stack syslog client (preview feature)**. This client allows the forwarding of audit and logs related to the Azure Stack infrastructure to a syslog server or security information and event management (SIEM) software external to Azure Stack. The syslog client now supports the TCP protocol with plain text or TLS 1.2 encryption, the latter being the default configuration. You can configure the TLS connection with either server-only or mutual authentication.

  To configure how the syslog client communicates (such as protocol, encryption, and authentication) with the syslog server, use the *Set-SyslogServer* cmdlet. This cmdlet is available from the privileged endpoint (PEP).

  To add the client-side certificate for the syslog client TLS 1.2 mutual authentication, use the Set-SyslogClient cmdlet in the PEP.

  With this preview, you can see a much larger number of audits and alerts. 

  Because this feature is still in preview, don't rely on it in production environments.

  For more information, see [Azure Stack syslog forwarding](../azure-stack-integrate-security.md).

<!-- ####### | IS, ASDK | --> 
- **Azure Resource Manager includes the region name.** With this release, objects retrieved from the Azure Resource Manager will now include the region name attribute. If an existing PowerShell script directly passes the object to another cmdlet, the script may produce an error and fail. This is Azure Resource Manager compliant behavior, and requires the calling client to subtract the region attribute. For more information about the Azure Resource Manager see [Azure Resource Manager Documentation](/azure/azure-resource-manager/). <!-- verify 8-10 mdb -->

<!-- TBD | IS, ASDK -->  
- **Changes to Delegated Providers functionality.** Starting with 1807 the Delegated Providers model is simplified in order to better align with the Azure reseller model and Delegated Providers will not be able to create other Delegated Providers, essentially flattening the model and making the Delegated Provider feature available on a single level. To enable the transition to the new model and the management of the subscriptions, the user-subscriptions can now be moved between new or existing Delegated Provider subscriptions that belong to the same Directory tenant. User-subscriptions belonging to the Default Provider Subscription can also be moved to the Delegated Provider Subscriptions in the same Directory-tenant.  For more information see [Delegate offers in Azure Stack](../azure-stack-delegated-provider.md).

<!-- 2536808 IS ASDK --> 
- **Improved VM creation time** for VMs that are created with images you download from Azure Marketplace.

<!-- TBD | IS, ASDK -->  
- **Azure Stack Capacity Planner usability improvements**. The Azure Stack [Capacity Planner](https://aka.ms/azstackcapacityplanner) now offers a simplified experience for inputting S2D cache and S2D capacity when defining solution SKUs. The 1000 VM limit has been removed.


### Fixed issues

<!-- TBD | ASDK, IS --> 
- Various improvements were made to the update process to make it more reliable. In addition, fixes have been made to underlying infrastructure, which minimize potential downtime for workloads during the update.

<!--2292271 | ASDK, IS --> 
- We fixed an issue where a modified Quota limit did not apply to existing subscriptions. Now, when you raise a Quota limit for a network resource that is part of an Offer and Plan associated with a user subscription, the new limit applies to the pre-existing subscriptions, as well as new subscriptions.

<!-- 448955 | IS ASDK --> 
- You can now successfully query activity logs for systems that are deployed in a UTC+N time zone.    

<!-- 2319627 |  ASDK, IS --> 
- Pre-check for backup configuration parameters (Path/Username/Password/Encryption Key) no longer sets incorrect settings to the backup configuration. (Previously, incorrect settings were set into the backup and backup would then fail when triggered.)

<!-- 2215948 |  ASDK, IS -->
- The backup list now refreshes when you manually delete the backup from the external share.

<!-- 2332636 | IS -->  
- Update to this version no longer resets the default owner of the default provider subscription to the built-in **CloudAdmin** user when deployed with AD FS.

<!-- 2360715 |  ASDK, IS -->  
- When you set up datacenter integration, you no longer access the AD FS metadata file from an Azure file share. For more information, see [Setting up AD FS integration by providing federation metadata file](../azure-stack-integrate-identity.md#setting-up-ad-fs-integration-by-providing-federation-metadata-file). 

<!-- 2388980 | ASDK, IS --> 
- We fixed an issue that prevented users from assigned an existing Public IP Address that had been previously assigned to a Network Interface or Load Balancer to a new Network Interface or Load Balancer.  

<!-- 2551834 - IS, ASDK --> 
- When you select *Overview* for a storage account in either the admin or user portals, the *Essentials* pane now displays all the expected information correctly. 

<!-- 2551834 - IS, ASDK --> 
- When you select *Tags* for a storage account in either the admin or user portals, the information now displays correctly.

<!-- TBD - IS ASDK --> 
- This version of Azure Stack fixes the issue that prevented the application of driver updates from OEM Extension packages.

<!-- 2055809- IS ASDK --> 
- We fixed an issue that prevented you from deleting VMs from the compute blade when the VM failed to be created.  

<!--  2643962 IS ASDK -->  
- The alert for *Low memory capacity* no longer appears incorrectly.

- **Various fixes** for performance, stability, security, and the operating system that is used by Azure Stack.


<!-- ### Additional releases timed with this update    -->

### Common Vulnerabilities and Exposures
Azure Stack uses Server Core installations of Windows Server 2016 to host key infrastructure. This release installs the following Windows Server 2016 updates on the infrastructure servers for Azure Stack: 
- [CVE-2018-8206](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2018-8206)
- [CVE-2018-8222](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2018-8222)
- [CVE-2018-8282](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2018-8282)
- [CVE-2018-8304](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2018-8304)
- [CVE-2018-8307](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2018-8307)
- [CVE-2018-8308](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2018-8308) 
- [CVE-2018-8309](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2018-8309)
- [CVE-2018-8313](https://portal.msrc.microsoft.com/en-us/security-guidance/advisory/CVE-2018-8313)  

For more information about these vulnerabilities, click on the preceding links, or see Microsoft Knowledge Base articles [4338814](https://support.microsoft.com/help/4338814)  and [4345418](https://support.microsoft.com/help/4345418).



## Before you begin

### Prerequisites

- Install the Azure Stack 1805 update before you apply the Azure Stack 1807 update.  There was no update 1806.  

- Install the latest available update or hotfix for version 1805.  

- Before you start installation of this update, run [Test-AzureStack](../azure-stack-diagnostic-test.md) with the following parameters to validate the status of your Azure Stack and resolve any operational issues found, including all warnings and failures. Also review active alerts, and resolve any that require action.  

  ```PowerShell
  Test-AzureStack -Include AzsControlPlane, AzsDefenderSummary, AzsHostingInfraSummary, AzsHostingInfraUtilization, AzsInfraCapacity, AzsInfraRoleSummary, AzsPortalAPISummary, AzsSFRoleSummary, AzsStampBMCSummary
  ``` 

### Known issues with the update process

<!-- 2468613 - IS --> 
- During installation of this update, you might see alerts with the title *Error Template for FaultType UserAccounts.New is missing.*  You can safely ignore these alerts. These alerts will close automatically after installation of this update completes.

<!-- 2489559 - IS --> 
- Do not attempt to create virtual machines during the installation of this update. For more information about managing updates, see [Manage updates in Azure Stack overview](../azure-stack-updates.md).

<!-- 2830461 - IS --> 
- In certain circumstances when an update requires attention, the corresponding alert may not be generated. The accurate status will still be reflected in the portal and is not impacted.

### Post-update steps
After the installation of this update, install any applicable Hotfixes. For more information view the following knowledge base articles, as well as our [Servicing Policy](../azure-stack-servicing-policy.md). 
- [KB 4464231 Azure Stack Hotfix Azure Stack Hotfix 1.1807.1.78](https://support.microsoft.com/help/4464231)

<!-- 2933866 IS --> 
After installation of this update, you can see **improved status for failed update installations.** This might include information about previous update installation failures that are revised to reflect the two new STATE categories. The new STATE categories are *PreparationFailed*, and *InstallationFailed*.  

## Known issues (post-installation)

The following are post-installation known issues for this build version.

### Portal

- The Azure Stack technical documentation focuses on the latest release. Due to portal changes between releases, what you see when using the Azure Stack portals might vary from what you see in the documentation. 

- The ability to [open a new support request from the dropdown](../azure-stack-manage-portals.md#quick-access-to-help-and-support) within the administrator portal is not available. Instead, for Azure Stack integrated systems, use the following link: [https://aka.ms/newsupportrequest](https://aka.ms/newsupportrequest).

<!-- 2931230 IS  ASDK --> 
- Plans that are added to a user subscription as an add-on plan cannot be deleted, even when you remove the plan from the user subscription. The plan will remain until the subscriptions that reference the add-on plan are also deleted. 

<!--2760466 IS  ASDK --> 
- When you install a new Azure Stack environment that runs this version, the alert that indicates *Activation Required* might not display. [Activation](../azure-stack-registration.md) is required before you can use marketplace syndication.  

<!-- TBD - IS ASDK --> 
- The two administrative subscription types that were introduced with version 1804 should not be used. The subscription types are **Metering subscription**, and **Consumption subscription**. These subscription types are visible in new Azure Stack environments beginning with version 1804 but are not yet ready for use. You should continue to use the **Default Provider** subscription type.

<!-- 2403291 - IS ASDK --> 
- You might not have use of the horizontal scroll bar along the bottom of the admin and user portals. If you can't access the horizontal scroll bar, use the breadcrumbs to navigate to a previous blade in the portal by selecting the name of the blade you want to view from the breadcrumb list found at the top left of the portal.

<!-- TBD - IS --> 
- It might not be possible to view compute or storage resources in the administrator portal. The cause of this issue is an error during the installation of the update that causes the update to be incorrectly reported as successful. If this issue occurs, contact Microsoft Customer Support Services for assistance.

<!-- TBD - IS --> 
- You might see a blank dashboard in the portal. To recover the dashboard, select the gear icon in the upper right corner of the portal, and then select **Restore default settings**.

<!-- TBD - IS ASDK --> 
- Deleting user subscriptions results in orphaned resources. As a workaround, first delete user resources or the entire resource group, and then delete user subscriptions.

<!-- TBD - IS ASDK --> 
- You cannot view permissions to your subscription using the Azure Stack portals. As a workaround, use PowerShell to verify permissions.


### Health and monitoring
<!-- 1264761 - IS ASDK -->  
- You might see alerts for the **Health controller** component that have the following details:  

   Alert #1:
   - NAME:  Infrastructure role unhealthy
   - SEVERITY: Warning
   - COMPONENT: Health controller
   - DESCRIPTION: The health controller Heartbeat Scanner is unavailable. This may affect health reports and metrics.  

  Alert #2:
   - NAME:  Infrastructure role unhealthy
   - SEVERITY: Warning
   - COMPONENT: Health controller
   - DESCRIPTION: The health controller Fault Scanner is unavailable. This may affect health reports and metrics.

  Both alerts can be safely ignored and they'll close automatically over time.  


<!-- 2812138 | IS --> 
- You might see an alert for **Storage** component that have the following details:

   - NAME: Storage service internal communication error  
   - SEVERITY: Critical  
   - COMPONENT: Storage  
   - DESCRIPTION: Storage service internal communication error occurred when sending requests to the following nodes.  

    The alert can be safely ignored, but you need to close the alert manually.

<!-- 2368581 - IS. ASDK --> 
- An Azure Stack operator, if you receive a low memory alert and tenant virtual machines fail to deploy with a **Fabric VM creation error**, it is possible that the Azure Stack stamp is out of available memory. Use the [Azure Stack Capacity Planner](https://gallery.technet.microsoft.com/Azure-Stack-Capacity-24ccd822) to best understand the capacity available for your workloads.


### Compute

<!-- 2724873 - IS --> 
- When using the PowerShell cmdlets **Start-AzsScaleUnitNode** or  **Stop-AzsScaleunitNode** to manage scale units, the first attempt to start or stop the scale unit might fail. If the cmdlet fails on the first run, run the cmdlet a second time. The second run should succeed to complete the operation. 

<!-- 2494144 - IS, ASDK --> 
- When selecting a virtual machine size for a virtual machine deployment, some F-Series VM sizes are not visible as part of the size selector when you create a VM. The following VM sizes do not appear in the selector: *F8s_v2*, *F16s_v2*, *F32s_v2*, and *F64s_v2*.  
  As a workaround, use one of the following methods to deploy a VM. In each method, you need to specify the VM size you want to use.

  - **Azure Resource Manager template:** When you use a template, set the *vmSize* in the template to equal the VM size you want to use. For example, the following entry is used to deploy a VM that uses the *F32s_v2* size:  

    ```
        "properties": {
        "hardwareProfile": {
                "vmSize": "Standard_F32s_v2"
        },
    ```  
  - **Azure CLI:** You can use the [az vm create](/cli/azure/vm?preserve-view=true&view=azure-cli-latest#az-vm-create) command and specify the VM size as a parameter, similar to `--size "Standard_F32s_v2"`.

  - **PowerShell:** With PowerShell you can use [New-AzureRMVMConfig](/powershell/module/azurerm.compute/new-azurermvmconfig?preserve-view=true&view=azurermps-6.0.0) with the parameter that specifies the VM size, similar to `-VMSize "Standard_F32s_v2"`.


<!-- TBD - IS ASDK --> 
- Scaling settings for virtual machine scale sets are not available in the portal. As a workaround, you can use [Azure PowerShell](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-manage-powershell#change-the-capacity-of-a-scale-set). Because of PowerShell version differences, you must use the `-Name` parameter instead of `-VMScaleSetName`.

<!-- TBD - IS --> 
- When you create an availability set in the portal by going to **New** > **Compute** > **Availability set**, you can only create an availability set with a fault domain and update domain of 1. As a workaround, when creating a new virtual machine, create the availability set by using PowerShell, CLI, or from within the portal.

<!-- TBD - IS ASDK --> 
- When you create virtual machines on the Azure Stack user portal, the portal displays an incorrect number of data disks that can attach to a DS series VM. DS series VMs can accommodate as many data disks as the Azure configuration.

<!-- TBD - IS ASDK --> 
- If provisioning an extension on a VM deployment takes too long, users should let the provisioning time-out instead of trying to stop the process to deallocate or delete the VM.  

<!-- 1662991 IS ASDK --> 
- Linux VM diagnostics is not supported in Azure Stack. When you deploy a Linux VM with VM diagnostics enabled, the deployment fails. The deployment also fails if you enable the Linux VM basic metrics through diagnostic settings.  

<!-- 2724961- IS ASDK --> 
- When you register the **Microsoft.Insight** resource provider in Subscription settings, and create a Windows VM with Guest OS Diagnostic enabled, the VM overview page doesn't show metrics data. 

   To find metrics data, like the CPU Percentage chart for the VM, go to the **Metrics** blade and show all the supported Windows VM guest metrics.

### Networking  

<!-- 1766332 - IS ASDK --> 
- Under **Networking**, if you click **Create VPN Gateway** to set up a VPN connection, **Policy Based** is listed as a VPN type. Do not select this option. Only the **Route Based** option is supported in Azure Stack.

<!-- 1902460 - IS ASDK --> 
- Azure Stack supports a single *local network gateway* per IP address. This is true across all tenant subscriptions. After the creation of the first local network gateway connection, subsequent attempts to create a local network gateway resource with the same IP address are blocked.

<!-- 16309153 - IS ASDK --> 
- On a Virtual Network that was created with a DNS Server setting of *Automatic*, changing to a custom DNS Server fails. The updated settings are not pushed to VMs in that Vnet.

<!-- 2702741 -  IS ASDK --> 
- Public IPs that are deployed by using the Dynamic allocation method are not guaranteed to be preserved after a Stop-Deallocate is issued.

<!-- 2529607 - IS ASDK --> 
- During Azure Stack *Secret Rotation*, there is a period in which Public IP Addresses are unreachable for two to five minutes.

<!-- 2664148 - IS ASDK --> 
- In scenarios where the tenant is accessing their virtual machines by using a S2S VPN tunnel, they might encounter a scenario where connection attempts fail if the on-premise subnet was added to the Local Network Gateway after gateway was already created. 


### SQL and MySQL



<!-- No Number - IS, ASDK -->  
- Special characters, including spaces and periods, are not supported in the **Family** name when you create a SKU for the SQL and MySQL resource providers. 

<!-- TBD - IS --> 
- Only the resource provider is supported to create items on servers that host SQL or MySQL. Items created on a host server that are not created by the resource provider might result in a mismatched state.  

<!-- TBD - IS -->
> [!NOTE]   
> After you update to this version of Azure Stack, you can continue to use the SQL and MySQL resource providers that you previously deployed.  We recommend you update SQL and MySQL when a new release becomes available. Like Azure Stack, apply updates to SQL and MySQL resource providers sequentially. For example, if you use version 1804, first apply version 1805, and then update to 1807.  
>  
> The install of this update does not affect the current use of SQL or MySQL resource providers by your users. 
> Regardless of the version of the resource providers you use, your users data in their databases is not touched, and remains accessible.  

### App Service

<!-- 2352906 - IS ASDK --> 
- Users must register the storage resource provider before they create their first Azure Function in the subscription.

<!-- 2489178 - IS ASDK --> 
- In order to scale out infrastructure (workers, management, front-end roles), you must use PowerShell as described in the release notes for Compute.

<!-- TBD - IS ASDK --> 
- App Service can only be deployed into the *Default Provider subscription* at this time. 


### Usage  
<!-- TBD - IS ASDK --> 
- Usage Public IP address usage meter data shows the same *EventDateTime* value for each record instead of the *TimeDate* stamp that shows when the record was created. Currently, you can't use this data to perform accurate accounting of public IP address usage.


<!-- #### Identity -->
<!-- #### Marketplace -->


## Download the update
You can download the Azure Stack 1807 update package from [here](https://aka.ms/azurestackupdatedownload).


## Next steps
- To review the servicing policy for Azure Stack integrated systems, and what you must do to keep your system in a supported state, see [Azure Stack servicing policy](../azure-stack-servicing-policy.md).  
- To use the Privileged End Point (PEP) to monitor and resume updates, see [Monitor updates in Azure Stack using the privileged endpoint](../azure-stack-monitor-update.md).  
- For an overview of the update management in Azure Stack, see [Manage updates in Azure Stack overview](../azure-stack-updates.md).  
- For more information about how to apply updates with Azure Stack, see [Apply updates in Azure Stack](../azure-stack-apply-updates.md).
::: moniker-end

::: moniker range="azs-1805"
## 1805 archived release notes
*Applies to: Azure Stack integrated systems*

This article describes the improvements and fixes in the 1805 update package, known issues for this version, and where to download the update. Known issues are divided into issues directly related to the update process and issues with the build (post-installation).

> [!IMPORTANT]        
> This update package is only for Azure Stack integrated systems. Do not apply this update package to the Azure Stack Development Kit.

## Build reference    
The Azure Stack 1805 update build number is **1.1805.1.47**.  

> [!TIP]  
> Based on customer feedback, there is an update to the version schema in use for Microsoft Azure Stack.  Starting with this update, 1805, the new schema better represents the current cloud version.  
> 
> The version schema is now *Version.YearYearMonthMonth.MinorVersion.BuildNumber* where the second and third sets indicate the version and release. For example, 1805.1 represents the *release to manufacturing* (RTM) version of 1805.  


### New features
This update includes the following improvements for Azure Stack.
<!-- 2297790 - IS, ASDK --> 
- **Azure Stack now includes a *Syslog* client** as a *preview feature*. This client allows the forwarding of audit and security logs related to the Azure Stack infrastructure to a Syslog server or security information and event management (SIEM) software that is external to Azure Stack. Currently, the Syslog client only supports unauthenticated UDP connections over default port 514. The payload of each Syslog message is formatted in Common Event Format (CEF). 

  To configure the Syslog client, use  the **Set-SyslogServer** cmdlet exposed in the Privileged Endpoint. 

  With this preview, you might see the following three alerts. When presented by Azure Stack, these alerts include *descriptions* and *remediation* guidance. 
  - TITLE: Code Integrity Off  
  - TITLE: Code Integrity in Audit Mode 
  - TITLE: User Account Created

  While this feature is in preview, it should not be relied upon in production environments.   




### Fixed issues

<!-- # - applicability -->
- We fixed the issue that blocked [opening a new support request from the dropdown](../azure-stack-manage-portals.md#quick-access-to-help-and-support) from within the admin portal. This option now works as intended. 

- **Various fixes** for performance, stability, security, and the operating system that is used by Azure Stack.


<!-- # Additional releases timed with this update    -->



## Before you begin    

### Prerequisites
- Install the Azure Stack 1804 update before you apply the Azure Stack 1805 update.  
- Install the latest available update or hotfix for version 1804.   
- Before you start installation of update 1805, run [Test-AzureStack](../azure-stack-diagnostic-test.md) to validate the status of your Azure Stack and resolve any operational issues found. Also review active alerts, and resolve any that require action. 

### Known issues with the update process   
- During installation of the 1805 update, you might see alerts with the title *Error  Template for FaultType UserAccounts.New is missing.*  You can safely ignore these alerts. These alerts will close automatically after the update to 1805 completes.   

<!-- 2489559 - IS --> 
- Do not attempt to create virtual machines during the installation of this update. For more information about managing updates, see [Manage updates in Azure Stack overview](../azure-stack-updates.md).


### Post-update steps
After the installation of 1805, install any applicable Hotfixes. For more information view the following knowledge base articles, as well as our [Servicing Policy](../azure-stack-servicing-policy.md).  
 - [KB 4344102 - Azure Stack Hotfix 1.1805.7.57](https://support.microsoft.com/help/4344102).


## Known issues (post-installation)
The following are post-installation known issues for this build version.

### Portal  

- The Azure Stack technical documentation focuses on the latest release. Due to portal changes between releases, what you see when using the Azure Stack portals might vary from what you see in the documentation. 

<!-- 2931230 IS  ASDK --> 
- Plans that are added to a user subscription as an add-on plan cannot be deleted, even when you remove the plan from the user subscription. The plan will remain until the subscriptions that reference the add-on plan are also deleted. 

<!-- TBD - IS ASDK --> 
- You cannot apply driver updates by using an OEM Extension package with this version of Azure Stack.  There is no workaround for this problem.

<!-- 2551834 - IS, ASDK --> 
- When you select **Overview** for a storage account in either the admin or user portals, the information from the *Essentials* pane does not display.  The Essentials pane displays information about the account like its *Resource group*, *Location*, and *Subscription ID*.  Other options for Overview  are accessible, like *Services* and *Monitoring*, as well as options to *Open in Explorer* or to *Delete storage account*. 

  To view the unavailable information, use the [Get-azureRMstorageaccount](/powershell/module/azurerm.storage/get-azurermstorageaccount?preserve-view=true&view=azurermps-6.2.0) PowerShell cmdlet. 

<!-- 2551834 - IS, ASDK --> 
- When you select **Tags** for a storage account in either the admin or user portals, the information fails to load and does not display.  

  To view the unavailable information, use the [Get-AzureRmTag](/powershell/module/azurerm.tags/get-azurermtag?preserve-view=true&view=azurermps-6.2.0) PowerShell cmdlet.


<!-- 2332636 - IS -->  
- When you use AD FS for your Azure Stack identity system and update to this version of Azure Stack, the default owner of the default provider subscription is reset to the built-in **CloudAdmin** user.  
  Workaround:  To resolve this issue after you install this update, use step 3 from the [Trigger automation to configure claims provider trust in Azure Stack](../azure-stack-integrate-identity.md) procedure to reset the owner of the default provider subscription.   

<!-- TBD - IS ASDK --> 
- Some administrative subscription types are not available. When you upgrade Azure Stack to this version, the two subscription types that were introduced with version 1804 are not visible in the console. This is expected. The unavailable subscription types are *Metering subscription*, and *Consumption subscription*. These subscription types are visible in new Azure Stack environments beginning with version 1804 but are not yet ready for use. You should continue to use the *Default Provider* subscription type.  

<!-- 2403291 - IS ASDK --> 
- You might not have use of the horizontal scroll bar along the bottom of the admin and user portals. If you can't access the horizontal scroll bar, use the breadcrumbs to navigate to a previous blade in the portal by selecting the name of the blade you want to view from the breadcrumb list found at the top left of the portal.

<!-- TBD - IS --> 
- It might not be possible to view compute or storage resources in the administrator portal. The cause of this issue is an error during the installation of the update that causes the update to be incorrectly reported as successful. If this issue occurs, contact Microsoft Customer Support Services for assistance.

<!-- TBD - IS --> 
- You might see a blank dashboard in the portal. To recover the dashboard, select the gear icon in the upper right corner of the portal, and then select **Restore default settings**.

<!-- TBD - IS ASDK --> 
- Deleting user subscriptions results in orphaned resources. As a workaround, first delete user resources or the entire resource group, and then delete user subscriptions.

<!-- TBD - IS ASDK --> 
- You cannot view permissions to your subscription using the Azure Stack portals. As a workaround, use PowerShell to verify permissions.


### Health and monitoring
<!-- 1264761 - IS ASDK -->  
- You might see alerts for the *Health controller* component that have the following details:  
 
   Alert #1:
   - NAME:  Infrastructure role unhealthy
   - SEVERITY: Warning
   - COMPONENT: Health controller
   - DESCRIPTION: The health controller Heartbeat Scanner is unavailable. This may affect health reports and metrics.  

  Alert #2:
   - NAME:  Infrastructure role unhealthy
   - SEVERITY: Warning
   - COMPONENT: Health controller
   - DESCRIPTION: The health controller Fault Scanner is unavailable. This may affect health reports and metrics.

  Both alerts #1 and #2 can be safely ignored and they'll close automatically over time. 

  You might also see the following alert for *Capacity*. For this alert, the percentage of available memory identified in the description can vary:  

  Alert #3:
   - NAME:  Low memory capacity
   - SEVERITY: Critical
   - COMPONENT: Capacity
   - DESCRIPTION: The region has consumed more than 80.00% of available memory. Creating virtual machines with large amounts of memory may fail.  

  In this version of Azure Stack, this alert can fire incorrectly. If tenant virtual machines continue to deploy successfully, you can safely ignore this alert. 
  
  Alert #3 does not automatically close. If you close this alert Azure Stack will create the same alert within 15 minutes.  

<!-- 2368581 - IS. ASDK --> 
- As an Azure Stack operator, if you receive a low memory alert and tenant virtual machines fail to deploy with a *Fabric VM creation error*, it is possible that the Azure Stack stamp is out of available memory. Use the [Azure Stack Capacity Planner](https://gallery.technet.microsoft.com/Azure-Stack-Capacity-24ccd822) to best understand the capacity available for your workloads. 


### Compute
<!-- TBD - IS, ASDK --> 
- When selecting a virtual machine size for a virtual machine deployment, some F-Series VM sizes are not visible as part of the size selector when you create a VM. The following VM sizes do not appear in the selector: *F8s_v2*, *F16s_v2*, *F32s_v2*, and *F64s_v2*.  
  As a workaround, use one of the following methods to deploy a VM. In each method, you need to specify the VM size you want to use.

  - **Azure Resource Manager template:** When you use a template, set the *vmSize* in the template to equal the VM size you want to use. For example, the following entry is used to deploy a VM that uses the *F32s_v2* size:  

    ```
        "properties": {
        "hardwareProfile": {
                "vmSize": "Standard_F32s_v2"
        },
    ```  
  - **Azure CLI:** You can use the [az vm create](/cli/azure/vm?preserve-view=true&view=azure-cli-latest#az-vm-create) command and specify the VM size as a parameter, similar to `--size "Standard_F32s_v2"`.

  - **PowerShell:** With PowerShell you can use [New-AzureRMVMConfig](/powershell/module/azurerm.compute/new-azurermvmconfig?preserve-view=true&view=azurermps-6.0.0) with the parameter that specifies the VM size, similar to `-VMSize "Standard_F32s_v2"`.


<!-- TBD - IS ASDK --> 
- Scaling settings for virtual machine scale sets are not available in the portal. As a workaround, you can use [Azure PowerShell](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-manage-powershell#change-the-capacity-of-a-scale-set). Because of PowerShell version differences, you must use the `-Name` parameter instead of `-VMScaleSetName`.

<!-- TBD - IS --> 
- When you create an availability set in the portal by going to **New** > **Compute** > **Availability set**, you can only create an availability set with a fault domain and update domain of 1. As a workaround, when creating a new virtual machine, create the availability set by using PowerShell, CLI, or from within the portal.

<!-- TBD - IS ASDK --> 
- When you create virtual machines on the Azure Stack user portal, the portal displays an incorrect number of data disks that can attach to a DS series VM. DS series VMs can accommodate as many data disks as the Azure configuration.

<!-- TBD - IS ASDK --> 
- When a VM image fails to be created, a failed item that you cannot delete might be added to the VM images compute blade.

  As a workaround, create a new VM image with a dummy VHD that can be created through Hyper-V (New-VHD -Path C:\dummy.vhd -Fixed -SizeBytes 1 GB). This process should fix the problem that prevents deleting the failed item. Then, 15 minutes after creating the dummy image, you can successfully delete it.

  You can then try to redownload the VM image that previously failed.

<!-- TBD - IS ASDK --> 
- If provisioning an extension on a VM deployment takes too long, users should let the provisioning time-out instead of trying to stop the process to deallocate or delete the VM.  

<!-- 1662991 IS ASDK --> 
- Linux VM diagnostics is not supported in Azure Stack. When you deploy a Linux VM with VM diagnostics enabled, the deployment fails. The deployment also fails if you enable the Linux VM basic metrics through diagnostic settings.  


### Networking
<!-- TBD - IS ASDK --> 
- You cannot create user-defined routes in either the admin or user portal. As a workaround, use [Azure PowerShell](/azure/virtual-network/tutorial-create-route-table-powershell).

<!-- 1766332 - IS ASDK --> 
- Under **Networking**, if you click **Create VPN Gateway** to set up a VPN connection, **Policy Based** is listed as a VPN type. Do not select this option. Only the **Route Based** option is supported in Azure Stack.

<!-- 2388980 - IS ASDK --> 
- After a VM is created and associated with a public IP address, you can't disassociate that VM from that IP address. Disassociation appears to work, but the previously assigned public IP address remains associated with the original VM.

  Currently, you must use only new public IP addresses for new VMs you create.

  This behavior occurs even if you reassign the IP address to a new VM (commonly referred to as a *VIP swap*). All future attempts to connect through this IP address result in a connection to the original VM, and not to the new one.

<!-- 2292271 - IS ASDK --> 
- If you raise a Quota limit for a Network resource that is part of an Offer and Plan that is associated with a tenant subscription, the new limit is not applied to that subscription. However, the new limit does apply to new subscriptions that are created after the quota is increased.

  To work around this problem, use an Add-On plan to increase a Network Quota when the plan is already associated with a subscription. For more information, see how to [make an add-on plan available](../azure-stack-subscribe-plan-provision-vm.md#to-make-an-add-on-plan-available).

<!-- 2304134 IS ASDK --> 
- You cannot delete a subscription that has DNS Zone resources or Route Table resources associated with it. To successfully delete the subscription, you must first delete DNS Zone and Route Table resources from the tenant subscription.


<!-- 1902460 - IS ASDK --> 
- Azure Stack supports a single *local network gateway* per IP address. This is true across all tenant subscriptions. After the creation of the first local network gateway connection, subsequent attempts to create a local network gateway resource with the same IP address are blocked.

<!-- 16309153 - IS ASDK --> 
- On a Virtual Network that was created with a DNS Server setting of *Automatic*, changing to a custom DNS Server fails. The updated settings are not pushed to VMs in that Vnet.

<!-- TBD - IS ASDK --> 
- Azure Stack does not support adding additional network interfaces to a VM instance after the VM is deployed. If the VM requires more than one network interface, they must be defined at deployment time.

<!-- 2096388 IS --> 
- You cannot use the admin portal to update rules for a network security group.

    Workaround for App Service: If you need to remote desktop to the Controller instances, you modify the security rules within the network security groups with PowerShell.  Following are examples of how to *allow*, and then restore the configuration to *deny*:  

    - *Allow:*

      ```powershell    
      Connect-AzureRmAccount -EnvironmentName AzureStackAdmin

      $nsg = Get-AzureRmNetworkSecurityGroup -Name "ControllersNsg" -ResourceGroupName "AppService.local"

      $RuleConfig_Inbound_Rdp_3389 =  $nsg | Get-AzureRmNetworkSecurityRuleConfig -Name "Inbound_Rdp_3389"

      ##This doesn't work. Need to set properties again even in case of edit

      #Set-AzureRmNetworkSecurityRuleConfig -Name "Inbound_Rdp_3389" -NetworkSecurityGroup $nsg -Access Allow  

      Set-AzureRmNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg `
        -Name $RuleConfig_Inbound_Rdp_3389.Name `
        -Description "Inbound_Rdp_3389" `
        -Access Allow `
        -Protocol $RuleConfig_Inbound_Rdp_3389.Protocol `
        -Direction $RuleConfig_Inbound_Rdp_3389.Direction `
        -Priority $RuleConfig_Inbound_Rdp_3389.Priority `
        -SourceAddressPrefix $RuleConfig_Inbound_Rdp_3389.SourceAddressPrefix `
        -SourcePortRange $RuleConfig_Inbound_Rdp_3389.SourcePortRange `
        -DestinationAddressPrefix $RuleConfig_Inbound_Rdp_3389.DestinationAddressPrefix `
        -DestinationPortRange $RuleConfig_Inbound_Rdp_3389.DestinationPortRange

      # Commit the changes back to NSG
      Set-AzureRmNetworkSecurityGroup -NetworkSecurityGroup $nsg
      ```

    - *Deny:*

        ```powershell

        Connect-AzureRmAccount -EnvironmentName AzureStackAdmin

        $nsg = Get-AzureRmNetworkSecurityGroup -Name "ControllersNsg" -ResourceGroupName "AppService.local"

        $RuleConfig_Inbound_Rdp_3389 =  $nsg | Get-AzureRmNetworkSecurityRuleConfig -Name "Inbound_Rdp_3389"

        ##This doesn't work. Need to set properties again even in case of edit

        #Set-AzureRmNetworkSecurityRuleConfig -Name "Inbound_Rdp_3389" -NetworkSecurityGroup $nsg -Access Allow  

        Set-AzureRmNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg `
          -Name $RuleConfig_Inbound_Rdp_3389.Name `
          -Description "Inbound_Rdp_3389" `
          -Access Deny `
          -Protocol $RuleConfig_Inbound_Rdp_3389.Protocol `
          -Direction $RuleConfig_Inbound_Rdp_3389.Direction `
          -Priority $RuleConfig_Inbound_Rdp_3389.Priority `
          -SourceAddressPrefix $RuleConfig_Inbound_Rdp_3389.SourceAddressPrefix `
          -SourcePortRange $RuleConfig_Inbound_Rdp_3389.SourcePortRange `
          -DestinationAddressPrefix $RuleConfig_Inbound_Rdp_3389.DestinationAddressPrefix `
          -DestinationPortRange $RuleConfig_Inbound_Rdp_3389.DestinationPortRange

        # Commit the changes back to NSG
        Set-AzureRmNetworkSecurityGroup -NetworkSecurityGroup $nsg
        ```


### SQL and MySQL

<!-- TBD - IS --> 
- Only the resource provider is supported to create items on servers that host SQL or MySQL. Items created on a host server that are not created by the resource provider might result in a mismatched state.  

<!-- IS, ASDK --> 
- Special characters, including spaces and periods, are not supported in the **Family** or **Tier** names when you create a SKU for the SQL and MySQL resource providers.

<!-- TBD - IS --> 
> [!NOTE]  
> After you update to Azure Stack 1805, you can continue to use the SQL and MySQL resource providers that you previously deployed.  We recommend you update SQL and MySQL when a new release becomes available. Like Azure Stack, apply updates to SQL and MySQL resource providers sequentially. For example, if you use version 1803, first apply version 1804, and then update to 1805.      
>   
> The install of update 1805 does not affect the current use of SQL or MySQL resource providers by your users.
> Regardless of the version of the resource providers you use, your users data in their databases is not touched, and remains accessible.    



### App Service
<!-- 2352906 - IS ASDK --> 
- Users must register the storage resource provider before they create their first Azure Function in the subscription.

<!-- 2489178 - IS ASDK --> 
- In order to scale out infrastructure (workers, management, front-end roles), you must use PowerShell as described in the release notes for Compute.

<!-- TBD - IS ASDK --> 
- App Service can only be deployed into the *Default Provider subscription* at this time. 


### Usage  
<!-- TBD - IS ASDK --> 
- Usage Public IP address usage meter data shows the same *EventDateTime* value for each record instead of the *TimeDate* stamp that shows when the record was created. Currently, you can't use this data to perform accurate accounting of public IP address usage.


<!-- #### Identity -->
<!-- #### Marketplace -->


## Download the update
You can download the Azure Stack 1805 update package from [here](https://aka.ms/azurestackupdatedownload).


## See also
- To use the Privileged End Point (PEP) to monitor and resume updates, see [Monitor updates in Azure Stack using the privileged endpoint](../azure-stack-monitor-update.md).
- For an overview of the update management in Azure Stack, see [Manage updates in Azure Stack overview](../azure-stack-updates.md).
- For more information about how to apply updates with Azure Stack, see [Apply updates in Azure Stack](../azure-stack-apply-updates.md).
::: moniker-end

::: moniker range="azs-1804"
## 1804 archived release notes
*Applies to: Azure Stack integrated systems*

This article describes the improvements and fixes in the 1804 update package, known issues for this release, and where to download the update. Known issues are divided into issues directly related to the update process and issues with the build (post-installation).

> [!IMPORTANT]        
> This update package is only for Azure Stack integrated systems. Do not apply this update package to the Azure Stack Development Kit.

## Build reference    
The Azure Stack 1804 update build number is **20180513.1**.   

### New features
This update includes the following improvements for Azure Stack.

<!-- 15028744 - IS -->  
- **Visual Studio support for disconnected Azure Stack deployments using AD FS**. Within Visual Studio you now can add subscriptions and authenticate using AD FS federated User credentials. 
 
<!-- 1779474, 1779458 - IS --> 
- **Use Av2 and F series virtual machines**. Azure Stack can now use virtual machines based on the Av2-series and F-series virtual machine sizes. For more information see [Virtual machine sizes supported in Azure Stack](../../user/azure-stack-vm-sizes.md). 

<!-- 1759172 - IS, ASDK --> 
- **New administrative subscriptions**. With 1804 there are two new subscription types available in the portal. These new subscription types are in addition to the Default Provider subscription and visible with new Azure Stack installations beginning with version 1804. *Do not use these new subscription types with this version of Azure Stack*. We will announce the availability to use these subscription types in with a future update. 

  If you update Azure Stack to version 1804, the two new subscription types are not visible. However, new deployments of Azure Stack integrated systems and installations of the Azure Stack Development Kit version 1804 or later have access to all three subscription types.  

  These new subscription types are part of a larger change to secure the Default Provider subscription, and to make it easier to deploy shared resources like SQL Hosting servers. As we add more parts of this larger change with future updates to Azure Stack, resources deployed under these new subscription types might be lost. 

  The three subscription types now visible are:  
  - Default Provider subscription:  Continue to use this subscription type. 
  - Metering subscription: *Do not use this subscription type.*
  - Consumption subscription: *Do not use this subscription type*

  



## Fixed issues

<!-- IS, ASDK -->  
- In the admin portal, you no longer have to refresh the Update tile before it displays information.
 
<!-- 2050709  -->  
- You can now use the admin portal to edit storage metrics for Blob service, Table service, and Queue service.
 
<!-- IS, ASDK --> 
- Under **Networking**, when you click **Connection** to set up a VPN connection, **Site-to-site (IPsec)** is now the only available option.

- **Various fixes** for performance, stability, security, and the operating system that is used by Azure Stack.

## Additional releases timed with this update  
The following are now available, but don't require Azure Stack update 1804.
- **Update to the Microsoft Azure Stack System Center Operations Manager Monitoring Pack**. A new version (1.0.3.0) of the Microsoft System Center Operations Manager Monitoring Pack for Azure Stack is available for [download](https://www.microsoft.com/download/details.aspx?id=55184). With this version, you can use Service Principals when you add a connected Azure Stack deployment. This version also features an Update Management experience that allows you to take remediation action directly from within Operations Manager. There are also new dashboards that display resource providers, scale units, and scale unit nodes.

- **New Azure Stack Admin PowerShell Version 1.3.0**.  Azure Stack PowerShell 1.3.0 is now available for installation. This version provides commands for all Admin resource providers to manage Azure Stack.  With this release, some content will be deprecated from the Azure Stack Tools GitHub [repository](https://github.com/Azure/AzureStack-Tools). 

   For installation details, follow the [instructions](../azure-stack-powershell-install.md) or the [help](/azure-stack/operator?preserve-view=true&view=azurestackps-1.3.0) content for Azure Stack Module 1.3.0. 

- **Initial release of Azure Stack API Rest Reference**. The [API reference for all Azure Stack Admin resource providers](/rest/api/azure-stack/) is now published. 


## Before you begin    

### Prerequisites
- Install the Azure Stack 1803 update before you apply the Azure Stack 1804 update.  
  
- Install the latest available update or hotfix for version 1803. 


### Known issues with the update process   
- During installation of the 1804 update, you might see alerts with the title *Error : Template for FaultType UserAccounts.New is missing.*  You can safely ignore these alerts. These alerts will close automatically after the update to 1804 completes.   
 
<!-- TBD - IS --> 
- Do not attempt to create virtual machines during the installation of this update. For more information about managing updates, see [Manage updates in Azure Stack overview](../azure-stack-updates.md).


### Post-update steps
After the installation of 1804, install any applicable Hotfixes. For more information view the following knowledge base articles, as well as our [Servicing Policy](../azure-stack-servicing-policy.md).  
 - [KB 4344114 - Azure Stack Hotfix 1.0.180527.15](https://support.microsoft.com/help/4344114).




### Known issues (post-installation)
The following are post-installation known issues for build  **20180513.1**.

#### Portal

- The Azure Stack technical documentation focuses on the latest release. Due to portal changes between releases, what you see when using the Azure Stack portals might vary from what you see in the documentation. 

<!-- TBD - IS ASDK --> 
- You cannot apply driver updates by using an OEM Extension package with this version of Azure Stack.  There is no workaround for this problem.

<!-- 1272111 - IS --> 
- After you install or update to this version of Azure Stack, you might not be able to view Azure Stack scale units in the Admin portal.  
  Workaround: Use PowerShell to view information about Scale Units. For more information, see the [help](/azure-stack/operator?preserve-view=true&view=azurestackps-1.3.0) content for Azure Stack Module 1.3.0. 

<!-- 2332636 - IS -->  
- When you use AD FS for your Azure Stack identity system and update to this version of Azure Stack, the default owner of the default provider subscription is reset to the built-in **CloudAdmin** user.  
  Workaround:  To resolve this issue after you install this update, use step 3 from the [Trigger automation to configure claims provider trust in Azure Stack](../azure-stack-integrate-identity.md) procedure to reset the owner of the default provider subscription.   

<!-- TBD - IS ASDK --> 
- Some administrative subscription types are not available.  When you upgrade Azure Stack to this version, the two subscription types that were [introduced with version 1804](#new-features) are not visible in the console. This is expected. The unavailable subscription types are *Metering subscription*, and *Consumption subscription*. These subscription types are visible in new Azure Stack environments beginning with version 1804 but are not yet ready for use. You should continue to use the *Default Provider* subscription type.  


<!-- TBD -  IS ASDK -->
- The ability [to open a new support request from the dropdown](../azure-stack-manage-portals.md#quick-access-to-help-and-support) from within the administrator portal isn't available. Instead, use the following link:     
    - For Azure Stack integrated systems, use https://aka.ms/newsupportrequest.

<!-- 2403291 - IS ASDK --> 
- You might not have use of the horizontal scroll bar along the bottom of the admin and user portals. If you can't access the horizontal scroll bar, use the breadcrumbs to navigate to a previous blade in the portal by selecting the name of the blade you want to view from the breadcrumb list found at the top left of the portal.

<!-- TBD - IS --> 
- It might not be possible to view compute or storage resources in the administrator portal. The cause of this issue is an error during the installation of the update that causes the update to be incorrectly reported as successful. If this issue occurs, contact Microsoft Customer Support Services for assistance.

<!-- TBD - IS --> 
- You might see a blank dashboard in the portal. To recover the dashboard, select the gear icon in the upper right corner of the portal, and then select **Restore default settings**.

<!-- TBD - IS ASDK --> 
- Deleting user subscriptions results in orphaned resources. As a workaround, first delete user resources or the entire resource group, and then delete user subscriptions.

<!-- TBD - IS ASDK --> 
- You cannot view permissions to your subscription using the Azure Stack portals. As a workaround, use PowerShell to verify permissions.

<!-- TBD - IS ASDK --> 
- In the admin portal, you might see a critical alert for the *Microsoft.Update.Admin* component. The Alert name, description, and remediation all display as:  
    - *ERROR - Template for FaultType ResourceProviderTimeout is missing.*

  This alert can be safely ignored. 


#### Health and monitoring
<!-- 1264761 - IS ASDK -->  
- You might see alerts for the *Health controller* component that have the following details:  

   Alert #1:
   - NAME:  Infrastructure role unhealthy
   - SEVERITY: Warning
   - COMPONENT: Health controller
   - DESCRIPTION: The health controller Heartbeat Scanner is unavailable. This may affect health reports and metrics.  

  Alert #2:
   - NAME:  Infrastructure role unhealthy
   - SEVERITY: Warning
   - COMPONENT: Health controller
   - DESCRIPTION: The health controller Fault Scanner is unavailable. This may affect health reports and metrics.

  Both alerts can be safely ignored. They will close automatically over time.  
 

#### Compute
<!-- TBD - IS --> 
- When selecting a virtual machine size for a virtual machine deployment, some F-Series VM sizes are not visible as part of the size selector when you create a VM. The following VM sizes do not appear in the selector: *F8s_v2*, *F16s_v2*, *F32s_v2*, and *F64s_v2*.  
  As a workaround, use one of the following methods to deploy a VM. In each method, you need to specify the VM size you want to use.

  - **Azure Resource Manager template:** When you use a template, set the *vmSize* in the template to equal the desired VM size. For example, the following is used to deploy a VM that uses the *F32s_v2* size:  

    ```
        "properties": {
        "hardwareProfile": {
                "vmSize": "Standard_F32s_v2"
        },
    ```  
  - **Azure CLI:** You can use the [az vm create](/cli/azure/vm?preserve-view=true&view=azure-cli-latest#az-vm-create) command and specify the VM size as a parameter, similar to `--size "Standard_F32s_v2"`.

  - **PowerShell:** With PowerShell you can use [New-AzureRMVMConfig](/powershell/module/azurerm.compute/new-azurermvmconfig?preserve-view=true&view=azurermps-6.0.0) with the parameter that specifies the VM size, similar to `-VMSize "Standard_F32s_v2"`.


<!-- TBD - IS ASDK --> 
- Scaling settings for virtual machine scale sets are not available in the portal. As a workaround, you can use [Azure PowerShell](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-manage-powershell#change-the-capacity-of-a-scale-set). Because of PowerShell version differences, you must use the `-Name` parameter instead of `-VMScaleSetName`.

<!-- TBD - IS --> 
- When you create an availability set in the portal by going to **New** > **Compute** > **Availability set**, you can only create an availability set with a fault domain and update domain of 1. As a workaround, when creating a new virtual machine, create the availability set by using PowerShell, CLI, or from within the portal.

<!-- TBD - IS ASDK --> 
- When you create virtual machines on the Azure Stack user portal, the portal displays an incorrect number of data disks that can attach to a D series VM. All supported D series VMs can accommodate as many data disks as the Azure configuration.

<!-- TBD - IS ASDK --> 
- When a VM image fails to be created, a failed item that you cannot delete might be added to the VM images compute blade.

  As a workaround, create a new VM image with a dummy VHD that can be created through Hyper-V (New-VHD -Path C:\dummy.vhd -Fixed -SizeBytes 1 GB). This process should fix the problem that prevents deleting the failed item. Then, 15 minutes after creating the dummy image, you can successfully delete it.

  You can then try to redownload the VM image that previously failed.

<!-- TBD - IS ASDK --> 
- If provisioning an extension on a VM deployment takes too long, users should let the provisioning time-out instead of trying to stop the process to deallocate or delete the VM.  

<!-- 1662991 IS ASDK --> 
- Linux VM diagnostics is not supported in Azure Stack. When you deploy a Linux VM with VM diagnostics enabled, the deployment fails. The deployment also fails if you enable the Linux VM basic metrics through diagnostic settings.  


#### Networking
<!-- 1766332 - IS ASDK --> 
- Under **Networking**, if you click **Create VPN Gateway** to set up a VPN connection, **Policy Based** is listed as a VPN type. Do not select this option. Only the **Route Based** option is supported in Azure Stack.

<!-- 2388980 - IS ASDK --> 
- After a VM is created and associated with a public IP address, you can't disassociate that VM from that IP address. Disassociation appears to work, but the previously assigned public IP address remains associated with the original VM.

  Currently, you must use only new public IP addresses for new VMs you create.

  This behavior occurs even if you reassign the IP address to a new VM (commonly referred to as a *VIP swap*). All future attempts to connect through this IP address result in a connection to the originally associated VM, and not to the new one.

<!-- 2292271 - IS ASDK --> 
- If you raise a Quota limit for a Network resource that is part of an Offer and Plan that is associated with a tenant subscription, the new limit is not applied to that subscription. However, the new limit does apply to new subscriptions that are created after the quota is increased. 

  To work around this problem, use an Add-On plan to increase a Network Quota when the plan is already associated with a subscription. For more information, see how to [make an add-on plan available](../azure-stack-subscribe-plan-provision-vm.md#to-make-an-add-on-plan-available).

<!-- 2304134 IS ASDK --> 
- You cannot delete a subscription that has DNS Zone resources or Route Table resources associated with it. To successfully delete the subscription, you must first delete DNS Zone and Route Table resources from the tenant subscription. 
  

<!-- 1902460 - IS ASDK --> 
- Azure Stack supports a single *local network gateway* per IP address. This is true across all tenant subscriptions. After the creation of the first local network gateway connection, subsequent attempts to create a local network gateway resource with the same IP address are blocked.

<!-- 16309153 - IS ASDK --> 
- On a Virtual Network that was created with a DNS Server setting of *Automatic*, changing to a custom DNS Server fails. The updated settings are not pushed to VMs in that Vnet.

<!-- TBD - IS ASDK --> 
- Azure Stack does not support adding additional network interfaces to a VM instance after the VM is deployed. If the VM requires more than one network interface, they must be defined at deployment time.

<!-- 2096388 IS --> 
- You cannot use the admin portal to update rules for a network security group. 

    Workaround for App Service: If you need to remote desktop to the Controller instances, you modify the security rules within the network security groups with PowerShell.  Following are examples of how to *allow*, and then restore the configuration to *deny*:  
    
    - *Allow:*
 
      ```powershell    
      Connect-AzureRmAccount -EnvironmentName AzureStackAdmin
      
      $nsg = Get-AzureRmNetworkSecurityGroup -Name "ControllersNsg" -ResourceGroupName "AppService.local"
      
      $RuleConfig_Inbound_Rdp_3389 =  $nsg | Get-AzureRmNetworkSecurityRuleConfig -Name "Inbound_Rdp_3389"
      
      ##This doesn't work. Need to set properties again even in case of edit
      
      #Set-AzureRmNetworkSecurityRuleConfig -Name "Inbound_Rdp_3389" -NetworkSecurityGroup $nsg -Access Allow  
      
      Set-AzureRmNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg `
        -Name $RuleConfig_Inbound_Rdp_3389.Name `
        -Description "Inbound_Rdp_3389" `
        -Access Allow `
        -Protocol $RuleConfig_Inbound_Rdp_3389.Protocol `
        -Direction $RuleConfig_Inbound_Rdp_3389.Direction `
        -Priority $RuleConfig_Inbound_Rdp_3389.Priority `
        -SourceAddressPrefix $RuleConfig_Inbound_Rdp_3389.SourceAddressPrefix `
        -SourcePortRange $RuleConfig_Inbound_Rdp_3389.SourcePortRange `
        -DestinationAddressPrefix $RuleConfig_Inbound_Rdp_3389.DestinationAddressPrefix `
        -DestinationPortRange $RuleConfig_Inbound_Rdp_3389.DestinationPortRange
      
      # Commit the changes back to NSG
      Set-AzureRmNetworkSecurityGroup -NetworkSecurityGroup $nsg
      ```

    - *Deny:*

        ```powershell
        
        Connect-AzureRmAccount -EnvironmentName AzureStackAdmin
        
        $nsg = Get-AzureRmNetworkSecurityGroup -Name "ControllersNsg" -ResourceGroupName "AppService.local"
        
        $RuleConfig_Inbound_Rdp_3389 =  $nsg | Get-AzureRmNetworkSecurityRuleConfig -Name "Inbound_Rdp_3389"
        
        ##This doesn't work. Need to set properties again even in case of edit
    
        #Set-AzureRmNetworkSecurityRuleConfig -Name "Inbound_Rdp_3389" -NetworkSecurityGroup $nsg -Access Allow  
    
        Set-AzureRmNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg `
          -Name $RuleConfig_Inbound_Rdp_3389.Name `
          -Description "Inbound_Rdp_3389" `
          -Access Deny `
          -Protocol $RuleConfig_Inbound_Rdp_3389.Protocol `
          -Direction $RuleConfig_Inbound_Rdp_3389.Direction `
          -Priority $RuleConfig_Inbound_Rdp_3389.Priority `
          -SourceAddressPrefix $RuleConfig_Inbound_Rdp_3389.SourceAddressPrefix `
          -SourcePortRange $RuleConfig_Inbound_Rdp_3389.SourcePortRange `
          -DestinationAddressPrefix $RuleConfig_Inbound_Rdp_3389.DestinationAddressPrefix `
          -DestinationPortRange $RuleConfig_Inbound_Rdp_3389.DestinationPortRange
          
        # Commit the changes back to NSG
        Set-AzureRmNetworkSecurityGroup -NetworkSecurityGroup $nsg 
        ```

#### SQL and MySQL

<!-- TBD - IS --> 
- Only the resource provider is supported to create items on servers that host SQL or MySQL. Items created on a host server that are not created by the resource provider might result in a mismatched state.  

<!-- IS, ASDK --> 
- Special characters, including spaces and periods, are not supported in the **Family** or **Tier** names when you create a SKU for the SQL and MySQL resource providers.

<!-- TBD - IS -->
> [!NOTE]  
> After you update to Azure Stack 1804, you can continue to use the SQL and MySQL resource providers that you previously deployed.  We recommend you update SQL and MySQL when a new release becomes available. Like Azure Stack, apply updates to SQL and MySQL resource providers sequentially.  For example, if you use version 1802, first apply version 1803, and then update to 1804.      
>   
> The install of update 1804 does not affect the current use of SQL or MySQL resource providers by your users.
> Regardless of the version of the resource providers you use, your users data in their databases is not touched, and remains accessible.    



#### App Service
<!-- 2352906 - IS ASDK --> 
- Users must register the storage resource provider before they create their first Azure Function in the subscription.

<!-- TBD - IS ASDK --> 
- In order to scale out infrastructure (workers, management, front-end roles), you must use PowerShell as described in the release notes for Compute.

<!-- TBD - IS ASDK --> 
- App Service can only be deployed into the **Default Provider Subscription** at this time.  In a future update App Service will deploy into the new Metering Subscription introduced in Azure Stack 1804 and all existing deployments will be migrated to this new subscription also.

#### Usage  
<!-- TBD - IS ASDK --> 
- Usage Public IP address usage meter data shows the same *EventDateTime* value for each record instead of the *TimeDate* stamp that shows when the record was created. Currently, you can't use this data to perform accurate accounting of public IP address usage.


<!-- #### Identity -->
<!-- #### Marketplace --> 


## Download the update
You can download the Azure Stack 1804 update package from [here](https://aka.ms/azurestackupdatedownload).


## See also
- To use the Privileged End Point (PEP) to monitor and resume updates, see [Monitor updates in Azure Stack using the privileged endpoint](../azure-stack-monitor-update.md).
- For an overview of the update management in Azure Stack, see [Manage updates in Azure Stack overview](../azure-stack-updates.md).
- For more information about how to apply updates with Azure Stack, see [Apply updates in Azure Stack](../azure-stack-apply-updates.md).
::: moniker-end

::: moniker range="azs-1803"
## 1803 archived release notes
*Applies to: Azure Stack integrated systems*

This article describes the improvements and fixes in the 1803 update package, known issues for this release, and where to download the update. Known issues are divided into issues directly related to the update process and issues with the build (post-installation).

> [!IMPORTANT]        
> This update package is only for Azure Stack integrated systems. Do not apply this update package to the Azure Stack Development Kit.

## Build reference    
The Azure Stack 1803 update build number is **20180329.1**.


## Before you begin    
> [!IMPORTANT]    
> Do not attempt to create virtual machines during the installation of this update. For more information about managing updates, see [Manage updates in Azure Stack overview](../azure-stack-updates.md).


### Prerequisites
- Install the Azure Stack 1802 update before you apply the Azure Stack 1803 update.   

- Install **AzS Hotfix 1.0.180312.1- Build 20180222.2** before you apply the Azure Stack 1803 update. This hotfix updates Windows Defender, and is available when you download updates for Azure Stack.

  To install the hotfix, follow the normal procedures for [installing updates for Azure Stack](../azure-stack-apply-updates.md). The name of the update appears as **AzS Hotfix 1.0.180312.1**, and includes the following files: 
    - PUPackageHotFix_20180222.2-1.exe
    - PUPackageHotFix_20180222.2-1.bin
    - Metadata.xml

  After uploading these files to a storage account and container, run the install from the Update tile in the admin portal. 
  
  Unlike updates to Azure Stack, installing this update does not change the version of Azure Stack. To confirm this update is installed, view the list of **Installed updates**.



### New features 
This update includes the following improvements and fixes for Azure Stack.

- **Update Azure Stack secrets** - (Accounts and Certificates). For more information about managing secrets, see [Rotate secrets in Azure Stack](../azure-stack-rotate-secrets.md). 

<!-- 1914853 --> 
- **Automatic redirect to HTTPS** when you use HTTP to access the administrator and user portals. This improvement was made based on [UserVoice](https://feedback.azure.com/forums/344565-azure-stack/suggestions/32205385-it-would-be-great-if-there-was-a-automatic-redirec) feedback for Azure Stack. 

<!-- 2202621  --> 
- **Access the Marketplace** - You can now open the Azure Stack Marketplace by using the [+New](https://ms.portal.azure.com/#create/hub) option from within the admin and user portals the same way you do in the Azure portals.
 
<!-- 2202621 --> 
- **Azure Monitor** - Azure Stack adds [Azure Monitor](/azure/monitoring-and-diagnostics/monitoring-overview-azure-monitor) to the admin and user portals. This includes new explorers for metrics and activity logs. To access this Azure Monitor from external networks, port **13012** must be open in firewall configurations. For more information about ports required by Azure Stack, see [Azure Stack datacenter integration - Publish endpoints](../azure-stack-integrate-endpoints.md).

   Also as part of this change, under **More services**, *Audit logs* now appears as *Activity logs*. The functionality is now consistent with the Azure portal. 

<!-- 1664791 --> 
- **Sparse files** -  When you add a New image to Azure Stack, or add an image through marketplace syndication, the image is converted to a sparse file. Images that were added prior to using Azure Stack version 1803 cannot be converted. Instead, you must use marketplace syndication to resubmit those images to take advantage of this feature. 
 
   Sparse files are an efficient file format used to reduce storage space use, and improve I/O. ?For more information, see [Fsutil sparse](/windows-server/administration/windows-commands/fsutil-sparse) for Windows Server. 

### Fixed issues

<!-- 1739988 --> 
- Internal Load Balancing (ILB) now properly handles MAC addresses for back-end VMs, which causes ILB to drop packets to the back-end network when using Linux instances on the back-end network. ILB works fine with Windows instances on the back-end network. 

<!-- 1805496 --> 
- An issue where VPN Connections between Azure Stack would become disconnected due to Azure Stack using different settings for the IKE policy than Azure. The values for SALifetime (Time) and SALiftetime (Bytes) were not compatible with Azure and have changed in 1803 to match the Azure settings. The value for SALifetime (Seconds) prior to 1803 was 14,400 and now changes to 27,000 in 1803. The value for SALifetime (Bytes) prior to 1803 was 819,200 and changes to 33,553,408 in 1803.

<!-- 2209262 --> 
- The IP issue where VPN Connections was previously visible in the portal; however enabling or toggling IP Forwarding has no effect. The feature is turned on by default and the ability to change this not yet supported.  The control has been removed from the portal. 

<!-- 1766332 --> 
- Azure Stack does not support Policy Based VPN Gateways, even though the option appears in the Portal.  The option has been removed from the Portal. 

<!-- 1868283 --> 
- Azure Stack now prevents resizing of a virtual machine that is created with dynamic disks. 

<!-- 1756324 --> 
- Usage data for virtual machines is now separated at hourly intervals. This is consistent with Azure. 

<!--  2253274 --> 
- The issue where in the admin and user portals, the Settings blade for vNet Subnets fails to load. As a workaround, use PowerShell and the [Get-AzureRmVirtualNetworkSubnetConfig](/powershell/module/azurerm.network/get-azurermvirtualnetworksubnetconfig?preserve-view=true&view=azurermps-5.5.0) cmdlet to view and manage this information.

- When you create a virtual machine, the message *Unable to display pricing* no longer appears when choosing a size for the VM size.

- Various fixes for performance, stability, security, and the operating system that is used by Azure Stack.


### Changes
- The way to change the state of a newly created offer from *private* to *public* or *decommissioned* has changed. For more information, see [Create an offer](../azure-stack-create-offer.md).


### Known issues with the update process    
<!-- 2328416 --> 
During installation of the 1803 update, there can be downtime of the blob service and internal services that use blob service. This includes some virtual machine operations. This down time can cause failures of tenant operations or alerts from services that can't access data. This issue resolves itself when the update completes installation. 



### Post-update steps
- After the installation of 1803, install any applicable Hotfixes. For more information view the following knowledge base articles, as well as our [Servicing Policy](../azure-stack-servicing-policy.md).

  - [KB 4344115 - Azure Stack Hotfix 1.0.180427.15](https://support.microsoft.com/help/4344115).

- After installing this update, review your firewall configuration to ensure [necessary ports](../azure-stack-integrate-endpoints.md) are open. For example, this update introduces *Azure Monitor* which includes a change of Audit logs to Activity logs. With this change, port 13012 is now used and must also be open.  


### Known issues (post-installation)
The following are post-installation known issues for build  **20180323.2**.

#### Portal
<!-- 2332636 - IS -->  
- When you use AD FS for your Azure Stack identity system and update to this version of Azure Stack, the default owner of the default provider subscription is reset to the built-in **CloudAdmin** user.  
  Workaround:  To resolve this issue after you install this update, use step 3 from the [Trigger automation to configure claims provider trust in Azure Stack](../azure-stack-integrate-identity.md) procedure to reset the owner of the default provider subscription.   

- The ability [to open a new support request from the dropdown](../azure-stack-manage-portals.md#quick-access-to-help-and-support) from within the administrator portal isn't available. Instead, use the following link:     
    - For Azure Stack integrated systems, use https://aka.ms/newsupportrequest.

<!-- 2050709 --> 
- In the admin portal, it is not possible to edit storage metrics for Blob service, Table service, or Queue service. When you go to Storage, and then select the blob, table, or queue service tile, a new blade opens that displays a metrics chart for that service. If you then select Edit from the top of the metrics chart tile, the Edit Chart blade opens but does not display options to edit metrics.

- It might not be possible to view compute or storage resources in the administrator portal. The cause of this issue is an error during the installation of the update that causes the update to be incorrectly reported as successful. If this issue occurs, contact Microsoft Customer Support Services for assistance.

- You might see a blank dashboard in the portal. To recover the dashboard, select the gear icon in the upper right corner of the portal, and then select **Restore default settings**.

- Deleting user subscriptions results in orphaned resources. As a workaround, first delete user resources or the entire resource group, and then delete user subscriptions.

- You cannot view permissions to your subscription using the Azure Stack portals. As a workaround, use PowerShell to verify permissions.

- In the dashboard of the admin portal, the Update tile fails to display information about updates. To resolve this issue, click on the tile to refresh it.

- In the admin portal, you might see a critical alert for the *Microsoft.Update.Admin* component. The Alert name, description, and remediation all display as:  
    - *ERROR - Template for FaultType ResourceProviderTimeout is missing.*

  This alert can be safely ignored. 


#### Health and monitoring
<!-- 1264761 - IS ASDK -->  
- You might see alerts for the *Health controller* component that have the following details:  

   Alert #1:
   - NAME:  Infrastructure role unhealthy
   - SEVERITY: Warning
   - COMPONENT: Health controller
   - DESCRIPTION: The health controller Heartbeat Scanner is unavailable. This may affect health reports and metrics.  

  Alert #2:
   - NAME:  Infrastructure role unhealthy
   - SEVERITY: Warning
   - COMPONENT: Health controller
   - DESCRIPTION: The health controller Fault Scanner is unavailable. This may affect health reports and metrics.

  Both alerts can be safely ignored. They will close automatically over time.  


#### Marketplace
- Users can browse the full marketplace without a subscription and can see administrative items like plans and offers. These items are non-functional to users.



#### Compute
- Scaling settings for virtual machine scale sets are not available in the portal. As a workaround, you can use [Azure PowerShell](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-manage-powershell#change-the-capacity-of-a-scale-set). Because of PowerShell version differences, you must use the `-Name` parameter instead of `-VMScaleSetName`.

- When you create an availability set in the portal by going to **New** > **Compute** > **Availability set**, you can only create an availability set with a fault domain and update domain of 1. As a workaround, when creating a new virtual machine, create the availability set by using PowerShell, CLI, or from within the portal.

- When you create virtual machines on the Azure Stack user portal, the portal displays an incorrect number of data disks that can attach to a D series VM. All supported D series VMs can accommodate as many data disks as the Azure configuration.

- When a VM image fails to be created, a failed item that you cannot delete might be added to the VM images compute blade.

  As a workaround, create a new VM image with a dummy VHD that can be created through Hyper-V (New-VHD -Path C:\dummy.vhd -Fixed -SizeBytes 1 GB). This process should fix the problem that prevents deleting the failed item. Then, 15 minutes after creating the dummy image, you can successfully delete it.

  You can then try to redownload the VM image that previously failed.

-  If provisioning an extension on a VM deployment takes too long, users should let the provisioning time-out instead of trying to stop the process to deallocate or delete the VM.  

<!-- 1662991 --> 
- Linux VM diagnostics is not supported in Azure Stack. When you deploy a Linux VM with VM diagnostics enabled, the deployment fails. The deployment also fails if you enable the Linux VM basic metrics through diagnostic settings.  


#### Networking
- After a VM is created and associated with a public IP address, you can't disassociate that VM from that IP address. Disassociation appears to work, but the previously assigned public IP address remains associated with the original VM.

  Currently, you must use only new public IP addresses for new VMs you create.

  This behavior occurs even if you reassign the IP address to a new VM (commonly referred to as a *VIP swap*). All future attempts to connect through this IP address result in a connection to the originally associated VM, and not to the new one.



- Azure Stack supports a single *local network gateway* per IP address. This is true across all tenant subscriptions. After the creation of the first local network gateway connection, subsequent attempts to create a local network gateway resource with the same IP address are blocked.

- On a Virtual Network that was created with a DNS Server setting of *Automatic*, changing to a custom DNS Server fails. The updated settings are not pushed to VMs in that Vnet.

- Azure Stack does not support adding additional network interfaces to a VM instance after the VM is deployed. If the VM requires more than one network interface, they must be defined at deployment time.

<!-- 2096388 --> 
- You cannot use the admin portal to update rules for a network security group. 

    Workaround for App Service: If you need to remote desktop to the Controller instances, you modify the security rules within the network security groups with PowerShell.  Following are examples of how to *allow*, and then restore the configuration to *deny*:  
    
    - *Allow:*
 
      ```powershell    
      Add-AzureRmAccount -EnvironmentName AzureStackAdmin
      
      $nsg = Get-AzureRmNetworkSecurityGroup -Name "ControllersNsg" -ResourceGroupName "AppService.local"
      
      $RuleConfig_Inbound_Rdp_3389 =  $nsg | Get-AzureRmNetworkSecurityRuleConfig -Name "Inbound_Rdp_3389"
      
      ##This doesn't work. Need to set properties again even in case of edit
      
      #Set-AzureRmNetworkSecurityRuleConfig -Name "Inbound_Rdp_3389" -NetworkSecurityGroup $nsg -Access Allow  
      
      Set-AzureRmNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg `
        -Name $RuleConfig_Inbound_Rdp_3389.Name `
        -Description "Inbound_Rdp_3389" `
        -Access Allow `
        -Protocol $RuleConfig_Inbound_Rdp_3389.Protocol `
        -Direction $RuleConfig_Inbound_Rdp_3389.Direction `
        -Priority $RuleConfig_Inbound_Rdp_3389.Priority `
        -SourceAddressPrefix $RuleConfig_Inbound_Rdp_3389.SourceAddressPrefix `
        -SourcePortRange $RuleConfig_Inbound_Rdp_3389.SourcePortRange `
        -DestinationAddressPrefix $RuleConfig_Inbound_Rdp_3389.DestinationAddressPrefix `
        -DestinationPortRange $RuleConfig_Inbound_Rdp_3389.DestinationPortRange
      
      # Commit the changes back to NSG
      Set-AzureRmNetworkSecurityGroup -NetworkSecurityGroup $nsg
      ```

    - *Deny:*

        ```powershell
        
        Add-AzureRmAccount -EnvironmentName AzureStackAdmin
        
        $nsg = Get-AzureRmNetworkSecurityGroup -Name "ControllersNsg" -ResourceGroupName "AppService.local"
        
        $RuleConfig_Inbound_Rdp_3389 =  $nsg | Get-AzureRmNetworkSecurityRuleConfig -Name "Inbound_Rdp_3389"
        
        ##This doesn't work. Need to set properties again even in case of edit
    
        #Set-AzureRmNetworkSecurityRuleConfig -Name "Inbound_Rdp_3389" -NetworkSecurityGroup $nsg -Access Allow  
    
        Set-AzureRmNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg `
          -Name $RuleConfig_Inbound_Rdp_3389.Name `
          -Description "Inbound_Rdp_3389" `
          -Access Deny `
          -Protocol $RuleConfig_Inbound_Rdp_3389.Protocol `
          -Direction $RuleConfig_Inbound_Rdp_3389.Direction `
          -Priority $RuleConfig_Inbound_Rdp_3389.Priority `
          -SourceAddressPrefix $RuleConfig_Inbound_Rdp_3389.SourceAddressPrefix `
          -SourcePortRange $RuleConfig_Inbound_Rdp_3389.SourcePortRange `
          -DestinationAddressPrefix $RuleConfig_Inbound_Rdp_3389.DestinationAddressPrefix `
          -DestinationPortRange $RuleConfig_Inbound_Rdp_3389.DestinationPortRange
          
        # Commit the changes back to NSG
        Set-AzureRmNetworkSecurityGroup -NetworkSecurityGroup $nsg 
        ```


#### SQL and MySQL
- Before proceeding, review the important note in [before you begin](#before-you-begin) near the start of these release notes.

- It can take up to one hour before users can create databases in a new SQL or MySQL deployment.

- Only the resource provider is supported to create items on servers that host SQL or MySQL. Items created on a host server that are not created by the resource provider might result in a mismatched state.  

<!-- IS, ASDK --> 
- Special characters, including spaces and periods, are not supported in the **Family** name when you create a SKU for the SQL and MySQL resource providers.

> [!NOTE]  
> After you update to Azure Stack 1803, you can continue to use the SQL and MySQL resource providers that you previously deployed.  We recommend you update SQL and MySQL when a new release becomes available. Like Azure Stack, apply updates to SQL and MySQL resource providers sequentially.  For example, if you use version 1711, first apply version 1712, then 1802, and then update to 1803.      
>   
> The install of update 1803 does not affect the current use of SQL or MySQL resource providers by your users.
> Regardless of the version of the resource providers you use, your users data in their databases is not touched, and remains accessible.    



#### App Service
- Users must register the storage resource provider before they create their first Azure Function in the subscription.

- In order to scale out infrastructure (workers, management, front-end roles), you must use PowerShell as described in the release notes for Compute.


#### Usage  
- Usage Public IP address usage meter data shows the same *EventDateTime* value for each record instead of the *TimeDate* stamp that shows when the record was created. Currently, you can't use this data to perform accurate accounting of public IP address usage.

<!-- #### Identity -->

#### Downloading Azure Stack Tools from GitHub
- When using the *invoke-webrequest* PowerShell cmdlet to download the Azure Stack tools from GitHub, you receive an error:     
    -  *invoke-webrequest : The request was aborted: Could not create SSL/TLS secure channel.*     

  This error occurs because of a recent GitHub support deprecation of the Tlsv1 and Tlsv1.1 cryptographic standards (the default for PowerShell). For more information, see [Weak cryptographic standards removal notice](https://githubengineering.com/crypto-removal-notice/).

  To resolve this issue, add `[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12` to the top of the script to force the PowerShell console to use TLSv1.2 when downloading from GitHub repositories.


## Download the update
You can download the Azure Stack 1803 update package from [here](https://aka.ms/azurestackupdatedownload).


## See also
- To use the Privileged End Point (PEP) to monitor and resume updates, see [Monitor updates in Azure Stack using the privileged endpoint](../azure-stack-monitor-update.md).
- For an overview of the update management in Azure Stack, see [Manage updates in Azure Stack overview](../azure-stack-updates.md).
- For more information about how to apply updates with Azure Stack, see [Apply updates in Azure Stack](../azure-stack-apply-updates.md).
::: moniker-end

::: moniker range="azs-1802"
## 1802 archived release notes
*Applies to: Azure Stack integrated systems*

This article describes the improvements and fixes in the 1802 update package, known issues for this release, and where to download the update. Known issues are divided into issues directly related to the update process and issues with the build (post-installation).

> [!IMPORTANT]        
> This update package is only for Azure Stack integrated systems. Do not apply this update package to the Azure Stack Development Kit.

## Build reference    
The Azure Stack 1802 update build number is **20180302.1**.  


## Before you begin    
> [!IMPORTANT]    
> Do not attempt to create virtual machines during the installation of this update. For more information about managing updates, see [Manage updates in Azure Stack overview](../azure-stack-updates.md).


### Prerequisites
- Install the Azure Stack 1712 update before you apply the Azure Stack 1802 update.    

- Install **AzS Hotfix 1.0.180312.1- Build 20180222.2** before you apply the Azure Stack 1802 update. This hotfix updates Windows Defender, and is available when you download updates for Azure Stack.

  To install the hotfix, follow the normal procedures for [installing updates for Azure Stack](../azure-stack-apply-updates.md). The name of the update appears as **AzS Hotfix 1.0.180312.1**, and includes the following files: 
    - PUPackageHotFix_20180222.2-1.exe
    - PUPackageHotFix_20180222.2-1.bin
    - Metadata.xml

  After uploading these files to a storage account and container, run the install from the Update tile in the admin portal. 
  
  Unlike updates to Azure Stack, installing this update does not change the version of Azure Stack.  To confirm this update is installed, view the list of **Installed updates**.
 


### Post-update steps
After the installation of 1802, install any applicable Hotfixes. For more information view the following knowledge base articles, as well as our [Servicing Policy](../azure-stack-servicing-policy.md). 
- Azure Stack hotfix **1.0.180302.4**. [KB 4131152 - Existing Virtual Machine Scale Sets may become unusable](https://support.microsoft.com/help/4131152) 

  This fix also resolves the issues detailed in  [KB 4103348 - Network Controller API service crashes when you try to install an Azure Stack update](https://support.microsoft.com/help/4103348).


### New features and fixes
This update includes the following improvements and fixes for Azure Stack.

- **Support is added for the following Azure Storage Service API versions**:
    - 2017-04-17 
    - 2016-05-31 
    - 2015-12-11 
    - 2015-07-08 
    
    For more information, see [Azure Stack Storage: Differences and considerations](../../user/azure-stack-acs-differences.md).

- **Support for larger [Block Blobs](../../user/azure-stack-acs-differences.md)**:
    - The maximum allowable block size is increased from 4 MB to 100 MB.
    - The maximum blob size is increased from 195 GB to 4.75 TB.  

- **Infrastructure backup** now appears in the Resource Providers tile, and alerts for backup are enabled. For more information about the Infrastructure Backup Service, see [Backup and data recovery for Azure Stack with the Infrastructure Backup Service](../azure-stack-backup-infrastructure-backup.md).

- **Update to the *Test-AzureStack* cmdlet** to improve diagnostics for storage. For more information on this cmdlet, see [Validation for Azure Stack](../azure-stack-diagnostic-test.md).

- **Role-Based Access Control (RBAC) improvements** - You can now use RBAC to delegate permissions to Universal User Groups when Azure Stack is deployed with AD FS. To learn more about RBAC, see [Manage RBAC](../azure-stack-manage-permissions.md).

- **Support is added for multiple fault domains**.  For more information, see High availability for Azure Stack.

- **Support for physical memory upgrades** - You can now expand the memory capacity of Azure Stack integrated system after your initial deployment. For more information, see [Manage physical memory capacity for Azure Stack](../azure-stack-manage-storage-physical-memory-capacity.md).

- **Various fixes** for performance, stability, security, and the operating system that is used by Azure Stack.

<!-- #### New features -->

<!-- #### Fixes -->

### Known issues with the update process    
*There are no known issues for the installation of update 1802.*


### Known issues (post-installation)
The following are post-installation known issues for build  **20180302.1**

#### Portal
<!-- 2332636 - IS -->  
- When you use AD FS for your Azure Stack identity system and update to this version of Azure Stack, the default owner of the default provider subscription is reset to the built-in **CloudAdmin** user.  
  Workaround:  To resolve this issue after you install this update, use step 3 from the [Trigger automation to configure claims provider trust in Azure Stack](../azure-stack-integrate-identity.md) procedure to reset the owner of the default provider subscription.   

- The ability [to open a new support request from the dropdown](../azure-stack-manage-portals.md#quick-access-to-help-and-support) from within the administrator portal isn't available. Instead, use the following link:     
    - For Azure Stack integrated systems, use https://aka.ms/newsupportrequest.

<!-- 2050709 --> 
- In the admin portal, it is not possible to edit storage metrics for Blob service, Table service, or Queue service. When you go to Storage, and then select the blob, table, or queue service tile, a new blade opens that displays a metrics chart for that service. If you then select Edit from the top of the metrics chart tile, the Edit Chart blade opens but does not display options to edit metrics.

- It might not be possible to view compute or storage resources in the administrator portal. The cause of this issue is an error during the installation of the update that causes the update to be incorrectly reported as successful. If this issue occurs, contact Microsoft Customer Support Services for assistance.

- You might see a blank dashboard in the portal. To recover the dashboard, select the gear icon in the upper right corner of the portal, and then select **Restore default settings**.

- Deleting user subscriptions results in orphaned resources. As a workaround, first delete user resources or the entire resource group, and then delete user subscriptions.

- You cannot view permissions to your subscription using the Azure Stack portals. As a workaround, use PowerShell to verify permissions.

- In the dashboard of the admin portal, the Update tile fails to display information about updates. To resolve this issue, click on the tile to refresh it.

-  In the admin portal you might see a critical alert for the Microsoft.Update.Admin component. The Alert name, description, and remediation all display as:  
    
    *ERROR - Template for FaultType ResourceProviderTimeout is missing.*

    This alert can be safely ignored. 

<!-- 2253274 --> 
- In the admin and user portals, the Settings blade for vNet Subnets fails to load. As a workaround, use PowerShell and the [Get-AzureRmVirtualNetworkSubnetConfig](/powershell/module/azurerm.network/get-azurermvirtualnetworksubnetconfig?preserve-view=true&view=azurermps-5.5.0) cmdlet to view and  manage this information.

- In both the admin portal and user portal, the Overview blade fails to load when you select the Overview blade for storage accounts that were created with an older API version (example: 2015-06-15). This includes system storage accounts like **updateadminaccount** that is used during patch and update. 

  As a workaround, use PowerShell to run the **Start-ResourceSynchronization.ps1** script to restore access to the storage account details. [The script is available from GitHub](https://github.com/Azure/AzureStack-Tools/tree/master/Support/scripts), and must run with service administrator credentials on the privileged endpoint. 

- The **Service Health** blade fails to load. When you open the Service Health blade in either the admin or user portal, Azure Stack displays an error and does not load information. This is expected behavior. Although you can select and open Service Health, this feature is not yet available but will be implemented in a future version of Azure Stack.


#### Health and monitoring
<!-- 1264761 - IS ASDK -->  
- You might see alerts for the *Health controller* component that have the following details:  

  Alert #1:
   - NAME:  Infrastructure role unhealthy
   - SEVERITY: Warning
   - COMPONENT: Health controller
   - DESCRIPTION: The health controller Heartbeat Scanner is unavailable. This may affect health reports and metrics.  

  Alert #2:
   - NAME:  Infrastructure role unhealthy
   - SEVERITY: Warning
   - COMPONENT: Health controller
   - DESCRIPTION: The health controller Fault Scanner is unavailable. This may affect health reports and metrics.

  Both alerts can be safely ignored. They will close automatically over time.  


#### Marketplace
- Users can browse the full marketplace without a subscription and can see administrative items like plans and offers. These items are non-functional to users.

#### Compute
- Scaling settings for virtual machine scale sets are not available in the portal. As a workaround, you can use [Azure PowerShell](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-manage-powershell#change-the-capacity-of-a-scale-set). Because of PowerShell version differences, you must use the `-Name` parameter instead of `-VMScaleSetName`.

<!-- 2290877  --> 
- You cannot scale up a virtual machine scale set (VMSS) that was created when using Azure Stack prior to version 1802. This is due to the change in support for using availability sets with virtual machine scale sets. This support was added with version 1802.  When you attempt to add additional instances to scale a VMSS that was created prior to this support being added, the action fails with the message *Provisioning state failed*. 

  This issue is resolved in version 1803. To resolve this issue for version 1802, install Azure Stack hotfix **1.0.180302.4**. For more information, see [KB 4131152: Existing Virtual Machine Scale Sets may become unusable](https://support.microsoft.com/help/4131152). 

- Azure Stack supports using only Fixed type VHDs. Some images offered through the marketplace on Azure Stack use dynamic VHDs but those have been removed. Resizing a virtual machine (VM) with a dynamic disk attached to it leaves the VM in a failed state.

  To mitigate this issue, delete the VM without deleting the VM's disk, a VHD blob in a storage account. Then convert the VHD from a dynamic disk to a fixed disk, and then re-create the virtual machine.

- When you create an availability set in the portal by going to **New** > **Compute** > **Availability set**, you can only create an availability set with a fault domain and update domain of 1. As a workaround, when creating a new virtual machine, create the availability set by using PowerShell, CLI, or from within the portal.

- When you create virtual machines on the Azure Stack user portal, the portal displays an incorrect number of data disks that can attach to a D series VM. All supported D series VMs can accommodate as many data disks as the Azure configuration.

- When a VM image fails to be created, a failed item that you cannot delete might be added to the VM images compute blade.

  As a workaround, create a new VM image with a dummy VHD that can be created through Hyper-V (New-VHD -Path C:\dummy.vhd -Fixed -SizeBytes 1 GB). This process should fix the problem that prevents deleting the failed item. Then, 15 minutes after creating the dummy image, you can successfully delete it.

  You can then try to redownload the VM image that previously failed.

-  If provisioning an extension on a VM deployment takes too long, users should let the provisioning time-out instead of trying to stop the process to deallocate or delete the VM.  

<!-- 1662991 --> 
- Linux VM diagnostics is not supported in Azure Stack. When you deploy a Linux VM with VM diagnostics enabled, the deployment fails. The deployment also fails if you enable the Linux VM basic metrics through diagnostic settings.  




#### Networking
- After a VM is created and associated with a public IP address, you can't disassociate that VM from that IP address. Disassociation appears to work, but the previously assigned public IP address remains associated with the original VM.

  Currently, you must use only new public IP addresses for new VMs you create.

  This behavior occurs even if you reassign the IP address to a new VM (commonly referred to as a *VIP swap*). All future attempts to connect through this IP address result in a connection to the originally associated VM, and not to the new one.

- Internal Load Balancing (ILB) improperly handles MAC addresses for back-end VMs, which causes ILB to break when using Linux instances on the Back-End network.  ILB works fine with Windows instances on the Back-End Network.

-    The IP Forwarding feature is visible in the portal, however enabling IP Forwarding has no effect. This feature is not yet supported.

- Azure Stack supports a single *local network gateway* per IP address. This is true across all tenant subscriptions. After the creation of the first local network gateway connection, subsequent attempts to create a local network gateway resource with the same IP address are blocked.

- On a Virtual Network that was created with a DNS Server setting of *Automatic*, changing to a custom DNS Server fails. The updated settings are not pushed to VMs in that Vnet.

- Azure Stack does not support adding additional network interfaces to a VM instance after the VM is deployed. If the VM requires more than one network interface, they must be defined at deployment time.

<!-- 2096388 --> 
- You cannot use the admin portal to update rules for a network security group. 

    Workaround for App Service: If you need to remote desktop to the Controller instances, you modify the security rules within the network security groups with PowerShell.  Following are examples of how to *allow*, and then restore the configuration to *deny*:  
    
    - *Allow:*
 
      ```powershell    
      Login-AzureRMAccount -EnvironmentName AzureStackAdmin
      
      $nsg = Get-AzureRmNetworkSecurityGroup -Name "ControllersNsg" -ResourceGroupName "AppService.local"
      
      $RuleConfig_Inbound_Rdp_3389 =  $nsg | Get-AzureRmNetworkSecurityRuleConfig -Name "Inbound_Rdp_3389"
      
      ##This doesn't work. Need to set properties again even in case of edit
      
      #Set-AzureRmNetworkSecurityRuleConfig -Name "Inbound_Rdp_3389" -NetworkSecurityGroup $nsg -Access Allow  
      
      Set-AzureRmNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg `
        -Name $RuleConfig_Inbound_Rdp_3389.Name `
        -Description "Inbound_Rdp_3389" `
        -Access Allow `
        -Protocol $RuleConfig_Inbound_Rdp_3389.Protocol `
        -Direction $RuleConfig_Inbound_Rdp_3389.Direction `
        -Priority $RuleConfig_Inbound_Rdp_3389.Priority `
        -SourceAddressPrefix $RuleConfig_Inbound_Rdp_3389.SourceAddressPrefix `
        -SourcePortRange $RuleConfig_Inbound_Rdp_3389.SourcePortRange `
        -DestinationAddressPrefix $RuleConfig_Inbound_Rdp_3389.DestinationAddressPrefix `
        -DestinationPortRange $RuleConfig_Inbound_Rdp_3389.DestinationPortRange
      
      # Commit the changes back to NSG
      Set-AzureRmNetworkSecurityGroup -NetworkSecurityGroup $nsg
      ```

    - *Deny:*

        ```powershell
        
        Login-AzureRMAccount -EnvironmentName AzureStackAdmin
        
        $nsg = Get-AzureRmNetworkSecurityGroup -Name "ControllersNsg" -ResourceGroupName "AppService.local"
        
        $RuleConfig_Inbound_Rdp_3389 =  $nsg | Get-AzureRmNetworkSecurityRuleConfig -Name "Inbound_Rdp_3389"
        
        ##This doesn't work. Need to set properties again even in case of edit
    
        #Set-AzureRmNetworkSecurityRuleConfig -Name "Inbound_Rdp_3389" -NetworkSecurityGroup $nsg -Access Allow  
    
        Set-AzureRmNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg `
          -Name $RuleConfig_Inbound_Rdp_3389.Name `
          -Description "Inbound_Rdp_3389" `
          -Access Deny `
          -Protocol $RuleConfig_Inbound_Rdp_3389.Protocol `
          -Direction $RuleConfig_Inbound_Rdp_3389.Direction `
          -Priority $RuleConfig_Inbound_Rdp_3389.Priority `
          -SourceAddressPrefix $RuleConfig_Inbound_Rdp_3389.SourceAddressPrefix `
          -SourcePortRange $RuleConfig_Inbound_Rdp_3389.SourcePortRange `
          -DestinationAddressPrefix $RuleConfig_Inbound_Rdp_3389.DestinationAddressPrefix `
          -DestinationPortRange $RuleConfig_Inbound_Rdp_3389.DestinationPortRange
          
        # Commit the changes back to NSG
        Set-AzureRmNetworkSecurityGroup -NetworkSecurityGroup $nsg 
        ```





#### SQL and MySQL
 - Before proceeding, review the important note in [before you begin](#before-you-begin) near the start of these release notes.
- It can take up to one hour before users can create databases in a new SQL or MySQL deployment.

- Only the resource provider is supported to create items on servers that host SQL or MySQL. Items created on a host server that are not created by the resource provider might result in a mismatched state.  

<!-- IS, ASDK --> 
- Special characters, including spaces and periods, are not supported in the **Family** name when you create a SKU for the SQL and MySQL resource providers.

> [!NOTE]  
> After you update to Azure Stack 1802, you can continue to use the SQL and MySQL resource providers that you previously deployed.  We recommend you update SQL and MySQL when a new release becomes available. Like Azure Stack, apply updates to SQL and MySQL resource providers sequentially.  For example, if you use version 1710, first apply version 1711, then 1712, and then update to 1802.      
>   
> The install of update 1802 does not affect the current use of SQL or MySQL resource providers by your users.
> Regardless of the version of the resource providers you use, your users data in their databases is not touched, and remains accessible.    


#### App Service
- Users must register the storage resource provider before they create their first Azure Function in the subscription.

- In order to scale out infrastructure (workers, management, front-end roles), you must use PowerShell as described in the release notes for Compute.

<!-- #### Identity -->

#### Downloading Azure Stack Tools from GitHub
- When using the *invoke-webrequest* PowerShell cmdlet to download the Azure Stack tools from GitHub, you receive an error:     
    -  *invoke-webrequest : The request was aborted: Could not create SSL/TLS secure channel.*     

  This error occurs because of a recent GitHub support deprecation of the Tlsv1 and Tlsv1.1 cryptographic standards (the default for PowerShell). For more information, see [Weak cryptographic standards removal notice](https://githubengineering.com/crypto-removal-notice/).

  To resolve this issue, add `[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12` to the top of the script to force the PowerShell console to use TLSv1.2 when downloading from GitHub repositories.


## Download the update
You can download the Azure Stack 1802 update package from [here](https://aka.ms/azurestackupdatedownload).


## More information
Microsoft has provided a way to monitor and resume updates using the Privileged End Point (PEP) installed with Update 1710.

- See the [Monitor updates in Azure Stack using the privileged endpoint documentation](/azure/azure-stack/azure-stack-monitor-update).

## See also

- For an overview of the update management in Azure Stack, see [Manage updates in Azure Stack overview](../azure-stack-updates.md).
- For more information about how to apply updates with Azure Stack, see [Apply updates in Azure Stack](../azure-stack-apply-updates.md).
::: moniker-end
