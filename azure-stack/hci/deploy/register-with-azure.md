---
title: Connect Azure Stack HCI to Azure
description: How to register Azure Stack HCI with Azure.
author: khdownie
ms.author: v-kedow
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 12/10/2020
---

# Connect Azure Stack HCI to Azure

> Applies to: Azure Stack HCI v20H2

Azure Stack HCI is delivered as an Azure service and needs to register within 30 days of installation per the Azure Online Services Terms. This topic explains how to register your Azure Stack HCI cluster with [Azure Arc](https://azure.microsoft.com/services/azure-arc/) for monitoring, support, billing, and hybrid services. Upon registration, an Azure Resource Manager resource is created to represent each on-premises Azure Stack HCI cluster, effectively extending the Azure management plane to Azure Stack HCI. Information is periodically synced between the Azure resource and the on-premises cluster(s).

   > [!IMPORTANT]
   > Registering with Azure is required. Until your cluster is registered with Azure, the Azure Stack HCI operating system is not validly licensed, is not supported, and has reduced functionality (for example, you won't be able to create virtual machines).

## Prerequisites for registration

You won’t be able to register with Azure until you've created an Azure Stack HCI cluster. The nodes can be physical machines or virtual machines, but they must have Unified Extensible Firmware Interface (UEFI), meaning you can’t use Hyper-V Generation 1 virtual machines. Azure Arc registration is a native capability of Azure Stack HCI, so there is no agent required.

### Internet access

Azure Stack HCI needs to periodically connect to the Azure public cloud. If outbound connectivity is restricted by your external corporate firewall or proxy server, they must be configured to allow outbound access to port 443 (HTTPS) on a limited number of well-known Azure IPs. For more information on how to prepare your firewalls, see Configure firewalls for Azure Stack HCI.

### Azure subscription

If you don’t already have an Azure account, [create one](https://azure.microsoft.com/). 

You can use an existing subscription of any type:
- Free account with Azure credits [for students](https://azure.microsoft.com/free/students/) or [Visual Studio subscribers](https://azure.microsoft.com/pricing/member-offers/credit-for-visual-studio-subscribers/)
- [Pay-as-you-go](https://azure.microsoft.com/pricing/purchase-options/pay-as-you-go/) subscription with credit card
- Subscription obtained through an Enterprise Agreement (EA)
- Subscription obtained through the Cloud Solution Provider (CSP) program

### Azure Active Directory permissions

You'll need Azure Active Directory permissions to complete the registration process. If you don't already have them, ask your Azure AD administrator to grant consent or delegate the permissions to you. See [Manage Azure registration](../manage/manage-azure-registration.md#azure-active-directory-permissions) for more information.

## Register using PowerShell

Use the following procedure to register an Azure Stack HCI cluster with Azure using a management PC.

1. Install the required cmdlets on your management PC. 

   ```PowerShell
   Install-Module -Name Az.StackHCI
   ```

   > [!NOTE]
   > - You may see a prompt such as "Do you want PowerShellGet to install and import the NuGet provider now?" to which you should answer Yes (Y).
   > - You may further be prompted "Are you sure you want to install the modules from 'PSGallery'?" to which you should answer Yes (Y).

2. Perform the registration using the name of any server in the cluster. To get your Azure subscription ID, visit [portal.azure.com](https://portal.azure.com), navigate to Subscriptions, and copy/paste your ID from the list.

   ```PowerShell
   Register-AzStackHCI  -SubscriptionId "<subscription_ID>" -ComputerName Server1 [–Credential] [-ResourceName] [-ResourceGroupName]
   ```

   This syntax registers the cluster (of which Server1 is a member), as the current user, with the default Azure region and cloud environment, and using smart default names for the Azure resource and resource group, but you can add parameters to this command to specify these values if you want.

   Remember that the user running the `Register-AzStackHCI` cmdlet must have [Azure Active Directory permissions](../manage/manage-azure-registration.md#azure-active-directory-permissions), or the registration process will not complete; instead, it will exit and leave the registration pending admin consent. Once permissions have been granted, simply re-run `Register-AzStackHCI` to complete registration.

3. Authenticate with Azure

   To complete the registration process, you need to authenticate (sign in) using your Azure account. Your account needs to have access to the Azure subscription that was specified in step 4 above in order for registration to proceed. Copy the code provided, navigate to microsoft.com/devicelogin on another device (like your PC or phone), enter the code, and sign in there. This is the same experience Microsoft uses for other devices with limited input modalities, like Xbox.

The registration workflow will detect when you've logged in and proceed to completion. You should then be able to see your cluster in the Azure portal.

## Next steps

You are now ready to:

- [Validate the cluster](validate.md)
- [Create volumes](../manage/create-volumes.md)
