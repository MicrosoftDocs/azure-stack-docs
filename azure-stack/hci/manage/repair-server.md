---
title: Repair a server on Azure Local, version 23H2
description: Learn how to repair a server on your Azure Local, version 23H2 system.
ms.topic: article
author: alkohli
ms.author: alkohli
ms.date: 10/16/2024
---

# Repair a server on Azure Local, version 23H2

[!INCLUDE [applies-to](../../hci/includes/hci-applies-to-23h2.md)]

This article describes how to repair a server on your Azure Local instance.

## About repair servers

Azure SLocal is a hyperconverged system that allows you to repair machines from existing instances. You may need to repair a machine in an instance if there's a hardware failure.

Before you repair a machine, make sure to check with your solution provider, which components on the machine are field replacement units (FRUs) that you can replace yourself and which components would require a technician to replace.

Parts that support hot swap typically don't require you to reimage the machine unlike the non hot-swappable components such as motherboard do. Consult your hardware manufacturer to determine which component replacements would require you to reimage the machine. For more information, see [Component replacement](#component-replacement).

## Repair machine workflow

The following flow diagram shows the overall process to repair a machine.

:::image type="content" source="./media/repair-server/repair-server-workflow-2.png" alt-text="Diagram illustrating the repair machine process." lightbox="./media/repair-server/repair-server-workflow-2.png":::

\**Machine may not be in a state where shutdown is possible or necessary*

To repair an existing machine, follow these high-level steps:

1. If possible, shut down the machine that you want to repair. Depending on the state of the machine, a shutdown may not be possible or necessary.
1. Reimage the machine that needs to be repaired.
1. Run the repair machine operation. The Azure Stack HCI Operating System, drivers, and firmware are updated as part of the repair operation.

    The storage is automatically rebalanced on the reimaged machine. Storage rebalance is a low priority task that can run for multiple days depending on the number of machines and the storage used.

## Supported scenarios

Repairing a machine reimages a machine and brings it back to the instance with the previous name and configuration.

Repairing a single machine results in a redeployment with the option to persist the data volumes. Only the system volume is deleted and newly provisioned during deployment.

> [!IMPORTANT]
> Make sure that you always have backups for your workloads and do not rely on the system resiliency only. This is especially critical in single-machine scenarios.

### Resiliency settings

In this release, for a repair machine operation, specific tasks aren't performed on the workload volumes that you created after the deployment. For a repair machine operation, only the required infrastructure volumes and the workload volumes are restored and surfaced as cluster shared volumes (CSVs).

The other workload volumes that you created after the deployment are still retained and you can discover these volumes by running the `Get-VirtuaDisk` cmdlet. You'll need to manually unlock the volume (if the volume has BitLocker enabled), and create a CSV (if needed).

### Hardware requirements

When repairing a machine, the system validates the hardware of the new, incoming machine and ensures that the machine meets the hardware requirements before it's added to the instance.

[!INCLUDE [hci-hardware-requirements-add-repair-server](../../hci/includes/hci-hardware-requirements-add-repair-server.md)]

### Machine replacement

You may replace the entire machine:

- With a new machine that has a different serial number compared to the old machine.
- With the current machine after you reimage it.

The following scenarios are supported during machine replacement:

| **Machine** | **Disk** | **Supported** |
|--|--|--|
| New machine | New disks | Yes |
| New machine | Current disks | Yes |
| Current machine (reimaged) | Current disks reformatted * | No |
| Current machine (reimaged) | New disks | Yes |
| Current machine (reimaged) | Current disks | Yes |

**Disks that have been used by Storage Spaces Direct, require proper cleaning. Reformatting isn't sufficient. See how to [Clean drives](/windows-server/storage/storage-spaces/deploy-storage-spaces-direct#step-31-clean-drives).

> [!IMPORTANT]
> If you replace a component during machine repair, you don't need to replace or reset data drives. If you replace a drive or reset it, then the drive won't be recognized once the machine joins the instance.

### Component replacement

On your Azure Local instance, non hot-swappable components include the following items:

- Motherboard/baseboard management controller (BMC)/video card
- Disk controller/host bus adapter (HBA)/backplace
- Network adapter
- Graphics processing unit
- Data drives (drives that don't support hot swap, for example PCI-e add-in cards)

The actual replacement steps for non hot-swappable components vary based on your original equipment manufacturer (OEM) hardware vendor. See your OEM vendor's documentation if a machine repair is required for non hot-swappable components.

## Prerequisites

Before you repair a machine, you must ensure that:

[!INCLUDE [hci-prerequisites-add-repair-server](../../hci/includes/hci-prerequisites-add-repair-server.md)]

- If needed, take the machine that you have identified for repair offline. Follow the steps here:

    - [Verify the machine is healthy prior to taking it offline](maintain-servers.md#verify-its-safe-to-take-the-server-offline-1).
    - [Pause and drain the machine](maintain-servers.md#pause-and-drain-the-server-1).
    - [Shut down the machine](maintain-servers.md#shut-down-the-server-1).

## Repair a machine

This section describes how to repair a machine using PowerShell, monitor the status of the `Repair-Server` operation and troubleshoot, if there are any issues.

Make sure that you have reviewed the [prerequisites](#prerequisites). 

Follow these steps on the machine you're trying to repair.

1. Install the operating system and required drivers. Follow the steps in [Install the Azure Stack HCI, version 23H2 Operating System](../deploy/deployment-install-os.md).

    > [!NOTE]
    > If you deployed your Azure Local instance using custom storage IPs, you must manually assign IPs to the storage network adapters after the machine is repaired.

2. Register the machine with Arc. Follow the steps in [Register with Arc and set up permissions](../deploy/deployment-arc-register-server-permissions.md).

    > [!NOTE]
    > You must use the same parameters as the existing machines to register with Arc. For example: Resource Group name, Region, Subscription, and Tentant.

3. Assign the following permissions to the repaired machine:

    - Azure Local Device Management Role
    - Key Vault Secrets User
    For more information, see [Assign permissions to the machine](../deploy/deployment-arc-register-server-permissions.md).

Follow these steps on another machine that is a member of the same Azure Local instance.

1. Before you add the machine, make sure to get an updated authentication token. Run the following command:

   ```powershell
    Update-AuthenticationToken
   ```

1. If you are running a version prior to 2405.3, you must run the following command to clean up conflicting files:

    ```powershell
    Get-ChildItem -Path "$env:SystemDrive\NugetStore" -Exclude Microsoft.AzureStack.Solution.LCMControllerWinService*,Microsoft.AzureStack.Role.Deployment.Service* | Remove-Item -Recurse -Force
    ```

1. Sign into the machine that is already a member of the instance, with the domain user credentials that you provided during the deployment of the instance. Run the following command to repair the incoming machine:

    ```powershell
    $Cred = Get-Credential 
    Repair-Server -Name "< Name of the new server>" -LocalAdminCredential $Cred
    ```

    > [!NOTE]
    > The machine name must be the [NetBIOS name](/windows/win32/sysinfo/computer-names).

1. Make a note of the operation ID as output by the `Repair-Server` command. You use this later to monitor the progress of the `Repair-Server` operation.



### Monitor operation progress

To monitor the progress of the add machine operation, follow these steps:

[!INCLUDE [hci-monitor-add-repair-server](../../hci/includes/hci-monitor-add-repair-server.md)]

### Recovery scenarios

Following recovery scenarios and the recommended mitigation steps are tabulated for repairing a machine:

| Scenario description | Mitigation | Supported? |
|--|--|--|
| Repair machine operation failed. | To complete the operation, investigate the failure. <br>Rerun the failed operation using `Add-Server -Rerun`. | Yes |
| Repair machine operation succeeded partially but had to start with a fresh operation system install. | In this scenario, the orchestrator (also known as Lifecycle Manager) has already updated its knowledge store with the new machine. Use the repair machine scenario. | Yes |

### Troubleshooting

If you experience failures or errors while repairing a machine, you can capture the output of the failures in a log file.

- Sign in with the domain user credentials that you provided during the deployment of the instance. Capture the issue in the log files.

    ```powershell
    Get-ActionPlanInstance -ActionPlanInstanceID $ID |out-file log.txt
    ```

- To rerun the failed operation, use the following cmdlet:

    ```powershell
    Repair-Server -Rerun
    ```

## Next steps

Learn more about how to [Add a machine](./add-server.md).
