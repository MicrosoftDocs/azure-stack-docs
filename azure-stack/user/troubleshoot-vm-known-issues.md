---
title: Troubleshooting VM known issues on Azure Stack Hub
description: Troubleshoot VM known issues on Azure Stack Hub. Learn how to resolve common virtual machine and scale set errors quickly.
author: sethmanheim

ms.topic: troubleshooting
ms.date: 07/09/2026
ms.author: sethm
ms.reviewer: thoroet
ms.lastreviewed: 07/09/2020

# Intent: As a developer using Azure Stack Hub, I want to fix an issue I encounter when creating or managing my VM so that my users can use my VM or service delivered by the stack.
# Keyword: Azure Stack Hub troubleshooting VM

---

# Known issues: VMs on Azure Stack Hub

This article lists known issues for troubleshooting the Azure Stack Hub compute resource provider when working with virtual machines (VMs) and scale sets.

## Portal doesn't show correct VM name
- **Applicable**  
    This issue applies to all releases.  
- **Cause**  
    When you view details of a VM in the overview pane, the computer name shows as (not available). The display is by design for VMs created from specialized disks or disk snapshots.  
- **Remediation**  
    In the portal, select **Settings** > **Properties**.
- **Occurrence**  
    Common  

## VM boot diagnostics
- **Applicable**  
    This issue applies to all supported releases.  
- **Cause**  
    When you create a new virtual machine (VM), you might see the following error message: Failed to start virtual machine 'vm-name'. Error: Failed to update serial output settings for VM 'vm-name'. The error occurs if you enable boot diagnostics on a VM, but delete your boot diagnostics storage account.  
- **Remediation**  
    Recreate the storage account with the same name you previously used.
- **Occurrence**  
    Common  

## VM diagnostics storage account not found
- **Applicable**  
    This issue applies to all supported releases.  
- **Cause**  
    When you try to start a stop-deallocated virtual machine, you might see the following error message: VM diagnostics Storage account 'diagnosticstorageaccount' not found. Ensure storage account is not deleted. This error occurs if you attempt to start a VM with boot diagnostics enabled, but the referenced boot diagnostics storage account is deleted.  
- **Remediation**  
    Recreate the storage account with the same name you previously used.  
- **Occurrence**
    Common  

## Consumed compute quota
- **Applicable**  
    This issue applies to all supported releases.  
- **Cause**   
    When you create a new virtual machine, you might receive an error such as This subscription is at capacity for Total Regional vCPUs on this location. This subscription is using all 50 Total Regional vCPUs available. This error indicates that you reached the quota for total cores available to you.  
- **Remediation**  
    Ask your operator for an add-on plan with additional quota. Changing the current plan's quota doesn't work or reflect increased quota.
- **Occurrence**  
    Rare  

## Virtual machine scale set

-  **Applicable**  
    This issue applies to all supported releases.  
- **Cause**  
    Create failures during patch and update on four-node Azure Stack Hub environments. Creating VMs in an availability set of three fault domains and creating a virtual machine scale set instance fails with a FabricVmPlacementErrorUnsupportedFaultDomainSize error during the update process on a four-node Azure Stack Hub environment.  
- **Remediation**  
    You can create single VMs in an availability set with two fault domains successfully. However, scale set instance creation is still not available during the update process on a four-node Azure Stack Hub deployment.  
- **Occurrence**  
    Rare  

## Next steps

Learn more about [Azure Stack Hub VM features](azure-stack-vm-considerations.md).
