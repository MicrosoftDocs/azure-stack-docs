---
title: Replace an operating system disk
description: Learn how to replace an operating system disk
author: sethmanheim

ms.topic: how-to
ms.date: 02/05/2021
ms.author: sethm
ms.reviewer: 
ms.lastreviewed: 

# Intent: 
# Keyword: 

---

# Replacing an operating system disk

Use the following procedure to replace a failed operating system disk
in a scale unit node.

## Prerequisites

1.  Review *Notes, cautions, and warnings* at the beginning of this guide.

2.  Review Handling precautions.

3.  Required knowledge for working with scale unit nodes in Azure Stack Hub ruggedized if you are working with a scale unit node.

4.  Complete Verifying scale unit node access and
health.

5.  Complete Powering off scale unit
    nodes.

    For the Azure Stack Hub scale unit nodes, the operating system runs from a mirrored pair of M.2 SSD modules residing on the Boot Optimized Storage Solution (BOSS) card. The system must be powered off to replace an operating system disk.
    
## Steps

1.  Locate the physical node in the rack.

2.  Verify that the node is powered off. The power LED should be orange.

    > [!CAUTION]
    > Before disconnecting the cables on the server you are working on, ensure that each cable is properly labeled. The cables MUST be reconnected to the same ports.
    
3.  Replace the failed M.2 SSD module.

    Follow the [M.2 SSD module replacement process](https://www.dell.com/support/manuals/en-us/poweredge-r640/per640_ism_pub/installing-the-m.2-ssd-module?guid=guid-038529e9-709b-4d16-91a2-26f69beb6f40&lang=en-us)
    for scale unit nodes.
    
4.  Power on the node.

    After reconnecting the power, if the server does not automatically
    reboot, then press the power button to turn the node back on.
    
## Next steps

1.  Complete Powering on and repairing a scale unit node.

2.  Complete Verifying scale unit node health.

