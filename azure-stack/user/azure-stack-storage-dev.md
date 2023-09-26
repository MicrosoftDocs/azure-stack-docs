---
title: Learn Azure Stack Hub storage development tools  
description: Guidance to get started with using Azure Stack Hub storage development tools 
author: sethmanheim
ms.author: sethm
ms.date: 2/1/2021
ms.topic: conceptual
ms.reviewer: jiahan
ms.lastreviewed: 08/12/2020

# Intent: As an Azure Stack user, I want to get started with Azure Stack storage dev tools.
# Keyword: azure stack storage development

---


# Get started with Azure Stack Hub storage development tools

Microsoft Azure Stack Hub provides a set of storage services that includes blob, table, and queue storage.

Use this article as a guide to get started using Azure Stack Hub storage development tools. You can find more detailed information and sample code in corresponding Azure storage tutorials.

> [!NOTE]  
> There are differences between Azure Stack Hub storage and Azure storage, including specific requirements for each platform. For example, there are specific client libraries and endpoint suffix requirements for Azure Stack Hub. For more information, see [Azure Stack Hub storage: Differences and considerations](azure-stack-acs-differences.md).

## Azure client libraries

For the storage client libraries, be aware of the version that is compatible with the REST API. You must also specify the Azure Stack Hub endpoint in your code.

::: moniker range=">=azs-2301"
### 2301 update and newer

| Client library | Azure Stack Hub supported version | Link | Endpoint specification |
|----------------|-------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------|
| .NET | Common: 12.9.0<br>Blob: 12.10.0<br>Queue: 12.8.0 | NuGet package:<br>Common: <https://www.nuget.org/packages/Azure.Storage.common/12.9.0><br>Blob: <https://www.nuget.org/packages/Azure.Storage.Blobs/12.10.0><br>Queue: <https://www.nuget.org/packages/Azure.Storage.queues/12.8.0><br> <br>GitHub release:<br>Common: <https://github.com/Azure/azure-sdk-for-net/tree/Azure.Storage.Common_12.9.0/sdk/storage/Azure.Storage.Common><br>Blob: <https://github.com/Azure/azure-sdk-for-net/tree/Azure.Storage.Blobs_12.10.0/sdk/storage/Azure.Storage.Blobs><br>Queue: <https://github.com/Azure/azure-sdk-for-net/tree/Azure.Storage.Queues_12.8.0/sdk/storage/Azure.Storage.Queues>  | app.config file |
| Java | Common: 12.12.0<br>Blob: 12.14.3<br>Queue: 12.11.3 | Maven package:<br>Common: <https://mvnrepository.com/artifact/com.azure/azure-storage-common/12.12.0><br>Blob: <https://mvnrepository.com/artifact/com.azure/azure-storage-blob/12.14.3><br>Queue: <https://mvnrepository.com/artifact/com.azure/azure-storage-queue/12.11.3><br> <br>GitHub release:<br>Common: <https://github.com/Azure/azure-sdk-for-java/tree/azure-storage-common_12.12.0/sdk/storage/azure-storage-common><br>Blob: <https://github.com/Azure/azure-sdk-for-java/tree/azure-storage-blob_12.14.3/sdk/storage/azure-storage-blob><br>Queue: <https://github.com/Azure/azure-sdk-for-java/tree/azure-storage-queue_12.11.3/sdk/storage/azure-storage-queue> | Connection string setup |
| Node.js | 2.8.3 | NPM link:<br><https://www.npmjs.com/package/azure-storage><br>(Run: `npm install azure-storage@2.8.3`)<br> <br>GitHub release:<br><https://github.com/Azure/azure-storage-node/releases/tag/v2.8.3> | Service instance declaration |
| C++ | Blob: 12.2.0<br>Queue: 12.0.0 | GitHub release:<br>Blob: <https://github.com/Azure/azure-sdk-for-cpp/tree/azure-storage-blobs_12.2.0><br>Queue: <https://github.com/Azure/azure-sdk-for-cpp/tree/azure-storage-queues_12.0.0> | Connection string setup |
| PHP | 1.2.0 | GitHub release:<br>Common: <https://github.com/Azure/azure-storage-php/releases/tag/v1.2.0-common><br>Blob: <https://github.com/Azure/azure-storage-php/releases/tag/v1.2.0-blob><br>Queue:<br><https://github.com/Azure/azure-storage-php/releases/tag/v1.1.1-queue><br>Table: <https://github.com/Azure/azure-storage-php/releases/tag/v1.1.0-table><br> <br>Install via Composer (To learn more, [see the details below](#install-php-client-via-composer---current).) | Connection string setup |
| Python | Blob: 12.9.0<br>Queue: 12.1.6 | GitHub release:<br>Blob:<br><https://github.com/Azure/azure-sdk-for-python/tree/azure-storage-blob_12.9.0/sdk/storage/azure-storage-blob><br>Queue:<br><https://github.com/Azure/azure-sdk-for-python/tree/azure-storage-queue_12.1.6/sdk/storage/azure-storage-queue> | Service instance declaration |
| Ruby | 1.0.1 | RubyGems package:<br>Common:<br><https://rubygems.org/gems/azure-storage-common/versions/1.0.1><br>Blob: <https://rubygems.org/gems/azure-storage-blob/versions/1.0.1><br>Queue: <https://rubygems.org/gems/azure-storage-queue/versions/1.0.1><br>Table: <https://rubygems.org/gems/azure-storage-table/versions/1.0.1><br> <br>GitHub release:<br>Common: <https://github.com/Azure/azure-storage-ruby/releases/tag/v1.0.1-common><br>Blob: <https://github.com/Azure/azure-storage-ruby/releases/tag/v1.0.1-blob><br>Queue: <https://github.com/Azure/azure-storage-ruby/releases/tag/v1.0.1-queue><br>Table: <https://github.com/Azure/azure-storage-ruby/releases/tag/v1.0.1-table> | Connection string setup |

> [!NOTE]
> There is a high severity vulnerability in old version of .NET and Java client library, because of the dependencies on a vulnerable version of Jackson package. It is strongly suggested to use the latest supported version of .NET and Java client library to avoid security issue.

#### Install PHP client via Composer - current

To install via Composer: (take the blob as an example).

1. Create a file named **composer.json** in the root of the project with following code:

    ```json
    {
      "require": {
      "Microsoft/azure-storage-blob":"1.2.0"
      }
    }
    ```

2. Download [composer.phar](https://getcomposer.org/composer.phar) to the project root.
3. Run: `php composer.phar install`.

### Specify API version
To use the new **.NET** client library (**Common: v12.9.0 / Blob: v12.10.0 / Queue: v12.8.0**) and **Java** client library (**Common: v12.12.0 / Blob: v12.13.0 / Queue: v12.10.0**), you must explicitly specify the serviceVersion in each client class (including *BlobServiceClient*, *BlobContainerClient*, *BlobClient*, *QueueServiceClient*, and *QueueClient*), because the default version in the client class is not currently supported by Azure Stack Hub.
#### Examples

##### .NET
```.net
BlobClientOptions options = new BlobClientOptions(BlobClientOptions.ServiceVersion.V2019_07_07);
BlobServiceClient client = new BlobServiceClient("<connection_string>", options);
```

##### Java
```java
BlobServiceVersion version = BlobServiceVersion.V2019_07_07; 
BlobServiceClient blobServiceClient = new BlobServiceClientBuilder()
    .endpoint("<your_endpoint>")
    .sasToken("<your_SAS_token>")
    .serviceVersion(version)
    .buildClient();

```
::: moniker-end

::: moniker range=">=azs-2008 <azs-2301"
### 2008 update and newer

| Client library | Azure Stack Hub supported version | Link | Endpoint specification |
|----------------|-------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------|
| .NET | Common: 12.9.0<br>Blob: 12.10.0<br>Queue: 12.8.0 | NuGet package:<br>Common: <https://www.nuget.org/packages/Azure.Storage.common/12.9.0><br>Blob: <https://www.nuget.org/packages/Azure.Storage.Blobs/12.10.0><br>Queue: <https://www.nuget.org/packages/Azure.Storage.queues/12.8.0><br> <br>GitHub release:<br>Common: <https://github.com/Azure/azure-sdk-for-net/tree/Azure.Storage.Common_12.9.0/sdk/storage/Azure.Storage.Common><br>Blob: <https://github.com/Azure/azure-sdk-for-net/tree/Azure.Storage.Blobs_12.10.0/sdk/storage/Azure.Storage.Blobs><br>Queue: <https://github.com/Azure/azure-sdk-for-net/tree/Azure.Storage.Queues_12.8.0/sdk/storage/Azure.Storage.Queues>  | app.config file |
| Java | Common: 12.12.0<br>Blob: 12.13.0<br>Queue: 12.10.0 | Maven package:<br>Common: <https://mvnrepository.com/artifact/com.azure/azure-storage-common/12.12.0><br>Blob: <https://mvnrepository.com/artifact/com.azure/azure-storage-blob/12.13.0><br>Queue: <https://mvnrepository.com/artifact/com.azure/azure-storage-queue/12.10.0><br> <br>GitHub release:<br>Common: <https://github.com/Azure/azure-sdk-for-java/tree/azure-storage-common_12.12.0/sdk/storage/azure-storage-common><br>Blob: <https://github.com/Azure/azure-sdk-for-java/tree/azure-storage-blob_12.13.0/sdk/storage/azure-storage-blob><br>Queue: <https://github.com/Azure/azure-sdk-for-java/tree/azure-storage-queue_12.10.0/sdk/storage/azure-storage-queue> | Connection string setup |
| Node.js | 2.8.3 | NPM link:<br><https://www.npmjs.com/package/azure-storage><br>(Run: `npm install azure-storage@2.8.3`)<br> <br>GitHub release:<br><https://github.com/Azure/azure-storage-node/releases/tag/v2.8.3> | Service instance declaration |
| C++ | 7.2.0 | GitHub release:<br><https://github.com/Azure/azure-storage-cpp/releases/tag/v7.2.0> | Connection string setup |
| PHP | 1.2.0 | GitHub release:<br>Common: <https://github.com/Azure/azure-storage-php/releases/tag/v1.2.0-common><br>Blob: <https://github.com/Azure/azure-storage-php/releases/tag/v1.2.0-blob><br>Queue:<br><https://github.com/Azure/azure-storage-php/releases/tag/v1.1.1-queue><br>Table: <https://github.com/Azure/azure-storage-php/releases/tag/v1.1.0-table><br> <br>Install via Composer (To learn more, [see the details below](#install-php-client-via-composer---current).) | Connection string setup |
| Python | Blob: 12.3.1<br>Queue: 12.1.6 | GitHub release:<br>Blob:<br><https://github.com/Azure/azure-sdk-for-python/tree/azure-storage-blob_12.3.1/sdk/storage/azure-storage-blob><br>Queue:<br><https://github.com/Azure/azure-sdk-for-python/tree/azure-storage-queue_12.1.6/sdk/storage/azure-storage-queue> | Service instance declaration |
| Ruby | 1.0.1 | RubyGems package:<br>Common:<br><https://rubygems.org/gems/azure-storage-common/versions/1.0.1><br>Blob: <https://rubygems.org/gems/azure-storage-blob/versions/1.0.1><br>Queue: <https://rubygems.org/gems/azure-storage-queue/versions/1.0.1><br>Table: <https://rubygems.org/gems/azure-storage-table/versions/1.0.1><br> <br>GitHub release:<br>Common: <https://github.com/Azure/azure-storage-ruby/releases/tag/v1.0.1-common><br>Blob: <https://github.com/Azure/azure-storage-ruby/releases/tag/v1.0.1-blob><br>Queue: <https://github.com/Azure/azure-storage-ruby/releases/tag/v1.0.1-queue><br>Table: <https://github.com/Azure/azure-storage-ruby/releases/tag/v1.0.1-table> | Connection string setup |

> [!NOTE]
> There is a high severity vulnerability in old version of .NET and Java client library, because of the dependencies on a vulnerable version of Jackson package. It is strongly suggested to use the latest supported version of .NET and Java client library to avoid security issue.

#### Install PHP client via Composer - current

To install via Composer: (take the blob as an example).

1. Create a file named **composer.json** in the root of the project with following code:

    ```json
    {
      "require": {
      "Microsoft/azure-storage-blob":"1.2.0"
      }
    }
    ```

2. Download [composer.phar](https://getcomposer.org/composer.phar) to the project root.
3. Run: `php composer.phar install`.

### Specify API version
To use the new **.NET** client library (**Common: v12.9.0 / Blob: v12.10.0 / Queue: v12.8.0**) and **Java** client library (**Common: v12.12.0 / Blob: v12.13.0 / Queue: v12.10.0**), you must explicitly specify the serviceVersion in each client class (including *BlobServiceClient*, *BlobContainerClient*, *BlobClient*, *QueueServiceClient*, and *QueueClient*), because the default version in the client class is not currently supported by Azure Stack Hub.
#### Examples

##### .NET
```.net
BlobClientOptions options = new BlobClientOptions(BlobClientOptions.ServiceVersion.V2019_07_07);
BlobServiceClient client = new BlobServiceClient("<connection_string>", options);
```

##### Java
```java
BlobServiceVersion version = BlobServiceVersion.V2019_07_07; 
BlobServiceClient blobServiceClient = new BlobServiceClientBuilder()
    .endpoint("<your_endpoint>")
    .sasToken("<your_SAS_token>")
    .serviceVersion(version)
    .buildClient();

```
::: moniker-end

::: moniker range=">=azs-2005 <azs-2008"
### 2005 update

| Client library | Azure Stack Hub supported version | Link | Endpoint specification |
|----------------|-------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------|
| .NET | 11.0.0 | NuGet package:<br>Common: <https://www.nuget.org/packages/Microsoft.Azure.Storage.Common/11.0.0><br>Blob: <https://www.nuget.org/packages/Microsoft.Azure.Storage.Blob/11.0.0><br>Queue:<br><https://www.nuget.org/packages/Microsoft.Azure.Storage.Queue/11.0.0><br> <br>GitHub release:<br><https://github.com/Azure/azure-storage-net/releases/tag/v11.0.0> | app.config file |
| Java | 12.0.0-preview.3 | Maven package:<br><https://mvnrepository.com/artifact/com.azure/azure-storage-blob/12.0.0-preview.3><br> <br>GitHub release:<br><https://github.com/Azure/azure-sdk-for-java/tree/master/sdk/storage> | Connection string setup |
| Node.js | 2.8.3 | NPM link:<br><https://www.npmjs.com/package/azure-storage><br>(Run: `npm install azure-storage@2.8.3`)<br> <br>GitHub release:<br><https://github.com/Azure/azure-storage-node/releases/tag/v2.8.3> | Service instance declaration |
| C++ | 7.1.0 | GitHub release:<br><https://github.com/Azure/azure-storage-cpp/releases/tag/v7.1.0> | Connection string setup |
| PHP | 1.2.0 | GitHub release:<br>Common: <https://github.com/Azure/azure-storage-php/releases/tag/v1.2.0-common><br>Blob: <https://github.com/Azure/azure-storage-php/releases/tag/v1.2.0-blob><br>Queue:<br><https://github.com/Azure/azure-storage-php/releases/tag/v1.1.1-queue><br>Table: <https://github.com/Azure/azure-storage-php/releases/tag/v1.1.0-table><br> <br>Install via Composer (To learn more, [see the details below](#install-php-client-via-composer---current).) | Connection string setup |
| Python | 2.1.0 | GitHub release:<br>Common:<br><https://github.com/Azure/azure-storage-python/releases/tag/v2.1.0-common><br>Blob:<br><https://github.com/Azure/azure-storage-python/releases/tag/v2.1.0-blob><br>Queue:<br><https://github.com/Azure/azure-storage-python/releases/tag/v2.1.0-queue> | Service instance declaration |
| Ruby | 1.0.1 | RubyGems package:<br>Common:<br><https://rubygems.org/gems/azure-storage-common/versions/1.0.1><br>Blob: <https://rubygems.org/gems/azure-storage-blob/versions/1.0.1><br>Queue: <https://rubygems.org/gems/azure-storage-queue/versions/1.0.1><br>Table: <https://rubygems.org/gems/azure-storage-table/versions/1.0.1><br> <br>GitHub release:<br>Common: <https://github.com/Azure/azure-storage-ruby/releases/tag/v1.0.1-common><br>Blob: <https://github.com/Azure/azure-storage-ruby/releases/tag/v1.0.1-blob><br>Queue: <https://github.com/Azure/azure-storage-ruby/releases/tag/v1.0.1-queue><br>Table: <https://github.com/Azure/azure-storage-ruby/releases/tag/v1.0.1-table> | Connection string setup |

#### Install PHP client via Composer - current

To install via Composer: (take the blob as an example).

1. Create a file named **composer.json** in the root of the project with following code:

    ```json
    {
      "require": {
      "Microsoft/azure-storage-blob":"1.2.0"
      }
    }
    ```

2. Download [composer.phar](https://getcomposer.org/composer.phar) to the project root.
3. Run: `php composer.phar install`.
::: moniker-end
## Endpoint declaration

An Azure Stack Hub endpoint includes two parts: the name of a region and the Azure Stack Hub domain.
In the Azure Stack Development Kit, the default endpoint is **local.azurestack.external**.
Contact your cloud admin if you're not sure about your endpoint.

## Examples

### .NET

For Azure Stack Hub, the endpoint suffix is specified in the app.config file:

```xml
<add key="StorageConnectionString"
value="DefaultEndpointsProtocol=https;AccountName=myaccount;AccountKey=mykey;
EndpointSuffix=local.azurestack.external;" />
```

### Java

For Azure Stack Hub, the endpoint suffix is specified in the setup of connection string:

```java
public static final String storageConnectionString =
    "DefaultEndpointsProtocol=http;" +
    "AccountName=your_storage_account;" +
    "AccountKey=your_storage_account_key;" +
    "EndpointSuffix=local.azurestack.external";
```

### Node.js

For Azure Stack Hub, the endpoint suffix is specified in the declaration instance:

```nodejs
var blobSvc = azure.createBlobService('myaccount', 'mykey',
'myaccount.blob.local.azurestack.external');
```

### C++

For Azure Stack Hub, the endpoint suffix is specified in the setup of connection string:

```cpp
const utility::string_t storage_connection_string(U("DefaultEndpointsProtocol=https;
AccountName=your_storage_account;
AccountKey=your_storage_account_key;
EndpointSuffix=local.azurestack.external"));
```

### PHP

For Azure Stack Hub, the endpoint suffix is specified in the setup of connection string:

```php
$connectionString = 'BlobEndpoint=https://<storage account name>.blob.local.azurestack.external/;
QueueEndpoint=https:// <storage account name>.queue.local.azurestack.external/;
TableEndpoint=https:// <storage account name>.table.local.azurestack.external/;
AccountName=<storage account name>;AccountKey=<storage account key>'
```

### Python

For Azure Stack Hub, the endpoint suffix is specified in the declaration instance:

```python
block_blob_service = BlockBlobService(account_name='myaccount',
account_key='mykey',
endpoint_suffix='local.azurestack.external')
```

### Ruby

For Azure Stack Hub, the endpoint suffix is specified in the setup of connection string:

```ruby
set
AZURE_STORAGE_CONNECTION_STRING=DefaultEndpointsProtocol=https;
AccountName=myaccount;
AccountKey=mykey;
EndpointSuffix=local.azurestack.external
```

## Blob storage

The following Azure Blob storage tutorials are applicable to Azure Stack Hub. Note the specific endpoint suffix requirement for Azure Stack Hub described in the previous [Examples](#examples) section.

* [Get started with Azure Blob storage using .NET](/azure/storage/blobs/storage-dotnet-how-to-use-blobs)
* [How to use Blob storage from Java](/azure/storage/blobs/storage-java-how-to-use-blob-storage)
* [How to use Blob storage from Node.js](/azure/storage/blobs/storage-nodejs-how-to-use-blob-storage)
* [How to use Blob storage from C++](/azure/storage/blobs/storage-c-plus-plus-how-to-use-blobs)
* [How to use Blob storage from PHP](/azure/storage/blobs/storage-php-how-to-use-blobs)
* [How to use Azure Blob storage from Python](/azure/storage/blobs/storage-python-how-to-use-blob-storage)
* [How to use Blob storage from Ruby](/azure/storage/blobs/storage-ruby-how-to-use-blob-storage)

## Queue storage

The following Azure Queue storage tutorials are applicable to Azure Stack Hub. Note the specific endpoint suffix requirement for Azure Stack Hub described in the previous [Examples](#examples) section.

* [Get started with Azure Queue storage using .NET](/azure/storage/queues/storage-quickstart-queues-dotnet?tabs=passwordless%2Croles-azure-portal%2Cenvironment-variable-windows%2Csign-in-azure-cli)
* [How to use Queue storage from Java](/azure/storage/queues/storage-quickstart-queues-java?tabs=powershell%2Cpasswordless%2Croles-azure-portal%2Cenvironment-variable-windows%2Csign-in-azure-cli)
* [How to use Queue storage from Node.js](/azure/storage/queues/storage-quickstart-queues-nodejs?tabs=passwordless%2Croles-azure-portal%2Cenvironment-variable-windows%2Csign-in-azure-cli)
* [How to use Queue storage from C++](/azure/storage/queues/storage-c-plus-plus-how-to-use-queues)
* [How to use Queue storage from PHP](/azure/storage/queues/storage-php-how-to-use-queues)
* [How to use Queue storage from Python](/azure/storage/queues/storage-quickstart-queues-python?tabs=passwordless%2Croles-azure-portal%2Cenvironment-variable-windows%2Csign-in-azure-cli)
* [How to use Queue storage from Ruby](/azure/storage/queues/storage-ruby-how-to-use-queue-storage)

## Table storage

The following Azure Table storage tutorials are applicable to Azure Stack Hub. Note the specific endpoint suffix requirement for Azure Stack Hub described in the previous [Examples](#examples) section.

* [Get started with Azure Table storage using .NET](/azure/cosmos-db/table-storage-how-to-use-dotnet)
* [How to use Table storage from Java](/azure/cosmos-db/table-storage-how-to-use-java)
* [How to use Azure Table storage from Node.js](/azure/cosmos-db/table-storage-how-to-use-nodejs)
* [How to use Table storage from C++](/azure/cosmos-db/table-storage-how-to-use-c-plus)
* [How to use Table storage from PHP](/azure/cosmos-db/table-storage-how-to-use-php)
* [How to use Table storage in Python](/azure/cosmos-db/table-storage-how-to-use-python)
* [How to use Table storage from Ruby](/azure/cosmos-db/table-storage-how-to-use-ruby)

## Next steps

* [Introduction to Microsoft Azure storage](/azure/storage/common/storage-introduction)
