---
title: Create logical networks for Azure Local virtual machines on Azure Local for multi-rack deployments (Preview)
description: Learn how to create logical networks on Azure Local for multi-rack deployments. (Preview)
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 11/07/2025
---

# Create logical networks for Azure Local VMs for multi-rack deployments (Preview)

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article describes how to create or add logical networks on Azure Local for multi-rack deployments. Any Azure Local virtual machines (VMs) that you create use these logical networks.

> [!NOTE]
> Azure Local VMs only support IPv4 addresses. IPv6 addresses aren't supported.

## Prerequisites

Before you begin, make sure to complete the following prerequisites:


# [Azure CLI](#tab/azurecli)

- Make sure to review and [complete the prerequisites](../manage/azure-arc-vm-management-prerequisites.md). If using a client to connect to your Azure Local, see [Connect to the system remotely](../manage/azure-arc-vm-management-prerequisites.md#connect-to-the-system-remotely).

- Make sure that you have at least one L3 Internal Network configured with sufficient IP addresses and that you have the right set of permissions to associate this internal network with the logical network you create. 

- To create VMs with static IP addresses in your address space, add a logical network with static IP allocation. Reserve an IP range with your network admin and make sure to get the address prefix for this IP range.

> [!NOTE]
> Dynamic IP allocation is not supported on Azure Local Rack Scale preview version. Only static logical networks are supported.

# [Azure portal](#tab/azureportal)

The prerequisites for the Azure portal are the same as those for the Azure CLI. See [Azure CLI](../manage/create-logical-networks.md#tabpanel_1_azurecli).

---


## Create the logical network

You can create a logical network using either the Azure Command-Line Interface (CLI) or by using the Azure portal.

> [!NOTE]
> Once a logical network is created, you can't update the following:
>
> - Default gateway
> - IP pools
> - IP address space
> - VLAN ID
> - Virtual switch name (applies to ALM)
> - Fabric Network (reference to the underlying L3 Internal Network) 

# [Azure CLI](#tab/azurecli)

Complete the following steps to create a logical network using Azure CLI.

### Sign in and set subscription

1. [Connect to your Azure Local instance](../deploy/deployment-prerequisites.md).

1. Sign in and type:

    ```azurecli
    az login --use-device-code 
    ```

1. Set your subscription:

    ```azurecli
    az account set --subscription <Subscription ID>

### Create logical network via CLI

You can use the `az stack-hci-vm network lnet create` cmdlet to create a logical network on the L3 internal network of your choice or static IP configuration. Only static IP allocation is supported in Azure Local Rack Scale v1.0.0.

> [!NOTE]
> For both dynamic and static logical networks, the following apply:
> - Creating logical networks with overlapping IP pools on the same VLAN isn't permitted.
> - If a VLAN ID isn't specified, the value defaults to 0.

#### Create a static logical network via CLI

In this release, you can create Azure Local VMs enabled by Azure Arc using a static IP only via the Azure CLI.

Create a static logical network when you want to create Azure Local VMs with network interfaces on these logical networks. Follow these steps in Azure CLI to configure a static logical network:

1. Set the parameters. Here's an example:

    ```azurecli
    $lnetName = "mylocal-lnet-static"
    $internalNetworkName = "<L3InternalNetwork>" 
    $subscription = "<Subscription ID>"
    $resource_group = "mylocal-rg"
    $customLocationName = "mylocal-cl"
    $customLocationID ="/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ExtendedLocation/customLocations/$customLocationName"
    $location = "eastus"
    $addressPrefixes = "100.68.180.0/28"
    $ipPoolEnd = “100.68.180.20” 
    $ipPoolStart = “100.68.180.10”
    $gateway = "192.168.200.1"
    $dnsServers = "192.168.200.222"
    $vlan = "201"
    ```

    > [!NOTE]
    > For the default VM switch created at the deployment, pass the name string encased in double quotes followed by single quotes. For example, a default VM switch ConvergedSwitch(management_compute_storage) is passed as '"ConvergedSwitch(management_compute_storage)"'.

    For static IP, the *required* parameters are tabulated as follows. Contact your network admin to get networking specific input parameters in the table below:

    | Parameters | Description |
    |------------|-------------|
    | **name**  |Name for the logical network that you create for your Azure Local. Make sure to provide a name that follows the [Naming rules for Azure network resources.](/azure/azure-resource-manager/management/resource-name-rules#microsoftnetwork) You can't rename a logical network after it's created. |
    | **resource-group** |Name of the resource group where you create the logical network. For ease of management, we recommend that you use the same resource group as your Azure Local. |
    | **subscription** |Name or ID of the subscription where your Azure Local is deployed. This could be another subscription you use for logical network on your Azure Local. |
    | **custom-location** | Use this to provide the custom location associated with your Azure Local where you're creating this logical network. |
    | **location** | Azure regions as specified by `az locations`. |
    | **vlan** | VLAN ID as configured in the L3 internal network that's been provided as the fabric network resource .<br>**Note**: Outbound traffic from the VM, such as internet-bound packets, may be dropped if a default VLAN isn’t configured on the physical switch to handle untagged traffic. |
    | **address-prefixes** | Subnet address in CIDR notation. For example: "192.168.0.0/16". Must match the "ipv4prefix" in the L3 internal network that's been provided as the fabric network resource. |
    | **dns-servers** | List of IPv4 addresses of DNS servers. Specify multiple DNS servers in a space separated format. For example: "10.0.0.5" "10.0.0.10". Use the `--no-dns-server` flag instead if you choose to not provide this parameter. |
    | **gateway** | Ipv4 address of the default gateway. Use `--no-gateway` flag instead if you choose to not provide this parameter. |

    > [!NOTE]
    > `dns-servers` and `gateway` are optional. Use the `--no-gateway` flag to bypass passing the gateway parameter. Use `--no-dns-servers` flag to bypass passing the `dns-servers` parameter.
 

1. Create a static logical network. Run the following cmdlet:

    ```azurecli
        az stack-hci-vm network lnet create --subscription $subscription --resource-group $resource_group --custom-location $customLocationID --location $location --name $lnetName --ip-allocation-method "Static" --address-prefixes $addressPrefixes --ip-pool-start $ipPoolStart --ip-pool-end $ipPoolEnd --ip-pool-type "vm" --gateway $gateway --dns-servers $dnsServers --fabric-network-configuration-id $fabricResourceID
    ```

    Here's a sample output:

    ```output
    {
      "extendedLocation": {
        "name": "/subscriptions/<Subscription ID>resourceGroups/mylocal-rg/providers/Microsoft.ExtendedLocation/customLocations/mylocal-cl",
        "type": "CustomLocation"
      },
      "id": "/subscriptions/<Subscription ID>resourceGroups/mylocal-rg/providers/Microsoft.AzureStackHCI/logicalnetworks/mylocal-lnet-static",
      "location": "eastus",
      "name": "mylocal-lnet-static",
      "properties": {
        "dhcpOptions": {
          "dnsServers": [
            "192.168.200.222"
          ]
        },
    
        "fabricNetworkConfiguration": { 

          "resourceId": " /subscriptions/<Subscription ID>/resourceGroups/mylocal-rg/providers/Microsoft.ManagedNetworkFabric/l3IsolationDomains/<L3 Isolation Domain> /internalNetworks/<name of internal network>" 

        }, 
        "provisioningState": "Succeeded",
        "status": {},
        "subnets": [
          {
            "name": "mylocal-lnet-static",
            "properties": {
              "addressPrefix": "192.168.201.0/24",
              "addressPrefixes": null,
              "ipAllocationMethod": "Static",
              "ipConfigurationReferences": null,
              "ipPools": null,
              "routeTable": {
                "etag": null,
                "name": null,
                "properties": {
                  "routes": [
                    {
                      "name": "mylocal-lnet-static-default-route",
                      "properties": {
                        "addressPrefix": "0.0.0.0/0",
                        "nextHopIpAddress": "192.168.200.1"
                      }
                    }
                  ]
                },
                "type": null
              },
              "vlan": null
            }
          }
        ],
        
      },
      "resourceGroup": "mylocal-rg",
      "systemData": {
        "createdAt": "2023-11-02T16:38:18.460150+00:00",
        "createdBy": "guspinto@contoso.com",
        "createdByType": "User",
        "lastModifiedAt": "2023-11-02T16:40:22.996281+00:00",
        "lastModifiedBy": "319f651f-7ddb-4fc6-9857-7aef9250bd05",
        "lastModifiedByType": "Application"
      },
      "tags": null,
      "type": "microsoft.azurestackhci/logicalnetworks"
    }
    ```

  Once the logical network creation is complete, you're ready to create virtual machines with network interfaces on these logical networks.


## Next steps

- [Create Azure Local VMs enabled by Azure Arc](../manage/create-arc-virtual-machines.md)