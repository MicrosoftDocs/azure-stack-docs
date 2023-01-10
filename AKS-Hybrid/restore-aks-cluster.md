---
title: Process for restoring AKS hybrid cluster from a disaster
description: Learn how to restore AKS hybrid clusters after a disaster.
author: baziwane
ms.topic: how-to
ms.date: 01/10/2023
ms.author: rbaziwane 
ms.lastreviewed: 01/10/2023
ms.reviewer: rbaziwane
# Intent: As an IT Pro, I need to learn how to restore AKS hybrid following a disaster.
# Keyword: Disaster Recovery
---

# Restore the state of AKS clusters after a disaster

In AKS on Azure Stack HCI or Windows Server, the management cluster is deployed as a single standalone virtual machine (VM) per deployment, making it a single point of failure. It is important to note that a management cluster outage has no impact on applications running in the workload clusters. When the management cluster VM fails, the workload clusters (and workloads) continue running, but you won't be able to perform day-2 operations. For example, you cannot create new workload clusters, create or scale a node pool, or upgrade Kubernetes versions, until the VM is restored.

The management cluster is a VM that's tracked in Windows failover clustering. It is also resilient to host-level disruptions. In other words, during a host machine failure, Windows failover clustering restarts the VM on a healthy host machine. This article provides guidance on how to perform the following tasks:

- Restore the state of AKS on new hardware (could be a new site).  
- Recovery from corruption of the management cluster.

In either of these scenarios, the management cluster and all the workload clusters must be recreated.  

## Restore the state of AKS on new hardware (or a new site)  

Recovering the state of AKS clusters requires that you have a management cluster available on new hardware or at the new location.

- AKS supports backing up Kubernetes clusters to Azure Blob Storage and MinIO using Velero. Microsoft recommends backing up Azure Storage because it provides 3 redundant copies of data in the primary storage region.
- Consider running the backup on a cron job to ensure available backups meet recovery point objectives.  

### Prerequisites

Prepare the cold standby in advance of a disaster by creating a management cluster and an empty workload cluster. You need an empty workload cluster for each Kubernetes cluster you want to restore from backup. The following prerequisites are required:

- Set up and cluster physical host machines.
- Configure required storage.
- For SMB: [Use the AKS on Azure Stack HCI Files Container Storage Interface (CSI) drivers](/azure/aks/hybrid/container-storage-interface-files).
- For local storage: [Use the AKS on Azure Stack HCI and Windows Server disk Container Storage Interface (CSI) drivers](/azure/aks/hybrid/container-storage-interface-disks#create-a-custom-storage-class-for-an-aks-on-azure-stack-hci-and-windows-server-disk).
- Workload cluster backups are available: [How to create a backup of a Kubernetes workload cluster](/azure/aks/hybrid/backup-workload-cluster#use-velero-to-create-a-workload-cluster-backup).
- An AKS (management cluster) is installed on new hardware, or you can install a new management cluster on new hardware using steps 1-5 of this article: [Use PowerShell to set up Kubernetes on Azure Stack HCI and Windows Server clusters](/azure/aks/hybrid/kubernetes-walkthrough-powershell).
- An empty workload cluster is required to restore the backups. See [How to restore a workload cluster from a backup](/azure/aks/hybrid/backup-workload-cluster#use-velero-to-restore-a-workload-cluster).

## Recover from management cluster corruption

Recovering from a management cluster corruption requires uninstalling AKS and reinstalling the management cluster and all the workload clusters. Workload clusters can be restored into empty workload clusters from Velero backups.  

### Prerequisites

- Workload cluster backups: [How to create a backup of a Kubernetes workload cluster](/azure/aks/hybrid/backup-workload-cluster#use-velero-to-create-a-workload-cluster-backup).
- Backup of AKS configuration for previous networking, storage, and cluster settings. Cluster settings include sizes and counts of control plane, load balancer and worker node VMs. For example, if your old cluster had 3 **Standard_A2_V2** control plane VMs, you must create 3 control plane VMs in the new environment.

To recover from management cluster corruption, perform the following steps:

- Uninstall AKS: [Uninstall-AksHci for AKS on Azure Stack HCI](/azure/aks/hybrid/reference/ps/uninstall-akshci).
- Install a new AKS management cluster using steps 1-5 of this article: [Use PowerShell to set up Kubernetes on Azure Stack HCI and Windows Server clusters](/azure/aks/hybrid/kubernetes-walkthrough-powershell).
- Create the workload cluster with required node pools using step 6 in the above article. You need a separate workload cluster for each workload cluster you are restoring from backup.
- You can configure multiple control plane VMs and load balancer VMs during workload cluster creation using this article: [New-AksHciCluster for AKS on Azure Stack HCI and Windows Server](/azure/aks/hybrid/reference/ps/new-akshcicluster).
- Configure required storage:
  - For SMB: [Use the AKS on Azure Stack HCI Files Container Storage Interface (CSI) drivers](/azure/aks/hybrid/container-storage-interface-files).
  - For local storage: [Use the AKS hybrid disk Container Storage Interface (CSI) drivers](/azure/aks/hybrid/container-storage-interface-disks#create-a-custom-storage-class-for-an-aks-on-azure-stack-hci-and-windows-server-disk).
- Restore all workload clusters from backup.

## FAQ

### What resiliency is built into the management cluster?

Each AKS deployment includes a management cluster that is a single standalone VM. For resiliency and high availability, AKS relies on windows failover clustering to recover the VM in the event of a disruption.

It is important to note that a management cluster outage has no impact on applications running in workload clusters. When the management cluster VM goes down, this impacts your ability to perform AKS Day 2 operations, such as create new workload clusters, create or scale node pools, upgrade Kubernetes versions, etc., until the VM is recovered. In cases where you are unable to recover from a management cluster failure, we recommend contacting Microsoft Support.

### What's included in a Velero backup?  

| Filename                       | Content description                                     |
| ------------------------------------ | ------------------------------------------------------------ |
| *-csi-volumesnapshotclasses.json.gz  | Files containing 'csi' are the persistent volume snapshots.  |
| *-csi-volumesnapshotcontents.json.gz | Files containing 'csi' are persistent volumes snapshots.     |
| *-csi-volumesnapshots.json.gz        | Files containing 'csi' are the persistent volume snapshots.  |
| *-logs.gz                            | Log output of backup operation. Same data from running: velero backup log \<backupname\>. |
| *-podvolumebackups.json.gz           | Metadata about the pods and persistent volumes.              |
| *-resource-list.json.gz              | Resources contained in a backup are listed in this file.     |
| *-volumesnapshots.json.gz            | Metadata about the pods and persistent volumes.              |
| *.tar.gz                             | Metadata – namespace, number of pod replicas, memory, cpu. Same data as returned from: `kubectl get deployment`. |

### What's not included in Velero backups? 

The Velero backup does not include the following:

- Management cluster (AKS) configuration
- Control plane VM (API server) metadata  
- Load balancer (HA Proxy) metadata  
- Network settings  
- Storage settings 

### How do I back up the AKS configuration before a disaster?

To back up the management cluster configuration, open a PowerShell terminal and run the following command: 

 ```PowerShell
 Get-AksHciConfig | ConvertTo-Json 
 ```

### How do I make sure the workload cluster has the same configuration as before a disaster?

To back up the workload cluster configuration, open a PowerShell terminal and run the following command: 

``` PowerShell 
Get-AksHciCluster -name <cluster name> | ConvertTo-Json 
```
