---
title: Validate solution upgrade readiness for Azure Local, version 23H2
description: Learn how to assess upgrade readiness for Azure Local, version 23H2 that already had its operating system upgraded from version 22H2.
author: alkohli
ms.topic: how-to
ms.date: 09/19/2025
ms.author: alkohli
ms.reviewer: alkohli
ms.service: azure-local
---

# Validate solution upgrade readiness for Azure Local

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2-22h2.md)]

This article describes how to assess the upgrade readiness of your Azure Local after the operating system (OS) was upgraded.

Throughout this article, we refer to OS version 24H2 or 23H2 as the *new* version, and version 22H2 as the *old* version.

## Assess solution upgrade readiness

This *recommended* step helps you assess the readiness of Azure Local for the upgrade. The following steps help you assess the upgrade readiness:

- Install and use the Environment Checker to verify that Network ATC is installed and enabled on the machine. Verify that there are no Preview versions for Azure Arc Resource Bridge running on your system.
- Ensure that sufficient storage space is available for the infrastructure volume.
- Perform other checks like installation of required Windows features, enablement of Application Control policies, BitLocker suspension, and OS language.
- Review and remediate validation checks that block the upgrade.

## Use Environment Checker to validate upgrade readiness

We recommend that you use the Environment Checker to validate your system readiness before you upgrade the solution. For more information, see [Assess environment readiness with Environment Checker](../manage/use-environment-checker.md). A report is generated with potential findings that require corrective actions to be ready for the solution update.

Some of the actions require machine reboots. The information from the validation report allows you to plan maintenance windows ahead of time to be ready. The same checks are executed during the solution upgrade to ensure your system meets the requirements.

### Table: Blocking validation tests for upgrade

The following table contains the validation tests with severity *Critical* that block the upgrade. Any items that block the upgrade must be addressed before you apply the solution upgrade.

| Name                              | Severity |
|-----------------------------------|----------|
| Windows OS is 23H2                | Critical |
| AKS HCI install state             | Critical |
| Supported cloud type              | Critical |
| BitLocker suspension              | Critical |
| Cluster exists                    | Critical |
| All nodes in same cluster         | Critical |
| Cluster node is up                | Critical |
| Stretched cluster <!--ASK-->      | Critical |
| Language is English               | Critical |
| Microsoft on-premises cloud (MOC) install state  | Critical |
| MOC services running              | Critical |
| Network ATC feature is installed  | Critical |
| Required Windows features         | Critical |
| Storage pool                      | Critical |
| Storage volume                    | Critical |
| Windows Defender for Application Control (WDAC) enablement      | Critical |

### Table: Non-blocking validation tests for upgrade

The following table contains the validation tests with severity *Warning* that should be addressed after the upgrade to take advantage of the new capabilities introduced with Azure Local 2311.2.

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

### Set up the Environment Checker

Follow these steps to set up the Environment Checker on a machine of your Azure Local system:

1. Select one machine that's a member of the system.

1. Sign in to the machine using local administrative credentials.

1. Install the Environment Checker on the machine. Run the following PowerShell command from the PSGallery:

   ```powershell
   Install-Module -Name AzStackHci.EnvironmentChecker -AllowClobber
   ```

### Run the validation

1. Sign in to the machine where you installed the Environment Checker using local administrative credentials.

1. To run the validation locally on the machine, run the following PowerShell command:

   ```powershell
   Invoke-AzStackHciUpgradeValidation
   ```

1. To remotely validate other machines in the system, run the following PowerShell command for each remote machine:

   ```powershell
   $PsSession=New-Pssession -ComputerName "MyRemoteMachine"
   Invoke-AzStackHciUpgradeValidation -PsSession $PsSession
   ```

   <details>
   <summary>Expand this section to see an example output.</summary>

   :::image type="content" source="./media/upgrade-22h2-to-23h2/sample-output-from-23h2-upgrade-enviro-validator.png" alt-text="Diagram that illustrates sample output from the upgrade environment validator." lightbox="./media/upgrade-22h2-to-23h2/sample-output-from-23h2-upgrade-enviro-validator.png":::

   </details>

1. (Optional) Use the `PassThru` flag to get the raw output that allows you to filter the output. Run the following command:

   ```powershell
   $result=Invoke-AzStackHciUpgradeValidation -PassThru
   $result | ? status -eq "failure" |ft displayname,status,severity
   ```

   <details>
   <summary>Expand this section to see an example output.</summary>

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

   </details>

## Remediation guidance

Each validation check of Environment Checker includes remediation guidance with links that help you resolve the potential issues. For more information, see [Remediation guidance](../manage/use-environment-checker.md#).

## Remediation 1: Install Windows features

Azure Local requires you to install specific Windows roles and features, and enable a set of required features (that are optional for Windows Server). Some features would require a restart after the installation. Hence, it's important that you put the machine into maintenance mode before you install the roles and features. Verify that all the active virtual machines (VMs) have migrated to other machines.

Use the following commands for each machine to install the required Windows roles and features. If a feature is already present, the install automatically skips it.

```powershell
#Install required Windows roles and features
$windowsRoleFeature =  @( 

                "Failover-Clustering",
                "FS-VSS-Agent", 
                "FS-Resource-Manager", 
                "GPMC", 
                "NetworkATC", 
                "NetworkController",
                "RSAT-AD-Powershell", 
                "RSAT-Hyper-V-Tools", 
                "Data-Center-Bridging", 
                "NetworkVirtualization", 
                "RSAT-AD-AdminCenter"
                )
foreach ($feature in $windowsRoleFeature) 
{ 
Install-WindowsFeature -Name $feature -IncludeAllSubFeature -IncludeManagementTools 
} 

#Enable a set of Windows features that are required for Azure Local, but optional for Windows Server
$windowsFeature = @( 

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
                "NetFx4ServerFeatures", 
                "NetFx4", 
                "MicrosoftWindowsPowerShellRoot", 
                "MicrosoftWindowsPowerShell", 
                "Server-Psh-Cmdlets", 
                "KeyDistributionService-PSH-Cmdlets", 
                "TlsSessionTicketKey-PSH-Cmdlets", 
                "Tpm-PSH-Cmdlets", 
                "ServerCore-WOW64", 
                "SmbDirect", 
                "FailoverCluster-AdminPak", 
                "Windows-Defender", 
                "SMBBW", 
                "FailoverCluster-FullServer", 
                "FailoverCluster-PowerShell", 
                "DataCenterBridging", 
                "BitLocker", 
                "Dedup-Core", 
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
foreach ($featureName in $windowsFeature) 
{ 
Enable-WindowsOptionalFeature -FeatureName $featurename -All -Online 
} 
```

## Remediation 2: Ensure that machines are up

Ensure that all the machines are up and that the system is *Online*. Use the Failover Cluster Manager UI or the PowerShell cmdlets to confirm that all the machines are online.

To verify all machines of the system are online, run the following PowerShell command:

```powershell
Get-ClusterNode -Cluster "mysystem" 
```

## Remediation 3: Suspend BitLocker

If a reboot occurs when applying the solution upgrade, disable BitLocker. If there's a reboot, you would need to enter the BitLocker recovery, which interrupts the upgrade process.

### Suspend BitLocker

To suspend BitLocker, run the following PowerShell command:

```powershell
Suspend-Bitlocker -MountPoint "C:" -RebootCount 0 
```

### Resume BitLocker

After the upgrade is complete, to resume BitLocker, run the following PowerShell command:

```powershell
Resume-Bitlocker -MountPoint "C:" 
```

## Remediation 4: Enable Application Control (WDAC) policies

If your system is running WDAC policies, it could result in a conflict with the Arc enablement of the solution. Before you Arc enable your system, disable the policies. After the system is Arc enabled, you can enable WDAC using the *new* version WDAC policies.

To learn more about how to disable WDAC policies, see [Remove Windows Defender Application Control policies](/windows/security/application-security/application-control/windows-defender-application-control/deployment/disable-wdac-policies).

## Remediation 5: Ensure language is English

Only systems installed using an English language are eligible to apply the solution upgrade. Make sure that your system was installed using English.

If you used the English ISO but configured a different language during setup, you must change the language settings for the LCM Upgrade user account as follows:

1. Sign in to each machine using the domain account you plan to use for the upgrade.

1. Run the following PowerShell commands:

    ```powershell
    $UserLanguageList = New-WinUserLanguageList -Language en-US
    Set-WinUserLanguageList -LanguageList $UserLanguageList
    ```

## Remediation 6: Check storage pool space

Azure Local 2311.2 creates a dedicated volume. This volume is used solely for the new infrastructure capabilities - for example, to run the Azure Arc Resource Bridge.

The required size for the infrastructure volume is 250 GB. Ensure that the storage pool has enough space to accommodate the new volume.

### Free up space in storage pool

Shrinking existing volumes isn't supported with Storage Spaces Direct. There are three alternatives to freeing up space in the storage pool:

- **Option 1**: Convert volumes from fixed to thin provisioned. Using thin provisioned volumes is also the default configuration when deploying a new system with the default setting.

- **Option 2**: Back up all the data, re-create the volume with a smaller size, and restore the content.

- **Option 3**: Add more physical drives to expand the pool capacity.

   > [!NOTE]
   > Before you convert the volumes to thin provisioned, shut down all the VMs stored on that particular volume.

### Verify available space

Follow these steps to confirm the storage pool configuration:

1. To confirm the storage pool size and allocated size, run the following PowerShell command:

   ```powershell
   Get-StoragePool -IsPrimordial $false
   ```

   <details>
   <summary>Expand this section to see an example output.</summary>

   | FriendlyName | OperationalStatus | HealthStatus | IsPrimordial | IsReadOnly | Size  | AllocatedSize |
   |--------------|-------------------|--------------|--------------|------------|-------|---------------|
   | S2D on venom  | OK                | Healthy      | False        | False       | 2 TB  | 1.53 TB        |

   </details>

1. To list all volumes in the storage pool, run the following PowerShell command:

   ```powershell
   Get-StoragePool -IsPrimordial $false | Get-VirtualDisk
   ```

   <details>
   <summary>Expand this section to see an example output.</summary>

   | FriendlyName | ResiliencySettingName | FaultDomainRedundancy | OperationalStatus | HealthStatus | Size | FootprintOnPool | StorageEfficiency |
   |--------------|-----------------------|-----------------------|------------------|--------------|------|-----------------|------------------|
   |ClusterPerformanceHistory | Mirror | 1 | OK | Healthy | 21 GB | 43 GB | 48.84% |
   | TestVolume | Mirror | 0 | OK | Healthy | 1 TB | 1 TB | 99.95% |
   | TestVolume2 | Mirror | 0 | OK | Healthy | 500 GB | 55.5 GB | 99.90% |

   </details>

1. To confirm that a fixed volume is provisioned, run the following PowerShell command:

   ```powershell
   $volume = Get-VirtualDisk -FriendlyName TestVolume
   $volume.ProvisioningType
   ```

   <details>
   <summary>Expand this section to see an example output.</summary>

   `Fixed`

   </details>

1. To convert the volume to thin provisioned, run the following PowerShell command:

   ```powershell
   Set-VirtualDisk -FriendlyName TestVolume -ProvisioningType Thin
   ```

1. To finish the conversion, the volume must be restarted. To do this, run the following PowerShell command. Make sure you adjust the CSV name to match your system:

   ```powershell
   Get-ClusterSharedVolume -Name "System Disk 1" | Stop-ClusterResource
   Get-ClusterSharedVolume -Name "System Disk 1" | Start-ClusterResource
   ```

1. To confirm that the actual footprint on the storage pool has changed, run the following PowerShell command:

   ```powershell
   Get-StoragePool -IsPrimordial $false| Get-VirtualDisk
   ```

   <details>
   <summary>Expand this section to see an example output.</summary>

   | FriendlyName | ResiliencySettingName | FaultDomainRedundancy | OperationalStatus | HealthStatus | Size | FootprintOnPool | StorageEfficiency |
   |--------------|-----------------------|-----------------------|------------------|--------------|------|-----------------|------------------|
   | ClusterPerformanceHistory | Mirror | 1 | OK | Healthy | 21 GB | 43 GB | 48.84% |
   | TestVolume | Mirror | 0 | OK | Healthy | 1 TB | 36.5 GB | 98.63% |
   | TestVolume2 | Mirror | 0 | OK | Healthy | 750 GB | 28.5 GB | 98.25% |

   </details>

## Remediation 7: Check the storage volume name

Azure Local 2311.2 deployment creates a dedicated volume *Infrastructure_1* in the existing storage pool. This volume is dedicated for the new infrastructure capabilities.

Make sure to verify that there are no volumes that exist with the name *Infrastructure_1*. If there's an existing volume with the same name, this test fails.<!--ASK which test fails-->

> [!NOTE]
> Renaming the existing volume impacts the VMs as the mount point of the cluster shared volume changes. Additional configuration changes are required for all the VMs.

- To rename the existing volume, run the following PowerShell command:

   ```powershell
   Set-VirtualDisk -FriendlyName Infrastructure_1 -NewFriendlyName NewName
   ```

## Remediation 8: Check the cluster functional level and storage pool version

Make sure that the cluster functional level and storage pool version are up to date. For more information, see [Update the cluster functional level and storage pool version](./post-upgrade-steps.md#step-3-perform-the-post-os-upgrade-steps).

## Remediation 9: Check the Azure Arc Lifecycle extension

1. Review the extension status using the Azure Arc resource view.

    :::image type="content" source="./media/install-solution-upgrade/upgrade-22h2-to-23h2-azureedgelcm-extension.png" alt-text="Screenshot of Azure Arc extensions list view." lightbox="./media/install-solution-upgrade/upgrade-22h2-to-23h2-azureedgelcm-extension.png":::

   If an update is available, select the **AzureEdgeLifecycleManager** extension and then select **Update**.

1. If the **AzureEdgeLifecycleManager** extension isn't listed, install it manually using the following steps on each machine:

   ```powershell
   $ResourceGroup = "Your Resource Group Name"
   $Region = "eastus" #replace with your region
   $tenantid = "Your tenant ID"
   $SubscriptionId = "Your Subscription ID"
   Login-AzAccount –UseDeviceAuthentication –tenantid  $tenantid –subscriptionid $SubscriptionId
   Install-module az.connectedmachine
   New-AzConnectedMachineExtension -Name "AzureEdgeLifecycleManager" -ResourceGroupName $ResourceGroup -MachineName $env:COMPUTERNAME -Location $Region -Publisher "Microsoft.AzureStack.Orchestration" -ExtensionType "LcmController" -NoWait
   ```

## Remediation 10: Check the MOC install state

Follow these steps to apply solution upgrade if you're running Azure Kubernetes Service (AKS) workloads on your Azure Local:

1. Wait for the solution upgrade banner to appear on your Azure Local resource page.
1. Remove AKS and all the settings from AKS hybrid before you apply the solution upgrade. Kubernetes versions are incompatible between the *old* and *new* versions of Azure Local. Additionally, preview versions of Azure Local VMs enabled by Azure Arc can't be updated.

For more information, see [Uninstall-Aks-Hci for AKS enabled by Azure Arc](/azure/aks/hybrid/reference/ps/uninstall-akshci).

Once you uninstall AKS Arc, you must uninstall the **AksHci** Powershell module using the followng command, as this module does not work on 23H2 and later:

```powershell
Uninstall-Module -Name AksHci -Force
```

To avoid any PowerShell version-related issues in your AKS deployment, you can use this [helper script to delete old AKS-HCI PowerShell modules](https://github.com/Azure/aksArc/issues/130).

1. If you have used the preview version of AKS Arc on 22H2 or the preview version of Arc VM on 22H2, uninstall MOC by running the command `Uninstall-Moc` on a Azure Local node, to remove the VM instances created using the preview version.

## Remediation 11: Check the AKS install state

Follow these steps to apply solution upgrade if you're running AKS workloads on your Azure Local:

1. Wait for the solution upgrade banner to appear on your Azure Local resource page.
1. Remove AKS and all the settings from AKS hybrid before you apply the solution upgrade. Kubernetes versions are incompatible between the *old* and *new* versions of Azure Local.

For more information, see [Uninstall-Aks-Hci for AKS enabled by Azure Arc](/azure/aks/hybrid/reference/ps/uninstall-akshci).

Once you uninstall AKS Arc, you must uninstall the **AksHci** Powershell module using the followng command, as this module does not work on 23H2 and later:

```powershell
Uninstall-Module -Name AksHci -Force
```

To avoid any PowerShell version-related issues in your AKS deployment, you can use this [helper script to delete old AKS-HCI PowerShell modules](https://github.com/Azure/aksArc/issues/130).

## Next steps

- [Learn how to apply the solution upgrade.](./install-solution-upgrade.md)
