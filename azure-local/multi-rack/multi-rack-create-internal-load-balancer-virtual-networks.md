---
title: Create and Manage an Internal Load Balancer on Multi-Rack Deployments for Azure Local (Preview)
description: Learn to create and configure internal load balancers for Azure Local multi-rack deployments (preview).
#customer intent: As a network administrator, I want to understand the internal load balancers on Azure Local so that I can have the correct setup for my deployment.
author: ronmiab
ms.author: robess
ms.date: 11/24/2025
ms.topic: how-to
ms.service: azure-local
ms.subservice: multi-rack
---

# Create and manage an internal load balancer in multi-rack deployments of Azure Local (preview)

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article describes how to create an internal load balancer on multi-rack deployments for Azure Local using Azure CLI.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Prerequisites  

Before you begin, complete the following prerequisites:  

- Review and [complete the prerequisites](./multi-rack-vm-management-prerequisites.md).  
- The `stack-hci-vm` Azure CLI extension version 1.13.0 or later. To check your version, run `az extension show --name stack-hci-vm`. To install or upgrade, see [Install CLI extensions for multi-rack](multi-rack-cli-extensions.md).

- Access to an Azure subscription with the appropriate role-based access control (RBAC) role and permissions assigned. For more information, see [RBAC to manage Azure Local virtual machines (VMs) for multi-rack deployments (preview)](../multi-rack/multi-rack-assign-vm-rbac-roles.md).

- Access to a resource group where you want to provision the load balancer.

- Access to the ARM ID of the custom location associated with your Azure Local multi-rack instance where you want to provision the load balancer resource.

- For backend pools you want to add to the load balancer instance, make sure you have the ARM IDs of the network interfaces you want to add to the backend pool and of the VNet they are in.

- Access to ARM ID of the VNet subnet where you want to create the load balancer.

  - If there's no public load balancer already on this VNet, you need to provide an empty subnet without any user VMs.

  - If there's already a public load balancer on the target VNet, provide the same subnet ARM ID where the other load balancer is present.
  
- If you're using a client to connect to your Azure Local multi-rack instance, see [Connect to the system remotely](./multi-rack-vm-management-prerequisites.md#connect-to-the-system-remotely).

## Create internal load balancer on virtual networks using Azure CLI

Use the `az stack-hci-vm network lb` cmdlet to create an internal load balancer on virtual networks in your Azure Local instance.

Key things to consider before you create an internal load balancer:

- After creating the load balancer, you can't update the frontend IP or the virtual network subnet.

- To update tags, you can only use `az stack-hci-vm network lb update`.

- To add or associate backend pools, rules, frontend IP configs, or probes, either:

  - Repeat the `--frontend-ip`, `--backend-pool`, `--lb-rule`, or `--probe` parameters with key values for each additional configuration within the `az stack-hci-vm network lb create` command.
  - Or run the relevant subgroup command to add, delete, or update specific items for these configuration types. For example:
    - `az stack-hci-vm network lb frontend-ip add/delete`
    - `az stack-hci-vm network lb backend-pool add/update/delete`
    - `az stack-hci-vm network lb probe add/update/delete`
    - `az stack-hci-vm network lb lb-rule add/update/delete`

### Review required parameters

Before creating the load balancer, review the required parameters in the following table:

| **Parameters** | **Description** |
|---|---|
| **name** | Name for the load balancer on the Azure Local multi-rack instance. Make sure to provide a name that follows the [Naming rules for Azure network resources](/azure/azure-resource-manager/management/resource-name-rules#microsoftnetwork). You can't rename a load balancer after creation. |
| **resource-group** | Name of the resource group where you create the load balancer. |
| **custom-location** | Use this parameter to provide the fully qualified Azure Resource Manager (ARM) ID of the custom location associated with your Azure Local instance where you're creating this load balancer. |
| **location** | (Optional) Azure regions as specified by az locations. If not specified, the location of the resource group is used. |
| **frontend-ip** | Configuration for a single frontend IP as space-separated key=value pairs. See below for details of the required keys. Can be repeated to configure multiple frontend IPs. |
| **backend-pool** | Configuration for a single backend pool as space-separated key=value pairs. See below for details of the required keys. Can be repeated to configure multiple backend pools. |
| **probe** | Configuration for a single backend health probe as space-separated key=value pairs. See below for details of the required keys. Can be repeated to configure multiple probes. |
| **lb-rule** | Configuration for a single load balancing rule as space-separated key=value pairs. See below for details of the required keys. Can be repeated to configure multiple load balancing rules. |

#### Keys for frontend-ip

| **Key** | **Required** | **Description** |
|---|---|---|
| **name** | Yes | Name for the frontend IP configuration. |
| **subnet-id** | Yes | Azure Resource Manager ID of the virtual network subnet where all your load balancer instances are created. No other workload resources should be present in this delegated subnet. |
| **allocation-method** | No | Choose allocation method for the private address assigned to your load balancer instance. Allowed values: Static and Dynamic. Defaults to Dynamic. |
| **private-ip** | No | If you choose "Static" as the allocation method, you must provide the private IP address you want to assign your load balancer instance. |

#### Keys for backend-pool

| **Key** | **Required** | **Description** |
|---|---|---|
| **name** | Yes | Name for the backend pool. |
| **addresses** | Yes | A comma-separated list of Azure Resource Manager IDs of the network interface's IP configuration, for each network interface you wish to include in the backend pool. |
| **vnet-id** | No | Azure Resource Manager ID of the Virtual Network where the backend pool resources reside. NOTE: All backend resources should be in the same virtual network as the load balancer. |

#### Keys for probes

| **Key** | **Required** | **Description** |
|---|---|---|
| **name** | Yes | Name for the probe you want to create for this load balancer. |
| **protocol** | Yes | Transport protocol used by this probe. Allowed values: Tcp, Http. |
| **port** | Yes | Port for communicating with the probe. |
| **path** | Required for Http | URL path for Http probes to use when checking backend health. |
| **interval** | No | Interval in seconds between probe attempts. |
| **threshold** | No | Number of consecutive probe failures before the backend is considered unhealthy. |

#### Keys for load balancing rules

| **Key** | **Required** | **Description** |
|---|---|---|
| **name** | Yes | Name for the load balancing rule. |
| **frontend-ip** | Yes | Name of the frontend IP configuration you want to include in the scope of this load balancing rule. This must correspond to a frontend IP configuration also supplied in a `--frontend-ip` parameter. |
| **backend-pool** | Yes | Name of the backend IP configuration you want to include in the scope of this load balancing rule. This must correspond to a backend pool also supplied in a `--backend-pool` parameter. |
| **frontend-port** | Yes | The port for the external endpoint. Port numbers for each rule must be unique within the load balancer. |
| **backend-port** | Yes | The port for internal connections on the endpoint. |
| **protocol** | Yes | Reference to the transport protocol used by the load balancing rule. Allowed values: Tcp, Udp. |
| **probe** | No | Reference to the probe to associate with this rule. This must correspond to a probe supplied with a `--probe` parameter. |
| **load-distribution** | No | Load distribution policy for this rule. Allowed values:<br>**Default** (5-tuple hash of source IP, source port, destination IP, destination port, protocol - distributes connections evenly),<br><br>**SourceIP** (2-tuple hash of source IP, destination IP - ensures requests from same client IP go to same backend), or<br><br>**SourceIPProtocol** (3-tuple hash of source IP, destination IP, protocol - balances between client affinity and distribution). |

### Steps to create an internal load balancer on virtual networks

The example in this section shows how to create an internal load balancer on a virtual network with backend pools, load balancing rules, and probes already configured.

#### Sign in and set subscription

1. Connect to your Azure Local multi-rack instance.  

1. Sign in. Type:

    ```powershell
    az login --use-device-code
    ```

1. Set your subscription. Type:

    ```powershell
    az account set --subscription <Subscription ID> 
    ```

#### Set parameters

1. Set the [parameters](#review-required-parameters). Here's an example:  

    > [!NOTE]
    > When no Public IP resource is provided in the frontend configuration, the load balancer becomes an internal load balancer.

    ```powershell
    $location = "eastus"
    $subscriptionID = "<subscription-ID>"
    $resourceGroup = "mylocal-rg"
    $clusterResourceGroup = "<Cluster Resource Group>"
    $customLocationName = "<Custom Location Name>"
    $customLocationID = "/subscriptions/$subscriptionID/resourceGroups/$clusterResourceGroup/providers/Microsoft.ExtendedLocation/customLocations/$customLocationName"
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
    $lbRuleLoadDistribution = "Default"
    $probePort = 80
    $probeName = "probe1"
    $probeProtocol = "Http"
    $probeInterval = 5
    $probeRequestPath = "/"
    $probeNumProbe = 2
    $backendPoolName = "web-backend"
    $backendVNetID = "/subscriptions/$subscriptionID/resourceGroups/mylocal-rg/providers/Microsoft.Network/virtualNetworks/mylocal-vnet"
    ```

1. Set backend pool addresses.

    ```powershell
    $backendPoolBEAddresses = "/subscriptions/$subscriptionID/resourceGroups/$resourceGroup/providers/Microsoft.AzureStackHCI/networkInterfaces/nic1/ipConfigurations/ipconfig","/subscriptions/$subscriptionID/resourceGroups/$resourceGroup/providers/Microsoft.AzureStackHCI/networkInterfaces/nic2/ipConfigurations/ipconfig"
    ```

#### Create the internal load balancer

Create a load balancer. Run the following cmdlet:  

```powershell
az stack-hci-vm network lb create `
    --subscription $subscriptionID `
    --resource-group $resourceGroup `
    --name $name `
    --location $location `
    --frontend-ip name=$frontendIPConfigName private-ip=$frontendIPPrivateAddress allocation-method=$frontendIPAllocationMethod subnet-id=$frontendIPSubnetID `
    --backend-pool name=$backendPoolName addresses=$backendPoolBEAddresses vnet-id=$backendVNetID `
    --lb-rule name=$lbRuleName frontend-ip=$lbRuleFrontendIPConfigName backend-pool=$lbRuleBackendPoolName frontend-port=$lbRuleFrontendPort backend-port=$lbRuleBackendPort protocol=$lbRuleProtocol probe=$lbRuleProbeName load-distribution=$lbRuleLoadDistribution `
    --probe name=$lbRuleProbeName protocol=$probeProtocol port=$probePort path=$probeRequestPath interval=$probeInterval threshold=$probeNumProbe `
    --custom-location $customLocationID
```
