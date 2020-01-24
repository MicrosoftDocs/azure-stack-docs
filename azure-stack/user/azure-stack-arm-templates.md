---
title: Use Azure Resource Manager templates in Azure Stack Hub | Microsoft Docs
description: Learn how to use Azure Resource Manager templates in Azure Stack Hub to provision resources.
author: mattbriggs

ms.service: azure-stack

ms.topic: article
ms.date: 1/22/2020
ms.author: mabrigg
ms.reviewer: justini
ms.lastreviewed: 11/14/2018

---
# Use Azure Resource Manager templates in Azure Stack Hub

You can use Azure Resource Manager templates to deploy and provision all the resources for your application in a single, coordinated operation. You can also redeploy templates to make changes to the resources in a resource group.

These templates can be deployed with the Microsoft Azure Stack Hub portal, PowerShell, the command line, and Visual Studio.

The following quickstart templates are [available on GitHub](https://aka.ms/azurestackgithub):

## Deploy SharePoint Server (non-high-availability deployment)

Use the PowerShell [Desired State Configuration](/powershell/scripting/dsc/overview/overview) (DSC) extension to [create a SharePoint Server 2013 farm](https://github.com/Azure/AzureStack-QuickStart-Templates/tree/master/sharepoint-2013-non-ha) that includes the following resources:

* A virtual network
* Three storage accounts
* Two external load balancers
* One virtual machine (VM) configured as a domain controller for a new forest with a single domain
* One VM configured as a SQL Server 2014 stand-alone server
* One VM configured as a one-machine SharePoint Server 2013 farm

## Deploy AD (non-high-availability-deployment)

Use the PowerShell DSC extension to [create an AD domain controller server](https://github.com/Azure/AzureStack-QuickStart-Templates/tree/master/ad-non-ha) that includes the following resources:

* A virtual network
* One storage account
* One external load balancer
* One virtual machine (VM) configured as a domain controller for a new forest with a single domain

## Deploy AD/SQL (non-high-availability-deployment)

Use the PowerShell DSC extension to [create a SQL Server 2014 stand-alone server](https://github.com/Azure/AzureStack-QuickStart-Templates/tree/master/sql-2014-non-ha) that includes the following resources:

* A virtual network
* Two storage accounts
* One external load balancer
* One virtual machine (VM) configured as a domain controller for a new forest with a single domain
* One VM configured as a SQL Server 2014 stand-alone server

## VM-DSC-Extension-Azure-Automation-Pull-Server

Use the PowerShell DSC extension to configure an existing virtual machine Local Configuration Manager (LCM) and register it to an Azure Automation Account DSC Pull Server.

## Create a virtual machine from a user image

[Create a virtual machine from a custom user image](https://github.com/Azure/AzureStack-QuickStart-Templates/tree/master/101-vm-create-from-customimage). This template also deploys a virtual network (with DNS), public IP address, and a network interface.

## Basic virtual machine

[Deploy a Windows VM](https://aka.ms/aa6zdzx) that includes a virtual network (with DNS), public IP address, and a network interface.

## Cancel a running template deployment

To cancel a running template deployment, use the [Stop-AzureRmResourceGroupDeployment](/powershell/module/azurerm.resources/stop-azurermresourcegroupdeployment) PowerShell [cmdlet](/powershell/scripting/developer/cmdlet/cmdlet-overview).

## Next steps

* [Deploy templates with the portal](azure-stack-deploy-template-portal.md)
* [Deploy templates with PowerShell](azure-stack-deploy-template-powershell.md)
* [Deploy templates with Visual Studio](azure-stack-deploy-template-visual-studio.md)
* [Azure Resource Manager overview](/azure/azure-resource-manager/resource-group-overview)
