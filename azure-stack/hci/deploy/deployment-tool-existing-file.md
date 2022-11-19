---
title: Deploy Azure Stack HCI using an existing configuration file (preview) 
description: Learn how to deploy Azure Stack HCI using an existing configuration file (preview).
author: dansisson
ms.topic: how-to
ms.date: 11/17/2022
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

Here is a sample configuration file (JSON format) you can modify, save, and use for deployment. One advantage to using your own configuration file is that more settings can be specified than are available when creating a file interactively. For descriptions of each setting, see the reference section below.

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

1. Open a web browser from a computer that has network connectivity to the first server also known as the staging server.

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

## Reference: Configuration file settings

The following table gives descriptions for the settings listed in the configuration file:

|Setting|Description|
|---|---|
|**SecuritySettings**|Section name|
|SecurityModeSealed|This parameter should only be modified based on your OEM guidance. Do not modify this parameter without OEM validation.|
|SecuredCoreEnforced|This parameter should only be modified based on your OEM guidance. Do not modify this parameter without OEM validation.|
|VBSProtection|By default, Virtualization-based Security (VBS) is enabled on your Azure Stack HCI cluster. For more information, see [Virtualization-based Security](/windows-hardware/design/device-experiences/oem-vbs).|
|HVCIProtection|By default, Hypervisor-protected Code Integrity (HVCI) is enabled on your Azure HCI cluster. For more information, see [Hypervisor-protected Code Integrity](/windows-hardware/design/device-experiences/oem-hvci-enablement).|
|DRTMProtection|By default, Secure Boot is enabled on your Azure HCI cluster. This setting is hardware dependent. For more information, see [Secure Boot with Dynamic Root of Trust for Measurement (DRTM)](/windows-server/security/secured-core-server#2-advanced-protection).|
|KernelDMAProtection|By default, Pre-boot Kernel Direct Memory Access (DMA) protection is enabled on your Azure HCI cluster. This setting is hardware dependent. For more information, see [Kernel Direct Memory Access protection](/windows-server/security/secured-core-server#2-advanced-protection).|
|DriftControlEnforced|When set to `true`, the security baseline is re-applied regularly. For more information, see [Security baseline settings for Azure Stack HCI](../concepts/secure-baseline.md)|
|CredentialGuardEnforced|When set to `true`, Credential Guard is enabled.|
|SMBSigningEnforced|When set to `true`, the SMB default instance requires sign in for the client and server services. For more information, see [Overview of Server Message Block signing](/troubleshoot/windows-server/networking/overview-server-message-block-signing).|
|SMBClusterEncryption|When set to `true`, cluster east-west traffic is encrypted. For more information, see [SMB encryption](/windows-server/storage/file-server/smb-security#smb-encryption).|
|SideChannelMitigationEnforced|When set to `true`, all the side channel mitigations are enabled.|
|BitLockerBootVolume|When set to `true`, BitLocker XTS_AES 256-bit encryption is enabled for all data-at-rest on the OS volume of your Azure Stack HCI cluster. This setting is TPM-hardware dependent. For more information, see [BitLocker encryption for Azure Stack HCI](../concepts/security-bitlocker.md).|
|BitLockerDataVolumes|When set to `true`, BitLocker XTS-AES 256-bit encryption is enabled for all data-at-rest on your Azure Stack HCI cluster shared volumes. For more information, see [BitLocker encryption for Azure Stack HCI](../concepts/security-bitlocker.md).|
|SEDProtectionEnforced|Not used for Azure Stack HCI version 22H2.|
|WDACEnforced|Windows Defender Application Control (WDAC) is enabled by default and limits the applications and the code that you can run on your Azure Stack HCI cluster. For more information, see [Windows Defender Application Control](../concepts/security-windows-defender-application-control.md).|
|**Observability**|Section name|
|StreamingDataClient|Enables telemetry data to be sent to Microsoft.|
|EULocation|Location of your cluster. The log and diagnostic data is sent to the appropriate diagnostics servers depending upon where your cluster resides. Setting this to `false` results in all data sent to Microsoft to be stored outside of the EU.|
|EpisodicDataUpload|When set to `true`, collects log data to facilitate quicker issue resolution.|
|**Cluster**|Section name|
|Name|The cluster name provided when preparing Active Directory.|
|StaticAddress| This value is not used during deployment and will be removed in future releases.|
|**Storage**|Section name|
|ConfigurationMode|By default, this mode is set to `Express` and your storage is configured as per best practices based on the number of nodes in the cluster. For more information, see step [4. 1 Set up cluster storage in Deploy Azure Stack HCI interactively](deployment-tool-new-file.md).|
|**OptionalServices**|Section name|
|VirtualSwitchName| This value is not used during deployment and will be removed in future releases.|
|CSVPath| This value is not used during deployment and will be removed in future releases.|
|ARBRegion| This value is not used during deployment and will be removed in future releases.|
|**ActiveDirectorySettings**|Section name|
|NamingPrefix|The prefix used for all AD objects created for the Azure Stack HCI deployment. The prefix must not exceed eight characters.|
|DomainFQDN|The fully qualified domain name (FQDN) for the Active Directory domain used by your cluster.|
|ExternalDomainFQDN| This value is not used during deployment and will be removed in future releases.|
|ADOUPath|The path to the Active Directory Organizational Unit (ADOU) container object prepared for the deployment. Format must be that for a distinguished name (including domain components). For example: "OU=OUName,DC=contoso,DC=com".|
|DNSForwarder|Name of the server used to forward DNS queries for external DNS names. This value is not used during deployment and will be removed in future releases.|
|**InfrastructureNetwork**|Section name|
|VlanId|Only supported value in version 2210 is `0`.|
|SubnetMask|Subnet mask that matches the provided IP address space.|
|Gateway|Default gateway that should be used for the provided IP address space.|
|IPPools|Range of IP addresses from which addresses are allocated for nodes within a subnet.|
|StartingAddress|Starting IP address for the management network. A minimum of six free, contiguous IPv4 addresses (excluding your host IPs) are needed for infrastructure services such as clustering.|
|EndingAddress|Ending IP address for the management network. A minimum of six free, contiguous IPv4 addresses (excluding your host IPs) are needed for infrastructure services such as clustering.|
|DNSServers| IPv4 address of the DNS servers in your environment. DNS servers are required as they're used when your server attempts to communicate with Azure or to resolve your server by name in your network. The DNS server you configure must be able to resolve the Active Directory domain.|
|**PhysicalNodes**|Section name|
|Name|Name of each physical server on your Azure Stack HCI cluster.|
|IPv4Address|The IPv4 address assigned to each physical server on your Azure Stack HCI cluster.|
|**HostNetwork**|Section name|
|Intents|The network intents assigned to the network reference pattern used for the deployment. Each intent will define its own name, traffic type, adapter names, and overrides as recommended by your OEM.|
|Name|Name of the network intent you wish to create.|
|TrafficType|Type of network traffic. Examples include compute, storage, and management traffic.|
|Adapter|Array of network interfaces used for the network intent.|
|OverrideVirtualSwitchConfigurationOverrides|This parameter should only be modified based on your OEM guidance. Do not modify this parameter without OEM validation.|
|OverrideQoSPolicy|This parameter should only be modified based on your OEM guidance. Do not modify this parameter without OEM validation.|
|QoSPolicyOverrides|List of QoS policy overrides as specified by your OEM. Do not modify this parameter without OEM validation.|
|PriorityValue8021Action_Cluster|This parameter should only be modified based on your OEM guidance. Do not modify this parameter without OEM validation.|
|PriorityValue8021Action_SMB|This parameter should only be modified based on your OEM guidance. Do not modify this parameter without OEM validation.|
|BandwidthPercentage_SMB|This parameter should only be modified based on your OEM guidance. Do not modify this parameter without OEM validation.|
|OverrideAdapterProperty|This parameter should only be modified based on your OEM guidance. Do not modify this parameter without OEM validation.|
|AdapterPropertyOverrides|List of adapter property overrides as specified by your OEM. Do not modify this parameter without OEM validation.|
|JumboPacket|This parameter should only be modified based on your OEM guidance. Do not modify this parameter without OEM validation.|
|NetworkDirect|This parameter should only be modified based on your OEM guidance. Do not modify this parameter without OEM validation.|
|NetworkDirectTechnology|This parameter should only be modified based on your OEM guidance. Do not modify this parameter without OEM validation.|
|**StorageNetworks**|Section name|
|Name|Name of the storage network.|
|NetworkAdapterName|Name of the storage network adapter.|
|VlanID|ID specified for the VLAN storage network. This setting is applied to the network interfaces that route the storage and VM migration traffic. Network ATC uses VLANs 711 and 712 for the first two storage networks. Additional storage networks will use the next VLAN ID on the sequence.|

## Next steps

- [Validate deployment](deployment-tool-validate.md).
- If needed, [troubleshoot deployment](deployment-tool-troubleshoot.md).
