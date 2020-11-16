---
title: Use Datacenter Firewall for SDN in Azure Stack HCI
description: Use this topic to get started with Datacenter Firewall for Software-Defined Networking in Azure Stack HCI.
author: khdownie
ms.author: v-kedow
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 11/16/2020
---

# Use Datacenter Firewall for Software-Defined Networking in Azure Stack HCI

> Applies to: Azure Stack HCI, version 20H2; Windows Server 2019

This topic provides instructions for configuring access control lists (ACLs) to manage data traffic flow using Datacenter Firewall for Software Defined Networking (SDN) in Azure Stack HCI using Windows PowerShell. You enable and configure Datacenter Firewall by creating ACLs that get applied to a subnet or a network interface. The example scripts in this topic use Windows PowerShell commands exported from the **NetworkController** module. You can also use Windows Admin Center to configure and manage ACLs.

## Configure Datacenter Firewall to allow all traffic

Once you deploy SDN, you should test for basic network connectivity in your new environment. To accomplish this, create a rule for Datacenter Firewall that allows all network traffic, without restriction.

Use the entries in the following table to create a set of rules that allow all inbound and outbound network traffic.

| Source IP | Destination IP | Protocol | Source Port | Destination Port | Direction | Action | Priority |
|:---------:|:--------------:|:--------:|:-----------:|:----------------:|:---------:|:------:|:--------:|
|    \*     |       \*       |   All    |     \*      |        \*        |  Inbound  | Allow  |   100    |
|    \*     |       \*       |   All    |     \*      |        \*        | Outbound  | Allow  |   110    |

---

In this example, you create an ACL with two rules:

1. **AllowAll_Inbound** - allows all network traffic to pass into the network interface where this ACL is configured.
2. **AllowAllOutbound** - allows all traffic to pass out of the network interface. This ACL, identified by the resource id "AllowAll-1" is now ready to be used in virtual subnets and network interfaces.

First, connect to one of the cluster nodes by opening a PowerShell session:

```PowerShell
Enter-PSSession <server-name>
```

Then, run the following script to create the ACL:

```PowerShell
$ruleproperties = new-object Microsoft.Windows.NetworkController.AclRuleProperties
$ruleproperties.Protocol = "All"
$ruleproperties.SourcePortRange = "0-65535"
$ruleproperties.DestinationPortRange = "0-65535"
$ruleproperties.Action = "Allow"
$ruleproperties.SourceAddressPrefix = "*"
$ruleproperties.DestinationAddressPrefix = "*"
$ruleproperties.Priority = "100"
$ruleproperties.Type = "Inbound"
$ruleproperties.Logging = "Enabled"
$aclrule1 = new-object Microsoft.Windows.NetworkController.AclRule
$aclrule1.Properties = $ruleproperties
$aclrule1.ResourceId = "AllowAll_Inbound"
$ruleproperties = new-object Microsoft.Windows.NetworkController.AclRuleProperties
$ruleproperties.Protocol = "All"
$ruleproperties.SourcePortRange = "0-65535"
$ruleproperties.DestinationPortRange = "0-65535"
$ruleproperties.Action = "Allow"
$ruleproperties.SourceAddressPrefix = "*"
$ruleproperties.DestinationAddressPrefix = "*"
$ruleproperties.Priority = "110"
$ruleproperties.Type = "Outbound"
$ruleproperties.Logging = "Enabled"
$aclrule2 = new-object Microsoft.Windows.NetworkController.AclRule
$aclrule2.Properties = $ruleproperties
$aclrule2.ResourceId = "AllowAll_Outbound"
$acllistproperties = new-object Microsoft.Windows.NetworkController.AccessControlListProperties
$acllistproperties.AclRules = @($aclrule1, $aclrule2)
New-NetworkControllerAccessControlList -ResourceId "AllowAll" -Properties $acllistproperties -ConnectionUri <NC REST FQDN>
```

>[!NOTE]
>The Windows PowerShell command reference for Network Controller is located in the topic [Network Controller cmdlets](/powershell/module/networkcontroller/).

## Use ACLs to limit traffic on a subnet
In this example, you create an ACL that prevents virtual machines (VMs) within the 192.168.0.0/24 subnet from communicating with each other. This type of ACL is useful for limiting the ability of an attacker to spread laterally within the subnet, while still allowing the VMs to receive requests from outside of the subnet, as well as to communicate with other services on other subnets.

|   Source IP    | Destination IP | Protocol | Source Port | Destination Port | Direction | Action | Priority |
|:--------------:|:--------------:|:--------:|:-----------:|:----------------:|:---------:|:------:|:--------:|
|  192.168.0.1   |       \*       |   All    |     \*      |        \*        |  Inbound  | Allow  |   100    |
|       \*       |  192.168.0.1   |   All    |     \*      |        \*        | Outbound  | Allow  |   101    |
| 192.168.0.0/24 |       \*       |   All    |     \*      |        \*        |  Inbound  | Block  |   102    |
|       \*       | 192.168.0.0/24 |   All    |     \*      |        \*        | Outbound  | Block  |   103    |
|       \*       |       \*       |   All    |     \*      |        \*        |  Inbound  | Allow  |   104    |
|       \*       |       \*       |   All    |     \*      |        \*        | Outbound  | Allow  |   105    |

---

The ACL created by the example script below, identified by the resource id **Subnet-192-168-0-0**, can now be applied to a virtual network subnet that uses the "192.168.0.0/24" subnet address. Any network interface that is attached to that virtual network subnet automatically gets the above ACL rules applied.

The following is an example script to create this ACL using the Network Controller REST API:

```PowerShell
import-module networkcontroller
$ncURI = "https://mync.contoso.local"
$aclrules = @()

$ruleproperties = new-object Microsoft.Windows.NetworkController.AclRuleProperties
$ruleproperties.Protocol = "All"
$ruleproperties.SourcePortRange = "0-65535"
$ruleproperties.DestinationPortRange = "0-65535"
$ruleproperties.Action = "Allow"
$ruleproperties.SourceAddressPrefix = "192.168.0.1"
$ruleproperties.DestinationAddressPrefix = "*"
$ruleproperties.Priority = "100"
$ruleproperties.Type = "Inbound"
$ruleproperties.Logging = "Enabled"

$aclrule = new-object Microsoft.Windows.NetworkController.AclRule
$aclrule.Properties = $ruleproperties
$aclrule.ResourceId = "AllowRouter_Inbound"
$aclrules += $aclrule

$ruleproperties = new-object Microsoft.Windows.NetworkController.AclRuleProperties
$ruleproperties.Protocol = "All"
$ruleproperties.SourcePortRange = "0-65535"
$ruleproperties.DestinationPortRange = "0-65535"
$ruleproperties.Action = "Allow"
$ruleproperties.SourceAddressPrefix = "*"
$ruleproperties.DestinationAddressPrefix = "192.168.0.1"
$ruleproperties.Priority = "101"
$ruleproperties.Type = "Outbound"
$ruleproperties.Logging = "Enabled"

$aclrule = new-object Microsoft.Windows.NetworkController.AclRule
$aclrule.Properties = $ruleproperties
$aclrule.ResourceId = "AllowRouter_Outbound"
$aclrules += $aclrule

$ruleproperties = new-object Microsoft.Windows.NetworkController.AclRuleProperties
$ruleproperties.Protocol = "All"
$ruleproperties.SourcePortRange = "0-65535"
$ruleproperties.DestinationPortRange = "0-65535"
$ruleproperties.Action = "Deny"
$ruleproperties.SourceAddressPrefix = "192.168.0.0/24"
$ruleproperties.DestinationAddressPrefix = "*"
$ruleproperties.Priority = "102"
$ruleproperties.Type = "Inbound"
$ruleproperties.Logging = "Enabled"

$aclrule = new-object Microsoft.Windows.NetworkController.AclRule
$aclrule.Properties = $ruleproperties
$aclrule.ResourceId = "DenySubnet_Inbound"
$aclrules += $aclrule

$ruleproperties = new-object Microsoft.Windows.NetworkController.AclRuleProperties
$ruleproperties.Protocol = "All"
$ruleproperties.SourcePortRange = "0-65535"
$ruleproperties.DestinationPortRange = "0-65535"
$ruleproperties.Action = "Deny"
$ruleproperties.SourceAddressPrefix = "*"
$ruleproperties.DestinationAddressPrefix = "192.168.0.0/24"
$ruleproperties.Priority = "103"
$ruleproperties.Type = "Outbound"
$ruleproperties.Logging = "Enabled"

$aclrule = new-object Microsoft.Windows.NetworkController.AclRule
$aclrule.Properties = $ruleproperties
$aclrule.ResourceId = "DenySubnet_Outbound"

$ruleproperties = new-object Microsoft.Windows.NetworkController.AclRuleProperties
$ruleproperties.Protocol = "All"
$ruleproperties.SourcePortRange = "0-65535"
$ruleproperties.DestinationPortRange = "0-65535"
$ruleproperties.Action = "Allow"
$ruleproperties.SourceAddressPrefix = "*"
$ruleproperties.DestinationAddressPrefix = "*"
$ruleproperties.Priority = "104"
$ruleproperties.Type = "Inbound"
$ruleproperties.Logging = "Enabled"

$aclrule = new-object Microsoft.Windows.NetworkController.AclRule
$aclrule.Properties = $ruleproperties
$aclrule.ResourceId = "AllowAll_Inbound"
$aclrules += $aclrule

$ruleproperties = new-object Microsoft.Windows.NetworkController.AclRuleProperties
$ruleproperties.Protocol = "All"
$ruleproperties.SourcePortRange = "0-65535"
$ruleproperties.DestinationPortRange = "0-65535"
$ruleproperties.Action = "Allow"
$ruleproperties.SourceAddressPrefix = "*"
$ruleproperties.DestinationAddressPrefix = "*"
$ruleproperties.Priority = "105"
$ruleproperties.Type = "Outbound"
$ruleproperties.Logging = "Enabled"

$aclrule = new-object Microsoft.Windows.NetworkController.AclRule
$aclrule.Properties = $ruleproperties
$aclrule.ResourceId = "AllowAll_Outbound"
$aclrules += $aclrule

$acllistproperties = new-object Microsoft.Windows.NetworkController.AccessControlListProperties
$acllistproperties.AclRules = $aclrules

New-NetworkControllerAccessControlList -ResourceId "Subnet-192-168-0-0" -Properties $acllistproperties -ConnectionUri $ncURI
```

## Add an ACL to a network interface

Once you've created an ACL and assigned it to a virtual subnet, you might want to override that default ACL on the virtual subnet with a specific ACL for an individual network interface. In this case, you apply specific ACLs directly to network interfaces attached to VLANs, instead of the virtual network. If you have ACLs set on the virtual subnet connected to the network interface, both ACLs are applied and prioritizes the network interface ACLs above the virtual subnet ACLs.

In this example, we demonstrate how to add an ACL to a virtual network.

>[!TIP]
>It is also possible to add an ACL at the same time that you create the network interface.

1. Get or create the network interface to which you will add the ACL.

   ```PowerShell
   $nic = get-networkcontrollernetworkinterface -ConnectionUri $uri -ResourceId "MyVM_Ethernet1"
   ```

2. Get or create the ACL you will add to the network interface.

   ```PowerShell
   $acl = get-networkcontrolleraccesscontrollist -ConnectionUri $uri -ResourceId "AllowAllACL"
   ```

3. Assign the ACL to the AccessControlList property of the network interface.

   ```PowerShell
    $nic.properties.ipconfigurations[0].properties.AccessControlList = $acl
   ```

4. Add the network interface in Network Controller.

   ```PowerShell
   new-networkcontrollernetworkinterface -ConnectionUri $uri -Properties $nic.properties -ResourceId $nic.resourceid
   ```

## Remove an ACL from a network interface

In this example, we show you how to remove an ACL from a network interface. Removing an ACL applies the default set of rules to the network interface. The default set of rules allows all outbound traffic but blocks all inbound traffic. If you want to allow all inbound traffic, you must follow the previous [example](#add-an-acl-to-a-network-interface) to add an ACL that allows all inbound and all outbound traffic.

1. Get the network interface from which you will remove the ACL.
   ```PowerShell
   $nic = get-networkcontrollernetworkinterface -ConnectionUri $uri -ResourceId "MyVM_Ethernet1"
   ```

2. Assign $null to the AccessControlList property of the ipConfiguration.
   ```PowerShell
   $nic.properties.ipconfigurations[0].properties.AccessControlList = $null
   ```

3. Add the network interface object in Network Controller.
   ```PowerShell
   new-networkcontrollernetworkinterface -ConnectionUri $uri -Properties $nic.properties -ResourceId $nic.resourceid
   ```

## Next steps

For related information, see also:

- Datacenter Firewall overview
- [Network Controller overview](../concepts/network-controller-overview.md)
- [SDN in Azure Stack HCI](../concepts/software-defined-networking.md)