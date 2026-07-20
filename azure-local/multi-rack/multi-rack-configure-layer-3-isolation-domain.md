---
title: Manage Layer 3 Isolation Domains for Azure Local Multi-rack Deployments
description: Learn how to manage Layer 3 isolation domains for Azure Local multi-rack deployments.
author: sipastak
ms.author: sipastak
ms.topic: how-to
ms.service: azure-local
ms.date: 04/15/2026
---

# Manage Layer 3 isolation domains for multi-rack deployments of Azure Local

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article describes how to create, modify, or delete Layer 3 (L3) isolation domains for multi-rack deployments of Azure Local.

Isolation domains enable network connectivity between workloads hosted in the same rack (intra-rack communication) or different racks (inter-rack communication) and with endpoints external to Azure Local. You can create, update, delete, and check the status of your L3 isolation domains by using the Azure Command-Line Interface (CLI).

## About isolation domains

A Layer 3 isolation domain has two components:

- **Internal network** – This network enables L3 East-West connectivity across racks within the multi-rack instance.
- **External network** – This network enables L3 North-South connectivity from the multi-rack instance to networks outside the instance.

The workflow for a successful provisioning of an L3 isolation domain is as follows:

- Create an L3 isolation domain
- Create one or more internal networks
- Create an external network (optional)
- Enable an L3 isolation domain

## Prerequisites

- Create the Network Fabric Controller (NFC) and the Network Fabric. For more information, see [Create a network fabric controller for multi-rack deployments of Azure Local](/azure/operator-nexus/howto-configure-network-fabric-controller).

- Install the latest version of the required [Azure CLI extensions](/azure/operator-nexus/howto-install-cli-extensions).

- Use VLAN values between 501 and 3000. Azure Local reserves VLAN values of 500 and below for platform use, so you can't use them for your workload networks.

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

      Registration can take up to 10 minutes. When the registration finishes, the `RegistrationState` in the output changes to `Registered`.

### Review L3 isolation domain parameters

Use the following *required* parameters to provision and configure your L3 isolation domain.

| Parameter | Description | Example |
| --- | --- | --- |
| `resource-group` | Use an appropriate resource group name specifically for the L3 isolation domain of your choice. | `ResourceGroupName` |
| `resource-name` | Resource name of the L3 isolation domain. | `example-l3domain` |
| `nf-id` | ARM resource ID of the network fabric. | "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFresourcegroupname/providers/Microsoft.ManagedNetworkFabric/NetworkFabrics/NFname" |

The following parameters for isolation domains are *optional*:

| Parameter | Description | Example |
| --- | --- | --- |
| `location` | Azure region for the resource. Defaults to the resource group location if not specified. | `eastus` |
| `redistribute-connected-subnets` | Advertise connected subnets. Allowed values: `True`, `False`. Default is `True`. | True |
| `redistribute-static-routes` | Advertise static routes. Allowed values: `True`, `False`. Default is `False`. | False |
| `aggregate-route-configuration` | List of IPv4 and IPv6 aggregate route configurations. | |
| `connected-subnet-route-policy` | Route policy configuration for IPv4 or IPv6 L3 ISD-connected subnets. Refer to the help file for the correct syntax. | |


### Create an L3 isolation domain

1. Set parameters as needed.

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
      "resourceGroup": "example-resourcegroup", 
      "systemData": { 
        "createdAt": "2023-XX-XXT00:00:00.0000000Z", 
        "createdBy": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx", 
        "createdByType": "Application", 
        "lastModifiedAt": "2023-XX-XXT00:00:00.0000000Z", 
        "lastModifiedBy": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx", 
        "lastModifiedByType": "Application" 
      },			    
    
      "type": "microsoft.managednetworkfabric/l3isolationdomains" 
    }
    ```

    </details>

    > [!NOTE]
    > A newly created L3 isolation domain shows an administrative state of `Disabled`, both in the command output and in the Azure portal. This state is expected. You enable the domain after you create its internal and external networks.

## Show L3 isolation domain details

To get the L3 isolation domains details and administrative state:

1. Set parameters as needed.

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
      "resourceGroup": "example-resourcegroup", 
      "systemData": { 
        "createdAt": "2023-XX-XXT00:00:00.0000000Z", 
        "createdBy": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx", 
        "createdByType": "Application", 
        "lastModifiedAt": "2023-XX-XXT00:00:00.0000000Z", 
        "lastModifiedBy": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx", 
        "lastModifiedByType": "Application" 
      },			    
    
      "type": "microsoft.managednetworkfabric/l3isolationdomains" 
    }
    ```
    </details>

### List L3 isolation domains

1. Set parameters as needed.

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
          "createdAt": "2023-XX-XXT00:00:00.0000000Z", 
          "createdBy": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx", 
          "createdByType": "Application", 
          "lastModifiedAt": "2023-XX-XXT00:00:00.0000000Z", 
          "lastModifiedBy": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx", 
          "lastModifiedByType": "Application" 
        },			    
    
        "type": "microsoft.managednetworkfabric/l3isolationdomains" 
      } 
    ```
    </details>

## Create an internal network

After you create an L3 isolation domain, create an internal network. Internal networks enable Layer 3 inter-rack and intra-rack communication. An L3 isolation domain can support multiple internal networks, each on a separate VLAN. 

### Review internal network parameters

The following parameters are *required* for creating internal networks.

| Parameter | Description | Example |
| --- | --- | --- |
| `l3-isolation-domain-name` | Resource name of the L3 isolation domain. | example-l3domain |
| `resource-group` | Use the corresponding NFC resource group name. | NFCresourcegroupname |
| `resource-name` | Name of the internal network. | example-internalnetwork |
| `vlan-id` | VLAN identifier with range from 501 to 3000. | 805 |

The following parameters are *optional* for creating internal networks:

| Parameter | Description | Example |
| --- | --- | --- |
| `mtu` | L3 MTU to be configured for the internal network. Maximum supported value is 9000. Default is 1500. | 1500 |
| `connected-ipv4-subnets` | IPv4 subnet to be used for the internal network. | 10.0.0.0/24 |
| `extension` | Extension flag for the internal network. Allowed values: `NoExtension`, `NPB`. Default is `NoExtension`. | NoExtension |
| `is-monitoring-enabled` | Enable or disable Two-Way Active Measurement Protocol (TWAMP) monitoring on the internal network. Allowed values: `True`, `False`. Default is `False`. | False |
| `bgp-configuration` | BGP configuration properties. See [BGP configuration fields](#bgp-configuration-fields). | |
| `static-route-configuration` | Static route configuration properties. | |
| `import-route-policy` | Import route policy, either IPv4 or IPv6. | |
| `export-route-policy` | Export route policy, either IPv4 or IPv6. | |
| `ingress-acl-id` | ARM resource ID of the ingress access control list. | |
| `egress-acl-id` | ARM resource ID of the egress access control list. | |
| `native-ipv4-prefix-limit` | Native IPv4 prefix limit configuration properties. | |
| `annotation` | Switch configuration description. | |

#### BGP configuration fields

The following fields are specified within the `--bgp-configuration` parameter:

| Field | Description | Example |
| --- | --- | --- |
| `peerASN` | Peer ASN of the network function. | 65047 |
| `defaultRouteOriginate` | Enables a default route to be originated when advertising routes via BGP. Allowed values: `True`, `False`. | True |
| `allowAS` | Allows routes to be received and processed even if the router detects its own ASN in the AS-Path. To disable, input 0. Possible values are 1 to 10 and the default is 2. | 2 |
| `allowASOverride` | Enable or disable allowAS. | Enable |
| `ipv4ListenRangePrefixes` | BGP IPv4 listen range. Maximum range allowed is /28. | 10.1.2.0/28 |
| `ipv4NeighborAddress` | IPv4 neighbor address. | 10.0.0.11 |


### Create an internal network with BGP configuration and specified peering address

You must create an internal network before you enable an L3 isolation domain. This command creates an internal network with BGP configuration and a specified peering address:

1. Set parameters as needed. Set parameters in angle brackets \< \> to your own values. Remove the angle brackets when you run the command.

    ```azurecli
    $resourceGroupName = "example-resourcegroup"
    $isoDomainName = "example-l3domain"
    $resourceName = "example-internalnetwork"
    $vLanId = "805"
    $ConnectedIPv4Subnets = "[{prefix:'10.1.2.0/24'}]"   
    $mtu = "1500"
    $bgpConfiguration =  "{defaultRouteOriginate:True,allowAS:2,allowASOverride:Enable,peerASN:65047,ipv4ListenRangePrefixes:['10.1.2.0/28']}"
    ```

1. Create the internal network with BGP configuration:

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
    
        "peerASN": 65047 
      }, 
    
      "configurationState": "Succeeded", 
      "connectedIPv4Subnets": [ 
        { 
          "prefix": "10.1.2.0/24" 
        } 
      ], 
    
      "id": "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/l3IsolationDomains/example-l3domain/internalNetworks/example-internalnetwork", 
      "isMonitoringEnabled": "False", 
      "mtu": 1500, 
      "name": "example-internalnetwork", 
      "networkFabricId": "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/networkFabrics/NFName", 
      "provisioningState": "Succeeded", 
      "resourceGroup": "example-resourcegroup", 
      "systemData": { 
        "createdAt": "2023-XX-XXT00:00:00.0000000Z", 
        "createdBy": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx", 
        "createdByType": "Application", 
        "lastModifiedAt": "2023-XX-XXT00:00:00.0000000Z", 
        "lastModifiedBy": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx", 
        "lastModifiedByType": "Application" 
      }, 
    
      "type": "microsoft.managednetworkfabric/l3isolationdomains/internalnetworks", 
      "vlanId": 805 
    } 
    ```
    </details>

### Create an internal network with static routes

1. Set parameters as needed. Set parameters in angle brackets \< \> to your own values. Remove the angle brackets when you run the command.

    ```azurecli
    $resourceGroupName = "example-resourcegroup"
    $isoDomainName = "example-l3domain"
    $resourceName = "example-internalnetwork-2"
    $vLanId = "2600"
    $ConnectedIPv4Subnets = "[{prefix:'10.2.0.0/24'}]"   
    $mtu = "1500"
    ```

1. Create the internal network with multiple static routes with a single next hop:
    
    ```azurecli
    az networkfabric internalnetwork create --resource-group $resourceGroupName --l3-isolation-domain-name $isoDomainName --resource-name $resourceName --vlan-id $vLanId --mtu $mtu --connected-ipv4-subnets $ConnectedIPv4Subnets --static-route-configuration "{bfdConfiguration:{multiplier:5,intervalInMilliSeconds:300},ipv4Routes:[{prefix:'10.3.0.0/24',nextHop:['10.5.0.1']},{prefix:'10.4.0.0/24',nextHop:['10.6.0.1']}]}" 
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
      "id": "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/l3IsolationDomains/example-l3domain/internalNetworks/example-internalnetwork-2", 
      "isMonitoringEnabled": "False", 
      "mtu": 1500, 
      "name": "example-internalnetwork-2", 
      "networkFabricId": "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/networkFabrics/NFName", 
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
        "createdAt": "2023-XX-XXT00:00:00.0000000Z", 
        "createdBy": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx", 
        "createdByType": "Application", 
        "lastModifiedAt": "2023-XX-XXT00:00:00.0000000Z", 
        "lastModifiedBy": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx", 
        "lastModifiedByType": "Application" 
      }, 
    
      "type": "microsoft.managednetworkfabric/l3isolationdomains/internalnetworks", 
      "vlanId": 2600 
    } 
    ```
    </details>

## Create an external network

By using external networks, workloads can connect through Layer 3 to your provider edge devices. When you use external networks, workloads can interact with external services like firewalls and DNS. For Option A peering, you provide the peer ASN (`peerASN`) of your provider edge device. For Option B peering, you provide route targets.

The commands for creating an external network by using Azure CLI include the following parameters.

### Review external network parameters

The following parameters are *required* for creating external networks:

| Parameter | Description | Example |
| --- | --- | --- | 
| `l3-isolation-domain-name` | Resource name of the L3 isolation domain. | example-l3domain |
| `resource-group` | Use the corresponding NFC resource group name. | NFCresourcegroupname |
| `resource-name` | Name of the external network. | example-externalnetwork |
| `peering-option` | Peering using either option A or option B. Possible values are `OptionA` and `OptionB`. | OptionB |

The following parameters are *optional* for creating external networks:

| Parameter | Description | Example |
| --- | --- | --- |
| `option-a-properties` | Configuration of `OptionA` properties. Refer to the `OptionA` example in a subsequent section. | |
| `option-b-properties` | Configuration of `OptionB` properties. To specify, use `exportIpv4/Ipv6RouteTargets` or `importIpv4/Ipv6RouteTargets`. | `exportIpv4RouteTargets:['1234:1234']` |
| `nni-id` | ARM resource ID of the network-to-network interconnect (NNI) of the external network. | |
| `import-route-policy` | Import route policy, either IPv4 or IPv6. | |
| `export-route-policy` | Export route policy, either IPv4 or IPv6. | |
| `static-route-configuration` | Static route configuration. | |
| `annotation` | Switch configuration description. | | 


For Option A, you need to create an external network before you enable the L3 isolation domain. An external network is dependent on an internal network, so you can't enable an external network without an internal network. The `vlan-id` value should be between 501 and 3000.


### Create an external network using Option B

1. Set parameters as needed. 

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
    az networkfabric externalnetwork create --resource-group $resourceGroupName --l3-isolation-domain-name $isoDomainName --resource-name $resourceName --peering-option $peeringOption --option-b-properties "{routeTargets:{exportIpv4RouteTargets:['$exportIpv4RouteTargets'],importIpv4RouteTargets:['$importIpv4RouteTargets']}}" 
    ```

    <details>
    <summary>Expand this section to see an example output.</summary>

    ```json
    { 
      "administrativeState": "Enabled", 
      "id": "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/l3IsolationDomains/example-l3domain/externalNetworks/example3-externalnetwork", 
      "name": "example3-externalnetwork", 
      "networkFabricId": "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/networkFabrics/NFName", 
      "networkToNetworkInterconnectId": "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/networkFabrics/NFName/networkToNetworkInterconnects/NNIName", 
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
        "createdAt": "2023-XX-XXT00:00:00.0000000Z", 
        "createdBy": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx", 
        "createdByType": "Application", 
        "lastModifiedAt": "2023-XX-XXT00:00:00.0000000Z", 
        "lastModifiedBy": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx", 
        "lastModifiedByType": "Application" 
      }, 
    
      "type": "microsoft.managednetworkfabric/l3isolationdomains/externalnetworks" 
    } 
    ```
    </details>

### Create an external network using Option A

1. Set parameters as needed. 

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
    az networkfabric externalnetwork create --resource-group $resourceGroupName --l3-isolation-domain-name $isoDomainName --resource-name $resourceName --peering-option $peeringOption --option-a-properties "{peerASN:$peerASN,vlanId:$vlanId,mtu:$mtu,primaryIpv4Prefix:'$primaryIpv4Prefix',secondaryIpv4Prefix:'$secondaryIpv4Prefix'}" 
    ``` 

    <details>
    <summary>Expand this section to see an example output.</summary>

    ```json
    { 
      "administrativeState": "Enabled", 
      "id": "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/l3IsolationDomains/example-l3domain/externalNetworks/example-externalipv4network", 
      "name": "example-externalipv4network", 
      "networkFabricId": "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/networkFabrics/NFName", 
      "networkToNetworkInterconnectId": "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/networkFabrics/NFName/networkToNetworkInterconnects/NNIName", 
      "optionAProperties": { 
        "fabricASN": 65050, 
        "mtu": 1500, 
        "peerASN": 65026, 
        "primaryIpv4Prefix": "10.18.0.148/30", 
        "secondaryIpv4Prefix": "10.18.0.152/30", 
        "vlanId": 2423 
      }, 
    
      "peeringOption": "OptionA", 
      "provisioningState": "Succeeded", 
      "resourceGroup": "example-resourcegroup", 
      "systemData": { 
        "createdAt": "2023-XX-XXT00:00:00.0000000Z", 
        "createdBy": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx", 
        "createdByType": "Application", 
        "lastModifiedAt": "2023-XX-XXT00:00:00.0000000Z", 
        "lastModifiedBy": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx", 
        "lastModifiedByType": "Application" 
      }, 
    
      "type": "microsoft.managednetworkfabric/l3isolationdomains/externalnetworks" 
    }
    ```
    </details>

### Create an external network using IPv6

1. Set parameters as needed.

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
    az networkfabric externalnetwork create --resource-group $resourceGroupName --l3-isolation-domain-name $isoDomainName --resource-name $resourceName --peering-option $peeringOption --option-a-properties "{peerASN:$peerASN,vlanId:$vlanId,mtu:$mtu,primaryIpv6Prefix:'$primaryIpv6Prefix',secondaryIpv6Prefix:'$secondaryIpv6Prefix'}" 
    ```
    
    The supported primary and secondary IPv6 prefix size is /127. 

    <details>
    <summary>Expand this section to see an example output.</summary>

    ```json
    { 
      "administrativeState": "Enabled", 
      "id": "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/l3IsolationDomains/example-l3domain/externalNetworks/example-externalipv6network", 
      "name": "example-externalipv6network", 
      "networkFabricId": "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/networkFabrics/NFName", 
      "networkToNetworkInterconnectId": "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/networkFabrics/NFName/networkToNetworkInterconnects/NNIName", 
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
      "resourceGroup": "example-resourcegroup", 
      "systemData": { 
        "createdAt": "2023-XX-XXT00:00:00.0000000Z", 
        "createdBy": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx", 
        "createdByType": "Application", 
        "lastModifiedAt": "2023-XX-XXT00:00:00.0000000Z", 
        "lastModifiedBy": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx", 
        "lastModifiedByType": "Application" 
      }, 
    
      "type": "microsoft.managednetworkfabric/l3isolationdomains/externalnetworks" 
    }
    ``` 
    </details>

### Enable an L3 isolation domain

1. Set parameters as needed.

    ```azurecli
    $resourceGroupName = "example-resourcegroup"
    $resourceName = "example-l3domain"
    ```

1. Enable an L3 isolation domain.

    ```azurecli
    az networkfabric l3domain update-admin-state --resource-group $resourceGroupName --resource-name $resourceName --state Enable 
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
      "networkFabricId": "/subscriptions/xxxxxx-xxxxxx-xxxx-xxxx-xxxxxx/resourceGroups/NFResourceGroupName/providers/Microsoft.ManagedNetworkFabric/networkFabrics/NFName", 
      "provisioningState": "Succeeded", 
      "redistributeConnectedSubnets": "True", 
      "redistributeStaticRoutes": "False", 
      "resourceGroup": "example-resourcegroup", 
      "systemData": { 
        "createdAt": "2023-XX-XXT00:00:00.0000000Z", 
        "createdBy": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx", 
        "createdByType": "Application", 
        "lastModifiedAt": "2023-XX-XXT00:00:00.0000000Z", 
        "lastModifiedBy": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx", 
        "lastModifiedByType": "Application" 
      },				  
    
      "type": "microsoft.managednetworkfabric/l3isolationdomains" 
    } 
    ```
    </details>

    > [!NOTE]
    > Use the `az networkfabric l3domain show` command to verify that the administrative state changed to `Enabled`.

    A newly created L3 isolation domain is in the `Disabled` state by default, so you create your internal and external networks first and then enable the domain.

    To add more internal or external networks to an L3 isolation domain that's already enabled, first disable the domain, add the networks, and then enable it again. To disable the domain, use the same command with `--state Disable`:

    ```azurecli
    az networkfabric l3domain update-admin-state --resource-group $resourceGroupName --resource-name $resourceName --state Disable
    ```

## Delete an L3 isolation domain

1. Set parameters as needed.

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

## Next steps

- [Create logical networks](./multi-rack-create-logical-networks.md)
