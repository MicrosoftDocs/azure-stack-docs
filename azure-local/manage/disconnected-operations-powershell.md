---
title: Use Azure PowerShell for Disconnected Operations on Azure Local (preview)
description:  Learn how to use Azure PowerShell for disconnected operations on Azure Local (preview).
ms.topic: how-to
author: ronmiab
ms.author: robess
ms.date: 01/05/2026
ms.reviewer: haraldfianbakken
ai-usage: ai-assisted
---

# Use Azure PowerShell for disconnected operations on Azure Local (preview)

::: moniker range=">=azloc-2511"

This article explains how to configure Azure PowerShell for disconnected operations on Azure Local.

[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]

## About Azure PowerShell

Azure PowerShell is a versatile, cross-platform set of PowerShell modules that you can use to create and manage Azure resources for Azure Local disconnected operations. For more information, see [What is Azure PowerShell](/powershell/azure/what-is-azure-powershell).

## Configure certificates for Azure PowerShell

Before you begin, make sure your client computer trusts the public key used to secure the endpoints for your disconnected operations appliance. If you get an SSL warning when using your private cloud endpoint, you didn't trust the public key on the client.

## Add private cloud

To add your private cloud, run the following command:

```powershell
$applianceCloudName = "azure.local"
$applianceFQDN = "autonomous.cloud.private"

$AdminManagementEndPointUri = "https://armmanagement.$($applianceFQDN)/"
$DirectoryTenantId = "98b8267d-e97f-426e-8b3f-7956511fd63f"

#retrieve ALDO endpoints

$armMetadataEndpoint = $AdminManagementEndPointUri.ToString().TrimEnd('/') + "/metadata/endpoints?api-version=2015-01-01"

$endpoints = Invoke-RestMethod -Method Get -Uri $armMetadataEndpoint -ErrorAction Stop

$azEnvironment = Add-AzEnvironment `
-Name $applianceCloudName `
-ActiveDirectoryEndpoint ($endpoints.authentication.loginEndpoint.TrimEnd('/') + "/") `
-ActiveDirectoryServiceEndpointResourceId $endpoints.authentication.audiences[0] `
-ResourceManagerEndpoint $AdminManagementEndPointUri.ToString() `
-GalleryEndpoint $endpoints.galleryEndpoint `
-MicrosoftGraphEndpointResourceId $endpoints.graphEndpoint `
-MicrosoftGraphUrl $endpoints.graphEndpoint `
-AdTenant $DirectoryTenantId `
-GraphEndpoint $endpoints.graphEndpoint `
-GraphAudience $endpoints.graphEndpoint `
-EnableAdfsAuthentication:($endpoints.authentication.loginEndpoint.TrimEnd("/").EndsWith("/adfs",[System.StringComparison]::OrdinalIgnoreCase)) 
```

## List cloud endpoints

To list cloud endpoints, run the following command:

```powershell
Get-AzEnvironment
```

Here's a sample output:

```console
| Name              | Resource Manager Url                            | ActiveDirectory Authority               |
|-------------------|-------------------------------------------------|-----------------------------------------| 
| AzureChinaCloud   | https://management.chinacloudapi.cn/            | https://login.chinacloudapi.cn/         |
| AzureCloud        | https://management.azure.com/                   | https://login.microsoftonline.com       |
| AzureUSGovernment | https://management.usgovcloudapi.net/           | https://login.microsoftonline.us/       |
| azure.local       | https://armmanagement.autonomous.cloud.private/ | https://login.autonomous.cloud.private/ |
```

## Sign in to your private cloud (using device authentication)

To sign in to your private cloud using device authentication, run the following command:

```powershell
$applianceCloudName = "azure.local" 
Connect-AzAccount -EnvironmentName $applianceCloudName -UseDeviceAuthentication
```

## Sign in to your private cloud (using a service principal)

To sign in to your private cloud using a service principal, run the following command:

```powershell
$applianceCloudName = "azure.local" 
$clientSecret = "retracted"

# Define service principal credentials
$appId = "your-application-id"
$TenantId = "your-tenant-id"
$SecurePassword = $clientSecret|ConvertTo-SecureString  -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential($appId, $SecurePassword)

# Connect to Azure using the service principal
Connect-AzAccount -ServicePrincipal -Credential $Credential -TenantId $TenantId  -EnvironmentName $applianceCloudName
```

## Set Azure context (different subscription)

To set Azure context for a different subscription, run the following command:

```powershell
Write-Host "Selecting a different subscription than the default subscription.."
$subscriptionName = "Starter subscription"
$subscription = Get-AzSubscription -SubscriptionName $subscriptionName
# Set the context to that subscription
Set-AzContext -SubscriptionId $subscription.Id
```

## Appendix

### Create an SPN for automation (with password)

To create an SPN for automation using a password, run the following command:

```powershell
$sp = New-AzADServicePrincipal -DisplayName "MyAutomationSPN"
## Output the password - this will not be shown again!
$sp.PasswordCredentials.SecretText
(Get-AzContext).Tenant.Id
```

### Create an SPN for automation (with certificate)

To create an SPN for automation using a certificate, run the following command:

```powershell
$cert = [System.Convert]::ToBase64String((Get-Content "C:\path\cert.cer" -Encoding byte))
$sp = New-AzADServicePrincipal -DisplayName "CertAuthSPN" -CertValue $cert
(Get-AzContext).Tenant.Id
```

::: moniker-end

::: moniker range="<=azloc-2510"

This feature is available only in Azure Local 2511 and newer.
::: moniker-end

