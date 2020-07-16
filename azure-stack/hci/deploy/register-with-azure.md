---
title: Connect Azure Stack HCI to Azure
description: How to register Azure Stack HCI with Azure.
author: khdownie
ms.author: v-kedow
ms.topic: how-to
ms.date: 07/21/2020
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

You'll need Azure Active Directory permissions to complete the registration process. If you don't already have them, ask your Azure AD administrator to grant permissions or delegate them to you. See [Manage Azure registration](../manage/manage-azure-registration.md) for more information.

## Register using PowerShell

Install the PowerShell Module for Azure Stack HCI by running the following PowerShell command on one or more servers in a cluster running the Azure Stack HCI operating system:

```PowerShell
Install-WindowsFeature RSAT-Azure-Stack-HCI -ComputerName Server1
```

Import and install the required cmdlets on your management PC or a cluster node:

```PowerShell
Install-Module Az.AzureStackHCI
Import-Module Az.AzureStackHCI
```

Register (this will prompt for Azure log-in):

```PowerShell
Register-AzureStackHCI -SubscriptionId "e569b8af-6ecc-47fd-a7d5-2ac7f23d8bfe" [-ResourceName] [-ResourceGroupName] [-ComputerName –Credential]
```

The minimum syntax requires only your Azure subscription ID. Remember that if the user running the above command must have Azure Active Directory permissions, or the registration process will not complete.

## Authenticate with Azure
Once dependencies have been installed and the parameters have been validated, you need to authenticate (sign in) using your Azure account. Your account needs to have access to the Azure subscription that was specified in order for registration to proceed.

If you ran Register-AzureStackHCI remotely from an operating system with Desktop experience, such as Windows 10, an interactive Azure login window will pop up. The exact prompts you see will vary depending on your security settings (e.g. two-factor authentication). Follow the prompts to log in.

If you ran Register-AzureStackHCI locally on the Azure Stack HCI operating system, which is unable to render an interactive Azure login window, you’ll be prompted to visit microsoft.com/devicelogin on another device (like your PC or phone), enter the code, and sign in there. This is the same experience Microsoft uses for other devices with limited input modalities, like Xbox.

The registration workflow will detect when you’ve logged in and proceed to completion. You should nthen be able to see your cluster in the Azure portal.

## Next steps

You are now ready to:

- Validate the cluster
- [Create volumes](create-volumes.md)
