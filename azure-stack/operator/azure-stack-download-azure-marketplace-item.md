---
title: Download marketplace items from Azure and publish to Azure Stack | Microsoft Docs
description: Learn how to download marketplace items from Azure and publish to Azure Stack.
services: azure-stack
documentationcenter: ''
author: sethmanheim
manager: femila
editor: ''

ms.assetid:
ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: conceptual
ms.date: 10/10/2019
ms.author: sethm
ms.reviewer: ihcherie
ms.lastreviewed: 12/10/2018
---

# Download existing marketplace items from Azure and publish to Azure Stack

*Applies to: Azure Stack integrated systems and Azure Stack Development Kit*

As a cloud operator, you can download items from Azure Marketplace and make them available in Azure Stack. The items you can choose are from a curated list of Azure Marketplace items that are pre-tested and supported to work with Azure Stack. Additional items are frequently added to this list, so continue to check back for new content.

There are two scenarios for connecting to Azure Marketplace:

- **A connected scenario** - requires your Azure Stack environment to be connected to the internet. You use the Azure Stack portal to locate and download items.
- **A disconnected or partially connected scenario** - requires you to access the internet using the Marketplace syndication tool to download Marketplace items. Then, you transfer your downloads to your disconnected Azure Stack installation. This scenario uses PowerShell.

See [Azure Marketplace items for Azure Stack](azure-stack-marketplace-azure-items.md) for a complete list of the marketplace items you can download. See the [Azure Stack Marketplace changes](azure-stack-marketplace-changes.md) article for a list of recent additions, deletions, and updates to Azure Stack Marketplace.

## Connected scenario

If Azure Stack connects to the internet, you can use the administrator portal to download marketplace items.

### Prerequisites

Your Azure Stack deployment must have internet connectivity and be [registered with Azure](azure-stack-registration.md).

### Use the portal to download marketplace items
  
1. Sign in to the Azure Stack administrator portal.

2. Review the available storage space before downloading marketplace items. Later, when you select items for download, you can compare the download size to your available storage capacity. If capacity is limited, consider options for [managing available space](azure-stack-manage-storage-shares.md#manage-available-space).

    To review available space: in **Region management**, select the region you want to explore and then go to **Resource Providers** > **Storage**:

    ![Review storage space in Azure Stack administrator portal](media/azure-stack-download-azure-marketplace-item/storage.png)

3. Open Azure Stack Marketplace and connect to Azure. To do so, select the **Marketplace management** service, select **Marketplace items**, and then select **Add from Azure**:

    ![Add marketplace items from Azure](media/azure-stack-download-azure-marketplace-item/marketplace.png)

4. The portal displays the list of items available for download from the Azure Marketplace. You can filter products by name, publisher and/or type of product. Each line item also shows the currently available version. If more than one version of a Marketplace item is available, the **Version** column shows **Multiple**. You can click on each item to view its description and additional information, including its download size:

    [![List of marketplace items](media/azure-stack-download-azure-marketplace-item/add-from-azure1sm.png "List of marketplace items")](media/azure-stack-download-azure-marketplace-item/add-from-azure1.png#lightbox)

5. If the version of an item is shown as **Multiple**, you can select that item and then choose a specific version from the resulting version selector dropdown:

    [![Select version](media/azure-stack-download-azure-marketplace-item/add-from-azure3sm.png "Select version")](media/azure-stack-download-azure-marketplace-item/add-from-azure3.png#lightbox)

6. Select the item you want, and then select **Download**. Download times vary.

    ![Downloading Azure Marketplace item](media/azure-stack-download-azure-marketplace-item/image04.png)

    After the download completes, you can deploy the new marketplace item as either an Azure Stack operator or a user.

7. To deploy the downloaded item, select **+ Create a resource**, and then search among the categories for the new marketplace item. Next select the item to begin the deployment process. The process varies for different marketplace items.

## Disconnected or a partially connected scenario

If Azure Stack is in a disconnected mode, you use PowerShell and the *marketplace syndication tool* to download the marketplace items to a machine with internet connectivity. You then transfer the items to your Azure Stack environment. In a disconnected environment, you can't download marketplace items by using the Azure Stack portal.

The marketplace syndication tool can also be used in a connected scenario.

There are two parts to this scenario:

- **Part 1:** Download from Azure Marketplace. On the computer with internet access you configure PowerShell, download the syndication tool, and then download items from Azure Marketplace.  
- **Part 2:** Upload and publish to Azure Stack Marketplace. You move the files you downloaded to your Azure Stack environment, import them to Azure Stack, and then publish them to Azure Stack Marketplace.  

### Prerequisites

- A connected environment (does not have to be Azure Stack). You need connectivity to get the list of products from Azure with their details, and to download everything locally. Once this is done, the rest of the procedure does not require any internet connectivity. It creates a catalog of items you've previously downloaded for you to use in your disconnected environment.

- A USB key or external drive to connect to your disconnected environment and transfer all the necessary artifacts.

- A disconnected Azure Stack environment with the following prerequisites:
  - Your Azure Stack deployment must be [registered with Azure](azure-stack-registration.md).
  - The computer that has internet connectivity must have **Azure Stack PowerShell Module version 1.2.11** or higher. If not already present, [install Azure Stack-specific PowerShell modules](azure-stack-powershell-install.md).
  - To enable import of a downloaded marketplace item, the [PowerShell environment for the Azure Stack operator](azure-stack-powershell-configure-admin.md) must be configured.
  - Clone the [Azure Stack tools](https://github.com/Azure/AzureStack-Tools) GitHub repo.

- You must have a [storage account](azure-stack-manage-storage-accounts.md) in Azure Stack that has a publicly accessible container (which is a storage blob). You use the container as temporary storage for the marketplace items gallery files. If you're not familiar with storage accounts and containers, see [Work with blobs - Azure portal](/azure/storage/blobs/storage-quickstart-blobs-portal) in the Azure documentation.

- The marketplace syndication tool is downloaded during the first procedure.

- You can install [AzCopy](/azure/storage/common/storage-use-azcopy) for optimal download performance, but it's not required.

Once you have registered, you can disregard the following message that appears on the Marketplace management blade, as this is not relevant for the disconnected use case:

[![Not registered message](media/azure-stack-download-azure-marketplace-item/toolsmsgsm.png "Not registered message")](media/azure-stack-download-azure-marketplace-item/toolsmsg.png#lightbox)

### Use the marketplace syndication tool to download marketplace items

> [!IMPORTANT]
> Be sure to download the marketplace syndication tool each time you download marketplace items in a disconnected scenario. Frequent changes are made to this script and the most current version should be used for each download.

1. On a computer with an Internet connection, open a PowerShell console as an administrator.

2. Add the Azure account that you've used to register Azure Stack. To add the account, in PowerShell run `Add-AzureRmAccount` without any parameters. You're prompted to enter your Azure account credentials and you might have to use two-factor authentication, depending on your account's configuration.

   [!include[Remove Account](../../includes/remove-account.md)]

3. If you have multiple subscriptions, run the following command to select the one you've used for registration:  

   ```powershell  
   Get-AzureRmSubscription -SubscriptionID 'Your Azure Subscription GUID' | Select-AzureRmSubscription
   $AzureContext = Get-AzureRmContext
   ```

4. Download the latest version of the marketplace syndication tool by using the following script:  

   ```powershell
   # Download the tools archive.
   [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
   invoke-webrequest https://github.com/Azure/AzureStack-Tools/archive/master.zip `
     -OutFile master.zip

   # Expand the downloaded files.
   expand-archive master.zip `
     -DestinationPath `
     -Force

   # Change to the tools directory.
   cd .\AzureStack-Tools-master
   ```

5. Import the syndication module and then launch the tool by running the following commands. Replace `Destination folder path` with a location to store the files you download from Azure Marketplace.

   ```powershell  
   Import-Module .\Syndication\AzureStack.MarketplaceSyndication.psm1

   Export-AzSOfflineMarketplaceItem -Destination "Destination folder path in quotes"
   ```

   Note that `Export-AzSOfflineMarketplaceItem` has an additional `-cloud` flag that specifies the cloud environment. By default, it's **azurecloud**.

6. When the tool runs, you should see a screen similar to the following image, with the list of available Azure marketplace items:

   [![Azure Marketplace items popup](media/azure-stack-download-azure-marketplace-item/tool1sm.png "Azure Marketplace items")](media/azure-stack-download-azure-marketplace-item/tool1.png#lightbox)

7. If more than one version of a Marketplace item is available, the **Version** column shows **Multiple versions**. If the version of an item is shown as **Multiple versions**, you can select that item and then choose a specific version from the resulting version selector window:

   [![Version selector](media/azure-stack-download-azure-marketplace-item/tool2sm.png "Select version")](media/azure-stack-download-azure-marketplace-item/tool2.png#lightbox)

7. If you have not installed the Azure Storage tools, you will get the following message. In order to install these tools, make sure you download [AzCopy](/azure/storage/common/storage-use-azcopy#download-azcopy):

   ![Storage tools](media/azure-stack-download-azure-marketplace-item/vmnew1.png)

8. Select the item that you want to download and make a note of the **Version**. You can hold the **Ctrl** key to select multiple images. You reference the *version* when you import the item in the next procedure.

   You can also filter the list of images by using the **Add criteria** option.

9. Select **OK**, and then review and accept the legal terms.

10. The time that the download takes depends on the size of the item. After the download completes, the item is available in the folder that you specified in the script. The download includes a VHD file (for virtual machines) or a .zip file (for virtual machine extensions). It might also include a gallery package in the *.azpkg* format, which is simply a .zip file.

11. If the download fails, you can try again by re-running the following PowerShell cmdlet:

    ```powershell
    Export-AzSOfflineMarketplaceItem -Destination "Destination folder path in quotes"
    ```

    Before retrying, remove the product folder in which the download failed. For example, if the download script fails when downloading to `D:\downloadFolder\microsoft.customscriptextension-arm-1.9.1`, remove the `D:\downloadFolder\microsoft.customscriptextension-arm-1.9.1` folder, then rerun the cmdlet.

### Import the download and publish to Azure Stack Marketplace using PowerShell

1. You must move the files that you have [previously downloaded](#use-the-marketplace-syndication-tool-to-download-marketplace-items) locally so that they are available to your Azure Stack environment. The marketplace syndication tool must also be available to your Azure Stack environment because you need to use the tool to perform the import operation.

   The following image shows a folder structure example. `D:\downloadfolder` contains all the downloaded marketplace items. Each subfolder is a marketplace item (for example, `microsoft.custom-script-linux-arm-2.0.3`), named by the product ID. Inside each subfolder is the marketplace item's downloaded content.

   [![Marketplace download directory structure](media/azure-stack-download-azure-marketplace-item/mp1sm.png "Marketplace download directory structure")](media/azure-stack-download-azure-marketplace-item/mp1.png#lightbox)

2. Follow the instructions in [this article](azure-stack-powershell-configure-admin.md) to configure the Azure Stack Operator PowerShell session.

3. Import the syndication module and then launch the marketplace syndication tool by running the following script:

   ```powershell
   $credential = Get-Credential -Message "Enter the azure stack operator credential:"
   Import-AzSOfflineMarketplaceItem -origin "marketplace content folder" -AzsCredential $credential
   ```

   The `-origin` parameter specifies the top-level folder that contains all the downloaded products; for example, `"D:\downloadfolder"`.

   The `-AzsCredential` parameter is optional. It's used to renew the access token, if it has expired. If the `-AzsCredential` parameter isn't specified and the token expires, you receive a prompt to enter the operator credentials.

    > [!NOTE]  
    > AD FS only supports interactive authentication with user identities. If a credential object is required, you must use a service principal (SPN). For more information about setting up a service principal with Azure Stack and AD FS as your identity management service, see [Manage an AD FS service principal](azure-stack-create-service-principals.md#manage-an-ad-fs-service-principal).

4. After the script successfully completes, the item should be available in Azure Stack Marketplace.

## Next steps

- [Add a custom virtual machine image](azure-stack-add-vm-image.md)
- [Create and publish a custom Marketplace item](azure-stack-create-and-publish-marketplace-item.md)
