--- 
title: Set up a cluster witness 
description: Learn how to set up a cluster witness 
author: v-dasis 
ms.topic: how-to 
ms.date: 02/12/2021
ms.author: v-dasis 
ms.reviewer: JasonGerend 
---

# Set up a cluster witness

> Applies to Azure Stack HCI, version 20H2; Windows Server 2019

Setting up a witness resource is highly recommended for all clusters, and should be set up right after you create a cluster. Two-node clusters need a witness so that either server going offline does not cause the other node to become unavailable as well. Three and higher-node clusters need a witness to be able to withstand two servers failing or being offline.  

You can either use an SMB file share as a witness or use an Azure cloud witness. An Azure cloud witness is recommended, provided all server nodes in the cluster have a reliable internet connection.

For file share witnesses, there are requirements for the file server. See [System requirements](../concepts/system-requirements.md) for more information.

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

### Create an Azure storage account

This section describes how to create an Azure storage account and view and copy endpoint URLs and access keys for that account.

To configure Cloud Witness, you must have a valid Azure Storage Account that can be used to store the Azure blob file (used for arbitration). Cloud Witness creates a well-known Container **msft-cloud-witness** under the Microsoft Storage Account. Cloud Witness writes a single blob file with corresponding cluster's unique ID used as the file name of the blob file under this **msft-cloud-witness** container. This means that you can use the same Microsoft Azure Storage Account to configure a Cloud Witness for multiple different clusters.

When you use the same Azure Storage Account for configuring Cloud Witness for multiple different clusters, a single **msft-cloud-witness** container gets created automatically. This container will contain one-blob file per cluster.

> [!NOTE]  
> Cloud Witness uses HTTPS (default port 443) to establish communication with the Azure blob service. Ensure that the HTTPS port is accessible.

1. Sign in to the [Azure portal](https://portal.azure.com).
1. On the Azure portal home menu, under **Azure services**, select **Storage accounts**.

    :::image type="content" source="media/witness/cloud-witness-home.png" alt-text="Azure portal home screen" lightbox="media/witness/cloud-witness-home.png":::

1. Under **Storage accounts**, select **New**.

    :::image type="content" source="media/witness/cloud-witness-create.png" alt-text="Azure new storage account" lightbox="media/witness/cloud-witness-create.png":::

1. On the **Create storage account** page, do the following:
    1. Select the Azure **Subscription** to apply the storage account to.
    1. Select the Azure **Resource group** to apply the storage account to.
    1. Enter a **Storage account name**.
    <br>Storage account names must be between 3 and 24 characters in length and may contain numbers and lowercase letters only. The storage account name must also be unique within Azure.
    1. Select a **Location** that is closest to you physically.
    1. For **Performance**, select **Standard**.
    1. For **Account kind**, select **Storage general purpose**.
    1. For **Replication**, select **Locally-redundant storage (LRS)**.
    1. When finished, click **Review + create**.

    :::image type="content" source="media/witness/cloud-witness-create-storage-account.png" alt-text="Azure create storage account" lightbox="media/witness/cloud-witness-create-storage-account.png":::

1. Ensure that the storage account passes validation and review account settings. Then click **Create**.

    :::image type="content" source="media/witness/cloud-witness-validation.png" alt-text="Azure storage account validation" lightbox="media/witness/cloud-witness-validation.png":::

1. It may take a few seconds for account deployment to occur in Azure. When deployment is complete, click **Go to resource**.

    :::image type="content" source="media/witness/cloud-witness-deployment.png" alt-text="Azure storage account deployment" lightbox="media/witness/cloud-witness-deployment.png":::

### Generate the access keys and endpoint URL

When you create an Azure storage account, it generates two access keys that are automatically generated, primary key (key1) and a secondary key (key2). For a first-time creation of a cloud witness, use **key1**. The endpoint URL is also generated automatically.

When you create an Azure storage account, the following URLs are generated using the format: `https://<Storage Account Name>.<Storage Type>.<Endpoint>`

An Azure cloud witness uses a blob as the storage type. Azure uses **.core.windows.net** as the endpoint. When configuring a cloud witness, you may configure it with a different endpoint as per your scenario. For example, the Azure data center in Australia uses a different endpoint.  

#### Copy the account name and access key

1. In the Azure portal, under **Settings**, select **Access keys**.
1. Select **Show keys** to display key information.
1. Click the copy-and-paste icon to the right of the **Storage account name** and **key 1** fields and paste each text string to Notepad or other text editor.

    :::image type="content" source="media/witness/cloud-witness-access-keys.png" alt-text="Azure storage account access keys" lightbox="media/witness/cloud-witness-access-keys.png":::

#### Copy the endpoint URL

1. In the Azure portal, select **Properties**.
1. Select **Show keys** to display key information.
1. Under **Blob service**, click the copy-and-paste icon to the right of the **blob service** field and paste the text string to Notepad or other text editor.

    :::image type="content" source="media/witness/cloud-witness-blob-service.png" alt-text="Azure blob endpoint" lightbox="media/witness/cloud-witness-blob-service.png":::

### Save settings in Windows Admin Center

1. In Windows Admin Center, under **Tools**, select **Settings**, then **Witness**.
1. For **Witness type**, select **Cloud witness**.
1. For the following fields, paste the text strings you copied previously for:
    1. **Azure storage account name**
    1. **Azure storage access key**
    1. **Azure service endpoint**

    :::image type="content" source="media/witness/cloud-witness-1.png" alt-text="Cloud Witness access keys" lightbox="media/witness/cloud-witness-1.png":::

1. When finished, click **Save**.

## Set up a witness using Windows PowerShell

To setup a cluster witness using PowerShell, run one of two cmdlets.

Use the following cmdlet to create an Azure cloud witness. Enter the Azure storage account and access key information:

```powershell
Set-ClusterQuorum –Cluster "Cluster1" -CloudWitness -AccountName "AzureStorageAccountName" -AccessKey "AzureStorageAccountAccessKey"
```

Use the following cmdlet to create a file-share witness. Enter the path to the file server share:

```powershell
Set-ClusterQuorum -FileShareWitness "\\fileserver\share" -Credential (Get-Credential)
```

## Next steps

- For more information on cluster quorum, see [Understanding cluster and pool quorum on Azure Stack HCI](../concepts/quorum.md).

- For more information about creating and managing Azure Storage Accounts, see [About Azure Storage Accounts](/azure/storage/common/storage-account-create).