---
title: Reuse Azure Arc-enabled server resources when you migrate VMs to Azure Local
description: Learn how to retain existing Azure Arc connected machine agents when you migrate VMware and Hyper-V VMs to Azure Local using Azure Migrate.
author: trumanbrown
ms.topic: how-to
ms.date: 09/28/2026
ms.author: trumanbrown
ms.subservice: hyperconverged
---

# Reuse Azure Arc-enabled server resources when you migrate VMs to Azure Local

[!INCLUDE [hci-applies-to-2503](../includes/hci-applies-to-2503.md)]

This article describes how to retain the existing [Azure Connected Machine agent](/azure/azure-arc/servers/agent-overview) on your source virtual machines (VMs) when you migrate them to Azure Local using Azure Migrate. It applies to both VMware and Hyper-V source VMs that are onboarded as [Azure Arc-enabled servers](/azure/azure-arc/servers/overview).
## Benefits

Arc reuse provides the following benefits when you migrate Arc-enabled VMs to Azure Local:

- **Retain the existing Azure Arc resource and configuration.** Azure Migrate transitions the existing Microsoft.HybridCompute/machines resource from an Arc-enabled server to an Azure Local VM. Tags, role-based access control (RBAC) assignments, Azure Policy assignments, monitoring configuration, and installed VM extensions carry forward with the resource.
- **Keep the existing Connected Machine agent.** Azure Migrate reconfigures the agent during migration, so you don't need to uninstall it before migration and reinstall it afterward.

You don't need to create a new Azure Migrate project to use Arc reuse. Azure Migrate fully supports existing projects, including projects that have appliances already registered and VMs already replicating.

> [!NOTE]
> Arc reuse doesn't change how VM data is replicated. Disks continue to replicate directly from the source appliance to the target Azure Local instance.

## Key considerations

Because the migrated VM inherits the identity of the existing Azure Arc resource, several target properties are locked to that resource. Review these considerations before you plan your replication batches.

| Consideration | Details |
|---|---|
| Only Arc-enabled servers are supported | Reuse requires source VMs onboarded as Azure Arc-enabled servers, where the Connected Machine agent is installed directly on the guest OS. This requirement corresponds to a `Microsoft.HybridCompute/machines` resource with no `kind` property set. Machines projected through an [Azure Arc resource bridge](/azure/azure-arc/resource-bridge/overview) aren't supported, even with guest management enabled. This limitation includes [Arc-enabled VMware vSphere](/azure/azure-arc/vmware-vsphere/overview) (`kind: VMware`), [Arc-enabled SCVMM](/azure/azure-arc/system-center-virtual-machine-manager/overview) (`kind: SCVMM`), Azure Local (`kind: HCI`), and Azure VMware Solution (`kind: AVS`). To check a machine, open its Azure Arc resource and select **Overview** > **JSON View**. This requirement applies to the source VM before migration. After a successful migration, the reused resource becomes an Azure Local VM (`kind: HCI`). |
| Resource group is locked | Target VMs are created in the resource group that contains the selected Arc-enabled server resources. On the **Target settings** step, **VM subscription** and **Resource group** are read-only. |
| Region doesn't change | Migration doesn't change the region of the reused Azure Arc resource. Instead, it adds the custom location of the target Azure Local instance to the resource. After migration, the **Overview** page shows **Location** as that custom location, in the form `<instance-name>-customlocation (<region>)`. |
| Mixed batches follow the Arc-enabled resource group | If a batch contains both reuse and non-reuse VMs, including VMs that aren't Arc-enabled, *all* of them are created in the Arc-enabled resource group. To place other VMs elsewhere, replicate them in a separate batch. |
| VM name is locked | For an Arc-enabled source VM selected for reuse, **Target VM name** is fixed to the name of the source Arc-enabled resource, because that Azure Arc property is immutable. Non-reuse VMs can still be renamed during migration. Renaming the VM in the source environment doesn't change the Azure Arc resource name. To change the name, delete and recreate the Azure Arc resource before you start replication, which also discards the tags, role assignments, and policy assignments that reuse preserves. For more information, see [How to rename Azure Arc-enabled servers and migrate across regions](/azure/azure-arc/servers/manage-howto-migrate). |
| Move resource groups *before* you migrate | Azure Local VMs enabled by Azure Arc currently can't be moved between resource groups after migration. Move the Azure Arc resource first, then select **Refresh Arc status** in the wizard to pick up the change. |
| Non-reused Arc resources are orphaned | An Arc-enabled source VM replicated without **Reuse Arc-enabled server** selected leaves behind a stale Azure Arc resource that you must delete manually. VMs that aren't Arc-enabled aren't affected. |
| Uninstall the agent if you don't reuse | If you don't reuse an Arc-enabled source VM's resource, uninstall the Connected Machine agent before you migrate it. Migrating with the agent still active results in a duplicate, nonfunctional Azure Arc resource that's difficult to troubleshoot. For more information, see [Uninstall the agent](/azure/azure-arc/servers/manage-agent?tabs=windows#uninstall-the-agent). |
| Reuse can't be changed after replication starts | To change the setting, stop replication and start a new replication batch. |

## Prerequisites

Before you begin, make sure that:

- You have a new or existing Azure Migrate project for Azure Local with the source and target appliances registered and discovery completed. Your environment must also meet the requirements for [VMware VM migration](migrate-vmware-replicate.md) or [Hyper-V VM migration](migrate-hyperv-replicate.md).
- The source VMs that you want to reuse are Azure Arc-enabled servers, have the Azure Connected Machine agent installed, and show a **Connected** status in Azure Arc.

- You have the [Azure Local Migrate Owner](/azure/role-based-access-control/built-in-roles/migration#azure-local-migrate-owner) role on the subscription that contains the Arc-enabled resources that you're migrating.

## Configure Arc reuse in the Replicate wizard


In your Azure Migrate project, start the Replicate wizard for Azure Local. Complete Basics and Target appliance as described in [Discover and replicate VMware VMs](migrate-vmware-replicate.md#step-3-start-replication) or [Discover and replicate Hyper-V VMs](migrate-hyperv-replicate.md#step-3-start-replication).

### Virtual machines

1. For **Do you want to retain the Azure Arc-enabled server connected machine agents during migration?**, select **Yes**.

    Select **No** if you want a new Azure Local VM resource projected for every migrated VM. If you select **No**, uninstall the Connected Machine agent on each Arc-enabled source VM before you migrate it.

1. After you select the VMs to replicate, select **Configure Arc-enabled server reuse**, and review the **Arc-enabled server status** and **Resource group** for each VM:

    - **Enabled**: The VM has the Connected Machine agent installed and an existing Azure Arc resource, shown in **Resource group**.
    - **Disabled**: The VM isn't Arc-enabled. It has no resource group or reuse toggle, and is migrated with a new Azure Local VM projection.

    Status comes from the last discovery cycle. If the data looks stale, select **Refresh Arc status**. This action might take some time.

1. Set **Reuse Arc-enabled server** to enabled for each Arc-enabled source VM whose Azure Arc resource you want to retain, then select **Save** and **Next**.

    :::image type="content" source="./media/migrate-arc-reuse/arc-reuse-configure-blade.png" alt-text="Screenshot showing the Configure Arc-enabled server reuse pane with the Reuse Arc-enabled server toggle turned on for an Arc-enabled virtual machine." lightbox="./media/migrate-arc-reuse/arc-reuse-configure-blade.png":::

> [!IMPORTANT]
> All VMs in the batch are deployed into the resource group that contains the selected Arc-enabled server resources, including VMs that aren't Arc-enabled and VMs without **Reuse Arc-enabled server** selected. To migrate other VMs into a different resource group, select them in a separate replication batch.

### Target settings

You can't change the **VM subscription** and **Resource group** because they're locked to match the resource group of the selected Arc-enabled servers. To choose a different subscription or resource group, go back to **Virtual machines** and disable Arc-enabled reuse. All other target settings stay the same.

:::image type="content" source="./media/migrate-arc-reuse/arc-reuse-target-settings.png" alt-text="Screenshot showing the Target settings tab with the locked VM subscription and resource group." lightbox="./media/migrate-arc-reuse/arc-reuse-target-settings.png":::

### Compute


For each Arc-enabled source VM you select for reuse, the **Target VM name** is read-only and matches the source Arc-enabled resource name. It shows the following message:


> This VM is selected for Arc-enabled reuse. The name is fixed to the source Arc-enabled resource and can't be changed.

:::image type="content" source="./media/migrate-arc-reuse/arc-reuse-compute-name.png" alt-text="Screenshot showing the Compute tab with a locked target VM name for a VM selected for Arc reuse." lightbox="./media/migrate-arc-reuse/arc-reuse-compute-name.png":::
Review the compute settings, and then select **Next**.
### Review and start replication

On the **Review + Start replication** tab, validate the selected virtual machines, ensure all details are correct, and then select **Replicate**.

:::image type="content" source="./media/migrate-arc-reuse/arc-reuse-review.png" alt-text="Screenshot showing the Review + Start replication tab with the selected virtual machines pane open." lightbox="./media/migrate-arc-reuse/arc-reuse-review.png":::

## Migrate and verify

After initial replication finishes, migrate the VMs as described in [Migrate VMware VMs to Azure Local using Azure Migrate](migrate-vmware-migrate.md) or [Migrate Hyper-V VMs to Azure Local using Azure Migrate (preview)](migrate-azure-migrate.md). During migration, Azure Migrate reconfigures the Connected Machine agent on the migrated VM instead of onboarding a new one.

To confirm that reuse succeeded, open the Azure Arc resource for the migrated VM and verify the following on the **Overview** page:

- The resource header reads **Machine - Azure Arc (Azure Local)** and **Virtual machine kind** is **Azure Local**. The same `Microsoft.HybridCompute/machines` resource transitioned from an Arc-enabled server to an Azure Local VM, rather than a new resource being projected.
- **Status** is **Running** and **Arc agent** is **Enabled (connected)**.
- The tags that you applied before migration are still present.
- Under **Extensions**, the extensions installed before migration are still listed.

:::image type="content" source="./media/migrate-arc-reuse/arc-reuse-migrated-vm.png" alt-text="Screenshot showing the Overview page of the migrated VM with Virtual machine kind set to Azure Local and tags and extensions retained." lightbox="./media/migrate-arc-reuse/arc-reuse-migrated-vm.png":::

Optionally, verify that Access control (IAM) assignments, Azure Policy assignments, and monitoring data are intact.

## Troubleshoot a failed migration

If the migration fails, the action you take depends on where the **Planned failover** job stopped.

### Failure at or before Starting failover
 
This is the more common failure scenario. No Azure Local resources were created, and the reused Azure Arc resource remains unchanged.

Fix the issue, and then run the migration again as you would for a migration without Arc reuse.

For more information, see [Troubleshoot issues when migrating VMs to Azure Local using Azure Migrate](migrate-troubleshoot.md) and [Known issues in Azure Migrate for Azure Local](migration-known-issues.md).

### Failure at Preparing protected entities or later

An Azure Local VM instance was already created on the reused Azure Arc resource and you must remove it before retrying.

**Don't retry the migration in this state.** [Contact Microsoft Support](../manage/get-support.md) for help with the cleanup.

> [!WARNING]
> Don't delete the `Microsoft.HybridCompute/machines` resource. It holds the Azure Arc configuration that you're preserving, including tags, RBAC assignments, Azure Policy assignments, and extensions. Deleting it can't be undone.

## Next steps

- [Discover and replicate VMware VMs for migration to Azure Local using Azure Migrate](migrate-vmware-replicate.md)
- [Discover and replicate Hyper-V VMs for migration to Azure Local using Azure Migrate (preview)](migrate-hyperv-replicate.md)
- [Migrate VMware VMs to Azure Local using Azure Migrate](migrate-vmware-migrate.md)
- [Migrate Hyper-V VMs to Azure Local using Azure Migrate (preview)](migrate-azure-migrate.md)
