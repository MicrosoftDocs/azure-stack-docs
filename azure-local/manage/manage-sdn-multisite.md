---
title: Manage SDN Multisite for Azure Local and Windows Server
description: Learn how to manage a multisite SDN solution for Azure Local and Windows Server.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.subservice: 
zone_pivot_groups: windows-os
ms.date: 06/03/2025
---

# Manage SDN Multisite for Azure Local and Windows Server

:::zone pivot="azure-local"

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes how to deploy and manage the Software Defined Networking (SDN) Multisite solution for Azure Local using Windows Admin Center.

::: zone-end

:::zone pivot="windows-server"

>Applies to: Windows Server 2025

This article describes how to deploy and manage the Software Defined Networking (SDN) Multisite solution for Windows Server using Windows Admin Center.

::: zone-end

:::zone pivot="azure-local"

For an overview of SDN Multisite, it's current capabilities and limitations, see [Overview of SDN Multisite](../concepts/sdn-multisite-overview.md?pivot=azure-stack-hci).

::: zone-end

:::zone pivot="windows-server"

For an overview of SDN Multisite, it's current capabilities and limitations, see [Overview of SDN Multisite](../concepts/sdn-multisite-overview.md?pivots=windows-server&context=/windows-server/context/windows-server-edge-networking).

::: zone-end

## Prerequisites

Before you can enable SDN Multisite, ensure the following prerequisites are met:

:::zone pivot="azure-local"

- You must have access to Azure Local clusters deployed at two separate physical sites.

- There must be an underlying [physical network connectivity](../concepts/plan-software-defined-networking-infrastructure.md#physical-and-logical-network-configuration) between the sites. Additionally, the provider network name must be the same on both sites.

- SDN must be installed on both sites separately, using [Windows Admin Center](../deploy/sdn-wizard.md) or [SDN Express scripts](./sdn-express.md). Separate sites are required so that the SDN components, such as Network Controller VMs, Software Load Balancer Multiplexor VMs, and SDN Gateway VMs are unique to each site.

::: zone-end

:::zone pivot="windows-server"

- You must have access to Windows Server 2025 or later clusters deployed at two separate physical sites.

- There must be an underlying [physical network connectivity](../concepts/plan-software-defined-networking-infrastructure.md?pivots=windows-server&context=/windows-server/context/windows-server-edge-networking#physical-and-logical-network-configuration) between the sites. Additionally, the provider network name must be the same on both sites.

- SDN must be installed on both sites separately, using [Windows Admin Center](../deploy/sdn-wizard.md?pivots=windows-server&context=/windows-server/context/windows-server-edge-networking) or [SDN Express scripts](./sdn-express.md?pivots=windows-server&context=/windows-server/context/windows-server-edge-networking). Separate sites are required so that the SDN components, such as Network Controller VMs, Software Load Balancer Multiplexor VMs, and SDN Gateway VMs are unique to each site.

::: zone-end

- Your firewall configuration must permit TCP port 49001 for cross-cluster communication.

- You must have Windows Admin Center version 2311 or later installed on your management PC or server. See [Install Windows Admin Center](/windows-server/manage/windows-admin-center/deploy/install).

- One of the two sites must not have virtual networks, NSGs, and user defined routes configured.

- The SDN MAC pool must not overlap between the two sites.

- The IP pools for the logical networks, including Hyper-V Network Virtualization Provider Address (HNV PA), Public VIP, Private VIP, Generic Routing Encapsulation (GRE) VIP, and L3 must not overlap between the two sites.

## Enable SDN Multisite

Here's a high-level workflow for enabling SDN Multisite:

- Meet prerequisites. See [Prerequisites](#prerequisites).
- Establish peering. See [Establish peering](#establish-peering).
- Check peering status. See [Check peering status](#check-peering-status).

### Establish peering

Follow these steps to establish peering across multiple sites using Windows Admin Center:

1. In Windows Admin Center, connect to your cluster in the primary site to begin peering across sites. Under **Tools**, scroll down to the **Networking** section, and select **Network controllers**.

1. On the **Network Controllers** page, select **New** to add a secondary site.

1. In the **Connect clusters** pane, provide the necessary connection information:

    1. Enter the **Name** of the secondary site. For example, **Secondary site**.

    1. Enter the **Network Controller REST Uri** of the secondary site.

    1. Enter the **Cluster name for new site** or secondary site.

    1. Enter the **Network Controller VM name for new site** or secondary site. The name can be any Network Controller VM name of the secondary site.

    1. Enter the **Network Controller VM name for** your primary location. The name can be any Network Controller VM name of your primary location.

1. Select **Submit**.

    :::image type="content" source="./media/manage-sdn-multisite/deploy-sdn-multisite.png" alt-text="Deploy SDN Multisite using Windows Admin Center" lightbox="./media/manage-sdn-multisite/deploy-sdn-multisite.png" :::

    Once peering is initiated, resources such as virtual networks or policy configurations that were once local to the primary site become global resources synced across sites.

### Check peering status

After you enable SDN Multisite, review the current configuration to determine which site is designated as the primary and which one as the secondary.

Follow these steps to review SDN Multisite peering status:

1. In Windows Admin Center, connect to your cluster in any site. Under **Tools**, scroll down to the **Networking** section, and select **Network controllers**.

1. On the **Network Controllers** page, under the **Inventory** tab, review the status of the following two columns:

    - **State**: This column can have one of the following values:
        - `Local` indicates the site through which you're accessing SDN Multisite.
        - `Initiated`, `Connected`, or `Failed` indicates the status of peering.
    - **Primary**: This column can have one of the following values:
        - `Yes` indicates the site is a primary site.
        - `No` indicates the site is a secondary site.

        :::image type="content" source="./media/manage-sdn-multisite/check-peering-status.png" alt-text="Screenshot that shows current peering status." lightbox="./media/manage-sdn-multisite/check-peering-status.png" :::

## Manage SDN Multisite

This section describes the tasks that you can perform to manage your SDN Multisite solution using Windows Admin Center.

### Change primary site

You can have only one primary site at a time. If your scenario requires more than one primary site, reach out to [sdn_feedback@microsoft.com](mailto:sdn_feedback@microsoft.com).

In certain scenarios, you might need to change your primary site. For example, if your primary site goes down and becomes unreachable, but there are global policies and resources to be changed and synced. In such cases, you can change the primary site to help prevent data loss and ensure continuity of information. However, if there are pending changes in your old primary site, there's a potential risk of data loss when transitioning to the new primary sites.

Follow these steps to change the primary site:

1. Make sure SDN Multisite is enabled. See [Check peering status](#check-peering-status).

1. Connect to your cluster in any site. Under **Tools**, scroll down to the **Networking** section, and select **Network controllers**.

1. On the **Network Controllers** page, under the **Inventory** tab, select the row for the secondary site that you want to convert into primary.

1. Select **Make Primary** to change the secondary site into primary.

    :::image type="content" source="./media/manage-sdn-multisite/convert-to-primary.png" alt-text="Screenshot that shows the Make Primary button used for converting a secondary site into primary." lightbox="./media/manage-sdn-multisite/convert-to-primary.png" :::

### Rename sites

There might be scenarios where you need to rename your sites for improved relevance or to conform with the naming convention followed in your organization.

To rename sites, follow these steps:

1. Make sure SDN Multisite is enabled. See [Check peering status](#check-peering-status).

1. Connect to your cluster in any site. Under **Tools**, scroll down to the **Networking** section, and select **Network controllers**.

1. On the **Network Controllers** page, under the **Inventory** tab, select the site to rename.

1. Select **Rename** to change the site name.

    :::image type="content" source="./media/manage-sdn-multisite/rename-sites.png" alt-text="Screenshot that shows the Rename button used for renaming a site." lightbox="./media/manage-sdn-multisite/rename-sites.png" :::

## Remove SDN Multisite

In some cases, you might need to remove peering to stop resource synchronization across sites. For example, to isolate resources due to a security concern or due to a change in the infrastructure strategy of your organization.

When you remove peering, resource synchronization is aborted, and each site keeps its own copy of resources. For example, you have a virtual network with two VMs, one on each site. When peering is removed, each site still has the same virtual network resource and the local site VM still functions with the same network settings. But it can't communicate with the VM on the remote site.

To remove peering, follow these steps:

1. In Windows Admin Center, connect to your cluster in any site. Under **Tools**, scroll down to the **Networking** section, and select **Network controllers**.

1. On the **Network Controllers** page, select **Delete**.

1. On the confirmation window, select **Yes**.

   After remove peering, it takes a moment for your sites to update. If it doesn't update, refresh your browser.

### Re-establish peering after SDN Multisite removal

If you intend to re-establish your multisite connection after its removal, your secondary site will need to be set up as a new SDN environment. This means there can't be any pre-existing virtual networks or network security groups. However, your secondary location has a local cache of the once global resources from SDN Multisite. Even when you remove SDN Multisite, your secondary location still has a copy of those resources. Without SDN Multisite, those resources are now out of sync.

For redeployment after SDN Multisite removal, ensure the following are removed:

:::zone pivot="azure-local"

- Virtual networks. See [Delete a virtual network](./tenant-virtual-networks.md#delete-a-virtual-network)
- Network Security Groups. See [Delete a network security group](./use-datacenter-firewall-windows-admin-center.md#delete-a-network-security-group)

::: zone-end

:::zone pivot="windows-server"

- Virtual networks. See [Delete a virtual network](./tenant-virtual-networks.md?pivots=windows-server&context=/windows-server/context/windows-server-edge-networking#delete-a-virtual-network)
- Network Security Groups. See [Delete a network security group](./use-datacenter-firewall-windows-admin-center.md?pivots=windows-server&context=/windows-server/context/windows-server-edge-networking#delete-a-network-security-group)

::: zone-end

## Next steps

- [Read the blog about SDN Multisite](https://techcommunity.microsoft.com/t5/azure-stack-blog/software-defined-networking-multisite-a-tale-of-2-sdn-sites/ba-p/3990521)

:::zone pivot="azure-local"

- [Software Defined Networking (SDN) in Azure Local and Windows Server](../concepts/software-defined-networking.md)

::: zone-end

:::zone pivot="windows-server"

- [Software Defined Networking (SDN) in Azure Local and Windows Server](../concepts/software-defined-networking.md?pivots=windows-server&context=/windows-server/context/windows-server-edge-networking)

::: zone-end
