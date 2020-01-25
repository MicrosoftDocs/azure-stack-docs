---
title: Allow apps to access Azure Stack Hub Key Vault secrets | Microsoft Docs
description: Learn how to run a sample app that retrieves keys and secrets from a key vault in Azure Stack Hub.
author: sethmanheim

ms.topic: conceptual
ms.date: 01/06/2020
ms.author: sethm
ms.lastreviewed: 04/08/2019

---

# Allow apps to access Azure Stack Hub Key Vault secrets

Follow the steps in this article to run the sample app **HelloKeyVault** that retrieves keys and secrets from a key vault in Azure Stack Hub.

## Prerequisites

You can install the following prerequisites from the [Azure Stack Development Kit](../asdk/asdk-connect.md#connect-to-azure-stack-using-rdp), or from a Windows-based external client if you're [connected through VPN](../asdk/asdk-connect.md#connect-to-azure-stack-using-vpn):

* Install [Azure Stack Hub-compatible Azure PowerShell modules](../operator/azure-stack-powershell-install.md).
* Download the [tools required to work with Azure Stack Hub](../operator/azure-stack-powershell-download.md).

## Create a key vault and register an app

To prepare for the sample application:

* Create a key vault in Azure Stack Hub.
* Register an app in Azure Active Directory (Azure AD).

Use the Azure portal or PowerShell to prepare for the sample app.

> [!NOTE]
> By default, the PowerShell script creates a new app in Active Directory. However, you can register one of your existing applications.

Before running the following script, make sure you provide values for the `aadTenantName` and `applicationPassword` variables. If you don't specify a value for `applicationPassword`, this script generates a random password.

```powershell
$vaultName           = 'myVault'
$resourceGroupName   = 'myResourceGroup'
$applicationName     = 'myApp'
$location            = 'local'

# Password for the application. If not specified, this script generates a random password during app creation.
$applicationPassword = ''

# Function to generate a random password for the application.
Function GenerateSymmetricKey()
{
    $key = New-Object byte[](32)
    $rng = [System.Security.Cryptography.RNGCryptoServiceProvider]::Create()
    $rng.GetBytes($key)
    return [System.Convert]::ToBase64String($key)
}

Write-Host 'Please log into your Azure Stack Hub user environment' -foregroundcolor Green

$tenantARM = "https://management.local.azurestack.external"
$aadTenantName = "FILL THIS IN WITH YOUR AAD TENANT NAME. FOR EXAMPLE: myazurestack.onmicrosoft.com"

# Configure the Azure Stack Hub operator's PowerShell environment.
Add-AzureRMEnvironment `
  -Name "AzureStackUser" `
  -ArmEndpoint $tenantARM

$TenantID = Get-AzsDirectoryTenantId `
  -AADTenantName $aadTenantName `
  -EnvironmentName AzureStackUser

# Sign in to the user portal.
Add-AzureRmAccount `
  -EnvironmentName "AzureStackUser" `
  -TenantId $TenantID `

$now = [System.DateTime]::Now
$oneYearFromNow = $now.AddYears(1)

$applicationPassword = GenerateSymmetricKey

# Create a new Azure AD application.
$identifierUri = [string]::Format("http://localhost:8080/{0}",[Guid]::NewGuid().ToString("N"))
$homePage = "https://contoso.com"

Write-Host "Creating a new AAD Application"
$ADApp = New-AzureRmADApplication `
  -DisplayName $applicationName `
  -HomePage $homePage `
  -IdentifierUris $identifierUri `
  -StartDate $now `
  -EndDate $oneYearFromNow `
  -Password $applicationPassword

Write-Host "Creating a new AAD service principal"
$servicePrincipal = New-AzureRmADServicePrincipal `
  -ApplicationId $ADApp.ApplicationId

# Create a new resource group and a key vault in that resource group.
New-AzureRmResourceGroup `
  -Name $resourceGroupName `
  -Location $location

Write-Host "Creating vault $vaultName"
$vault = New-AzureRmKeyVault -VaultName $vaultName `
  -ResourceGroupName $resourceGroupName `
  -Sku standard `
  -Location $location

# Specify full privileges to the vault for the application.
Write-Host "Setting access policy"
Set-AzureRmKeyVaultAccessPolicy -VaultName $vaultName `
  -ObjectId $servicePrincipal.Id `
  -PermissionsToKeys all `
  -PermissionsToSecrets all

Write-Host "Paste the following settings into the app.config file for the HelloKeyVault project:"
'<add key="VaultUrl" value="' + $vault.VaultUri + '"/>'
'<add key="AuthClientId" value="' + $servicePrincipal.ApplicationId + '"/>'
'<add key="AuthClientSecret" value="' + $applicationPassword + '"/>'
Write-Host
```

The following image shows the output from the script used to create the key vault:

![Key vault with access keys](media/azure-stack-key-vault-sample-app/settingsoutput.png)

Make a note of the **VaultUrl**, **AuthClientId**, and **AuthClientSecret** values returned by the previous script. You use these values to run the **HelloKeyVault** application.

## Download and configure the sample application

Download the key vault sample from the Azure [Key Vault client samples](https://www.microsoft.com/download/details.aspx?id=45343) page. Extract the contents of the .zip file on your development workstation. There are two apps in the samples folder. This article uses **HelloKeyVault**.

To load the **HelloKeyVault** sample:

1. Browse to the **Microsoft.Azure.KeyVault.Samples** > **samples** > **HelloKeyVault** folder.
2. Open the **HelloKeyVault** app in Visual Studio.

### Configure the sample application

In Visual Studio:

1. Open the HelloKeyVault\App.config file and find the `<appSettings>` element.
2. Update the **VaultUrl**, **AuthClientId**, and **AuthClientSecret** keys with the values returned when creating the key vault. By default, the App.config file has a placeholder for `AuthCertThumbprint`. Replace this placeholder with `AuthClientSecret`.

   ![App settings](media/azure-stack-key-vault-sample-app/appconfig.png)

3. Rebuild the solution.

## Run the app

When you run **HelloKeyVault**, the app signs in to Azure AD and then uses the `AuthClientSecret` token to authenticate to the key vault in Azure Stack Hub.

You can use the **HelloKeyVault** sample to:

* Perform basic operations such as create, encrypt, wrap, and delete on the keys and secrets.
* Pass parameters such as `encrypt` and `decrypt` to **HelloKeyVault**, and apply the specified changes to a key vault.

## Next steps

* [Deploy a VM with a Key Vault password](azure-stack-key-vault-deploy-vm-with-secret.md)
* [Deploy a VM with a Key Vault certificate](azure-stack-key-vault-push-secret-into-vm.md)
