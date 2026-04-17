---
title: Create Load Balancers on Logical Networks using Azure CLI in Multi-Rack Deployments of Azure Local (preview)
description: Learn how to create load balancers on logical networks using Azure CLI in multi-rack deployments of Azure Local (preview).
ms.topic: how-to
ms.date: 11/25/2025
author: alkohli
ms.author: alkohli
ms.subservice: multi-rack
---

# Create load balancers on logical networks using Azure CLI in multi-rack deployments of Azure Local (preview)

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

- To add multiple backend pools, rules, frontend IP configs, or probes, either:

  - Repeat the `--frontend-ip`, `--backend-pool`, `--lb-rule`, or `--probe` parameters with key values for each additional configuration within the `az stack-hci-vm network lb create` command.
  - Or run the relevant subgroup command to add, delete, or update specific items for these configuration types. For example:
    - `az stack-hci-vm network lb frontend-ip add/delete`
    - `az stack-hci-vm network lb backend-pool add/update/delete`
    - `az stack-hci-vm network lb probe add/update/delete`
    - `az stack-hci-vm network lb lb-rule add/update/delete`

### Required parameters

Before you begin, review the required parameters:

| Parameter | Description |
|--|--|
| name | Name for the load balancer. Follow the [naming rules for Azure network resources](/azure/azure-resource-manager/management/resource-name-rules#microsoftnetwork). You can't rename a load balancer after it's created. |
| resource-group | Name of the managed resource group of the custom location. |
| custom-location | ARM ID of the custom location associated with your Azure Local instance where you're creating this load balancer. |
| location | Azure region as specified by `az locations`. |
| frontend-ip | Configuration for a single frontend IP as space-separated key=value pairs. See below for details of the required keys. Can be repeated to configure multiple frontend IPs. |
| backend-pool | Configuration for a single backend pool as space-separated key=value pairs. See below for details of the required keys. Can be repeated to configure multiple backend pools. |
| probe | Configuration for a single backend health probe as space-separated key=value pairs. See below for details of the required keys. Can be repeated to configure multiple probes. |
| lb-rule | Configuration for a single load balancing rule as space-separated key=value pairs. See below for details of the required keys. Can be repeated to configure multiple load balancing rules. |

#### Required keys for frontend-ip

| Key | Description |
|--|--|
| name | Name for the frontend IP configuration. |
| public-ip-id | Required for load balancer on logical network. Azure Resource Manager ID of the Public IP resource you want to assign to your load balancer. Each frontend IP configuration can have only one public IP address, but multiple frontend IP configurations are supported. The logical network that the public IP belongs to should be the logical network you wish to deploy your load balancer on. |

#### Required keys for backend-pool

| Key | Description |
|--|--|
| name | Name for the backend pool. |
| addresses | A comma-separated list of Azure Resource Manager IDs of the network interface's IP configuration, for each network interface you wish to include in the backend pool. |
| lnet-id | Azure Resource Manager ID of the Logical Network where the backend pool resources reside. NOTE: All backend resources should be in the same logical network as the load balancer. |

#### Required keys for probes

| Key | Description |
|--|--|
| name | Name for the probe you want to create for this load balancer. |
| protocol | Transport protocol used by this probe. |
| port | Port for communicating with the probe. |

#### Required keys for load balancing rules

| Key | Description |
|--|--|
| name | Name for the load balancing rule. |
| frontend-ip | Name of the frontend IP configuration you want to include in the scope of this load balancing rule. This must correspond to a frontend IP configuration also supplied in a `--frontend-ip` parameter. |
| backend-pool | Name of the backend IP configuration you want to include in the scope of this load balancing rule. This must correspond to a backend pool also supplied in a `--backend-pool` parameter. |
| frontend-port | The port for the external endpoint. Port numbers for each rule must be unique within the load balancer. |
| backend-port | The port for internal connections on the endpoint. |
| protocol | Reference to the transport protocol used by the load balancing rule (All, Tcp, Udp). |
| probe | Reference to the probe to associate with this rule. This must correspond to a probe supplied with a `--probe` parameter. |
| load-distribution | Load distribution policy for this rule. Allowed values:<br>- **Default**: 5-tuple hash (source IP, source port, destination IP, destination port, protocol) distributes connections evenly.<br>- **SourceIP**: 2-tuple hash (source IP, destination IP) ensures requests from same client IP go to same backend.<br>- **SourceIPProtocol**: 3-tuple hash (source IP, destination IP, protocol) balances between client affinity and distribution. |

### Steps to create a load balancer on a logical network

The example in this section demonstrates how to create a load balancer on a logical network with backend pools, load balancing rules, and probes already configured.

#### Sign in and set subscription

1. Connect to your Azure Local instance.

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
    $resourceGroup = "my-mrg"  
    $customLocationName = "mylocal-cl"
    $customLocationID ="/subscriptions/$subscriptionID/resourceGroups/$resourceGroup/providers/Microsoft.ExtendedLocation/customLocations/$customLocationName"  
    $name = "mylocal-LNET-LB" 
    $frontendIPConfigName= "fe1"
    $frontendIPPublicIP = "/subscriptions/$subscriptionID/resourceGroups/$resourceGroup/providers/Microsoft.AzureStackHCI/publicIPAddresses/mylocal-publicIP"
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
    $backendLNetID = "/subscriptions/$subscriptionID/resourceGroups/$resourceGroup/providers/Microsoft.AzureStackHCI/logicalNetworks/mylocal-lnet"
    ```

1. Set backend pool addresses.

    ```azurecli
    $backendPoolBEAddresses = "/subscriptions/$subscriptionID/resourceGroups/$resourceGroup/providers/Microsoft.AzureStackHCI/networkInterfaces/nic1/ipConfigurations/ipconfig","/subscriptions/$subscriptionID/resourceGroups/$resourceGroup/providers/Microsoft.AzureStackHCI/networkInterfaces/nic2/ipConfigurations/ipconfig"
    ```

#### Create the load balancer

Create a load balancer. Run the following cmdlet:  

```azurecli
az stack-hci-vm network lb create `
--subscription $subscriptionID `
--resource-group $resourceGroup `
--name $name `
--location $location `
--frontend-ip name=$frontendIPConfigName public-ip-id=$frontendIPPublicIP `
--backend-pool name=$backendPoolName addresses=$backendPoolBEAddresses lnet-id=$backendLNetID `
--lb-rule name=$lbRuleName frontend-ip=$lbRuleFrontendIPConfigName backend-pool=$lbRuleBackendPoolName frontend-port=$lbRuleFrontendPort backend-port=$lbRuleBackendPort protocol=$lbRuleProtocol probe=$lbRuleProbeName load-distribution=$lbRuleLoadDistribution `
--probe name=$lbRuleProbeName protocol=$probeProtocol port=$probePort path=$probeRequestPath interval=$probeInterval threshold=$probeNumProbe `
--custom-location $customLocationID
```
