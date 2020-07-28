---
title: Connect Azure Stack HCI to Azure
description: How to register Azure Stack HCI with Azure.
author: khdownie
ms.author: v-kedow
ms.topic: how-to
ms.date: 07/27/2020
---

# Connect Azure Stack HCI to Azure

> Applies to Azure Stack HCI v20H2; Windows Server 2019

Azure Stack HCI is delivered as an Azure service and needs to register within 30 days of installation per the Azure Online Services Terms. This topic explains how to register your Azure Stack HCI cluster with [Azure Arc](https://azure.microsoft.com/services/azure-arc/) for monitoring, support, billing, and hybrid services. Upon registration, an Azure Resource Manager resource is created to represent each on-premises Azure Stack HCI cluster, effectively extending the Azure management plane to Azure Stack HCI. Information is periodically synced between the Azure resource and the on-premises cluster. 

## Prerequisites for registration

You won’t be able to register with Azure until you've created an Azure Stack HCI cluster. The nodes can be physical machines or virtual machines, but they must have Unified Extensible Firmware Interface (UEFI), meaning you can’t use Hyper-V Generation 1 virtual machines. Azure Arc registration is a native capability of Azure Stack HCI, so there is no agent required.

### Internet access

The Azure Stack HCI nodes need connectivity to the cloud in order to connect to Azure. For example, an outbound ping should succeed:

```PowerShell
C:\> ping bing.com
```

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

Install the PowerShell Module for Azure Stack HCI by running the following PowerShell command on one or more servers in a cluster running the Azure Stack HCI operating system:

```PowerShell
Install-WindowsFeature RSAT-Azure-Stack-HCI -ComputerName Server1
```

Install the required cmdlets on a cluster node or management PC:

```PowerShell
Install-Module Az.StackHCI
```
   > [!NOTE]
   > 1.	You may see a prompt such as "Do you want PowerShellGet to install and import the NuGet provider now?" to which you should answer Yes (Y).
   > 2.	You may further be prompted "Are you sure you want to install the modules from 'PSGallery'?" to which you should answer Yes (Y).
   > 3.	Finally, you might assume that installing the entire **Az** module would include the **StackHCI** sub-module, and that will be correct long-term. However, per standard Azure PowerShell convention, sub-modules in Preview aren't included automatically; rather, you need to explicitly specify them. Thus, for now, you need to explicitly ask for **Az.StackHCI** as shown above.

For the simplest experience, run the following command on an Azure Stack HCI clustered node (this will prompt for Azure log-in):

```PowerShell
Register-AzStackHCI  -SubscriptionId "e569b8af-6ecc-47fd-a7d5-2ac7f23d8bfe" [-ResourceName] [-ResourceGroupName]
```

The minimum syntax requires only your Azure subscription ID. This syntax registers the local cluster (of which the local server is a member), as the current user, with the default Azure region and cloud environment, and using smart default names for the Azure resource and resource group. 

If you'd prefer to register the cluster using a management PC, supply the **-ComputerName** parameter with the name of a server in the cluster and your credentials, if needed:

```PowerShell
Register-AzStackHCI  -SubscriptionId "e569b8af-6ecc-47fd-a7d5-2ac7f23d8bfe" -ComputerName Server1 [–Credential] [-ResourceName] [-ResourceGroupName]
```

By default, the Azure resource created to represent the Azure Stack HCI cluster inherits the cluster name and is placed in a new resource group with the same name plus the suffix "-rg". You can specify a different resource name or place the resource into an existing resource group with the optional parameters listed above.

Remember that the user running the `Register-AzStackHCI` cmdlet must have [Azure Active Directory permissions](../manage/manage-azure-registration.md#azure-active-directory-permissions), or the registration process will not complete; instead, it will exit and leave the registration pending admin consent. Once permissions have been granted, simply re-run `Register-AzStackHCI` to complete registration.

   > [!NOTE]
   > If upon registering, you receive an error similar to the message below, **please try registering again in 24-48 hours**. The Azure integration is still in the process of being rolled out across regions. You can still proceed with your evaluation, and it won't affect any functionality. Just make sure you come back and register later!
   >
   > `Register-AzStackHCI : Azure Stack HCI is not yet available in region <regionName>`
   >
   > To check if Azure Stack HCI is available in your Azure region, [use this tool](https://azure.microsoft.com/global-infrastructure/services/) and search for "hci."

## Authenticate with Azure
Once dependencies have been installed and the parameters have been validated, you need to authenticate (sign in) using your Azure account. Your account needs to have access to the Azure subscription that was specified in order for registration to proceed.

If you ran `Register-AzStackHCI` locally on the Azure Stack HCI operating system, which is unable to render an interactive Azure login window, you’ll be prompted to visit microsoft.com/devicelogin on another device (like your PC or phone), enter the code, and sign in there. This is the same experience Microsoft uses for other devices with limited input modalities, like Xbox.

If you ran `Register-AzStackHCI` remotely from a management PC with Desktop experience, such as Windows 10, an interactive Azure login window will pop up. The exact prompts you see will vary depending on your security settings (e.g. two-factor authentication). Follow the prompts to log in.

The registration workflow will detect when you've logged in and proceed to completion. You should then be able to see your cluster in the Azure portal.

## Next steps

You are now ready to:

- [Validate the cluster](validate.md)
- [Create volumes](../manage/create-volumes.md)
