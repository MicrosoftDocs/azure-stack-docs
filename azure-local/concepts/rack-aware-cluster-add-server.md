---
title: Add or repair a node to a rack aware cluster on Azure Local (Preview)
description: Learn how to add or repair a node to a rack aware cluster on Azure Local (Preview).
author: alkohli
ms.topic: how-to
ms.date: 10/20/2025
ms.author: alkohli
---

# Add or repair a node to a rack aware cluster (Preview)

> Applies to: Azure Local version 2510 and later

This article explains how to add or repair servers (nodes) for your Azure Local rack aware cluster.

[!INCLUDE [important](../includes/hci-preview.md)]

## Add a server

For more information on adding a server, see [Add a node on Azure Local](../manage/add-server.md).

### Limitations

This is only supported for 2+2 to 3+3, and 3+3 to 4+4 rack aware cluster. You can't add nodes to a 1+1 rack aware cluster. For a rack aware cluster, you must add two nodes at a time by using the `Add-Server` command:

```azurecli
Add-Server -Name <String Array> -HostIpv4 <String Array> -LocalAvailabilityZone <String Array> -LocalAdminCredential <Credential>
```

### Parameters

The following parameters can be used with the `Add-Server` command:

**Name**: String array with names of two nodes.  

**HostIpv4**: String array with two IPv4 addresses for the two nodes. Ensure that the IPv4 addresses are listed in the same respective order as the two nodes for the `Name` parameter.

**LocalAvailabilityZone**: String array of local availability zones in the respective order of the nodes being added. You need to ensure the nodes are added to the correct zone.  

For example, if you are adding nodes ["Node1", "Node2"] and Node1 is in ZoneA, and Node2 is in ZoneB, then the value should be ["ZoneA", "ZoneB"].

**LocalAdminCredential**: Local administrator user credentials for the nodes. Use the same credential for both nodes.

To validate that the nodes were added successfully, run the `Get-ClusterFaultDomain` command. You should see the two nodes are listed and added to the correct zone.

```output
[<IP address>]: PS C:\> Get-ClusterFaultDomain

Name                    Type      ParentName            ChildrenNames   Location
----                    ----      ----------            -------------   --------
Site <IP address>/24	Site                            {Zone1, Zone2}
Zone1	                Rack	  Site <IP address>/24	{ASRRR15, ASRRR16, ASRRR17, ASRRR18}	
Zone2	                Rack	  Site <IP address>/24	{ASRRR25, ASRRR26, ASRRR27, ASRRR28}
ASRRR15       	        Node	  Zone1
ASRRR16	                Node	  Zone1
ASRRR17	                Node	  Zone1
ASRRR18	                Node	  Zone1
ASRRR25	                Node	  Zone2
ASRRR26	                Node	  Zone2
ASRRR27	                Node	  Zone2
ASRRR28	                Node	  Zone2
```
You can also see the zone and node information in the Azure portal by going to your Azure Local resource page and under **Infrastructure** selecting **Machines**:

:::image type="content" source="media/rack-aware-cluster-add-server/add-server-portal.png" alt-text="Screenshot in Azure portal showing server added." lightbox="media/rack-aware-cluster-add-server/add-server-portal.png":::

## Repair a server

You can repair nodes in your Azure Local rack aware cluster. You may need to repair a node in your system if there is a hardware failure. For more information, see [Repair a node on Azure Local](../manage/repair-server.md).