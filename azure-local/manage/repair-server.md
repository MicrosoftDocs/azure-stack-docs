---
title: Repair a node on Azure Local, version 23H2
description: Learn how to repair a node on your Azure Local, version 23H2 system.
ms.topic: how-to
author: alkohli
ms.author: alkohli
ms.date: 08/26/2025
---

# Repair a node on Azure Local

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes how to repair a node on your Azure Local instance. In this article, each server is referred to as a node.

## About repair nodes

Azure Local is a hyperconverged system that allows you to repair nodes from existing systems. You may need to repair a node in a system if there's a hardware failure.

Before you repair a node, make sure to check with your solution provider, which components on the node are field replacement units (FRUs) that you can replace yourself and which components would require a technician to replace.

Parts that support hot swap typically don't require you to reimage the node unlike the non hot-swappable components such as motherboard do. Consult your hardware manufacturer to determine which component replacements would require you to reimage the node. For more information, see [Component replacement](#component-replacement).

## Repair node workflow

The following flow diagram shows the overall process to repair a node.

:::image type="content" source="./media/repair-server/repair-server-workflow-2.png" alt-text="Diagram illustrating the repair node process." lightbox="./media/repair-server/repair-server-workflow-2.png":::

\*Node may not be in a state where shutdown is possible or necessary*

To repair an existing node, follow these high-level steps:

1. If possible, shut down the node that you want to repair. Depending on the state of the node, a shutdown may not be possible or necessary.
1. Reimage the node that needs to be repaired.
1. Run the repair node operation. The Azure Stack HCI Operating System, drivers, and firmware are updated as part of the repair operation.

    The storage is automatically rebalanced on the reimaged node. Storage rebalance is a low priority task that can run for multiple days depending on the number of nodes and the storage used.

## Supported scenarios

Repairing a node reimages a node and brings it back to the system with the previous name and configuration.

Repairing a single node results in a redeployment with the option to persist the data volumes. Only the system volume is deleted and newly provisioned during deployment.

> [!IMPORTANT]
> Make sure that you always have backups for your workloads and do not rely on the system resiliency only. This is especially critical in single-node scenarios.

### Resiliency settings

In this release, for a repair node operation, specific tasks aren't performed on the workload volumes that you created after the deployment. For a repair node operation, only the required infrastructure volumes and the workload volumes are restored and surfaced as cluster shared volumes (CSVs).

The other workload volumes that you created after the deployment are still retained and you can discover these volumes by running the `Get-VirtualDisk` cmdlet. You'll need to manually unlock the volume (if the volume has BitLocker enabled), and create a CSV (if needed).

### Hardware requirements

When repairing a node, the system validates the hardware of the new, incoming node and ensures that the node meets the hardware requirements before it's added to the system.

[!INCLUDE [hci-hardware-requirements-add-repair-server](../includes/hci-hardware-requirements-add-repair-server.md)]

### Node replacement

You may replace the entire node:

- With a new node that has a different serial number compared to the old node.
- With the current node after you reimage it.

The following scenarios are supported during node replacement:

| **Node** | **Disk** | **Supported** |
|--|--|--|
| New node | New disks | Yes |
| New node | Current disks | Yes |
| Current node (reimaged) | New disks | Yes |
| Current node (reimaged) | Current disks | Yes |
| Current node (reimaged) | Current data disks reformatted | No |

> [!IMPORTANT]
> If you replace a component during node repair, you don't need to replace or reset data drives. If you replace a drive or reset it, then the drive won't be recognized once the node joins the system.

### Component replacement

On your Azure Local instance, non hot-swappable components include the following items:

- Motherboard/baseboard management controller (BMC)/video card
- Disk controller/host bus adapter (HBA)/backplace
- Network adapter
- Graphics processing unit
- Data drives (drives that don't support hot swap, for example PCI-e add-in cards)

The actual replacement steps for non hot-swappable components vary based on your original equipment manufacturer (OEM) hardware vendor. See your OEM vendor's documentation if a node repair is required for non hot-swappable components.

## Prerequisites

Before you repair a node, you must ensure that:

[!INCLUDE [hci-prerequisites-add-repair-server](../includes/hci-prerequisites-add-repair-server.md)]
- If needed, take the node that you have identified for repair offline. Follow the steps here:

  1. [Verify the node is healthy prior to taking it offline](maintain-servers.md#verify-its-safe-to-take-the-server-offline-1).
  1. [Pause and drain the node](maintain-servers.md#pause-and-drain-the-server-1).
  1. [Shut down the node](maintain-servers.md#shut-down-the-server-1).

## Repair a node

This section describes how to repair a node using PowerShell, monitor the status of the `Repair-Server` operation and troubleshoot, if there are any issues.

Make sure that you have reviewed the [prerequisites](#prerequisites).

Follow these steps on the node you're trying to repair.

1. Sign into the Azure portal with [Azure Stack HCI Administrator role permissions](./assign-vm-rbac-roles.md#about-built-in-rbac-roles).
    1. Go to the resource group used to deploy your Azure Local instance. In the resource group, identify the Azure Arc machine resource for the faulty node that you wish to repair.
    1. In the Azure Arc machine resource, go to **Settings > Locks**. In the right-pane, you see a resource lock.
    1. Select the lock and then select the trash can icon to delete the lock.

        :::image type="content" source="./media/repair-server/delete-resource-lock-1.png" alt-text="Screenshot of deletion of resource lock on the faulty Azure Arc machine node." lightbox="./media/repair-server/delete-resource-lock-1.png":::

    1. On the **Overview** page of the Azure Arc machine resource, in the right-pane, select **Delete**. This action should delete the faulty machine node.  

        :::image type="content" source="./media/repair-server/delete-machine-node-resource-1.png" alt-text="Screenshot of deletion of faulty Azure Arc machine node." lightbox="./media/repair-server/delete-machine-node-resource-1.png":::

1. Install the operating system and required drivers on the node you wish to repair. Follow the steps in [Install the Azure Stack HCI Operating System, version 23H2](../deploy/deployment-install-os.md).

    >[!NOTE]
    > - For versions 2503 and later, you'll need to use the OS image of the same solution as that running on the existing cluster. 
    > - Use the [Get solution version](../update/azure-update-manager-23h2.md#get-solution-version) to identify the solution version that you are running on the cluster.
    > - Use the [OS image](https://github.com/Azure-Samples/AzureLocal/blob/main/os-image/os-image-tracking-table.md) table to identify and download the appropriate OS image version.

1. Register the node with Arc. Follow the steps in [Register with Arc and set up permissions](../deploy/deployment-arc-register-server-permissions.md).

    > [!NOTE]
    > You must use the same parameters as the existing nodes to register with Arc. For example: Resource Group name, Region, Subscription, and Tenant.

1. Assign the following permissions to the repaired node:

    - Azure Stack HCI Device Management Role
    - Key Vault Secrets User
    For more information, see [Assign permissions to the node](../deploy/deployment-arc-register-server-permissions.md).

Follow these steps on another node that is a member of the same Azure Local instance.

1. Sign into the node that is already a member of the system, with the domain user credentials that you provided during the deployment of the system. Run the following command to repair the incoming node:

    ```powershell
    $Cred = Get-Credential 
    Repair-Server -Name "<Name of the new node>" -LocalAdminCredential $Cred
    ```

    > [!NOTE]
    > The node name must be the [NetBIOS name](/windows/win32/sysinfo/computer-names). The parameter `LocalAdminCredential` by default, is the builtin Administrator account created by the Windows OS installation.

1. Make a note of the operation ID as output by the `Repair-Server` command. You use this later to monitor the progress of the `Repair-Server` operation.

### Monitor operation progress

To monitor the progress of the add node operation, follow these steps:

[!INCLUDE [hci-monitor-add-repair-server](../includes/hci-monitor-add-repair-server.md)]

### Recovery scenarios

Following recovery scenarios and the recommended mitigation steps are tabulated for repairing a node:

| Scenario description | Mitigation | Supported? |
|--|--|--|
| Repair node operation failed. | To complete the operation, investigate the failure. <br>Rerun the failed operation using `Repair-Server -Rerun`. | Yes |
| Repair node operation succeeded partially but had to start with a fresh operation system install. | In this scenario, the orchestrator (also known as Lifecycle Manager) has already updated its knowledge store with the new node. Use the repair node scenario. | Yes |

### Troubleshoot issues

Starting with the 2508 release, validation runs after you execute the `Repair-Server` command. If a test fails, the validator returns information to help you resolve the failure.

Here's an example of a validation failure message:

:::image type="content" source="./media/repair-server/validation-error.png" alt-text="Screenshot of validation error message." lightbox="./media/repair-server/validation-error.png":::

If you experience failures or errors while repairing a node, you can capture the output of the failures in a log file.

- Sign in with the domain user credentials that you provided during the deployment of the system. Capture the issue in the log files.

    ```powershell
    Get-ActionPlanInstance -ActionPlanInstanceID $ID |out-file log.txt
    ```

- To rerun the failed operation, use the following cmdlet:

    ```powershell
    Repair-Server -Rerun
    ```

If you encounter an issue during the repair node operation and need help from Microsoft Support, you can follow the steps in [Collect diagnostic logs for Azure Local (preview)](collect-logs.md) to collect and send diagnostic logs to Microsoft.

You might need to provide diagnostic logs from the node under repair. Make sure you run the `Send-DiagnosticData` cmdlet from this node.

## Next steps

Learn more about how to [Add a node](./add-server.md).
