---
title: Power on and repair a Scale Unit node
description: Learn how to power on and repair a Scale Unit node
author: PatAltimore

ms.topic: how-to
ms.date: 11/13/2020
ms.author: patricka
ms.reviewer: 
ms.lastreviewed: 

# Intent: 
# Keyword: 

---

# Powering on and repairing a Scale Unit node

**Steps**

To repair and bring a Scale Unit node back into production you must
run the Azure Stack Hub repair procedure.

> [!NOTE]
> The repair procedure takes approximately three hours to
complete.

1.  In the **Administration Portal**, select the node and select **Repair**.

    ![](media/image-52.png)

1.  Provide the **BMC IP Address** that corresponds to the node you are repairing and select **Repair**.

    ![](media/image-53.png)

1.  Monitor the progress in the notification pane:

    ![](media/image-54.png)
    
    
    > [!NOTE]
    > If the repair procedure does not complete in three hours or
    an issue occurs, then open a case with Dell Technologies Support who
    may engage Microsoft Support for further troubleshooting.
    
    When the repair process is complete, the node returns to a **Running
    Operational Status**.
    
