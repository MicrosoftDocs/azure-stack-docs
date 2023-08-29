---
title: Review requirements for Hyper-V VM migration to Azure Stack HCI using Azure Migrate (preview) 
description: Learn the system requirements for Hyper-V migration to Azure Stack HCI using Azure Migrate (preview).
author: alkohli
ms.topic: how-to
ms.date: 08/29/2023
ms.author: alkohli
ms.subservice: azure-stack-hci
---

# Review requirements for Hyper-V VM migration to Azure Stack HCI using Azure Migrate (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article lists the system requirements for migrating Hyper-V virtual machines (VMs) to Azure Stack HCI using Azure Migrate. If you haven't already, read the [Overview](migrate-hyperv-requirements.md).

[!INCLUDE [important](../../includes/hci-preview.md)]

## Supported operating systems

The following operating systems (OS) are supported for the source appliance, target appliance, and for the guest VMs that you are migrating.

**Source and target appliance OS**: Windows Server 2022

**Windows Server guest VM OS**:

- Windows Server 2022
- Windows Server 2019
- Windows Server 2016
- Windows Server 2012 R2
- Windows Server 2008 R2

**Linux guest VM OS**:

- Red Hat Linux 6.x, 7.x
- Ubuntu Server and Pro. 18.x
- CentOS 7.x
- SUSE Linux Enterprise 12.x
- Debian 9.x

## Supported geographies

You can create an Azure Migrate project in many geographies in the Azure public cloud. Here is a list of supported geographies for migration to Azure Stack HCI:

|Geography|Metadata storage locations|
|-|-|
|Asia-Pacific|South East Asia, East Asia|
|Europe|North Europe, West Europe|
|United States|East US, Central US, West Central US, West US2|

Keep in mind the following information as you create a project:

- The project geography is only used to store the discovered metadata.
- When you create a project, you select a geography. The project and related resources are created in one of the regions in the geography. The region is allocated by the Azure Migrate service. Azure Migrate does not move or store customer data outside of the region allocated.

## Azure portal requirements

For more information on Azure subscriptions and roles, see [Azure roles, Azure AD roles, and classic subscription administrator roles](/azure/role-based-access-control/rbac-and-directory-admin-roles).

|Level|Permissions|
|-|-|
|Tenant|Application administrator permissions|
|Subscription|Contributor and User Access Administrator permissions|

## Source Hyper-V cluster and VM requirements

In this release, you can only migrate VMs that have disks attached to the local cluster storage. If the VM disks are not attached to the local cluster storage, the disks can’t be migrated.

## Target Azure Stack HCI cluster and VM requirements

- The target Azure Stack HCI cluster HCI version must be the 22H2 release or later.

- Standalone VMs on standalone (non-clustered) Hyper-V hosts can be discovered and migrated however, standalone VMs hosted on "clustered" Hyper-V hosts cannot be discovered and migrated. To migrate these VMs they need to be [made highly available](https://www.thomasmaurer.ch/2013/01/how-to-make-an-existing-hyper-v-virtual-machine-highly-available/) (HA) first.

- Before you begin, for all Windows VMs, bring all the disks online and persist the drive letter. For more information, see how to [configure a SAN policy](/azure/migrate/prepare-for-migration#configure-san-policy) to bring the disks online.

## Agent and service requirements

Make sure that the source appliance VM and the target appliance VM have a healthy configuration by ensuring the following agents and services are running:

**On the source appliance VM**:
  
- Microsoft Azure Gateway Service (*asrgwy*)
- Microsoft Azure Hyper-V Discovery Service (*amhvdiscoverysvc*)
- Azure Site Recovery Management Service (*asrmgmtsvc*)

Logs and configuration can be found at *C:\ProgramData\Microsoft Azure\Logs* and *C:\ProgramData\Microsoft Azure\Config*.

**On the target appliance VM**:
 
- Microsoft Azure Gateway Service (*asrgwy*)
- Azure Site Recovery Management Service (*asrmgmtsvc*)
    
Logs and configuration can be found at *C:\ProgramData\Microsoft Azure\Logs* and *C:\ProgramData\Microsoft Azure\Config*.

The **Arc Resource Bridge** must be configured and running on the target appliance VM. Make sure that you have the following configured:

- Arc Resource Bridge must have a virtual network configured.

- Arc Resource Bridge must have storage path(s) configured.

Arc Resource Bridge agent logs can be captured by running these PowerShell cmdlets:

```PowerShell
Get-MocLogs
Get-MocEventLog
Get-ArcHciLogs
```

## Next steps

- [Complete the prerequisites](migrate-hyperv-requirements.md).