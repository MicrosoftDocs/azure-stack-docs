---
author: BryanLa
ms.author: bryanla
ms.service: azure-stack
ms.topic: include
ms.date: 10/10/2020
ms.reviewer: bryanla
ms.lastreviewed: 10/20/2020
---

Finally, determine the resource provider's latest deployment properties, which are used to complete the secret rotation process.

### Determine deployment properties

Resource providers are deployed into your Azure Stack Hub environment as a versioned product package. Packages are assigned a unique package ID, in the format `'microsoft.<product-id>.<installed-version>'`. Where `<product-id>` is a unique string representing the resource provider, and `<installed-version>` represents a specific version. The secrets associated with each package are stored in the Azure Stack Hub Key Vault service. 

Open an elevated PowerShell console and complete the following steps to determine the properties required to rotate the resource provider's secrets:

1. Sign in to your Azure Stack Hub environment using your operator credentials. See [Connect to Azure Stack Hub with PowerShell](../operator/azure-stack-powershell-configure-admin.md) for PowerShell sign-in script. Be sure to replace all placeholder values appropriate to your environment, such as endpoint URLs and directory tenant name.

2. Run the `Get-AzsProductDeployment` cmdlet to retrieve a list of the latest resource provider deployments. The returned `"value"` collection contains an element for each deployed resource provider. Find the resource provider of interest and make note of the values for these properties:
   - `"name"` - contains the resource provider product ID in the second segment of the value. 
   - `"properties"."deployment"."version"` - contains the currently deployed version number. 

   In the following example, notice the Event Hubs RP deployment in the first element in the collection, which has a product ID of `"microsoft.eventhub"`, and version `"1.2003.0.0"`:

   ```powershell
   PS C:\WINDOWS\system32> Get-AzsProductDeployment -AsJson
   VERBOSE: GET https://adminmanagement.myregion.mycompany.com/subscriptions/ze22ca96-z546-zbc6-z566-z35f68799816/   providers/Microsoft.Deployment.Admin/locations/global/productDeployments?api-version=2019-01-01 with 0-char payload
   VERBOSE: Received 2656-char response, StatusCode = OK
   {
       "value":  [
                     {
                         "id":  "/subscriptions/ze22ca96-z546-zbc6-z566-z35f68799816/providers/Microsoft.   Deployment.Admin/locations/global/productDeployments/microsoft.eventhub",
                         "name":  "global/microsoft.eventhub",
                         "type":  "Microsoft.Deployment.Admin/locations/productDeployments",
                         "properties":  {
                                            "status":  "DeploymentSucceeded",
                                            "subscriptionId":  "b37ae55a-a6c6-4474-ba97-81519412adf5",
                                            "deployment":  {
                                                               "version":  "1.2003.0.0",
                                                               "actionPlanInstanceResourceId":"/subscriptions/ze22ca96-z546-zbc6-z566-z35f68799816/providers/Microsoft.Deployment.Admin/locations/global/actionplans/abcdfcd3-fef0-z1a3-z85d-z6ceb0f31e36",
                                                               "parameters":  {
   
                                                                              }
                                                           },
                                            "lastSuccessfulDeployment":  {
                                                                             "version":  "1.2003.0.0",
                                                                             "actionPlanInstanceResourceId":"/subscriptions/ze22ca96-z546-zbc6-z566-z35f68799816/providers/Microsoft.Deployment.Admin/locations/global/actionplans/abcdfcd3-fef0-z1a3-z85d-z6ceb0f31e36",
                                                                             "parameters":  {
   
                                                                                            }
                                                                         },
                                            "provisioningState":  "Succeeded"
                                        }
                     },
                     {
                     ...
                     }
                 ]
   }
   ```

3. Build the resource provider's package ID, by concatenating the resource provider product ID and version. For example, using the values derived in the previous step, the Event Hubs RP package ID is `microsoft.eventhub.1.2003.0.0`. 

4. Run `Get-AzsProductSecret -PackageId` to retrieve the list of secret types being used by the package ID created in the previous step. In the returned `value` collection, find the entry containing a `"properties"."secretKind"` value of `"Certificate"`. This is the entry for the RP's certificate secret, which is identified by the last segment of the `"name"` property. 

   In the following example, the secrets collection returned for the Event Hubs RP contains a `"Certificate"` secret named `aseh-ssl-gateway-pfx`. 

   ```powershell
   PS C:\WINDOWS\system32> Get-AzsProductSecret -PackageId $packageId -AsJson
   VERBOSE: GET
   https://adminmanagement.myregion.mycompany.com/subscriptions/ze22ca96-z546-zbc6-z566-z35f68799816/providers/   Microsoft.Deployment.Admin/locations/global/productPackages/microsoft.eventhub.1.2003.0.0/secrets?   api-version=2019-
   01-01 with 0-char payload
   VERBOSE: Received 617-char response, StatusCode = OK
   {
       "value":  [
                     {
                         "id":  "/subscriptions/ze22ca96-z546-zbc6-z566-z35f68799816/providers/Microsoft.   Deployment.Admin/locations/global/productPackages/microsoft.eventhub.1.2003.0.0/secrets/   aseh-ssl-gateway-pfx",
                         "name":  "global/microsoft.eventhub.1.2003.0.0/aseh-ssl-gateway-pfx",
                         "type":  "Microsoft.Deployment.Admin/locations/productPackages/secrets",
                         "properties":  {
                                            "secretKind":  "Certificate",
                                            "description":  "Event Hubs gateway SSL certificate.",
                                            "expiresAfter":  "P730D",
                                            "secretDescriptor":  {
   
                                                                 },
                                            "secretState":  {
                                                                "status":  "Deployed",
                                                                "rotationStatus":  "None",
                                                                "expirationDate":  "2022-03-31T00:16:05.3068718Z"
                                                            },
                                            "provisioningState":  "Succeeded"
                                        }
                     },
                     ...
                 ]
   }
   ```

### Rotate the secrets

1. Use the `Set-AzsProductSecret` cmdlet to upload your new certificate to Key Vault, which will be used by the rotation process. Replace the variable placeholder values accordingly before running the script:

| Placeholder | Description | Example value |
| ----------- | ----------- | --------------|
| `<product-id>` | The product ID of the latest resource provider deployment. | `microsoft.eventhub` |
| `<installed-version>` | The version of the latest resource provider deployment. | `1.2003.0.0` |
| `$certSecretName` | The name under which the certificate secret is stored. | `aseh-ssl-gateway-pfx` |
| `$pfxFilePath` | The path to your certificate PFX file. | `C:\dir\eh-cert-file.pfx` |
| `$pfxPassword` | The password assigned to your certificate .PFX file. | `strong@CertSecret6` |

   ```powershell
   $productId = '<product-id>'
   $packageId = $productId + '.' + '<installed-version>'
   $certSecretName = '<cert-secret-name>' 
   $pfxFilePath = '<cert-pfx-file-path>'
   $pfxPassword = ConvertTo-SecureString '<pfxpassword>' -AsPlainText -Force   
   Set-AzsProductSecret -PackageId $packageId -SecretName $certSecretName -PfxFileName $pfxFilePath -PfxPassword    $pfxPassword -Force
   ```

2. Finally, use the `Invoke-AzsProductRotateSecretsAction` cmdlet to rotate the internal and external secrets:

```powershell
Invoke-AzsProductRotateSecretsAction -ProductId $productId
```

> [!NOTE]
> It takes approximately 3.5 - 4 hours to complete the rotation process.

