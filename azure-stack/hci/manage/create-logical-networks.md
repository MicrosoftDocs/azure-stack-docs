---
title: Create logical networks for Azure Stack HCI cluster (preview)
description: Learn how to create logical networks on your Azure Stack HCI cluster. The Arc VM running on your cluster used this logical network (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 11/17/2023
---

# Create logical networks for Azure Stack HCI (preview)

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article describes how to create or add logical networks for your Azure Stack HCI cluster.

[!INCLUDE [hci-preview](../../includes/hci-preview.md)]

## Prerequisites

Before you begin, make sure to complete the following prerequisites:

[!INCLUDE [hci-vm-image-prerequisites-marketplace](../../includes/hci-vm-image-prerequisites-marketplace.md)]

- Make sure you have an external VM switch that can be accessed by all the servers in your Azure Stack HCI cluster. By default, an external switch is created during the deployment of your Azure Stack HCI cluster that you can use to associate with the logical network you will create.

  Run the following command to get the name of the external VM switch on your cluster.

  ```powershell
  Get-VmSwitch -SwitchType External
  ```

  Make a note of the name of the switch. You use this information when you create a logical network. Here's a sample output:

  ```output
  PS C:\Users\hcideployuser> Get-VmSwitch -SwitchType External
  Name                               SwitchType       NetAdapterInterfaceDescription
  ----                               ----------       ----------------------------
  ConvergedSwitch(management_compute_storage) External        Teamed-Interface
  PS C:\Users\hcideployuser>
  ```

- To create VMs with static IP addresses in your address space, add a logical network with static IP allocation. Reserve an IP range with your network admin and make sure to get the address prefix for this IP range.

## Sign in and set subscription

[!INCLUDE [hci-vm-sign-in-set-subscription](../../includes/hci-vm-sign-in-set-subscription.md)]

## Create logical network

You can use the `az stack-hci-vm network lnet create` cmdlet to create a logical network on the VM switch for DHCP or a static configuration. The parameters used to create a DHCP and a static logical network are different.

### Create a static logical network

In this release, you can create virtual machines using a static IP only via the Azure CLI.

Create a static logical network when you want to create virtual machines with network interfaces on these logical networks. Follow these steps in Azure CLI to configure a static logical network:


1. Set the parameters. Here's an example:

    ```azurecli
    $lnetName = "myhci-lnet-static"
    $vmSwitchName = '"ConvergedSwitch(management_compute_storage)"'
    $subscription = "<Subscription ID>"
    $resource_group = "myhci-rg"
    $customLocationName = "myhci-cl"
    $customLocationID ="/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ExtendedLocation/customLocations/$customLocationName"
    $location = "eastus"
    $addressPrefixes = "100.68.180.0/28"
    $gateway = "192.168.200.1"
    $dnsServers = " 192.168.200.222"
    ```

    > [!NOTE]
    > For the default VM switch created at the deployment, pass the name string encased in double quotes followed by single quotes. For example, a default VM switch ConvergedSwitch(management_compute_storage) is passed as '"ConvergedSwitch(management_compute_storage)"'.

    For static IP, the *required* parameters are tabulated as follows:

    | Parameters | Description |
    |------------|-------------|
    | **name**  |Name for the logical network that you create for your Azure Stack HCI cluster. Make sure to provide a name that follows the [Rules for Azure resources.](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-networking) You can't rename a logical network after it's created. |
    | **vm-switch-name** |Name of the external virtual switch on your Azure Stack HCI cluster where you deploy the logical network. |
    | **resource-group** |Name of the resource group where you create the logical network. For ease of management, we recommend that you use the same resource group as your Azure Stack HCI cluster. |
    | **subscription** |Name or ID of the subscription where your Azure Stack HCI is deployed. This could be another subscription you use for logical network on your Azure Stack HCI cluster. |
    | **custom-location** | Use this to provide the custom location associated with your Azure Stack HCI cluster where you're creating this logical network. |
    | **location** | Azure regions as specified by `az locations`. |
    | **vlan** |VLAN identifier for Arc VMs. Contact your network admin to get this value. A value of 0 implies that there's no VLAN ID. |
    | **ip-allocation-method** | IP address allocation method and could be `Dynamic` or `Static`. If this parameter isn't specified, by default the logical network is created with a dynamic configuration. |
    | **address-prefixes** | Subnet address in CIDR notation. For example: "192.168.0.0/16". |
    | **dns-servers** | List of IPv4 addresses of DNS servers. Specify multiple DNS servers in a space separated format. For example: "10.0.0.5" "10.0.0.10" |
    | **gateway** | Ipv4 address of the default gateway. |

    > [!NOTE]
    > DNS server and gateway must be specified if you're creating a static logical network.

1. Create a static logical network. Run the following cmdlet:

    ```azurecli
    az stack-hci-vm network lnet create --subscription $subscription --resource-group $resource_group --custom-location $customLocationID --location $location --name $lnetName --vm-switch-name $vmSwitchName --ip-allocation-method "Static" --address-prefixes $addressPrefixes --gateway $gateway --dns-servers $dnsServers     
    ```

    Here's a sample output:

    ```output
    {
      "extendedLocation": {
        "name": "/subscriptions/<Subscription ID>resourceGroups/myhci-rg/providers/Microsoft.ExtendedLocation/customLocations/myhci-cl",
        "type": "CustomLocation"
      },
      "id": "/subscriptions/<Subscription ID>resourceGroups/myhci-rg/providers/Microsoft.AzureStackHCI/logicalnetworks/myhci-lnet-static",
      "location": "eastus",
      "name": "myhci-lnet-static",
      "properties": {
        "dhcpOptions": {
          "dnsServers": [
            "192.168.200.222"
          ]
        },
        "provisioningState": "Succeeded",
        "status": {},
        "subnets": [
          {
            "name": "myhci-lnet-static",
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
                      "name": "myhci-lnet-static-default-route",
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
        "vmSwitchName": "ConvergedSwitch(management_compute_storage)"
      },
      "resourceGroup": "myhci-rg",
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


### Create a DHCP logical network

Create a DHCP logical network when the underlying network to which you want to connect your virtual machines has DHCP. 

Follow these steps to configure a DHCP logical network:

1. Set the parameters. Here's an example using the default external switch:

    ```azurecli
    $lnetName = "myhci-lnet-dhcp"
    $vmSwitchName = '"ConvergedSwitch(management_compute_storage)"'
    $subscription =  "<Subscription ID>" 
    $resource_group = "myhci-rg"
    $customLocationName = "myhci-cl" 
    $customLocationID ="/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ExtendedLocation/customLocations/$customLocationName"
    $location = "eastus"
    ```

    > [!NOTE]
    > For the default VM switch created at the deployment, pass the name string encased in double quotes followed by single quotes. For example, a default VM switch ConvergedSwitch(management_compute_storage) is passed as '"ConvergedSwitch(management_compute_storage)"'.
    
    Here are the parameters that are *required* to create a DHCP logical network:

    | Parameters | Description |
    |--|--|
    | **name** | Name for the logical network that you create for your Azure Stack HCI cluster. Make sure to provide a name that follows the [Rules for Azure resources.](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-networking) You can't rename a logical network after it's created. |
    | **vm-switch-name** | Name of the external virtual switch on your Azure Stack HCI cluster where you deploy the logical network. |
    | **resource-group** | Name of the resource group where you create the logical network. For ease of management, we recommend that you use the same resource group as your Azure Stack HCI cluster. |
    | **subscription** | Name or ID of the subscription where your Azure Stack HCI is deployed. This could be another subscription you use for logical network on your Azure Stack HCI cluster. |
    | **custom-location** | Use this to provide the custom location associated with your Azure Stack HCI cluster where you're creating this logical network. |
    | **location** | Azure regions as specified by `az locations`. |
    | **vlan** | VLAN identifier for Arc VMs. Contact your network admin to get this value. A value of 0 implies that there's no VLAN ID. |

1. Run the following cmdlet to create a DHCP logical network:

    ```azurecli
    az stack-hci-vm network lnet create --subscription $subscription --resource-group $resource_group --custom-location $customLocationID --location $location --name $lnetname --vm-switch-name $vmSwitchName --ip-allocation-method "Dynamic"
    ```

    Here's a sample output:
    
    ```output
    {
      "extendedLocation": {
        "name": "/subscriptions/<Subscription ID>/resourceGroups/myhci-rg/providers/Microsoft.ExtendedLocation/customLocations/myhci-cl",
        "type": "CustomLocation"
      },
      "id": "/subscriptions/<Subscription ID>/resourceGroups/myhci-rg/providers/Microsoft.AzureStackHCI/logicalnetworks/myhci-lnet-dhcp",
      "location": "eastus",
      "name": "myhci-lnet-dhcp",
      "properties": {
        "dhcpOptions": null,
        "provisioningState": "Succeeded",
        "status": {},
        "subnets": [
          {
            "name": "myhci-lnet-dhcp",
            "properties": {
              "addressPrefix": null,
              "addressPrefixes": null,
              "ipAllocationMethod": "Dynamic",
              "ipConfigurationReferences": null,
              "ipPools": null,
              "routeTable": null,
              "vlan": 0
            }
          }
        ],
        "vmSwitchName": "ConvergedSwitch(management_compute_storage)"
      },
      "resourceGroup": "myhci-rg",
      "systemData": {
        "createdAt": "2023-11-02T16:32:51.531198+00:00",
        "createdBy": "guspinto@contoso.com",
        "createdByType": "User",
        "lastModifiedAt": "2023-11-02T23:08:08.462686+00:00",
        "lastModifiedBy": "319f651f-7ddb-4fc6-9857-7aef9250bd05",
        "lastModifiedByType": "Application"
      },
      "tags": null,
      "type": "microsoft.azurestackhci/logicalnetworks"
    }
    ```



## Next steps

- [Create Arc virtual machines on Azure Stack HCI](create-arc-virtual-machines.md)
