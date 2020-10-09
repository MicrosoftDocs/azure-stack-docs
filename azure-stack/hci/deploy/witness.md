--- 
title: Set up a cluster witness 
description: Learn how to set up a cluster witness 
author: v-dasis 
ms.topic: how-to 
ms.date: 08/11/2020 
ms.author: v-dasis 
ms.reviewer: JasonGerend 
---

# Set up a cluster witness

> Applies to Azure Stack HCI, version 20H2; Windows Server 2019

Setting up a witness resource is mandatory for all clusters, and should be set up right after you create a cluster. Two-node clusters need a witness so that either server going offline does not cause the other node to become unavailable as well. Three and higher-node clusters need a witness to be able to withstand two servers failing or being offline.  

You can either use an SMB file share as a witness or use an Azure cloud witness. An Azure cloud witness is recommended, provided all server nodes in the cluster have a reliable internet connection. For more information, see [Deploy a Cloud Witness for a Failover Cluster](/windows-server/failover-clustering/deploy-cloud-witness).

For file-share witnesses, there are requirements for the file server. See [Before you deploy Azure Stack HCI](before-you-start.md) for more information.

## Set up a witness using Windows Admin Center

1. In Windows Admin Center, select **Cluster Manager** from the top drop-down arrow.
1. Under **Cluster connections**, select the cluster.
1. Under **Tools**, select **Settings**.
1. In the right pane, select **Witness**.
1. For **Witness type**, select one of the following:
      - **Cloud witness** - enter your Azure storage account name, access key, and endpoint URL, as described below
      - **File share witness** - enter the file share path "(//server/share)"

> [!NOTE]
> The third option, **Disk witness**, is not suitable for use in stretched clusters.

## Create an Azure Storage Account to use as a Cloud Witness

This section describes how to create a storage account and view and copy endpoint URLs and access keys for that account.

To configure Cloud Witness, you must have a valid Azure Storage Account which can be used to store the blob file (used for arbitration). Cloud Witness creates a well-known Container **msft-cloud-witness** under the Microsoft Storage Account. Cloud Witness writes a single blob file with corresponding cluster's unique ID used as the file name of the blob file under this **msft-cloud-witness** container. This means that you can use the same Microsoft Azure Storage Account to configure a Cloud Witness for multiple different clusters.

When you use the same Azure Storage Account for configuring Cloud Witness for multiple different clusters, a single **msft-cloud-witness** container gets created automatically. This container will contain one-blob file per cluster.

> [!NOTE]  
> Cloud Witness uses HTTPS (default port 443) to establish communication with Azure blob service. Ensure that HTTPS port is accessible via network Proxy.

### To create an Azure storage account

1. Sign in to the [Azure portal](https://portal.azure.com).
1. On the Hub menu, select New -> Data + Storage -> Storage account.
1. In the Create a storage account page, do the following:
    1. Enter a name for your storage account.
    <br>Storage account names must be between 3 and 24 characters in length and may contain numbers and lowercase letters only. The storage account name must also be unique within Azure.
    1. For **Account kind**, select **General purpose**.
    <br>You can't use a Blob storage account for a Cloud Witness.
    1. For **Performance**, select **Standard**.
    <br>You can't use Azure Premium Storage for a Cloud Witness.
    1. For **Replication**, select **Locally-redundant storage (LRS)** .
    <br>Failover Clustering uses the blob file as the arbitration point, which requires some consistency guarantees when reading the data. Therefore you must select **Locally-redundant storage** for **Replication** type.

### View and copy storage access keys for your Azure Storage Account

When you create a Microsoft Azure Storage Account, it is associated with two Access Keys that are automatically generated - Primary Access key and Secondary Access key. For a first-time creation of Cloud Witness, use the **Primary Access Key**. There is no restriction regarding which key to use for Cloud Witness.  

#### To view and copy storage access keys

In the Azure portal, navigate to your storage account, click **All settings** and then click **Access Keys** to view, copy, and regenerate your account access keys. The Access Keys blade also includes pre-configured connection strings using your primary and secondary keys that you can copy to use in your applications.

:::image type="content" source="media/witness/cloud-witness-1.png" alt-text="Cloud Witness access keys" lightbox="media/witness/cloud-witness-1.png":::

### View and copy endpoint URL Links

When you create a Storage Account, the following URLs are generated using the format: `https://<Storage Account Name>.<Storage Type>.<Endpoint>`  

Cloud Witness always uses **Blob** as the storage type. Azure uses **.core.windows.net** as the Endpoint. When configuring Cloud Witness, it is possible that you configure it with a different endpoint as per your scenario (for example the Microsoft Azure datacenter in China has a different endpoint).  

> [!NOTE]  
> The endpoint URL is generated automatically by Cloud Witness resource and there is no extra step of configuration necessary for the URL.  

#### To view and copy endpoint URL links

In the Azure portal, navigate to your storage account, click **All settings** and then click **Properties** to view and copy your endpoint URLs.  

:::image type="content" source="media/witness/cloud-witness-2.png" alt-text="Cloud Witness endpoint URL" lightbox="media/witness/cloud-witness-2.png":::  

## Set up a witness using Windows PowerShell

To setup a cluster witness using PowerShell, run one of the following cmdlets.

Use the following cmdlet to create an Azure cloud witness:

```powershell
Set-ClusterQuorum –Cluster "Cluster1" -CloudWitness -AccountName "AzureStorageAccountName" -AccessKey "AzureStorageAccountAccessKey"
```

Use the following cmdlet to create a file-share witness:

```powershell
Set-ClusterQuorum -FileShareWitness "\\fileserver\share" -Credential (Get-Credential)
```

## Next steps

- For more information on cluster quorum, see [Understanding cluster and pool quorum on Azure Stack HCI](../concepts/quorum.md).

- For more information about creating and managing Azure Storage Accounts, see [About Azure Storage Accounts](/azure/storage/common/storage-account-create).