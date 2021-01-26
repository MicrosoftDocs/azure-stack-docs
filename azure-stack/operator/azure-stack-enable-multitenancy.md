---
title: Configure multi-tenancy in Azure Stack Hub 
description: Learn how to configure multi-tenancy for guest Azure Active Directory tenants in Azure Stack Hub.
author: BryanLa
ms.topic: how-to
ms.date: 01/26/2021
ms.author: bryanla
ms.reviewer: bryanr
ms.lastreviewed: 01/26/2021

# Intent: As an Azure Stack operator, I want to configure multi-tenancy so multiple directory tenants can access my Azure Stack.
# Keyword: configure multi-tenancy azure stack

---


# Configure multi-tenancy in Azure Stack Hub

You can configure Azure Stack Hub to support sign-ins from users that reside in other Azure Active Directory (Azure AD) directories, allowing them to use services in Azure Stack Hub. These directories have a "guest" relationship with your Azure Stack Hub, and as such, are considered guest Azure AD tenants. For example, consider the following scenario:

- You're the service administrator of contoso.onmicrosoft.com, the home Azure AD tenant providing identity and access management services to your Azure Stack Hub.
- Mary is the directory administrator of fabrikam.onmicrosoft.com, the guest Azure AD tenant where guest users are located.
- Mary's company (Fabrikam) uses IaaS and PaaS services from your company. Fabrikam wants to allow users from the guest directory (fabrikam.onmicrosoft.com) to sign in and use Azure Stack Hub resources secured by contoso.onmicrosoft.com.

This guide provides the steps required, in the context of this scenario, to enable or disable multi-tenancy in Azure Stack Hub for a guest directory tenant. You and Mary accomplish this process by registering/unregistering the guest directory tenant, which will enable/disable Azure Stack Hub sign-ins and service consumption by Fabrikam users. 

If you're a Cloud Solution Provider (CSP), you have additional ways you can [configure and manage a multi-tenant Azure Stack Hub](azure-stack-add-manage-billing-as-a-csp.md). 

## Prerequisites

Before registering or unregistering a guest directory, you and Mary must complete administrative steps for your respective Azure AD tenants: the Azure Stack Hub home directory (Contoso), and the guest directory (Fabrikam):

 - [Install](powershell-install-az-module.md) and [configure](azure-stack-powershell-configure-admin.md) PowerShell for Azure Stack Hub.
 - [Download the Azure Stack Hub Tools](azure-stack-powershell-download.md), and import the Connect and Identity modules:

    ```powershell
    Import-Module .\Identity\AzureStack.Identity.psm1
    ```

## Register a guest directory

To register a guest directory for multi-tenancy, both the home Azure Stack Hub directory and guest directory will need to be configured.

### Configure Azure Stack Hub directory

1. As the service administrator of contoso.onmicrosoft.com, you must first onboard the Fabrikam's guest directory tenant to Azure Stack Hub. The following script will configure Azure Resource Manager to accept sign-ins from users and service principals in the fabrikam.onmicrosoft.com tenant:

```powershell  
## The following Azure Resource Manager endpoint is for the ASDK. If you're in a multinode environment, contact your operator or service provider to get the endpoint, formatted as adminmanagement.<region>.<FQDN>.
$adminARMEndpoint = "https://adminmanagement.local.azurestack.external"

## Replace the value below with the Azure Stack Hub directory
$azureStackDirectoryTenant = "contoso.onmicrosoft.com"

## Replace the value below with the guest directory tenant. 
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

2. Next, Mary (directory admin of Fabrikam) must register Azure Stack Hub with the fabrikam.onmicrosoft.com guest directory, by running the following script:

```powershell
## The following Azure Resource Manager endpoint is for the ASDK. If you're in a multinode environment, contact your operator or service provider to get the endpoint, formatted as management.<region>.<FQDN>.
$tenantARMEndpoint = "https://management.local.azurestack.external"
    
## Replace the value below with the guest directory tenant.
$guestDirectoryTenantName = "fabrikam.onmicrosoft.com"

Register-AzSWithMyDirectoryTenant `
 -TenantResourceManagerEndpoint $tenantARMEndpoint `
 -DirectoryTenantName $guestDirectoryTenantName `
 -Verbose
```

> [!IMPORTANT]
> If your Azure Stack Hub administrator installs new services or updates in the future, you may need to run this script again.
>
> Run this script again at any time to check the status of the Azure Stack Hub apps in your directory.
>
> If you've noticed issues with creating VMs in Managed Disks (introduced in the 1808 update), a new **Disk Resource Provider** was added requiring this script to be run again.

3. Finally, Mary can direct Fabrikam users with @fabrikam.onmicrosoft.com accounts to sign in by visiting the [Azure Stack Hub user portal](../user/azure-stack-use-portal.md). For multinode systems, the user portal URL is formatted as `https://management.<region>.<FQDN>`. For an ASDK deployment, the URL is `https://portal.local.azurestack.external`.

Mary must also direct any foreign principals (users in the Fabrikam directory without the suffix of fabrikam.onmicrosoft.com) to sign in using `https://<user-portal-url>/fabrikam.onmicrosoft.com`. If they don't specify the `/fabrikam.onmicrosoft.com` directory tenant in the URL, they're sent to their default directory and receive an error that says their administrator hasn't consented.

## Unregister a guest directory

If you no longer want to allow sign-ins to Azure Stack Hub services from a guest directory tenant, you can unregister the directory:

1. As the administrator of the guest directory (Mary in this scenario), run *Unregister-AzsWithMyDirectoryTenant*. The cmdlet uninstalls all the Azure Stack Hub apps from the new directory.

    ``` PowerShell
    ## The following Azure Resource Manager endpoint is for the ASDK. If you're in a multinode environment, contact your operator or service provider to get the endpoint, formatted as management.<region>.<FQDN>.
    $tenantARMEndpoint = "https://management.local.azurestack.external"
        
    ## Replace the value below with the guest directory tenant.
    $guestDirectoryTenantName = "fabrikam.onmicrosoft.com"
    
    Unregister-AzsWithMyDirectoryTenant `
     -TenantResourceManagerEndpoint $tenantARMEndpoint `
     -DirectoryTenantName $guestDirectoryTenantName `
     -Verbose 
    ```

2. As the service administrator of Azure Stack Hub (you in this scenario), run *Unregister-AzSGuestDirectoryTenant*.

    ``` PowerShell
    ## The following Azure Resource Manager endpoint is for the ASDK. If you're in a multinode environment, contact your operator or service provider to get the endpoint, formatted as adminmanagement.<region>.<FQDN>.
    $adminARMEndpoint = "https://adminmanagement.local.azurestack.external"
    
    ## Replace the value below with the Azure Stack Hub directory
    $azureStackDirectoryTenant = "contoso.onmicrosoft.com"
    
    ## Replace the value below with the guest directory tenant. 
    $guestDirectoryTenantToBeDecommissioned = "fabrikam.onmicrosoft.com"
    
    ## Replace the value below with the name of the resource group in which the directory tenant resource was created (resource group must already exist).
    $ResourceGroupName = "system.local"
    
    Unregister-AzSGuestDirectoryTenant -AdminResourceManagerEndpoint $adminARMEndpoint `
     -DirectoryTenantName $azureStackDirectoryTenant `
     -GuestDirectoryTenantName $guestDirectoryTenantToBeDecommissioned `
     -ResourceGroupName $ResourceGroupName
    ```

    > [!WARNING]
    > The disable multi-tenancy steps must be performed in order. Step #1 fails if step #2 is completed first.

## Retrieve Azure Stack Hub identity health report 

Replace the `<region>`, `<domain>`, and `<homeDirectoryTenant>` placeholders, then execute the following cmdlet as the Azure Stack Hub administrator.

```powershell

$AdminResourceManagerEndpoint = "https://adminmanagement.<region>.<domain>"
$DirectoryName = "<homeDirectoryTenant>.onmicrosoft.com"
$healthReport = Get-AzsHealthReport -AdminResourceManagerEndpoint $AdminResourceManagerEndpoint -DirectoryTenantName $DirectoryName
Write-Host "Healthy directories: "
$healthReport.directoryTenants | Where status -EQ 'Healthy' | Select -Property tenantName,tenantId,status | ft


Write-Host "Unhealthy directories: "
$healthReport.directoryTenants | Where status -NE 'Healthy' | Select -Property tenantName,tenantId,status | ft
```

### Update Azure AD tenant permissions

This action will clear an alert in Azure Stack Hub, indicating that a directory requires an update. Run the following command from the **Azurestack-tools-master/identity** folder:

```powershell
Import-Module ..\Identity\AzureStack.Identity.psm1

$adminResourceManagerEndpoint = "https://adminmanagement.<region>.<domain>"

# This is the primary tenant Azure Stack Hub is registered to:
$homeDirectoryTenantName = "<homeDirectoryTenant>.onmicrosoft.com"

Update-AzsHomeDirectoryTenant -AdminResourceManagerEndpoint $adminResourceManagerEndpoint `
   -DirectoryTenantName $homeDirectoryTenantName -Verbose
```

The script prompts you for administrative credentials on the Azure AD tenant, and takes several minutes to run. The alert should clear after you run the cmdlet.

## Next steps

- [Manage delegated providers](azure-stack-delegated-provider.md)
- [Azure Stack Hub key concepts](azure-stack-overview.md)
- [Manage usage and billing for Azure Stack Hub as a Cloud Solution Provider](azure-stack-add-manage-billing-as-a-csp.md)
- [Add tenant for usage and billing to Azure Stack Hub](azure-stack-csp-howto-register-tenants.md)
