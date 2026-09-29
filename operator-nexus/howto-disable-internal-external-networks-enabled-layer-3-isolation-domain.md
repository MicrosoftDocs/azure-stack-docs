---
title: Disable internal or external networks in an enabled Layer 3 isolation domain
description: Learn to safely disable internal and external networks in an enabled Layer 3 isolation domain in Azure Operator Nexus.
author: rbhupatiraju-ms
ms.author: rbhupatiraju
ms.service: azure-operator-nexus
ms.topic: how-to
ms.date: 05/16/2025
ms.custom: template-how-to
#Customer intent: As a network operator, I want to disable internal and external networks in an enabled Layer 3 isolation domain so that I can change network resources without disrupting service.
---

# How to disable internal and external networks in an enabled Layer 3 isolation domain

This article explains how to disable internal and external networks in an enabled Layer 3 isolation domain in Azure Operator Nexus. It also explains how to re-enable or delete them by following the Commit Workflow v2 process.

## Prerequisites

- The fabric supports Commit Workflow v2.
- The Layer 3 isolation domain (ISD) is enabled.
- Fabric Runtime version 7.0.0 or later.

> [!NOTE]
>
> - Always perform a **Lock** followed by a **Commit** after administrative state changes.
> - You can delete a network only after you disable it and commit the change.
> - You can't disable or enable a network if the parent Layer 3 ISD isn't enabled.
> - Associated resources are also disabled unless they're shared globally.

## Common parameters

The following parameters are used across the commands in this article:

- `--resource-group <rg>` – Resource group that contains the ISD and network resources.
- `--l3-isolation-domain-name <isd-name>` – The Layer 3 isolation domain that the networks belong to.
- `--resource-name <resource-name>` – Internal or external network resource name.
- `--fabric <fabric-name>` – Fabric resource name for commit operations.

## Disable the external network

Set the administrative state of the external network to **Disable**.

```azurecli
az networkfabric externalnetwork update-admin-state \
  --resource-group <rg> \
  --l3-isolation-domain-name <isd-name> \
  --resource-name <external-network-name> \
  --state Disable
```
### Verify state

```azurecli
az networkfabric externalnetwork show \
  --resource-group <rg> \
  --l3-isolation-domain-name <isd-name> \
  --resource-name <external-network-name> \
  --query "{name:name, adminState:administrativeState, provState:provisioningState}"
```

## Disable an internal network

> [!WARNING]
> Keep at least one Internal Network enabled per ISD to avoid service disruption.

Set the administrative state of the internal network to **Disable**.

### Disable the internal network:

```azurecli
az networkfabric internalnetwork update-admin-state \
  --resource-group <rg> \
  --l3-isolation-domain-name <isd-name> \
  --resource-name <internal-network-name> \
  --state Disable
```

### Verify state:

```azurecli
az networkfabric internalnetwork show \
  --resource-group <rg> \
  --l3-isolation-domain-name <isd-name> \
  --resource-name <internal-network-name> \
  --query "{name:name, adminState:administrativeState, provState:provisioningState}"
```

## Commit Workflow v2 (Fabric-wide)

Always perform a **Lock** followed by a **Commit** after administrative state changes. Use the Commit Workflow v2: lock the new fabric configuration, inspect the configuration diff, and then commit the changes. For more information, see [How to use Commit Workflow v2 in Azure Operator Nexus](./howto-use-commit-workflow-v2.md)

## Re-enable a network (rollback or enable)

### External network: Enable

```azurecli
az networkfabric externalnetwork update-admin-state \
  --resource-group <rg> \
  --l3-isolation-domain-name <isd-name> \
  --resource-name <external-network-name> \
  --state Enable  
```

### Internal network: Enable

```azurecli
az networkfabric internalnetwork update-admin-state \
  --resource-group <rg> \
  --l3-isolation-domain-name <isd-name> \
  --resource-name <internal-network-name> \
  --state Enable   
```

### Commit the change

To lock and commit the change after you enable the network, see [Commit Workflow v2](./howto-use-commit-workflow-v2.md).

## Delete a network (optional)

> [!IMPORTANT]
> You must disable and commit the network before you delete it.

### External network: Delete

```azurecli
az networkfabric externalnetwork delete \
  --resource-group <rg> \
  --l3-isolation-domain-name <isd-name> \
  --resource-name <external-network-name> 
```

### Internal network: Delete

```azurecli
az networkfabric internalnetwork delete \
  --resource-group <rg> \
  --l3-isolation-domain-name <isd-name> \
  --resource-name <internal-network-name>
```

## Frequently asked questions

This section answers common questions about disabling and re-enabling internal and external networks.

### Why can't I delete a network directly?

You can't delete a network directly because it helps maintain configuration integrity and prevents traffic disruption. Disable the network and commit the change first.

### Can I re-enable a disabled network?

Yes. Set the administrative state back to `Enable`, and then commit the change through Commit Workflow v2.

## Related content

- [How to use Commit Workflow v2 in Azure Operator Nexus](./howto-use-commit-workflow-v2.md)
