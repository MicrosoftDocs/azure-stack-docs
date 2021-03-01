---
title: Manage Azure Stack HCI cluster registration with Azure
description: How to manage your Azure registration for Azure Stack HCI clusters, understand registration status, and unregister a cluster when you're ready to decommission it.
author: khdownie
ms.author: v-kedow
ms.topic: how-to
ms.date: 02/10/2021
---

# Manage cluster registration with Azure

> Applies to Azure Stack HCI version 20H2

After you've created an Azure Stack HCI cluster, you must [register Windows Admin Center with Azure](register-windows-admin-center.md) and then [register the cluster with Azure](../deploy/register-with-azure.md). After the cluster is registered, it periodically syncs information between the on-premises cluster and the cloud. 

This article explains how to view your registration status, grant Azure Active Directory (Azure AD) permissions, and unregister your cluster when you're ready to decommission it.

## View registration status in Windows Admin Center

When you connect to a cluster by using Windows Admin Center, you'll see the dashboard, which displays the Azure connection status. **Connected** means that the cluster is already registered with Azure and has successfully synced to the cloud within the last day.

:::image type="content" source="media/manage-azure-registration/registration-status.png" alt-text="Screenshot that shows the cluster connection status on the Windows Admin Center dashboard." lightbox="media/manage-azure-registration/registration-status.png":::

You can get more information by selecting **Settings** at the bottom of the **Tools** menu on the left, and then selecting **Azure Stack HCI registration**.

:::image type="content" source="media/manage-azure-registration/azure-stack-hci-registration.png" alt-text="Screenshot that shows selections for getting Azure Stack H C I registration information." lightbox="media/manage-azure-registration/azure-stack-hci-registration.png":::

## View registration status in PowerShell

To view registration status by using Windows PowerShell, use the `Get-AzureStackHCI` PowerShell cmdlet and the `ClusterStatus`, `RegistrationStatus`, and `ConnectionStatus` properties. 

For example, after you install the Azure Stack HCI operating system, but before you create or join a cluster, the `ClusterStatus` property shows a `NotYet` status:

:::image type="content" source="media/manage-azure-registration/1-get-azurestackhci.png" alt-text="Screenshot that shows the Azure registration status before cluster creation.":::

After the cluster is created, only `RegistrationStatus` shows a `NotYet` status:

:::image type="content" source="media/manage-azure-registration/2-get-azurestackhci.png" alt-text="Screenshot that shows the Azure registration status after cluster creation.":::

You must register an Azure Stack HCI cluster within 30 days of installation, as defined in the Azure Online Services Terms. If you haven't created or joined a cluster after 30 days, `ClusterStatus` will show `OutOfPolicy`. If you haven't registered the cluster after 30 days, `RegistrationStatus` will show `OutOfPolicy`.

After the cluster is registered, you can see `ConnectionStatus` and the `LastConnected` time. The `LastConnected` time is usually within the last day unless the cluster is temporarily disconnected from the internet. An Azure Stack HCI cluster can operate fully offline for up to 30 consecutive days.

:::image type="content" source="media/manage-azure-registration/3-get-azurestackhci.png" alt-text="Screenshot that shows the Azure registration status after registration.":::

If you exceed the maximum period of offline operation, `ConnectionStatus` will show `OutOfPolicy`.

## Assign Azure AD app permissions

In addition to creating an Azure resource in your subscription, registering Azure Stack HCI creates an app identity in your Azure AD tenant. This identity is conceptually similar to a user. The app identity inherits the cluster name. This identity acts on behalf on the Azure Stack HCI cloud service, as appropriate, within your subscription.

If the user who registers the cluster is an Azure AD administrator or has sufficient permissions, this all happens automatically. No additional action is required. Otherwise, you might need approval from your Azure AD administrator to complete registration. Your administrator can either explicitly grant consent to the app, or they can delegate permissions so that you can grant consent to the app:

:::image type="content" source="media/manage-azure-registration/aad-permissions.png" alt-text="Diagram that shows Azure Active Directory permissions and identity." border="false":::

To grant consent, open [portal.azure.com](https://portal.azure.com) and sign in with an Azure account that has sufficient permissions in Azure AD. Go to **Azure Active Directory** > **App registrations**. Select the app identity named after your cluster, and go to **API permissions**.

For the general availability (GA) release of Azure Stack HCI, the app requires the following permissions. They're different from the app permissions that were required in public preview.

```http
https://azurestackhci-usage.trafficmanager.net/AzureStackHCI.Cluster.Read

https://azurestackhci-usage.trafficmanager.net/AzureStackHCI.Cluster.ReadWrite

https://azurestackhci-usage.trafficmanager.net/AzureStackHCI.ClusterNode.Read

https://azurestackhci-usage.trafficmanager.net/AzureStackHCI.ClusterNode.ReadWrite
```

For public preview, the app permissions (now deprecated) were:

```http
https://azurestackhci-usage.trafficmanager.net/AzureStackHCI.Census.Sync

https://azurestackhci-usage.trafficmanager.net/AzureStackHCI.Billing.Sync
```

Seeking approval from your Azure AD administrator might take some time, so the `Register-AzStackHCI` cmdlet will exit and leave the registration in a `pending admin consent` (partially completed) status. After consent is granted, rerun `Register-AzStackHCI` to complete registration.

## Assign Azure AD user permissions

The user who runs `Register-AzStackHCI` needs Azure AD permissions to:

- Create (`New-Remove-AzureADApplication`), get (`Get-Remove-AzureADApplication`), set (`Set-Remove-AzureADApplication`), or remove (`Remove-AzureADApplication`) Azure AD applications.
- Create (`New-Get-AzureADServicePrincipal`) or get (`Get-AzureADServicePrincipal`) the Azure AD service principal.
- Manage Active Directory application secrets (`New-Remove-AzureADApplicationKeyCredential`, `Get-Remove-AzureADApplicationKeyCredential`, or `Remove-AzureADApplicationKeyCredential`).
- Grant consent to use specific application permissions (`New-AzureADApplicationKeyCredential`, `Get-AzureADApplicationKeyCredential`, or `Remove-AzureADServiceAppRoleAssignments`).

There are three ways to assign these permissions.

### Option 1: Allow any user to register applications

In Azure Active Directory, go to **User settings** > **App registrations**. Under **Users can register applications**, select **Yes**.

This option allows any user to register applications. However, the user still needs the Azure AD admin to grant consent during cluster registration. 

> [!NOTE]
> This option is a tenant-level setting, so it might not be suitable for large enterprise customers.

### Option 2: Assign the Cloud Application Administration role

Assign the built-in *Cloud Application Administration* Azure AD role to the user. This assignment will allow the user to register and unregister clusters without the need for additional Active Directory admin consent.

### Option 3: Create a custom Active Directory role and consent policy

The most restrictive option is to create a custom Active Directory role with a custom consent policy that delegates tenant-wide admin consent for required permissions to the Azure Stack HCI service. When you assign this custom role to users, they can both register and grant consent without the need for additional Active Directory admin consent.

> [!NOTE]
> This option requires an Azure AD Premium license. It uses custom Active Directory roles and custom consent policy features that are now in public preview.

1. Connect to Azure AD:
   
   ```powershell
   Connect-AzureAD
   ```

2. Create a custom consent policy:

   ```powershell
   New-AzureADMSPermissionGrantPolicy -Id "AzSHCI-registration-consent-policy" -DisplayName "Azure Stack HCI registration admin app consent policy" -Description "Azure Stack HCI registration admin app consent policy"
   ```

3. Add a condition that includes required app permissions for the Azure Stack HCI service, which carries the app ID 1322e676-dee7-41ee-a874-ac923822781c. 
   
   > [!NOTE]
   > The following permissions are for the GA release of Azure Stack HCI. They won't work with public preview unless you have applied the [November 23, 2020, preview update (KB4586852)](https://support.microsoft.com/help/4595086/azure-stack-hci-release-notes-overview) to every server in your cluster and have downloaded Az.StackHCI module version 0.4.1 or later.
   
   ```powershell
   New-AzureADMSPermissionGrantConditionSet -PolicyId "AzSHCI-registration-consent-policy" -ConditionSetType "includes" -PermissionType "application" -ResourceApplication "1322e676-dee7-41ee-a874-ac923822781c" -Permissions "bbe8afc9-f3ba-4955-bb5f-1cfb6960b242","8fa5445e-80fb-4c71-a3b1-9a16a81a1966","493bd689-9082-40db-a506-11f40b68128f","2344a320-6a09-4530-bed7-c90485b5e5e2"
   ```

4. Grant permissions to allow registering Azure Stack HCI, noting the custom consent policy that you created in step 2:
   
   ```powershell
   $displayName = "Azure Stack HCI Registration Administrator "
   $description = "Custom AD role to allow registering Azure Stack HCI "
   $templateId = (New-Guid).Guid
   $allowedResourceAction =
   @(
          "microsoft.directory/applications/createAsOwner",
          "microsoft.directory/applications/delete",
          "microsoft.directory/applications/standard/read",
          "microsoft.directory/applications/credentials/update",
          "microsoft.directory/applications/permissions/update",
          "microsoft.directory/servicePrincipals/appRoleAssignedTo/update",
          "microsoft.directory/servicePrincipals/appRoleAssignedTo/read",
          "microsoft.directory/servicePrincipals/appRoleAssignments/read",
          "microsoft.directory/servicePrincipals/createAsOwner",
          "microsoft.directory/servicePrincipals/credentials/update",
          "microsoft.directory/servicePrincipals/permissions/update",
          "microsoft.directory/servicePrincipals/standard/read",
          "microsoft.directory/servicePrincipals/managePermissionGrantsForAll.AzSHCI-registration-consent-policy"
   )
   $rolePermissions = @{'allowedResourceActions'= $allowedResourceAction}
   ```

5. Create the new custom Active Directory role:

   ```powershell
   $customADRole = New-AzureADMSRoleDefinition -RolePermissions $rolePermissions -DisplayName $displayName -Description $description -TemplateId $templateId -IsEnabled $true
   ```

6. Follow [these instructions](/azure/active-directory/fundamentals/active-directory-users-assign-role-azure-portal?context=/azure/active-directory/roles/context/ugr-context) to assign the new custom Active Directory role to the user who will register the Azure Stack HCI cluster with Azure.

## Unregister Azure Stack HCI by using Windows Admin Center

When you're ready to decommission your Azure Stack HCI cluster, connect to the cluster by using Windows Admin Center. Select **Settings** at the bottom of the **Tools** menu on the left. Then select **Azure Stack HCI registration**, and select the **Unregister** button. 

The unregistration process automatically cleans up the Azure resource that represents the cluster, the Azure resource group (if the group was creating during registration and doesn't contain any other resources), and the Azure AD app identity. This cleanup stops all monitoring, support, and billing functionality through Azure Arc.

> [!NOTE]
> Unregistering an Azure Stack HCI cluster requires an Azure AD administrator or another user who has [sufficient permissions](#azure-ad-user-permissions). 
>
> If your Windows Admin Center gateway is registered to a different Azure Active Directory (tenant) ID than was used to initially register the cluster, you might encounter problems when you try to unregister the cluster by using Windows Admin Center. If this happens, use the following PowerShell instructions.

## Unregister Azure Stack HCI by using PowerShell

You can also use the `Unregister-AzStackHCI` cmdlet to unregister an Azure Stack HCI cluster. You can run the cmdlet either on a cluster node or from a management PC.

You might need to install the latest version of the `Az.StackHCI` module. If you're prompted with `Are you sure you want to install the modules from 'PSGallery'?`, answer yes (`Y`).

```PowerShell
Install-Module -Name Az.StackHCI
```

### Unregister from a cluster node

If you're running the `Unregister-AzStackHCI` cmdlet on a server in the cluster, use the following syntax. Specify your Azure subscription ID and the resource name of the Azure Stack HCI cluster that you want unregister.

```PowerShell
Unregister-AzStackHCI -SubscriptionId "e569b8af-6ecc-47fd-a7d5-2ac7f23d8bfe" -ResourceName HCI001
```

You're prompted to visit microsoft.com/devicelogin on another device (like your PC or phone). Enter the code, and sign in there to authenticate with Azure.

### Unregister from a management PC

If you're running the cmdlet from a management PC, you also need to specify the name of a server in the cluster:

```PowerShell
Unregister-AzStackHCI -ComputerName ClusterNode1 -SubscriptionId "e569b8af-6ecc-47fd-a7d5-2ac7f23d8bfe" -ResourceName HCI001
```

An interactive Azure login window appears. The exact prompts that you see will vary depending on your security settings (for example, two-factor authentication). Follow the prompts to sign in.

## Clean up after a cluster that was not properly unregistered

If a user destroys an Azure Stack HCI cluster without unregistering it, such as by reimaging the host servers or deleting virtual cluster nodes, then artifacts will be left over in Azure. These artifacts are harmless and won't incur billing or use resources, but they can clutter the Azure portal. To clean them up, you can manually delete them.

To delete the Azure Stack HCI resource, go to its page in the Azure portal and select **Delete** from the action bar at the top. Enter the name of the resource to confirm the deletion, and then select **Delete**. 

To delete the Azure AD app identity, go to **Azure AD** > **App Registrations** > **All Applications**. Select **Delete** and confirm.

You can also delete the Azure Stack HCI resource by using PowerShell:

```PowerShell
Remove-AzResource -ResourceId "HCI001"
```

You might need to install the `Az.Resources` module:

```PowerShell
Install-Module -Name Az.Resources
```

If the resource group was created during registration and doesn't contain any other resources, you can delete it too:

```PowerShell
Remove-AzResourceGroup -Name "HCI001-rg"
```

## Next steps

For related information, see:

- [Register Windows Admin Center with Azure](register-windows-admin-center.md)
- [Connect Azure Stack HCI to Azure](../deploy/register-with-azure.md)