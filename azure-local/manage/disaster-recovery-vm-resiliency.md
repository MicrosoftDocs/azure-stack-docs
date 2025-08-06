---
title: Virtual machine resiliency for Azure Local
description: Virtual machine resiliency considerations for Azure Local.
ms.topic: article
author: sipastak
ms.author: sipastak
ms.date: 07/24/2025
---

# Virtual machine resiliency for Azure Local

After establishing resilient hardware with optimal configuration at the operating system level, it's essential to focus on virtual machine (VM) resiliency, which is fundamental to maintaining continuous operations for business-critical applications.  

All virtual machines deployed on Azure Local are highly available by default, ensuring that if any node in the cluster fails, the affected VMs will automatically restart and continue operating on the remaining nodes. However, even with these robust fault tolerance and resiliency measures in place, this alone isn't sufficient. To avoid service disruption or data loss that can’t be addressed by local redundancy alone, it’s important to consider a combination of comprehensive backup strategies with continuous data replication technologies. Backup strategies safeguard against data corruption, accidental or malicious data deletion, and catastrophic events, enabling restoration of data to a previous state if necessary. Meanwhile, replication provides synchronized copies of VMs data across multiple Azure Local instances clusters and/or Azure, ensuring minimal downtime and rapid failover in the event of hardware or system failure. Together, these create a robust safety net that protects data and maintains operational and business continuity during unforeseen disruptions.

## Backup Tools

### Microsoft Azure Backup Server

[Microsoft Azure Backup Server](/azure/backup/backup-azure-microsoft-azure-backup) (MABS), an evolution of System Center Data Protection Manager, is a Microsoft backup solution that can be effectively used to protect Azure Local VMs. MABS offers a hybrid backup approach, providing short-term retention on local disk storage for fast operational recoveries and long-term retention through integration with Azure Backup services, allowing backups to be vaulted offsite to an Azure Recovery Services vault.  

If you're using MABS, there are two approaches to protect VMs: **host-level VM backup** and **guest-level VM backup**.

- **Host-level VM backup**: Install the backup agent on each Azure Local host (each cluster node) and back up entire VMs at the hypervisor level. This captures the whole VM (all virtual disks). It has the advantage of not requiring an agent inside each VM, and its agnostic to the guest OS. Host-level backups allow full VM restores, where you can recover an entire VM to the same or different cluster. However, host-level backups aren't application-aware. For example, they won't truncate SQL logs or guarantee application-consistent restores beyond what Volume Shadow Copy Service (VSS) provides.

- **Guest-level VM backup**: Install backup agents inside the guest OS of the VM. This allows application-consistent backups for VSS-aware applications running within the operating system, ensuring that application data is captured in a consistent state. For example, you can back up SQL databases with full fidelity and restore individual items like a single database or a specific file easily. The trade-off is manageability: you must manage agents on each VM, and the backup only covers what’s inside the VM, to restore the whole VM, you’d typically rebuild it and then restore data within.  

- **Use both**: Many organizations use a combination, guest-level backups for critical applications that need point-in-time or item-level recovery like restoring a single database or a file without rolling back the whole VM, plus host-level backups for fast recovery of entire VMs or to recover from host failure scenarios.

Setting up MABS involves deploying the MABS server software on a dedicated VM on the cluster, configuring its local storage, installing protection agents on the Azure Local hosts and/or guests, and then creating protection groups with the VMs you want to protect. Protection groups define what is backed up (for example, specific VMs), the backup schedule, short-term and long-term retention policies on local disk or Azure. For more information on installing MABS for Azure Local VMs, see [Back up Azure Local virtual machines with Azure Backup Server](/%20azure/backup/back-up-azure-stack-hyperconverged-infrastructure-virtual-machines).

### Partner backup solutions

Beyond MABS, a mature market of partner backup and recovery vendors offers robust solutions for Azure Local environments. These solutions often provide a rich set of advanced features, broader platform support, and different licensing or cost models that might be attractive depending on specific organizational requirements.  

#### Commvault

Commvault Cloud offers unified, enterprise-grade data protection for Azure Local environments, enabling secure backup, recovery, and ransomware protection across virtual machines, databases, and unstructured data. With intelligent automation and policy-driven workflows, Commvault simplifies compliance, improves resiliency, and delivers scalable protection from edge to cloud, all while maintaining full control of your data within your Azure Local region.

- [Commvault Azure Local support](https://documentation.commvault.com/2024e/essential/azure_local.html)
- [Commvault auto recovery](https://documentation.commvault.com/2024e/essential/azure_local_auto_recovery.html)

#### Rubrik

Rubrik Security Cloud delivers comprehensive data protection and security for virtual machines deployed in Azure Local environments. Rubrik performs a first full and forever incremental set of backups, ensuring data protection with immutable, air-gapped, and access-controlled copies. Through a unified SaaS control plane, organizations can manage data from their Azure Local environments, providing a single view into critical data assets. This integration also enables continuous threat monitoring, threat hunting, anomaly detection, and facilitates rapid cyber recovery, allowing for quick restoration of VMs and applications to a clean state following an attack.

- [Azure Local Protection Datasheet](https://www.rubrik.com/content/dam/rubrik/en/resources/data-sheet/ds-rubrik-for-microsoft-hyper-v-and-azure-stack-hci.pdf)
- [Rubrik Data Protection](https://www.rubrik.com/products/data-protection?icid=2022-07-11_MJND3NC6KI)
- [Data Threat Analytics](https://www.rubrik.com/products/data-threat-analytics)
- [Mass Recovery](https://www.rubrik.com/products/mass-recovery)

#### Veeam

Veeam backup and replication supports backup and replication of Azure Local VMs. With Veeam Backup and Replication it's possible to migrate workloads from different platforms or from Hyper-V to Azure Local. Cross-platform restore can be performed using Instant VM Recovery. You can also replicate workloads from older versions of Hyper-V to Azure Local.

- [Veeam Azure Marketplace](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/veeam.veeam-backup-replication?tab=overview )
- [Veeam Azure Local support](https://www.veeam.com/kb4047)
- [Veeem Supported Platforms](https://helpcenter.veeam.com/docs/backup/hyperv/platform_support.html)

## Backup frequency, retention, and restoration testing

Even with hardware fault tolerance and Storage Spaces Direct maintaining multiple copies of data, implementing and regularly testing data backup processes is essential. Storage redundancy protects against infrastructure failures, but it doesn't prevent data corruption, deletion, or site-wide disasters. Regular backups ensure you can restore data or entire VMs to a previous point in time if needed.

- **Backup frequency and retention**: Ensure that your backup frequency aligns with your Recovery Point Objective (RPO), which defines the maximum acceptable amount of data loss for your organization. Depending on the importance of a virtual machine to the business, schedule nightly backups or multiple backups per day if necessary, using incremental backups. Additionally, implement a retention policy that aligns with business and compliance requirements (for example, retain daily backups for two weeks, monthly backups for six months, yearly backups for seven years). Azure Backup, through the Microsoft Azure Backup Server (MABS), can facilitate both short-term on-premises retention and long-term cloud-based retention. 

- **Testing restores**: A backup is only as good as your ability to restore it, so it's important to regularly test restoration of VMs and data from backups. Periodically perform a full VM recovery test to an isolated network or a lab cluster to ensure the process is smooth and timely. This practice is part of disaster recovery strategy to guarantee that backups serve their purpose in an actual emergency.

## Use Hyper-V Replica for continuous replication of business-critical VMs

While backups protect data and enable point-in-time recovery, they don't offer immediate failover capabilities, restoring from a backup can be time-consuming, often taking hours. For business or mission-critical VMs where even minimal downtime or data loss is unacceptable, continuous replication technologies provide a mechanism to maintain an up-to-date copy of VMs at a secondary location, enabling rapid failover and minimal data loss in the event of a disaster.

Hyper-V Replica is a feature built into Azure Stack HCI operating system that enables asynchronous replication of VMs between two Hyper-V hosts or failover clusters. This technology can be utilized to replicate VMs between two separate Azure Local clusters, providing an on-premises disaster recovery solution.

### Functionality

When Hyper-V Replica is enabled for a VM, an initial copy of the VM (including its configuration and VHDs) is created on a designated replica server or cluster. Subsequently, changes made to the primary VM are tracked and written to log files. These logs are then transmitted to the replica site and applied to the replica VM asynchronously, based on a configurable replication frequency (for example, every 30 seconds, 5 minutes, or 15 minutes).  

Configuration involves enabling the Azure Local clusters to act as replica servers, setting up authentication methods (typically Kerberos within a domain, or certificate-based for non-domain joined or cross-domain scenarios), configuring firewall rules to allow replication traffic, and then enabling replication on a per-VM basis. Per-VM settings include specifying the replica server/cluster, selecting the VHDs to replicate, choosing the replication frequency, and defining how many recovery points (snapshots in time) to maintain on the replica side. Hyper-V Replica supports replication, test failover, failover, reverse replication, and failback for both planned and unplanned scenarios.

### Configuration

 Hyper-V Replica needs to be configured using PowerShell on Azure Local nodes, or it can be set up remotely via the Failover Cluster Manager user interface on any Windows Server machine within the same network (as the Azure Local instances). It requires appropriate permissions to connect and administer both Azure Local machines. There's no option to configure Hyper-V Replica from the Azure portal.

For more information, see the deployment steps in [Set up Hyper-V Replica](/windows-server/virtualization/hyper-v/manage/set-up-hyper-v-replica).
  
### Network and performance considerations

During the replication process, the hardware and network you use affects the services that rely on them. Depending on the amount of data replicated between the source and target systems, this process consumes a large amount of system resources. Your device performance is impacted until this process completes. Adequate network bandwidth is required between the two Azure Local clusters for Hyper-V replica to function optimally, especially with lower replication intervals (for example, 30 seconds). Similarly, the target cluster needs sufficient storage IOPS to keep up with incoming replication traffic. For more information, see [Feature and performance optimization of Hyper-V Replica (HVR)](/troubleshoot/windows-server/virtualization/feature-performance-optimization-hyper-v-replica).

## Recovery plans and testing

It's essential to have a recovery plan where you document all the steps required to fail over workloads, including the sequence (for example, domain controllers should be activated before application servers), and any necessary network adjustments (such as DNS updates and user redirection). Hyper-V Replica enables the creation of recovery plans, allowing for the sequencing of VM groups and the inclusion of scripts as part of the failover process. These plans can be manual or scripted via PowerShell.  

It's important to regularly test the disaster recovery plan through simulated drills. Conducting a test failover at least once a month is recommended to ensure functionality and maintain staff proficiency. Additionally, testing reveals if your RTOs are being met, such as the time required to spin up in Azure or on secondary hardware.
