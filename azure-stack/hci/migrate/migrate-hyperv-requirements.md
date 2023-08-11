---
title: System requirements for Hyper-V VM migration to Azure Stack HCI using Azure Migrate (preview) 
description: Learn the system requirements for Hyper-V migration to Azure Stack HCI using Azure Migrate (preview).
author: alkohli
ms.topic: how-to
ms.date: 08/11/2023
ms.author: alkohli
ms.subservice: azure-stack-hci
---

# System requirements for Hyper-V VM migration to Azure Stack HCI using Azure Migrate (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes the system requirements for Hyper-V virtual machine (VM) migration to Azure Stack HCI using Azure Migrate.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Supported operating systems

The following operating systems (OS) are supported for the Azure Migrate source appliance and the target appliance, and for the guest VMs that you are migrating.

**Source appliance OS** - Windows Server 2016

**Target appliance OS** - Windows server 2022

**Windows Server guest VM OS**

- Windows server 2022
- Windows Server 2019
- Windows Server 2016
- Windows Server 2012 R2
- Windows Server 2008 R2

**Linux guest VM OS**

- Red Hat Linux 6.x, 7.x
- Ubuntu Server and Pro. 18.x
- CentOS 7.x
- SUSE Linux Enterprise 12.x
- Debian 9.x

## Region requirements

The following Azure regions are supported for your Azure Migrate service:

|Country|Supported regions|
|-|-|
|US|Central US|
|Europe|West Europe|

## Azure portal requirements

For more information on subscriptions and roles, see [Azure roles, Azure AD roles, and classic subscription administrator roles](https://learn.microsoft.com/azure/role-based-access-control/rbac-and-directory-admin-roles).

|Level|Permissions|
|-|-|
|Tenant|Application administrator permissions|
|Subscription|Contributor and User Access Administrator permissions|

## Source Hyper-V cluster and VM requirements

Scale-Out File Server (SOFS) is not supported in Public Preview. If the VM disks are on a SOFS, you can’t migrate those VMs with the Public Preview.

## Target Azure Stack HCI cluster and VM requirements

- The target Azure Stack HCI cluster HCI version must be the 23H2 supplemental package release or the [latest release](https://learn.microsoft.com//azure-stack/hci/release-information#azure-stack-hci-version-22h2-os-build-20349).

- Standalone VMs on standalone (non-clustered) Hyper-V hosts can be discovered and migrated however, standalone VMs hosted on "clustered" Hyper-V hosts cannot be discovered and migrated. To migrate these VMs they need to be [made highly available](https://www.thomasmaurer.ch/2013/01/how-to-make-an-existing-hyper-v-virtual-machine-highly-available/).

- Before you migrate, for all the Windows VMs, bring all the disks online and persist the drive letter. For more information, see how to [configure a SAN policy](/azure/migrate/prepare-for-migration#configure-san-policy) to bring disks online.

## Agent and service requirements

Make sure that the source appliance VM and the target appliance VM have a healthy configuration by ensuring the following agents and services are running:

1. On the source appliance VM (also known as Azure Migrate appliance):
  
     - Microsoft Azure Gateway Service (*asrgwy*)
     - Microsoft Azure Hyper-V Discovery Service (*amhvdiscoverysvc*)
     - Azure Site Recovery Management Service (*asrmgmtsvc*)

    Logs and configuration can be found at *C:\ProgramData\Microsoft Azure\Logs* and *C:\ProgramData\Microsoft Azure\Config*.

1. On the target appliance VM:
 
     - Microsoft Azure Gateway Service (*asrgwy*)
     - Azure Site Recovery Management Service (*asrmgmtsvc*)
    
    Logs and configuration can be found at *C:\ProgramData\Microsoft Azure\Logs* and *C:\ProgramData\Microsoft Azure\Config*.


The Arc Resource Bridge must be configured and running on the target appliance VM. Make sure that you have the following configured:

- Arc Resource Bridge must have virtual network configured.

- Arc Resource Bridge must have storage path(s) configured.

- Arc Resource Bridge agent logs can be captured by running these PowerShell cmdlets:

    ```PowerShell
    Get-MocLogs
    Get-MocEventLog
    Get-ArcHciLogs
    ```

## Next steps

- Start [Complete prerequisites](migrate-hyperv-requirements.md).