---
title: Configure network security groups with tags in Windows Admin Center (preview)
description: Learn how to configure network security groups with tags in Windows Admin Center (preview).
ms.author: v-mandhiman
ms.reviewer: anpaul
ms.topic: article
author: ManikaDhiman
ms.date: 09/22/2022
---

# Configure network security groups with tags in Windows Admin Center (preview)

> Applies to: Azure Stack HCI, versions 22H2 (preview)

This article describes how to configure network security groups with network security tags in Windows Admin Center.

> [!IMPORTANT]
> The network security tags feature is currently in PREVIEW. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

With network security tags, you can create custom user-defined tags, attach those tags to your virtual machine (VM) network interfaces, and apply network access policies (with network security groups) based on these tags.

## Key benefits

In Azure Stack HCI, version 21H2, you could create network security groups to configure access policies based on network constructs (network prefixes/subnets). So, if you want to prevent your Web Server VMs from communicating with your database VMs, you must identify corresponding network subnets and create policy to deny communication between those subnets. There are a few limitations with this approach:

- Your security policies are tied to network constructs, so you'll need to know which apps are hosted on which network segments. You will need to have a fair understanding of your network infrastructure and architecture.

- You normally build policy for one application and may want to reuse that policy for other applications as well. For example, your web app in production environment can only be reached over port 80 from the internet, and can't be reached by other apps in production or other environments. Now, if you provision another web app, it will have a similar policy. But, with network segmentation, your policy needs to be recreated because the policy has network elements that are unique to apps.

- If you decommission your old application and provision a new application in the same network segment, you'll have to modify your policy.

With the network security tags feature, you no longer need to track the network segments where your applications are hosted. Using the same Web Server and database VMs example above, you can tag corresponding VMs with "Web" and "Database" network security tags. You can then create a network security group rule to prevent "Web" network security tag from communicating with "Database" network security tag.

## Create network security tag based network security groups

To create network security tag based network security groups, follow these steps:

1. [Create one or more network security tags](#create-network-security-tags).

1. [Assign a network security tag to a VM](#assign-network-security-tag-to-a-vm).

1. [Create a network security group](#create-a-network-security-group).

1. [Create a network security rule for the network security group](#create-a-network-security-group-rule).

1. [Apply the network security group to a VM, network subnet, network security tag](#apply-network-security-group).

## Create network security tags

1. On the Windows Admin Center home screen, under **All connections**, select the cluster that you want to create the ACL on.

1. Under **Tools**, scroll down to the **Networking** area, and select **Network security groups**.

1. Under **Network security groups**, select **Network Security Tags** tab, and then select **New**.

1. In the **Create Network Security Tag** pane, enter a name for the network security tag in the **Name** field.

    :::image type="content" source="media/network-security-groups-with-tags/create-network-security-tag.png" alt-text="Screenshot of the Create Network Security Tag pane.":::

1. (Optional) In the **Type** field, enter a type for the tag. This field is useful if you want to categorize tags for easy management. For example, you can have different tags with the same type "Application", such as SQL, Web, IOT, Sensor, etc.

1. Select **Submit**.

## Assign network security tag to a VM

You can assign a network security tag to a VM either when creating a new VM or afterwards when changing the properties of an existing VM.

### Assign network security tag during VM creation

For step-by-step instructions on how to create a new VM, see [Create a new VM](vm.md#create-a-new-vm).

To assign a network security tag while creating a new VM:

1. On the Windows Admin Center home screen, under **All connections**, select the server or cluster you want to create the VM on.

1. Under **Tools**, scroll down and select **Virtual machines**.

1. Under **Virtual machines**, select the **Inventory** tab, select **Add**, and then select **New**.

1. Under **New virtual machine**, enter a name for your VM.

1. Enter other properties for the VM.

1. Under **Network**, select the network security tag you created earlier, in [Create network security tag](#create-network-security-tags).

    :::image type="content" source="media/network-security-groups-with-tags/assign-tag-during-vm-creation.png" alt-text="Screenshot showing the step to assign network security tag while creating a new VM.":::

1. Select **Create**.

### Assign network security tag to an existing VM

You can assign a network security tag to an existing VM by changing its settings. For detailed instructions on how to change VM settings, see [Change VM settings](vm.md#change-vm-settings).

1. Under **Tools**, scroll down to the **Networking** area, and select **Virtual machines**.

1. Select the **Inventory** tab, select a VM, and then select **Settings**.

1. On the **Settings** page, select **Networks**.

1. Under **Network Security Tag** section, select **Add Network Security Tag**, select the network security tag you created earlier, in [Create network security tag](#create-network-security-tags).

1. Select **Save network settings**.

## Create a network security group

1. On the Windows Admin Center home screen, under **All connections**, select the cluster that you want to create the ACL on.

1. Under **Tools**, scroll down to the **Networking** area, and select **Network security groups**.

1. Under **Network security groups**, select the **Inventory** tab, and then select **New**.

1. In the **Network Security Groups** pane, type a name for the network security group, and then select **Submit**.

    :::image type="content" source="media/network-security-groups-with-tags/create-network-security-group.png" alt-text="Screenshot showing the Network Security Group pane.":::

1. Under **Network Security Groups**, verify that the **Provisioning state** of the new ACL shows **Succeeded**.

## Create a network security group rule

After you create a network security group, you're ready to create network security group rules. If you want to apply network security group rules to both inbound and outbound traffic, you need to create two rules.

1. On the Windows Admin Center home screen, under **All connections**, select the cluster that you want to create the ACL on.

1. Under **Tools**, scroll down to the **Networking** area, and select **Network security groups**.

1. Under **Network security groups**, select the **Inventory** tab, and then select the network security group that you created earlier, in [Create a network security group](#create-a-network-security-group).

1. Under **Network security rule**, select **New**.

1. In the **Network security rule** pane on the right, provide the following information:

    | Field | Description |
    | ----- | ----------- |
    | **Name** | Name of the rule. |
    | **Priority** | Priority of the rule. Acceptable values are **101** to **65000**. A lower value denotes a higher priority. |
    | **Types** | Type of the rule. This can be **Inbound** or **Outbound**. |
    | **Protocol** | Protocol to match either an incoming or outgoing packet. Acceptable values are **All**, **TCP** and **UDP**. |
    | **Source** | Select **Network Security Tag**.<br><br>**Note:** You can either select an address prefix or a network security tag but not both. |
    | **Source Security Tag Type** | (Optional) Select a type for the tag. |
    | **Source Security Tag** | Select a network security tag that you created earlier, in [Create network security tag](#create-network-security-tags). |
    | **Source Port Range** | Specify the source port range to match either an incoming or outgoing packet. You can enter `*` to specify all source ports. |
    | **Destination** | Select **Network Security Tag**.<br><br>**Note:** You can either select an address prefix or a network security tag but not both. Source and Destination can be different. |
    | **Destination Security Tag Type** | (Optional) Select a type for the tag. |
    | **Destination Security Tag** | Select a network security tag that you created earlier, in [Create network security tag](#create-network-security-tags). |
    | **Destination Port Range** | Specify the destination port range to match either an incoming or outgoing packet. You can enter `*` to specify all destination ports. |
    | **Actions** | If the above conditions are matched, specify either to allow or block the packet. Acceptable values are **Allow** and **Deny**. |
    | **Logging** | Specify either to enable or disable logging for the rule. If logging is enabled, all traffic matched by this rule is logged on the host computers. |

1. Select **Submit**.

## Apply network security group

You can apply a network security group to:

- [Virtual network subnet](use-datacenter-firewall-windows-admin-center.md#apply-an-acl-to-a-virtual-network)
- [Logical network subnet](use-datacenter-firewall-windows-admin-center.md#apply-an-acl-to-a-logical-network)
- [Specific network interface](use-datacenter-firewall-windows-admin-center.md#apply-an-acl-to-a-network-interface)
- [Network security tag](#apply-network-security-group-to-a-network-security-tag)

### Apply network security group to a network security tag

When you apply a network security group to a network security tag, the network security group rules apply to all VM network interfaces that are associated with that network security tag.

To apply a network security group to a network security tag via Windows Admin Center, follow these steps:

1. On the Windows Admin Center home screen, under **All connections**, select the cluster that you want to apply the network security group on.

1. Under **Tools**, scroll down to the **Networking** area, and select **Network security groups**.

1. Under **Network security groups**, select **Network Security Tags** tab.

1. Select the network security tag you want to edit and then select **Settings**.

1. On the **Editing Network Security Tag** pane for the selected tag, select the network security group you want to apply to the network security tag.

    :::image type="content" source="media/network-security-groups-with-tags/apply-setwork-security-group-to-tag.png" alt-text="Screenshot showing how to apply an existing network security group to a network security tag.":::

1. Select **Submit**.

## Next steps

For related information, see also:

- [What is Datacenter Firewall?](../concepts/datacenter-firewall-overview.md)
- [Use Datacenter Firewall to configure ACLs with Windows Admin Center](use-datacenter-firewall-windows-admin-center.md)
- [Use Datacenter Firewall to configure ACLs with PowerShell](use-datacenter-firewall-powershell.md)
