---
title: Deploy MySQL resource provider on Azure Stack Hub | Microsoft Docs
description: Learn how to deploy the MySQL resource provider adapter and MySQL databases as a service on Azure Stack Hub. 
services: azure-stack 
documentationCenter: '' 
author: mattbriggs 
manager: femila 
editor: '' 
ms.service: azure-stack 
ms.workload: na 
ms.tgt_pltfrm: na 
ms.devlang: na 
ms.topic: article 
ms.date: 10/02/2019
ms.author: mabrigg
ms.reviewer: xiaofmao
ms.lastreviewed: 03/18/2019
---

# Deploy the MySQL resource provider on Azure Stack Hub

Use the MySQL Server resource provider to expose MySQL databases as an Azure Stack Hub service. The MySQL resource provider runs as a service on a Windows Server 2016 Server Core virtual machine (VM).

> [!IMPORTANT]
> Only the resource provider is supported to create items on servers that host SQL or MySQL. Items created on a host server that aren't created by the resource provider might result in a mismatched state.

## Prerequisites

There are several prerequisites that need to be in place before you can deploy the Azure Stack Hub MySQL resource provider. To meet these requirements, complete the steps in this article on a computer that can access the privileged endpoint VM.

* If you haven't already, [register Azure Stack Hub](./azure-stack-registration.md) with Azure so you can download Azure Marketplace items.

* Add the required Windows Server core VM to Azure Stack Hub Marketplace by downloading the **Windows Server 2016 Datacenter - Server Core** image.

* Download the MySQL resource provider binary and then run the self-extractor to extract the contents to a temporary directory.

  >[!NOTE]
  >To deploy the MySQL provider on a system that doesn't have internet access, copy the [mysql-connector-net-6.10.5.msi](https://dev.mysql.com/get/Downloads/Connector-Net/mysql-connector-net-6.10.5.msi) file to a local path. Provide the path name using the **DependencyFilesLocalPath** parameter.

* The resource provider has a minimum corresponding Azure Stack Hub build.

  |Minimum Azure Stack Hub version|MySQL RP version|
  |-----|-----|
  |Version 1910 (1.1910.0.58)|[MySQL RP version 1.1.47.0](https://aka.ms/azurestackmysqlrp11470)|
  |Version 1808 (1.1808.0.97)|[MySQL RP version 1.1.33.0](https://aka.ms/azurestackmysqlrp11330)|  
  |Version 1808 (1.1808.0.97)|[MySQL RP version 1.1.30.0](https://aka.ms/azurestackmysqlrp11300)|
  |Version 1804 (1.0.180513.1)|[MySQL RP version 1.1.24.0](https://aka.ms/azurestackmysqlrp11240)
  |     |     |
  
> [!IMPORTANT]
> Before deploying the MySQL resource provider version 1.1.47.0, you should have your Azure Stack Hub system upgraded to 1910 update or later versions. The MySQL resource provider version 1.1.47.0 on previous unsupported Azure Stack Hub versions doesn't work.

* Ensure datacenter integration prerequisites are met:

    |Prerequisite|Reference|
    |-----|-----|
    |Conditional DNS forwarding is set correctly.|[Azure Stack Hub datacenter integration - DNS](azure-stack-integrate-dns.md)|
    |Inbound ports for resource providers are open.|[Azure Stack Hub datacenter integration - Publish endpoints](azure-stack-integrate-endpoints.md#ports-and-protocols-inbound)|
    |PKI certificate subject and SAN are set correctly.|[Azure Stack Hub deployment mandatory PKI prerequisites](azure-stack-pki-certs.md#mandatory-certificates)[Azure Stack Hub deployment PaaS certificate prerequisites](azure-stack-pki-certs.md#optional-paas-certificates)|
    |     |     |

In a disconnected scenario, you need first use the following steps to download the required PowerShell modules and register the repository manually.

1. Sign in to a computer with internet connectivity and use the following scripts to download the PowerShell modules.

```powershell
Import-Module -Name PowerShellGet -ErrorAction Stop
Import-Module -Name PackageManagement -ErrorAction Stop

# path to save the packages, c:\temp\azs1.6.0 as an example here
$Path = "c:\temp\azs1.6.0"
Save-Package -ProviderName NuGet -Source https://www.powershellgallery.com/api/v2 -Name AzureRM -Path $Path -Force -RequiredVersion 2.3.0
Save-Package -ProviderName NuGet -Source https://www.powershellgallery.com/api/v2 -Name AzureStack -Path $Path -Force -RequiredVersion 1.6.0
```

2. Then you copy the downloaded packages to a USB device.

3. Sign in to the disconnected workstation and copy the packages from the USB device to a location on the workstation.

4. Register this location as a local repository.

```powershell
# requires -Version 5
# requires -RunAsAdministrator
# requires -Module PowerShellGet
# requires -Module PackageManagement

$SourceLocation = "C:\temp\azs1.6.0"
$RepoName = "azs1.6.0"

Register-PSRepository -Name $RepoName -SourceLocation $SourceLocation -InstallationPolicy Trusted
```

### Certificates

_For integrated systems installations only_. You must provide the SQL PaaS PKI certificate described in the optional PaaS certificates section of [Azure Stack Hub deployment PKI requirements](./azure-stack-pki-certs.md#optional-paas-certificates). Place the .pfx file in the location specified by the **DependencyFilesLocalPath** parameter. Don't provide a certificate for ASDK systems.

## Deploy the resource provider

After you've installed all the prerequisites, you can run the **DeployMySqlProvider.ps1** script to deploy the MySQL resource provider. The DeployMySqlProvider.ps1 script is extracted as part of the MySQL resource provider installation files that you downloaded for your version of Azure Stack Hub.

 > [!IMPORTANT]
 > Before deploying the resource provider, review the release notes to learn about new functionality, fixes, and any known issues that could affect your deployment.

To deploy the MySQL resource provider, open a new elevated PowerShell window (not PowerShell ISE) and change to the directory where you extracted the MySQL resource provider binary files. We recommend using a new PowerShell window to avoid potential problems caused by PowerShell modules that are already loaded.

Run the **DeployMySqlProvider.ps1** script, which completes the following tasks:

* Uploads the certificates and other artifacts to a storage account on Azure Stack Hub.
* Publishes gallery packages so that you can deploy MySQL databases using the gallery.
* Publishes a gallery package for deploying hosting servers.
* Deploys a VM using the Windows Server 2016 core image you downloaded, and then installs the MySQL resource provider.
* Registers a local DNS record that maps to your resource provider VM.
* Registers your resource provider with the local Azure Resource Manager for the operator account.

> [!NOTE]
> When the MySQL resource provider deployment starts, the **system.local.mysqladapter** resource group is created. It may take up to 75 minutes to finish the  deployments required to this resource group.

### DeployMySqlProvider.ps1 parameters

You can specify these parameters from the command line. If you don't, or if any parameter validation fails, you're prompted to provide the required parameters.

| Parameter name | Description | Comment or default value |
| --- | --- | --- |
| **CloudAdminCredential** | The credential for the cloud administrator, necessary for accessing the privileged endpoint. | _Required_ |
| **AzCredential** | The credentials for the Azure Stack Hub service admin account. Use the same credentials that you used for deploying Azure Stack Hub. | _Required_ |
| **VMLocalCredential** | The credentials for the local administrator account of the MySQL resource provider VM. | _Required_ |
| **PrivilegedEndpoint** | The IP address or DNS name of the privileged endpoint. |  _Required_ |
| **AzureEnvironment** | The Azure environment of the service admin account used for deploying Azure Stack Hub. Required only for Azure AD deployments. Supported environment names are **AzureCloud**, **AzureUSGovernment**, or if using a China Azure AD, **AzureChinaCloud**. | AzureCloud |
| **DependencyFilesLocalPath** | For integrated systems only, your certificate .pfx file must be placed in this directory. For disconnected environments, download [mysql-connector-net-6.10.5.msi](https://dev.mysql.com/get/Downloads/Connector-Net/mysql-connector-net-6.10.5.msi) to this directory. You can optionally copy one Windows Update MSU package here. | _Optional_ (_mandatory_ for integrated systems or disconnected environments) |
| **DefaultSSLCertificatePassword** | The password for the .pfx certificate. | _Required_ |
| **MaxRetryCount** | The number of times you want to retry each operation if there's a failure.| 2 |
| **RetryDuration** | The timeout interval between retries, in seconds. | 120 |
| **Uninstall** | Removes the resource provider and all associated resources (see the following notes). | No |
| **DebugMode** | Prevents automatic cleanup on failure. | No |
| **AcceptLicense** | Skips the prompt to accept the GPL license.  <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html> | |

## Deploy the MySQL resource provider using a custom script

If you are deploying the MySQL resource provider version 1.1.33.0 or previous versions, you need to install specific versions of AzureRm.BootStrapper and Azure Stack Hub modules in PowerShell. If you are deploying the MySQL resource provider version 1.1.47.0, the deployment script will automaticly download and install the necessary PowerShell modules for you to path C:\Program Files\SqlMySqlPsh.

```powershell
# Install the AzureRM.Bootstrapper module, set the profile and install the AzureStack module
# Note that this might not be the most currently available version of Azure Stack Hub PowerShell
Install-Module -Name AzureRm.BootStrapper -Force
Use-AzureRmProfile -Profile 2018-03-01-hybrid -Force
Install-Module -Name AzureStack -RequiredVersion 1.6.0
```

> [!NOTE]
> In disconnected scenario, you need to download the required PowerShell modules and register the repository manually as a prerequisite.

To eliminate any manual configuration when deploying the resource provider, you can customize the following script. Change the default account information and passwords as needed for your Azure Stack Hub deployment.

```powershell
# Use the NetBIOS name for the Azure Stack Hub domain. On the Azure Stack Hub SDK, the default is AzureStack but could have been changed at install time.
$domain = "AzureStack"  

# For integrated systems, use the IP address of one of the ERCS VMs.
$privilegedEndpoint = "AzS-ERCS01"

# Provide the Azure environment used for deploying Azure Stack Hub. Required only for Azure AD deployments. Supported environment names are AzureCloud, AzureUSGovernment, or AzureChinaCloud. 
$AzureEnvironment = "<EnvironmentName>"

# Point to the directory where the resource provider installation files were extracted.
$tempDir = 'C:\TEMP\MYSQLRP'

# The service admin account (can be Azure Active Directory or Active Directory Federation Services).
$serviceAdmin = "admin@mydomain.onmicrosoft.com"
$AdminPass = ConvertTo-SecureString "P@ssw0rd1" -AsPlainText -Force
$AdminCreds = New-Object System.Management.Automation.PSCredential ($serviceAdmin, $AdminPass)

# Set the credentials for the new resource provider VM local admin account
$vmLocalAdminPass = ConvertTo-SecureString "P@ssw0rd1" -AsPlainText -Force
$vmLocalAdminCreds = New-Object System.Management.Automation.PSCredential ("mysqlrpadmin", $vmLocalAdminPass)

# And the cloudadmin credential required for privileged endpoint access.
$CloudAdminPass = ConvertTo-SecureString "P@ssw0rd1" -AsPlainText -Force
$CloudAdminCreds = New-Object System.Management.Automation.PSCredential ("$domain\cloudadmin", $CloudAdminPass)

# Change the following as appropriate.
$PfxPass = ConvertTo-SecureString "P@ssw0rd1" -AsPlainText -Force

# For version 1.1.47.0, we install the PowerShell modules used by the RP to C:\Program Files\SqlMySqlPsh,
# add this path to the system $env:PSModulePath to make sure it can find the modules.
$rpModulePath = Join-Path -Path $env:ProgramFiles -ChildPath 'SqlMySqlPsh'
$env:PSModulePath = $env:PSModulePath + ";" + $rpModulePath

# Change to the directory folder where you extracted the installation files. Don't provide a certificate on ASDK!
. $tempDir\DeployMySQLProvider.ps1 `
    -AzCredential $AdminCreds `
    -VMLocalCredential $vmLocalAdminCreds `
    -CloudAdminCredential $cloudAdminCreds `
    -PrivilegedEndpoint $privilegedEndpoint `
    -AzureEnvironment $AzureEnvironment `
    -DefaultSSLCertificatePassword $PfxPass `
    -DependencyFilesLocalPath $tempDir\cert `
    -AcceptLicense

```

When the resource provider installation script finishes, refresh your browser to make sure you can see the latest updates.

## Verify the deployment by using the Azure Stack Hub portal

1. Sign in to the administrator portal as the service admin.
2. Select **Resource Groups**.
3. Select the **system.\<location\>.mysqladapter** resource group.
4. On the summary page for Resource group Overview, there should be no failed deployments.
5. Finally, select **Virtual machines** in the administrator portal to verify that the MySQL resource provider VM was successfully created and is running.

## Next steps

[Add hosting servers](azure-stack-mysql-resource-provider-hosting-servers.md)
