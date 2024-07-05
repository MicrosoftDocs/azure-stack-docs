---
title: Prepare to Upgrade Azure Stack HCI, version 22H2 to Azure Stack HCI, version 23H2
description: Learn how to prepare to upgrade from Azure Stack HCI, version 22H2 to Azure Stack HCI, version 23H2.
author: alkohli
ms.topic: how-to
ms.date: 07/02/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Upgrade from Azure Stack HCI, version 22H2 to Azure Stack HCI, version 23H2

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes how to prepare your Azure Stack HCI solution update after the OS has been updated from v22H2 to v23H2. 

The upgrade from Azure Stack HCI 22H2 to version 23H2 occurs in three steps:

1. Upgrade the operating system.
1. Prepare for the solution update.
1. Apply the solution update.

This article only covers the second step, which is to prepare for the solution update.

## Prepare for the solution update

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
Suspend-Bitlocker -MountPoint "C:" -RebootCount 0 
```

After the upgrade you can resume BitLocker with the following PowerShell command:

```powershell
Resume-Bitlocker -MountPoint "C:" 
```

### WDAC Enablement

Active WDAC policies can conflict with the Arc solution enablement so they must be disabled prior. After the Arc solution has been enabled, WDAC can be enabled using the new 23H2 WDAC policies.

To learn more about how to disable WDAC policies, see [Remove Windows Defender Application Control policies - Windows Security | Microsoft Learn](/windows/security/application-security/application-control/windows-defender-application-control/deployment/disable-wdac-policies).

### Language is English

Initially, only clusters that have been installed using an English language are eligible to apply the solution upgrade.

### Storage pool

Azure Stack HCI 23H2 does create a dedicated volume...


## Next steps

- [Learn how to apply the solution update.](../index.yml)
