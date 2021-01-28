---
title: Azure Stack Hub 1910 release notes 
description: 1910 Release notes for Azure Stack Hub integrated systems, including updates and bug fixes.
author: sethmanheim

ms.topic: article
ms.date: 01/25/2021
ms.author: sethm
ms.reviewer: sranthar
ms.lastreviewed: 09/09/2020

# Intent: As an Azure Stack Hub user, I want to know what's new in the latest release so that I can plan my update.
# Keyword: Notdone: keyword noun phrase

---

# Azure Stack Hub release notes

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

For more information about update build types, see [Manage updates in Azure Stack Hub](azure-stack-updates.md).

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

After the installation of this update, install any applicable hotfixes. For more information, see our [servicing policy](azure-stack-servicing-policy.md).

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack Hub hotfix 1.1910.63.186](https://support.microsoft.com/help/4574735)
