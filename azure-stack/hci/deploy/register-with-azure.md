---
title: Connect Azure Stack HCI to Azure
description: How to register Azure Stack HCI clusters with Azure.
author: arduppal
ms.author: arduppal
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 11/29/2021
---

# Connect Azure Stack HCI to Azure

> Applies to: Azure Stack HCI, versions 21H2 and 20H2

Now that you've deployed the Azure Stack HCI operating system and created a cluster, you must register the cluster with Azure. Azure Stack HCI is delivered as an Azure service and needs to register within 30 days of installation per the Azure Online Services Terms.

This topic explains how to register your Azure Stack HCI cluster with Azure for monitoring, support, billing, and hybrid services. Upon registration, an Azure Resource Manager resource is created to represent each on-premises Azure Stack HCI cluster, effectively extending the Azure management plane to Azure Stack HCI. Information is periodically synced between the Azure resource and the on-premises cluster(s). Azure registration is a native capability of the Azure Stack HCI operating system, so there is no agent needed to register.

   > [!IMPORTANT]
   > Registering with Azure is required, and your cluster is not fully supported until your registration is active. If you do not register your cluster with Azure upon deployment, or if your cluster is registered but has not connected to Azure for more than 30 days, the system will not allow new virtual machines (VMs) to be created or added. When this occurs, you will see the following error message when attempting to create VMs:
   >
   > *There was a failure configuring the virtual machine role for 'vmname'. Job failed. Error opening "vmname" clustered roles. The service being accessed is licensed for a particular number of connections. No more connections can be made to the service at this time because there are already as many connections as the service can accept.*
   >
   > The solution is to allow outbound connectivity to Azure and make sure your cluster is registered as described in this topic.

## Prerequisites for cluster registration

You won't be able to register your cluster with Azure until you've created an Azure Stack HCI cluster. In order for the cluster to be supported, the cluster nodes must be physical servers. Virtual machines can be used for testing.

For the simplest registration experience, have an Azure AD admin (Owner or User Access Administrator with Contributor role) complete the registration process using either Windows Admin Center or PowerShell.

   > [!IMPORTANT]
   > Azure Stack HCI is now available in Azure China. To register your Azure Stack HCI cluster in Azure China, please ensure you are using [Windows Admin Center version 2103.2](https://aka.ms/wac2103.2) or later. You can also [Register a cluster using PowerShell](#register-a-cluster-using-powershell).
   > 
   > Azure Stack HCI is now available in Preview in Azure Government. Registration requires [Windows Admin Center version 2110](https://aka.ms/wac2110) or later.

Before you register your cluster, make sure every server in the cluster is up and running, and that the following prerequisites are satisfied.

### Windows Admin Center must be registered with Azure

If you plan to register an Azure Stack HCI cluster by using Windows Admin Center, you must first [register Windows Admin Center with Azure](../manage/register-windows-admin-center.md) and supply your Azure Active Directory (tenant) ID. Make sure that the computer on which you run Windows Admin Center is joined to the same Active Directory domain in which you'll create the cluster, or a trusted domain.

### Internet access and firewall ports

Azure Stack HCI needs to periodically connect to the Azure public cloud. If outbound connectivity is restricted by your external corporate firewall or proxy server, they must be configured to allow outbound access to port 443 (HTTPS) on a limited number of well-known Azure IPs. For information on how to prepare your firewalls and set up a proxy server, see [Firewall requirements for Azure Stack HCI](../concepts/firewall-requirements.md).

   > [!NOTE]
   > The registration process tries to contact the PowerShell Gallery to verify that you have the latest version of the necessary PowerShell modules such as Az and AzureAD. Although the PowerShell Gallery is hosted on Azure, it does not currently have a service tag. If you cannot run the above cmdlet from a management machine that has outbound internet access, we recommend downloading the modules and manually transferring them to a cluster node where you will run the `Register-AzStackHCI` command. Alternatively, you can [install the modules in a disconnected scenario](/powershell/scripting/gallery/how-to/working-with-local-psrepositories?view=powershell-7.1#installing-powershellget-on-a-disconnected-system&preserve-view=true).

### Azure subscription and permissions

If you don't already have an Azure account, [create one](https://azure.microsoft.com/).

You can use an existing subscription of any type:

- Free account with Azure credits [for students](https://azure.microsoft.com/free/students/) or [Visual Studio subscribers](https://azure.microsoft.com/pricing/member-offers/credit-for-visual-studio-subscribers/)
- [Pay-as-you-go](https://azure.microsoft.com/pricing/purchase-options/pay-as-you-go/) subscription with credit card
- Subscription obtained through an Enterprise Agreement (EA)
- Subscription obtained through the Cloud Solution Provider (CSP) program

The user registering the cluster must have Azure subscription permissions to:

- Register a resource provider.
- Get Azure resources and resource groups.

If your Azure subscription is through an EA or CSP, the easiest way is to ask your Azure subscription admin to assign a built-in "Owner" role to your subscription, or a "User Access Administrator" role along with a "Contributor" role. However, some admins may prefer a more restrictive option. In this case, it's possible to create a custom Azure role specific for Azure Stack HCI registration by following these steps:

1. Create a json file called **customHCIRole.json** with following content. Make sure to change `<subscriptionID>` to your Azure subscription ID. To get your subscription ID, visit [portal.azure.com](https://portal.azure.com), navigate to Subscriptions, and copy/paste your ID from the list.

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
       "Microsoft.GuestConfiguration/register/action"
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

### Azure Active Directory permissions

You'll also need appropriate Azure Active Directory permissions to complete the registration process. If you don't already have them, ask your Azure AD administrator to grant consent or delegate the permissions to you. See [Manage Azure registration](../manage/manage-azure-registration.md#assign-azure-ad-app-permissions) for more information.

## Region availability

The Azure Stack HCI service is used for registration, billing, and management. It is currently supported in the following regions. These public regions support geographic locations worldwide, for clusters deployed anywhere in the world:

- East US
- West Europe
- Southeast Asia

This region supports Azure China:

- China East 2

This region supports Azure Government:

- US Gov Virginia

## Register a cluster using Windows Admin Center

The easiest way to register your Azure Stack HCI cluster is using Windows Admin Center. Remember that the user must have [Azure Active Directory permissions](../manage/manage-azure-registration.md#assign-azure-ad-app-permissions), or the registration process will not complete; instead, it will exit and leave the registration pending admin approval, and the user will have to re-run the registration wizard once permissions are granted. 

If you're running Azure Stack HCI, version 21H2, the user must be assigned an Azure Owner role or a User Access Administrator role, or they will encounter an error message: "Failed to assign required roles for Azure Arc integration." Users who are not assigned these roles can still [Register a cluster using PowerShell](#register-a-cluster-using-powershell), but they must manually disable Azure Arc integration.

   > [!WARNING]
   > To register your Azure Stack HCI cluster in Azure China, please ensure you are using [Windows Admin Center version 2103.2](https://aka.ms/wac2103.2) or later.
   > 
   > Azure Stack HCI is now available in Preview in Azure Government. Registration requires [Windows Admin Center version 2110](https://aka.ms/wac2110) or later.

1. Before beginning the registration process, you must first [register Windows Admin Center with Azure](../manage/register-windows-admin-center.md) and sign into Windows Admin Center with your Azure account.

   > [!IMPORTANT]
   > When registering Windows Admin Center with Azure, it's important to use the same Azure Active Directory (tenant) ID that you plan to use for the cluster registration. An Azure AD tenant ID represents a specific instance of Azure AD containing accounts and groups, whereas an Azure subscription ID represents an agreement to use Azure resources for which charges accrue. To find your tenant ID, visit [portal.azure.com](https://portal.azure.com) and select **Azure Active Directory**. Your tenant ID will be displayed under **Tenant information**. To get your Azure subscription ID, navigate to **Subscriptions** and copy/paste your ID from the list.

2. Open Windows Admin Center and select **Settings** from the very bottom of the **Tools** menu at the left. Then select **Azure Stack HCI registration** from the bottom of the **Settings** menu. If your cluster has not yet been registered with Azure, then **Registration status** will say **Not registered**. Click the **Register** button to proceed. You can also select **Register this cluster** from the Windows Admin Center dashboard.

   > [!NOTE]
   > If you did not register Windows Admin Center in step 1, you'll be asked to do so now. Instead of the cluster registration wizard, you'll see the Windows Admin Center registration wizard.

3. Specify the Azure subscription ID that you want to register the cluster to. To get your Azure subscription ID, visit [portal.azure.com](https://portal.azure.com), navigate to **Subscriptions** and copy/paste your ID from the list. If your Azure AD admin gave you an Azure resource group to use, select it from the drop-down menu. Use the **Use existing** resource group option to register the Azure stack HCI cluster:

   :::image type="content" source="media/register/register-with-azure.png" alt-text="The cluster registration wizard will ask for your Azure subscription ID, resource group, and region" lightbox="media/register/register-with-azure.png":::

   If you want to use the **Create new** resource group option, you must provide the following two permissions to the subscription. Add these two lines to the **customHCIRole.json** file shown in step 1 of [Azure subscription and permissions](#azure-subscription-and-permissions):

   ```json
   "Microsoft.Resources/subscriptions/resourceGroups/write"
   "Microsoft.Resources/subscriptions/resourceGroups/delete"
   ```

   The file will appear as follows:

   ```json
   {
     "Name": "Azure Stack HCI registration role",
     "Id": null,
     "IsCustom": true,
     "Description": "Custom Azure role to allow subscription-level access to register Azure Stack HCI",
     "Actions": [
       "Microsoft.Resources/subscriptions/resourceGroups/read",
       "Microsoft.Resources/subscriptions/resourceGroups/write"
       "Microsoft.Resources/subscriptions/resourceGroups/delete"
       "Microsoft.AzureStackHCI/register/action",
       "Microsoft.AzureStackHCI/Unregister/Action",
       "Microsoft.AzureStackHCI/clusters/*",
       "Microsoft.Authorization/roleAssignments/write",
       "Microsoft.HybridCompute/register/action",
       "Microsoft.GuestConfiguration/register/action"
     ],
     "NotActions": [
     ],
   "AssignableScopes": [
       "/subscriptions/<subscriptionId>"
     ]
   }
   ```

4. Select the [Azure region](#region-availability) from the drop-down menu and click **Register**.

5. If you have sufficient Azure Active Directory permissions, the cluster registration workflow should now proceed to completion, and you should be able to see your cluster in the Azure portal. If you receive a message that you need additional Azure Active Directory permissions, proceed to step 5.

6. If you don't have sufficient Azure Active Directory permissions, you'll need to ask your Azure AD admin to [grant permissions to the app](../manage/manage-azure-registration.md#assign-azure-ad-app-permissions). You should see a link to the Azure portal that goes to the cluster's specific app ID, as in the screenshot below. Copy this link and give it to your Azure AD admin. To check whether consent has been granted, select **View consent in Azure AD**. After consent has been granted, re-run the wizard beginning with step 2 above.

   :::image type="content" source="media/register/registration-permissions.png" alt-text="If you need additional Azure Active Directory permissions to register the cluster, you'll be given a link to provide to your Azure AD admin" lightbox="media/register/registration-permissions.png":::

## Register a cluster using PowerShell

Use the following procedure to register an Azure Stack HCI cluster with Azure using a management PC.

   > [!IMPORTANT]
   > Only Azure users with Owner or User Access Administrator roles can register an Azure Stack HCI cluster with Azure Arc integration.

1. Install the required cmdlets on your management PC. If you're running Azure Stack HCI, version 20H2 and your cluster was deployed prior to December 10, 2020, make sure you have applied the November 23, 2020 Preview Update (KB4586852) to each server in the cluster before attempting to register with Azure.

   ```PowerShell
   Install-Module -Name Az.StackHCI
   ```

   > [!NOTE]
   > - You may see a prompt such as **Do you want PowerShellGet to install and import the NuGet provider now?** to which you should answer **Yes** (Y).
   > - You may further be prompted **Are you sure you want to install the modules from 'PSGallery'?** to which you should answer **Yes** (Y).

2. Perform the registration using the name of any server in the cluster. To get your Azure subscription ID, visit [portal.azure.com](https://portal.azure.com), navigate to **Subscriptions** and copy/paste your ID from the list. You must also provide the name of a pre-existing resource group:

   > [!IMPORTANT]
   > If you're registering Azure Stack HCI in Azure China, run the `Register-AzStackHCI` cmdlet with these additional parameters: 
   >
   > `-EnvironmentName AzureChinaCloud -Region "ChinaEast2"`
   >
   > If you're registering in Azure Government, use these parameters:
   >
   > `-EnvironmentName AzureUSGovernment -Region "USGovVirginia"`

   ```PowerShell
   Register-AzStackHCI  -SubscriptionId "<subscription_ID>" -ComputerName Server1 -ResourceGroupName cluster1-rg
   ```

   This syntax registers the cluster (of which `Server1` is a member) as the current user, and places the HCI cluster resource in the specified resource group (`cluster1-rg`) with the default Azure region and cloud environment, and using smart default names for the Azure resource. You can also add the optional `-Region`, `-ResourceName`, and `-TenantId` parameters to this command to specify these values.

   > [!NOTE]
   > If you're running Azure Stack HCI, version 21H2, running the `Register-AzStackHCI` cmdlet [enables Azure Arc integration](#enabling-azure-arc-integration) on every server in the cluster by default, and the user running it must be an Azure Owner or User Access Administrator. If you do not want the servers to be Arc enabled or do not have the proper roles, pass this additional parameter: `-EnableAzureArcServer:$false`

   Remember that the user running the `Register-AzStackHCI` cmdlet must have [Azure Active Directory permissions](../manage/manage-azure-registration.md#assign-azure-ad-app-permissions), or the registration process will not complete; instead, it will exit and leave the registration pending admin approval. Once permissions have been granted, simply re-run `Register-AzStackHCI` to complete registration.

3. Authenticate with Azure

   To complete the registration process, you need to authenticate (sign in) using your Azure account. Your account needs to have access to the Azure subscription that was specified in step 2 above in order for registration to proceed. Copy the code provided, navigate to microsoft.com/devicelogin on another device (like your PC or phone), enter the code, and sign in there. The registration workflow will detect when you've logged in and proceed to completion. You should then be able to see your cluster in the Azure portal.

## Enabling Azure Arc integration

If you're a preview channel customer and you registered your preview channel cluster with Azure for the first time on or after June 15, 2021, every server in the cluster will be Azure Arc-enabled by default, as long as the user registering the cluster has Azure Owner or User Access Administrator roles. Otherwise, you'll need to take the following steps to enable Azure Arc integration on the servers.

   > [!NOTE]
   > Azure Arc integration is only available in Azure Stack HCI, version 21H2 and preview builds. It is not available on Azure Stack HCI, version 20H2.

1. Install the latest version of the `Az.StackHCI` module on your management PC:

   ```PowerShell
   Install-Module -Name Az.StackHCI
   ```

2. Re-run the `Register-AzStackHCI` cmdlet and specify your Azure subscription ID, which must be the same ID to which the cluster was originally registered. The `-ComputerName` parameter can be the name of any server in the cluster. This step enables Azure Arc integration on every server in the cluster. It will not affect your current cluster registration with Azure, and you don't need to unregister the cluster first.

   ```PowerShell
   Register-AzStackHCI  -SubscriptionId "<subscription_ID>" -ComputerName Server1
   ```

   > [!IMPORTANT]
   > If the cluster was originally registered using a `-Region`, `-ResourceName`, or `-ResourceGroupName` that's different from the default settings, you'll need to specify those same parameters and values here. Running `Get-AzureStackHCI` will display these values.

3. If Azure Arc integration fails, then the servers may need to communicate through a proxy server. To resolve this, set the proxy server environment variable by running the following PowerShell command as administrator on each server in the cluster:

   ```PowerShell
   [Environment]::SetEnvironmentVariable("https_proxy", "http://{proxy-url}:{proxy-port}", "Machine")
   $env:https_proxy = [System.Environment]::GetEnvironmentVariable("https_proxy","Machine")
   # For the changes to take effect, the agent service needs to be restarted after the proxy environment variable is set.
   Restart-Service -Name himds
   ```

   Then, re-register the Azure Stack HCI cluster.

## Troubleshooting

Troubleshooting Azure Stack HCI registration issues requires looking at both PowerShell registration logs and hcisvc debug logs from each server in the cluster.

### Collect PowerShell registration logs

When `Register-AzStackHCI` and `Unregister-AzStackHCI` cmdlets are run, log files called **RegisterHCI_{yyyymmdd-hhss}.log** and **UnregisterHCI_{yyyymmdd-hhss}.log** are created for each attempt. These files are created in the working directory of the PowerShell session in which the cmdlets are run. Debug logs are not included by default. If there is an issue which needs the additional debug logs, set debug preference to **Continue** by running the following cmdlet before running `Register-AzStackHCI` or `Unregister-AzStackHCI`.

```PowerShell
$DebugPreference = 'Continue'
```

### Collect on-premises hcisvc logs

To enable debug logs for hcisvc, run the following in PowerShell on each server in the cluster:

```PowerShell
wevtutil.exe sl /q /e:true Microsoft-AzureStack-HCI/Debug
```

To get the logs:

```PowerShell
Get-WinEvent -Logname Microsoft-AzureStack-HCI/Debug -Oldest -ErrorAction Ignore
```

### Common registration issues

During registration, each server in the cluster must be up and running with outbound internet connectivity to Azure. The `Register-AzStackHCI` cmdlet talks to all servers in the cluster to provision certificates for each. Each server will use its certificate to make API call to HCI services in the cloud to validate registration.

If registration fails, you may see the following message:

**Failed to register. Couldn't generate self-signed certificate on node(s) {Node1,Node2}. Couldn't set and verify registration certificate on node(s) {Node1,Node2}**

If there are node names after the 'Couldn't generate self-signed certificate on node(s)' part of the error message, then we weren't able to generate the certificate on those server(s). To troubleshoot:

1. Check that each server listed in the above message is up and running. You can check the status of hcisvc by running `sc.exe query hcisvc` and start it if needed with `start-service hcisvc`.

2. Check that each server listed in the error message has connectivity to the machine on which the `Register-AzStackHCI` cmdlet is run. Verify this by running the following cmdlet from the machine on which `Register-AzStackHCI` is run, using `New-PSSession` to connect to each server in the cluster and make sure it works.
   
   ```PowerShell
   New-PSSession -ComputerName {failing nodes}
   ```
   
If there are node names after the 'Couldn't set and verify registration certificate on node(s)' part of the error message, then we were able to generate the certificate on the server(s), but the server(s) weren't able to successfully call the HCI cloud service API. To troubleshoot:

1. Make sure each server has the required internet connectivity to talk to Azure Stack HCI cloud services and other required Azure services like Azure Active Directory, and that it's not being blocked by firewall(s). See [Firewall requirements for Azure Stack HCI](../concepts/firewall-requirements.md).

2. Try running the `Test-AzStackHCIConnection` cmdlet and make sure it succeeds. This cmdlet will invoke the health endpoint of HCI cloud services to test connectivity.

3. Look at the hcisvc debug logs on each node listed in the error message. 

   - It's ok to have 'ExecuteWithRetry operation AADTokenFetch failed with retryable error' appear a few times before it either fails with 'ExecuteWithRetry operation AADTokenFetch failed after all retries' or 'ExecuteWithRetry operation AADTokenFetch succeeded in retry'.
   - If you encounter 'ExecuteWithRetry operation AADTokenFetch failed after all retries' in the logs, we weren't able to fetch the Azure Active Directory token from the service even after all the retries. There will be an associated AAD exception that's logged with this message. 
   - If you see "AADSTS700027: Client assertion contains an invalid signature. [Reason - The key used is expired. Thumbprint of key used by client: '{SomeThumbprint}', Found key 'Start=06/29/2021 21:13:15, End=06/29/2023 21:13:15'", this is an issue with how the time is set on the server. Check the UTC time on all the servers by running `[System.DateTime]::UtcNow` in PowerShell, and compare it with the actual UTC time. If the time isn't correct, then set the correct the times on the servers and then try registration again.

## Next steps

To perform the next management task related to this article, see:
> [!div class="nextstepaction"]
> [Validate an Azure Stack HCI cluster](validate.md)
