---
title: Connect to Azure Stack Hub with PowerShell 
description: Learn how to connect to Azure Stack Hub with PowerShell.
author: sethmanheim
ms.topic: how-to
ms.date: 03/06/2025
ms.author: sethm
ms.reviewer: thoroet
ms.lastreviewed: 02/01/2021

# Intent: As an Azure Stack operator, I want to learn how to connect to Azure Stack using Powershell.
# Keyword: connect azure stack powershell

---


# Connect to Azure Stack Hub with PowerShell

You can configure Azure Stack Hub to use PowerShell to manage resources like creating offers, plans, quotas, and alerts. This article helps you configure the operator environment.

## Prerequisites

Run the following prerequisites from a Windows-based external client.

- Install [Azure Stack Hub-compatible Azure PowerShell modules](powershell-install-az-module.md).  
- Download the [tools required to work with Azure Stack Hub](azure-stack-powershell-download.md).  

<a name='connect-with-azure-ad'></a>

## Connect with Microsoft Entra ID

To configure the Azure Stack Hub operator environment with PowerShell, run the following script. Replace the Microsoft Entra tenantName and Azure Resource Manager endpoint values with your own environment configuration.

[!INCLUDE [remove-account-az](../includes/remove-account-az.md)]

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
    Connect-AzAccount -EnvironmentName "AzureStackAdmin" -TenantId $TenantId
```

[!INCLUDE [note-powershell-adfs](../includes/note-powershell-adfs.md)]

## Test the connectivity

Now that you have everything set up, use PowerShell to create resources within Azure Stack Hub. For example, you can create a resource group for an app and add a virtual machine. Use the following command to create a resource group named **MyResourceGroup**:

```powershell  
New-AzResourceGroup -Name "MyResourceGroup" -Location "Local"
```

## Next steps

- [Use PowerShell to manage subscriptions, plans, and offers in Azure Stack Hub](azure-stack-powershell-plan-offer.md)
- [Develop templates for Azure Stack Hub](../user/azure-stack-develop-templates.md).
- [Deploy templates with PowerShell](../user/azure-stack-deploy-template-powershell.md).
- [Azure Stack Hub Module Reference](/powershell/azurestackhub/overview).
