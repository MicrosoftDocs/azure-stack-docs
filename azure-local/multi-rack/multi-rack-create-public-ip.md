---
title: Create Public IP Addresses on Multi-rack Deployments of Azure Local (preview)
description: Learn how to create public IP resources on multi-rack deployments of Azure Local (preview).
author: sipastak
ms.author: sipastak
ms.topic: how-to
ms.service: azure-local
ms.date: 11/18/2025
---

# Create public IP addresses on multi-rack deployments of Azure Local (preview)

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article describes how to public IP addresses on multi-rack deployments of Azure Local.

A public IP in a multi-rack deployment of Azure Local represents an externally routable IP address resource.

Unlike Azure public IP addresses, which are always internet-routable, a public IP on multi-rack deployments can be configured with any IP address that is routable within your network or, optionally, internet-facing. This resource can be attached to software defined networking (SDN) services, such as NAT Gateways and Software Load Balancers (SLB), to expose them to external networks (on-prem or the internet).  

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Key characteristics of public IPs on multi-rack deployments

- **Only IPv4**: Public IP address resources can only be IPv4 today. IPv6 addresses aren't supported on multirack deployments.
- **Static allocation only**: Public IP addresses are statically allocated from a user-created logical network with routable IP address space assigned. Dynamic allocation of IP addresses isn't supported. Effectively, the public IP resource is assigned an IP address at the time it’s created and it stays the same throughout the life of the resource.
- **Supported resources**: Public IP address resources can only be assigned to NAT Gateways and SLBs. They can't be associated with a VM network interface.

## Prerequisites

Before you begin, complete these prerequisites:

- Review and [complete the prerequisites](./multi-rack-vm-management-prerequisites.md). If you're using a client to connect to your Azure Local, see [Connect to the system remotely](./multi-rack-vm-management-prerequisites.md#connect-to-the-system-remotely).

- Access to an Azure subscription with the appropriate [RBAC role and permissions assigned](multi-rack-assign-vm-rbac-roles.md).

- Access to a resource group where you want to provision the public IP address.

- Access to the ARM ID of the custom location associated with your Azure Local max instance where you want to provision the public IP resource.

- Access to the ARM ID of the logical network from which the public IP resource would be allocated its IP address.


## Create a public IP resource

You can create a public IP resource using the Azure Command-Line Interface (CLI).

### Sign in and set subscription

1. Connect to your Azure Local instance.

1. Sign in and type:

    ```azurecli
    az login --use-device-code 
    ```

1. Set your subscription:

    ```azurecli
    az account set --subscription <Subscription ID>
    ```

### Create the public IP address

Use the `az stack-hci-vm network public-ip create` command to create a public IP address on your multi-rack deployment.

> [!NOTE]
>
> - Only IPv4 addresses are supported. IPv6 addresses aren't supported.
> - No fields can be modified after creating the public IP resource.

1. Set the parameters. Here's an example:

    ```azurecli
    $location = "eastus"  
    $resourceGroup = "mylocal-rg"  
    $customLocationID ="/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ExtendedLocation/customLocations/$customLocationName"  
    $name = “mylocal-publicip” 
    $allocationScope  ="/subscriptions/$subscription/resourceGroups/$resource_group/providers /Microsoft.AzureStackHCI/logicalNetworks/MyLnet” 
    $ip = "20.30.40.50"  
    ```

    The *required* parameters are tabulated as follows:

    | Parameters | Description |
    |------------|-------------|
    | `name`  |Name for the public IP resource that you create. Make sure to provide a name that follows the [Naming rules for Azure network resources.](/azure/azure-resource-manager/management/resource-name-rules#microsoftnetwork). You can't rename a public IP resource after it's created. |
    | `resource-group` |Name of the resource group where you create the public IP resource. |
    | `subscription` |ARM ID of the subscription you want to use to create your public IP resource. |
    | `custom-location` | ARM ID of the custom location associated with your Azure Local where you're creating this public IP resource. |
    | `location` | Azure regions as specified by `az locations`. |
    | `allocation-scope` | ARM ID of the LogicalNetwork resource from which the public IP should be allocated. |
    | `ip` | If you want to specify a particular static IP address, this optional field can be used. If omitted, the system will pick an IP from the IP pool associated with the logical network. |

1. Create a public IP. Run the following command:

    ```azurecli
    az stack-hci-vm network public-ip create 
    --resource-group $resource_group 
    --name $name
    --location $location 
    --version IPv4
    --allocation-scope $allocationScope
    --ip-address $ip
    --custom-location $customLocationID
    ```

    <!--Here's a sample output:

    ```output
    ``` -->

    Once the public IP is created, you can associate it with a NAT Gateway or a SLB.

## Next steps

- Create a NAT gateway <!--insert link-->
- Create a Software Load Balancer <!--insert link-->