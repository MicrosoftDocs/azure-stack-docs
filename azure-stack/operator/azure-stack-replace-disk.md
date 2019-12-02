---
title: Replace a physical disk
titleSuffix: Azure Stack
description: Learn how to replace a physical disk in Azure Stack.
services: azure-stack
documentationcenter: ''
author: mattbriggs
manager: femila
editor: ''

ms.assetid: 449ae53e-b951-401a-b2c9-17fee2f491f1
ms.service: azure-stack
ms.workload: na
pms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 10/10/2019
ms.author: mabrigg
ms.reviewer: thoroet
ms.lastreviewed: 06/04/2019

---

# Replace a physical disk in Azure Stack

*Applies to: Azure Stack integrated systems and Azure Stack Development Kit*

This article describes the general process to replace a physical disk in Azure Stack. If a physical disk fails, you should replace it as soon as possible.

You can use this procedure for integrated systems, and for Azure Stack Development Kit (ASDK) deployments that have hot-swappable disks.

Actual disk replacement steps will vary based on your original equipment manufacturer (OEM) hardware vendor. See your vendor's field replaceable unit (FRU) documentation for detailed steps that are specific to your system.

## Review disk alert information
When a disk fails, you receive an alert that tells you that connectivity has been lost to a physical disk.

![Alert showing connectivity lost to physical disk in Azure Stack administration](media/azure-stack-replace-disk/DiskAlert.png)

If you open the alert, the alert description contains the scale unit node and the exact physical slot location for the disk that you must replace. Azure Stack further helps you to identify the failed disk by using LED indicator capabilities.

## Replace the physical disk

Follow your OEM hardware vendor's FRU instructions for actual disk replacement.

> [!note]
> Replace disks for one scale unit node at a time. Wait for the virtual disk repair jobs to complete before moving on to the next scale unit node.

To prevent the use of an unsupported disk in an integrated system, the system blocks disks that aren't supported by your vendor. If you try to use an unsupported disk, a new alert tells you a disk has been quarantined because of an unsupported model or firmware.

After you replace the disk, Azure Stack automatically discovers the new disk and starts the virtual disk repair process.

## Check the status of virtual disk repair using Azure Stack PowerShell

After you replace the disk, you can monitor the virtual disk health status and repair job progress by using Azure Stack PowerShell.

1. Check that you have Azure Stack PowerShell installed. For more information, see [Install PowerShell for Azure Stack](azure-stack-powershell-install.md).
2. Connect to Azure Stack with PowerShell as an operator. For more information, see [Connect to Azure Stack with PowerShell as an operator](azure-stack-powershell-configure-admin.md).
3. Run the following cmdlets to verify the virtual disk health and repair status:

    ```powershell  
    $scaleunit=Get-AzsScaleUnit
    $StorageSubSystem=Get-AzsStorageSubSystem -ScaleUnit $scaleunit.Name
    Get-AzsVolume -StorageSubSystem $StorageSubSystem.Name -ScaleUnit $scaleunit.name | Select-Object VolumeLabel, OperationalStatus, RepairStatus
    ```

    ![Azure Stack volumes health in Powershell](media/azure-stack-replace-disk/get-azure-stack-volumes-health.png)

4. Validate Azure Stack system state. For instructions, see [Validate Azure Stack system state](azure-stack-diagnostic-test.md).
5. Optionally, you can run the following command to verify the status of the replaced physical disk.

    ```powershell  
    $scaleunit=Get-AzsScaleUnit
    $StorageSubSystem=Get-AzsStorageSubSystem -ScaleUnit $scaleunit.Name

    Get-AzsDrive -StorageSubSystem $StorageSubSystem.Name -ScaleUnit $scaleunit.name | Sort-Object StorageNode,MediaType,PhysicalLocation | Format-Table Storagenode, Healthstatus, PhysicalLocation, Model, MediaType,  CapacityGB, CanPool, CannotPoolReason
    ```

    ![Replaced physical disks in Azure Stack with Powershell](media/azure-stack-replace-disk/check-replaced-physical-disks-azure-stack.png)

## Check the status of virtual disk repair using the privileged endpoint

After you replace the disk, you can monitor the virtual disk health status and repair job progress by using the privileged endpoint. Follow these steps from any computer that has network connectivity to the privileged endpoint.

1. Open a Windows PowerShell session and connect to the privileged endpoint.

    ```powershell
        $cred = Get-Credential
        Enter-PSSession -ComputerName <IP_address_of_ERCS>`
          -ConfigurationName PrivilegedEndpoint -Credential $cred
    ```
  
2. Run the following command to view virtual disk health:

    ```powershell
        Get-VirtualDisk -CimSession s-cluster
    ```

   ![Powershell output of Get-VirtualDisk command](media/azure-stack-replace-disk/GetVirtualDiskOutput.png)

3. Run the following command to view current storage job status:

    ```powershell
        Get-VirtualDisk -CimSession s-cluster | Get-StorageJob
    ```

    ![Powershell output of Get-StorageJob command](media/azure-stack-replace-disk/GetStorageJobOutput.png)

4. Validate the Azure Stack system state. For instructions, see [Validate Azure Stack system state](azure-stack-diagnostic-test.md).

## Troubleshoot virtual disk repair using the privileged endpoint

If the virtual disk repair job appears stuck, run the following command to restart the job:

```powershell
Get-VirtualDisk -CimSession s-cluster | Repair-VirtualDisk
```
