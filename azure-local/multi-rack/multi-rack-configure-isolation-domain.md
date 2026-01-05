---
title: Manage L3 Isolation Domains for Azure Local Multi-rack Deployments (preview)
description: Learn how to manage L3 isolation domains for Azure Local multi-rack deployments (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 12/18/2025
---

# Manage L3 isolation domains for Azure Local multi-rack deployments (preview)

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article describes how to create, modify, or delete Layer 3 (L3) isolation domains for Azure Local multi-rack deployments.

Isolation domains enable network connectivity between workloads hosted in the same rack (intra-rack communication) or different racks (inter-rack communication) as well as with endpoints external to Azure Local. You can create, update, delete, and check the status of your L3 isolation domains by using the Azure Command-Line Interface (CLI).

## Prerequisites 

- Create the Network Fabric Controller (NFC) and the network fabric. 

- Install the latest version of the [Azure CLI extensions](/azure/operator-nexus/howto-install-cli-extensions).

- Use VLAN values between 501 and 4095. Azure Local reserves VLAN values less than or equal to 500 for platform use, so you can't use VLANs in this range for your workload networks.

- Register the managed fabric providers: 
    1. Use the following command to sign in to your Azure account and set the subscription to your Azure subscription ID. Use the same subscription ID for all the resources in your network fabric and cluster. 

        ```azurecli
            az login 
            az account set --subscription <subscription>
        ```

    1. Register providers for a managed network fabric: 

        1. In Azure CLI, enter the command:

            ```azurecli
                az provider register --namespace Microsoft.ManagedNetworkFabric
            ```

        1. Monitor the registration process by using the command:

            ```azurecli
                az provider show -n Microsoft.ManagedNetworkFabric -o table
              ```

            Registration can take up to 10 minutes. When it's finished, the `RegistrationState` in the output changes to `Registered`.


<!-- ## L2 isolation domains

L2 isolation domains establish Layer 2 connectivity between workloads running on Azure Local nodes.

### L3 isolation domain parameters

The following parameters are used for the management of L2 isolation domains.

| Parameter | Description | Example |
| --- | --- | --- |
| `resource-group` | Use an appropriate resource group name specifically for ISD of your choice. | `ResourceGroupName` |
| `resource-name` | Resource name of the L2 isolation domain. | `example-l2domain` |
| `location` | Azure region used during NFC creation. | `eastus` |
| `nf-Id` | Network fabric ID. | "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFresourcegroupname/providers/Microsoft.ManagedNetworkFabric/NetworkFabrics/NFname" |
| `vlan-id` | VLAN identifier value. VLANs 1-500 are reserved and can't be used. The VLAN identifier value can't be changed once specified. To modify the VLAN identifier value, you must delete and recreate the isolation domain. The range is between 501-4095. | 501 |
| `mtu` | Maximum transmission unit is 1500 by default, if not specified. | 1500 |
| `administrativeState` | Enable/Disable indicates the administrative state of the isolation domain. | Enable |
| `subscriptionId` | Azure subscription ID for your instance. |  | 
| `provisioningState` | Indicates provisioning state. | |

### Create L2 isolation domain 

Create an L2 isolation domain using this command: 

```azurecli
az networkfabric l2domain create \ 
--resource-group "ResourceGroupName" \ 
--resource-name "example-l2domain" \ 
--location "eastus" \ 
--nf-id "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/NetworkFabrics/NFname" \ 
--vlan-id  750\ 
--mtu 1501
```

**Sample output:** 

```json
{ 
  "administrativeState": "Disabled",		  
  "id": "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/l2IsolationDomains/example-l2domain", 
  "location": "eastus", 
  "mtu": 1501, 
  "name": "example-l2domain", 
  "networkFabricId": "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFresourcegroupname/providers/Microsoft.ManagedNetworkFabric/networkFabrics/NFName", 
  "provisioningState": "Succeeded", 
  "resourceGroup": "ResourceGroupName", 
  "systemData": { 
    "createdAt": "2023-XX-XXT14:57:59.167177+00:00", 
    "createdBy": "email@address.com", 
    "createdByType": "User", 
    "lastModifiedAt": "2023-XX-XXT14:57:59.167177+00:00", 
    "lastModifiedBy": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx", 
    "lastModifiedByType": "Application" 
  },			    

  "type": "microsoft.managednetworkfabric/l2isolationdomains", 
  "vlanId": 750 
}
```

### Display L2 isolation domain details

This command shows details about L2 isolation domains, including their administrative states: 

```azurecli
az networkfabric l2domain show --resource-group "ResourceGroupName" --resource-name "example-l2domain"
``` 

**Sample output**

```json
{ 
  "administrativeState": "Disabled",					  
  "id": "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/l2IsolationDomains/example-l2domain", 
  "location": "eastus", 
  "mtu": 1501, 
  "name": "example-l2domain", 
  "networkFabricId": "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/networkFabrics/NFName", 
  "provisioningState": "Succeeded", 
  "resourceGroup": "ResourceGroupName", 
  "systemData": { 
    "createdAt": "2023-XX-XXT14:57:59.167177+00:00", 
    "createdBy": "email@address.com", 
    "createdByType": "User", 
    "lastModifiedAt": "2023-XX-XXT14:57:59.167177+00:00", 
    "lastModifiedBy": "d1bd24c7-b27f-477e-86dd-939e1078890", 
    "lastModifiedByType": "Application" 
  },			    

  "type": "microsoft.managednetworkfabric/l2isolationdomains", 
  "vlanId": 750 
}
```

### List L2 isolation domains 

This command lists all L2 isolation domains available in a resource group:

```azurecli
az networkfabric l2domain list --resource-group "ResourceGroupName"
```

**Sample output**

```json
 { 
    "administrativeState": "Enabled", 
    "id": "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/l2IsolationDomains/example-l2domain", 
    "location": "eastus", 
    "mtu": 1501, 
    "name": "example-l2domain", 
    "networkFabricId": "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxxxxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/networkFabrics/NFName", 
    "provisioningState": "Succeeded", 
    "resourceGroup": "ResourceGroupName", 
    "systemData": { 
      "createdAt": "2022-XX-XXT22:26:33.065672+00:00", 
      "createdBy": "email@address.com", 
      "createdByType": "User", 
      "lastModifiedAt": "2022-XX-XXT14:46:45.753165+00:00", 
      "lastModifiedBy": "d1bd24c7-b27f-477e-86dd-939e107873d7", 
      "lastModifiedByType": "Application" 
    }, 

    "type": "microsoft.managednetworkfabric/l2isolationdomains", 
    "vlanId": 750 
  }
```
### Enable an L2 isolation domain 

You must enable an isolation domain to push the configuration to your network fabric devices. Use the following command to change the administrative state of an isolation domain and enable it:

```azurecli
az networkfabric l2domain update-admin-state --resource-group "ResourceGroupName" --resource-name "example-l2domain" --state Enable/Disable 
```

**Sample output**

```json
{ 
  "administrativeState": "Enabled", 
  "id": "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/l2IsolationDomains/example-l2domain", 
  "location": "eastus", 
  "mtu": 1501, 
  "name": "example-l2domain", 
  "networkFabricId": "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/networkFabrics/NFName", 
  "provisioningState": "Succeeded", 
  "resourceGroup": "ResourceGroupName", 
  "systemData": { 
    "createdAt": "2023-XX-XXT14:57:59.167177+00:00", 
    "createdBy": "email@address.com", 
    "createdByType": "User", 
    "lastModifiedAt": "2023-XX-XXT14:57:59.167177+00:00", 
    "lastModifiedBy": "d1bd24c7-b27f-477e-86dd-939e107873d7", 
    "lastModifiedByType": "Application" 
  }, 

  "type": "microsoft.managednetworkfabric/l2isolationdomains", 
  "vlanId": 501 
} 
```

### Delete an L2 isolation domain 

Use this command to delete an L2 isolation domain:

```azurecli
az networkfabric l2domain delete --resource-group "ResourceGroupName" --resource-name "example-l2domain"
``` 

> [!NOTE]
> Use the `show` or `list` command to validate that the isolation domain is deleted. Deleted resources will not appear in the output result.-->

## L3 isolation domains

L3 isolation domains establish Layer 3 connectivity between workloads running on Azure Local compute nodes. 

The Layer 3 isolation domain has two components: 

- **Internal network** – enables Layer 3 east-west connectivity across racks within the multi-rack network fabric + cluster.  

- **External network** – Enable Layer 3 north-south connectivity from the multi-rack network fabric + cluster to external networks.

The L3 isolation domain enables deploying workloads that advertise service IPs to the fabric via the Border Gateway Protocol (BGP).

An L3 isolation domain also has two Autonomous System Numbers (ASNs): 

1. The fabric ASN, which is the ASN of the network devices on the network fabric. You specify the fabric ASN when creating the network fabric. 

1. The peer ASN, which is the ASN of the workloads in Azure Local. This number must be unique and can't be the same as the fabric ASN. 

### Provision an L3 isolation domain

The workflow for provisioning an L3 isolation domain is as follows: 

1. Create an L3 isolation domain.

1. Create one or more internal networks.

1. Enable the L3 isolation domain.

To make changes to an existing L3 isolation domain, follow these steps: 

1. Disable the L3 isolation domain.

1. Make changes to the L3 isolation domain.

1. Re-enable the L3 isolation domain.

The process to show, enable, disable, and delete IPv6-based isolation domains is the same as the process for IPv4-based domains. The VLAN range for creating isolation domain is 501 through 4095.

### L3 isolation domain parameters

Use the following parameters to configure L3 isolation domains.

| Parameter | Description | Example |
| --- | --- | --- |
| `resource-group` | Use an appropriate resource group name specifically for ISD of your choice. | ResourceGroupName |
| `resource-name` | Resource Name of the l3isolationDomain. | example-l3domain |
| `location` | Azure Region used during NFC creation. | eastus |
| subscriptionId | Your Azure subscriptionId for your network fabric  + cluster. | xxxx-xxxx-xxxx-xxxx-xxxx |
| `nf-Id` | Azure subscriptionId used during NFC creation. | /subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/NetworkFabrics/NFName" |
| `Vlan-id` | VLAN identifier value. You can't change the VLAN identifier value after you specify it. The range is between 501-3000. | 501 | 

The following parameters for isolation domains are *not required*:

| Parameter | Description | Example |
| --- | --- | --- |
| `mtu` | Maximum transmission unit is 1500 by default, if not specified. | 1500-9000 |
| `administrativeState` | `Enable/Disable` indicate the administrative state of the isolation domain. | Enable |
| `provisioningState` | Indicates provisioning state. | |
| `redistributeConnectedSubnet` | Advertise connected subnets default value is True. | True |
| `redistributeStaticRoutes` | Advertised static routes can have value of true/False. Default value is False. | False |
| `aggregateRouteConfiguration` | List of Ipv4 and Ipv6 route configurations. | | 
| `connectedSubnetRoutePolicy` | Route policy configuration for IPv4 or Ipv6 L3 ISD-connected subnets. Refer to the help file for using correct syntax. | |

 
### Create an L3 isolation domain 

Use this command to create an L3 isolation domain:

```azurecli
az networkfabric l3domain create --resource-group "ResourceGroupName" --resource-name "l3mgmt" --location "eastus" --nf-id "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/networkFabrics/NFName"
```
<!--
> [!NOTE]
> For MPLS (Multiprotocol Label Switching) Option 10 (Option B) connectivity to external networks via provider edge (PE) devices, you can specify option B)parameters while creating an isolation domain.
-->

**Sample output**

```json
{ 
  "administrativeState": "Disabled", 
  "configurationState": "Succeeded",								  
  "id": "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/l3IsolationDomains/example-l3domain", 
  "location": "eastus", 
  "name": "example-l3domain", 
  "networkFabricId": "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/networkFabrics/NFName", 
  "provisioningState": "Succeeded", 
  "redistributeConnectedSubnets": "True", 
  "redistributeStaticRoutes": "False", 
  "resourceGroup": "ResourceGroupName", 
  "systemData": { 
    "createdAt": "2022-XX-XXT06:23:43.372461+00:00", 
    "createdBy": "email@example.com", 
    "createdByType": "User", 
    "lastModifiedAt": "2023-XX-XXT09:40:38.815959+00:00", 
    "lastModifiedBy": "d1bd24c7-b27f-477e-86dd-939e10787367", 
    "lastModifiedByType": "Application" 
  },			    

  "type": "microsoft.managednetworkfabric/l3isolationdomains" 
} 
```

<!--### Create an untrusted L3 isolation domain 

```azurecli
az networkfabric l3domain create --resource-group "ResourceGroupName" --resource-name "l3untrust" --location "eastus" --nf-id "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/networkFabrics/NFName"
```

### Create a trusted L3 isolation domain 

```azurecli
az networkfabric l3domain create --resource-group "ResourceGroupName" --resource-name "l3trust" --location "eastus" --nf-id "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/networkFabrics/NFName" 
```

### Create a management L3 isolation domain

```azurecli
az networkfabric l3domain create --resource-group "ResourceGroupName" --resource-name "l3mgmt" --location "eastus" --nf-id "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/networkFabrics/NFName"
``` 
-->

### Display L3 isolation domain details

To get the L3 isolation domains details and administrative state:

```azurecli
az networkfabric l3domain show --resource-group "ResourceGroupName" --resource-name "example-l3domain" 
```

**Sample output**

```json
{ 
  "administrativeState": "Disabled", 
  "configurationState": "Succeeded",				 								  
  "id": "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/l3IsolationDomains/example-l3domain", 
  "location": "eastus", 
  "name": "example-l3domain", 
  "networkFabricId": "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/networkFabrics/NFName", 
  "provisioningState": "Succeeded", 
  "redistributeConnectedSubnets": "True", 
  "redistributeStaticRoutes": "False", 
  "resourceGroup": "2023-XX-XXT09:40:38.815959+00:00", 
  "systemData": { 
    "createdAt": "2023-XX-XXT09:40:38.815959+00:00", 
    "createdBy": "email@example.com", 
    "createdByType": "User", 
    "lastModifiedAt": "2023-XX-XXT09:40:46.923037+00:00", 
    "lastModifiedBy": "d1bd24c7-b27f-477e-86dd-939e10787456", 
    "lastModifiedByType": "Application" 
  },			    

  "type": "microsoft.managednetworkfabric/l3isolationdomains" 
}
```

### List L3 isolation domains

Use this command to get a list of all L3 isolation domains available in a resource group:

```azurecli
az networkfabric l3domain list --resource-group "ResourceGroupName"
``` 

**Sample output**

```json
{ 
    "administrativeState": "Disabled", 
    "configurationState": "Succeeded",					 							  
    "id": "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/l3IsolationDomains/example-l3domain", 
    "location": "eastus", 
    "name": "example-l3domain", 
    "networkFabricId": "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/networkFabrics/NFName", 
    "provisioningState": "Succeeded", 
    "redistributeConnectedSubnets": "True", 
    "redistributeStaticRoutes": "False", 
    "resourceGroup": "ResourceGroupName", 
    "systemData": { 
      "createdAt": "2023-XX-XXT09:40:38.815959+00:00", 
      "createdBy": "email@example.com", 
      "createdByType": "User", 
      "lastModifiedAt": "2023-XX-XXT09:40:46.923037+00:00", 
      "lastModifiedBy": "d1bd24c7-b27f-477e-86dd-939e10787890", 
      "lastModifiedByType": "Application" 
    },			    

    "type": "microsoft.managednetworkfabric/l3isolationdomains" 
  } 
```

### Enable an L3 isolation domain 

Use the following command to change the administrative state of an L3 isolation domain to enable or disable it: 

> [!NOTE]
> To change the administrative state of an L3 isolation domain, include at least one internal network. 

```azurecli
az networkfabric l3domain update-admin-state --resource-group "ResourceGroupName" --resource-name "example-l3domain" --state Enable/Disable 
```

**Sample output**

```json
{ 
  "administrativeState": "Enabled", 
  "configurationState": "Succeeded",		 
  "id": "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/ResourceGroupName/providers/Microsoft.ManagedNetworkFabric/l3IsolationDomains/example-l3domain",				  
  "location": "eastus", 
  "name": "example-l3domain", 
  "networkFabricId": "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/NFresourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/networkFabrics/NFName", 
  "provisioningState": "Succeeded", 
  "redistributeConnectedSubnets": "True", 
  "redistributeStaticRoutes": "False", 
  "resourceGroup": "NFResourceGroupName", 
  "systemData": { 
    "createdAt": "2023-XX-XXT06:23:43.372461+00:00", 
    "createdBy": "email@address.com", 
    "createdByType": "User", 
    "lastModifiedAt": "2023-XX-XXT06:25:53.240975+00:00", 
    "lastModifiedBy": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx", 
    "lastModifiedByType": "Application" 
  },				  

  "type": "microsoft.managednetworkfabric/l3isolationdomains" 
} 
```

Use the `az show` command to verify whether the administrative state changed to `Enabled`. 

### Delete an L3 isolation domain

Use this command to delete an L3 isolation domain:

```azurecli
 az networkfabric l3domain delete --resource-group "ResourceGroupName" --resource-name "example-l3domain"
``` 

Use the `show` or `list` commands to validate that an isolation domain is deleted.

## Create an internal network 

After you create an L3 isolation domain, create an internal network. Internal networks enable Layer 3 inter-rack and intra-rack communication. An L3 isolation domain can support multiple internal networks, each on a separate VLAN. 

<!-- The following diagram represents an example workloads with three internal networks: trusted, untrusted, and management. Each of the internal networks is created in its own L3 isolation domain.

:::image type="content" source="./media/multi-rack-configure-isolation-domain/isolation-domain-diagram.png" alt-text="Digram of an isolation domain." lightbox="./media/multi-rack-configure-isolation-domain/isolation-domain-diagram.png":::

The IPv4 prefixes for these networks are: 

- Trusted network: 10.151.1.11/24 
- Management network: 10.151.2.11/24 
- Untrusted network: 10.151.3.11/24 

### Internal network parameters -->

The following parameters are required for creating internal networks. 

| Parameter | Description | Example |
| --- | --- | --- |
| `vlan-Id` | Vlan identifier with range from 501 to 4095. | 1001 |
| `resource-group` | Use the corresponding NFC resource group name. | NFCresourcegroupname |
| `l3-isolation-domain-name` | Resource name of the L3 isolation domain | example-l3domain |
| `location` | The Azure region used during NFC creation | `eastus` |

The following parameters are *not required* for creating internal networks:

| Parameter | Description | Example |
| --- | --- | --- |
| `connectedIPv4Subnets` | IPv4 subnet used by the HAKS workloads. | 10.0.0.0/24 |
| `connectedIPv6Subnets` | IPv6 subnet used by the HAKS workloads. | 10:101:1::1/64 |
| `staticRouteConfiguration` | IPv4/IPv6 prefix of the static route. | IPv4 10.0.0.0/24 and Ipv6 10:101:1::1/64 | 
| `staticRouteConfiguration->extension` | extension flag for internal network static route. | NoExtension/NPB |
| `bgpConfiguration` | IPv4 nexthop address | 10.0.0.0/24 |
| `defaultRouteOriginate` | True/False. Enables default route to be originated when advertising routes via BGP. | True |
| `peerASN` | Peer ASN of network function. | 65047 |
| `allowAS` | Allows for routes to be received and processed even if the router detects its own ASN in the AS-Path. Input as 0 is disable, Possible values are 1-10, default is 2. | 2 |
| `allowASOverride` | Enable Or Disable allowAS | Enable |
| `extension` | extension flag for internal network. | NoExtension/NPB |
| `ipv4ListenRangePrefixes`  | BGP IPv4 listen range, maximum range allowed in /28  | 10.1.0.0/26  |
| `ipv6ListenRangePrefixes`  |BGP IPv6 listen range, maximum range allowed in /127  |3FFE:FFFF:0:CD30::/127  |
| `ipv4ListenRangePrefixes`  |BGP IPv4 listen range, maximum range allowed in /28  |10.1.0.0/26  |
| `ipv4NeighborAddress`  |IPv4 neighbor address  |10.0.0.11  |
| `ipv6NeighborAddress`  |IPv6 neighbor address  |10:101:1::11  |
| `isMonitoringEnabled`  |To enable or disable monitoring on internal network  |False  |

You must create an internal network before you enable an L3 isolation domain. This command creates an internal network with BGP configuration and a specified peering address: 

```azurecli
az networkfabric internalnetwork create  
--resource-group "ResourceGroupName"  
--l3-isolation-domain-name "example-l3domain"  
--resource-name "example-internalnetwork"  
--vlan-id 805  
--connected-ipv4-subnets '[{"prefix":"10.1.2.0/24"}]'  
--mtu 1500  
--bgp-configuration  '{"defaultRouteOriginate": "True", "allowAS": 2, "allowASOverride": "Enable", "PeerASN": 65535, "ipv4ListenRangePrefixes": ["10.1.2.0/28"]}' 
```

**Sample output**

```json
{ 
  "administrativeState": "Enabled", 
  "bgpConfiguration": { 
    "allowAS": 2, 
    "allowASOverride": "Enable", 
    "defaultRouteOriginate": "True", 
    "fabricASN": 65050, 
    "ipv4ListenRangePrefixes": [ 
      "10.1.2.0/28" 
    ], 

    "peerASN": 65535 
  }, 

  "configurationState": "Succeeded", 
  "connectedIPv4Subnets": [ 
    { 
      "prefix": "10.1.2.0/24" 
    } 
  ], 

  "extension": "NoExtension", 
  "id": "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/l3IsolationDomains/example-l3domain/internalNetworks/example-internalnetwork", 
  "isMonitoringEnabled": "True", 
  "mtu": 1500, 
  "name": "example-internalnetwork", 
  "provisioningState": "Succeeded", 
  "resourceGroup": "ResourceGroupName", 
  "systemData": { 
    "createdAt": "2023-XX-XXT04:32:00.8159767Z", 
    "createdBy": "email@example.com", 
    "createdByType": "User", 
    "lastModifiedAt": "2023-XX-XXT04:32:00.8159767Z", 
    "lastModifiedBy": "email@example.com", 
    "lastModifiedByType": "User" 
  }, 

  "type": "microsoft.managednetworkfabric/l3isolationdomains/internalnetworks", 
  "vlanId": 805 
} 
```

<!--### Create an untrusted internal network 

```azurecli
az networkfabric internalnetwork create --resource-group "ResourceGroupName" --l3-isolation-domain-name l3untrust --resource-name untrustnetwork --location "eastus" --vlan-id 502 --fabric-asn 65048 --peer-asn 65047--connected-i-pv4-subnets prefix="10.151.3.11/24" --mtu 1500 
```

### Create a trusted internal network 

```azurecli
az networkfabric internalnetwork create --resource-group "ResourceGroupName" --l3-isolation-domain-name l3trust --resource-name trustnetwork --location "eastus" --vlan-id 503 --fabric-asn 65048 --peer-asn 65047--connected-i-pv4-subnets prefix="10.151.1.11/24" --mtu 1500 
```

### Create an internal management network 

```azurecli
az networkfabric internalnetwork create --resource-group "ResourceGroupName" --l3-isolation-domain-name l3mgmt --resource-name mgmtnetwork --location "eastus" --vlan-id 504 --fabric-asn 65048 --peer-asn 65047--connected-i-pv4-subnets prefix="10.151.2.11/24" --mtu 1500 
```
--->

### Create multiple static routes with a single next hop 

```azurecli
az networkfabric internalnetwork create --resource-group "fab2nfrg180723" --l3-isolation-domain-name "example-l3domain" --resource-name "example-internalNetwork" --vlan-id 2600 --mtu 1500 --connected-ipv4-subnets "[{prefix:'10.2.0.0/24'}]" --static-route-configuration '{extension:NPB,bfdConfiguration:{multiplier:5,intervalInMilliSeconds:300},ipv4Routes:[{prefix:'10.3.0.0/24',nextHop:['10.5.0.1']},{prefix:'10.4.0.0/24',nextHop:['10.6.0.1']}]}' 
```
 
**Sample output**

```json
{ 
  "administrativeState": "Enabled", 
  "configurationState": "Succeeded", 
  "connectedIPv4Subnets": [ 
    { 
      "prefix": "10.2.0.0/24" 
    } 
  ], 

  "extension": "NoExtension", 
  "id": "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/l3IsolationDomains/example-l3domain/internalNetworks/example-internalnetwork", 
  "isMonitoringEnabled": "True", 
  "mtu": 1500, 
  "name": "example-internalNetwork", 
  "provisioningState": "Succeeded", 
  "resourceGroup": "ResourceGroupName", 
  "staticRouteConfiguration": { 
    "bfdConfiguration": { 
      "administrativeState": "Disabled", 
      "intervalInMilliSeconds": 300, 
      "multiplier": 5 
    }, 

    "extension": "NoExtension", 
    "ipv4Routes": [ 
      { 

        "nextHop": [ 
          "10.5.0.1" 
        ], 
        "prefix": "10.3.0.0/24" 
      }, 

      { 
        "nextHop": [ 
          "10.6.0.1" 
        ], 
        "prefix": "10.4.0.0/24" 
      } 
    ] 
  }, 

  "systemData": { 
    "createdAt": "2023-XX-XXT13:46:26.394343+00:00", 
    "createdBy": "email@example.com", 
    "createdByType": "User", 
    "lastModifiedAt": "2023-XX-XXT13:46:26.394343+00:00", 
    "lastModifiedBy": "email@example.com", 
    "lastModifiedByType": "User" 
  }, 

  "type": "microsoft.managednetworkfabric/l3isolationdomains/internalnetworks", 
  "vlanId": 2600 
} 
```

### Create internal network using IPv6 

```azurecli
az networkfabric internalnetwork create --resource-group "fab2nfrg180723" --l3-isolation-domain-name "example-l3domain" --resource-name "example-internalnetwork" --vlan-id 2800 --connected-ipv6-subnets '[{"prefix":"10:101:1::0/64"}]' --mtu 1500 
```

**Sample output**

```json
{ 
  "administrativeState": "Enabled", 
  "configurationState": "Succeeded", 
  "connectedIPv6Subnets": [ 
    { 
      "prefix": "10:101:1::0/64" 
    } 
  ], 

  "extension": "NoExtension", 
  "id": "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/l3IsolationDomains/l3domain2/internalNetworks/example-internalnetwork", 
  "isMonitoringEnabled": "True", 
  "mtu": 1500, 
  "name": "example-internalnetwork", 
  "provisioningState": "Succeeded", 
  "resourceGroup": "ResourceGroupName", 
  "systemData": { 
    "createdAt": "2023-XX-XXT10:34:33.933814+00:00", 
    "createdBy": "email@example.com", 
    "createdByType": "User", 
    "lastModifiedAt": "2023-XX-XXT10:34:33.933814+00:00", 
    "lastModifiedBy": "email@example.com", 
    "lastModifiedByType": "User" 
  }, 

  "type": "microsoft.managednetworkfabric/l3isolationdomains/internalnetworks", 

  "vlanId": 2800 
} 
```

## Create an external network

By using external networks, workloads can connect through Layer 3 to your provider edge devices. When you use external networks, workloads can interact with external services like firewalls and DNS. To create external networks, you need the fabric ASN that you created during network fabric creation. 

The commands for creating an external network by using Azure CLI include the following parameters. 

### External network parameters

| Parameter | Description | Example |
| --- | --- | --- | 
| `peeringOption` | Peering using either option A or option B. Possible values are `OptionA` and `OptionB`. | OptionB |
| `optionBProperties` | OptionB properties configuration. To specify, use `exportIPv4/IPv6RouteTargets` or `importIpv4/Ipv6RouteTargets`. | `"exportIpv4/Ipv6RouteTargets": ["1234:1234"]` |
| `optionAProperties` | Configuration of OptionA properties. Refer to OptionA example in section below. | |
| `external` | This optional parameter inputs MPLS Option 10 (B) connectivity to external networks via provider edge (PE) devices. Using this option, you can input, import, and export route targets as shown in the example. | | 

### Create an external network using Option B 

```azurecli
az networkfabric externalnetwork create --resource-group "ResourceGroupName" --l3domain "examplel3-externalnetwork" --resource-name "examplel3-externalnetwork" --peering-option "OptionB" --option-b-properties "{routeTargets:{exportIpv4RouteTargets:['65045:2001'],importIpv4RouteTargets:['65045:2001']}}" 
```

**Sample output**

```json
{ 
  "administrativeState": "Enabled", 
  "id": "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/l3IsolationDomains/example-l3domain/externalNetworks/examplel3-externalnetwork", 
  "name": "examplel3-externalnetwork", 
  "optionBProperties": { 
    "exportRouteTargets": [ 
      "65045:2001" 
    ], 

    "importRouteTargets": [ 
      "65045:2001" 
    ], 

    "routeTargets": { 
      "exportIpv4RouteTargets": [ 
        "65045:2001" 
      ], 

      "importIpv4RouteTargets": [ 
        "65045:2001" 
      ] 
    } 
  }, 

  "peeringOption": "OptionB", 
  "provisioningState": "Succeeded", 
  "resourceGroup": "ResourceGroupName", 
  "systemData": { 
    "createdAt": "2023-XX-XXT15:45:31.938216+00:00", 
    "createdBy": "email@address.com", 
    "createdByType": "User", 
    "lastModifiedAt": "2023-XX-XXT15:45:31.938216+00:00", 
    "lastModifiedBy": "email@address.com", 
    "lastModifiedByType": "User" 
  }, 

  "type": "microsoft.managednetworkfabric/l3isolationdomains/externalnetworks" 
} 
```

### Create an external network using Option A

For Option A, you need to create an external network before you enable the L3 isolation domain. An external network depends on an internal network, so you can't enable an external network without an internal network. The `vlan-id` value should be between 501 and 4095. 

```azurecli
az networkfabric externalnetwork create --resource-group "ResourceGroupName" --l3domain "example-l3domain" --resource-name "example-externalipv4network" --peering-option "OptionA" --option-a-properties '{"peerASN": 65026,"vlanId": 2423, "mtu": 1500, "primaryIpv4Prefix": "10.18.0.148/30", "secondaryIpv4Prefix": "10.18.0.152/30"}'
``` 

**Sample output**

```json
{ 
  "administrativeState": "Enabled", 
  "id": "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/l3IsolationDomains/example-l3domain/externalNetworks/example-externalipv4network", 
  "name": "example-externalipv4network", 
  "optionAProperties": { 
    "fabricASN": 65050, 
    "mtu": 1500, 
    "peerASN": 65026, 
    "primaryIpv4Prefix": "10.21.0.148/30", 
    "secondaryIpv4Prefix": "10.21.0.152/30", 
    "vlanId": 2423 
  }, 

  "peeringOption": "OptionA", 
  "provisioningState": "Succeeded", 
  "resourceGroup": "ResourceGroupName", 
  "systemData": { 
    "createdAt": "2023-07-19T09:54:00.4244793Z", 
    "createdAt": "2023-XX-XXT07:23:54.396679+00:00",  
    "createdBy": "email@address.com", 
    "lastModifiedAt": "2023-XX-XX1T07:23:54.396679+00:00",  
    "lastModifiedBy": "email@address.com", 
    "lastModifiedByType": "User" 
  }, 

  "type": "microsoft.managednetworkfabric/l3isolationdomains/externalnetworks" 
}
```

### Create an external network using IPv6 

```azurecli
az networkfabric externalnetwork create --resource-group "ResourceGroupName" --l3domain "example-l3domain" --resource-name "example-externalipv6network" --peering-option "OptionA" --option-a-properties '{"peerASN": 65026,"vlanId": 2423, "mtu": 1500, "primaryIpv6Prefix": "fda0:d59c:da16::/127", "secondaryIpv6Prefix": "fda0:d59c:da17::/127"}' 
```

The supported primary and secondary IPv6 prefix size is /127. 

**Sample output**

```json
{ 
  "administrativeState": "Enabled", 
  "id": "/subscriptions//xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/l3IsolationDomains/example-l3domain/externalNetworks/example-externalipv6network", 
  "name": "example-externalipv6network", 
  "optionAProperties": { 
    "fabricASN": 65050, 
    "mtu": 1500, 
    "peerASN": 65026, 
    "primaryIpv6Prefix": "fda0:d59c:da16::/127", 
    "secondaryIpv6Prefix": "fda0:d59c:da17::/127", 
    "vlanId": 2423 
  }, 

  "peeringOption": "OptionA", 
  "provisioningState": "Succeeded", 
  "resourceGroup": "ResourceGroupName", 
  "systemData": { 
    "createdAt": "2022-XX-XXT07:52:26.366069+00:00", 
    "createdBy": "email@address.com", 
    "createdByType": "User", 
    "lastModifiedAt": "2022-XX-XXT07:52:26.366069+00:00", 
    "lastModifiedBy": "email@address.com", 
    "lastModifiedByType": "User" 
  }, 

  "type": "microsoft.managednetworkfabric/l3isolationdomains/externalnetworks" 
}
``` 

<!--### Enable a highly available L2 isolation domain 

Run the following command to enable a highly available (HA) L2 isolation domain:

```azurecli
az networkfabric l2domain update-administrative-state --resource-group "ResourceGroupName" --resource-name "l2HAnetwork" --state Enable
```
-->

### Enable an untrusted L3 isolation domain 

Use this command to enable an untrusted L3 isolation domain:

```azurecli 
az networkfabric l3domain update-admin-state --resource-group "ResourceGroupName" --resource-name "l3untrust" --state Enable 
```

Use this command to enable a trusted L3 isolation domain: 

```azurecli 
az networkfabric l3domain update-admin-state --resource-group "ResourceGroupName" --resource-name "l3trust" --state Enable
```

### Enable a management L3 isolation domain 

Use this command to enable a management L3 isolation domain: 

```azurecli
az networkfabric l3domain update-admin-state --resource-group "ResourceGroupName" --resource-name "l3untrust" --state Enable
```
