---
title: Install PowerShell Az module for Azure Stack Hub 
description: Learn how to install PowerShell for Azure Stack Hub.
author: sethmanheim
ms.topic: install-set-up-deploy
ms.custom: linux-related-content
ms.date: 05/08/2025
ms.author: sethm
ms.lastreviewed:  12/6/2021

# Intent: As an Azure Stack operator, I want to install Powershell Az for Azure Stack.
# Keyword: install powershell azure stack Az
---

# Install PowerShell Az and Azure Stack modules for Azure Stack Hub

> [!IMPORTANT]  
> All versions of the Azure Resource Manager (AzureRM) PowerShell module are outdated and out of support. The **Az** PowerShell module is now the recommended PowerShell module for interacting with Azure and Azure Stack Hub. This article describes how to get started with the Az PowerShell module. For information about how to migrate to the Az PowerShell module, see [Migrate from AzureRM to Azure PowerShell Az in Azure Stack Hub](migrate-azurerm-az.md). For details about the increased functionality of the Az modules, which have been adopted across global Azure, see [Introducing the Azure Az PowerShell module](/powershell/azure/new-azureps-module-az).

| Azure Stack Hub Version | AzureStack PowerShell version |
| --- | --- |
| 2102 | 2.1.1 |
| 2108 | 2.2.0 |
| 2206 | 2.3.0 |
| 2301+ | 2.4.0 |

For more information about AzureStack modules, see the [PSGallery](https://www.powershellgallery.com/packages/AzureStack).

This article explains how to install the Azure PowerShell Az and compatible Azure Stack Hub administrator modules using **PowerShellGet**. You can install the Az modules on Windows, macOS, and Linux platforms.

You can also run the Az modules for Azure Stack Hub in a Docker container. For instructions, see [Use Docker to run PowerShell for Azure Stack Hub](../user/azure-stack-powershell-user-docker.md).

You can use *API profiles* to specify the compatible endpoints for the Azure Stack Hub resource providers. API profiles provide a way to manage version differences between Azure and Azure Stack Hub. An API version profile is a set of Azure Resource Manager PowerShell modules with specific API versions. Each cloud platform has a set of supported API version profiles. For example, Azure Stack Hub supports a specific profile version such as [**2020-09-01-hybrid**](../user/azure-stack-profiles-azure-resource-manager-versions.md). When you install a profile, the Azure Resource Manager PowerShell modules that correspond to the specified profile are installed.

You can install Azure Stack Hub compatible PowerShell Az modules in Internet-connected, partially connected, or disconnected scenarios. This article walks you through the detailed instructions for these scenarios.

## Verify your prerequisites

Az modules are supported on Azure Stack Hub with update 2002 or later, and with all current hotfixes installed. See the [Azure Stack Hub release notes](release-notes.md) for more information.

The Azure PowerShell Az modules work with PowerShell 5.1 or higher on Windows, or PowerShell Core 6.x and later on all platforms. You should install the [latest version of PowerShell Core](/powershell/scripting/install/installing-powershell#powershell-core) available for your operating system. Azure PowerShell has no other requirements when run on PowerShell Core.

To check your PowerShell version, run the following command:

```powershell  
$PSVersionTable.PSVersion
```

### Prerequisites for Windows

To use Azure PowerShell in PowerShell 5.1 on Windows:

1. Update to
   [Windows PowerShell 5.1](/powershell/scripting/windows-powershell/install/installing-windows-powershell#upgrading-existing-windows-powershell)
   if needed. If you're on Windows 10, you already have PowerShell 5.1 installed.
1. Install [.NET Framework 4.7.2 or later](/dotnet/framework/install).
1. Make sure you have the latest version of PowerShellGet. Run the following cmdlets from an elevated prompt:

   ```powershell  
   [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

   powershell -noprofile
   $PSVersionTable
   Uninstall-Module PowershellGet -AllVersions -Force -Confirm:$false
   Get-module PowershellGet
   Find-module PowershellGet
   Install-Module PowershellGet -MinimumVersion 2.2.3 -Force
   ```

### Prerequisites for Linux and Mac

PowerShell Core 6.x or later version is needed. Follow the [link](/powershell/scripting/install/installing-powershell-core-on-windows) for instructions.

### Uninstall existing versions of the Azure Stack Hub PowerShell modules

Before you install the required version, make sure that you uninstall any previously installed Azure Stack Hub Azure Resource Manager or Az PowerShell modules. Uninstall the modules using one of the following two methods:

- To uninstall the existing Azure Resource Manager and Az PowerShell modules, close all the active PowerShell sessions, and run the following cmdlets:

  ```powershell
  Get-Module -Name Azure* -ListAvailable | Uninstall-Module -Force -Verbose -ErrorAction Continue
  Get-Module -Name Azs.* -ListAvailable | Uninstall-Module -Force -Verbose -ErrorAction Continue
  Get-Module -Name Az.* -ListAvailable | Uninstall-Module -Force -Verbose -ErrorAction Continue
  ```

  If you encounter an error such as "The module is already in use," close the PowerShell sessions that use the modules and rerun these cmdlets.

- If `Uninstall-Module` didn't succeed, delete all the folders that start with **Azure**, **Az**, or **Azs** from the `$env:PSModulePath` locations. For Windows PowerShell, the locations might be `C:\Program Files\WindowsPowerShell\Modules` and `C:\Users\{yourusername}\Documents\WindowsPowerShell\Modules`. For PowerShell Core, the locations might be `C:\Program Files\PowerShell\7\Modules` and `C:\Users\{yourusername}\Documents\PowerShell\Modules`. Deleting these folders removes any existing Azure PowerShell modules.

## Connected: install with internet connectivity

The Azure Stack Az module works with PowerShell 5.1 or greater on a Windows machine, or PowerShell 6.x or greater on a Linux or macOS platform. Using the PowerShellGet cmdlets is the preferred installation method. This method works the same way on the supported platforms.

1. Run the following command from a PowerShell session to update PowerShellGet to a minimum of version 2.2.3:

   ```powershell  
   [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
   Install-Module PowerShellGet -MinimumVersion 2.2.3 -Force
   ```

1. Close your PowerShell session, then open a new PowerShell session so that the update can take effect.
1. Run the following commands to install Az modules:

   ```powershell
   [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
   Install-Module -Name Az.BootStrapper -Force
   Install-AzProfile -Profile 2020-09-01-hybrid -Force
   ```

1. Install the AzureStack PowerShell modules:

   ::: moniker range=">azs-2206"
   ```powershell
   Install-Module -Name AzureStack -RequiredVersion 2.4.0
   ```
   ::: moniker-end

   ::: moniker range=">azs-2108 <=azs-2206"
   ```powershell
   Install-Module -Name AzureStack -RequiredVersion 2.3.0
   ```
   ::: moniker-end

   ::: moniker range=">azs-2102 <=azs-2108"
   ```powershell
   Install-Module -Name AzureStack -RequiredVersion 2.2.0
   ```
   ::: moniker-end

   ::: moniker range="<=azs-2102"
   ```powershell
   Install-Module -Name AzureStack -RequiredVersion 2.1.1
   ```
   ::: moniker-end

## Disconnected: Install without internet connection

In a disconnected scenario, you first download the PowerShell modules to a machine that has internet connectivity. Then, you transfer them to the Azure Stack Development Kit (ASDK) for installation.

Sign in to a computer with internet connectivity and use the following scripts to download the Azure Resource Manager and Azure Stack Hub packages, depending on your version of Azure Stack Hub.

Installation has five steps:

1. Install Azure Stack Hub PowerShell on a connected machine.
1. Enable additional storage features.
1. Transport the PowerShell packages to your disconnected workstation.
1. Manually bootstrap the NuGet provider on your disconnected workstation.
1. Confirm the installation of PowerShell.

### Install Azure Stack Hub PowerShell

1. The following code installs Az modules from the [trustworthy online repository](https://www.powershellgallery.com/):

   ```powershell
   [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
   Install-module -Name PowerShellGet -MinimumVersion 2.2.3 -Force
   Import-Module -Name PackageManagement -ErrorAction Stop
   $savedModulesPath = "<Path that is used to save the packages>"
   Save-Package -ProviderName NuGet -Source https://www.powershellgallery.com/api/v2 -Name Az -Path $savedModulesPath -Force -RequiredVersion 2.0.1
   ```

1. After the Az modules are installed, proceed with installing the AzureStack modules:

   ::: moniker range=">azs-2206"
   ```powershell
   Save-Package -ProviderName NuGet -Source https://www.powershellgallery.com/api/v2 -Name AzureStack -Path $savedModulesPath -Force -RequiredVersion 2.4.0
   ```
   ::: moniker-end

   ::: moniker range=">azs-2108 <=azs-2206"
   ```powershell
   Save-Package -ProviderName NuGet -Source https://www.powershellgallery.com/api/v2 -Name AzureStack -Path $savedModulesPath -Force -RequiredVersion 2.3.0
   ```
   ::: moniker-end

   ::: moniker range=">azs-2102 <=azs-2108"
   ```powershell
   Save-Package -ProviderName NuGet -Source https://www.powershellgallery.com/api/v2 -Name AzureStack -Path $savedModulesPath -Force -RequiredVersion 2.2.0
   ```
   ::: moniker-end

   ::: moniker range="<=azs-2102"
   ```powershell
   Save-Package -ProviderName NuGet -Source https://www.powershellgallery.com/api/v2 -Name AzureStack -Path $savedModulesPath -Force -RequiredVersion 2.1.1
   ```
   ::: moniker-end

> [!NOTE]  
> On machines without an internet connection, we recommend that you run the Disable-`AzDataCollection` cmdlet to disable the telemetry data collection. Otherwise, you might experience a performance degradation of the cmdlets. This is applicable only for machines without an internet connection.

### Add your packages to your workstation

1. Copy the downloaded packages to a USB device.
1. Sign in to the disconnected workstation and copy the packages from the USB device to a location on the workstation.
1. Manually bootstrap the NuGet provider on your disconnected workstation. For instructions, see [Manually bootstrapping the NuGet provider on a machine that isn't connected to the internet](/powershell/scripting/gallery/how-to/getting-support/bootstrapping-nuget#manually-bootstrapping-the-nuget-provider-on-a-machine-that-is-not-connected-to-the-internet).
1. Register this location as the default repository and install the `AzureRM` and `AzureStack` modules from this repository:

   ```powershell
    # requires -Version 5
    # requires -RunAsAdministrator
    # requires -Module PowerShellGet
    # requires -Module PackageManagement

    $SourceLocation = "<Location on the development kit that contains the PowerShell packages>"
    $RepoName = "MyNuGetSource"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Register-PSRepository -Name $RepoName -SourceLocation $SourceLocation -InstallationPolicy Trusted
    ```

1. Install the Az modules.

   ```powershell
    Install-Module -Name Az -Repository $RepoName -RequiredVersion 2.0.1 -Scope AllUsers
   ```

1. Install the AzureStack modulesL

   ::: moniker range=">azs-2206"
   ```powershell
   Install-Module -Name AzureStack -Repository $RepoName -RequiredVersion 2.4.0 -Scope AllUsers
   ```
   ::: moniker-end

   ::: moniker range=">azs-2108 <=azs-2206"
   ```powershell
   Install-Module -Name AzureStack -Repository $RepoName -RequiredVersion 2.3.0 -Scope AllUsers
   ```
   ::: moniker-end

   ::: moniker range=">azs-2102 <=azs-2108"
   ```powershell
   Install-Module -Name AzureStack -Repository $RepoName -RequiredVersion 2.2.0 -Scope AllUsers
   ```
   ::: moniker-end

   ::: moniker range="<=azs-2102"
   ```powershell
   Install-Module -Name AzureStack -Repository $RepoName -RequiredVersion 2.1.1 -Scope AllUsers
   ```
   ::: moniker-end

### Confirm the installation of PowerShell

Confirm the installation by running the following command:

```powershell
Get-Module -Name "Az*" -ListAvailable
Get-Module -Name "Azs*" -ListAvailable
```

## Configure PowerShell to use a proxy server

In scenarios that require a proxy server to access the internet, you first configure PowerShell to use an existing proxy server:

1. Open an elevated PowerShell prompt.
1. Run the following commands:

   ```powershell
   #To use Windows credentials for proxy authentication
   [System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials

   #Alternatively, to prompt for separate credentials that can be used for #proxy authentication
   [System.Net.WebRequest]::DefaultWebProxy.Credentials = Get-Credential
   ```

## Use the Az module

You can still use the cmdlets and code samples based on AzureRM modules. However, you must change the name of the modules and cmdlets. The module names were changed such that `AzureRM` and Azure become `Az`, and the same for cmdlets. For example, the `AzureRM.Compute` module was renamed to `Az.Compute`.` New-AzureRMVM` is ` New-AzVM`, and `Get-AzureStorageBlob` is now `Get-AzStorageBlob`.

For a more thorough discussion and guidance for moving AzureRM scripts to Az and information about breaking changes in Azure Stack Hub's Az module, see [Migrate from AzureRM to Azure PowerShell Az](migrate-azurerm-az.md).

## Known issues

[!Include[Known issue for install - one](../includes/known-issue-az-install-1.md)]

[!Include[Known issue for install - two](../includes/known-issue-az-install-2.md)]

[!Include[Known issue for install - three](../includes/known-issue-az-install-3.md)]

[!Include[Known issue for install - four](../includes/known-issue-az-install-4.md)]

[!Include[Known issue for install - five](../includes/known-issue-az-install-5-az.md)]

### Error: "SharedTokenCacheCredential authentication failed"

- Applicable: This issue applies to all supported releases.
- Cause: A **SharedTokenCacheCredential authentication failed** error is thrown when having multiple versions of **AzAccounts** installed with Azure Stack Hub PowerShell Module version 2.1.1.
- Remediation: Remove all versions of AzAccounts and only install the supported AzAccounts version 2.2.8.
- Occurrence: Common

## Next steps

- [Download Azure Stack Hub tools from GitHub](azure-stack-powershell-download.md)
- [Configure the Azure Stack Hub user's PowerShell environment](../user/azure-stack-powershell-configure-user.md)
- [Configure the Azure Stack Hub operator's PowerShell environment](azure-stack-powershell-configure-admin.md)
- [Manage API version profiles in Azure Stack Hub](../user/azure-stack-version-profiles.md)
