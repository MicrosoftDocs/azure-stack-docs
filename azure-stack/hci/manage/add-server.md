---
title: Manage capacity by adding a server on Azure Local, version 23H2.
description: Learn how to manage capacity on your Azure Local, version 23H2 system by adding a server.
ms.topic: article
author: alkohli
ms.author: alkohli
ms.date: 10/30/2024
---

# Add a server on Azure Local, version 23H2

[!INCLUDE [applies-to](../../hci/includes/hci-applies-to-23h2.md)]

This article describes how to manage capacity by adding a server (often called scale-out) to your Azure Local instance.

## About add servers

You can easily scale the compute and storage at the same time on Azure Local by adding machines to an existing cluster. Your Azure Local instance supports a maximum of 16 servers.

Each new physical machine that you add to your system must closely match the rest of the machines in terms of CPU type, memory, number of drives, and the type and size of the drives.

You can dynamically scale your Azure Local instance from 1 to 16 servers. In response to the scaling, the orchestrator (also known as Lifecycle Manager) adjusts the drive resiliency, network configuration including the on-premises agents such as orchestrator agents, and Arc registration. The dynamic scaling may require the network architecture change from connected without a switch to connected via a network switch.

> [!IMPORTANT]
>
> - In this release, you can only add one server at any given time. You can however add multiple servers sequentially so that the storage pool is rebalanced only once.
> - It is not possible to permanently remove a server from a cluster.

## Add server workflow

The following flow diagram shows the overall process to add a server:

:::image type="content" source="./media/add-server/add-server-workflow.png" alt-text="Diagram illustrating process to add a server." lightbox="./media/add-server/add-server-workflow.png":::

To add a server, follow these high-level steps:

1. Install the operating system, drivers, and firmware on the new machine that you plan to add. For more information, see [Install OS](../deploy/deployment-install-os.md).
1. Add the prepared server via the `Add-server` PowerShell cmdlet.
1. When adding a server to the instance, the system validates that the new incoming server meets the CPU, memory, and storage (drives) requirements before it actually adds the server.
1. Once the server is added, the instance is also validated to ensure that it's functioning normally. Next, the storage pool is automatically rebalanced. Storage rebalance is a low priority task that doesn't impact actual workloads. The rebalance can run for multiple days depending on number of the servers and the storage used.

> [!NOTE]
> If you deployed your Azure Local instance using custom storage IPs, you must manually assign IPs to the storage network adapters after the server is added.

## Supported scenarios

For adding a server, the following scale-out scenarios are supported:

| **Start scenario** | **Target scenario** | **Resiliency settings** | **Storage network architecture** | **Witness settings** |
|--|--|--|--|--|
| Single-server | Two-server cluster | Two-way mirror | Configured with and without a switch | Witness required for target scenario. |
| Two-server cluster | Three-server cluster | Three-way mirror | Configured with a switch only | Witness optional for target scenario. |
| Three-server cluster | N-server cluster | Three-way mirror | Switch only | Witness optional for target scenario. |

When upgrading an instance from two to three servers, the storage resiliency level is changed from a two-way mirror to a three-way mirror.

### Resiliency settings

In this release, for add server operation, specific tasks aren't performed on the workload volumes created after the deployment.

For add server operation, the resiliency settings are updated for the required infrastructure volumes and the workload volumes created during the deployment. The settings remain unchanged for other workload volumes that you created after the deployment (since the intentional resiliency settings of these volumes aren't known and you may just want a 2-way mirror volume regardless of the cluster scale).

However, the default resiliency settings are updated at the storage pool level and so any new workload volumes that you created after the deployment will inherit the resiliency settings.

### Hardware requirements

When adding a server, the system validates the hardware of the new, incoming server and ensures that the server meets the hardware requirements before it's added to the instance.

[!INCLUDE [hci-hardware-requirements-add-repair-server](../../hci/includes/hci-hardware-requirements-add-repair-server.md)]

## Prerequisites

Before you add a server, you would need to complete the hardware and software prerequisites.

#### Hardware prerequisites

Make sure to complete the following prerequisites:

1. The first step is to acquire new Azure Local hardware from your original OEM. Always refer to your OEM-provided documentation when adding new server hardware for use in your instance.
1. Place the new physical machine in the predetermined location, for example, a rack and cable it appropriately.
1. Enable and adjust physical switch ports as applicable in your network environment.

#### Software prerequisites

Make sure to complete the following prerequisites:

[!INCLUDE [hci-prerequisites-add-repair-server](../../hci/includes/hci-prerequisites-add-repair-server.md)]

## Add a server

This section describes how to add a machine using PowerShell, monitor the status of the `Add-Server` operation and troubleshoot, if there are any issues.

### Add a server using PowerShell

Make sure that you have reviewed and completed the [prerequisites](#prerequisites).

On the new machine that you plan to add, follow these steps.

1. Install the operating system and required drivers on the new machine that you plan to add. Follow the steps in [Install the Azure Local, version 23H2 Operating System](../deploy/deployment-install-os.md).

2. Register the machine with Arc. Follow the steps in [Register with Arc and set up permissions](../deploy/deployment-arc-register-server-permissions.md).

    > [!NOTE]
    > You must use the same parameters as the existing machines to register with Arc. For example: Resource Group name, Region, Subscription, and Tentant.

3. Assign the following permissions to the newly added machines:

    - Azure Local Device Management Role
    - Key Vault Secrets User
    For more information, see [Assign permissions to the machine](../deploy/deployment-arc-register-server-permissions.md).

On a machine that already exists on your instance, follow these steps:

1. Sign in with the domain user credentials that you provided during the deployment of the instance.

1. (Optional) Before you add the machine, make sure to get an updated authentication token. Run the following command:

    ```powershell
    Update-AuthenticationToken 
    ```

1. If you are running a version prior to 2405.3, you must run the following command to clean up conflicting files:

    ```powershell
    Get-ChildItem -Path "$env:SystemDrive\NugetStore" -Exclude Microsoft.AzureStack.Solution.LCMControllerWinService*,Microsoft.AzureStack.Role.Deployment.Service* | Remove-Item -Recurse -Force
    ```

1. Run the following command to add the new incoming machine:

    ```powershell
    $HostIpv4 = "<IPv 4 for the new machine>"
    $Cred = Get-Credential 
    Add-Server -Name "< Name of the new machine>" -HostIpv4 $HostIpv4 -LocalAdminCredential $Cred 
    ```

1. Make a note of the operation ID as output by the `Add-Server` command. You use this operation ID later to monitor the progress of the `Add-Server` operation.

### Monitor operation progress

To monitor the progress of the add server operation, follow these steps:

[!INCLUDE [hci-monitor-add-repair-server](../../hci/includes/hci-monitor-add-repair-server.md)]

The newly added machine shows in the Azure portal in your Azure Local instance list after several hours. To force the machine to show up in Azure portal, run the following command:

```powershell
Sync-AzureStackHCI
```

### Recovery scenarios

Following recovery scenarios and the recommended mitigation steps are tabulated for adding a machine:

| Scenario description | Mitigation | Supported? |
|--|--|--|
| Added a new machine out of band without using the orchestrator. | Remove the added machine. <br> Use the orchestrator to add the machine. | No |
| Added a new machine with orchestrator and the operation failed. | To complete the operation, investigate the failure. <br>Rerun the failed operation using `Add-Server -Rerun`. | Yes |
| Added a new machine with orchestrator. <br>The operation succeeded partially but had to start with a fresh operating system install. | In this scenario, orchestrator has already updated its knowledge store with the new machine. Use the repair machine scenario. | Yes |

### Troubleshoot issues

If you experience failures or errors while adding a machine, you can capture the output of the failures in a log file. On a machine that already exists on your instance, follow these steps:

- Sign in with the domain user credentials that you provided during the deployment of the instance. Capture the issue in the log files.

    ```powershell
    Get-ActionPlanInstance -ActionPlanInstanceID $ID|out-file log.txt
    ```

- To rerun the failed operation, use the following cmdlet:

    ```powershell
    Add-Server -Rerun
    ```

## Next steps

Learn more about how to [Repair a machine](./repair-server.md).
