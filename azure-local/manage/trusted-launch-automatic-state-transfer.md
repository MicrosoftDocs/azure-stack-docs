---
title: Automatic virtual TPM state transfer for Azure Local
description: Learn how automatic virtual TPM state transfer works for Azure Local.
ms.topic: how-to
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.date: 04/04/2025
---

# Automatic transfer of virtual TPM state for Trusted launch for Azure Local VMs

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article uses an example to illustrate the automatic transfer of virtual TPM (vTPM) state for Trusted launch for Azure Local VM, even as the VM migrates or fails over to another machine in the system. This operation allows the applications that use the vTPM to function normally during VM migration or failover.

## Example

This example shows a Trusted launch for Azure Local VM running Windows 11 guest with BitLocker encryption enabled. Here are the steps to run this example:

1. Create an Azure Local Trusted launch VM running a supported Windows 11 guest operating system (OS).

1. Enable BitLocker encryption for the OS volume on the Win 11 guest. Sign on to the Windows 11 guest and enable BitLocker encryption for the OS volume:

    1. In the search box on the task bar, type "Manage BitLocker," and then select it from the list of results.

    1. Select **Turn on BitLocker** and then follow the instructions to encrypt the OS volume (C:). BitLocker uses vTPM as a key protector for the OS volume.

1. Confirm the owner node of the VM.

    ```powershell
    Get-ClusterGroup <VM name>
    ```

1. Migrate the VM to another machine in the system. Run the following PowerShell command from the machine that the VM is on.

    ```powershell
    Move-ClusterVirtualMachineRole -Name <VM name> -Node <destination node> -MigrationType Shutdown
    ```

1. Confirm that the owner node of the VM is the specified destination node.

    ```powershell
    Get-ClusterGroup <VM name>
    ```

1. After VM migration completes, verify if the VM is available and BitLocker is enabled.

1. Verify that you can sign on to the Windows 11 guest in the VM, and if BitLocker encryption for the OS volume remains enabled. If true, this confirms that the vTPM state was preserved during VM migration.

    > [!NOTE]
    > If vTPM state wasn't preserved during VM migration, VM startup would result in BitLocker recovery during guest boot up. You would be prompted for the BitLocker recovery password when you attempted to sign on to the Windows 11 guest. This situation occurs because the boot measurement (stored in the vTPM) of the migrated VM on the destination node is different from that of the original VM.

1. Force the VM to fail over to another machine in the system.

    1. Confirm the owner node of the VM using the following command.

        ```powershell
        Get-ClusterGroup <VM name>
        ```

    1. Use Failover Cluster Manager to stop the cluster service on the owner node as follows: Select the owner node as displayed in Failover Cluster Manager.  On the **Actions** right pane, select **More Actions** and then select **Stop Cluster Service**.

    1. Stopping the cluster service on the owner node causes the VM to be automatically migrated to another available machine in the system. Restart the cluster service afterwards.

1. After failover completes, verify if the VM is available and BitLocker is enabled after failover.

1. Confirm that the owner node of the VM is the specified destination node.

    ```powershell
    Get-ClusterGroup <VM name>
    ```

1. After VM failover completes, verify if the VM is available and BitLocker is enabled.

1. Verify that you can sign on to the Windows 11 guest in the VM, and if BitLocker encryption for the OS volume remains enabled. If true, the vTPM state was preserved during VM failover.

    > [!NOTE]
    > If vTPM state wasn't preserved during VM migration, VM startup would result in BitLocker recovery during guest boot up. You would be prompted for the BitLocker recovery password when you attempted to sign on to the Windows 11 guest. This situation occurs because the boot measurement (stored in the vTPM) of the migrated VM on the destination node is different from that of the original VM.

## Next steps

- [Manage Trusted launch for Azure Local VM guest state protection key](trusted-launch-vm-import-key.md).
