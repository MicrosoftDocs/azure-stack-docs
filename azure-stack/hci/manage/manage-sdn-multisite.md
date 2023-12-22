---
title: Manage SDN Multisite in Azure Stack HCI (preview)
description: Learn how to manage a multisite SDN solution in Azure Stack HCI (preview)
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.date: 12/22/2023
---

# Manage SDN Multisite in Azure Stack HCI

> Applies to: Azure Stach HCI, version 23H2 (preview)

This article describes how to deploy and manage the Software Defined Networking (SDN) Multisite solution in Azure Stack HCI.

[!INCLUDE [important](../../includes/hci-preview.md)]

## About SDN Multisite

SDN Multisite allows you to expand the capabilities of traditional SDN on Azure Stack HCI clusters stretched across distinct sites. With SDN Multisite, you can have native Layer 2 and Layer 3 connectivity across multiple physical locations or sites for virtualized workloads.

When you enable SDN Multisite, one site is designated as the primary site and the remaining sites become secondary. The primary site is responsible for resource synchronization. If the primary site is unreachable, resources can't be updated through the secondary site. Conversely, if the secondary site is unreachable, resources can be updated through the primary site. During multisite peering, the primary site is automatically selected, but you have the option to change it later through Windows Admin Center.

## Benefits

Here are the benefits of using SDN Multisite:

- **Unified policy management system.** Manage and configure your networks across multiple sites from a single primary site, with shared virtual networks and policy configurations.
- **Seamless workload migration.** Seamlessly migrate workloads across phyical sites without having to reconfigure IP addresses or pre-existing Network Security Groups (NSGs).
- **Automatic reachability to new VMs.** Get automatic reachability to newly created virtual machines (VMs) and automatic manageability to any of their associated NSGs across your physical locations.

## Limitations

The SDN Multisite feature currently has a few limitations:

- Supported only between two sites.
- Sites must be connected over a private network, as encryption support for sites connected over the internet is not provided.
- Internal load balancing isn't supported.

## Prerequisites

Before you can enable SDN Multisite, ensure the following prerequisites are met:

- There must be underlying [physical network connectivity](../concepts/plan-software-defined-networking-infrastructure.md#physical-and-logical-network-configuration) between the sites. Additionally, the provider network name must be the same on both sites.

- Your firewall configuration must permit TCP port 49001 for cross-cluster communication.

- You must have Windows Admin Center version 2311 or later installed on your management PC or server. See [Install Windows Admin Center](/windows-server/manage/windows-admin-center/deploy/install).

- SDN must be installed on both sites separately, using [Windows Admin Center](./sdn-wizard.md) or [SDN Express scripts](../manage/sdn-express.md). Consequently, SDN components, such as Network Controller VMs, Software Load Balancer Multiplexor VMs, and SDN Gateway VMs are unique to each site.

- One of the two sites must not have any virtual networks, NSGs, and user defined routes configured.

- The SDN MAC pool must not overlap between the two sites.

- The IP pools for the logical networks, including Hyper-V Network Virtualization Provider Address (HNV PA), Public VIP, Private VIP, Generic Routing Encapsulation (GRE) VIP, and L3 must not overlap between the two sites.

## Workflow


- Establish peering
- Check peering status
- Manage SDN Mutisite

## Establish peering

Follow these steps to establish peering across multiple sites using Windows Admin Center:

1. In Windows Admin Center, connect to your cluster in the primary site to begin peering across locations. Under **Tools**, scroll down to the **Networking** section, and select **Network controllers**.

1. On the **Network Controllers** page, select **New** to add a secondary site.

1. On the **Connect clusters** pane on the right, provide the necessary REST information:

    1. Enter the **Name** of the secondary site. For example, **Secondary site**.

    1. Enter the **Network Controller REST Uri** of the secondary site.

    1. Enter the **Cluster name for new site** or secondary site.
    
    1. Enter the **Network Controller VM name for new site** or secondary site. This can be any Network Controller VM name of the secondary site.
    
    1. Enter the **Network Controller VM name for** your primary location. This can be any Network Controller VM name of your primary location.

1. Select **Submit**.

    :::image type="content" source="./media/manage-sdn-multisite/deploy-sdn-multisite.png" alt-text="Deploy SDN Multisite using Windows Admin Center" lightbox="./media/manage-sdn-multisite/deploy-sdn-multisite.png" :::

    Once peering is initiated, resources such as virtual networks or policy configurations that were once local to the primary site become global resources synced across locations. For details on which resources are synchronized or not, see [Resource synchronization between sites](#resource-synchronization-between-sites).

### Resource synchronization between sites

This section lists the resources that are synchronized and those that aren't synchronized between sites after peering is established.

**Synchronized**

You can update these resources through any site, and the system internally ensures that they are synced across sites.

- Virtual networks
- Network Security Groups (NSGs)
- User Defined Routes

**Not synchronized**

- Load balancing policies
- Virtual IP addresses (VIPs)

These policies are created on the local site, and if you want the same policies on the other site, you must manually create them there. If your backend VMs for load balancing policies are located on a single site, then connectivity over SLB will work fine without any additional configuration. But, if you expect the backend VMs to move from one site to the other, by default, connectivity will only work if there are any backend VMs behind a VIP on the local site. If all the backend VMs move to another site, connectivity over that VIP will fail.

## Check peering status

After you enable SDN Multisite, review the current configuration to determine which site is designated as the primary and which one as the secondary.

Follow these steps to review SDN Multisite peering status:

1. In Windows Admin Center, connect to your cluster in the primary site to begin peering across locations. Under **Tools**, scroll down to the **Networking** section, and select **Network controllers**.
1. On the **Network Controllers** page, under the **Inventory** tab, review the status of the following two columns:
    1. **State**: 
        - Local indicates the site you are accessing SDN Multisite through
        - Initated, Connected, or Failed: Indicates 
    1. **Primary**

## Manage SDN Multisite

This section describes the management tasks that you can perform after enabliing SDN Multisite solution.

### Convert secondary site into primary

In certain scenarios, you might need to convert your secondary site into primary.

Follow these steps to convert a secondary site into primary:

1. In Windows Admin Center, connect to your cluster in the primary site to begin peering across locations. Under **Tools**, scroll down to the **Networking** section, and select **Network controllers**.
1. On the **Network Controllers** page, under the **Inventory** tab, select the row for the secondary site.
1. Select **Make Primary** to change the secondary site into primary.

    :::image type="content" source="./media/manage-sdn-multisite/convert-to-primary.png" alt-text="Screenshot that shows the Make Primary button used for converting a secondary site into primary." lightbox="./media/manage-sdn-multisite/convert-to-primary.png" :::

### Rename sites

There might be scnearios where you need to rename your sites for improved relevance or to conform with the naming convention followed in your organization.

Follow these steps to rename sites:

1. In Windows Admin Center, connect to your cluster in the primary site to begin peering across locations. Under **Tools**, scroll down to the **Networking** section, and select **Network controllers**.
1. On the **Network Controllers** page, under the **Inventory** tab, select the site to rename.
1. Select **Rename** to change the secondary site into primary.

    :::image type="content" source="./media/manage-sdn-multisite/rename-sites.png" alt-text="Screenshot that shows the Rename button used for renaming a site." lightbox="./media/manage-sdn-multisite/rename-sites.png" :::

## Remove peering

When you remove peering, resource synchronization is aborted, and each site keeps its own copy of resources. For example, you have a virtual network with two VMs, one on each site. When peering is removed, each site still has the same virtual network resource and the local site VM still functions with the same network settings. But it cannot communicate with the VM on the remote site.

Once SDN Multisite is removed, resources are no longer synced across sites. This means that Network Security Groups and Virtual Network updates made to one site does not become propagated to the secondary location.

Follow these steps to remove peering:

1. In Windows Admin Center, connect to your cluster in the primary site to begin peering across locations. Under **Tools**, scroll down to the **Networking** section, and select **Network controllers**.
1. On the **Network Controllers** page, select **Delete**.

    :::image type="content" source="./media/manage-sdn-multisite/remove-peering-delete-button.png" alt-text="Screenshot that shows the Delete button used for removing peering." lightbox="./media/manage-sdn-multisite/remove-peering-delete-button.png" :::

1. On the confirmation window, select **Yes**.

    :::image type="content" source="./media/manage-sdn-multisite/remove-peering-confirmation.png" alt-text="Screenshot of the confirmation window confirming removal of peering." lightbox="./media/manage-sdn-multisite/remove-peering-confirmation.png" :::

    After you've removed peering, it will take a moment for your sites to update. If it still hasn't updated, then refresh your browser.

## Re-establish peering after removal

With redeploying after removal, your secondary site will have to be a fresh SDN environment. This means that there cannot be any preexisting virtual networks or network security groups. However, if you’re attempting to redeploy  after removing multisite, your secondary location will have a local cache of the once global resources from  multisite. Even though Multisite has been removed, your secondary location will still have a copy of those resources. Without Multisite, those resources are just out of sync now. With redeployment after Multisite removal, ensure the following:

- Virtual networks are removed. See [Delete a virtual network](./tenant-virtual-networks.md#delete-a-virtual-network)
- Network Security Groups are removed. See [Delete a network security group](./use-datacenter-firewall-windows-admin-center.md#delete-a-network-security-group)

## Next steps

- [Software Defined Networking (SDN) in Azure Stack HCI and Windows Server](../concepts/software-defined-networking.md)