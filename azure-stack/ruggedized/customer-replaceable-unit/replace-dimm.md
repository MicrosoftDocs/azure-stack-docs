---
title: Replace a DIMM
description: Learn how to replace a DIMM
author: sethmanheim

ms.topic: how-to
ms.date: 02/05/2021
ms.author: sethm
ms.reviewer: 
ms.lastreviewed: 

# Intent: 
# Keyword: 

---

# Replacing a DIMM

Use the following procedure to replace a DIMM.

## Prerequisites

1.  Review *Notes, cautions, and warnings* at the beginning of this
    guide

2.  Review Handling precautions.

3.  Review

    -   Required knowledge for working with scale unit nodes in a
        Ruggedized Cloud
        Appliance if you are working with a scale unit node

    -   Required knowledge for working with the Hardware Lifecycle
        Host if you are working with the Hardware Lifecycle Host

4.  Complete

    -   Verifying scale unit node access and health if you are working with a scale unit node

    -   Verifying Hardware Lifecycle Host access and
        health if you are working with the Hardware Lifecycle Host

5.  Complete

    -   Powering off scale unit nodes if you are working with a scale unit node

    -   Powering off the Hardware Lifecycle
        Host if
        you are working with the Hardware Lifecycle Host

## Steps

1.  Locate the physical node in the rack.

2.  Verify that the node is powered off. The power LED should be orange.

    > [!CAUTION]
    > Before disconnecting the cables on the server you are working on, ensure that each cable is properly labeled. The cables MUST be reconnected to the same ports.
    
3.  Replace the DIMM or DIMMs.

    Follow the [memory module replacement process](https://www.dell.com/support/manuals/en-us/poweredge-r640/per640_ism_pub/installing-a-memory-module?guid=guid-39b861b5-0677-4414-83db-cdf6882b3f6d&lang=en-us)
    for scale unit nodes or Hardware Lifecycle Hosts.
    
4.  Power on the node.

    After reconnecting the power, if the server does not automatically
    reboot, then press the power button to turn the node back on.
    
## Next steps

If you are working with a scale unit node:

1.  Complete Powering on a scale unit
    node.

2.  Complete Verifying scale unit node
    health. If you are
    working with the Hardware Lifecycle Host, complete Verifying Hardware Lifecycle Host health.
    
