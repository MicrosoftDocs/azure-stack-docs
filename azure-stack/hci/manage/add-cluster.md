---
title: Add or remove servers for an Azure Stack HCI cluster
description: Learn how to add or remove server nodes from a cluster in Azure Stack HCI
ms.topic: how-to
author: v-dasis
ms.author: v-dasis
ms.reviewer: jgerend
ms.date: 07/21/2020
---

# Add or remove servers for an Azure Stack HCI cluster

> Applies to: Azure Stack HCI, version 20H2; Windows Server 2019

You can easily add or remove servers from a cluster in Azure Stack HCI. Keep in mind that each new physical server must closely match the rest of the servers in the cluster when it comes to CPU type, memory, number of drives, and the type and size of the drives.

Whenever you add or remove a server, you must also perform cluster validation afterwards to ensure the cluster is functioning normally.

## Obtain OEM hardware

The first step is to acquire new HCI hardware from your original OEM. Always refer to your OEM-provided documentation when adding new server hardware for use in your cluster.

1. Place the new physical server in the rack and cable it appropriately.
1. Enable physical switch ports and adjust access control lists (ACLs) and VLAN IDs if applicable.
1. Configure the correct IP address in the baseboard management controller (BMC) and apply all BIOS settings per OEM instructions.
1. Apply the current firmware baseline to all components by using the tools that are provided by your OEM.
1. Run OEM validation tests to ensure homogeneity with the existing cluster servers.

## Add a server to the cluster

Once your server has spun up correctly, use Windows Admin Center to join the server to your cluster.

:::image type="content" source="media/manage-cluster/add-server.png" alt-text="Add server screen" lightbox="media/manage-cluster/add-server.png":::

1. In **Windows Admin Center**, select **Cluster Manager** from the top drop-down arrow.
1. Under **Cluster connections**, select the cluster.
1. Under **Tools**, select **Servers**.
1. Under **Servers**, select the **Inventory** tab.
1. On the **Inventory** tab, select **Add**.
1. In **Server name**, enter the full-qualified domain name of the server you want to add, click **Add**, then click **Add** again at the bottom.
1. Verify the server has been successfully added to your cluster.

## Remove a server from the cluster

The steps for removing a server from your cluster are similar to those for adding a server to a cluster.

Keep in mind that when you remove a server, you will also remove any virtual machines, drives, and workloads associated with the server.

:::image type="content" source="media/manage-cluster/remove-server.png" alt-text="Remove server dialog" lightbox="media/manage-cluster/remove-server.png":::

1. In **Windows Admin Center**, select **Cluster Manager** from the top drop-down arrow.
1. Under **Cluster connections**, select the cluster.
1. Under **Tools**, select **Servers**.
1. Under **Servers**, select the **Inventory** tab.
1. On the **Inventory** tab, select the server you want to remove, then select **Remove**.
1. To also remove any server drives from the storage pool, enable that checkbox.
1. Verify the server has been successfully removed from the cluster.

Anytime you add or remove a server node from a cluster, be sure and run a cluster validation test afterwards.

## Next steps

- You should validate the cluster after adding or removing node. See [Validate the cluster](../deploy/validate.md) for more information.