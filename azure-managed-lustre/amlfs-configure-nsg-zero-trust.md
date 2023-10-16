---
title: Configure network security groups for Azure Managed Lustre file systems in a zero-trust environment
description: Configure network security group rules to allow Azure Managed Lustre file system support in a zero-trust virtual network. 
ms.topic: how-to
ms.date: 10/16/2023
author: pauljewellmsft
ms.author: pauljewell
ms.reviewer: mayabishop

---

# Configure a network security group for Azure Managed Lustre file systems in a zero-trust environment

This article describes how to configure network security group (NSG) rules to allow Azure Managed Lustre file system support in a zero-trust virtual network.

## Prerequisites

- An Azure subscription. If you don't have an Azure subscription, [create a free account](https://azure.microsoft.com/free/) before you begin.
- An Azure Managed Lustre file system deployed in your Azure subscription. For more information, see [Create an Azure Managed Lustre file system](../quickstart-create-azure-file-system.md).
- A virtual network (VNet) with a subnet that's configured to allow Azure Managed Lustre file system support. For more information, see [Configure a subnet for Azure Managed Lustre file system support](../configure-subnet.md).

## Configure network security group rules

To configure network security group rules for Azure Managed Lustre file system support, add the following inbound security rules to the NSG:

| Name | Port | Protocol | Source | Destination | Action |
| --- | --- | --- | --- | --- | --- |

Add the following outbound security rules to the NSG:

| Name | Port | Protocol | Source | Destination | Action |
| --- | --- | --- | --- | --- | --- |

The following example shows how to configure network security group rules for Azure Managed Lustre file system support in a zero-trust environment:

## Next steps
