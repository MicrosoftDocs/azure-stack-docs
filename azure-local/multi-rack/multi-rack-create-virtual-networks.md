---
title: Create virtual networks on Azure Local for multi-rack deployments (Preview)
description: Learn how to create virtual networks on Azure Local for multi-rack deployments. (Preview)
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 11/07/2025
---

# Create virtual networks on Azure Local for multi-rack deployments (Preview)

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article describes what virtual networks on Azure Local are and how to create them for multi-rack deployments. 

## What are virtual networks? 

Virtual networks are a new software-defined networking resource available for multi-rack deployments. Virtual Networks on Azure Local are similar to Azure Virtual Networks and provide a private, overlay network solution to customers with the same scale and isolation benefits of Azure Virtual networks. 

Following the structure of Azure Virtual Networks, we provide: 

- **Address space**: When creating a VNet for multi-rack deployments, you define a private IP address space using one or more CIDRs (e.g., 10.0.0.0/16). All resources deployed within the VNet will receive a private IP address from this space.  

- **Subnets**: Each VNet’s address space can be segmented into smaller subnets to group and isolate resources and to apply different security policies to each subnet.

> [!NOTE]
> VNet peering isn't supported on Azure Local Rack Scale.

## Using a virtual network for multi-rack deployments

- **Communication between resources on the same VNet**: Routing is automatically enabled between all resources in a VNet, unless explicitly denied using network security rules. Resources can communicate with each other using the assigned private IP addresses. 

- **Configure outbound communication**: To enable outbound traffic from your VNet resources, you need to configure a NAT Gateway.  

- **Configure inbound communication**: To enable inbound traffic to your VNet resources, you need to configure a Software Load Balancer (recommended) or configure inbound rules on a NAT gateway. 

- **Filter network traffic**: You can create Network Security Groups (NSGs) with security rules to filter traffic to and from resources by source and destination IP address, port, and protocol.  

## Prerequisites  

Before you begin, make sure to complete the following prerequisites:

Make sure to review and [complete the prerequisites](../manage/azure-arc-vm-management-prerequisites.md). If using a client to connect to your Azure Local, see [Connect to the system remotely](../manage/azure-arc-vm-management-prerequisites.md#connect-to-the-system-remotely).  

*** Add CLI prereqs? ***

*** Add ARM template prereqs? ***

## Create the virtual network 

You can create a virtual network using either the Azure Command-Line Interface (CLI) or by using ARM templates.  

> [!NOTE]
> Once a virtual network is created, you can't update any fields.

==Azure CLI ==

Complete the following steps to create a virtual network using Azure CLI.  

## Sign in and set subscription  

1. Connect to your Azure Local Rack Scale instance.  

1. Sign in. Type:  

    ```azurecli
    az login --use-device-code  
    ```

1. Set your subscription.  

    ```azurecli
    az account set --subscription <Subscription ID>  
    ```

## Create virtual network via CLI  

You can use the `azstack-hci-vm network vnet` cmdlet to create a virtual network on your Azure Local Rack Scale instance. Only IPv4 addresses are supported - there is no support for IPv6 addresses. 

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
| name  | Name for the virtual network on the Azure Local Rack Scale instance. Make sure to provide a name that follows the Naming rules for Azure network resources. You can't rename a virtual network after it's created. |  
| resource-group  | Name of the resource group where you create the virtual network. For ease of management, we recommend that you use the same resource group as your Azure Local. |  
| custom-location  
| Use this to provide the custom location associated with your Azure Local where you're creating this virtual network.  | 
| location  | Azure regions as specified by az locations.  | 
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
    ** NEED OUTPUT CODE **
    ```  

Once the virtual network is created, you can create a subnet.

## Create a virtual network subnet 

Create virtual network subnet via CLI  

Once you’ve created a virtual network, you can create one or more subnets on the virtual network. You need to define at least one subnet in a VNet as the workloads, including network interfaces, load balancers, and others will be housed to a subnet in a virtual network.  

> [!NOTE]
> Only the Network Security Group (NSG) field can be modified after VNet creation.

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
| name  | Name for the virtual network subnet on the Azure Local Rack Scale instance. Make sure to provide a name that follows the Naming rules for Azure network resources. You can't rename a virtual network after it's created.  |
| vnet-name | Name of the parent virtual network. |
| resource-group  | Name of the resource group where you create the logical network. For ease of management, we recommend that you use the same resource group as your Azure Local.  |
| subscription  | Name or ID of the subscription where your Azure Local is deployed. This could be another subscription you use for logical network on your Azure Local.  |
| custom-location  | Use this to provide the custom location associated with your Azure Local where you're creating this logical network.  |
| location  | Azure regions as specified by az locations.  |
| address-prefix  | Private address space in CIDR notation. Must be fall within the parent virtual network address space. For example: "10.0.0.0/24".  |

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
** NEED OUTPUT CODE **
``` 

Once the virtual network subnet is created, you can start creating network interfaces and subsequently, virtual machines. Additionally, you can also create other SDN services like NAT gateway and Software Load Balancer.

## Next steps  

- [Create a network interface]
- [Associate a VNet Subnet with a NAT Gateway]
- [Create Azure Local VMs enabled by Azure Arc]