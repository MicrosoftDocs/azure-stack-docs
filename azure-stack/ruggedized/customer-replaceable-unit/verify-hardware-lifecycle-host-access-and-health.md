---
title: Verify Hardware Lifecycle Host access and health
description: Learn how to verify Hardware Lifecycle Host access and health
author: PatAltimore

ms.topic: how-to
ms.date: 11/13/2020
ms.author: patricka
ms.reviewer: 
ms.lastreviewed: 

# Intent: 
# Keyword: 

---

# Verifying Hardware Lifecycle Host access and health

Log in to the iDRAC and the Hardware Lifecycle Host (HLH) OS and
verify the system health.

1.  Connect to the iDRAC.

    1.  Using a web browser, navigate to the iDRAC web interface and log in using the credentials provided by the customer.

        ![Screenshot that shows the iDRAC login page.](media/image-3.png) 
    
    1.  From the top navigation menu, select **System**.

        ![Screenshot that shows the Dashboard with the 'System' menu highlighted.](media/image-4.png)
        
    1.  From the **Overview** tab, verify the system is
        completely healthy or shows the issue expected that should be
        remediate during this hardware replacement.
    
        ![Screenshot that shows the 'System' page with the overview tiles highlighted.](media/image-5.png)
    
2.  Connect to the HLH OS using the iDRAC virtual console.

    > [!NOTE]
    > You can skip this step if you log in using a crash cart with
    VGA and USB connections.
    
    1.  In the iDRAC web interface, select
        **Dashboard**.

        ![Screenshot that shows the 'Dashboard' button selected.](media/image-6.png)
    
    1.  In the **Virtual Console** pane, select **Settings**.
    
        ![Screenshot that shows the 'Settings' button selected.](media/image-7.png)
        
    1.  Check the **Plug-in Type** is set to **HTML 5**. If it is not,
        change this, select **Apply**, and then **OK** when prompted.
    
        ![Screenshot that shows the 'Configuration' page with 'Plug-in Type - HTML5' and the 'Apply' button selected.](media/image-8.png)
        
    1.  Select **Launch Virtual Console**.

        ![Screenshot that shows the 'Configuration' page with the 'Launch Virtual Console' option highlighted.](media/image-9.png)
    
    1.  If a pop-up warning is displayed, change the browser settings to
        always allow. For example, in Internet Explorer, select **Options for
        this site** and select **Always allow**. If required, after changing
        the browser setting, repeat the previous step to launch the virtual
        console.
    
        ![Screenshot that shows the 'Warning' pop-up displayed.](media/image-10.png)
        
    1.  The virtual console should now be present. To log in to the
        operating system, from the top hand menu, select **Console
        Controls**.
    
        ![Screenshot that shows the virtual console with the 'Console Controls' button selected.](media/image-11.png)
        
    1.  Select the **Keyboard Macro**, **Ctrl+Alt-Del** and select **Apply**
        and then **Close**.
    
        ![Screenshot that shows the 'Console Controls' screen with 'Keyboard Macros' and the 'Close' button selected.](media/image-12.png)
        
    1.  Select the **user** based on the credentials provided by the
        customer, enter the password and select the **arrow** to log in.
    
        ![Screenshot that shows user credentials being entered.](media/image-13.png)
        
        You are now logged in to the HLH.
        
3.  Verify health.

    1.  Launch **Server Manager**.

        ![Screenshot that shows 'Server Manager' selected.](media/image-14.png)
        
    1.  Select **Yes** to the **User Account Control** prompt.
    
        ![Screenshot that shows the 'User Account Control' prompt with the 'Yes' button selected.](media/image-15.png)
        
    1.  From the **Tools** menu, select **Hyper-V Manager**.
    
        ![Screenshot that shows the 'Tools' menu open and 'Hyper-V Manager' selected.](media/image-16.png)
        
    1.  In **Hyper-V Manager**, select the top node in the left menu and then
        verify that VMs such as the **Privileged Access Workstation**, if
        applicable, are in a **Running** state.