---
title: Create logical networks for Azure Local VMs for multi-rack deployments
description: Learn how to create logical networks on Azure Local VMs for multi-rack deployments.
author: sipastak
ms.author: sipastak
ms.topic: how-to
ms.service: azure-local
ms.date: 06/23/2026
ms.subservice: multi-rack
---

# Create logical networks for Azure Local VMs for multi-rack deployments

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article describes how to create or add logical networks for Azure Local virtual machines (VMs) for multi-rack deployments. Azure Local VMs that you create use these logical networks.

> [!NOTE]
> Azure Local VMs support only IPv4 addresses. IPv6 addresses aren't supported.

## Prerequisites

Before you begin, complete these prerequisites:

- Review and [complete the prerequisites](./multi-rack-vm-management-prerequisites.md). If you're using a client to connect to your Azure Local, see [Connect to the system remotely](./multi-rack-vm-management-prerequisites.md#connect-to-the-system-remotely).

- Ensure you have at least one Layer 3 internal network configured with sufficient IP addresses and the right permissions to associate this internal network with the logical network you create.

- Gather the following details about the Layer 3 internal network you plan to associate with the logical network: Azure Resource Manager (ARM) ID, subnet (address prefix), and VLAN ID. These details must match the internal network when creating the logical network.

- To create VMs with static IP addresses in your address space, add a logical network with static IP allocation. Reserve an IP range with your network admin, and get the address prefix for this IP range.

> [!NOTE]
> Dynamic IP allocation isn't supported on Azure Local for multi-rack deployments. Only static logical networks are supported.
>
> When you create logical networks for Azure Local for multi-rack deployments, specify the IP pool with IP pool type `vm`. This action restricts the logical network to those IP addresses.
> If you don't specify an IP pool during logical network creation, the entire subnet address space in the Layer 3 internal network is dedicated to this logical network. No other logical network can be created on this Layer 3 internal network.
> You can create multiple logical networks on the same Layer 3 internal network with non-overlapping IP pools.

> [!IMPORTANT]
> You can't share a logical network between Azure Local VMs enabled by Azure Arc and Azure Kubernetes Service (AKS) enabled by Azure Arc. Create a separate, dedicated logical network for each workload type. Don't reuse a logical network that's used for Azure Local VMs to deploy AKS Arc clusters, and vice versa.

## Create the logical network

You can create a logical network using either the Azure Command-Line Interface (CLI) or the Azure portal.

> [!NOTE]
> After a logical network is created, you can't update any fields except the Network Security Group (NSG) field.

To create a logical network using Azure CLI, follow these steps.

### Sign in and set subscription

1. Connect to your Azure Local instance.

1. Sign in and type:

    ```azurecli
    az login --use-device-code 
    ```

1. Set your subscription:

    ```azurecli
    az account set --subscription "<Subscription ID>"
    ```

### Create logical network

To create a logical network on the Layer 3 internal network of your choice or static IP configuration, use the `az stack-hci-vm network lnet create` command. Only static IP allocation is supported in this release of multi-rack deployments.

> [!IMPORTANT]
> The logical network must align with the Layer 3 internal network you created (or are reusing) in your isolation domain. The `vlan`, `address-prefixes`, `gateway`, and IP pool (`ip-pool-start`/`ip-pool-end`) values aren't arbitrary. They must come from that internal network's VLAN and subnet, and you can't reuse them across logical networks. The example values in the following table reuse the internal network created in the isolation domain article. To create or look up the internal network and its IP range, see [Create an internal network](./multi-rack-configure-layer-3-isolation-domain.md#create-an-internal-network).

> [!NOTE]
> You can't create logical networks with overlapping IP pools on the same VLAN.

#### Create a static logical network

You can create Azure Local VMs enabled by Azure Arc with a static IP only via the Azure CLI.

Create a static logical network when you want to create Azure Local VMs with network interfaces on these logical networks. Follow these steps in Azure CLI to configure a static logical network:

1. Set the parameters. Here's an example:

    ```azurecli
    $lnetName = "mylocal-lnet-static"
    $fabricResourceID = "<L3 ISD internal network ARM ID>"
    $subscription = "<Subscription ID>"
    $resourceGroup = "mylocal-rg"
    $customLocationID = "<custom location ARM resource ID>"
    $location = "eastus"
    $addressPrefixes = "10.1.2.0/24"
    $ipPoolEnd = "10.1.2.20"
    $ipPoolStart = "10.1.2.10"
    $dnsServers = "192.168.200.222"
    $vlan = "805"
    ```

    > [!NOTE]
    > This example associates the logical network with a Layer 3 internal network by passing `fabric-network-configuration-id`, so it doesn't set `gateway`. Set `gateway` only when you create a logical network that isn't associated with a network fabric.

    For static IP, the *required* parameters are tabulated as follows. Contact your network admin to get networking specific input parameters in the following table:

    | Parameters | Description |
    |------------|-------------|
    | **name**  |Name for the logical network that you create for your Azure Local. Make sure to provide a name that follows the [Naming rules for Azure network resources.](/azure/azure-resource-manager/management/resource-name-rules#microsoftnetwork) You can't rename a logical network after it's created. |
    | **resource-group** |Name of the resource group where you create the logical network. For ease of management, we recommend that you use the same resource group as your Azure Local. |
    | **subscription** |Name or ID of the subscription where your Azure Local is deployed. This could be another subscription you use for the logical network on your Azure Local. |
    | **custom-location** | Use this parameter to provide the custom location associated with your Azure Local where you're creating this logical network. |
    | **location** | Azure regions as specified by `az locations`. |
    | **vlan** | VLAN ID as configured in the Layer 3 Internal Network and provided as the fabric network resource. |
    | **address-prefixes** | Subnet address in CIDR notation. For example: "192.168.0.0/16". Must match "ipv4prefix" in the Layer 3 Internal Network provided as the fabric network resource. Only one prefix is supported.|
    | **ip-pool-start** | Start of the IP pool. For example: “192.168.0.0”. |
    | **ip-pool-end** | End of the IP pool. For example: “192.168.0.20”. |
    | **ip-allocation-method** | IP address allocation method. For multirack deployments, use `"Static"`. |
    | **ip-pool-type** | IP pool type. Use `"vm"` to restrict the logical network to the specified IP pool. |
    | **dns-servers** | List of IPv4 addresses of DNS servers. Specify multiple DNS servers in a space separated format. For example: "10.0.0.5" "10.0.0.10" Use the `--no-dns-servers` flag instead if you choose not to provide this parameter.|
    | **gateway** | IPv4 address of the default gateway. Required only when the logical network isn't associated with a managed network fabric (that is, when you don't pass `fabric-network-configuration-id`). When you associate the logical network with a fabric network, routing is provided by the Layer 3 internal network, so `gateway` (and `routes`) must be omitted. |
    | **fabric-network-configuration-id** |ARM resource ID of the Layer 3 Internal network. |

    > [!NOTE]
    > The `dns-servers` parameter is optional. Use the `--no-dns-servers` flag to bypass passing the `dns-servers` parameter.

    > [!IMPORTANT]
    > The `gateway` and `routes` parameters can't be used together with `fabric-network-configuration-id`. Routing configuration isn't supported on logical networks associated with a network fabric. When you pass `fabric-network-configuration-id` (as in the example that follows), omit `gateway` and `routes`.

1. Create a static logical network. Run the following command:

    ```azurecli
    az stack-hci-vm network lnet create --subscription $subscription --resource-group $resourceGroup --custom-location $customLocationID --location $location --name $lnetName --ip-allocation-method "Static" --address-prefixes $addressPrefixes --ip-pool-start $ipPoolStart --ip-pool-end $ipPoolEnd --ip-pool-type "vm" --dns-servers $dnsServers --fabric-network-configuration-id $fabricResourceID --vlan $vlan
    ```

    Here's a sample output:

    <details>
    <summary>Expand this section to see an example output.</summary>

    ```output
    {
      "extendedLocation": {
        "name": "/subscriptions/<Subscription ID>/resourceGroups/mylocal-rg/providers/Microsoft.ExtendedLocation/customLocations/mylocal-cl",
        "type": "CustomLocation"
      },
      "id": "/subscriptions/<Subscription ID>/resourceGroups/mylocal-rg/providers/Microsoft.AzureStackHCI/logicalnetworks/mylocal-lnet-static",
      "location": "eastus",
      "name": "mylocal-lnet-static",
      "properties": {
        "dhcpOptions": {
          "dnsServers": [
            "192.168.200.222"
          ]
        },
        "fabricNetworkConfiguration": {
          "resourceId": "/subscriptions/<Subscription ID>/resourceGroups/<network fabric resource group>/providers/Microsoft.ManagedNetworkFabric/l3IsolationDomains/example-l3domain/internalNetworks/example-internalnetwork"
        },
        "provisioningState": "Succeeded",
        "status": {
          "errorCode": "",
          "errorMessage": "",
          "provisioningStatus": {
            "operationId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
            "status": "Succeeded"
          },
          "fabricIntegration": {
            "state": "Connected",
            "health": "Healthy",
            "resourceType": "L3InternalNetwork",
            "lastChecked": "2023-11-02T16:40:00Z"
          }
        },
        "subnets": [
          {
            "name": "mylocal-lnet-static",
            "properties": {
              "addressPrefix": "10.1.2.0/24",
              "addressPrefixes": null,
              "ipAllocationMethod": "Static",
              "routeTable": {
                "properties": {
                  "routes": [
                    {
                      "name": "mylocal-lnet-static-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx-default-route",
                      "properties": {
                        "addressPrefix": "0.0.0.0/0",
                        "nextHopIpAddress": "10.1.2.1"
                      }
                    }
                  ]
                }
              },
              "vlan": 805
            }
          }
        ],
        "vmSwitchName": null
      },
      "resourceGroup": "mylocal-rg",
      "systemData": {
        "createdAt": "2023-11-02T16:38:18.460150+00:00",
        "createdBy": "user@contoso.com",
        "createdByType": "User",
        "lastModifiedAt": "2023-11-02T16:40:22.996281+00:00",
        "lastModifiedBy": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
        "lastModifiedByType": "Application"
      },
      "tags": null,
      "type": "microsoft.azurestackhci/logicalnetworks"
    }
    ```
    </details>

    After the logical network creation is complete, you're ready to create VMs with network interfaces on these logical networks. You can also create public IP and load balancer resources on these logical networks.

## Next steps

- [Create network interfaces](./multi-rack-create-network-interfaces.md)
- [Create network security groups](./multi-rack-create-network-security-groups.md)
- [Create public IP addresses](./multi-rack-create-public-ip.md)
