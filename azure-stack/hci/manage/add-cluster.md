---
title: Add or remove servers for an Azure Stack HCI cluster
description: Learn how to add or remove server nodes from a cluster in Azure Stack HCI
ms.topic: how-to
author: JasonGerend
ms.author: jgerend
ms.reviewer: stevenek
ms.date: 11/18/2022
---

# Add or remove servers for an Azure Stack HCI cluster

> Applies to: Azure Stack HCI, versions 21H2 and 20H2

You can easily add or remove servers from a cluster in Azure Stack HCI. Keep in mind that each new physical server must closely match the rest of the servers in the cluster when it comes to CPU type, memory, number of drives, and the type and size of the drives.

Whenever you add or remove a server, you must also perform cluster validation afterwards to ensure the cluster is functioning normally. This applies to both non-stretched and stretched clusters.

## Before you begin

The first step is to acquire new HCI hardware from your original OEM. Always refer to your OEM-provided documentation when adding new server hardware for use in your cluster.

1. Place the new physical server in the rack and cable it appropriately.
1. Enable physical switch ports and adjust access control lists (ACLs) and VLAN IDs if applicable.
1. Configure the correct IP address in the baseboard management controller (BMC) and apply all BIOS settings per OEM instructions.
1. Apply the current firmware baseline to all components by using the tools that are provided by your OEM.
1. Run OEM validation tests to ensure hardware homogeneity with the existing clustered servers.
1. Install the Azure Stack HCI operating system on the new server. For detailed information, see [Deploy Azure Stack HCI](../deploy/operating-system.md).
1. Join the server to the cluster domain.

## Add a server to a cluster

Use Windows Admin Center to join the server to your cluster.

:::image type="content" source="media/manage-cluster/add-server.png" alt-text="Add server screen" lightbox="media/manage-cluster/add-server.png":::

1. In **Windows Admin Center**, select **Cluster Manager** from the top drop-down arrow.
1. Under **Cluster connections**, select the cluster.
1. Under **Tools**, select **Servers**.
1. Under **Servers**, select the **Inventory** tab.
1. On the **Inventory** tab, select **Add**.
1. In **Server name**, enter the full-qualified domain name of the server you want to add, click **Add**, then click **Add** again at the bottom.
1. Verify the server has been successfully added to your cluster.

If the node has been added to a single server, see these [manual steps](../deploy/single-server.md#change-a-single-node-to-a-multi-node-cluster-optional) to reconfigure Storage Spaces Direct.

> [!NOTE]
> If the cluster has Arc-for-server enabled, the new server automatically gets Arc-for-server enabled during the next scheduler run, which runs every hour.

### Add a server to an SDN-enabled cluster

If Software Defined Networking (SDN) is already deployed on the cluster to which you're adding a new server, Windows Admin Center doesn't automatically add the new server to the SDN environment. You must use the SDN Express script to add the new server to the SDN infrastructure of the cluster.

Before you run the script, ensure that a virtual switch is created and the server is successfully added to the cluster. Also, ensure that the server is paused so that the workloads cannot move to it.

1. Download the latest version of the [SDN Express PowerShell scripts from the SDN GitHub repository](https://github.com/microsoft/SDN/tree/master/SDNExpress/scripts).
1. Run the following PowerShell cmdlets on the newly added server:

    ```powershell
    Import-Module SDNExpressModule.PSM1 -verbose
    $NCURI = "Insert NC URI"
    $creds = Get-Credential
    Add-SDNExpressHost -RestName $NCURI -VirtualSwitchName "Insert vSwitch Name" -ComputerName "Insert Name" -HostPASubnetPrefix "Example: 172.23.0.1/24" -Credential $creds
    ```
    where:
    - NCURI is the Network Controller REST API in the following format:
    `"https://<name of the Network Controller REST API>"`. For example: "https://mync.contoso.local"
    - ComputerName is the fully qualified domain name (FQDN) of the server to be added
    - HostPASubnetPrefix is the address prefix of the Provider Address (PA) network

## Remove a server from a cluster

Keep in mind that when you remove a server, you will also remove any virtual machines (VMs), drives, and workloads associated with the server.

### Uninstall VM extensions

Before you remove a server from a cluster, you must uninstall any VM extensions from your Azure Arc-enabled servers, or else you risk issues installing extensions later if you add the server back again.

You can remove VM extensions by using the [Azure portal](/azure/azure-arc/servers/manage-vm-extensions-portal#uninstall-extension), using the [Azure CLI](/azure/azure-arc/servers/manage-vm-extensions-cli#remove-an-installed-extension), or using [Azure PowerShell](/azure/azure-arc/servers/manage-vm-extensions-powershell#remove-an-installed-extension).

### Remove a server by using PowerShell

To remove a server from a cluster by using PowerShell:

1. Run `Disable-AzureStackHCIArcIntegration` on the server to be removed.
2. Run `Remove-ClusterNode -Name <ServerName>` from a management PC or another server in the cluster.

### Remove a server by using Windows Admin Center

The steps for removing a server from your cluster by using Windows Admin Center are similar to those for adding a server to a cluster.

:::image type="content" source="media/manage-cluster/remove-server.png" alt-text="Remove server dialog" lightbox="media/manage-cluster/remove-server.png":::

1. In **Windows Admin Center**, select **Cluster Manager** from the top drop-down arrow.
1. Under **Cluster connections**, select the cluster.
1. Under **Tools**, select **Servers**.
1. Under **Servers**, select the **Inventory** tab.
1. On the **Inventory** tab, select the server you want to remove, then select **Remove**.
1. To also remove any server drives from the storage pool, enable that checkbox.
1. Verify the server has been successfully removed from the cluster.

Anytime you add or remove servers from a cluster, be sure and run a cluster validation test afterwards.

## Add server pairs to a stretched cluster

Stretched clusters require the same number of server nodes and the same number of drives in each site. When adding a server pair to a stretched cluster, their drives are immediately added to the storage pool of both sites in the stretched cluster. If the storage pool at each site is not the same size at the time of addition, it is rejected. This is because the size of the storage pool must be the same between sites.

Take a few minutes to watch the video on adding server nodes to a stretched cluster:

> [!VIDEO https://www.youtube.com/embed/AVHPkRmsZ5Y]

You add or remove servers to a stretched cluster using Windows PowerShell. Using the [Get-ClusterFaultDomainXML](/powershell/module/failoverclusters/get-clusterfaultdomainxml) and [Set-ClusterFaultDomainXML](/powershell/module/failoverclusters/set-clusterfaultdomainxml) cmdlets, you first modify the site (fault domain) information prior to adding the servers.

Then, you can add the server pair to each site simultaneously using the [Add-ClusterNode](/powershell/module/failoverclusters/add-clusternode) cmdlet, allowing each new server's drives to be added at the same time also.

Typically, you manage clusters from a remote computer, rather than on a server in a cluster. This remote computer is called the management computer.

> [!NOTE]
> When running PowerShell commands from a management computer, include the `-Cluster` parameter with the name of the cluster you are managing.

Ok, let's begin:

1. Use the following PowerShell cmdlets to determine the state of the cluster:

    Returns the list of active servers in the cluster:

     ```powershell
    Get-ClusterNode
    ```

    Returns the stats for the cluster storage pool:

    ```powershell
    Get-StoragePool pool*
    ```

    Lists which servers are on which site (fault domain):

    ```powershell
    Get-ClusterFaultDomain
    ```

1. Open the `Sites.xml` file in Notepad or other text editor:

    ```powershell
    Get-ClusterFaultDomainXML | out-file sites.xml
    ```
 
    ```powershell
    notepad
    ```

1. Navigate to where the `Sites.xml` file is located locally on your management PC and open the file. The `Sites.xml` file will look similar to this:

    ```
    <Topology>
        <Site Name="Site1" Description="" Location="">
            <Node Name="Server1" Description="" Location="">
            <Node Name="Server2" Description="" Location="">
        </Site>
        <Site Name="Site2" Description="" Location="">
            <Node Name="Server3" Description="" Location="">
            <Node Name="Server4" Description="" Location="">
        </Site>
    <Topology>
    ```

1. Using this example, you would add a server to each site (`Server5`, `Server6`) as follows:

    ```
    <Topology>
        <Site Name="Site1" Description="" Location="">
            <Node Name="Server1" Description="" Location="">
            <Node Name="Server2" Description="" Location="">
            <Node Name="Server5" Description="" Location="">
        </Site>
        <Site Name="Site2" Description="" Location="">
            <Node Name="Server3" Description="" Location="">
            <Node Name="Server4" Description="" Location="">
            <Node Name="Server6" Description="" Location="">
        </Site>
    <Topology>
    ```

1. Modify the current site (fault domain) information.  The first command sets a variable to obtain the contents of the `Sites.xml` file and output it. The second command sets the modification based on the variable `$XML`.

    ```
    $XML = Get-Content .\sites.xml | out-string
    Set-ClusterFaultDomainXML -xml $XML
    ```

1. Verify that the modifications you made are correct:

    ```
    Get-ClusterFaultDomain
    ```

1. Add the server pair to your cluster using the `Add-ClusterNode` cmdlet:

    ```
    Add-ClusterNode -Name Server5,Server6
    ```

Once the servers have been successfully added, the associated drives are automatically added to each site's storage pools. Lastly, the Health Service creates a storage job to include the new drives.

## Remove server pairs from a stretched cluster

Before you remove server pairs from a cluster, you must uninstall any VM extensions from your Azure Arc-enabled servers, or else you risk issues installing extensions later if you add the servers back again.

You can remove VM extensions by using the [Azure portal](/azure/azure-arc/servers/manage-vm-extensions-portal#uninstall-extension), using the [Azure CLI](/azure/azure-arc/servers/manage-vm-extensions-cli#remove-an-installed-extension), or using [Azure PowerShell](/azure/azure-arc/servers/manage-vm-extensions-powershell#remove-an-installed-extension).

Removing a server pair from a stretched cluster is a similar process to adding a server pair, but using the [Remove-ClusterNode](/powershell/module/failoverclusters/remove-clusternode) cmdlet instead.

1. Use the following PowerShell cmdlets to determine the state of the cluster:

    Returns the list of active servers in the cluster:

     ```powershell
    Get-ClusterNode
    ```

    Returns the stats for the cluster storage pool:

    ```powershell
    Get-StoragePool pool*
    ```

    Lists which servers are on which site (fault domain):

    ```powershell
    Get-ClusterFaultDomain
    ```

1. Open the `Sites.xml` file in Notepad or other text editor:

    ```powershell
    Get-ClusterFaultDomainXML | out-file sites.xml
    ```
 
    ```powershell
    notepad
    ```

1. Using the previous example, in the `Sites.xml` file, remove the `<Node Name="Server5" Description="" Location="">` and the  `<Node Name="Server6" Description="" Location="">` XML entry for each site.
1. Modify the current site (fault domain) information using the following two cmdlets:

    ```
    $XML = Get-Content .\sites.xml | out-string
    Set-ClusterFaultDomainXML -xml $XML
    ```

1. Verify that the modifications you made are correct:

    ```
    Get-ClusterFaultDomain
    ```

1. Run the following cmdlet on the servers to be removed (Server5 and Server6) to disable Azure Arc integration:

    ```
    Disable-AzureStackHCIArcIntegration
    ```

1. Remove the server pairs from the cluster using the `Remove-ClusterNode` cmdlet:

    ```
    Remove-ClusterNode -Name Server5,Server6
    ```

Once the servers have been successfully removed, the associated drives are automatically removed from the site pools. Lastly, the Health Service creates a storage job to remove these drives.

## Next steps

- You should validate the cluster after adding or removing a server. For more information, see [Validate the cluster](../deploy/validate.md) for more information.