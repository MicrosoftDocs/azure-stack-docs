---
title: Azure Local virtual machine placement in a Rack Aware Cluster (Preview)
description: Use this topic to learn how to place your Azure Local VMs on a Rack Aware Cluster (Preview).
author: alkohli
ms.author: alkohli
ms.topic: overview
ms.service: azure-local
ms.date: 09/27/2025
---

# Place Azure Local VMs on a Rack Aware Cluster (Preview)

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes how to place an Azure Local virtual machine (VM) enabled by Azure Arc, on a Rack Aware Cluster.

[!INCLUDE [important](../includes/hci-preview.md)]

## About Rack Aware Cluster and Azure Local VMs

You can run Azure Local VMs on a Rack Aware Cluster running on an Azure Local instance. A Rack Aware Cluster is designed to enhance fault tolerance and data distribution within an Azure Local instance.

Before you place Azure VMs on a Rack Aware Cluster, make sure to create 2 or more zones. 

<Availability zones expands the level of control you have to maintain the availability of the applications and data on your VMs. An Availability Zone is a physically separate zone, within an Azure region. There are three Availability Zones per supported Azure region.

Each Availability Zone has a distinct power source, network, and cooling. By designing your solutions to use replicated VMs in zones, you can protect your apps and data from the loss of a data center. If one zone is compromised, then replicated apps and data are instantly available in another zone.>

Once you have the placement zones, you can assign those to the VMs to reduce latency, improve performance, ensure redundancy and meet compliance requirements.

> [!IMPORTANT]
> Updating zone configuration of existing virtual machines is not supported.  

## Prerequisites

- Make sure that you've access to a Rack Aware Cluster. For more information, see [Deploy a Rack Aware Cluster](../index.yml).
- Ensure that the Rack Aware Cluster has 2 or more availability zones configured. For more information, see [Configuring availability zones](../index.yml).
    - Go to the **Settings** blade of the Azure Local instance in the Azure portal, and select **Availability zones**. You can see the availability zones configured for your Rack Aware Cluster. Insert image here.
- Before you create an Azure Local VM for a rack aware cluster, make sure that all prerequisites listed in [Create Azure Local virtual machines enabled by Azure Arc](../manage/create-arc-virtual-machines.md) are met.

## Create and place the Azure Local VM

### Sign in and set the subscription

[!INCLUDE [hci-vm-sign-in-set-subscription](../includes/hci-vm-sign-in-set-subscription.md)]

### Set the parameters

1. Set the parameters:

    ```azurecli
    $vmName ="local-vm" 
    $subscription =  "<Subscription ID>" 
    $resource_group = "local-rg" 
    $customLocationName = "local-cl" 
    $customLocationID ="/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ExtendedLocation/customLocations/$customLocationName" 
    $location = "eastus" 
    $computerName = "mycomputer" 
    $userName = "local-user" 
    $password = "<password for the VM>" 
    $imageName ="ws22server" 
    $nicName ="local-vnic"  
    $storagePathName = "local-sp"  
    $storagePathId = "/subscriptions/<Subscription ID>/resourceGroups/local-rg/providers/Microsoft.AzureStackHCI/storagecontainers/local-sp" 
    $zone = "local-zone"
    ```

You can now create the Azure Local VM in a specific availability zone with or without strict placement.

### Create a VM in a specific availability zone without strict placement

Once you have set up availability zones in a rack aware cluster, you can create Azure Local VMs on a specific availability zone to reduce latency, improve performance, ensure redundancy, and meet compliance requirements.

When you create a VM in a specific availability zone, the default option is without strict placement. The VM is created on a machine within the specified zone (using the `--zone` flag).

If all machines within a zone are down, the VM can migrate to another machine outside of the zone. However, the VM attempts to fail back to a machine within the original zone when that availability zone recovers.

> [!NOTE]
> If no zone is specified when creating an Azure Local VM, the system automatically chooses an optimal placement within the rack aware cluster.


1. Run the following command:

    ```azurecli
    az stack-hci-vm create --name $vmName --resource-group $resource_group --admin-username $userName --admin-password $password --computer-name $computerName --image $imageName --location $location --authentication-type all --nics $nicName --custom-location $customLocationID --hardware-profile memory-mb="8192" processors="4" --storage-path-id $storagePathId –zone $zone 
    ```
 
1. Verify that the VM is created in the desired zone. Look under the `placementProfile` in the output.

    ```azurecli
    "placementProfile": { 
      "strictPlacementPolicy": null, 
      "zone": "local-zone" 
    }, 
    ```

### Create a VM in a specific availability zone with strict placement enabled

To create a VM in a specific availability zone and ensure it stays within that availability zone, you can specify another flag `--strict-placement` to `true`. The VM is created on a node within the specified zone (`--zone`). If all machines within a zone are down, the VM also goes down. 

> [!TIP]
> Only enable strict placement if the VM isn't required to be always running or needs to adhere to a specific availability zone due to compliance requirements.  

Follow these steps to create a VM in a specific availability zone with strict placement enabled:

1. Run the following command:

    ```azurecli
    az stack-hci-vm create --name $vmName --resource-group $resource_group --admin-username $userName --admin-password $password --computer-name $computerName --image $imageName --location $location --authentication-type all --nics $nicName --custom-location $customLocationID --hardware-profile memory-mb="8192" processors="4" --storage-path-id $storagePathId –zone $zone –strict-placement true
    ```

1. Verify that the VM has strict placement enabled and was created in the desired zone. Look under `placementProfile` in the output.

    ```azurecli
    "placementProfile": { 
      "strictPlacementPolicy": true, 
      "zone": "local-zone" 
    },
    ```

## Next steps

- See [Rack Aware Cluster networking overview](../plan/rack-aware-clustering-overview.md).