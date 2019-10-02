---
title: Protect VMs deployed on Azure Stack | Microsoft Docs
description: Learn how to build a recovery plan to protect VMs deployed on Azure Stack against data loss and unplanned downtime.
services: azure-stack
documentationcenter: ''
author: mattbriggs
manager: femila
editor: ''

ms.assetid: 4e5833cf-4790-4146-82d6-737975fb06ba
ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: conceptual
ms.date: 10/02/2019
ms.author: mabrigg
ms.reviewer: hectorl
ms.lastreviewed: 3/19/2018
---

# Protect VMs deployed on Azure Stack

Use this article as a guide to developing a plan for protecting virtual machines (VMs) that your users deploy on Azure Stack.


To protect against data loss and unplanned downtime, you need to implement a backup-recovery or disaster-recovery plan for user apps and their data. This plan might be unique for each app but follows a framework established by your organization's comprehensive business continuity and disaster recovery (BC/DR) strategy. A good starting point is [Azure Stack: Considerations for business continuity and disaster recovery](https://aka.ms/azurestackbcdrconsiderationswp).

## Azure Stack infrastructure recovery

Users are responsible for protecting their VMs separately from Azure Stack's infrastructure services.

The recovery plan for Azure Stack infrastructure services **does not** include recovery of user VMs, storage accounts, or databases. As the app owner, you're responsible for implementing a recovery plan for your apps and data.

If the Azure Stack cloud is offline for an extended time or permanently unrecoverable, you need to have a recovery plan in place that:

* Ensures minimal downtime.
* Keeps critical VMs, such as database servers, running.
* Enables apps to keep servicing user requests.

The operator of the Azure Stack cloud is responsible for creating a recovery plan for the underlying Azure Stack infrastructure and services. To learn more, see [Recover from catastrophic data loss](../operator/azure-stack-backup-recover-data.md).

## Considerations for IaaS VMs
The operating system installed in the IaaS VM limits which products you can use to protect the data it contains. For Windows based IaaS VMs, you can use Microsoft and partner products to protect data. For Linux based IaaS VMs, the only option is to use partner products. Refer to [this datasheet for all the BC/DR partners with validated products for Azure Stack](https://aka.ms/azurestackbcdrpartners).

## Source/target combinations

Each Azure Stack cloud is deployed to one datacenter. A separate environment is required to recover your apps. The recovery environment can be another Azure Stack cloud in a different datacenter or the Azure public cloud. Your data sovereignty and data privacy requirements determine the recovery environment for your app. As you enable protection for each app, you have the flexibility to choose a specific recovery option for each one. You can have apps in one subscription backing up data to another datacenter. In another subscription, you can replicate data to the Azure public cloud.

Plan your backup-recovery and disaster-recovery strategy for each app to determine the target for each app. A recovery plan helps your organization properly size the storage capacity required on-premises and project consumption in the public cloud.

|  | Global Azure | Azure Stack deployed into CSP datacenter and operated by CSP | Azure Stack deployed into customer datacenter and operated by customer |
|------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------|
| **Azure Stack deployed into CSP datacenter and operated by CSP** | User VMs are deployed to the CSP-operated Azure Stack.<br><br>User VMs are restored from backup or failed over directly to Azure. | CSP operates the primary and secondary instances of Azure Stack in their own datacenters.<br><br>User VMs are restored or failed over between the two Azure Stack instances. | CSP operates Azure Stack in the primary site.<br><br>Customer's datacenter is the restore or failover target. |
| **Azure Stack deployed into customer datacenter and operated by customer** | User VMs are deployed to the customer-operated Azure Stack.<br><br>User VMs are restored from backup or failed over directly to Azure. | Customer operates Azure Stack in the primary site.<br><br>CSP's datacenter is the restore or failover target. | Customer operates the primary and secondary instances of Azure Stack in their own datacenters.<br><br>User VMs are restored or failed over between the two Azure Stack instances. |

![Source-target combinations](media/azure-stack-manage-vm-backup/vm_backupdataflow_01.png)

## App recovery objectives

Determine the amount of downtime and data loss your organization can tolerate for each app. By quantifying downtime and data loss, you can create a recovery plan that minimizes the impact of a disaster on your organization. For each app, consider:

 - **Recovery time objective (RTO)**  
RTO is the maximum acceptable time that an app can be unavailable after an incident. For example, an RTO of 90 minutes means that you must be able to restore the app to a running state within 90 minutes from the start of a disaster. If you have a low RTO, you might keep a second deployment continually running on standby to protect against a regional outage.
 - **Recovery point objective (RPO)**  
RPO is the maximum duration of data loss that is acceptable during a disaster. For example, if you store data in a single database which is backed up hourly and has no replication to other databases, you could lose up to an hour of data.

RTO and RPO are business requirements. Conduct a risk assessment to  define the app's RTO and RPO.

Another metric is **Mean Time to Recover** (MTTR), which is the average time that it takes to restore the app after a failure. MTTR is an empirical value for a system. If MTTR exceeds the RTO, then a failure in the system will cause an unacceptable business disruption because it won't be possible to restore the system within the defined RTO.

### Backup-restore

The most common protection scheme for VM-based apps is to use backup software. Backing up a VM typically includes the operating system, operating system configuration, app binaries, and app data. The backups are created by taking a snapshot of the volumes, disks, or the entire VM. With Azure Stack, you have the flexibility of backing up from within the context of the guest OS or from the Azure Stack storage and compute APIs. Azure Stack doesn't support taking backups at the hypervisor level.
 
![Backup-restor](media/azure-stack-manage-vm-backup/vm_backupdataflow_03.png)

Recovering the app requires restoring one or more VMs to the same cloud or to a new cloud. You can target a cloud in your datacenter or the public cloud. The cloud you choose is completely within your control and is based on your data privacy and sovereignty requirements.

 - RTO: Downtime measured in hours
 - RPO: Variable data loss (depending on backup frequency)
 - Deployment topology: Active/passive

#### Planning your backup strategy

Planning your backup strategy and defining scale requirements starts with quantifying the number of VM instances that need to be protected. Backing up all VMs across all servers in an environment is a common strategy. However, with Azure Stack, there are some VMs that do need to be backed up. For example, VMs in a scale-set are considered ephemeral resources that can come and go, sometimes without notice. Any durable data that needs to be protected is stored in a separate repository such as a database or object store.

Important considerations for backing up VMs on Azure Stack:

 - **Categorization**
    - Consider a model where users opt in to VM backup.
    - Define a recovery service level agreement (SLA) based on the priority of the apps or the impact to the business.
 - **Scale**
    - Consider staggered backups when on-boarding a large number of new VMs (if backup is required).
    - Evaluate backup products that can efficiently capture and transmit backup data to minimize resource content on the solution.
    - Evaluate backup products that efficiently store backup data using incremental or differential backups to minimize the need for full backups across all VMs in the environment.
 - **Restore**
    - Backup products can restore virtual disks, app data within an existing VM, or the entire VM resource and associated virtual disks. The restore scheme you need depends on how you plan to restore the app. For example, it may be easier to redeploy SQL server from a template and then restore the databases instead of restoring the entire VM or set of VMs.

### Replication/manual failover

An alternate approach to supporting high availability is to replicate your app VMs to another cloud and rely on a manual failover. The replication of the operating system, app binaries, and app data can be done at the VM level or guest OS level. The failover is managed using additional software that isn't part of the app.

With this approach, the app is deployed in one cloud and its VM is replicated to the other cloud. If a failover is triggered, the secondary VMs need to be powered on in the second cloud. In some scenarios, the failover creates the VMs and attaches disks to them. This process can take a long time to complete, especially with a multi-tiered app that requires a specific start-up sequence. There may also be steps that must be run before the app is ready to start servicing requests.

![Replication-manual failover](media/azure-stack-manage-vm-backup/vm_backupdataflow_02.png)

 - RTO: Downtime measured in minutes
 - RPO: Variable data loss (depending on replication frequency)
 - Deployment topology: Active/Passive stand-by
 
### High availability/automatic failover

For apps where your business can only tolerate a few seconds or minutes of downtime and minimal data loss, consider a high-availability configuration. High-availability apps are designed to quickly and automatically recover from faults. For local hardware faults, Azure Stack infrastructure implements high availability in the physical network using two top of rack switches. For compute level faults, Azure Stack uses multiple nodes in a scale unit. At the VM level, you can use scale sets in combination with fault domains to ensure node failures don't take down your app.

In combination with scale sets, your app will need to support high availability natively or support the use of clustering software. For example, Microsoft SQL Server supports high availability natively for databases using synchronous-commit mode. However, if you can only support asynchronous replication, then there will be some data loss. Apps can also be deployed into a failover cluster where the clustering software handles the automatic failover of the app.

Using this approach, the app is only active in one cloud, but the software is deployed to multiple clouds. The other clouds are in stand-by mode ready to start the app when the failover is triggered.

 - RTO: Downtime measured in seconds
 - RPO: Minimal data loss
 - Deployment topology: Active/Active stand-by

### Fault tolerance

Azure Stack physical redundancy and infrastructure service availability only protect against hardware level faults/failures such as disk, power supply, network port, or node. However, if your app must always be available and can never lose any data, you need to implement fault tolerance natively in your app or use additional software to enable fault tolerance.

First, you need to ensure the app VMs are deployed using scale sets to protect against node-level failures. To protect against the cloud going offline, the same app must already be deployed to a different cloud so it can continue servicing requests without interruption. This model is typically referred to an active-active deployment.

Keep in mind that each Azure Stack cloud is independent of each other, so the clouds are always considered active from an infrastructure perspective. In this case, multiple active instances of the app are deployed to one or more active clouds.

 - RTO: No downtime
 - RPO: No data loss
 - Deployment topology: Active/Active

### No recovery

Some apps in your environment may not need protection against unplanned downtime or data loss. For example, VMs used for development and testing typically don't need to be recovered. It's your decision to do without protection for an app or a specific VM. Azure Stack doesn't offer backup or replication of VMs from the underlying infrastructure. Similar to Azure, you need to opt-in to protection for each VM in each of your subscriptions.

 - RTO: Unrecoverable
 - RPO: Complete data loss

## Recommended topologies

Important considerations for your Azure Stack deployment:

|     | Recommendation | Comments |
|-------------------------------------------------------------------------------------------------|-----------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Backup/restore VMs to an external backup target already deployed in your datacenter | Recommended | Take advantage of existing backup infrastructure and operational skills. Make sure to size the backup infrastructure so it's ready to protect the additional VM instances. Make sure backup infrastructure isn't in close proximity to your source. You can restore VMs to the source Azure Stack, to a secondary Azure Stack instance, or Azure. |
| Backup/restore VMs to an external backup target dedicated to Azure Stack | Recommended | You can purchase new backup infrastructure or provision dedicated backup infrastructure for Azure Stack. Make sure backup infrastructure isn't in close proximity to your source. You can restore VMs to the source Azure Stack, to a secondary Azure Stack instance, or Azure. |
| Backup/restore VMs directly to global Azure or a trusted service provider | Recommended | As long as you can meet your data privacy and regulatory requirements, you can store your backups in global Azure or a trusted service provider. Ideally the service provider is also running Azure Stack so you get consistency in operational experience when you restore. |
| Replicate/failover VMs to a separate Azure Stack instance | Recommended | In the failover case, you need to have a second Azure Stack cloud fully operational so you can avoid extended app downtime. |
| Replicate/failover VMs directly to Azure or a trusted service provider | Recommended | As long as you can meet your data privacy and regulatory requirements, you can replicate your data to global Azure or a trusted service provider. Ideally the service provider is also running Azure Stack so you get consistency in operational experience after failover. |
| Deploy backup target on the same Azure Stack cloud with your app data | Not recommended | Avoid storing backups within the same Azure Stack cloud. Unplanned downtime of the cloud can keep you from your primary data and backup data. If you choose to deploy a backup target as a virtual appliance (for the purposes of optimization for backup and restore), you must ensure all data is continuously copied to an external backup location. |
| Deploy physical backup appliance into the same rack where the Azure Stack solution is installed | Not supported | Currently, you can't connect any other devices to the top of rack switches that aren't part of the original solution. |

## Next steps

This article provided general guidelines for protecting user VMs deployed on Azure Stack. For information about using Azure services to protect user VMs, refer to:

 - [Use Azure Backup to back up files and apps on Azure Stack](https://docs.microsoft.com/azure/backup/backup-mabs-files-applications-azure-stack)
 - [Azure Backup Server support for Azure Stack](https://docs.microsoft.com/azure/backup/ ) 
 - [Azure Site Recovery support for Azure Stack](https://docs.microsoft.com/azure/site-recovery/)  

To learn more about the partner products that offer VM protection on Azure Stack, refer to [Protecting apps and data on Azure Stack](https://azure.microsoft.com/blog/protecting-applications-and-data-on-azure-stack/).
