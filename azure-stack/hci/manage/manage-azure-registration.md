---
title: Manage Azure registration for Azure Stack HCI
description: How to manage your Azure registration for Azure Stack HCI and understand registration status using PowerShell.
author: khdownie
ms.author: v-kedow
ms.topic: how-to
ms.date: 12/10/2020
---

# Manage Azure registration

> Applies to Azure Stack HCI v20H2

Once you've created an Azure Stack HCI cluster, you must [register the cluster with Azure Arc](../deploy/register-with-azure.md). Once the cluster is registered, it periodically syncs information between the on-premises cluster and the cloud. This topic explains how to understand your registration status, grant Azure Active Directory permissions, and unregister your cluster when you're ready to decommission it.

## Understanding registration status

To understand registration status, use the `Get-AzureStackHCI` PowerShell cmdlet and the `ClusterStatus`, `RegistrationStatus`, and `ConnectionStatus` properties. For example, after installing the Azure Stack HCI operating system, before creating or joining a cluster, the `ClusterStatus` property shows "not yet" status:

:::image type="content" source="media/manage-azure-registration/1-get-azurestackhci.png" alt-text="Azure registration status before cluster creation":::

Once the cluster is created, only `RegistrationStatus` shows "not yet" status:

:::image type="content" source="media/manage-azure-registration/2-get-azurestackhci.png" alt-text="Azure registration status after cluster creation":::

Azure Stack HCI needs to register within 30 days of installation per the Azure Online Services Terms. If not clustered after 30 days, the `ClusterStatus` will show `OutOfPolicy`, and if not registered after 30 days, the `RegistrationStatus` will show `OutOfPolicy`.

Once the cluster is registered, you can see the `ConnectionStatus` and `LastConnected` time, which is usually within the last day unless the cluster is temporarily disconnected from the Internet. An Azure Stack HCI cluster can operate fully offline for up to 30 consecutive days.

:::image type="content" source="media/manage-azure-registration/3-get-azurestackhci.png" alt-text="Azure registration status after registration":::

If that maximum period is exceeded, the `ConnectionStatus` will show `OutOfPolicy`.

## Azure Active Directory app permissions

In addition to creating an Azure resource in your subscription, registering Azure Stack HCI creates an app identity, conceptually similar to a user, in your Azure Active Directory tenant. The app identity inherits the cluster name. This identity acts on behalf on the Azure Stack HCI cloud service, as appropriate, within your subscription.

If the user who runs `Register-AzureStackHCI` is an Azure Active Directory administrator or has been delegated sufficient permissions, this all happens automatically, and no additional action is required. If not, approval may be needed from your Azure Active Directory administrator to complete registration. Your administrator can either explicitly grant consent to the app, or they can delegate permissions so that you can grant consent to the app:

:::image type="content" source="media/manage-azure-registration/aad-permissions.png" alt-text="Azure Active Directory permissions and identity diagram" border="false":::

To grant consent, open [portal.azure.com](https://portal.azure.com) and sign in with an Azure account that has sufficient permissions on the Azure Active Directory. Navigate to **Azure Active Directory**, then **App registrations**. Select the app identity named after your cluster and navigate to **API permissions**.

For the General Availability (GA) release of Azure Stack HCI, the app requires the following permissions, which are different than the app permissions required in Public Preview:

```http
https://azurestackhci-usage.trafficmanager.net/AzureStackHCI.Cluster.Read

https://azurestackhci-usage.trafficmanager.net/AzureStackHCI.Cluster.ReadWrite

https://azurestackhci-usage.trafficmanager.net/AzureStackHCI.ClusterNode.Read

https://azurestackhci-usage.trafficmanager.net/AzureStackHCI.ClusterNode.ReadWrite
```

For Public Preview, the app permissions were (these are now deprecated):

```http
https://azurestackhci-usage.trafficmanager.net/AzureStackHCI.Census.Sync

https://azurestackhci-usage.trafficmanager.net/AzureStackHCI.Billing.Sync
```

Seeking approval from your Azure Active Directory administrator could take some time, so the `Register-AzureStackHCI` cmdlet will exit and leave the registration in status "pending admin consent," i.e. partially completed. Once consent has been granted, simply re-run `Register-AzureStackHCI` to complete registration.

## Azure Active Directory user permissions

The user who runs Register-AzStackHCI needs Azure AD permissions to:

- Create/Get/Set/Remove Azure AD applications (New/Get/Set/Remove-AzureADApplication)
- Create/Get Azure AD service principal (New/Get-New-AzureADServicePrincipal)
- Manage AD application secrets (New/Get/Remove-AzureADApplicationKeyCredential)
- Grant consent to use specific application permissions (New/Get/Remove AzureADServiceAppRoleAssignments)

There are three ways in which this can be accomplished.

### Option 1: Allow any user to register applications

In Azure Active Directory, navigate to **User settings > App registrations**. Under **Users can register applications**, select **Yes**.

This will allow any user to register applications. However, the user will still require the Azure AD admin to grant consent during cluster registration. Note that this is a tenant level setting, so it may not be suitable for large enterprise customers.

### Option 2: Assign Cloud Application Administration role

Assign the built-in "Cloud Application Administration" Azure AD role to the user. This will allow the user to register clusters without the need for additional AD admin consent.

### Option 3: Create a custom AD role and consent policy

The most restrictive option is to create a custom AD role with a custom consent policy that delegates tenant-wide admin consent for required permissions to the Azure Stack HCI Service. When assigned this custom role, users are able to both register and grant consent without the need for additional AD admin consent.

   > [!NOTE]
   > This option requires an Azure AD Premium license and uses custom AD roles and custom consent policy features which are currently in public preview.

   1. Connect to Azure AD:
   
      ```powershell
      Connect-AzureAD
      ```

   2. Create a custom consent policy:

      ```powershell
      New-AzureADMSPermissionGrantPolicy -Id "AzSHCI-registration-consent-policy" -DisplayName "Azure Stack HCI registration admin app consent policy" -Description "Azure Stack HCI registration admin app consent policy"
      ```

   3. Add a condition that includes required app permissions for Azure Stack HCI service, which carries the app ID 1322e676-dee7-41ee-a874-ac923822781c. Note that the following permissions are for the GA release of Azure Stack HCI, and will not work with Public Preview unless you have applied the [November 23, 2020 Preview Update (KB4586852)](https://support.microsoft.com/help/4595086/azure-stack-hci-release-notes-overview) to every server in your cluster and have downloaded the Az.StackHCI module version 0.4.1 or later.
   
      ```powershell
      New-AzureADMSPermissionGrantConditionSet -PolicyId "AzSHCI-registration-consent-policy" -ConditionSetType "includes" -PermissionType "application" -ResourceApplication "1322e676-dee7-41ee-a874-ac923822781c" -Permissions "bbe8afc9-f3ba-4955-bb5f-1cfb6960b242","8fa5445e-80fb-4c71-a3b1-9a16a81a1966","493bd689-9082-40db-a506-11f40b68128f","2344a320-6a09-4530-bed7-c90485b5e5e2"
      ```

   4. Grant permissions to allow registering Azure Stack HCI, noting the custom consent policy created in Step 2:
   
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

   5. Create the new custom AD role:

      ```powershell
      $customADRole = New-AzureADMSRoleDefinition -RolePermissions $rolePermissions -DisplayName $displayName -Description $description -TemplateId $templateId -IsEnabled $true
      ```

   6. Assign the new custom AD role to the user who will register the Azure Stack HCI cluster with Azure by following [these instructions](/azure/active-directory/fundamentals/active-directory-users-assign-role-azure-portal?context=/azure/active-directory/roles/context/ugr-context).

## Unregister Azure Stack HCI with Azure

When you're ready to decommission your Azure Stack HCI cluster, use the `Unregister-AzStackHCI` cmdlet to unregister. This stops all monitoring, support, and billing functionality through Azure Arc. The Azure resource representing the cluster and the Azure Active Directory app identity are deleted, but the resource group is not, because it may contain other unrelated resources.

If running the `Unregister-AzStackHCI` cmdlet on a cluster node, use this syntax and specify your Azure subscription ID as well as the resource name of the Azure Stack HCI cluster you wish to unregister:

```PowerShell
Unregister-AzStackHCI -SubscriptionId "e569b8af-6ecc-47fd-a7d5-2ac7f23d8bfe" -ResourceName HCI001
```

You'll be prompted to visit microsoft.com/devicelogin on another device (like your PC or phone), enter the code, and sign in there to authenticate with Azure.

If running the cmdlet from a management PC, you'll also need to specify the name of a server in the cluster:

```PowerShell
Unregister-AzStackHCI -ComputerName ClusterNode1 -SubscriptionId "e569b8af-6ecc-47fd-a7d5-2ac7f23d8bfe" -ResourceName HCI001
```

An interactive Azure login window will pop up. The exact prompts you see will vary depending on your security settings (e.g. two-factor authentication). Follow the prompts to log in.

## Next steps

For related information, see also:

- [Connect Azure Stack HCI to Azure](../deploy/register-with-azure.md)
- [Monitor Azure Stack HCI with Azure Monitor](azure-monitor.md)