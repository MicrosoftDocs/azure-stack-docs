---
author: ronmiab
ms.author: robess
ms.service: azure-local
ms.topic: include
ms.date: 09/01/2026
---

## Register Azure Local by using the Configurator app

Use the Configurator app to configure machine settings and register Azure Local with Azure Arc.

### Sign in to the Configurator app

1. On the client machine, launch the Configurator app.

1. On the **Machine name** page, enter the machine name, serial number, hostname, or IP address of the Azure Local machine, and then select **Next**.

   :::image type="content" source="./media/application-arc-gateway-start/app-machine-name.png" alt-text="Screenshot of the machine selection page in the Configurator app." lightbox="./media/application-arc-gateway-start/app-machine-name.png":::

1. Enter the local administrator password, and then select **Sign in**.

   :::image type="content" source="./media/application-arc-gateway-start/app-sign-in.png" alt-text="Screenshot of the sign-in page in the Configurator app." lightbox="./media/application-arc-gateway-start/app-sign-in.png":::

1. After authentication, review the configuration status and prerequisite validation results.

   :::image type="content" source="./media/application-arc-gateway-start/app-arc-agent-home.png" alt-text="Screenshot of the Arc agent setup page showing machine readiness and status information." lightbox="./media/application-arc-gateway-start/app-arc-agent-home.png":::

### Configure machine settings

1. On the **Basics** page, review the following machine configuration:

   - Network settings
   - DNS configuration
   - Remote Desktop settings
   - Connectivity method
   - Time zone
   - Time server
   - Hostname

   :::image type="content" source="./media/application-arc-gateway-start/app-basics-overview.png" alt-text="Screenshot of the Basics page showing network, DNS, and other machine settings." lightbox="./media/application-arc-gateway-start/app-basics-overview.png":::

1. To modify network settings, select **Edit network settings**. Provide the interface name, IP allocation method, IP address, subnet, gateway, and preferred DNS server. Optionally, enter an alternate DNS server.

   :::image type="content" source="./media/application-arc-gateway-start/app-network-settings.png" alt-text="Screenshot of network settings in the Configurator app." lightbox="./media/application-arc-gateway-start/app-network-settings.png":::

   > [!IMPORTANT]
   > Ensure that the IP addresses you assign are available and not in use.

1. To modify Remote Desktop, connectivity, time server, or hostname settings, select **Edit settings**.

   :::image type="content" source="./media/application-arc-gateway-public-settings/app-additional-settings.png" alt-text="Screenshot of additional machine settings in the Configurator app." lightbox="./media/application-arc-gateway-public-settings/app-additional-settings.png":::
