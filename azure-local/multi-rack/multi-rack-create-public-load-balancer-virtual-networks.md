---
title: Create Public Load Balancer on Virtual Networks for Multi-Rack Deployments of Azure Local
description: Learn how to create and manage a public Load Balancer on Azure Local for multi-rack deployments. Distribute inbound traffic efficiently across virtual machines.
#customer intent: As a network administrator, I want to learn how to create a public Load Balancer on Azure Local so that I can distribute traffic across virtual machines in a multi-rack deployment.
author: alkohli
ms.author: alkohli
ms.reviewer: alkohli
ms.date: 11/24/2025
ms.topic: how-to
ms.service: azure-local
ms.subservice: multi-rack
---

# Create public load balancer on virtual networks on multi-rack deployments of Azure Local

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article describes how to create a public load balancer on a multi-rack deployment of Azure Local using the Azure Command-line Interface (CLI).

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## About public load balancer

Load balancer on Azure Local for multi-rack deployments is a fully managed load balancing service that distributes incoming traffic across backend virtual machines (VMs). A public load balancer on virtual networks provides inbound connectivity from external networks (Internet or enterprise WAN) to VMs (network interfaces) and distributes traffic flows directed to a public frontend IP across a backend pool consisting of VMs in the virtual network.

You can create a load balancer on multi-rack deployments using Azure CLI, Azure Resource Manager (ARM) templates, or Bicep templates.

## Prerequisites  

- Review and [Complete the prerequisites](./multi-rack-vm-management-prerequisites.md).  
- Get access to an Azure subscription with the appropriate RBAC role and permissions assigned. For more information, see [RBAC roles for multi-rack deployments of Azure Local](./multi-rack-assign-vm-rbac-roles.md).
- Access to a resource group where you want to provision the load balancer.
- Configure a NAT gateway on the virtual network where you’re creating the load balancer. For more information, see [Create a NAT gateway on virtual networks in multi-rack deployments of Azure Local](multi-rack-nat-gateway-overview.md).
- Get access to Azure Resource Manager ID of the custom location associated with your Azure Local instance where you want to provision the load balancer resource.
- To add backend pools to your load balancer instance, get access to the Azure Resource Manager IDs of the network interfaces you want to add to the backend pool and the associated virtual network.
- Get access to Azure Resource Manager ID of the VNet subnet where you want to create the load balancer.
  - If a public load balancer doesn't exist on this VNet, provide an empty subnet without any user VMs.
  - If a public load balancer exists on the target VNet, provide the same subnet Azure Resource Manager ID where the other load balancer is present.

    > [!NOTE]
    > You need separate subnets for different types of load balancers.

- If using a client to connect to your Azure Local instance, see [Connect to the system remotely](./multi-rack-vm-management-prerequisites.md#connect-to-the-system-remotely).
- Get access to Azure Resource Manager ID of the public IP resource you wish to use for the frontend IP configuration. The public IP resource must come from the same logical network as the public IP used in the NAT Gateway.

## Create public load balancer on virtual networks using Azure CLI

Complete the following steps to create a public load balancer on a virtual network using Azure CLI.  

## Sign in and set subscription

Follow these steps to sign in and set your subscription.

1. Connect to your Azure Local instance.  

1. Sign in. Type:  

    ```azurecli
      
    az login --use-device-code
    ```

1. Set your subscription.  

    ```azurecli
      
    az account set --subscription <Subscription ID>  
    ```

> [!NOTE]
> - Use the `az stack-hci-vm network lb update` cmdlet to update tags.
> - To associate backend pools, load balancing rules, frontend-ip-config or probes after creating the load balancer, use the relevant `az stack-hci-vm network lb` subgroup command for the given config type.

### Create a public load balancer on virtual networks with Azure CLI

Use the `az stack-hci-vm network lb` cmdlet to create a load balancer on your Azure Local instance.  

> [!NOTE]
> You can't update the frontend IP or the virtual network subnet after creating the load balancer.

Follow these steps in Azure CLI to create a load balancer:  

1. Set the parameters. Here's an example:  

    ```azurecli    
    $location = "eastus"  
    $subscriptionID = "<subscription ID>"
    $resourceGroup = "my-mrg"  
    $customLocationName = "<Custom Location Name>"
    $customLocationID ="/subscriptions/$subscriptionID/resourceGroups/$resourceGroup/providers/Microsoft.ExtendedLocation/customLocations/$customLocationName"  
    $name = "mylocal-VNET-PublicLB"
    $frontendIPConfigName= "fe1"
    $frontendIPPublicIP = "/subscriptions/$subscriptionID/resourceGroups/$resourceGroup/providers/Microsoft.AzureStackHCI/publicIPAddresses/mylocal-publicIP"
    $frontendIPPrivateAddress = "10.0.0.4"
    $frontendIPAllocationMethod = "Static"
    $frontendIPSubnetID = "/subscriptions/$subscriptionID/resourceGroups/$resourceGroup/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/mylocal-subnet1"
    $lbRuleName = "rule1"
    $lbRuleBackendPoolName = "web-backend"
    $lbRuleFrontendIPConfigName = "fe1"
    $lbRuleFrontendPort = 80
    $lbRuleBackendPort = 8080
    $lbRuleProtocol = "Tcp"
    $lbRuleProbeName = "probe1"
    $lbRuleLoadDistribution = "Default"
    $probePort = 80
    $probeName = "probe1"
    $probeProtocol = "Http"
    $probeInterval = 5
    $probeRequestPath = "/"
    $probeNumProbe = 2
    $backendPoolName = "web-backend"
    $backendVNetID = "/subscriptions/$subscriptionID/resourceGroups/$resourceGroup/providers/Microsoft.Network/virtualNetworks/mylocal-vnet"

    $backendPoolBEAddresses = "/subscriptions/$subscriptionID/resourceGroups/$resourceGroup/providers/Microsoft.AzureStackHCI/networkInterfaces/nic1/ipConfigurations/ipconfig","/subscriptions/$subscriptionID/resourceGroups/$resourceGroup/providers/Microsoft.AzureStackHCI/networkInterfaces/nic2/ipConfigurations/ipconfig"
    ```

    The *required* parameters are tabulated as follows:  
    
    | **Parameters** | **Description** |
    |---|---|
    | **name** | Name for the Load Balancer on the Azure Local instance. Make sure to provide a name that follows the [Naming rules for Azure network resources](/azure/azure-resource-manager/management/resource-name-rules#microsoftnetwork). You can't rename a Load Balancer after it's created. |
    | **resource-group** | Name of the managed resource group for your custom location. |
    | **custom-location** | Use this parameter to provide the fully qualified Azure Resource Manager (ARM) ID of the custom location associated with your Azure Local instance where you're creating this Load Balancer. |
    | **location** | Azure regions as specified by az locations. |
    | **frontend-ip** | Configuration for a single frontend IP as space-separated key=value pairs. See below for details of the required keys. Can be repeated to configure multiple frontend IPs. |
    | **backend-pool** | Configuration for a single backend pool as space-separated key=value pairs. See below for details of the required keys. Can be repeated to configure multiple backend pools. |
    | **probe** | Configuration for a single backend health probe as space-separated key=value pairs. See below for details of the required keys. Can be repeated to configure multiple probes. |
    | **lb-rule** | Configuration for a single load balancing rule as space-separated key=value pairs. See below for details of the required keys. Can be repeated to configure multiple load balancing rules. |

    #### Required keys for frontend-ip

    | **Key** | **Description** |
    |---|---|
    | **name** | Name for the frontend IP configuration. |
    | **subnet-id** | Azure Resource Manager ID of the virtual network subnet where all your public load balancer instances are created. No other workload resources should be present in this delegated subnet. |
    | **public-ip-id** | Required for public load balancer. Azure Resource Manager ID of the Public IP resource you want to assign to your load balancer. Each frontend IP configuration can have only one public IP address, but multiple frontend IP configurations are supported, with the same subnet. |
    | **allocation-method** | Choose allocation method for the private address assigned to your load balancer instance. Allowed values: Static and Dynamic. |
    | **private-ip** | If you choose "Static" as the allocation method, you must provide the private IP address you want to assign your load balancer instance. |

    #### Required keys for backend-pool

    | **Key** | **Description** |
    |---|---|
    | **name** | Name for the backend pool. |
    | **addresses** | A comma-separated list of Azure Resource Manager IDs of the network interface's IP configuration, for each network interface you wish to include in the backend pool. |
    | **vnet-id** | Azure Resource Manager ID of the Virtual Network where the backend pool resources reside. NOTE: All backend resources should be in the same virtual network as the load balancer. |

    #### Required keys for probes

    | **Key** | **Description** |
    |---|---|
    | **name** | Name for the probe you want to create for this load balancer. |
    | **protocol** | Transport protocol used by this probe. |
    | **port** | Port for communicating with the probe. |

    #### Required keys for load balancing rules

    | **Key** | **Description** |
    |---|---|
    | **name** | Name for the load balancing rule. |
    | **frontend-ip** | Name of the frontend IP configuration you want to include in the scope of this load balancing rule. This must correspond to a frontend IP configuration also supplied in a `--frontend-ip` parameter. |
    | **backend-pool** | Name of the backend IP configuration you want to include in the scope of this load balancing rule. This must correspond to a backend pool also supplied in a `--backend-pool` parameter. |
    | **frontend-port** | The port for the external endpoint. Port numbers for each rule must be unique within the load balancer. |
    | **backend-port** | The port for internal connections on the endpoint. |
    | **protocol** | Reference to the transport protocol used by the load balancing rule (All, Tcp, Udp). |
    | **probe** | Reference to the probe to associate with this rule. This must correspond to a probe supplied with a `--probe` parameter. |
    | **load-distribution** | Load distribution policy for this rule. Allowed values:<br>**Default** (5-tuple hash of source IP, source port, destination IP, destination port, protocol - distributes connections evenly),<br><br>**SourceIP** (2-tuple hash of source IP, destination IP - ensures requests from same client IP go to same backend), or<br><br>**SourceIPProtocol** (3-tuple hash of source IP, destination IP, protocol - balances between client affinity and distribution). |

1. Create a load balancer. Run the following cmdlet:  

    ```azurecli        
    az stack-hci-vm network lb create `
    --subscription $subscriptionID `
    --resource-group $resourceGroup `
    --name $name `
    --location $location `
    --frontend-ip name=$frontendIPConfigName private-ip=$frontendIPPrivateAddress allocation-method=$frontendIPAllocationMethod subnet-id=$frontendIPSubnetID public-ip-id=$frontendIPPublicIP `
    --backend-pool name=$backendPoolName addresses=$backendPoolBEAddresses vnet-id=$backendVNetID `
    --lb-rule name=$lbRuleName frontend-ip=$lbRuleFrontendIPConfigName backend-pool=$lbRuleBackendPoolName frontend-port=$lbRuleFrontendPort backend-port=$lbRuleBackendPort protocol=$lbRuleProtocol probe=$lbRuleProbeName load-distribution=$lbRuleLoadDistribution `
    --probe name=$lbRuleProbeName protocol=$probeProtocol port=$probePort path=$probeRequestPath interval=$probeInterval threshold=$probeNumProbe `
    --custom-location $customLocationID
    ```

In this example, you create a public load balancer on a virtual network with a backend pool, load balancing rule, and probe already configured.

> [!NOTE]
> To add more backend pools, rules, frontend IP configs, or probes, either:
> - Repeat the `--frontend-ip`, `--backend-pool`, `--lb-rule`, or `--probe` parameters with key values for each additional configuration within the `az stack-hci-vm network lb create` command above.
> - Or you can run the relevant subgroup command to add, delete, or update specific items for these configuration types. For example:
>   - `az stack-hci-vm network lb frontend-ip add/delete`
>   - `az stack-hci-vm network lb backend-pool add/update/delete`
>   - `az stack-hci-vm network lb probe add/update/delete`
>   - `az stack-hci-vm network lb lb-rule add/update/delete`
