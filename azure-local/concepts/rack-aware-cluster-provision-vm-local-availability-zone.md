---
title: Provision VMs in local availability zone for Azure Local (Preview)
description: Learn about how to provision VMs in local availability zone for Azure Local (Preview).
author: alkohli
ms.topic: conceptual
ms.date: 10/08/2025
ms.author: alkohli
---

# Provision VMs in a local availability zone (Preview)

This article explains how to create Azure Local virtual machines (VMs) in a local availability zone to reduce latency, improve performance, ensure redundancy, and meet compliance requirements.

> [!IMPORTANT]
> Updating placement configuration of existing virtual machines (VMs) is not supported.

[!INCLUDE [important](../includes/hci-preview.md)]

## Prerequisites

- Make sure that you have access to a Rack Aware Cluster.  

- Before you create an Azure Local VM for a Rack Aware Cluster, make sure that all prerequisites listed in [Create Azure Local virtual machines enabled by Azure Arc](/manage/create-arc-virtual-machines.md) are met.

## Create and place the VM

1. Connect to a machine on your Azure Local. 

1. Sign in, then run the following command:

    ```azurecli
    az login --use-device-code
    ```

1. Set your subscription:

    ```azurecli
    az account set --subscription <Subscription ID>
    ```

1. Set the following parameters:

    ```azurecli
    $vmName ="local-vm"  
    $subscription = “<Subscription ID>"  
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

## Create a VM in a specific availability zone without strict placement

Once you have set up availability zones in a Rack Aware Cluster, you can create Azure Local VMs on a specific availability zone to reduce latency, improve performance, ensure redundancy, and meet compliance requirements.

When you create a VM in a specific availability zone, the default option is without strict placement. The VM is created on a machine within the specified zone using the `--zone` flag.

If all machines within a zone are down, the VM can migrate to another machine outside of the zone. However, the VM attempts to fail back to a machine within the original zone when that availability zone recovers. 

> [!NOTE]
> If no zone is specified when creating an Azure Local VM, the system automatically chooses an optimal placement within the Rack Aware Cluster.

1. Run the following command:

    ```azurecli
    az stack-hci-vm create --name $vmName --resource-group $resource_group --admin-username $userName --admin-password $password --computer-name $computerName --image $imageName --location $location --authentication-type all --nics $nicName --custom-location $customLocationID --hardware-profile memory-mb="8192" processors="4" --storage-path-id $storagePathId –zone $zone
    ```

1. Verify that the VM is created in the desired zone. Look under the `placementProfile` in the output:

    ```azurecli
    "placementProfile": {  
      "strictPlacementPolicy": null,  
      "zone": "local-zone"  
    },
    ```

## Create a VM in a specific availability zone with strict placement enabled

To create a VM in a specific availability zone and ensure it stays within that availability zone, you can specify another flag `--strict-placement` to `true`. The VM is created on a machine within the specified zone (--zone). If all machines within a zone are down, the VM also goes down. 

> [!TIP]
> Only enable strict placement if the VM isn't required to be always running or needs to adhere to a specific availability zone due to compliance requirements.

Follow these steps to create a VM in a specific availability zone with strict placement enabled:

1. Run the following command:

    ```azurecli
    az stack-hci-vm create --name $vmName --resource-group $resource_group --admin-username $userName --admin-password $password --computer-name $computerName --image $imageName --location $location --authentication-type all --nics $nicName --custom-location $customLocationID --hardware-profile memory-mb="8192" processors="4" --storage-path-id $storagePathId –zone $zone –strict-placement true 
    ```

1. Verify that the VM has strict placement enabled and was created in the desired zone. Look under `placementProfile` in the output.

    ```azurecli
    "placementProfile": {  
      "strictPlacementPolicy": true,  
      "zone": "local-zone"  
    }, 
    ```
## Next steps