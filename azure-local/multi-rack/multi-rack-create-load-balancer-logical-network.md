---
title: Create Load Balancers on Logical Networks using Azure CLI in Multi-Rack Deployments of Azure Local (Preview)
description: Learn how to create load balancers on logical networks using Azure CLI in multi-rack deployments of Azure Local (Preview).
ms.topic: conceptual
ms.date: 11/20/2025
author: alkohli
ms.author: alkohli
---

# Create load balancers on logical networks using Azure CLI in multi-rack deployments of Azure Local (Preview)

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article describes how to create load balancers on logical networks using Azure CLI in multi-rack deployments of Azure Local.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Prerequisites

- Review and complete the [prerequisites](./multi-rack-prerequisites.md).  
- Access to an Azure subscription with the appropriate RBAC role and permissions. For more information, see [Use Role-based Access Control to manage Azure Local VMs for multi-rack deployments](./multi-rack-assign-vm-rbac-roles.md).
- Access to a resource group where you want to provision the load balancer.
- Access to the Azure Resource Manager (ARM) ID of the custom location associated with your Azure Local instance where you want to provision the load balancer resource.
- Access to ARM ID of the public IP resource for the frontend IP configuration. The public IP resource must come from the same logical network where you’re creating the load balancer.
- For backend pools you want to add to the load balancer instance, make sure you have:
    - ARM IDs of the network interfaces you want to add to the backend pool.
    - ARM ID of the logical network where these backend resources reside.
- If you're using a client to connect to your Azure Local instance, see [Connect to the system remotely](./multi-rack-vm-management-prerequisites.md#connect-to-the-system-remotely).  

## Create load balancers on logical networks using Azure CLI

Use the `az stack-hci-vm network lb` cmdlet to create a load balancer on logical networks in your Azure Local instance.  

Key things to consider before you create a load balancer on logical networks:

- After creating the load balancer, you can't update the frontend IP configuration or change the logical network. The `az stack-hci-vm network lb update` command can only be used to update tags.

- If you need to add more backend pools, rules, or probes, you must use the `az stack-hci-vm network lb create` command again, using the exact same variables you provided during the initial creation.

### Required parameters

Before you begin, review the required parameters:

| Parameter | Description |
|--|--|
| name | Name for the load balancer. Follow the [naming rules for Azure network resources](/azure/azure-resource-manager/management/resource-name-rules#microsoftnetwork). You can't rename a load balancer after it's created. |
| resource-group | Name of the resource group where you create the load balancer. |
| custom-location | ARM ID of the custom location associated with your Azure Local instance where you're creating this load balancer. |
| location | Azure region as specified by `az locations`. |
| frontend-ip-config-names | Name for the frontend IP configuration. Your load balancer can have multiple frontend IP configurations. |
| frontend-ip-public-ip-ids | Required for load balancer on logical network. ARM IDs of the public IP resource you want to assign to your load balancer. The public IP resource should come from the same logical network where the load balancer is being created. |
| backend-pool-names | Names for the backend pools. |
| backend-pool-backend-addresses | Array of backend addresses. Each entry takes three inputs:<br>- **name**: Name of the specific backend server/resource.<br>- **network_interface_ip_configuration**: ARM ID of the network interface’s IP configuration.<br>- **admin_state**: Administrative state (Up, Down, or None). |
| backend-pool-logical-network-ids | ARM ID of the logical network where the backend pool resources reside. All backend resources should be in the same logical network as the load balancer. |
| lb-rule-names | Names for the load balancing rules. |
| lb-rule-frontend-ip-config-names | Names of the frontend IP configurations you want to include in the scope of this load balancing rule. |
| lb-rule-backend-pool-names | Names of the backend IP configurations you want to include in the scope of this load balancing rule. |
| lb-rule-frontend-ports | External endpoint port. Port numbers for each rule must be unique within the load balancer. |
| lb-rule-backend-ports | The port for internal connections on the endpoint. |
| lb-rule-protocols | Transport protocol used by the load balancing rule. Allowed values:<br> All, Tcp, Udp. |
| lb-rule-probe-names | Reference to the probe to associate with this rule. |
| lb-rule-load-distributions | Load distribution policy for this rule. Allowed values:<br>- **Default**: 5-tuple hash (source IP, source port, destination IP, destination port, protocol) distributes connections evenly.<br>- **SourceIP**: 2-tuple hash (source IP, destination IP) ensures requests from same client IP go to same backend.<br>- **SourceIPProtocol**: 3-tuple hash (source IP, destination IP, protocol) balances between client affinity and distribution. |
| lb-rule-idle-timeouts | Timeout for the TCP idle connection. Used only when protocol is set to Tcp. |
| probe-names | Names for the probes you want to create for this load balancer. |
| probe-protocols | Transport protocol used by this probe. |
| probe-ports | Ports for communicating the probe. |

### Steps to create a load balancer on a logical network

The example in this section demonstrates how to create a load balancer on a logical network with backend pools, load balancing rules, and probes already configured.

#### Sign in and set subscription

1. Connect to your Azure Local max instance.

1. Sign in. Type:

    ```azurecli
    az login --use-device-code
    ```

1. Set your subscription.

    ```azurecli
    az account set --subscription <Subscription ID>
    ```
  
#### Set the parameters

1. Set the parameters.

    ```azurecli
    $location = "eastus"  
    $subscriptionID = "<subscription ID>"
    $resourceGroup = "mylocal-rg"  
    $customLocationID ="/subscriptions/$subscriptionID/resourceGroups/$resource_group/providers/Microsoft.ExtendedLocation/customLocations/$customLocationName"  
    $name = "mylocal-LNET-LB" 
    $frontendIPConfigName= "fe1"
    $frontendIPPublicIP = "/subscriptions/$subscriptionID/resourceGroups/$resourceGroup/providers/Microsoft.AzureStackHCI/publicIPAddresses/mylocal-publicIP"
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
    $backendLNetID = "/subscriptions/$subscriptionID/resourceGroups/$resourceGroup/providers/Microsoft.AzureStackHCI/logicalNetworks/mylocal-lnet"
    ```

1. Set backend pool addresses. Depending on your shell, use the appropriate format:

    **BASH**

    ```bash
    $backendPoolBEAddresses = '[{"name": "be1", "admin_state": "Up", "network_interface_ip_configuration": "/subscriptions/$subscriptionID/resourceGroups/$resourceGroup/providers/Microsoft.AzureStackHCI/networkInterfaces/nic1/ipConfigurations/ipconfig"}, {"name": "be2", "admin_state": "Up", "network_interface_ip_configuration": "/subscriptions/$subscriptionID/resourceGroups/$resourceGroup/providers/Microsoft.AzureStackHCI/networkInterfaces/nic2/ipConfigurations/ipconfig"}]'
    ```

    **PowerShell**

    ```powershell
    $backendPoolBEAddresses = '[{\"name\": \"nic1\", \"admin_state\": \"Up\", \"network_interface_ip_configuration\": \"/subscriptions/$subscriptionID/resourceGroups/$resourceGroup/providers/Microsoft.AzureStackHCI/networkInterfaces/nic1/ipConfigurations/ipconfig\"}, {\"name\": \"nic2\", \"admin_state\": \"Up\", \"network_interface_ip_configuration\": \"/subscriptions/$subscriptionID/resourceGroups/$resourceGroup/providers/Microsoft.AzureStackHCI/networkInterfaces/nic2/ipConfigurations/ipconfig\"}]' 
    ```

#### Create the load balancer

1. Create a load balancer. Run the following cmdlet:  

    ```azurecli
    az stack-hci-vm network lb create `
    --subscription $subscriptionID `
    --resource-group $resource_group `
    --name $name `
    --location $location `
    --frontend-ip-config-names $frontendIPConfigName `
    --frontend-ip-public-ip-ids $frontendIPPublicIP `
    --backend-pool-names $backendPoolName `
    --backend-pool-backend-addresses $backendPoolBEAddresses `
    --backend-pool-logical-network-ids $backendLNetID `
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
    --lb-rule-idle-timeouts 4 5 `
    --probe-names $probeName `
    --probe-protocols $probeProtocol `
    --probe-ports $probePort `
    --probe-request-paths $probeRequestPaths `
    --probe-intervals $probeIntervals `
    --probe-num-probes $probeNumProbes `
    --custom-location $customLocationID
    ```

<!--Need to add a sample output-->
<!--Can we add a step to verify that the load balancer is created?-->