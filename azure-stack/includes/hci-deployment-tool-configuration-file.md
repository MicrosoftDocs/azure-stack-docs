---
author: ManikaDhiman
ms.author: v-mandhiman
ms.service: azure-stack
ms.topic: include
ms.date: 06/20/2023
ms.subservice: azure-stack-hci
ms.reviewer: alkohli
ms.lastreviewed: 12/05/2022
---

Here's a sample configuration file (JSON format) you can modify, save, and use for deployment. One advantage to using your own configuration file is that more settings can be specified than are available when creating a file interactively. For descriptions of each setting, see the reference section later in this article.

```json
{
    "Version": "10.0.0.0",
    "ScaleUnits": [
        {
            "DeploymentData": {
                "SecuritySettings": {
                    "HVCIProtection": true,
                    "DRTMProtection": true,
                    "DriftControlEnforced": true,
                    "CredentialGuardEnforced": true,
                    "SMBSigningEnforced": true,
                    "SMBClusterEncryption": false,
                    "SideChannelMitigationEnforced": true,
                    "BitlockerBootVolume": true,
                    "BitlockerDataVolumes": true,
                    "WDACEnforced": true
                },
                "Observability": {
                    "StreamingDataClient": true,
                    "EULocation": false,
                    "EpisodicDataUpload": true
                },
                "Cluster": {
                    "Name": "ms169154cluster",
                    "WitnessType": "Cloud",
                    "WitnessPath": "",
                    "CloudAccountName": "myasestoragacct",
                    "AzureServiceEndpoint": "core.windows.net"
                },
                "Storage": {
                    "ConfigurationMode": "Express"
                },
                "NamingPrefix": "ms169",
                "DomainFQDN": "ASZ1PLab8.nttest.microsoft.com",
                "InfrastructureNetwork": [
                    {
                        "VlanId": "0",
                        "SubnetMask": "255.255.248.0",
                        "Gateway": "10.57.48.1",
                        "IPPools": [
                            {
                                "StartingAddress": "10.57.48.60",
                                "EndingAddress": "10.57.48.66"
                            }
                        ],
                        "DNSServers": [
                            "10.57.50.90"
                        ]
                    }
                ],
                "PhysicalNodes": [
                    {
                        "Name": "ms169host",
                        "IPv4Address": "10.57.51.224"
                    },
                    {
                        "Name": "ms154host",
                        "IPv4Address": "10.57.53.236"
                    }
                ],
                "HostNetwork": {
                    "Intents": [
                        {
                            "Name": "Compute_Management",
                            "TrafficType": [
                                "Compute",
                                "Management"
                            ],
                            "Adapter": [
                                "Port2"
                            ],
                            "OverrideVirtualSwitchConfiguration": false,
                            "VirtualSwitchConfigurationOverrides": {
                                "EnableIov": "",
                                "LoadBalancingAlgorithm": ""
                            },
                            "OverrideQoSPolicy": false,
                            "QoSPolicyOverrides": {
                                "PriorityValue8021Action_Cluster": "",
                                "PriorityValue8021Action_SMB": "",
                                "BandwidthPercentage_SMB": ""
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
                                "Port3",
                                "Port4"
                            ],
                            "OverrideVirtualSwitchConfiguration": false,
                            "VirtualSwitchConfigurationOverrides": {
                                "EnableIov": "",
                                "LoadBalancingAlgorithm": ""
                            },
                            "OverrideQoSPolicy": false,
                            "QoSPolicyOverrides": {
                                "PriorityValue8021Action_Cluster": "",
                                "PriorityValue8021Action_SMB": "",
                                "BandwidthPercentage_SMB": ""
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
                            "Name": "Storage1Network",
                            "NetworkAdapterName": "Port3",
                            "VlanId": 5
                        },
                        {
                            "Name": "Storage2Network",
                            "NetworkAdapterName": "Port4",
                            "VlanId": 5
                        }
                    ]
                },
                "ADOUPath": "OU=ms169,DC=ASZ1PLab8,DC=nttest,DC=microsoft,DC=com"
            }
        }
    ]
}
```