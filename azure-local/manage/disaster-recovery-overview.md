---
title: Disaster recovery for Azure Local virtual machines
description: Disaster recovery considerations for Azure Local virtual machines.
ms.topic: article
author: sipastak
ms.author: sipastak
ms.date: 08/14/2025
---

# Disaster recovery for Azure Local virtual machines

Disaster recovery planning is strategic for any organization using IT infrastructure, and its importance is magnified in hybrid environments that use Azure Local. Ensuring business systems and services are resilient and can recover from disruptions, ranging from localized hardware failures to site-wide disasters, is vital for maintaining business operations, safeguarding data, and preserving trust.  

For Azure Local instance deployments that blend edge infrastructure with Azure cloud services a carefully planned and complete disaster recovery strategy shouldn't be a static document or a one-time implementation. Instead, it should be a dynamic and continuous lifecycle improvement process, designed to adapt and evolve to changing business needs and threat landscapes. To learn more about creating a robust disaster recovery strategy for your business systems and infrastructure, see [Azure’s Reliability design principles](/azure/well-architected/reliability/principles).  

 Azure Local integrates familiar technologies (Hyper-V, Failover Clustering, Storage Spaces Direct) and Azure services (Backup, Site Recovery, etc.) that provide robust disaster recovery capabilities. In the context of Azure Local, a well-defined, documented, and tested disaster recovery strategy is critical for ensuring that workloads hosted on-premises remain online and available in the event of any planned or unplanned outage, such as hardware or power failures, network issues, or site-level disasters.

Because Azure Local VMs are deployed and run on an Azure Local instance, we need to start from the ground up - covering physical infrastructure resiliency, strategies for VMs (backups, continuous replication), and cover workloads, such as Azure Virtual Desktop and Arc-Enabled SQL Server. To learn more about implementing strategies for each of these categories, see:

- [Infrastructure resiliency](disaster-recovery-infrastructure-resiliency.md)
- [Virtual machine resiliency](disaster-recovery-vm-resiliency.md)
- [Workloads on Azure Local VMs](disaster-recovery-workloads.md)


## Next steps

- Learn more about [Infrastructure resiliency](disaster-recovery-infrastructure-resiliency.md).
