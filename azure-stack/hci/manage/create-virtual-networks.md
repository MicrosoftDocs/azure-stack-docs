---
title: Create virtual networks for Azure Stack HCI cluster (preview)
description: Learn how to create virtual networks on your Azure Stack HCI cluster. The Arc VM running on your cluster used this virtual network (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 06/07/2023
---

# Create virtual networks for Azure Stack HCI (preview)

> Applies to: Azure Stack HCI, versions 22H2 and 21H2

This article describes how to create or add virtual networks for your Azure Stack HCI cluster.

[!INCLUDE [hci-preview](../../includes/hci-preview.md)]


## Prerequisites

Before you begin, make sure to complete the following prerequisites:

1. Make sure that you have access to an Azure Stack HCI cluster. This cluster should have Arc Resource Bridge installed on it and a custom location created as per the instructions in [Set up Arc Resource Bridge using Azure CLI](./deploy-arc-resource-bridge-using-command-line.md).
    - Go to the resource group in Azure. You can see the custom location and Azure Arc Resource Bridge that you've created for the Azure Stack HCI cluster. Make a note of the subscription, resource group, and the custom location as you use these later in this scenario.

1. Make sure you have an external VM switch that can be accessed by all the servers in your Azure Stack HCI cluster. By default, an external switch is created during the deployment of your Azure Stack HCI cluster that you can use. You can also create another external switch on your cluster.

    Run the following command to get the name of the external VM switch on your cluster.

    Make a note of the name of the switch. You use this information when you create a virtual network.

    ```azurecli
    Get-VmSwitch -SwitchType External
    ```

    Here's a sample output:

    ```azurecli
    PS C:\Users\hcideployuser> Get-VmSwitch -SwitchType External
    Name                               SwitchType       NetAdapterInterfaceDescription
    ----                               ----------       ----------------------------
    ConvergedSwitch(compute_management) External        Teamed-Interface
    PS C:\Users\hcideployuser>
    ```
1. If you want to create a virtual network with static IP allocation, reserve an IP range with your network admin. Make sure to get the address prefix for this IP range from your network admin.


## Create virtual network

You can use the `azurestackhci virtualnetwork` cmdlet to create a virtual network on the VM switch for DHCP or a static configuration. This VM switch is deployed on all hosts of your cluster. The parameters used for DHCP and static are different.

### Parameters used to create virtual network

   For both DHCP and static, the *required* parameters to be specified are tabulated as follows:

   | Parameter | Description |
   | ----- | ----------- |
   | **name** | Name for the virtual network that you'll create for your Azure Stack HCI cluster. Make sure to provide a name that follows the [Rules for Azure resources.](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-networking) You can't rename a virtual network after it's created. |
   | **vm-switch-name** |Name of the external virtual switch on your Azure Stack HCI cluster where you deploy the virtual network. |
   | **resource-group** |Name of the resource group where your Azure Stack HCI is deployed. This could also be another precreated resource group. |
   | **subscription** |Name or ID of the subscription where your Azure Stack HCI is deployed. This could be another subscription you use for virtual network on your Azure Stack HCI cluster. |
   | **CustomLocation** |Name or ID of the custom location to use for virtual network on your Azure Stack HCI cluster. |

   For both DHCP and static, you can specify the following *optional* parameters:

   | Parameter | Description |
   | --------- | ----------- |
   | **Location** | Azure regions as specified by `az locations`. |

   For static IP only, the *required* basic parameters are tabulated as follows:


   | Parameter | Description |
   | --------- | ----------- |
   | **IPAllocationMethod** |IP address allocation method and could be dynamic or static. If this parameter isn't specified, by default the virtual network is created with a dynamic configuration. |
   | **IpAddressPrefix** | Subnet address in CIDR notation. For example: "192.168.0.0/16".  |


   For static IP only, you can specify the following *optional* parameters:

   | Parameter | Description |
   | --------- | ----------- |
   | **DNSServers** | IPv4 address of DNS servers. |
   | **Gateway** | Ipv4 address of the default gateway. |
   | **VLan ID** | vLAN identifier for Arc VMs. Contact your network admin to get this value. A value of 0 implies that there's no vLAN ID.  |

### Configure DHCP

Follow these steps to configure a DHCP virtual network:

1. Set the parameters. Here's an example using the default external switch:

    ```azurecli
    $VNetName = "test-vnet-dynamic"
    $VSwitchName = "ConvergedSwitch(compute_management)"    
    $Subscription =  "hcisub" 
    $ResourceGroupName = "hcirg"
    $CustomLocName = "altsnclus-cl" 
    $Location = "eastus2euap"
    ```

1. Run the following cmdlet to create a DHCP virtual network:

   ```azurecli
   az azurestackhci virtualnetwork create --subscription $Subscription --resource-group $ResourceGroupName --extended-location name="/subscriptions/$Subscription/resourceGroups/$ResourceGroupName/providers/Microsoft.ExtendedLocation/customLocations/$CustomLocName" type="CustomLocation" --location $Location --IpAllocationMethod "Dynamic" --network-type "Transparent" --name $VNetName --vm-switch-name $VSwitchName
   ```

    Here's a sample output:

    ```console

    {
      "extendedLocation": {
        "name": "/subscriptions/680d0dad-59aa-4464-adf3-b34b2b427e8c/resourceGroups/hcirg/providers/Microsoft.ExtendedLocation/customLocations/altsnclus-cl",
        "type": "CustomLocation"
      },
      "id": "/subscriptions/680d0dad-59aa-4464-adf3-b34b2b427e8c/resourceGroups/hcirg/providers/Microsoft.AzureStackHCI/virtualnetworks/test-vnet-dynamic",
      "location": "eastus2euap",
      "name": "test-vnet-dynamic",
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
      "resourceGroup": "hcirg",
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


### Configure static

1. Set the parameters. Here's an example:

    ```azurecli
    $VNetName = "test-vnet-static"
    $VSwitchName = '"ConvergedSwitch(compute_management)"' 
    $Subscription =  "hcisub" 
    $ResourceGroupName = "hcirg"
    $CustomLocName = "altsnclus-cl" 
    $Location = "eastus2euap" 
    $AddressPrefix = "10.0.0.0/24"
    ```

    > [!NOTE]
    > For the default VM switch created at the deployment, you will need to pass the name string encased in double quotes followed by single quotes. For example, a default VM switch ConvergedSwitch(compute_management) will be passed as '"ConvergedSwitch(compute_management)"'.

1. Create a static virtual network. Run the following cmdlet:
 
    ```azurecli
    az azurestackhci virtualnetwork create --subscription $subscription --resource-group $resource_group --extended-location name=$customLocationID type="CustomLocation" --location $Location --network-type "Transparent" --name $VNetName --vm-switch-name $VSwitchName --ip-allocation-method "Static" --address-prefix $AddressPrefix   
    ```
    Here's a sample output:

    ```console
    {
      "extendedLocation": {
        "name": "/subscriptions/680d0dad-59aa-4464-adf3-b34b2b427e8c/resourcegroups/hcirg/providers/microsoft.extendedlocation/customlocations/altsnclus-cl",
        "type": "CustomLocation"
      },
      "id": "/subscriptions/680d0dad-59aa-4464-adf3-b34b2b427e8c/resourceGroups/hcirg/providers/Microsoft.AzureStackHCI/virtualnetworks/test-vnet-static",
      "location": "eastus2euap",
      "name": "test-vnet-static",
      "properties": {
        "dhcpOptions": {
          "dnsServers": null
        },
        "networkType": "Transparent",
        "provisioningState": "Succeeded",
        "status": {},
        "subnets": [
          {
            "name": "test-vnet-si-cidr",
            "properties": {
              "addressPrefix": "10.0.0.0/24",
              "addressPrefixes": null,
              "ipAllocationMethod": "Static",
              "ipConfigurationReferences": null,
              "ipPools": [
                {
                  "end": "10.0.0.16",
                  "info": {},
                  "ipPoolType": null,
                  "start": "10.0.0.0"
                }
              ],
              "routeTable": {
                "id": null,
                "name": null,
                "properties": {
                  "routes": null
                },
                "type": null
              },
              "vlan": null
            }
          }
        ],
        "vmSwitchName": "ConvergedSwitch(compute_management)"
      },
      "resourceGroup": "hcirg",
      "systemData": {
        "createdAt": "2023-06-01T18:59:38.879658+00:00",
        "createdBy": "johndoe@contoso.com",
        "createdByType": "User",
        "lastModifiedAt": "2023-06-01T18:59:50.714931+00:00",
        "lastModifiedBy": "319f651f-7ddb-4fc6-9857-7aef9250bd05",
        "lastModifiedByType": "Application"
      },
      "tags": null,
      "type": "microsoft.azurestackhci/virtualnetworks"
    }
    ```



## Next steps

- [Manage virtual machines in the Azure portal](manage-virtual-machines-in-azure-portal.md)
