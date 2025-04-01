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

This article gives a high-level overview of the Azure Local Rack Aware Clustering feature. Azure Local Rack Aware Cluster is an advanced architecture designed to enhance fault tolerance and data distribution within an Azure Local instance. This architecture enables you to cluster nodes that are strategically placed across two physical racks in two different rooms or buildings with high bandwidth and low latency. An example of Rack Aware Cluster could be the use in a manufacturing plant to minimize the risk of data loss or downtime in the event of a rack-level failure.  

The diagram shows a cluster of two racks of servers with top-of-rack (Tor) switches connected between rooms. Each rack functions as a local availability zone across layers from the operating system to Azure Local management, including Azure Local VMs enabled by Azure Arc and Azure Kubernetes Service (AKS).  

:::image type="content" source="media/rack-aware-clustering-overview/rack-aware-cluster-architecture.png" alt-text="Diagram of rack aware cluster architecture." lightbox="media/rack-aware-clustering-overview/rack-aware-cluster-architecture.png":::

This direct connection between racks supports a single storage pool, with Rack Aware Clusters guaranteeing data copy distribution evenly between the two racks.  This design is particularly valuable in environments that require high availability and disaster recovery capabilities. Even if an entire rack encounters an issue, the other rack maintains the integrity and accessibility of the data.

To support the synchronous replications between racks, a dedicated storage network intent is required to secure the bandwidth and low latency for storage traffic. The required round-trip latency between the two racks should be 1ms or less.

For detailed networking requirements, see [Rack Aware Clustering network design](rack-aware-clustering-network-design.md).

## Requirements and supported configurations

All [system requirements for Azure Local](../concepts/system-requirements-23h2.md) apply to rack aware clusters.  Additional requirements for rack-aware clusters include:

- Data drives must be all-flash, either Nonvolatile Memory Express (NVMe) or solid-state drives (SSD).

- Azure Local Rack Aware Cluster supports only two local availability zones, with a maximum of four machines in each zone. The two zones must contain an equal number of machines. See the table for supported configurations with volume resiliency settings.

    | Machines in 2 zones  | Volume resiliency   | Infrastructure volumes  | Workload volumes  |
    | -- | -- | -- | -- |
    | 1+1 (2-node cluster)  | 2-way mirror  | 1 | 2 |
    | 2+2 (4-node cluster)  | Rack Level Nested Mirror (4-way mirror)  | 1 | 4 |
    | 3+3 (6-node cluster)  | Rack Level Nested Mirror (4-way mirror)  | 1 | 6 |
    | 4+4 (8-node cluster)  | Rack Level Nested Mirror (4-way mirror)  | 1 | 8 |

- Only new greenfield deployments are supported - no conversion from standard clusters.

- To facilitate synchronous replications between racks, a dedicated storage network is essential to ensure adequate bandwidth and low latency for storage traffic. The round-trip latency requirement between two racks should be 1 millisecond or less. The necessary bandwidth can be calculated based on the cluster size and the network interface card (NIC) speed as follows:

    | Machines in zone | NIC speed | Storage ports | Bandwidth required |
    | -- | -- | -- | -- |
    | 1 | 10 | 2 | 20 GbE  |
    | 2 | 10 | 2 | 40 GbE  |
    | 3 | 10 | 2 | 60 GbE  |
    | 4 | 10 | 2 | 80 GbE  |
    | 1 | 25 | 2 | 50 GbE  |
    | 2 | 25 | 2 | 100 GbE |
    | 3 | 25 | 2 | 150 GbE |
    | 4 | 25 | 2 | 200 GbE |


> [!NOTE]
> Adding a machine to a cluster (`add-node` command) isn't supported in Azure Local version 2504.

## Storage design

Storage Spaces Direct is used to create a single storage pool that aggregates the disk capacity from all machines. For a 1+1 configuration, two volumes are created—one on each machine—with a two-way mirror that respects the rack fault domain, ensuring two copies of data are available in the cluster, one in each rack. In a 2+2 configuration, four volumes are created—one on each machine—with a two-way mirror that also respects the rack fault domain, providing one copy of data in each rack. With a two-way mirror, the total usable capacity of the storage pool is 50%. With a two-way mirror, the system can handle one type of failure at a time. This means each cluster can support the failure of either one rack, one machine, or one disk without losing data.

Only two-way mirror volumes are supported. Three-way mirror volumes aren't supported.

## Azure Local virtual machines

This section deals with Azure Local virtual machines (VMs).

### VM prerequisites

Before you create an Azure Local VM for Rack Aware Clustering, make sure that all prerequisites listed in [Create Azure Local virtual machines enabled by Azure Arc](../manage/create-arc-virtual-machines.md) are met.

### Create a VM in a specific availability zone

Once availability zones are set up in Rack Aware Cluster, Azure Local VMs can be created on a specific availability zone to reduce latency, improve performance, ensure redundancy, and meet compliance requirements.

When creating a VM to a specific availability zone, the default option is without strict placement. The VM will be created on a machine within the specified zone (`--zone`). If all machines within a zone are down, the VM can migrate to another machine outside of the zone. However, the VM will attempt to failback to a machine within the original zone when that availability zone recovers.

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

To create a VM in a specific availability zone and ensure it stays within that availability zone, you can specify an additional flag `--strict-placement` to `true`. The VM will be created on a node within the specified zone (`--zone`). If all machines within a zone are down, the VM will also go down. Only enable strict placement if the VM is not required to be running at all times or needs to adhere to a specific availability zone due to compliance requirements.  

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