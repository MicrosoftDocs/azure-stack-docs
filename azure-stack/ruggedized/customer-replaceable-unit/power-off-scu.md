---
title: Power off Scale Unit nodes
description: Learn how to power off Scale Unit nodes
author: PatAltimore

ms.topic: how-to
ms.date: 11/13/2020
ms.author: patricka
ms.reviewer: 
ms.lastreviewed: 

# Intent: 
# Keyword: 

---

# Powering off Scale Unit nodes

Before a Scale Unit node can be powered off you must verify the Scale
Unit\'s health and identify the node that needs repairing.

If the node\'s **Power Status** is not **Stopped**, use the following
procedure below to safely shut down the node.

**Steps**

1.  Drain the Scale Unit node.

    1.  From the Administration Portal, select the node in need of
        repair and then select **Drain**.

        ![Screenshot that shows the 'Administration' page with the 'Drain' action selected and a node highlighted.](media/image-23.png)
        
    1.  When prompted, enter the name of the
        node to drain and select **Yes**.

        ![Screenshot that shows the 'Administration - Nodes' page.](media/image-24.png)
    
    1.  You will see a notification saying the drain is in progress.
    
        ![Screenshot that shows the 'Administration - Nodes' page with the drain notification displayed.](media/image-25.png)
        
    1.  Log in to the iDRAC interface and verify the node\'s service tag in the **System Information**.
    

2.  Shut down the Scale Unit node.

    1.  Once the drain is completed, select the node again, verify that
        the **Operational State** is **Maintenance** and select **Shutdown**.

        ![Screenshot that shows the 'Administration - Nodes' page with a node and the 'Shutdown' action selected.](media/image-26.png)
        
    1.  When prompted, select **Yes** to confirm the shutdown.
    
        ![Screenshot that shows the 'Administration - Nodes' page with the 'Shutdown node' dialog displayed.](media/image-27.png)
        
    1.  You will see a notification saying
        the shutdown is in progress.

        ![Screenshot that shows the 'Administration - Nodes' page with the shutdown in progress dialog displayed.](media/image-28.png)
    
    1.  When the shutdown is complete, the **Power Status** is **Stopped**.
    
        ![Screenshot that shows the 'Administration - Nodes' page with a node selected and 'Stopped' highlighted for the 'Power Status'.](media/image-29.png)
        