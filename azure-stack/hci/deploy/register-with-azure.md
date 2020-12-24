---
title: Connect Azure Stack HCI to Azure
description: How to register Azure Stack HCI clusters with Azure.
author: khdownie
ms.author: v-kedow
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 12/23/2020
---

# Connect Azure Stack HCI to Azure

> Applies to: Azure Stack HCI v20H2

Azure Stack HCI is delivered as an Azure service and needs to register within 30 days of installation per the Azure Online Services Terms. This topic explains how to register your Azure Stack HCI cluster with [Azure Arc](https://azure.microsoft.com/services/azure-arc/) for monitoring, support, billing, and hybrid services. Upon registration, an Azure Resource Manager resource is created to represent each on-premises Azure Stack HCI cluster, effectively extending the Azure management plane to Azure Stack HCI. Information is periodically synced between the Azure resource and the on-premises cluster(s).

   > [!IMPORTANT]
   > Registering with Azure is required. Until your cluster is registered with Azure, the Azure Stack HCI operating system is not validly licensed, is not supported, and has reduced functionality (for example, you won't be able to create virtual machines). If you do not register your cluster with Azure, or if your cluster has not connected to Azure for 30 days, you will see the following error message when attempting to create VMs: 
   > 
   > *There was a failure configuring the virtual machine role for 'vmname'. Job failed. Error opening "vmname" clustered roles. The service being accessed is licensed for a particular number of connections. No more connections can be made to the service at this time because there are already as many connections as the service can accept.*
   > 
   > The solution is to allow outbound connectivity to Azure and register your cluster with Azure as described in this topic.

## Prerequisites for registration

You won't be able to register with Azure until you've created an Azure Stack HCI cluster. In order for the cluster to be supported, the cluster nodes must be physical servers. Virtual machines can be used for testing, but they must support Unified Extensible Firmware Interface (UEFI), meaning you can't use Hyper-V Generation 1 virtual machines. Azure Arc registration is a native capability of the Azure Stack HCI operating system, so there is no agent needed to register.

### Internet access

Azure Stack HCI needs to periodically connect to the Azure public cloud. If outbound connectivity is restricted by your external corporate firewall or proxy server, they must be configured to allow outbound access to port 443 (HTTPS) on a limited number of well-known Azure IPs. For information on how to prepare your firewalls, see [Configure firewalls for Azure Stack HCI](../concepts/configure-firewalls.md).

   > [!NOTE]
   > The registration process tries to contact the PowerShell Gallery to verify that you have the latest version of the necessary PowerShell modules such as Az and AzureAD. Although the PowerShell Gallery is hosted on Azure, it does not currently have a service tag. If you cannot run the above cmdlet from a management machine that has outbound internet access, we recommend downloading the modules and manually transferring them to a cluster node where you will run the `Register-AzStackHCI` command. Alternatively, you can [install the modules in a disconnected scenario](/powershell/scripting/gallery/how-to/working-with-local-psrepositories?view=powershell-7.1#installing-powershellget-on-a-disconnected-system).

### Azure subscription and permissions

If you don’t already have an Azure account, [create one](https://azure.microsoft.com/).

You can use an existing subscription of any type:
- Free account with Azure credits [for students](https://azure.microsoft.com/free/students/) or [Visual Studio subscribers](https://azure.microsoft.com/pricing/member-offers/credit-for-visual-studio-subscribers/)
- [Pay-as-you-go](https://azure.microsoft.com/pricing/purchase-options/pay-as-you-go/) subscription with credit card
- Subscription obtained through an Enterprise Agreement (EA)
- Subscription obtained through the Cloud Solution Provider (CSP) program

The user registering the cluster must have Azure subscription permissions to:

- Register a resource provider
- Create/Get/Delete Azure resources and resource groups

If your Azure subscription is through an EA or CSP, the easiest way is to ask your Azure subscription admin to assign a built-in "Owner" or "Contributor" Azure role to your subscription. However, some admins may prefer a more restrictive option. In this case, it's possible to create a custom Azure role specific for Azure Stack HCI registration by following these steps:

1. Create a json file called **customHCIRole.json** with following content. Make sure to change <subscriptionID> to your Azure subscription ID. To get your subscription ID, visit [portal.azure.com](https://portal.azure.com), navigate to Subscriptions, and copy/paste your ID from the list.

   ```json
   {
     "Name": "Azure Stack HCI registration role”,
     "Id": null,
     "IsCustom": true,
     "Description": "Custom Azure role to allow subscription-level access to register Azure Stack HCI",
     "Actions": [
       "Microsoft.Resources/subscriptions/resourceGroups/write",
       "Microsoft.Resources/subscriptions/resourceGroups/read",
       "Microsoft.Resources/subscriptions/resourceGroups/delete",
       "Microsoft.AzureStackHCI/register/action",
       "Microsoft.AzureStackHCI/Unregister/Action",
       "Microsoft.AzureStackHCI/clusters/*"
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

You'll also need appropriate Azure Active Directory permissions to complete the registration process. If you don't already have them, ask your Azure AD administrator to grant consent or delegate the permissions to you. See [Manage Azure registration](../manage/manage-azure-registration.md#azure-active-directory-app-permissions) for more information.

## Register using PowerShell

Use the following procedure to register an Azure Stack HCI cluster with Azure using a management PC.

1. Install the required cmdlets on your management PC. If you are registering a cluster deployed from the current General Availability (GA) image of Azure Stack HCI, simply run the following command. If your cluster was deployed from the Public Preview image, make sure you have applied the November 23, 2020 Preview Update (KB4586852) to each server in the cluster before attempting to register with Azure.

   ```PowerShell
   Install-Module -Name Az.StackHCI
   ```

   > [!NOTE]
   > - You may see a prompt such as "Do you want PowerShellGet to install and import the NuGet provider now?" to which you should answer Yes (Y).
   > - You may further be prompted "Are you sure you want to install the modules from 'PSGallery'?" to which you should answer Yes (Y).

2. Perform the registration using the name of any server in the cluster. To get your Azure subscription ID, visit [portal.azure.com](https://portal.azure.com), navigate to Subscriptions, and copy/paste your ID from the list.

   ```PowerShell
   Register-AzStackHCI  -SubscriptionId "<subscription_ID>" -ComputerName Server1 [–Credential] [-ResourceName] [-ResourceGroupName] [-Region]
   ```

   This syntax registers the cluster (of which Server1 is a member), as the current user, with the default Azure region and cloud environment, and using smart default names for the Azure resource and resource group, but you can add parameters to this command to specify these values if you want.

   Remember that the user running the `Register-AzStackHCI` cmdlet must have [Azure Active Directory permissions](../manage/manage-azure-registration.md#azure-active-directory-app-permissions), or the registration process will not complete; instead, it will exit and leave the registration pending admin consent. Once permissions have been granted, simply re-run `Register-AzStackHCI` to complete registration.

3. Authenticate with Azure

   To complete the registration process, you need to authenticate (sign in) using your Azure account. Your account needs to have access to the Azure subscription that was specified in step 4 above in order for registration to proceed. Copy the code provided, navigate to microsoft.com/devicelogin on another device (like your PC or phone), enter the code, and sign in there. This is the same experience Microsoft uses for other devices with limited input modalities, like Xbox.

The registration workflow will detect when you've logged in and proceed to completion. You should then be able to see your cluster in the Azure portal.

## Next steps

You are now ready to:

- [Validate the cluster](validate.md)

