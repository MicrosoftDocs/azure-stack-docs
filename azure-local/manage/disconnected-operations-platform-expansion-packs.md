---
title: Manage Platform expansion packs for disconnected operations
description: Learn how to manage platform expansion packs to add capabilities to disconnected operations for Azure Local after deployment.
author: haraldfianbakken
ms.author: hafianba
ms.reviewer: robess
ms.date: 09/01/2026
ms.topic: concept-article
ms.subservice: hyperconverged
ai-usage: ai-assisted
---

# Manage platform expansion packs for disconnected operations

::: moniker range=">=azloc-2606"

Platform expansion packs provide a mechanism for adding and managing capabilities on demand (post deployment) in disconnected operations for Azure Local. By using platform expansion packs, you can discover, acquire, and manage the lifecycle of platform expansions for new features you need on disconnected operations.

This article focuses on how to manage platform expansion packs for disconnected operations.

## Prerequisites

Before onboarding a platform expansion pack, review the following list:

- Azure Local disconnected operations deployed and running minimum version 2607
- Acquired and downloaded an approved platform expansion pack package.
- Expansion pack copied to seed node or client machine, for example: `C:\AzureLocalDisconnectedOperations\packs\myexpansionpack.zip`
- Management endpoint client secret and operator access
- OperationsModule available on client machine (or seed node) to access the platform expansion pack commands
- Sufficient storage capacity for uploading and installing the platform expansion pack.

## Manage platform expansion packs by using operations module

### Discover the platform expansion pack commands

Load the OperationsModule and set the management client context:

```powershell
$applianceConfigBasePath = 'C:\AzureLocalDisconnectedOperations'
# Import the OperationsModule
Import-Module "$applianceConfigBasePath\OperationsModule\Azure.Local.DisconnectedOperations.psd1" -Force    
$password = ConvertTo-SecureString 'RETRACTED' -AsPlainText -Force  
$managementIp = "169.254.53.25"
$context = Set-DisconnectedOperationsClientContext -ManagementEndpointClientCertificatePath "${env:localappdata}\AzureLocalOpModuleDev\certs\ManagementEndpoint\ManagementEndpointClientAuth.pfx" -ManagementEndpointClientCertificatePassword $password -ManagementEndpointIpAddress $managementIp 
```

Discover commands available through the operations module.

```powershell
  Get-Command *expansion* -Module Azure.Local.DisconnectedOperations
```

### Upload a platform expansion pack

```powershell
$expansionPackPath = 'C:\AzureLocalDisconnectedOperations\packs\myexpansionpack.zip'
$uploadId = Start-AldoExpansionPackUpload `
    -ExpansionPackPath $uploadId
```

### Monitor platform expansion pack upload status

Use the upload status cmdlet to verify that the package uploads successfully and is ready for installation.

```powershell
  Get-AldoExpansionPackUploadStatus
```

### Start platform expansion pack installation

Use the installation cmdlet to start installing a previously uploaded platform extension pack. Review the following examples:

```powershell
# 1. Start async (do not block)
Start-AldoExpansionPackInstallation `
    -ExpansionPackId $uploadId

# 2. Start upload and block until completion
Start-AldoExpansionPackInstallation `
    -ExpansionPackId $uploadId `
    -Wait
```

### Monitor platform expansion pack installation status

Use the installation status cmdlet to monitor progress until installation finishes.

```powershell
Get-AldoExpansionPackInstallationStatus `
    -ExpansionPackId $uploadId

# If supported
Get-AldoExpansionPackInstallationStatus `
    -ExpansionPackId $uploadId `
    -Wait
```

### List packs and inspect installed content

List all expansion packs, view a specific expansion pack, and if supported, view component-level details.

```powershell
# List all packs
Get-AldoExpansionPackDetails

# View a specific pack
Get-AldoExpansionPackDetails `
    -ExpansionPackId $uploadId

# View a specific component inside a platform expansion pack
Get-AldoExpansionPackDetails `
    -ExpansionPackId $uploadId `
    -ComponentId '<component-id>'

```

### Remove a platform expansion pack

Use the remove cmdlet when you no longer need a platform expansion pack. Use it with caution because the content is no longer available in the system or for tenants to use.

```powershell
# Remove the entire expansion pack
Remove-AldoExpansionPack `
    -ExpansionPackId $uploadId

# Remove a specific component in the expansion pack
Remove-AldoExpansionPack `
    -ExpansionPackId $uploadId `
    -ComponentId '<component-id>'
```

### Cmdlet reference

|Cmdlet|Use It To|
|---|-----|
|Start-ApplianceExpansionPackUpload|Upload and stage a platform expansion pack|
|Get-ApplianceExpansionPackUploadStatus|Check upload progress or completion|
|Start-ApplianceExpansionPackInstallation|Start installation of an uploaded expansion pack|
|Get-ApplianceExpansionPackInstallationStatus|Monitor installation progress of an expansion pack|
|Get-ApplianceExpansionPackDetails|List expansion packs and inspect details|
|Remove-ApplianceExpansionPack|Remove a platform expansion pack|

::: moniker-end

::: moniker range="<=azloc-2605"

This feature is available only in Azure Local 2606 or later.

::: moniker-end
