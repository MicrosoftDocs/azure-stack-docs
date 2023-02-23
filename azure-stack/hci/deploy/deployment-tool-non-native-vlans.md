---
title: Deploy Azure Stack HCI using non-native VLANs (preview)
description: Learn how to Deploy Azure Stack HCI using non-native VLANs for management network (preview).
author: ManikaDhiman
ms.topic: how-to
ms.date: 02/23/2023
ms.author: v-mandhiman
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Deploy Azure Stack HCI using non-native VLAN ID for management network (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-supplemental-package.md)]

This article describes how to configure Azure Stack HCI clusters to use non-native VLANs for the management network.

By default, native VLAN ID 0 is used for the management network when you use the Supplemental Package to deploy Azure Stack HCI. However, in some scenarios you might have to use a specific VLAN ID for management network.

## Deployment workflow

To deploy Azure Stack HCI using non-native VLAN ID for management network, perform these high-level steps:

- [Deploy the Azure Stack HCI operating system on every server in the cluster.](./deployment-tool-install-os.md)
- [Create virtual switch using the required naming convention on every server in the cluster.](#create-virtual-switch-using-the-required-naming-convention)
- [Configure the management virtual network adapter using the required naming convention on every server in the cluster.](#configure-the-management-virtual-network-adapter-using-the-required-naming-convention)
- [Configure the required VLAN ID to the management virtual network adapter on every server in the cluster](#configure-the-required-vlan-id-to-the-management-virtual-network-adapter)
- [Create a deployment configuration file](#create-a-deployment-configuration-file)
- [Deploy Azure Stack HCI using the configuration file](./deployment-tool-existing-file.md)

## Create virtual switch using the required naming convention

Azure Stack HCI with Supplemental Package deployments requires specific naming convention for the virtual switches and virtual network adapters used for the management and compute network traffic types. These requirements are enforced to ensure that post deployment lifecycle management operations can be orchestrated without issues in coordination with the underlying components.

Here's the naming convention to follow for the virtual switch for the management and compute network traffic types:

Name of the virtual switch: `"ConvergedSwitch($Intentname)"`

  where:

  - The name is case sensitive.

  -  `$Intentname` inside parenthesis can be any string you want, preferably describing the purpose of the virtual switch.

  - The list of network adapter names must be the list of physical network
adapters that you plan to use for the management and compute network
traffic types.

  **Example:** To create a new virtual switch that conforms to the required naming convention, run the following command:

  ```powershell
  $IntentName = "MgmtCompute" 
  New-VMSwitch -Name "ConvergedSwitch($IntentName)" -NetAdapterName "NIC1","NIC2" -EnableEmbeddedTeaming $true -AllowManagementOS $true
  ```

## Configure the management virtual network adapter using the required naming convention

After you configure the virtual switch, create the management virtual network adapter. Make sure that the name of the virtual network adapter follows the required naming convention, which the Lifecycle Manager uses.

Here's the naming convention to follow for the virtual network adapter for the management and compute network traffic types:

Name of the virtual network adapter: `"vManagement($Intentname)"`

  where:

  - The name is case sensitive.

  - `$Intentname` inside parenthesis can be any string you want but must match the string used for the virtual switch.

  **Example:** To update the management virtual network adapter name, run the following command:

  ```powershell
  $IntentName = "MgmtCompute" 
  Rename-VMNetworkAdapter -ManagementOS -Name "ConvergedSwitch($IntentName)" -       NewName "vManagement($IntentName)"
  ```

## Configure the required VLAN ID to the management virtual network adapter

After you create the virtual switch and the management virtual network adapter, specify the required VLAN ID to this adapter. Although there are different options to assign a VLAN ID to a virtual network adapter, we support only supported option is to use the `Set-VMNetworkAdapterIsolation` cmdlet.

The following example shows how to configure the management virtual network adapter to use VLAN ID 8 instead of native.

```powershell
Set-VMNetworkAdapterIsolation -ManagementOS -VMNetworkAdapterName "vManagement($IntentName)" -AllowUntaggedTraffic $true -IsolationMode Vlan -DefaultIsolationID 8
```

After you configure the required VLAN ID, you can assign the IP address and gateways to the management virtual network adapter to validate its connectivity with other servers, DNS, Active Directory, and Internet.

## Create a deployment configuration file

After you finish the network configuration in all the servers, create a configuration file to use for your deployment. For information about how to create the configuration file, see [Deploy Azure Stack HCI using an existing configuration file (preview)](deployment-tool-existing-file.md).

The following example shows a snippet of the `HostNetwork` configuration section, where the Management and Compute intent is defined to use the two physical network adapters assigned for these traffics. There is no reference to the management virtual network adapters created in the previous steps because the deployment engine keeps the nodes network configuration untouched, including the VLAN ID.

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