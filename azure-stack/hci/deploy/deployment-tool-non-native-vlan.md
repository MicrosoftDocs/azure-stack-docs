---
title: Deploy Azure Stack HCI using non-native VLAN ID (preview)
description: Learn how to deploy Azure Stack HCI using non-native VLAN ID for the management network (preview).
author: ManikaDhiman
ms.topic: how-to
ms.date: 02/23/2023
ms.author: v-mandhiman
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Deploy Azure Stack HCI using non-native VLAN ID for the management network (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-supplemental-package.md)]

When you deploy Azure Stack HCI using an existing configuration file, by default, a native VLAN ID 0 is used for the management network. However, in some specific scenarios, you may need to use a non-native VLAN ID for the management network.

This article describes how to deploy Azure Stack HCI using a non-native VLAN ID for the management network. This deployment method uses an existing configuration file that you have modified for your environment. For the default deployment scenario using a native VLAN ID, see [Deploy Azure Stack HCI using an existing configuration file (preview)](deployment-tool-existing-file.md).

## Prerequisites

Before you begin, make sure you've done the following:

- Satisfy the [prerequisites](deployment-tool-prerequisites.md).
- Complete the [deployment checklist](deployment-tool-checklist.md).
- Prepare your [Active Directory](deployment-tool-active-directory.md) environment.
- [Install version 22H2](deployment-tool-install-os.md) on each server.
- [Set up the first server](deployment-tool-set-up-first-server.md) in your Azure Stack HCI cluster.

## Deployment workflow

Here are the high-level steps to deploy Azure Stack HCI by using a non-native VLAN ID for the management network:

- [Enable Hyper-V role on each server in the cluster](#enable-hyper-v-role-on-each-server).
- [Create a virtual switch on every server in the cluster using the required naming convention](#create-a-virtual-switch-using-the-required-naming-conventions).
- [Configure the management virtual network adapter on every server in the cluster using the required naming convention](#configure-the-management-virtual-network-adapter-using-the-required-naming-conventions).
- [Configure the required VLAN ID to the management virtual network adapter on every server in the cluster](#configure-the-required-vlan-id-to-the-management-virtual-network-adapter).
- [Deploy Azure Stack HCI using the configuration file](./deployment-tool-existing-file.md).

## Enable Hyper-V role on each server

You must install the Hyper-V role on all servers before the deployment. This is required because the VLAN ID is configured on the management virtual network adapter on each server. The management virtual network adapter is connected to the virtual switch that uses the two physical network adapters that you plan to use for management and compute network traffic. We don't support configuring the VLAN ID directly on the physical network adapters.

To install the Hyper-V role, run the following command on each server:

```powershell
Install-WindowsFeature -Name Hyper-V -ComputerName <computer_name> -IncludeManagementTools -Restart
```

For detailed installation instructions, see [Install Hyper-V by using the Install-WindowsFeature cmdlet](/windows-server/virtualization/hyper-v/get-started/install-the-hyper-v-role-on-windows-server#install-hyper-v-by-using-the-install-windowsfeature-cmdlet) in the Install the Hyper-V role on Windows Server article.

## Create virtual switches using the recommended naming conventions

Azure Stack HCI with Supplemental Package deployment relies on Network ATC to create and configure the virtual switches and virtual network adapters for management, compute, and storage intents. By default, when Network ATC creates the virtual switch for the intents, it uses a specific name for the virtual switch. Although it is not required, we recommend to name your virtual switches with the same naming convention.  

Here's the recommended naming convention for the virtual switches:

Format for the name of the virtual switch: `"ConvergedSwitch($IntentName)"`

where:

- The name is case-sensitive.
    
- `$IntentName` inside the parenthesis can be any string you want, preferably indicating the intent type. This string should match the name on the virtual nic for management as described in the next step.

- The list of network adapter names must be the list of physical network adapters that you plan to use for the management and compute network traffic types.

**Example:** To create a virtual switch using the required naming convention and with an intent name within parenthesis describing the purpose of the virtual switch, run the following command:

```powershell
$IntentName = "MgmtCompute"
New-VMSwitch -Name "ConvergedSwitch($IntentName)" -NetAdapterName "NIC1","NIC2" -EnableEmbeddedTeaming $true -AllowManagementOS $true
```

In this example, a virtual switch `MgmtCompute` is created using two network adapters `NIC1` and `NIC2`. This virtual switch is used for management and compute network traffic.

## Configure the management virtual network adapter using the required naming conventions

After you create the virtual switch, configure the management virtual network adapter. However, you must update the required name to adhere to the required naming convention used by the lifecycle management engine. Follow these naming conventions to name the virtual network adapter for the management and compute network traffic types:

Name of the virtual network adapter: `"vManagement($Intentname)"`

where:

- The name is case-sensitive.

- `$Intentname` inside the parenthesis must match the string that you used for the virtual switch.

**Example:** To update the name of the management virtual network adapter, run the following command:

```powershell
$IntentName = "MgmtCompute" 
Rename-VMNetworkAdapter -ManagementOS -Name "ConvergedSwitch($IntentName)" -NewName "vManagement($IntentName)"
```

In this example, the name of the management virtual network adapter is updated from `ConvergedSwitch(MgmtCompute)` to `vManagement(MgmtCompute)`.

## Configure the required VLAN ID to the management virtual network adapter

After you create the virtual switch and the management virtual network adapter, specify the required VLAN ID for this adapter by using the `Set-VMNetworkAdapterIsolation` cmdlet.

> [!IMPORTANT]
> There are different options to assign a VLAN ID to a virtual network adapter, but we support only using the `Set-VMNetworkAdapterIsolation` cmdlet. 

**Example:** The following example shows how to configure the management virtual network adapter to use VLAN ID `8` instead of the native VLAN ID `0`.

```powershell
Set-VMNetworkAdapterIsolation -ManagementOS -VMNetworkAdapterName "vManagement($IntentName)" -AllowUntaggedTraffic $true -IsolationMode Vlan -DefaultIsolationID 8
```

After you configure the required VLAN ID, assign an IP address and gateways to the management virtual network adapter. This verifies that the virtual network adapter has connectivity with other servers, DNS, Active Directory, and internet.

## Deploy Azure Stack HCI using the configuration file

After you finish configuring the networking elements on all the servers, you're ready to deploy Azure Stack HCI using a configuration file that you manually create beforehand using a text editor. For information about how to create the configuration file and then run the deployment, see [Deploy Azure Stack HCI using an existing configuration file (preview)](deployment-tool-existing-file.md).

The following example shows a snippet of the `HostNetwork` configuration section within the configuration file, where the management and compute intent is defined to use the two physical network adapters assigned for these traffic types. There's no reference to the management virtual network adapters created in the previous steps because the deployment tool keeps the network configuration as-is, including the VLAN ID.

```JSON
"HostNetwork": {
                    "Intents": [
                        {
                            "Name": "MgmtCompute",
                            "TrafficType": [
                                "Management",
                                "Compute"
                            ],
                            "Adapter": [
                                "NIC1",
                                "NIC2"
                            ],
                            "OverrideVirtualSwitchConfiguration": false,
                            "OverrideQoSPolicy": false,
                            "QoSPolicyOverrides": {
                                "PriorityValue8021Action_Cluster": "7",
                                "PriorityValue8021Action_SMB": "3",
                                "BandwidthPercentage_SMB": "50%"
                            },
                            "OverrideAdapterProperty": false,
                            "AdapterPropertyOverrides": {
                                "JumboPacket": "",
                                "NetworkDirect": "",
                                "NetworkDirectTechnology": ""
                            }
                        },
                        {
                            "Name": "Storage",
                            "TrafficType": [
                                "Storage"
                            ],
                            "Adapter": [
                                "NIC3",
                                "NIC4"
                            ],
                            "OverrideVirtualSwitchConfiguration": false,
                            "OverrideQoSPolicy": false,
                            "QoSPolicyOverrides": {
                                "PriorityValue8021Action_Cluster": "7",
                                "PriorityValue8021Action_SMB": "3",
                                "BandwidthPercentage_SMB": "50%"
                            },
                            "OverrideAdapterProperty": false,
                            "AdapterPropertyOverrides": {
                                "JumboPacket": "",
                                "NetworkDirect": "",
                                "NetworkDirectTechnology": ""
                            }
                        }
                    ],
                    "StorageNetworks": [
                        {
                            "Name": "RDMA1",
                            "NetworkAdapterName": "NIC3",
                            "VlanId": 711
                        },
                        {
                            "Name": "RDMA2",
                            "NetworkAdapterName": "NIC4",
                            "VlanId": 712
                        }
                    ]
                },
```

## Next steps

- [Validate deployment](deployment-tool-validate.md).
- If needed, [troubleshoot deployment](deployment-tool-troubleshoot.md).