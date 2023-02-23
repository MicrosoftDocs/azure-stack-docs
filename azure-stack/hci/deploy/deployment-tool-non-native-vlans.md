---
title: Deploy Azure Stack HCI using non-native VLAN ID (preview)
description: Learn how to Deploy Azure Stack HCI using non-native VLAN ID for the management network (preview).
author: ManikaDhiman
ms.topic: how-to
ms.date: 02/23/2023
ms.author: v-mandhiman
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Deploy Azure Stack HCI using non-native VLAN ID for the management network (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-supplemental-package.md)]

This article describes how to deploy Azure Stack HCI using an existing configuration file that uses a non-native VLAN ID for the management network, instead of the default native VLAN ID `0`.

## Prerequisites

Before you begin, make sure you have done the following:

- Satisfy the [prerequisites](deployment-tool-prerequisites.md).
- Complete the [deployment checklist](deployment-tool-checklist.md).
- Prepare your [Active Directory](deployment-tool-active-directory.md) environment.
- [Install version 22H2](deployment-tool-install-os.md) on each server.

## Deployment workflow

Here are the high-level steps to deploy Azure Stack HCI by using a non-native VLAN ID for the management network:

- [Create a virtual switch on every server in the cluster using the required naming convention](#create-a-virtual-switch-conforming-to-the-required-naming-convention).
- [Configure the management virtual network adapter on every server in the cluster using the required naming convention](#configure-the-management-virtual-network-adapter-using-the-required-naming-convention).
- [Configure the required VLAN ID to the management virtual network adapter on every server in the cluster](#configure-the-required-vlan-id-to-the-management-virtual-network-adapter).
- [Create a deployment configuration file](#create-a-deployment-configuration-file).
- [Deploy Azure Stack HCI using the configuration file](./deployment-tool-existing-file.md).

## Create a virtual switch using the required naming conventions

The virtual switch name that you use for the management and compute network traffic types must follow these naming conventions:

Name of the virtual switch: `"ConvergedSwitch($Intentname)"`

  where:

  - The name is case-sensitive.

  -  `$Intentname` inside parenthesis can be any string you want, preferably describing the purpose of the virtual switch.

  - The list of network adapter names must be the list of physical network adapters that you plan to use for the management and compute network traffic types.

  **Example:** To create a new virtual switch that conforms to the required naming conventions, run the following command:

  ```powershell
  $IntentName = "MgmtCompute"
  New-VMSwitch -Name "ConvergedSwitch($IntentName)" -NetAdapterName "NIC1","NIC2" -EnableEmbeddedTeaming $true -AllowManagementOS $true
  ```

## Configure the management virtual network adapter conforming to the required naming conventions

After you configure the virtual switch, create the management virtual network adapter.

The virtual network adapter name for the management and compute network traffic types must follow these naming conventions:

Name of the virtual network adapter: `"vManagement($Intentname)"`

  where:

  - The name is case-sensitive.

  - `$Intentname` inside parenthesis can be any string you want but must match the string that you used for the virtual switch.

  **Example:** To update the management virtual network adapter name, run the following command:

  ```powershell
  $IntentName = "MgmtCompute" 
  Rename-VMNetworkAdapter -ManagementOS -Name "ConvergedSwitch($IntentName)" -       NewName "vManagement($IntentName)"
  ```

## Configure the required VLAN ID to the management virtual network adapter

After you create the virtual switch and the management virtual network adapter, specify the required VLAN ID to this adapter by using the `Set-VMNetworkAdapterIsolation` cmdlet.

The following example shows how to configure the management virtual network adapter to use VLAN ID `8` instead of the native VLAN ID `0`.

```powershell
Set-VMNetworkAdapterIsolation -ManagementOS -VMNetworkAdapterName "vManagement($IntentName)" -AllowUntaggedTraffic $true -IsolationMode Vlan -DefaultIsolationID 8
```

After you configure the required VLAN ID, assign the IP address and gateways to the management virtual network adapter to validate its connectivity with other servers, DNS, Active Directory, and Internet.

## Create a deployment configuration file

After you finish configuring the networking elements on all the servers, create a configuration file to use for your deployment. For information about how to create the configuration file, see [Create the configuration file](deployment-tool-existing-file.md#create-the-configuration-file).

The following example shows a snippet of the `HostNetwork` configuration section within the configuration file, where the management and compute intent is defined to use the two physical network adapters assigned for these traffic types. There is no reference to the management virtual network adapters created in the previous steps because the deployment tool keeps the network configuration as-is, including the VLAN ID.

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