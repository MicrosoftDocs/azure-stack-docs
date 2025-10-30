---
title: Workloads Resiliency for Azure Local
description: Disaster recovery workloads for Azure Local.
ms.topic: article
author: sipastak
ms.author: sipastak
ms.date: 10/23/2025
---
# Workloads resiliency for Azure Local

Disaster recovery for workloads running on Azure Local virtual machines (VMs) requires a layered approach that aligns infrastructure-level protections with application-specific continuity strategies. Whether you're hosting SQL Server databases or delivering virtual desktops through Azure Virtual Desktop, each workload type has unique recovery requirements and dependencies. Azure Local supports a wide range of disaster recovery technologies allowing you to tailor recovery plans to meet business continuity goals and ensure rapid recovery from disruptions.

## Arc-enabled SQL Server

Azure Local VMs can host high performance instances of [Arc-enabled SQL Server](/sql/sql-server/azure-arc/overview), including those using Always-On Availability Groups to provide enterprise-level high-availability (HA) and disaster-recovery (DR) capabilities. The primary objective of SQL Server disaster recovery is to meet the application's specific Recovery Time Objective (RTO) and Recovery Point Objective (RPO) in the event of a disruption. SQL Server provides a rich set of built-in features for both high-availability (HA) within a single site/cluster and disaster recovery (DR) to a secondary site/cluster.

For SQL Server workloads running on Azure Local VMs, a comprehensive disaster recovery strategy must combine host-level protection mechanisms with SQL Server's own native high availability/disaster recovery features. While host-level protection safeguards the entire server instance, including the operating system and SQL Server binaries, SQL-native solutions like [Always-On Availability Groups](/sql/database-engine/availability-groups/windows/overview-of-always-on-availability-groups-sql-server) and Log Shipping offer more granular control over database availability, provide application-consistent data protection, and can often achieve lower RPOs, especially for highly transactional databases. By using SQL Server’s own disaster recovery capabilities, in addition to Azure Local’s host-level protections, organizations can achieve more robust data protection and faster recovery times.

### Disaster recovery capabilities of SQL Server on Azure Local VMs

Arc-enabled SQL Server provides a range of proven disaster recovery technologies, all of which are fully supported on Azure Local deployments. You can choose one or combine several, depending on application requirements and your Recovery Point Objective (RPO) / Recovery Time Objective (RTO) targets.

Key SQL Server disaster recovery features and best-practice recommendations for using them on Azure Local include:

- **Always On Availability Groups (AG)**
  - An Always On AG is a premier high-availability/disaster recovery feature that protects a set of user databases by replicating transactions from a primary to one or more secondary replicas.
  - In an Azure Local environment, AGs can be used within a single cluster for high availability and across clusters or sites for disaster recovery. For automatic failover, deploy AGs on a Windows Server Failover Cluster (WSFC) and use synchronous-commit mode between replicas in proximity (low latency network). Use asynchronous-commit mode for replicas at distant replicas (higher latency) to maximize performance. [Distributed Availability Groups](/sql/database-engine/availability-groups/windows/distributed-availability-groups) can also span multiple clusters for advanced scenarios. Always On AGs on Azure Local support both automatic and manual failover when configured appropriately and are the recommended solution for protecting critical databases requiring minimal downtime.
  - For more information, see [What is an Always On availability group](/sql/database-engine/availability-groups/windows/overview-of-always-on-availability-groups-sql-server).

- **Always on failover cluster instances (FCI)**:
  - An Always On failover cluster instance is an instance-level high availability solution based on WSFC that provides failover of the entire SQL Server instance (including all databases) to another node in the VM guest-level cluster.
  - An FCI on Azure Local uses the cluster’s shared storage (provided by the Azure Local S2D volumes) to ensure the SQL instance can restart on a second node with the same data.
  - Best practice: Use FCIs to protect applications that require instance-level failover or in scenarios where shared storage is available.
  - For more information, see [Always On failover cluster instances](/sql/sql-server/failover-clusters/windows/always-on-failover-cluster-instances-sql-server).  

- **Log shipping**:
  - Log shipping periodically backs up transaction logs from a primary database and restores them to a secondary database. This establishes a warm standby server that can be brought online in a disaster. On Azure Local, log shipping is fully supported and can be a low-cost disaster recovery option for less time-sensitive databases.
  - Best practice: ensure the log backup frequency aligns with your RPO. Also monitor the restore delay on the secondary to estimate failover time. For more information, see [About log shipping](/sql/database-engine/log-shipping/about-log-shipping-sql-server).

- **Database mirroring**:
  - Mirroring maintains two copies of a database and can be configured synchronously or asynchronously. However, mirroring is deprecated in recent SQL versions and isn't recommended for new deployments. Instead, use Basic Availability Groups or full Always On AGs, which provide similar capabilities on Azure Local without the limitations of mirroring.
  - For more information, see [Database Mirroring](/sql/database-engine/database-mirroring/database-mirroring-sql-server).

- **Backup and Restore**:
  - Regular database backups including full, differential, and transaction log backups are the foundation of any disaster recovery strategy. SQL Server supports backing up to a disk or to a URL such as Azure Blob Storage. Customers can use [Microsoft Azure Backup Server](/azure/backup/backup-azure-sql-mabs) (MABS) or non-Microsoft partner tools to back up their whole VMs or applications to local disks and to cloud storage. SQL Server also offers [Managed Backup to Azure](/sql/relational-databases/backup-restore/sql-server-managed-backup-to-microsoft-azure), which can automatically schedule backups to cloud storage without MABS or any non-Microsoft backup solution.
  - Best practice: Use whichever tool makes sense for your environment, take frequent backups to meet your RPO goals, and routinely test restoration.
  - For more information, see [Back Up and Restore of SQL Server Databases](/sql/relational-databases/backup-restore/back-up-and-restore-of-sql-server-databases)

- **Replication**:
  - SQL Server replication (Transactional, Merge, or Snapshot) allows copying and distributing data from one database to others in near real-time. While typically used for distributing read-only copies or synchronizing data, replication can also serve as part of a disaster recovery strategy. On Azure Local, all forms of SQL Server replication are supported.
  - Caveat: Replication doesn't automatically fail over entire databases and might require manual reconfiguration in a disaster.
  - For more information, see [SQL Server Replication](/sql/relational-databases/replication/sql-server-replication).  

All the above capabilities can be mixed to achieve a desired outcome. For example, use an Always on AG for zero-data-loss high availability within your primary site, and simultaneously use asynchronous replication to a secondary Azure Local instance off-site for disaster recovery. The choice should be guided by your application’s RPO/RTO requirements and whether the solution provides automatic failover or requires a manual process.

### Arc-enabled SQL Server benefits

Every guest enabled Azure Local VM is Arc enabled, therefore the SQL Server inside the VM will automatically be Arc-enabled SQL Server. Through Azure Arc integration, you gain cloud-based visibility and management for your on-premises SQL Server’s disaster recovery setup. Azure Arc doesn't replace the SQL-native disaster recovery features above, but it provides unified tools to monitor, manage, and enhance these capabilities from the Azure portal.

Key Azure Arc-enabled SQL Server features for disaster recovery include:

- **Always On Availability Group Management**:
  - View and manage Always-On AGs on Arc-enabled SQL Servers in the Azure portal. This includes seeing the list of availability groups, their replicas and synchronization state, and performing manual failover if needed.
  - For more information, see [Manage Always On availability groups](/sql/sql-server/azure-arc/manage-availability-group).

- **Failover Cluster Instance Visibility**:
  - Azure Arc surfaces SQL Server FCIs in the portal, allowing you to identify and monitor FCI deployments across your hybrid environment.
  - For more information, see [View Always On failover cluster instances in Azure Arc](/sql/sql-server/azure-arc/support-for-fci).

- **Automated Backup and Restore**:
  - Configure automated backups via Azure Policy or the portal. The Arc SQL Server extension can schedule and execute backups according to a defined policy. You can restore them from the portal as well.
  - For more information, see [Manage](/sql/sql-server/azure-arc/backup-local) and [Restore to a point-in-time](/sql/sql-server/azure-arc/point-in-time-restore).

- **Backup to URL with Managed Identity**:
  - Arc allows your on-premises SQL Server to use an Azure Managed Identity for authentication when backing up to Azure Blob Storage. This eliminates the need for SAS tokens or account keys.
  - For more information, see [Back up to URL with managed identity (preview)](/sql/sql-server/azure-arc/backup-to-url).

## Azure Virtual Desktop

[Azure Virtual Desktop](/azure/architecture/hybrid/azure-local-workload-virtual-desktop) provides a comprehensive platform for securely delivering virtualized Windows desktops and applications to users anywhere, seamlessly integrating with both cloud and on-premises environments.  

The Azure Virtual Desktop architecture consists of several core components, including session host virtual machines, the Azure Virtual Desktop control plane (which manages user connections, brokering, and gateway services form the cloud), user profile storage (such as FSLogix), and network configurations that together provide a seamless virtual desktop experience. An effective disaster recovery strategy for Azure Virtual Desktop on Azure Local must account for the recovery and continuity of each of these components to ensure a smooth transition upon failover.

Azure Virtual Desktop session hosts are virtual machines that run the actual desktop and application environments users connect to when accessing Azure Virtual Desktop. Each session host delivers resources, manages user sessions, and ensures workloads are isolated and performant. As a result, many of the VM recovery options listed for Azure Local VMs also apply to Azure Virtual Desktop, but require additional considerations to account for the other core components of a virtual desktop solution.  

### Pooled host pools

In the pooled model, users are assigned to any available session host from a pool, and the VMs are ideally stateless. User-specific data and settings are roamed using [FSLogix profile containers](/fslogix/concepts-container-recovery-business-continuity), which store the entire user profile in a VHD(X) file dynamically attached at sign-in. For disaster recovery, the primary focus for pooled hosts is on ensuring the availability of the golden image used to deploy session hosts, the FSLogix profile containers, and any MSIX app attach packages to rebuild the image. Since the VMs aren't mapped directly to a user, full VM backup and failover methods like Hyper-V Replica may not be needed.  

The recommended disaster recovery approach for pooled session hosts is to create a host pool on a secondary site, either Azure or another cluster, and configure it to match the primary host pool. These hosts can remain dormant and be turned on at failover time or can be always active. It's important to ensure that the secondary host pool has access to the same FSLogix profiles and are built from the same image at the primary hosts to provide the same experience to users. You can use OneDrive redirection to ensure FSLogix profiles stay in sync between the two sites.

At failover time, if the hosts are dormant, they must be turned on and users reassigned to the secondary host pool. If they're always active, no admin intervention is needed at failover time. Failing back after the primary cluster’s health is restored is done in a similar manner once the original hosts are back online.  

### Personal Host Pools

With personal session hosts, each user is assigned to a specific, dedicated session host VM. These VMs are stateful, as users may install applications or store data directly on them. Consequently, disaster recovery for personal session hosts typically requires full VM-level backup and replication (using Hyper-V Replica) to preserve the unique state of each user's desktop.

### Fail over to another Azure Local cluster using Hyper-V Replica

A secondary Azure Local cluster can be used as a failover site to keep session hosts on premises. The strategy largely follows the recommendations for VM resiliency using [Hyper-V replica](disaster-recovery-vm-resiliency.md#use-hyper-v-replica-for-continuous-replication-of-business-critical-vms), with special considerations for personal session hosts.

The strategy largely follows the recommendations in the Hyper-V Replica section above, with special considerations for pooled and personal session hosts.

- **Prepare the cluster for failover**: Ensure that the secondary cluster has sufficient compute and storage capacity to support a failover, has matching network configuration and is routable to the primary cluster. Ensure that AD DC and DNS settings are configured the same on the secondary cluster so that the replicated VMs can authenticate smoothly.

- **Enable Hyper-V Replica**: Hyper-V Replica must be configured using PowerShell or Failover Cluster Manager, it can't be done from the Azure portal. Replication must be enabled on both the primary and secondary clusters, and replication settings must be defined for each VM, including recovery frequency, and initial replication method.  

- **Replicate session hosts**: For personal session hosts, ensure that each VM is replicated regularly to the secondary cluster and that the user-to-VM mapping is consistent with the primary cluster. It's recommended to keep the replicated VMs provisioned and assigned to the host pool before failover, but if not, they must be assigned upon failover.

### Hyper-V Replica failover

At failover time, the first step is to confirm that the domain controller is operational and DNS settings are up to date before starting any hosts. Personal session hosts should have the latest replication turned on and checked to ensure that the profile is assigned appropriately.

It's important to note that after failover using Hyper-V Replica, VMs on the secondary site will be unmanaged. End users are able to use Azure Virtual Desktop as they normally would, but the VMs won't be manageable from the portal the way they were before failover. In order to restore management capabilities, it's recommended to fail back to the primary site as soon as it can be restored.  

### Hyper-V Replica failback

It's recommended to plan a maintenance window to fail VMs back to the primary site once it's healthy and functional. Reverse replication of VMs back to the primary site and verify that the hosts are accessible and DNS settings are as expected.  

### Multi-cluster resiliency

Another approach to disaster resiliency for pooled host pools is to divide session hosts within a host pool across multiple clusters. This offers seamless redirection in the case of a single cluster failure with limited redundancy.

To configure this approach:

- Ensure that both clusters are configured in the same way and have matching AD and DNS settings.
- Deploy session hosts on both clusters, then [manually add them to host pools](/azure/virtual-desktop/add-session-hosts-host-pool) using the Azure Virtual Desktop portal, PowerShell, or Azure CLI.
- Sessions will automatically load balance across clusters as needed. In this case, use a Scale-Out File Server to store FSLogix profiles to be accessible by both clusters.  

To learn more, see [Azure Virtual Desktop for Azure Local](/azure/architecture/hybrid/azure-local-workload-virtual-desktop).

## Next steps

Learn more about:

- [Azure Site Recovery](azure-site-recovery.md)
- [Azure Backup Server](/azure/backup/back-up-azure-stack-hyperconverged-infrastructure-virtual-machines)
