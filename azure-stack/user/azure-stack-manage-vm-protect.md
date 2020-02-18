---
title: Protect VMs deployed on Azure Stack Hub 
description: Learn how to build a recovery plan to protect VMs deployed on Azure Stack Hub against data loss and unplanned downtime.
author: mattbriggs

ms.topic: conceptual
ms.date: 02/18/2020
ms.author: mabrigg
ms.reviewer: hectorl
ms.lastreviewed: 2/19/2020
---

# Protect VMs deployed on Azure Stack Hub

Use this article as a guide to help you develop a data protection and disaster recovery strategy for user-deployed IaaS virtual machines (VMs) deployed on Azure Stack Hub.

To protect against data loss and extended downtime, implement a backup-recovery or disaster-recovery plan for user applications and their data. Each application must be evaluated as part of your organization’s comprehensive business continuity and disaster recovery (BC/DR) strategy. A good starting point is [Azure Stack Hub: Considerations for business continuity and disaster recovery](https://aka.ms/azurestackbcdrconsiderationswp).

## Considerations for protecting IaaS VMs

### Roles and responsibilities

First, make sure there is a clear understanding of the roles and responsibilities attributed to application owners and operators in the context of protection and recovery.

Users are responsible for protecting VMs. Operators are responsible for keeping Azure Stack Hub online and healthy. Azure Stack Hub includes a service that backs up internal service data from infrastructure services and **does not** include any user data including user-created VMs, storage accounts with user or application data, or user databases.


| Application owner/architect 	| Azure Stack Hub operator 	|
|---	|---	|
| <ul><li>Align application architecture with cloud design principles.</li></br><li>Modernize traditional applications as required, to prepare them for the cloud environment.</li></br><li>Define acceptable RTO and RPO for the application.</li></br><li>Identify application resources and data repositories that need to be protected.</li></br><li>Implement a data and application recovery method that best aligns to the application architecture and customer requirements.</li></ul> 	| <ul><li>Identify the organization's business continuity and disaster recovery goals.</li></br><li>Deploy enough Azure Stack Hub instances to meet the organization's BC/DR goals.</li></br><li>Design and operate application/data protection infrastructure.</li></br><li>Provide managed solutions or self-service access to protection services.</li></br><li>Work with application owners/architects to understand application design and recommend protection strategies.</li></br><li>Enable infrastructure backup for service healing and cloud recovery.</li></ul> 	|

## Source/target combinations

Users that need to protect against a datacenter or site outage can use another Azure Stack Hub or Azure to provide high availability or quick recovery. With primary and secondary location, users can deploy applications in an active/active or active/passive configuration across two environments. For less critical workloads, users can use capacity in the secondary location to perform on-demand restore of applications from backup.

One or more Azure Stack Hub clouds can be deployed to a datacenter. To survive a catastrophic disaster, deploying at least one Azure Stack Hub cloud in a different datacenter ensures that you can failover workloads and minimize unplanned downtime. If you only have one Azure Stack Hub, you should consider using the Azure public cloud as your recovery cloud. The determination of where your application can run will be determined by government regulations, corporate policies, and stringent latency requirements. You have the flexibility to determine the appropriate recovery location per application. For example, you can have applications in one subscription backing up data to another datacenter and in another subscription, replicating data to the Azure public cloud.

## Application recovery objectives

Application owners are primarily responsible for determining the amount of downtime and data loss that the application and the organization can tolerate. By quantifying acceptable downtime and acceptable data loss, you can create a recovery plan that minimizes the impact of a disaster on your organization. For each application, consider the following:

 - **Recovery time objective (RTO)**  
RTO is the maximum acceptable time that an app can be unavailable after an incident. For example, an RTO of 90 minutes means that you must be able to restore the app to a running state within 90 minutes from the start of a disaster. If you have a low RTO, you might keep a second deployment continually running on standby to protect against a regional outage.
 - **Recovery point objective (RPO)**  
RPO is the maximum duration of data loss that is acceptable during a disaster. For example, if you store data in a single database which is backed up hourly and has no replication to other databases, you could lose up to an hour of data.

Another metric is *Mean Time to Recover* (MTTR), which is the average time that it takes to restore the application after a failure. MTTR is an empirical value for a system. If MTTR exceeds the RTO, then a failure in the system causes an unacceptable business disruption because it won't be possible to restore the system within the defined RTO.

## Protection options 

### Backup-restore

The most common protection scheme for VM-based applications is to protect the entire system using disk snapshots, or install an agent in the guest operating system.

::: moniker range="azs-2002"
### Disk snapshots

For VMs with managed disks, you can create a crash-consistent snapshot of each disk attached to a VM without interrupting the workload in the running VM, using the portal or PowerShell in the same way as in Azure.

For VMs with unmanaged disks, you can create a crash-consistent snapshot of each page blob using REST APIs. See [storage considerations](azure-stack-acs-differences.md) for instructions on how to make an asynchronous call to the API required for taking a snapshot of unmanaged disks attached to a running VM. This is not required if the VM is powered off.

::: moniker-end

::: moniker range="<=azs-1910"
### Disk snapshots
For VMs with managed or unmanaged disks, you can create a snapshot of each disk attached to a VM while the VM is powered off using REST APIs. 

Creating snapshots of managed or unmanaged disk snapshots attached to a running VM is not recommended. Make sure you update to 2002 before snapshotting disks attached to a running VM.

::: moniker-end

Recovering a VM from snapshots requires that you first create a copy of the snapshot to use a new disk. The new disk can then be attached to a new VM. 

The recommended approach is to use a backup solution from one of the Azure Stack Hub partners that supports disk snapshot for backup. These solutions orchestrate recovering the VM from the disk snapshots. 

### Guest agent

Backing up a VM using a guest OS agent typically includes capturing operating system configuration, files/folders, disks, application binaries, or application data. 

Recovering an application from an agent requires manually recreating the VM, installing the operating system, and installation of the guest agent. At that point, data can be restored into the guest OS or directly to the application.

### VMs in a scale-set or availability group

VMs in a scale set or availability group that are considered ephemeral resources should not be backed up at the VM level, especially if the application is stateless. For stateful applications deployed in a scale-set or availability group, consider protecting the application data (for example, a database or volume in a storage pool). 

### Replication/manual failover

For applications that require minimal data loss or minimal downtime, data replication can be enabled at the guest OS or application level to replicate data to another location. Some applications, such as Microsoft SQL Server, natively support replication. If the application does not support replication, you can use software in the guest OS to replicate disks, or a partner solution that installs as an agent in the guest OS.

With this approach, the application is deployed in one cloud and the data is replicated to the other cloud on-premises or to Azure. When a failover is triggered, the application in the target will need to be started and attached to the replicated data before it can start servicing requests.
 
### High availability/automatic failover

For stateless applications that can only tolerate a few seconds or minutes of downtime, consider a high-availability configuration. High-availability applications are designed to be deployed in multiple locations in an active/active topology where all instances can service requests. For local hardware faults, the Azure Stack Hub infrastructure implements high availability in the physical network using two top of rack switches. For compute-level faults, Azure Stack Hub uses multiple nodes in a scale unit. At the VM level, you can use scale sets in combination with fault domains to ensure node failures don't take down your application. The same application would need to be deployed to a secondary location in the same configuration. To make the application active/active, a load balancer or DNS can be used to direct requests to all available instances.

### No recovery

Some apps in your environment may not need protection against unplanned downtime or data loss. For example, VMs used for development and testing typically do not need to be recovered. It's your decision to do without protection for an application or dataset.

## Recommended topologies

Important considerations for your Azure Stack Hub deployment:

|     | Recommendation | Comments |
|-------------------------------------------------------------------------------------------------|-----------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Backup/restore VMs to an external backup target already deployed in your datacenter | Recommended | Take advantage of existing backup infrastructure and operational skills. Make sure to size the backup infrastructure so it's ready to protect the additional VM instances. Make sure backup infrastructure isn't in close proximity to your source. You can restore VMs to the source Azure Stack Hub, to a secondary Azure Stack Hub instance, or Azure. |
| Backup/restore VMs to an external backup target dedicated to Azure Stack Hub | Recommended | You can purchase new backup infrastructure or provision dedicated backup infrastructure for Azure Stack Hub. Make sure backup infrastructure isn't in close proximity to your source. You can restore VMs to the source Azure Stack Hub, to a secondary Azure Stack Hub instance, or Azure. |
| Backup/restore VMs directly to global Azure or a trusted service provider | Recommended | As long as you can meet your data privacy and regulatory requirements, you can store your backups in global Azure or a trusted service provider. Ideally the service provider is also running Azure Stack Hub so you get consistency in operational experience when you restore. |
| Replicate/failover VMs to a separate Azure Stack Hub instance | Recommended | In the failover case, you need to have a second Azure Stack Hub cloud fully operational so you can avoid extended app downtime. |
| Replicate/failover VMs directly to Azure or a trusted service provider | Recommended | As long as you can meet your data privacy and regulatory requirements, you can replicate your data to global Azure or a trusted service provider. Ideally the service provider is also running Azure Stack Hub so you get consistency in operational experience after failover. |
| Deploy a backup target on the same Azure Stack Hub that also hosts all the applications protected by the same backup target. | Stand-alone target: Not recommended </br> Target that replicates backup data externally: Recommended | If you choose to deploy a backup appliance on Azure Stack Hub (for the purposes of optimizing operational restore), you must ensure all data is continuously copied to an external backup location. |
| Deploy physical backup appliance into the same rack where the Azure Stack Hub solution is installed | Not supported | Currently, you can't connect any other devices to the top of rack switches that aren't part of the original solution. |

## Next steps

This article provided general guidelines for protecting user VMs deployed on Azure Stack Hub. For information about using Azure services to protect user VMs, refer to:

- [Azure Stack IaaS – part four – Protect Your Stuff](https://azure.microsoft.com/blog/azure-stack-iaas-part-four/)
- [Considerations for business continuity and disaster recovery](https://aka.ms/azurestackbcdrconsiderationswp)

### Azure Backup Server
 - [Use Azure Backup to back up files and apps on Azure Stack Hub](https://docs.microsoft.com/azure/backup/backup-mabs-files-applications-azure-stack)
 - [Azure Backup Server support for Azure Stack Hub](https://docs.microsoft.com/azure/backup/ ) 
 
 ### Azure Site Recovery
 - [Azure Site Recovery support for Azure Stack Hub](https://docs.microsoft.com/azure/site-recovery/)  
 
 ### Partner products
 - [Azure Stack Hub Datacenter Integration Partner Ecosystem datasheet](https://aka.ms/azurestackbcdrpartners)
