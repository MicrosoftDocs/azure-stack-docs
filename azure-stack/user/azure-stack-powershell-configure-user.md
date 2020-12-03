---
title: Connect to Azure Stack Hub with PowerShell as a user 
description: Learn how to connect to Azure Stack Hub with PowerShell to use the interactive prompt or write scripts.
author: mattbriggs

ms.topic: article
ms.date: 11/22/2020
ms.author: mabrigg
ms.reviewer: thoroet
ms.lastreviewed: 11/22/2020

# Intent: As an Azure Stack user, I want to connect to Azure Stack with PowerShell so that I can use interactive prompt or write scripts to create and manage resources.
# Keyword: connect Azure Stack powershell

---


# Connect to Azure Stack Hub with PowerShell as a user

You can connect to Azure Stack Hub with PowerShell to manage Azure Stack Hub resources. For example, you can use PowerShell to subscribe to offers, create virtual machines (VMs), and deploy Azure Resource Manager templates.

To get setup:
  - Make sure you have the requirements.
  - Connect with Azure Active Directory (Azure AD) or Active Directory Federation Services (AD FS). 
  - Register resource providers.
  - Test your connectivity.

## Prerequisites to connecting with PowerShell

Configure these prerequisites from the [development kit](../asdk/asdk-connect.md#connect-to-azure-stack-using-rdp), or from a Windows-based external client if you're [connected through VPN](../asdk/asdk-connect.md#connect-to-azure-stack-using-vpn):

* Install [Azure Stack Hub-compatible Azure PowerShell modules](../operator/powershell-install-az-module.md).
* Download the [tools required to work with Azure Stack Hub](../operator/azure-stack-powershell-download.md).

Make sure you replace the following script variables with values from your Azure Stack Hub configuration:

- **Azure AD tenant name**  
  The name of your Azure AD tenant used to manage Azure Stack Hub. For example, yourdirectory.onmicrosoft.com.
- **Azure Resource Manager endpoint**  
  For Azure Stack Development kit, this value is set to `https://management.local.azurestack.external`. To get this value for Azure Stack Hub integrated systems, contact your service provider.

## Connect to Azure Stack Hub with Azure AD

### [Az modules](#tab/az1)

```powershell  
    Add-AzEnvironment -Name "AzureStackUser" -ArmEndpoint "https://management.local.azurestack.external"
    # Set your tenant name
    $AuthEndpoint = (Get-AzEnvironment -Name "AzureStackUser").ActiveDirectoryAuthority.TrimEnd('/')
    $AADTenantName = "<myDirectoryTenantName>.onmicrosoft.com"
    $TenantId = (invoke-restmethod "$($AuthEndpoint)/$($AADTenantName)/.well-known/openid-configuration").issuer.TrimEnd('/').Split('/')[-1]

    # After signing in to your environment, Azure Stack Hub cmdlets
    # can be easily targeted at your Azure Stack Hub instance.
    Add-AzAccount -EnvironmentName "AzureStackUser" -TenantId $TenantId
```
### [AzureRM modules](#tab/azurerm1)
 
```powershell  
    Add-AzureRMEnvironment -Name "AzureStackUser" -ArmEndpoint "https://management.local.azurestack.external"
    # Set your tenant name
    $AuthEndpoint = (Get-AzureRMEnvironment -Name "AzureStackUser").ActiveDirectoryAuthority.TrimEnd('/')
    $AADTenantName = "<myDirectoryTenantName>.onmicrosoft.com"
    $TenantId = (invoke-restmethod "$($AuthEndpoint)/$($AADTenantName)/.well-known/openid-configuration").issuer.TrimEnd('/').Split('/')[-1]

    # After signing in to your environment, Azure Stack Hub cmdlets
    # can be easily targeted at your Azure Stack Hub instance.
    Add-AzureRMAccount -EnvironmentName "AzureStackUser" -TenantId $TenantId
```

---


## Connect to Azure Stack Hub with AD FS

### [Az modules](#tab/az2)

  ```powershell  
  # Register an Azure Resource Manager environment that targets your Azure Stack Hub instance
  Add-AzEnvironment -Name "AzureStackUser" -ArmEndpoint "https://management.local.azurestack.external"

  # Sign in to your environment
  Login-AzAccount -EnvironmentName "AzureStackUser"
  ```
### [AzureRM modules](#tab/azurerm2)
 
  ```powershell  
  # Register an Azure Resource Manager environment that targets your Azure Stack Hub instance
  Add-AzureRMEnvironment -Name "AzureStackUser" -ArmEndpoint "https://management.local.azurestack.external"

  # Sign in to your environment
  Login-AzureRMAccount -EnvironmentName "AzureStackUser"
  ```

---


## Register resource providers

Resource providers aren't automatically registered for new user subscriptions that don't have any resources deployed through the portal. You can explicitly register a resource provider by running the following script:

### [Az modules](#tab/az3)

```powershell  
foreach($s in (Get-AzSubscription)) {
        Select-AzSubscription -SubscriptionId $s.SubscriptionId | Out-Null
        Write-Progress $($s.SubscriptionId + " : " + $s.SubscriptionName)
Get-AzResourceProvider -ListAvailable | Register-AzResourceProvider
    }
```
### [AzureRM modules](#tab/azurerm3)
 
```powershell  
foreach($s in (Get-AzureRMSubscription)) {
        Select-AzureRMSubscription -SubscriptionId $s.SubscriptionId | Out-Null
        Write-Progress $($s.SubscriptionId + " : " + $s.SubscriptionName)
Get-AzureRMResourceProvider -ListAvailable | Register-AzureRMResourceProvider
    }
```

---


[!Include [AD FS only supports interactive authentication with user identities](../includes/note-powershell-adfs.md)]

## Test the connectivity

When you've got everything setup, test connectivity by using PowerShell to create resources in Azure Stack Hub. As a test, create a resource group for an application and add a VM. Run the following command to create a resource group named "MyResourceGroup":

### [Az modules](#tab/az4)
```powershell  
New-AzResourceGroup -Name "MyResourceGroup" -Location "Local"
```

### [AzureRM modules](#tab/azurerm4)
 
```powershell  
New-AzureRMResourceGroup -Name "MyResourceGroup" -Location "Local"
```

---


## Next steps

- [Develop templates for Azure Stack Hub](azure-stack-develop-templates.md)
- [Deploy templates with PowerShell](azure-stack-deploy-template-powershell.md)
- [Azure Stack Hub PowerShell Module Reference](/powershell/azure/azure-stack/overview)
- If you want to set up PowerShell for the cloud operator environment, refer to the [Configure the Azure Stack Hub operator's PowerShell environment](../operator/azure-stack-powershell-configure-admin.md) article.
