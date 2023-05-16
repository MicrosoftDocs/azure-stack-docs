---
title: Manage capacity by adding a server of Azure Stack HCI. (preview)
description: Learn how to manage capacity on your Azure Stack HCI by adding a server. (preview)
ms.topic: article
author: alkohli
ms.author: alkohli
ms.date: 05/16/2023
---

# Repair a server on your Azure Stack HCI (preview)

[!INCLUDE [hci-applies-to-22h2-later](../../includes/hci-applies-to-22h2-later.md)]

This article describes how to repair a server on your Azure Stack HCI cluster.

[!INCLUDE [hci-preview](../../includes/hci-preview.md)]

## About repair servers

Azure Stack HCI is a hyperconverged system that allows you to scale compute and storage at the same time by adding servers to an existing cluster. Azure Stack HCI cluster supports a maximum of up to 16 nodes.

You can dynamically scale your Azure Stack HCI cluster from 1 to 16 nodes. In response to the scaling, Azure Stack HCI Orchestrator adjusts the drive resiliency, network configuration including the on-premises agents such as Lifecycle Manager agents, and Arc registration.

The dynamic scaling may require the network architecture change from connected without a switch to connected via a network switch.

> [!IMPORTANT]
> - It is not possible to permanently remove a server from a cluster.

Before you repair a server, make sure to check with your solution provider, which components on the server are field replacement units (FRUs) that you can replace yourself and which components would require a technician to replace. Any component replacement requires a reimaging of the server.

## Repair server workflow

The following flow diagram shows the overall process to repair a server.

<!--![Diagram illustrating the repair server process](media/5c6250989cdee68489da5846900a2494.png)-->

\**Server may not be in a state where shutdown is possible/necessary*

To repair an existing server, follow these high-level steps:

1. If possible, shut down the server that you want to repair. Depending on the state of the server, a shutdown may not be possible or necessary.
1. Remove this server temporarily from the cluster.
1. Reimage the server that needs to be repaired. Install the Azure Stack HCI OS, drivers, and firmware.
1. Add the repaired server back to the cluster. The storage will be automatically rebalanced on the reimaged server.

Take into considerations the following limitations:

- The operations to add a sever includes two phases: compute and storage
- Storage phase is doing a rebalance which is a low priority task to not impact actual workloads and can run multiple days depending on number of nodes and used storage.


## Supported scenarios

Repairing a server will re-image a server and bring it back to the cluster with the previous name and configuration. Repairing a single node cluster will result in a re-deployment with the option to persist the data volumes. Only the system volume will be deleted and newly provisioned during deployment.

It is critical to ensure you always have backups for your workloads and do not rely on the system resiliency only, especially in single node cluster scenarios.

### Hardware requirements

When repairing a server, the system validates the hardware of the new, incoming node and ensures that the node meets the hardware requirements before it's added to the cluster.

Here's a list of hardware components that are checked:

| **Component** | **Compliancy check**               |
|---------------|------------------------------------|
| CPU           | Validate the new server has the same number of or more CPU cores. If the CPU cores on the incoming node don't meet this requirement, a warning is presented. The operation is however allowed.                             |
| Memory        | Validate the new server has the same amount of or more memory installed. If the memory on the incoming node doesn't meet this requirement, a warning is presented. The operation is however allowed.                         |
| Drives        | Validate the new server has the same number of data drives available for Storage Spaces Direct. If the number of drives on the incoming node don't meet this requirement, an error is reported and the operation is blocked. |

## Prerequisites

Before you add a server, you must ensure that:

- Deployment user is active in Active Directory.
- Signed in as deployment user or another user with equivalent permissions.
- Credentials for the deployment user haven't changed.

## Repair a server

This section describes how to add a server using PowerShell, monitor the status of the `Add-Server` operation and troubleshoot, if there are any issues.

Make sure that you have reviewed the [prerequisites](#prerequisites). Follow these steps to repair a server.

1. Install the operating system and required drivers. Follow the steps in [Install the Azure Stack HCI, version 22H2 Operating System](../deploy/deployment-tool-install-os.md).

**Note**: You must also [Install required Windows Roles](../deploy/deployment-tool-install-os.md#install-required-windows-roles).

1. Sign in with local administrator account, into the server that will be repaired.
1. Patch the server to ensure it has the same OS level as the servers that are already part of the cluster.

    ```powershell
    # Retrieve incoming server's OS build version and installed KBs 

    Set-Item WSMan:\LocalHost\Client\TrustedHosts -Value "s-cluster" -Force
    
    $IncomingNodeVersionStr = cmd /c ver 
    
    "$IncomingNodeVersionStr" -match "\d+\.\d+\.\d+\.\d+" | Out-Null 
    
    $IncomingNodeBuildOsVersion = $Matches[0] 
    
    Write-Host "Incoming node's Build Version: $IncomingNodeBuildOsVersion" -ForegroundColor Black -BackgroundColor Yellow 
    
     
    
    # Retrieve cluster's OS build version and installed KBs 
    
    $ClusterNodeVersionStr = Invoke-Command -Computer s-cluster { cmd /c ver } -Credential $LocalAdmin 
    
    "$ClusterNodeVersionStr" -match "\d+\.\d+\.\d+\.\d+" | Out-Null 
    
    $ClusterNodeBuildOsVersion = $Matches[0] 
    
    Write-Host "Cluster's Build Version: $ClusterNodeBuildOsVersion" -ForegroundColor Black -BackgroundColor Yellow 
    
     
    
    # Checking KBs on incoming node 
    
    $IncomingNodeKBs = (Get-Hotfix).HotfixID 
    
    $IncomingNodeKBsStr = $IncomingNodeKBs -join "," 
    
    Write-Host "Current KBs installed on incoming node: $IncomingNodeKBsStr" -ForegroundColor Black -BackgroundColor Yellow 
    
     
    
    # Checking KBs on cluster 
    
    $ClusterNodeKBs = Invoke-Command -Computer s-cluster { (Get-Hotfix).HotfixID } -Credential $LocalAdmin 
    
    $ClusterNodeKBsStr = $ClusterNodeKBs -join "," 
    
    Write-Host "Current KBs installed in cluster: $ClusterNodeKBsStr" -ForegroundColor Black -BackgroundColor Yellow 
    
     
    
    # Detecting KBs missing from incoming node 
    
    $KbsToInstall = [string[]]((Compare-Object -ReferenceObject $clusterNodeKBs -DifferenceObject $IncomingNodeKBs | Where-Object { $_.SideIndicator -eq '<=' }).InputObject) 
    
    Write-Host "KBs to install: $($KbsToInstall -join ",")" -ForegroundColor Black -BackgroundColor Yellow 
    
     
    
    # Installing KBs    
    
    Install-Module –Name PSWindowsUpdate -Force -Confirm:$false 
    
    Import-Module PSWindowsUpdate 
    
    Install-WindowsUpdate -KBArticleID $KbsToInstall -AcceptAll –IgnoreReboot -Verbose 
    
    Remove-Module -Name PSWindowsUpdate –Force 
    
     
    
    # Retrieve incoming server's OS build version and installed KBs after installation 
    
    $IncomingNodeVersionStr = cmd /c ver 
    
    "$IncomingNodeVersionStr" -match "\d+\.\d+\.\d+\.\d+" | Out-Null 
    
    $IncomingNodeBuildOsVersion = $Matches[0] 
    
    Write-Host "Incoming node's build version: $IncomingNodeBuildOsVersion" -ForegroundColor Black -BackgroundColor Green 
    
     
    
    # Retrieve cluster's OS Build version and installed KBs after installation 
    
    $ClusterNodeVersionStr = Invoke-Command -Computer s-cluster { cmd /c ver } -Credential $LocalAdmin 
    
    "$ClusterNodeVersionStr" -match "\d+\.\d+\.\d+\.\d+" | Out-Null 
    
    $ClusterNodeBuildOsVersion = $Matches[0] 
    
    Write-Host "Cluster's Build Version: $ClusterNodeBuildOsVersion" -ForegroundColor Black -BackgroundColor Green 
    
     
    
    # Checking KBs on incoming node after installation 
    
    $IncomingNodeKBs = (Get-hotfix).HotfixID 
    
    $IncomingNodeKBsStr = $incomingNodeKBs -join "," 
    
    Write-Host "Current KBs installed on incoming node: $IncomingNodeKBsStr" -ForegroundColor Black -BackgroundColor Green 
    
     
    
    # Checking KBs on cluster after installation 
    
    $ClusterNodeKBs = Invoke-Command -Computer s-cluster { (Get-Hotfix).HotfixID } -Credential $LocalAdmin 
    
    $ClusterNodeKBsStr = $ClusterNodeKBs -join "," 
    
    Write-Host "Current KBs installed in cluster:    
    ```

1. Close all the PowerShell session on the server you're signed in.
1. In a new PowerShell session, run the following command:

    ```powershell
    Uninstall-Module –Name PSWindowsUpdate –Force
    ```

1. Sign in with the lifecycle manager account into a server that is already a member of the cluster. Run the following command to add the new server

    ```powershell
    $Cred = Get-Credential 
    Repair-Server -Name "< Name of the new server>" -LocalAdminCredential $Cred
    ```

1. Make a note of the operation ID as output by the `Repair-Server` command. You use this later to monitor the progress of the `Repair-Server` operation.

### Monitor operation progress

To monitor the progress of the add server operation, follow these steps:

1. Run the following cmdlet and provide the operation ID from the previous step.

    ```powershell
    $ID = "<Operation ID>" 
    Start-MonitoringActionplanInstanceToComplete -actionPlanInstanceID $ID 
    ```

1. After the add server operation is complete, the background storage rebalancing job will continue to run. To verify the progress of this storage rebalancing job, use the following cmdlet:

    ```powershell
    Get-VirtualDisk Get-StorageJob
    ```

    If the storage job is complete, the cmdlet won't return an output.

### Troubleshooting

1. If you experience failures or errors while repairing a server, you can capture the output of the failures in a log file.

    ```powershell
    Get-ActionPlanInstance -actionPlanInstanceID $ID |out-file log.txt
    ```

1. To rerun the failed operation, use the following cmdlet:

    ```powershell
    Repair-Server -Rerun
    ```


## Next steps

[Learn more about Hybrid capabilities with Azure services](../hybrid-capabilities-with-azure-services.md)
