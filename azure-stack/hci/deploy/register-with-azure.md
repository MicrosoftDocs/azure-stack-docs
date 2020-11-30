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

Azure Stack HCI is delivered as an Azure service and needs to register within 30 days of installation per the Azure Online Services Terms. This topic explains how to register your Azure Stack HCI cluster with [Azure Arc](https://azure.microsoft.com/services/azure-arc/) for monitoring, support, billing, and hybrid services. Upon registration, an Azure Resource Manager resource is created to represent each on-premises Azure Stack HCI cluster, effectively extending the Azure management plane to Azure Stack HCI. Information is periodically synced between the Azure resource and the on-premises cluster. 

## Prerequisites for registration

You won’t be able to register with Azure until you've created an Azure Stack HCI cluster. The nodes can be physical machines or virtual machines, but they must have Unified Extensible Firmware Interface (UEFI), meaning you can’t use Hyper-V Generation 1 virtual machines. Azure Arc registration is a native capability of Azure Stack HCI, so there is no agent required.

### Internet access

The Azure Stack HCI nodes need connectivity to the cloud in order to connect to Azure. For example, an outbound ping should succeed:

```PowerShell
C:\> ping bing.com
```

You'll also need to ensure that your corporate firewall does not block outbound connectivity to Azure. See Configure firewalls for more information.

### Azure subscription

If you don’t already have an Azure account, [create one](https://azure.microsoft.com/). 

You can use an existing subscription of any type:
- Free account with Azure credits [for students](https://azure.microsoft.com/free/students/) or [Visual Studio subscribers](https://azure.microsoft.com/pricing/member-offers/credit-for-visual-studio-subscribers/)
- [Pay-as-you-go](https://azure.microsoft.com/pricing/purchase-options/pay-as-you-go/) subscription with credit card
- Subscription obtained through an Enterprise Agreement (EA)
- Subscription obtained through the Cloud Solution Provider (CSP) program

### Azure Active Directory permissions

You'll need Azure Active Directory permissions to complete the registration process. If you don't already have them, ask your Azure AD administrator to grant permissions or delegate them to you. See [Manage Azure registration](../manage/manage-azure-registration.md#azure-active-directory-permissions) for more information.

## Register using PowerShell

Use the following procedure to register an Azure Stack HCI cluster with Azure:

1. Connect to one of the cluster nodes by opening a PowerShell session and entering the following command:

   ```PowerShell
   Enter-PSSession <server-name>
   ```

2. Install the PowerShell Module for Azure Stack HCI:

   ```PowerShell
   Install-WindowsFeature RSAT-Azure-Stack-HCI
   ```

3. Install the required cmdlets. If you're deploying Azure Stack HCI from the Public Preview image, you'll need to use version 0.3.1 of the Az.StackHCI PowerShell module:

   ```PowerShell
   Install-Module -Name Az.StackHCI -RequiredVersion 0.3.1
   ```

   If you've already installed the [November 23, 2020 Preview Update (KB4586852)](../release-notes.md) on every server in your cluster and are just now registering your cluster with Azure, then you can safely use the latest version of Az.StackHCI:

   ```PowerShell
   Install-Module -Name Az.StackHCI
   ```

   > [!NOTE]
   > 1.	You may see a prompt such as "Do you want PowerShellGet to install and import the NuGet provider now?" to which you should answer Yes (Y).
   > 2.	You may further be prompted "Are you sure you want to install the modules from 'PSGallery'?" to which you should answer Yes (Y).
   > 3.	Finally, you may assume that installing the entire **Az** module would include the **StackHCI** sub-module but that is not the case. Sub-modules in Preview aren't included automatically according to the standard Azure PowerShell convention so you need to explicitly request for **Az.StackHCI** as shown above.

4. Perform the actual registration:

   ```PowerShell
   Register-AzStackHCI  -SubscriptionId "<subscription_ID>" [-ResourceName] [-ResourceGroupName]
   ```

   This syntax registers the local cluster (of which the local server is a member), as the current user, with the default Azure region and cloud environment, and using smart default names for the Azure resource and resource group, but you can add parameters to this command to specify these values if you want.

   Remember that the user running the `Register-AzStackHCI` cmdlet must have [Azure Active Directory permissions](../manage/manage-azure-registration.md#azure-active-directory-permissions), or the registration process will not complete; instead, it will exit and leave the registration pending admin consent. Once permissions have been granted, simply re-run `Register-AzStackHCI` to complete registration.

5. Authenticate with Azure

   To complete the registration process, you need to authenticate (sign in) using your Azure account. Your account needs to have access to the Azure subscription that was specified in step 4 above in order for registration to proceed. Copy the code provided, navigate to microsoft.com/devicelogin on another device (like your PC or phone), enter the code, and sign in there. This is the same experience Microsoft uses for other devices with limited input modalities, like Xbox.

The registration workflow will detect when you've logged in and proceed to completion. You should then be able to see your cluster in the Azure portal.

## Next steps

You are now ready to:

- [Validate the cluster](validate.md)
- [Create volumes](../manage/create-volumes.md)
