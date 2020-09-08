---
author: mattbriggs
ms.author: mabrigg
ms.service: azure-stack
ms.topic: include
ms.date: 08/04/2020
ms.reviewer: thoroet
ms.lastreviewed: 08/04/2020
---

You can upload your VHD with the portal, or with the container you created in the portal, use AzCopy.

### Portal to generate SAS URL and upload VHD

1. Sign in to the Azure Stack Hub user portal.

2. Select **Storage Accounts** and select an existing storage account or create a new storage account.

3. Select **Blobs** in the storage account blade for your storage account. Select Container to create a new container.

4. Type the name of your container, and then select **Blob (anonymous read access for blobs only)**.

5. If you are going to use AzCopy to upload your image rather than the portal, create a SAS token. Select **Shared access signature** in the storage account, and then select **Generate SAS and connection string**. Copy and make a note of the **Blob service SAS URL**. You will use this URL when using AzCopy to upload your VHD.

6. Select your container and then select **Upload**. Upload your VHD.

### AzCopy VHD

Use Azure Storage Explorer or AzCopy to reduce that chance that your VHD will be corrupted in the upload process, and your upload will be faster. The following steps use AzCopy on a Windows 10 machine. AzCopy is a command-line utility that you can use to copy blobs or files to or from a storage account.

1. If you don't have AzCopy installed, install AzCopy. You find find instruction to download and get started with AzCopy in the article [Get started with AzCopy](https://docs.microsoft.com/azure/storage/common/storage-use-azcopy-v10). Make a note of where you store the binary. You can [add AzCopy to your path](https://www.architectryan.com/2018/03/17/add-to-the-path-on-windows-10/) to use it from the PowerShell command line.

2. Open PowerShell to use AzCopy from the shell.

3. Use AzCopy to upload your VHD into the your container in the storage account.

    ```powershell  
    set AZCOPY_DEFAULT_SERVICE_API_VERSION=2017-11-09
    azcopy cp "/path/to/file.vhd" "https://[account].blob.core.windows.net/[container]/[path/to/blob]?[SAS] --blob-type=PageBlob
    ```

> [!NOTE]  
> Upload your VHD using syntax similar to uploading a single file to virtual directory. Add `--blob-type=PageBlob` to make sure that the VHD is uploaded as a **Page Blob**, instead of **Block** by default.

For more information about using AzCopy and other storage tools, see [Use data transfer tools in Azure Stack Hub Storage](/azure-stack/user/azure-stack-storage-transfer).