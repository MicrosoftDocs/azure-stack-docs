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

Root squash is a security feature that prevents root users from accessing files on the file system. When root squash is enabled, root users are mapped to the anonymous user ID (UID) and group ID (GID) on the file system. The anonymous UID and GID are set to 65534 by default. You can change the anonymous UID and GID to a different value during cluster creation.

## Prerequisites

- An Azure subscription. If you don't have an Azure subscription, [create a free account](https://azure.microsoft.com/free/) before you begin.

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
