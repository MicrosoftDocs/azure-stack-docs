---
title: Change languages in Azure Stack HCI
description: This topic provides guidance on how to change languages in the Azure Stack HCI operating system.
author: JohnCobb1
ms.author: v-johcob
ms.topic: how-to
ms.date: 06/24/2020
---

# Azure Stack HCI change languages

>Applies to: Azure Stack HCI, version 20H2; Windows Server 2019

This topic provides guidance on how to change languages in the Azure Stack HCI operating system.

## Change privacy settings on a single server

Here’s how to change the privacy settings on a server running either Windows Server or Azure Stack HCI. To manage privacy settings in your enterprise as a whole, see [Manage enterprise diagnostic data](#manage-enterprise-diagnostic-data).

If the server has the Full Desktop installation option, use the following steps:
1. Connect to the Server Manager Dashboard of the Windows Server.

    This could be locally via a keyboard and monitor, or using a remote management (headless or BMC) controller, or Remote Desktop. 

1. In Server Manage, under **Dashboard**, select **Local Server**.
1. On the **Properties** page of the server, next to **Feedback & Diagonstics**, select **Settings**.

    On the **Setting** page, the **Feedback frequency** and **Diagnotic and usage data** settings display. 
 
1. Expand the **Diagnotic and usage data** setting to select one of the following options:
    - **Required diagnostic data**
    - **Enhanced**
    - **Optional diagnostic data**

    >[!NOTE]
    > On the **Settings** page, if the notice **Some settings are managed by your organization** displays, then the **Diagnotic and usage data** setting may not be available.

If the server is running Azure Stack HCI and uses Server Core, use the following steps:
1. Log on to the server running Azure Stack HCI.

    This could be locally via a keyboard and monitor, or using a remote management (headless or BMC) controller, or Remote Desktop. The Server Configuration tool (Sconfig) opens automatically when you log on to the server.

1. On the **Welcome to Azure Stack HCI** screen, at the **Enter a number to select an option:** prompt, type **10** and press Enter.
1. On the **Change Telemetry** confirmation prompt, select **Yes** to display the following options:

    Available Telemetry settings: **1 Security**, **2 Basic**, **3 Enhanced**, **4 Full**

1. At the **Enter new telemetry setting:** prompt, type the option you want and press Enter.
