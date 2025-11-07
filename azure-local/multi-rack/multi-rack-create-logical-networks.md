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
> Dynamic IP allocation is not supported on Azure Local Rack Scale preview version.

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
> - Fabric Network (reference to the underlying L3 Internal Network) (applies to all) 

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
    | **vlan** | VLAN identifier for Azure Local VMs. If no VLAN ID is specified, the logical network (LNET) is created with a default VLAN ID of 0. In this configuration, the Azure Local VM sends untagged network traffic, which the physical switch maps to its default VLAN.<br>**Note**: Outbound traffic from the VM, such as internet-bound packets, may be dropped if a default VLAN isn’t configured on the physical switch to handle untagged traffic. |
    | **address-prefixes** | Subnet address in CIDR notation. For example: "192.168.0.0/16". |
    | **dns-servers** | List of IPv4 addresses of DNS servers. Specify multiple DNS servers in a space separated format. For example: "10.0.0.5" "10.0.0.10" |
    | **gateway** | Ipv4 address of the default gateway. |

    > [!NOTE]
    > DNS server, gateway, and VLAN ID must be specified if you're creating a static logical network.
 

1. Create a static logical network. Run the following cmdlet:

    ```azurecli
    az stack-hci-vm network lnet create --subscription $subscription --resource-group $resource_group --custom-location $customLocationID --location $location --name $lnetName --ip-allocation-method "Static" --address-prefixes $addressPrefixes --gateway $gateway --dns-servers $dnsServers --fabric-network-configuration-id $internalNetworkName
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


# [Azure portal](#tab/azureportal)

Complete the following steps to create a logical network using Azure portal.

1. In the left pane, under **Resources**, select **Logical networks**.

   :::image type="content" source="./media/multi-rack-create-logical-networks/select-logical-network.png" alt-text="Screenshot showing Resources pane in Azure portal." lightbox="./media/multi-rack-create-logical-networks/select-logical-network.png":::

1. In the right pane, select **Create logical network**.

   :::image type="content" source="./media/multi-rack-create-logical-networks/create-logical-network.png" alt-text="Screenshot showing logical network creation link." lightbox="./media/multi-rack-create-logical-networks/create-logical-network.png":::

1. On the **Create logical network** page, on the **Basics** tab:

    - Select the Azure subscription name.
    - Select the associated resource group name.
    - Provide a logical network name. Make sure to provide a name that follows the [Rules for Azure resources.](/azure/azure-resource-manager/management/resource-name-rules#microsoftnetwork) You can't rename a logical network after it's created.
    - Enter the virtual switch name that you saved earlier.
    - The geographic region is automatically set to the region where you registered your system.
    - The custom location is automatically populated from the system.

    When complete, select **Next: Network Configuration**.

   :::image type="content" source="./media/multi-rack-create-logical-networks/enter-network-name.png" alt-text="Screenshot showing Basics tab." lightbox="./media/multi-rack-create-logical-networks/enter-network-name.png":::

### Create a static logical network via portal

1. On the **Network configuration** tab, select **Static** and then enter the following:
    - IPv4 address space (previously reserved).
    - IP pools (if used).
    - Default gateway address.
    - DNS server address.
    - VLAN ID (if used).

    When complete, select **Review + Create**.

   :::image type="content" source="./media/multi-rack-create-logical-networks/enter-ip-addresses.png" alt-text="Screenshot showing Network configuration tab." lightbox="./media/multi-rack-create-logical-networks/enter-ip-addresses.png":::

1. On the **Review + Create** tab, review network settings and then select **Create**:

   :::image type="content" source="./media/multi-rack-create-logical-networks/review-and-create-static.png" alt-text="Screenshot showing static network properties page." lightbox="./media/multi-rack-create-logical-networks/review-and-create-static.png":::

### Create a DHCP logical network via portal

1. On the **Network Configuration** tab, select **DHCP**, and then select **Review + Create**.

1. Enter VLAN ID if used.

   :::image type="content" source="./media/multi-rack-create-logical-networks/configure-dynamic.png" alt-text="Screenshot of DHCP configuration for logical network." lightbox="./media/multi-rack-create-logical-networks/configure-dynamic.png":::

1. On the **Review + Create** tab, review settings and then select **Create**:

   :::image type="content" source="./media/multi-rack-create-logical-networks/review-and-create.png" alt-text="Screenshot of Review + Create for the DHCP logical network." lightbox="./media/multi-rack-create-logical-networks/review-and-create.png":::

### Deploy the logical network via portal

These steps are the same for both static and DHCP network deployments.

1. Verify the network deployment job was submitted:

   :::image type="content" source="./media/multi-rack-create-logical-networks/submitting-deployment.png" alt-text="Screenshot of the submitted deployment job." lightbox="./media/multi-rack-create-logical-networks/submitting-deployment.png":::

1. Verify that the deployment is in progress:

   :::image type="content" source="./media/multi-rack-create-logical-networks/deployment-in-progress.png" alt-text="Screenshot indicating that the deployment job is in progress." lightbox="./media/multi-rack-create-logical-networks/deployment-in-progress.png":::

1. Verify the deployment job completed successfully and then select either **Pin to dashboard** or **Go to resource group**:

   :::image type="content" source="./media/multi-rack-create-logical-networks/deployment-succeeded.png" alt-text="Screenshot of successful completion of the deployment job." lightbox="./media/multi-rack-create-logical-networks/deployment-succeeded.png":::

1. In the resource group, select **Overview** and then verify the logical network is created and listed on the **Resources** tab:

   :::image type="content" source="./media/multi-rack-create-logical-networks/verify-network-created.png" alt-text="Screenshot of the newly created logical network." lightbox="./media/multi-rack-create-logical-networks/verify-network-created.png":::

---

## Next steps

- [Create Azure Local VMs enabled by Azure Arc](../manage/create-arc-virtual-machines.md)