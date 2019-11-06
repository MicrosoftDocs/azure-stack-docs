---
title: Azure Stack release notes | Microsoft Docs
description: Learn about the updates for Azure Stack integrated systems, including what's new, and where to download the update.
services: azure-stack
documentationcenter: ''
author: sethmanheim
manager: femila
editor: ''

ms.assetid:  
ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 11/06/2019
ms.author: sethm
ms.reviewer: prchint
ms.lastreviewed: 11/06/2019
---

# Azure Stack updates: release notes

*Applies to: Azure Stack integrated systems*

This article describes the contents of Azure Stack update packages. The update includes what's new improvements, and fixes for this release of Azure Stack.

To access release notes for a different version, use the version selector dropdown above the table of contents on the left.

::: moniker range=">=azs-1906"
> [!IMPORTANT]  
> This update package is only for Azure Stack integrated systems. Do not apply this update package to the Azure Stack Development Kit.
::: moniker-end
::: moniker range="<azs-1906"
> [!IMPORTANT]  
> If your Azure Stack instance is behind by more than two updates, it's considered out of compliance. You must [update to at least the minimum supported version to receive support](azure-stack-servicing-policy.md#keep-your-system-under-support).
::: moniker-end

## Update planning

Before applying the update, make sure to review the following information:

- [Known issues](known-issues.md)
- [Security updates](release-notes-security-updates.md)
- [Checklist of activities before and after applying the update](release-notes-checklist.md)

For help with troubleshooting updates and the update process, see [Troubleshoot patch and update issues for Azure Stack](azure-stack-updates-troubleshoot.md).

<!---------------------------------------------------------->
<!------------------- SUPPORTED VERSIONS ------------------->
<!---------------------------------------------------------->
::: moniker range="azs-1910"
## 1910 build reference

The Azure Stack 1910 update build number is **1.1910.x.xx**.

### Update type

Starting with 1908, the underlying operating system on which Azure Stack runs was updated to Windows Server 2019. This enables core fundamental enhancements, as well as the ability to bring additional capabilities to Azure Stack in the near future.

The Azure Stack 1910 update build type is **Express**. For more information about update build types, see the [Manage updates in Azure Stack](azure-stack-updates.md) article. The expected time it takes for the 1910 update to complete is approximately 10 hours, regardless of the number of physical nodes in your Azure Stack environment. Exact update runtimes will typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware specifications. Runtimes lasting longer than the expected value are not uncommon and do not require action by Azure Stack operators unless the update fails. This runtime approximation is specific to the 1906 update and should not be compared to other Azure Stack updates.

For more information about update build types, see [Manage updates in Azure Stack](azure-stack-updates.md).

- Exact update runtimes typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware configuration.
- Runtimes lasting longer than expected are not uncommon and do not require action by Azure Stack operators unless the update fails.
- This runtime approximation is specific to the 1910 update and should not be compared to other Azure Stack updates.

<!-- ## What's in this update -->

<!-- The current theme (if any) of this release. -->

### What's new

<!-- What's new, also net new experiences and features. -->

- The administrator portal now shows the privileged endpoint IP addresses in the region properties menu for easier discovery. In addition, it shows the current configured time server and DNS forwarders.

- The Azure Stack health and monitoring system can now raise alerts for various hardware components if an error happens. This requires additional configuration. For more information, see [Monitor Azure Stack hardware components](azure-stack-hardware-monitoring.md).

- A new version of Azure Stack Admin PowerShell modules is available. <!-- For more information, see -->

- Added the **Set-AzSDefenderManualUpdate** cmdlet in the privileged endpoint (PEP) to configure the manual update for Windows Defender definitions in the Azure Stack infrastructure. For more information, see [Update Windows Defender Antivirus on Azure Stack](azure-stack-security-av.md).

- Added the **Get-AzSDefenderManualUpdate** cmdlet in the privileged endpoint (PEP) to retrieve the configuration of the manual update for Windows Defender definitions in the Azure Stack infrastructure. For more information, see [Update Windows Defender Antivirus on Azure Stack](azure-stack-security-av.md).

- Added the **Set-AzSDnsForwarder** cmdlet in the privileged endpoint (PEP) to change the forwarder settings of the DNS servers in Azure Stack. For more information about DNS configuration, see [Azure Stack datacenter DNS integration](azure-stack-integrate-dns.md).

- Added the **Get-AzSDnsForwarder** cmdlet in the privileged endpoint (PEP) to retrieve the forwarder settings of the DNS servers in Azure Stack. For more information about DNS configuration, see [Azure Stack datacenter DNS integration](azure-stack-integrate-dns.md).

### Improvements

<!-- Changes and product improvements with tangible customer-facing value. -->

- Added auditing rule to report when an external device (for example, a USB key) is mounted to a node of the Azure Stack infrastructure. The audit log is emitted via syslog and will be displayed as **Microsoft-Windows-Security-Auditing: 6416|Plug and Play Events**. For more information about how to configure the syslog client, see [Syslog forwarding](azure-stack-integrate-security.md).

- Azure Stack is moving to 4096 bit RSA keys for the internal certificates. Running internal secret rotation will replace old 2048 bit certificates with 4096 bit long certificates. For more information about secret rotation in Azure Stack, see [Rotate secrets in Azure Stack](azure-stack-rotate-secrets.md).

- Upgrades to the complexity of cryptographic algorithms and key strength for several internal components to comply with the Committee on National Security Systems - Policy 15 (CNSSP-15), which provides best practices for the use of public standards for secure information sharing. Among the improvements, there is AES256 for Kerberos authentication, and SHA384 for VPN encryption. For more information about CNSSP-15, see the [Committee on National Security Systems, Policies page](http://www.cnss.gov/CNSS/issuances/Policies.cfm).

### Changes

- When downloading marketplace items from Azure to Azure Stack, there is a new user interface that enables you to specify a version of the item, when multiple versions exist. The new UI is available in both connected and disconnected scenarios. For more information, see [Download marketplace items from Azure to Azure Stack](azure-stack-download-azure-marketplace-item.md).  

- Starting in 1910, the Azure Stack system requires an additional /20 private internal IP space. This network is private to the Azure Stack system and can be re-used on multiple Azure Stack systems within your datacenter. While the network is private to Azure Stack, it must not overlap with a network in your datacenter. The /20 private IP space is divided into multiple networks that enable running the Azure Stack infrastructure on containers (as previously mentioned in the [1905 release notes](release-notes.md?view=azs-1905)). The goal of running the Azure Stack infrastructure in containers is to optimize utilization and enhance performance. In addition, the /20 private IP space is also used to enable ongoing efforts that will reduce required routable IP space prior to deployment.

  - Please note that the /20 input serves as a 1911 pre-requisite. When the Azure Stack 1911 update is released and an attempt is made to install it, the update will fail if you have not completed the /20 input as described below in remediation steps. An alert will be present in the admin portal until the above remediation steps have been completed. Please see the [Datacenter network integration](azure-stack-network.md#private-network) article to understand how this new private space will be consumed. 

  - Remediation steps: To remediate, follow the instructions to [open a PEP Session](azure-stack-privileged-endpoint.md#access-the-privileged-endpoint). Prepare a [private internal IP range](azure-stack-network.md#logical-networks) of size /20, and run the following cmdlet in the PEP session using the format: `Set-AzsInternalNetwork -UserSubnet 100.87.0.0/20`. If the operation is performed successfully, you will receive the message **Azs Internal Network range added to the config**. If successfully completed, the alert will close in the admin portal. The Azure Stack system will now be able to update to 1911.

### Fixes

<!-- Product fixes that came up from customer deployments worth highlighting, especially if there is an SR/ICM associated to it. -->

- Fixed an issue that prevented enforcing TLS 1.2 policy on environments deployed prior to the Azure Stack 1904 release.

## Security updates

For information about security updates in this update of Azure Stack, see [Azure Stack security updates](release-notes-security-updates.md).

## Update planning

Before applying the update, make sure to review the following information:

- [Known issues](known-issues.md)
- [Security updates](release-notes-security-updates.md)
- [Checklist of activities before and after applying the update](release-notes-checklist.md)

## Download the update

You can download the Azure Stack 1910 update package from [the Azure Stack download page](https://aka.ms/azurestackupdatedownload).

## Hotfixes

Azure Stack releases hotfixes on a regular basis. Be sure to install the latest Azure Stack hotfix for 1908 before updating Azure Stack to 1910.

Azure Stack hotfixes are only applicable to Azure Stack integrated systems; do not attempt to install hotfixes on the ASDK.

### Prerequisites: Before applying the 1910 update

The 1910 release of Azure Stack must be applied on the 1908 release with the following hotfixes:

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack hotfix 1.1908.8.41](https://support.microsoft.com/help/4528074)

### After successfully applying the 1910 update

After the installation of this update, install any applicable hotfixes. For more information, see our [servicing policy](azure-stack-servicing-policy.md).

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- No hotfix available for 1910.
::: moniker-end

::: moniker range="azs-1908"
## 1908 build reference

The Azure Stack 1908 update build number is **1.1908.4.33**.

### Update type

For 1908, the underlying operating system on which Azure Stack runs has been updated to Windows Server 2019. This enables core fundamental enhancements, as well as the ability to bring additional capabilities to Azure Stack in the near future.

The Azure Stack 1908 update build type is **Full**. As a result, the 1908 update has a longer runtime than express updates like 1906 and 1907. Exact runtimes for full updates typically depend on the number of nodes that your Azure Stack instance contains, the capacity used on your system by tenant workloads, your system's network connectivity (if connected to the internet), and your system hardware configuration. The 1908 update has had the following expected runtimes in our internal testing: 4 nodes - 42 hours, 8 nodes - 50 hours, 12 nodes - 60 hours, 16 nodes - 70 hours. Update runtimes lasting longer than these expected values are not uncommon and do not require action by Azure Stack operators unless the update fails.

For more information about update build types, see [Manage updates in Azure Stack](azure-stack-updates.md).

- Exact update runtimes typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware configuration.
- Runtimes lasting longer than expected are not uncommon and do not require action by Azure Stack operators unless the update fails.
- This runtime approximation is specific to the 1908 update and should not be compared to other Azure Stack updates.

<!-- ## What's in this update -->

<!-- The current theme (if any) of this release. -->

### What's new

<!-- What's new, also net new experiences and features. -->

- For 1908, note that the underlying operating system on which Azure Stack runs has been updated to Windows Server 2019. This enables core fundamental enhancements, as well as the ability to bring additional capabilities to Azure Stack in the near future.
- All components of Azure Stack infrastructure now operate in FIPS 140-2 mode.
- Azure Stack operators can now remove portal user data. For more information, see [Clear portal user data from Azure Stack](azure-stack-portal-clear.md).

### Improvements

<!-- Changes and product improvements with tangible customer-facing value. -->
- Improvements to data at rest encryption of Azure Stack to persist secrets into the hardware Trusted Platform Module (TPM) of the physical nodes.

### Changes

- Hardware providers will be releasing OEM extension package 2.1 or later at the same time as Azure Stack version 1908. The OEM extension package 2.1 or later is a prerequisite for Azure Stack version 1908. For more information about how to download OEM extension package 2.1 or later, contact your system's hardware provider, and see the [OEM updates](azure-stack-update-oem.md#oem-contact-information) article.  

### Fixes

- Fixed an issue with compatibility with future Azure Stack OEM updates and an issue with VM deployment using customer user images. This issue was found in 1907 and fixed in hotfix [KB4517473](https://support.microsoft.com/en-us/help/4517473/azure-stack-hotfix-1-1907-12-44)  
- Fixed an issue with OEM Firmware update and corrected misdiagnosis in Test-AzureStack for Fabric Ring Health. This issue was found in 1907 and fixed in hotfix [KB4515310](https://support.microsoft.com/en-us/help/4515310/azure-stack-hotfix-1-1907-7-35)
- Fixed an issue with OEM Firmware update process. This issue was found in 1907 and fixed in hotfix [KB4515650](https://support.microsoft.com/en-us/help/4515650/azure-stack-hotfix-1-1907-8-37)

<!-- Product fixes that came up from customer deployments worth highlighting, especially if there is an SR/ICM associated to it. -->

## Security updates

For information about security updates in this update of Azure Stack, see [Azure Stack security updates](release-notes-security-updates.md).

## <a name="download-the-update-1908"></a>Download the update

You can download the Azure Stack 1908 update package from [the Azure Stack download page](https://aka.ms/azurestackupdatedownload).

## Hotfixes

Azure Stack releases hotfixes on a regular basis. Be sure to install the latest Azure Stack hotfix for 1907 before updating Azure Stack to 1908.

Azure Stack hotfixes are only applicable to Azure Stack integrated systems; do not attempt to install hotfixes on the ASDK.

### Prerequisites: Before applying the 1908 update

The 1908 release of Azure Stack must be applied on the 1907 release with the following hotfixes:

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack hotfix 1.1907.18.56](https://support.microsoft.com/help/4528552)

The Azure Stack 1908 Update requires **Azure Stack OEM version 2.1 or later** from your system's hardware provider. OEM updates include driver and firmware updates to your Azure Stack system hardware. For more information about applying OEM updates, see [Apply Azure Stack original equipment manufacturer updates](azure-stack-update-oem.md)

### After successfully applying the 1908 update

After the installation of this update, install any applicable hotfixes. For more information, see our [servicing policy](azure-stack-servicing-policy.md).

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack hotfix 1.1908.8.41](https://support.microsoft.com/help/4528074)
::: moniker-end

::: moniker range="azs-1907"
## 1907 build reference

The Azure Stack 1907 update build number is **1.1907.0.20**.

### Update type

The Azure Stack 1907 update build type is **Express**. For more information about update build types, see the [Manage updates in Azure Stack](azure-stack-updates.md) article. Based on internal testing, the expected time it takes for the 1907 update to complete is approximately 13 hours.

- Exact update runtimes typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware configuration.
- Runtimes lasting longer than expected are not uncommon and do not require action by Azure Stack operators unless the update fails.
- This runtime approximation is specific to the 1907 update and should not be compared to other Azure Stack updates.

## What's in this update

<!-- The current theme (if any) of this release. -->

### What's new

<!-- What's new, also net new experiences and features. -->

- General availability release of the Azure Stack diagnostic log collection service to facilitate and improve diagnostic log collection. The Azure Stack diagnostic log collection service provides a simplified way to collect and share diagnostic logs with Microsoft Customer Support Services (CSS). This diagnostic log collection service provides a new user experience in the Azure Stack administrator portal that enables operators to set up the automatic upload of diagnostic logs to a storage blob when certain critical alerts are raised, or to perform the same operation on demand. For more information, see the [Diagnostic log collection](azure-stack-diagnostic-log-collection-overview.md) article.

- General availability release of the Azure Stack network infrastructure validation as a part of the Azure Stack validation tool **Test-AzureStack**. Azure Stack network infrastructure will be a part of **Test-AzureStack**, to identify if a failure occurs on the network infrastructure of Azure Stack. The test checks connectivity of the network infrastructure by bypassing the Azure Stack software-defined network. It demonstrates connectivity from a public VIP to the configured DNS forwarders, NTP servers, and identity endpoints. In addition, it checks for connectivity to Azure when using Azure AD as the identity provider, or the federated server when using ADFS. For more information, see the [Azure Stack validation tool](azure-stack-diagnostic-test.md) article.

- Added an internal secret rotation procedure to rotate internal SQL TLS certificates as required during a system update.

### Improvements

<!-- Changes and product improvements with tangible customer-facing value. -->

- The Azure Stack update blade now displays a **Last Step Completed** time for active updates. This can be seen by going to the update blade and clicking on a running update. **Last Step Completed** is then available in the **Update run details** section.

- Improvements to **Start-AzureStack** and **Stop-AzureStack** operator actions. The time to start Azure Stack has been reduced by an average of 50%. The time to shut down Azure Stack has been reduced by an average of 30%. The average startup and shutdown times remain the same as the number of nodes increases in a scale-unit.

- Improved error handling for the disconnected Marketplace tool. If a download fails or partially succeeds when using **Export-AzSOfflineMarketplaceItem**, a detailed error message is displayed with more details about the error and mitigation steps, if any.

- Improved the performance of managed disk creation from a large page blob/snapshot. Previously, it triggered a timeout when creating a large disk.  

<!-- https://icm.ad.msft.net/imp/v3/incidents/details/127669774/home -->
- Improved virtual disk health check before shutting down a node to avoid unexpected virtual disk detaching.

- Improved storage of internal logs for administrator operations. This results in improved performance and reliability during administrator operations by minimizing the memory and storage consumption of internal log processes. You might also notice improved page load times of the update blade in the administrator portal. As part of this improvement, update logs older than 6 months will no longer be available in the system. If you require logs for these updates, be sure to [Download the summary](azure-stack-apply-updates.md) for all update runs older than 6 months before performing the 1907 update.

### Changes

- Azure Stack version 1907 contains a warning alert that instructs operators to be sure to update their system's OEM package to version 2.1 or later before updating to version 1908. For more information about how to apply Azure Stack OEM updates, see [Apply an Azure Stack original equipment manufacturer update](azure-stack-update-oem.md).

- Added a new outbound rule (HTTPS) to enable communication for Azure Stack diagnostic log collection service. For more information, see [Azure Stack datacenter integration - Publish endpoints](azure-stack-integrate-endpoints.md#ports-and-urls-outbound).

- The infrastructure backup service now deletes partially uploaded backups if the external storage location runs out of capacity.

- Infrastructure backups no longer include a backup of domain services data. This only applies to systems using Azure Active Directory as the identity provider.

- We now validate that an image being ingested into the **Compute -> VM images** blade is of type page blob.

- The privileged endpoint command **Set-BmcCredential** now updates the credential in the Baseboard Management Controller.

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

For information about security updates in this update of Azure Stack, see [Azure Stack security updates](release-notes-security-updates.md).

## Update planning

Before applying the update, make sure to review the following information:

- [Known issues](known-issues.md)
- [Security updates](release-notes-security-updates.md)
- [Checklist of activities before and after applying the update](release-notes-checklist.md)

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

After the installation of this update, install any applicable hotfixes. For more information, see our [servicing policy](azure-stack-servicing-policy.md).

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack hotfix 1.1907.18.56](https://support.microsoft.com/help/4528552)
::: moniker-end

::: moniker range="azs-1906"
## 1906 build reference

The Azure Stack 1906 update build number is **1.1906.0.30**.

### Update type

The Azure Stack 1906 update build type is **Express**. For more information about update build types, see the [Manage updates in Azure Stack](azure-stack-updates.md) article. The expected time it takes for the 1906 update to complete is approximately 10 hours, regardless of the number of physical nodes in your Azure Stack environment. Exact update runtimes will typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware specifications. Runtimes lasting longer than the expected value are not uncommon and do not require action by Azure Stack operators unless the update fails. This runtime approximation is specific to the 1906 update and should not be compared to other Azure Stack updates.

## What's in this update

<!-- The current theme (if any) of this release. -->

<!-- What's new, also net new experiences and features. -->

- Added a **Set-TLSPolicy** cmdlet in the privileged endpoint (PEP) to force TLS 1.2 on all the endpoints. For more information, see [Azure Stack security controls](azure-stack-security-configuration.md).

- Added a **Get-TLSPolicy** cmdlet in the privileged endpoint (PEP) to retrieve the applied TLS policy. For more information, see [Azure Stack security controls](azure-stack-security-configuration.md).

- Added an internal secret rotation procedure to rotate internal TLS certificates as required during a system update.

- Added a safeguard to prevent expiration of internal secrets by forcing internal secrets rotation in case a critical alert on expiring secrets is ignored. This should not be relied on as a regular operating procedure. Secrets rotation should be planned during a maintenance window. For more information, see [Azure Stack secret rotation](azure-stack-rotate-secrets.md).

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

For information about security updates in this update of Azure Stack, see [Azure Stack security updates](release-notes-security-updates.md).

## Update planning

Before applying the update, make sure to review the following information:

- [Known issues](known-issues.md)
- [Security updates](release-notes-security-updates.md)
- [Checklist of activities before and after applying the update](release-notes-checklist.md)

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

After the installation of this update, install any applicable hotfixes. For more information, see our [servicing policy](azure-stack-servicing-policy.md).

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack hotfix 1.1906.15.60](https://support.microsoft.com/help/4524559)
::: moniker-end

::: moniker range=">=azs-1906"
## Automatic update notifications

Systems that can access the internet from the infrastructure network will see the **Update available** message in the operator portal. Systems without internet access can download and import the .zip file with the corresponding .xml.

> [!TIP]  
> Subscribe to the following *RSS* or *Atom* feeds to keep up with Azure Stack hotfixes:
>
> - [RSS](https://support.microsoft.com/app/content/api/content/feeds/sap/en-us/32d322a8-acae-202d-e9a9-7371dccf381b/rss)
> - [Atom](https://support.microsoft.com/app/content/api/content/feeds/sap/en-us/32d322a8-acae-202d-e9a9-7371dccf381b/atom)

## Archive

To access archived release notes for an older version, use the version selector dropdown above the table of contents on the left, and select the version you want to see.

## Next steps

- For an overview of the update management in Azure Stack, see [Manage updates in Azure Stack overview](azure-stack-updates.md).  
- For more information about how to apply updates with Azure Stack, see [Apply updates in Azure Stack](azure-stack-apply-updates.md).
- To review the servicing policy for Azure Stack integrated systems, and what you must do to keep your system in a supported state, see [Azure Stack servicing policy](azure-stack-servicing-policy.md).  
- To use the Privileged End Point (PEP) to monitor and resume updates, see [Monitor updates in Azure Stack using the privileged endpoint](azure-stack-monitor-update.md).
::: moniker-end

<!------------------------------------------------------------>
<!------------------- UNSUPPORTED VERSIONS ------------------->
<!------------------------------------------------------------>
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

::: moniker range="<azs-1906"
You can access [older versions of Azure Stack release notes on the TechNet Gallery](https://aka.ms/azsarchivedrelnotes). These archived documents are provided for reference purposes only and do not imply support for these versions. For information about Azure Stack support, see [Azure Stack servicing policy](azure-stack-servicing-policy.md). For further assistance, contact Microsoft Customer Support Services.
::: moniker-end


