---
title: Manage Key Vault in Azure Stack Hub using PowerShell 
description: Learn how to manage Key Vault in Azure Stack Hub by using PowerShell.
author: sethmanheim

ms.topic: how-to
ms.custom:
  - devx-track-azurepowershell
ms.date: 11/20/2020
ms.author: sethm
ms.lastreviewed: 11/20/2020

# Intent: Notdone: As a < type of user >, I want < what? > so that < why? >
# Keyword: Notdone: keyword noun phrase
---

# Manage Key Vault in Azure Stack Hub using PowerShell

This article describes how to create and manage a key vault in Azure Stack Hub using PowerShell. You'll learn how to use Key Vault PowerShell cmdlets to:

* Create a key vault.
* Store and manage cryptographic keys and secrets.
* Authorize users or apps to invoke operations in the vault.

>[!NOTE]
>The Key Vault PowerShell cmdlets described in this article are provided in the Azure PowerShell SDK.

## Prerequisites

* You must subscribe to an offer that includes the Azure Key Vault service.
* [Install PowerShell for Azure Stack Hub](../operator/powershell-install-az-module.md).
* [Configure the Azure Stack Hub PowerShell environment](azure-stack-powershell-configure-user.md).

## Enable your tenant subscription for Key Vault operations

Before you can issue any operations against a key vault, you must ensure that your tenant subscription is enabled for vault operations. To verify that key vault operations are enabled, run the following command:

### [Az modules](#tab/az1)

```powershell  
Get-AzResourceProvider -ProviderNamespace Microsoft.KeyVault | ft -Autosize
```
### [AzureRM modules](#tab/azurerm1)
 

 ```powershell  
Get-AzureRMResourceProvider -ProviderNamespace Microsoft.KeyVault | ft -Autosize
```
---


If your subscription is enabled for vault operations, the output shows **RegistrationState** is **Registered** for all resource types of a key vault.

![Key vault registration state in Powershell](media/azure-stack-key-vault-manage-powershell/image1.png)

If vault operations are not enabled, issue the following command to register the Key Vault service in your subscription:

### [Az modules](#tab/az2)

```powershell
Register-AzResourceProvider -ProviderNamespace Microsoft.KeyVault
```

### [AzureRM modules](#tab/azurerm2)
 
 ```powershell
Register-AzureRMResourceProvider -ProviderNamespace Microsoft.KeyVault
```

---


If the registration is successful, the following output is returned:

![Key vault registration in Powershell successful](media/azure-stack-key-vault-manage-powershell/image2.png)

When you invoke the key vault commands, you might receive an error, such as "The subscription is not registered to use namespace 'Microsoft.KeyVault'." If you get an error, confirm you've enabled the Key Vault resource provider by following the previous instructions.

## Create a key vault

Before you create a key vault, create a resource group so that all of the resources related to the key vault exist in a resource group. Use the following command to create a new resource group:

### [Az modules](#tab/az3)

```powershell
New-AzResourceGroup -Name "VaultRG" -Location local -verbose -Force
```
### [AzureRM modules](#tab/azurerm3)
 
 ```powershell
New-AzureRMResourceGroup -Name "VaultRG" -Location local -verbose -Force
```

---


![New resource group generated in Powershell](media/azure-stack-key-vault-manage-powershell/image3.png)

Now, use the following cmdlet to create a key vault in the resource group that you created earlier. This command reads three mandatory parameters: resource group name, key vault name, and geographic location.

Run the following command to create a key vault:

### [Az modules](#tab/az4)

```powershell
New-AzKeyVault -VaultName "Vault01" -ResourceGroupName "VaultRG" -Location local -verbose
```
   
### [AzureRM modules](#tab/azurerm4)
 
```powershell
New-AzureRMKeyVault -VaultName "Vault01" -ResourceGroupName "VaultRG" -Location local -verbose
```

---


![New key vault generated in Powershell](media/azure-stack-key-vault-manage-powershell/image4.png)

The output of this command shows the properties of the key vault that you created. When an app accesses this vault, it must use the **Vault URI** property, which is `https://vault01.vault.local.azurestack.external` in this example.

### Active Directory Federation Services (AD FS) deployment

In an AD FS deployment, you might get this warning: "Access policy is not set. No user or application has access permission to use this vault." To resolve this issue, set an access policy for the vault by using the [**Set-AzKeyVaultAccessPolicy**](#authorize-an-app-to-use-a-key-or-secret) command:

### [Az modules](#tab/az5)

```powershell
# Obtain the security identifier(SID) of the active directory user
$adUser = Get-ADUser -Filter "Name -eq '{Active directory user name}'"
$objectSID = $adUser.SID.Value

# Set the key vault access policy
Set-AzKeyVaultAccessPolicy -VaultName "{key vault name}" -ResourceGroupName "{resource group name}" -ObjectId "{object SID}" -PermissionsToKeys {permissionsToKeys} -PermissionsToSecrets {permissionsToSecrets} -BypassObjectIdValidation
```

### [AzureRM modules](#tab/azurerm5)

```powershell
# Obtain the security identifier(SID) of the active directory user
$adUser = Get-ADUser -Filter "Name -eq '{Active directory user name}'"
$objectSID = $adUser.SID.Value

# Set the key vault access policy
Set-AzureRMKeyVaultAccessPolicy -VaultName "{key vault name}" -ResourceGroupName "{resource group name}" -ObjectId "{object SID}" -PermissionsToKeys {permissionsToKeys} -PermissionsToSecrets {permissionsToSecrets} -BypassObjectIdValidation
```

---


## Manage keys and secrets

After you create a vault, use these steps to create and manage keys and secrets in the vault.

### Create a key

Use the **Add-AzureKeyVaultKey** cmdlet to create or import a software-protected key in a key vault:

```powershell
Add-AzureKeyVaultKey -VaultName "Vault01" -Name "Key01" -verbose -Destination Software
```


The `-Destination` parameter is used to specify that the key is software protected. When the key is successfully created, the command outputs the details of the created key.

![New key vault key generated in Powershell](media/azure-stack-key-vault-manage-powershell/image5.png)

You can now reference the created key by using its URI. If you create or import a key that has same name as an existing key, the original key is updated with the values specified in the new key. You can access the previous version by using the version-specific URI of the key. For example:

* Use `https://vault10.vault.local.azurestack.external:443/keys/key01` to always get the current version.
* Use `https://vault010.vault.local.azurestack.external:443/keys/key01/d0b36ee2e3d14e9f967b8b6b1d38938a` to get this specific version.

### Get a key

Use the **Get-AzureKeyVaultKey** cmdlet to read a key and its details:

```powershell
Get-AzureKeyVaultKey -VaultName "Vault01" -Name "Key01"
```

### Create a secret

Use the **Set-AzureKeyVaultSecret** cmdlet to create or update a secret in a vault. A secret is created if one does not already exist. A new version of the secret is created if it already exists:

```powershell
$secretvalue = ConvertTo-SecureString "User@123" -AsPlainText -Force
Set-AzureKeyVaultSecret -VaultName "Vault01" -Name "Secret01" -SecretValue $secretvalue
```

![Create a secret in Powershell](media/azure-stack-key-vault-manage-powershell/image6.png)

### Get a secret

Use the **Get-AzureKeyVaultSecret** cmdlet to read a secret in a key vault. This command can return all or specific versions of a secret:

```powershell
Get-AzureKeyVaultSecret -VaultName "Vault01" -Name "Secret01"
```

After you create the keys and secrets, you can authorize external apps to use them.

## Authorize an app to use a key or secret

Use the following cmdlet to authorize an app to access a key or secret in the key vault.

In the following example, the vault name is **ContosoKeyVault**, and the app you want to authorize has a client ID of **00001111-aaaa-2222-bbbb-3333cccc4444**. To authorize the app, run the following command. You can also specify the **PermissionsToKeys** parameter to set permissions for a user, an app, or a security group.

When using the cmdlet against an AD FS configured Azure Stack Hub environment,  the parameter BypassObjectIdValidation should be provided

### [Az modules](#tab/az6)

```powershell
Set-AzKeyVaultAccessPolicy -VaultName 'ContosoKeyVault' -ServicePrincipalName 00001111-aaaa-2222-bbbb-3333cccc4444 -PermissionsToKeys decrypt,sign -BypassObjectIdValidation
```
### [AzureRM modules](#tab/azurerm6)

```powershell
Set-AzureRMKeyVaultAccessPolicy -VaultName 'ContosoKeyVault' -ServicePrincipalName 00001111-aaaa-2222-bbbb-3333cccc4444 -PermissionsToKeys decrypt,sign -BypassObjectIdValidation
```

---


If you want to authorize that same app to read secrets in your vault, run the following cmdlet:

### [Az modules](#tab/az7)

```powershell
Set-AzKeyVaultAccessPolicy -VaultName 'ContosoKeyVault' -ServicePrincipalName 8f8c4bbd-485b-45fd-98f7-ec6300 -PermissionsToKeys Get -BypassObjectIdValidation
```

### [AzureRM modules](#tab/azurerm7)

```powershell
Set-AzureRMKeyVaultAccessPolicy -VaultName 'ContosoKeyVault' -ServicePrincipalName 8f8c4bbd-485b-45fd-98f7-ec6300 -PermissionsToKeys Get -BypassObjectIdValidation
```

---


## Next steps

* [Deploy a VM with a password stored in Key Vault](azure-stack-key-vault-deploy-vm-with-secret.md)
* [Deploy a VM with a certificate stored in Key Vault](azure-stack-key-vault-push-secret-into-vm.md)
