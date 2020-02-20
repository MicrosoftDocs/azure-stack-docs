---
title: Azure Stack Hub release notes 
description: Release notes for Azure Stack Hub integrated systems, including updates and bug fixes.
author: sethmanheim

ms.topic: article
ms.date: 02/20/2020
ms.author: sethm
ms.reviewer: prchint
ms.lastreviewed: 01/17/2020
---

# Azure Stack Hub release notes

This article describes the contents of Azure Stack Hub update packages. The update includes improvements and fixes for the latest release of Azure Stack Hub.

To access release notes for a different version, use the version selector dropdown above the table of contents on the left.

::: moniker range=">=azs-1907"
> [!IMPORTANT]  
> This update package is only for Azure Stack Hub integrated systems. Do not apply this update package to the Azure Stack Development Kit (ASDK).
::: moniker-end
::: moniker range="<azs-1907"
> [!IMPORTANT]  
> If your Azure Stack Hub instance is behind by more than two updates, it's considered out of compliance. You must [update to at least the minimum supported version to receive support](azure-stack-servicing-policy.md#keep-your-system-under-support).
::: moniker-end

## Update planning

Before applying the update, make sure to review the following information:

- [Known issues](known-issues.md)
- [Security updates](release-notes-security-updates.md)
- [Checklist of activities before and after applying the update](release-notes-checklist.md)

For help with troubleshooting updates and the update process, see [Troubleshoot patch and update issues for Azure Stack Hub](azure-stack-updates-troubleshoot.md).

<!---------------------------------------------------------->
<!------------------- SUPPORTED VERSIONS ------------------->
<!---------------------------------------------------------->
::: moniker range="azs-2002"
## 2002 build reference

The Azure Stack Hub 2002 update build number is **1.2002.x.xx**.

### Update type

The Azure Stack Hub 2002 update build type is **Full**.

The 2002 update package is larger in size compared to previous updates. The increased size results in longer download times. The update will remain in the **Preparing** state for a long time, and operators can expect this process to take longer than with previous updates. The 2002 update has had the following expected runtimes in our internal testing: 4 nodes - 42 hours, 8 nodes - 50 hours, 12 nodes - 60 hours, 16 nodes - 70 hours. Exact update runtimes typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware specifications. Runtimes lasting longer than the expected value are not uncommon and do not require action by Azure Stack Hub operators unless the update fails. This runtime approximation is specific to the 2002 update and should not be compared to other Azure Stack Hub updates.

For more information about update build types, see [Manage updates in Azure Stack Hub](azure-stack-updates.md).

<!-- ## What's in this update -->

<!-- The current theme (if any) of this release. -->

### What's new

<!-- What's new, also net new experiences and features. -->

- A new version (1.8.1) of the Azure Stack Hub admin PowerShell modules based on AzureRM is available.

### Improvements

<!-- Changes and product improvements with tangible customer-facing value. -->

- Improvements to the Azure Stack Hub readiness checker tool to validate AD Graph integration using all TCP IP ports allocated to AD Graph.
- The offline syndication tool has been updated with reliability improvements. The tool is no longer available on GitHub, and has been [moved to the PowerShell Gallery](https://www.powershellgallery.com/packages/Azs.Syndication.Admin/). For more information, see [Download Marketplace items to Azure Stack Hub](azure-stack-download-azure-marketplace-item.md).
- Improvements to [diagnostic log collection](azure-stack-diagnostic-log-collection-overview-tzl.md). The new experience streamlines and simplifies diagnostic log collection by removing the need to configure a blob storage account in advance. The storage environment is preconfigured so that you can send logs before opening a support case, and spend less time on a support call.
- Improved the time required to collect diagnostic logs for [Proactive Log Collection and the on-demand log collection](azure-stack-diagnostic-log-collection-overview-tzl.md).
- The download progress of an Azure Stack Hub update package is now visible in the update blade after an update is initiated. This only applies to connected Azure Stack Hub systems that choose to [prepare update packages via automatic download](azure-stack-update-prepare-package.md#automatic-download-and-preparation-for-update-packages).
- Reliability improvements for Network Controller Host agent.
- Improve reliability of network validation at deployment time of Azure Stack Hub.
- Introduced new micro-service called DNS Orchestrator that improves the resiliency logic for the internal DNS services during patch and update. 
- You can now create disk snapshots without interrupting the IO workload in the running VM. Backup vendor solutions (Commvault and Veritas) use the live snapshot functionality to provide backup of VMs with managed and unmanaged disks. We recommend using backup solutions to ensure consistent backups of VMs and efficient use of live snapshot functionality. Work with your backup vendor to deploy the appropriate version of their solution that uses the live snapshot functionality. For managed disk snapshots, see [Azure Stack Hub managed disks](../user/azure-stack-managed-disk-considerations.md). For unmanaged disk snapshots, see [Azure Stack Hub storage: Differences and considerations](../user/azure-stack-acs-differences.md).
- This update contains changes to the update process that significantly improve the performance of future full updates. These changes take effect with the next full update after the 2002 release. These changes will specifically target improving the performance of the phase of a full update in which the host operating systems are updated. Improving the performance of host operating system updates significantly reduces the window of time for which tenant workloads are impacted during full updates.
- Added a new request validation to fail invalid blob URIs for the boot diagnostic storage account parameter while creating VMs.
- Added auto-remediation and logging improvements for Rdagent and Host agent - two services on the host that facilitate VM CRUD operations.
- Introduced a new micro-service called DNS Orchestrator that improves the resiliency logic for the internal DNS services during patch and update. 
- You can now create disk snapshots without interrupting the IO workload in the running VM. Backup vendor solutions (Commvault and Veritas) use the live snapshot functionality to provide backup of VMs with managed and unmanaged disks. We recommend using backup solutions to ensure consistent backups of VMs and efficient use of the live snapshot functionality. Work with your backup vendor to deploy the appropriate version of their solution that uses the live snapshot functionality. For managed disk snapshots, see [Azure Stack Hub managed disks](../user/azure-stack-managed-disk-considerations.md). For unmanaged disk snapshots, see [Azure Stack Hub storage: Differences and considerations](../user/azure-stack-acs-differences.md).
- This update contains changes to the update process that significantly improve the performance of future full updates. These changes take effect with the next full update after the 2002 release, and specifically target improving the performance of the phase of a full update in which the host operating systems are updated. Improving the performance of host operating system updates significantly reduces the window of time in which tenant workloads are impacted during full updates.

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
  
### Fixes

<!-- Product fixes that came up from customer deployments worth highlighting, especially if there is an SR/ICM associated to it. -->

<!-- Fixed an issue where adding more than one public IP on the same NIC on a Virtual Machine resulted in internet connectivity issues. Now, a NIC with two public IPs should work as expected.[This fix actually didn't go in 1910 due to build issues, commenting out until next build (2002) ] -->


- Fixed an issue that caused the system to raise an alert indicating that the Azure AD home directory needs to be configured.
- Fixed an issue that prevented an alert indicating that the Azure AD home directory must be configured to not automatically close.
- Fixed an issue that caused updates to fail during the update preparation phase as a result of internal failures of the update resource provider.
- Fixed an issue causing add-on resource provider operations to fail after performing Azure Stack Hub secret rotation.
- Fixed an issue that was a common cause of Azure Stack Hub update failures due to memory pressure on the ERCS role.
- Fixed a bug in the update blade in which the update status showed as **Installing** instead of **Preparing** during the preparation phase of an Azure Stack Hub update.
- Fixed a filtering issue in Marketplace management, which incorrectly cleared all results when filters were set after the page loaded for the first time.
- Fixed an issue where a VM with multiple NICs and multiple IP configurations is not reachable via the public IP. 
- Fixed an issue where the RSC feature on the physical switches was creating inconsistences and dropping the traffic flowing through a load balancer. The RSC feature is now disabled by default. 
- Fixed an issue where adding a secondary IP to the VM was causing RDP issues.
- Fixed an issue where the MAC address of a NIC was being cached, and assigning of that address to another resource was causing VM deployment failures. 
- Fixed an issue with I/O stall in the guest OS as a result of snapshotting disks while the IaaS VMs is powered on. The fix introduces functionality changes as part of the API. Backup solutions that create crash-consistent IaaS VM backups using the disk snapshot API will also require updates to consume the new functionality. For more information, see [Protect VMs deployed on Azure Stack Hub](../user/azure-stack-manage-vm-protect.md).
- Fixed an issue where Windows VM images from the RETAIL channel could not have their license activated by AVMA.
- Fixed an issue where VMs would fail to be created if the number of virtual cores requested by the VM was equal to the node's physical cores. We will now allow VMs to have virtual cores equal to or below the node's physical cores.
- Fixed an issue where we do not allow to set the license type "null" to switch pay as you go images to BYOL.
- Fixed an issue to allow extensions to be added to a VMSS.


## Security updates

For information about security updates in this update of Azure Stack Hub, see [Azure Stack Hub security updates](release-notes-security-updates.md).

## Update planning

Before applying the update, make sure to review the following information:

- [Known issues](known-issues.md)
- [Security updates](release-notes-security-updates.md)
- [Checklist of activities before and after applying the update](release-notes-checklist.md)

## Download the update

You can download the Azure Stack Hub 2002 update package from [the Azure Stack Hub download page](https://aka.ms/azurestackupdatedownload).

## Hotfixes

Azure Stack Hub releases hotfixes on a regular basis. Be sure to install the latest Azure Stack Hub hotfix for 1910 before updating Azure Stack Hub to 2002.

Azure Stack Hub hotfixes are only applicable to Azure Stack Hub integrated systems; do not attempt to install hotfixes on the ASDK.

### Prerequisites: Before applying the 2002 update

The 2002 release of Azure Stack Hub must be applied on the 1910 release with the following hotfixes:

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack Hub hotfix 1.1910.24.108](https://support.microsoft.com/help/4541350)

### After successfully applying the 2002 update

After the installation of this update, install any applicable hotfixes. For more information, see our [servicing policy](azure-stack-servicing-policy.md).

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- No Azure Stack Hub hotfix available for 2002.
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
  - Receive CSS and engineering support for their deployments.


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

- Starting with the 1910 release, the Azure Stack Hub system **requires** an additional /20 private internal IP space. This network is private to the Azure Stack Hub system and can be reused on multiple Azure Stack Hub systems within your datacenter. While the network is private to Azure Stack Hub, it must not overlap with a network in your datacenter. The /20 private IP space is divided into multiple networks that enable running the Azure Stack Hub infrastructure on containers (as previously mentioned in the [1905 release notes](release-notes.md?view=azs-1905)). The goal of running the Azure Stack Hub infrastructure in containers is to optimize utilization and enhance performance. In addition, the /20 private IP space is also used to enable ongoing efforts that will reduce required routable IP space before deployment.

  - Please note that the /20 input serves as a prerequisite to the next Azure Stack Hub update after 1910. When the next Azure Stack Hub update after 1910 releases and you attempt to install it, the update will fail if you haven't completed the /20 input as described in the remediation steps as follows. An alert will be present in the administrator portal until the above remediation steps have been completed. See the [Datacenter network integration](azure-stack-network.md#private-network) article to understand how this new private space will be consumed.

  - Remediation steps: To remediate, follow the instructions to [open a PEP Session](azure-stack-privileged-endpoint.md#access-the-privileged-endpoint). Prepare a [private internal IP range](azure-stack-network.md#logical-networks) of size /20, and run the following cmdlet (only available starting with 1910) in the PEP session using the following example: `Set-AzsPrivateNetwork -UserSubnet 100.87.0.0/20`. If the operation is performed successfully, you'll receive the message **Azs Internal Network range added to the config**. If successfully completed, the alert will close in the administrator portal. The Azure Stack Hub system can now update to the next version.
  
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

## Update planning

Before applying the update, make sure to review the following information:

- [Known issues](known-issues.md)
- [Security updates](release-notes-security-updates.md)
- [Checklist of activities before and after applying the update](release-notes-checklist.md)

## Download the update

You can download the Azure Stack Hub 1910 update package from [the Azure Stack Hub download page](https://aka.ms/azurestackupdatedownload).

## Hotfixes

Azure Stack Hub releases hotfixes on a regular basis. Be sure to install the latest Azure Stack Hub hotfix for 1908 before updating Azure Stack Hub to 1910.

Azure Stack Hub hotfixes are only applicable to Azure Stack Hub integrated systems; don't attempt to install hotfixes on the ASDK.

### Prerequisites: Before applying the 1910 update

The 1910 release of Azure Stack Hub must be applied on the 1908 release with the following hotfixes:

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack Hub hotfix 1.1908.14.53](https://support.microsoft.com/help/4537661)

### After successfully applying the 1910 update

After the installation of this update, install any applicable hotfixes. For more information, see our [servicing policy](azure-stack-servicing-policy.md).

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack Hub hotfix 1.1910.17.95](https://support.microsoft.com/help/4537833)
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

## <a name="download-the-update-1908"></a>Download the update

You can download the Azure Stack Hub 1908 update package from [the Azure Stack Hub download page](https://aka.ms/azurestackupdatedownload).

## Hotfixes

Azure Stack Hub releases hotfixes on a regular basis. Be sure to install the latest Azure Stack Hub hotfix for 1907 before updating Azure Stack Hub to 1908.

Azure Stack Hub hotfixes are only applicable to Azure Stack Hub integrated systems; don't attempt to install hotfixes on the ASDK.

### Prerequisites: Before applying the 1908 update

The 1908 release of Azure Stack Hub must be applied on the 1907 release with the following hotfixes:

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack Hub hotfix 1.1907.18.56](https://support.microsoft.com/help/4528552)

The Azure Stack Hub 1908 Update requires **Azure Stack Hub OEM version 2.1 or later** from your system's hardware provider. OEM updates include driver and firmware updates to your Azure Stack Hub system hardware. For more information about applying OEM updates, see [Apply Azure Stack Hub original equipment manufacturer updates](azure-stack-update-oem.md)

### After successfully applying the 1908 update

After the installation of this update, install any applicable hotfixes. For more information, see our [servicing policy](azure-stack-servicing-policy.md).

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack Hub hotfix 1.1908.14.53](https://support.microsoft.com/help/4537661)
::: moniker-end

::: moniker range="azs-1907"
## 1907 build reference

The Azure Stack Hub 1907 update build number is **1.1907.0.20**.

### Update type

The Azure Stack Hub 1907 update build type is **Express**. For more information about update build types, see the [Manage updates in Azure Stack Hub](azure-stack-updates.md) article. Based on internal testing, the expected time it takes for the 1907 update to complete is approximately 13 hours.

- Exact update runtimes typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware configuration.
- Runtimes lasting longer than expected aren't uncommon and don't require action by Azure Stack Hub operators unless the update fails.
- This runtime approximation is specific to the 1907 update and shouldn't be compared to other Azure Stack Hub updates.

## What's in this update

<!-- The current theme (if any) of this release. -->

### What's new

<!-- What's new, also net new experiences and features. -->

- General availability release of the Azure Stack Hub diagnostic log collection service to facilitate and improve diagnostic log collection. The Azure Stack Hub diagnostic log collection service provides a simplified way to collect and share diagnostic logs with Microsoft Customer Support Services (CSS). This diagnostic log collection service provides a new user experience in the Azure Stack Hub administrator portal that enables operators to set up the automatic upload of diagnostic logs to a storage blob when certain critical alerts are raised. The service can also be used to perform the same operation on demand. For more information, see the [Diagnostic log collection](azure-stack-diagnostic-log-collection-overview.md) article.

- General availability release of the Azure Stack Hub network infrastructure validation as a part of the Azure Stack Hub validation tool **Test-AzureStack**. Azure Stack Hub network infrastructure will be a part of **Test-AzureStack**, to identify if a failure occurs on the network infrastructure of Azure Stack Hub. The test checks connectivity of the network infrastructure by bypassing the Azure Stack Hub software-defined network. It demonstrates connectivity from a public VIP to the configured DNS forwarders, NTP servers, and identity endpoints. It also checks for connectivity to Azure when using Azure AD as the identity provider, or the federated server when using ADFS. For more information, see the [Azure Stack Hub validation tool](azure-stack-diagnostic-test.md) article.

- Added an internal secret rotation procedure to rotate internal SQL TLS certificates as required during a system update.

### Improvements

<!-- Changes and product improvements with tangible customer-facing value. -->

- The Azure Stack Hub update blade now displays a **Last Step Completed** time for active updates. This addition can be seen by going to the update blade and clicking on a running update. **Last Step Completed** is then available in the **Update run details** section.

- Improvements to **Start-AzureStack** and **Stop-AzureStack** operator actions. The time to start Azure Stack Hub has been reduced by an average of 50%. The time to shut down Azure Stack Hub has been reduced by an average of 30%. The average startup and shutdown times remain the same as the number of nodes increases in a scale-unit.

- Improved error handling for the disconnected Marketplace tool. If a download fails or partially succeeds when using **Export-AzSOfflineMarketplaceItem**, a detailed error message displays with more details about the error and any possible mitigation steps.

- Improved the performance of managed disk creation from a large page blob/snapshot. Previously, it triggered a timeout when creating a large disk.  

<!-- https://icm.ad.msft.net/imp/v3/incidents/details/127669774/home -->
- Improved virtual disk health check before shutting down a node to avoid unexpected virtual disk detaching.

- Improved storage of internal logs for administrator operations. This addition results in improved performance and reliability during administrator operations by minimizing the memory and storage consumption of internal log processes. You might also notice improved page load times of the update blade in the administrator portal. As part of this improvement, update logs older than six months will no longer be available in the system. If you require logs for these updates, be sure to [Download the summary](azure-stack-apply-updates.md) for all update runs older than six months before performing the 1907 update.

### Changes

- Azure Stack Hub version 1907 contains a warning alert that instructs operators to be sure to update their system's OEM package to version 2.1 or later before updating to version 1908. For more information about how to apply Azure Stack Hub OEM updates, see [Apply an Azure Stack Hub original equipment manufacturer update](azure-stack-update-oem.md).

- Added a new outbound rule (HTTPS) to enable communication for Azure Stack Hub diagnostic log collection service. For more information, see [Azure Stack Hub datacenter integration - Publish endpoints](azure-stack-integrate-endpoints.md#ports-and-urls-outbound).

- The infrastructure backup service now deletes partially uploaded backups if the external storage location runs out of capacity.

- Infrastructure backups no longer include a backup of domain services data. This change only applies to systems using Azure Active Directory as the identity provider.

- We now validate that an image being ingested into the **Compute -> VM images** blade is of type page blob.

- The privileged endpoint command **Set-BmcCredential** now updates the credential in the Baseboard Management Controller.

### Fixes

<!-- Product fixes that came up from customer deployments worth highlighting, especially if there's an SR/ICM associated to it. -->
- Fixed an issue in which the publisher, offer, and SKU were treated as case sensitive in a Resource Manager template: the image wasn't fetched for deployment unless the image parameters were the same case as that of the publisher, offer, and SKU.

<!-- https://icm.ad.msft.net/imp/v3/incidents/details/129536438/home -->
- Fixed an issue with backups failing with a **PartialSucceeded** error message, due to timeouts during backup of storage service metadata.  

- Fixed an issue in which deleting user subscriptions resulted in orphaned resources.

- Fixed an issue in which the description field wasn't saved when creating an offer.

- Fixed an issue in which a user with **Read only** permissions was able to create, edit, and delete resources. Now the user is only able to create resources when the **Contributor** permission is assigned. 

<!-- https://icm.ad.msft.net/imp/v3/incidents/details/127772311/home -->
- Fixed an issue in which the update fails due to a DLL file locked by the WMI provider host.

- Fixed an issue in the update service that prevented available updates from displaying in the update tile or resource provider. This issue was found in 1906 and fixed in hotfix [KB4511282](https://support.microsoft.com/help/4511282/).

- Fixed an issue that could cause updates to fail due to the management plane becoming unhealthy due to a bad configuration. This issue was found in 1906 and fixed in hotfix [KB4512794](https://support.microsoft.com/help/4512794/).

- Fixed an issue that prevented users from completing deployment of third-party images from the marketplace. This issue was found in 1906 and fixed in hotfix [KB4511259](https://support.microsoft.com/help/4511259/).

- Fixed an issue that could cause VM creation from managed images to fail due to our user image manager service crashing. This issue was found in 1906 and fixed in hotfix [KB4512794](https://support.microsoft.com/help/4512794/)

- Fixed an issue in which VM CRUD operations could fail due to the app gateway cache not being refreshed as expected. This issue was found in 1906 and fixed in hotfix [KB4513119](https://support.microsoft.com/en-us/help/4513119/)

- Fixed an issue in the health resource provider which impacted the availability of the region and alert blades in the administrator portal. This issue was found in 1906 and fixed in hotfix [KB4512794](https://support.microsoft.com/help/4512794).

## Security updates

For information about security updates in this update of Azure Stack Hub, see [Azure Stack Hub security updates](release-notes-security-updates.md).

## Update planning

Before applying the update, make sure to review the following information:

- [Known issues](known-issues.md)
- [Security updates](release-notes-security-updates.md)
- [Checklist of activities before and after applying the update](release-notes-checklist.md)

## Download the update

You can download the Azure Stack Hub 1907 update package from [the Azure Stack Hub download page](https://aka.ms/azurestackupdatedownload).

## Hotfixes

Azure Stack Hub releases hotfixes on a regular basis. Be sure to install the latest Azure Stack Hub hotfix for 1906 before updating Azure Stack Hub to 1907.

Azure Stack Hub hotfixes are only applicable to Azure Stack Hub integrated systems; don't attempt to install hotfixes on the ASDK.

### Before applying the 1907 update

The 1907 release of Azure Stack Hub must be applied on the 1906 release with the following hotfixes:

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack Hub hotfix 1.1906.15.60](https://support.microsoft.com/help/4524559)

### After successfully applying the 1907 update

After the installation of this update, install any applicable hotfixes. For more information, see our [servicing policy](azure-stack-servicing-policy.md).

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack Hub hotfix 1.1907.18.56](https://support.microsoft.com/help/4528552)
::: moniker-end

::: moniker range=">=azs-1907"
## Automatic update notifications

Systems that can access the internet from the infrastructure network will see the **Update available** message in the operator portal. Systems without internet access can download and import the .zip file with the corresponding .xml.

> [!TIP]  
> Subscribe to the following *RSS* or *Atom* feeds to keep up with Azure Stack Hub hotfixes:
>
> - [RSS](https://support.microsoft.com/app/content/api/content/feeds/sap/en-us/32d322a8-acae-202d-e9a9-7371dccf381b/rss)
> - [Atom](https://support.microsoft.com/app/content/api/content/feeds/sap/en-us/32d322a8-acae-202d-e9a9-7371dccf381b/atom)

## Archive

To access archived release notes for an older version, use the version selector dropdown above the table of contents on the left and select the version you want to see.

## Next steps

- For an overview of the update management in Azure Stack Hub, see [Manage updates in Azure Stack Hub overview](azure-stack-updates.md).  
- For more information about how to apply updates with Azure Stack Hub, see [Apply updates in Azure Stack Hub](azure-stack-apply-updates.md).
- To review the servicing policy for Azure Stack Hub and what you must do to keep your system in a supported state, see [Azure Stack Hub servicing policy](azure-stack-servicing-policy.md).  
- To use the privileged endpoint (PEP) to monitor and resume updates, see [Monitor updates in Azure Stack Hub using the privileged endpoint](azure-stack-monitor-update.md).
::: moniker-end

<!------------------------------------------------------------>
<!------------------- UNSUPPORTED VERSIONS ------------------->
<!------------------------------------------------------------>
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

::: moniker range="<azs-1907"
You can access [older versions of Azure Stack Hub release notes on the TechNet Gallery](https://aka.ms/azsarchivedrelnotes). These archived documents are provided for reference purposes only and do not imply support for these versions. For information about Azure Stack Hub support, see [Azure Stack Hub servicing policy](azure-stack-servicing-policy.md). For further assistance, contact Microsoft Customer Support Services.
::: moniker-end


