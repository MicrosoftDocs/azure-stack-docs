---
title: Azure Stack VM features | Microsoft Docs
description: Learn about different features and considerations when working with VMs in an Azure Stack Hub ruggedized.
services: azure-stack
author: sethmanheim
manager: lizross
ms.service: azure-stack
ms.topic: how-to
ms.date: 03/06/2025
ms.author: sethm
ms.lastreviewed: 10/14/2020

---

# Azure Stack VM features

Azure Stack virtual machines (VMs) provide on-demand, scalable computing resources. Before you deploy VMs, you should learn the differences between the VM features available in Azure Stack and Microsoft Azure. This article describes these differences and identifies key considerations for planning VM deployments. To learn about high-level differences between Azure Stack and Azure, see the [Key considerations](../user/azure-stack-considerations.md) article.

## VM differences

| Feature | Azure (global) | Azure Stack |
| --- | --- | --- |
| Virtual machine images | The Azure Marketplace has images that you can use to create a VM. See the [Azure Marketplace](https://azuremarketplace.microsoft.com/marketplace/apps/category/compute?subcategories=virtual-machine-images&page=1) page to view the list of images that are available in the Azure Marketplace. | By default, there aren't any images available in the Azure Stack marketplace. The Azure Stack cloud admin must publish or download images to the Azure Stack marketplace before users can use them. |
| Virtual machine sizes | Azure supports a wide variety of sizes for VMs. To learn about the available sizes and options, refer to the [Windows VMs sizes](/azure/virtual-machines/sizes) and [Linux VM sizes](/azure/virtual-machines/linux/sizes) topics. | Azure Stack supports a subset of VM sizes that are available in Azure. To view the list of supported sizes, refer to the [VM sizes](#vm-sizes) section of this article. |
| Virtual machine quotas | [Quota limits](/azure/azure-subscription-service-limits#service-specific-limits) are set by Microsoft. | The Azure Stack cloud admin must assign quotas before they offer VM to their users. |
| Virtual machine extensions |Azure supports a wide variety of VM extensions. To learn about the available extensions, refer to the [VM extensions and features](/azure/virtual-machines/windows/extensions-features) article.| Azure Stack supports a subset of extensions that are available in Azure and each of the extensions have specific versions. The Azure Stack cloud admin can choose which extensions to be made available to for their users. To view the list of supported extensions, refer to the [VM extensions](#vm-extensions) section of this article. |
| Virtual machine storage | Supports [managed disks.](/azure/virtual-machines/windows/managed-disks-overview) | Managed disks are supported in Azure Stack with version 1808 and later. |
| Virtual machine disk performance | Depends on disk type and size. | Depends on VM size of the VM, which the disks are attached to. For more info, refer to the [VM sizes supported in Azure Stack](azure-stack-vm-sizes.md) article.
| API versions | Azure always has the latest API versions for all the VM features. | Azure Stack supports specific Azure services and specific API versions for these services. To view the list of supported API versions, refer to the [API versions](#api-versions) section of this article. |
| Azure Instance Metadata Service | The Azure Instance Metadata Service provides info about running VM instances that can be used to manage and set up your VM.  | The Azure Instance Metadata Service isn't supported on Azure Stack. |
| Virtual machine availability sets|Multiple fault domains (2 or 3 per region).<br>Multiple update domains.|Multiple fault domains (2 or 3 per region).<br>Single update domain, with live migration to protect workloads during update. 20 update domains supported for template compatibility.<br>VM and availability set should be in the same location and resource group.|
| Virtual machine scale sets|Autoscale is supported.|Autoscale isn't supported.<br><br>Add more instances to a scale set using the portal, Resource Manager templates, or PowerShell. |
| Cloud Witness | Select the endpoints from the storage account properties available in Azure Stack. | [Cloud Witness](/windows-server/failover-clustering/deploy-cloud-witness) is a type of Failover Cluster quorum witness that uses Microsoft Azure to provide a vote on cluster quorum.<br>The endpoints in global Azure compared to Azure Stack may look like:<br>For global Azure:<br>`https://mywitness.blob.core.windows.net/`<br>For Azure Stack:<br>`https://mywitness.blob.<region>.<FQDN>/`|
| Virtual machine diagnostics | Linux VM diagnostics are supported. | Linux VM diagnostics aren't supported in Azure Stack. When you deploy a Linux VM with VM diagnostics enabled, the deployment fails. The deployment also fails if you enable the Linux VM basic metrics through diagnostic settings. |

## VM sizes

Azure Stack imposes resource limits to avoid over consumption of resources (server local and service-level.) These limits improve the tenant experience by reducing the affect resource consumption by other tenants.

- For networking egress from the VM, there are bandwidth caps in place. Caps in Azure Stack are the same as the caps in Azure.
- For storage resources, Azure Stack implements storage IOPS (Input/Output Operations Per Second) limits to avoid basic overconsumption of resources by tenants for storage use.
- For VM disks, disk IOPS on Azure Stack is a function of VM size instead of the disk type. This means that for a Standard_Fs series VM, regardless of whether you choose SSD or HDD for the disk type, the IOPS limit for an second data disk is 2300 IOPS.

The following table lists the VMs that are supported on Azure Stack along with their configuration:

| Type            | Size          | Range of supported sizes |
| ----------------| ------------- | ------------------------ |
|General purpose  |Basic A        |[A0 - A4](azure-stack-vm-sizes.md#basic-a)                   |
|General purpose  |Standard A     |[A0 - A7](azure-stack-vm-sizes.md#standard-a)              |
|General purpose  |Av2-series     |[A1_v2 - A8m_v2](azure-stack-vm-sizes.md#av2-series)     |
|General purpose  |D-series       |[D1 - D4](azure-stack-vm-sizes.md#d-series)              |
|General purpose  |Dv2-series     |[D1_v2 - D5_v2](azure-stack-vm-sizes.md#ds-series)        |
|General purpose  |DS-series      |[DS1 - DS4](azure-stack-vm-sizes.md#dv2-series)            |
|General purpose  |DSv2-series    |[DS1_v2 - DS5_v2](azure-stack-vm-sizes.md#dsv2-series)      |
|Memory optimized |D-series       |[D11 - D14](azure-stack-vm-sizes.md#mo-d)            |
|Memory optimized |DS-series      |[DS11 - DS14](azure-stack-vm-sizes.md#mo-ds)|
|Memory optimized |Dv2-series     |[D11_v2 - DS14_v2](azure-stack-vm-sizes.md#mo-dv2)     |
|Memory optimized |DSv2-series    |[DS11_v2 - DS14_v2](azure-stack-vm-sizes.md#mo-dsv2)    |
|Compute optimized|F-series       |[F1 - F16](azure-stack-vm-sizes.md#f-series)    |
|Compute optimized|Fs-series      |[F1s - F16s](azure-stack-vm-sizes.md#fs-series)    |
|Compute optimized|Fsv2-series    |[F2s_v2 - F64s_v2](azure-stack-vm-sizes.md#fsv2-series)    |

VM sizes and their associated resource quantities are consistent between Azure Stack and Azure. This consistency includes the amount of memory, the number of cores, and the number/size of data disks that can be created. However, performance of VMs with the same size depends on the underlying characteristics of a particular Azure Stack environment.

## VM extensions

Azure Stack includes a small set of extensions. Updates and additional extensions are available through Marketplace syndication.

Use the following PowerShell script to get the list of VM extensions that are available in your Azure Stack environment:

If provisioning an extension on a VM deployment takes too long, let the provisioning time out instead of trying to stop the process to deallocate or delete the VM.

### [Az modules](#tab/az1)

```powershell
Get-AzVmImagePublisher -Location local | `
  Get-AzVMExtensionImageType | `
  Get-AzVMExtensionImage | `
  Select Type, Version | `
  Format-Table -Property * -AutoSize
```

### [AzureRM modules](#tab/azurerm1)

```powershell
Get-AzureRmVmImagePublisher -Location local | `
  Get-AzureRmVMExtensionImageType | `
  Get-AzureRmVMExtensionImage | `
  Select Type, Version | `
  Format-Table -Property * -AutoSize
```

---

## API versions

VM features in Azure Stack support the following API versions:

"2017-12-01",
"2017-03-30",
"2016-03-30",
"2015-06-15"

You can use the following PowerShell script to get the API versions for the VM features that are available in your Azure Stack environment:

### [Az modules](#tab/az2)

```powershell
Get-AzResourceProvider | `
  Select ProviderNamespace -Expand ResourceTypes | `
  Select * -Expand ApiVersions | `
  Select ProviderNamespace, ResourceTypeName, @{Name="ApiVersion"; Expression={$_}} | `
  where-Object {$_.ProviderNamespace -like "Microsoft.compute"}
```
### [AzureRM modules](#tab/azurerm2)

```powershell
Get-AzureRmResourceProvider | `
  Select ProviderNamespace -Expand ResourceTypes | `
  Select * -Expand ApiVersions | `
  Select ProviderNamespace, ResourceTypeName, @{Name="ApiVersion"; Expression={$_}} | `
  where-Object {$_.ProviderNamespace -like "Microsoft.compute"}
```

---

The list of supported resource types and API versions may vary if the cloud operator updates your Azure Stack environment to a newer version.

## Windows activation

Windows products must be used in accordance with Product Use Rights and Microsoft license terms. Azure Stack uses [Automatic VM Activation](/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/dn303421(v%3dws.11)) (AVMA) to activate Windows Server VMs.

- Azure Stack host activates Windows with AVMA keys for Windows Server 2016. All VMs that run Windows Server 2012 R2 or later are automatically activated.
- VMs that run Windows Server 2012 or earlier aren't automatically activated and must be activated by using [MAK activation](/previous-versions/tn-archive/ff793438(v=technet.10)). To use MAK activation, you must provide your own product key.

Microsoft Azure uses KMS activation to activate Windows VMs. If you move a VM from Azure Stack to Azure and encounter activation problems, see [Troubleshoot Azure Windows VM activation problems](/azure/virtual-machines/windows/troubleshoot-activation-problems). Additional info can be found at the [Troubleshooting Windows activation failures on Azure VMs](/archive/blogs/mast/troubleshooting-windows-activation-failures-on-azure-vms) Azure Support Team Blog post.

## Next steps

[Create a Windows VM with PowerShell in Azure Stack](../user/azure-stack-quick-create-vm-windows-powershell.md)
