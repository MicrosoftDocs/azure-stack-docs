---
title: Use API version profiles with Java in Azure Stack Hub 
description: Learn how to use API version profiles with Java in Azure Stack Hub.
author: sethmanheim

ms.topic: article
ms.date: 01/23/2020
ms.author: sethm
ms.reviewer: sijuman
ms.lastreviewed: 05/16/2019

# Intent: As an Azure Stack user, I want to use API version profiles with Java in Azure stack so I can benefit from the use of profiles.
# Keyword: azure stack api profiles java

---


# Use API version profiles with Java in Azure Stack Hub

The Java SDK for the Azure Stack Hub Resource Manager provides tools to help you build and manage your infrastructure. Resource providers in the SDK include Compute, Networking, Storage, App Services, and [Key Vault](/azure/key-vault/key-vault-whatis).

The Java SDK incorporates API profiles by including dependencies in the **Pom.xml** file that loads the correct modules in the **.java** file. However, you can add multiple profiles as dependencies, such as the **2019-03-01-hybrid**, or **latest**, as the Azure profile. Using these dependencies loads the correct module so that when you create your resource type, you can select which API version from those profiles you want to use. This enables you to use the latest versions in Azure, while developing against the most current API versions for Azure Stack Hub.

Using the Java SDK enables a true hybrid cloud developer experience. API profiles in the Java SDK enable hybrid cloud development by helping you switch between global Azure resources and resources in Azure Stack Hub.

## Java and API version profiles

An API profile is a combination of resource providers and API versions. Use an API profile to get the latest, most stable version of each resource type in a resource provider package.

- To use the latest versions of all the services, use the **latest** profile as the dependency.

  - To use the latest profile, the dependency is **com.microsoft.azure**.

  - To use the latest supported services available in Azure Stack Hub, use the
    **com.microsoft.azure.profile\_2019\_03\_01\_hybrid** profile.

    - The profile is specified in the **Pom.xml** file as a dependency, which loads modules automatically if you choose the right class from the dropdown list (as you would with .NET).

  - Dependencies appear as follows:

     ```xml
     <dependency>
     <groupId>com.microsoft.azure.profile_2019_03_01_hybrid</groupId>
     <artifactId>azure</artifactId>
     <version>1.0.0-beta</version>
     </dependency>
     ```

  - To use specific API versions for a resource type in a specific resource provider, use the specific API versions defined through Intellisense.

You can combine all of the options in the same app.

## Install the Azure Java SDK

Follow these steps to install the Java SDK:

1. Follow the official instructions to install Git. See [Getting Started - Installing Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

2. Follow the instructions to install the [Java SDK](https://zulu.org/download/) and [Maven](https://maven.apache.org/). The correct version is version 8 of the Java Developer Kit. The correct version of Apache Maven is 3.0 or above. To complete the quickstart, the `JAVA_HOME` environment variable must be set to the install location of the Java Development Kit. For more info, see [Create your first function with Java and Maven](/azure/azure-functions/functions-create-first-java-maven).

3. To install the correct dependency packages, open the **Pom.xml** file in your Java app. Add a dependency, as shown in the following code:

   ```xml  
   <dependency>
   <groupId>com.microsoft.azure.profile_2019_03_01_hybrid</groupId>
   <artifactId>azure</artifactId>
   <version>1.0.0-beta</version>
   </dependency>
   ```

4. The set of packages that need to be installed depends on the profile version you want to use. The package names for the profile versions are:

   - **com.microsoft.azure.profile\_2019\_03\_01\_hybrid**
   - **com.microsoft.azure**
     - **latest**

5. If not available, create a subscription and save the subscription ID for later use. For instructions on how to create a subscription, see [Create subscriptions to offers in Azure Stack Hub](../operator/azure-stack-subscribe-plan-provision-vm.md).

6. Create a service principal and save the client ID and the client secret. For instructions on how to create a service principal for Azure Stack Hub, see [Provide applications access to Azure Stack Hub](../operator/azure-stack-create-service-principals.md). The client ID is also known as the application ID when creating a service principal.

7. Make sure your service principal has the contributor/owner role on your subscription. For instructions on how to assign a role to service principal, see [Provide applications access to Azure Stack Hub](../operator/azure-stack-create-service-principals.md).

## Prerequisites

To use the Azure Java SDK with Azure Stack Hub, you must supply the following values, and then set values with environment variables. To set the environmental variables, see the instructions following the table for your operating system.

| Value                     | Environment variables | Description                                                                                                                                                                                                          |
| ------------------------- | --------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Tenant ID                 | `AZURE_TENANT_ID`            | Your Azure Stack Hub [tenant ID](../operator/azure-stack-identity-overview.md).                                                          |
| Client ID                 | `AZURE_CLIENT_ID`             | The service principal application ID saved when the service principal was created in the previous section.                                                                                              |
| Subscription ID           | `AZURE_SUBSCRIPTION_ID`      | You use the [subscription ID](../operator/service-plan-offer-subscription-overview.md#subscriptions) to access offers in Azure Stack Hub.                |
| Client Secret             | `AZURE_CLIENT_SECRET`        | The service principal application secret saved when the service principal was created.                                                                                                                                   |
| Resource Manager Endpoint | `ARM_ENDPOINT`              | See the [Azure Stack Hub Resource Manager endpoint](../user/azure-stack-version-profiles-ruby.md#the-azure-stack-hub-resource-manager-endpoint) article. |
| Location                  | `RESOURCE_LOCATION`    | **Local** for Azure Stack Hub.                                                                                                                                                                                                |

To find the tenant ID for your Azure Stack Hub, see the instructions [here](../operator/azure-stack-csp-ref-operations.md). To set your environment variables, use the procedures in the following sections:

### Microsoft Windows

To set the environment variables in a Windows command prompt, use the following format:

```shell
Set AZURE_TENANT_ID=<Your_Tenant_ID>
```

### MacOS, Linux, and Unix-based systems

In Unix based systems, use the following command:

```shell
Export AZURE_TENANT_ID=<Your_Tenant_ID>
```

### Trust the Azure Stack Hub CA root certificate

If you are using the Azure Stack Development Kit (ASDK), you must trust the CA root certificate on your remote machine. You do not need to trust the CA root certificate with Azure Stack Hub integrated systems.

#### Windows

1. Export the Azure Stack Hub self-signed certificate to your desktop.

1. In a command prompt, change the directory to `%JAVA_HOME%\bin`.

1. Run the following command:

   ```shell
   .\keytool.exe -importcert -noprompt -file <location of the exported certificate here> -alias root -keystore %JAVA_HOME%\lib\security\cacerts -trustcacerts -storepass changeit
   ```

### The Azure Stack Hub Resource Manager endpoint

Azure Resource Manager is a management framework that allows admins to deploy, manage, and monitor Azure resources. Azure Resource Manager can handle these tasks as a group, rather than individually, in a single operation.

You can get the metadata info from the Resource Manager endpoint. The endpoint returns a JSON file with the info required to run your code.

Note the following considerations:

- The **ResourceManagerUrl** in the ASDK is: `https://management.local.azurestack.external/`.

- The **ResourceManagerUrl** in integrated systems is: `https://management.region.<fqdn>/`, where `<fqdn>` is your fully qualified domain name.

To retrieve the metadata required: `<ResourceManagerUrl>/metadata/endpoints?api-version=1.0`.

Sample JSON file:

```json
{
   "galleryEndpoint": "https://portal.local.azurestack.external:30015/",
   "graphEndpoint": "https://graph.windows.net/",
   "portal Endpoint": "https://portal.local.azurestack.external/",
   "authentication":
      {
      "loginEndpoint": "https://login.windows.net/",
      "audiences": ["https://management.<yourtenant>.onmicrosoft.com/3cc5febd-e4b7-4a85-a2ed-1d730e2f5928"]
      }
}
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

## Samples using API profiles

Use the following GitHub samples as references for creating solutions with .NET and Azure Stack Hub API profiles:

- [Manage resource groups](https://github.com/Azure-Samples/Hybrid-resources-java-manage-resource-group)

- [Manage storage accounts](https://github.com/Azure-Samples/hybrid-storage-java-manage-storage-accounts)

- [Manage a Virtual Machine](https://github.com/Azure-Samples/hybrid-compute-java-manage-vm) (updated with 2019-03-01-hybrid profile)

### Sample unit test project

1. Clone the repository using the following command:

   ```shell
   git clone https://github.com/Azure-Samples/Hybrid-resources-java-manage-resource-group.git`
   ```

2. Create an Azure service principal and assign a role to access the subscription. For instructions on creating a service principal, see [Use Azure PowerShell to create a service principal with a certificate](../operator/azure-stack-create-service-principals.md).

3. Retrieve the following required environment variables:

   - `AZURE_TENANT_ID`
   - `AZURE_CLIENT_ID`
   - `AZURE_CLIENT_SECRET`
   - `AZURE_SUBSCRIPTION_ID`
   - `ARM_ENDPOINT`
   - `RESOURCE_LOCATION`

4. Set the following environment variables using the info retrieved from the service principal you created using the command prompt:

   - `export AZURE_TENANT_ID={your tenant ID}`
   - `export AZURE_CLIENT_ID={your client ID}`
   - `export AZURE_CLIENT_SECRET={your client secret}`
   - `export AZURE_SUBSCRIPTION_ID={your subscription ID}`
   - `export ARM_ENDPOINT={your Azure Stack Hub Resource Manager URL}`
   - `export RESOURCE_LOCATION={location of Azure Stack Hub}`

   In Windows, use **set** instead of **export**.

5. Use the `getActiveDirectorySettings` function to retrieve the Azure Resource Manager metadata endpoints.

    ```java
    // Get Azure Stack Hub cloud endpoints
    final HashMap<String, String> settings = getActiveDirectorySettings(armEndpoint);
    ```

6. In the **Pom.xml** file, add the following dependency to use the **2019-03-01-hybrid** profile for Azure Stack Hub. This dependency installs the modules associated with this profile for the Compute, Networking, Storage, Key Vault, and App Services resource providers:

   ```xml
   <dependency>
   <groupId>com.microsoft.azure.profile_2019_03_01_hybrid</groupId>
   <artifactId>azure</artifactId>
   <vers1s.0.0-beta</version>
   </dependency>
   ```

7. In the command prompt that was open to set the environment variables, enter the following command:

   ```shell
   mvn clean compile exec:java
   ```

## Next steps

For more information about API profiles, see:

- [Version profiles in Azure Stack Hub](azure-stack-version-profiles.md)
- [Resource provider API versions supported by profiles](azure-stack-profiles-azure-resource-manager-versions.md)
