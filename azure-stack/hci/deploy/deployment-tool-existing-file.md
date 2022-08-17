---
title: Deploy Azure Stack HCI version 22H2 (preview) using a configuration file
description: Learn how to deploy Azure Stack HCI version 22H2 (preview) using an existing configuration file
author: dansisson
ms.topic: how-to
ms.date: 08/23/2022
ms.author: v-dansisson
ms.reviewer: jgerend
---

# Deploy Azure Stack HCI version 22H2 (preview) using a configuration file

> Applies to: Azure Stack HCI, version 22H2 (preview)

This article discusses how to run the deployment tool using a configuration file you create.

This article assumes that you have already installed the Azure Stack HCI version 22H2 OS and have [set up the deployment tool](deployment-tool-new-file.md) previously.

> [!NOTE]
> Deploying a single-node cluster can only be done [using PowerShell](deployment-tool-powershell.md) or using an existing configuration file in this preview release.

## Create the configuration file

Here is a sample configuration file (JSON format) you can modify, save, and use for deployment. One advantage to using your own configuration file is that more settings can be specified than are available when creating a file on the fly in Windows Admin Center.

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
                        "Name": "your_Server1"
                    },
                    {
                        "Name": "your_Server2"
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
                    "CSVPath": "C:\\clusterStorage|\\Volume1",
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

## Run the deployment tool

The deployment tool "hooks" into, and appears as additional pages in Windows Admin Center. This procedure uses a configuration file that you manually create.

1. Open a web browser from a computer that has network connectivity to the staging server.

1. In the URL field, enter *https://your_staging-server-IP-address*.

1. Accept the security warning displayed by your browser - this is shown because we’re using a self-signed certificate.

1. Authenticate using the local administrator credentials of your first (staging)server.

1. In Windows Admin Center, on the **Get started deploying Azure Stack** page, select **Use an existing config file**, then select either **One server** or **Multiple servers**.

      :::image type="content" source="media/deployment-tool/deployment-get-started.png" alt-text="Deployment Get Started page" lightbox="media/deployment-tool/deployment-get-started.png":::

1. On step **1.1 Import configuration file**, import the existing configuration by selecting **Browse** or dragging the file to the page.

    :::image type="content" source="media/deployment-tool/deployment-wizard-2e.png" alt-text="Deployment step 1.1" lightbox="media/deployment-tool/deployment-wizard-2e.png":::

1. On step **1.2 Review deployment setting**, review the settings stored in the configuration file.

    :::image type="content" source="media/deployment-tool/deployment-wizard-3e.png" alt-text="Deployment step 1.2" lightbox="media/deployment-tool/deployment-wizard-3e.png":::

1. On step **2.1 Credentials**, enter the credentials for the internal directory service and the local administrator credentials.
When specifying a username, omit the domain name (don't use *domain\username*). The *Administrator* username isn't supported.

    :::image type="content" source="media/deployment-tool/file-deployment-step-2.1-credentials.png" alt-text="Deployment step 2.1" lightbox="media/deployment-tool/file-deployment-step-2.1-credentials.png":::

    > [!NOTE]
    > Credentials are never collected or stored in the configuration file.

1. When completed, click **Deploy** to start deployment of your cluster.

    :::image type="content" source="media/deployment-tool/file-deployment-step-3.1-deploy-cluster.png" alt-text="Deploy cluster page" lightbox="media/deployment-tool/file-deployment-step-3.1-deploy-cluster.png":::

1. It can take up to 3 hours for deployment to complete. To monitor your deployment, log in to the first (staging) server and watch the orchestration engine process. Due to a known issue, you must monitor the deployment progress using the deployment log file stored in *C:\clouddeployment\logs* until the staging server restarts.

    :::image type="content" source="media/deployment-tool/deployment-monitoring.png" alt-text="Monitor deployment" lightbox="media/deployment-tool/deployment-monitoring.png":::

## Post deployment

After deployment has completed, remove the Windows Admin Center instance used by the deployment tool. Log in to the staging server and run the following command:

```powershell
Get-CimInstance -ClassName Win32_Product|Where-object {$_name -like “Windows Admin Center”}| Invoke-CimMethod -MethodName Uninstall
```

## Next step

If needed, [troubleshoot deployment](deployment-tool-troubleshooting.md).