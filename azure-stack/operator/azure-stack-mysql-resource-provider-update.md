---
title: Update the MySQL resource provider in Azure Stack Hub 
description: Learn how to update the Azure Stack Hub MySQL resource provider in Azure Stack Hub. 
author: sethmanheim
ms.topic: article 
ms.date: 9/22/2020
ms.author: sethm
ms.reviewer: jiadu
ms.lastreviewed: 09/26/2021

# Intent: As an Azure Stack operator, I want to update the Azure Stack MySQL resource provider.
# Keyword: azure stack update mysql resource provider

---

# Update the MySQL resource provider in Azure Stack Hub

[!INCLUDE [preview-banner](../includes/sql-mysql-rp-limit-access.md)]

> [!IMPORTANT]
> Before updating the resource provider, review the release notes to learn about new functionality, fixes, and any known issues that could affect your deployment. The release notes also specify the minimum Azure Stack Hub version required for the resource provider.

> [!IMPORTANT]
> Updating the resource provider will NOT update the hosting MySQL Server. 

When Azure Stack Hub releases a new build, we may release A new MySQL resource provider adapter. While the existing adapter continues to work, we recommend updating to the latest build as soon as possible.

  |Supported Azure Stack Hub version|MySQL RP version|Windows Server that RP service is running on
  |-----|-----|-----|
   |2206, 2301|MySQL RP version 2.0.13.x|Microsoft AzureStack Add-on RP Windows Server 1.2009.0
  |2108,2206|MySQL RP version 2.0.6.x|Microsoft AzureStack Add-on RP Windows Server 1.2009.0
  |2108, 2102, 2008, 2005|[MySQL RP version 1.1.93.5](https://aka.ms/azshmysqlrp11935)|Microsoft AzureStack Add-on RP Windows Server
  |2005, 2002, 1910|[MySQL RP version 1.1.47.0](https://aka.ms/azurestackmysqlrp11470)|Windows Server 2016 Datacenter - Server Core|
  |1908|[MySQL RP version 1.1.33.0](https://aka.ms/azurestackmysqlrp11330)|Windows Server 2016 Datacenter - Server Core|
  |     |     |     |

## Update MySQL Server resource provider V2

If you have already deployed MySQL RP V2, and want to check for updates, check [How to apply updates to resource provider](resource-provider-apply-updates.md).

If you want to update from MySQL RP V1 to MySQL RP V2, make sure you have first updated to MySQL RP V1.1.93.x, then apply the major version upgrade process to upgrade from MySQl RP V1 to MySQL RP V2.

## Update from MySQL RP V1.1.93.x to MySQL RP V2.0.6.0

### Prerequisites

1. Make sure you have updated MySQL RP V1 to the latest 1.1.93.x. Under Default Provider Subscription, find the RP resource group (naming format: system.`<region`>.mysqladapter). Confirm the version tag and MySQL RP VM name in resource group.

2. [Open a support case](../operator/azure-stack-help-and-support-overview.md) to get the MajorVersionUpgrade package, and add your subscription to the ASH marketplace allowlist for the future V2 version.

3. Download Microsoft AzureStack Add-On RP Windows Server 1.2009.0 to marketplace. 

4. Ensure your Azure Stack Hub meets the datacenter integration prerequisites.

   |Prerequisite|Reference|
   |-----|-----|
   |Conditional DNS forwarding is set correctly.|[Azure Stack Hub datacenter integration - DNS](azure-stack-integrate-dns.md)|
   |Inbound ports for resource providers are open.|[Azure Stack Hub datacenter integration - Ports and protocols inbound](azure-stack-integrate-endpoints.md#ports-and-protocols-inbound)|
   |PKI certificate subject and SAN are set correctly.|[Azure Stack Hub deployment mandatory PKI prerequisites](azure-stack-pki-certs.md)<br>[Azure Stack Hub deployment PaaS certificate prerequisites](azure-stack-pki-certs.md)|
   |     |     |

5. (for disconnected environment) Install the required PowerShell modules, similar to the update process used to [Deploy the MySQL resource provider](./azure-stack-mysql-resource-provider-deploy.md).

6. Prepare the MySQL Connector Uri with the required version. For details, refer to [Deploy the MySQL resource provider](./azure-stack-mysql-resource-provider-deploy.md). 
e.g. https://\<storageAcountName\>.blob.\<region\>.\<FQDN\>/\<containerName\>/mysql-connector-net-8.0.21.msi

### Trigger MajorVersionUpgrade
Run the following script from an elevated PowerShell console to perform major version upgrade. 

> [!NOTE]
> Make sure the client machine that you run the script on is of OS version no older than Windows 10 or Windows Server 2016, and the client machine has X64 Operating System Architecture.

> [!IMPORTANT]
> We strongly recommend using **Clear-AzureRmContext -Scope CurrentUser** and **Clear-AzureRmContext -Scope Process** to clear the cache before running the deployment or update script.


``` powershell
# Check Operating System version
$osVersion = [environment]::OSVersion.Version
if ($osVersion.Build -lt 10240)
{
    Write-Host "OS version is too old: $osVersion."
    return
}

$osArch = (Get-WmiObject Win32_OperatingSystem).OSArchitecture
if ($osArch -ne "64-bit")
{
    Write-Host "OS Architecture is not 64 bit."
    return
}

# Check LongPathsEnabled registry key
$regPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem'
$longPathsEnabled = 'LongPathsEnabled'
$property = Get-ItemProperty -Path $regPath -Name $longPathsEnabled -ErrorAction Stop
if ($property.LongPathsEnabled -eq 0)
{
    Write-Host "Detect LongPathsEnabled equals to 0, prepare to set the property."
    Set-ItemProperty -Path $regPath -Name $longPathsEnabled -Value 1 -ErrorAction Stop
    Write-Host "Set the long paths property, please restart the PowerShell."
    return
} 

# Use the NetBIOS name for the Azure Stack Hub domain. 
$domain = "YouDomain" 
# For integrated systems, use the IP address of one of the ERCS VMs
$privilegedEndpoint = "YouDomain-ERCS01"
# Provide the Azure environment used for deploying Azure Stack Hub. Required only for Azure AD deployments. Supported values for the <environment name> parameter are AzureCloud, AzureChinaCloud, or AzureUSGovernment depending which Azure subscription you're using.
$AzureEnvironment = "AzureCloud"
# Point to the directory where the resource provider installation files were extracted.
$tempDir = 'C:\extracted-folder\MajorVersionUpgrade-MySQLRP'
# The service admin account can be Azure Active Directory or Active Directory Federation Services.
$serviceAdmin = "admin@mydomain.onmicrosoft.com"
$AdminPass = ConvertTo-SecureString 'xxxxxxxx' -AsPlainText -Force
$AdminCreds = New-Object System.Management.Automation.PSCredential ($serviceAdmin, $AdminPass)
# Add the cloudadmin credential that's required for privileged endpoint access.
$CloudAdminPass = ConvertTo-SecureString 'xxxxxxxx' -AsPlainText -Force
$CloudAdminCreds = New-Object System.Management.Automation.PSCredential ("$domain\cloudadmin", $CloudAdminPass)
# Change the following as appropriate.
$PfxPass = ConvertTo-SecureString 'xxxxxxx' -AsPlainText -Force
# Provide the pfx file path
$PfxFilePath = "C:\tools\mysqlcert\SSL.pfx"
# Local blob uri where stores the required mysql connector
$MySQLConnector = "Provide the MySQL Connector Uri according to Prerequisites step."
# PowerShell modules used by the RP MajorVersionUpgrade are placed in C:\Program Files\SqlMySqlPsh
# The deployment script adds this path to the system $env:PSModulePath to ensure correct modules are used.
$rpModulePath = Join-Path -Path $env:ProgramFiles -ChildPath 'SqlMySqlPsh'
$env:PSModulePath = $env:PSModulePath + ";" + $rpModulePath 
. $tempDir\MajorVersionUpgradeMySQLProvider.ps1 -AzureEnvironment $AzureEnvironment -AzCredential $AdminCreds -CloudAdminCredential $CloudAdminCreds -Privilegedendpoint $privilegedEndpoint -PfxPassword $PfxPass -PfxCert $PfxFilePath -MySQLConnector $MySQLConnector

```

> [!NOTE] 
> The DNS address and the corresponding IP address of MySQL RP V2 are different. To get the new public IP, you can contact support to require a DRP break glass and find the MySQLRPVM1130-PublicIP resource. You can also run "nslookup mysqlrp.dbadapter.\<fqdn\>" from a client machine that already passed the endpoint test to find out the public IP.

### Validate the upgrade is successful

1.	The MajorVersionUpgrade script executed without any errors.
2.	Check the resource provider in marketplace and make sure that MySQL RP 2.0 has been installed successfully.
3.  The old **system.\<location\>.mysqladapter** resource group and **system.\<location\>.dbadapter.dns** resource group in the default provider subscription will not be automatically deleted by the script. 
* We recommend keeping the Storage Account and the Key Vault in the mysqladapter resource group for some time. If after the upgrade, any tenant user observes inconsistent database or login metadata, it is possible to get support to restore the metadata from the resource group.
* After verifying that the DNS Zone in the dbadapter.dns resource group is empty with no DNS record, it is safe to delete the dbadapter.dns resource group.
* [IMPORTANT] Do not use the V1 deploy script to uninstall the V1 version. After upgrade completed and confirmation that the upgrade was successful, you can manually delete the resource group from the provider subscription.

## Update from MySQL RP V1 earlier version to MySQL RP V1.1.93.x

MySQL resource provider V1 update is cumulative. You can directly update to the 1.1.93.x version. 

To update the resource provider to 1.1.93.x, use the **UpdateMySQLProvider.ps1** script. Use your service account with local administrative rights and is an **owner** of the subscription. This update script is included with the download of the resource provider. 

To update the resource provider, you use the **UpdateMySQLProvider.ps1** script. Use your service account with local administrative rights and is an **owner** of the subscription. The update script is included with the download of the resource provider. 

The update process is similar to the process used to [Deploy the resource provider](./azure-stack-mysql-resource-provider-deploy.md). The update script uses the same arguments as the DeployMySqlProvider.ps1 script, and you'll need to provide certificate information.

### Update script processes

The **UpdateMySQLProvider.ps1** script creates a new virtual machine (VM) with the latest OS image, deploy the latest resource provider code, and migrates the settings from the old resource provider to the new resource provider.

>[!NOTE]
>We recommend that you download the Microsoft AzureStack Add-on RP Windows Server 1.2009.0 image from Marketplace Management. If you need to install an update, you can place a **single** MSU package in the local dependency path. The script will fail if there's more than one MSU file in this location.

After the *UpdateMySQLProvider.ps1* script creates a new VM, the script migrates the following settings from the old resource provider VM:

* database information
* hosting server information
* required DNS record

> [!IMPORTANT]
> We strongly recommend using **Clear-AzureRmContext -Scope CurrentUser** and **Clear-AzureRmContext -Scope Process** to clear the cache before running the deployment or update script.

## Update script parameters 
Specify the following parameters from the command line when you run the **UpdateMySQLProvider.ps1** PowerShell script. If you don't, or if any parameter validation fails, you're prompted to provide the required parameters.

| Parameter Name | Description | Comment or default value | 
| --- | --- | --- | 
| **CloudAdminCredential** | The credential for the cloud admin, necessary for accessing the privileged endpoint. | _Required_ | 
| **AzCredential** | The credentials for the Azure Stack Hub service admin account. Use the same credentials that you used for deploying Azure Stack Hub. The script will fail if the account you use with AzCredential requires multi-factor authentication (MFA). | _Required_ | 
| **VMLocalCredential** |The credentials for the local admin account of the MySQL resource provider VM. | _Required_ | 
| **PrivilegedEndpoint** | The IP address or DNS name of the privileged endpoint. |  _Required_ | 
| **AzureEnvironment** | The Azure environment of the service admin account used for deploying Azure Stack Hub. Required only for Microsoft Entra deployments. Supported environment names are **AzureCloud**, **AzureUSGovernment**, or if using a China Microsoft Entra ID, **AzureChinaCloud**. | AzureCloud |
| **DependencyFilesLocalPath** | Your certificate .pfx file must be placed in this directory as well. | _Optional_ (_mandatory_ for multi-node) | 
| **DefaultSSLCertificatePassword** | The password for the .pfx certificate. | _Required_ | 
| **MaxRetryCount** | The number of times you want to retry each operation if there's a failure.| 2 | 
| **RetryDuration** | The timeout interval between retries, in seconds. | 120 | 
| **Uninstall** | Remove the resource provider and all associated resources (see the following notes). | No | 
| **DebugMode** | Prevents automatic cleanup on failure. | No | 
| **AcceptLicense** | Skips the prompt to accept the GPL license.  (https://www.gnu.org/licenses/old-licenses/gpl-2.0.html) | | 

### Update script example

If you are updating the MySQL resource provider version to 1.1.33.0 or previous versions, you need to install specific versions of AzureRm.BootStrapper and Azure Stack Hub modules in PowerShell. 

If you are updating the MySQL resource provider to version 1.1.47.0 or later, you can skip this step. The deployment script will automatically download and install the necessary PowerShell modules for you to path C:\Program Files\SqlMySqlPsh. 

>[!NOTE]
>If folder C:\Program Files\SqlMySqlPsh already exists with PowerShell module downloaded, it is recommended to clean up this folder before running the update script. This is to make sure the right version of PowerShell module is downloaded and used.

```powershell 
# Run the following scripts when updating to version 1.1.33.0 only.
# Install the AzureRM.Bootstrapper module, set the profile and install the AzureStack module.
# Note that this might not be the most currently available version of Azure Stack Hub PowerShell.
Install-Module -Name AzureRm.BootStrapper -Force
Use-AzureRmProfile -Profile 2018-03-01-hybrid -Force
Install-Module -Name AzureStack -RequiredVersion 1.6.0
```

> [!NOTE]
> In disconnected scenario, you need to download the required PowerShell modules and register the repository manually as a prerequisite. You can get more information in [Deploy MySQL resource provider](azure-stack-mysql-resource-provider-deploy.md)

The following example shows the *UpdateMySQLProvider.ps1* script that you can run from an elevated PowerShell console. Be sure to change the variable information and passwords as needed:

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
$AdminPass = ConvertTo-SecureString 'P@ssw0rd1' -AsPlainText -Force 
$AdminCreds = New-Object System.Management.Automation.PSCredential ($serviceAdmin, $AdminPass) 
 
# Set credentials for the new resource provider VM.
$vmLocalAdminPass = ConvertTo-SecureString 'P@ssw0rd1' -AsPlainText -Force 
$vmLocalAdminCreds = New-Object System.Management.Automation.PSCredential ("mysqlrpadmin", $vmLocalAdminPass) 
 
# And the cloudadmin credential required for privileged endpoint access.
$CloudAdminPass = ConvertTo-SecureString 'P@ssw0rd1' -AsPlainText -Force 
$CloudAdminCreds = New-Object System.Management.Automation.PSCredential ("$domain\cloudadmin", $CloudAdminPass) 

# Change the following as appropriate.
$PfxPass = ConvertTo-SecureString 'P@ssw0rd1' -AsPlainText -Force 

# For version 1.1.47.0 or later, the PowerShell modules used by the RP deployment are placed in C:\Program Files\SqlMySqlPsh
# The deployment script adds this path to the system $env:PSModulePath to ensure correct modules are used.
$rpModulePath = Join-Path -Path $env:ProgramFiles -ChildPath 'SqlMySqlPsh'
$env:PSModulePath = $env:PSModulePath + ";" + $rpModulePath 

# Change directory to the folder where you extracted the installation files.
# Then adjust the endpoints.
.$tempDir\UpdateMySQLProvider.ps1 -AzCredential $AdminCreds -VMLocalCredential $vmLocalAdminCreds -CloudAdminCredential $cloudAdminCreds -PrivilegedEndpoint $privilegedEndpoint -AzureEnvironment $AzureEnvironment -DefaultSSLCertificatePassword $PfxPass -DependencyFilesLocalPath $tempDir\cert -AcceptLicense
```  

When the resource provider update script finishes, close the current PowerShell session.

## Next steps

[Maintain MySQL resource provider](azure-stack-mysql-resource-provider-maintain.md)
