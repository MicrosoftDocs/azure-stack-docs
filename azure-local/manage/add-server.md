---
title: Manage Capacity by Adding a Node on Azure Local, Version 24H2
description: Learn how to manage capacity on your Azure Local, version 24H2 system by adding a node.
ms.topic: how-to
author: rajeshkumar
ms.author: rajeshkumar
ms.date: 06/17/2026
ms.subservice: hyperconverged
---

# Add a node on Azure Local

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes how to manage capacity by adding a node (often called scale-out) to your Azure Local instance. In this article, each server is referred to as a node.

## About add nodes

You can easily scale the compute and storage at the same time on Azure Local by adding nodes to an existing system. Your Azure Local instance supports a maximum of 16 nodes.

Each new physical node that you add to your system must closely match the rest of the nodes in terms of CPU type, memory, number of drives, and the type and size of the drives.

You can dynamically scale your Azure Local instance from 1 to 16 nodes. In response to the scaling, the orchestrator (also known as Lifecycle Manager) adjusts the drive resiliency, network configuration including the on-premises agents such as orchestrator agents, and Arc registration. The dynamic scaling might require the network architecture change from connected without a switch to connected via a network switch.

> [!IMPORTANT]
>
> - In this release, you can only add one node at any given time. You can however add multiple nodes sequentially so that the storage pool is rebalanced only once.
> - It isn't possible to permanently remove a node from a system.

## Add node workflow

The following flow diagram shows the overall process to add a node:

:::image type="content" source="./media/add-server/add-server-workflow.png" alt-text="Diagram illustrating process to add a node." lightbox="./media/add-server/add-server-workflow.png":::

To add a node, follow these high-level steps:

1. Install the operating system, drivers, and firmware on the new node that you plan to add. For more information, see [Install OS](../deploy/deployment-install-os.md).
2. Add the prepared node by using either PowerShell (`Add-Server`) or the Azure Local experience in the Azure portal.
3. When you add a node to the system, the system validates that the new incoming node meets the CPU, memory, and storage (drives) requirements before it actually adds the node.
4. Once the node is added, the system is also validated to ensure that it's functioning normally. Next, the storage pool is automatically rebalanced. Storage rebalance is a low priority task that doesn't affect actual workloads. The rebalance can run for multiple days depending on number of the nodes and the storage used.

> [!NOTE]
> If you deployed your Azure Local instance using custom storage IPs, you must manually assign IPs to the storage network adapters after the node is added.

## Supported scenarios

When you add a node, the following scale-out scenarios are supported:

| **Start scenario** | **Target scenario** | **Resiliency settings** | **Storage network architecture** | **Witness settings** |
| -- | -- | -- | -- | -- |
| Single-node | Two-node system | Two-way mirror | Configured with and without a switch | Witness required for target scenario. |
| Two-node system | Three-node system | Three-way mirror | Configured with a switch only | Witness optional for target scenario. |
| Three-node system | N-node system | Three-way mirror | Switch only | Witness optional for target scenario. |

When you upgrade a system from two to three nodes, the storage resiliency level changes from a two-way mirror to a three-way mirror.

The following scenarios are currently not supported via the **Azure portal**:
- Scaling out from a single-node to two-node system
- Scaling out for rack aware clusters
- Scaling out for disaggregated deployments with local availability zones configured
- Scaling out is not supported for systems deployed in the Azure Government cloud

### Resiliency settings

In this release, the add node operation doesn't perform specific tasks on the workload volumes that you create after the deployment.

For the add node operation, the resiliency settings update for the required infrastructure volumes and the workload volumes that you create during the deployment. The settings stay the same for other workload volumes that you create after the deployment (since the intentional resiliency settings for these volumes aren't known and you might want a two-way mirror volume regardless of the system scale).

However, the default resiliency settings update at the storage pool level, so any new workload volumes that you create after the deployment inherit the resiliency settings.

### Hardware requirements

When you add a node, the system validates the hardware of the new, incoming node and ensures that the node meets the hardware requirements before adding it to the system.

[!INCLUDE [hci-hardware-requirements-add-repair-server](../includes/hci-hardware-requirements-add-repair-server.md)]

## Prerequisites

Before you add a node, complete the hardware and software prerequisites.

### Hardware prerequisites

Make sure you complete the following prerequisites:

1. Acquire new Azure Local hardware from your original OEM. Always refer to your OEM-provided documentation when adding new node hardware for use in your system.
2. Place the new physical node in the predetermined location, such as a rack, and cable it appropriately.
3. Enable and adjust physical switch ports as applicable in your network environment.

### Software prerequisites

Make sure you complete the following prerequisites:

[!INCLUDE [hci-prerequisites-add-repair-server](../includes/hci-prerequisites-add-repair-server.md)]

## Add a node

You can add a node to your Azure Local instance by using either PowerShell or the Azure Local experience in the Azure portal.

## [PowerShell](#tab/azure-powershell)

Use PowerShell when you want to script and automate the add node workflow.

### Prepare (PowerShell)

Follow these steps to add a node by using PowerShell:

1. Install the operating system, drivers, and firmware on the new node that you plan to add. For more information, see [Install OS](../deploy/deployment-install-os.md).

   > [!IMPORTANT]
   > For versions 2503 and later, use the OS image from the same solution version as the existing cluster. Use [Get solution version](/azure/azure-local/update/azure-update-manager-23h2#get-solution-version) to identify the running solution version, and use the [OS image table](https://github.com/Azure-Samples/AzureLocal/blob/main/os-image/os-image-tracking-table.md) to select a matching image. Avoid selecting the image only from Azure portal because not all image versions might be listed.

2. Register the new node with Arc. For guidance, see [Register with Arc and set up permissions](/azure/azure-local/deploy/deployment-arc-register-server-permissions).

   > [!NOTE]
   > Use the same Arc registration parameters as the existing nodes, including resource group, region, subscription, and tenant.

3. Assign required permissions to the newly added node, including **Azure Stack HCI Device Management Role**, **Connected InfraVMs**, and **Key Vault Secrets User**.
4. Run the `Add-Server` cmdlet to add the prepared node to your Azure Local instance.

   Example:

   ```powershell
   Add-Server -Name "<new-node-name>"
   ```

5. Wait for system validation to confirm that the incoming node meets CPU, memory, and storage (drives) requirements.
6. Verify that the node is added successfully and allow storage rebalance to complete. Rebalance is a low-priority background task and can run for multiple days depending on node count and storage usage.

### If scaling from a single-node system

Before you run `Add-Server`, complete these tasks:

1. Configure a quorum witness. See [Deploy a quorum witness](/windows-server/failover-clustering/deploy-quorum-witness?tabs=domain-joined-witness%2Cpowershell%2Cfailovercluster1&pivots=cloud-witness).
2. Configure a storage intent if you didn't configure one during the initial deployment.

   Example:

   ```powershell
   Set-StorageNetworkIntent -Name "StorageNet" -StorageIntentAdapters "Ethernet1, Ethernet2" -Switchless $false -VLANID "877, 888"
   ```

### Run the add node operation

On a node that already exists in your system, follow these steps:

1. Sign in with the domain user credentials (AzureStackLCMUser or an equivalent user) that you provided during system deployment.
2. Run the following command to add the incoming node by using local administrator credentials for the new node:

   ```powershell
   $HostIpv4 = "<IPv4 for the new node>"
   $Cred = Get-Credential
   Add-Server -Name "<Name of the new node>" -HostIpv4 $HostIpv4 -LocalAdminCredential $Cred
   ```

3. Save the operation ID returned by `Add-Server`. You use this ID to monitor operation progress.

### Monitor operation progress (PowerShell)

1. Run the following cmdlet and provide the operation ID from the previous step:

   ```powershell
   $ID = "<Operation ID>"
   Start-MonitoringActionplanInstanceToComplete -ActionPlanInstanceID $ID
   ```

2. After the add node operation completes, monitor storage rebalance progress:

   ```powershell
   Get-VirtualDisk | Get-StorageJob
   ```

   If storage rebalance is complete, this cmdlet returns no output.

3. If needed, force synchronization so the node appears sooner in Azure portal:

   ```powershell
   Sync-AzureStackHCI
   ```

### Recovery scenarios

| Scenario | Mitigation | Rerun required |
| -- | -- | -- |
| Added a new node out of band without using the orchestrator. | Remove the added node and use the orchestrator to add the node. | No |
| Added a new node with orchestrator and the operation failed. | Investigate the failure and rerun the failed operation by using `Add-Server -Rerun`. | Yes |
| Added a new node with orchestrator and the operation partially succeeded, but you must start with a fresh OS install. | Use the repair node scenario because orchestrator already updated its knowledge store with the new node. | Yes |

### Troubleshoot PowerShell add node operations

> [!NOTE]
> Starting with release 2508, validation runs after you execute the `Add-Server` command. If a test fails, the validator returns details to help resolve the failure.

If you experience failures while adding a node, capture output to a log file:

```powershell
Get-ActionPlanInstance -ActionPlanInstanceID $ID | Out-File log.txt
```

To rerun a failed operation:

```powershell
Add-Server -Rerun
```

> [!NOTE]
> If you deployed your Azure Local instance using custom storage IPs, you must manually assign IPs to the storage network adapters after the node is added.

## [Azure portal (preview)](#tab/azure-portal)

Use the Azure Local experience in the Azure portal for a guided, wizard-based workflow.

### Prepare (Azure portal)

The add node wizard in the Azure portal guides you through eight steps to successfully add a new machine to your cluster.

Follow these steps to add a node using the Azure portal:

#### Step 1: Launch the wizard

1. In the Azure portal, go to your Azure Local instance.
2. In the **Machines** pane, select **Add Machine**.
3. The **Basics** tab opens automatically.

:::image type="content" source="./media/add-server/add-server-machine-pane.png" alt-text="Screenshot of the Machines pane with the Add Machine button." lightbox="./media/add-server/add-server-machine-pane.png":::

#### Step 2: Select machine in Basics tab

In the **Basics** tab, select the machine that you want to add to your cluster.

:::image type="content" source="./media/add-server/add-server-add-machine-selection.png" alt-text="Screenshot of the Basics tab showing available machines to add." lightbox="./media/add-server/add-server-add-machine-selection.png":::

1. **Machine selection**: The context pane displays all available machines. Filter and select the machine you want to add.
2. **Key vault selection**: Create a new key vault or select an existing key vault to continue.
3. **Local administrator**: Local administrator user credentials for the machines. Use the same credential for all machines.
4. **Extension installation**: After selection, the wizard automatically installs mandatory extensions on the machine.
5. **Machine state**: The machine transitions to the **Ready** state once extension installation completes.

#### Step 3: Lite validation

In this step, the wizard performs initial validation on the selected machine.

:::image type="content" source="./media/add-server/add-server-machine-selection-basics.png" alt-text="Screenshot of the Lite Validation step showing validation controls." lightbox="./media/add-server/add-server-machine-selection-basics.png":::

1. Select **Validate selected machines** to run the validation.
2. If validation succeeds, the **Next** button becomes enabled to proceed to the Networking tab.
3. If validation fails, review the error message for details and resolve the issue before retrying.

### Add node operation

#### Step 4: Networking tab

The Networking tab automatically processes network configuration for your cluster.


- No user interaction is required on this tab.
- The wizard automatically proceeds to the Validation tab after processing networking configuration.

#### Step 5: Validation and RBAC assignment

The Validation tab assigns necessary permissions for the add node operation to succeed.

:::image type="content" source="./media/add-server/add-server-machine-validation-rbac.png" alt-text="Screenshot of the Validation tab showing RBAC assignments." lightbox="./media/add-server/add-server-machine-validation-rbac.png":::

The following role-based access control (RBAC) assignments are configured:

| **Scope** | **Role** | **Purpose** |
| -- | -- | -- |
| Resource Group | Azure Stack HCI Device Management Role | Device management on Azure Stack HCI cluster |
| Azure Stack HCI Device | Connected InfraVMs | Infrastructure VM management |
| Secrets (via Key Vault) | Secret User Role | Access cluster secrets during deployment |
| Key Vault (local identity with Azure Key Vault only) | Secret Officer Role, Certificate Officer Role | Secret and certificate management for adless scenarios |

Once the secret is created and the RBAC assignments are configured, assign the **Key Vault Secrets User** role to the existing nodes at the **Secrets** scope.

#### Step 6: Validation job execution

The wizard creates and runs a validation job to verify the configuration before deployment. Select the **Refresh** button to retrieve the latest validation status.

:::image type="content" source="./media/add-server/add-server-validation-job-trigger.png" alt-text="Screenshot showing the validation job trigger in the portal." lightbox="./media/add-server/add-server-validation-job-trigger.png":::

:::image type="content" source="./media/add-server/add-server-validation-progress-status.png" alt-text="Screenshot showing validation job progress and status in the portal." lightbox="./media/add-server/add-server-validation-progress-status.png":::

#### Step 7: Review and create

Review the cluster and machine details before deploying.

:::image type="content" source="./media/add-server/add-server-confirmation-before-deploy.png" alt-text="Screenshot of the review screen showing confirmation before deployment." lightbox="./media/add-server/add-server-confirmation-before-deploy.png":::

Select **Review + Add machine** to trigger the deployment job.

The wizard now transitions to **Deploy mode** and redirects you to the **Jobs** pane to monitor progress.

### Monitor operation progress

#### Step 8: Monitor deployment

Track the add node job in the **Jobs** pane.

:::image type="content" source="./media/add-server/add-server-deployment-job-status.png" alt-text="Screenshot of the Jobs pane showing add node deployment tracking." lightbox="media/add-server/add-server-deployment-job-status.png":::


The newly added node appears in the **Machines** pane after deployment completes successfully. The Azure portal updates automatically after several hours.

### Troubleshoot

If the add node operation fails, review the error details from the **Jobs** pane by selecting **View details** next to the failed step. After resolving the reported issue, select the job and then select the **Retry** button to resume.

---

### Troubleshoot issues

If you encounter an issue during the add node operation and need help from Microsoft Support, you can follow the steps in [Collect diagnostic logs for Azure Local (preview)](collect-logs.md) to collect and send the diagnostic logs to Microsoft.

You might need to provide diagnostic logs from the new node that's to be added to the cluster. Make sure you run the `Send-DiagnosticData` cmdlet from the new node.

## Next steps

- Learn more about how to [Repair a node](./repair-server.md).
