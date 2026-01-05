---
title: Use Azure PowerShell for Disconnected Operations on Azure Local (preview)
description:  Learn how to use Azure PowerShell for disconnected operations on Azure Local (preview).
ms.topic: how-to
author: ronmiab
ms.author: robess
ms.date: 12/22/2025
ai-usage: ai-assisted
---

# Use Azure PowerShell for disconnected operations on Azure Local (preview)

::: moniker range=">=azloc-2511"

This article explains how to configure Azure PowerShell for disconnected operations on Azure Local. 

[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]

## About Azure PowerShell

**Azure PowerShell** is a versatile, cross-platform set of PowerShell modules that you can use to create and manage Azure resources for Azure Local disconnected operations. For more information, see [What is Azure PowerShell](/powershell/azure/what-is-azure-powershell).

## Configure certificates for Azure PowerShell

Before you begin, make sure your client computer trusts the public key used to secure the endpoints for your disconnected operations appliance. If you get an SSL warning when using your private cloud endpoint, you didn't trust the public key on the client.

## Add private cloud

To add your private cloud, run the following command:

```powershell
    $applianceCloudName = "azure.local"
    $applianceFQDN = "autonomous.cloud.private"
    Add-AzEnvironment -Name $applianceCloudName -ARMEndpoint "https://armmanagement.$($applianceFQDN)"
```

## List cloud endpoints

To list cloud endpoints, run the following command:

```powershell
Get-AzEnvironment
```

Here's a sample output:

```console
| Name | Resource Manager Url | ActiveDirectory Authority |
|-------------------|--------------------------------------|---------------------------| 
| AzureChinaCloud   | https://management.chinacloudapi.cn/ | https://login.chinacloudapi.cn/ |
| AzureCloud        | https://management.azure.com/        | https://login.microsoftonline.com |
| AzureUSGovernment | https://management.usgovcloudapi.net/  | https://login.microsoftonline.us/ |
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
$clientSecret = 'retracted'

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

### Create a SPN for automation (with password)

To create a SPN for automation using a password, run the following command:

```powershell
$sp = New-AzADServicePrincipal -DisplayName "MyAutomationSPN"
## Output the password - this will not be shown again!
$sp.PasswordCredentials.SecretText
(Get-AzContext).Tenant.Id
```

### Create a SPN for automation (with certificate)

To create a SPN for automation using a certificate, run the following command:

```powershell
$cert = [System.Convert]::ToBase64String((Get-Content "C:\path\cert.cer" -Encoding byte))
$sp = New-AzADServicePrincipal -DisplayName "CertAuthSPN" -CertValue $cert
(Get-AzContext).Tenant.Id
```

::: moniker-end

::: moniker range="<=azloc-2510"

This feature is available only in Azure Local 2511 and newer.
::: moniker-end

