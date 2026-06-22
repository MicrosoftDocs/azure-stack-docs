---
title: Rotate cluster credentials on Azure Local
description: Learn how to rotate Azure Local cluster credentials by using the az networkcloud cluster rotate-credential command.
author: ghugo
ms.author: gagehugo
ms.topic: how-to
ms.service: azure-local
ms.date: 05/27/2026
---

# Rotate cluster credentials on Azure Local

This article describes how to rotate cluster credentials on Azure Local by using the `az networkcloud cluster rotate-credential` command.

## Prerequisites

Before you begin:

- Install and sign in to Azure CLI. For more information, see [Install Azure CLI](/cli/azure/install-azure-cli).
- Make sure that the cluster is healthy and online.
- Make sure that your account has permissions to run write operations on the target cluster resource.
- Make sure that the target Azure Local cluster is running the edge credential service.

  > [!IMPORTANT]
  > The `az networkcloud cluster rotate-credential` API is only supported for clusters running the edge credential service. If you run this command against an Operator Nexus cluster, the operation fails with an unsupported error.

## Rotate a credential

Use the following command syntax:

```azurecli
az networkcloud cluster rotate-credential \
  -g <resource-group-name> \
  -n <cluster-name> \
  --credentials <credential-type>
```

The `--credentials` parameter accepts the following values:

- `console-credential` - Rotates the console user credential used for user access.
- `bmc-credential` - Rotates the baseboard management controller (BMC) credential used to manage the cluster hardware.
- `storage-appliance-credential` - Rotates the credential used to access the storage appliance associated with the cluster.
- `root-credential` - Rotates the root user credential on the cluster. This option only works when the root user is enabled.

### Example commands

Rotate the console credential:

```azurecli
az networkcloud cluster rotate-credential \
  -g <resource-group-name> \
  -n <cluster-name> \
  --credentials console-credential
```

Rotate the BMC credential:

```azurecli
az networkcloud cluster rotate-credential \
  -g <resource-group-name> \
  -n <cluster-name> \
  --credentials bmc-credential
```

## Unsupported and error scenarios

### Operator Nexus clusters

If you run this command on an Operator Nexus cluster, the request returns an unsupported operation error because Nexus clusters don't support this API.

Example:

```output
This API only supports clusters running the edge credential manager service.
```

### Root user not enabled

If you run the `rotate-credential` command on a cluster where the root user isn't enabled and specify `--credential root-credential`, the request fails.

Example:

```output
Credential root-credential was entered for rotation but this user is not enabled.
```