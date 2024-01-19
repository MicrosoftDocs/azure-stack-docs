---
title: Configure root squash settings for Azure Managed Lustre file systems
description: Learn how to configure root squash settings for Azure Managed Lustre file systems. 
ms.topic: how-to
ms.date: 01/10/2024
author: pauljewellmsft
ms.author: pauljewell
ms.reviewer: mayabishop

---

# Configure root squash settings for Azure Managed Lustre file systems

Root squash is a security feature that prevents a user with root privileges on a client from accessing files on the file system.

## Prerequisites

- An Azure subscription. If you don't have an Azure subscription, [create a free account](https://azure.microsoft.com/free/) before you begin.

## Root squash settings

The following table details the available parameters for `rootSquashSettings` at the REST API level:

| Parameter | Values | Type | Description |
| --- | --- | --- | --- |
| `mode` | `RootOnly`, `All`, `None` | String | `RootOnly`: Affects only the **root** user on non-trusted systems. UID and GID on files are squashed to the provided `squashUID` and `squashGID`, respectively.</br>`All`: Affects **all** users on non-trusted systems. UID and GID on files are squashed to the provided `squashUID` and `squashGID`, respectively.</br>`None` (default): Disables the root squash feature so that no squashing of UID and GID is performed for any user on any system. |
| `nosquashNidLists` | | String | Network ID (NID) IP address lists added to the trusted systems. |
| `squashUID` | 1 - 4294967295 | Integer | Numeric value that the user ID (UID) is squashed to. |
| `squashGID` | 1 - 4294967295 | Integer | Numeric value that the group ID (GID) is squashed to. |

## Enable root squash during cluster creation

When you create an Azure Managed Lustre file system, you can enable root squash during cluster creation.

To enable root squash during cluster creation, follow these steps:

## Change root squash settings for an existing cluster

You can change the root squash settings for an existing Azure Managed Lustre file system by using the Azure portal. To change the root squash settings for an existing cluster, follow these steps:

## Disable root squash for an existing cluster

You can disable root squash for an existing Azure Managed Lustre file system by using the Azure portal. To disable root squash for an existing cluster, follow these steps:

## Next steps

To learn more about Azure Managed Lustre, see the following articles:

- [What is Azure Managed Lustre?](amlfs-overview.md)
- [Create an Azure Managed Lustre file system](create-file-system-portal.md)

To learn more about root squash settings for Azure Managed Lustre, see the following article:

- [Manage root squash settings for Azure Managed Lustre file systems](root-squash-overview.md)
