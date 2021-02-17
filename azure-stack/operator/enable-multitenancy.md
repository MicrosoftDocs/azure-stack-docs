---
title: Configure multi-tenancy in Azure Stack Hub 
description: Learn how to configure multi-tenancy for guest Azure Active Directory tenants in Azure Stack Hub.
author: BryanLa
ms.topic: how-to
ms.date: 02/19/2021
ms.author: bryanla
ms.reviewer: bryanr
ms.lastreviewed: 02/19/2021
zone_pivot_groups: management-tool-portal-powershell

# Intent: As an Azure Stack operator, I want to configure multi-tenancy so multiple directory tenants can access my Azure Stack.
# Keyword: configure multi-tenancy azure stack
---


# Configure multi-tenancy in Azure Stack Hub

You can configure Azure Stack Hub to support sign-ins from users that reside in other Azure Active Directory (Azure AD) directories, allowing them to use services in Azure Stack Hub. These directories have a "guest" relationship with your Azure Stack Hub, and as such, are considered guest Azure AD tenants. For example, consider the following scenario:

- You're the service administrator of contoso.onmicrosoft.com, the home Azure AD tenant providing identity and access management services to your Azure Stack Hub.
- Mary is the directory administrator of adatum.onmicrosoft.com, the guest Azure AD tenant where guest users are located.
- Mary's company (Adatum) uses IaaS and PaaS services from your company. Adatum wants to allow users from the guest directory (adatum.onmicrosoft.com) to sign in and use Azure Stack Hub resources secured by contoso.onmicrosoft.com.

This guide provides the steps required, in the context of this scenario, to enable or disable multi-tenancy in Azure Stack Hub for a guest directory tenant. You and Mary accomplish this process by registering/unregistering the guest directory tenant, which will enable/disable Azure Stack Hub sign-ins and service consumption by Adatum users. 

If you're a Cloud Solution Provider (CSP), you have additional ways you can [configure and manage a multi-tenant Azure Stack Hub](azure-stack-add-manage-billing-as-a-csp.md). 

::: zone pivot="management-tool-powershell"
## Prerequisites

Before registering or unregistering a guest directory, you and Mary must complete administrative steps for your respective Azure AD tenants: the Azure Stack Hub home directory (Contoso), and the guest directory (Adatum):

 - [Install](powershell-install-az-module.md) and [configure](azure-stack-powershell-configure-admin.md) PowerShell for Azure Stack Hub.
 - [Download the Azure Stack Hub Tools](azure-stack-powershell-download.md), and import the Connect and Identity modules:

    ```powershell
    Import-Module .\Identity\AzureStack.Identity.psm1
    ```

## Register a guest directory

To register a guest directory for multi-tenancy, both the home Azure Stack Hub directory and guest directory will need to be configured.

#### Configure Azure Stack Hub directory

As the service administrator of contoso.onmicrosoft.com, you must first onboard the Adatum's guest directory tenant to Azure Stack Hub. The following script will configure Azure Resource Manager to accept sign-ins from users and service principals in the adatum.onmicrosoft.com tenant:

```powershell  
## The following Azure Resource Manager endpoint is for the ASDK. If you're in a multinode environment, contact your operator or service provider to get the endpoint, formatted as adminmanagement.<region>.<FQDN>.
$adminARMEndpoint = "https://adminmanagement.local.azurestack.external"

## Replace the value below with the Azure Stack Hub directory
$azureStackDirectoryTenant = "contoso.onmicrosoft.com"

## Replace the value below with the guest directory tenant. 
$guestDirectoryTenantToBeOnboarded = "adatum.onmicrosoft.com"

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

#### Configure guest directory

Next, Mary (directory admin of Adatum) must register Azure Stack Hub with the adatum.onmicrosoft.com guest directory, by running the following script:

```powershell
## The following Azure Resource Manager endpoint is for the ASDK. If you're in a multinode environment, contact your operator or service provider to get the endpoint, formatted as management.<region>.<FQDN>.
$tenantARMEndpoint = "https://management.local.azurestack.external"
    
## Replace the value below with the guest directory tenant.
$guestDirectoryTenantName = "adatum.onmicrosoft.com"

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

### Direct users to sign in

Finally, Mary can direct Adatum users with @adatum.onmicrosoft.com accounts to sign in by visiting the [Azure Stack Hub user portal](../user/azure-stack-use-portal.md). For multinode systems, the user portal URL is formatted as `https://management.<region>.<FQDN>`. For an ASDK deployment, the URL is `https://portal.local.azurestack.external`.

Mary must also direct any foreign principals (users in the Adatum directory without the suffix of adatum.onmicrosoft.com) to sign in using `https://<user-portal-url>/adatum.onmicrosoft.com`. If they don't specify the `/adatum.onmicrosoft.com` directory tenant in the URL, they're sent to their default directory and receive an error that says their administrator hasn't consented.

## Unregister a guest directory

If you no longer want to allow sign-ins to Azure Stack Hub services from a guest directory tenant, you can unregister the directory. Again, both the home Azure Stack Hub directory and guest directory will need to be configured:

1. As the administrator of the guest directory (Mary in this scenario), run `Unregister-AzsWithMyDirectoryTenant`. The cmdlet uninstalls all the Azure Stack Hub apps from the new directory.

    ``` PowerShell
    ## The following Azure Resource Manager endpoint is for the ASDK. If you're in a multinode environment, contact your operator or service provider to get the endpoint, formatted as management.<region>.<FQDN>.
    $tenantARMEndpoint = "https://management.local.azurestack.external"
        
    ## Replace the value below with the guest directory tenant.
    $guestDirectoryTenantName = "adatum.onmicrosoft.com"
    
    Unregister-AzsWithMyDirectoryTenant `
     -TenantResourceManagerEndpoint $tenantARMEndpoint `
     -DirectoryTenantName $guestDirectoryTenantName `
     -Verbose 
    ```

2. As the service administrator of Azure Stack Hub (you in this scenario), run the `Unregister-AzSGuestDirectoryTenant` cmdlet:

    ``` PowerShell
    ## The following Azure Resource Manager endpoint is for the ASDK. If you're in a multinode environment, contact your operator or service provider to get the endpoint, formatted as adminmanagement.<region>.<FQDN>.
    $adminARMEndpoint = "https://adminmanagement.local.azurestack.external"
    
    ## Replace the value below with the Azure Stack Hub directory
    $azureStackDirectoryTenant = "contoso.onmicrosoft.com"
    
    ## Replace the value below with the guest directory tenant. 
    $guestDirectoryTenantToBeDecommissioned = "adatum.onmicrosoft.com"
    
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

## Update Azure AD tenant permissions

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
::: zone-end

::: zone pivot="management-tool-portal"
## Register a guest directory

To register a guest directory for multi-tenancy, both the home Azure Stack Hub directory and guest directory will need to be configured.

#### Configure Azure Stack Hub directory

The first step is to make your Azure Stack Hub system aware of the guest directory. In this example, the directory from Mary's company Adatum is called **adatum.onmicrosoft.com**.

1. Sign in to the Azure Stack Hub administrator portal and go to **All services - Directories**.

   [![Directories list](./media/azure-stack-enable-multitenancy/directories.png)](./media/azure-stack-enable-multitenancy/directories-expanded.png#lightbox)

2. Select **Add** to start the onboarding process. Enter the guest directory name "adatum.onmicrosoft.com", and then click **Add** at the bottom of the page.

   [![Add](./media/azure-stack-enable-multitenancy/add-directory.png)](./media/azure-stack-enable-multitenancy/add-directory-expanded.png#lightbox)

3. The guest directory appears in the list view, with a status of **unregistered**.

   [![Registered](./media/azure-stack-enable-multitenancy/unregistered.png)](./media/azure-stack-enable-multitenancy/unregistered-expanded.png#lightbox)

4. Only Mary has the credentials to authenticate to the guest directory, so you must send her the link to complete the registration. Check the box next to **adatum.onmicrosoft.com** and then select **Register**.

   [![Click Register](./media/azure-stack-enable-multitenancy/register.png)](./media/azure-stack-enable-multitenancy/register-expanded.png#lightbox)

5. A new browser tab opens. Select **Copy link** at the bottom of the page, and provide it to Mary.

6. If you have the credentials for the guest directory, you can complete the registration yourself by clicking **Sign in**.

   [![Sign in](./media/azure-stack-enable-multitenancy/sign-in.png)](./media/azure-stack-enable-multitenancy/sign-in-expanded.png#lightbox)

#### Configure guest directory

Mary received the email with the link to register the directory. She opens the link in the browser and confirms the Azure Active Directory and the Azure Resource Manager endpoint of your Azure Stack Hub system.

1. Mary clicks **Sign in** using her global admin credentials for adatum.onmicrosoft.com.

   > [!NOTE]
   > Make sure pop-up blockers are disabled before signing in.

   [![Sign in to manage directory](./media/azure-stack-enable-multitenancy/sign-in.png)](./media/azure-stack-enable-multitenancy/sign-in-expanded.png#lightbox)

2. Mary reviews the status for the directory and sees it is not registered.

   [![Manage directory](./media/azure-stack-enable-multitenancy/not-registered.png)](./media/azure-stack-enable-multitenancy/not-registered-expanded.png#lightbox)

3. Mary clicks **Register** to start the process. 

   > [!NOTE]
   > Required objects for Visual Studio Code might not be able to be created, and must use PowerShell.

   ![Register directory](./media/azure-stack-enable-multitenancy/register-directory.png)

4. Once the registration process is finished, Mary can review all the applications that were created in the directory, and check their status.

   ![Check app status](./media/azure-stack-enable-multitenancy/manage-directory.png)

5. Mary has successfully completed the registration process and can now start using the Azure Stack Hub system with her directory **adatum.onmicrosoft.com**.

> [!IMPORTANT]
> It can take up to one hour for the Azure Stack operator to see the directory status updated in the admin portal.

### Direct users to sign in

Finally, Mary can direct Adatum users with @adatum.onmicrosoft.com accounts to sign in by visiting the [Azure Stack Hub user portal](../user/azure-stack-use-portal.md). For multinode systems, the user portal URL is formatted as `https://management.<region>.<FQDN>`. For an ASDK deployment, the URL is `https://portal.local.azurestack.external`.

Mary must also direct any foreign principals (users in the Adatum directory without the suffix of adatum.onmicrosoft.com) to sign in using `https://<user-portal-url>/adatum.onmicrosoft.com`. If they don't specify the `/adatum.onmicrosoft.com` directory tenant in the URL, they're sent to their default directory and receive an error that says their administrator hasn't consented.

## Unregister a guest directory

If you no longer want to allow sign-ins to Azure Stack Hub services from a guest directory tenant, you can unregister the directory. Again, both the home Azure Stack Hub directory and guest directory will need to be configured:

#### Configure guest directory

Mary no longer uses services on Azure Stack Hub and must remove the objects. She opens the URL again that she received via email to unregister the directory. Before starting this process, Mary removes all the resources from the Azure Stack Hub subscription.

1. Mary clicks **Sign in** using her global admin credentials for **adatum.onmicrosoft.com**.

   > [!NOTE]
   > Make sure pop-up blockers are disabled before signing in.

   [![Graphical user interface, application description automatically generated](./media/azure-stack-enable-multitenancy/sign-in.png)](./media/azure-stack-enable-multitenancy/sign-in-expanded.png#lightbox)

2. Mary sees the status of the directory.

   ![Directory status](./media/azure-stack-enable-multitenancy/manage-directory.png)

3. Mary clicks **Unregister** to start the action.

   ![Unregister](./media/azure-stack-enable-multitenancy/unregister-directory.png)

4. When the process has finished, the status is shown as **Not registered**:

   [![Not registered](./media/azure-stack-enable-multitenancy/status-not-registered-2.png)](./media/azure-stack-enable-multitenancy/status-not-registered-2-expanded.png#lightbox)

   Mary has successfully unregistered the directory **adatum.onmicrosoft.com**.

   > [!NOTE]
   > It can take up to one hour to show the directory as not registered in the Azure Stack admin portal.

#### Configure Azure Stack Hub directory

As an Azure Stack Hub operator, you can remove the guest directory at any point, even if Mary has not previously unregistered the directory.

1. Sign in to the Azure Stack Hub administrator portal and go to **All services - Directories**.

   [![All services directories](./media/azure-stack-enable-multitenancy/directory-list.png)](./media/azure-stack-enable-multitenancy/directory-list-expanded.png#lightbox)

2. Check the box next to the directory **adatum.onmicrosoft.com** and select **Remove**.

   [![Remove](./media/azure-stack-enable-multitenancy/directory-list-2.png)](./media/azure-stack-enable-multitenancy/directory-list-2-expanded.png#lightbox)

3. Confirm the delete action by typing **yes** and selecting **Remove**.

   [![Select Remove](./media/azure-stack-enable-multitenancy/remove-directory.png)](./media/azure-stack-enable-multitenancy/remove-directory-expanded.png#lightbox)

   You have successfully removed the directory.

## Managing required updates

Azure Stack Hub updates can introduce support for new tools or services that might require an update of the home or guest directory.

As an Azure Stack Hub operator, you get an alert in the admin portal that informs you about a required directory update. You can also determine whether an update is required for home or guest directories by viewing the directories blade in the admin portal. Each directory listing shows the type of directory. The type can be a home or guest directory, and its status is shown. 

#### Update Azure Stack Hub directories

When an Azure Stack Hub directory update is required, a status of **Update Required** is shown. For example:

[![Update home directory](./media/azure-stack-enable-multitenancy/update-directory.png)](./media/azure-stack-enable-multitenancy/update-directory.png#lightbox)

To update the directory, check the box in front of the **Directory name** and select **Update**.

#### Update guest directory

An Azure Stack Hub operator must also inform the guest directory owner, that they must update their directory via the URL shared for registration. The operator can also send the URL again, but it does not change.

Mary, the owner of the guest directory, opens the URL again that she received via email when doing the initial directory registration:

1. Mary selects **Sign in** using her global admin credentials for **adatum.onmicrosoft.com**. Make sure pop-up blockers are disabled before signing in.

   ![Graphical user interface, application Description automatically generated](./media/azure-stack-enable-multitenancy/sign-in.png)

2. Mary sees the status of the directory saying an update is required.

3. The **Update** action is available for Mary to update the guest directory. It can take up to one hour to show the directory as registered
in the Azure Stack admin portal.

## Additional capabilities

An Azure Stack Hub operator can view the subscriptions associated with a directory. In addition, each directory has an action to manage the directory directly in the Azure portal. To manage, the target directory must have manage permissions in the Azure portal.
::: zone-end

## Next steps

- [Manage delegated providers](azure-stack-delegated-provider.md)
- [Azure Stack Hub key concepts](azure-stack-overview.md)
- [Manage usage and billing for Azure Stack Hub as a Cloud Solution Provider](azure-stack-add-manage-billing-as-a-csp.md)
- [Add tenant for usage and billing to Azure Stack Hub](azure-stack-csp-howto-register-tenants.md)
