---
title: Convert to a stretched Azure Stack HCI cluster
description: Learn how to convert to a stretched cluster in Azure Stack HCI
ms.topic: how-to
author: v-dasis
ms.author: v-dasis
ms.reviewer: jgerend
ms.date: 09/16/2021
---

# Convert to a stretched Azure Stack HCI cluster

> Applies to: Azure Stack HCI, versions 21H2 and 20H2

This article explains and gives the steps required to create a stretched cluster by adding new server nodes to an existing single-site cluster. You use Windows PowerShell commands to accomplish this.

Single-site clusters use Windows Admin Center to [Add or remove servers](add-cluster.md) for an Azure Stack HCI cluster. The PowerShell commands described here do the same thing when converting a single-site cluster to a stretched cluster.

## Before you begin

The first step is to acquire new Azure Stack HCI server hardware from your original OEM vendor, with the same characteristics as the existing server node hardware. Each new physical server must closely match the rest of the servers in the cluster when it comes to CPU type, memory, number of drives, and the type and size of the drives.

Refer to your OEM-provided documentation when adding new server hardware for use in a cluster. For more information about Azure Stack HCI Integrated System solution hardware, see the [Azure Stack HCI Catalog](https://aka.ms/AzureStackHCICatalog).

Follow these steps to prep the new server nodes:

1. Place the new physical servers in the rack and cable them appropriately.
1. Enable physical switch ports and adjust access control lists (ACLs) and VLAN IDs if applicable.
1. Configure the correct IP address in the baseboard management controller (BMC) and apply all BIOS settings per OEM instructions.
1. Apply the current firmware baseline to all components by using the tools that are provided by your OEM.
1. Run OEM validation tests to ensure hardware homogeneity with the existing clustered servers.
1. Install the Azure Stack HCI operating system on the new server. For detailed information, see [Deploy Azure Stack HCI](/azure-stack/hci/deploy/operating-system).
1. Join the servers to the same cluster domain.

Whenever you add or remove a server, perform cluster validation afterwards to ensure the cluster is functioning normally.

## Before you add server nodes

Stretched clusters require the same number of server nodes and the same number of drives in each site. When adding servers to an Azure Stack HCI cluster, their drives are automatically added to a single storage pool. In a stretched cluster however, each site must have its own storage pool.

To ensure that separate storage pools are created, sites must be created first before new server nodes can be added. Once the sites are created, the server nodes can be added to the cluster and its own pool created, one for each site.

## Create an additional site

Azure Stack HCI automatically creates a site when you create a (non-stretched) cluster. Because the cluster is created in a single site, server nodes are added to this site and a single drive pool is created.

Normally, when creating additional sites, the [New-ClusterFaultDomain](/powershell/module/failoverclusters/new-clusterfaultdomain) cmdlet is used. However, you cannot add server nodes to a site when the servers are not a part of the cluster.  

Much like when you [Add or remove servers](add-cluster.md) to an Azure Stack HCI cluster using Windows Admin Center, the [Get-ClusterFaultDomainXML](/powershell/module/failoverclusters/get-clusterfaultdomainxml) and [Set-ClusterFaultDomainXML](/powershell/module/failoverclusters/set-clusterfaultdomainxml) cmdlets are used to create an XML file that specifies the sites and nodes in them. When additional server nodes are added to the cluster, they are added to the new site and the second site’s drive pool is created.

You can add additional servers simultaneously using the [Add-ClusterNode](/powershell/module/failoverclusters/add-clusternode) cmdlet, which adds each new server's drives at the same time.

Typically, you manage clusters from a remote client computer, rather than on a server in the cluster. This remote computer is called the management computer.

>[!NOTE]
>When running PowerShell commands from a management computer, include the `-Cluster` parameter with the name of the cluster you are managing.

Ok, let's begin:

1. List the site and server nodes currently in the cluster and create a `Sites.xml` file:

    ~~~PowerShell
    Get-ClusterFaultDomainXML | out-file sites.xml
    ~~~

1. Navigate to where the `Sites.xml` file is located on your management computer and open the file. For example, if there are two nodes currently in the cluster, the `Sites.xml` file will look like this:

    ~~~cmd
    <Topology>
        <Site Name="Site1" Description="" Location="">
            <Node Name="NODE1" Description="" Location="">
            <Node Name="NODE2" Description="" Location="">
        </Site>
    <Topology>
    ~~~

1. Using this example, add a new site name and the two new servers to the site so that the `Sites.xml` file looks like this:

    ~~~PowerShell
    <Topology>
        <Site Name="Site1" Description="" Location="">
            <Node Name="NODE1" Description="" Location="">
            <Node Name="NODE2" Description="" Location="">
        </Site>
        <Site Name="Site2" Description="" Location="">
            <Node Name="NODE3" Description="" Location="">
            <Node Name="NODE4" Description="" Location="">
        </Site>
    <Topology>
    ~~~

1. Modify the site (fault domain) information. The first command sets a variable to obtain and display the contents of the `Sites.xml` file. The second command sets the modification based on the variable `$XML`, as follows:

    ~~~PowerShell
    $XML = Get-Content .\sites.xml | out-string
    Set-ClusterFaultDomainXML -xml $XML
    ~~~

1. Verify that the modifications you made are correct:

    ~~~PowerShell
    Get-ClusterFaultDomain
    ~~~

## Add new server nodes

Once the sites have been created, you next add the new servers to the cluster. These servers would be added to the new site as specified previously and a new pool of the drives is also created.

1. Using the `Add-ClusterNode` cmdlet, add the new server nodes to the cluster:

    ~~~PowerShell
    Add-ClusterNode -Name NODE3, NODE4
    ~~~

1. Once the servers are added, verify that they are in the correct new site using the following:

    ~~~PowerShell
    Get-ClusterFaultDomain
    ~~~

1. Verify the new drive pool is created. This may take a few minutes to create the storage pool from the newly added nodes:

    ~~~PowerShell
    Get-StoragePool
    ~~~

## Create disks and replication

Creating the virtual disks on the secondary site and setting up Storage Replica is a manual process. To see all the virtual disks currently in the cluster, use the [Get-VirtualDisk](/powershell/module/storage/get-virtualdisk) cmdlet.  

With Storage Replica, all disks must be of the same size and attributes. When creating the disks on the secondary site, the same method of virtual disk creation and disk resiliency that you used for the primary site nodes. Storage Replica also requires a log drive for each site to perform replication.  

## Next steps

- [Create volumes on Azure Stack HCI and Windows Server clusters](create-volumes.md)
- [Stretch Cluster Replication Using Shared Storage](/windows-server/storage/storage-replica/stretch-cluster-replication-using-shared-storage)
