---
author: ManikaDhiman
ms.author: v-mandhiman
ms.service: azure-stack
ms.topic: include
ms.date: 02/08/2023
ms.subservice: azure-stack-hci
ms.reviewer: alkohli
ms.lastreviewed: 12/05/2022
---

Here's a sample configuration file (JSON format) you can modify, save, and use for deployment. One advantage to using your own configuration file is that more settings can be specified than are available when creating a file interactively. For descriptions of each setting, see the reference section later in this article.

```json
{
    "Version": "3.0.0.0",
    "ScaleUnits": [
        {
            "DeploymentData": {
                "SecuritySettings": {
                    "SecurityModeSealed": true,
                    "SecuredCoreEnforced": true,
                    "VBSProtection": true,
                    "HVCIProtection": true,
                    "DRTMProtection": true,
                    "KernelDMAProtection": true,
                    "DriftControlEnforced": true,
                    "CredentialGuardEnforced": false,
                    "SMBSigningEnforced": true,
                    "SMBClusterEncryption": false,
                    "SideChannelMitigationEnforced": true,
                    "BitlockerBootVolume": true,
                    "BitlockerDataVolumes": true,
                    "SEDProtectionEnforced": true,
                    "WDACEnforced": true
                },
                "Observability": {
                    "StreamingDataClient": true,
                    "EULocation": false,
                    "EpisodicDataUpload": true
                },
                "Cluster": {
                    "Name": "cluster_name",
                    "StaticAddress": [
                        ""
                    ]
                },
                "Storage": {
                    "ConfigurationMode": "Express"
                },
                "OptionalServices": {
                    "VirtualSwitchName": "",
                    "CSVPath": "",
                    "ARBRegion": ""
                },
                "NamingPrefix": "HCI002",
                "DomainFQDN": "contoso.com",
                "ExternalDomainFQDN": "",
                "InfrastructureNetwork": [
                    {
                        "VlanId": "0",
                        "SubnetMask": "255.255.255.0",
                        "Gateway": "10.0.50.1",
                        "IPPools": [
                            {
                                "StartingAddress": "10.0.50.52",
                                "EndingAddress": "10.0.50.59"
                            }
                        ],
                        "DNSServers": [
                            "10.0.50.10"
                        ]
                    }
                ],
                "PhysicalNodes": [
                    {
                        "Name": "node1_name",
                        "IPv4Address": "10.0.50.51"
                    }
                ],
                "HostNetwork": {
                    "Intents": [
                        {
                            "Name": "Compute_Management_Storage",
                            "TrafficType": [
                                "Compute",
                                "Management",
                                "Storage"
                            ],
                            "Adapter": [
                                "Ethernet_Name",
                                "Ethernet2_Name"
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
                            "Name": "Storage1_Network_Name",
                            "NetworkAdapterName": "Ethernet_Adapter",
                            "VlanId": 711
                        },
                        {
                            "Name": "Storage2_Network_Name",
                            "NetworkAdapterName": "Ethernet2_Adapter",
                            "VlanId": 712
                        }
                    ]
                },
                "ADOUPath": "OU=HCI002,DC=contoso,DC=com",
                "DNSForwarder": [
                    "10.0.50.10"
                ]
            }
        }
    ]
}
```