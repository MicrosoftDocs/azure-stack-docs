---
title: Connect to Azure Stack Hub with PowerShell 
description: Learn how to connect to Azure Stack Hub with PowerShell.
author: mattbriggs

ms.topic: article
ms.date: 10/19/2020
ms.author: mabrigg
ms.reviewer: thoroet
ms.lastreviewed: 10/19/2020

# Intent: As an Azure Stack operator, I want to learn how to connect to Azure Stack using Powershell.
# Keyword: connect azure stack powershell

---


# Connect to Azure Stack Hub with PowerShell

You can configure Azure Stack Hub to use PowerShell to manage resources like creating offers, plans, quotas, and alerts. This topic helps you configure the operator environment.

## Prerequisites

Run the following prerequisites either from the [Azure Stack Development Kit (ASDK)](../asdk/asdk-connect.md#connect-with-rdp) or from a Windows-based external client if you're [connected to the ASDK through VPN](../asdk/asdk-connect.md#connect-with-vpn).

- Install [Azure Stack Hub-compatible Azure PowerShell modules](powershell-install-az-module.md).  
- Download the [tools required to work with Azure Stack Hub](azure-stack-powershell-download.md).  

## Connect with Azure AD

To configure the Azure Stack Hub operator environment with PowerShell, run one of the scripts below. Replace the Azure Active Directory (Azure AD) tenantName and Azure Resource Manager endpoint values with your own environment configuration.

[!include[Remove Account](../../includes/remove-account.md)]

```powershell  
    # Register an Azure Resource Manager environment that targets your Azure Stack Hub instance. Get your Azure Resource Manager endpoint value from your service provider.
    Add-AzEnvironment -Name "AzureStackAdmin" -ArmEndpoint "https://adminmanagement.local.azurestack.external" `
      -AzureKeyVaultDnsSuffix adminvault.local.azurestack.external `
      -AzureKeyVaultServiceEndpointResourceId https://adminvault.local.azurestack.external

    # Set your tenant name.
    $AuthEndpoint = (Get-AzEnvironment -Name "AzureStackAdmin").ActiveDirectoryAuthority.TrimEnd('/')
    $AADTenantName = "<myDirectoryTenantName>.onmicrosoft.com"
    $TenantId = (invoke-restmethod "$($AuthEndpoint)/$($AADTenantName)/.well-known/openid-configuration").issuer.TrimEnd('/').Split('/')[-1]

    # After signing in to your environment, Azure Stack Hub cmdlets
    # can be easily targeted at your Azure Stack Hub instance.
    Add-AzAccount -EnvironmentName "AzureStackAdmin" -TenantId $TenantId
```

## Connect with AD FS

Connect to the Azure Stack Hub operator environment with PowerShell with Azure Active Directory Federated Services (Azure AD FS). For the ASDK, this Azure Resource Manager endpoint is set to `https://adminmanagement.local.azurestack.external`. To get the Azure Resource Manager endpoint for Azure Stack Hub integrated systems, contact your service provider.

  ```powershell  
  # Register an Azure Resource Manager environment that targets your Azure Stack Hub instance. Get your Azure Resource Manager endpoint value from your service provider.
    Add-AzEnvironment -Name "AzureStackAdmin" -ArmEndpoint "https://adminmanagement.local.azurestack.external" `
      -AzureKeyVaultDnsSuffix adminvault.local.azurestack.external `
      -AzureKeyVaultServiceEndpointResourceId https://adminvault.local.azurestack.external

  # Sign in to your environment.
  Login-AzAccount -EnvironmentName "AzureStackAdmin"
  ```

[!Include [AD FS only supports interactive authentication with user identities](../includes/note-powershell-adfs.md)]

## Test the connectivity

Now that you've got everything set-up, use PowerShell to create resources within Azure Stack Hub. For example, you can create a resource group for an app and add a virtual machine. Use the following command to create a resource group named **MyResourceGroup**.

```powershell  
New-AzResourceGroup -Name "MyResourceGroup" -Location "Local"
```

## Next steps

- [Develop templates for Azure Stack Hub](../user/azure-stack-develop-templates.md).
- [Deploy templates with PowerShell](../user/azure-stack-deploy-template-powershell.md).
  - [Azure Stack Hub Module Reference](/powershell/azure/azure-stack/overview).
