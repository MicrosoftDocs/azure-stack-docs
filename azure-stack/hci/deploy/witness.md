--- 
title: Setup a cluster witness 
description: Learn how to setup a cluster witness 
author: v-dasis 
ms.topic: how-to 
ms.date: 07/08/2020 
ms.author: v-dasis 
ms.reviewer: JasonGerend 
---

# Setup a cluster witness

> Applies to Azure Stack HCI, version 20H2; Windows Server 2019

A witness resource is highly recommended for all clusters. Two-node clusters need a witness so that either server going offline does not cause the other node to become unavailable as well. Three and higher-node clusters need a witness to be able to withstand two servers failing or being offline.  You can use a file share as a witness or use an Azure cloud witness.

A cloud witness is recommended if all server nodes have a reliable Internet connection. For more information, see [Deploy a Cloud Witness for a Failover Cluster](https://docs.microsoft.com/windows-server/failover-clustering/deploy-cloud-witness)

## Setup a witness using Windows Admin Center

1. In Windows Admin Center, under **Tools**, select **Settings**.
1. In the right pane, select **Witness**.
1. Under **Witness type**, select one of the following:
      - **Cloud witness** - enter your Azure storage account name, key and endpoint
      - **File share witness** - enter the file share path (//server/share)

> [!NOTE]
> The **Disk witness** option is not suitable for stretched clusters.


## Setup a witness using Windows PowerShell

Use the following cmdlet to create an Azure cloud witness:

```powershell
Set-ClusterQuorum –Cluster Cluster1 -CloudWitness -AccountName <AzureStorageAccountName> -AccessKey <AzureStorageAccountAccessKey>
```

Use the following cmdlet to create a file-share witness:

```powershell
Set-ClusterQuorum –Cluster Cluster1 -FileShareWitness \\fileserver\fsw
```

## Next steps

For more information on cluster quorum, see [](https://docs.microsoft.com/windows-server/failover-clustering/manage-cluster-quorum)