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

Azure Stack HCI is delivered as an Azure service and needs to register within 30 days of installation per the Azure Online Services Terms. This topic explains how to register your Azure Stack HCI cluster with with [Azure Arc](https://azure.microsoft.com/services/azure-arc/) for monitoring, support, billing, and hybrid services. Upon registration, an Azure Resource Manager (ARM) resource is created to represent each on-premises Azure Stack HCI cluster, effectively extending the Azure management plane to Azure Stack HCI. Azure Arc registration is a native capability of Azure Stack HCI, with no agent required.

## Prerequisites for registration

You won’t be able to register with Azure until you've created an Azure Stack HCI cluster. The nodes can be physical machines or virtual machines, but they must have Unified Extensible Firmware Interface (UEFI), meaning you can’t use Hyper-V Generation 1 virtual machines.

### Internet access

The Azure Stack HCI nodes need outbound connectivity to the cloud. For example, a ping should succeed:

```PowerShell
C:\> ping bing.com
```

### Azure subscription

If you don’t already have an Azure account, [create one](https://azure.microsoft.com/). 

You can use an existing subscription of any type:
- Free account with Azure credits for students or Visual Studio subscribers
- Pay-as-you-go subscription with credit card
- Subscription obtained through an Enterprise Agreement (EA)
- Subscription obtained through the Cloud Solution Provider (CSP) program

### Azure Active Directory permissions

You'll need Azure Active Directory permissions to complete the registration process. If you don't already have them, ask your Azure AD administrator to grant permissions or delegate them to you.

## Register using PowerShell

Install the PowerShell Module for Azure Stack HCI by running the following PowerShell command on one or more servers in a cluster running the Azure Stack HCI operating system:

```PowerShell
Install-WindowsFeature RSAT-Azure-Stack-HCI -ComputerName Server1
```

Install the required cmdlets on your management PC or a cluster node:

```PowerShell
Import-Module Az.AzureStackHCI
```

Register (this will prompt for Azure log-in):

```PowerShell
Register-AzureStackHCI -SubscriptionId "e569b8af-6ecc-47fd-a7d5-2ac7f23d8bfe" [-ResourceName] [-ResourceGroupName] [-ComputerName –Credential]
```

Remember that if the user running the above command does not have Azure Active Directory permissions, the registration process will not complete.

You should now be able to see your cluster in the Azure portal.

## Next steps

You are now ready to:

- Create VMs and deploy workloads
- Validate and load-test the cluster
