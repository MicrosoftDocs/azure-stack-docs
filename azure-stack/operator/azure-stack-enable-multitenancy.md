---
title: Configure multi-tenancy in Azure Stack Hub 
description: Learn how to enable and disable multiple Azure Active Directory tenants in Azure Stack Hub.
author: IngridAtMicrosoft

ms.topic: article
ms.date: 06/10/2019
ms.author: inhenkel
ms.reviewer: bryanr
ms.lastreviewed: 06/10/

# Intent: As an Azure Stack operator, I want to configure multi-tenancy so multiple tenants can access my Azure Stack.
# Keyword: configure multi-tenancy azure stack

---


# Configure multi-tenancy in Azure Stack Hub

You can configure Azure Stack Hub to support users from multiple Azure Active Directory (Azure AD) tenants, allowing them to use services in Azure Stack Hub. For example, consider the following scenario:

- You're the service administrator of contoso.onmicrosoft.com, where Azure Stack Hub is installed.
- Mary is the directory administrator of fabrikam.onmicrosoft.com, where guest users are located.
- Mary's company receives IaaS and PaaS services from your company and needs to allow users from the guest directory (fabrikam.onmicrosoft.com) to sign in and use Azure Stack Hub resources in contoso.onmicrosoft.com.

This guide provides the steps required, in the context of this scenario, to configure multi-tenancy in Azure Stack Hub. In this scenario, you and Mary must complete steps to enable users from Fabrikam to sign in and consume services from the Azure Stack Hub deployment in Contoso.

## Enable multi-tenancy

There are a few prerequisites to account for before you configure multi-tenancy in Azure Stack Hub:
  
 - You and Mary must coordinate administrative steps across both the directory Azure Stack Hub is installed in (Contoso), and the guest directory (Fabrikam).
 - Make sure you've [installed](azure-stack-powershell-install.md) and [configured](azure-stack-powershell-configure-admin.md) PowerShell for Azure Stack Hub.
 - [Download the Azure Stack Hub Tools](azure-stack-powershell-download.md), and import the Connect and Identity modules:

    ```powershell
    Import-Module .\Connect\AzureStack.Connect.psm1
    Import-Module .\Identity\AzureStack.Identity.psm1
    ```

### Configure Azure Stack Hub directory

In this section, you configure Azure Stack Hub to allow sign-ins from Fabrikam Azure AD directory tenants.

Onboard the guest directory tenant (Fabrikam) to Azure Stack Hub by configuring Azure Resource Manager to accept users and service principals from the guest directory tenant.

The service admin of contoso.onmicrosoft.com runs the following commands:

```powershell  
## The following Azure Resource Manager endpoint is for the ASDK. If you're in a multinode environment, contact your operator or service provider to get the endpoint.
$adminARMEndpoint = "https://adminmanagement.local.azurestack.external"

## Replace the value below with the Azure Stack Hub directory
$azureStackDirectoryTenant = "contoso.onmicrosoft.com"

## Replace the value below with the guest tenant directory. 
$guestDirectoryTenantToBeOnboarded = "fabrikam.onmicrosoft.com"

## Replace the value below with the name of the resource group in which the directory tenant registration resource should be created (resource group must already exist).
$ResourceGroupName = "system.local"

## Replace the value below with the region location of the resource group.
$location = "local"

# Subscription Name
$SubscriptionName = "Default Provider Subscription"

Register-AzSGuestDirectoryTenant -AdminResourceManagerEndpoint $adminARMEndpoint `
 -DirectoryTenantName $azureStackDirectoryTenant `
 -GuestDirectoryTenantName $guestDirectoryTenantToBeOnboarded `
 -Location $location `
 -ResourceGroupName $ResourceGroupName `
 -SubscriptionName $SubscriptionName
```

### Configure guest directory

Once the Azure Stack Hub operator has enabled the Fabrikam directory to be used with Azure Stack Hub, Mary must register Azure Stack Hub with Fabrikam's directory tenant.

#### Registering Azure Stack Hub with the guest directory

Mary (directory admin of Fabrikam) runs the following commands in the guest directory fabrikam.onmicrosoft.com:

```powershell
## The following Azure Resource Manager endpoint is for the ASDK. If you're in a multinode environment, contact your operator or service provider to get the endpoint.
$tenantARMEndpoint = "https://management.local.azurestack.external"
    
## Replace the value below with the guest tenant directory.
$guestDirectoryTenantName = "fabrikam.onmicrosoft.com"

Register-AzSWithMyDirectoryTenant `
 -TenantResourceManagerEndpoint $tenantARMEndpoint `
 -DirectoryTenantName $guestDirectoryTenantName `
 -Verbose
```

> [!IMPORTANT]
> If your Azure Stack Hub admin installs new services or updates in the future, you may need to run this script again.
>
> Run this script again at any time to check the status of the Azure Stack Hub apps in your directory.
>
> If you've noticed issues with creating VMs in Managed Disks (introduced in the 1808 update), a new **Disk Resource Provider** was added requiring this script to be run again.

### Direct users to sign in

Now that you and Mary have completed the steps to onboard Mary's directory, Mary can direct Fabrikam users to sign in. Fabrikam users (users with the fabrikam.onmicrosoft.com suffix) sign in by visiting https\://portal.local.azurestack.external.

Mary will direct any [foreign principals](/azure/role-based-access-control/rbac-and-directory-admin-roles) in the Fabrikam directory (users in the Fabrikam directory without the suffix of fabrikam.onmicrosoft.com) to sign in using https\://portal.local.azurestack.external/fabrikam.onmicrosoft.com. If they don't use this URL, they're sent to their default directory (Fabrikam) and receive an error that says their admin hasn't consented.

## Disable multi-tenancy

If you no longer want multiple tenants in Azure Stack Hub, you can disable multi-tenancy by doing the following steps in order:

1. As the admin of the guest directory (Mary in this scenario), run *Unregister-AzsWithMyDirectoryTenant*. The cmdlet uninstalls all the Azure Stack Hub apps from the new directory.

    ``` PowerShell
    ## The following Azure Resource Manager endpoint is for the ASDK. If you're in a multinode environment, contact your operator or service provider to get the endpoint.
    $tenantARMEndpoint = "https://management.local.azurestack.external"
        
    ## Replace the value below with the guest tenant directory.
    $guestDirectoryTenantName = "fabrikam.onmicrosoft.com"
    
    Unregister-AzsWithMyDirectoryTenant `
     -TenantResourceManagerEndpoint $tenantARMEndpoint `
     -DirectoryTenantName $guestDirectoryTenantName `
     -Verbose 
    ```

2. As the service admin of Azure Stack Hub (you in this scenario), run *Unregister-AzSGuestDirectoryTenant*.

    ``` PowerShell
    ## The following Azure Resource Manager endpoint is for the ASDK. If you're in a multinode environment, contact your operator or service provider to get the endpoint.
    $adminARMEndpoint = "https://adminmanagement.local.azurestack.external"
    
    ## Replace the value below with the Azure Stack Hub directory
    $azureStackDirectoryTenant = "contoso.onmicrosoft.com"
    
    ## Replace the value below with the guest tenant directory. 
    $guestDirectoryTenantToBeDecommissioned = "fabrikam.onmicrosoft.com"
    
    ## Replace the value below with the name of the resource group in which the directory tenant registration resource should be created (resource group must already exist).
    $ResourceGroupName = "system.local"
    
    Unregister-AzSGuestDirectoryTenant -AdminResourceManagerEndpoint $adminARMEndpoint `
     -DirectoryTenantName $azureStackDirectoryTenant `
     -GuestDirectoryTenantName $guestDirectoryTenantToBeDecommissioned `
     -ResourceGroupName $ResourceGroupName
    ```

    > [!WARNING]
    > The disable multi-tenancy steps must be performed in order. Step #1 fails if step #2 is completed first.

## Next steps

- [Manage delegated providers](azure-stack-delegated-provider.md)
- [Azure Stack Hub key concepts](azure-stack-overview.md)
- [Manage usage and billing for Azure Stack Hub as a Cloud Solution Provider](azure-stack-add-manage-billing-as-a-csp.md)
- [Add tenant for usage and billing to Azure Stack Hub](azure-stack-csp-howto-register-tenants.md)
