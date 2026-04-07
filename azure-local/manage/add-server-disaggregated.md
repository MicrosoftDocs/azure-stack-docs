---
title: Add a Node on Azure Local for Disaggregated Deployments
description: Learn how to manage capacity on your Azure Local disaggregated deployment by adding a node.
ms.topic: how-to
author: alkohli
ms.author: alkohli
ms.date: 03/31/2026
ms.subservice: hyperconverged
---

# Add a node on Azure Local for disaggregated deployments

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes how to manage capacity by adding a node (often called scale-out) to your Azure Local instance. In this article, each server is referred to as a node.

## About add nodes

You can easily scale the compute and storage at the same time on Azure Local by adding nodes to an existing system. Your Azure Local instance supports a maximum of 16 nodes.

Each new physical node that you add to your system must closely match the rest of the nodes in terms of CPU type, memory, number of drives, and the type and size of the drives.

You can dynamically scale your Azure Local instance from 1 to 16 nodes. In response to the scaling, the orchestrator (also known as Lifecycle Manager) adjusts the drive resiliency, network configuration including the on-premises agents such as orchestrator agents, and Arc registration. The dynamic scaling may require the network architecture change from connected without a switch to connected via a network switch.

> [!IMPORTANT]
>
> - In this release, you can only add one node at any given time. You can however add multiple nodes sequentially.
> - It is not possible to permanently remove a node from a system.

## Add node workflow

The following flow diagram shows the overall process to add a node:

:::image type="content" source="./media/add-server/add-server-workflow-disaggregated.png" alt-text="Diagram illustrating process to add a node." lightbox="./media/add-server/add-server-workflow.png":::

To add a node, follow these high-level steps:

1. Install the operating system, drivers, firmware and connect your SAN on the new node that you plan to add. For more information, see [Install OS](../deploy/deployment-install-os-disaggregated.md).
1. Add the prepared node via the `Add-server` PowerShell cmdlet.
1. When adding a node to the system, the system validates that the new incoming node meets the CPU and memory requirements before it actually adds the node.
1. Once the node is added, the system is also validated to ensure that it's functioning normally.


## Supported scenarios

For adding a node, the following scale-out scenarios are supported:

| **Start scenario** | **Target scenario** | **Witness settings** |
|--|--|--|
| Single-node | Two-node system | Witness required for target scenario. |
| Two-node system | Three-node system | Witness optional for target scenario. |
| Three-node system | N-node system | Witness optional for target scenario. |


### Hardware requirements

When adding a node, the system validates the hardware of the new, incoming node and ensures that the node meets the hardware requirements before it's added to the system.

[!INCLUDE [hci-hardware-requirements-add-repair-server](../includes/hci-hardware-requirements-add-repair-server -disaggregated.md)]

## Prerequisites

Before you add a node, you would need to complete the hardware and software prerequisites.

#### Hardware prerequisites

Make sure to complete the following prerequisites:

1. The first step is to acquire new Azure Local hardware from your original OEM. Always refer to your OEM-provided documentation when adding new node hardware for use in your system.
1. Place the new physical node in the predetermined location, for example, a rack, and cable it appropriately.
1. Enable and adjust physical switch ports as applicable in your network environment.

#### Software prerequisites

Make sure to complete the following prerequisites:

[!INCLUDE [hci-prerequisites-add-repair-server](../includes/hci-prerequisites-add-repair-server.md)]

## Add a node

This section describes how to add a node using PowerShell, monitor the status of the `Add-Server` operation and troubleshoot, if there are any issues.

### Add a node using PowerShell

Make sure that you have reviewed and completed the [prerequisites](#prerequisites).

On the new node that you plan to add, follow these steps.

1. Install the operating system and required drivers on the new node that you plan to add. Follow the steps in [Install the Azure Stack HCI Operating System, version 23H2](../deploy/deployment-install-os.md).

    >[!NOTE]
    > - For versions 2503 and later, you'll need to use the OS image of the same solution as that running on the existing cluster.
    > - Use the [Get solution version](../update/azure-update-manager-23h2.md#get-solution-version) to identify the solution version that you are running on the cluster.
    > - Use the [OS image](https://github.com/Azure-Samples/AzureLocal/blob/main/os-image/os-image-tracking-table.md) table to identify and download the appropriate OS image version.

1. Register the node with Arc. Follow the steps in [Register with Arc and set up permissions](../deploy/deployment-arc-register-server-permissions.md).

    > [!NOTE]
    > You must use the same parameters as the existing node to register with Arc. For example: Resource Group name, Region, Subscription, and Tenant.

1. Assign the following permissions to the newly added nodes:

    - Azure Stack HCI Device Management Role
    - Key Vault Secrets User
    For more information, see [Assign permissions to the node](../deploy/deployment-arc-register-server-permissions.md).

If you're scaling out from a single-node, follow these steps first:

1. [Configure a quorum witness](/windows-server/failover-clustering/deploy-quorum-witness?tabs=domain-joined-witness%2Cpowershell%2Cfailovercluster1&pivots=cloud-witness) for the Azure Local instance.


On a node that already exists on your system, follow these steps:

1. Sign in with the domain user credentials (AzureStackLCMUser or another user with equivalent permissions) that you provided during the deployment of the system.

1. Run the following command to add the new incoming node using a local administrator credential for the new node:

    ```powershell
    $HostIpv4 = "<IPv 4 for the new node>"
    $Cred = Get-Credential 
    Add-Server -Name "<Name of the new node>" -HostIpv4 $HostIpv4 -LocalAdminCredential $Cred 
    ```

1. Make a note of the operation ID as output by the `Add-Server` command. You use this operation ID later to monitor the progress of the `Add-Server` operation.

### Monitor operation progress

To monitor the progress of the add node operation, follow these steps:

[!INCLUDE [hci-monitor-add-repair-server](../includes/hci-monitor-add-repair-server.md)]

The newly added node shows in the Azure portal in your Azure Local instance list after several hours. To force the node to show up in Azure portal, run the following command:

```powershell
Sync-AzureStackHCI
```

### Recovery scenarios

Following recovery scenarios and the recommended mitigation steps are tabulated for adding a node:

| Scenario description | Mitigation | Supported? |
|--|--|--|
| Added a new node out of band without using the orchestrator. | Remove the added node. <br> Use the orchestrator to add the node. | No |
| Added a new node with orchestrator and the operation failed. | To complete the operation, investigate the failure. <br>Rerun the failed operation using `Add-Server -Rerun`. | Yes |
| Added a new node with orchestrator. <br>The operation succeeded partially but had to start with a fresh operating system install. | In this scenario, orchestrator has already updated its knowledge store with the new node. Use the repair node scenario. | Yes |

### Troubleshoot issues

Starting with the 2508 release, validation runs after you execute the `Add-Server` command. If a test fails, the validator returns information to help you resolve the failure.

Here's an example of a validation failure message:

:::image type="content" source="./media/add-server/validation-error.png" alt-text="Screenshot of validation error message." lightbox="./media/add-server/validation-error.png":::

If you experience failures or errors while adding a node, you can capture the output of the failures in a log file. On a node that already exists on your system, follow these steps:

- Sign in with the domain user credentials that you provided during the deployment of the system. Capture the issue in the log files.

    ```powershell
    Get-ActionPlanInstance -ActionPlanInstanceID $ID|out-file log.txt
    ```

- To rerun the failed operation, use the following cmdlet:

    ```powershell
    Add-Server -Rerun
    ```

If you encounter an issue during the add node operation and need help from Microsoft Support, you can follow the steps in [Collect diagnostic logs for Azure Local (preview)](collect-logs.md) to collect and send the diagnostic logs to Microsoft. 

You might need to provide diagnostic logs from the new node that's to be added to the cluster. Make sure you run the `Send-DiagnosticData` cmdlet from the new node.

## Next steps

- Learn more about how to [Repair a node](./repair-server.md).
