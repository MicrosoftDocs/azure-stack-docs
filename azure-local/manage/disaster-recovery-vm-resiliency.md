---
title: Virtual Machine Resiliency for Azure Local
description: Virtual machine resiliency considerations for Azure Local.
ms.topic: article
author: sipastak
ms.author: sipastak
ms.date: 01/07/2026
ms.subservice: hyperconverged
---

# Virtual machine resiliency for Azure Local

After reviewing and implementing the design considerations for [infrastructure resiliency](disaster-recovery-infrastructure-resiliency.md) at the platform level, it's essential to understand how your virtual machines (VMs) and applications are resilient to failures. This understanding helps you enable them to detect, withstand, and recover from failures within an acceptable time period. Resiliency is fundamental to maintaining continuous operations for business-critical applications.

By default, all virtual machines (VMs) on Azure Local are designed for high availability. If a physical node in the cluster fails, any affected VMs automatically restart and continue to operate on the remaining nodes, as long as there's enough compute capacity available for the VMs. Even with these strong platform-level fault tolerance and resiliency features in place, it's essential that the applications deployed inside your VMs follow well-architected principles.

Well-architected applications integrate reliability into their code, infrastructure, and operations. For example, deploying multiple instances of application services inside two or more Azure Local VMs is essential for eliminating single points of failure within the application layer. Incorporating additional resiliency at this layer mitigates the risk of downtime should an individual VM or application instance fail. For more information, see [workload resiliency](disaster-recovery-workloads-resiliency.md). Additionally, robust application design should encompass comprehensive business continuity and disaster recovery (BCDR) strategies, including regular DR failover validation and data backup and recovery tests to ensure your disaster recovery procedures operate as intended.

To mitigate the risk of service disruptions or data loss that the redundancy capabilities of a single Azure Local instance can't mitigate, it's essential to implement a combination of comprehensive [backup strategies](#backup-tools) alongside continuous [data replication technologies](#continuous-replication-of-business-critical-vms).

- Backup strategies protect against scenarios such as data corruption, accidental or malicious deletion, and catastrophic incidents. They facilitate the restoration of data to a previous state when necessary.

- Data replication technologies enable synchronized copies of virtual machine data to be maintained across multiple Azure Local instances and Azure regions. This practice can minimize downtime and enable rapid workload failover in the event of hardware or system failure. Together, these approaches provide a robust safety net designed to safeguard data and sustain operational and business continuity during unexpected disruptions.

For more information and recommendations to enhance the resiliency of your workload and applications, review [Azure Well-Architected Framework (WAF) - Reliability design principles](/azure/well-architected/reliability/principles).

## Storage path (volumes) considerations

Azure Local instances deployed by using the [*Create workload volumes and required infrastructure volumes (Recommended)*](/azure/azure-local/deploy/deploy-via-portal#optionally-change-advanced-settings-and-apply-tags) option create a 'UserStorage_X' cluster shared volumes (CSVs), one per physical node in the cluster, and an associated Storage Path resource created in Azure for each volume. Workload resources, such as Azure Local VMs and Arc-enabled Azure Kubernetes Server (AKS) clusters, use the storage path resource in Azure to store VM images. For example, a CSV with the local file system path of `C:\ClusterStorage\UserStorage_1\` has a storage path resource created in Azure that represents the cluster shared volume (CSV) to enable Azure Local VMs virtual hard disks (VHDs) to be placed on a specific target volume. For more information, see [about storage paths](/azure/azure-local/manage/create-storage-path#about-storage-path).

When deploying well-architected applications that utilize multiple Azure Local VMs to enhance workload resiliency, where possible, place each VM's virtual hard disks (VHDs) in separate storage paths to optimize redundancy. For example, when provisioning multiple Azure Local VMs that run instances of the same service, using different storage paths for each VMs VHDs helps mitigate the risk of all VMs using a single storage path (volume).

You configure the storage path used by Azure Local VMs when you create their virtual hard disks. When you use infrastructure as code (IaC) to provision workloads, the placement logic for VHDs employs a round-robin allocation logic for storage path selection. For multi-node Azure Local instances, each storage path maps to a different volume by default. Therefore, each VMs VHDs are distributed across different storage paths (volumes), which increases workload resiliency, specifically for scenarios where a single volume is temporarily offline or unavailable. For more granular provisioning control, specify the `--storage-path-id` parameter when using Azure CLI for workload deployment, allowing you to target specific storage paths when provisioning virtual hard disks for Azure Local VMs.

## Backup Tools

### Microsoft Azure Backup Server

[Microsoft Azure Backup Server](/azure/backup/backup-azure-microsoft-azure-backup) (MABS), an evolution of System Center Data Protection Manager, is a Microsoft backup solution that you can use to protect Azure Local VMs. MABS offers a hybrid backup approach, providing short-term retention on local disk storage for fast operational recoveries and long-term retention through integration with Azure Backup services, allowing you to vault backups offsite to an Azure Recovery Services vault.  

If you're using MABS, you can protect VMs by using two approaches: **host-level VM backup** and **guest-level VM backup**.

- **Host-level VM backup**: Install the backup agent on each Azure Local host (each cluster node) and back up entire VMs at the hypervisor level. This approach captures the whole VM, including all virtual disks. It doesn't require an agent inside each VM, and it's agnostic to the guest OS. Host-level backups allow full VM restores, where you can recover an entire VM to the same or different cluster. However, host-level backups aren't application-aware. For example, they don't truncate SQL logs or guarantee application-consistent restores beyond what Volume Shadow Copy Service (VSS) provides.

    > [!NOTE]
    >- Restoring an Azure Local VM on a different cluster restores the VM as an unmanaged VM. This means that all services inside the VM start working, but the VM can't be managed from Azure until it's registered on the new Azure Local cluster and reconnected to its resource that exists in Azure.
    >- Reconnecting means the Azure resource is updated with the new resource group (optional, you can also keep it in the same resource group), custom location, storage path, and logical network of the VM.
    >- If you restore the VM in-place on the same cluster, registering and reconnecting aren't needed. The VM's Azure connection is restored, and it continues to be managed from Azure as long as it's within [Azure Arc's 45-day reconnection window](/azure/azure-arc/servers/overview#agent-status).

- **Guest-level VM backup**: Install backup agents inside the guest OS of the VM. This approach allows application-consistent backups for VSS-aware applications running within the operating system, ensuring that application data is captured in a consistent state. For example, you can back up SQL databases with full fidelity and restore individual items like a single database or a specific file easily. The trade-off is manageability: you must manage agents on each VM, and the backup only covers what's inside the VM. To restore the whole VM, you typically rebuild it and then restore data within.  

- **Use both**: Many organizations use a combination of both approaches. Use guest-level backups for critical applications that need point-in-time or item-level recovery, like restoring a single database or a file without rolling back the whole VM. Use host-level backups for fast recovery of entire VMs or to recover from host failure scenarios.

Setting up MABS involves deploying the MABS server software on a dedicated VM on the cluster, configuring its local storage, installing protection agents on the Azure Local hosts and/or guests, and then creating protection groups with the VMs you want to protect. Protection groups define what is backed up (for example, specific VMs), the backup schedule, and short-term and long-term retention policies on local disk or Azure. For more information on installing MABS for Azure Local VMs, see [Back up Azure Local virtual machines with Azure Backup Server](/azure/backup/back-up-azure-stack-hyperconverged-infrastructure-virtual-machines).

| Attribute | Host-level VM backup | Guest-level VM backup |
| ----------- | ---------------------- | ----------------------- |
| Requires agent in the guest OS | No | Yes |
| Requires agent in all nodes of the cluster | Yes | No |
| Agnostic to guest OS | Yes | No |
| Application aware | No | Yes |
| Backup | The whole VM and disks | Applications and files (application-consistent backups that are VSS aware) |
| Restore | Whole VM | App data and individual files |
| Restore VM to the same cluster | Yes | Not applicable |
| Restore VM to an alternate cluster | Yes | Not applicable |

### Partner backup solutions

Beyond MABS, a mature market of partner backup and recovery vendors offers robust solutions for Azure Local environments. These solutions often provide a rich set of advanced features, broader platform support, and different licensing or cost models that might be attractive depending on specific organizational requirements.  

#### CloudCasa by Catalogic

CloudCasa delivers Kubernetes-native backup, disaster recovery, and migration for AKS on Azure Local and Arc-enabled clusters. It protects cluster resources and persistent volumes, with the ability to perform granular restores, including file-level recovery. Backups can be stored in Azure Blob Storage, other object storage, or network file system (NFS). CloudCasa supports restores to the same site, a secondary Azure Local cluster, or Azure AKS for disaster recovery.

- [CloudCasa on Azure Marketplace](https://azuremarketplace.microsoft.com/marketplace/apps?search=cloudcasa)
- [CloudCasa solutions for Azure](https://cloudcasa.io/partners/microsoft-azure/)
- [Simplify Upgrades and Backup for Azure Local](https://cloudcasa.io/blog/upgrade-backup-azure-local/)

#### Cohesity DataProtect

Cohesity DataProtect, part of the Data Cloud platform, protects VMs with a single data-security platform. It combines backup, replication, and disaster recovery with unlimited immutable snapshots, granular file/VM/database restores, instant mass restore at scale, and integrated anomaly detection and data classification to speed clean recovery after cyber events. For Azure Local, Cohesity offers deep integration with the platform. This integration includes automatic VM discovery, policy-based protection, many restore options, and incremental-forever backups using Microsoft Resilient Change Tracking (RCT).

Cohesity extends support by leveraging its mature Hyper-V connector and workflows, giving a consistent operating model as customers move Hyper-V workloads onto Azure Local.

- [Cohesity DataProtect](https://www.cohesity.com/platform/dataprotect/)
- [Support statements for Azure Local](https://docs.cohesity.com/ui/login?redirectPath=%2F7_3%2FWeb%2FUserGuide%2FContent%2FReleaseNotes%2FSupportedVersions.htm#MicrosoftHyperV)

#### Cohesity NetBackup

Cohesity NetBackup delivers cyber-resilient data protection for Azure Local, enabling organizations to protect Azure Local virtual machines and applications using the same enterprise‑grade platform they rely on across hybrid and multi‑cloud environments.

NetBackup uses its mature Hyper-V integration and Microsoft Resilient Change Tracking (RCT) to provide policy-based, incremental-forever backups for Azure Local workloads. Efficient block-level change capture minimizes backup windows and network usage. Azure Local support is documented in the NetBackup 11.x Software Compatibility List under Hyper-V and Azure Local.

- [Cohesity NetBackup](https://www.cohesity.com/platform/netbackup/)
- [NetBackup 11.x Software Compatibility List - Hyper-V and Azure Local](https://download.veritas.com/resources/content/live/OSVC/100046000/100046445/en_US/nbu_110_scl.html?__gda__=1767992686_c71cac89f902a6922f833d1f35f710db#Hyper-V_and_Azure_Local)
- [NetBackup Compatibility List for all Versions](https://www.veritas.com/support/en_US/article.100040093)

#### Commvault

Commvault Cloud offers unified, enterprise-grade data protection for Azure Local environments, enabling secure backup, recovery, and ransomware protection across virtual machines, databases, and unstructured data. With intelligent automation and policy-driven workflows, Commvault simplifies compliance, improves resiliency, and delivers scalable protection from edge to cloud, all while maintaining full control of your data within your Azure Local region.

- [Commvault for Azure Local](https://documentation.commvault.com/11.42/software/azure_local.html)
- [Solution briefs](https://www.commvault.com/resources/solution-brief/commvault-for-microsoft-azure-local)
- [Commvault Marketplace SaaS](https://marketplace.microsoft.com/en-us/product/saas/commvault.commvault_complete_backup_recovery?tab=Overview)

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
- [Veeam Supported Platforms](https://helpcenter.veeam.com/docs/backup/hyperv/platform_support.html)

## Backup frequency, retention, and restoration testing

Even with hardware fault tolerance and Storage Spaces Direct maintaining multiple copies of data, it's essential to implement and regularly test data backup processes. Storage redundancy protects against infrastructure failures, but it doesn't prevent data corruption, deletion, or site-wide disasters. Regular backups ensure you can restore data or entire VMs to a previous point in time if needed.

- **Backup frequency and retention**: Ensure that your backup frequency aligns with your Recovery Point Objective (RPO), which defines the maximum acceptable amount of data loss for your organization. Depending on the importance of a virtual machine to the business, schedule nightly backups or multiple backups per day if necessary, using incremental backups. Additionally, implement a retention policy that aligns with business and compliance requirements (for example, retain daily backups for two weeks, monthly backups for six months, yearly backups for seven years). Azure Backup, through the Microsoft Azure Backup Server (MABS), can facilitate both short-term on-premises retention and long-term cloud-based retention.

- **Testing restores**: A backup is only as good as your ability to restore it, so it's important to regularly test restoration of VMs and data from backups. Periodically perform a full VM recovery test to an isolated network or a lab cluster to ensure the process is smooth and timely. This practice is part of disaster recovery strategy to guarantee that backups serve their purpose in an actual emergency.

## Continuous replication of business-critical VMs

While backups protect data and enable point-in-time recovery, they don't offer immediate failover capabilities. Restoring from a backup can be time-consuming, often taking hours. For business or mission-critical VMs where even minimal downtime or data loss is unacceptable, continuous replication technologies provide a mechanism to maintain an up-to-date copy of VMs at a secondary location. These technologies enable rapid failover and minimal data loss in the event of a disaster. Two continuous replication technologies Azure Local supports are Azure Site Recovery and Hyper-V Replica.

### Use Azure Site Recovery to replicate Azure Local VMs to Azure

Azure Site Recovery is Microsoft's cloud-based disaster recovery solution designed to replicate on-premises VMs to Azure. Azure Site Recovery facilitates the replication of Azure local VMs into Azure, ensuring the protection of business-critical workloads. This service continuously transmits changes from your on-premises VMs to Azure. As a result, in the event of a significant outage at your local site or cluster, you can fail over the VM to Azure to maintain operational continuity.

Key points about Azure Site Recovery for Azure Local:

- **Deployment**:
  - Automated deployment: Azure Local created an extension to Azure Site Recovery for automated deployment. Azure Site Recovery extension can detect all the nodes of the cluster and deploy Azure Site Recovery on all nodes automatically and configure them with the replication policy. For more information, see [Protect VM workloads with Azure Site Recovery](azure-site-recovery.md#step-1-prepare-infrastructure-on-your-target-host).
  - Manual deployment: Azure Site Recovery extension for Azure Local is in preview and only applicable to test environments. For those customers that need a production ready solution, Azure Site Recovery can be configured manually on Azure Local cluster using the [Hyper-V to Azure disaster recovery](/azure/site-recovery/hyper-v-azure-architecture) option.  

- **Frequent replication**: Azure Site Recovery can achieve Recovery Point Objectives (RPOs) as low as 30 seconds.

- **Failover**:
  - Once replication is in place, you can initiate a failover to Azure. This process brings up the VM in Azure by using the replicated data. You can test this process by using a test failover, which creates a copy in Azure on an isolated network for verification without shutting down on-premises VMs.
  - During an actual disaster, if the primary site is down unexpectedly, you do an unplanned failover even if the source VM isn't running.
  - For scenarios such as hardware maintenance or replacement, you can initiate a planned failover. This failover gracefully shuts down the VM so that it can commit its memory to disk to ensure zero data loss.
  - After failover, your VM runs in Azure.  

- **Failback**:
  - When the disaster is mitigated, and the cluster is operational, Azure Site Recovery can reverse the replication direction and replicate any changes made while operating in Azure back to your Azure Local cluster. After reverse replication you can fail back the VM, allowing operations to switch back to on-premises.
  - For successful failback, the on-premises environment must be healthy. If your cluster isn't available, you can register another Azure Local cluster to the Azure Site Recovery Hyper-V site and failback the VM to a node on an alternate cluster.

    > [!NOTE]
    >- Failing back an Azure Local VM on an alternate cluster fails back the VM as an unmanaged VM. This means that all services inside the VM start working, but the VM can't be managed from Azure until it's registered on the new Azure Local cluster and reconnected to its resource that exists in Azure.
    >- Reconnecting means the Azure resource is updated with the new resource group (optional, you can also keep it in the same resource group), custom location, storage path, and logical network of the VM.
    >- If the VM is failed back on the same cluster, registering and reconnecting aren't needed. The VM's Azure connection is restored, and it continues to be managed from Azure as long as it's within [Azure Arc's 45-day reconnection window](/azure/azure-arc/servers/overview#agent-status).

For more information and to install Azure Site Recovery, see [Protect VM workloads with Azure Site Recovery on Azure Local (preview)](azure-site-recovery.md).

### Use Hyper-V Replica for continuous replication of business-critical VMs

Hyper-V Replica is a feature built into Azure Local that enables asynchronous replication of VMs between two Hyper-V hosts or failover clusters. You can use this technology to replicate VMs between two separate Azure Local clusters, providing an on-premises disaster recovery solution.

When you enable Hyper-V Replica for a VM, it creates an initial copy of the VM (including its configuration and VHDs) on a designated replica server or cluster. Hyper-V Replica then tracks changes you make to the primary VM and writes them to log files. It transmits these logs to the replica site, where it applies them to the replica VM asynchronously.

Key points about using Hyper-V replica with Azure Local:

- **Deployment**:

  - **Manual deployment**: You can't configure Hyper-V Replica through the Azure portal. Use PowerShell on Azure Local nodes to configure it. Alternatively, administrators can remotely access the Azure Local cluster from any Windows Server machine within the same network and complete setup through the Failover Cluster Manager user interface. You need appropriate permissions to connect to and manage both Azure Local clusters.

  - **Configuration**: You enable the Azure Local clusters to act as replica servers, set up authentication methods (typically Kerberos within a domain, or certificate-based for non-domain joined or cross-domain scenarios), configure firewall rules to allow replication traffic, and then enable replication on a per-VM basis. Per-VM settings include specifying the replica server or cluster, selecting the VHDs to replicate, choosing the replication frequency, and defining how many recovery points (snapshots in time) to maintain on the replica side. Hyper-V Replica supports replication, test failover, failover, reverse replication, and failback for both planned and unplanned scenarios.

- **Replication frequency**: You can configure replication frequency to occur every 30 seconds, 5 minutes, or 15 minutes.

- **Failover**:

  - Once replication is in place, you can initiate a failover to the replica server. This action brings up the VM on the replica server by using the replicated data. You can test this action by using a test failover, which creates a VM on an isolated network for verification without shutting down the replicated VM.

  - During an actual disaster, if the primary site is down unexpectedly, you can perform an unplanned failover even if the replicated VM isn't running.

    - For scenarios such as hardware maintenance or replacement, you can initiate a planned failover. This process gracefully shuts down the replicated VM, ensuring that its memory is committed to disk to prevent any data loss.

  - After failover, your VM runs on the replica server.

    > [!NOTE]
    >- Failing over an Azure Local VM to the replica cluster fails over the VM as an unmanaged VM. This means that all services inside the VM start working, but you can't manage the VM from Azure until it's registered on the new Azure Local cluster and reconnected to its resource that exists in Azure.
    >- Reconnecting means the Azure resource is updated with the new resource group (optional, you can also keep it in the same resource group), custom location, storage path, and logical network of the VM.
    >- Registering and reconnecting might not be necessary if the failover is temporary and the VM is expected to be failed back to the original cluster once the disaster is mitigated. During this period, the VM isn't manageable from Azure, but its services are operational.

- **Failback**:
  - Once the disaster is mitigated, and the cluster is operational, Hyper-V replica can reverse the replication direction and replicate any changes made while operating on replica server back to the original Azure Local cluster.
  - After the reverse replication, you can fail back the VM, allowing the VM to switch back to its originating cluster.

    > [!NOTE]
    > After the VM is failed back to its originating cluster, registering and reconnecting aren't needed. The VM’s Azure connection is restored, and it continues to be managed from Azure as long as it's within [Azure Arc’s 45-day reconnection window](/azure/azure-arc/servers/overview#agent-status).

For more information, see the deployment steps in [Set up Hyper-V Replica](/windows-server/virtualization/hyper-v/get-started/Install-Hyper-V).

#### Functionality

When you enable Hyper-V Replica for a VM, it creates an initial copy of the VM (including its configuration and VHDs) on a designated replica server or cluster. Hyper-V Replica then tracks changes you make to the primary VM and writes them to log files. It transmits these logs to the replica site and applies them to the replica VM asynchronously, based on a configurable replication frequency (for example, every 30 seconds, 5 minutes, or 15 minutes).  

Configuration involves enabling the Azure Local clusters to act as replica servers, setting up authentication methods (typically Kerberos within a domain, or certificate-based for non-domain joined or cross-domain scenarios), configuring firewall rules to allow replication traffic, and then enabling replication on a per-VM basis. Per-VM settings include specifying the replica server or cluster, selecting the VHDs to replicate, choosing the replication frequency, and defining how many recovery points (snapshots in time) to maintain on the replica side. Hyper-V Replica supports replication, test failover, failover, reverse replication, and failback for both planned and unplanned scenarios.

> [!NOTE]
> For Azure Local cluster-to-cluster replication, you must configure the Hyper-V Replica Broker role on each cluster. This broker coordinates replication and provides the cluster-wide endpoint for receiving VM changes.

#### Configuration

 You need to configure Hyper-V Replica by using PowerShell on Azure Local nodes, or you can set it up remotely via the Failover Cluster Manager user interface on any Windows Server machine within the same network as the Azure Local instances. You need appropriate permissions to connect and administer both Azure Local machines. There's no option to configure Hyper-V Replica from the Azure portal.

For more information, see the deployment steps in [Set up Hyper-V Replica](/windows-server/virtualization/hyper-v/manage/set-up-hyper-v-replica).
  
#### Network and performance considerations

During the replication process, the hardware and network you use affect the services that rely on them. Depending on the amount of data replicated between the source and target systems, this process consumes a large amount of system resources. Your device performance is impacted until this process completes. Adequate network bandwidth is required between the two Azure Local clusters for Hyper-V replica to function optimally, especially with lower replication intervals (for example, 30 seconds). Similarly, the target cluster needs sufficient storage input output operations per second (IOPS) to keep up with incoming replication traffic. For more information, see [Feature and performance optimization of Hyper-V Replica (HVR)](/troubleshoot/windows-server/virtualization/feature-performance-optimization-hyper-v-replica).

## Compare Azure Site Recovery and Hyper-V Replica

When choosing between Azure Site Recovery and Hyper-V Replica for Azure Local VMs, consider the differences between both solutions:

| Attribute | Azure Site Recovery | Hyper-V Replica |
| --------- | ------------------- | --------------- |
| Replication destinations | Azure Local to Azure | Azure Local to Azure Local |
| Failed over VMs run as | Azure VMs | Azure Local VMs |
| Deployment | Automated on all nodes, initiated from the Azure portal, and uses [Azure Site Recovery](azure-site-recovery.md) extension. | Manual, on each node, out-of-band, and through local tools ([Hyper-V Manager](/windows-server/virtualization/hyper-v/manage/set-up-hyper-v-replica#deployment-steps)). |
| Requires Azure control plane | Yes | No |
| Provides recovery plans for orchestration of failover sequences | Yes | No |
| Requires network evaluation for the failed over VM to continue servicing | Yes | Yes |
| Incurs Azure usage cost | Yes. See [Pricing - Site Recovery](https://azure.microsoft.com/pricing/details/site-recovery). | No |
| Requires registration if the VM is failed back to its original site after disaster is mitigated | No | No (the VM can be failed over to the disaster recovery site temporarily and failed back to its original site after disaster is mitigated) |
| Requires registration if the failed over VM had to permanently reside in the disaster recovery site | No (Azure VMs don’t require registration) | Yes |

**Use Azure Site Recovery and Hyper-V Replica both**: Organizations with remote sites with single clusters and larger hubs with multiple clusters can extend Azure as a disaster recovery site. Use Azure Site Recovery for remote sites and Hyper-V Replica for larger locations. This architecture allows some VMs to replicate to Azure while others replicate to a secondary site, ensuring flexibility and tailored disaster recovery strategies for various operational needs.

## Recovery plans and testing

It's essential to have a recovery plan where you document all the steps required to fail over workloads, including the sequence (for example, domain controllers should be activated before application servers), and any necessary network adjustments (such as DNS updates and user redirection). Hyper-V Replica enables the creation of recovery plans, allowing for the sequencing of VM groups and the inclusion of scripts as part of the failover process. These plans can be manual or scripted via PowerShell.  

Regularly test the disaster recovery plan through simulated drills. Conduct a test failover at least once a month to ensure functionality and maintain staff proficiency. Additionally, testing reveals if your recovery time objectives (RTOs) are being met, such as the time required to spin up in Azure or on secondary hardware.

For additional information, review [Architecture strategies for designing a disaster recovery strategy](/azure/well-architected/reliability/disaster-recovery#maintain-a-disaster-recovery-plan).

## Next steps

- Learn more about [Workloads resiliency](disaster-recovery-workloads-resiliency.md).
