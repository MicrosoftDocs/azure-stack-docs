---
title: Protect VMs deployed on Azure Stack | Microsoft Docs
description: Learn how to build a recovery plan to protect VMs deployed on Azure Stack against data loss and unplanned downtime.
services: azure-stack
documentationcenter: ''
author: sethmanheim
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: tzl
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: conceptual
ms.date: 02/16/2021
ms.author: sethm
ms.reviewer: hectorl
ms.lastreviewed: 3/19/2018
---

# Protect VMs deployed on Azure Stack Hub - Ruggedized

Use this article as a guide to develop a plan for protecting virtual machines (VMs) that your users deploy on Azure Stack Hub.

To protect against data loss and unplanned downtime, implement a data protection and disaster recovery plan for VM-based applications on Azure Stack Hub. The protection plan implemented will depend on business requirements and design of the application. This plan should follow the framework established by your organization\'s comprehensive business continuity and disaster recovery (BC/DR) strategy. For a high level overview of the BC/DR considerations for Azure Stack Hub, see [Azure Stack: Considerations for business continuity and disaster recovery](https://azure.microsoft.com/resources/azure-stack-considerations-for-business-continuity-and-disaster-recovery/).

## Application recovery objectives

Determine the amount of downtime and data loss your organization can tolerate for each application. By quantifying downtime and data loss, you can create a recovery plan that minimizes the impact of a disaster on your organization. For each application, consider:

- **Recovery time objective (RTO)**\
    RTO is the maximum acceptable time that an app can be unavailable after an incident. For example, an RTO of 90 minutes means that you must be able to restore the app to a running state within 90 minutes from the start of a disaster. If you have a low RTO, you might keep a second deployment continually running on standby to protect against a regional outage.

- **Recovery point objective (RPO)**\
    RPO is the maximum duration of data loss that is acceptable during a disaster. For example, if you store data in a single database which is backed up hourly and has no replication to other databases, you could lose up to an hour of data.

Conduct an assessment to define the RTO and RPO for each application.

Another important metric to consider is **Mean Time to Recover** (MTTR), which is the average time that it takes to restore the application after a failure. MTTR is an empirical value for a system. If MTTR exceeds the RTO, then a failure in the system will cause an unacceptable business disruption because it won\'t be possible to restore the system within the defined RTO.

## Protection options for IaaS VMs

### Backup-restore

The most common protection scheme for VM-based apps is to use backup software. Backing up a VM typically includes the operating system, operating system configuration, application binaries, and persistent application data contained inside the VM. The backups are created by using an agent in the guest OS to capture application, OS, or file system/volumes. Another approach is agent-less by relying on integration with Azure Stack Hub APIs to read information about the VM configuration and snapshot the disks attached to the VM. Please note that Azure Stack Hub does not support backing up directly from the hypervisor.

### Planning your backup strategy

Planning your backup strategy and defining scale requirements starts with quantifying the number of VM instances that need to be protected. Backing up all VMs in the system may not be the most effective way to protect application. With Azure Stack Hub, VMs in a scale-set or availability set should not be backed up at the VM level. These VMs are considered ephemeral since the set of VMs can be scaled-in or out. Ideally any data that needs to be persisted is in a separate repository such as a database or object store. If the applications deployed in a scale-out architecture contains data that must be persisted and protected, then that will require application level backup using native capabilities provided by the application or by relying on an agent.

Important considerations for backing up VMs on Azure Stack:

- **Categorization**
  - Consider a model where users opt into VM backup.
  - Define a recovery service level agreement (SLA) based on the priority of the applications or the impact to the business.
- **Scale**
  - Consider staggered backups when on-boarding a large number of new VMs (if backup is required).
  - Evaluate backup products that can efficiently capture and transmit backup data to minimize resource content on the solution.
  - Evaluate backup products that efficiently store backup data using incremental or differential backups to minimize the need for full backups across all VMs in the environment.
- **Restore**
  - Backup products can restore virtual disks, app data within an existing VM, or the entire VM resource and associated virtual disks. The restore scheme you need depends on how you plan to restore the app. For example, it may be easier to redeploy SQL server from a template and then restore the databases instead of restoring the entire VM or set of VMs.

### Replication/manual failover

An alternate approach to supporting recovery is to replicate data to another environment. The data can be scoped to the application like database replication or to the operating system in the guest OS using an agent, or at the VM level by integrating with Azure Stack Hub APIs. In the event of a disaster, failover to the secondary location is required. The failover can be handled natively by the application like with SQL Availability Groups or at the guest OS level using agents or cluster technology, or at the VM level using a protection product.

### High availability/automatic failover

Applications that natively support high availability or rely on cluster software to achieve high availability across nodes can be deployed across a group of VMs in one Azure Stack Hub or across multiple Azure Stack Hub instances. In all cases, some level of load balancing is required to ensure application traffic is routed correctly. In this configuration, the application can automatically recover from faults. For local hardware faults, Azure Stack Hub infrastructure implements high availability and fault tolerance in the physical infrastructure. For compute level faults, Azure Stack Hub uses multiple nodes in a scale unit in an N-1 configuration. At the VM level, availability and scale sets model each node in the scale-unit as a fault domain to guarantee node-level anti-affinity so node failures do not take down a distributed application.

### No protection

Some applications may not have data that needs to be persisted. For example, VMs used for development and testing typically don\'t need to be recovered. Another example is a stateless application that can be re-deployed from a CI/CD pipeline in the event of a failure. It is important to identify the applications that do not require protection to avoid unnecessarily protecting VMs.

<!-- ## Recommended topologies

Important considerations for your Azure Stack deployment: -->

## Next steps

This article provided general guidelines for protecting user VMs deployed on Azure Stack. For information about using Azure services to protect user VMs, refer to:

- [Considerations for business continuity and disaster recovery](https://azure.microsoft.com/resources/azure-stack-considerations-for-business-continuity-and-disaster-recovery/)

### Partner products

- [Azure Stack Datacenter Integration Partner Ecosystem datasheet](https://azure.microsoft.com/resources/azure-stack-datacenter-integration-partners/)
- To learn more about the partner products that offer VM protection on Azure Stack, see [Protecting apps and data on Azure Stack](https://azure.microsoft.com/blog/protecting-applications-and-data-on-azure-stack/).
