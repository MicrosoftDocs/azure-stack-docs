---
title: Configure network security groups for Azure Managed Lustre file systems in a zero-trust environment
description: Configure network security group rules to allow Azure Managed Lustre file system support in a zero-trust virtual network. 
ms.topic: how-to
ms.date: 10/18/2023
author: pauljewellmsft
ms.author: pauljewell
ms.reviewer: mayabishop

---

# Configure a network security group for Azure Managed Lustre file systems in a zero-trust environment

Network security groups can be configured to filter inbound and outbound network traffic to and from Azure resources in an Azure virtual network. A network security group can contain security rules that filter network traffic by IP address, port, and protocol. When a network security group is associated with a subnet, security rules are applied to resources deployed in that subnet.

This article describes how to configure network security group rules to secure access to an Azure Managed Lustre file system (AMLFS) cluster in a zero-trust environment.

## Prerequisites

- An Azure subscription. If you don't have an Azure subscription, [create a free account](https://azure.microsoft.com/free/) before you begin.
- A virtual network with a subnet that's configured to allow Azure Managed Lustre file system support. To learn more, see [Networking prerequisites](amlfs-prerequisites.md#network-prerequisites).
- An Azure Managed Lustre file system deployed in your Azure subscription. To learn more, see [Create an Azure Managed Lustre file system](create-file-system-portal.md).

## Create and configure a network security group

You can use an Azure network security group to filter network traffic between Azure resources in an Azure virtual network. A network security group contains security rules that allow or deny inbound network traffic to, or outbound network traffic from, several types of Azure resources. For each rule, you can specify source and destination, port, and protocol.

To create a network security group in the Azure portal, follow these steps:

1. In the search box at the top of the portal, enter *Network security group*. Select **Network security groups** in the search results.

2. Select **+ Create**.

3. In the **Create network security group** page, under the **Basics** tab, enter or select the following values:

    | Setting | Action |
    | --- | --- |
    | **Project details** | |
    | Subscription | Select your Azure subscription. |
    | Resource group | Select an existing resource group, or create a new one by selecting **Create new**. This example uses the **sample-rg** resource group. |
    | **Instance details** | |
    | Network security group name | Enter a name for the network security group you're creating. |
    | Region | Select the region you want. |

    :::image type="content" source="media/nsg-zero-trust/nsg-create-new.png" alt-text="Screenshot showing how to create a network security group in the Azure portal." lightbox="media/nsg-zero-trust/nsg-create-new.png":::

4. Select **Review + create**.

5. After you see the **Validation passed** message, select **Create**.

### Associate the network security group to a subnet

Once the network security group is created, you can associate it to the unique subnet in your virtual network where the Azure Managed Lustre file system exists. To associate the network security group to a subnet using the Azure portal, follow these steps:

1. In the search box at the top of the portal, enter *Network security group* and select **Network security groups** in the search results.

2. Select the name of your network security group, then select **Subnets**.

3. To associate a network security group to the subnet, select **+ Associate**, then select your virtual network and the subnet that you want to associate the network security group to. Select **OK**.

:::image type="content" source="./media/nsg-zero-trust/nsg-associate-to-subnet.png" alt-text="Screenshot showing how to associate a network security group to a subnet in Azure portal." lightbox="media/nsg-zero-trust/nsg-associate-to-subnet.png":::

## Configure network security group rules

To configure network security group rules for Azure Managed Lustre file system support, you can add inbound and outbound security rules to the network security group that's associated to the subnet where your Azure Managed Lustre file system is deployed. The following sections describe how to create and configure the inbound and outbound security rules that allow Azure Managed Lustre file system support in a zero-trust environment.

> [!NOTE]
> The security rules shown in this section are configured based on an Azure Managed Lustre file system deployment in East US region, with Blob Storage integration enabled. You might need to adjust the rules based on your deployment region and other configuration settings for the Azure Managed Lustre file system.

### Create inbound security rules

You can create inbound security rules in the Azure portal. The following example shows how to create and configure a new inbound security rule:

1. In the Azure portal, open the network security group resource you created in the previous step.
1. Select **Inbound security rules** under **Settings**.
1. Select **+ Add**.
1. In the **Add inbound security rule** pane, configure the settings for the rule and select **Add**.

:::image type="content" source="media/nsg-zero-trust/nsg-add-inbound-security-rule.png" alt-text="Screenshot showing how to create an inbound security rule for a network security group in the Azure portal." lightbox="media/nsg-zero-trust/nsg-add-inbound-security-rule.png":::

Add the following inbound rules to the network security group:

| Priority | Name | Port | Protocol | Source | Destination | Action | Description |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 110 | *rule-name* | Any | Any | 10.0.2.0/24 | 10.0.2.0/24 | Allow | Permit protocol or port flows between hosts on the AMLFS cluster subnet 10.0.2.0/24. |
| 111 | *rule-name* | 988 | TCP | 10.0.3.0/24 | 10.0.2.0/24 | Allow | Permit communication between the Lustre client subnet and the AMLFS cluster subnet. Allows only source TCP ports 1020-1023 and destination port 988. |
| 112 | *rule-name* | Any | TCP | AzureMonitor | VirtualNetwork | Allow | Permit inbound flows from the AzureMonitor service tag. Allow TCP source port 443 only. |
| 120 | *rule-name* | Any | Any | Any | Any | Deny | Deny all other inbound flows. |

The inbound security rules in the Azure portal should look similar to the following screenshot:

:::image type="content" source="media/nsg-zero-trust/nsg-inbound-security-rules.png" alt-text="Screenshot showing inbound security rules for a network security group in the Azure portal." lightbox="media/nsg-zero-trust/nsg-inbound-security-rules.png":::

### Create outbound security rules

You can create outbound security rules in the Azure portal. The following example shows how to create and configure a new outbound security rule:

1. In the Azure portal, open the network security group resource you created in an earlier step.
1. Select **Outbound security rules** under **Settings**.
1. Select **+ Add**.
1. In the **Add outbound security rule** pane, configure the settings for the rule and select **Add**.

:::image type="content" source="media/nsg-zero-trust/nsg-add-outbound-security-rule.png" alt-text="Screenshot showing how to create an outbound security rule for a network security group in the Azure portal." lightbox="media/nsg-zero-trust/nsg-add-outbound-security-rule.png":::

Add the following outbound rules to the network security group:

| Priority | Name | Port | Protocol | Source | Destination | Action | Description |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 100 | *rule-name* | 443 | TCP | VirtualNetwork | AzureMonitor | Allow | Permit outbound flows to the AzureMonitor service tag. TCP destination port 443 only. |
| 101 | *rule-name* | 443 | TCP | VirtualNetwork | AzureKeyVault.EastUS | Allow | Permit outbound flows to the AzureKeyVault.EastUS service tag. TCP destination port 443 only. |
| 102 | *rule-name* | 443 | TCP | VirtualNetwork | AzureActiveDirectory | Allow | Permit outbound flows to the AzureActiveDirectory service tag. TCP destination port 443 only. |
| 103 | *rule-name* | 443 | TCP | VirtualNetwork | Storage.EastUS | Allow | Permit outbound flows to the Storage.EastUS service tag. TCP destination port 443 only. |
| 104 | *rule-name* | 443 | TCP | VirtualNetwork | GuestAndHybridManagement | Allow | Permits outbound flows to the GuestAndHybridManagement service tag. TCP destination port 443 only. |
| 105 | *rule-name* | 443 | TCP | VirtualNetwork | ApiManagement.EastUS | Allow | Permit outbound flows to the ApiManagement.EastUS service tag. TCP destination port 443 only. |
| 106 | *rule-name* | 443 | TCP | VirtualNetwork | AzureDataLake | Allow | Permit outbound flows to the AzureDataLake service tag. TCP destination port 443 only. |
| 107 | *rule-name* | 443 | TCP | VirtualNetwork | AzureResourceManager | Allow | Permits outbound flows to the AzureResourceManager service tag. TCP destination port 443 only. |
| 108 | *rule-name* | 1020-1023 | TCP | 10.0.2.0/24 | 10.0.3.0/24 | Allow | Permit outbound flows for AMLFS cluster to Lustre client. TCP source port 988, destination ports 1020-1023 only. |
| 109 | *rule-name* | 123 | UDP | 10.0.2.0/24 | 168.61.215.74/32 | Allow | Permit outbound flows to MS NTP server (168.61.215.74). UDP destination port 123 only. |
| 110 | *rule-name* | 443 | TCP | VirtualNetwork | 20.34.120.0/21 | Allow | Permit outbound flows to AMLFS Telemetry (20.45.120.0/21). TCP destination port 443 only. |
| 111 | *rule-name* | Any | Any | 10.0.2.0/24 | 10.0.2.0/24 | Allow | Permit protocol or port flows between hosts on the AMLFS cluster subnet 10.0.2.0/24. |
| 1000 | *rule-name* | Any | Any | VirtualNetwork | Internet | Deny | Deny outbound flows to the internet. |
| 1010 | *rule-name* | Any | Any | Any | Any | Deny | Deny all other outbound flows. |

The outbound security rules in the Azure portal should look similar to the following screenshot:

:::image type="content" source="media/nsg-zero-trust/nsg-outbound-security-rules.png" alt-text="Screenshot showing outbound security rules for a network security group in the Azure portal." lightbox="media/nsg-zero-trust/nsg-outbound-security-rules.png":::

## Next steps

To learn more about Azure Managed Lustre, see the following articles:

- [What is Azure Managed Lustre?](amlfs-overview.md)
- [Create an Azure Managed Lustre file system](create-file-system-portal.md)

To learn more about Azure network security groups, see the following articles:

- [Overview of network security groups](/azure/virtual-network/network-security-groups-overview)
- [How network security groups filter network traffic](/azure/virtual-network/network-security-group-how-it-works)
