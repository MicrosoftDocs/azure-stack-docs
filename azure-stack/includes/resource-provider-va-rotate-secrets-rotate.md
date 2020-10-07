---
author: BryanLa
ms.author: bryanla
ms.service: azure-stack
ms.topic: include
ms.date: 10/10/2020
ms.reviewer: bryanla
ms.lastreviewed: 10/10/2020
---

Resource providers are deployed as a versioned product package into your Azure Stack Hub environment. Packages are assigned a unique package ID, in the format `'microsoft.<resource-provider>.<installed-version>'`. Where `<resource-provider>` represents the name of the resource provider, and `<installed-version>` represents a specific version in the format of `n.nnnn.n.n`. The secrets associated with each package are maintained in the Azure Stack Hub Key Vault service. 

Open an elevated PowerShell console and complete the following steps to rotate the resource provider (RP) secrets:

1. Sign in to your Azure Stack Hub environment using your operator credentials. See [Connect to Azure Stack Hub with PowerShell](../operator/azure-stack-powershell-configure-admin.md) for PowerShell script appropriate for your environment. Be sure to replace all placeholder values before running the appropriate script, such as endpoint URLs and your directory tenant name.

2. Run the `Get-AzsProductDeployment` cmdlet to retrieve the names and versions of the latest deployments of all resource providers. The following example shows only the first element returned in the `"value"` collection, which is for the Event Hubs RP deployment:
- The `"value"."name"` property contains the resource provider name in the second segment, ie: `"microsoft.eventhub"`. 
- The `"value"."properties"."deployment"."version"` property contains the currently deployed version number, ie: `"1.2003.0.0"`

```powershell
PS C:\WINDOWS\system32> Get-AzsProductDeployment -AsJson
VERBOSE: GET https://adminmanagement.bellevue.azurestack.corp.microsoft.com/subscriptions/ze22ca96-z546-zbc6-z566-z35f68799816/providers/Microsoft.Deployment.Admin/locations/global/productDeployments?api-version=2019-01-01 with 0-char payload
VERBOSE: Received 2656-char response, StatusCode = OK
{
    "value":  [
                  {
                      "id":  "/subscriptions/ze22ca96-z546-zbc6-z566-z35f68799816/providers/Microsoft.Deployment.Admin/locations/global/productDeployments/microsoft.eventhub",
                      "name":  "global/microsoft.eventhub",
                      "type":  "Microsoft.Deployment.Admin/locations/productDeployments",
                      "properties":  {
                                         "status":  "DeploymentSucceeded",
                                         "subscriptionId":  "b37ae55a-a6c6-4474-ba97-81519412adf5",
                                         "deployment":  {
                                                            "version":  "1.2003.0.0",
                                                            "actionPlanInstanceResourceId":  "/subscriptions/9e22ca99-854f-4bcb-956a-135f68799815/providers/Microsoft.Deployment.Admin/locations/global/actionplans/ab23fcd3-fef0-41a3-885d-e6ceb0f31e34",
                                                            "parameters":  {

                                                                           }
                                                        },
                                         "lastSuccessfulDeployment":  {
                                                                          "version":  "1.2003.0.0",
                                                                          "actionPlanInstanceResourceId":  "/subscriptions/9e22ca99-854f-4bcb-956a-135f68799815/providers/Microsoft.Deployment.Admin/locations/global/actionplans/ab23fcd3-fef0-41a3-885d-e6ceb0f31e34",
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

3. Build the resource provider's package ID, by concatenating the resource provider name and version. For example, using the values derived in the previous step, the Event Hubs RP package ID is `microsoft.eventhub.1.2003.0.0`. 

```powershell
$productId = 'microsoft.eventhub' # From Get-AzsProductDeployment 
$productVersion = '1.2003.0.0'
$packageId = ('{0}.{1}' -f $productId, $productVersion)
```

4. Using the `Get-AzsProductSecret` cmdlet, determine the secret name assigned to your RP's certificate. Find the entry in the `value` collection with a `"properties"."secretKind"` value of `"Certificate"`. Copy the last segment of the `"name"` property, for example `aseh-ssl-gateway-pfx`. 

```powershell
PS C:\WINDOWS\system32> Get-AzsProductSecret -PackageId $packageId -AsJson
VERBOSE: GET
https://adminmanagement.myregion.mycompany.com/subscriptions/ze22ca96-z546-zbc6-z566-z35f68799816/providers/Microsoft.Deployment.Admin/locations/global/productPackages/microsoft.eventhub.1.2003.0.0/secrets?api-version=2019-
01-01 with 0-char payload
VERBOSE: Received 617-char response, StatusCode = OK
{
    "value":  [
                  {
                      "id":  "/subscriptions/ze22ca96-z546-zbc6-z566-z35f68799816/providers/Microsoft.Deployment.Admin/locations/global/productPackages/microsoft.eventhub.1.2003.0.0/secrets/aseh-ssl-gateway-pfx",
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
5. Use the `Set-AzsProductSecret` cmdlet to upload your new certificate to Key Vault. Replace the variable placeholder values accordingly before running the script:

| Variable | Description | Example value |
| -------- | ----------- | --------------|
| `$certSecretName` | The name under which the certificate secret is stored. | The Event Hubs RP uses `'aseh-ssl-gateway-pfx'`. |
| `$PackageId` | The resource provider package name in the format `'Microsoft.<resource-provider>.<installed-version>'`, where `<resource-provider>` is one of the following values:<br>- `Eventhub`. | `'Microsoft.Eventhub.1.2003.0.0'` |
| `$pfxPassword` | The password given to your certificate .PFX file. | `'strong@CertSecret6'` |
| `$sslCertPath` | The path to your certificate PFX file. | `'\\machine\dir\cert-file.pfx'` |

```powershell
$certName = '<cert-subject-name>' 
$pfxPassword = ConvertTo-SecureString '<pfxpassword>' -AsPlainText -Force   
$PackageId = 'Microsoft.<resource-provider>.<installed-version>'
$sslCertPath = '<cert-pfx-file-path>'
Set-AzsProductSecret -PackageId $PackageId -SecretName $certName -PfxFileName $sslCertPath -PfxPassword $pfxPassword -Force
```

```powershell
# Initialize resource provider variables
$productId = 'microsoft.eventhub'
$productVersion = (Get-AzsProductDeployment -ProductId $productId).properties.deployment.version
$packageId = ('{0}.{1}' -f $productId, $productVersion)
$certSecretName = ((Get-AzsProductSecret -PackageId $packageId).value.name).split('/')[2]
$certPath = 'C:\dir\new-cert.pfx'

```


3. Finally, use the `Invoke-AzsProductRotateSecretsAction` cmdlet to rotate the internal and external secrets:

```powershell
$ProductId = 'Microsoft.Eventhub'
Invoke-AzsProductRotateSecretsAction -ProductId $ProductId
```

> [!NOTE]
> It takes approximately 3.5 - 4 hours to complete the rotation process.

