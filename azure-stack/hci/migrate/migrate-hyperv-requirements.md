---
title: Review requirements for Hyper-V VM migration to Azure Stack HCI using Azure Migrate (preview) 
description: Learn the system requirements for Hyper-V migration to Azure Stack HCI using Azure Migrate (preview).
author: alkohli
ms.topic: how-to
ms.date: 09/13/2023
ms.author: alkohli
ms.subservice: azure-stack-hci
---

# Review requirements for Hyper-V VM migration to Azure Stack HCI using Azure Migrate (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article lists the system requirements for migrating Hyper-V virtual machines (VMs) to Azure Stack HCI using Azure Migrate.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Supported operating systems

The following operating systems (OS) are supported for the source appliance, target appliance, and for the guest VMs that you are migrating.


|Component  |Supported OS |
|---------|---------|
|Source appliance     |Windows Server 2022         |
|Target appliance     |Windows Server 2022         |
|Guest VM    |Windows Server 2022<br>Windows Server 2019<br>Windows Server 2016<br>Windows Server 2012 R2<br>Windows Server 2008 R2*       |
|Guest VM     | Red Hat Linux 6.x, 7.x<br>Ubuntu Server and Pro. 18.x<br>CentOS 7.x<br>SUSE Linux Enterprise 12.x<br>Debian 9.x        |

For appliances to discover Windows Server 2008 R2 VMs, you must do the following:

1. Download and install [KB patch 3138612](https://www.microsoft.com/download/details.aspx?id=51208). This clears the Windows Update error 80072EFE.
 You can then update all patches to get the latest Hyper-V integration services.
2. Run `winrm quickconfig` from a command prompt as an Administrator to add Windows Remote Management (WinRm) access through your firewall.

## Supported geographies

You can create an Azure Migrate project in many geographies in the Azure public cloud. Here's a list of supported geographies for migration to Azure Stack HCI:

|Geography|Metadata storage locations|
|-|-|
|Asia-Pacific|South East Asia, East Asia|
|Europe|North Europe, West Europe|
|United States|East US, Central US, West Central US, West US2|

Keep in mind the following information as you create a project:

- The project geography is only used to store the discovered metadata.
- When you create a project, you select a geography. The project and related resources are created in one of the regions in the geography. The region is allocated by the Azure Migrate service. Azure Migrate doesn't move or store customer data outside of the region allocated.

## Azure portal requirements

For more information on Azure subscriptions and roles, see [Azure roles, Azure AD roles, and classic subscription administrator roles](/azure/role-based-access-control/rbac-and-directory-admin-roles).

|Level|Permissions|
|-|-|
|Tenant|Application administrator|
|Subscription|Contributor, User Access Administrator|

## Source Hyper-V server and VM requirements

In this release, you can only migrate VMs that have disks attached to the local cluster storage. If the VM disks aren't attached to the local cluster storage, the disks can’t be migrated.

Create a Windows Server 2022 VM with this minimum configuration:

- 16 GB memory.
- 80 GB disk.
- 8 vCPUs.


## Target Azure Stack HCI cluster and VM requirements

- The target Azure Stack HCI cluster OS must be version 23H2 or later.

- You can discover and migrate standalone VMs on standalone (non-clustered) Hyper-V hosts. However, standalone VMs hosted on clustered Hyper-V hosts cannot be discovered or migrated. To migrate these VMs, they need to be [made highly available](https://www.thomasmaurer.ch/2013/01/how-to-make-an-existing-hyper-v-virtual-machine-highly-available/) first.

- Before you begin, for all Windows VMs, bring all the disks online and persist the drive letter. For more information, see how to [configure a SAN policy](/azure/migrate/prepare-for-migration#configure-san-policy) to bring the disks online.

## Arc Resource Bridge requirements

The Arc Resource Bridge must be configured and running on the target appliance VM. Make sure that you have the following configured:

- Arc Resource Bridge must have a virtual network configured.

- Arc Resource Bridge must have storage path(s) configured.

Arc Resource Bridge agent logs can be captured by running these PowerShell cmdlets:

```PowerShell
Get-MocLogs
Get-MocEventLog
Get-ArcHciLogs
```

## Next steps

- [Complete the prerequisites](migrate-hyperv-prerequisites.md).