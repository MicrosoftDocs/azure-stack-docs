---
title: Introduction to Azure Stack Hub VMs 
description: Learn about Azure Stack Hub VMs.
author: sethmanheim

ms.topic: conceptual
ms.date: 02/03/2020
ms.author: sethm
ms.reviewer: kivenkat
ms.lastreviewed: 01/05/2019

---
# Introduction to Azure Stack Hub VMs

Azure Stack Hub offers virtual machines (VMs) as a type of on-demand and scalable computing resource. You can choose a VM when you need more control over the computing environment. This article provides details before you create your first VM.

An Azure Stack Hub VM gives you the flexibility of virtualization without the need to manage clusters or individual machines. However, you still need to maintain the VM by doing tasks such as configuring, patching/updating, and installing the software that runs on it.

You can use Azure Stack Hub VMs in several ways. For example:

- **Development and test**: Azure Stack Hub VMs enable you to create a computer with a specific configuration required to code and test an application.

- **Applications in the cloud**: Because demand for your application can fluctuate, it might make economic sense to run it on a VM in Azure Stack Hub. You pay for extra VMs when you need them and shut them down when you don't.

- **Extended datacenter**: VMs in an Azure Stack Hub virtual network can be connected to your organization's network, or to Azure.

The VMs that your application uses can scale up, or scale out, to whatever is required to meet your needs.

## Before creating a VM

There are always design considerations when you build out an application infrastructure in Azure Stack Hub. These aspects of a VM are important to think about before you start creating your infrastructure:

- The names of your application resources.
- The size of the VM.
- The maximum number of VMs that can be created.
- The operating system that the VM runs.
- The configuration of the VM after it starts.
- The related resources that the VM needs.

### Naming

A VM has a name assigned to it and it has a computer name configured as part of the operating system. The name of a VM can be up to 15 characters.

If you use Azure Stack Hub to create the operating system disk, the computer name and the VM name are the same. If you upload and use your own image that contains a previously configured operating system and use it to create a VM, the names may be different. When you upload your own image file, as a best practice, make sure the computer name in the operating system matches the VM name.

### VM size

The size of the VM that you use is determined by the workload that you want to run. The size that you choose then determines factors such as processing power, memory, and storage capacity. Azure Stack Hub offers different kinds of sizes to support many types of uses.

### VM limits

Your subscription has default quota limits in place that can impact the deployment of VMs for your project. The current limit on a per subscription basis is 20 VMs per region.

### Operating system disks and images

VMs in Azure Stack Hub are limited to the generation one virtual hard disk (VHD/VHDX) format. VHDs can be used to store the machine operating system (OS) and data. VHDs are also used for the images you choose from to install an OS. Azure Stack Hub provides a marketplace to use with various versions and types of operating systems. Marketplace images are identified by image publisher, offer, SKU, and version (typically the latest version is specified as **latest**).

The following table shows how to find the information for an image:

|Method|Description|
|---------|---------|
|Azure Stack Hub portal|The values are automatically specified for you when you select an image to use.|
|Azure Stack Hub PowerShell|`Get-AzureRMVMImagePublisher -Location "location"`<br>`Get-AzureRMVMImageOffer -Location "location" -Publisher "publisherName"`<br>`Get-AzureRMVMImageSku -Location "location" -Publisher "publisherName" -Offer "offerName"`|
|REST APIs     |[List image publishers](/rest/api/compute/platformimages/platformimages-list-publishers)<br>[List image offers](/rest/api/compute/platformimages/platformimages-list-publisher-offers)<br>[List image SKUs](/rest/api/compute/platformimages/platformimages-list-publisher-offer-skus)|

You can choose to upload and use your own image. If you do, the publisher name, offer, and SKU aren't used.

### Extensions

VM extensions give your VM additional capabilities through post deployment configuration and automated tasks.
These common tasks can be accomplished using extensions:

- **Run custom scripts**: The Custom Script extension helps you to configure workloads on the VM by running your script when the VM is provisioned.

- **Deploy and manage configurations**: The PowerShell Desired State Configuration (DSC) extension helps you set up DSC on a VM to manage configurations and environments.

- **Collect diagnostics data**: The Azure Diagnostics extension helps you configure the VM to collect diagnostics data that can be used to monitor the health of your application.

### Related resources

The resources in the following table are used by the VM and need to exist or be created when the VM is created:

|Resource|Required|Description|
|---------|---------|---------|
|Resource group|Yes|The VM must be contained in a resource group.|
|Storage account|No|The VM doesn't need the storage account to store its virtual hard disks if using managed disks. <br>The VM does need the storage account to store its virtual hard disks if using unmanaged disks.|
|Virtual network|Yes|The VM must be a member of a virtual network.|
|Public IP address|No|The VM can have a public IP address assigned to it to remotely access it.|
|Network interface|Yes|The VM needs the network interface to communicate in the network.|
|Data disks|No|The VM can include data disks to expand storage capabilities.|

## Create your first VM

You have several choices to create a VM. Your choice depends on your environment. The following table provides information to help get you started creating your VM:

|Method|Article|
|---------|---------|
|Azure Stack Hub portal|Create a Windows VM with the Azure Stack Hub portal<br>[Create a Linux VM using the Azure Stack Hub portal](azure-stack-quick-linux-portal.md)|
|Templates|Azure Stack Hub Quickstart templates are located at:<br> [https://github.com/Azure/AzureStack-QuickStart-Templates](https://aka.ms/aa6z60s)|
|PowerShell|[Create a Windows VM by using PowerShell in Azure Stack Hub](azure-stack-quick-create-vm-windows-powershell.md)<br>[Create a Linux VM by using PowerShell in Azure Stack Hub](azure-stack-quick-create-vm-linux-powershell.md)|
|CLI|[Create a Windows VM by using CLI in Azure Stack Hub](azure-stack-quick-create-vm-windows-cli.md)<br>[Create a Linux VM by using CLI in Azure Stack Hub](azure-stack-quick-create-vm-linux-cli.md)|

## Manage your VM

You can manage VMs using a browser-based portal, command-line tools with support for scripting, or directly through APIs. Some typical management tasks that you might do are:

- Getting information about a VM
- Connecting to a VM
- Managing availability
- Making backups

### Get information about your VM

The following table shows you some of the ways you can get information about a VM.

|Method|Description|
|---------|---------|
|Azure Stack Hub portal|On the hub menu, click **Virtual Machines** and then select the VM from the list. On the page for the VM, you have access to overview information, setting values, and monitoring metrics.|
|Azure PowerShell|Managing VMs is similar in Azure and Azure Stack Hub. For more information about using PowerShell, see the following Azure topic:<br>[Create and Manage Windows VMs with the Azure PowerShell module](/azure/virtual-machines/windows/tutorial-manage-vm#understand-vm-sizes)|
|Client SDKs|Using C# to manage VMs is similar in Azure and Azure Stack Hub. For more information, see the following Azure topic:<br>[Create and manage Windows VMs in Azure using C#](/azure/virtual-machines/windows/csharp)|

### Connect to your VM

You can use the **Connect** button in the Azure Stack Hub portal to connect to your VM.

## Next steps

- [Considerations for VMs in Azure Stack Hub](azure-stack-vm-considerations.md)
