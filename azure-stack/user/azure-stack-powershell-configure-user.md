---
title: Connect to Azure Stack Hub with PowerShell as a user | Microsoft Docs
description: Learn how to connect to Azure Stack Hub with PowerShell. 
author: mattbriggs

ms.topic: article
ms.date: 1/22/2020
ms.author: mabrigg
ms.reviewer: thoroet
ms.lastreviewed: 10/02/2019

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

* Install [Azure Stack Hub-compatible Azure PowerShell modules](../operator/azure-stack-powershell-install.md).
* Download the [tools required to work with Azure Stack Hub](../operator/azure-stack-powershell-download.md).

Make sure you replace the following script variables with values from your Azure Stack Hub configuration:

- **Azure AD tenant name**  
  The name of your Azure AD tenant used to manage Azure Stack Hub. For example, yourdirectory.onmicrosoft.com.
- **Azure Resource Manager endpoint**  
  For Azure Stack Development kit, this value is set to https://management.local.azurestack.external. To get this value for Azure Stack Hub integrated systems, contact your service provider.

## Connect to Azure Stack Hub with Azure AD

```powershell  
    Add-AzureRMEnvironment -Name "AzureStackUser" -ArmEndpoint "https://management.local.azurestack.external"
    # Set your tenant name
    $AuthEndpoint = (Get-AzureRmEnvironment -Name "AzureStackUser").ActiveDirectoryAuthority.TrimEnd('/')
    $AADTenantName = "<myDirectoryTenantName>.onmicrosoft.com"
    $TenantId = (invoke-restmethod "$($AuthEndpoint)/$($AADTenantName)/.well-known/openid-configuration").issuer.TrimEnd('/').Split('/')[-1]

    # After signing in to your environment, Azure Stack Hub cmdlets
    # can be easily targeted at your Azure Stack Hub instance.
    Add-AzureRmAccount -EnvironmentName "AzureStackUser" -TenantId $TenantId
```

## Connect to Azure Stack Hub with AD FS

  ```powershell  
  # Register an Azure Resource Manager environment that targets your Azure Stack Hub instance
  Add-AzureRMEnvironment -Name "AzureStackUser" -ArmEndpoint "https://management.local.azurestack.external"

  # Sign in to your environment
  Login-AzureRmAccount -EnvironmentName "AzureStackUser"
  ```

## Register resource providers

Resource providers aren't automatically registered for new user subscriptions that don't have any resources deployed through the portal. You can explicitly register a resource provider by running the following script:

```powershell  
foreach($s in (Get-AzureRmSubscription)) {
        Select-AzureRmSubscription -SubscriptionId $s.SubscriptionId | Out-Null
        Write-Progress $($s.SubscriptionId + " : " + $s.SubscriptionName)
Get-AzureRmResourceProvider -ListAvailable | Register-AzureRmResourceProvider
    }
```

## Test the connectivity

When you've got everything setup, test connectivity by using PowerShell to create resources in Azure Stack Hub. As a test, create a resource group for an application and add a VM. Run the following command to create a resource group named "MyResourceGroup":

```powershell  
New-AzureRmResourceGroup -Name "MyResourceGroup" -Location "Local"
```

## Next steps

- [Develop templates for Azure Stack Hub](azure-stack-develop-templates.md)
- [Deploy templates with PowerShell](azure-stack-deploy-template-powershell.md)
- [Azure Stack Hub PowerShell Module Reference](https://docs.microsoft.com/powershell/azure/azure-stack/overview)
- If you want to set up PowerShell for the cloud operator environment, refer to the [Configure the Azure Stack Hub operator's PowerShell environment](../operator/azure-stack-powershell-configure-admin.md) article.
