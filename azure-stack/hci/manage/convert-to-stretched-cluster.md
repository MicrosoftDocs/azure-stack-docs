---
title: Convert to a stretched Azure Stack HCI cluster
description: Learn how to convert to a stretched cluster in Azure Stack HCI
ms.topic: how-to
author: v-dasis
ms.author: v-dasis
ms.reviewer: jgerend
ms.date: 09/09/2021
---

# Convert to a stretched Azure Stack HCI cluster

> Applies to: Azure Stack HCI, version 20H2; , Azure Stack HCI, version 21H2

You can easily add or remove servers from a cluster in Azure Stack HCI. Keep in mind that each new physical server must closely match the rest of the servers in the cluster when it comes to CPU type, memory, number of drives, and the type and size of the drives.

Whenever you add or remove a server, you must also perform cluster validation afterwards to ensure the cluster is functioning normally.

When it comes to adding nodes in a stretch cluster, it can be done to an existing cluster or add a new site with new nodes to an existing running to create a stretch cluster.  Adding nodes to an existing stretch cluster has all the steps explained here.  This document will explain and give the steps to create a stretch cluster by adding nodes to an existing single site cluster.

## Before you begin

The first step is to acquire new HCI hardware from your original OEM with the same characteristics as the existing cluster nodes. Always refer to your OEM-provided documentation when adding new server hardware for use in your cluster.

1. Place the new physical servers in the rack and cable it appropriately.
1. Enable physical switch ports and adjust access control lists (ACLs) and VLAN IDs if applicable.
1. Configure the correct IP address in the baseboard management controller (BMC) and apply all BIOS settings per OEM instructions.
1. Apply the current firmware baseline to all components by using the tools that are provided by your OEM.
1. Run OEM validation tests to ensure hardware homogeneity with the existing clustered servers.
1. Install the Azure Stack HCI operating system on the new server. For detailed information, see Deploy Azure Stack HCI.
1. Join the server to the same cluster domain.

## Before adding nodes

Stretched clusters require the same number of server nodes and the same number of drives in each site. When adding servers to an Azure Stack HCI cluster, their drives are automatically added to the storage pool. In a stretched cluster, each site must have its own storage pool.

To prevent this from occurring so it’s own pool can be created, sites must be created before the nodes can be added.  Once the sites are created, the new nodes can be added to the cluster and its own pool is created.

Creating Sites

With Azure Stack HCI, sites are automatically created when the cluster is created.  Since the cluster was created as a single site, the existing nodes were added to this site and a pool of the drives were created.

Normally, when creating additional sites, the command New-ClusterFaultDomain would be used. However, you cannot add nodes to a site when nodes are not a part of the cluster.  Much like in Add or remove servers for an Azure Stack HCI cluster, the Get-ClusterFaultDomainXML and Set-ClusterFaultDomainXML cmdlets are used to create an XML file that will have the sites and nodes in them.  when the new nodes are added to the cluster, they are added to the new site and the second site’s pool is created.

Once in place, adding the new servers simultaneously using the Add-ClusterNode cmdlet, allowing each new server's drives to be added at the same time also.

Typically, you manage clusters from a remote computer, rather than on a server in a cluster. This remote computer is called the management computer.

>[!NOTE]
>When running PowerShell commands from a management computer, include the `-Cluster paramete`r with the name of the cluster you are managing.

Ok, let's begin:

1. List the current sites and nodes currently in the cluster and create a `Sites.xml` file.

~~~PowerShell
Get-ClusterFaultDomainXML | out-file sites.xml
~~~

1. Navigate to where the Sites.xml file is located locally on your management PC and open the file. For example, if there are two nodes currently in the cluster, the `Sites.xml` file will look like this:

~~~cmd
<Topology>
    <Site Name="Site1" Description="" Location="">
        <Node Name="NODE1" Description="" Location="">
        <Node Name="NODE2" Description="" Location="">
    </Site>
<Topology>
~~~

1. Using this example, add a new site name and the two new servers to the site so the Sites.xml file would look like this:

~~~cmd
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

1. The next step is to modify the site (fault domain) information. The first command sets a variable to obtain the contents of the `Sites.xml` file and output it. The second command sets the modification based on the variable $XML.

~~~PowerShell
$XML = Get-Content .\sites.xml | out-string
Set-ClusterFaultDomainXML -xml $XML
~~~

1. Verify that the modifications you made are correct:

~~~PowerShell
Get-ClusterFaultDomain
~~~

## Add new nodes

Once the sites have been created, the next steps are adding the new servers to your cluster. As they are added, the servers would be added to the new site defined above and a new pool of the drives would be created.

1. Using the `Add-ClusterNode` cmdlet, add the new site nodes to the cluster:

~~~PowerShell
Add-ClusterNode -Name NODE3, NODE4
~~~

1. Once the servers have been successfully added, verify that the nodes are in the correct new site with the command:

~~~PowerShell
Get-ClusterFaultDomain
~~~

1. Next is to verify the new pool was created with the below command.  Please note that this may take a few minutes as it must create the storage pool from the newly added nodes.

~~~PowerShell
Get-StoragePool
~~~

## Create disks and replication

Creating the virtual disks on the secondary site and setting up the replicas is a manual process that is next.  To get a listing of the virtual disks currently in the cluster, the `Get-VirtualDisk` PowerShell command would be run.  

Please note that with Storage Replica, the disks must be of the same size and attributes.  When creating the disks on the secondary site, the same method of virtual disk creation and disk resiliency should be used as was done on the original site nodes. Additionally, Storage Replica requires a log drive for each site to do replication.  

## Next steps

- Create volumes on Azure Stack HCI and Windows Server clusters.
- Stretch Cluster Replication Using Shared Storage