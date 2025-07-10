---
title: Use data transfer tools in Azure Stack Hub Storage 
description: Learn about Azure Stack Hub Storage data transfer tools.
author: sethmanheim

ms.topic: how-to
ms.custom:
  - devx-track-azurepowershell
  - devx-track-azurecli
ms.date: 01/14/2025
ms.author: sethm
ms.reviewer: xiaofmao
ms.lastreviewed: 11/22/2020

# Intent: As an Azure Stack user, I want to learn about data transfer tools for Azure Stack Storage so I can transfer data to and from Azure Stack.
# Keyword: Azure stack storage data transfer
---

# Use data transfer tools in Azure Stack Hub Storage

Azure Stack Hub provides a set of storage services for disks, blobs, tables, queues, and account management functions. Some Azure Storage tools are available if you want to manage or move data to or from Azure Stack Hub Storage. This article provides an overview of the available tools.

Your requirements determine which of the following tools works best for you:

- **AzCopy**: A storage-specific, command-line utility that you can download to copy data from one object to another object within or between your storage accounts.
- **Azure PowerShell**: A task-based, command-line shell and scripting language designed especially for system administration.
- **Azure CLI**: An open-source, cross-platform tool that provides a set of commands for working with the Azure and Azure Stack Hub platforms.
- **Microsoft Azure Storage Explorer**: An easy-to-use stand-alone app with a user interface.
- **Blobfuse**: A virtual file system driver for Azure Blob Storage, which allows you to access your existing block blob data in your storage account through the Linux file system.

Because of storage services differences between Azure and Azure Stack Hub, there might be some specific requirements for each tool described in the following sections. For a comparison between Azure Stack Hub Storage and Azure Storage, see [Azure Stack Hub Storage: Differences and considerations](azure-stack-acs-differences.md).

## AzCopy

AzCopy is a command-line utility designed to copy data to and from Microsoft Azure blob and table storage using simple commands with optimal performance. You can copy data from one object to another within or between your storage accounts.

### Download and install AzCopy

[Download AzCopy V10+](/azure/storage/common/storage-use-azcopy-v10#download-azcopy).

### AzCopy 10.1 configuration and limits

AzCopy 10.1 is now able to be configured to use older API versions. This enables (limited) support for Azure Stack Hub.
To configure the API version for AzCopy to support Azure Stack Hub, set the `AZCOPY_DEFAULT_SERVICE_API_VERSION` environment variable to `2017-11-09`.

| Operating system | Command  |
|--------|-----------|
| **Windows** | In a command prompt use: `set AZCOPY_DEFAULT_SERVICE_API_VERSION=2017-11-09`<br> In PowerShell use: `$env:AZCOPY_DEFAULT_SERVICE_API_VERSION="2017-11-09"`|
| **Linux** | `export AZCOPY_DEFAULT_SERVICE_API_VERSION=2017-11-09` |
| **MacOS** | `export AZCOPY_DEFAULT_SERVICE_API_VERSION=2017-11-09` |

In AzCopy 10.1, the following features are supported for Azure Stack Hub:

| Feature | Supported actions |
| --- | --- |
|Manage container|Create a container<br>List contents of containers
|Manage job|Display jobs<br>Resume a job
|Remove blob|Remove a single blob<br>Remove entire or partial virtual directory
|Upload file|Upload a file<br>Upload a directory<br>Upload the contents of a directory
|Download file|Download a file<br>Download a directory<br>Download the contents of a directory
|Synchronize file|Synchronize a container to a local file system<br>Synchronize a local file system to a container

> [!NOTE]
> Azure Stack Hub doesn't support providing authorization credentials to AzCopy by using Microsoft Entra ID. You must access storage objects on Azure Stack Hub using a Shared Access Signature (SAS) token.
> Azure Stack Hub doesn't support synchronous data transfer between two Azure Stack Hub blob locations, and between Azure Storage and Azure Stack Hub. You can't use `azcopy cp` to move data from Azure Stack Hub to Azure Storage (or the other way around) directly with AzCopy 10.1.

### AzCopy command examples for data transfer

The following examples follow typical scenarios for copying data to and from Azure Stack Hub blobs. To learn more, see [Get started with AzCopy](/azure/storage/common/storage-use-azcopy-v10).

### Download all blobs to a local disk

```azurecli
azcopy cp "https://[account].blob.core.windows.net/[container]/[path/to/directory]?[SAS]" "/path/to/dir" --recursive=true
```

### Upload single file to virtual directory

```azurecli
azcopy cp "/path/to/file.txt" "https://[account].blob.core.windows.net/[container]/[path/to/blob]?[SAS]"
```

### AzCopy known issues

- Any AzCopy operation on a file storage isn't available because file storage isn't yet available in Azure Stack Hub.
- If you want to transfer data between two Azure Stack Hub blob locations, or between Azure Stack Hub and Azure Storage by using AzCopy 10.1, download the data to a local location first, and then upload again to the target directory on Azure Stack Hub or Azure Storage.
- The Linux version of AzCopy only supports the 1802 update or later versions; it doesn't support Table service.
- If you want to copy data to and from your Azure Table Storage service, you can use PowerShell, CLI, or the Azure client libraries.

## Azure PowerShell

Azure PowerShell is a module that provides cmdlets for managing services on both Azure and Azure Stack Hub. It's a task-based, command-line shell and scripting language designed especially for system administration.

### Install and Configure PowerShell for Azure Stack Hub

Azure Stack Hub compatible Azure PowerShell modules are required to work with Azure Stack Hub. For more information, see [Install PowerShell for Azure Stack Hub](../operator/powershell-install-az-module.md) and [Configure the Azure Stack Hub user's PowerShell environment](azure-stack-powershell-configure-user.md).

### PowerShell Sample script for Azure Stack Hub 
### [Az modules](#tab/az1)

This sample assumes you have successfully [Installed PowerShell for Azure Stack Hub](../operator/powershell-install-az-module.md). This script will help you complete the configuration and ask your Azure Stack Hub tenant credentials to add your account to the local PowerShell environment. The script will then set the default Azure subscription, create a new storage account in Azure, create a new container in this new storage account, and upload an existing image file (blob) to that container. After the script lists all blobs in that container, it will create a new destination directory on your local computer and download the image file.

1. Install [Azure Stack Hub-compatible Azure PowerShell modules](../operator/powershell-install-az-module.md).
2. Download the [tools required to work with Azure Stack Hub](../operator/azure-stack-powershell-download.md).
3. Open **Windows PowerShell ISE** and **Run as Administrator**, then click **File** > **New** to create a new script file.
4. Copy the script below and paste it to the new script file.
5. Update the script variables based on your configuration settings.
   > [!NOTE]
   > This script has to be run at the root directory for **AzureStack_Tools**.

```powershell  
# begin

$ARMEvnName = "AzureStackUser" # set AzureStackUser as your Azure Stack Hub environment name
$ARMEndPoint = "https://management.local.azurestack.external" 
$GraphAudience = "https://graph.windows.net/" 
$AADTenantName = "<myDirectoryTenantName>.onmicrosoft.com" 

$SubscriptionName = "basic" # Update with the name of your subscription.
$ResourceGroupName = "myTestRG" # Give a name to your new resource group.
$StorageAccountName = "azsblobcontainer" # Give a name to your new storage account. It must be lowercase.
$Location = "Local" # Choose "Local" as an example.
$ContainerName = "photo" # Give a name to your new container.
$ImageToUpload = "C:\temp\Hello.jpg" # Prepare an image file and a source directory in your local computer.
$DestinationFolder = "C:\temp\download" # A destination directory in your local computer.

# Import the Connect PowerShell module"
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
Import-Module .\Connect\AzureStack.Connect.psm1

# Configure the PowerShell environment
# Register an Az environment that targets your Azure Stack Hub instance
Add-AzEnvironment -Name $ARMEvnName -ARMEndpoint $ARMEndPoint 

# Login
$TenantID = Get-AzsDirectoryTenantId -AADTenantName $AADTenantName -EnvironmentName $ARMEvnName
Connect-AzAccount -EnvironmentName $ARMEvnName -TenantId $TenantID 

# Set a default Azure subscription.
Select-AzSubscription -SubscriptionName $SubscriptionName

# Create a new Resource Group 
New-AzResourceGroup -Name $ResourceGroupName -Location $Location

# Create a new storage account.
New-AzStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageAccountName -Location $Location -Type Standard_LRS

# Set a default storage account.
Set-AzCurrentStorageAccount -StorageAccountName $StorageAccountName -ResourceGroupName $ResourceGroupName 

# Create a new container.
New-AzStorageContainer -Name $ContainerName -Permission Off

# Upload a blob into a container.
Set-AzStorageBlobContent -Container $ContainerName -File $ImageToUpload

# List all blobs in a container.
Get-AzStorageBlob -Container $ContainerName

# Download blobs from the container:
# Get a reference to a list of all blobs in a container.
$blobs = Get-AzStorageBlob -Container $ContainerName

# Create the destination directory.
New-Item -Path $DestinationFolder -ItemType Directory -Force  

# Download blobs into the local destination directory.
$blobs | Get-AzureStorageBlobContent -Destination $DestinationFolder

# end
```

### [AzureRM modules](#tab/azurerm1)

This sample assumes you have successfully [Installed PowerShell for Azure Stack Hub](../operator/azure-stack-powershell-install.md). This script will help you complete the configuration and ask your Azure Stack Hub tenant credentials to add your account to the local PowerShell environment. The script will then set the default Azure subscription, create a new storage account in Azure, create a new container in this new storage account, and upload an existing image file (blob) to that container. After the script lists all blobs in that container, it will create a new destination directory on your local computer and download the image file.

1. Install [Azure Stack Hub-compatible Azure PowerShell modules](../operator/azure-stack-powershell-install.md).
2. Download the [tools required to work with Azure Stack Hub](../operator/azure-stack-powershell-download.md).
3. Open **Windows PowerShell ISE** and **Run as Administrator**, then click **File** > **New** to create a new script file.
4. Copy the script below and paste it to the new script file.
5. Update the script variables based on your configuration settings.
   > [!NOTE]
   > This script has to be run at the root directory for **AzureStack_Tools**.

```powershell  
# begin

$ARMEvnName = "AzureStackUser" # set AzureStackUser as your Azure Stack Hub environment name
$ARMEndPoint = "https://management.local.azurestack.external" 
$GraphAudience = "https://graph.windows.net/" 
$AADTenantName = "<myDirectoryTenantName>.onmicrosoft.com" 

$SubscriptionName = "basic" # Update with the name of your subscription.
$ResourceGroupName = "myTestRG" # Give a name to your new resource group.
$StorageAccountName = "azsblobcontainer" # Give a name to your new storage account. It must be lowercase.
$Location = "Local" # Choose "Local" as an example.
$ContainerName = "photo" # Give a name to your new container.
$ImageToUpload = "C:\temp\Hello.jpg" # Prepare an image file and a source directory in your local computer.
$DestinationFolder = "C:\temp\download" # A destination directory in your local computer.

# Import the Connect PowerShell module"
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
Import-Module .\Connect\AzureStack.Connect.psm1

# Configure the PowerShell environment
# Register an AzureRM environment that targets your Azure Stack Hub instance
Add-AzureRMEnvironment -Name $ARMEvnName -ARMEndpoint $ARMEndPoint 

# Login
$TenantID = Get-AzsDirectoryTenantId -AADTenantName $AADTenantName -EnvironmentName $ARMEvnName
Add-AzureRMAccount -EnvironmentName $ARMEvnName -TenantId $TenantID 

# Set a default Azure subscription.
Select-AzureRMSubscription -SubscriptionName $SubscriptionName

# Create a new Resource Group 
New-AzureRMResourceGroup -Name $ResourceGroupName -Location $Location

# Create a new storage account.
New-AzureRMStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageAccountName -Location $Location -Type Standard_LRS

# Set a default storage account.
Set-AzureRMCurrentStorageAccount -StorageAccountName $StorageAccountName -ResourceGroupName $ResourceGroupName 

# Create a new container.
New-AzureContainer -Name $ContainerName -Permission Off

# Upload a blob into a container.
Set-AzureBlobContent -Container $ContainerName -File $ImageToUpload

# List all blobs in a container.
Get-AzureBlob -Container $ContainerName

# Download blobs from the container:
# Get a reference to a list of all blobs in a container.
$blobs = Get-AzureStorageBlob -Container $ContainerName

# Create the destination directory.
New-Item -Path $DestinationFolder -ItemType Directory -Force  

# Download blobs into the local destination directory.
$blobs | Get-AzureStorageBlobContent -Destination $DestinationFolder

# end
```

---

### PowerShell known issues

#### Get-AzStorageAccountKey difference

The current compatible Azure PowerShell module version for Azure Stack Hub is 1.2.11 for the user operations. It's different from the latest version of Azure PowerShell. This difference impacts storage services operation in the following way:

The return value format of `Get-AzStorageAccountKey` in version 1.2.11 has two properties: `Key1` and `Key2`, while the current Azure version returns an array containing all the account keys.

```powershell
# This command gets a specific key for a storage account, 
# and works for Azure PowerShell version 1.4, and later versions.
(Get-AzStorageAccountKey -ResourceGroupName "RG01" `
-AccountName "MyStorageAccount").Value[0]

# This command gets a specific key for a storage account, 
# and works for Azure PowerShell version 1.3.2, and previous versions.
(Get-AzStorageAccountKey -ResourceGroupName "RG01" `
-AccountName "MyStorageAccount").Key1
```

For more information, see [Get-AzureRMStorageAccountKey](/powershell/module/Az.storage/Get-AzStorageAccountKey).

#### Copy blob between Azure Stack Hub clusters

`Start-AzStorageBlobCopy` can be used to start a copy job to move a blob. When setting the property `AbsoluteUri` as the blob uri on another Azure Stack Hub cluster, this cmdlet can be used to copy blob between two Azure Stack Hub clusters. Make sure the source and destination Azure Stack Hub clusters are on the same update version. Azure Stack Hub currently doesn't support using `Start-AzStorageBlobCopy` to copy blob between two Azure Stack Hub clusters which have deployed different update versions.

## Azure CLI

The Azure CLI is Azure's command-line experience for managing Azure resources. You can install it on macOS, Linux, and Windows and run it from the command line.

Azure CLI is optimized for managing and administering Azure resources from the command line, and for building automation scripts that work against the Azure Resource Manager. It provides many of the same functions found in the Azure Stack Hub portal, including rich data access.

Azure Stack Hub requires Azure CLI version 2.0 or later. For more information about installing and configuring Azure CLI with Azure Stack Hub, see [Install and configure Azure Stack Hub CLI](azure-stack-version-profiles-azurecli2.md). For more information about how to use the Azure CLI to perform several tasks working with resources in your Azure Stack Hub storage account, see [Using the Azure CLI with Azure storage](/azure/storage/storage-azure-cli).

### Azure CLI sample script for Azure Stack Hub

Once you complete the CLI installation and configuration, you can try the following steps to work with a small shell sample script to interact with Azure Stack Hub storage resources. The script completes the following actions:

- Creates a new container in your storage account.
- Uploads an existing file (as a blob) to the container.
- Lists all blobs in the container.
- Downloads the file to a destination on your local computer that you specify.

Before you run this script, make sure that you can successfully connect and sign in to the target Azure Stack Hub.

1. Open your favorite text editor, then copy and paste the preceding script into the editor.
2. Update the script's variables to reflect your configuration settings.
3. After you've updated the necessary variables, save the script, and exit your editor. The next steps assume you've named your script **my_storage_sample.sh**.
4. Mark the script as executable, if necessary: `chmod +x my_storage_sample.sh`
5. Execute the script. For example, in Bash: `./my_storage_sample.sh`

```azurecli
#!/bin/bash
# A simple Azure Stack Hub storage example script

export AZURESTACK_RESOURCE_GROUP=<resource_group_name>
export AZURESTACK_RG_LOCATION="local"
export AZURESTACK_STORAGE_ACCOUNT_NAME=<storage_account_name>
export AZURESTACK_STORAGE_CONTAINER_NAME=<container_name>
export AZURESTACK_STORAGE_BLOB_NAME=<blob_name>
export FILE_TO_UPLOAD=<file_to_upload>
export DESTINATION_FILE=<destination_file>

echo "Creating the resource group..."
az group create --name $AZURESTACK_RESOURCE_GROUP --location $AZURESTACK_RG_LOCATION

echo "Creating the storage account..."
az storage account create --name $AZURESTACK_STORAGE_ACCOUNT_NAME --resource-group $AZURESTACK_RESOURCE_GROUP --account-type Standard_LRS

echo "Creating the blob container..."
az storage container create --name $AZURESTACK_STORAGE_CONTAINER_NAME --account-name $AZURESTACK_STORAGE_ACCOUNT_NAME

echo "Uploading the file..."
az storage blob upload --container-name $AZURESTACK_STORAGE_CONTAINER_NAME --file $FILE_TO_UPLOAD --name $AZURESTACK_STORAGE_BLOB_NAME --account-name $AZURESTACK_STORAGE_ACCOUNT_NAME

echo "Listing the blobs..."
az storage blob list --container-name $AZURESTACK_STORAGE_CONTAINER_NAME --account-name $AZURESTACK_STORAGE_ACCOUNT_NAME --output table

echo "Downloading the file..."
az storage blob download --container-name $AZURESTACK_STORAGE_CONTAINER_NAME --account-name $AZURESTACK_STORAGE_ACCOUNT_NAME --name $AZURESTACK_STORAGE_BLOB_NAME --file $DESTINATION_FILE --output table

echo "Done"
```

## Microsoft Azure Storage Explorer

Azure Storage Explorer is a standalone app from Microsoft. It allows you to easily work with both Azure Storage and Azure Stack Hub Storage data on Windows, macOS, and Linux computers. If you want an easy way to manage your Azure Stack Hub Storage data, then consider using Microsoft Azure Storage Explorer.

- For more information about configuring Azure Storage Explorer to work with Azure Stack Hub, see [Connect Storage Explorer to an Azure Stack Hub subscription](azure-stack-storage-connect-se.md).
- For more information about Microsoft Azure Storage Explorer, see [Get started with storage explorer](/azure/vs-azure-tools-storage-manage-with-storage-explorer).

## Blobfuse 

[Blobfuse](https://github.com/Azure/azure-storage-fuse) is a virtual file system driver for Azure Blob Storage, which allows you to access your existing block blob data in your storage account through the Linux file system. Azure Blob Storage is an object storage service and therefore doesn't have a hierarchical namespace. Blobfuse provides this namespace using the virtual directory scheme with the use of forward-slash `/` as a delimiter. Blobfuse works on both Azure and Azure Stack Hub. 

To learn more about mounting blob storage as a file system with Blobfuse on Linux, see [How to mount Blob storage as a file system with Blobfuse](/azure/storage/blobs/storage-how-to-mount-container-linux).

For Azure Stack Hub, *blobEndpoint* needs to be specified while configuring your storage account credentials along with accountName, accountKey/sasToken, and containerName.

In the Azure Stack Development Kit (ASDK), the *blobEndpoint* should be `myaccount.blob.local.azurestack.external`. In Azure Stack Hub integrated system, contact your cloud admin if you're not sure about your endpoint.

*accountKey* and *sasToken* can only be configured one at a time. When a storage account key is given, the credentials configuration file is in the following format:

```output
accountName myaccount 
accountKey myaccesskey== 
containerName mycontainer 
blobEndpoint myaccount.blob.local.azurestack.external
```

When a shared access token is given, the credentials configuration file is in the following format:

``` output
accountName myaccount 
sasToken ?mysastoken 
containerName mycontainer 
blobEndpoint myaccount.blob.local.azurestack.external
```

## Next steps

* [Connect storage explorer to an Azure Stack Hub subscription](azure-stack-storage-connect-se.md)
* [Get started with Storage Explorer](/azure/vs-azure-tools-storage-manage-with-storage-explorer)
* [Azure-consistent storage: differences and considerations](azure-stack-acs-differences.md)
* [Introduction to Microsoft Azure storage](/azure/storage/common/storage-introduction)
