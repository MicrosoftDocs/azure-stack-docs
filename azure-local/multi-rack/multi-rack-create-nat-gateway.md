---
title: Create NAT gateway in Multi-Rack Deployments of Azure Local (preview)
description: Learn how to create NAT gateway in multi-rack deployments of Azure Local (preview).
ms.topic: concept-article
ms.date: 12/08/2025
author: alkohli
ms.author: alkohli
---

# Create a NAT gateway in multi-rack deployments of Azure Local (preview)

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article describes how to create a Network Address Translation (NAT) gateway in multi-rack deployments of Azure Local.

For an overview of NAT gateway, see [About NAT gateway on multi-rack deployments of Azure Local](./multi-rack-nat-gateway-overview.md).

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Prerequisites

- Review and complete all [prerequisites](./multi-rack-prerequisites.md).
- Ensure you have access to the Azure Resource Manager (ARM) ID of the custom location associated with your Azure Local instance where you want to provision the NAT gateway resource.
- Ensure you have access to the ARM ID of the public IP resource that the NAT gateway will use for translation.
- If you're using a client to connect to your Azure Local instance, see [Connect to the system remotely](./multi-rack-vm-management-prerequisites.md#connect-to-the-system-remotely).
- Ensure you have access to an Azure subscription with the appropriate role-based access control (RBAC) role and permissions assigned. For more information, see [Use Role-based Access Control to manage Azure Local VMs for multi-rack deployments](./multi-rack-assign-vm-rbac-roles.md).

- Ensure you have access to a resource group where you want to provision the NAT gateway.

## Create a NAT gateway using Azure CLI

Use the `az stack-hci-vm network nat` command to create a NAT gateway on your Azure Local instance.

Key things to consider before you create a NAT gateway:

- NAT gateway is supported only on virtual networks and can be associated with a virtual network subnet. NAT gateway isn't supported on logical networks.
- After a NAT gateway is created, you can't modify any of its fields except for its NAT inbound rules.
- The commands in this section use PowerShell syntax. If you're running them in a Bash environment, ensure to adjust the JSON field formatting and quoting accordingly.

### Review required parameters

Before you begin, review the required parameters:

| Parameter | Description |
|--|--|
| name | Name for the NAT gateway in Azure Local. Follow the [naming rules for Azure network resources](/azure/azure-resource-manager/management/resource-name-rules#microsoftnetwork). You can't rename a NAT gateway after it's created. |
| resource-group | Name of the resource group where you want to create the NAT gateway. |
| custom-location | Use this to provide the fully qualified ARM ID of the custom location associated with your Azure Local instance where you're creating the NAT gateway. |
| location | Azure region associated with your Azure Local instance. For example, `eastus`, `westeurope`. |
| public-ip-address-ids | ARM IDs of the public IP resources you want to associate with the NAT gateway. **Note:** Currently only one public IP is supported. |
| inbound-nat-rules | Inbound NAT rules provided in a JSON format. Must include:<br>- Name of the rule<br>- Protocol<br>- Frontend port<br>- Backend port<br>- ARM ID of the IP config of the VM network interface (backend)<br>- ARM ID of the public IP of the NAT gateway |

### Sign in and set subscription

1. Connect to your Azure Local instance.

1. Sign in:

    ```azurecli
    az login --use-device-code
    ```

1. Set your subscription:

    ```azurecli
    az account set --subscription <Subscription ID>
    ```
  
### Set the parameters

Set the [parameters](#review-required-parameters). Here's an example:

```azurecli
$location = "eastus"
$resourceGroup = "mylocal-rg"
$customLocationID ="/subscriptions/$subscription/xxxx/<resource-group>/providers/Microsoft.ExtendedLocation/customLocations/xxxx"
$name = "mylocal-NAT-GW"
$publicIP = "/subscriptions/xxxx/resourceGroups/test-rg/providers/Microsoft.Network/publicIPAddresses/mylocal-pip1"
$inboundRules = '[
    {
        \"name\": \"sshRule\",
        \"protocol\": \"Tcp\",
        \"frontend_port\": 2222,
        \"backend_port\": 22,
        \"backend_ip_config_id\": \"/subscriptions/'"$subscriptionID"'/resourceGroups/'"$resourceGroup"'/providers/Microsoft.AzureStackHCI/networkInterfaces/nic1/ipConfigurations/ipconfig\",
        \"public_ip_id\": \"/subscriptions/'"$subscriptionID"'/resourceGroups/'"$resourceGroup"'/providers/Microsoft.AzureStackHCI/publicIPAddresses/mylocal-publicIP\"
    },
    {
        \"name\": \"rdpRule\",
        \"protocol\": \"Tcp\",
        \"frontend_port\": 50001,
        \"backend_port\": 3389,
        \"backend_ip_config_id\": \"/subscriptions/'"$subscriptionID"'/resourceGroups/'"$resourceGroup"'/providers/Microsoft.AzureStackHCI/networkInterfaces/nic2/ipConfigurations/ipconfig\",
        \"public_ip_id\": \"/subscriptions/'"$subscriptionID"'/resourceGroups/'"$resourceGroup"'/providers/Microsoft.AzureStackHCI/publicIPAddresses/mylocal-publicIP\"
    }
]'
```

### Create the NAT gateway

Run the following command to create the NAT gateway:  

```azurecli
az stack-hci-vm network nat create `
--resource-group $resourceGroup `
--name $name `
--location $location `
--public-ip-address-ids $publicIP `
--inbound-nat-rules $inboundRules `
--custom-location $customLocationID
```

Once the NAT gateway is created, you can associate it with a virtual network subnet.

## Associate a virtual network subnet with a NAT gateway

Use the `az stack-hci-vm network vnet subnet update` command to associate a virtual network subnet with a NAT gateway.

Follow these steps to configure a virtual network using Azure CLI:

1. Set the parameters. Here's an example:

    ```azurecli
    $resourceGroup = "mylocal-rg"
    $vnet = "mylocal-vnet"
    $subnet = "mylocal-subnet"
    $natgatewayID = "/subscriptions/xxxx/resourceGroups/test-rg/providers/Microsoft.Network/natGateways/mylocal-NAT-GW"
    ```

    Required parameters:

    | Parameter | Description |
    |--|--|
    |vnet-name | Name of the virtual network whose subnet you want to update. |
    | name | Name of the virtual network subnet you want to update. |
    | resource-group | Name of the resource group where the virtual network subnet exists. |
    | nat-gateway | Fully qualified ARM ID of the NAT gateway you want to associate with the subnet. |

1. Update the virtual network subnet with the NAT gateway reference:

    ```azurecli
    az stack-hci-vm network vnet subnet update \
    --resource-group $resourceGroup \
    --vnet-name $vnet \
    --name $subnet \
    --nat-gateway $natgatewayID
    ```

## Update inbound rules on the NAT gateway

To update NAT inbound rules after the NAT gateway is created, rerun the `az stack-hci-vm network nat create` command using the same configuration values that were specified when the NAT gateway was originally created, along with the updated inbound rule definitions.

## Next steps

- [Create and manage an internal load balancer in multi-rack deployments of Azure Local](./multi-rack-create-internal-load-balancer-virtual-networks.md)
- [Create load balancers on logical networks using Azure CLI in multi-rack deployments of Azure Local](./multi-rack-create-load-balancer-logical-network.md)