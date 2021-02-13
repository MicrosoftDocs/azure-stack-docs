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

You can either use an SMB file share as a witness or an Azure cloud witness. An Azure cloud witness is recommended, provided all server nodes in the cluster have a reliable internet connection. This article covers creating a cloud witness.

## Before you begin

Before you can create a cloud witness, you must have an Azure account and subscription, and register your Azure Stack HCI cluster with Azure. See the following articles for more information:

- [Create an Azure account](https://docs.microsoft.com/dotnet/azure/create-azure-account)
- If applicable, [create an additional Azure subscription](https://docs.microsoft.com/azure/cost-management-billing/manage/create-subscription)
- [Connect Azure Stack HCI to Azure](../deploy/register-with-azure)

For file share witnesses, there are requirements for the file server. See [System requirements](../concepts/system-requirements.md) for more information.

## Create an Azure storage account

This section describes how to create an Azure storage account. This account is used to store an Azure blob file used for arbitration for a specific cluster. You can use the same Azure storage account to configure a cloud witness for multiple clusters.

1. Sign in to the [Azure portal](https://portal.azure.com).
1. On the Azure portal home menu, under **Azure services**, select **Storage accounts**. If this icon is missing, select **Create a resource** to create a *Storage accounts* resource first.

    :::image type="content" source="media/witness/cloud-witness-home.png" alt-text="Azure portal home screen" lightbox="media/witness/cloud-witness-home.png":::

1. On the **Storage accounts** page, select **New**.

    :::image type="content" source="media/witness/cloud-witness-create.png" alt-text="Azure new storage account" lightbox="media/witness/cloud-witness-create.png":::

1. On the **Create storage account** page, complete the following:
    1. Select the Azure **Subscription** to apply the storage account to.
    1. Select the Azure **Resource group** to apply the storage account to.
    1. Enter a **Storage account name**.
    <br>Storage account names must be between 3 and 24 characters in length and may contain numbers and lowercase letters only. This name must also be unique within Azure.
    1. Select a **Location** that is closest to you physically.
    1. For **Performance**, select **Standard**.
    1. For **Account kind**, select **Storage general purpose**.
    1. For **Replication**, select **Locally-redundant storage (LRS)**.
    1. When finished, click **Review + create**.

    :::image type="content" source="media/witness/cloud-witness-create-storage-account.png" alt-text="Azure create storage account" lightbox="media/witness/cloud-witness-create-storage-account.png":::

1. Ensure that the storage account passes validation and then review account settings. When finished, click **Create**.

    :::image type="content" source="media/witness/cloud-witness-validation.png" alt-text="Azure storage account validation" lightbox="media/witness/cloud-witness-validation.png":::

1. It may take a few seconds for account deployment to occur in Azure. When deployment is complete, click **Go to resource**.

    :::image type="content" source="media/witness/cloud-witness-deployment.png" alt-text="Azure storage account deployment" lightbox="media/witness/cloud-witness-deployment.png":::

## Copy the access key and endpoint URL

When you create an Azure storage account, it generates two access keys that are automatically generated, a primary key (key1) and a secondary key (key2). For the first time creation of a cloud witness, **key1** is used for the witness. The endpoint URL is also generated automatically.

An Azure cloud witness uses a blob file for storage, with an endpoint generated of the form *https://storage_account_name.blob.core.windows.net* as the endpoint. 

> [!NOTE]  
> An Azure cloud witness uses HTTPS (default port 443) to establish communication with the Azure blob service. Ensure that the HTTPS port is accessible.

### Copy the account name and access key

1. In the Azure portal, under **Settings**, select **Access keys**.
1. Select **Show keys** to display key information.
1. Click the copy-and-paste icon to the right of the **Storage account name** and **key1** fields and paste each text string to Notepad or other text editor.

    :::image type="content" source="media/witness/cloud-witness-access-keys.png" alt-text="Azure storage account access keys" lightbox="media/witness/cloud-witness-access-keys.png":::

### Copy the endpoint URL (optional)

The endpoint URL is optional and may not be needed for a cloud witness.

1. In the Azure portal, select **Properties**.
1. Select **Show keys** to display endpoint information.
1. Under **Blob service**, click the copy-and-paste icon to the right of the **Blob service** field and paste the text string to Notepad or other text editor.

    :::image type="content" source="media/witness/cloud-witness-blob-service.png" alt-text="Azure blob endpoint" lightbox="media/witness/cloud-witness-blob-service.png":::

## Create a cloud witness using Windows Admin Center

Now you are ready to create a witness instance for your cluster using Windows Admin Center.

1. In Windows Admin Center, select **Cluster Manager** from the top drop-down arrow.
1. Under **Cluster connections**, select the cluster.
1. Under **Tools**, select **Settings**.
1. In the right pane, select **Witness**.
1. For **Witness type**, select one of the following:
      - **Cloud witness** - enter your Azure storage account name, access key, and endpoint URL, as described previously
      - **File share witness** - enter the file share path "(//server/share)"
1. For a cloud witness, for the following fields, paste the text strings you copied previously for:
    1. **Azure storage account name**
    1. **Azure storage access key**
    1. **Azure service endpoint**

    :::image type="content" source="media/witness/cloud-witness-1.png" alt-text="Cloud Witness access keys" lightbox="media/witness/cloud-witness-1.png":::

1. When finished, click **Save**. It might take a bit for the information to propagate to Azure.

> [!NOTE]
> The third option, **Disk witness**, is not suitable for use in stretched clusters.

## Create a cloud witness using Windows PowerShell

You are ready to create a witness instance for your cluster using PowerShell.

Use the following cmdlet to create an Azure cloud witness. Enter the Azure storage account name and access key information as described previously:

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