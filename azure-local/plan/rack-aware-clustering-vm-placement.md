---
title: Overview of Azure Local Rack Aware Clustering
description: Use this topic to learn about Azure Local Rack Aware Clustering.
author: alkohli
ms.author: alkohli
ms.topic: overview
ms.service: azure-local
ms.date: 04/01/2025
---

# Azure Local Rack Aware Clustering overview

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article gives a high-level overview of the Azure Local Rack Aware Clustering feature including its benefits and use cases. The article also details the supported configurations and deployment requirements for rack aware clustering.

[!INCLUDE [important](../includes/hci-preview.md)]

## About Rack Aware Cluster and virtual machines on Azure Local

Azure Local Rack Aware Cluster is an advanced architecture designed to enhance fault tolerance and data distribution within an Azure Local instance. This architecture enables you to cluster nodes that are strategically placed across two physical racks in two different rooms or buildings with high bandwidth and low latency. An example of Rack Aware Cluster could be the use in a manufacturing plant to minimize the risk of data loss or downtime in the event of a rack-level failure.  


### VM prerequisites

Before you create an Azure Local VM for Rack Aware Clustering, make sure that all prerequisites listed in [Create Azure Local virtual machines enabled by Azure Arc](../manage/create-arc-virtual-machines.md) are met.

### Create a VM in a specific availability zone

Once availability zones are set up in Rack Aware Cluster, Azure Local VMs can be created on a specific availability zone to reduce latency, improve performance, ensure redundancy, and meet compliance requirements.

When you create a VM in a specific availability zone, the default option is without strict placement. The VM is created on a machine within the specified zone (`--zone`). If all machines within a zone are down, the VM can migrate to another machine outside of the zone. However, the VM attempts to failback to a machine within the original zone when that availability zone recovers.

> [!NOTE]
> If no zone is specified when creating an Azure Local VM, the system will automatically choose an optimal placement within the Rack Aware Cluster.

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

### Create a VM in a specific availability zone (strict placement enabled)

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