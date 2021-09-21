---
title: Update Marketplace items in Azure Stack Hub
description: Learn how to update Marketplace items in Azure Stack Hub. 
author: sethmanheim
ms.topic: article
ms.date: 9/21/2021
ms.author: sethm
ms.reviewer: thoroet
ms.lastreviewed: 9/21/2021

# Intent: As an Azure Stack Hub operator, I want to update an item in Azure Stack Hub Marketplace.
# Keyword: update marketplace items azure stack hub

---

# Update Marketplace items in Azure Stack Hub

As a cloud operator one of your responsibilities is to update the Azure Stack Hub marketplace. When a new version of a marketplace item is available in Azure you can download the newer version to take advantage of new features, security fixes and stability improvements.

There are four types of marketplace items:

-   Virtual Machine Images
-   Extensions
-   Solution Templates
-   Resource Providers

New Virtual Machine images, extension and solution templates will be leveraged automatically when users deploy new resources. Resource Providers use the Azure Stack Hub update experience and are not covered by this document.

You can find more information about recent additions, updates, changes, and removals changes at [Azure Stack Hub Marketplace changes](azure-stack-marketplace-changes.md)

Updating extension within already deployed virtual machines require some additional steps.

## Retrieve the new version

The process to download a new version of a marketplace item is the same as the initial download of a marketplace item.

1.  First check the version of an already downloaded marketplace item in the Azure Stack Hub marketplace using the administrator portal.

    ![Check the version in the Azure Stack Hub marketplace.](media/marketplace-update-items/check-marketplace-in-azure-stack-hub.png)

2.  Follow the [instructions](https://docs.microsoft.com/azure-stack/operator/azure-stack-download-azure-marketplace-item) for connected or disconnected systems to download the new marketplace item. Only download marketplace items that have a new version.

## Update already deployed extensions

After the operator has downloaded a new version of an extension the user must take one of the following two actions to ensure the new version is getting applied.

1.  Restart the virtual machine. The extension gets updated automatically when starting the virtual machine. This can be done via the user portal or PowerShell.
2.  Use PowerShell to update the extension without a restart. This is helpful when scheduling a downtime for a virtual machine is not possible and an emergency update is required.

As a **user** you can use the following steps to query virtual machines and list the used extensions and update the installed extension to the new version without restarting the VM.

Running the below PowerShell will list all virtual machines and the installed extensions. Before running the cmdlets below make sure you installed [PowerShell for Azure Stack Hub]powershell-install-az-module.md).

```powershell  
$VMs=Get-AzVM 

Foreach ($VM in $VMs) 

{ 

Get-AzVMExtension -ResourceGroup $VM.ResourceGroupName -VMName $VM.name | ft VMName, Name,TypeHandlerVersion,Publisher, ExtensionType,Location 

} 
```

If you want to list VMs that are running a specific extension you can use the following command.

```powershell  
$extensionname="SampleExtensionName" 

$VMs=Get-AzVM 

Foreach ($VM in $VMs) { 

$VMExtensions=Get-AzVMExtension -ResourceGroup $VM.ResourceGroupName -VMName $VM.name 

$extensions=$VMExtensions.name 

Foreach ($Extension in $Extensions) {if ($Extension -eq $extensionname) 

{write-host $VM.Name} 

} 

} 
```

Running the below PowerShell will update the extension to the latest version.

```powershell  
Set-AzVMExtension -ResourceGroupName "SampleRG" -VMName "SampleVM" -Name "ExtensionName" -Publisher "PublisherName" -typeHandlerVersion "NewExtensionVersion" -ExtensionType SampleType -Location local 
```

Note: It can take several minutes for the extension to be updated. You can safely run the first command to check the version if it got updated.

## List of recently updated extension

| Name                                 | Publisher                            | TypeHandlerVersion | ExtensionType    |
|--------------------------------------|--------------------------------------|--------------------|------------------|
| Microsoft.EnterpriseCloud.Monitoring | Microsoft.EnterpriseCloud.Monitoring | 1.14               | OmsAgentForLinux |
| microsoft.linuxdiagnostic-3.1.135    | Microsoft.Azure.Diagnostics          | 4.0                | LinuxDiagnostic  |

> [NOTE]  
> If you have installed any version of the following two extensions:

-   Azure Update and Configuration Management
-   Azure Update and Configuration Management for Linux

Ensure you replace them with the **Azure Monitor, Update and Configuration Management for Linux** extension minimum version 1.14.01.

## Next steps

For more information about the Azure Stack Hub Marketplace, see [Azure Stack Hub Marketplace overview](azure-stack-marketplace.md)


