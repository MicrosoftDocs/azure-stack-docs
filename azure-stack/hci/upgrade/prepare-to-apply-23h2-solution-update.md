---
title: Upgrade Azure Stack HCI, version 22H2 to Azure Stack HCI, version 23H2
description: Learn how to upgrade from Azure Stack HCI, version 22H2 to Azure Stack HCI, version 23H2.
author: alkohli
ms.topic: how-to
ms.date: 07/02/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Upgrade from Azure Stack HCI, version 22H2 to Azure Stack HCI, version 23H2

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes how to upgrade from Azure Stack HCI 22H2 to version 23H2 in three steps:

1. Upgrade the operating system.
1. Prepare for the solution update.
1. Apply the solution update.

## Step 1: Upgrade the operating system

The Azure Stack HCI operating system update is available via Windows Update and via the downloadable media. The media is the same ISO file that is used for new deployments and can be downloaded via the [Azure portal](https://portal.azure.com/#view/Microsoft_Azure_HybridCompute/AzureArcCenterBlade/~/hciGetStarted).

There are different tools available to upgrade the operating system that include but aren't exclusive to built in tools like Cluster aware updating (CAU) and Server Configuration tool (SConfig).

Cluster aware updating orchestrates the process of applying the operating system automated to all cluster members using either Windows Update or ISO media.

For more information about available tools, see:

- [Cluster operating system rolling upgrade](https://learn.microsoft.com/windows-server/failover-clustering/cluster-operating-system-rolling-upgrade).
- [Update Azure HCI cluster (Applies to 23H2)](https://learn.microsoft.com/azure-stack/hci/manage/update-cluster).
- [Update a cluster using PowerShell](https://learn.microsoft.com/azure-stack/hci/manage/update-cluster#update-a-cluster-using-powershell).

### Check for updates using PowerShell

Use the `Invoke-CAUScan` cmdlet to scan servers for applicable updates and get a list of the initial set of updates that are applied to each server in a specified cluster:

```PowerShell
Invoke-CauScan -ClusterName Cluster1 -CauPluginName Microsoft.WindowsUpdatePlugin -Verbose
```

Generation of the list can take a few minutes to complete. The preview list includes only an initial set of updates; it doesn't include updates that might become applicable after the initial updates are installed.


### Install operating system updates using PowerShell

To scan servers for operating system updates and perform a full updating run on the specified cluster, use the `Invoke-CAURun` cmdlet:

```PowerShell
Invoke-CauRun -ClusterName Cluster1 -CauPluginName Microsoft.WindowsUpdatePlugin -MaxFailedNodes 1 -MaxRetriesPerNode 3 -RequireAllNodesOnline -EnableFirewallRules -Force
```

This command performs a scan and a full updating run on the cluster named Cluster1. This cmdlet uses the **Microsoft.WindowsUpdatePlugin** plug-in and requires that all cluster nodes be online before running this cmdlet. In addition, this cmdlet allows no more than three retries per node before marking the node as failed and allows no more than one node to fail before marking the entire updating run as failed. It also enables firewall rules to allow the servers to restart remotely. Because the command specifies the Force parameter, the cmdlet runs without displaying confirmation prompts.

The updating run process includes the following:

- Scanning for and downloading applicable updates on each server in the cluster
- Moving currently running clustered roles off each server
- Installing the updates on each server
- Restarting the server if required by the installed updates
- Moving the clustered roles back to the original server

The updating run process also includes ensuring that quorum is maintained, checking for additional updates that can only be installed after the initial set of updates are installed, and saving a report of the actions taken is completed.

### Install feature updates using PowerShell

To install feature updates using PowerShell, follow these steps. If your cluster is running Azure Stack HCI, version 20H2, be sure to apply the [May 20, 2021 preview update (KB5003237)](https://support.microsoft.com/topic/may-20-2021-preview-update-kb5003237-0c870dc9-a599-4a69-b0d2-2e635c6c219c) via Windows Update, or the `Set-PreviewChannel` cmdlet won't work.

1. Run the following cmdlets on every server in the cluster:

   ```PowerShell
   Set-WSManQuickConfig
   Enable-PSRemoting
   Set-NetFirewallRule -Group "@firewallapi.dll,-36751" -Profile Domain -Enabled true
   ```

2. To test whether the cluster is properly set up to apply software updates using Cluster-Aware Updating (CAU), run the `Test-CauSetup` cmdlet, which will notify you of any warnings or errors:

   ```PowerShell
   Test-CauSetup -ClusterName Cluster1
   ```

3. Validate the cluster's hardware and settings by running the `Test-Cluster` cmdlet on one of the servers in the cluster. If any of the condition checks fail, resolve them before proceeding to step 4.

   ```PowerShell
   Test-Cluster
   ```

4. Check for the feature update:

   ```PowerShell
   Invoke-CauScan -ClusterName <ClusterName> -CauPluginName "Microsoft.RollingUpgradePlugin" -CauPluginArguments @{'WuConnected'='true';} -Verbose | fl *
   ```

   Inspect the output of the above cmdlet and verify that each server is offered the same Feature Update, which should be the case.

5. You'll need a separate server or VM outside the cluster to run the `Invoke-CauRun` cmdlet from. **Important: The system on which you run `Invoke-CauRun` must be running either Windows Server 2022, Azure Stack HCI, version 21H2, or Azure Stack HCI, version 20H2 with the [May 20, 2021 preview update (KB5003237)](https://support.microsoft.com/topic/may-20-2021-preview-update-kb5003237-0c870dc9-a599-4a69-b0d2-2e635c6c219c) installed**.

   ```PowerShell
   Invoke-CauRun -ClusterName <ClusterName> -CauPluginName "Microsoft.RollingUpgradePlugin" -CauPluginArguments @{'WuConnected'='true';} -Verbose -EnableFirewallRules -Force
   ```

6. Check for any further updates and install them.

You're now ready to perform [post-installation steps for feature updates](#post-installation-steps-for-feature-updates).

## Check on the status of an updating run

An administrator can get summary information about an updating run in progress by running the `Get-CauRun` cmdlet:

```PowerShell
Get-CauRun -ClusterName Cluster1
```

Here's some sample output:

```output
RunId                   : 834dd11e-584b-41f2-8d22-4c9c0471dbad 
RunStartTime            : 10/13/2019 1:35:39 PM 
CurrentOrchestrator     : NODE1 
NodeStatusNotifications : { 
Node      : NODE1 
Status    : Waiting 
Timestamp : 10/13/2019 1:35:49 PM 
} 
NodeResults             : { 
Node                     : NODE2 
Status                   : Succeeded 
ErrorRecordData          : 
NumberOfSucceededUpdates : 0 
NumberOfFailedUpdates    : 0 
InstallResults           : Microsoft.ClusterAwareUpdating.UpdateInstallResult[] 
}
```

## Post-installation steps for feature updates

Once the feature updates are installed, you'll need to update the cluster functional level and update the storage pool version using PowerShell in order to enable new features.

   > [!IMPORTANT]
   > Azure Stack HCI clusters running Storage Replica will require each server to be restarted a second time after the 21H2 Feature update is complete before performing the post-installation steps. This is a known issue.

1. **Update the cluster functional level.**

   We recommend updating the cluster functional level as soon as possible. If you installed the feature updates with Windows Admin Center and checked the optional **Update the cluster functional level to enable new features** checkbox, you can skip this step.

   Run the following cmdlet on any server in the cluster:

   ```PowerShell
   Update-ClusterFunctionalLevel

   You'll see a warning that you can't undo this operation. Confirm **Y** that you want to continue.

   > [!WARNING]
   > After you update the cluster functional level, you can't roll back to the previous operating system version.

2. **Update the storage pool.**

   After the cluster functional level has been updated, use the following cmdlet to update the storage pool. Run `Get-StoragePool` to find the FriendlyName for the storage pool representing your cluster. In this example, the FriendlyName is **S2D on hci-cluster1**:

   ```PowerShell
   Update-StoragePool -FriendlyName "S2D on hci-cluster1"
   ```

   You'll be asked to confirm the action. At this point, new cmdlets will be fully operational on any server in the cluster.

3. **Upgrade VM configuration levels (optional).**

   You can optionally upgrade VM configuration levels by stopping each VM using the `Update-VMVersion` cmdlet and then starting the VMs again.

4. **Verify that the upgraded cluster functions as expected.**

   Roles should fail over correctly and, if VM live migration is used on the cluster, VMs should successfully live migrate.

5. **Validate the cluster.**

   Run the `Test-Cluster` cmdlet on one of the servers in the cluster and examine the cluster validation report.

## Perform a manual feature update of a Failover Cluster using SCONFIG

To do a manual feature update of a failover cluster, use the **SCONFIG** tool and Failover Clustering PowerShell cmdlets. To reference the **SCONFIG** document, see [Configure a Server Core installation of Windows Server and Azure Stack HCI with the Server Configuration tool (SConfig)](/windows-server/administration/server-core/server-core-sconfig)

For each node in the cluster, run these commands on the target node:

1. `Suspend-ClusterNode -Node<node> -Drain`

    Check suspend using `Get-ClusterGroup`--nothing should be running on the target node.

    Run the **SCONFIG** option 6.3 on the target node.

    After the target node has rebooted, wait for the storage repair jobs to complete by running `Get-Storage-Job` until there are no storage jobs or all storage jobs are completed.

2. `Resume-ClusterNode -Node <nodename> -Failback`

When all nodes have been upgraded, run these two cmdlets:

   `Update-ClusterFunctional Level`

   `Update-StoragePool`

## Perform a fast, offline update of all servers in a cluster

This method allows you to take all the servers in a cluster down at once and update them all at the same time. This saves time during the updating process, but the trade-off is downtime for the hosted resources.

If there is a critical security update that you need to apply quickly or you need to ensure that updates complete within your maintenance window, this method may be for you. This process brings down the Azure Stack HCI cluster, updates the servers, and brings it all up again.

1. Plan your maintenance window.
2. Take the virtual disks offline.
3. Stop the cluster to take the storage pool offline. Run the `Stop-Cluster` cmdlet or use Windows Admin Center to stop the cluster.
4. Set the cluster service to **Disabled** in Services.msc on each server. This prevents the cluster service from starting up while being updated.
5. Apply the Windows Server Cumulative Update and any required Servicing Stack Updates to all servers. You can update all servers at the same time: there's no need to wait because the cluster is down.
6. Restart the servers and ensure everything looks good.
7. Set the cluster service back to **Automatic** on each server.
8. Start the cluster. Run the `Start-Cluster` cmdlet or use Windows Admin Center.  
9. Give it a few minutes.  Make sure the storage pool is healthy.
10. Bring the virtual disks back online.
11. Monitor the status of the virtual disks by running the `Get-Volume` and `Get-VirtualDisk` cmdlets.

## Next steps

- [Learn how to prepare to apply solution update.](../index.yml)

## Step 2: Prepare for the solution update

The following sections document steps to prepare your system for the solution update.

### Validate upgrade readiness

We recommend that you use the environment checker to validate your system prior the solution update.  

A report will be generated with potential findings that require corrective actions to be ready for the solution update.

Some of the actions require server reboots. The information from the validation report will allow you to plan maintenance windows ahead of time to be ready.

The same checks are executed during the solution upgrade process to ensure your system meets the requirements.

List of validation tests with severity critical that will block upgrade. The following items must be addressed prior to the solution update.

| Name                              | Severity |
|-----------------------------------|----------|
| Windows OS is 23H2                | Critical |
| AKS HCI install state             | Critical |
| Supported cloud type              | Critical |
| Bitlocker suspension              | Critical |
| Cluster exists                    | Critical |
| All nodes in same cluster         | Critical |
| Cluster node is up                | Critical |
| Stretched cluster                 | Critical |
| Language is English               | Critical |
| MOC install state                 | Critical |
| MOC services running              | Critical |
| Network ATC feature is installed  | Critical |
| Required Windows features         | Critical |
| Storage pool                      | Critical |
| Storage volume                    | Critical |
| WDAC enablement                   | Critical |

List of validation tests with severity warning that should be addressed post upgrade to take advantage of new capabilities introduced with 23H2.

| Name                                           | Severity |
|------------------------------------------------|----------|
| TPM Property `OwnerClearDisabled` is False     | Warning  |
| TPM Property `TpmReady` is True                | Warning  |
| TPM Property `TpmPresent` is True              | Warning  |
| TPM Property `LockoutCount` is 0               | Warning  |
| TPM Property `TpmActivated` is True            | Warning  |
| TPM Property `ManagedAuthLevel` is Full        | Warning  |
| TPM Property `AutoProvisioning` is Enabled     | Warning  |
| TPM Property `LockedOut` is False              | Warning  |
| TPM Property `TpmEnabled` is True              | Warning  |

### Set up the environment validator

1. Select one server that's the part of the cluster.

1. Sign in to the server using local administrative credentials.

1. Install the environment checker on the server. Run the following PowerShell command from the PSGallery:

   ```powershell
   Install-Module -Name AzStackHci.EnvironmentChecker -allowclobber
   ```

### Run the validator

1. Sign in to the machine where you installed the environment checker using local administrative credentials.

1. To run the validation locally on the server, run the following PowerShell command:

   ```powershell
   Invoke-AzStackHciUpgradeValidation
   ```

1. To validate other servers in the cluster, run the following PowerShell command:

   ```powershell
   $PsSession=New-Pssession -computername "MyRemoteMachine"
   Invoke-AzStackHciUpgradeValidation -PsSession $PsSession
   ```

   Here's sample output:

   :::image type="content" source="./media/upgrade-22h2-to-23h2/sample-output-from-23h2-upgrade-enviro-validator.png" alt-text="Diagram that illustrates sample output from the 23H2 upgrade environment validator." lightbox="./media/upgrade-22h2-to-23h2/sample-output-from-23h2-upgrade-enviro-validator.png":::

1. (Optional) Use the `PassThru` flag to get the raw output that allows you to filter the output. Run the following command:

   ```powershell
   $result=Invoke-AzStackHciUpgradeValidation -PassThru
   $result | ? status -eq "failure" |ft displayname,status,severity
   ```

   Here's sample output:

   | DisplayName                                         | Status   | Severity |
   |-----------------------------------------------------|----------|----------|
   | Test Windows OS is 23H2                             | Failure  | Warning  |
   | Test Network ATC feature is installed on the node   | Failure | Warning |
   | Test required Windows features                      | Failure  | Warning  |
   | Test storage pool                                   | Failure  | Warning  |
   | Test TMP property `OwnerCleareDisabled` is False 22H2N1 | Failure  | Warning  |
   | Test TMP property `TmpPReady` is True 22H2N1        | Failure  | Warning  |
   | Test TMP property `TmpPresent` is True 22H2N1       | Failure  | Warning  |
   | Test TMP property `LockOutCount` is 0               | Failure  | Warning  |
   | Test TMP property `TmpActivated` is True 22H2N1     | Failure  | Warning  |
   | Test TMP property `AutoProvisioning` is Enabled 22H2N1 | Failure  | Warning  |
   | Test TMP property `TmpEnabled` is True 22H2N1       | Failure  | Warning  |

### Remediation guidance

Each validation check includes remediation guidance with links that provide guidance to resolve potential issues.

### Required Windows features

Azure Stack HCI version 23H2 requires a set of Windows roles and features to be installed. Some of them do require a restart so it is important you put the node into maintenance prior installing them. Verify all active virtual machines have been migrated to other cluster members.

Use the following commands for each servers to install the required features. If a feature is already present, it will skip it automatically.

```powershell
#Install Windows Roles & Features 
$windowsFeature =  @( 

                "Failover-Clustering",
                "NetworkATC", 
                "RSAT-AD-Powershell", 
                "RSAT-Hyper-V-Tools", 
                "Data-Center-Bridging", 
                "NetworkVirtualization", 
                "RSAT-AD-AdminCenter"
                ) 
foreach ($feature in $windowsFeature) 
{ 
install-windowsfeature -name $feature -IncludeAllSubFeature -IncludeManagementTools 
} 
@Install requires optional Windows features 
$windowsOptionalFeature = @( 

                "Server-Core", 
                "ServerManager-Core-RSAT", 
                "ServerManager-Core-RSAT-Role-Tools", 
                "ServerManager-Core-RSAT-Feature-Tools", 
                "DataCenterBridging-LLDP-Tools", 
                "Microsoft-Hyper-V", 
                "Microsoft-Hyper-V-Offline", 
                "Microsoft-Hyper-V-Online", 
                "RSAT-Hyper-V-Tools-Feature", 
                "Microsoft-Hyper-V-Management-PowerShell", 
                "NetworkVirtualization", 
                "RSAT-AD-Tools-Feature", 
                "RSAT-ADDS-Tools-Feature", 
                "DirectoryServices-DomainController-Tools", 
                "ActiveDirectory-PowerShell", 
                "DirectoryServices-AdministrativeCenter", 
                "DNS-Server-Tools", 
                "EnhancedStorage", 
                "WCF-Services45", 
                "WCF-TCP-PortSharing45", 
                "NetworkController", 
                "NetFx4ServerFeatures", 
                "NetFx4", 
                "MicrosoftWindowsPowerShellRoot", 
                "MicrosoftWindowsPowerShell", 
                "Server-Psh-Cmdlets", 
                "KeyDistributionService-PSH-Cmdlets", 
                "TlsSessionTicketKey-PSH-Cmdlets", 
                "Tpm-PSH-Cmdlets", 
                "FSRM-Infrastructure", 
                "ServerCore-WOW64", 
                "SmbDirect", 
                "FailoverCluster-AdminPak", 
                "Windows-Defender", 
                "SMBBW", 
                "FailoverCluster-FullServer", 
                "FailoverCluster-PowerShell", 
                "Microsoft-Windows-GroupPolicy-ServerAdminTools-Update", 
                "DataCenterBridging", 
                "BitLocker", 
                "Dedup-Core", 
                "FileServerVSSAgent", 
                "FileAndStorage-Services", 
                "Storage-Services", 
                "File-Services", 
                "CoreFileServer", 
                "SystemDataArchiver", 
                "ServerCoreFonts-NonCritical-Fonts-MinConsoleFonts", 
                "ServerCoreFonts-NonCritical-Fonts-BitmapFonts", 
                "ServerCoreFonts-NonCritical-Fonts-TrueType", 
                "ServerCoreFonts-NonCritical-Fonts-UAPFonts", 
                "ServerCoreFonts-NonCritical-Fonts-Support", 
                "ServerCore-Drivers-General", 
                "ServerCore-Drivers-General-WOW64", 
                "NetworkATC" 
            ) 
foreach ($featureName in $windowsOptionalFeature) 
{ 
enable-windowsoptionalfeature -featurename $featurename -all -online 
} 
```

### Cluster Node is up

Ensure all cluster members are up and report itself as online. You can use the Failover Cluster manager graphical interface or PowerShell to confirm all nodes are online.

Run the following PowerShell command to verify all members are online:

```powershell
Get-CluterNode -cluster mycluster 
```

### Stretched cluster

The team is working on supporting multi room clustering where cluster nodes are separated across two rooms. Stretch clustering is one implementation that does solve for long distances. Based on customer feedback, we are prioritizing a solution that is designed for short distances up to 1Km that is separating a cluster into availability zones by maintaining the operational management aspect of a single room cluster.

When running a stretch cluster, you must apply the operating system update which provides improvements using a new replication engine. We do understand this is a constraint as the Arc solution enablement will not be available for you initially.

### BitLocker Suspension

BitLocker must be disabled when applying the solution upgrade in case a reboot happens. In case of a reboot, the BitLocker recovery must be entered which will interrupt the upgrade process.

Use the following PowerShell command to suspend BitLocker:

```powershell
Suspend-Bitlocker -MountPoint “C:” -RebootCount 0 
```

After the upgrade you can resume BitLocker with the following PowerShell command:

```powershell
Resume-Bitlocker -MountPoint “C:”  
```

### WDAC Enablement

Active WDAC policies can conflict with the Arc solution enablement so they must be disabled prior. After the Arc solution has been enabled, WDAC can be enabled using the new 23H2 WDAC policies.

To learn more about how to disable WDAC policies, see [Remove Windows Defender Application Control policies - Windows Security | Microsoft Learn](https://learn.microsoft.com/windows/security/application-security/application-control/windows-defender-application-control/deployment/disable-wdac-policies).

### Language is English

Initially, only clusters that have been installed using an English language are eligible to apply the solution upgrade.

### Storage pool

Azure Stack HCI 23H2 does create a dedicated volume...
