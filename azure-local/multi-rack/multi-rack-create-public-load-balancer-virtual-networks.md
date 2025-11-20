---
title: Create Public Load Balancer on Virtual Networks for Multi-Rack Deployments of Azure Local
description: Learn how to create and manage a public Load Balancer on Azure Local for multi-rack deployments. Distribute inbound traffic efficiently across virtual machines.
#customer intent: As a network administrator, I want to learn how to create a public Load Balancer on Azure Local so that I can distribute traffic across virtual machines in a multi-rack deployment.
author: alkohli
ms.author: alkohli
ms.reviewer: alkohli
ms.date: 11/20/2025
ms.topic: how-to
ms.service: azure-local
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
- Get access to a resource group where you want to provision the public IP address.
- Configure a NAT gateway on the virtual network where you’re creating the load balancer. For more information, see [Create a NAT gateway on virtual networks in multi-rack deployments of Azure Local](../index.yml).
- Get access to ARM ID of the custom location associated with your Azure Local instance where you want to provision the load balancer resource.
- To add backend pools to your load balancer instance, get access to the ARM IDs of the network interfaces you want to add to the backend pool and the associated virtual network (virtual network).
- Get access to ARM ID of the VNet subnet where you want to create the load balancer.
  - If a public load balancer doesn't exist on this VNet, provide an empty subnet without any user VMs.
  - If a public load balancer exists on the target VNet, provide the same subnet ARM ID where the other load balancer is present.

    > [!NOTE]
    > You need separate subnets for different types of load balancers.

- If using a client to connect to your Azure Local max instance, see [Connect to the system remotely](./multi-rack-vm-management-prerequisites.md#connect-to-the-system-remotely). 
- Get access to ARM ID of the public IP resource for the frontend IP configuration. The public IP resource must come from the same logical network as the public IP used in the NAT Gateway.

## Create public load balancer on virtual networks using Azure CLI

Complete the following steps to create a Public Load Balancer on a Virtual Network using Azure CLI.  

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
> - To associate backend pools, load balancing rules, or probes after creating the load balancer, use the `az stack-hci-vm network lb` create command with the same parameters.

### Create a public load balancer on virtual networks with Azure CLI

Use the `az stack-hci-vm network lb` cmdlet to create a load balancer on your Azure Local instance.  

> [!NOTE]
> You can't update the frontend IP or the virtual network subnet after creating the load balancer.

Follow these steps in Azure CLI to configure a virtual network:  

1. Set the parameters. Here's an example:  

    ```azurecli    
    $location = "eastus"  
    $subscriptionID = "<subscription ID>"
    $resourceGroup = "mylocal-rg"  
    $customLocationID ="/subscriptions/$subscriptionID/resourceGroups/$resource_group/providers/Microsoft.ExtendedLocation/customLocations/$customLocationName"  
    $name = "mylocal-VNET-PublicLB"
    $frontendIPConfigName= "fe1"
    $frontendIPPublicIP = "/subscriptions/$subscriptionID/resourceGroups/$resourceGroup/providers/Microsoft.AzureStackHCI/publicIPAddresses/mylocal-publicIP"
    $frontendIPPrivateAddress = "10.0.0.4"
    $frontendIPAllocationMethod = "Static"
    $frontendIPSubnetID = "/subscriptions/$subscriptionID/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/mylocal-subnet1"
    $lbRuleName = "rule1"
    $lbRuleBackendPoolName = "web=backend"
    $lbRuleFrontendIPConfigName = "fe1"
    $lbRuleFrontendPort = 80
    $lbRuleBackendPort = 8080
    $lbRuleProtocol = Tcp
    $lbRuleProbeName = "probe1"
    $lbRuleLoadDistributions = Default
    $probePort = 80
    $probeName = "probe1"
    $probeProtocol = "Tcp"
    $probeIntervals = 5
    $probeRequestPaths = "/"
    $probeNumProbes = 2
    $backendPoolName = "web-backend"
    $backendVNetID = "/subscriptions/$subscriptionID/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/mylocal-vnet"
    ```

    **If using BASH**

    ```bash
    $backendPoolBEAddresses = '[{"name": "be1", "admin_state": "Up", "network_interface_ip_configuration": "/subscriptions/$subscriptionID/resourceGroups/$resourceGroup/providers/Microsoft.AzureStackHCI/networkInterfaces/nic1/ipConfigurations/ipconfig"}, {"name": "be2", "admin_state": "Up", "network_interface_ip_configuration": "/subscriptions/$subscriptionID/resourceGroups/$resourceGroup/providers/Microsoft.AzureStackHCI/networkInterfaces/nic2/ipConfigurations/ipconfig"}]'
    ```

    **If using PowerShell:**
    
    ```powershell
    $backendPoolBEAddresses = '[{\"name\": \"nic1\", \"admin_state\": \"Up\", \"network_interface_ip_configuration\": \"/subscriptions/$subscriptionID/resourceGroups/$resourceGroup/providers/Microsoft.AzureStackHCI/networkInterfaces/nic1/ipConfigurations/ipconfig\"}, {\"name\": \"nic2\", \"admin_state\": \"Up\", \"network_interface_ip_configuration\": \"/subscriptions/$subscriptionID/resourceGroups/$resourceGroup/providers/Microsoft.AzureStackHCI/networkInterfaces/nic2/ipConfigurations/ipconfig\"}]'
    ```

    The *required* parameters are tabulated as follows:  
    
    | **Parameters** | **Description** |
    |---|---|
    | **name** | Name for the Load Balancer on the Azure Local instance. Make sure to provide a name that follows the [Naming rules for Azure network resources](/azure/azure-resource-manager/management/resource-name-rules#microsoftnetwork). You can't rename a Load Balancer after it's created. |
    | **resource-group** | Name of the resource group where you create the Load Balancer. |
    | **custom-location** | Use this parameter to provide the fully qualified Azure Resource Manager (ARM) ID of the custom location associated with your Azure Local instance where you're creating this Load Balancer. |
    | **location** | Azure regions as specified by az locations. |
    | **frontend-ip-config-names** | Name(s) for the frontend IP configuration(s). |
    | **frontend-ip-subnet-ids** | ARM IDs of the virtual network subnet where all your load balancer instances are created. No other resources should be present in this delegated subnet. |
    | **frontend-ip-public-ip-ids** | Required for public load balancer. ARM IDs of the Public IP resource you want to assign to your load balancer. Each frontend IP configuration can have only one public IP address, but multiple frontend IP configurations are supported, with the same subnet. |
    | **frontend-ip-allocation-methods** | Choose allocation method for the private address assigned to your load balancer instance. Allowed values: Static and Default. |
    | **frontend-ip-private-address** | If you choose "Static" as the allocation method, you must provide the private IP address you want to assign your load balancer instance. |
    | **backend-pool-names** | Name(s) for the backend pool(s) |
    | **backend-pool-backend-addresses** | An array of backend addresses. Each entry takes three inputs:<br><br>1. "name": Name of the specific backend server/resource<br>1. "network_interface_ip_configuration": ARM ID of the network interface's IP configuration. |
    | **backend-pool-virtual-network-ids** | ARM ID of the Virtual Network where the backend pool resources reside. NOTE: All backend resources should be in the same virtual network as the load balancer. |
    | **lb-rule-names** | Names for the load balancing rules. |
    | **lb-rule-frontend-ip-config-names** | Names of the frontend IP configurations you want to include in the scope of this load balancing rule. |
    | **lb-rule-backend-pool-names** | Names of the backend IP configurations you want to include in the scope of this load balancing rule |
    | **lb-rule-frontend-ports** | The port for the external endpoint. Port numbers for each rule must be unique within the load balancer. |
    | **lb-rule-backend-ports** | The port for internal connections on the endpoint. |
    | **lb-rule-protocols** | Reference to the transport protocol used by the load balancing rule (All, TCP, UDP) |
    | **lb-rule-probe-names** | Reference to the probe to associate with this rule |
    | **lb-rule-load-distributions** | Load distribution policy for this rule. Allowed values:<br>**Default** (5-tuple hash of source IP, source port, destination IP, destination port, protocol - distributes connections evenly),<br><br>**SourceIP** (2-tuple hash of source IP, destination IP - ensures requests from same client IP go to same backend), or<br><br>**SourceIPProtocol** (3-tuple hash of source IP, destination IP, protocol - balances between client affinity and distribution). |
    | **lb-rule-idle-timeouts** | The timeout for the TCP idle connection. This element is only used when the protocol is set to Tcp. |
    | **probe-names** | Names for the probes you want to create for this load balancer |
    | **probe-protocols** | Transport protocol used by this probe |
    | **probe-ports** | Ports for communicating the probe. |


1. Create a Load Balancer. Run the following cmdlet:  

    ```azurecli        
    az stack-hci-vm network lb create `
    --subscription $subscriptionID `
    --resource-group $resource_group `
    --name $name `
    --location $location `
    --frontend-ip-config-names $frontendIPConfigName `
    --frontend-ip-private-addresses $frontendIPPrivateAddress `
    --frontend-ip-allocation-methods $frontendIPAllocationMethod `
    --frontend-ip-subnet-ids $frontendIPSubnetID `
    --frontend-ip-public-ip-ids $frontendIPPublicIP `
    --backend-pool-names $backendPoolName `
    --backend-pool-backend-addresses $backendPoolBEAddresses `
    --backend-pool-virtual-network-ids $backendVNetID `
    --lb-rule-names $lbRuleName `
    --lb-rule-frontend-ip-config-names $lbRuleFrontendIPConfigName `
    --lb-rule-backend-pool-names $lbRuleBackendPoolName `
    --lb-rule-frontend-ports $lbRuleFrontendPort `
    --lb-rule-backend-ports $lbRuleBackendPort `
    --lb-rule-protocols $lbRuleProtocol `
    --lb-rule-probe-names $lbRuleProbeName `
    --lb-rule-load-distributions $lbRuleLoadDistributions `
    --probe-names $lbRuleProbeName `
    --probe-protocols $lbRuleProtocol `
    --probe-ports $probePort `
    --custom-location $customLocation `
    --lb-rule-idle-timeouts 4 5 `
    --probe-names $probeName `
    --probe-protocols $probeProtocol `
    --probe-ports $probePort `
    --probe-request-paths $probeRequestPaths `
    --probe-intervals $probeIntervals `
    --probe-num-probes $probeNumProbes `
    --custom-location $customLocationID
    ```

Here's a sample output:  Need to insert sample output from az cli cmdlet

In this example, you create a Public Load Balancer on a Virtual Network with backend pools, load balancing rules, and probes already configured.

> [!NOTE]
> To add more backend pools, rules, or probes, use the same `az stack-hci-vm network lb create` command. Provide the exact same variables you provided at the time of create plus the new values you want to update your load balancer instance with.
