---
title: Deploy Azure Stack HCI using non-native VLAN ID (preview)
description: Learn how to deploy Azure Stack HCI using non-native VLAN ID for the management network (preview).
author: alkohli
ms.topic: how-to
ms.date: 03/02/2023
ms.author: alkohli
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

- [Create a virtual switch on every server in the cluster using the recommended naming convention](#create-virtual-switches-using-the-recommended-naming-conventions).
- [Configure the management virtual network adapter on every server in the cluster using the required naming convention](#configure-the-management-virtual-network-adapter-using-the-required-naming-conventions).
- [Configure the required VLAN ID to the management virtual network adapter on every server in the cluster](#configure-the-required-vlan-id-to-the-management-virtual-network-adapter).
- [Deploy Azure Stack HCI using the configuration file](#deploy-azure-stack-hci-using-the-configuration-file).

## Create virtual switches using the recommended naming conventions

Azure Stack HCI with Supplemental Package deployment relies on Network ATC to create and configure the virtual switches and virtual network adapters for management, compute, and storage intents. By default, when Network ATC creates the virtual switch for the intents, it uses a specific name for the virtual switch. Although it is not required, we recommend to name your virtual switches with the same naming convention.  

Here are the recommended naming conventions for the virtual switches:

Format for the virtual switch name: `"ConvergedSwitch($IntentName)"`

where:

- The name is case-sensitive.
    
- `$IntentName` inside the parenthesis can be any string you want, preferably indicating the intent type. This string should match the management virtual network adapter name as described later, in the [Configure the management virtual network adapter using the required naming conventions](#configure-the-management-virtual-network-adapter-using-the-required-naming-conventions) section.

**Example:** The following example shows how to create a virtual switch using the recommended naming convention. Here you create a virtual switch, `ConvergedSwitch(MgmtCompute)` for management and compute traffic types by using two physical network adapters, `NIC1` and `NIC2`. Note the list of network adapter names must be the list of physical network adapters that you plan to use for the management and compute network traffic types.

```powershell
$IntentName = "MgmtCompute"
New-VMSwitch -Name "ConvergedSwitch($IntentName)" -NetAdapterName "NIC1","NIC2" -EnableEmbeddedTeaming $true -AllowManagementOS $false
```

## Configure the management virtual network adapter using the required naming conventions

After you create the virtual switch, configure the management virtual network adapter on every server in the cluster.

Here are required naming conventions for the virtual network adapter used for the management traffic:

Format for the management virtual network adapter name: `"vManagement($IntentName)"`

where:

- The name is case-sensitive.

- `$IntentName` inside the parenthesis must match the string that you used for the virtual switch.

**Example:** The following example shows how to update the name of the management virtual network adapter:

```powershell
$IntentName = "MgmtCompute"  
Add-VMNetworkAdapter -ManagementOS -SwitchName "ConvergedSwitch($IntentName)" -Name “vManagement($IntentName)” 

#NetAdapter needs to be renamed because during creation, Hyper-V adds the string “vEthernet “ to the beginning of the name 

Rename-NetAdapter -Name “vEthernet (vManagement($IntentName))” -NewName “vManagement($IntentName)” 
```

## Configure the required VLAN ID to the management virtual network adapter

After you create the virtual switch and the management virtual network adapter, specify the required VLAN ID for this adapter by using the `Set-VMNetworkAdapterIsolation` cmdlet.

> [!IMPORTANT]
> Although there are multiple ways to assign a VLAN ID to a virtual network adapter, we support using the `Set-VMNetworkAdapterIsolation` cmdlet only.

**Example:** The following example shows how to configure the management virtual network adapter to use VLAN ID `8` instead of the native VLAN ID `0`.

```powershell
Set-VMNetworkAdapterIsolation -ManagementOS -VMNetworkAdapterName "vManagement($IntentName)" -AllowUntaggedTraffic $true -IsolationMode Vlan -DefaultIsolationID 8
```

After you configure the required VLAN ID, assign an IP address and gateways to the management virtual network adapter. This verifies that the virtual network adapter has connectivity with other servers, DNS, Active Directory, and internet.

## Deploy Azure Stack HCI using the configuration file

After you finish configuring the networking elements on all the servers, you're ready to deploy Azure Stack HCI using a configuration file that you have modified for your environment. For information about how to create the configuration file and then run the deployment, see [Deploy Azure Stack HCI using an existing configuration file (preview)](deployment-tool-existing-file.md).

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
                                "NetworkDirect": "Enabled", 
                                "NetworkDirectTechnology": "iWARP" 
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