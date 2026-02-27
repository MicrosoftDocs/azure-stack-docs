---
title: Cluster Inspect Action Hardware Validation
description: Overview of Cluster Inspect Action Hardware Validation
author: vanjams
ms.author: vanjanikolin
ms.service: azure-operator-nexus
ms.topic: how-to
ms.date: 02/03/2026
ms.custom: template-how-to
---

# Cluster Inspect Action to run Hardware Validation

This article describes how to run a cluster inspect action, which performs a [Hardware Validation (HWV)](./concepts-hardware-validation-overview.md) on bare metal servers in a cluster.

The time required to complete cluster inspect depends on the number of nodes and type of cluster and whether "ResetHardware" flag is used.

## Prerequisites

- Gather the following information:
  - Name of the resource group for the cluster
  - Name of the Bare Metal Machine (BMM) and/or rack to include in the cluster inspection
  - Subscription ID
- Cluster Detailed status must be either `Pending Deployment` or `Running`
- The cluster inspect action requires 2026-01-01-preview API

> [!IMPORTANT]
> Cluster inspect action is rejected if there's another running cluster inspection or HWV on the cluster.
>
> `ResetHardware` is only supported on clusters in `Pending Deployment` state


## Cluster Inspect Command Arguments

The `az networkcloud cluster inspect` command triggers an inspection of the cluster to perform validation and optional corrective actions based on the supplied extra actions and filters.

| Parameter | Description |
|---|---|
| `--cluster-name` | The name of the cluster. |
| `--ids` | Cluster resource ID. |
| `--resource-group`, `-g` | Name of the resource group. You can configure the default group using `az configure --defaults group=<name>`. |
| `--subscription` | Name or ID of subscription. You can configure the default subscription using `az account set -s NAME_OR_ID`. |
| `--filter-devices` | Indicates which devices are included in the inspection. By default, all devices that can be targeted are included. Supports shorthand-syntax, json-file, and yaml-file. |
| `--additional-actions` | Extra actions supplement the default nondisruptive cluster inspection. Extra actions are disallowed if the cluster is in a deployed and running state. Supports shorthand-syntax, json-file, and yaml-file. |
| `--no-wait` | Don't wait for the long-running operation to finish. Allowed values: `0`, `1`, `f`, `false`, `n`, `no`, `t`, `true`, `y`, `yes`. |

## Running Cluster Inspect Action


**The following Azure CLI command will run a read only, non-disruptive Cluster Inspect Action against all BMMs in a cluster:**

```azurecli
az networkcloud cluster inspect \
  --ids <Resource ID>
```

**The following Azure CLI command will run a disruptive Cluster Inspection against one BMM**

```azurecli
az networkcloud cluster inspect \
  --ids <Resource ID> \
  --filter-devices '{"bareMetalMachineNames": [<BMM name>]}' \
  --additional-actions ResetHardware
```

**The following Azure CLI command will run a disruptive Cluster Inspection against one rack**

```azurecli
az networkcloud cluster inspect \
  --ids <Resource ID> \
  --filter-devices '{"rackNames": [<rack name>]}' \
  --additional-actions ResetHardware
```

> [!NOTE]
> The BMM names specified in `bareMetalMachineNames` and rack names specified in `rackNames` are case sensitive. Multiple bare metal machines can be listed in `bareMetalMachineNames` and multiple rack names can be listed in `rackNames`. Both `bareMetalMachineNames` and `rackNames` can be used together in the same command; the resulting filter is additive.

## Cluster Inspect Action Results

Cluster Inspection results are logged to the Cluster Log Analytics Workspace.

If hardware validation fails during cluster inspection, see [Troubleshoot hardware validation failure](./troubleshoot-hardware-validation-failure.md) for detailed troubleshooting procedures organized by validation category.