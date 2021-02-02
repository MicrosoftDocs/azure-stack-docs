---
title: Use Datacenter Firewall for SDN in Azure Stack HCI and Windows Server
description: Use this topic to get started with Datacenter Firewall for Software-Defined Networking in Azure Stack HCI, Windows Server 2019, and Windows Server 2016.
author: khdownie
ms.author: v-kedow
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 02/02/2021
---

# Use Datacenter Firewall for Software-Defined Networking in Azure Stack HCI and Windows Server

> Applies to: Azure Stack HCI, version 20H2; Windows Server 2019; Windows Server 2016

This topic provides instructions for configuring access control lists (ACLs) to manage data traffic flow using [Datacenter Firewall](../concepts/datacenter-firewall-overview.md) for Software Defined Networking (SDN) in Azure Stack HCI using Windows PowerShell. You enable and configure Datacenter Firewall by creating ACLs that get applied to a subnet or a network interface. The example scripts in this topic use Windows PowerShell commands exported from the **NetworkController** module. You can also use Windows Admin Center to configure and manage ACLs.

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
2. **AllowAllOutbound** - allows all traffic to pass out of the network interface. This ACL, identified by the resource ID "AllowAll-1" is now ready to be used in virtual subnets and network interfaces.

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

The ACL created by the example script below, identified by the resource ID **Subnet-192-168-0-0**, can now be applied to a virtual network subnet that uses the "192.168.0.0/24" subnet address. Any network interface that is attached to that virtual network subnet automatically gets the above ACL rules applied.

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

Once you've created an ACL and assigned it to a virtual subnet, you might want to override that default ACL on the virtual subnet with a specific ACL for an individual network interface. Beginning in Windows Server 2019 Datacenter, you can apply specific ACLs directly to network interfaces attached to SDN logical networks, in addition to SDN virtual networks. If you have ACLs set on the virtual subnet connected to the network interface, both ACLs are applied, and the network interface ACLs are prioritized above the virtual subnet ACLs.

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

## Firewall auditing

Introduced in Windows Server 2019, firewall auditing is a new capability for the Datacenter Firewall that records any flow processed by SDN firewall rules. All ACLs that have logging enabled are recorded. The log files must be in a syntax that is consistent with the [Azure Network Watcher flow logs](/azure/network-watcher/network-watcher-nsg-flow-logging-overview). These logs can be used for diagnostics or archived for later analysis.

Here is a sample script to enable firewall auditing on the host servers. Update the variables at the beginning and run this on an Azure Stack HCI cluster with [Network Controller](../concepts/network-controller-overview.md) deployed:

```PowerShell
$logpath = "C:\test\log1"
$servers = @("sa18n22-2", "sa18n22-3", "sa18n22-4")
$uri = "https://sa18n22sdn.sa18.nttest.microsoft.com"

# Create log directories on the hosts
invoke-command -Computername $servers  {
    param(
        $Path
    )
    mkdir $path    -force
} -argumentlist $LogPath

# Set firewall auditing settings on Network Controller
$AuditProperties = new-object Microsoft.Windows.NetworkController.AuditingSettingsProperties
$AuditProperties.OutputDirectory = $logpath
set-networkcontrollerauditingsettingsconfiguration -connectionuri $uri -properties $AuditProperties -force  | out-null

# Enable logging on each server
$servers = get-networkcontrollerserver -connectionuri $uri
foreach ($s in $servers) {
    $s.properties.AuditingEnabled = @("Firewall")
    new-networkcontrollerserver -connectionuri $uri -resourceid $s.resourceid -properties $s.properties -force | out-null
}
```

Once enabled, a new file appears in the specified directory on each host about once per hour.  You should periodically process these files and remove them from the hosts.  The current file has zero length and is locked until flushed at the next hour mark:

```syntax
PS C:\test\log1> dir

    Directory: C:\test\log1

Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----        7/19/2018   6:28 AM          17055 SdnFirewallAuditing.d8b3b697-5355-40e2-84d2-1bf2f0e0dc4a.20180719TL122803093.json
-a----        7/19/2018   7:28 AM           7880 SdnFirewallAuditing.d8b3b697-5355-40e2-84d2-1bf2f0e0dc4a.20180719TL132803173.json
-a----        7/19/2018   8:28 AM           7867 SdnFirewallAuditing.d8b3b697-5355-40e2-84d2-1bf2f0e0dc4a.20180719TL142803264.json
-a----        7/19/2018   9:28 AM          10949 SdnFirewallAuditing.d8b3b697-5355-40e2-84d2-1bf2f0e0dc4a.20180719TL152803360.json
-a----        7/19/2018   9:28 AM              0 SdnFirewallAuditing.d8b3b697-5355-40e2-84d2-1bf2f0e0dc4a.20180719TL162803464.json
```

These files contain a sequence of flow events, for example:

```syntax
{
    "records": [
        {
            "properties":{
                "Version":"1.0",
                "flows":[
                    {
                        "flows":[
                            {
                                "flowTuples":["1531963580,192.122.0.22,192.122.255.255,138,138,U,I,A"],
                                "portId":"9",
                                "portName":"7290436D-0422-498A-8EB8-C6CF5115DACE"
                            }
                        ],
                        "rule":"Allow_Inbound"
                    }
                ]
            },
            "operationName":"NetworkSecurityGroupFlowEvents",
            "resourceId":"394f647d-2ed0-4c31-87c5-389b8c0c8132",
            "time":"20180719:L012620622",
            "category":"NetworkSecurityGroupFlowEvent",
            "systemId":"d8b3b697-5355-40e2-84d2-1bf2f0e0dc4a"
            },
```

Note, logging takes place only for rules that have **Logging** set to **Enabled**, for example:

```syntax
{
    "Tags":  null,
    "ResourceRef":  "/accessControlLists/AllowAll",
    "InstanceId":  "4a63e1a5-3264-4986-9a59-4e77a8b107fa",
    "Etag":  "W/\"1535a780-0fc8-4bba-a15a-093ecac9b88b\"",
    "ResourceMetadata":  null,
    "ResourceId":  "AllowAll",
    "Properties":  {
                       "ConfigurationState":  null,
                       "ProvisioningState":  "Succeeded",
                       "AclRules":  [
                                        {
                                            "ResourceMetadata":  null,
                                            "ResourceRef":  "/accessControlLists/AllowAll/aclRules/AllowAll_Inbound",
                                            "InstanceId":  "ba8710a8-0f01-422b-9038-d1f2390645d7",
                                            "Etag":  "W/\"1535a780-0fc8-4bba-a15a-093ecac9b88b\"",
                                            "ResourceId":  "AllowAll_Inbound",
                                            "Properties":  {
                                                               "Protocol":  "All",
                                                               "SourcePortRange":  "0-65535",
                                                               "DestinationPortRange":  "0-65535",
                                                               "Action":  "Allow",
                                                               "SourceAddressPrefix":  "*",
                                                               "DestinationAddressPrefix":  "*",
                                                               "Priority":  "101",
                                                               "Description":  null,
                                                               "Type":  "Inbound",
                                                               "Logging":  "Enabled",
                                                               "ProvisioningState":  "Succeeded"
                                                           }
                                        },
                                        {
                                            "ResourceMetadata":  null,
                                            "ResourceRef":  "/accessControlLists/AllowAll/aclRules/AllowAll_Outbound",
                                            "InstanceId":  "068264c6-2186-4dbc-bbe7-f504c6f47fa8",
                                            "Etag":  "W/\"1535a780-0fc8-4bba-a15a-093ecac9b88b\"",
                                            "ResourceId":  "AllowAll_Outbound",
                                            "Properties":  {
                                                               "Protocol":  "All",
                                                               "SourcePortRange":  "0-65535",
                                                               "DestinationPortRange":  "0-65535",
                                                               "Action":  "Allow",
                                                               "SourceAddressPrefix":  "*",
                                                               "DestinationAddressPrefix":  "*",
                                                               "Priority":  "110",
                                                               "Description":  null,
                                                               "Type":  "Outbound",
                                                               "Logging":  "Enabled",
                                                               "ProvisioningState":  "Succeeded"
                                                           }
                                        }
                                    ],
                       "IpConfigurations":  [

                                            ],
                       "Subnets":  [
                                       {
                                           "ResourceMetadata":  null,
                                           "ResourceRef":  "/virtualNetworks/10_0_1_0/subnets/Subnet1",
                                           "InstanceId":  "00000000-0000-0000-0000-000000000000",
                                           "Etag":  null,
                                           "ResourceId":  null,
                                           "Properties":  null
                                       }
                                   ]
                   }
}
```

## Next steps

For related information, see also:

- [Datacenter Firewall overview](../concepts/datacenter-firewall-overview.md)
- [Network Controller overview](../concepts/network-controller-overview.md)
- [SDN in Azure Stack HCI and Windows Server](../concepts/software-defined-networking.md)