---
title: Use API version profiles with Java in Azure Stack Hub 
description: Learn how to use API version profiles with Java in Azure Stack Hub.
author: sethmanheim

ms.topic: article
ms.date: 1/13/2022
ms.author: sethm
ms.reviewer: weshi1
ms.lastreviewed: 3/23/2022

# Intent: As an Azure Stack user, I want to use API version profiles with Java in Azure stack so I can benefit from the use of profiles.
# Keyword: azure stack api profiles java

---


# Use API version profiles with Java in Azure Stack Hub
>[!IMPORTANT]
>The Java SDK has been updated from track 1 to track 2. We recommend migrating to the track 2 SDK as soon as possible. For instructions, see [this migration guide](https://github.com/Azure/azure-sdk-for-java/blob/main/sdk/resourcemanager/docs/MIGRATION_GUIDE.md).

The Java SDK for the Azure Stack Hub Resource Manager provides tools to help you build and manage your infrastructure. Resource providers in the SDK include compute, networking, storage, app services, and Azure Key Vault. You can find the [Hybrid Java Samples repository](https://github.com/Azure-Samples/Hybrid-Java-Samples) on GitHub. This article will help you set up your environment, get the right credentials, grab the repository, and create a resource group in Azure Stack Hub.

Using the Java SDK enables a true hybrid cloud developer experience. Switching the version dependencies in the `POM.xml` in the Java SDK enable hybrid cloud development by helping you switch between global Azure resources to resources in Azure Stack Hub.

::: moniker range=">=azs-2102"

To use the latest version of the services, use the **latest** profile as the dependency.

You can target your app to resource in Azure tack Hub by taking your existing **com.azure.resourcemanager** dependency and change the version from `x.y.z` to `x.y.z-hybrid`. The hybrid packages, which provide support for Azure Stack Hub, use a `-hybrid` suffix at the end of the version, for example, `1.0.0-hybrid`. This will point to a static collection of endpoints associated with the version.

To get the the latest profile, take your existing **com.azure.resourcemanager** dependency and change the version to **latest**. The **latest** profile Java packages provide a consistent experience with Azure. The packages share the same group ID as Azure **com.azure.resourcemanager**. The artifact ID and namespaces are also the same as global Azure. This helps in porting your Azure app to Azure Stack Hub. To find more about the endpoints used in Azure Stack Hub as par of the hybrid profile, see the [Summary
of API profiles](../user/azure-stack-version-profiles.md#summary-of-api-profiles).

The profile is specified in the `pom.xml` file in the Maven project as a dependency. The profile loads modules automatically if you choose the right class from the dropdown list (as you would with .NET).
## Set up your development environment

To prepare your environment for running the SDK, you can use an IDE such as Eclipse or Visual Studio Code, but you will need to have Git, the Java SDK, and Apache Maven installed. You can find details about the prerequisites for the setting up your development environment at [Use the Azure SDK for Java](/azure/developer/java/sdk/overview)

1. Install Git. You can find the official instructions to install Git at [Getting Started - Installing Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

1. Install the Java SDK and set your `JAVA_HOME` environment variable to the location of the binaries for Java Development Kit. You can find the downloadable installation media instructions for the [OpenJDK](https://www.microsoft.com/openjdk). Install version 8 or greater of the Java Developer Kit.

1. Install Apache Maven. You can find instruction at [the Apache Maven Project](https://maven.apache.org/). Install Apache Maven is 3.0 or above. 
::: moniker-end
::: moniker range="<=azs-2008"
## Java and API version profiles

To use the latest versions of all the services, use the **latest** profile as the dependency.

  - To use the latest profile, the dependency is **com.microsoft.azure**.

  - To use the latest supported services available in Azure Stack Hub, use the
    **com.microsoft.azure.profile\_2019\_03\_01\_hybrid** profile.

    - The profile is specified in the **Pom.xml** file as a dependency, which loads modules automatically if you choose the right class from the dropdown list (as you would with .NET).

  - Dependencies appear as follows:

     ```xml
     <dependency>
     <groupId>com.microsoft.azure.profile_2019_03_01_hybrid</groupId>
     <artifactId>azure</artifactId>
     <version>1.0.0-beta-1</version>
     </dependency>
     ```

  - To use specific API versions for a resource type in a specific resource provider, use the specific API versions defined through Intellisense.

You can combine all of the options in the same app.

## Install the Azure Java SDK

Follow these steps to install the Java SDK:

1. Follow the official instructions to install Git. See [Getting Started - Installing Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

1. Follow the instructions to install the [Java SDK](https://zulu.org/download/) and [Maven](https://maven.apache.org/). The correct version is version 8 of the Java Developer Kit. The correct version of Apache Maven is 3.0 or above. To complete the quickstart, the `JAVA_HOME` environment variable must be set to the install location of the Java Development Kit. For more info, see [Create your first function with Java and Maven](/azure/azure-functions/functions-create-first-java-maven).

1. To install the correct dependency packages, open the **Pom.xml** file in your Java app. Add a dependency, as shown in the following code:
   ```xml  
   <dependency>
   <groupId>com.microsoft.azure.profile_2019_03_01_hybrid</groupId>
   <artifactId>azure</artifactId>
   <version>1.0.0-beta-1</version>
   </dependency>
   ```

1. The set of packages that need to be installed depends on the profile version you want to use. The package names for the profile versions are:
   - **com.microsoft.azure.profile\_2019\_03\_01\_hybrid**
   - **com.microsoft.azure**
     - **latest**

::: moniker-end

## Profiles

For profiles containing dates, to use a different SDK profile or version, substitute the date in `com.microsoft.azure.profile<date>_hybrid`. For example, for the 2008 version, the profile is `2019_03_01`, and the string becomes `com.microsoft.azure.profile_2019_03_01_hybrid`. Note that sometimes the SDK team changes the name of the packages, so simply replacing the date of a string with a different date might not work. See the following table for association of profiles and Azure Stack versions.

| Azure Stack version | Profile |
|---------------------|---------|
|2301|2020_09_01|
|2206|2020_09_01|
|2108|2020_09_01|
|2102|2020_09_01|
|2008|2019_03_01|

For more information about Azure Stack Hub and API profiles, see the [Summary of API profiles](azure-stack-version-profiles.md).

## Subscription

If you do not already have a subscription, create a subscription and save the subscription ID to be used later. For information about how to create a subscription, see this [document](../operator/azure-stack-subscribe-plan-provision-vm.md).

## Service principal

A service principal and its associated environment information should be created and saved somewhere. Service principal with `owner` role is recommended, but depending on the sample, a `contributor` role may suffice. Refer to the README in the [sample repository](https://github.com/Azure-Samples/Hybrid-Java-Samples) for the required values. You may read these values in any format supported by the SDK language such as from a JSON file (which our samples use). Depending on the sample being run, not all of these values may be used. See the [sample repository](https://github.com/Azure-Samples/Hybrid-Java-Samples) for updated sample code or further information.

## Tenant ID

To find the directory or tenant ID for your Azure Stack Hub, follow the instructions [in this article](./authenticate-azure-stack-hub.md#get-the-tenant-id).

## Register resource providers

Register required resource providers by following this [document](/azure/azure-resource-manager/management/resource-providers-and-types). These resource providers will be required depending on the samples you want to run. For example, if you want to run a VM sample, the `Microsoft.Compute` resource provider registration is required.

## Azure Stack resource manager endpoint

Azure Resource Manager (ARM) is a management framework that enables administrators to deploy, manage, and monitor Azure resources. Azure Resource Manager can handle these tasks as a group, rather than individually, in a single operation. You can get the metadata info from the Resource Manager endpoint. The endpoint returns a JSON file with the info required to run your code.

- The **ResourceManagerEndpointUrl** in the Azure Stack Development Kit (ASDK) is: `https://management.local.azurestack.external/`.
- The **ResourceManagerEndpointUrl** in integrated systems is: `https://management.region.<fqdn>/`, where `<fqdn>` is your fully qualified domain name.
- To retrieve the metadata required: `<ResourceManagerUrl>/metadata/endpoints?api-version=1.0`.
For available API versions, see [Azure rest API specifications](https://github.com/Azure/azure-rest-api-specs/tree/main/profile). E.g., in `2020-09-01` profile version, you can change the `api-version` to `2019-10-01` for resource provider `microsoft.resources`.

Sample JSON:
```json
{
   "galleryEndpoint": "https://portal.local.azurestack.external:30015/",
   "graphEndpoint": "https://graph.windows.net/",
   "portal Endpoint": "https://portal.local.azurestack.external/",
   "authentication": 
      {
         "loginEndpoint": "https://login.windows.net/",
         "audiences": ["https://management.yourtenant.onmicrosoft.com/3cc5febd-e4b7-4a85-a2ed-1d730e2f5928"]
      }
}
```

::: moniker range="<=azs-2008"

### Trust the Azure Stack Hub CA root certificate

If you are using the Azure Stack Development Kit (ASDK), you must trust the CA root certificate on your remote machine. You do not need to trust the CA root certificate with Azure Stack Hub integrated systems.

#### Windows

1. Export the Azure Stack Hub self-signed certificate to your desktop.

1. In a command prompt, change the directory to `%JAVA_HOME%\bin`.

1. Run the following command:

   ```shell
   .\keytool.exe -importcert -noprompt -file <location of the exported certificate here> -alias root -keystore %JAVA_HOME%\lib\security\cacerts -trustcacerts -storepass changeit
   ```

## Existing API profiles

- **com.microsoft.azure.profile\_2019\_03\_01\_hybrid**: Latest profile built for Azure Stack Hub. Use this profile for services to be most compatible with Azure Stack Hub, as long as you're on 1904 or later.

- **com.microsoft.azure.profile\_2018\_03\_01\_hybrid**: Profile built for Azure Stack Hub. Use this profile for services to be compatible with Azure Stack Hub versions 1808 or later.

- **com.microsoft.azure**: Profile consisting of the latest versions of all services. Use the latest versions of all the services.

For more information about Azure Stack Hub and API profiles, see the [Summary
of API profiles](../user/azure-stack-version-profiles.md#summary-of-api-profiles).

## Azure Java SDK API profile usage

The following code authenticates the service principal on Azure Stack Hub. It creates a token using the tenant ID and the authentication base, which is specific to Azure Stack Hub:

```java
AzureTokenCredentials credentials = new ApplicationTokenCredentials(client, tenant, key, AZURE_STACK)
                    .withDefaultSubscriptionID(subscriptionID);
Azure azureStack = Azure.configure()
                    .withLogLevel(com.microsoft.rest.LogLevel.BASIC)
                    .authenticate(credentials, credentials.defaultSubscriptionID());
```

This code enables you to use the API profile dependencies to deploy your app successfully to Azure Stack Hub.

## Define Azure Stack Hub environment setting functions

To register the Azure Stack Hub cloud with the correct endpoints, use the following code:

```java
// Get Azure Stack Hub cloud endpoints
final HashMap<String, String> settings = getActiveDirectorySettings(armEndpoint);

AzureEnvironment AZURE_STACK = new AzureEnvironment(new HashMap<String, String>() {
                {
                    put("managementEndpointUrl", settings.get("audience"));
                    put("resourceManagerEndpointUrl", armEndpoint);
                    put("galleryEndpointUrl", settings.get("galleryEndpoint"));
                    put("activeDirectoryEndpointUrl", settings.get("login_endpoint"));
                    put("activeDirectoryResourceID", settings.get("audience"));
                    put("activeDirectoryGraphResourceID", settings.get("graphEndpoint"));
                    put("storageEndpointSuffix", armEndpoint.substring(armEndpoint.indexOf('.')));
                    put("keyVaultDnsSuffix", ".vault" + armEndpoint.substring(armEndpoint.indexOf('.')));
                }
            });
```

The `getActiveDirectorySettings` call in the previous code retrieves the endpoints from the metadata endpoints. It states the environment variables from the call that's made:

```java
public static HashMap<String, String> getActiveDirectorySettings(String armEndpoint) {

    HashMap<String, String> adSettings = new HashMap<String, String>();
    try {

        // create HTTP Client
        HttpClient httpClient = HttpClientBuilder.create().build();

        // Create new getRequest with below mentioned URL
        HttpGet getRequest = new HttpGet(String.format("%s/metadata/endpoints?api-version=1.0",
                             armEndpoint));

        // Add additional header to getRequest which accepts application/xml data
        getRequest.addHeader("accept", "application/xml");

        // Execute request and catch response
        HttpResponse response = httpClient.execute(getRequest);

        // Check for HTTP response code: 200 = success
        if (response.getStatusLine().getStatusCode() != 200) {
            throw new RuntimeException("Failed : HTTP error code : " + response.getStatusLine().getStatusCode());
        }

        String responseStr = EntityUtils.toString(response.getEntity());
        JSONObject responseJson = new JSONObject(responseStr);
        adSettings.put("galleryEndpoint", responseJson.getString("galleryEndpoint"));
        JSONObject authentication = (JSONObject) responseJson.get("authentication");
        String audience = authentication.get("audiences").toString().split("\"")[1];
        adSettings.put("login_endpoint", authentication.getString("loginEndpoint"));
        adSettings.put("audience", audience);
        adSettings.put("graphEndpoint", responseJson.getString("graphEndpoint"));

    } catch (ClientProtocolException cpe) {
        cpe.printStackTrace();
        throw new RuntimeException(cpe);
    } catch (IOException ioe) {
        ioe.printStackTrace();
        throw new RuntimeException(ioe);
    }
    return adSettings;
}
```

### Sample unit test project

1. Clone the repository using the following command:

   ```shell
   git clone https://github.com/Azure-Samples/Hybrid-Java-Samples.git -b resourcegroup-2019-03-01-hybrid
   ```

1. Create an Azure service principal and assign a role to access the subscription. For instructions on creating a service principal, see [Use Azure PowerShell to create a service principal with a certificate](../operator/give-app-access-to-resources.md).

1. Retrieve the following required environment variables:

   - `AZURE_TENANT_ID`
   - `AZURE_CLIENT_ID`
   - `AZURE_CLIENT_SECRET`
   - `AZURE_SUBSCRIPTION_ID`
   - `ARM_ENDPOINT`
   - `RESOURCE_LOCATION`

1. Set the following environment variables using the info retrieved from the service principal you created using the command prompt:

   - `export AZURE_TENANT_ID={your tenant ID}`
   - `export AZURE_CLIENT_ID={your client ID}`
   - `export AZURE_CLIENT_SECRET={your client secret}`
   - `export AZURE_SUBSCRIPTION_ID={your subscription ID}`
   - `export ARM_ENDPOINT={your Azure Stack Hub Resource Manager URL}`
   - `export RESOURCE_LOCATION={location of Azure Stack Hub}`

   In Windows, use **set** instead of **export**.

1. Use the `getActiveDirectorySettings` function to retrieve the Azure Resource Manager metadata endpoints.

    ```java
    // Get Azure Stack Hub cloud endpoints
    final HashMap<String, String> settings = getActiveDirectorySettings(armEndpoint);
    ```

1. In the **Pom.xml** file, add the following dependency to use the **2019-03-01-hybrid** profile for Azure Stack Hub. This dependency installs the modules associated with this profile for the Compute, Networking, Storage, Key Vault, and App Services resource providers:

    ```xml
    <dependency>
      <groupId>com.microsoft.azure.profile_2019_03_01_hybrid</groupId>
      <artifactId>azure</artifactId>
      <version>1.0.0-beta-1</version>
    </dependency>
    ```

1. In the command prompt that was open to set the environment variables, enter the following command:

   ```shell
   mvn clean compile exec:java
   ```
   
::: moniker-end

## Samples

See [this sample repository](https://github.com/Azure-Samples/Hybrid-Java-Samples) for update-to-date (track 2) sample code. See [this sample repository](https://github.com/Azure-Samples/Hybrid-Java-Samples/releases/tag/track1) for track 1 sample code. The root `README.md` describes general requirements, and each sub-directory contains a specific sample with its own `README.md` on how to run that sample.

::: moniker range="<=azs-2008"

See [here](https://github.com/Azure-Samples/Hybrid-Java-Samples/tree/07c59f36fb2ada0ffb404410d6efcfeaa137cdc3) for the sample applicable for Azure Stack version `2008` or profile `2019-03-01` and below.

::: moniker-end

## Next steps

Learn more about API profiles:
- [Manage API version profiles in Azure Stack Hub](azure-stack-version-profiles.md)
- [Resource provider API versions supported by profiles](azure-stack-profiles-azure-resource-manager-versions.md)
