---
title: Back up your storage accounts on Azure Stack Hub
description: Learn how to back up your storage accounts on Azure Stack Hub with step-by-step guidance on data replication, AzCopy setup, and disaster recovery strategies.
author: sethmanheim

ms.topic: how-to
ms.date: 07/08/2026
ms.author: sethm
ms.reviewer: thoroet
ms.lastreviewed: 12/2/2020
ms.custom: sfi-image-nochange

# Intent: Notdone: As a < type of user >, I want < what? > so that < why? >
# Keyword: Notdone: keyword noun phrase

---


# Back up your storage accounts on Azure Stack Hub

This article covers protection and recovery of storage accounts within Azure Storage accounts on Azure Stack Hub.

## Elements of the solution

This section describes the overall structure of the solution and its major parts.

:::image type="content" source="./media/azure-stack-network-howto-backup-storage/azure-stack-storage-backup.png" alt-text="Diagram that shows the overall structure of Azure Stack Hub storage backup." lightbox="./media/azure-stack-network-howto-backup-storage/azure-stack-storage-backup.png":::

### Application layer

You can replicate data between storage accounts on separate Azure Stack Hub scale units by issuing multiple [PUT Blob](/rest/api/storageservices/put-blob) or [Put Block](/rest/api/storageservices/put-block) operations to write objects to multiple locations. Alternatively, the application can issue the [Copy Blob](/rest/api/storageservices/copy-blob) operation to copy the blob to a storage account hosted on a separate scale unit after the Put operation to the primary account finishes.

### Scheduled copy task

AzCopy is a tool that you can use to copy data from local filesystems, Azure Cloud Storage, Azure Stack Hub Storage, and s3. Currently, AzCopy can't copy data between two Azure Stack Hub Storage Accounts. Copying objects from a source Azure Stack Hub Storage account to a target Azure Stack Hub Storage account requires an intermediary local filesystem.

For more information, see the AzCopy section in the [Use data transfer tools in Azure Stack Hub Storage](./azure-stack-storage-transfer.md#azcopy) article.

### Azure Stack Hub (source)

This storage account is the source of the data you want to back up.

You need the Source Storage Account URL and SAS Token. For instructions on working with a storage account, see [Get started with Azure Stack Hub storage development tools](azure-stack-storage-dev.md).

### Azure Stack Hub (target)

This target stores the account data you want to back up. The target Azure Stack Hub instance must be in a different location from your source Azure Stack Hub. The source needs to connect to the target.

You need the Source Storage Account URL and SAS Token. For instructions on working with a storage account, see [Get started with Azure Stack Hub storage development tools](azure-stack-storage-dev.md).

### Intermediary local filesystem

You need a place to run AzCopy and store data when copying from your source and then writing to your target Azure Stack Hub. This place is an intermediate server in your source Azure Stack Hub.

You can create a Linux or Windows server as your intermediate server. The server will need to have enough space to store all of the objects in the source Storage account containers.

- For instructions on setting up a Linux Server, see [Create a Linux server VM by using the Azure Stack Hub portal](azure-stack-quick-linux-portal.md).
- For instructions on setting a Windows Server, see [Create a Windows server VM with the Azure Stack Hub portal](azure-stack-quick-windows-portal.md).

After you set up your Windows Server, install [Azure Stack Hub PowerShell](../operator/powershell-install-az-module.md?toc=/azure-stack/user/toc.json&bc=/azure-stack/breadcrumb/toc.json) and [Azure Stack Hub Tools](../operator/azure-stack-powershell-download.md?toc=/azure-stack/user/toc.json&bc=/azure-stack/breadcrumb/toc.json).

## Set up backup for storage accounts

1. Retrieve the Blob Endpoint for the source and target storage accounts.

    :::image type="content" source="./media/azure-stack-network-howto-backup-storage/back-up-step1.png" alt-text="Screenshot that shows the primary blob endpoint for the source and target storage accounts.":::

1. Create and record SAS Tokens for the source and target storage accounts.

    :::image type="content" source="./media/azure-stack-network-howto-backup-storage/back-up-step2.png" alt-text="Screenshot that shows Azure Stack Hub Storage Backup." lightbox="./media/azure-stack-network-howto-backup-storage/back-up-step2.png":::

1. Install [AzCopy](https://github.com/Azure/azure-storage-azcopy) on the intermediary server and set the API Version to account for Azure Stack Hub Storage Accounts.

    - For a Windows server:

    ```PowerShell  
    set AZCOPY_DEFAULT_SERVICE_API_VERSION=2017-11-09 PowerShell use: $env:AZCOPY_DEFAULT_SERVICE_API_VERSION="2017-11-09"
    ```

    - For a Linux (Ubuntu) server:

    ```bash  
    export AZCOPY_DEFAULT_SERVICE_API_VERSION=2017-11-09
    ```

1. On your intermediate server, create script. Update this command with your **storage account**, **SAS key**, and **local directory path**. You run the script to copy data incrementally from the **source** storage account.

    ```
    azcopy sync "https:/<storagaccount>/<container>?<SAS Key>" "C:\\myFolder" --recursive=true --delete-destination=true
    ```

1. Enter the **storage account**, **SAS key**, and **local directory path**. You use this information to copy data incrementally to the **target** storage account.
    
    ```
    azcopy sync "C:\\myFolder" "https:// <storagaccount>/<container>?<SAS Key>" --recursive=true --delete-destination=true
    ```

1. Use Cron or Task Scheduler to schedule the copy from the source Azure Stack Hub storage account to local storage on the intermediate server. Then copy from local storage in the intermediate server to the target Azure Stack Hub storage account.

    The RPO you can achieve with this solution is determined by the /MO parameter value and the network bandwidth between the source account and the intermediary server and the intermediary server and the target account.

    - For a Linux (Ubuntu) server:

    ```bash
    schtasks /CREATE /SC minute /MO 5 /TN "AzCopy Script" /TR C:\\&lt;script name>.bat
    ```

    | Parameter | Note |
    | ---- | ---- |
    | /SC | Use a minute schedule. |
    | /MO | An interval of *XX* minutes. |
    | /TN | The task name. |
    | /TR | The path to the `script.bat` file. |

    - For a Windows server:

    For information on using the Windows Task schedule, see [Task Scheduler for developers](/windows/win32/taskschd/task-scheduler-start-page).

## Use your storage account in a disaster

Each Azure Stack Hub Storage account has a unique DNS name that comes from the name of the Azure Stack Hub region. For example, `https://krsource.blob.east.asicdc.com/`. Applications that write to and read from this DNS name need to handle the storage account DNS name change when the target account is used during a disaster. For example, the target account might be `https://krtarget.blob.west.asicdc.com/`.

You can change application connection strings after a disaster is declared to account for the relocation of the objects. If you use a CNAME record in front of an Azure Load Balancer that fronts the source and target storage accounts, you can configure the Load Balancer with a manual failover algorithm that you can use to declare the target.

If SAS is used by the application rather than Microsoft Entra ID or AD FS, the above method will not work and application connection strings will need to be updated with the target storage account URL and the SAS key(s) generated for the target storage account.

## Next steps

[Get started with Azure Stack Hub storage development tools](azure-stack-storage-dev.md)
