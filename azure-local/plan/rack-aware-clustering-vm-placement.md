---
title: Azure Local virtual machine placement in a Rack Aware Cluster (Preview)
description: Use this topic to learn how to place your Azure Local VMs on a Rack Aware Cluster (Preview).
author: alkohli
ms.author: alkohli
ms.topic: overview
ms.service: azure-local
ms.date: 04/01/2025
---

# Place Azure Local VMs on a Rack Aware Cluster (Preview)

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes how to place an Azure Local virtual machine (VM) on a Rack Aware Cluster.

[!INCLUDE [important](../includes/hci-preview.md)]

## About Rack Aware Cluster and Azure Local VMs

Azure Local Rack Aware Cluster is an advanced architecture designed to enhance fault tolerance and data distribution within an Azure Local instance. This architecture enables you to cluster nodes that are strategically placed across two physical racks in two different rooms or buildings with high bandwidth and low latency. An example of Rack Aware Cluster could be the use in a manufacturing plant to minimize the risk of data loss or downtime in the event of a rack-level failure.  

## Prerequisites

Before you create an Azure Local VM for a rack aware cluster, make sure that all prerequisites listed in [Create Azure Local virtual machines enabled by Azure Arc](../manage/create-arc-virtual-machines.md) are met.

## Create a VM in a specific availability zone without strict placement

Once you have set up availability zones in a rack aware cluster, you can create Azure Local VMs on a specific availability zone to reduce latency, improve performance, ensure redundancy, and meet compliance requirements.

When you create a VM in a specific availability zone, the default option is without strict placement. The VM is created on a machine within the specified zone (`--zone`).

If all machines within a zone are down, the VM can migrate to another machine outside of the zone. However, the VM attempts to fail back to a machine within the original zone when that availability zone recovers.

> [!NOTE]
> If no zone is specified when creating an Azure Local VM, the system automatically chooses an optimal placement within the rack aware cluster.

1. Connect to a machine on your Azure Local instance.
1. Sign in and set the subscription:

    :::image type="content" source="media/rack-aware-clustering-overview/rack-aware-cluster-vm-sign-in.png" alt-text="Screenshot showing VM sign in." lightbox="media/rack-aware-clustering-overview/rack-aware-cluster-vm-sign-in.png":::

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
    $zone = “local-zone”
    ```

1. Run the following command:

    ```azurecli
    az stack-hci-vm create --name $vmName --resource-group $resource_group --admin-username $userName --admin-password $password --computer-name $computerName --image $imageName --location $location --authentication-type all --nics $nicName --custom-location $customLocationID --hardware-profile memory-mb="8192" processors="4" --storage-path-id $storagePathId –zone $zone 
    ```
 
1. Verify that the VM was created in the desired zone. Look under `placementProfile` in the output.

    ```azurecli
    "placementProfile": { 
      "strictPlacementPolicy": null, 
      "zone": "local-zone" 
    }, 
    ```

## Create a VM in a specific availability zone with strict placement enabled

To create a VM in a specific availability zone and ensure it stays within that availability zone, you can specify another flag `--strict-placement` to `true`. The VM is created on a node within the specified zone (`--zone`). If all machines within a zone are down, the VM also goes down. Only enable strict placement if the VM isn't required to be always running or needs to adhere to a specific availability zone due to compliance requirements.  

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

- See [Rack Aware Cluster networking](rack-aware-clustering-network-design.md).