---
title: Azure Stack Hub update activity checklist 
description:  Checklist to prepare your system for the latest Azure Stack Hub update.
author: sethmanheim

ms.topic: article
ms.date: 02/20/2020
ms.author: sethm
ms.reviewer: ppacent
ms.lastreviewed: 01/14/2020

---

# Azure Stack Hub update activity checklist

Review this checklist in order to prepare for an Azure Stack Hub update. This article contains a checklist of update-related activities for Azure Stack Hub operators.

## Prepare for Azure Stack Hub update

| &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Activity &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;                   | Details                                                   |
|------------------------------|-----------------------------------------------------------|
| Review known issues     | [List of known issues](known-issues.md).                |
| Review security updates | [List of security updates](release-notes-security-updates.md).      |
| Apply latest OEM package | Contact your OEM to ensure your system meets the minimum OEM package requirements for the Azure Stack Hub version your system is being updated to. Ensure your OEM package is compatible with the Azure Stack Hub version you are updating to. If your OEM package is not compatible with the Azure Stack Hub version you are updating to, you will need to perform an OEM package update before running an Azure Stack Hub update. For instructions, see "Apply Azure Stack Hub original equipment manufacturer (OEM) updates." |
| Optional: Configure automatic log collection | It is recommended that you configure automatic log collection on your Azure Stack Hub environment to streamline the process of collecting system logs in the event that you need to open a support ticket. To configure automatic log collection, see the instructions in [Configure automatic Azure Stack Hub diagnostic log collection](azure-stack-configure-automatic-diagnostic-log-collection.md). |
| Apply latest hotfixes | Apply the latest hotfixes that apply to the currently installed release. For a list of the latest hotfixes, see the [release notes Hotfixes](release-notes.md) section. |
| Run capacity planner tool | Make sure to use the latest version of the [Azure Stack Hub Capacity Planner tool](azure-stack-capacity-planning-overview.md) to perform your workload planning and sizing. The latest version contains bug fixes and provides new features that are released with each Azure Stack Hub update. |
| Run **Test-AzureStack** | Run `Test-AzureStack -Group UpdateReadiness` to identify operational issues. The cmdlet is accessible through the  Privileged Endpoint Session (PEP). For more information, see [Validate Azure Stack Hub system state](azure-stack-diagnostic-test.md). |
| Resolve issues | Resolve any operational issues identified by `Test-AzureStack`. |
| Update available | In connected scenarios only, Azure Stack Hub deployments periodically check a secured endpoint and automatically notify you if an update is available for your cloud. Disconnected customers can download and import new packages using the [process described here](azure-stack-apply-updates.md). |
| Schedule a maintenance window and notify your users | You should notify users of any maintenance operations, and schedule normal maintenance windows during non-business hours if possible. Maintenance operations can affect existing tenant workloads and cause new tenants operations (for example, creating, reconfiguring, or deleting VMs) to fail - whether the operation is initiated from the portal or programmatically from the Azure Resource Manager API. Other operations such as backup may also be unavailable until the update is complete. For Azure Stack Hub express and full updates, you can check the [release notes](release-notes.md) for a forecast of how long the update is expected to take for the version you are applying. |

## During Azure Stack Hub update

| Activity | Details |
|--------------------|------------------------------------------------------------------------------------------------------|
| Manage the update |[Manage updates in Azure Stack Hub using the operator portal](azure-stack-updates.md). |
|  |  |
| Monitor the update | If the operator portal is unavailable, [monitor updates in Azure Stack Hub using the privileged endpoint](azure-stack-monitor-update.md). |
|  |  |
| Resume updates | After remediating a failed update, [resume updates in Azure Stack Hub using the privileged endpoint](azure-stack-monitor-update.md). |

> [!IMPORTANT]  
> Do not run **Test-AzureStack** during an update, as this will cause the update to stall.

## After Azure Stack Hub update

| Activity | Details |
|--------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Apply latest hotfixes | Apply the latest hotfixes applicable to the updated version. |
| Retrieve encryption keys | Retrieve the data at rest encryption keys and securely store them outside of your Azure Stack Hub deployment. Follow the [instructions on how to retrieve the keys](azure-stack-security-bitlocker.md). |
|  |  |
| Re-enable multi-tenancy | In case of a multi-tenanted Azure Stack Hub, [make sure you configure all guest directory tenants](azure-stack-enable-multitenancy.md#configure-guest-directory) after a successful update. |

## Next steps

- [Review list of known issues](known-issues.md)
- [Review list of security updates](release-notes-security-updates.md)
