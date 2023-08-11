--- 
title: Set up a cluster witness 
description: Learn how to set up a cluster witness 
author: jasongerend 
ms.topic: how-to 
ms.date: 04/19/2023
ms.author: jgerend 
ms.reviewer: stevenek 
---

# Set up a cluster witness

> Applies to: Azure Stack HCI, versions 22H2 and 21H2; Windows Server 2022, Windows Server 2019

This article describes how to set up an Azure Stack HCI or Windows Server cluster with a cluster witness in Azure (known as a cloud witness).

We recommend setting up a cluster witness for clusters with two, three, or four nodes. The witness helps the cluster determine which nodes have the most up-to-date cluster data if some nodes can't communicate with the rest of the cluster. You can host the cluster witness on a file share located on another server, or use a cloud witness.

To learn more about cluster witnesses and quorum, see [Understanding cluster and pool quorum on Azure Stack HCI](../concepts/quorum.md). To manage the witness, including setting a file share witness, see [Change cluster settings](../manage/cluster.md#change-cluster-settings).

## Before you begin

Before you can create a cloud witness, you must have an Azure account and subscription, and register your Azure Stack HCI cluster with Azure. See the following articles for more information:

- Make sure that port 443 is open in your firewalls and that `*.core.windows.net` is included in any firewall allow lists you're using between the cluster and Azure Storage. For details, see [Recommended firewall URLs](../concepts/firewall-requirements.md#recommended-firewall-urls).
- If your network uses a proxy server for internet access, you must [configure proxy settings for Azure Stack HCI](./configure-proxy-settings.md).
- [Create an Azure account](/dotnet/azure/create-azure-account).
- If applicable, [create an additional Azure subscription](/azure/cost-management-billing/manage/create-subscription).
- [Connect Azure Stack HCI to Azure](../deploy/register-with-azure.md).
- Make sure DNS is available for the cluster.

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

When you create an Azure storage account, the process automatically generates two access keys, a primary key (key1) and a secondary key (key2). For the first time creation of a cloud witness, **key1** is used. The endpoint URL is also generated automatically.

An Azure cloud witness uses a blob file for storage, with an endpoint generated of the form *storage_account_name.blob.core.windows.net* as the endpoint.

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

Alternatively, you can create a witness instance for your cluster using PowerShell.

Use the following cmdlet to create an Azure cloud witness. Enter the Azure storage account name and access key information as described previously:

```powershell
Set-ClusterQuorum –Cluster "Cluster1" -CloudWitness -AccountName "AzureStorageAccountName" -AccessKey "AzureStorageAccountAccessKey"
```

Use the following cmdlet to create a file share witness. Enter the path to the file server share:

```powershell
Set-ClusterQuorum -FileShareWitness "\\fileserver\share" -Credential (Get-Credential)
```

## Next steps

To perform the next management task related to this article, see:
> [!div class="nextstepaction"]
> [Connect Azure Stack HCI to Azure](..\deploy\register-with-azure.md)

- For more information on cluster quorum, see [Understanding cluster and pool quorum on Azure Stack HCI](../concepts/quorum.md).

- For more information about creating and managing Azure Storage Accounts, see [Create a storage account](/azure/storage/common/storage-account-create).
