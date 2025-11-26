---
title: Create and Manage an Internal Load Balancer on Multi-Rack Deployments for Azure Local (Preview)
description: Learn to create and configure internal load balancers for Azure Local multi-rack deployments (preview).
#customer intent: As a network administrator, I want to understand the internal load balancers on Azure Local so that I can have the correct setup for my deployment.
author: ronmiab
ms.author: robess
ms.reviewer: alkohli
ms.date: 11/24/2025
ms.topic: concept-article
ms.service: azure-local
---

# Create and manage an internal load balancer in multi-rack deployments of Azure Local (preview)

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article described how to create an internal load balancer on multi-rack deployments for Azure Local using Azure CLI.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Prerequisites  

Before you begin, complete the following prerequisites:  

- Review and [complete the prerequisites](../manage/azure-arc-vm-management-prerequisites.md).  

- Access to an Azure subscription with the appropriate role-based access control (RBAC) role and permissions assigned. For more information, see [RBAC to manage Azure Local virtual machines (VMs) for multi-rack deployments (preview)](../multi-rack/multi-rack-assign-vm-rbac-roles.md).

- Access to a resource group where you want to provision the public IP address.

- Access to the ARM ID of the custom location associated with your Azure Local multi-rack instance where you want to provision the load balancer resource.

- For backend pools you want to add to the load balancer instance, make sure you have the ARM IDs of the network interfaces you want to add to the backend pool and of the VNet they are in.

- Access to ARM ID of the VNet subnet where you want to create the load balancer.

  - If there's no public load balancer already on this VNet, you need to provide an empty subnet without any user VMs.

  - If there's already a public load balancer on the target VNet, provide the same subnet ARM ID where the other load balancer is present.
  
- If you're using a client to connect to your Azure Local multi-rack instance, see [Connect to the system remotely](../manage/azure-arc-vm-management-prerequisites.md#connect-to-the-system-remotely).

## Create internal load balancer on virtual networks using Azure CLI

Use the `az stack-hci-vm network lb` cmdlet to create an internal load balancer on virtual networks in your Azure Local instance.

Key things to consider before you create an internal load balancer:

- After creating the load baancer, you can't update the frontend IP or the virtual network subnet.

- To update tags, you can only use `az stack-hci-vm network lb update`.

- To add or associate backend pools, load balancing rules, or probes, use `az stack-hci-vm network lb create` with the same variables you used when creating the load balancer, plus the new values.

### Review required parameters

Before creating the load balancer, review the required parameters in the following table:

| **Parameters** | **Description** |
|---|---|
| **name** | Name for the load balancer on the Azure Local multi-rack instance. Make sure to provide a name that follows the [Naming rules for Azure network resources](/azure/azure-resource-manager/management/resource-name-rules#microsoftnetwork). You can't rename a load balancer after creation. |
| **resource-group** | Name of the resource group where you create the load balancer. |
| **custom-location** | Use this parameter to provide the fully qualified Azure Resource Manager (ARM) ID of the custom location associated with your Azure Local instance where you're creating this load balancer. |
| **location** | Azure regions as specified by az locations. |
| **frontend-ip-config-names** | Names for the frontend IP configurations. |
| **frontend-ip-subnet-ids** | ARM IDs of the virtual network subnet where you create all your load balancer instances. No other resources should be present in this delegated subnet. |
| **frontend-ip-allocation-methods** | Choose an allocation method for the private address assigned to your load balancer instance. Allowed values: **Static** and **Default** |
| **frontend-ip-private-address** | If you choose **Static** as the allocation method, you must provide the private IP address you want to assign your load balancer instance. |
| **backend-pool-names** | Names for the backend pools |
| **backend-pool-backend-addresses** | An array of backend addresses. Each entry takes three inputs:<br><br>1. "name": Name of the specific backend server/resource<br>1. "network_interface_ip_configuration": ARM ID of the network interface's IP configuration. |
| **backend-pool-virtual-network-ids** | ARM ID of the Virtual Network where the backend pool resources reside. All backend resources should be in the same virtual network as the load balancer. |
| **lb-rule-names** | Names for the load balancing rules. |
| **lb-rule-frontend-ip-config-names** | Names of the frontend IP configurations you want to include in the scope of this load balancing rule. |
| **lb-rule-backend-pool-names** | Names of the backend IP configurations you want to include in the scope of this load balancing rule |
| **lb-rule-frontend-ports** | The port for the external endpoint. Port numbers for each rule must be unique within the load balancer. |
| **lb-rule-backend-ports** | The port for internal connections on the endpoint. |
| **lb-rule-protocols** | Reference to the transport protocol used by the load balancing rule (All, Tcp, Udp) |
| **lb-rule-probe-names** | Reference to the probe to associate with this rule |
| **lb-rule-load-distributions** | Load distribution policy for this rule. Allowed values:<br>**Default** (5-tuple hash of source IP, source port, destination IP, destination port, protocol - distributes connections evenly),<br><br>**SourceIP** (2-tuple hash of source IP, destination IP - ensures requests from same client IP go to same backend), or<br><br>**SourceIPProtocol** (3-tuple hash of source IP, destination IP, protocol - balances between client affinity and distribution). |
| **lb-rule-idle-timeouts** | The timeout for the TCP idle connection. This element is only used when the protocol is set to Tcp. |
| **probe-names** | Names for the probes you want to create for this load balancer |
| **probe-protocols** | Transport protocol used by this probe |
| **probe-ports** | Ports for communicating the probe. |

### Steps to create an internal load balancer on virtual networks

The example in this section shows how to create an internal load balancer on a virtual network with backend pools, load balancing rules, and probes already configured.

#### Sign in and set subscription

1. Connect to your Azure Local multi-rack instance.  

1. Sign in. Type:

    ```azurecli
    az login --use-device-code
    ```

1. Set your subscription. Type:

    ```azurecli
    az account set --subscription <Subscription ID> 
    ```

#### Set parameters

1. Set the [parameters](#review-required-parameters). Here's an example:  

    > [!NOTE]
    > When no Public IP resource is provided in the frontend configuration, the load balancer becomes an internal load balancer.

    ```azurecli
    $location = "eastus"
    $subscriptionID = "<subscription-ID>"
    $resourceGroup = "mylocal-rg"
    $customLocationID = "/subscriptions/$subscriptionID/resourceGroups/$resourceGroup/providers/Microsoft.ExtendedLocation/customLocations/$customLocationName"
    $name = "mylocal-VNET-InternalLB"
    $frontendIPConfigName = "fe1"
    $frontendIPPrivateAddress = "10.0.0.4"
    $frontendIPAllocationMethod = "Static"
    $frontendIPSubnetID = "/subscriptions/$subscriptionID/resourceGroups/mylocal-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/mylocal-subnet1"
    $lbRuleName = "rule1"
    $lbRuleBackendPoolName = "web-backend"
    $lbRuleFrontendIPConfigName = "fe1"
    $lbRuleFrontendPort = 80
    $lbRuleBackendPort = 8080
    $lbRuleProtocol = "Tcp"
    $lbRuleProbeName = "probe1"
    $lbRuleLoadDistributions = "Default"
    $probePort = 80
    $probeName = "probe1"
    $probeProtocol = "Http"
    $probeIntervals = 5
    $probeRequestPaths = "/"
    $probeNumProbes = 2
    $backendPoolName = "web-backend"
    $backendVNetID = "/subscriptions/$subscriptionID/resourceGroups/mylocal-rg/providers/Microsoft.Network/virtualNetworks/mylocal-vnet"
    ```

1. Set backend pool addresses.

    ```azurecli
    $backendPoolBEAddresses = '[{\"name\": \"nic1\", \"admin_state\": \"Up\", \"network_interface_ip_configuration\": \"/subscriptions/$subscriptionID/resourceGroups/$resourceGroup/providers/Microsoft.AzureStackHCI/networkInterfaces/nic1/ipConfigurations/ipconfig\"}, {\"name\": \"nic2\", \"admin_state\": \"Up\", \"network_interface_ip_configuration\": \"/subscriptions/$subscriptionID/resourceGroups/$resourceGroup/providers/Microsoft.AzureStackHCI/networkInterfaces/nic2/ipConfigurations/ipconfig\"}]'
    ```

#### Create the internal load balancer

1. Create a load balancer. Run the following cmdlet:  

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
    --lb-rule-idle-timeouts 4 `
    --probe-request-paths $probeRequestPaths `
    --probe-intervals $probeIntervals `
    --probe-num-probes $probeNumProbes `
    --custom-location $customLocationID
    ```