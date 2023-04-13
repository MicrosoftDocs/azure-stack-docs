---
title: Register Azure Stack HCI with Azure
description: How to register Azure Stack HCI clusters with Azure.
author: sethmanheim
ms.author: sethm
ms.reviewer: arduppal
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.custom:
  - references_regions
  - devx-track-azurepowershell
ms.date: 04/12/2023
---

# Register Azure Stack HCI with Azure

[!INCLUDE [applies-to](../../includes/hci-applies-to-22h2-21h2-20h2.md)]

Now that you've deployed the [Azure Stack HCI operating system](./operating-system.md) and [created a cluster](./create-cluster.md), you must register the cluster with Azure.

This article describes how to register your Azure Stack HCI cluster with Azure via Windows Admin Center or PowerShell. For information on how to manage cluster registration, see [Manage cluster registration]().

## About cluster registration

Azure Stack HCI is delivered as an Azure service. As per the Azure online services terms, you must register your cluster within 30 days of installation. Your cluster isn't fully supported until your registration is active. If you don't register your cluster with Azure upon deployment, or if your cluster is registered but hasn't connected to Azure for more than 30 days, the system won't allow new virtual machines (VMs) to be created or added. For more information, see  [Job failure when attempting to create VM](troubleshoot-hci-registration.md#job-failure-when-attempting-to-create-vm).

After registration, an Azure Resource Manager resource is created to represent the on-premises Azure Stack HCI cluster. With Azure Stack HCI, version 21H2, registering a cluster automatically creates an Azure Arc of the server resource for each server in the Azure Stack HCI cluster. This Azure Arc integration extends the Azure management plane to Azure Stack HCI. The Azure Arc integration enables periodic syncing of information between the Azure resource and the on-premises clusters.

## Before you begin

Before you begin cluster registration, make sure to complete the following prerequisites:

- Make sure you have an Azure Stack HCI cluster with physical servers that are up and running.

- Make sure you have an Azure subscription and you know the Azure region where the cluster resources should be created. For more information about Azure subscription and supported Azure regions, see [Azure requirements](../concepts/system-requirements.md#azure-requirements).

- Make sure you have access to a management PC. Your management computer must be joined to the same Active Directory domain in which you've created your Azure Stack HCI cluster.

- If you're using Windows Admin Center to register the cluster:
   - [Install Windows Admin Center](/windows-server/manage/windows-admin-center/deploy/install) on a management PC and [register your Windows Admin Center instance with Azure](../manage/register-windows-admin-center.md).
   > [!IMPORTANT]
   > When registering Windows Admin Center with Azure, it's important to use the same Azure Active Directory (tenant) ID that you plan to use for the cluster registration. An Azure AD tenant ID represents a specific instance of Azure AD containing accounts and groups, whereas an Azure subscription ID represents an agreement to use Azure resources for which charges accrue. To find your tenant ID, go to the Azure portal and select Azure Active Directory. Your tenant ID is displayed under Tenant information. To get your Azure subscription ID, navigate to Subscriptions and copy/paste your ID from the list.

   - To register your cluster in Azure China, install Windows Admin Center version 2103.2 or later.

- If you're using PowerShell to register the cluster:
   - You must run all the PowerShell commands as the Administrator user.
   - Install the [`Az.StackHCI`](/powershell/module/az.stackhci) PowerShell module on your management PC.
   > [!NOTE]
   > If you cannot run the cmdlet from a management PC that has outbound internet access, we recommend downloading the modules and manually transferring them to a cluster node where you can run the `Register-AzStackHCI` cmdlet. Alternatively, you can [install the modules in a disconnected scenario](/powershell/scripting/gallery/how-to/working-with-local-psrepositories#installing-powershellget-on-a-disconnected-system).

## Prechecks

Before proceeding with registration, make sure you don't have any conflicting Azure policies that might interfere with cluster registration. Some of the common conflicting policies can be:

- **Resource group naming**: Azure Stack HCI registration provides two configuration parameters for naming resource groups: `-ResourceGroupName` and `-ArcServerResourceGroupName`. See [Register-AzStackHCI](/powershell/module/az.stackhci/register-azstackhci) for details on the resource group naming. Make sure that the naming does not conflict with the existing policies.

- **Resource group tags**: Currently Azure Stack HCI does not support adding tags to resource groups during cluster registration. Make sure your policy accounts for this behavior.

- **.msi download**: Azure Stack HCI downloads the Arc agent on the cluster nodes during cluster registration. Make sure you don't restrict these downloads.

- **Credentials lifetime**: By default, the Azure Stack HCI service requests two years of credential lifetime. Make sure your Azure policy doesn't have any configuration conflicts.

   > [!NOTE]
   > If you have a separate resource group for Arc-for-Server resources, we recommend using a resource group having Arc-for-Server resources related only to Azure Stack HCI. The Azure Stack HCI resource provider has permissions to manage any other Arc-for-Server resources in the **ArcServer** resource group.

## Assign permissions for cluster registration

You can assign permissions for cluster registration from the Azure portal or by using PowerShell.

### Assign permissions from the Azure portal

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

| Permissions | Reason |
|--|--|
| "Microsoft.Resources/subscriptions/resourceGroups/read",</br> "Microsoft.Resources/subscriptions/resourceGroups/write",</br> "Microsoft.Resources/subscriptions/resourceGroups/delete"</br> "Microsoft.AzureStackHCI/register/action",</br> "Microsoft.AzureStackHCI/Unregister/Action",</br> "Microsoft.AzureStackHCI/clusters/*",</br>"Microsoft.Authorization/roleAssignments/read", | To register and unregister the Azure Stack HCI cluster. |
| "Microsoft.Authorization/roleAssignments/write",</br> "Microsoft.HybridCompute/register/action",</br> "Microsoft.GuestConfiguration/register/action",</br> "Microsoft.HybridConnectivity/register/action" | To register and unregister the Arc for server resources. |

## Register a cluster

You can register your Azure Stack HCI cluster using Windows Admin Center or PowerShell.

# [Windows Admin Center](#tab/windows-admin-center)

Before registration make sure all the [prerequisites](#before-you-begin) and [prechecks](#prechecks) are met.

1. Launch Windows Admin center and sign in to your Azure account. Go to **Settings** > **Account**, and then select **Sign in** under **Azure Account**.

1. In Windows Admin Center, select **Cluster Manager** from the top drop-down arrow.

1. Under **Cluster connections**, select the cluster you want to register.

1. On **Dashboard**, under **Azure Arc**, check the status of **Azure Stack HCI registration** and **Arc-enabled servers**.

   - **Not configured** means your cluster isn't registered.
   - **Connected** means your cluster is registered with Azure and is successfully synced to the cloud within the last day. Skip rest of the registration steps and see [Manage the cluster](../manage/cluster.md) to manage your cluster.

1. If your cluster isn't registered, under **Azure Stack HCI registration**, select **Register** to proceed.

   > [!NOTE]
   > You can also register your cluster from the **Tools** > **Azure Arc** dashboard, which is currently in preview.

   > [!NOTE]
   > If you did not register Windows Admin Center in step 1, you are asked to do so now. Instead of the cluster registration wizard, you'll see the Windows Admin Center registration wizard.

1. Specify the Azure subscription ID to which you want to register the cluster. To get your Azure subscription ID, visit the Azure portal, navigate to **Subscriptions**, and copy/paste your ID from the list.

1. Select the Azure region from the drop-down menu.

1. Select one of the following options to select the Azure Stack HCI resource group:

   - Select **Use existing** to create the Azure Stack HCI cluster and Arc for Server resources in an existing resource group.

   - Select **Create new** to create a new resource group. Enter a name for the new resource group.

      :::image type="content" source="media/register-with-azure/arc-registration-flyout.png" alt-text="Screenshot of cluster registration wizard." lightbox="media/register-with-azure/arc-registration-flyout.png":::

1. Select **Register**. It takes a few minutes to complete the registration.

# [PowerShell](#tab/power-shell)

Before registration, [make sure all the prerequisites are met](#before-you-begin).

Follow these steps to register an Azure Stack HCI cluster with Azure using PowerShell from a management computer.

1. Install the required PowerShell cmdlets on your management computer. If you're running Azure Stack HCI version 20H2, and your cluster was deployed prior to December 10, 2020, make sure you have applied the November 23, 2020 Preview Update (KB4586852) to each server in the cluster before attempting to register with Azure.

   ```PowerShell
   Install-Module -Name Az.StackHCI
   ```

   > [!NOTE]
   > If you see a prompt such as **Do you want PowerShellGet to install and import the NuGet provider now?**, press **Yes(Y)**.
   >
   > If you see another prompt saying **Are you sure you want to install the modules from 'PSGallery'?** press **Yes(Y)**.

2. Use the [Register-AzStackHCI](/powershell/module/az.stackhci/register-azstackhci) cmdlet, with the `subscriptionID`, `TenantID`, `ComputerName`, and `Region` parameters. The following example registers an HCI cluster to the East US region by connecting to one of the nodes of the cluster called `server1`, and automatically Arc-enables each node of the cluster.

   To get your Azure subscription ID, visit the Azure portal, navigate to **Subscriptions**, and copy/paste your ID from the list. To get your tenant ID, visit the Azure portal, navigate to **Azure Active Directory**, and copy/paste your tenant ID:

   ```powershell
   Register-AzStackHCI  -SubscriptionId "<subscription_ID>" -ComputerName server1 -Region "eastus" -TenantId "<tenant_id>"  
   ```

   If the management PC has a GUI, you will get a login prompt, in which you provide the credentials to access the cluster nodes. If the management PC doesn't have a GUI, use the parameter `-credentials <credentials to log in to cluster nodes>` in the `Register-AzStackHCI` cmdlet.

   This syntax registers the cluster (of which **Server1** is a member) as the current user, and automatically Arc-enables the nodes by default. The command also places the HCI cluster resource as the `<on-prem cluster name>` Azure resource and all the Arc-for-Server resources as `<server name>` in the `<on-prem cluster name>-rg` resource group, in the specified region, subscription, and tenant with the default cloud environment (AzureCloud). You can use the optional `-ResourceGroupName` and `-ArcServerResourceGroupName` parameters to this cmdlet.

   > [!NOTE]
   > If you have a separate resource group for Arc-for-Server resources, we recommend using a resource group having Arc-for-Server resources related only to Azure Stack HCI. The Azure Stack HCI resource provider has permissions to manage any other Arc-for-Server resources in the ArcForServer resource group.

   For PowerShell module version 1.4.1 or earlier, you can't use a pre-created resource group for the `ARCServerResourceGroupName` parameter.

   > [!NOTE]
   > If you are registering Azure Stack HCI in Azure China, run the `Register-AzStackHCI` cmdlet with these additional parameters: `-EnvironmentName "AzureChinaCloud" -Region "ChinaEast2"`.
   >
   > If you're registering in Azure Government, use `-EnvironmentName "AzureUSGovernment" -Region "UsGovVirginia"`.

   > [!NOTE]
   > Azure Arc integration is not available for Azure Stack HCI, version 20H2. For Azure Stack HCI version 21H2 and later, the clusters are automatically Arc-enabled on registration.

3. Authenticate with Azure. To complete the registration process, you must authenticate (sign in) using your Azure account. Your account must have access to the Azure subscription that was specified in step 2. If your management node has a user interface, a sign-in screen appears, in order to proceed with the registration. If your management node doesn't have a UI, follow the device code-based login workflow, as guided on the console. The registration workflow detects when you've logged in, and proceeds to completion. You should then be able to see your cluster in the Azure portal.

---

## Manage cluster registration

After you register your cluster with Azure, you can manage its registration in Windows Admin Center, PowerShell, and the Azure portal.

Depending on your cluster configuration and requirements, you may need to take the following actions to manage the cluster registration:

- View status of registration and Arc-enabled servers
- Enable Azure Arc integration
- Upgrade Arc agent on cluster servers
- Unregister the cluster
- Troubleshoot cluster registrations
- Review FAQs

For information on how to manage your cluster registration, see [Manage cluster registration](../manage/manage-cluster-registration.md).

## Next steps

To perform the next management task related to this article, see:
> [!div class="nextstepaction"]
> [Validate an Azure Stack HCI cluster](validate.md)
