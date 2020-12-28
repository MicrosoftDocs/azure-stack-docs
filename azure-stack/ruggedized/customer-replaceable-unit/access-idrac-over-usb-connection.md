---
title: Access iDRAC over USB connection
description: Learn how to access iDRAC over USB connection
author: myoungerman

ms.topic: how-to
ms.date: 11/13/2020
ms.author: v-myoung
ms.reviewer: 
ms.lastreviewed: 

# Intent: 
# Keyword: 

---

# Accessing the iDRAC interface over a direct USB connection

The iDRAC direct feature allows you to directly connect your laptop to
the iDRAC USB port. This feature allows you to interact directly with
the iDRAC interfaces such as the web interface, RACADM, and WSMan for
advanced server management and servicing.



To access the iDRAC interface over the USB port, do the following from
your laptop.

**Steps**

1.  From your laptop, turn off any wireless networks and disconnect from
    any other hard-wired networks.

2.  Connect a micro USB cable from your
    laptop to the iDRAC Direct port, located on the front of the server.
    Refer to item 4 in the diagram.

    ![Diagram that shows a power button, U S B, and micro U S B ports.](media/image-67.png)

3.  Wait for the laptop to acquire the IP address 169.254.0.4.

    It may take several seconds for the IP addresses to be acquired. The
    iDRAC acquires the IP address 169.254.0.3.

4.  Connect to the iDRAC web interface.

    To access the iDRAC web interface, open a browser, and go to
    169.254.0.3.

5.  Complete the required activities.

    

    > [!NOTE]
    > When the iDRAC is
    using the USB port, which is item 3 in the diagram above, the LED
    blinks indicating activity. The blink frequency is four per second.
    
6.  Disconnect the micro USB cable.

    After completing the desired actions, disconnect the USB cable from
    the system. The LED turns off.
    
