---
title: Manage Layer 3 Isolation Domains for Azure Local Multi-rack Deployments (preview)
description: Learn how to manage Layer 3 isolation domains for Azure Local multi-rack deployments (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 01/21/2026
---

# Manage Layer 3 isolation domains for multi-rack deployments of Azure Local (preview)

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article describes how to create, modify, or delete Layer 3 (L3) isolation domains for multi-rack deployments of Azure Local.

Isolation domains enable network connectivity between workloads hosted in the same rack (intra-rack communication) or different racks (inter-rack communication) and with endpoints external to Azure Local. You can create, update, delete, and check the status of your L3 isolation domains by using the Azure Command-Line Interface (CLI).

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## About isolation domains

A Layer 3 isolation domain has two components:

- **Internal network** – This network enables L3 East-West connectivity across racks within the multi-rack instance.
- **External network** – This network enables L3 North-South connectivity from the multi-rack instance to networks outside the instance.

The workflow for a successful provisioning of an L3 isolation domain is as follows:

- Create an L3 isolation domain
- Create one or more internal networks
- Create an external network (optional) <!-- check with Vatsal -->
- Enable an L3 isolation domain

## Prerequisites

- Create the Network Fabric Controller (NFC) and the Network Fabric. For more information, see [Create a network fabric controller for multi-rack deployments of Azure Local](/azure/operator-nexus/howto-configure-network-fabric-controller).

- Install the latest version of the required [Azure CLI extensions](/azure/operator-nexus/howto-install-cli-extensions).

- Use VLAN values between 501 and 4095. Azure Local reserves VLAN values less than or equal to 500 for platform use, so you can't use VLANs in this range for your workload networks.

- Sign in to your Azure account and set the subscription to your Azure subscription ID. Use the same subscription ID for all the resources in your network fabric and cluster.

  ```azurecli
  az login 
  az account set --subscription "<Subscription ID>"
  ```

- Register resource providers for a managed network fabric:

  1. In Azure CLI, enter the command:

      ```azurecli
      az provider register --namespace Microsoft.ManagedNetworkFabric
      ```

  1. Monitor the registration process by using the command:

      ```azurecli
      az provider show -n Microsoft.ManagedNetworkFabric -o table
      ```

      Registration can take up to 10 minutes. When it's finished, the `RegistrationState` in the output changes to `Registered`.

### Review L3 isolation domain parameters

Use the following *required* parameters to provision and configure your L3 isolation domain.

| Parameter | Description | Example |
| --- | --- | --- |
| `resource-group` | Use an appropriate resource group name specifically for the L3 isolation domain of your choice. | `ResourceGroupName` |
| `resource-name` | Resource name of the L3 isolation domain. | `example-l3domain` |
| `subscription` | Azure subscription ID for your instance. | `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` |
| `location` | Azure region used during NFC creation. | `eastus` |
| `nf-Id` | Network fabric ID. | "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFresourcegroupname/providers/Microsoft.ManagedNetworkFabric/NetworkFabrics/NFname" |
| `vlan-Id` | VLAN identifier value. The range is between 501-3000. <br><br> VLANs 1-500 are reserved for platform use and can't be used. The VLAN identifier value can't be changed once specified. <br><br> To modify the VLAN identifier value, you must delete and recreate the isolation domain.  | 501 |

The following parameters for isolation domains are *optional*:

| Parameter | Description | Example |
| --- | --- | --- |
| `mtu` | Maximum transmission unit is 1500 by default, if not specified. | 1500-9000 |
| `administrativeState` | `Enable/Disable` indicate the administrative state of the isolation domain. | Enable |
| `provisioningState` | Indicates provisioning state. | |
| `redistributeConnectedSubnet` | Advertise connected subnets default value is True. | True |
| `redistributeStaticRoutes` | Advertised static routes can have value of True/False. Default value is False. | False |
| `aggregateRouteConfiguration` | List of Ipv4 and Ipv6 route configurations. | |
| `connectedSubnetRoutePolicy` | Route policy configuration for IPv4 or Ipv6 L3 ISD-connected subnets. Refer to the help file for using correct syntax. | |


### Create an L3 isolation domain

1. Set some parameters. Set parameters in angle brackets \< \> to your own values. Remove the angle brackets when you run the command.

    ```azurecli
    $resourceGroupName = "example-resourcegroup"
    $resourceName = "example-l3domain"
    $location = "eastus"
    $nfId = "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/networkFabrics/NFName"
    ```

1. Use this command to create an L3 isolation domain:

    ```azurecli
    az networkfabric l3domain create --resource-group $resourceGroupName --resource-name $resourceName --location $location --nf-id $nfId
    ```

    <details>
    <summary>Expand this section to see an example output.</summary>

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

    </details>

## Show L3 isolation domain details

To get the L3 isolation domains details and administrative state:

1. Set some parameters. Set parameters in angle brackets \< \> to your own values. Remove the angle brackets when you run the command.

    ```azurecli
    $resourceGroupName = "example-resourcegroup"
    $resourceName = "example-l3domain"
    ```

1. Use this command to get the details of an L3 isolation domain:

    ```azurecli
    az networkfabric l3domain show --resource-group $resourceGroupName --resource-name $resourceName
    ```

    <details>
    <summary>Expand this section to see an example output.</summary>

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
    </details>

### List L3 isolation domains

1. Set some parameters. Set parameters in angle brackets \< \> to your own values. Remove the angle brackets when you run the command.

    ```azurecli
    $resourceGroupName = "example-resourcegroup"
    ```

1. Use the following command to get a list of all L3 isolation domains available in a resource group:

    ```azurecli
    az networkfabric l3domain list --resource-group $resourceGroupName
    ``` 

    <details>
    <summary>Expand this section to see an example output.</summary>

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
        "resourceGroup": "example-resourcegroup", 
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
    </details>

## Update administrative state of an L3 isolation domain

1. Set some parameters. Set parameters in angle brackets \< \> to your own values. Remove the angle brackets when you run the command.

    ```azurecli
    $resourceGroupName = "example-resourcegroup"
    $resourceName = "example-l3domain"
    ```

1. Use the following command to change the administrative state of an L3 isolation domain to enable or disable it:

    > [!NOTE]
    > To change the administrative state of an L3 isolation domain, include at least one internal network.
    
    ```azurecli
    az networkfabric l3domain update-admin-state --resource-group $resourceGroupName --resource-name $resourceName --state Enable/Disable 
    ```

    <details>
    <summary>Expand this section to see an example output.</summary>

    ```json
    { 
      "administrativeState": "Enabled", 
      "configurationState": "Succeeded",		 
      "id": "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/example-resourcegroup/providers/Microsoft.ManagedNetworkFabric/l3IsolationDomains/example-l3domain",				  
      "location": "eastus", 
      "name": "example-l3domain", 
      "networkFabricId": "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/NFresourceGroups/NFexample-resourcegroup/providers/Microsoft.ManagedNetworkFabric/networkFabrics/NFName", 
      "provisioningState": "Succeeded", 
      "redistributeConnectedSubnets": "True", 
      "redistributeStaticRoutes": "False", 
      "resourceGroup": "NFexample-resourcegroup", 
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
    </details>


> [!NOTE]
> Use the `az show` command to verify whether the administrative state changed to `Enabled`.

## Delete an L3 isolation domain

1. Set some parameters. Set parameters in angle brackets \< \> to your own values. Remove the angle brackets when you run the command.

    ```azurecli
    $resourceGroupName = "example-resourcegroup"
    $resourceName = "example-l3domain"
    ```

1. Use this command to delete an L3 isolation domain:

    ```azurecli
     az networkfabric l3domain delete --resource-group $resourceGroupName --resource-name $resourceName
    ``` 


> [!NOTE]
> Use the `show` or `list` commands to validate that an isolation domain is deleted.

## Create an internal network

After you create an L3 isolation domain, create an internal network. Internal networks enable Layer 3 inter-rack and intra-rack communication. An L3 isolation domain can support multiple internal networks, each on a separate VLAN. 

### Review internal network parameters

The following parameters are *required* for creating internal networks.

| Parameter | Description | Example |
| --- | --- | --- |
| `vlan-Id` | VLAN identifier with range from 501 to 4095. | 1001 |
| `resource-group` | Use the corresponding NFC resource group name. | NFCresourcegroupname |
| `l3-isolation-domain-name` | Resource name of the L3 isolation domain | example-l3domain |
| `location` | The Azure region used during NFC creation | `eastus` |
| `connectedIPv4Subnets` | IPv4 subnet used by the HAKS workloads. | 10.0.0.0/24 |
| `bgpConfiguration` | IPv4 next hop address | 10.0.0.0/24 |
| `peerASN` | Peer ASN of network function. | 65047 |
| `ipv4ListenRangePrefixes`  | BGP IPv4 listen range, maximum range allowed in /28  | 10.1.0.0/26  |

The following parameters are *optional* for creating internal networks:

| Parameter | Description | Example |
| --- | --- | --- |
| `connectedIPv6Subnets` | IPv6 subnet used by the HAKS workloads. | 10:101:1::1/64 |
| `staticRouteConfiguration` | IPv4/IPv6 prefix of the static route. | IPv4 10.0.0.0/24 and Ipv6 10:101:1::1/64 | 
| `staticRouteConfiguration->extension` | extension flag for internal network static route. | NoExtension/NPB |
| `defaultRouteOriginate` | True/False. Enables default route to be originated when advertising routes via BGP. | True |
| `allowAS` | Allows for routes to be received and processed even if the router detects its own ASN in the AS-Path. TO disable, input 0. <br>Possible values are 1 to 10 and the default is 2. | 2 |
| `allowASOverride` | Enable or disable allowAS | Enable |
| `extension` | extension flag for internal network. | NoExtension/NPB |
| `ipv6ListenRangePrefixes`  |BGP IPv6 listen range, maximum range allowed in /127  |3FFE:FFFF:0:CD30::/127  |
| `ipv4ListenRangePrefixes`  |BGP IPv4 listen range, maximum range allowed in /28  |10.1.0.0/26  |
| `ipv4NeighborAddress`  |IPv4 neighbor address  |10.0.0.11  |
| `ipv6NeighborAddress`  |IPv6 neighbor address  |10:101:1::11  |
| `isMonitoringEnabled`  |To enable or disable monitoring on internal network  |False  |


### Create an internal network with BGP configuration and specified peering address

You must create an internal network before you enable an L3 isolation domain. This command creates an internal network with BGP configuration and a specified peering address:

1. Set some parameters. Set parameters in angle brackets \< \> to your own values. Remove the angle brackets when you run the command.

    ```azurecli
    $subscription =  "<Subscription ID>"
    $resourceGroupName = "example-resourcegroup"
    $isoDomainName = "example-l3domain"
    $resourceName = "example-internalnetwork"
    $location = "eastus"
    $vLanId = "805"
    $ConnectedIPv4Subnets = '[{"prefix":"10.1.2.0/24"}]'   
    $ipv4ListenRangePrefixes = '["10.1.2.0/28"]'
    $mtu = "1500"
    $bgpConfiguration =  '{"defaultRouteOriginate": "True", "allowAS": 2, "allowASOverride": "Enable", "PeerASN": 65535, "ipv4ListenRangePrefixes": ["10.1.2.0/28"]}'
    ```

1. Create the internal network with BGP configuration and specified peering address:

    ```azurecli
    az networkfabric internalnetwork create --resource-group $resourceGroupName --l3-isolation-domain-name $isoDomainName --resource-name $resourceName --vlan-id $vLanId --connected-ipv4-subnets $ConnectedIPv4Subnets --mtu $mtu --bgp-configuration $bgpConfiguration
    ```

    <details>
    <summary>Expand this section to see an example output.</summary>
   
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
      "resourceGroup": "example-resourcegroup", 
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
    </details>

### Create multiple static routes with a single next hop 

1. Set some parameters. Set parameters in angle brackets \< \> to your own values. Remove the angle brackets when you run the command.

    ```azurecli
    $subscription =  "<Subscription ID>"
    $resourceGroupName = "example-resourcegroup"
    $isoDomainName = "example-l3domain"
    $resourceName = "example-internalnetwork"
    $vLanId = "2600"
    $ConnectedIPv4Subnets = '[{"prefix":"10.1.2.0/24"}]'   
    $mtu = "1500"
    ```

1. Create the internal network with multiple static routes with a single next hop:
    
    ```azurecli
    az networkfabric internalnetwork create --resource-group $resourceGroupName --l3-isolation-domain-name $isoDomainName --resource-name $resourceName --vlan-id $vLanId --mtu $mtu --connected-ipv4-subnets $ConnectedIPv4Subnets --static-route-configuration '{extension:NPB,bfdConfiguration:{multiplier:5,intervalInMilliSeconds:300},ipv4Routes:[{prefix:'10.3.0.0/24',nextHop:['10.5.0.1']},{prefix:'10.4.0.0/24',nextHop:['10.6.0.1']}]}' 
    ```
     
    <details>
    <summary>Expand this section to see an example output.</summary>

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
      "resourceGroup": "example-resourcegroup", 
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
    </details>

    
### Create internal network using IPv6 

1. Set some parameters. Set parameters in angle brackets \< \> to your own values. Remove the angle brackets when you run the command.

    ```azurecli
    $subscription =  "<Subscription ID>"
    $resourceGroupName = "example-resourcegroup"
    $isoDomainName = "example-l3domain"
    $resourceName = "example-internalnetwork"
    $vLanId = "2600"
    $connectedIPv6Subnets = '[{"prefix":"10:101:1::0/64"}]'   
    $mtu = "1500"
    ```

1. Create the internal network using IPv6:

    ```azurecli
    az networkfabric internalnetwork create --resource-group $resourceGroupName --l3-isolation-domain-name $isoDomainName --resource-name $resourceName --vlan-id $vLanId --connected-ipv6-subnets $connectedIPv6Subnets --mtu $mtu
    ```

    <details>
    <summary>Expand this section to see an example output.</summary>

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
    </details>

## Create an external network

By using external networks, workloads can connect through Layer 3 to your provider edge devices. When you use external networks, workloads can interact with external services like firewalls and DNS. To create external networks, you need the fabric ASN that you created during network fabric creation.

The commands for creating an external network by using Azure CLI include the following parameters.

### Review external network parameters

The following parameters are *required* for creating external networks:

| Parameter | Description | Example |
| --- | --- | --- | 
| `peeringOption` | Peering using either option A or option B. Possible values are `OptionA` and `OptionB`. | OptionB |

The following parameters are *optional* for creating external networks:

| Parameter | Description | Example |
| --- | --- | --- |
| `optionBProperties` | OptionB properties configuration. To specify, use `exportIPv4/IPv6RouteTargets` or `importIpv4/Ipv6RouteTargets`. | `"exportIpv4/Ipv6RouteTargets": ["1234:1234"]` |
| `optionAProperties` | Configuration of `OptionA` properties. Refer to `OptionA` example in a subsequent section. | |
| `external` | This optional parameter inputs MPLS Option 10 (B) connectivity to external networks via provider edge devices. Using this option, you can input, import, and export route targets as shown in the example. | | 


For Option A, you need to create an external network before you enable the L3 isolation domain. An external network is dependent on an internal network, so an external network can't be enabled without an internal network. The `vlan-id` value should be between 501 and 4095.


### Create an external network using Option B

1. Set some parameters. Set parameters in angle brackets \< \> to your own values. Remove the angle brackets when you run the command.

    ```azurecli
    $resourceGroupName = "example-resourcegroup"
    $isoDomainName = "example-l3domain"
    $resourceName = "example3-externalnetwork"
    $peeringOption = "OptionB"
    $exportIpv4RouteTargets = "65045:2001"
    $importIpv4RouteTargets = "65045:2001"
    ```

1. Create the external network using Option B:
    
    ```azurecli
    az networkfabric externalnetwork create --resource-group $resourceGroupName --l3domain $isoDomainName --resource-name $resourceName --peering-option $peeringOption --option-b-properties "{routeTargets:{exportIpv4RouteTargets:['$exportIpv4RouteTargets'],importIpv4RouteTargets:['$importIpv4RouteTargets']}}" 
    ```

    <details>
    <summary>Expand this section to see an example output.</summary>

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
      "resourceGroup": "example-resourcegroup", 
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
    </details>

### Create an external network using Option A

1. Set some parameters. Set parameters in angle brackets \< \> to your own values. Remove the angle brackets when you run the command.

    ```azurecli
    $resourceGroupName = "example-resourcegroup"
    $isoDomainName = "example-l3domain"
    $resourceName = "example-externalipv4network"
    $peeringOption = "OptionA"
    $peerASN = "65026"
    $vlanId = "2423"
    $mtu = "1500"
    $primaryIpv4Prefix = "10.18.0.148/30"
    $secondaryIpv4Prefix = "10.18.0.152/30"
    ```

1. Create the external network using Option A:

    ```azurecli
    az networkfabric externalnetwork create --resource-group $resourceGroupName --l3domain $isoDomainName --resource-name $resourceName --peering-option $peeringOption --option-a-properties '{"peerASN": $peerASN,"vlanId": $vlanId, "mtu": $mtu, "primaryIpv4Prefix": "$primaryIpv4Prefix", "secondaryIpv4Prefix": "$secondaryIpv4Prefix"}'
    ``` 

    <details>
    <summary>Expand this section to see an example output.</summary>

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
    </details>

### Create an external network using IPv6

1. Set some parameters. Set parameters in angle brackets \< \> to your own values. Remove the angle brackets when you run the command.

    ```azurecli
    $resourceGroupName = "example-resourcegroup"
    $isoDomainName = "example-l3domain"
    $resourceName = "example-externalipv6network"
    $peeringOption = "OptionA"
    $peerASN = "65026"
    $vlanId = "2423"
    $mtu = "1500"
    $primaryIpv6Prefix = "fda0:d59c:da16::/127"
    $secondaryIpv6Prefix = "fda0:d59c:da17::/127"
    ```
1. Create the external network using IPv6:
    
    ```azurecli
    az networkfabric externalnetwork create --resource-group "ResourceGroupName" --l3domain "example-l3domain" --resource-name "example-externalipv6network" --peering-option "OptionA" --option-a-properties '{"peerASN": 65026,"vlanId": 2423, "mtu": 1500, "primaryIpv6Prefix": "fda0:d59c:da16::/127", "secondaryIpv6Prefix": "fda0:d59c:da17::/127"}' 
    ```
    
    The supported primary and secondary IPv6 prefix size is /127. 

    <details>
    <summary>Expand this section to see an example output.</summary>

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
    </details>

### Enable an L3 isolation domain

1. Set some parameters. Set parameters in angle brackets \< \> to your own values. Remove the angle brackets when you run the command.

    ```azurecli
    $resourceGroupName = "example-resourcegroup"
    $resourceName = "example-l3domain"
    ```

1. Enable an untrusted L3 isolation domain:

    ```azurecli
    az networkfabric l3domain update-admin-state --resource-group $resourceGroupName --resource-name $resourceName --state Enable 
    ```

