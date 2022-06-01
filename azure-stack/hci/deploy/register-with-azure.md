---
title: Connect Azure Stack HCI to Azure
description: How to register Azure Stack HCI clusters with Azure.
author: sethmanheim
ms.author: sethm
ms.reviewer: arduppal
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.custom: references_regions
ms.date: 05/17/2022
---

# Connect and manage Azure Stack HCI registration

> Applies to: Azure Stack HCI, versions 21H2 and 20H2

Now that you've deployed the Azure Stack HCI operating system and created a cluster, you must register the cluster with Azure. Azure Stack HCI is delivered as an Azure service, and must be registered within 30 days of installation (per the Azure online services terms).

This article describes the following topics:

- How to register your Azure Stack HCI cluster with Azure for monitoring, support, billing, and hybrid services. Upon registration, an Azure Resource Manager resource is created to represent the on-premises Azure Stack HCI cluster, effectively extending the Azure management plane to Azure Stack HCI. Information is periodically synchronized between the Azure resource and the on-premises cluster(s).
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

:::image type="content" source="media/register-with-azure/access-control.png" alt-text="Screenshot of assign permissions screen" lightbox="media/register-with-azure/access-control.png":::

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
       "Microsoft.AzureStackHCI/register/action",
       "Microsoft.AzureStackHCI/Unregister/Action",
       "Microsoft.AzureStackHCI/clusters/*",
       "Microsoft.Authorization/roleAssignments/write",
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
| "Microsoft.Resources/subscriptions/resourceGroups/read"</b> "Microsoft.AzureStackHCI/register/action"</b> "Microsoft.AzureStackHCI/Unregister/Action"</b> "Microsoft.AzureStackHCI/clusters/*"</b>     | To register and unregister Azure Stack HCI cluster      |
| "Microsoft.Authorization/roleAssignments/write", "Microsoft.HybridCompute/register/action", "Microsoft.GuestConfiguration/register/action", "Microsoft.HybridConnectivity/register/action" | To register and unregister the Arc for server resources |

### Register a cluster using Windows Admin Center

There are two ways to register a cluster: using Windows Admin Center, or using PowerShell.

Before registration make sure all the [prerequisites](#prerequisites-for-cluster-registration) are met.

> [!WARNING]
> To register your Azure Stack HCI cluster in Azure China, ensure you are using [Windows Admin Center version 2103.2](https://aka.ms/wac2103.2) or later.

1. Before beginning the registration process, you must first [register Windows Admin Center with Azure](../manage/register-windows-admin-center.md) and sign into Windows Admin Center with your Azure account.

> [!IMPORTANT]
> When registering Windows Admin Center with Azure, it's important to use the same Azure Active Directory (tenant) ID that you plan to use for the cluster registration. An Azure AD tenant ID represents a specific instance of Azure AD containing accounts and groups, whereas an Azure subscription ID represents an agreement to use Azure resources for which charges accrue. To find your tenant ID, visit the Azure portal and select Azure Active Directory. Your tenant ID will be displayed under Tenant information. To get your Azure subscription ID, navigate to Subscriptions and copy/paste your ID from the list.

1. Open Windows Admin Center. Do one of the following steps:
   1. Select the cluster connection.
   2. Select **Settings** from the bottom of the **Tools** menu on the left.
   3. Select **Azure Stack HCI registration**. If your cluster has not yet been registered with Azure, then **Registration status** shows **Not registered**. Select **Register** to proceed.
   4. Select **Register this cluster** from the Windows Admin Center dashboard.

   > [!NOTE]
   > If you did not register Windows Admin Center in step 1, you are asked to do so now. Instead of the cluster registration wizard, you'll see the Windows Admin Center registration wizard.

3. Specify the Azure subscription ID to which you want to register the cluster. To get your Azure subscription ID, visit the Azure portal, navigate to **Subscriptions**, and copy/paste your ID from the list. Select **Use existing resource group** to create the Azure stack HCI cluster resource in an existing resource group. Select the Azure region from the drop-down menu and then click **Register**.

   :::image type="content" source="media/register-with-azure/register-with-azure.png" alt-text="The cluster registration wizard will ask for your Azure subscription ID, resource group, and region" lightbox="media/register/register-with-azure.png":::

### View registration status using Windows Admin Center

When you connect to a cluster by using Windows Admin Center, you'll see the dashboard, which displays the Azure connection status. **Connected** means that the cluster is already registered with Azure and has successfully synced to the cloud within the last day.

:::image type="content" source="media/register-with-azure/registration-status.png" alt-text="Screenshot that shows the cluster connection status on the Windows Admin Center dashboard." lightbox="media/register-with-azure/registration-status.png":::

You can get more information by selecting **Settings** at the bottom of the **Tools** menu on the left, and then selecting **Azure Stack HCI registration**.

:::image type="content" source="media/register-with-azure/azure-stack-hci-registration.png" alt-text="Screenshot that shows selections for getting Azure Stack H C I registration information." lightbox="media/register-with-azure/azure-stack-hci-registration.png":::

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

2. Perform the registration using the name of any server in the cluster. To get your Azure subscription ID, visit the Azure portal, navigate to **Subscriptions**, and copy/paste your ID from the list.

   ```powershell
   Register-AzStackHCI  -SubscriptionId "<subscription_ID>" -ComputerName Server1  
   ```

   If the management PC has a GUI, you will get a login prompt, in which you provide the credentials to access the cluster nodes. If the management PC doesn't have a GUI, use the parameter `-credentials <credentials to log in to cluster nodes>` in the **Register-AzStackHCI** cmdlet.

   This syntax registers the cluster (of which `Server1` is a member) as the current user, and places the HCI cluster resource as `<on-prem cluster name>` Azure resource in the `<on-prem cluster name>-rg` resource group with the default Azure region and cloud environment (AzureCloud). You can also add the optional `-Region`, `-ResourceGroupName`, `-TenantId`, and `-ArcServerResourceGroupName` parameters to this cmdlet.

   > [!NOTE]
   > If you are registering Azure Stack HCI in Azure China, run the `Register-AzStackHCI` cmdlet with these additional parameters: `-EnvironmentName "AzureChinaCloud" -Region "ChinaEast2"`.
   >
   > If you're registering in Azure Government, use `-EnvironmentName "AzureUSGovernment" -Region "UsGovVirginia"`.

   > [!NOTE]
   > Azure Arc integration is not available for Azure Stack HCI, version 20H2. If you are running Azure Stack HCI 21H2 and do not want the servers to be Arc enabled or do not have the proper roles, specify this additional parameter: `-EnableAzureArcServer:$false`.

   Using the latest **Az.StackHCI** module and running the **Register-AzStackHCI** cmdlet with Azure Stack HCI 21H2 automatically Arc-enables the nodes by default, and places the Arc for server resources in an automatically generated Arc managed resource group. If you want to specify the name of the Arc for server resource group, use the additional parameter `-ArcServerResourceGroupName <ArcRgName>`. Note that the specified `<ArcRgName>` cannot pre-exist, it must be created by the HCI service. For example:

   ```powershell
   Register-AzStackHCI  -SubscriptionId "<subscription_ID>" -ComputerName Server1 -ResourceGroupName cluster1-rg -ArcServerResourceGroupName <ArcRgName>
   ```

3. Authenticate with Azure. To complete the registration process, you must authenticate (sign in) using your Azure account. Your account must have access to the Azure subscription that was specified in step 2. If your management node has a user interface, a sign-in screen appears, in order to proceed with the registration. If your management node doesn't have a UI, copy the code provided, navigate to microsoft.com/devicelogin on another device (such as your computer or phone), enter the code, and sign in there. The registration workflow detects when you've logged in, and proceeds to completion. You should then be able to see your cluster in the Azure portal.

### View registration status using PowerShell

To view registration status by using Windows PowerShell, use the `Get-AzureStackHCI` PowerShell cmdlet and the `ClusterStatus`, `RegistrationStatus`, and `ConnectionStatus` properties. 

For example, after you install the Azure Stack HCI operating system, but before you create or join a cluster, the `ClusterStatus` property shows a `NotYet` status:

:::image type="content" source="media/register-with-azure/1-get-azurestackhci.png" alt-text="Screenshot that shows the Azure registration status before cluster creation.":::

After the cluster is created, only `RegistrationStatus` shows a `NotYet` status:

:::image type="content" source="media/register-with-azure/2-get-azurestackhci.png" alt-text="Screenshot that shows the Azure registration status after cluster creation.":::

You must register an Azure Stack HCI cluster within 30 days of installation, as defined in the Azure Online Services Terms. If you haven't created or joined a cluster after 30 days, `ClusterStatus` will show `OutOfPolicy`. If you haven't registered the cluster after 30 days, `RegistrationStatus` will show `OutOfPolicy`.

After the cluster is registered, you can see `ConnectionStatus` and the `LastConnected` time. The `LastConnected` time is usually within the last day unless the cluster is temporarily disconnected from the internet. An Azure Stack HCI cluster can operate fully offline for up to 30 consecutive days.

:::image type="content" source="media/register-with-azure/3-get-azurestackhci.png" alt-text="Screenshot that shows the Azure registration status after registration.":::

If you exceed the maximum period of offline operation, `ConnectionStatus` will show `OutOfPolicy`.

## Register a cluster using SPN

Before registration, make sure the prerequisites are met: the HCI cluster must exist, and internet access and firewall ports are configured correctly.

In some cases, the user running the registration cmdlet might not have permissions on the subscription to perform role assignments on the service principal. In such cases, you can create an SPN with the **Azure Connected Machine Onboarding** and **Azure Connected Machine Resource Administrator** roles, and you can use the created SPN credentials during registration. 

> [!NOTE]
> HCI does not update the credentials of the SPN created in this way. When the SPN credentials are near expiry, you must regenerate the credentials and run the "repair registration" flow to update the SPN credentials on the cluster.

To register the cluster and Arc-enable the servers, run the following PowerShell commands after updating them with your environment information. The following commands require **Az.Resources** (minimum version 5.6.0) and **Az.Accounts** (minimum version 2.7.6). You can use the `get-installedModule <module name>` cmdlet to check the installed version of PowerShell. 

```powershell
#Connect to subscription
Connect-AzAccount -TenantId <Tenant_ID> -SubscriptionId <Subscription_ID> -Scope Process

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
Register-AzStackHCI   -SubscriptionId < Subscription_ID>  -ArcSpnCredential:$spnCred
```

## View the cluster and Arc resources in Azure portal

To view the status of the cluster and Arc resources, navigate to the following screen in the Azure portal:

:::image type="content" source="media/register-with-azure/cluster-status.png" alt-text="Screenshot of cluster status blade" lightbox="media/register-with-azure/cluster-status.png":::

## Enable Azure Arc integration

> [!NOTE]
> Azure Arc integration is not available for Azure Stack HCI, version 20H2. If you are running Azure Stack HCI 21H2 and do not want the servers to be Arc enabled or do not have the proper roles, specify this additional parameter: `-EnableAzureArcServer:$false`.

If you're a preview channel customer and you registered your preview channel cluster with Azure for the first time on or after June 15, 2021, every server in the cluster will be Azure Arc-enabled by default, as long as the user registering the cluster has Azure Owner or User Access Administrator roles. Otherwise, you'll need to take the following steps to enable Azure Arc integration on the servers.

> [!NOTE]
> Azure Arc integration is only available in Azure Stack HCI, version 21H2 and preview builds. It is not available on Azure Stack HCI, version 20H2.

1. Install the latest version of the `Az.StackHCI` module on your management PC:

   ```PowerShell
   Install-Module -Name Az.StackHCI
   ```

2. Rerun the `Register-AzStackHCI` cmdlet and specify your Azure subscription ID, which must be the same ID with which the cluster was originally registered. The `-ComputerName` parameter can be the name of any server in the cluster. This step enables Azure Arc integration on every server in the cluster. It will not affect your current cluster registration with Azure, and you don't need to unregister the cluster first:

   ```PowerShell
   Register-AzStackHCI  -SubscriptionId "<subscription_ID>" -ComputerName Server1
   ```

   > [!IMPORTANT]
   > If the cluster was originally registered using a `-Region`, `-ResourceName`, or `-ResourceGroupName` that's different from the default settings, you must specify those same parameters and values here. Running `Get-AzureStackHCI` will display these values.

3. If Azure Arc integration fails, then the servers may need to communicate through a proxy server. To resolve this, set the proxy server environment variable by running the following PowerShell command as administrator on each server in the cluster:

   ```PowerShell
   [Environment]::SetEnvironmentVariable("https_proxy", "http://{proxy-url}:{proxy-port}", "Machine")
   $env:https_proxy = [System.Environment]::GetEnvironmentVariable("https_proxy","Machine")
   # For the changes to take effect, the agent service needs to be restarted after the proxy environment variable is set.
   Restart-Service -Name himds
   ```

   Then, re-register the Azure Stack HCI cluster.

## Upgrade Arc agent on cluster servers

> Applies to: Azure Stack HCI, version 21H2

To automatically update the Arc agent when a new version is available, make sure the servers for the cluster check for updates in Microsoft Update. See the steps under [Microsoft Update configuration](/azure/azure-arc/servers/manage-agent#windows-agent) to make sure Microsoft Update is correctly configured.

1. In the Server Configuration Tool (Sconfig.exe), select the option to **Install Updates** (option 6):

   :::image type="content" source="media/register/sconfig-install.png" alt-text="Options to install update":::

2. Select the option for **All quality updates** (option 1).

3. You can choose to specifically update the Arc agent, or install all of the updates available:

   :::image type="content" source="media/register/sconfig-updates.png" alt-text="Sconfig options":::

4. Run `azcmagent version` from PowerShell on each node to verify the Arc agent version.

## Unregister Azure Stack HCI

There are two ways to unregister Azure Stack HCI: using Windows Admin Center, or using PowerShell.

### Unregister Azure Stack HCI using Windows Admin Center

When you're ready to decommission your Azure Stack HCI cluster, connect to the cluster using Windows Admin Center. Select **Settings** at the bottom of the **Tools** menu on the left. Then select **Azure Stack HCI registration**, and select the **Unregister** button.

The unregistration process automatically cleans up the Azure resource that represents the cluster, the Azure resource group (if the group was created during registration and doesn't contain any other resources), and the Azure AD app identity. This cleanup stops all monitoring, support, and billing functionality through Azure Arc.

> [!NOTE]
> If your Windows Admin Center gateway is registered to a different AAD tenant ID that was used to initially register the cluster, you might encounter problems when you try to unregister the cluster using Windows Admin Center. If this happens, please use PowerShell instructions.

### Unregister Azure Stack HCI using PowerShell

Using PowerShell. you can use the `Unregister-AzStackHCI` cmdlet to unregister an Azure Stack HCI cluster. You can run the cmdlet either on a cluster node or from a management computer.

You might need to install the latest version of the **Az.StackHCI** module. If you see a prompt that says **Are you sure you want to install the modules from 'PSGallery'?**, answer yes (Y):

```powershell
Install-Module -Name Az.StackHCI
```

#### Unregister from cluster-node

If you're running the `Unregister-AzStackHCI` cmdlet on a server in the cluster, use the following syntax. Specify your Azure subscription ID and the resource name of the Azure Stack HCI cluster that you want to unregister:

```powershell
Unregister-AzStackHCI -SubscriptionId "<subscription ID GUID>" -ResourceName HCI001
```

You're prompted to visit microsoft.com/devicelogin on another device (such as your PC or phone). Enter the code, and sign in there to authenticate with Azure.

#### Unregister from a management PC

If you're running the cmdlet from a management PC, you must also specify the name of a server (node) in the cluster:

```powershell
Unregister-AzStackHCI -ComputerName ClusterNode1 -SubscriptionId "<subscription ID GUID>" -ResourceName HCI001
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

## Next steps

To perform the next management task related to this article, see:
> [!div class="nextstepaction"]
> [Validate an Azure Stack HCI cluster](validate.md)
