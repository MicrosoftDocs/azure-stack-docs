---
title: Enable External Storage (SAN) on Azure Local
description: Describes how to enable integration of external Storage from various SAN vendors to Azure Local.
author: shriramnat
ms.author: shnatara
ms.reviewer: ronmiab
ms.topic: how-to
ms.date: 03/27/2026
ms.subservice: hyperconverged
---
# Connecting an External Storage Array to Azure Local

## Overview
Azure Local supports attaching external Fibre Channel (FC) storage area network (SAN) storage as an alternative to local storage (Storage Spaces Direct). This capability enables customers with existing SAN investments to reuse that infrastructure while running Azure Local workloads.

## Supported SAN Solutions

> [!NOTE]
> - External SAN is supported for block storage over Fibre Channel only.
> - All cluster nodes must have identical HBA configuration and zoning.
> - Logical unit numbers (LUNs) must be presented to all cluster nodes (no partial presentation).
> - Only NT file system (NTFS) formatted volumes are supported for SAN-backed Cluster Shared Volumes (CSVs).
> - ReFS isn't supported for SAN-backed volumes in this preview.
> - Each SAN LUN must be dedicated to a single CSV (no sharing across clusters).
> - Multipath I/O (MPIO) must be configured consistently across all nodes before volume use.

Select one of the partners below to view their support statements:

# [Dell](#tab/Dell-PowerStore-support)
The Dell PowerStore family (T and Q appliances) running OS 3.0 or later is supported as external storage for Azure Local. .

# [EverPure](#tab/EverPure-support)
Supported versions of Purity on FlashArray models (FA//X, FA//XL, FA//C, FA//E). Detailed instructions are available [here](https://support.purestorage.com/auth/login?redirect=%2Fbundle%2Fm_getting_started_with_flasharray%2Fpage%2FSolutions%2FVMware_Platform_Guide%2FTroubleshooting_for_VMware_Solutions%2FVMware-Related_KB_Articles%2Flibrary%2Fcommon_content%2Fc_introduction_46.html)

# [Hitachi](#tab/Hitachi-Vantara-support)
Hitachi VSP One storage family is supported for use with Azure Local.
Reference: https://compatibility.hitachivantara.com/products/interop-matrix
The following Hitachi storage models are qualified to integrate with Azure Local (subject to program scope and the PCG for host/fabric specifics):
- Hitachi VSP One Block High End
- Hitachi VSP One Block 24
- Hitachi VSP One Block 26
- Hitachi VSP One Block 28
- Hitachi VSP 5100, 5200, 5500, 5600
- Hitachi VSP E1090, E590, E790, E990
- Hitachi VSP F350, F370, F700, F900
- Hitachi VSP G130, G350, G370, G700, G900


# [HPE](#tab/HPE-Alletra-support)
The HPE Alletra MP 10000 (Fibre Channel) storage is supported for use with Azure Local.

# [Lenovo](#tab/Lenovo-support)
The following Lenovo Storage systems are supported for use with Azure Local:
- ThinkSystem DS Series
- ThinkSystem DM Series
- ThinkSystem DG Series

# [NetApp](#tab/Netapp-support)
NetApp supports ONTAP-based external SAN arrays, including NetApp AFF, NetApp ASA, and other ONTAP platforms configured for SAN. These arrays are supported for use with Azure Local external storage when the solution is deployed as FC block storage presented to Azure Local nodes and consumed as CSVs.

Supported ONTAP versions are governed by the [NetApp Interoperability Matrix Tool (IMT)](https://www.netapp.com/company/interoperability/), which lists the qualified configurations. Support is provided when the following end-to-end configuration components are validated and listed in the NetApp IMT:

- Azure Local release
- Windows driver stack
- FC HBAs
- ONTAP version
- Multipathing and host utilities
- Switch and fabric components 

## Deployment Sequence
1. Deploy Azure Local cluster without SAN zoning  
2. Configure MPIO on all nodes  
3. Perform FC zoning and SAN configuration  
4. Present LUNs to all cluster nodes  
5. Proceed with disk initialization and clustering  


## Prerequisites
The following prerequisites apply to use this document: 
- Azure Local cluster deployed with 2604 release or later. 
- Fibre Channel HBAs (Windows Server 2025 certified HBA and driver) installed in all cluster nodes and zoned on the FC fabric. 
- The SAN array is accessible on the FC fabric with management access configured. 

> [!IMPORTANT]
> Don't zone in FC HBA World Wide Names (WWNs) until AFTER the Azure Local deployment, to avoid deployment confusion for FC LUNs. 

## Step 1: Enable Multipath IO 

1. Enable MPIO feature on each node:
    ```powershell
    Add-WindowsFeature -Name 'Multipath-IO' -IncludeManagementTools
    ```

## Step 2: Configure MPIO and Set MPIO policy  

> [!NOTE]
> Run configurations on each Azure Local node. MPIO policy changes aren't in effect until after a reboot. 

# [Dell](#tab/Dell-PowerStore)

> [!Note:] Required HBA: Emulex LPe36002-M64  |  Firmware: 03.09.19 (DUP: D815X A00-00)  |  Driver: 14.4.393.20 (DUP: VKNP1 A00-00). Install firmware via DUP through the iDRAC System Update menu; install driver via DUP in Windows OS. 

1. Register Dell PowerStore with MSDSM: 
    ```powershell
    New-MSDSMSupportedHW -VendorId "DellEMC" -ProductId "PowerStore" 
    ```

2. Set round robin load-balancing policy: 
    ```powershell
    Set-MSDSMGlobalDefaultLoadBalancePolicy -Policy RR 
    ```
3. Configure MPIO path recovery settings: 
    ```powershell
    Set-MPIOSetting -NewPathVerificationState Enabled -NewPathVerificationPeriod 30 ` 
    -NewPDORemovePeriod 20 -NewRetryCount 3 -NewRetryInterval 3 ` 
    -CustomPathRecovery Enabled -NewPathRecoveryInterval 10 -NewDiskTimeout 30 
    ```
4. Verify that paths are using correct policy: 
    ```powershell
    mpclaim -s -d 
    ```
5. Restart each node after completing MPIO configuration. Perform reboots in a rolling manner before proceeding with SAN configuration and WWN registration. 

6. Launch the PowerStore WebUI. For example, `https://PowerStoreManagementIPorFQDN`.

7. Compute → Host Information → Hosts & Host Groups → '+Add Host.'

8. Enter host name; select Operating System = Windows; select Next. 

9. Select Fibre Channel as protocol; select Next. 

10. Run Get-InitiatorPort on the node for World Wide Port Names (WWPNs); select the appropriate initiators; select Next. Leave default Local Connectivity; select Next. Verify summary and select Add Host. Repeat for all nodes. 

11. Compute → Host Information → '+Add Host Group'; enter name; select all cluster hosts; select Create. 

12. Storage → Volume → '+CREATE'; enter name, size, and Volume Performance Policy; select Next. 

13. Select SCSI protocol; map to the host group; select 'Generate Automatically' for LUN ID; complete the wizard. 

14. On each cluster node, rescan for the new volume: 
    ```powershell
    Update-HostStorageCache 
    ```
# [EverPure](#tab/EverPure)

1. Register Pure FlashArray with MSDSM: 
    ```powershell
    New-MSDSMSupportedHw -VendorId PURE -ProductId FlashArray 
    ```
2. Remove the generic vendor wildcard entry (if present): 
    ```powershell
    Remove-MSDSMSupportedHw -VendorId 'Vendor*' -ProductId 'Product*' 
    ```
3. Set Round robin load-balancing policy: 
    ```powershell
    Set-MSDSMGlobalDefaultLoadBalancePolicy -Policy RR 
    ```
4. Verify that paths are using correct policy: 
    ```powershell
    mpclaim -s -d
    ``` 

5. Configure MPIO path recovery settings: 
    ```powershell
    Set-MPIOSetting -NewPathRecoveryInterval 20 -CustomPathRecovery Enabled -NewPDORemovePeriod 20 -NewDiskTimeout 60 -NewPathVerificationState Enabled
    ```

6. Restart each node after completing MPIO configuration. Perform reboots in a rolling manner before proceeding with SAN configuration and WWN registration. 

6. Launch the Purity WebUI. For example, `https://FlashArrayManagementIPorFQDN`

7. Navigate to Storage → Hosts → select '+' to create a new host for each cluster node. Don't select a Personality. 

8. Select the host; select the three vertical ellipses under Host Ports → 'Configure WWN.' If nodes are zoned, WWNs appear under 'Existing WWNs.' Select the two WWNs for each host. Repeat for each node. 

9. Navigate to Storage → Host Groups → select '+'; name the host group and add all cluster host objects. 

10. Navigate to Storage → Volumes → select '+'; enter name, size, and assign to the host group. 

12. On each cluster node, rescan for the new volume: 
    ```powershell
    Update-HostStorageCache
    ``` 

# [Hitachi](#tab/Hitachi-Vantara)
**Note:** Default MSDSM settings with RR policy are effective for Hitachi storage 

1. Autoclaim Hitachi Open-V disks with MSDSM: 
    ```powershell
    mpclaim -r -i -d "HITACHI OPEN-V" 
    ```
2. Set Round robin load-balancing policy: 
    ```powershell
    Set-MSDSMGlobalDefaultLoadBalancePolicy -Policy RR 
    ```
3. Verify that paths are using correct policy: 
    ```powershell
    mpclaim -s -d 
    ```
4. Restart each node after completing MPIO configuration. Perform reboots in a rolling manner before proceeding with SAN configuration and WWN registration. 

5. On the FC switch, zone the HBA WWNs for every cluster node to the target ports on the VSP 5600 or VSP One Block 28. 

6. Register each host's WWN in the VSP Storage Navigator. 

7. Create SAN LUNs of the required size on the VSP array. 

8. Unmask the LUNs to all cluster hosts via host group / LUN mapping configuration. 

9. On each cluster node, rescan for the new volume: 
    ```powershell
    Update-HostStorageCache 
    ```
# [HPE](#tab/HPE-Alletra) 

1. Install the HPE PowerShell Toolkit (or use the array GUI) 

2. Register HPE array with MSDSM:  
    ```powershell
    New-MSDSMSupportedHW -VendorId "3PARdata" -ProductId "VV" -Verbose 
    ```
3. Set Round robin load-balancing:  
    ```powershell
    Set-MSDSMGlobalDefaultLoadBalancePolicy -Policy RR 
    ```
4. No other MPIO tuning is required when host persona is set to WINDOWS on the array. 

5. Verify that paths are using correct policy: 
    ```powershell
    mpclaim -s -d
    ```

6. Restart each node after completing MPIO configuration. Perform reboots in a rolling manner before proceeding with SAN configuration and WWN registration. 

7. Connect to array:  
    ```powershell
    Connect-HPESAN -ArrayNameOrIPAddress <IP> -ArrayType AlletraMP-B10000 -Credential (get-credential)
    ```

8. Retrieve WWPNs from each node:  
    ```powershell
    Get-InitiatorPort | Format-Table PortAddress 
    ```
9. Create host entries (per node):  
    ```powershell
    new-a9host -HostName <NodeName> -FCWWN <WWPN> -Persona WINDOWS 
    ```
10. Create host set (cluster grouping):  
    ```powershell
    new-a9hostset -HostSetName <ClusterName> -SetMembers <NodeList> 
    ```
11. Create volume:  
    ```powershell
    new-a9vv -VVName <VolumeName> -CpgName <CPG> -SizeMiB <Size> -TPVV $true 
    ```
12. Map volume to host set:  
    ```powershell
    New-a9vLun -VolumeName <VolumeName> -HostSet <ClusterName> 
    ```
13. Rescan disks on each node:  
    ```powershell
    Update-HostStorageCache 
    ```

# [NetApp and Lenovo](#tab/NetApp-Lenovo) 

1. Set Application Control (WDAC) to Audit mode BEFORE installing Host Utilities; revert to Enforced mode after installation is complete. 

2. Set Application Control to Audit mode (see Microsoft Learn for WDAC management). 

3. Copy the NetApp Windows Host Utilities installer to each Azure Local node. 

4. Install Host Utilities with MPIO enabled (system autoreboots on completion): 
    ```
    msiexec /i installer.msi /quiet MULTIPATHING=1 
    ```
5. After reboot, revert Application Control to Enforced mode. 

6. Set Round robin load-balancing policy: 
    ```powershell
    Set-MSDSMGlobalDefaultLoadBalancePolicy -Policy RR 
    ```
7. Verify that paths are using correct policy: 
    ```
    mpclaim -s -d 
    ```
**Note:** The Windows Host Utilities installer automatically sets the required HBA registry values. See NetApp ONTAP SAN Host documentation for details. 

8. Restart each node after completing MPIO configuration. Perform reboots in a rolling manner before proceeding with SAN configuration and WWN registration. 

9. Zone and register FC WWNs for each host with the SAN array via the FC switch. 

10. Create a new Storage Virtual Machine (SVM) with FC (block protocol) enabled. Use CLI, ONTAP System Manager, or NetApp PowerShell Toolkit. 

11. Configure FC protocol settings for the SVM. 

12. Assign Logical Interfaces (LIFs) to the SVM on each cluster node. 

13. Start the FC service on the SVM. 

14. Create FC port sets using the SVM LIFs. 

15. Create an initiator group (igroup) of type Windows using the port set. 

16. Add each cluster node's WWPN as initiators to the igroup. 

17. Create a LUN using the Create LUN wizard; associate it with the igroup. 

18. On each cluster node, rescan for the new volume: 
    ```powershell
    Update-HostStorageCache 
    ```

---

## Step 3: Verify SAN Disks Before Initialization 
1. On each Azure Local node, run: 
    ```powershell
    Get-Disk  
    ```
2. Verify that new disks are visible on all nodes, disk sizes match expected LUN sizes and the number of disks is consistent across nodes. If disks are missing: 

3. Rerun Update-HostStorageCache 

4. Verify zoning and LUN masking 

## Step 4: Initialize and Format Disks 

**Note:** Run on one cluster node only. 

1. Get the new disk (usually the one with no partition): 
    ```powershell
    $disk = Get-Disk | Where-Object PartitionStyle -Eq 'RAW' 
    ```

2. Initialize as GPT: 
    ```powershell
    Initialize-Disk -Number $disk.Number -PartitionStyle GPT 
    ```
4. Create a partition and format it as NTFS: 
    ```powershell
    New-Partition -DiskNumber $disk.Number -UseMaximumSize -AssignDriveLetter | 
    Format-Volume -FileSystem NTFS -NewFileSystemLabel "ClusterDisk1" -Confirm:$false 
    ```
## Step 5: Validate Cluster Configuration and Add CSV  

1. Validate cluster storage configuration and inspect the report for issues. 
    ```powershell
    Test-Cluster 
    ```
2. Add SAN volumes as Cluster Shared Volumes: 
    ```powershell
    Get-ClusterAvailableDisk | Add-ClusterDisk | Add-ClusterSharedVolume 
    ```

## Step 6: Add Storage Path in Azure portal 
1. In the Azure portal (portal.azure.com), select the Azure Local Cluster. 

2. Under Resources, select Storage Paths, then Create Storage Path. 

3. Enter a friendly Name and the actual File System Path (for example, C:\ClusterStorage\{VolumeName}), then select Create. 

**Note:** Reference: [Create Storage Path on Azure Local](../manage/create-storage-path.md)

## Troubleshooting 

Use the following guidance to identify and resolve common issues when attaching SAN storage to Azure Local. 

### Disks aren't visible on cluster nodes 

If SAN disks don't appear on one or more cluster nodes, first verify that Fibre Channel zoning is configured correctly between the host HBAs and the SAN array target ports. Ensure that all LUNs are masked and presented to every node in the cluster. On each node, run the following command to refresh the storage view: 
```powershell
Update-HostStorageCache 
```

If the disks are still not visible, confirm that the HBA drivers and firmware are correctly installed and that all FC ports are online. 

### MPIO isn't claiming disks correctly 

If disks are visible but MPIO isn't managing them, verify that the correct storage vendor is registered with MSDSM and that the MPIO feature is enabled on all nodes. 

Run the following command to check disk claim status: 
```
mpclaim -s -d 
```
Ensure that disks are listed under MSDSM and that multiple active paths are present. If disks aren't claimed, recheck vendor registration and reboot the node to apply MPIO settings. 

### Cluster validation fails during Test-Cluster 

If the Test-Cluster command reports errors, review the generated validation report carefully and don't proceed with configuration until all critical issues are resolved. Common causes include inconsistent disk visibility across nodes, incorrect zoning, or LUNs that aren't presented uniformly to all cluster members. Ensure that all nodes can see the same set of disks with identical characteristics. 

### Unable to add disks as Cluster Shared Volumes 

If disks can't be added as Cluster Shared Volumes, verify that the disks are visible to all nodes and aren't already in use or reserved. Confirm that the disks are initialized and formatted correctly using NTFS. You can also check disk state using: 
```powershell
Get-ClusterAvailableDisk 
```

Only disks listed as available can be added to the cluster. 

### Cluster Shared Volumes aren't accessible 

If CSV paths aren't accessible or don't appear under C:\ClusterStorage\, verify that the disks were successfully added to the cluster and promoted to CSVs. 

Use the following command to confirm CSV status: 
```powershell
Get-ClusterSharedVolume 
```

If volumes are missing or inaccessible, check Failover Cluster Manager for disk ownership and status, and ensure that there are no underlying storage connectivity issues. 

### Storage Path creation fails in Azure portal 

If creating a Storage Path fails in the Azure portal, verify that the specified file system path exists and is accessible on the cluster. The path must point to a valid CSV location under C:\ClusterStorage\. Also confirm that the Azure Arc connection for the cluster is healthy and that the cluster resource is in a ready state. If the issue persists, retry the operation after confirming that all previous steps completed successfully. 

## Next Articles: 

- [Create a VM on Azure Local](../manage/create-arc-virtual-machines.md)
- [Using External Storage in AKS clusters on Azure Local](../manage/use-external-storage-for-containerized-workloads.md)
- [Deploying AVD on Azure Local](/azure/virtual-desktop/azure-local-overview) 
