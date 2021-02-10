---
author: mattbriggs
ms.author: mabrigg
ms.service: azure-stack
ms.topic: include
ms.date: 2/1/2021
ms.reviewer: thoroet
ms.lastreviewed: 08/04/2020
---

Use Azure Storage Explorer or AzCopy to reduce that chance that your VHD will be corrupted in the upload process, and your upload will be faster. The following steps use AzCopy. AzCopy is a command-line utility that you can use to copy blobs or files to or from a storage account.

1. If you don't have AzCopy installed, install AzCopy. You find find instruction to download and get started with AzCopy in the article [Get started with AzCopy](/azure/storage/common/storage-use-azcopy-v10). Add AzCopy to your path. `need instructions.`

2. You will need the SAS URL for the VHD in Azure storage.

3. Open PowerShell to use AzCopy from the shell, and run the following command:

    ```powershell  
    azcopy <SAS URL> <local path> --check-md5=NoCheck
    ````

    > [!NOTE]
    > If the VHD  doesn't contain the MD5 data and if you run AzCopy without the `--check-md5=NoCheck` option, it'll fail because the hash will not match.