---
title: Add or remove servers from a cluster in Azure Stack HCI
description: Learn how to add or remove server nodes from a cluster in Azure Stack HCI 
ms.topic: article
ms.prod: 
author: v-dasis
ms.author: v-dasis
ms.reviewer: jgerend
ms.date: 03/04/2020
---

# Add or remove servers from a cluster in Azure Stack HCI

>Applies to: Windows Server 2019

Each new physical server that you add must be homogeneous in CPU type, memory, and disk number and size to the servers that are already present in the cluster.

## Add hardware from your OEM ##

1. Refer to your OEM-provided documentation.
1. Place the new physical server in the rack and cable it appropriately.
1. Enable physical switch ports and adjust access control lists (ACLs) if applicable.
1. Configure the correct IP address in the baseboard management controller (BMC) and apply all BIOS settings per your OEM instructions.
1. Apply the current firmware baseline to all components by using the tools that are provided by the hardware OEM.

## Perform cluster validation ##

You must perform cluster validation on the server before joining the server to your cluster.

1. Open **XYZ Tool**, and select **XYZ**.
2. ** PLACEHOLDER STEPS**
3. Verify that all validations steps were successful.

## Add the server to the cluster ##

You use Windows Admin Center to join the server to your cluster.

1. Open **Windows Admin Center**.
1. Select **Cluster Manager** from the top drop-down arrow.
1. Under **Cluster connections**, select the cluster.
1. Under **Tools**, select **Servers**.
1. Under **Servers**, select the **Inventory** tab.
1. On the **Inventory** tab, select **Add**.
1. In **Server name**, enter the full-qualified domain name of the server you want to add, click **Add**, then click **Add** again at the bottom.
1. **PLACEHOLDER STEP**

## Remove a server from the cluster ##

These steps are similar to those are adding a server to a cluster.

1. Open **Windows Admin Center**.
1. Select **Cluster Manager** from the top drop-down arrow.
1. Under **Cluster connections**, select the cluster.
1. Under **Tools**, select **Servers**.
1. Under **Servers**, select the **Inventory** tab.
1. On the **Inventory** tab, select the server you want to remove, then select **Remove**.
1. **PLACEHOLDER STEP**
1. Verify the server has been successfully removed from the cluster.

## Next Steps ##

To do xyz, see zyx for more information.