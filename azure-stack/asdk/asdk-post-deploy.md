---
title: Post deployment configurations for the ASDK 
description: Learn about the recommended configuration changes to make after installing the Azure Stack Development Kit (ASDK).
author: justinha

ms.topic: article
ms.date: 11/14/2020
ms.author: justinha
ms.reviewer: misainat
ms.lastreviewed: 11/14/2020

# Intent: As an ASDK user, I want to know recommended configuration changes after I deploy the ASDK.
# Keyword: asdk configuration changes

---


# Post deployment configurations for ASDK

After you [install the Azure Stack Development Kit (ASDK)](asdk-install.md), you should make a few recommended post deployment configuration changes while signed in as AzureStack\AzureStackAdmin on the ASDK host computer.

## Install Azure Stack PowerShell

Azure Stack compatible Azure PowerShell modules are required to work with Azure Stack.

PowerShell commands for Azure Stack are installed through the PowerShell Gallery. To register the PSGallery repository, open an elevated PowerShell session and run the following command:

``` Powershell
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
```

Use API version profiles to specify Azure Stack compatible Az modules.  API version profiles provide a way to manage version differences between Azure and Azure Stack. An API version profile is a set of Az PowerShell modules with specific API versions. The **Az.BootStrapper** module that's available through the PowerShell Gallery provides PowerShell cmdlets that are required to work with API version profiles.

You can install the latest Azure Stack PowerShell module with or without internet connectivity to the ASDK host computer:

> [!IMPORTANT]
> Before installing the required version, make sure that you [uninstall any existing Azure PowerShell modules](../operator/powershell-install-az-module.md#3-uninstall-existing-versions-of-the-azure-stack-hub-powershell-modules).

- **With an internet connection** from the ASDK host computer: Run the following PowerShell script to install these modules on your ASDK installation:

### [Az modules](#tab/az1)

  ```powershell  
  # Update the current PowerShellGet module to latest version, required to support PreRelease modules
  Install-Module -Name PowerShellGet -Force

  Get-Module -Name Azs.* -ListAvailable | Uninstall-Module -Force -Verbose
  Get-Module -Name Azure* -ListAvailable | Uninstall-Module -Force -Verbose

  # Install the Az.BootStrapper module. Select Yes when prompted to install NuGet
  Install-Module -Name Az.BootStrapper

  # Install and import the API Version Profile required by Azure Stack into the current PowerShell session.
  Use-AzProfile -Profile 2019-03-01-hybrid -Force
  Install-Module -Name AzureStack -RequiredVersion 2.0.2-preview -AllowPrerelease
  ```

If the installation is successful, the Az and AzureStack modules are displayed in the output.

### [AzureRM modules](#tab/azurerm1)

  ```powershell  
  Get-Module -Name Azs.* -ListAvailable | Uninstall-Module -Force -Verbose
  Get-Module -Name Azure* -ListAvailable | Uninstall-Module -Force -Verbose

  # Install the AzureRM.BootStrapper module. Select Yes when prompted to install NuGet
  Install-Module -Name AzureRM.BootStrapper

  # Install and import the API Version Profile required by Azure Stack into the current PowerShell session.
  Use-AzureRmProfile -Profile 2019-03-01-hybrid -Force
  Install-Module -Name AzureStack -RequiredVersion 1.8.2
  ```

If the installation is successful, the AureRM and AzureStack modules are displayed in the output.

---

- **Without an internet connection** from the ASDK host computer: In a disconnected scenario, you must first download the PowerShell modules to a machine that has internet connectivity using the following PowerShell commands:

### [Az modules](#tab/az2)

  ```powershell
  $Path = "<Path that is used to save the packages>"

  Save-Package `
    -ProviderName NuGet -Source https://www.powershellgallery.com/api/v2 -Name Az -Path $Path -Force -RequiredVersion 2.3.0
  
  Save-Package `
    -ProviderName NuGet -Source https://www.powershellgallery.com/api/v2 -Name AzureStack -Path $Path -Force -RequiredVersion 1.5.0
  ```

  Next, copy the downloaded packages to the ASDK computer and register the location as the default repository and install the Az and AzureStack modules from this repository:

  ```powershell  
  $SourceLocation = "<Location on the development kit that contains the PowerShell packages>"
  $RepoName = "MyNuGetSource"

  Register-PSRepository -Name $RepoName -SourceLocation $SourceLocation -InstallationPolicy Trusted

  Install-Module Az -Repository $RepoName

  Install-Module AzureStack -Repository $RepoName
  ```

### [AzureRM modules](#tab/azurerm2)

  ```powershell
  $Path = "<Path that is used to save the packages>"

  Save-Package `
    -ProviderName NuGet -Source https://www.powershellgallery.com/api/v2 -Name AzureRM -Path $Path -Force -RequiredVersion 2.3.0
  
  Save-Package `
    -ProviderName NuGet -Source https://www.powershellgallery.com/api/v2 -Name AzureStack -Path $Path -Force -RequiredVersion 1.5.0
  ```

  Next, copy the downloaded packages to the ASDK computer and register the location as the default repository and install the AzureRM and AzureStack modules from this repository:

  ```powershell  
  $SourceLocation = "<Location on the development kit that contains the PowerShell packages>"
  $RepoName = "MyNuGetSource"

  Register-PSRepository -Name $RepoName -SourceLocation $SourceLocation -InstallationPolicy Trusted

  Install-Module AzureRM -Repository $RepoName

  Install-Module AzureStack -Repository $RepoName
  ```

---

## Download the Azure Stack tools

[AzureStack-Tools](https://github.com/Azure/AzureStack-Tools) is a GitHub repository that hosts PowerShell modules for managing and deploying resources to Azure Stack. You use the tools using the Az PowerShell modules, or the AzureRM modules.

### [Az modules](#tab/az3)

To get these tools, clone the GitHub repository from the `az` branch or download the **AzureStack-Tools** folder by running the following script:

```powershell
# Change directory to the root directory.
cd \

# Download the tools archive.
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 
invoke-webrequest `
  https://github.com/Azure/AzureStack-Tools/archive/az.zip `
  -OutFile az.zip

# Expand the downloaded files.
expand-archive az.zip `
  -DestinationPath . `
  -Force

# Change to the tools directory.
cd AzureStack-Tools-az

```
### [AzureRM modules](#tab/azurerm3)

To get these tools, clone the GitHub repository from the `master` branch or download the **AzureStack-Tools** folder by running the following script in an elevated PowerShell prompt:

```powershell
# Change directory to the root directory.
cd \

# Download the tools archive.
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
invoke-webrequest `
  https://github.com/Azure/AzureStack-Tools/archive/master.zip `
  -OutFile master.zip

# Expand the downloaded files.
expand-archive master.zip `
  -DestinationPath . `
  -Force

# Change to the tools directory.
cd AzureStack-Tools-master

```
For more information about using the AzureRM module for Azure Stack Hub, see [Install PowerShell AzureRM module for Azure Stack Hub](../operator/azure-stack-powershell-install.md)

---

## Validate the ASDK installation

To ensure that your ASDK deployment was successful, use the Test-AzureStack cmdlet by following these steps:

1. Sign in as AzureStack\AzureStackAdmin on the ASDK host computer.
2. Open PowerShell as an admin (not PowerShell ISE).
3. Run: `Enter-PSSession -ComputerName AzS-ERCS01 -ConfigurationName PrivilegedEndpoint`
4. Run: `Test-AzureStack`

The tests take a few minutes to complete. If the installation was successful, the output looks something like:

![Test Azure Stack - Installation successful](media/asdk-post-deploy/test-azurestack.png)

If there was a failure, follow the troubleshooting steps to get help.

## Enable multi-tenancy

For deployments using Azure AD, you need to [enable multi-tenancy](../operator/azure-stack-enable-multitenancy.md#enable-multi-tenancy) for your ASDK installation.

> [!NOTE]
> When admin or user accounts from domains other than the one used to register Azure Stack are used to log in to an Azure Stack portal, the domain name used to register Azure Stack must be appended to the portal URL. For example, if Azure Stack has been registered with fabrikam.onmicrosoft.com and the user account logging in is admin@contoso.com, the URL to use to log in to the user portal would be: https\://portal.local.azurestack.external/fabrikam.onmicrosoft.com.

## Next steps

[Register the ASDK with Azure](asdk-register.md)
