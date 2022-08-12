---
title: Deploy Azure Stack HCI version 22H2 using an existing configuration file
description: Learn how to deploy Azure Stack HCI version 22H2 using an existing configuration file
author: dansisson
ms.topic: how-to
ms.date: 08/23/2022
ms.author: jgerend
ms.reviewer: jgerend
---

# Deploy Azure Stack HCI version 22H2 using an existing configuration file (preview)

> Applies to: Azure Stack HCI, version 22H2 (preview)

This article discusses how to run the deployment tool using a configuration file you have created using the sample configuration file as a template.

This article assumes that you have already installed the Azure Stack HCI version 22H2 OS and have [set up the deployment tool](deployment-tool-new-file.md) previously.

> [!NOTE]
> Deploying a single-node cluster can only be done [using PowerShell](deployment-tool-powershell.md) or using an existing configuration file in this preview release.

## Create the configuration file

Here is a sample configuration file (JSON format) you can modify and use for deployment:

```json
{
    "Version": "2.0.0.0",
    "ScaleUnits": [
        {
            "DeploymentData": {
                "DomainFQDN": "contoso.com",
                "SecuritySettings": {
                    "SecurityModeSealed": true,
                    "WDACEnforced": true

                },
                "InternalDomainConfiguration": {
                    "InternalDomainName": "contoso.com",
                    "Timeserver": "10.10.240.20",
                    "DNSForwarder": "10.10.240.23"
                },
                "Observability": {
                    "StreamingDataClient": true,
                    "EULocation": false,
                    "EpisodicDataUpload": true
                },
                "Cluster": {
                    "Name": "s-cluster",
                    "StaticAddress": [""]
                },
                "Storage": {
                    "ConfigurationMode": "Express"
                },
                "TimeZone": "Pacific Standard Time",
                "DNSForwarder": ["10.10.240.23"],
                "TimeServer": "10.10.240.20",
                "InfrastructureNetwork": {
                    "VlanId": [8],
                    "Subnet": ["100.101.165.0/24"],
                    "Gateway": "100.101.165.1",
                    "StartingAddress": "",
                    "EndingAddress": ""
                },
                "PhysicalNodes": [
                    {
                        "Name": "asb88rr10u09"
                    },
                    {
                        "Name": "asb88rr10u11"
                    }
                ],
                "HostNetwork": {
                    "Intents": [
                        {
                            "Name": "Compute_Storage_Management",
                            "TrafficType": [
                                "Compute",
                                "Storage",
                                "Management"
                            ],
                            "Adapter": [
                                "NIC1",
                                "NIC2"
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
                                "BandwidthPercentage_SMB": "",
                                "BandwidthPercentage_Cluster": ""
                            },
                            "OverrideAdapterProperty": false,
                            "AdapterPropertyOverrides": {
                                "EncapOverhead": "",
                                "VlanID": "",
                                "JumboPacket": "",
                                "NetworkDirectTechnology": ""
                            }
                        }
                    ]
                },
                "SDNIntegration": {
                    "Enabled": true,
                    "NetworkControllerName": "nc",
                    "MacAddressPoolStart": "06-EC-00-00-00-01",
                    "MacAddressPoolStop": "06-EC-00-00-FF-FF"
                },
                "OptionalServices": {
                    "VirtualSwitchName": "vSwitch",
                    "CSVPath": "C:\\clusterStorage\\Volume1",
                    "ARBRegion": "eastus"
                },
                "CompanyName": "Microsoft",
                "RegionName": "Redmond",
                "ExternalDomainFQDN": "ext-contoso.com",
                "NamingPrefix": "iastack",
                "Storage1Network": {
                    "VlanId": [108],
                    "Subnet": ["100.73.16.0/25"]
                },
                "Storage2Network": {
                    "VlanId": [208],
                    "Subnet": ["100.73.21.0/25"]
                }
            }
        }
    ]
}
```

## Run deployment in Windows Admin Center

The deployment tool "hooks" into, and appears as additional pages and screens in Windows Admin Center. This procedure uses the configuration file that you have manually created.

1. Open a web browser from a computer that has network connectivity to the staging server.

1. In the URL field, enter *https://* followed by the IP address of your staging server.

1. Accept the security warning displayed by your browser - this is shown because we’re using a self-signed certificate.

1. Authenticate using the local administrator credentials of your staging server.

1. In Windows Admin Center, on the **Get started deploying Azure Stack** page, select **Use an existing config file** to deploy with an existing file.

    :::image type="content" source="media/deployment-tool/create-cluster-atc-verify-adaptor.png" alt-text="Create cluster wizard - Verify network adapters" lightbox="media/cluster/create-cluster-atc-verify-adaptor.png":::

1. On step **1.1 Import configuration file**, import the existing configuration by selecting **Browse** or dragging the file to the page.

    :::image type="content" source="media/deployment-tool/create-cluster-atc-verify-adaptor.png" alt-text="Create cluster wizard - Verify network adapters" lightbox="media/cluster/create-cluster-atc-verify-adaptor.png":::

1. On step **1.2 Review deployment setting**, review the settings stored in the configuration file.

    :::image type="content" source="media/deployment-tool/create-cluster-atc-verify-adaptor.png" alt-text="Create cluster wizard - Verify network adapters" lightbox="media/cluster/create-cluster-atc-verify-adaptor.png":::

1. On step **2.1 Credentials**, enter the credentials for the internal directory service and the local administrator credentials.
When specifying a username, omit the domain name (don't use *domain\username*). The "Administrator" username isn't supported.

    :::image type="content" source="media/deployment-tool/create-cluster-atc-verify-adaptor.png" alt-text="Create cluster wizard - Verify network adapters" lightbox="media/cluster/create-cluster-atc-verify-adaptor.png":::

    > [!NOTE]
    > Credentials should never be stored in the configuration file.

1. To monitor your deployment, log in to the staging server and watch the orchestration engine process. Due to a known issue, you must monitor the deployment progress using the deployment log file stored in C:\clouddeployment\logs until the staging server restarts.

    :::image type="content" source="media/deployment-tool/monitor-deployment.png" alt-text="Deployment wizard step" lightbox="media/deployment-tool/deployment-wizard-1.png":::

1. Remove the Windows Admin Center installation used for deployment. Sign in to the staging server and run the following command:

    ```powershell
    Get-CimInstance -ClassName Win32_Product|Where-object {$_name -like “Windows Admin Center”}| Invoke-CimMethod -MethodName Uninstall
    ```

Congratulations, you have deployed Azure Stack HCI, version 22H2 preview 3!

## Next step

If needed, [troubleshoot deployment](deployment-tool-troubleshooting.md).