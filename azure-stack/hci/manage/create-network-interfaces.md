---
title: Create network interfaces for virtual machines on Azure Stack HCI (preview)
description: Learn how to create network interfaces on an existing logical network associated with your Azure Stack HCI cluster. The Arc VM running on your cluster uses these network interfaces (preview).
author: alkohli
ms.author: alkohli
ms.reviewer: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.custom: devx-track-azurecli
ms.date: 11/20/2023
---

# Create network interfaces for Arc virtual machines on Azure Stack HCI (preview)

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article describes how to create network interfaces that you can associate with an Arc VM on your Azure Stack HCI cluster. You can create network interfaces using the Azure portal or the Azure CLI. 


[!INCLUDE [hci-preview](../../includes/hci-preview.md)]

## About network interfaces

Network interfaces are an Azure resource and can be used to deploy virtual machines on your cluster. After a logical network is created, you can create network interfaces and associate those with the virtual machines you'll create.

You can create network interfaces using the Azure portal or the Azure CLI. When using the Azure portal, the network interface creation is a part of the VM creation process. When using the Azure CLI, you can create a network interface first and then use it to create a VM.


## Prerequisites

Before you create a network interface, make sure that the following prerequisites are completed.

# [Azure CLI](#tab/azurecli)

[!INCLUDE [hci-vm-prerequisites](../../includes/hci-vm-prerequisites.md)]

- If using a client to connect to your Azure Stack HCI cluster, see [Connect to Azure Stack HCI via Azure CLI client](./azure-arc-vm-management-prerequisites.md#azure-command-line-interface-cli-requirements).

- Access to a logical network that you created on your Azure Stack HCI cluster. For more information, see [Create logical network](./create-virtual-networks.md).


# [Azure portal](#tab/azureportal)

[!INCLUDE [hci-vm-prerequisites](../../includes/hci-vm-prerequisites.md)]

---


## Create network interface

To create a VM, you'll first need to create a network interface on your logical network. The steps can be different depending on whether your logical network is static or DHCP.

# [Azure CLI](#tab/azurecli)

### Sign in and set subscription

[!INCLUDE [hci-vm-sign-in-set-subscription](../../includes/hci-vm-sign-in-set-subscription.md)]

### Virtual network interface with static IP


Follow these steps to create a network interface on your static logical network. Replace the parameters in `< >` with the appropriate values.

1. Set the required parameters. Here's a sample output:

    ```azurecli
    $lnetName = "myhci-lnet-static"
    $gateway ="100.68.180.1" 
    $ipAddress ="100.68.180.6" 
    $nicName ="myhci-nic-static"
    $subscription =  "<Subscription ID>"
    $resource_group = "myhci-rg"
    $customLocationName = "myhci-cl" 
    $customLocationID ="/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ExtendedLocation/customLocations/$customLocationName"
    $location = "eastus"
    ```

    Here is a description of the parameters:

    | Parameter | Description |
    | ----- | ----------- |
    | **name** | Name for the network interface that you'll create on the logical network deployed on your Azure Stack HCI cluster. Make sure to provide a name that follows the [Rules for Azure resources.](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-networking) You can't rename a network interface after it's created. |
    | **resource-group** |Name of the resource group where your Azure Stack HCI is deployed. This could also be another precreated resource group. |
    | **subscription** |Name or ID of the subscription where your Azure Stack HCI is deployed. This could be another subscription you use for logical network on your Azure Stack HCI cluster. |
    | **custom-location** |Name or ID of the custom location to use for logical network on your Azure Stack HCI cluster.  |
    | **location** | Azure regions as specified by `az locations`. For example, this could be `eastus`, `eastus2euap`. |
    | **subnet-id** |Name of your logical network. For example: `test-lnet-dynamic`.  |
    | **ip-allocation-method** |IP address allocation method and could be `dynamic` or `static` for your network interface. If this parameter isn't specified, by default the network interface is created with a dynamic configuration. |
    | **ip-address** | An IPv4 address you want to assign to the network interface that you are creating. For example: "192.168.0.10".  |


1. To create a network interface with static IP address, run the following command:

    ```azurecli
    az stack-hci-vm network nic create --subscription $subscription --resource-group $resource_group --custom-location $customLocationID --location $location --name $nicName --subnet-id $lnetName --ip-address $ipAddress
    ```
    
    Here's a sample output:
    
    ```console   
    {
      "extendedLocation": {
        "name": "/subscriptions/<subscription ID>/resourceGroups/myhci-rg/providers/Microsoft.ExtendedLocation/customLocations/myhci-cl",
        "type": "CustomLocation"
      },
      "id": "/subscriptions/<subscription ID>/resourceGroups/myhci-rg/providers/Microsoft.AzureStackHCI/networkinterfaces/myhci-nic-static",
      "location": "eastus",
      "name": "myhci-nic-static",
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
                "id": "/subscriptions/<subscription ID>/resourceGroups/myhci-rg/providers/Microsoft.AzureStackHCI/logicalnetworks/myhci-lnet-static",
                "resourceGroup": "myhci-rg"
              }
            }
          }
        ],
        "macAddress": null,
        "provisioningState": "Succeeded",
        "resourceName": null,
        "status": {}
      },
      "resourceGroup": "myhci-rg",
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

### Virtual network interface with DHCP

Follow these steps to create a network interface on your DHCP logical network. Replace the parameters in `< >` with the appropriate values.


1. Set the required parameters. Here's a sample output:

    ```azurecli
    $nicName = "myhci-nic-dhcp"
    $lnetName = "myhci-lnet-dhcp"   
    $subscription =  "<subscription ID>" 
    $resource_group = "myhci-rg"
    $customLocationName = "myhci-cl" 
    $customLocationID ="/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ExtendedLocation/customLocations/$customLocationName"
    $location = "eastus"
    ```

    Here is a description of the parameters:

    | Parameter | Description |
    | ----- | ----------- |
    | **name** | Name for the network interface that you'll create on the logical network deployed on your Azure Stack HCI cluster. Make sure to provide a name that follows the [Rules for Azure resources.](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-networking) You can't rename a network interface after it's created. |
    | **resource-group** |Name of the resource group where your Azure Stack HCI is deployed. This could also be another precreated resource group. |
    | **subscription** |Name or ID of the subscription where your Azure Stack HCI is deployed. This could be another subscription you use for logical network on your Azure Stack HCI cluster. |
    | **custom-location** |Name or ID of the custom location to use for logical network on your Azure Stack HCI cluster. |
    | **location** | Azure regions as specified by `az locations`. For example, this could be `eastus`. |
    | **subnet-id** |Name of your logical network. For example: `test-lnet-dynamic`.  |

1. To create a network interface, run the following command:
 
    ```azurecli
    az stack-hci-vm network nic create --subscription $subscription --resource-group $resource_group --custom-location $customLocationID --location $location --name $nicName --subnet-id $lnetName
    ```
   
    Here is a sample output:
    
    ```azurecli
    {
      "extendedLocation": {
        "name": "/subscriptions/<subscription ID>/resourceGroups/myhci-rg/providers/Microsoft.ExtendedLocation/customLocations/myhci-cl",
        "type": "CustomLocation"
      },
      "id": "/subscriptions/<subscription ID>/resourceGroups/myhci-rg/providers/Microsoft.AzureStackHCI/networkinterfaces/myhci-vnic",
      "location": "eastus",
      "name": "myhci-nic-dhcp",
      "properties": {
        "ipConfigurations": [
          {
            "name": null,
            "properties": {
              "gateway": null,
              "prefixLength": null,
              "privateIpAddress": null,
              "privateIpAllocationMethod": null,
              "subnet": {
                "id": "myhci-lnet-dhcp"
              }
            }
          }
        ],
        "macAddress": null,
        "provisioningState": "Succeeded",
        "resourceName": "myhci-nic-dhcp",
        "status": {}
      },
      "resourceGroup": "myhci-rg",
      "systemData": {
        "createdAt": "2023-02-08T23:25:10.984508+00:00",
        "createdBy": "guspinto@contoso.com",
        "createdByType": "User",
        "lastModifiedAt": "2023-02-08T23:26:03.262252+00:00",
        "lastModifiedBy": "<ID>",
        "lastModifiedByType": "Application"
      },
      "tags": null,
      "type": "microsoft.azurestackhci/networkinterfaces"
    }
    PS C:\windows\system32> 
    ```

You can use this network interface to create a VM. For more information, see [Create a VM](../manage/create-arc-virtual-machines.md).


# [Azure portal](#tab/azureportal)

In the Azure portal, you create a network interface during the VM creation flow. For more information, see [Create Azure Stack HCI VM in Azure portal](./create-arc-virtual-machines.md).

---

## Next steps

- Use this network interface when you [Create an Arc VM on your Azure Stack HCI](./create-arc-virtual-machines.md).

