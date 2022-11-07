---
title: Deploy Azure Stack HCI using an existing configuration file (preview) 
description: Learn how to deploy Azure Stack HCI using an existing configuration file (preview).
author: dansisson
ms.topic: how-to
ms.date: 11/07/2022
ms.author: v-dansisson
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Deploy Azure Stack HCI using an existing configuration file (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-supplemental-package.md)]

After you have successfully installed the operating system, you are ready to set up and run the deployment tool. This method of deployment uses a configuration file that you manually create beforehand using a text editor.

The deployment tool wizard uses your file and further provides an interactive, guided experience that helps you deploy and register the cluster.

You can deploy both single-node and multi-node clusters using this procedure.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Prerequisites

Before you begin, make sure you have done the following:

- Satisfy the [prerequisites](deployment-tool-prerequisites.md).
- Complete the [deployment checklist](deployment-tool-checklist.md).
- Prepare your [Active Directory](deployment-tool-active-directory.md) environment.
- [Install version 22H2](deployment-tool-install-os.md) on each server.

## Create the configuration file

Here is a sample configuration file (JSON format) you can modify, save, and use for deployment. One advantage to using your own configuration file is that more settings can be specified than are available when creating a file interactively.

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
                    "Name": "v-cluster",
                    "StaticAddress": [
                        ""
                    ]
                },
                "Storage": {
                    "ConfigurationMode": "Express"
                },
                "OptionalServices": {
                    "VirtualSwitchName": "vSwitch",
                    "CSVPath": "C:\\clusterStorage\\Volume1",
                    "ARBRegion": "eastus"
                },
                "TimeZone": "Pacific Standard Time",
                "NamingPrefix": "HCI002",
                "DomainFQDN": "contoso.com",
                "ExternalDomainFQDN": "contoso.com",
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
                        "Name": "node11",
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
                                "Ethernet",
                                "Ethernet 2"
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
                            "NetworkAdapterName": "Ethernet",
                            "VlanId": 711
                        },
                        {
                            "Name": "Storage2Network",
                            "NetworkAdapterName": "Ethernet 2",
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

## Set up the deployment tool

> [!NOTE]
> You need to install and set up the deployment tool only on the first server in your cluster.

1. In Windows Admin Center, select the first server listed for the cluster to act as a staging server during deployment.

1. Sign in to the staging server using local administrative credentials.

1. Copy content from the *Cloud* folder you downloaded previously to any drive other than the C:\ drive.

1. Run the following command to install the deployment tool:

   ```PowerShell
    .\BootstrapCloudDeploymentTool.ps1 
    ```

    This step takes several minutes to complete.

    > [!NOTE]
    > If you manually extracted deployment content from the ZIP file previously, you must run `BootstrapCloudDeployment-Internal.ps1` instead.

## Run the deployment tool

You deploy single-node and multi-node clusters similarly using the interactive flow in Windows Admin Center.

> [!NOTE]
> You need to install and set up the deployment tool only on the first server in the cluster.

1. Open a web browser from a computer that has network connectivity to the first (staging_ server.

1. In the URL field, enter *https://your_staging-server-IP-address*.

1. Accept the security warning displayed by your browser - this is shown because we’re using a self-signed certificate.

1. Authenticate using the local administrator credentials of your staging server.

1. In Windows Admin Center, on the **Get started deploying Azure Stack** page, select **Use an existing config file**, then select either **One server** or **Multiple servers** as applicable for your deployment.

      :::image type="content" source="media/deployment-tool/config-file/deploy-existing-get-started.png" alt-text="Screenshot of the Deployment Get Started page." lightbox="media/deployment-tool/config-file/deploy-existing-get-started.png":::

1. On step **1.1 Import configuration file**, import the existing configuration file you created by selecting **Browse** or dragging the file to the page.

    :::image type="content" source="media/deployment-tool/config-file/deploy-existing-step-1-import.png" alt-text="Screenshot of the Deployment step 1.1 import file page." lightbox="media/deployment-tool/config-file/deploy-existing-step-1-import.png":::

1. On step **1.2 Provide registration details**, enter the following details to authenticate your cluster with Azure:

    :::image type="content" source="media/deployment-tool/config-file/deploy-existing-step-1-registration-details.png" alt-text="Screenshot of the Deployment step 1.2 registration details page." lightbox="media/deployment-tool/config-file/deploy-existing-step-1-registration-details.png":::

    1. Select the **Azure Cloud** to be used. In this release, only Azure public cloud is supported.
    
    1. Copy the authentication code.
    
    1. Select **login**. A new browser window opens. Enter the code that you copied earlier and then provide your Azure credentials. Multi-factor authentication (MFA) is supported.

    1. Go back to the deployment screen and provide the Azure registration details.

    1. From the dropdown, select the **Azure Active Directory ID** or the tenant ID.

    1. Select the associated subscription. This subscription is used to create the cluster resource, register it with Azure Arc and set up billing.

        > [!NOTE]
        > Make sure that you are a [user access administrator](/azure/role-based-access-control/built-in-roles#user-access-administrator) on this subscription. This will allow you to manage access to Azure resources, specifically to Arc-enable each server of an Azure Stack HCI cluster.

    1. Select an existing **Azure resource group** from the dropdown to associate with the cluster resource. To create a new resource group, leave the field empty.

    1. Select an **Azure region** from the dropdown or leave the field empty to use the default.import the existing configuration file you created by selecting **Browse** or dragging the file to the page.

1. On step **1.3 Review deployment setting**, review the settings stored in the configuration file.

    :::image type="content" source="media/deployment-tool/config-file/deploy-existing-step-1-review.png" alt-text="Screenshot of the Deployment step 1.3 review settings page." lightbox="media/deployment-tool/config-file/deploy-existing-step-1-review.png":::

1. On step **2.1 Credentials**, enter the username and password for the Active Directory account and username and password for the local administrator account.

    When specifying a username, omit the domain name (don't use *domain\username*). The *Administrator* username isn't supported.

    :::image type="content" source="media/deployment-tool/config-file/deploy-existing-step-2-credentials.png" alt-text="Screenshot of the Deployment step 2.1 page." lightbox="media/deployment-tool/config-file/deploy-existing-step-2-credentials.png":::

    > [!NOTE]
    > Credentials are never collected or stored in the configuration file.

1. On step **3.1 Deploy the cluster**, select **Deploy** to start deployment of your cluster.

    :::image type="content" source="media/deployment-tool/config-file/deploy-existing-step-3-deploy.png" alt-text="Screenshot of the Deploy cluster page." lightbox="media/deployment-tool/config-file/deploy-existing-step-3-deploy.png":::

1. It can take up to 1.5 hours for the deployment to complete. You can monitor your deployment progress and the details in near real-time.

    :::image type="content" source="media/deployment-tool/config-file/deployment-progress.png" alt-text="Screenshot of the Monitor deployment page." lightbox="media/deployment-tool/config-file/deployment-progress.png":::

## Next steps

- [Validate deployment](deployment-tool-validate.md).
- If needed, [troubleshoot deployment](deployment-tool-troubleshoot.md).
