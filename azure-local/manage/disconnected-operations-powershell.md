---
title: Use Azure Powershell for disconnected operations on Azure Local (preview)
description:  Learn how to use Azure Powershell for disconnected operations on Azure Local (preview).
ms.topic: how-to
author: hafianba
ms.author: hafianba
ms.date: 12/22/2025
ai-usage: ai-assisted
---

# Use Azure Command-Line Interface for disconnected operations on Azure Local (preview)

::: moniker range=">=azloc-2511"

This article explains how to configure Azure Powershell for disconnected operations on Azure Local. 

[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]

## About Azure Powershell

**Azure Powershell** is a versatile, cross-platform set of Powershell modules that lets you create and manage Azure resources for Azure Local disconnected operations. For more information, see [What is Azure Powershell](/powershell/azure/what-is-azure-powershell).

## Configure certificates for Azure Powershell
Before you begin - please make sure your client computer is trusting the public key used to secure the endpoints for your disconnected operations appliance. If you get an ssl warning when using your private cloud endpoint - you have not trusted the public key on the client.

## Add your private cloud 
```powershell
    $applianceCloudName = "azure.local"
    $applianceFQDN = "autonomous.cloud.private"
    Add-AzEnvironment -Name $applianceCloudName -ARMEndpoint "https://armmanagement.$($applianceFQDN)"
```
## List cloud endpoints 
```powershell
Get-AzEnvironment
```
Here is a sample output:
| Name| Resource Manager Url| ActiveDirectory Authority|
|----------------|------------------------------------|---------------------------| 
| AzureChinaCloud   | https://management.chinacloudapi.cn/| https://login.chinacloudapi.cn/|
| AzureCloud        | https://management.azure.com/                 | https://login.microsoftonline.com          |
| AzureUSGovernment | https://management.usgovcloudapi.net/         | https://login.microsoftonline.us/          |
| azure.local       | https://armmanagement.autonomous.cloud.private/ | https://login.autonomous.cloud.private/     |



## Login to your private cloud (using device authentication)
```powershell
$applianceCloudName = "azure.local" 
Connect-AzAccount -EnvironmentName $applianceCloudName -UseDeviceAuthentication
```
## Login to your private cloud (using a service principal)
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
```powershell
Write-Host "Selecting a different subscription than the default subscription.."
$subscriptionName = "Starter subscription"
$subscription = Get-AzSubscription -SubscriptionName $subscriptionName
# Set the context to that subscription
Set-AzContext -SubscriptionId $subscription.Id
```
## Appendix

### How to create a SPN for automation (with password)
```powershell
$sp = New-AzADServicePrincipal -DisplayName "MyAutomationSPN"
## Output the password - this will not be shown again!
$sp.PasswordCredentials.SecretText
(Get-AzContext).Tenant.Id
```
### How to create a SPN for automation (with certificate)
```powershell
$cert = [System.Convert]::ToBase64String((Get-Content "C:\path\cert.cer" -Encoding byte))
$sp = New-AzADServicePrincipal -DisplayName "CertAuthSPN" -CertValue $cert
(Get-AzContext).Tenant.Id
```
::: moniker-end

::: moniker range="<=azloc-2510"

This feature is available only in Azure Local 2511 and newer
::: moniker-end

