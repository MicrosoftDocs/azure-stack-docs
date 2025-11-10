---
title: Provision VMs in local availability zone for Azure Local (Preview)
description: Learn about how to provision VMs in local availability zone for Azure Local (Preview).
author: alkohli
ms.topic: conceptual
ms.date: 10/20/2025
ms.author: alkohli
---

# Provision Azure Local VMs in a local availability zone (Preview)

> Applies to: Azure Local version 2510 and later

This article explains how to create Azure Local virtual machines (VMs) in a local availability zone to reduce latency, improve performance, ensure redundancy, and meet compliance requirements.

> [!IMPORTANT]
> Updating placement configuration of existing virtual machines (VMs) is not supported.

[!INCLUDE [important](../includes/hci-preview.md)]

## Prerequisites

- Make sure that you have access to a rack aware cluster.  

- Before you create an Azure Local VM for a rack aware cluster, make sure that all prerequisites listed in [Create Azure Local virtual machines enabled by Azure Arc](../manage/create-arc-virtual-machines.md) are met.

# [Azure CLI](#tab/azure-CLI)

## Set parameters

1. Connect to a machine on your Azure Local.

1. Sign in and run the following command:

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

Once you have set up availability zones in a rack aware cluster, you can create Azure Local VMs on a specific availability zone to reduce latency, improve performance, ensure redundancy, and meet compliance requirements.

When you create a VM in a specific availability zone, the default option is without strict placement. The VM is created on a machine within the specified zone using the `--zone` flag.

If all machines within a zone are down, the VM can migrate to another machine outside of the zone. However, the VM attempts to fail back to a machine within the original zone when that availability zone recovers.

> [!NOTE]
> If no zone is specified when creating an Azure Local VM, the system automatically chooses an optimal placement within the rack aware cluster.

1. Run the following command:

    ```azurecli
    az stack-hci-vm create --name $vmName --resource-group $resource_group --admin-username $userName --admin-password $password --computer-name $computerName --image $imageName --location $location --authentication-type all --nics $nicName --custom-location $customLocationID --hardware-profile memory-mb="8192" processors="4" --storage-path-id $storagePathId --zone $zone
    ```

1. Verify that the VM is created in the desired zone. Look under the `placementProfile` in the output:

    ```azurecli
    "placementProfile": {  
      "strictPlacementPolicy": null,  
      "zone": "local-zone"  
    },
    ```

## Create a VM in a specific availability zone with strict placement enabled

To create a VM in a specific availability zone and ensure it stays within that availability zone, you can specify another flag `--strict-placement` to `true`. The VM is created on a machine within the specified zone (`--zone`). If all machines within a zone are down, the VM also goes down.

> [!TIP]
> Only enable strict placement if the VM isn't required to be always running or needs to adhere to a specific availability zone due to compliance requirements.

Follow these steps to create a VM in a specific availability zone with strict placement enabled:

1. Run the following command:

    ```azurecli
    az stack-hci-vm create --name $vmName --resource-group $resource_group --admin-username $userName --admin-password $password --computer-name $computerName --image $imageName --location $location --authentication-type all --nics $nicName --custom-location $customLocationID --hardware-profile memory-mb="8192" processors="4" --storage-path-id $storagePathId --zone $zone --strict-placement true 
    ```

1. Verify that the VM has strict placement enabled and was created in the desired zone. Look under `placementProfile` in the output.

    ```azurecli
    "placementProfile": {  
      "strictPlacementPolicy": true,  
      "zone": "local-zone"  
    }, 
    ```

# [Azure portal](#tab/azure-portal)

Follow these steps in Azure portal for your Azure Local.

1. Go to Azure **Arc cluster view** > **Virtual machines**.
1. From the top command bar, select **+ Create VM**.
1. In the **Instance details** section, input the following parameters:

    :::image type="content" source="media/rack-aware-cluster-availability-zone/no-zone.png" alt-text="Screenshot of virtual machine with no zone in the Azure portal." lightbox="media/rack-aware-cluster-availability-zone/no-zone.png":::

    1. Virtual machine name: The name should follow all the naming conventions for Azure virtual machines.
    1. Security type: Select Standard or Trusted launch virtual machines. For more information about Trusted launch Azure Local VMs, see [What is Trusted launch for Azure Local Virtual Machines?](../manage/trusted-launch-vm-overview.md)
    1. Image: Select the Marketplace or customer managed image to create the VM image.
    1. Virtual processor count: Specify the number of vCPUs you want to use to create the VM.
    1. Memory (MB): Specify the memory in MB for the VM you want to create.
    1. Memory type: Specify the memory type as static or dynamic.
    1. [Availability zone](#availability-zones): No zone, a zone without strict placement, and a zone with strick placement.
    1. Enable guest management: Extensions can be installed on VMs where guest management is enabled.
       - Add at least one network interface through the **Networking** tab to complete the guest management setup.
       - The enabled network interface must have a valid IP address and internet access. For more information, see [Azure Local VM management networking](../manage/azure-arc-vm-management-overview.md).

## Availability zones

### Create a VM without a specific availability zone

You can specify no zone when creating an Azure Local VM. This means the system automatically chooses an optimal placement within the rack aware cluster.

:::image type="content" source="media/rack-aware-cluster-availability-zone/no-zone.png" alt-text="Screenshot of virtual machine with no zone in the Azure portal." lightbox="media/rack-aware-cluster-availability-zone/no-zone.png":::

### Create a VM in an availability zone without strict placement

You can specify a zone without any strict placement enabled. This means if all machines within a zone are down, the VM can move to another machine outside of the zone. However, when the availability zone recovers, the VM attempts to fail back to a machine within the original zone.

In the **Instance details** section, input the following parameters:

**Availability zone**: Select the availability zone to place the VM in.
**Strict placement**: Do not select this checkbox to create the VM without strict placement

:::image type="content" source="media/rack-aware-cluster-availability-zone/zone-a.png" alt-text="Screenshot of virtual machine with zone A in the Azure portal." lightbox="media/rack-aware-cluster-availability-zone/zone-a.png":::

### Create a VM in an availability zone with strict placement

You can create a VM in a specific availability zone with strict placement to ensure the VM stays within that zone. This means if all machines within the specified zone are down, the VM also goes down.

In the **Instance details** section, input the following parameters:

Availability zone: Select the availability zone to place the VM in.
Strict placement: Select this checkbox to create the VM with strict placement.

:::image type="content" source="media/rack-aware-cluster-availability-zone/zone-a-strict.png" alt-text="Screenshot of virtual machine with zone A strict in the Azure portal." lightbox="media/rack-aware-cluster-availability-zone/zone-a-strict.png":::

---
