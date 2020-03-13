---
title: Install PowerShell Az module for Azure Stack Hub 
description: Learn how to install PowerShell for Azure Stack Hub.
author: mattbriggs

ms.topic: article
ms.date: 1/22/2020
ms.author: mabrigg
ms.reviewer: sijuman
ms.lastreviewed: 09/19/2019

# Intent: As an Azure Stack operator, I want to install Powershell Az for Azure Stack.
# Keyword: install powershell azure stack Az

---

# Install PowerShell Az module for Azure Stack Hub

This article explains how to install the Azure PowerShell Az modules using PowerShellGet. These instructions work on Windows, macOS, and Linux platforms.

If you would like to install PowerShell AzureRM module for Azure Stack Hub, see [Install PowerShell AzureRM module for Azure Stack Hub](azure-stack-powershell-install.md).

> [!IMPORTANT]
>  The PowerShell Az module is currently in public preview.
> This preview version is provided without a service level agreement, and it's not recommended for production workloads. Certain features might not be supported or might have constrained capabilities. 
> For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

You also need to use *API profiles* to specify the compatible endpoints for the Azure Stack Hub resource providers.
API profiles provide a way to manage version differences between Azure and Azure Stack Hub. An API version profile is a set of Azure Resource Manager PowerShell modules with specific API versions. Each cloud platform has a set of supported API version profiles. For example, Azure Stack Hub supports a specific profile version such as **2019-03-01-hybrid**. When you install a profile, the Azure Resource Manager PowerShell modules that correspond to the specified profile are installed.

You can install Azure Stack Hub compatible PowerShell Az modules in internet-connected, partially connected, or disconnected scenarios. This article walks you through the detailed instructions for these scenarios.

## 1. Verify your prerequisites

Azure PowerShell works with PowerShell 5.1 or higher on Windows, or PowerShell Core 6.x and later on all platforms. You should install the
[latest version of PowerShell Core](/powershell/scripting/install/installing-powershell#powershell-core) available for your operating system. Azure PowerShell has no additional requirements when run on PowerShell Core.

To check your PowerShell version, run the command:

```powershell  
$PSVersionTable.PSVersion
```

### Prerequisites for Windows
To use Azure PowerShell in PowerShell 5.1 on Windows:

1. Update to
   [Windows PowerShell 5.1](/powershell/scripting/install/installing-windows-powershell#upgrading-existing-windows-powershell)
   if needed. If you're on Windows 10, you already have PowerShell 5.1 installed.
2. Install [.NET Framework 4.7.2 or later](/dotnet/framework/install).
3. Make sure you have the latest version of PowerShellGet. Run `Update-Module PowerShellGet -Force`.

## 2. Validate the PowerShell Gallery accessibility

By default, the PowerShell gallery isn't configured as a trusted repository for PowerShellGet. The first time you use the PSGallery you see the following prompt:

```Output
Untrusted repository

You are installing the modules from an untrusted repository. If you trust this repository, change its InstallationPolicy value by running the `Set-PSRepository` cmdlet.

Are you sure you want to install the modules from 'PSGallery'?
[Y] Yes [A] Yes to All [N] No [L] No to All [S] Suspend [?] Help (default is "N"):
```

Answer `Yes` or `Yes to All` to continue with the installation.

The Az module is a rollup module for the Azure PowerShell cmdlets. Installing it downloads all of the available Azure Resource Manager modules, and makes their cmdlets available for use.

First, [install PowerShell Core 6.x or later](/powershell/scripting/install/installing-powershell-core-on-windows)

Then, from a PowerShell Core session, install the Az module for the current user only. This is the
recommended installation scope.

```powershell  
Install-Module -Name Az -AllowClobber -Scope CurrentUser
```

Installing the module for all users on a system requires elevated privileges. Start the PowerShell
session using **Run as administrator** in Windows or use the `sudo` command on macOS or Linux:

```powershell  
Install-Module -Name Az -AllowClobber -Scope AllUsers
```

## 3. Connected: Install PowerShell for Azure Stack Hub with internet connectivity

The Azure Stack AZ module will work Azure Stack Hub 2002 or later. In addition the Azure Stack Az module will work with PowerShell 5.1 or greater on a Windows machine, or PowerShell 6.x or greater on a Linux or macOS platform. Using the PowerShellGet cmdlets is the preferred installation method. This method works the same on the supported platforms. 

Run the following command from a PowerShell session:

```powershell  
Install-Module -Name Az -AllowClobber
Install-Module -Name Az.BootStrapper
Use-AzProfile -Profile 2019-03-01-hybrid -Force
Install-Module -Name AzureStack -RequiredVersion 2.0.0-preview -AllowPrerelease
```

> [!Note]  
> - Azure Stack Hub module version 2.0.0 is a breaking change. Refer to the [Migrate from AzureRM to Azure PowerShell Az in Azure Stack Hub](migrate-from-azurerm-to-az-azure-stack.md) for details.

> [!WARNING]  
> You can't have both the AzureRM and Az modules installed for PowerShell 5.1 for Windows at the same time. If you need to keep AzureRM available on your system, install the Az module for PowerShell Core 6.x or later. To do this, [install PowerShell Core 6.x or later](https://docs.microsoft.com/powershell/scripting/install/installing-powershell-core-on-windows) and then follow these instructions in a PowerShell Core terminal.


## 5. Disconnected: Install PowerShell without an internet connection

In some environments it's not possible to connect to the PowerShell Gallery. In those situations,
you can still install offline using one of these methods:

* Download the modules to another location in your network and use that as an installation source.
  This allows you to cache PowerShell modules on a single server or file share to be deployed with
  PowerShellGet to any disconnected systems. Learn how to set up a local repository and install on
  disconnected systems with [Working with local PowerShellGet repositories](https://docs.microsoft.com/powershell/scripting/gallery/how-to/working-with-local-psrepositories).
* [Download the Azure PowerShell MSI](https://docs.microsoft.com/powershell/azure/install-az-ps-msi) to a machine connected to the network,
  and then copy the installer to systems without access to PowerShell Gallery. Keep in mind that the
  MSI installer only works for PowerShell 5.1 on Windows.
* Save the module with [Save-Module](https://docs.microsoft.com/powershell/module/PowershellGet/Save-Module) to a file share,
  or save it to another source and manually copy it to other machines:

  ```powershell  
  Save-Module -Name Az -Path '\\server\share\PowerShell\modules' -Force
  ```

## 6. Configure PowerShell to use a proxy server

In scenarios that require a proxy server to access the internet, you first configure PowerShell to use an existing proxy server:

1. Open an elevated PowerShell prompt.
2. Run the following commands:

   ```powershell
   #To use Windows credentials for proxy authentication
   [System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials

   #Alternatively, to prompt for separate credentials that can be used for #proxy authentication
   [System.Net.WebRequest]::DefaultWebProxy.Credentials = Get-Credential
   ```

## 7. Use the Az module

You can use the cmdlets and code samples based on AzureRM. However, you will want to change the name of the modules and cmdlets. The module names have been changed so that `AzureRM` and Azure become `Az`, and the same for cmdlets. For example, the `AzureRM.Compute` module has been renamed to `Az.Compute`.` New-AzureRMVM` has become` New-AzVM`, and `Get-AzureStorageBlob` is now `Get-AzStorageBlob`.

For a more thorough discussion and guidance for moving AzurRM script to Az and breaking changes in Azure Stack Hub's AZ module, see [Migrate from AzureRM to Azure PowerShell Az](migrate-from-azurerm-to-az-azure-stack.md).

## Next steps

- [Download Azure Stack Hub tools from GitHub](azure-stack-powershell-download.md)
- [Configure the Azure Stack Hub user's PowerShell environment](../user/azure-stack-powershell-configure-user.md)
- [Configure the Azure Stack Hub operator's PowerShell environment](azure-stack-powershell-configure-admin.md)
- [Manage API version profiles in Azure Stack Hub](../user/azure-stack-version-profiles.md)

