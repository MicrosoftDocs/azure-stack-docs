---
title: Recover a Data Cluster Created Post Backup After Disconnected Operations Restore
description: Learn how to reconnect and re-register an Azure Local data cluster that was created after the most recent backup, following a disconnected operations restore.
author: anupam8995
ms.author: kumaranupam
ms.date: 07/22/2026
ms.topic: how-to
ms.service: azure-local
ms.subservice: hyperconverged
ai-usage: ai-assisted
---

# Recover a data cluster created after backup following a disconnected operations restore

::: moniker range=">=azloc-2603"

This article describes how to recover an Azure Local data cluster that you created *after* the most recent backup, following a [restore for disconnected operations](disconnected-operations-restore.md). Because the data cluster didn't exist when the backup was taken, the restored Azure Local disconnected operations (ALDO) environment doesn't include its registration. Recovery requires two procedures: first reconnect the data cluster to the restored environment, and then re-register the cluster so that its Azure resource representation is recreated.

## Prerequisites

Before you start, complete these prerequisites:

- **Restore complete**: The [restore operation](disconnected-operations-restore.md) for the Azure Local disconnected environment finished successfully.
- **Data cluster created after backup**: You created the data cluster after the backup that's used for the restore.
- **Operator access**: The identity that performs the recovery has the required OperatorRP RBAC role in the Operator subscription. For more information, see [Operator subscription and RBAC permissions](disconnected-operations-identity.md).

## Recovery workflow

To recover a data cluster that you created after backup, complete the following steps in order:

1. Reconnect the data cluster to the restored disconnected operations environment.
1. Re-register the data cluster on the restored disconnected operations setup.

## Step 1: Reconnect the data cluster

Reconnect the data cluster to the restored IRVM01 by updating DNS, flushing cached records, and restarting the Azure Arc agents on the cluster hosts and DVM.

Follow the procedure in [Reconnect a data cluster after a disconnected operations restore](disconnected-operations-post-restore-reconnect-cluster.md).

After the reconnection completes, the data cluster resolves the new DVM and the Azure Connected Machine agents reestablish their connection to the restored environment.

## Step 2: Re-register the data cluster

After reconnecting the data cluster, re-register it on the restored Azure Local disconnected operations setup so that the Azure resource representation is recreated. This procedure also recreates the Arc Resource Bridge (ARB), custom location (CL), logical network (Lnet), and storage resources for the cluster.

Follow the procedure in [Re-register the management or data cluster (created post backup) on a restored ALDO setup](disconnected-operations-post-restore-repair-register-management-cluster.md).

When this step finishes, the data cluster and its associated Arc resources are available in the restored Azure Local disconnected operations environment.

## Related content

- [Reconnect a data cluster after a disconnected operations restore](disconnected-operations-post-restore-reconnect-cluster.md)
- [Re-register the management or data cluster (created post backup) on a restored ALDO setup](disconnected-operations-post-restore-repair-register-management-cluster.md)
- [Restore for disconnected operations for Azure Local](disconnected-operations-restore.md)
- [Reconnect Azure Arc on cluster machines after a disconnected operations restore](disconnected-operations-post-restore-reconnect-arc.md)
- [Disconnected operations for Azure Local](/azure/azure-local/manage/disconnected-operations-overview?view=azloc-2602&preserve-view=true)

::: moniker-end

::: moniker range="<=azloc-2602"

This feature is available only in Azure Local 2603 or later.

::: moniker-end
