---
title: Using API version profiles with Node.js in Azure Stack Hub | Microsoft Docs
description: Learn about using API version profiles with Node.js in Azure Stack Hub.
services: azure-stack
documentationcenter: ''
author: mattbriggs
manager: femila

ms.service: azure-stack
ms.workload: na
pms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 11/11/2019
ms.author: mabrigg
ms.reviewer: sijuman
ms.lastreviewed: 11/11/2019

---

# Use API version Profiles with Node.js software development kit (SDK) in Azure Stack Hub

*Applies to: Azure Stack Hub integrated systems and Azure Stack Development Kit*

## Node.js and API version profiles

You can use Node.js SDK to help build and manage the infrastructure for your apps. API profiles in the Node.js SDK help with your hybrid cloud solutions by letting you switch between global Azure resources and Azure Stack Hub resources. You can code once and then target both global Azure and Azure Stack Hub. 

In this article, you can use [Visual Studio Code](https://code.visualstudio.com/) as your development tool. Visual Studio Code can debug the Node.js SDK and allows you to run the app and push the app to your Azure Stack Hub instance. You can debug from Visual Studio Code or through a terminal window running the command `node <nodefile.js>`.

## The Node.js SDK

The Node.js SDK provides Azure Stack Hub Resource Manager tools. Resource providers in the SDK include compute, networking, storage, app services, and KeyVault. There are 10 resource provider client libraries that you can install in your node.js application. You can also download specify which resource provider you will use for the **2018-03-01-hybrid** or **2019-03-01-profile** in order to optimize the memory for your application. Each module consists of a resource provider, the respective API version, and the API profile. 

An API profile is a combination of resource providers and API versions. You can use an API profile to get the latest, most stable version of each resource type in a resource provider package.

  -   To make use of the latest versions of all the services, use the **latest** profile of the packages.

  -   To use the services compatible with Azure Stack Hub, use the **\@azure/arm-resources-profile-hybrid-2019-03-01** or **\@azure/arm-storage-profile-2019-03-01-hybrid**

### Packages in npm

Each resource provider has its own package. You can get the package from the [npm registry](https://www.npmjs.com/package/@azure/arm-storage-profile-2019-03-01-hybrid).

You can find the following packages:

| Resource provider | Package |
| --- | --- |
| [App Service](https://www.npmjs.com/package/@azure/arm-appservice-profile-2019-03-01-hybrid) | @azure/arm-appservice-profile-2019-03-01-hybrid |
| [Azure Resource Manager Subscriptions](https://www.npmjs.com/package/@azure/arm-subscriptions-profile-hybrid-2019-03-01) | @azure/arm-subscriptions-profile-hybrid-2019-03-01  |
| [Azure Resource Manager Policy](https://www.npmjs.com/package/@azure/arm-policy-profile-hybrid-2019-03-01) | @azure/arm-policy-profile-hybrid-2019-03-01
| [Azure Resource Manager DNS](https://www.npmjs.com/package/@azure/arm-dns-profile-2019-03-01-hybrid) | @azure/arm-dns-profile-2019-03-01-hybrid  |
| [Authorization](https://www.npmjs.com/package/@azure/arm-authorization-profile-2019-03-01-hybrid) | @azure/arm-authorization-profile-2019-03-01-hybrid  |
| [Compute](https://www.npmjs.com/package/@azure/arm-compute-profile-2019-03-01-hybrid) | @azure/arm-compute-profile-2019-03-01-hybrid |
| [Storage](https://www.npmjs.com/package/@azure/arm-storage-profile-2019-03-01-hybrid) | @azure/arm-storage-profile-2019-03-01-hybrid |
| [Network](https://www.npmjs.com/package/@azure/arm-network-profile-2019-03-01-hybrid) | @azure/arm-network-profile-2019-03-01-hybrid |
| [Resources](https://www.npmjs.com/package/@azure/arm-resources-profile-hybrid-2019-03-01) | @azure/arm-resources-profile-hybrid-2019-03-01 |
 | [Keyvault](https://www.npmjs.com/package/@azure/arm-keyvault-profile-2019-03-01-hybrid) | @azure/arm-keyvault-profile-2019-03-01-hybrid |

To use the latest API-version of a service, use the **Latest** profile of the specific client library. For example, if you would like to use the latest-API version of resources service alone, use the `azure-arm-resource` profile of the **Resource Management Client Library.** package.

Use the specific API versions defined inside the package for the specific API-versions of a resource provider.

  > [!Note]  
  > You can combine all of the options in the same application.

## Install the Node.js SDK

1. Install Git. For instructions, see [Getting Started - Installing Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

2. Install or upgrade to the current version of [Node.js](https://nodejs.org/en/download/). Node.js also includes the [npm](https://www.npmjs.com/) JavaScript package manager.

3. Install or upgrade [Visual Studio Code](https://code.visualstudio.com/) and install the [Node.js extension](https://code.visualstudio.com/docs/nodejs/nodejs-debugging) for Visual Studio Code.

2.  Install the client packages for the Azure Stack Hub Resource Manger. For more information, see [how to install client libraries](https://www.npmjs.com/package/@azure/arm-keyvault-profile-2019-03-01-hybrid).

3.  The packages that need to be installed depends on the profile version you would like to use. You can find a list of resource providers in the [Packages in npm](#packages-in-npm) section.

4. Install the resource provider client library using npm. From the command line, run: `npm install <package-name>`. For example, you can run `npm install @azure/arm-authorization-profile-2019-03-01-hybrid` to install the authorization resource provider library.

5.  Create a subscription and make a note of the Subscription ID when you use the SDK. For instructions, see [Create subscriptions to offers in Azure Stack Hub](https://docs.microsoft.com/azure/azure-stack/azure-stack-subscribe-plan-provision-vm).

6.  Create a service principal and save the client ID and the client secret. The client ID is also known as the application ID when creating a service principal. For instructions, see [Provide applications access to Azure Stack Hub](../operator/azure-stack-create-service-principals.md).

7.  Make sure your service principal has contributor/owner role on your subscription. For instructions on how to assign a role to service principal, see [Provide applications access to Azure Stack Hub](../operator/azure-stack-create-service-principals.md).

### Node.js prerequisites 

To use the Node.js Azure SDK with Azure Stack Hub, you must supply the following values, and then set values with environment variables. To set the environmental variables, see the instructions following the table for your operating system.

| Value | Environment variables | Description |
| --- | --- | --- |
| Tenant ID | TENANT\_ID | The value of your Azure Stack Hub [tenant ID](https://docs.microsoft.com/azure/azure-stack/azure-stack-identity-overview). |
| Client ID | CLIENT\_ID | The service principal application ID saved when service principal was created on the previous section of this document.  |
| Subscription ID | AZURE\_SUBSCRIPTION\_ID   The [subscription ID](/azure-stack/operator/service-plan-offer-subscription-overview#subscriptions) is how you access offers in Azure Stack Hub.  |
| Client Secret | APPLICATION\_SECRET | The service principal application Secret saved when service principal was created. |
| Resource Manager Endpoint | ARM\_ENDPOINT | See [the Azure Stack Hub Resource Manager endpoint](https://docs.microsoft.com/azure/azure-stack/user/azure-stack-version-profiles-ruby#the-azure-stack-hub-resource-manager-endpoint). |

#### Set your environmental variables for Node.js

To set your environment variables:

  - **Microsoft Windows**  

    To set the environment variables, in a Windows command prompt, use the following format:
      
      `set Tenant_ID=<Your_Tenant_ID>`

  - **macOS, Linux, and Unix-based systems**  

    To set the environment variables, from a bash prompt, use the following format:

    `export Azure_Tenant_ID=<Your_Tenant_ID>`

**The Azure Stack Hub Resource Manager endpoint**

The Microsoft Azure Resource Manager is a management framework that allows administrators to deploy, manage, and monitor Azure resources. Azure Resource Manager can handle these tasks as a group, rather than individually, in a single operation.

You can get the metadata information from the Resource Manager endpoint. The endpoint returns a JSON file with the information required to run your code.

> [!Note]  
> The **ResourceManagerUrl** in the Azure Stack Development Kit (ASDK) is: `https://management.local.azurestack.external`
The **ResourceManagerUrl** in integrated systems is: `https://management.<location>.ext-<machine-name>.masd.stbtest.microsoft.com`
To retrieve the metadata required: `<ResourceManagerUrl>/metadata/endpoints?api-version=1.0`

Sample JSON file:

```JSON  
{
    "galleryEndpoint": "https://portal.local.azurestack.external/",

    "graphEndpoint": "https://graph.windowsNode.js/",

    "portal Endpoint": "https://portal.local.azurestack.external/",

    "authentication": {

        "loginEndpoint": "https://login.windowsNode.js/",

        "audiences": ["https://management.<yourtenant>.onmicrosoft.com/"]

    }

}
```

### Existing API profiles

-  **\@azure/arm-resourceprovider-profile-2019-03-01-hybrid**

    Latest Profile built for Azure Stack Hub. Use this profile for services to be most compatible with Azure Stack Hub as long as you are on 1808 stamp or further.

-  **\@azure-arm-resource**

    Profile consists of latest versions of all services. Use the latest versions of all the services in Azure.

For more information about Azure Stack Hub and API profiles, see a [Summary of API profiles](https://docs.microsoft.com/azure/azure-stack/user/azure-stack-version-profiles#summary-of-api-profiles).

### Azure Node.js SDK API Profile usage

The following lines should be used to instantiate a profile client. This parameter is only required for Azure Stack Hub or other private clouds. Global Azure already has these settings by default with @azure-arm-resource or @azure-arm-storage.

```Node.js  
var ResourceManagementClient = require('@azure/arm-resources-profile-hybrid-2019-03-01').ResourceManagementClient;

var StorageManagementClient = require('@azure/arm-storage-profile-2019-03-01-hybrid').StorageManagementClient;
````

The following code is needed to authenticate the service principal on Azure Stack Hub. It creates a token by the tenant ID and the authentication base, which is specific to Azure Stack Hub.

```Node.js  
var clientId = process.env['AZURE_CLIENT_ID'];
var tenantId = process.env['AZURE_TENANT_ID']; //"adfs"
var secret = process.env['AZURE_CLIENT_SECRET'];
var subscriptionId = process.env['AZURE_SUBSCRIPTION_ID'];
var base_url = process.env['ARM_ENDPOINT'];
var resourceClient, storageClient;
```

This will allow you to use the API Profile client library to deploy your application successfully to Azure Stack Hub.

The below code snippet uses the Azure Resource Manager endpoint that you specify for your Azure Stack Hub instance and gathers the data shown above such as gallery endpoint, graph endpoint, audiences, and portal endpoint.

```Node.js  
var map = {};
const fetchUrl = base_url + 'metadata/endpoints?api-version=1.0'
```

## Environment settings

To authenticate the service principal to the Azure Stack Hub environment, use the following code: Using this code and setting your environment variables in the command prompt automatically generates this mapping for the developer.

```Node.js  
function main() {
  var initializePromise = initialize();
  initializePromise.then(function (result) {
    var userDetails = result;
    console.log("Initialized user details");
    // Use user details from here
    console.log(userDetails)
    map["name"] = "AzureStack"
    map["portalUrl"] = userDetails.portalEndpoint 
    map["resourceManagerEndpointUrl"] = base_url 
    map["galleryEndpointUrl"] = userDetails.galleryEndpoint 
    map["activeDirectoryEndpointUrl"] = userDetails.authentication.loginEndpoint.slice(0, userDetails.authentication.loginEndpoint.lastIndexOf("/") + 1) 
    map["activeDirectoryResourceId"] = userDetails.authentication.audiences[0] 
    map["activeDirectoryGraphResourceId"] = userDetails.graphEndpoint 
    map["storageEndpointSuffix"] = "." + base_url.substring(base_url.indexOf('.'))  
    map["keyVaultDnsSuffix"] = ".vault" + base_url.substring(base_url.indexOf('.')) 
    map["managementEndpointUrl"] = userDetails.authentication.audiences[0] 
    map["validateAuthority"] = "false"
    Environment.Environment.add(map);
```

## Samples using API profiles

You can use the following samples as a reference for creating solutions with Node.js and Azure Stack Hub API profiles. You can get the samples from GitHub in the following repositories:

- [Storage node resource provider getting started](https://github.com/sijuman/storage-node-resource-provider-getting-started)
- [Compute node manage](https://github.com/sijuman/compute-node-manage-vm)
- [Resource-manager node resources and groups](https://github.com/sijuman/resource-manager-node-resources-and-groups)

### Sample create storage account 

1.  Clone the repository.

    ```bash  
    git clone https://github.com/sijuman/storage-node-resource-provider-getting-started.git
    ```

2.  Create an Azure service principal and assign a role to access the subscription. For instructions, see [Use Azure PowerShell to create a service principal with a certificate](https://docs.microsoft.com/azure/azure-stack/azure-stack-create-service-principals).

3.  Retrieve the following required values:
    - Tenant ID
    - Client ID
    - Client secret
    - Azure Subscription ID
    - Azure Stack Hub Resource Manager endpoint

4.  Set the following environment variables using the information you retrieved from the service principal you created using the command prompt:

    ```bash  
    export TENANT_ID=<your tenant id>
    export CLIENT_ID=<your client id>
    export APPLICATION_SECRET=<your client secret>K
    export AZURE_SUBSCRIPTION_ID=<your subscription id>
    export ARM_ENDPOINT=<your Azure Stack Hub Resource manager URL>
    ```

    > [!Note]  
    > On Windows, use **set** instead of **export**.

5.  Open the `index.js` file of the sample application.

6.  Set the location variable to your Azure Stack Hub location. For example, `LOCAL = "local"`.

7.  Set the credentials that will allow you to authenticate to Azure Stack Hub. This portion of the code is included in this sample on the index.js file.

    ```Node.js  
    var clientId = process.env['CLIENT_ID'];
    var tenantId = process.env['TENANT_ID']; //"adfs"
    var secret = process.env['APPLICATION_SECRET'];
    var subscriptionId = process.env['AZURE_SUBSCRIPTION_ID'];
    var base_url = process.env['ARM_ENDPOINT'];
    var resourceClient, storageClient;
    ```

8.  Checks that you have set the right client libraries, using a combination of the client libraries stipulated above. In this sample we have used the following below:

    ```Node.js
    var ResourceManagementClient = require('@azure/arm-resources-profile-hybrid-2019-03-01').ResourceManagementClient;
    var StorageManagementClient = require('@azure/arm-storage-profile-2019-03-01-hybrid').StorageManagementClient;
    ```

9.  Using [npm modules search](https://www.npmjs.com/package/@azure/arm-keyvault-profile-2019-03-01-hybrid), locate the **2019-03-01-hybrid** and install the packages associated with this profile for the Compute, Networking, Storage, KeyVault and App Services resource providers.

    This can be done by opening command prompt, redirecting it to the root folder of the repository, and running `npm install @azure/arm-keyvault-profile-2019-03-01-hybrid` for each resource provider used.

10.  On the command prompt, run the command `npm install` to install all node.js modules.

11.  Run the sample.

        ```Node.js  
        node index.js
        ```

12.  To clean up after index.js, run the cleanup script.

        ```Node.js  
        Node cleanup.js <resourceGroupName> <storageAccountName>
        ```

13.  The sample has successfully been completed. For more information on the sample, see below.

### What does index.js do?

The sample creates a new storage account, lists the storage accounts in the subscription or resource group, lists the storage account keys, regenerates the storage account keys, gets the storage account properties, updates the storage account SKU, and checks storage account name availability.

The sample starts by logging in using your service principal and creating **ResourceManagementClient** and **StorageManagementClient** objects using your credentials and subscription ID.

The sample then sets up a resource group in which it will create the new storage account.

```Node.js  
function createResourceGroup(callback) {
  var groupParameters = { location: location, tags: { sampletag: 'sampleValue' } };
  console.log('\nCreating resource group: ' + resourceGroupName);
  return resourceClient.resourceGroups.createOrUpdate(resourceGroupName, groupParameters, callback);
}
```

### Create a new storage account

Next, the sample creates a new storage account that is associated with the resource group created in the previous step.

In this case, the storage account name is randomly generated to assure uniqueness. However, the call to create a new storage account will succeed if an account with the same name already exists in the subscription.

```Node.js  
var createParameters = {
    location: location,
    sku: {
        name: accType,
    },
    kind: 'Storage',
    tags: {
        tag1: 'val1',
        tag2: 'val2'
    }
};


console.log('\\n--&gt;Creating storage account: ' + storageAccountName + ' with parameters:\\n' + util.inspect(createParameters));

return storageClient.storageAccounts.create(resourceGroupName, storageAccountName, createParameters, callback);
```

### List storage accounts in the subscription or resource group

The sample lists all of the storage accounts in a given subscription:

```Node.js  
console.log('\\n--&gt;Listing storage accounts in the current subscription.');

return storageClient.storageAccounts.list(callback);

It also lists storage accounts in the resource group:

    console.log('\\n--&gt;Listing storage accounts in the resourceGroup : ' + resourceGroupName);

return storageClient.storageAccounts.listByResourceGroup(resourceGroupName, callback);
```

### Read and regenerate storage account keys

The sample lists storage account keys for the newly created storage account and resource group:

```Node.js  
console.log('\\n--&gt;Listing storage account keys for account: ' + storageAccountName);

return storageClient.storageAccounts.listKeys(resourceGroupName, storageAccountName, callback);
```

It also regenerates the account access keys:

```Node.js  
console.log('\\n--&gt;Regenerating storage account keys for account: ' + storageAccountName);

return storageClient.storageAccounts.regenerateKey(resourceGroupName, storageAccountName, 'key1', callback);
```

### Get storage account properties

The sample reads the storage account's properties:

```Node.js  
console.log('\\n--&gt;Getting info of storage account: ' + storageAccountName);

return storageClient.storageAccounts.getProperties(resourceGroupName, storageAccountName, callback);
```

### Check storage account name availability

The sample checks whether a given storage account name is available in Azure:

```Node.js  
console.log('\\n--&gt;Checking if the storage account name : ' + storageAccountName + ' is available.');

return storageClient.storageAccounts.checkNameAvailability(storageAccountName, callback);
```

### Delete the storage account and resource group

Running cleanup.js deletes the storage account that the sample created:

```Node.js  
console.log('\\nDeleting storage account : ' + storageAccountName);
return storageClient.storageAccounts.deleteMethod(resourceGroupName, storageAccountName, callback);
```

It also deletes the resource group that the sample created:

```Node.js  
console.log('\\nDeleting resource group: ' + resourceGroupName);

return resourceClient.resourceGroups.deleteMethod(resourceGroupName, callback);
```

## Next steps

For more information about API profiles, see:

- [Manage API version profiles in Azure Stack Hub](azure-stack-version-profiles.md)
- [Resource provider API versions supported by profiles](azure-stack-profiles-azure-resource-manager-versions.md)
