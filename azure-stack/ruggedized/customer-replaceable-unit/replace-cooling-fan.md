---
title: Replace a cooling fan
description: Learn how to replace a cooling fan
author: PatAltimore

ms.topic: how-to
ms.date: 02/05/2021
ms.author: patricka
ms.reviewer: 
ms.lastreviewed: 

# Intent: 
# Keyword: 

---

# Replacing a cooling fan

Use the following procedure to replace a cooling fan or fans.

## Prerequisites

1.  Review *Notes, cautions, and warnings* at the beginning of this
    guide

2.  Review Handling precautions.

3.  Review

    -   Required knowledge for working with Scale Unit nodes in a Ruggedized Cloud Appliance

    -   Required knowledge for working with the Hardware Lifecycle Host on page 5 if you are working with the Hardware Lifecycle Host

4.  Complete

    -   Verifying Scale Unit node access and health if you are working with a Scale Unit node

    -   Verifying Hardware Lifecycle Host access and
        health if you are working with the Hardware Lifecycle Host

5.  Complete

    -   Powering off Scale Unit nodes if you are working with a Scale Unit node

    -   Powering off the Hardware Lifecycle
        Host if
        you are working with the Hardware Lifecycle Host

## Steps

1.  Locate the physical node in the rack.

2.  Verify that the node is powered off. The power LED should be orange.

    > [!CAUTION]
    > Before disconnecting the cables on the server you are working on, ensure that each cable is properly labeled. The cables MUST be reconnected to the same ports.
    
3.  Replace the fan or fans.

    Follow the [fan replacement process](https://www.dell.com/support/manuals/us/en/04/poweredge-r640/per640_ism_pub/dell-emc-poweredge-r640-overview?guid=guid-f39be9ba-158c-45e3-b8b1-f07bb750d6d4)
    for Scale Unit nodes or Hardware Lifecycle Hosts.
    
4.  Power on the node.

    After reconnecting the power, if the server does not automatically
    reboot, then press the power button to turn the node back on.
    
## Next steps

If you are working with a Scale Unit node:

1.  Complete Powering on a Scale Unit
    node

2.  Complete Verifying Scale Unit node
    health. If you are
    working with the Hardware Lifecycle Host:

    -   Complete Verifying Hardware Lifecycle Host health
    
