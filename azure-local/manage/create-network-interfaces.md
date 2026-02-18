---
title: Create network interfaces for virtual machines on Azure Local
description: Learn how to create network interfaces on an existing logical network associated with your Azure Local. The Azure Local VM enabled by Azure Arc uses these network interfaces.
author: alkohli
ms.author: alkohli
ms.reviewer: alkohli
ms.topic: how-to
ms.service: azure-local
ms.custom: devx-track-azurecli
ms.date: 02/11/2026
ms.subservice: hyperconverged
---

# Create network interfaces for Azure Local VMs enabled by Azure Arc

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to create network interfaces that you can associate with an Azure Local virtual machine (VM). You can create network interfaces using the Azure portal or Azure Command-Line Interface (CLI).

## About network interfaces

Network interfaces are an Azure resource and can be used to deploy virtual machines on your system. After a logical network is created, you can create network interfaces and associate them with the virtual machines you create.

You can create network interfaces using the Azure portal or the Azure CLI. In the Azure portal, the VM creation process includes creating the network interface. In the Azure CLI, you can create a network interface first, then create a VM, then associate the network interface with the VM.

## Prerequisites

Before you create a network interface, make sure that the following prerequisites are completed.

# [Azure CLI](#tab/azurecli)

- Make sure to review and [complete the prerequisites](./azure-arc-vm-management-prerequisites.md). If using a client to connect to your Azure Local, see [Connect to the system remotely](./azure-arc-vm-management-prerequisites.md#connect-to-the-system-remotely).

- Access to a logical network that you created on your Azure Local. For more information, see [Create logical network](./create-logical-networks.md).

# [Azure portal](#tab/azureportal)

In the Azure portal, you create a network interface during the VM creation flow. For prerequisites and more information, see [Create Azure Local VM in Azure portal](./create-arc-virtual-machines.md).

---

## Create network interface

To create a VM, you must first create a network interface on your logical network. The steps can be different depending on whether your logical network is static or uses Dynamic Host Configuration Protocol (DHCP).

# [Azure CLI](#tab/azurecli)

### Sign in and set subscription

[!INCLUDE [hci-vm-sign-in-set-subscription](../includes/hci-vm-sign-in-set-subscription.md)]

### Virtual network interface with static IP

Follow these steps to create a network interface on your static logical network.

1. Set the required parameters. Replace the `<PLACEHOLDERS>` with your values.

    ```azurecli
    $lnetName = "mylocal-lnet-static"
    $gateway = "100.68.180.1" 
    $ipAddress = "100.68.180.6" 
    $nicName ="mylocal-nic-static"
    $subscription = "<SUBSCRIPTION_ID>"
    $resource_group = "mylocal-rg"
    $customLocationName = "mylocal-cl" 
    $customLocationID ="/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ExtendedLocation/customLocations/$customLocationName"
    $location = "eastus"
    ```

1. To create a network interface with a static IP address, run the following command:

    ```azurecli
    az stack-hci-vm network nic create --subscription $subscription --resource-group $resource_group --custom-location $customLocationID --location $location --name $nicName --subnet-id $lnetName --ip-address $ipAddress
    ```

    Here's a description of the parameters:

    | Parameter | Description |
    | ----- | ----------- |
    | **name** | Name for the network interface. Make sure to provide a name that follows the [Rules for Azure resources](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-networking). You can't rename a network interface after you create it. |
    | **resource-group** | Name of the resource group where your Azure Local is deployed. This parameter can also be another precreated resource group. |
    | **subscription** | Name or ID of the subscription where your Azure Local is deployed. This parameter can also be another subscription you use for logical network on your Azure Local. |
    | **custom-location** | Name or ID of the custom location to use for logical network on your Azure Local. |
    | **location** | Azure region as specified by `az locations`. For example, `eastus`. |
    | **subnet-id** | Name of your logical network. For example: `test-lnet-dynamic`. |
    | **ip-allocation-method** | IP address allocation method. This parameter can be `dynamic` or `static`. If this parameter isn't specified, the network interface is created with a dynamic configuration. |
    | **ip-address** | The IPv4 address to assign to the network interface. For example, `192.168.0.10`. |

    Here's an example output:
    
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

### Virtual network interface with DHCP

Follow these steps to create a network interface on your DHCP logical network.

1. Set the required parameters. Replace the `<PLACEHOLDERS>` with your values.

    ```azurecli
    $nicName = "mylocal-nic-dhcp"
    $lnetName = "mylocal-lnet-dhcp"   
    $subscription = "<SUBSCRIPTION_ID>" 
    $resource_group = "mylocal-rg"
    $customLocationName = "mylocal-cl" 
    $customLocationID ="/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ExtendedLocation/customLocations/$customLocationName"
    $location = "eastus"
    ```

1. To create a network interface, run the following command:
 
    ```azurecli
    az stack-hci-vm network nic create --subscription $subscription --resource-group $resource_group --custom-location $customLocationID --location $location --name $nicName --subnet-id $lnetName
    ```

    Here's a description of the parameters:

    | Parameter | Description |
    | ----- | ----------- |
    | **name** | Name for the network interface. Make sure to provide a name that follows the [Rules for Azure resources](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-networking). You can't rename a network interface after you create it. |
    | **resource-group** | Name of the resource group where your Azure Local is deployed. This parameter can also be another precreated resource group. |
    | **subscription** | Name or ID of the subscription where your Azure Local is deployed. This parameter can also be another subscription you use for the logical network deployed on your Azure Local. |
    | **custom-location** | Name or ID of the custom location to use for logical network on your Azure Local. |
    | **location** | Azure region as specified by `az locations`. For example, `eastus`. |
    | **subnet-id** | Name of your logical network. For example, `test-lnet-dynamic`. |
   
    Here's an example output:
    
    ```azurecli
    {
      "extendedLocation": {
        "name": "/subscriptions/<subscription ID>/resourceGroups/mylocal-rg/providers/Microsoft.ExtendedLocation/customLocations/mylocal-cl",
        "type": "CustomLocation"
      },
      "id": "/subscriptions/<subscription ID>/resourceGroups/mylocal-rg/providers/Microsoft.AzureStackHCI/networkinterfaces/mylocal-vnic",
      "location": "eastus",
      "name": "mylocal-nic-dhcp",
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
                "id": "mylocal-lnet-dhcp"
              }
            }
          }
        ],
        "macAddress": null,
        "provisioningState": "Succeeded",
        "resourceName": "mylocal-nic-dhcp",
        "status": {}
      },
      "resourceGroup": "mylocal-rg",
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

In the Azure portal, you create a network interface during the VM creation flow. For more information, see [Create Azure Local VM in Azure portal](./create-arc-virtual-machines.md).

---

## Next steps

- Use this network interface when you [Create Azure Local VMs enabled by Azure Arc](./create-arc-virtual-machines.md).

