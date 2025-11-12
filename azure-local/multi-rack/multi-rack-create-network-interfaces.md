---
title: Create network interfaces for virtual machines on Azure Local for multi-rack deployments (Preview)
description: Learn how to create network interfaces on an existing logical network associated with your Azure Local for multi-rack deployments. The Azure Local VM enabled by Azure Arc uses these network interfaces. (Preview)
author: alkohli
ms.author: alkohli
ms.reviewer: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 11/12/2025
---

# Create network interfaces for Azure Local VMs for multi-rack deployments (Preview)

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article describes how to create network interfaces that you can associate with an Azure Local virtual machine (VM) for multi-rack deployments. You can create network interfaces using the Azure portal or Azure Command-Line Interface (CLI). 


## About network interfaces

Network interfaces are an Azure resource and can be used to deploy virtual machines on your system. On Azure Local for multi-rack deployments, network interfaces can be created on logical networks or virtual network (VNet) subnets. After a logical network or a VNet subnet is created, you can create network interfaces and associate those with the virtual machines you'll create.

You can create network interfaces using the Azure portal or the Azure CLI. When using the Azure portal, the network interface creation is a part of the VM creation process. When using the Azure CLI, you can create a network interface first and then use it to create a VM.


## Prerequisites

Before you create a network interface, make sure that the following prerequisites are completed.

# [Azure CLI](#tab/azurecli)

- Make sure to review and [complete the prerequisites](../manage/azure-arc-vm-management-prerequisites.md). If using a client to connect to your Azure Local, see [Connect to the system remotely](../manage/azure-arc-vm-management-prerequisites.md#connect-to-the-system-remotely).

- Access to a logical network or a VNet subnet that you created on your Azure Local. For more information, see [Create logical network](../manage/create-logical-networks.md).

# [Azure portal](#tab/azureportal)

In the Azure portal, you create a network interface during the VM creation flow. For prerequisites and more information, see [Create Azure Local VM in Azure portal](../manage/create-arc-virtual-machines.md).

---

## Create network interface

To create a VM, you'll first need to create a network interface on your logical network or virtual network.

> [!NOTE]
> Only static logical networks are supported in Azure Local for multi-rack deployments.

# [Azure CLI](#tab/azurecli)

### Sign in and set subscription

1. [Connect to a machine](../manage/azure-arc-vm-management-prerequisites.md#connect-to-the-system-directly) on your Azure Local.

1. Sign in and type:

    ```azurecli
    az login --use-device-code 
    ```

1. Set your subscription:

    ```azurecli
    az account set --subscription <Subscription ID>
    ```

### Network interface with static IP using logical network


Follow these steps to create a network interface on your static logical network. Replace the parameters in `< >` with the appropriate values.

1. Set the required parameters. Here's a sample output:

    ```azurecli
    $lnetName = "mylocal-lnet-static"
    $gateway ="100.68.180.1" 
    $ipAddress ="100.68.180.6" 
    $nicName ="mylocal-nic-static"
    $subscription =  "<Subscription ID>"
    $resource_group = "mylocal-rg"
    $customLocationName = "mylocal-cl" 
    $customLocationID ="/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ExtendedLocation/customLocations/$customLocationName"
    $location = "eastus"
    ```

    Here is a description of the parameters:

    | Parameter | Description |
    | ----- | ----------- |
    | **name** | Name for the network interface that you'll create on the logical network deployed on your Azure Local. Make sure to provide a name that follows the [Rules for Azure resources.](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-networking) You can't rename a network interface after it's created. |
    | **resource-group** |Name of the resource group where your Azure Local is deployed. This could also be another precreated resource group. |
    | **subscription** |Name or ID of the subscription where your Azure Local is deployed. This could be another subscription you use for logical network on your Azure Local. |
    | **custom-location** |Name or ID of the custom location to use for logical network on your Azure Local.  |
    | **location** | Azure regions as specified by `az locations`. For example, this could be `eastus`, `westeurope`. |
    | **subnet-id** |Name of your logical network or the ARM ID of the VNet subnet. For example: `test-lnet-dynamic`.  |
    | **ip-address** | An IPv4 address you want to assign to the network interface that you are creating. For example: "192.168.0.10". If you choose not to provide `ip-address`, an IP address will automatically be allocated from the available IP pool. |


1. To create a network interface with static IP address, run the following command:

    ```azurecli
    az stack-hci-vm network nic create --subscription $subscription --resource-group $resource_group --custom-location $customLocationID --location $location --name $nicName --subnet-id $lnetName --ip-address $ipAddress
    ```
    
    Here's a sample output:
    
    ```console   
    {
      "extendedLocation": {
        "name": "/subscriptions/<subscription ID>/resourceGroups/mylocal-rg/providers/Microsoft.ExtendedLocation/customLocations/mylocal-cl",
        "type": "CustomLocation"
      },
      "id": "/subscriptions/<subscription ID>/resourceGroups/mylocal-rg/providers/Microsoft.AzureStackHCI/networkinterfaces/mylocal-nic-static",
      "location": "eastus",
      "name": "mylocal-nic-static",
      "properties": {
        "dnsSettings": {
          "dnsServers": null
        },
        "ipConfigurations": [
          {
            "name": null,
            "properties": {
              "gateway": "192.168.200.1",
              "prefixLength": "24",
              "privateIpAddress": "192.168.201.3",
              "privateIpAllocationMethod": null,
              "subnet": {
                "id": "/subscriptions/<subscription ID>/resourceGroups/mylocal-rg/providers/Microsoft.AzureStackHCI/logicalnetworks/mylocal-lnet-static",
                "resourceGroup": "mylocal-rg"
              }
            }
          }
        ],
        "macAddress": null,
        "provisioningState": "Succeeded",
        "resourceName": null,
        "status": {}
      },
      "resourceGroup": "mylocal-rg",
      "systemData": {
        "createdAt": "2023-11-02T23:00:47.714910+00:00",
        "createdBy": "guspinto@contoso.com",
        "createdByType": "User",
        "lastModifiedAt": "2023-11-02T23:02:08.720545+00:00",
        "lastModifiedBy": "<ID>",
        "lastModifiedByType": "Application"
      },
      "tags": null,
      "type": "microsoft.azurestackhci/networkinterfaces"
    } 
    ```

You can use this network interface to create a VM. For more information, see [Create a VM](../manage/create-arc-virtual-machines.md).


## Network interface with static IP using virtual network 

Follow these steps to create a network interface on your static virtual network. Replace the parameters in `< >` with the appropriate values.

1. Set the required parameters. Here's a sample output:

    ```output
    $vnetName = "my-vnet-static" 
    $vnetSubnet = “/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.AzureStackHCI/virtualNetworks/$vnet_name/subnets/$subnet_name" 
    $gateway ="100.68.180.1"  
    $ipAddress ="100.68.180.6"  
    $nicName ="mylocal-nic-static" 
    $subscription =  "<Subscription ID>" 
    $resource_group = "mylocal-rg" 
    $customLocationName = "mylocal-cl"  

    $customLocationID ="/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ExtendedLocation/customLocations/$customLocationName" 

    $location = "eastus" 
    ```

    Here's is a description of the parameters:

    | Parameter | Description |
    | --- |  --- |
    | name | Name for the network interface that you'll create on the logical network deployed on your Azure Local. Make sure to provide a name that follows the Rules for Azure resources. You can't rename a network interface after it's created. |
    | resource-group | Name of the resource group where your Azure Local is deployed. This could also be another precreated resource group. |
    |  subscription | Name or ID of the subscription where your Azure Local is deployed. This could be another subscription you use for logical network on your Azure Local. |
    | custom-location | Name or ID of the custom location to use for logical network on your Azure Local. |
    | location | Azure regions as specified by az locations. For example, this could be eastus, westeurope. |
    | subnet-id | Name of your vnet subnet. For example: test-vnet-subnet. |
    | ip-address | An IPv4 address you want to assign to the network interface that you are creating. For example: "192.168.0.10". |
    | dns-server | IP address of the DNS server. You should set it at during network interface creation if it hasn't already been provided during the VNet subnet creation. |

1. To create a network interface with static IP address, run the following command: 

    ```azurecli
    az stack-hci-vm network nic create --subscription $subscription --resource-group $resource_group --custom-location $customLocationID --location $location --name $nicName --subnet-id $vnetSubnet --ip-address $ipAddress 
    ```
    Here's a sample output: 

    ```output
    { 

      "extendedLocation": { 

        "name": "/subscriptions/<subscription ID>/resourceGroups/mylocal-rg/providers/Microsoft.ExtendedLocation/customLocations/mylocal-cl", 

        "type": "CustomLocation" 

      }, 

      "id": "/subscriptions/<subscription ID>/resourceGroups/mylocal-rg/providers/Microsoft.AzureStackHCI/networkinterfaces/mylocal-nic-static", 

      "location": "eastus", 
      "name": "mylocal-nic-static", 
      "properties": { 
        "dnsSettings": { 
          "dnsServers": null 

        }, 

        "ipConfigurations": [ 

          { 

            "name": null, 
            "properties": { 
              "gateway": "192.168.200.1", 
              "prefixLength": "24", 
              "privateIpAddress": "192.168.201.3", 
              "privateIpAllocationMethod": null, 
              "subnet": { 

                "id": "/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.AzureStackHCI/virtualNetworks/$vnet_name/subnets/$subnet_name", 

                "resourceGroup": "mylocal-rg" 

              } 

            } 

          } 

        ], 

        "macAddress": null, 
        "provisioningState": "Succeeded", 
        "resourceName": null, 
        "status": {} 

      }, 

      "resourceGroup": "mylocal-rg", 
      "systemData": { 
        "createdAt": "2023-11-02T23:00:47.714910+00:00", 
        "createdBy": "guspinto@contoso.com", 
        "createdByType": "User", 
        "lastModifiedAt": "2023-11-02T23:02:08.720545+00:00", 
        "lastModifiedBy": "<ID>", 
        "lastModifiedByType": "Application" 

      }, 

      "tags": null, 
      "type": "microsoft.azurestackhci/networkinterfaces" 

    }  
    ```
You can use this network interface to create a VM. For more information. 

# [Azure portal](#tab/azureportal)

In the Azure portal, you create a network interface during the VM creation flow. For more information, see [Create Azure Local VM in Azure portal](../manage/create-arc-virtual-machines.md).

---

## Next steps

- Use this network interface when you [Create Azure Local VMs enabled by Azure Arc](../manage/create-arc-virtual-machines.md).
