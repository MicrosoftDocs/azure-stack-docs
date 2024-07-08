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

# Prepare to upgrade from Azure Stack HCI, version 22H2 to Azure Stack HCI, version 23H2

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes how to prepare your Azure Stack HCI solution update after the OS has been updated from v22H2 to v23H2.

The upgrade from Azure Stack HCI 22H2 to version 23H2 occurs in the following steps:

1. Upgrade the operating system.
1. Prepare for the solution update.
1. Apply the solution update.

This article only covers the second step, which is to prepare for the solution update.

## Prepare for the solution update

The following sections document steps to prepare your system for the solution update.

### Validate upgrade readiness

We recommend that you use the environment checker to validate your system readiness prior to the solution update. For more information, see [Assess environment readiness with Environment Checker](../manage/use-environment-checker.md).

A report is generated with potential findings that require corrective actions to be ready for the solution update.

Some of the actions require server reboots. The information from the validation report allows you to plan maintenance windows ahead of time to be ready.

The same checks are executed during the solution upgrade process to ensure your system meets the requirements.

The following table contains the validation tests with severity *Critical* that block the upgrade. Any items that block the upgrade must be addressed prior to the solution update.

| Name                              | Severity |
|-----------------------------------|----------|
| Windows OS is 23H2                | Critical |
| AKS HCI install state             | Critical |
| Supported cloud type              | Critical |
| BitLocker suspension              | Critical |
| Cluster exists                    | Critical |
| All nodes in same cluster         | Critical |
| Cluster node is up                | Critical |
| Stretched cluster                 | Critical |
| Language is English               | Critical |
| Microsoft on-premises cloud (MOC) install state  | Critical |
| MOC services running              | Critical |
| Network ATC feature is installed  | Critical |
| Required Windows features         | Critical |
| Storage pool                      | Critical |
| Storage volume                    | Critical |
| Windows Defender for Application Control (WDAC) enablement      | Critical |

The following table contains the validation tests with severity *Warning* that should be addressed after the upgrade to take advantage of the new capabilities introduced with Azure Stack HCI, version 23H2.

| Name                                           | Severity |
|------------------------------------------------|----------|
| Trusted Platform Module (TPM) Property `OwnerClearDisabled` is False     | Warning  |
| TPM Property `TpmReady` is True                | Warning  |
| TPM Property `TpmPresent` is True              | Warning  |
| TPM Property `LockoutCount` is 0               | Warning  |
| TPM Property `TpmActivated` is True            | Warning  |
| TPM Property `ManagedAuthLevel` is Full        | Warning  |
| TPM Property `AutoProvisioning` is Enabled     | Warning  |
| TPM Property `LockedOut` is False              | Warning  |
| TPM Property `TpmEnabled` is True              | Warning  |

### Set up the environment validator

Follow these steps to set up the environment validator:

1. Select one server that's the part of the cluster.

1. Sign in to the server using local administrative credentials.

1. Install the environment checker on the server. Run the following PowerShell command from the PSGallery:

   ```powershell
   Install-Module -Name AzStackHci.EnvironmentChecker -allowclobber
   ```

### Run the validator

1. Sign in to the server where you installed the environment checker using local administrative credentials.

1. To run the validation locally on the server, run the following PowerShell command:

   ```powershell
   Invoke-AzStackHciUpgradeValidation
   ```

1. To validate other servers in the cluster, run the following PowerShell command:

   ```powershell
   $PsSession=New-Pssession -computername "MyRemoteMachine"
   Invoke-AzStackHciUpgradeValidation -PsSession $PsSession
   ```

   Here's a sample output:

   :::image type="content" source="./media/upgrade-22h2-to-23h2/sample-output-from-23h2-upgrade-enviro-validator.png" alt-text="Diagram that illustrates sample output from the 23H2 upgrade environment validator." lightbox="./media/upgrade-22h2-to-23h2/sample-output-from-23h2-upgrade-enviro-validator.png":::

1. (Optional) Use the `PassThru` flag to get the raw output that allows you to filter the output. Run the following command:

   ```powershell
   $result=Invoke-AzStackHciUpgradeValidation -PassThru
   $result | ? status -eq "failure" |ft displayname,status,severity
   ```

   Here's a sample output:

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

Each validation check includes remediation guidance with links that help you resolve the potential issues.

### Install required Windows features

Azure Stack HCI, version 23H2 requires a set of Windows roles and features to be installed. Some features would require a restart after the installation. Hence, it is important that you put the server node into maintenance prior to installing them. Verify that all the active virtual machines have been migrated to other cluster members.

Use the following commands for each server to install the required features. If a feature is already present, the install automatically skips it.

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

### Ensure that cluster dnde is up

Ensure that all the cluster members are up and that the cluster is *Online*. Use the Failover Cluster manager UI or the PowerShell cmdlets to confirm that all the cluster nodes are online.

To verify all members of the cluster are online, run the following PowerShell command:

```powershell
Get-CluterNode -cluster "mycluster" 
```

<!--### Stretched cluster

The team is working on supporting multi room clustering where cluster nodes are separated across two rooms. Stretch clustering is one implementation that does solve for long distances. Based on customer feedback, we are prioritizing a solution that is designed for short distances up to 1Km that is separating a cluster into availability zones by maintaining the operational management aspect of a single room cluster.

When running a stretch cluster, you must apply the operating system update, which provides improvements using a new replication engine. We do understand this is a constraint as the Arc solution enablement won't be available for you initially.-->

### Suspend BitLocker

If a reboot occurs when applying the solution upgrade, disable BitLocker. If there is a reboot, you would need to enter the BitLocker recovery which interrupts the upgrade process.

To suspend BitLocker, run the following PowerShell command:

```powershell
Suspend-Bitlocker -MountPoint "C:" -RebootCount 0 
```

After the upgrade is complete, to resume BitLocker, run the following PowerShell command:

```powershell
Resume-Bitlocker -MountPoint "C:" 
```

### Enable WDAC policies

If your cluster is running WDAC policies, it could result in a conflict with the Arc enablement of the solution. Before you arc enable your cluster, disable the policies. After the cluster is Arc enabled, you can enable WDAC using the new 23H2 WDAC policies.

To learn more about how to disable WDAC policies, see [Remove Windows Defender Application Control policies](/windows/security/application-security/application-control/windows-defender-application-control/deployment/disable-wdac-policies).

### Ensure language is English

Only clusters installed using an English language are eligible to apply the solution upgrade. Make sure that your cluster was installed using English.

### Check storage pool space

Azure Stack HCI, version 23H2 creates a dedicated volume. Ensure that the storage pool has enough space to accommodate the new volume.


## Next steps

- [Learn how to apply the solution update.](../index.yml)
