---
title: Azure Stack Hub VM features 
description: Learn about different features and considerations when working with VMs in Azure Stack Hub.
author: sethmanheim

ms.topic: article
ms.custom:
ms.date: 02/02/2022
ms.author: sethm
ms.reviewer: thoroet
ms.lastreviewed: 07/15/2021

# Intent: As an Azure Stack user, I want to know what I need to do to move them to Azure Stack or work with them in Azure Stack.
# Keyword: Azure Stack VM
---


# Azure Stack Hub VM features

Azure Stack Hub virtual machines (VMs) provide on-demand, scalable computing resources. Before you deploy VMs, you should learn the differences between the VM features available in Azure Stack Hub and Microsoft Azure. This article describes these differences and identifies key considerations for planning VM deployments. To learn about high-level differences between Azure Stack Hub and Azure, see the [Key considerations](azure-stack-considerations.md) article.

## VM differences

| Feature | Azure (global) | Azure Stack Hub |
| --- | --- | --- |
| Virtual machine images | The Azure Marketplace has images that you can use to create a VM. See the [Azure Marketplace](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/category/compute?subcategories=virtual-machine-images&page=1) page to view the list of images that are available in the Azure Marketplace. | By default, there aren't any images available in the Azure Stack Hub Marketplace. The Azure Stack Hub cloud admin must publish or download images to the Azure Stack Hub Marketplace before users can use them. |
| VHD generation | Generation two VMs support key features that aren't supported in generation one VMs. These features include increased memory, Intel Software Guard Extensions (Intel SGX), and virtualized persistent memory (vPMEM). Generation two VMs running on-premises, have some features that aren't supported in Azure yet. For more information, see [Support for generation 2 VMs on Azure](/azure/virtual-machines/windows/generation-2)  | Azure Stack Hub supports only generation one VMs. You can convert a generation one VM from VHDX to the VHD file format and from dynamically expanding to a fixed-size disk. You can't change a VM's generation. For more information, see [Support for generation 2 VMs on Azure](/azure/virtual-machines/windows/generation-2). |
| Virtual machine sizes | Azure supports a wide variety of sizes for VMs. To learn about the available sizes and options, refer to the [Azure VMs sizes](/azure/virtual-machines/sizes). | Azure Stack Hub supports a subset of VM sizes that are available in Azure. To view the list of supported sizes, refer to the [VM sizes](#vm-sizes) section of this article. |
| Virtual machine quotas | [Quota limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#managing-limits) are set by Microsoft. | The Azure Stack Hub cloud admin must assign quotas before they offer VM to their users. |
| Virtual machine extensions |Azure supports a wide variety of VM extensions. To learn about the available extensions, refer to the [VM extensions and features](/azure/virtual-machines/windows/extensions-features) article.| Azure Stack Hub supports a subset of extensions that are available in Azure and each of the extensions have specific versions. The Azure Stack Hub cloud admin can choose which extensions to be made available to for their users. To view the list of supported extensions, refer to the [VM extensions](#vm-extensions) section of this article. |
| Virtual machine network | Public IP addresses assigned to a tenant VM are accessible over the Internet.<br><br><br>Azure VMs have a fixed DNS name. | Public IP addresses assigned to a tenant VM are accessible within the Azure Stack Development Kit environment only. A user must have access to the Azure Stack Development Kit via [RDP](../asdk/asdk-connect.md#connect-to-azure-stack-using-rdp) or [VPN](../asdk/asdk-connect.md#connect-to-azure-stack-using-vpn) to connect to a VM that is created in Azure Stack Hub.<br><br>VMs created within a specific Azure Stack Hub instance have a DNS name based on the value that is configured by the cloud admin. |
| Virtual machine storage | Supports [managed disks.](/azure/virtual-machines/windows/managed-disks-overview) | Managed disks are supported in Azure Stack Hub with version 1808 and later. |
| Virtual machine disk performance | Depends on disk type and size. | Depends on VM size of the VM, which the disks are attached to. For more info, refer to the [VM sizes supported in Azure Stack Hub](azure-stack-vm-sizes.md) article.
| OS Disk Swap | If you have an existing VM, but you want to swap the disk for a backup disk or another OS disk, you can [swap the OS disks](/azure/virtual-machines/windows/os-disk-swap). You don't have to delete and recreate the VM. You can even use a managed disk in another resource group, as long as it isn't already in use. | OS Disk Swap is not supported on Azure Stack Hub. |
| API versions | Azure always has the latest API versions for all the VM features. | Azure Stack Hub supports specific Azure services and specific API versions for these services. To view the list of supported API versions, refer to the [API versions](#api-versions) section of this article. |
| Azure Instance Metadata Service | The Azure Instance Metadata Service provides info about running VM instances that can be used to manage and set up your VM.  | The Azure Instance Metadata Service is available as a public preview with the Azure Stack Hub hotfix 1.2108.2.73. It supports the Compute & Network namespace. For more information, see [Azure Instance Metadata Service](instance-metadata-service.md). |
| Virtual machine availability sets|Multiple fault domains (2 or 3 per region).<br>Multiple update domains.|Multiple fault domains (2 or 3 per region).<br>Single update domain, with live migration to protect workloads during update. 20 update domains supported for template compatibility.<br>VM and availability set should be in the same location and resource group.|
| Virtual machine scale sets|Autoscale is supported.|Autoscale isn't supported.<br><br>Add more instances to a scale set using the portal, Resource Manager templates, or PowerShell. |
| Cloud Witness | Select the endpoints from the storage account properties available in Azure Stack Hub. | [Cloud Witness](/windows-server/failover-clustering/deploy-cloud-witness) is a type of Failover Cluster quorum witness that uses Microsoft Azure to provide a vote on cluster quorum.<br>The endpoints in global Azure compared to Azure Stack Hub may look like:<br>For global Azure:<br>`https://mywitness.blob.core.windows.net/`<br>For Azure Stack Hub:<br>`https://mywitness.blob.<region>.<FQDN>/`|
| Virtual machine diagnostics | Linux VM diagnostics are supported. | Linux VM diagnostics aren't supported in Azure Stack Hub. When you deploy a Linux VM with VM diagnostics enabled, the deployment fails. The deployment also fails if you enable the Linux VM basic metrics through diagnostic settings. |
| Nested virtualization VM sizes | Supported | Supported from release 2102 and later. |
| Reserved VM instances | Supported | Not supported. |
| VM deallocation | Supported | Supports VM deallocation. The guest operating system recognizes all network adapters as the same device, and maintains settings. |
| SAP workload certification | Azure supports [SAP workload certifications](/azure/virtual-machines/workloads/sap/sap-certifications), including HANA, NetWeaver, and others. | Azure Stack Hub hardware does not support certification of any SAP workloads. |

## VM sizes

Azure Stack Hub imposes resource limits to avoid over consumption of resources (server local and service-level.) These limits improve the tenant experience by reducing the affect resource consumption by other tenants.

- For networking egress from the VM, there are bandwidth caps in place. Caps in Azure Stack Hub are the same as the caps in Azure.
- For storage resources, Azure Stack Hub implements storage IOPS (Input/Output Operations Per Second) limits to avoid basic overconsumption of resources by tenants for storage use.
- For VM disks, disk IOPS on Azure Stack Hub is a function of VM size instead of the disk type. This means that for a Standard_Fs series VM, regardless of whether you choose SSD or HDD for the disk type, the IOPS limit for an second data disk is 2300 IOPS.
- Temp disks attached to the VM are not persistent and can be lost on control plane operations such as resize or stop-deallocate.

The following table lists the VMs that are supported on Azure Stack Hub along with their configuration:

| Type            | Size          | Range of supported sizes |
| ----------------| ------------- | ------------------------ |
|General purpose  |Basic A        |[A0 - A4](azure-stack-vm-sizes.md#basic-a)                   |
|General purpose  |Standard A     |[A0 - A7](azure-stack-vm-sizes.md#standard-a)              |
|General purpose  |Av2-series     |[A1_v2 - A8m_v2](azure-stack-vm-sizes.md#av2-series)     |
|General purpose  |D-series       |[D1 - D4](azure-stack-vm-sizes.md#d-series)              |
|General purpose  |Dv2-series     |[D1_v2 - D5_v2](azure-stack-vm-sizes.md#dsv2-series) |
|General purpose  |DS-series      |[DS1 - DS4](azure-stack-vm-sizes.md#dv2-series)            |
|General purpose  |DSv2-series    |[DS1_v2 - DS5_v2](azure-stack-vm-sizes.md#dv2-series)      |
|Memory optimized |D-series       |[D11 - D14](azure-stack-vm-sizes.md#d-series)            |
|Memory optimized |DS-series      |[DS11 - DS14](azure-stack-vm-sizes.md#d-series)|
|Memory optimized |Dv2-series     |[D11_v2 - DS14_v2](azure-stack-vm-sizes.md#dv2-series)     |
|Memory optimized |DSv2-series    |[DS11_v2 - DS14_v2](azure-stack-vm-sizes.md#dv2-series)    |
|Compute optimized|F-series       |[F1 - F16](azure-stack-vm-sizes.md#f-series)    |
|Compute optimized|Fs-series      |[F1s - F16s](azure-stack-vm-sizes.md#fs-series) |
|Compute optimized|Fsv2-series    |[F2s_v2 - F64s_v2](azure-stack-vm-sizes.md#fsv2-series) |
|GPU | NCv3-series |[NC6s_v3-NC24s_v3](gpu-vms-about.md#ncv3) |
|GPU | NVv4-series |[NV4as_v4](gpu-vms-about.md#nvv4) |
|GPU | NCasT4_v3-series |[NC4as_T4_v3-NC64as_T4_v3](gpu-vms-about.md#ncast4_v3)

VM sizes and their associated resource quantities are consistent between Azure Stack Hub and Azure. This consistency includes the amount of memory, the number of cores, and the number/size of data disks that can be created. However, performance of VMs with the same size depends on the underlying characteristics of a particular Azure Stack Hub environment.

## VM extensions

Azure Stack Hub includes a small set of extensions. Updates and additional extensions are available through Marketplace syndication. Bringing custom extensions into Azure Stack Hub is not a supported scenario; an extension must first be onboarded to Azure to be made available in Azure Stack Hub.

Use the following PowerShell script to get the list of VM extensions that are available in your Azure Stack Hub environment.

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
Get-AzureRMVmImagePublisher -Location local | `
  Get-AzVMExtensionImageType | `
  Get-AzVMExtensionImage | `
  Select Type, Version | `
  Format-Table -Property * -AutoSize
``` 
---

If provisioning an extension on a VM deployment takes too long, let the provisioning timeout instead of trying to stop the process to deallocate or delete the VM.

## API versions

VM features in Azure Stack Hub support the following API versions:

"2017-12-01",
"2017-03-30",
"2016-03-30",
"2015-06-15"

You can use the following PowerShell script to get the API versions for the VM features that are available in your Azure Stack Hub environment:

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
Get-AzureRMResourceProvider | `
  Select ProviderNamespace -Expand ResourceTypes | `
  Select * -Expand ApiVersions | `
  Select ProviderNamespace, ResourceTypeName, @{Name="ApiVersion"; Expression={$_}} | `
  where-Object {$_.ProviderNamespace -like "Microsoft.compute"}
```

---


The list of supported resource types and API versions may vary if the cloud operator updates your Azure Stack Hub environment to a newer version.

## Windows activation

Windows products must be used in accordance with Product Use Rights and Microsoft license terms. Azure Stack Hub uses [Automatic VM Activation](/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/dn303421(v%3dws.11)) (AVMA) to activate Windows Server VMs.

- Azure Stack Hub host activates Windows with AVMA keys for Windows Server 2016. All VMs that run Windows Server 2012 R2 or later are automatically activated.
- VMs that run Windows Server 2012 or earlier aren't automatically activated and must be activated by using [MAK activation](/previous-versions/tn-archive/ff793438(v=technet.10)). To use MAK activation, you must provide your own product key.

Microsoft Azure uses KMS activation to activate Windows VMs. If you move a VM from Azure Stack Hub to Azure and encounter activation problems, see [Troubleshoot Azure Windows VM activation problems](/azure/virtual-machines/windows/troubleshoot-activation-problems). Additional info can be found at the [Troubleshooting Windows activation failures on Azure VMs](/archive/blogs/mast/troubleshooting-windows-activation-failures-on-azure-vms) Azure Support Team Blog post.

## High Availability

Your VM may be subject to a reboot due to planned maintenance as scheduled by the Azure Stack Hub operator. For high availability of a multi-VM production system in Azure, VMs are placed in an [availability set](/azure/virtual-machines/windows/manage-availability#configure-multiple-virtual-machines-in-an-availability-set-for-redundancy) that spreads them across multiple fault domains and update domains. In the smaller scale of Azure Stack Hub, a fault domain in an availability set is defined as a single node in the scale unit.  

While the infrastructure of Azure Stack Hub is already resilient to failures, the underlying technology (failover clustering) still incurs some downtime for VMs on an impacted physical server if there's a hardware failure. Azure Stack Hub supports having an availability set with a maximum of three fault domains to be consistent with Azure.

### Fault domains

VMs placed in an availability set will be physically isolated from each other by spreading them as evenly as possible over multiple fault domains (Azure Stack Hub nodes). If there's a hardware failure, VMs from the failed fault domain will be restarted in other fault domains. They'll be kept in separate fault domains from the other VMs but in the same availability set if possible. When the hardware comes back online, VMs will be rebalanced to maintain high availability.

### Update domains

Update domains are another way that Azure provides high availability in availability sets. An update domain is a logical group of underlying hardware that can undergo maintenance at the same time. VMs located in the same update domain will be restarted together during planned maintenance. As tenants create VMs within an availability set, the Azure platform automatically distributes VMs across these update domains.

In Azure Stack Hub, VMs are live migrated across the other online hosts in the cluster before their underlying host is updated. Since there's no tenant downtime during a host update, the update domain feature on Azure Stack Hub only exists for template compatibility with Azure. VMs in an availability set will show 0 as their update domain number on the portal.

## Arc on Azure Stack Hub VMs

Arc enabled servers do not support installing the connected machine agent on virtual machines running in Azure, or virtual machines running on Azure Stack Hub or Azure Stack Edge, as they are already modeled as Azure VMs.

## Microsoft Office server products on Azure Stack Hub VMs

Not all Microsoft Office server products are supported on Azure Stack Hub VMs, which is clarified as follows:

| Product | Office support statement | More information |
| --------| ------------------------ | ---------------- |
| Exchange | Not supported. Does not meet the storage virtualization requirements for Exchange. |  [Exchange Server virtualization](/exchange/plan-and-deploy/virtualization) | 
| SharePoint | Supported only if specific networking requirements are met. | [Plan for virtualization of SharePoint Server](/sharepoint/install/deploy-sharepoint-virtual-machines) | 
| Skype | Not supported. Skype does not support live migration, a core virtualization feature used in Azure Stack Hub. | [Virtualization support for Skype for Business Server 2019](/skypeforbusiness/virtualization-guidance) |  


## Next steps

[Create a Windows VM with PowerShell in Azure Stack Hub](azure-stack-quick-create-vm-windows-powershell.md)
