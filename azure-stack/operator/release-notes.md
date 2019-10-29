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
ms.date: 10/21/2019
ms.author: sethm
ms.reviewer: prchint
ms.lastreviewed: 08/30/2019
---

# Azure Stack updates: release notes

*Applies to: Azure Stack integrated systems*

This article describes the contents of Azure Stack update packages. The update includes what's new improvements, and fixes for this release of Azure Stack.

To access release notes for a different version, use the version selector dropdown above the table of contents on the left.

::: moniker range=">=azs-1905"
> [!IMPORTANT]  
> This update package is only for Azure Stack integrated systems. Do not apply this update package to the Azure Stack Development Kit.
::: moniker-end
::: moniker range="<azs-1905"
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
::: moniker range="azs-1908"
## 1908 build reference

The Azure Stack 1908 update build number is **1.1908.4.33**.

### <a name="update-type-1908"></a>Update type

For 1908, the underlying operating system on which Azure Stack runs has been updated to Windows Server 2019. This enables core fundamental enhancements, as well as the ability to bring additional capabilities to Azure Stack in the near future.

The Azure Stack 1908 update build type is **Full**. As a result, the 1908 update has a longer runtime than express updates like 1906 and 1907. Exact runtimes for full updates typically depend on the number of nodes that your Azure Stack instance contains, the capacity used on your system by tenant workloads, your system's network connectivity (if connected to the internet), and your system hardware configuration. The 1908 update has had the following expected runtimes in our internal testing: 4 nodes - 42 hours, 8 nodes - 50 hours, 12 nodes - 60 hours, 16 nodes - 70 hours. Update runtimes lasting longer than these expected values are not uncommon and do not require action by Azure Stack operators unless the update fails.

For more information about update build types, see [Manage updates in Azure Stack](azure-stack-updates.md).

- Exact update runtimes typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware configuration.
- Runtimes lasting longer than expected are not uncommon and do not require action by Azure Stack operators unless the update fails.
- This runtime approximation is specific to the 1908 update and should not be compared to other Azure Stack updates.

<!-- ## What's in this update -->

<!-- The current theme (if any) of this release. -->

### <a name="whats-new-1908"></a>What's new

<!-- What's new, also net new experiences and features. -->

- For 1908, note that the underlying operating system on which Azure Stack runs has been updated to Windows Server 2019. This enables core fundamental enhancements, as well as the ability to bring additional capabilities to Azure Stack in the near future.
- All components of Azure Stack infrastructure now operate in FIPS 140-2 mode.
- Azure Stack operators can now remove portal user data. For more information, see [Clear portal user data from Azure Stack](azure-stack-portal-clear.md).

### <a name="improvements-1908"></a>Improvements

<!-- Changes and product improvements with tangible customer-facing value. -->
- Improvements to data at rest encryption of Azure Stack to persist secrets into the hardware Trusted Platform Module (TPM) of the physical nodes.

### <a name="changes-1908"></a>Changes

- Hardware providers will be releasing OEM extension package 2.1 or later at the same time as Azure Stack version 1908. The OEM extension package 2.1 or later is a prerequisite for Azure Stack version 1908. For more information about how to download OEM extension package 2.1 or later, contact your system's hardware provider, and see the [OEM updates](azure-stack-update-oem.md#oem-contact-information) article.  

### <a name="fixes-1908"></a>Fixes

- Fixed an issue with compatibility with future Azure Stack OEM updates and an issue with VM deployment useing customer user images. This issue was found in 1907 and fixed in hotfix [KB4517473](https://support.microsoft.com/en-us/help/4517473/azure-stack-hotfix-1-1907-12-44)  
- Fixed an issue with OEM Firmware update and corrected misdiagnosis in Test-AzureStack for Fabric Ring Health. This issue was found in 1907 and fixed in hotfix [KB4515310](https://support.microsoft.com/en-us/help/4515310/azure-stack-hotfix-1-1907-7-35)
- Fixed an issue with OEM Firmware update process. This issue was found in 1907 and fixed in hotfix [KB4515650](https://support.microsoft.com/en-us/help/4515650/azure-stack-hotfix-1-1907-8-37)


<!-- Product fixes that came up from customer deployments worth highlighting, especially if there is an SR/ICM associated to it. -->

## <a name="security-updates-1908"></a>Security updates

For information about security updates in this update of Azure Stack, see [Azure Stack security updates](release-notes-security-updates.md).

## <a name="download-the-update-1908"></a>Download the update

You can download the Azure Stack 1908 update package from [the Azure Stack download page](https://aka.ms/azurestackupdatedownload).

## <a name="hotfixes-1908"></a>Hotfixes

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

### <a name="update-type-1907"></a>Update type

The Azure Stack 1907 update build type is **Express**. For more information about update build types, see the [Manage updates in Azure Stack](azure-stack-updates.md) article. Based on internal testing, the expected time it takes for the 1907 update to complete is approximately 13 hours.

- Exact update runtimes typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware configuration.
- Runtimes lasting longer than expected are not uncommon and do not require action by Azure Stack operators unless the update fails.
- This runtime approximation is specific to the 1907 update and should not be compared to other Azure Stack updates.

## <a name="whats-in-this-update-1907"></a>What's in this update

<!-- The current theme (if any) of this release. -->

### <a name="whats-new-1907"></a>What's new

<!-- What's new, also net new experiences and features. -->

- General availability release of the Azure Stack diagnostic log collection service to facilitate and improve diagnostic log collection. The Azure Stack diagnostic log collection service provides a simplified way to collect and share diagnostic logs with Microsoft Customer Support Services (CSS). This diagnostic log collection service provides a new user experience in the Azure Stack administrator portal that enables operators to set up the automatic upload of diagnostic logs to a storage blob when certain critical alerts are raised, or to perform the same operation on demand. For more information, see the [Diagnostic log collection](azure-stack-diagnostic-log-collection-overview.md) article.

- General availability release of the Azure Stack network infrastructure validation as a part of the Azure Stack validation tool **Test-AzureStack**. Azure Stack network infrastructure will be a part of **Test-AzureStack**, to identify if a failure occurs on the network infrastructure of Azure Stack. The test checks connectivity of the network infrastructure by bypassing the Azure Stack software-defined network. It demonstrates connectivity from a public VIP to the configured DNS forwarders, NTP servers, and identity endpoints. In addition, it checks for connectivity to Azure when using Azure AD as the identity provider, or the federated server when using ADFS. For more information, see the [Azure Stack validation tool](azure-stack-diagnostic-test.md) article.

- Added an internal secret rotation procedure to rotate internal SQL TLS certificates as required during a system update.

### <a name="improvements-1907"></a>Improvements

<!-- Changes and product improvements with tangible customer-facing value. -->

- The Azure Stack update blade now displays a **Last Step Completed** time for active updates. This can be seen by going to the update blade and clicking on a running update. **Last Step Completed** is then available in the **Update run details** section.

- Improvements to **Start-AzureStack** and **Stop-AzureStack** operator actions. The time to start Azure Stack has been reduced by an average of 50%. The time to shut down Azure Stack has been reduced by an average of 30%. The average startup and shutdown times remain the same as the number of nodes increases in a scale-unit.

- Improved error handling for the disconnected Marketplace tool. If a download fails or partially succeeds when using **Export-AzSOfflineMarketplaceItem**, a detailed error message is displayed with more details about the error and mitigation steps, if any.

- Improved the performance of managed disk creation from a large page blob/snapshot. Previously, it triggered a timeout when creating a large disk.  

<!-- https://icm.ad.msft.net/imp/v3/incidents/details/127669774/home -->
- Improved virtual disk health check before shutting down a node to avoid unexpected virtual disk detaching.

- Improved storage of internal logs for administrator operations. This results in improved performance and reliability during administrator operations by minimizing the memory and storage consumption of internal log processes. You might also notice improved page load times of the update blade in the administrator portal. As part of this improvement, update logs older than 6 months will no longer be available in the system. If you require logs for these updates, be sure to [Download the summary](azure-stack-apply-updates.md) for all update runs older than 6 months before performing the 1907 update.

### <a name="changes-1907"></a>Changes

- Azure Stack version 1907 contains a warning alert that instructs operators to be sure to update their system's OEM package to version 2.1 or later before updating to version 1908. For more information about how to apply Azure Stack OEM updates, see [Apply an Azure Stack original equipment manufacturer update](azure-stack-update-oem.md).

- Added a new outbound rule (HTTPS) to enable communication for Azure Stack diagnostic log collection service. For more information, see [Azure Stack datacenter integration - Publish endpoints](azure-stack-integrate-endpoints.md#ports-and-urls-outbound).

- The infrastructure backup service now deletes partially uploaded backups if the external storage location runs out of capacity.

- Infrastructure backups no longer include a backup of domain services data. This only applies to systems using Azure Active Directory as the identity provider.

- We now validate that an image being ingested into the **Compute -> VM images** blade is of type page blob.

### <a name="fixes-1907"></a>Fixes

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

## <a name="security-updates-1907"></a>Security updates

For information about security updates in this update of Azure Stack, see [Azure Stack security updates](release-notes-security-updates.md).

## <a name="update-planning-1907"></a>Update planning

Before applying the update, make sure to review the following information:

- [Known issues](known-issues.md)
- [Security updates](release-notes-security-updates.md)
- [Checklist of activities before and after applying the update](release-notes-checklist.md)

## <a name="download-the-update-1907"></a>Download the update

You can download the Azure Stack 1907 update package from [the Azure Stack download page](https://aka.ms/azurestackupdatedownload).

## <a name="hotfixes-1907"></a>Hotfixes

Azure Stack releases hotfixes on a regular basis. Be sure to install the latest Azure Stack hotfix for 1906 before updating Azure Stack to 1907.

Azure Stack hotfixes are only applicable to Azure Stack integrated systems; do not attempt to install hotfixes on the ASDK.

### Before applying the 1907 update

The 1907 release of Azure Stack must be applied on the 1906 release with the following hotfixes:

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack hotfix 1.1906.15.60](https://support.microsoft.com/help/4524559)

### After successfully applying the 1907 update

After the installation of this update, install any applicable hotfixes. For more information, see our [servicing policy](azure-stack-servicing-policy.md).

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack hotfix 1.1907.17.54](https://support.microsoft.com/help/4523826)
::: moniker-end

::: moniker range="azs-1906"
## 1906 build reference

The Azure Stack 1906 update build number is **1.1906.0.30**.

### <a name="update-type-1906"></a>Update type

The Azure Stack 1906 update build type is **Express**. For more information about update build types, see the [Manage updates in Azure Stack](azure-stack-updates.md) article. The expected time it takes for the 1906 update to complete is approximately 10 hours, regardless of the number of physical nodes in your Azure Stack environment. Exact update runtimes will typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware specifications. Runtimes lasting longer than the expected value are not uncommon and do not require action by Azure Stack operators unless the update fails. This runtime approximation is specific to the 1906 update and should not be compared to other Azure Stack updates.

## <a name="whats-in-this-update-1906"></a>What's in this update

<!-- The current theme (if any) of this release. -->

<!-- What's new, also net new experiences and features. -->

- Added a **Set-TLSPolicy** cmdlet in the privileged endpoint (PEP) to force TLS 1.2 on all the endpoints. For more information, see [Azure Stack security controls](azure-stack-security-configuration.md).

- Added a **Get-TLSPolicy** cmdlet in the privileged endpoint (PEP) to retrieve the applied TLS policy. For more information, see [Azure Stack security controls](azure-stack-security-configuration.md).

- Added an internal secret rotation procedure to rotate internal TLS certificates as required during a system update.

- Added a safeguard to prevent expiration of internal secrets by forcing internal secrets rotation in case a critical alert on expiring secrets is ignored. This should not be relied on as a regular operating procedure. Secrets rotation should be planned during a maintenance window. For more information, see [Azure Stack secret rotation](azure-stack-rotate-secrets.md).

- Visual Studio Code is now supported with Azure Stack deployment using AD FS.

### <a name="improvements-1906"></a>Improvements

<!-- Changes and product improvements with tangible customer-facing value. -->

- The **Get-GraphApplication** cmdlet in the privileged endpoint now displays the thumbprint of the currently used certificate. This improves the certificate management for service principals when Azure Stack is deployed with AD FS.

- New health monitoring rules have been added to validate the availability of AD Graph and AD FS, including the ability to raise alerts.

- Improvements to the reliability of the backup resource provider when the infrastructure backup service moves to another instance.

- Performance optimization of external secret rotation procedure to provide a uniform execution time to facilitate scheduling of maintenance window.

- The **Test-AzureStack** cmdlet now reports on internal secrets that are about to expire (critical alerts).

- A new parameter is available for the **Register-CustomAdfs** cmdlet in the privileged endpoint that enables skipping the certificate revocation list checking when configuring the federation trust for AD FS.

- The 1906 release introduces greater visibility into update progress, so you can be assured that updates are not pausing. This results in an increase in the total number of update steps shown to operators in the **Update** blade. You might also notice more update steps happening in parallel than in previous updates.

#### <a name="networking-updates-1906"></a>Networking updates

- Updated lease time set in DHCP responder to be consistent with Azure.

- Improved retry rates to the resource provider in the scenario of failed deployment of resources.

- Removed the **Standard** SKU option from both the load balancer and public IP, as that is currently not supported.

### <a name="changes-1906"></a>Changes

- Creating a storage account experience is now consistent with Azure.

- Changed alert triggers for expiration of internal secrets:
  - Warning alerts are now raised 90 days prior to the expiration of secrets.
  - Critical alerts are now raised 30 days prior to the expiration of secrets.

- Updated strings in infrastructure backup resource provider for consistent terminology.

### <a name="fixes-1906"></a>Fixes

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

## <a name="security-updates-1906"></a>Security updates

For information about security updates in this update of Azure Stack, see [Azure Stack security updates](release-notes-security-updates.md).

## <a name="update-planning-1906"></a>Update planning

Before applying the update, make sure to review the following information:

- [Known issues](known-issues.md)
- [Security updates](release-notes-security-updates.md)
- [Checklist of activities before and after applying the update](release-notes-checklist.md)

## <a name="download-the-update-1906"></a>Download the update

You can download the Azure Stack 1906 update package from [the Azure Stack download page](https://aka.ms/azurestackupdatedownload).

## <a name="hotfixes-1906"></a>Hotfixes

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

::: moniker range="azs-1905"
## 1905 build reference

The Azure Stack 1905 update build number is **1.1905.0.40**.

### <a name="update-type-1905"></a>Update type

The Azure Stack 1905 update build type is **Full**. As a result, the 1905 update has a longer runtime than express updates like 1903 and 1904. Exact runtimes for full updates typically depend on the number of nodes that your Azure Stack instance contains, the capacity used on your system by tenant workloads, your system's network connectivity (if connected to the internet), and your system hardware configuration. The 1905 update has had the following expected runtimes in our internal testing: 4 nodes - 35 hours, 8 nodes - 45 hours, 12 nodes - 55 hours, 16 nodes - 70 hours. 1905 runtimes lasting longer than these expected values are not uncommon and do not require action by Azure Stack operators unless the update fails. For more information about update build types, see [Manage updates in Azure Stack](azure-stack-updates.md).

## <a name="whats-in-this-update-1905"></a>What's in this update

<!-- The current theme (if any) of this release. -->

<!-- What's new, also net new experiences and features. -->

- With this update, the update engine in Azure Stack can update the firmware of scale unit nodes. This requires a compliant update package from the hardware partners. Reach out to your hardware partner for details about availability.

- Windows Server 2019 is now supported and available to syndicate through the Azure Stack Marketplace.
With this update, Windows Server 2019 can now be successfully activated on a 2016 host.

- A new [Azure Account Visual Studio Code extension](../user/azure-stack-dev-start-vscode-azure.md) allows developers to target Azure Stack by logging in and viewing subscriptions, as well as a number of other services. The Azure Account extension works on both Azure Active Directory (Azure AD) and AD FS environments, and only requires a small change in Visual Studio Code user settings. Visual Studio Code requires a service principal to be given permission in order to run on this environment. To do so, import the identity script and run the cmdlets specified in [Multi-tenancy in Azure Stack](../operator/azure-stack-enable-multitenancy.md). This requires an update to the home directory, and registration of the Guest tenant directory for each directory. An alert is displayed after updating to 1905 or later, to update the home directory tenant for which the Visual Studio Code service principal is included. 

### <a name="improvements-1905"></a>Improvements

<!-- Changes and product improvements with tangible customer-facing value. -->
- As a part of enforcing TLS 1.2 on Azure Stack, the following extensions have been updated to these versions:

  - microsoft.customscriptextension-arm-1.9.3
  - microsoft.iaasdiagnostics-1.12.2.2
  - microsoft.antimalware-windows-arm-1.5.5.9
  - microsoft.dsc-arm-2.77.0.0
  - microsoft.vmaccessforlinux-1.5.2

  Please download these versions of the extensions immediately, so that new deployments of the extension do not fail when TLS 1.2 is enforced in a future release. Always set **autoUpgradeMinorVersion=true** so that minor version updates to extensions (for example, 1.8 to 1.9) are automatically performed.

- A new **Help and Support Overview** in the Azure Stack portal makes it easier for operators to check their support options, get expert help, and learn more about Azure Stack. On integrated systems, creating a support request will preselect Azure Stack service. We highly recommend that customers use this experience to submit tickets rather than using the global Azure portal. For more information, see [Azure Stack Help and Support](azure-stack-help-and-support-overview.md).

- When multiple Azure Active Directories are onboarded (through [this process](azure-stack-enable-multitenancy.md)), it is possible to neglect rerunning the script when certain updates occur, or when changes to the Azure AD Service Principal authorization cause rights to be missing. This can cause various issues, from blocked access for certain features, to more discrete failures which are hard to trace back to the original issue. To prevent this, 1905 introduces a new feature that checks for these permissions and creates an alert when certain configuration issues are found. This validation runs every hour, and displays the remediation actions required to fix the issue. The alert closes once all the tenants are in a healthy state.

- Improved reliability of infrastructure backup operations during service failover.

- A new version of the [Azure Stack Nagios plugin](azure-stack-integrate-monitor.md#integrate-with-nagios) is available that uses the [Azure Active Directory authentication libraries](/azure/active-directory/develop/active-directory-authentication-libraries) (ADAL) for authentication. The plugin now also supports Azure AD and Active Directory Federation Services (AD FS) deployments of Azure Stack. For more information, see the [Nagios plugin exchange](https://exchange.nagios.org/directory/Plugins/Cloud/Monitoring-AzureStack-Alerts/details) site.

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
  
### <a name="changes-1905"></a>Changes

- To increase reliability and availability during planned and unplanned maintenance scenarios, Azure Stack adds an additional infrastructure role instance for domain services.

- With this update, during repair and add node operations, the hardware is validated to ensure homogenous scale unit nodes within a scale unit.

- If scheduled backups are failing to complete and the defined retention period is exceeded, the infrastructure backup controller will ensure at least one successful backup is retained. 

### <a name="fixes-1905"></a>Fixes

<!-- Product fixes that came up from customer deployments worth highlighting, especially if there is an SR/ICM associated to it. -->

- Fixed an issue in which a **Compute host agent** warning appeared after restarting a node in the scale unit.

- Fixed issues in marketplace management in the administrator portal which showed incorrect results when filters were applied, and showed duplicate publisher names in the publisher filter. Also made performance improvements to display results faster.

- Fixed issue in the available backup blade that listed a new available backup before it completed upload to the external storage location. Now the available backup will show in the list after it is successfully uploaded to the storage location. 

<!-- ICM: 114819337; Task: 4408136 -->
- Fixed issue with retrieving recovery keys during backup operation. 

<!-- Bug: 4525587 -->
- Fixed issue with OEM update displaying version as 'undefined' in operator portal.

### <a name="security-updates-1905"></a>Security updates

For information about security updates in this update of Azure Stack, see [Azure Stack security updates](release-notes-security-updates.md).

## <a name="update-planning-1905"></a>Update planning

Before applying the update, make sure to review the following information:

- [Known issues](known-issues.md)
- [Security updates](release-notes-security-updates.md)
- [Checklist of activities before and after applying the update](release-notes-checklist.md)

## <a name="download-the-update-1905"></a>Download the update

You can download the Azure Stack 1905 update package from [the Azure Stack download page](https://aka.ms/azurestackupdatedownload). When using the downloader tool, be sure to use the latest version and not a cached copy from your downloads directory.

## <a name="hotfixes-1905"></a>Hotfixes

Azure Stack releases hotfixes on a regular basis. Be sure to install the latest Azure Stack hotfix for 1904 before updating Azure Stack to 1905.

Azure Stack hotfixes are only applicable to Azure Stack integrated systems; do not attempt to install hotfixes on the ASDK.

### Before applying the 1905 update

The 1905 release of Azure Stack must be applied on the 1904 release with the following hotfixes:

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack hotfix 1.1904.4.45](https://support.microsoft.com/help/4505688)

### After successfully applying the 1905 update

After the installation of this update, install any applicable hotfixes. For more information, see our [servicing policy](azure-stack-servicing-policy.md).

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack hotfix 1.1905.3.48](https://support.microsoft.com/help/4510078)
::: moniker-end

::: moniker range=">=azs-1905"
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

::: moniker range="<azs-1905"
You can access [older versions of Azure Stack release notes on the TechNet Gallery](https://aka.ms/azsarchivedrelnotes). These archived documents are provided for reference purposes only and do not imply support for these versions. For information about Azure Stack support, see [Azure Stack servicing policy](azure-stack-servicing-policy.md). For further assistance, contact Microsoft Customer Support Services.
::: moniker-end


