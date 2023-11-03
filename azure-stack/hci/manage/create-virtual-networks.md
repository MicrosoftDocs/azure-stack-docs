---
title: Create virtual networks for Azure Stack HCI cluster (preview)
description: Learn how to create virtual networks on your Azure Stack HCI cluster. The Arc VM running on your cluster used this virtual network (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 10/25/2023
---

# Create virtual networks for Azure Stack HCI (preview)

> Applies to: Azure Stack HCI, version 23H2

This article describes how to create or add virtual network for your Azure Stack HCI cluster.

[!INCLUDE [hci-preview](../../includes/hci-preview.md)]

## Prerequisites

Before you begin, make sure to complete the following prerequisites:

[!INCLUDE [hci-vm-image-prerequisites-marketplace](../../includes/hci-vm-image-prerequisites-marketplace.md)]

- Make sure you have an external VM switch that can be accessed by all the servers in your Azure Stack HCI cluster. By default, an external switch is created during the deployment of your Azure Stack HCI cluster that you can use to associate with the virtual network you will create.

  Run the following command to get the name of the external VM switch on your cluster.

  ```powershell
  Get-VmSwitch -SwitchType External
  ```

  Make a note of the name of the switch. You use this information when you create a virtual network. Here's a sample output:

  ```output
  PS C:\Users\hcideployuser> Get-VmSwitch -SwitchType External
  Name                               SwitchType       NetAdapterInterfaceDescription
  ----                               ----------       ----------------------------
  ConvergedSwitch(compute_management) External        Teamed-Interface
  PS C:\Users\hcideployuser>
  ```

- To create VMs with static IP addresses in your address space, add a virtual network with static IP allocation. Reserve an IP range with your network admin and make sure to get the address prefix for this IP range.

## Create virtual network

You can use the `az stack-hci-vm network vnet create` cmdlet to create a virtual network on the VM switch for DHCP or a static configuration. The parameters used to create a DHCP and a static virtual network are different.

### Parameters used to create virtual network

For both DHCP and static, the *required* parameters to be specified are tabulated as follows:

| Parameters | Description |
|--|--|
| **name** | Name for the virtual network that you create for your Azure Stack HCI cluster. Make sure to provide a name that follows the [Rules for Azure resources.](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-networking) You can't rename a virtual network after it's created. |
| **vm-switch-name** | Name of the external virtual switch on your Azure Stack HCI cluster where you deploy the virtual network. |
| **resource-group** | Name of the resource group where you create the virtual network. For ease of management, we recommend that you use the same resource group as your Azure Stack HCI cluster. |
| **subscription** | Name or ID of the subscription where your Azure Stack HCI is deployed. This could be another subscription you use for virtual network on your Azure Stack HCI cluster. |
| **custom-location** | Use this to provide the custom location associated with your Azure Stack HCI cluster where you're creating this virtual network. |
| **location** | Azure regions as specified by `az locations`. |
| **vlan** | VLAN identifier for Arc VMs. Contact your network admin to get this value. A value of 0 implies that there's no VLAN ID. |

For static IP only, the *required* and *optional* parameters are tabulated as follows:

| Parameter | Required/Optional | Description |
|--|--|--|
| **ip-allocation-method** | Required | IP address allocation method and could be `Dynamic` or `Static`. If this parameter isn't specified, by default the virtual network is created with a dynamic configuration. |
| **address-prefixes** | Required | Subnet address in CIDR notation. For example: "192.168.0.0/16". |
| **dns-servers** | Optional | List of IPv4 addresses of DNS servers. Specify multiple DNS servers in a space separated format. For example: "10.0.0.5" "10.0.0.10" |
| **gateway** | Optional | Ipv4 address of the default gateway. |

### Create a DHCP virtual network

Create a DHCP virtual network when the underlying network to which you want to connect your virtual machines has DHCP. 

Follow these steps to configure a DHCP virtual network:

1. Set the parameters. Here's an example using the default external switch:

    ```azurecli
    $vNetName = "myhci-vnet-dynamic"
    $vSwitchName = '"ConvergedSwitch(compute_management)"'
    $subscription =  "<Subscription ID>" 
    $resource_group = "myhci-rg"
    $customLocName = "myhci-cl" 
    $location = "eastus2euap"
    ```

    > [!NOTE]
    > For the default VM switch created at the deployment, pass the name string encased in double quotes followed by single quotes. For example, a default VM switch ConvergedSwitch(compute_management) is passed as '"ConvergedSwitch(compute_management)"'.
    
    Here are the parameters that are *required* to create a DHCP virtual network:

    | Parameters | Description |
    |--|--|
    | **name** | Name for the virtual network that you create for your Azure Stack HCI cluster. Make sure to provide a name that follows the [Rules for Azure resources.](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-networking) You can't rename a virtual network after it's created. |
    | **vm-switch-name** | Name of the external virtual switch on your Azure Stack HCI cluster where you deploy the virtual network. |
    | **resource-group** | Name of the resource group where you create the virtual network. For ease of management, we recommend that you use the same resource group as your Azure Stack HCI cluster. |
    | **subscription** | Name or ID of the subscription where your Azure Stack HCI is deployed. This could be another subscription you use for virtual network on your Azure Stack HCI cluster. |
    | **custom-location** | Use this to provide the custom location associated with your Azure Stack HCI cluster where you're creating this virtual network. |
    | **location** | Azure regions as specified by `az locations`. |
    | **vlan** | VLAN identifier for Arc VMs. Contact your network admin to get this value. A value of 0 implies that there's no VLAN ID. |

1. Run the following cmdlet to create a DHCP virtual network:

    ```azurecli
    az stack-hci-vm network vnet create --subscription $subscription --resource-group $resource_group --custom-location="/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ExtendedLocation/customLocations/$customLocName" --location $location --ip-allocation-method "Dynamic" --network-type "Transparent" --name $vNetName --vm-switch-name $vSwitchName
    ```

    Here's a sample output:
    
    ```output
    {
    "extendedLocation": {
    "name": "/subscriptions/<Subscription ID>/resourceGroups/myhci-rg/providers/Microsoft.ExtendedLocation/customLocations/myhci-cl",
    "type": "CustomLocation"
    },
    "id": "/subscriptions/<Subscription ID>/resourceGroups/myhci-rg/providers/Microsoft.AzureStackHCI/virtualnetworks/myhci-vnet-dynamic",
    "location": "eastus2euap",
    "name": "myhci-vnet-dynamic",
    "properties": {
      "dhcpOptions": {
        "dnsServers": null
      },
      "networkType": "Transparent",
      "provisioningState": "Succeeded",
      "status": {},
      "subnets": [],
      "vmSwitchName": "ConvergedSwitch(compute_management)"
    },
    "resourceGroup": "myhci-rg",
    "systemData": {
      "createdAt": "2023-06-06T00:10:40.562941+00:00",
      "createdBy": "johndoe@contoso.com",
      "createdByType": "User",
      "lastModifiedAt": "2023-06-06T00:11:26.659220+00:00",
      "lastModifiedBy": "319f651f-7ddb-4fc6-9857-7aef9250bd05",
      "lastModifiedByType": "Application"
    },
    "tags": null,
    "type": "microsoft.azurestackhci/virtualnetworks"
    }
    ```

### Create a static virtual network

In this release, you can create virtual machines using a static IP only via the Azure CLI.

Create a static virtual network when you want to create virtual machines with network interfaces on these virtual networks. Follow these steps in Azure CLI to configure a static virtual network:


1. Set the parameters. Here's an example:

    ```azurecli
    $vNetName = "MyVirtualNetwork"
    $vSwitchName = "ConvergedSwitch(managementcompute)"
    $subscriptionID = "<Subscription ID>"
    $resource_group = "HCI22H2RegistrationRG"
    $customLocName = "cluster-eecda70c5019425cab03d082a6d57e55-mocarb-cl"
    $customLocID="/subscriptions/$SubscriptionID/resourceGroups/$ResourceGroupname/providers/Microsoft.ExtendedLocation/customLocations/$Customlocationname"
    $location = "eastus"
    $addressPrefix = "100.68.180.0/28"
    ```

    > [!NOTE]
    > For the default VM switch created at the deployment, pass the name string encased in double quotes followed by single quotes. For example, a default VM switch ConvergedSwitch(compute_management) is passed as '"ConvergedSwitch(compute_management)"'.

    For static IP, the *required* parameters are tabulated as follows:

    | Parameters |Required/Optional | Description |
    |------------|------------------|-------------|
    | **name** | Required |Name for the virtual network that you create for your Azure Stack HCI cluster. Make sure to provide a name that follows the [Rules for Azure resources.](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-networking) You can't rename a virtual network after it's created. |
    | **vm-switch-name** | Required |Name of the external virtual switch on your Azure Stack HCI cluster where you deploy the virtual network. |
    | **resource-group** | Required |Name of the resource group where you create the virtual network. For ease of management, we recommend that you use the same resource group as your Azure Stack HCI cluster. |
    | **subscription** | Required |Name or ID of the subscription where your Azure Stack HCI is deployed. This could be another subscription you use for virtual network on your Azure Stack HCI cluster. |
    | **custom-location** | Required | Use this to provide the custom location associated with your Azure Stack HCI cluster where you're creating this virtual network. |
    | **location** |Required | Azure regions as specified by `az locations`. |
    | **vlan** | Required |VLAN identifier for Arc VMs. Contact your network admin to get this value. A value of 0 implies that there's no VLAN ID. |
    | **ip-allocation-method** | Required | IP address allocation method and could be `Dynamic` or `Static`. If this parameter isn't specified, by default the virtual network is created with a dynamic configuration. |
    | **address-prefixes** | Required | Subnet address in CIDR notation. For example: "192.168.0.0/16". |
    | **dns-servers** | Optional | List of IPv4 addresses of DNS servers. Specify multiple DNS servers in a space separated format. For example: "10.0.0.5" "10.0.0.10" |
    | **gateway** | Optional | Ipv4 address of the default gateway. |

    > [!NOTE]
    > DNS server and gateway must be specified if you're creating a static virtual network.

1. Create a static virtual network. Run the following cmdlet:

    ```azurecli
    az stack-hci-vm network vnet create --subscription $subscriptionid --resource-group $resource_group --custom-location=$customLocID --location $location --network-type "Transparent" --name $vNetName --ip-allocation-method "Static" --address-prefixes $addressPrefix --vm-switch-name $vSwitchName     
    ```
  
  Once the virtual network creation is complete, you're ready to create virtual machines with network interfaces on these virtual networks.

## Next steps

- [Create Arc virtual machines on Azure Stack HCI](create-arc-virtual-machines.md)
