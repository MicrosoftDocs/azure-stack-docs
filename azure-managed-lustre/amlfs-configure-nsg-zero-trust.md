---
title: Configure network security groups for Azure Managed Lustre file systems in a zero-trust environment
description: Configure network security group rules to allow Azure Managed Lustre file system support in a zero-trust virtual network. 
ms.topic: how-to
ms.date: 10/16/2023
author: pauljewellmsft
ms.author: pauljewell
ms.reviewer: mayabishop

---

# Configure a network security group for Azure Managed Lustre file systems in a zero-trust environment

This article describes how to configure network security group (NSG) rules to secure access to an Azure Managed Lustre file system (AMLFS) cluster in a zero-trust environment.

## Prerequisites

- An Azure subscription. If you don't have an Azure subscription, [create a free account](https://azure.microsoft.com/free/) before you begin.
- A virtual network with a subnet that's configured to allow Azure Managed Lustre file system support. To learn more, see [Networking prerequisites](amlfs-prerequisites.md#network-prerequisites).
- An Azure Managed Lustre file system deployed in your Azure subscription. To learn more, see [Create an Azure Managed Lustre file system](create-file-system-portal.md).

## Create a network security group (NSG)



## Configure network security group rules

To configure network security group rules for Azure Managed Lustre file system support, add the following inbound and outbound security rules to the NSG that's associated with the subnet where you deployed your AMLFS cluster.

> [!NOTE]
> The security rules shown in this section are configured based on an AMLFS cluster deployment in East US region, with Blob Storage integration enabled. You might need to adjust the rules based on your deployment region and other configuration settings for the AMLFS cluster.

### Create inbound security rules

You can create inbound security rules in the Azure portal. The following example shows how to create and configure a new inbound security rule:

1. In the Azure portal, open the NSG resource you created in the previous step.
1. Select **Inbound security rules** under **Settings**.
1. Select **+ Add**.
1. In the **Add inbound security rule** pane, configure the settings for the rule. The following example shows how to configure a rule to allow inbound traffic from the AMLFS cluster subnet to the Lustre client subnet. The rule allows only source TCP ports 1020-1023 and destination port 988.

    ![Inbound security rule](media/amlfs-configure-nsg-zero-trust/inbound-rule.png)

Add the following inbound rules to the NSG:

| Priority | Name | Port | Protocol | Source | Destination | Action | Description |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 110 | AllowCidrBlockCustomAnyInbound | Any | Any | 10.0.2.0/24 | 10.0.2.0/24 | Allow | Permit protocol or port flows between hosts on the AMLFS cluster subnet 10.0.2.0/24. |
| 111 | AllowLustre988Inbound | 988 | TCP | 10.0.3.0/24 | 10.0.2.0/24 | Allow | Permit communication between the Lustre client subnet and the AMLFS cluster subnet. Allows only source TCP ports 1020-1023 and destination port 988. |
| 112 | AllowTagCustomAnyInbound | Any | TCP | AzureMonitor | VirtualNetwork | Allow | Permit inbound flows from the AzureMonitor service tag. Allow TCP source port 443 only. |
| 120 | DenyAnyCustomAnyInbound | Any | Any | Any | Any | Deny | Deny all other inbound flows. |

Add the following outbound rules to the NSG:

| Priority | Name | Port | Protocol | Source | Destination | Action | Description |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 100 | AllowAnyCustomAnyOutbound | 443 | TCP | VirtualNetwork | AzureMonitor | Allow | Permit outbound flows to the AzureMonitor service tag. TCP destination port 443 only. |
| 101 | AllowTagCustomAnyOutbound | 443 | TCP | VirtualNetwork | AzureKeyVault.EastUS | Allow | Permit outbound flows to the AzureKeyVault.EastUS service tag. TCP destination port 443 only. |
| 102 | AllowADCustomAnyOutbound | 443 | TCP | VirtualNetwork | AzureActiveDirectory | Allow | Permit outbound flows to the AzureActiveDirectory service tag. TCP destination port 443 only. |
| 103 | AllowTagStorageCustomAnyOutbound | 443 | TCP | VirtualNetwork | Storage.EastUS | Allow | Permit outbound flows to the Storage.EastUS service tag. TCP destination port 443 only. |
| 104 | AllowTagGuestMgmtCustomAnyOutbound | 443 | TCP | VirtualNetwork | GuestAndHybridManagement | Allow | Permits outbound flows to the GuestAndHybridManagement service tag. TCP destination port 443 only. |
| 105 | AllowTagApiMgmtCustomAnyOutbound | 443 | TCP | VirtualNetwork | ApiManagement.EastUS | Allow | Permit outbound flows to the ApiManagement.EastUS service tag. TCP destination port 443 only. |
| 106 | AllowTagDataLakeCustomAnyOutbound | 443 | TCP | VirtualNetwork | AzureDataLake | Allow | Permit outbound flows to the AzureDataLake service tag. TCP destination port 443 only. |
| 107 | AllowTagResourceMgmtCustomAnyOutbound | 443 | TCP | VirtualNetwork | AzureResourceManager | Allow | Permits outbound flows to the AzureResourceManager service tag. TCP destination port 443 only. |
| 108 | AllowLustre1020-1023Outbound | 1020-1023 | TCP | 10.0.2.0/24 | 10.0.3.0/24 | Allow | Permit outbound flows for AMLFS cluster to Lustre client. TCP source port 988, destination ports 1020-1023 only. |
| 109 | AllowCidrBlockCustom123Outbound | 123 | UDP | 10.0.2.0/24 | 168.61.215.74/32 | Allow | Permit outbound flows to MS NTP server (168.61.215.74). UDP destination port 123 only. |
| 110 | AllowTelemetryOutbound | 443 | TCP | VirtualNetwork | 20.34.120.0/21 | Allow | Permit outbound flows to AMLFS Telemetry (20.45.120.0/21). TCP destination port 443 only. |
| 111 | AllowCidrBlockCustomAnyOutbound | Any | Any | 10.0.2.0/24 | 10.0.2.0/24 | Allow | Permit protocol or port flows between hosts on the AMLFS cluster subnet 10.0.2.0/24. |
| 1000 | DenyTagCustom8080Outbound | Any | Any | VirtualNetwork | Internet | Deny | Deny outbound flows to the internet. |
| 1010 | DenyAnyCustomAnyOutbound | Any | Any | Any | Any | Deny | Deny all other outbound flows. |

The following screenshot shows the NSG rules in the Azure portal:



## Next steps
