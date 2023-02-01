---
title: Register Azure Stack HCI with Azure
description: How to register Azure Stack HCI clusters with Azure.
author: sethmanheim
ms.author: sethm
ms.reviewer: arduppal
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.custom: references_regions
ms.date: 02/01/2023
---

# Register Azure Stack HCI with Azure

[!INCLUDE [applies-to](../../includes/hci-applies-to-22h2-21h2-20h2.md)]

Now that you've deployed the Azure Stack HCI operating system and created a cluster, you must register the cluster with Azure. Azure Stack HCI is delivered as an Azure service, and must be registered within 30 days of installation (per the Azure online services terms).

This article describes the following topics:

- How to register your Azure Stack HCI cluster with Azure for monitoring, support, billing, and hybrid services. Upon registration, an Azure Resource Manager resource is created to represent the on-premises Azure Stack HCI cluster, and from HCI 21H2 onwards by default it will create an Azure Arc of server resource for each server in the Azure Stack HCI cluster, effectively extending the Azure management plane to Azure Stack HCI. Information is periodically synchronized between the Azure resource and the on-premises cluster(s).
- How to view the registration status from Windows Admin Center and PowerShell.
- How to unregister the cluster when you are ready to decommission it.

   > [!IMPORTANT]
   > Registering with Azure is required, and your cluster is not fully supported until your registration is active. If you do not register your cluster with Azure upon deployment, or if your cluster is registered but has not connected to Azure for more than 30 days, the system will not allow new virtual machines (VMs) to be created or added. When this occurs, you will see the following error message when attempting to create VMs:
   >
   > "There was a failure configuring the virtual machine role for 'vmname'. Job failed. Error opening "vmname" clustered roles. The service being accessed is licensed for a particular number of connections. No more connections can be made to the service at this time because there are already as many connections as the service can accept."
   >
   > The solution is to allow outbound connectivity to Azure and to make sure your cluster is registered as described in this article.

## Region availability

The Azure Stack HCI service is used for registration, billing, and management. It is currently supported in the following regions. These public regions support geographic locations worldwide, for clusters deployed anywhere in the world:

- East US
- South Central US
- Canada Central
- West Europe
- Southeast Asia
- Australia East

This region supports Azure China:

- China East 2

This region supports Azure Government:

- US Gov Virginia

## Prerequisites for cluster registration

- **HCI cluster must exist**: You won't be able to register your cluster with Azure until you've created an Azure Stack HCI cluster. For the cluster to be supported, the cluster nodes must be physical servers. Virtual machines can be used for testing. Make sure every server in the cluster is up and running.
- **Configure internet access and firewall ports**: Azure Stack HCI needs to periodically connect to the Azure public cloud. If outbound connectivity is restricted by your external corporate firewall or proxy server, they must be configured to allow outbound access to port 443 (HTTPS) on a limited number of well-known Azure IPs. For information on how to prepare your firewalls and set up a proxy server, see [Firewall requirements for Azure Stack HCI](../concepts/firewall-requirements.md).

   > [!NOTE]
   > The registration process tries to contact the PowerShell Gallery to verify that you have the latest version of the necessary PowerShell modules such as Az and AzureAD. Although the PowerShell Gallery is hosted on Azure, it does not currently have a service tag. If you cannot run the cmdlet from a management machine that has outbound internet access, we recommend downloading the modules and manually transferring them to a cluster node where you can run the `Register-AzStackHCI` cmdlet. Alternatively, you can [install the modules in a disconnected scenario](/powershell/scripting/gallery/how-to/working-with-local-psrepositories?view=powershell-7.1#installing-powershellget-on-a-disconnected-system&preserve-view=true).
- **Azure subscription and permissions**: If you don't already have an Azure account, [create one](https://azure.microsoft.com/). You can use an existing subscription of any type:
  - Free account with Azure credits [for students](https://azure.microsoft.com/free/students/) or [Visual Studio subscribers](https://azure.microsoft.com/pricing/member-offers/credit-for-visual-studio-subscribers/).
  - [Pay-as-you-go](https://azure.microsoft.com/pricing/purchase-options/pay-as-you-go/) subscription with credit card.
  - Subscription obtained through an Enterprise Agreement (EA).
  - Subscription obtained through the Cloud Solution Provider (CSP) program.

  You can assign permissions using either the Azure portal, or using PowerShell cmdlets.

### Assign permissions from Azure portal

If your Azure subscription is through an EA or CSP, ask your Azure subscription admin to assign Azure subscription level privileges of:

- **User Access Administrator** role: Required to Arc-enable each server of an Azure Stack HCI cluster.
- **Contributor** role: Required to register and unregister the Azure Stack HCI cluster.

:::image type="content" source="media/register-with-azure/access-control.png" alt-text="Screenshot of assign permissions screen." lightbox="media/register-with-azure/access-control.png":::

### Assign permissions using PowerShell

Some admins may prefer a more restrictive option. In this case, it's possible to create a custom Azure role specific for Azure Stack HCI registration by following these steps:

1. Create a json file called **customHCIRole.json** with following content. Make sure to change `<subscriptionID>` to your Azure subscription ID. To get your subscription ID, visit [the Azure portal](https://portal.azure.com), navigate to **Subscriptions**, and copy/paste your ID from the list.

   ```json
   {
     "Name": "Azure Stack HCI registration role",
     "Id": null,
     "IsCustom": true,
     "Description": "Custom Azure role to allow subscription-level access to register Azure Stack HCI",
     "Actions": [
       "Microsoft.Resources/subscriptions/resourceGroups/read",
       "Microsoft.Resources/subscriptions/resourceGroups/write",
       "Microsoft.Resources/subscriptions/resourceGroups/delete", 
       "Microsoft.AzureStackHCI/register/action",
       "Microsoft.AzureStackHCI/Unregister/Action",
       "Microsoft.AzureStackHCI/clusters/*",
       "Microsoft.Authorization/roleAssignments/write",
       "Microsoft.Authorization/roleAssignments/read",
       "Microsoft.HybridCompute/register/action",
       "Microsoft.GuestConfiguration/register/action",
       "Microsoft.HybridConnectivity/register/action"
     ],
     "NotActions": [
     ],
   "AssignableScopes": [
       "/subscriptions/<subscriptionId>"
     ]
   }
   ```

2. Create the custom role:

   ```powershell
   New-AzRoleDefinition -InputFile <path to customHCIRole.json>
   ```

3. Assign the custom role to the user:

   ```powershell
   $user = get-AzAdUser -DisplayName <userdisplayname>
   $role = Get-AzRoleDefinition -Name "Azure Stack HCI registration role"
   New-AzRoleAssignment -ObjectId $user.Id -RoleDefinitionId $role.Id -Scope /subscriptions/<subscriptionid>
   ```

The following table explains why these permissions are required:

| Permissions                                                                                                                                                                                | Reason                                                  |
|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------|
| "Microsoft.Resources/subscriptions/resourceGroups/read",</br> "Microsoft.Resources/subscriptions/resourceGroups/write",</br> "Microsoft.Resources/subscriptions/resourceGroups/delete"</br> "Microsoft.AzureStackHCI/register/action",</br> "Microsoft.AzureStackHCI/Unregister/Action",</br> "Microsoft.AzureStackHCI/clusters/*",</br>"Microsoft.Authorization/roleAssignments/read", | To register and unregister the Azure Stack HCI cluster.      |
| "Microsoft.Authorization/roleAssignments/write",</br> "Microsoft.HybridCompute/register/action",</br> "Microsoft.GuestConfiguration/register/action",</br> "Microsoft.HybridConnectivity/register/action" | To register and unregister the Arc for server resources. |

## Required pre-checks

Make sure to complete the following pre-checks before proceeding with registration:

- **Do not configure conflicting Azure policies**: Make sure you don't have any conflicting Azure policies that might interfere with cluster registration. Some of the common conflicting policies might be:
  - **Resource group naming**: If you are providing values or trying to use the default values, make sure they don't conflict with Azure policy:
    - Resource group name for Azure Stack HCI cluster resource: the default value is `<cluster name-rg>`. You can provide a custom value (`-ResourceGroupName`).
  - **Resource group tags**: Currently HCI does not support adding tags to resource groups during cluster registration. Make sure your policy accounts for this behavior.
  - **.msi download**: HCI downloads the Arc agent on the cluster nodes during cluster registration. Make sure you do not restrict these downloads.
  - **Credentials lifetime**: By default, the HCI service requests 2 years of credential lifetime. Make sure your Azure policy doesn't have any configuration conflicts.

> [!NOTE]
> If you have a separate resource group for Arc-for-Server resources, we recommend using a resource group having Arc-for-Server resources related only to Azure Stack HCI. The Azure Stack HCI resource provider has permissions to manage any other Arc-for-Server resources in the **ArcServer** resource group.

## Register a cluster using Windows Admin Center

There are two ways to register a cluster: using Windows Admin Center, or using PowerShell.

Before registration make sure all the [prerequisites](#prerequisites-for-cluster-registration) are met.

> [!WARNING]
> To register your Azure Stack HCI cluster in Azure China, ensure you are using [Windows Admin Center version 2103.2](https://aka.ms/wac2103.2) or later.

1. Before beginning the cluster registration process, you must first [register Windows Admin Center with Azure](../manage/register-windows-admin-center.md). You must also sign in to your Azure account from within Windows Admin Center. To do so, go to **Settings** > **Account**, and then select **Sign in** under **Azure Account**.

   > [!IMPORTANT]
   > When registering Windows Admin Center with Azure, it's important to use the same Azure Active Directory (tenant) ID that you plan to use for the cluster registration. An Azure AD tenant ID represents a specific instance of Azure AD containing accounts and groups, whereas an Azure subscription ID represents an agreement to use Azure resources for which charges accrue. To find your tenant ID, visit the Azure portal and select Azure Active Directory. Your tenant ID will be displayed under Tenant information. To get your Azure subscription ID, navigate to Subscriptions and copy/paste your ID from the list.

1. Open Windows Admin Center and do one of the following:
   - Option 1
      1. Select the cluster connection.
      1. Select **Dashboard** from the **Tools** menu on the left pane.
      1. If your cluster has not yet been registered with Azure, then both the **Azure Stack HCI registration** and **Arc-enabled servers** status show **Not configured**.
      1. Select **Register** to proceed.
   - Option 2
      > [!NOTE]
      > The Azure Arc dashboard is currently in public preview.
      1. Select the cluster connection.
      1. Select **Azure Arc** from the **Tools** menu on the left.
      1. Select **Overview** within the **Azure Arc** section.
      1. If your cluster has not yet been registered with Azure, then both the **Azure Stack HCI registration** and **Arc-enabled servers** status show **Not configured**.
      1. Select the **Azure Stack HCI registration** tile.
      1. Select **Register** to proceed.

   > [!NOTE]
   > If you did not register Windows Admin Center in step 1, you are asked to do so now. Instead of the cluster registration wizard, you'll see the Windows Admin Center registration wizard.

1. Specify the Azure subscription ID to which you want to register the cluster. To get your Azure subscription ID, visit the Azure portal, navigate to **Subscriptions**, and copy/paste your ID from the list.

1. Select the Azure region from the drop-down menu.

1. Select one of the following options to select the Azure Stack HCI resource group:

   - Select **Use existing** to create the Azure Stack HCI cluster resource in an existing resource group. Optionally, enter the name of the **Arc-enabled servers resource group** where you want to create the Arc-enabled servers resources. If left blank, the default Arc-enabled servers resource group is the same as the one used for the Azure Stack HCI cluster.

   - Select **Create new** to create a new resource group.

      :::image type="content" source="media/register-with-azure/arc-registration-flyout.png" alt-text="Screenshot of cluster registration wizard." lightbox="media/register-with-azure/arc-registration-flyout.png":::

1. Select **Register**. It takes a few minutes to complete the registration.

## View registration and Arc-enabled servers status using Windows Admin Center

When you connect to a cluster using Windows Admin Center, you'll see the dashboard, which displays the Azure Stack HCI registration and Arc-enabled servers status. For Azure Stack HCI registration, **Connected** means that the cluster is already registered with Azure and has successfully synced to the cloud within the last day. For Arc-enabled servers, **Connected** means that all physical servers are Arc-enabled and can be managed from the Azure portal.

:::image type="content" source="media/register-with-azure/dashboard-connected.png" alt-text="Screenshot that shows the cluster connection status on the Windows Admin Center dashboard." lightbox="media/register-with-azure/dashboard-connected.png":::

You can get more information by selecting **Azure Arc** from the **Tools** menu on the left.

> [!NOTE]
> The Azure Arc dashboard is currently in public preview.

:::image type="content" source="media/register-with-azure/overview-connected.png" alt-text="Screenshot that shows selections for getting Azure Stack HCI registration information." lightbox="media/register-with-azure/overview-connected.png":::

On the **Overview** page, you will find high-level status information about Azure Stack HCI registration and Arc-enabled servers. You can click on either tile to be taken to the individual pages.

:::image type="content" source="media/register-with-azure/hci-registration-connected.png" alt-text="Screenshot of status information about registration." lightbox="media/register-with-azure/hci-registration-connected.png":::

On the **Azure Stack HCI registration** page, you can view both the Azure Stack HCI system and server status. This includes the Azure connection status and last Azure sync. You can find **Useful links** to troubleshooting documentation and cluster extensions. You can **Unregister** if needed.

:::image type="content" source="media/register-with-azure/arc-enabled-servers-connected.png" alt-text="Screenshot of servers status." lightbox="media/register-with-azure/arc-enabled-servers-connected.png":::

If your cluster is registered with Azure, but the physical servers are not yet Arc-enabled, you can do so from the **Arc-enabled servers** page. If the physical servers are Arc-enabled, you can view the Azure Arc status and version ID for each server. You can also find **Useful links** to troubleshooting information.

## Register a cluster using PowerShell

You can register a cluster using PowerShell instead of Windows Admin Center.

Before registration, [make sure all the prerequisites are met](#prerequisites-for-cluster-registration). Use the following workflow to register an Azure Stack HCI cluster with Azure using a management PC.

1. Install the required PowerShell cmdlets on your management computer. If you're running Azure Stack HCI version 20H2, and your cluster was deployed prior to December 10, 2020, make sure you have applied the November 23, 2020 Preview Update (KB4586852) to each server in the cluster before attempting to register with Azure.

   ```PowerShell
   Install-Module -Name Az.StackHCI
   ```

   > [!NOTE]
   > You may see a prompt such as **Do you want PowerShellGet to install and import the NuGet provider now?** Answer **Yes(Y)**.
   >
   > If you see another prompt saying **Are you sure you want to install the modules from 'PSGallery'?** Answer **Yes(Y)**.

2. Perform the registration using the name of any server in the cluster. To get your Azure subscription ID, visit the Azure portal, navigate to **Subscriptions**, and copy/paste your ID from the list. To get your tenant ID, visit the Azure portal, navigate to **Azure Active Directory**, and copy/paste your **Tenant ID**.

   ```powershell
   Register-AzStackHCI  -SubscriptionId "<subscription_ID>" -ComputerName Server1 -Region <region> -TenantId "<tenant_id>"  
   ```

   If the management PC has a GUI, you will get a login prompt, in which you provide the credentials to access the cluster nodes. If the management PC doesn't have a GUI, use the parameter `-credentials <credentials to log in to cluster nodes>` in the `Register-AzStackHCI` cmdlet.

   This syntax registers the cluster (of which **Server1** is a member) as the current user, and automatically Arc-enables the nodes by default. The command also places the HCI cluster resource as the `<on-prem cluster name>` Azure resource and all the Arc-for-Server resources as `<server name>` in the `<on-prem cluster name>-rg` resource group, in the specified region, subscription, and tenant with the default cloud environment (AzureCloud). You can use the optional `-ResourceGroupName` and `-ArcServerResourceGroupName` parameters to this cmdlet.

   > [!NOTE]
   > If you are registering Azure Stack HCI in Azure China, run the `Register-AzStackHCI` cmdlet with these additional parameters: `-EnvironmentName "AzureChinaCloud" -Region "ChinaEast2"`.
   >
   > If you're registering in Azure Government, use `-EnvironmentName "AzureUSGovernment" -Region "UsGovVirginia"`.

   > [!NOTE]
   > Azure Arc integration is not available for Azure Stack HCI, version 20H2. For Azure Stack HCI version 21H2 and later, the clusters are automatically Arc-enabled on registration.

3. Authenticate with Azure. To complete the registration process, you must authenticate (sign in) using your Azure account. Your account must have access to the Azure subscription that was specified in step 2. If your management node has a user interface, a sign-in screen appears, in order to proceed with the registration. If your management node doesn't have a UI, copy the code provided, navigate to microsoft.com/devicelogin on another device (such as your computer or phone), enter the code, and sign in there. The registration workflow detects when you've logged in, and proceeds to completion. You should then be able to see your cluster in the Azure portal.

## View registration status using PowerShell

To view registration status by using Windows PowerShell, use the `Get-AzureStackHCI` PowerShell cmdlet and the `ClusterStatus`, `RegistrationStatus`, and `ConnectionStatus` properties. 

For example, after you install the Azure Stack HCI operating system, but before you create or join a cluster, the `ClusterStatus` property shows a `NotYet` status:

:::image type="content" source="media/register-with-azure/1-get-azurestackhci.png" alt-text="Screenshot that shows the Azure registration status before cluster creation.":::

After the cluster is created, only `RegistrationStatus` shows a `NotYet` status:

:::image type="content" source="media/register-with-azure/2-get-azurestackhci.png" alt-text="Screenshot that shows the Azure registration status after cluster creation.":::

You must register an Azure Stack HCI cluster within 30 days of installation, as defined in the Azure Online Services Terms. If you haven't created or joined a cluster after 30 days, `ClusterStatus` will show `OutOfPolicy`. If you haven't registered the cluster after 30 days, `RegistrationStatus` will show `OutOfPolicy`.

After the cluster is registered, you can see `ConnectionStatus` and the `LastConnected` time. The `LastConnected` time is usually within the last day unless the cluster is temporarily disconnected from the internet. An Azure Stack HCI cluster can operate fully offline for up to 30 consecutive days.

:::image type="content" source="media/register-with-azure/3-get-azurestackhci.png" alt-text="Screenshot that shows the Azure registration status after registration.":::

If you exceed the maximum period of offline operation, `ConnectionStatus` will show `OutOfPolicy`.

> [!NOTE]
> BIOS\UEFI Firmware configuration must be the same on each HCI cluster node's hardware. Any nodes with different BIOS configurations compared to the majority may show **ConnectionStatus** as **OutOfPolicy**.

## View the cluster and Arc resources in Azure portal

To view the status of the cluster and Arc resources, navigate to the following screens in the Azure portal:

:::image type="content" source="media/register-with-azure/cluster-status-1.png" alt-text="Screenshot of cluster resources." lightbox="media/register-with-azure/cluster-status-1.png":::

:::image type="content" source="media/register-with-azure/cluster-status-2.png" alt-text="Screenshot of cluster status blade." lightbox="media/register-with-azure/cluster-status-2.png":::

### Enable Azure Arc integration

If you're a preview channel customer and you registered your preview channel cluster with Azure for the first time on or after June 15, 2021, every server in the cluster will be Azure Arc-enabled by default, as long as the user registering the cluster has required permissions as described in [Assign permissions from Azure portal](#assign-permissions-from-azure-portal).

You can take the following actions if:

1. You updated your Azure Stack HCI servers from 20H2 (which were previously not Arc-enabled manually) to 21H2, and Arc enablement doesn't happen automatically.
   - If you have previously Arc-enabled your 20H2 clusters, and after upgrading to 21H2 the Arc enablement is still failing, [see the guidance here to troubleshoot](troubleshoot-hci-registration.md#registration-completes-successfully-but-azure-arc-connection-in-portal-says-not-installed).
1. You disabled Arc enablement previously, and now you intend to Arc-enable your 21H2 or later Azure Stack HCI cluster.

   > [!NOTE]
   > Azure Arc integration is only available in Azure Stack HCI, version 21H2 and preview builds. It is not available on Azure Stack HCI, version 20H2.

1. Install the latest version of the `Az.StackHCI` module on your management PC:

   ```PowerShell
   Install-Module -Name Az.StackHCI
   ```

1. Rerun the `Register-AzStackHCI` cmdlet and specify your Azure subscription ID, which must be the same ID with which the cluster was originally registered. The `-ComputerName` parameter can be the name of any server in the cluster. This step enables Azure Arc integration on every server in the cluster. It will not affect your current cluster registration with Azure, and you don't need to unregister the cluster first:

   ```PowerShell
   Register-AzStackHCI  -SubscriptionId "<subscription_ID>" -ComputerName Server1 -Region <region> -TenantId "<tenant_id>"
   ```

   > [!IMPORTANT]
   > If the cluster was originally registered using a `-Region`, `-ResourceName`, or `-ResourceGroupName` that's different from the default settings, you must specify those same parameters and values here. Running `Get-AzureStackHCI` will display these values.

1. If Azure Arc integration fails, then the servers may need to communicate through a proxy server. To resolve this issue, follow the guidelines to [update proxy settings](/azure/azure-arc/servers/manage-agent#update-or-remove-proxy-settings). Then, re-register the Azure Stack HCI cluster.

## Upgrade Arc agent on cluster servers

> Applies to: Azure Stack HCI, version 21H2

To automatically update the Arc agent when a new version is available, make sure the servers for the cluster check for updates in Microsoft Update. See the steps under [Microsoft Update configuration](/azure/azure-arc/servers/manage-agent#windows-agent) to make sure Microsoft Update is correctly configured.

1. In the [Server Configuration Tool (SConfig)](/windows-server/administration/server-core/server-core-sconfig), select the option to **Install Updates** (option 6):

   :::image type="content" source="media/register/sconfig-install.png" alt-text="Options to install update":::

2. Select the option for **All quality updates** (option 1).

3. You can choose to specifically update the Arc agent, or install all of the updates available:

   :::image type="content" source="media/register/sconfig-updates.png" alt-text="Sconfig options":::

4. Run `azcmagent version` from PowerShell on each node to verify the Arc agent version.

## Unregister Azure Stack HCI

You can unregister Azure Stack HCI using Windows Admin Center or using PowerShell.

The unregistration process automatically cleans up the Azure resource that represents the cluster, the Azure resource group (if the group was created during registration and doesn't contain any other resources), and the Azure AD app identity. This cleanup stops all monitoring, support, and billing functionality through Azure Arc.

### Unregister Azure Stack HCI using Windows Admin Center

Follow these steps to unregister your Azure Stack HCI cluster:

1. Connect to the cluster using Windows Admin Center.

1. Select **Settings** at the bottom of the **Tools** menu on the left.

1. Select **Azure Stack HCI registration**, and select the **Unregister** button, and then select **Unregister** again.

> [!NOTE]
> If your Windows Admin Center gateway is registered to a different Azure AD tenant ID that was used to initially register the cluster, you might encounter problems when you try to unregister the cluster using Windows Admin Center. If this happens, you can use the PowerShell instructions in the next section.

### Unregister Azure Stack HCI using PowerShell

With PowerShell, you can use the `Unregister-AzStackHCI` cmdlet to unregister an Azure Stack HCI cluster. You can run the cmdlet either on a cluster node or from a management computer.

You might need to install the latest version of the **Az.StackHCI** module. If you see a prompt that says **Are you sure you want to install the modules from 'PSGallery'?**, answer yes (Y):

```powershell
Install-Module -Name Az.StackHCI
```

#### Unregister from cluster-node

If you're running the `Unregister-AzStackHCI` cmdlet on a server in the cluster, use the following syntax. Specify your Azure subscription ID and the resource name of the Azure Stack HCI cluster that you want to unregister:

```powershell
Unregister-AzStackHCI -SubscriptionId "<subscription ID GUID>" -ResourceName HCI001 -TenantID "<tenant_id>"
```

You're prompted to visit microsoft.com/devicelogin on another device (such as your PC or phone). Enter the code, and sign in there to authenticate with Azure.

#### Unregister from a management PC

If you're running the cmdlet from a management PC, you must also specify the name of a server (node) in the cluster:

```powershell
Unregister-AzStackHCI -ComputerName ClusterNode1 -SubscriptionId "<subscription ID GUID>" -ResourceName HCI001 -TenantId "<tenant_id>"
```

An interactive Azure login window appears. The exact prompts that you see will vary depending on your security settings (for example, two-factor authentication). Follow the prompts to sign in.

> [!IMPORTANT]
> If you're unregistering the Azure Stack HCI cluster in Azure China, run the `Unregister-AzStackHCI` cmdlet with these additional parameters:
>
> `-EnvironmentName AzureChinaCloud -Region "ChinaEast2"`
>
> If you're unregistering in Azure Government, use these additional parameters:
>
> `-EnvironmentName AzureUSGovernment -Region "USGovVirginia"`
>
> If you provide the `-SubscriptionId` parameter, make sure that it's the correct one. It's recommended that you let the unregister script determine the subscription automatically.

## Clean up after a cluster that was not properly unregistered

If a user destroys an Azure Stack HCI cluster without un-registering it, such as by re-imaging the host servers or deleting virtual cluster nodes, then artifacts will be left over in Azure. These artifacts are harmless and won't incur billing or use resources, but they can clutter the Azure portal. To clean them up, you can manually delete them.

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

## Troubleshooting

For information about common errors and mitigation steps to resolve them, see [Troubleshoot Azure Stack HCI registration](../deploy/troubleshoot-hci-registration.md).

## FAQ

The following are answers to some frequently asked questions:

### How do I use a more restricted custom permissions role?

You can further scope down the permissions required to perform HCI registration as described in [Assign permissions using PowerShell](#assign-permissions-using-powershell).

1. Sign in to the subscription you will use to register the cluster. Under **Settings > Resource Providers**, select the following resource providers and then select **Register**:
   - Microsoft.AzureStackHCI
   - Microsoft.HybridCompute
   - Microsoft.GuestConfiguration
   - Microsoft.HybridConnectivity

2. Create a JSON file called **customHCIRole.json** with the following content. Make sure to change `<subscriptionID>` to the ID of your Azure subscription. To get your subscription ID, visit the Azure portal, navigate to **Subscriptions**, then copy/paste your ID from the list.

   ```json
   {
     "Name": "Azure Stack HCI registration role",
     "Id": null,
     "IsCustom": true,
     "Description": "Custom Azure role to allow subscription-level access to register Azure Stack HCI",
     "Actions": [
       "Microsoft.Resources/subscriptions/resourceGroups/read",
       "Microsoft.AzureStackHCI/clusters/*",
       "Microsoft.Authorization/roleAssignments/write",
       "Microsoft.Authorization/roleAssignments/read"
      ],
      "NotActions": [
      ],
      "AssignableScopes": [
         "/subscriptions/<subscriptionId>"
      ]
   }
   ```

3. Create the custom role:

   ```powershell
   New-AzRoleDefinition -InputFile <path to customHCIRole.json>
   ```

4. Assign the custom role to the user:

   ```powershell
   $user = get-AzAdUser -DisplayName <userdisplayname>
   $role = Get-AzRoleDefinition -Name "Azure Stack HCI registration role"
   New-AzRoleAssignment -ObjectId $user.Id -RoleDefinitionId $role.Id -Scope /subscriptions/<subscriptionid>
   ```

   You can now register the cluster in the subscription with more restrictive role permissions, provided you are using an existing resource group for the cluster resource and Arc-for-Server resources.

   If you need to un-register this cluster, add the `Microsoft.Resources/subscriptions/resourceGroups/delete` permission in step 2.

### How do I register a cluster using ArmAccessToken/SPN?

Before registration, make sure the [prerequisites](#prerequisites-for-cluster-registration) and [prechecks](#required-pre-checks) are met.

> [!NOTE]
> When the SPN credentials are near expiry, you must regenerate the credentials and run the "repair registration" flow to update the SPN credentials on the cluster. This is important to remember if you plan to "Add new server" or "Unregister" in the future. These SPN credentials are used for initial onboarding to HCI. HCI still creates separate SPN credentials for Arc onboarding. To use a custom SPN for Arc onboarding, see [How do I register a cluster using SPN for Arc onboarding?](#how-do-i-register-a-cluster-using-spn-for-arc-onboarding).

1. Run ['Connect-AzAccount'](/powershell/module/az.accounts/connect-azaccount) to connect to Azure.
   To use SPN to connect, you can use:
   - Device Code-based authentication. Use `-DeviceCode` in the cmdlet.
   - Certificated based authentication. [See this article](/azure/active-directory/authentication/how-to-certificate-based-authentication) to configure the SPN for certificate-based authentication. Then use appropriate parameters in the `Connect-AzAccount` cmdlet that accept certificate information.
   The SPN you use should have all the required permissions on the subscription(s) [as listed here](#assign-permissions-from-azure-portal).
1. Assign `$token = Get-AzAccessToken`.
1. Run the following cmdlet:

   ```powershell
   Register-AzStackHCI -TenantId "<tenant_ID>" -SubscriptionId "<subscription_ID>" -ComputerName Server1 -Region <region> -ArmAccessToken $token.Token -AccountId $token.UserId
   ```

## How do I register a cluster using SPN for Arc onboarding?

> [!NOTE]
> In the latest PowerShell module, **Microsoft.Authorization/roleAssignments/write** permission is a requirement. Use version 1.4.1 or earlier to use SPN credentials for Arc onboarding if you don't have the **Microsoft.Authorization/roleAssignments/write** permission assigned. For Powershell module version 1.4.1 and earlier, you can't use an existing resource group for Arc-for-Server resources.

Before registration, make sure the prerequisites are met: the HCI cluster must exist, internet access and firewall ports are configured correctly, and the user registering the cluster has either the "contributor" role assigned for the subscription which is used for the cluster registration, or has the following list of permissions if a custom role is assigned:

- "Microsoft.Resources/subscriptions/resourceGroups/read",
- "Microsoft.Resources/subscriptions/resourceGroups/write",
- "Microsoft.AzureStackHCI/register/action",
- "Microsoft.AzureStackHCI/Unregister/Action",
- "Microsoft.AzureStackHCI/clusters/*",
- "Microsoft.Authorization/roleAssignments/read",
- "Microsoft.HybridCompute/register/action",
- "Microsoft.GuestConfiguration/register/action",
- "Microsoft.HybridConnectivity/register/action"

For unregistration, make sure you also have **Microsoft.Resources/subscriptions/resourceGroups/delete** permission.

The following guidelines are for the user running the registration cmdlet who cannot get the **Microsoft.Authorization/roleAssignments/write** permission assigned. In such cases, they can use the pre-created SPN with Arc onboarding roles (**Azure Connected Machine Onboarding** and **Azure Connected Machine Resource Administrator**) assigned to the SPN, and specify the credentials to the registration cmdlet using the `-ArcSpnCredential` option.

> [!NOTE]
> HCI does not update the credentials of the SPN created in this way. When the SPN credentials are near expiry, you must regenerate the credentials and run the "repair registration" flow to update the SPN credentials on the cluster.

To register the cluster and Arc-enable the servers, run the following PowerShell commands after updating them with your environment information. The following commands require **Az.Resources** (minimum version 5.6.0) and **Az.Accounts** (minimum version 2.7.6). You can use the `get-installedModule <module name>` cmdlet to check the installed version of a PowerShell module.

```powershell
#Connect to subscription
Connect-AzAccount -TenantId <tenant_id> -SubscriptionId <Subscription_ID> -Scope Process

#Create a new application registration
$app = New-AzADApplication -DisplayName "<unique_name>"

#Create a new SPN corresponding to the application registration
$sp = New-AzADServicePrincipal -ApplicationId  $app.AppId -Role "Reader" 

#Roles required on SPN for Arc onboarding
$AzureConnectedMachineOnboardingRole = "Azure Connected Machine Onboarding"
$AzureConnectedMachineResourceAdministratorRole = "Azure Connected Machine Resource Administrator"

#Assign roles to the created SPN
New-AzRoleAssignment -ObjectId $sp.Id -RoleDefinitionName $AzureConnectedMachineOnboardingRole | Out-Null
New-AzRoleAssignment -ObjectId $sp.Id -RoleDefinitionName $AzureConnectedMachineResourceAdministratorRole | Out-Null

# Set password validity time. SPN must be updated on the HCI cluster after this timeframe.
$pwdExpiryInYears = 300
$start = Get-Date
$end = $start.AddYears($pwdExpiryInYears)
$pw = New-AzADSpCredential -ObjectId $sp.Id -StartDate $start -EndDate $end
$password = ConvertTo-SecureString $pw.SecretText -AsPlainText -Force  

# Create SPN credentials object to be used in the register-azstackhci cmdlet
$spnCred = New-Object System.Management.Automation.PSCredential ($app.AppId, $password)
Disconnect-AzAccount -ErrorAction Ignore | Out-Null

# Use the SPN credentials created previously in the register-azstackhci cmdlet
Register-AzStackHCI -SubscriptionId < Subscription_ID> -Region <region> -ArcSpnCredential:$spnCred
```

### Is resource move supported for Azure Stack HCI resources?

We do not support resource move for any Azure Stack HCI resources. To change the location of the resources, you must [unregister](#unregister-azure-stack-hci) the cluster first, and then re-register it at the new location by passing the appropriate parameters in [Register-AzStackHCI](#register-a-cluster-using-powershell) cmdlet.


### What are some of the more commonly used registration and Arc cmdlets?

- For **Az.StackHCI** PowerShell module cmdlets, see the [HCI PowerShell documentation](/powershell/module/az.stackhci/).  
- **Get-AzureStackHCI**: returns the current node connection and policy information for Azure Stack HCI.
- **Get-AzureStackHCIArcIntegration**: returns the status of node Arc integration.
- **Sync-AzureStackHCI**:
  - Performs billing, licensing, and census sync with Azure.
  - The system runs this cmdlet automatically every 12 hours.
  - You should only use this cmdlet when a cluster's internet connection has been unavailable for an extended period.
  - Do not run this cmdlet immediately after server reboot; let the automatic sync happen. Otherwise, it may result in a bad state.

## Next steps

To perform the next management task related to this article, see:
> [!div class="nextstepaction"]
> [Validate an Azure Stack HCI cluster](validate.md)
