---
title: Replace an operating system disk
description: Learn how to replace an operating system disk
author: myoungerman

ms.topic: how-to
ms.date: 11/13/2020
ms.author: v-myoung
ms.reviewer: 
ms.lastreviewed: 

# Intent: 
# Keyword: 

---

# Replacing an operating system disk

Use the following procedure to replace a failed operating system disk
in a Scale Unit node.

Prerequisites

1.  Review *Notes, cautions, and warnings* at the beginning of this guide

2.  Review [Handling precautions]

3.  Required knowledge for working with Scale Unit nodes in a Tactical
Cloud
Appliance if you are working with a Scale Unit node

4.  Complete Verifying Scale Unit node access and
health

5.  Complete Powering off Scale Unit
    nodes

    For the Azure Stack Hub Scale Unit nodes, the operating system runs
    from a mirrored pair of M.2 SSD modules residing on the Dell PowerEdge
    Boot Optimized Storage Solution (BOSS) card. The system must be
    powered off to replace an operating system disk.
    
**Steps**

1.  Locate the physical node in the rack.

2.  Verify that the node is powered off. The power LED should be orange.

    > [!CAUTION]
    > Before disconnecting the cables on the server you are working on, ensure that each cable is properly labeled. The cables MUST be reconnected to the same ports.
    
3.  Replace the failed M.2 SSD module.

    Follow the M.2 SSD module replacement process in the [Dell EMC
    PowerEdge R640 Installation and Service
    Manual](https://www.dell.com/support/manuals/us/en/04/poweredge-r640/per640_ism_pub/dell-emc-poweredge-r640-overview?guid=guid-f39be9ba-158c-45e3-b8b1-f07bb750d6d4)
    for Scale Unit nodes.
    
4.  Power on the node.

    After reconnecting the power, if the server does not automatically
    reboot, then press the power button to turn the node back on.
    
## Next steps

1.  Complete Powering on and repairing a Scale Unit node.

2.  Complete Verifying Scale Unit node health.

