---
title: Process for restoring AKS hybrid cluster from a disaster
author: baziwane
ms.topic: how-to
ms.date: 01/10/2023
ms.author: rbaziwane 
ms.lastreviewed: 01/10/2023
ms.reviewer: SethM
# Intent: As an IT Pro, I need to learn how to restore AKS hybrid following a disaster.
# Keyword: Disaster Recovery
---

# Restore the state of AKS clusters after a disaster

In AKS on Azure Stack HCI or Windows Server, the management cluster is deployed as a single standalone virtual machine (VM) per deployment, making it a single point of failure. It is important to note that a management cluster outage has zero impact on applications running in the workload clusters. When the management cluster VM fails, the workload clusters (and workloads) would continue running but you won’t be able to perform day-2 operations i.e., you are unable to create new workload clusters, unable to create or scale a node pool, unable to upgrade Kubernetes versions, etc., until the VM is restored. 

Note: The management cluster being a VM that is tracked in windows failover clustering, it is also resilient to host level disruptions. In other words, during a host machine failure windows failover clustering will restart the VM on a healthy host machine.  This document provides guidance on how to perform the following:    

- Restore the state of AKS onto new hardware (could be a new site).  
- Recovery from corruption of the management cluster  

Note that in either scenario above, the management cluster and all the workload clusters will need to be recreated.  

## Restore the state of AKS onto new hardware (or new site)  

Recovering the state of AKS clusters requires that you have a management cluster available on new hardware or at the new location. 

#### Important: 

- AKS supports backing up of Kubernetes clusters to Azure Blob storage and MinIO using Velero. Microsoft recommends backing up Azure storage because it provides 3 redundant copies of data in the primary storage region. 
- Consider running the backup on a cron job to ensure available backups will meet recovery point objectives.  

#### Prerequisites: 

Prepare the cold standby in advance of a disaster by creating a management cluster and an empty workload cluster. You need an empty workload cluster for each Kubernetes cluster you want to restore from backup. 

- Physical host machines are already set up and clustered 

- Configure required storage 

  - For SMB: [Use the AKS on Azure Stack HCI Files Container Storage Interface (CSI) drivers - AKS-HCI | Microsoft Learn](/azure/aks/hybrid/container-storage-interface-files) 

  - For Local Storage: [Use the AKS on Azure Stack HCI and Windows Server disk Container Storage Interface (CSI) drivers - AKS-HCI | Microsoft Learn](/azure/aks/hybrid/container-storage-interface-disks#create-a-custom-storage-class-for-an-aks-on-azure-stack-hci-and-windows-server-disk) 

  - Workload cluster backups are available: [How to create a backup of a Kubernetes workload cluster](/azure/aks/hybrid/backup-workload-cluster#use-velero-to-create-a-workload-cluster-backup) 

- An AKS (management cluster) is installed on new hardware OR you can install a new management cluster on new hardware using steps 1-5 of this documentation:  [Use PowerShell to set up Kubernetes on Azure Stack HCI and Windows Server clusters - AKS-HCI | Microsoft Learn](/azure/aks/hybrid/kubernetes-walkthrough-powershell)  
- An empty workload cluster is required to restore the backups 

#### Instructions:  

- [How to restore a workload cluster from a backup](/azure/aks/hybrid/backup-workload-cluster#use-velero-to-restore-a-workload-cluster) 

## Recovering from management cluster corruption

Recovering from a management cluster corruption requires uninstalling AKS and reinstalling the management cluster and all the workload clusters. Workload clusters can be restored into empty workload clusters from Velero backups.  

####  Prerequisites:  

- Workload cluster backups: [How to create a backup of a Kubernetes workload cluster](/azure/aks/hybrid/backup-workload-cluster#use-velero-to-create-a-workload-cluster-backup) 

- Backup of AKS configuration for previous networking, storage, and cluster settings. Cluster settings include sizes and counts of control plane, load balancer and worker node VMs. For example, if your old cluster had 3 `Standard_A2_V2` control plane VMs, you would want to create 3 control plane VMs in the new environment. 

#### Instructions: 

- Uninstall AKS: [Uninstall-AksHci for AKS on Azure Stack HCI and Windows Server - AKS-HCI | Microsoft Learn](/azure/aks/hybrid/reference/ps/uninstall-akshci)  
- Install a new AKS management cluster using steps 1-5 of this documentation:  [Use PowerShell to set up Kubernetes on Azure Stack HCI and Windows Server clusters - AKS-HCI | Microsoft Learn](/azure/aks/hybrid/kubernetes-walkthrough-powershell) 
- Create the workload cluster with required node pools using step 6 in the above documentation. You need a separate workload cluster for each workload cluster you are restoring from backup. 
- You can configure multiple control plane VMs and load balancer VMs during workload cluster creation using this documentation: [New-AksHciCluster for AKS on Azure Stack HCI and Windows Server - AKS-HCI | Microsoft Learn](/azure/aks/hybrid/reference/ps/new-akshcicluster) 
- Configure required storage 
  - For SMB: [Use the AKS on Azure Stack HCI Files Container Storage Interface (CSI) drivers - AKS-HCI | Microsoft Learn](/azure/aks/hybrid/container-storage-interface-files) 
  - For Local Storage: [Use the AKS on Azure Stack HCI and Windows Server disk Container Storage Interface (CSI) drivers - AKS-HCI | Microsoft Learn](/azure/aks/hybrid/container-storage-interface-disks#create-a-custom-storage-class-for-an-aks-on-azure-stack-hci-and-windows-server-disk)
- Restore all workload clusters from backup: How to restore a workload cluster from a backup 

## Frequently Asked Questions

### What resiliency is built into the management cluster?

Each AKS deployment includes a management cluster that is a single standalone VM. For resiliency and high availability, AKS relies on windows failover clustering to recover the VM in the event of a disruption. 
It is important to note that a management cluster outage has zero impact on applications running in workload clusters. When the management cluster VM goes down, this would only have impact on your ability to perform AKS Day 2 operations such as create new workload clusters, creating or scaling node pools, upgrading Kubernetes versions, etc until the VM is recovered. In cases where you are unable to recover from a management cluster failure, we recommend contacting Microsoft Support. In the future, we are moving towards a completely stateless management cluster where management cluster failure will not be a problem.

### What’s included in a Velero backup?  

| **File  Name**                       | **Content  description**                                     |
| ------------------------------------ | ------------------------------------------------------------ |
| *-csi-volumesnapshotclasses.json.gz  | Files containing ‘csi’  are the persistent volume snapshots  |
| *-csi-volumesnapshotcontents.json.gz | Files containing ‘csi’  are persistent volumes snapshots     |
| *-csi-volumesnapshots.json.gz        | Files containing ‘csi’  are the persistent volume snapshots  |
| *-logs.gz                            | Log output of backup operation.  Same data from running: velero backup log <backupname> |
| *-podvolumebackups.json.gz           | Metadata about the  pods and persistent volumes              |
| *-resource-list.json.gz              | Resources contained in  a backup are listed in this file     |
| *-volumesnapshots.json.gz            | Metadata about the  pods and persistent volumes              |
| *.tar.gz                             | Metadata  – namespace, # of pod replicas, memory, cpu. Same    data as returned from: kubectl get deployment |

### What's NOT included in Velero backups? 

The Velero backup does not include the following:

- Management cluster (AKS) configuration

- Control plane VM (API server) metadata  
- Load balancer (HA Proxy) metadata  
- Network settings  
- Storage settings 

### How do I backup the AKS configuration as before a disaster? 

To back up the management cluster configuration, open a PowerShell terminal and run the following command: 

 ``` PowerShell 
 PS C:\ > Get-AksHciConfig | ConvertTo-Json 
 ```

### How do we make sure the workload cluster has the same configuration as before a disaster?   

To back up the workload cluster configuration, open a PowerShell terminal and run the following command: 

``` PowerShell 
PS C:\> Get-AksHciCluster -name <cluster name> | ConvertTo-Json 
```
