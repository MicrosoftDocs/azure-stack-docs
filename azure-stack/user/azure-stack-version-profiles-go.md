---
title: Use API version profiles with GO in Azure Stack Hub 
description: Learn how to use API version profiles with GO in Azure Stack Hub.
author: sethmanheim

ms.topic: article
ms.date: 01/23/2020
ms.author: sethm
ms.reviewer: sijuman
ms.lastreviewed: 05/26/2019

---

# Use API version profiles with Go in Azure Stack Hub

## Go and version profiles

A profile is a combination of different resource types with different versions from different services. Using a profile helps you mix and match between different resource types. Profiles can provide the following benefits:

- Stability for your app by locking to specific API versions.
- Compatibility for your app with Azure Stack Hub and regional Azure datacenters.

In the Go SDK, profiles are available under the profiles path. Profile version numbers are labeled in the **YYYY-MM-DD** format. The latest Azure Stack Hub API profile version is **2019-03-01** for Azure Stack Hub versions 1904 or later. To import a given service from a profile, import its corresponding module from the profile. For example, to import **Compute** service from **2019-03-01** profile, use the following code:

```go
import "github.com/Azure/azure-sdk-for-go/profiles/2019-03-01/compute/mgmt/compute"
```

## Install the Azure SDK for Go

1. Install Git. For instructions, see [Getting Started - Installing Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).
2. Install the [Go programming language](https://golang.org/dl). API profiles for Azure require Go version 1.9 or newer.
3. Install the Azure Go SDK and its dependencies by running the following bash command:

   ```bash
   go get -u -d github.com/Azure/azure-sdk-for-go/...
   ```

### The Go SDK

You can find more information about the Azure Go SDK at the following links:

- The Azure Go SDK at [Installing the Azure SDK for Go](/go/azure/azure-sdk-go-install).
- The Azure Go SDK is publicly available on GitHub in the [azure-sdk-for-go](https://github.com/Azure/azure-sdk-for-go) repository.

### Go-AutoRest dependencies

The Go SDK depends on the Azure **Go-AutoRest** modules to send REST requests to Azure Resource Manager endpoints. You must import the Azure **Go-AutoRest** module dependencies from [Azure Go-AutoRest on GitHub](https://github.com/Azure/go-autorest). You can find the install bash commands in the **Install** section.

## How to use Go SDK profiles on Azure Stack Hub

To run a sample of Go code on Azure Stack Hub, follow these steps:

1. Install the Azure SDK for Go and its dependencies. For instructions, see the previous section, [Install Azure SDK for Go](#install-the-azure-sdk-for-go).
2. Get the metadata info from the Resource Manager endpoint. The endpoint returns a JSON file with the info required to run your Go code.

   > [!NOTE]  
   > The **ResourceManagerUrl** in the Azure Stack Development Kit (ASDK) is: `https://management.local.azurestack.external/`  
   > The **ResourceManagerUrl** in integrated systems is: `https://management.<region>.<fqdn>/`  
   > To retrieve the metadata required: `<ResourceManagerUrl>/metadata/endpoints?api-version=1.0`
  
   Sample JSON file:

   ```json
   { "galleryEndpoint": "https://portal.local.azurestack.external:30015/",  
     "graphEndpoint": "https://graph.windows.net/",  
     "portal Endpoint": "https://portal.local.azurestack.external/",
     "authentication": {
       "loginEndpoint": "https://login.windows.net/",
       "audiences": ["https://management.<yourtenant>.onmicrosoft.com/3cc5febd-e4b7-4a85-a2ed-1d730e2f5928"]
     }
   }
   ```

3. If not available, create a subscription and save the subscription ID to be used later. For info on creating a subscription, see [Create subscriptions to offers in Azure Stack Hub](../operator/azure-stack-subscribe-plan-provision-vm.md).

4. Create a service principal that uses a client secret, with **Subscription** scope and **Owner** role. Save the service principal ID and secret. For information about creating a service principal for Azure Stack Hub, see [Use an app identity to access resources](../operator/azure-stack-create-service-principals.md). Your Azure Stack Hub environment is now set up.

5. Import a service module from the Go SDK profile in your code. The current version of Azure Stack Hub profile is **2019-03-01**. For example, to import a network module from the **2019-03-01** profile type, use the following code:

   ```go
   package main
    import "github.com/Azure/azure-sdk-for-go/profiles/2019-03-01/network/mgmt/network"
   ```

6. In your function, create and authenticate a client with a **New** client function call. To create a virtual network client, use the following code:  

   ```go
   package main

   import "github.com/Azure/azure-sdk-for-go/profiles/2019-03-01/network/mgmt/network"

   func main() {
      vnetClient := network.NewVirtualNetworksClientWithBaseURI("<baseURI>", "(subscriptionID>")
      vnetClient.Authorizer = autorest.NewBearerAuthorizer(token)
   ```

   Set `<baseURI>` to the **ResourceManagerUrl** value used in step 2. Set `<subscriptionID>` to the **SubscriptionID** value saved from step 3.

   To create the token, see the next section.  

7. Invoke API methods by using the client that you created in the previous step. For example, to create a virtual network by using the client from the previous step, see the following example:

   ```go
   package main

   import "github.com/Azure/azure-sdk-for-go/profiles/2019-03-01/network/mgmt/network"
   func main() {
   vnetClient := network.NewVirtualNetworksClientWithBaseURI("<baseURI>", "(subscriptionID>")
   vnetClient .Authorizer = autorest.NewBearerAuthorizer(token)

   vnetClient .CreateOrUpdate( )
   ```

For a complete example of creating a virtual network on Azure Stack Hub by using the Go SDK profile, see the [example](#example).

## Authentication

To get the **Authorizer** property from Azure Active Directory using the Go SDK, install the **Go-AutoRest** modules. These modules should have been already installed with the "Go SDK" installation. If they aren't, install the [authentication package from GitHub](https://github.com/Azure/go-autorest/tree/master/autorest/adal).

The Authorizer must be set as the authorizer for the resource client. There are different ways to get authorizer tokens on Azure Stack Hub by using client credentials:

1. If a service principal with owner role on the subscription is available, skip this step. Otherwise, see [Use an app identity to access resources](../operator/azure-stack-create-service-principals.md) for instructions on creating a service principal that uses a client secret, and for help on how to assign it an "owner" role scoped to your subscription. Be sure to capture the service principal application ID and secret.

2. Import the **adal** package from **Go-AutoRest** in your code.

   ```go
   package main
   import "github.com/Azure/go-autorest/autorest/adal"
   ```

3. Create an **oauthConfig** by using NewOAuthConfig method from **adal** module.

   ```go
   package main

   import "github.com/Azure/go-autorest/autorest/ada1"

   func CreateToken() (adal.OAuthTokenProvider, error) {
      var token adal.OAuthTokenProvider
      oauthConfig, err := adal.NewOAuthConfig(activeDirectoryEndpoint, tenantID)
   }
   ```

   Set `<activeDirectoryEndpoint>` to the value of the `loginEndpoint` property from the `ResourceManagerUrl` metadata retrieved on the previous section of this document. Set the `<tenantID>` value to your Azure Stack Hub tenant ID.

4. Finally, create a service principal token by using the `NewServicePrincipalToken` method from the **adal** module:

   ```go
   package main

   import "github.com/Azure/go-autorest/autorest/adal"

   func CreateToken() (adal.OAuthTokenProvider, error) {
       var token adal.OAuthTokenProvider
       oauthConfig, err := adal.NewOAuthConfig(activeDirectoryEndpoint, tenantID)
       token, err = adal.NewServicePrincipalToken(
           *oauthConfig,
           clientID,
           clientSecret,
           activeDirectoryResourceID)
       return token, err
   ```

    Set `<activeDirectoryResourceID>` to one of the values in the "audience" list from the **ResourceManagerUrl** metadata retrieved in the previous section of this article.
    Set `<clientID>` to the service principal application ID saved when the service principal was created in the previous section of this article.
    Set `<clientSecret>` to the service principal application secret saved when the service principal was created in the previous section of this article.

## Example

This example shows a sample of Go code that creates a virtual network on Azure Stack Hub. For complete examples of the Go SDK, see the [Azure Go SDK samples repository](https://github.com/Azure-Samples/azure-sdk-for-go-samples). Azure Stack Hub samples are available under the hybrid path inside service folders of the repository.

> [!NOTE]  
> To run the code in this example, verify that the subscription used has the **Network** resource provider listed as **Registered**. To verify, look for the subscription in the Azure Stack Hub portal, and select **Resource providers.**

1. Import the required packages in your code. Use the latest available profile on Azure Stack Hub to import the network module:

   ```go
   package main

   import (
       "context"
       "fmt"
       "github.com/Azure/azure-sdk-for-go/profiles/2019-03-01/network/mgmt/network"
       "github.com/Azure/go-autorest/autorest"
       "github.com/Azure/go-autorest/autorest/adal"
       "github.com/Azure/go-autorest/autorest/to"
   )
   ```

2. Define your environment variables. To create a virtual network, you must have a resource group.

   ```go
   var (
       activeDirectoryEndpoint = "yourLoginEndpointFromResourceManagerUrlMetadata"
       tenantID = "yourAzureStackTenantID"
       clientID = "yourServicePrincipalApplicationID"
       clientSecret = "yourServicePrincipalSecret"
       activeDirectoryResourceID = "yourAudienceFromResourceManagerUrlMetadata"
       subscriptionID = "yourSubscriptionID"
       baseURI = "yourResourceManagerURL"
       resourceGroupName = "existingResourceGroupName"
   )
   ```

3. Now that you've defined your environment variables, add a method to create an authentication token by using the **adal** package. For more info on authentication, see the previous section.

   ```go
   //CreateToken creates a service principal token
   func CreateToken() (adal.OAuthTokenProvider, error) {
      var token adal.OAuthTokenProvider
      oauthConfig, err := adal.NewOAuthConfig(activeDirectoryEndpoint, tenantID)
      token, err = adal.NewServicePrincipalToken(
          *oauthConfig,
          clientID,
          clientSecret,
          activeDirectoryResourceID)
      return token, err
   }
   ```

4. Add the `main` method. The `main` method first gets a token by using the method that is defined in the previous step. Then, it creates a client by using a network module from the profile. Finally, it creates a virtual network.

   ```go
   package main

   import (
      "context"
      "fmt"
      "github.com/Azure/azure-sdk-for-go/profiles/2019-03-01/network/mgmt/network"
      "github.com/Azure/go-autorest/autorest"
      "github.com/Azure/go-autorest/autorest/adal"
      "github.com/Azure/go-autorest/autorest/to"
   )

   var (
      activeDirectoryEndpoint = "yourLoginEndpointFromResourceManagerUrlMetadata"
      tenantID = "yourAzureStackTenantID"
      clientID = "yourServicePrincipalApplicationID"
      clientSecret = "yourServicePrincipalSecret"
      activeDirectoryResourceID = "yourAudienceFromResourceManagerUrlMetadata"
     subscriptionID = "yourSubscriptionID"
     baseURI = "yourResourceManagerURL"
     resourceGroupName = "existingResourceGroupName"
   )

   //CreateToken creates a service principal token
   func CreateToken() (adal.OAuthTokenProvider, error) {
      var token adal.OAuthTokenProvider
      oauthConfig, err := adal.NewOAuthConfig(activeDirectoryEndpoint, tenantID)
      token, err = adal.NewServicePrincipalToken(
          *oauthConfig,
          clientID,
          clientSecret,
          activeDirectoryResourceID)
      return token, err
   }

   func main() {
      token, _ := CreateToken()
      vnetClient := network.NewVirtualNetworksClientWithBaseURI(baseURI, subscriptionID)
      vnetClient.Authorizer = autorest.NewBearerAuthorizer(token)
      future, _ := vnetClient.CreateOrUpdate(
          context.Background(),
          resourceGroupName,
          "sampleVnetName",
          network.VirtualNetwork{
              Location: to.StringPtr("local"),
              VirtualNetworkPropertiesFormat: &network.VirtualNetworkPropertiesFormat{
                  AddressSpace: &network.AddressSpace{
                      AddressPrefixes: &[]string{"10.0.0.0/8"},
                  },
                  Subnets: &[]network.Subnet{
                      {
                          Name: to.StringPtr("subnetName"),
                          SubnetPropertiesFormat: &network.SubnetPropertiesFormat{
                              AddressPrefix: to.StringPtr("10.0.0.0/16"),
                          },
                      },
                  },
              },
          })
      err := future.WaitForCompletionRef(context.Background(), vnetClient.Client)
      if err != nil {
          fmt.Printf(err.Error())
          return
      }
   }
   ```

Some of the code samples available for Azure Stack Hub using the Go SDK are:

- [Create Virtual machine](https://github.com/Azure-Samples/Hybrid-Compute-Go-Create-VM)
- [Storage Dataplane](https://github.com/Azure-Samples/Hybrid-Storage-Go-Dataplane)
- [Use Managed Disks](https://github.com/Azure-Samples/Hybrid-Compute-Go-ManagedDisks) (a sample that uses 2019-03-01 profile which targets the latest API versions supported by Azure Stack Hub)

## Next steps

- [Install PowerShell for Azure Stack Hub](../operator/azure-stack-powershell-install.md)
- [Configure the Azure Stack Hub user's PowerShell environment](azure-stack-powershell-configure-user.md)
