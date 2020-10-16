---
title: Create stretched cluster volumes and set up replication
description: How to create volumes and set up replication for stretched clusters in Azure Stack HCI using Windows Admin Center and PowerShell.
author: v-dasis
ms.author: v-dasis
ms.topic: how-to
ms.date: 07/24/2020
---

# Create stretched cluster volumes and set up replication

> Applies to: Azure Stack HCI, version 20H2

This article describes how to create volumes and set up replication for stretched clusters in Azure Stack HCI using Windows Admin Center and PowerShell.

We will create volumes on four servers in two sites, two servers per site as an example. Keep in mind however, that if you want to create three-way mirror volumes, you need at least six servers, three servers per site.

## Stretched volumes and replication using Windows Admin Center

To create a volume and set up replication:

1. In Windows Admin Center, under **Tools**, select **Volumes**.
1. In the right pane, select the **Inventory** tab, then select **Create**.
1. In the **Create volume** panel, select **Replicate volume between sites**.
1. Select a replication direction between sites from the drop-down box.
1. Under **Replication mode**, select **Asynchronous** or **Synchronous**.
1. Enter a Source replication group name and a Destination replication group name.
1. Enter the desired size for the log volume.
1. Under **Advanced**, optionally do the following:
     - Enter/change the **Source replication group name**.
     - Enter/change the **Destination replication group name**.
     - To **use blocks already seeded on the target**..., select that checkbox.
     - To **encrypt replication traffic**, select that checkbox.
     - To **enable consistency groups**, select that checkbox.
1. When finished, click **Create**.
1. In the right pane, verify that a data disk and a log disk are created in your primary (active) site, and that corresponding data and log replica disks are created in the secondary (passive) site. For bidirectional replication, you should see two sets of data and volume disks.
1. Under **Tools**, select **Storage Replica**.
1. In the right pane, under **Partnerships**, verify that the replication partnership has been successfully created.

Afterwards, you should verify successful data replication between sites before deploying VMs and other workloads. See the Verifying replication section in [Validate the cluster](../deploy/validate.md) for more information.

## Create stretched volumes using PowerShell

Volume creation is different for single-site standard clusters versus stretched (two-site) clusters. For both scenarios however, you use the `New-Volume` cmdlet to create a virtual disk, partition and format it, create a volume with matching name, and add it to cluster shared volumes (CSV).

Creating volumes and virtual disks for stretched clusters is a bit more involved than for single-site clusters. Stretched clusters require a minimum of four volumes - two data volumes and two log volumes, with a data/log volume pair residing in each site. Then you will create a replication group for each site, and set up replication between them. We need to move resource groups around from server to server. The `Move-ClusterGroup` cmdlet is used to this.

1. First we move the `Available Storage` storage pool resource group to `Server1` in `Site1` using the `Move-ClusterGroup` cmdlet:

    ```powershell
    Move-ClusterGroup -Cluster ClusterS1 -Name ‘Available Storage’ -Node Server1
    ```

1. Next, create the first virtual disk (`Disk1`) for `Server1` in `Site1`:

    ```powershell
    New-Volume -CimSession Server1 -FriendlyName Disk1 -FileSystem REFS -DriveLetter F -ResiliencySettingName Mirror -Size 10GB -StoragePoolFriendlyName "Storage Pool for Site 1"
    ```

1. Create a second virtual disk (`Disk2`) for `Server1` in `Site1`:

    ```powershell
    New-Volume -CimSession Server1 -FriendlyName Disk2 -FileSystem REFS -DriveLetter G -ResiliencySettingName Mirror -Size 10GB -StoragePoolFriendlyName "Storage Pool for Site 1"
    ```

1. Now, take the `Available Storage` group offline:

    ```powershell
    Stop-ClusterGroup -Cluster ClusterS1 -Name 'Available Storage'
    ```

1. And move the `Available Storage` group to `Server3` in `Site2`:

    ```powershell
    Move-ClusterGroup -Name 'Available Storage' -Node Server3
    ```

1. Create the first virtual disk (`Disk3`) on `Server3` in `Site2`:

    ```powershell
    New-Volume -CimSession Server3 -FriendlyName Disk3 -FileSystem REFS -DriveLetter H -ResiliencySettingName Mirror -Size 10GB -StoragePoolFriendlyName "Storage Pool for Site 2"
    ```

1. And create a second virtual disk (`Disk4`) on `Server3` in `Site2`:

    ```powershell
    New-Volume -CimSession Server3 -FriendlyName Disk4 -FileSystem REFS -DriveLetter I -ResiliencySettingName Mirror -Size 10GB -StoragePoolFriendlyName "Storage Pool for Site 2"
    ```

1. Now take the `Available Storage` group offline and then move it back to one of the servers in `Site1`:

    ```powershell
    Stop-ClusterGroup -Cluster ClusterS1 -Name 'Available Storage'
    ```

    ```powershell
    Move-ClusterGroup -Cluster ClusterS1 -Name 'Available Storage' -Node Server1
    ```

1. Using the `Get-ClusterResource` cmdlet, ensure that four virtual disk volumes were created, two in each storage pool:

    ```powershell
    Get-ClusterResource -Cluster ClusterS1
    ```

1. Now add `Disk1` to Cluster Shared Volumes:

    ```powershell
    Add-ClusterSharedVolume -Name 'Cluster Virtual Disk (Disk1)'
    ```

You are done creating volumes, and ready to set up Storage Replica for replication.

## Set up replication using PowerShell

When using PowerShell to set up Storage Replica for a stretched cluster, the disk that will be used for the source data will need to be added as a Cluster Shared Volume (CSV). All other disks must remain as non-CSV drives in the Available Storage group. These disks will then be added as Cluster Shared Volumes during the Storage Replica creation process.

In the previous step, the virtual disks were added using drive letters to make the identification of them easier. Storage Replica is a one-to-one replication, meaning a single disk can replicate to another single disk.

### Step 1: Validate the topology for replication

Before starting, you should run the `Test-SRTopology` cmdlet for an extended period (like several hours). The `Test-SRTopology` cmdlet validates a potential replication partnership and validates the local host to the destination server or remotely between source and destination servers.

This cmdlet will verify that:

- SMB can be accessed over the network, which means that TCP port 445 and port 5445 are open bi-directionally.
- WS-MAN can be accessed over HTTP on the network, which means that TCP port 5985 and 5986 are open.
- An SR WMIv2 provider can be accessed and accepts requests.
- Source and destination data volumes exist and are writable.
- Source and destination log volumes exist with NTFS formatting or ReFS formatting and sufficient free space.
- Storage is initialized in GPT format, not MBR, with matching sector sizes.
- There is sufficient physical memory to run replication.

In addition, the `Test-SRTopology` cmdlet will also measure:

- Round-trip latency of ICMP and report the average.
- Performance counters for write Input/Output and report the average seen on that volume.
- Estimated initial synchronization time.

Once Test-SRTopology completes, it will create an .html file (TestSrTopologyReport with date and time) in your Windows Temp folder. Any warning or failures should be reviewed as they could cause Storage Replica to not be properly created.

An example command that would run for 5 hours would be:

```powershell
Test-SRTopology -SourceComputerName Server1 -SourceVolumeName W: -SourceLogVolumeName X: -DestinationComputerName Server3 -DestinationVolumeName Y: -DestinationLogVolumeName Z: -DurationInMinutes 300 -ResultPath c:\temp
```

### Step 2: Create the replication partnership

Now that you completed the `Test-SRTopology` tests, you are ready to configure Storage Replica and create the replication partnership. In a nutshell, we will configure Storage Replica by creating replication groups (RG) for each site and specifying the data volumes and log volumes for both the source server nodes in Site1 (Server1, Server2) and the destination (replicated) server nodes in Site2 (Server3, Server4).

Let's begin:

1. Add the Site1 data disk as a Cluster Shared Volume (CSV):

   ```powershell
   Add-ClusterSharedVolume -Name "Cluster Virtual Disk (Site1)"
   ```

1. The Available Storage group should be "owned" by the node it is currently sitting on. The group can be moved to Server1 using:

   ```powershell
   Move-ClusterGroup -Name “Available Storage” -Node Server1
   ```

1. To create the replication partnership, use the `New-SRPartnership` cmdlet. This cmdlet is also where you specify the source data volume and log volume names:

   ```powershell
   New-SRPartnership -SourceComputerName "Server1" -SourceRGName "Replication1" -SourceVolumeName "C:\ClusterStorage\Disk1\" -SourceLogVolumeName "G:" -DestinationComputerName "Server3" -DestinationRGName "Replication2" -DestinationVolumeName "H:" -DestinationLogVolumeName "I:"
   ```

The `New-SRPartnership` cmdlet creates a replication partnership between the two replication groups for the two sites. In this example `Replication1` is the replication group for primary node Server1 in Site1, and `Replication2` is the replication group for destination node Server3 in Site2.

Storage Replica will now be setting everything up. If there is any data to be replicated, it will do it here. Depending on the amount of data it needs to replicate, this may take a while. It is recommended to not move any groups around until this process completes.

## Next steps

For related topics and other storage management tasks, see also:

- [Stretched cluster overview](../concepts/stretched-clusters.md)
- [Plan volumes](../concepts/plan-volumes.md)
- [Extend volumes](extend-volumes.md)
- [Delete volumes](delete-volumes.md)
