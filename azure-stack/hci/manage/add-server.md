---
title: Manage capacity by adding a server of Azure Stack HCI. (preview)
description: Learn how to manage capacity on your Azure Stack HCI by adding a server. (preview)
ms.topic: article
author: alkohli
ms.author: alkohli
ms.date: 05/16/2023
---

## Add a server on your Azure Stack HCI (preview)

[!INCLUDE [hci-applies-to-22h2-later](../../includes/hci-applies-to-22h2-later.md)]

This article describes how to manage capacity by adding a server (often called scale out) to your Azure Stack HCI cluster.

[!INCLUDE [hci-preview](../../includes/hci-preview.md)]

## About add servers

Azure Stack HCI is a hyperconverged system that allows you to scale compute and storage at the same time by adding servers to an existing cluster. Azure Stack HCI cluster can have a maximum of up to 16 nodes. 

You can dynamically scale all the way from 1 to 16 nodes. In response to the scaling, Azure Stack HCI Orchestrator adjusts the drive resiliency, network configuration including the on-premises agents such as Lifecycle Manager agents, and Arc registration.

The dynamic scaling may require the network architecture change from connected without a switch to connected via a network switch.

> [!IMPORTANT]
> - In this preview release, only one server can be added at a given time. You can however add multiple servers sequentially so that the storage pool is rebalanced only once. 
> - It is not possible to permanently remove a server from a cluster.

Before you add a server, make sure to check with your solution provider, which components on the server are field replacement units (FRUs) that you can replace yourself and which components would require a technician to replace. Any component replacement will require a reimaging of the server.

## Add server workflow

The following flow diagram shows the overall process to add a server:

![Diagram illustrating process to add a server](media/79918550304be2cda5c8a7482b92b16b.png)

To add a server, follow these high-level steps:

1. Install OS, drivers, and firmware on the new cluster node that you plan to add.
1. Add the prepared node via the Add-server PowerShell cmdlet.
1. When adding a server to the cluster, the system validates the new server meets the CPU, memory, and storage (drives) requirements before it actually adds the server.
1. Once the server is added, the storage pool is automatically rebalanced.

## Supported scenarios

For adding a server, the following scale out scenarios are supported:

| **Start scenario**  | **Target scenario** | **Storage network architecture**     |
|---------------------|---------------------|--------------------------------------|
| Single server       | Two cluster nodes   | Configured with and without a switch |
| Two server cluster  | Three cluster nodes | Configured with a switch only        |
| Three server cluster| N cluster nodes     | Switch only                          |

When upgrading a single from two to three nodes, the storage resiliency level will be changed from a two-way mirror to a three-way mirror.

### Hardware requirements

When adding or repairing a server, the system validates the hardware of the new, incoming node and ensures that the node meets the hardware requirements before it is added to the cluster.

Here is a list of hardware components that are checked:

| **Component** | **Compliancy check**               |
|---------------|------------------------------------|
| CPU           | Validate the new server has the same number of or more CPU cores. If the CPU cores on the incoming node does not meet this requirement, a warning is presented. The operation is however allowed.                             |
| Memory        | Validate the new server has the same amount of or more memory installed. If the memory on the incoming node does not meet this requirement, a warning is presented. The operation is however allowed.                         |
| Drives        | Validate the new server has the same number of data drives available for Storage Spaces Direct. If the number of drives on the incoming node do not meet this requirement, an error is reported and the operation is blocked. |

## Prerequisites

Before you add a server, you must ensure that:

- Deployment user is active in Active Directory.
- Signed in as deployment user or another user with equivalent permissions.
- Credentials for the deployment user have not changed.

## Add a server

This section describes how to add a server using PowerShell, monitor the status of the `Add-Server` operation and troubleshoot, if there are any issues.

### Add a server using PowerShell

Make sure that you have reviewed and completed the [prerequisites](#prerequisites-for-add-and-repair-servers). Follow these steps to add a server using PowerShell.

1. Install the operating system and required drivers on the new node that you plan to add. Follow the steps in [Install the Azure Stack HCI, version 22H2 Operating System](../deploy/deployment-tool-install-os).

    > [!NOTE]
    > You must also [Install required Windows Roles](../deploy/deployment-tool-install-os.md#install-required-windows-roles).

1. Sign as a local administrator account, into the new server that will join the existing cluster.
1. On the server you signed into, run the following script to ensure that the new server is at the same patch level as the servers that are already a part of the cluster.



1. Close all PowerShell session on the server you are signed in.
1. In a new Powershell session, run the following command:

    ```powershell
    Uninstall-module –Name PSWIndowsUpdate –Force
    ```   

1.  Sign in with the lifecycle manager account into a server that is already a member of the cluster. Run the following command to add the new server

    ```powershell
    $Cred = Get-Credential 
    Add-Server -Name "< Name of the new server>" -HostIpv4 -LocalAdminCredential $Cred 
    ```
1. Make a note of the operation ID as output by the `Add-Server` command. You’ll use this later to monitor the progress of the `Add-Server` operation.

### Monitor operation progress

To monitor the progress of the add server operation, follow these steps:

1. Run the following cmdlet and provide the operation ID from the previous step.

    ```powershell
    $ID = "<Operation ID>" 
    Start-MonitoringActionplanInstanceToComplete -actionPlanInstanceID $ID 
    ```

1. After the add server operation is complete, the background storage rebalancing job will continue to run. To verify the progress of this storage rebalancing job, use the following cmdlet:

    ```powershell
    Get-VirtualDisk Get-StorageJob
    ```

    If the storage job is complete, the cmdlet won't return an output.

### Troubleshooting

1. If you experience failures or errors while adding a server, you can capture the output of the failures in a log file.

    ```powershell
    Get-ActionPlanInstance -ActionPlanInstanceID $ID out-file log.txt
    ```

1. To rerun the failed operation, use the following cmdlet:

    ```powershell
    Add-Server -Rerun
    ``` 


## Next steps

[Learn more about Hybrid capabilities with Azure services](../hybrid-capabilities-with-azure-services.md)
