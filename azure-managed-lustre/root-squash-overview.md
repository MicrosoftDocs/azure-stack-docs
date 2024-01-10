---
title: Root squash for Azure Managed Lustre file systems
description: Learn about root squash settings for Azure Managed Lustre file systems. 
ms.topic: conceptual
ms.date: 01/10/2024
author: pauljewellmsft
ms.author: pauljewell
ms.reviewer: mayabishop

---

# Root squash for Azure Managed Lustre file systems

Root squash is a security feature that prevents a user with root privileges on a client from accessing files on the file system.

## Root squash settings

The following table details the available parameters for `rootSquashSettings` at the REST API level:

| Parameter | Values | Type | Description |
| --- | --- | --- | --- |
| `mode` | `RootOnly`, `All`, `None` | String | `RootOnly`: Affects only the **root** user on non-trusted systems. UID and GID on files are squashed to the provided `squashUID` and `squashGID`, respectively.</br>`All`: Affects **all** users on non-trusted systems. UID and GID on files are squashed to the provided `squashUID` and `squashGID`, respectively.</br>`None` (default): Disables the root squash feature so that no squashing of UID and GID is performed for any user on any system. |
| `nosquashNidLists` | | String | Network ID (NID) IP address lists added to the trusted systems. |
| `squashUID` | 1 - 4294967295 | Integer | Numeric value that the user ID (UID) is squashed to. |
| `squashGID` | 1 - 4294967295 | Integer | Numeric value that the group ID (GID) is squashed to. |

## Network identity (NID) range format

You can change the root squash settings for an existing Azure Managed Lustre file system by using the Azure portal. To change the root squash settings for an existing cluster, follow these steps:

## Next steps

- [Configure root squash settings for Azure Managed Lustre file systems](root-squash-configure-setting.md)
