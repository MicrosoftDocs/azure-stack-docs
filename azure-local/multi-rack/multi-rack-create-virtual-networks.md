---
title: Create virtual networks for multi-rack deployments of Azure Local (Preview)
description: Learn how to create virtual networks for multi-rack deployments of Azure Local (Preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 11/14/2025
---

# Create virtual networks for multi-rack deployments of Azure Local (Preview)

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article provides an overview of virtual networks (VNets) for multi-rack deployments of Azure Local and shows how to create one.

## What are virtual networks?

Virtual networks are the Software Defined Networking (SDN) resource available for multi-rack deployments. Virtual networks on Azure Local function similar to Azure virtual networks by providing a private, overlay network solution. They offer the same benefits of scale and isolation as Azure virtual networks.

Based on the structure of Azure virtual networks, the following are provided:

- **Address space**: When creating a VNet on Azure Local for multi-rack deployments, you define a private IP address space using one or more CIDRs (Classless Inter-Domain Routing), for example 10.0.0.0/16. All resources deployed within the VNet receive a private IP address from this space. We recommend using private IP address ranges defined in RFC 1918 (such as 10.0.0.0/8, 172.16.0.0/12, and 192.168.0.0/16).

- **Subnets**: Each VNet address space can be segmented into smaller subnets to group and isolate resources and to apply different security policies to each subnet.

> [!NOTE]
> VNet peering isn't supported for multi-rack deployments.

## Using a virtual network for multi-rack deployments

- **Communication between resources on the same VNet**: Routing is automatically enabled between all resources in a VNet, unless explicitly denied using network security rules. Resources can communicate with each other using the assigned private IP addresses.

- **Configure outbound communication**: To enable outbound traffic from your VNet resources, you need to configure a NAT Gateway.  

- **Configure inbound communication**: To enable inbound traffic to your VNet resources, you need to configure a Software Load Balancer (recommended) or configure inbound rules on a NAT gateway.

- **Filter network traffic**: You can create Network Security Groups (NSGs) with security rules to filter traffic to and from resources by source and destination IP address, port, and protocol.  

## Prerequisites  

- Review and [complete the prerequisites](../manage/azure-arc-vm-management-prerequisites.md). If using a client to connect to your Azure Local, see [Connect to the system remotely](../manage/azure-arc-vm-management-prerequisites.md#connect-to-the-system-remotely).  
- Access to a resource group where you want to provision the virtual network.
- Access to Azure Resource Manager (ARM) ID of the custom location associated with your Azure Local instance where you want to provision the virtual network.

## Create the virtual network

You can create a virtual network using either the Azure Command-Line Interface (CLI) or by using ARM templates.  

> [!NOTE]
> After you create a virtual network, you can't update any fields except tags.

Complete the following steps to create a virtual network using Azure CLI.  

## Sign in and set subscription  

1. Connect to your deployment instance.

1. Sign in. Type:

    ```azurecli
    az login --use-device-code  
    ```

1. Set your subscription.

    ```azurecli
    az account set --subscription <Subscription ID>  
    ```

## Create virtual network via Azure CLI  

To create a virtual network on your Azure Local instance use the `azstack-hci-vm network vnet` cmdlet. Only IPv4 addresses are supported. There's no support for IPv6 addresses.

Complete these steps in Azure CLI to configure a virtual network:  

1. Set the parameters. Here's an example:  

    ```azurecli
    $vnetName = "mylocal-vnet"  
    $location = "eastus"  
    $customLocationID ="/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ExtendedLocation/customLocations/$customLocationName"  
    $addressPrefixes = “10.0.0.0/16” 
    $dnsServers = "192.168.200.222"  
    $resourceGroup = "mylocal-rg" 
    ```

    The required parameters:  

    | Parameter | Description  |
    | --- | --- |
    | name  | Name for the virtual network on the deployment instance. Make sure to provide a name that follows the [Naming rules for Azure network resources](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming). You can't rename a virtual network after it's created. |  
    | resource-group  | Name of the resource group where you create the virtual network.  |
    | custom-location  | Use this to provide the full ARM ID of the custom location associated with your Azure Local where you're creating this virtual network.  |
    | location  | Azure regions as specified by az locations. |
    | address-prefixes |  Private address space in CIDR notation. For example: "10.0.0.0/16".  |

1. Create a virtual network. Run the following cmdlet:  

    ```azurecli
    az stack-hci-vm network vnet create \ 
      --resource-group $resourceGroup \ 
      --name $vnetName \ 
      --location $location \ 
      --custom-location $customLocationID \ 
      --address-prefixes $addressPrefixes \ 
      --dns-servers $dnsServers \ 
    ```

    Here's a sample output:  

    ```output
    {
      "extendedLocation": {
        "name": "/subscriptions/<SubscriptionID>/resourceGroups/mylocal-rg>/providers/Microsoft.ExtendedLocation/customLocations/<CustomLocation>",
        "type": "CustomLocation"
      },
      "id": "/subscriptions/<SubscriptionID>/resourceGroups/mylocal-rg/providers/Microsoft.AzureStackHCI/virtualNetworks/mylocal-vnet",
      "location": "eastus",
      "name": "mylocal-vnet",
      "properties": {
        "addressSpace": {
          "addressPrefixes": [
            "10.0.0.0/16"
          ]
        },
        "dhcpOptions": {
          "dnsServers": [
            "10.X.X.X"
          ]
        },
        "provisioningState": "Succeeded",
        "status": {
          "errorCode": null,
          "errorMessage": null,
          "provisioningStatus": {
            "operationId": "<operationId>",
            "status": "Succeeded"
         }
        }
      },
      "resourceGroup": "mylocal-rg",
      "systemData": {
        "createdAt": "2025-11-10T16:35:05.518894+00:00",
        "createdBy": "user@contoso.com",
        "createdByType": "User",
        "lastModifiedAt": "2025-11-10T16:35:12.499753+00:00",
        "lastModifiedBy": "<lastModifiedBy>",
        "lastModifiedByType": "Application"
      },
      "tags": null,
      "type": "microsoft.azurestackhci/virtualnetworks"
    }
    ```  

    Once the virtual network is created, you can create a subnet.

## Create a virtual network subnet

After you create a virtual network, you can create one or more subnets on the virtual network. You need to define at least one subnet in a VNet as the workloads, including network interfaces, load balancers, and others are housed to a subnet in a virtual network.  

> [!NOTE]
> Only the NSG field can be modified after VNet subnet creation.

Complete these steps in Azure CLI to configure a virtual network subnet:

1. Set the parameters. Here's an example:

    ```azurecli
    $subnetName = "mylocal-subnet"  
    $vnetName = “mylocal-vnet” 
    $location = "eastus"  
    $customLocationID ="/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ExtendedLocation/customLocations/$customLocationName"  
    $addressPrefix = “10.0.0.0/24” 
    $dnsServers = "192.168.200.222"  
    $subscription = "<Subscription ID>"  
    $resourceGroup = "mylocal-rg"  
    $nsg = “mylocal-nsg” --- Optional 
    $routes = “'[{"name":"default","address_prefix":"0.0.0.0/0","next_hop_ip_address":"10.0.0.1"}]'”  
    ```

    The required parameters:  

    | Parameter | Description |
    | --- | --- |
    | name  | Name for the virtual network subnet on the deployment instance. Make sure to provide a name that follows the Naming rules for Azure network resources. You can't rename a virtual network subnet after it's created.  |
    | vnet-name | Name of the parent virtual network. |
    | resource-group  | Name of the resource group where you create the logical network. For ease of management, we recommend that you use the same resource group as the parent virtual network.  |
    | subscription  | Subscription ID you want to use for the resource creation.  |
    | custom-location  | Use this to provide the custom location associated with your Azure Local where you're creating this virtual network subnet.  |
    | location  | Azure regions as specified by az locations. |
    | address-prefix  | Private address space in CIDR notation. Must fall within the parent virtual network address space. For example: "10.0.0.0/24".  |

1. Create a virtual network subnet. Run the following cmdlet:  

    ```azurecli
    az stack-hci-vm network vnet subnet create \ 
    --resource-group $resourceGroup \ 
    --vnet-name $vnetName \
    --name $subnetName \ 
    --location $location \ 
    --custom-location $customLocationID \ 
    --address-prefix $addressPrefix \ 
    --network-security-group $nsg\ 
    --routes $routes 
    ```

    Here's a sample output:  

    ```output
    {
      "extendedLocation": {
        "name": "/subscriptions/<SubscriptionID>/resourceGroups/<mylocal-rg>/providers/Microsoft.ExtendedLocation/customLocations/<customLocation>",
        "type": "CustomLocation"
      },
      "id": "/subscriptions/<SubscriptionID>/resourceGroups/<mylocal-rg/providers/Microsoft.AzureStackHCI/virtualNetworks/mylocal-vnet/subnets/mylocal-subnet",
      "name": "mylocal-subnet",
      "properties": {
        "addressPrefix": "10.0.0.0/24",
        "ipConfigurations": null,
        "natGateway": null,
        "networkSecurityGroup": null,
        "provisioningState": "Succeeded",
        "routeTable": {
          "etag": null,
          "name": null,
          "properties": null,
          "type": null
        },
        "status": {
          "errorCode": "",
          "errorMessage": "",
          "provisioningStatus": {
            "operationId": "<operationId>",
            "status": "Succeeded"
          }
        }
      },
      "resourceGroup": "mylocal-rg",
      "systemData": {
        "createdAt": "2025-11-10T22:54:18.793244+00:00",
        "createdBy": "user@contoso.com",
        "createdByType": "User",
        "lastModifiedAt": "2025-11-10T22:54:30.424794+00:00",
        "lastModifiedBy": "<lastModifiedBy>",
        "lastModifiedByType": "Application"
      },
      "type": "microsoft.azurestackhci/virtualnetworks/subnets"
    }
    ```

    Once the virtual network subnet is created, you can start creating network interfaces and then, virtual machines. Additionally, you can also create other SDN services like NAT gateway and Software Load Balancer.

<!--Commented out next steps since the article links aren't available yet.
## Next steps  

- Create a network interface
-->