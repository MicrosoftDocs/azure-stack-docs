---
title: Add or repair a server to a Rack Aware Cluster on Azure Local (Preview)
description: Learn how to add or repair a server to a Rack Aware Cluster on Azure Local (Preview).
author: alkohli
ms.topic: how-to
ms.date: 10/09/2025
ms.author: alkohli
---

# Add or repair a server to a Rack Aware Cluster (Preview)

Applies to: Azure Local version 2510 and later

This article explains how to add or repair servers (nodes) for your Azure Local Rack Aware Cluster.


[!INCLUDE [important](../includes/hci-preview.md)]

## Add a server

For more information on adding a server, see [Add a node on Azure Local](../manage/add-server.md).

### Limitations

This is only supported for 2+2 to 3+3, and 3+3 to 4+4 Rack Aware Cluster. You can't add nodes to a 1+1 Rack Aware Cluster. For a Rack Aware Cluster, you must add two nodes at a time by using the `Add-Server` command:

```azurecli
Add-Server -Name <String Array> -HostIpv4 <String Array> -LocalAvailabilityZone <String Array> -LocalAdminCredential <Credential>
```

### Parameters

The following parameters can be used with the `Add-server` command:

**Name**: String array with names of two nodes.  

**HostIpv4**: String array with two IPv4 addresses for the two nodes. Ensure that the IPv4 addresses are listed in the same respective order as the two nodes for the `Name` parameter.

**LocalAvailabilityZone**: String array of local availability zones in the respective order of the nodes being added. You need to ensure the nodes are added to the correct zone.  

If you are adding nodes ["Node1", "Node2"] and Node1 is in ZoneA, and Node2 is in ZoneB, then the value should be ["ZoneA", "ZoneB"].

**LocalAdminCredential**: Local administrator user credentials for the nodes. Use the same credential for both nodes.

To validate that the nodes were added successfully, run the `Get-ClusterFaultDomain` command. You should see the two nodes are listed and added to the correct zone.

:::image type="content" source="media/rack-aware-cluster-add-server/add-server-output.png" alt-text="Screenshot of output showing server added." lightbox="media/rack-aware-cluster-add-server/add-server-output.png":::

You can also see the zone and node information in the Azure portal:

:::image type="content" source="media/rack-aware-cluster-add-server/add-server-portal.png" alt-text="Screenshot in Azure portal showing server added." lightbox="media/rack-aware-cluster-add-server/add-server-portal.png":::

## Repair a server

You can repair nodes in your Azure Local Rack Aware Cluster. You may need to repair a node in your system if there is a hardware failure. For more information, see [Repair a node on Azure Local](../manage/repair-server.md).


