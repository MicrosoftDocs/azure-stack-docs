---
title: Virtual Machine Resiliency for Azure Local
description: Virtual machine resiliency considerations for Azure Local.
ms.topic: article
author: sipastak
ms.author: sipastak
ms.date: 10/16/2025
---

# Virtual machine resiliency for Azure Local

After reviewing and implementing the design considerations for [infrastructure resiliency](disaster-recovery-infrastructure-resiliency.md) at the platform level, it's essential to understand how your virtual machines (VMs) and applications will be resilient to failures, to enable them to detect, withstand, and recover from failures within an acceptable time period, which is fundamental to maintaining continuous operations for business-critical applications.

All virtual machines deployed on Azure Local are highly available by default, ensuring that if any physical node in the cluster fails, the VMs running on the affected node are automatically restarted and to continue operate on the remaining nodes, (_when sufficient compute capacity is available_). However, even with these robust platform fault tolerance and resiliency measures in place, the workload and applications running in your VMs should be well-architected.

Well-architected applications have reliability capabilities implemented in application code, infrastructure, and operations. For example, it is critical to deploy multiple instances of workload services using two or more Azure Local VMs, to remove any single points of failure (SPoF) at the application layer. This helps prevent or minimize downtime when failure of a singe instance of the application fails, see [workload resiliency](disaster-recovery-workloads-resiliency.md) for further information. Well-architected applications should also have appropriate business continuity and disaster recovery (BC/DR) controls in place, such as regular backups and validation that disaster recovery failover processes work as expected.

Review [Azure Well-Architected Framework (WAF) Reliability design principles](/azure/well-architected/reliability/principles) for recommendations to improve your workload application(s) resiliency design.

To avoid service disruption or data loss that can’t be addressed by local redundancy alone, it’s important to consider a combination of comprehensive backup strategies with continuous data replication technologies. Backup strategies safeguard against data corruption, accidental or malicious data deletion, and catastrophic events, enabling restoration of data to a previous state if necessary. Meanwhile, replication provides synchronized copies of VMs data across multiple Azure Local instances clusters and/or Azure, ensuring minimal downtime and rapid failover in the event of hardware or system failure. Together, these create a robust safety net that protects data and maintains operational and business continuity during unforeseen disruptions.

## Storage path (volumes) considerations

Azure Local instances deployed using the default "_express storage_" configuration, will have a 'UserStorage_X' cluster shared volumes (CSVs) created, one per physical node in the cluster, and an associated Storage Path resource created in Azure for each volume. The storage path resource in Azure is used by workload resources, such as Azure Local VMs, AKS Arc clusters and to store VM images. For example, a CSV with the local file system path of `C:\ClusterStorage\UserStorage_1\`, will have a storage path resource created in the Azure, that represents the volume to enable Azure Local VMs virtual hard disks (VHD/Xs) to be placed on the volume. For more information see [about storage paths](/azure/azure-local/manage/create-storage-path#about-storage-path).

When deploying well-architected applications use have multiple Azure Local VMs to provide increased workload resiliency, it is recommended that each VMs virtual hard disk drives (VHD/Xs) files are stored using a different storage paths (_where possible depending on the size of the cluster_) to maximize resiliency. For example, the VHDs of each Azure Local VM should be deployed using a different storage path (_compared to other VMs that host instances the same service_), to help prevent a situation where all Azure Local VMs hosting instances of the same application or service are using a single storage path, that maps to a single volume. When creating multiple Azure Local VMs in a single deployment, using automation, storage paths are selected using round-robin to even distribute workload VHDs across volumes. If you would like additional control when provisioning Azure Local VMs, it is possible to specify the [--storage-path-id] parameter during deployment, to target a specific / different storage paths and volume.

## Backup Tools

### Microsoft Azure Backup Server

[Microsoft Azure Backup Server](/azure/backup/backup-azure-microsoft-azure-backup) (MABS), an evolution of System Center Data Protection Manager, is a Microsoft backup solution that can be effectively used to protect Azure Local VMs. MABS offers a hybrid backup approach, providing short-term retention on local disk storage for fast operational recoveries and long-term retention through integration with Azure Backup services, allowing backups to be vaulted offsite to an Azure Recovery Services vault.  

If you're using MABS, there are two approaches to protect VMs: **host-level VM backup** and **guest-level VM backup**.

- **Host-level VM backup**: Install the backup agent on each Azure Local host (each cluster node) and back up entire VMs at the hypervisor level. This captures the whole VM (all virtual disks). It has the advantage of not requiring an agent inside each VM, and its agnostic to the guest OS. Host-level backups allow full VM restores, where you can recover an entire VM to the same or different cluster. However, host-level backups aren't application-aware. For example, they won't truncate SQL logs or guarantee application-consistent restores beyond what Volume Shadow Copy Service (VSS) provides.

    > [!NOTE]
    >- Restoring an Azure Local VM on a different cluster restores the VM as an unmanaged VM. This means that all services inside the VM will start working, but the VM can’t be managed from Azure until it's registered on the new Azure Local cluster and reconnected to its resource that exists in Azure.
    >- Reconnecting means the Azure resource will be updated with the new resource group (optional, you can also keep it in the same resource group), custom location, storage path, and logical network of the VM.
    >- If the VM is restored in-place on the same cluster, registering and reconnecting aren't needed. The VM’s Azure connection will be restored, and it continues to be managed from Azure as long as it's within [Azure Arc’s 45-day reconnection window](/azure/azure-arc/servers/overview#agent-status).

- **Guest-level VM backup**: Install backup agents inside the guest OS of the VM. This allows application-consistent backups for VSS-aware applications running within the operating system, ensuring that application data is captured in a consistent state. For example, you can back up SQL databases with full fidelity and restore individual items like a single database or a specific file easily. The trade-off is manageability: you must manage agents on each VM, and the backup only covers what’s inside the VM, to restore the whole VM, you’d typically rebuild it and then restore data within.  

- **Use both**: Many organizations use a combination, guest-level backups for critical applications that need point-in-time or item-level recovery like restoring a single database or a file without rolling back the whole VM, plus host-level backups for fast recovery of entire VMs or to recover from host failure scenarios.

Setting up MABS involves deploying the MABS server software on a dedicated VM on the cluster, configuring its local storage, installing protection agents on the Azure Local hosts and/or guests, and then creating protection groups with the VMs you want to protect. Protection groups define what is backed up (for example, specific VMs), the backup schedule, short-term and long-term retention policies on local disk or Azure. For more information on installing MABS for Azure Local VMs, see [Back up Azure Local virtual machines with Azure Backup Server](/azure/backup/back-up-azure-stack-hyperconverged-infrastructure-virtual-machines).


|Attribute  |Host-level VM backup |Guest-level VM backup |
|---------|---------|---------|
|Requires agent in the guest OS    |  No     |  Yes    |
|Requires agent in all nodes of the cluster      | Yes   |    No     |
|Agnostic to guest OS     |   Yes      |     No    |
|Application aware    |  No       |     Yes    |
|Backup   |    The whole VM and disks     |   Applications and files (application-consistent backups that are VSS aware)       |
|Restore   |   Whole VM      |   App data and individual files      |
|Restore VM to the same cluster    |    Yes     |   Not applicable      |
|Restore VM to an alternate cluster     |    Yes     |   Not applicable      |


### Partner backup solutions

Beyond MABS, a mature market of partner backup and recovery vendors offers robust solutions for Azure Local environments. These solutions often provide a rich set of advanced features, broader platform support, and different licensing or cost models that might be attractive depending on specific organizational requirements.  

#### Commvault

Commvault Cloud offers unified, enterprise-grade data protection for Azure Local environments, enabling secure backup, recovery, and ransomware protection across virtual machines, databases, and unstructured data. With intelligent automation and policy-driven workflows, Commvault simplifies compliance, improves resiliency, and delivers scalable protection from edge to cloud, all while maintaining full control of your data within your Azure Local region.

For more information, visit the official Commvault documentation site for guidance on Commvault for Azure Local.

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

#### CloudCasa by Catalogic

CloudCasa delivers Kubernetes-native backup, disaster recovery, and migration for AKS on Azure Local and Arc-enabled clusters. It protects cluster resources and persistent volumes, with the ability to perform granular restores, including file-level recovery. Backups can be stored in Azure Blob Storage, other object storage, or NFS. CloudCasa supports restores to the same site, a secondary Azure Local cluster, or Azure AKS for disaster recovery.

- [CloudCasa on Azure Marketplace](https://azuremarketplace.microsoft.com/marketplace/apps?search=cloudcasa)
- [CloudCasa solutions for Azure](https://cloudcasa.io/partners/microsoft-azure/)
- [Simplify Upgrades and Backup for Azure Local](https://cloudcasa.io/blog/upgrade-backup-azure-local/)

### Backup frequency, retention, and restoration testing

Even with hardware fault tolerance and Storage Spaces Direct maintaining multiple copies of data, implementing and regularly testing data backup processes is essential. Storage redundancy protects against infrastructure failures, but it doesn't prevent data corruption, deletion, or site-wide disasters. Regular backups ensure you can restore data or entire VMs to a previous point in time if needed.

- **Backup frequency and retention**: Ensure that your backup frequency aligns with your Recovery Point Objective (RPO), which defines the maximum acceptable amount of data loss for your organization. Depending on the importance of a virtual machine to the business, schedule nightly backups or multiple backups per day if necessary, using incremental backups. Additionally, implement a retention policy that aligns with business and compliance requirements (for example, retain daily backups for two weeks, monthly backups for six months, yearly backups for seven years). Azure Backup, through the Microsoft Azure Backup Server (MABS), can facilitate both short-term on-premises retention and long-term cloud-based retention. 

- **Testing restores**: A backup is only as good as your ability to restore it, so it's important to regularly test restoration of VMs and data from backups. Periodically perform a full VM recovery test to an isolated network or a lab cluster to ensure the process is smooth and timely. This practice is part of disaster recovery strategy to guarantee that backups serve their purpose in an actual emergency.


## Continuous replication of business-critical VMs 

While backups protect data and enable point-in-time recovery, they don't offer immediate failover capabilities, restoring from a backup can be time-consuming, often taking hours. For business or mission-critical VMs where even minimal downtime or data loss is unacceptable, continuous replication technologies provide a mechanism to maintain an up-to-date copy of VMs at a secondary location, enabling rapid failover and minimal data loss in the event of a disaster. Two continuous replication technologies Azure Local supports are Azure Site Recovery and Hyper-V Replica.

### Use Azure Site Recovery to replicate Azure Local VMs to Azure

Azure Site Recovery is Microsoft's cloud-based disaster recovery solution designed to replicate on-premises VMs to Azure. Azure Site Recovery facilitates the replication of Azure local VMs into Azure, ensuring the protection of business-critical workloads. This service continuously transmits changes from your on-premises VMs to Azure. As a result, in the event of a significant outage at your local site or cluster, the VM can be failed over to Azure to maintain operational continuity.

Key points about Azure Site Recovery for Azure Local:

- **Deployment**:
    - Automated deployment: Azure Local created an extension to Azure Site Recovery for automated deployment. Azure Site Recovery extension can detect all the nodes of the cluster and deploy Azure Site Recovery on all nodes automatically and configure them with the replication policy. For more information, see [Protect VM workloads with Azure Site Recovery](azure-site-recovery.md#step-1-prepare-infrastructure-on-your-target-host).
    - Manual deployment: Azure Site Recovery extension for Azure Local is in preview and only applicable to test environments, for those customers that need a production ready solution, Azure Site Recovery can be configured manually on Azure Local cluster using the [Hyper-V to Azure disaster recovery](/azure/site-recovery/hyper-v-azure-architecture) option.  

- **Frequent replication**: Azure Site Recovery can achieve Recovery Point Objectives (RPOs) as low as 30 seconds.

- **Failover**:
    - Once replication is in place, you can initiate a Failover to Azure. This essentially brings up the VM in Azure using the replicated data. You can test this with a Test Failover, which creates a copy in Azure on an isolated network for verification without shutting down on-premises VMs. 
    - During an actual disaster, if the primary site is down unexpectedly, you would do an Unplanned Failover even if the source VM isn't running. 
    - For scenarios such as hardware maintenance or replacement, you can initiate a Planned Failover. This will gracefully shut down the VM so that it can commit its memory to disk to ensure zero data loss. 
    - After failover, your VM runs in Azure.  

- **Failback**:
    - When the disaster is mitigated, and the cluster is operational, Azure Site Recovery can reverse the replication direction and replicate any changes made while operating in Azure back to your Azure Local cluster. After reverse replication you can fail back the VM, allowing operations to switch back to on-premises. 
    - For successful failback, the on-premises environment must be healthy. If your cluster isn't available, you can register another Azure Local cluster to the Azure Site Recovery Hyper-V site and failback the VM to a node on an alternate cluster.

    > [!NOTE]
    >- Failing back an Azure Local VM on an alternate cluster will fail back the VM as an unmanaged VM. This means that all services inside the VM will start working, but the VM can’t be managed from Azure until it's registered on the new Azure Local cluster and reconnected to its resource that exists in Azure.
    >- Reconnecting means the Azure resource will be updated with the new resource group (optional, you can also keep it in the same resource group), custom location, storage path, and logical network of the VM.
    >- If the VM is failed back on the same cluster, registering and reconnecting aren't needed. The VM’s Azure connection will be restored, and it continues to be managed from Azure as long as it's within [Azure Arc’s 45-day reconnection window](/azure/azure-arc/servers/overview#agent-status).


For more information and to install Azure Site Recovery, see [Protect VM workloads with Azure Site Recovery on Azure Local (preview)](azure-site-recovery.md).

### Use Hyper-V Replica for continuous replication of business-critical VMs

Hyper-V Replica is a feature built into Azure Local that enables asynchronous replication of VMs between two Hyper-V hosts or failover clusters. This technology can be utilized to replicate VMs between two separate Azure Local clusters, providing an on-premises disaster recovery solution.

When Hyper-V Replica is enabled for a VM, an initial copy of the VM (including its configuration and VHDs) is created on a designated replica server or cluster. Subsequently, changes made to the primary VM are tracked and written to log files. These logs are then transmitted to the replica site and applied to the replica VM asynchronously.

Key points about using Hyper-V replica with Azure Local:

- **Deployment**:

    - **Manual deployment**: Hyper-V Replica can't be configured via the Azure portal; it must be configured using PowerShell on Azure Local nodes. Alternatively, administrators can remotely access the Azure Local cluster from any Windows Server machine within the same network and complete setup through the Failover Cluster Manager user interface. Appropriate permissions are required to connect to and manage both Azure Local clusters.

    - **Configuration**: Configuration involves enabling the Azure Local clusters to act as replica servers, setting up authentication methods (typically Kerberos within a domain, or certificate-based for nondomain joined or cross-domain scenarios), configuring firewall rules to allow replication traffic, and then enabling replication on a per-VM basis. Per-VM settings include specifying the replica server/cluster, selecting the VHDs to replicate, choosing the replication frequency, and defining how many recovery points (snapshots in time) to maintain on the replica side. Hyper-V Replica supports replication, test failover, failover, reverse replication, and failback for both planned and unplanned scenarios.

- **Replication frequency**: Replication frequency can be configured every 30 seconds, 5 minutes, or 15 minutes.

- **Failover**:

    - Once replication is in place, you can initiate a Failover to the replica server. This essentially brings up the VM on the replica server using the replicated data. You can test this with a Test Failover, which creates a VM on an isolated network for verification without shutting down the replicated VM.

    - During an actual disaster, if the primary site is down unexpectedly, you can do an Unplanned Failover even if the replicated VM isn't running.

    - For scenarios such as hardware maintenance or replacement, a Planned Failover can be initiated. This process gracefully shuts down the replicated VM, ensuring that its memory is committed to disk to prevent any data loss.

    - After failover, your VM runs on the replica server.

    > [!NOTE]
    >- Failing over an Azure Local VM to the replica cluster fails over the VM as an unmanaged VM. This means that all services inside the VM will start working, but the VM can’t be managed from Azure until it's registered on the new Azure Local cluster and reconnected to its resource that exists in Azure.
    >- Reconnecting means the Azure resource will be updated with the new resource group (optional, you can also keep it in the same resource group), custom location, storage path, and logical network of the VM.
    >- Registering and reconnecting may not be necessary if the failover is temporary and the VM is expected to be failed back to the original cluster once the disaster is mitigated. During this period, the VM won't be manageable from Azure, but its services will be operational.

- **Failback**:
    - Once the disaster is mitigated, and the cluster is operational, Hyper-V replica can reverse the replication direction and replicate any changes made while operating on replica server back to the original Azure Local cluster.
    - After the reverse replication, you can fail back the VM, allowing the VM to switch back to its originating cluster.

    > [!NOTE]
    > After the VM is failed back to its originating cluster, registering and reconnecting aren't needed. The VM’s Azure connection will be restored, and it continues to be managed from Azure as long as it's within [Azure Arc’s 45-day reconnection window](/azure/azure-arc/servers/overview#agent-status).


For more information, see the deployment steps in [Set up Hyper-V Replica](/windows-server/virtualization/hyper-v/get-started/Install-Hyper-V).

#### Functionality

When Hyper-V Replica is enabled for a VM, an initial copy of the VM (including its configuration and VHDs) is created on a designated replica server or cluster. Subsequently, changes made to the primary VM are tracked and written to log files. These logs are then transmitted to the replica site and applied to the replica VM asynchronously, based on a configurable replication frequency (for example, every 30 seconds, 5 minutes, or 15 minutes).  

Configuration involves enabling the Azure Local clusters to act as replica servers, setting up authentication methods (typically Kerberos within a domain, or certificate-based for nondomain joined or cross-domain scenarios), configuring firewall rules to allow replication traffic, and then enabling replication on a per-VM basis. Per-VM settings include specifying the replica server/cluster, selecting the VHDs to replicate, choosing the replication frequency, and defining how many recovery points (snapshots in time) to maintain on the replica side. Hyper-V Replica supports replication, test failover, failover, reverse replication, and failback for both planned and unplanned scenarios.

> [!NOTE]
> For Azure Local cluster-to-cluster replication, you must configure the Hyper-V Replica Broker role on each cluster. This broker coordinates replication and provides the cluster-wide endpoint for receiving VM changes.

#### Configuration

 Hyper-V Replica needs to be configured using PowerShell on Azure Local nodes, or it can be set up remotely via the Failover Cluster Manager user interface on any Windows Server machine within the same network (as the Azure Local instances). It requires appropriate permissions to connect and administer both Azure Local machines. There's no option to configure Hyper-V Replica from the Azure portal.

For more information, see the deployment steps in [Set up Hyper-V Replica](/windows-server/virtualization/hyper-v/manage/set-up-hyper-v-replica).
  
#### Network and performance considerations

During the replication process, the hardware and network you use affects the services that rely on them. Depending on the amount of data replicated between the source and target systems, this process consumes a large amount of system resources. Your device performance is impacted until this process completes. Adequate network bandwidth is required between the two Azure Local clusters for Hyper-V replica to function optimally, especially with lower replication intervals (for example, 30 seconds). Similarly, the target cluster needs sufficient storage IOPS to keep up with incoming replication traffic. For more information, see [Feature and performance optimization of Hyper-V Replica (HVR)](/troubleshoot/windows-server/virtualization/feature-performance-optimization-hyper-v-replica).

### Compare Azure Site Recovery and Hyper-V Replica

In choosing between Azure Site Recovery and Hyper-V Replica for Azure Local VMs, review the differences between both solutions:


| Attribute |Azure Site Recovery |Hyper-V Replica |
|---------|---------|---------|
|Replication destinations      |  Azure Local to Azure         |   Azure Local to Azure  Local    |
|Failed over VMs run as      |  Azure VMs        |  Azure Local VMs        |
|Deployment      |    Automated on all nodes, initiated from the Azure portal, and uses [Azure Site Recovery](azure-site-recovery.md) extension.     |  Manual, on each node, out-of-band, and through local tools ([Hyper-V Manager](/windows-server/virtualization/hyper-v/manage/set-up-hyper-v-replica#deployment-steps)).     |
|Requires Azure control plane      |      Yes   |    No     |
|Provides recovery plans for orchestration of failover sequences      |    Yes     |    No     |
|Requires network evaluation for the failed over VM to continue servicing      |    Yes     |    Yes     |
|Incurs Azure usage cost      |    Yes. See [Pricing - Site Recovery](https://azure.microsoft.com/pricing/details/site-recovery).     |     No    |
|Requires registration if the VM is failed back to its original site after disaster is mitigated | No | No (the VM can be failed over to the disaster recovery site temporarily and failed back to its original site after disaster is mitigated) |
|Requires registration if the failed over VM had to permanently reside in the disaster recovery site | No (Azure VMs don’t require registration) | Yes |



**Use Azure Site Recovery and Hyper-V Replica both**: Organizations with remote sites with single clusters and larger hubs with multiple clusters can extend Azure as a disaster recovery site, use Azure Site Recovery for remote sites and Hyper-V Replica for larger locations. This allows some VMs to replicate to Azure while others replicate to a secondary site, ensuring flexibility and tailored disaster recovery strategies for various operational needs.

### Recovery plans and testing

It's essential to have a recovery plan where you document all the steps required to fail over workloads, including the sequence (for example, domain controllers should be activated before application servers), and any necessary network adjustments (such as DNS updates and user redirection). Hyper-V Replica enables the creation of recovery plans, allowing for the sequencing of VM groups and the inclusion of scripts as part of the failover process. These plans can be manual or scripted via PowerShell.  

It's important to regularly test the disaster recovery plan through simulated drills. Conducting a test failover at least once a month is recommended to ensure functionality and maintain staff proficiency. Additionally, testing reveals if your RTOs are being met, such as the time required to spin up in Azure or on secondary hardware.

## Next steps

- Learn more about [Workloads resiliency](disaster-recovery-workloads-resiliency.md).
