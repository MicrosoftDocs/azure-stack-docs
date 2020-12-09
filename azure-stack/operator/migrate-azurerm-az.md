---
title: Migrate Azure PowerShell scripts from AzureRM to Az in Azure Stack Hub
description: Learn the steps and tools for migrating scripts from the AzureRM module to the new Az module in Azure Stack Hub.
author: mattbriggs
ms.author: mabrigg
ms.topic: conceptual
<<<<<<< HEAD
ms.date: 11/4/2020
ms.reviewer: sijuman
ms.lastreviewed: 11/4/2020
=======
ms.date: 12/2/2020
ms.reviewer: sijuman
ms.lastreviewed: 12/2/2020
>>>>>>> 912e5c42da96e10902cc5cd8e1496cdccc85e706
---

# Migrate from AzureRM to Azure PowerShell Az in Azure Stack Hub

The Az module has feature parity with AzureRM, but uses shorter and more consistent cmdlet names.
Scripts written for the AzureRM cmdlets won't automatically work with the new
module. To make the transition easier, Az offers tools to allow you to run your existing scripts
using AzureRM. No migration to a new command set is ever convenient, but this article will help
you get started on transitioning to the new module.

To see the full list of breaking changes between AzureRM and Az, see the [Migration guide for Az 1.0.0](/powershell/azure/migrate-az-1.0.0)

## Check for installed versions of AzureRM

Before taking any migration steps, check which versions of AzureRM are installed on your system. Doing so
allows you to make sure scripts are already running on the latest release, and let you know
if you can enable command aliases without uninstalling AzureRM.

To check which version(s) of AzureRM you have installed, run the command:

```powershell-interactive
Get-InstalledModule -Name AzureRM -AllVersions
```

## Check current scripts work with AzureRM

This is the most important step! Run your existing scripts, and make sure that they work with the
_latest_ release of AzureRM (__2.5.0__). If your scripts don't work, make sure to read
the [AzureRM migration guide](/powershell/azure/azurerm/migration-guide.6.0.0).

## Install the Azure PowerShell Az module

The first step is to install the Az module on your platform. When you install Az, it's recommended
that you uninstall AzureRM. In the following steps, you'll learn how to keep running your existing
scripts and enable compatibility for old cmdlet names.

To install the Azure PowerShell Az module, follow these steps:

* **Recommended**: [Uninstall the AzureRM module](/powershell/azure/uninstall-az-ps#uninstall-the-azurerm-module).
  Make sure that you remove _all_ installed versions of AzureRM, not just the most recent version.
* [Install the Az module](/powershell/azure/install-az-ps)

## Enable AzureRM compatibility aliases 

> [!IMPORTANT]
>
> Only enable compatibility mode if you've uninstalled _all_ versions of AzureRM. Enabling compatibility
> mode with AzureRM cmdlets still available may result in unpredictable behavior. Skip this step if you
> decided to keep AzureRM installed, but be aware that any AzureRM cmdlets will use
> the older modules and not call any Az cmdlets.

With AzureRM uninstalled and your scripts working with the latest AzureRM version, the next step is to 
enable the compatibility mode for the Az module. Compatibility is enabled with the command:

```powershell-interactive
Enable-AzureRmAlias -Scope CurrentUser
```

Aliases enable the ability to use old cmdlet names with the Az module installed. These
aliases are written to the user profile for the selected scope. If no user profile exists, one is created.

> [!WARNING]
>
> You can use a different `-Scope` for this command, but it's not recommended. Aliases are written to
> the user profile for the selected scope, so keep enabling them to as limited a scope as possible. Enabling aliases
> system-wide could also cause issues for other users which have AzureRM installed in their local scope.

Once the alias mode is enabled, run your scripts again to confirm that they still function as expected. 

## Change module and cmdlet names

In general, the module names have been changed so that `AzureRM` and `Azure` become `Az`, and the same for cmdlets.
For example, the `AzureRM.Compute` module has been renamed to `Az.Compute`. `New-AzureRMVM` has become `New-AzVM`,
and `Get-AzureStorageBlob` is now `Get-AzStorageBlob`.

There are exceptions to this naming change that you should be aware of. Some modules were renamed or merged into
existing modules without this affecting the suffix of their cmdlets, other than changing `AzureRM` or `Azure`
to `Az`. Otherwise, the full cmdlet suffix was changed to reflect the new module name.

| AzureRM module | Az module | Cmdlet suffix changed? |
|----------------|-----------|------------------------|
| AzureRM.Profile | Az.Accounts | Yes |
| AzureRM.Insights | Az.Monitor | Yes |
| AzureRM.Tags | Az.Resources | No |
| AzureRM.UsageAggregates | Az.Billing | No |
| AzureRM.Consumption | Az.Billing | No |

## Summary

By following these steps, you can update all of your existing scripts to use the new module. If you have any questions or problems with these steps that made your migration difficult, please comment on this article so that we can improve the instructions.

## Breaking changes for Az 1.0.0

This document provides detailed information on the changes between AzureRM 6.x and the new Az
module, version 1.x and later. The table of contents will help guide you through a full migration
path, including module-specific changes that may affect your scripts.

## General breaking changes

This section details the general breaking changes that are part of the redesign of the Az module.

### Cmdlet noun prefix changes

In the AzureRM module, cmdlets used either `AzureRM` or `Azure` as a noun prefix.  Az simplifies and normalizes cmdlet names, so that all cmdlets use 'Az' as their cmdlet noun prefix. For example:

```powershell  
Get-AzureRMVM
Get-AzureKeyVaultSecret
```

Has changed to:

```powershell  
Get-AzVM
Get-AzKeyVaultSecret
```

To make the transition to these new cmdlet names simpler, Az introduces two new cmdlets, [Enable-AzureRmAlias](/powershell/module/az.accounts/enable-azurermalias) and [Disable-AzureRmAlias](/powershell/module/az.accounts/disable-azurermalias).  `Enable-AzureRmAlias` creates aliases for the older cmdlet names in AzureRM that map to the newer Az cmdlet names. Using the `-Scope` argument with `Enable-AzureRmAlias` allows you to choose where aliases are enabled.

For example, the following script in AzureRM:

```powershell  
#Requires -Modules AzureRM.Storage
Get-AzureRmStorageAccount | Get-AzureStorageContainer | Get-AzureStorageBlob
```

Can be run with minimal changes using `Enable-AzureRmAlias`:

```powershell  
#Requires -Modules Az.Storage
Enable-AzureRmAlias -Scope Process
Get-AzureRmStorageAccount | Get-AzureStorageContainer | Get-AzureStorageBlob
```

Running `Enable-AzureRmAlias -Scope CurrentUser` will enable the aliases for all PowerShell sessions you open, so that after executing this cmdlet, a script like this would not need to be changed at all:

```powershell  
Get-AzureRmStorageAccount | Get-AzureStorageContainer | Get-AzureStorageBlob
```

For complete details on the usage of the alias cmdlets, see the [Enable-AzureRmAlias reference](/powershell/module/az.accounts/enable-azurermalias).

When you're ready to disable aliases, `Disable-AzureRmAlias` removes the created aliases. For complete details,
see the [Disable-AzureRmAlias reference](/powershell/module/az.accounts/disable-azurermalias).

> [!IMPORTANT]
> When disabling aliases, make sure that they are disabled for _all_ scopes which had aliases enabled.

### Module name changes

The module names have changed from `AzureRM.*` to `Az.*`, except for the following modules:

| AzureRM module | Az module |
|----------------|-----------|
| Azure.Storage | Az.Storage |
| Azure.AnalysisServices | Az.AnalysisServices |
| AzureRM.Profile | Az.Accounts |
| AzureRM.Insights | Az.Monitor |
| AzureRM.RecoveryServices.Backup | Az.RecoveryServices |
| AzureRM.RecoveryServices.SiteRecovery | Az.RecoveryServices |
| AzureRM.Tags | Az.Resources |
| AzureRM.MachineLearningCompute | Az.MachineLearning |
| AzureRM.UsageAggregates | Az.Billing |
| AzureRM.Consumption | Az.Billing |

The changes in module names mean that any script that uses `#Requires` or `Import-Module` to load specific modules will need to be changed to use the new module instead. For modules where the cmdlet suffix has not changed,
this means that although the module name has changed, the suffix indicating the operation space has _not_.

#### Migrating requires and import module statements

Scripts that use `#Requires` or `Import-Module` to declare a dependency on AzureRM modules must be updated to use the new module names. For example:

```powershell  
#Requires -Module AzureRM.Compute
```

Should be changed to:

```powershell  
#Requires -Module Az.Compute
```

For `Import-Module`:

```powershell  
Import-Module -Name AzureRM.Compute
```

Should be changed to:

```powershell  
Import-Module -Name Az.Compute
```

### Migrating fully qualified cmdlet invocations

Scripts that use module-qualified cmdlet invocations, such as:

```powershell  
AzureRM.Compute\Get-AzureRmVM
```

Must be changed to use the new module and cmdlet names:

```powershell  
Az.Compute\Get-AzVM
```

### Migrating module manifest dependencies

Modules that express dependencies on AzureRM modules through a module manifest (.psd1) file will need to updated the module names in their `RequiredModules` section:

```powershell
RequiredModules = @(@{ModuleName="AzureRM.Profile"; ModuleVersion="5.8.2"})
```

Must be changed to:

```powershell
RequiredModules = @(@{ModuleName="Az.Accounts"; ModuleVersion="1.0.0"})
```

### Removed modules

The following modules have been removed:

- `AzureRM.Backup`
- `AzureRM.Compute.ManagedService`
- `AzureRM.Scheduler`

The tools for these services are no longer actively supported.  Customers are encouraged to move to alternative services as soon as it is convenient.

### Windows PowerShell 5.1 and .NET 4.7.2

Using Az with PowerShell 5.1 for Windows requires the installation of .NET Framework 4.7.2. Using PowerShell
Core 6.x or later does not require .NET Framework.

### Temporary removal of user login using PSCredential

Due to changes in the authentication flow for .NET Standard, we are temporarily removing user login via PSCredential. This capability will be re-introduced in the 1/15/2019 release for PowerShell 5.1 for Windows. This is discussed in detail in [this GitHub issue.](https://github.com/Azure/azure-powershell/issues/7430)

### Default device code login instead of web browser prompt

Due to changes in the authentication flow for .NET Standard, we are using device login as the default login flow during interactive login. Web browser based login will be re-introduced for PowerShell 5.1 for Windows as the default in the 1/15/2019 release. At that time, users will be able to choose device login using a Switch parameter.

## Module breaking changes

This section details specific breaking changes for individual modules and cmdlets.

### Az.ApiManagement (previously AzureRM.ApiManagement)

- Removed the following cmdlets:
  - New-AzureRmApiManagementHostnameConfiguration
  - Set-AzureRmApiManagementHostnames
  - Update-AzureRmApiManagementDeployment
  - Import-AzureRmApiManagementHostnameCertificate
  - Use **Set-AzApiManagement** cmdlet to set these properties instead
- Removed the following properties:
  - Removed property `PortalHostnameConfiguration`, `ProxyHostnameConfiguration`, `ManagementHostnameConfiguration` and `ScmHostnameConfiguration` of type `PsApiManagementHostnameConfiguration` from `PsApiManagementContext`. Instead use `PortalCustomHostnameConfiguration`, `ProxyCustomHostnameConfiguration`, `ManagementCustomHostnameConfiguration` and `ScmCustomHostnameConfiguration` of type `PsApiManagementCustomHostNameConfiguration`.
  - Removed property `StaticIPs` from PsApiManagementContext. The property has been split into `PublicIPAddresses` and `PrivateIPAddresses`.
  - Removed required property `Location` from New-AzureApiManagementVirtualNetwork cmdlet.

### Az.Billing (previously AzureRM.Billing, AzureRM.Consumption, and AzureRM.UsageAggregates)

- The `InvoiceName` parameter was removed from the `Get-AzConsumptionUsageDetail` cmdlet.  Scripts will need to use other identity parameters for the invoice.

### Az.Compute (previously AzureRM.Compute)

- `IdentityIds` are removed from `Identity` property in `PSVirtualMachine` and `PSVirtualMachineScaleSet` objects
  Scripts should no longer use the value of this field to make processing decisions.
- The type of `InstanceView` property of `PSVirtualMachineScaleSetVM` object is changed from `VirtualMachineInstanceView` to `VirtualMachineScaleSetVMInstanceView`
- `AutoOSUpgradePolicy` and `AutomaticOSUpgrade` properties are removed from `UpgradePolicy` property
- The type of `Sku` property in `PSSnapshotUpdate` object is changed from `DiskSku` to `SnapshotSku`
- `VmScaleSetVMParameterSet` is removed from `Add-AzVMDataDisk` cmdlet, you can no longer add a data disk individually to a ScaleSet VM.

### Az.KeyVault (previously AzureRM.KeyVault)

- The `PurgeDisabled` property was removed from the `PSKeyVaultKeyAttributes`, `PSKeyVaultKeyIdentityItem`, and `PSKeyVaultSecretAttributes` objects
  Scripts should no longer reference the ```PurgeDisabled``` property to make processing decisions.

### Az.Monitor (previously AzureRM.Insights)

- Removed plural names `Categories` and `Timegrains` parameter in favor of singular parameter names from `Set-AzDiagnosticSetting` cmdlet
  Scripts using
  ```powershell  
  Set-AzureRmDiagnosticSetting -Timegrains PT1M -Categories Category1, Category2
  ```

  Should be changed to
  ```powershell  
  Set-AzDiagnosticSetting -Timegrain PT1M -Category Category1, Category2
  ```

### Az.Network (previously AzureRM.Network)

- Removed deprecated `ResourceId` parameter from `Get-AzServiceEndpointPolicyDefinition` cmdlet
- Removed deprecated `EnableVmProtection` property from `PSVirtualNetwork` object
- Removed deprecated `Set-AzVirtualNetworkGatewayVpnClientConfig` cmdlet

Scripts should no longer make processing decisions based on the values fo these fields.

### Az.Resources (previously AzureRM.Resources)

- Removed `Sku` parameter from `New/Set-AzPolicyAssignment` cmdlet
- Removed `Password` parameter from `New-AzADServicePrincipal` and `New-AzADSpCredential` cmdlet
  Passwords are automatically generated, scripts that provided the password:

  ```powershell  
  New-AzAdSpCredential -ObjectId 1f99cf81-0146-4f4e-beae-2007d0668476 -Password $secPassword
  ```

  Should be changed to retrieve the password from the output:

  ```powershell  
  $credential = New-AzAdSpCredential -ObjectId 1f99cf81-0146-4f4e-beae-2007d0668476
  $secPassword = $credential.Secret
  ```


### Az.Storage (previously Azure.Storage and AzureRM.Storage)

- To support creating an Oauth storage context with only the storage account name, the default parameter set has been changed to `OAuthParameterSet`
  - Example: `$ctx = New-AzureStorageContext -StorageAccountName $accountName`
- The `Location` parameter has become mandatory in the `Get-AzStorageUsage` cmdlet
- The Storage API methods now use the Task-based Asynchronous Pattern (TAP), instead of synchronous API calls. The following examples demonstrate the new asynchronous commands:

#### Blob snapshot

AzureRM:

```powershell  
$b = Get-AzureStorageBlob -Container $containerName -Blob $blobName -Context $ctx
$b.ICloudBlob.Snapshot()
```

Az:

```powershell  
$b = Get-AzStorageBlob -Container $containerName -Blob $blobName -Context $ctx
$task = $b.ICloudBlob.SnapshotAsync()
$task.Wait()
$snapshot = $task.Result
```

#### Share snapshot

AzureRM:

```powershell  
$Share = Get-AzureStorageShare -Name $containerName -Context $ctx
$snapshot = $Share.Snapshot()
```

Az:

```powershell  
$Share = Get-AzStorageShare -Name $containerName -Context $ctx
$task = $Share.SnapshotAsync()
$task.Wait()
$snapshot = $task.Result
```

#### Undelete soft-deleted blob

AzureRM:

```powershell  
$b = Get-AzureStorageBlob -Container $containerName -Blob $blobName -IncludeDeleted -Context $ctx
$b.ICloudBlob.Undelete()
```

Az:

```powershell  
$b = Get-AzStorageBlob -Container $containerName -Blob $blobName -IncludeDeleted -Context $ctx
$task = $b.ICloudBlob.UndeleteAsync()
$task.Wait()
```

#### Set blob tier

AzureRM:

```powershell  
$blockBlob = Get-AzureStorageBlob -Container $containerName -Blob $blockBlobName -Context $ctx
$blockBlob.ICloudBlob.SetStandardBlobTier("hot")

$pageBlob = Get-AzureStorageBlob -Container $containerName -Blob $pageBlobName -Context $ctx
$pageBlob.ICloudBlob.SetPremiumBlobTier("P4")
```

Az:

```powershell  
$blockBlob = Get-AzStorageBlob -Container $containerName -Blob $blockBlobName -Context $ctx
$task = $blockBlob.ICloudBlob.SetStandardBlobTierAsync("hot")
$task.Wait()

$pageBlob = Get-AzStorageBlob -Container $containerName -Blob $pageBlobName -Context $ctx
$task = $pageBlob.ICloudBlob.SetPremiumBlobTierAsync("P4")
$task.Wait()
```

### Az.Websites (previously AzureRM.Websites)

- Removed deprecated properties from the `PSAppServicePlan`, `PSCertificate`, `PSCloningInfo`, and `PSSite` objects

## Next steps

- Learn more about PowerShell on Azure Stack Hub, see [Get started with PowerShell in Azure Stack Hub](../user/azure-stack-powershell-overview.md)
- Install the PowerShell Az module, see [Install PowerShell Az module for Azure Stack Hub](powershell-install-az-module.md)
