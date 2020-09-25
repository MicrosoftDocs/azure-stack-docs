---
title: Change privacy settings
description: This topic provides guidance on how to change privacy settings in Windows Server and the Azure Stack HCI operating system.
author: JohnCobb1
ms.author: v-johcob
ms.topic: how-to
ms.date: 09/25/2020
---

# Change privacy settings on individual servers

>Applies to: Azure Stack HCI, version 20H2; Windows Server 2019, Windows Server 2016

Here’s how to change the privacy settings on a server running either Windows Server or Azure Stack HCI. To manage privacy settings with Group Policy on multiple servers at once or in your enterprise as a whole, see [Manage enterprise diagnostic data](/windows/privacy/configure-windows-diagnostic-data-in-your-organization#manage-enterprise-diagnostic-data).

## Change privacy settings on a server with the Full Desktop installation option
If the server is running Windows Server and has the Full Desktop installation option, use the following steps:
1. Connect to the Server Manager Dashboard of the Windows Server.

    You can connect locally by using a keyboard and monitor, or using a remote management (headless or BMC) controller, or Remote Desktop. 

1. In Server Manage under **Dashboard**, select **Local Server**.
1. On the **Properties** page of the server, next to **Feedback & Diagnostics**, select **Settings**.

    On the **Setting** page, the **Feedback frequency** and **Diagnostic and usage data** settings display. 
 
1. Expand the **Diagnostic and usage data** setting to select one of the following options:
    - **Required diagnostic data**
    - **Enhanced**
    - **Optional diagnostic data**

    >[!NOTE]
    > On the **Settings** page, if the notice **Some settings are managed by your organization** displays, then the **Diagnotic and usage data** setting may not be available.

## Change privacy settings on a server using Azure Stack HCI or Server Core
If the server uses the Azure Stack HCI operating system or Windows Server with the Server Core installation option, use the following steps:
1. Connect to a server in the Azure Stack HCI cluster by using Remote Desktop, a remote management (headless or BMC) controller, with a KVM, or by signing on locally by using a keyboard and monitor. 
1. If you connect to a server running Azure Stack HCI, the Server Configuration tool (Sconfig) opens automatically. If you connect to a server running Windows Server with Server Core, at the command prompt, enter `Sconfig`.
1. At the **Enter a number to select an option:** prompt, type **10** and press Enter.
1. On the **Change Telemetry** confirmation prompt, select **Yes** to display the following options:

    Available Telemetry settings: **1 Security**, **2 Basic**, **3 Enhanced**, **4 Full**

    >[!NOTE]
    > The default setting for Azure Stack HCI is **1 Security**.

1. At the **Enter new telemetry setting:** prompt, type the option you want and press Enter.

## Next steps

For related information, see also:
- [Add or remove servers](../manage/add-cluster.md)
