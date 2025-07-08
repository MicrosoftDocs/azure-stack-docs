---
title: Deploy disconnected operations for Azure Local (Preview)
description: Learn how to deploy disconnected operations for Azure Local in your datacenter (preview).
ms.topic: how-to
author: ronmiab
ms.author: robess
ms.date: 04/22/2025
---

# Deploy disconnected operations for Azure Local (preview)

::: moniker range=">=azloc-24112"

[!INCLUDE [applies-to:](../includes/release-2411-1-later.md)]

This article provides you with steps to deploy Azure Local with disconnected operations in your datacenter. You can determine the Azure Local topology, prepare the first machine for the disconnected operations appliance, install the appliance, and create the Azure Local instance.

## Key considerations

When deploying Azure Local with disconnected operations, consider the following key points:

- Ensure that your network configuration and the names entered in the portal are consistent with your setup and the previously created switches.
- Virtual deployments aren't supported. Physical machines are required.
- A minimum of three machines is required to support disconnected operations. Up to 8 machines are supported.
- The deployment of the Azure Local cluster may take several hours.
- The local control plane may experience periods of downtime during node reboots and updates.
- During the creation of the cluster, a thinly provisioned 2-TB infrastructure volume is created for disconnected operations. Do not tamper with or delete the infrastructure volumes created during the deployment process.
- Upon the creation of the Azure Local cluster, the disconnected operations VM appliance is moved to cluster storage and converted to a clustered VM.

## Prerequisites

|Requirements                | Details      |
|----------------------------|--------------|
| Hardware                   | [Plan and understand the hardware](disconnected-operations-overview.md#preview-participation-criteria) |
| Identity                   | [Plan and understand the identity](disconnected-operations-identity.md) |
| Networking                 | [Plan and understand the networking](disconnected-operations-network.md) |
| Public key infrastructure  | [Plan and understand the public key infrastructure (PKI)](disconnected-operations-pki.md) |
| Set up                     | [Set up disconnected operations for Azure Local](disconnected-operations-set-up.md) |

For more information, see [Azure Local disconnected operations overview](disconnected-operations-overview.md).

## Deployment checklist

Here's a checklist of things you need before you deploy Azure Local with disconnected operations:

- Network plan:
  - IP pool, Ingress IP, Fully Qualified Domain Name (FQDN), Domain name system (DNS), and Gateway (GW).
- DNS server to resolve IP to FQDN names.
- Local credentials for Azure Local machines.
- Active directory credentials for Azure Local deployment.
- [Active directory prepared for Azure Local deployment](../deploy/deployment-prep-active-directory.md).
- Certificates to secure ingress endpoints (26 certificates) and the public key (root) used to create these certificates.
- Certificates to secure the management endpoint (2 certificates).
- Credentials and parameters to integrate with identity provider:
  - Active Directory Federations Services (ADFS) application, credentials, server details, and certificate chain details for certificates used in identity configuration.
- Disconnected operations deployment files (manifest and appliance).
- The preview ISO (accompanying release 2411.2 or later).
- Firmware/device drivers from OEM.

## Deployment sequence  

In this preview, you can deploy Azure Local with disconnected operations on non-premier hardware stock keeping units (SKUs). For more information, see [Azure Local Catalog](https://azurelocalsolutions.azure.microsoft.com/).

You deploy and configure Azure Local with disconnected operations in multiple steps. The following image shows the overall journey, including post-deployment.

:::image type="content" source="./media/disconnected-operations/deployment/deployment-journey.png" alt-text="Screenshot of the deployment flow." lightbox=" ./media/disconnected-operations/deployment/deployment-journey.png":::

Here's a brief overview of the tools and processes used during the deployment. Access to Azure Local nodes (OS/host) might be required.

1. Use the existing tools and processes to install and configure the OS. You'll need Local admin access on all Azure Local nodes.
2. Run PowerShell and the Operations module on the first node (sorted by node name like `seed node`). You'll need Local admin access.
3. Use the local Azure portal or Azure CLI. You don't need physical node access, but you do need Azure Role-Based Access Control (RBAC) with the **Owner role**.
4. Use the local Azure portal or Azure CLI. You don't need physical node access, but you do need Azure RBAC with the **Operator role**.

## Prepare Azure Local machines  

To prepare each machine for the disconnected operations appliance, follow these steps:

1. Download the preview ISO (2411.2 and later).  

2. Install the OS and configure the node networking for each Azure Local machine you intend to use to form an instance. For more information, see [Install the Azure Stack HCI operating system](../deploy/deployment-install-os.md).  

3. On physical hardware, install firmware and drivers as instructed by your OEM.

4. Set up the virtual switches according to your planned network:  
   - [Network considerations for cloud deployments of Azure Local](../plan/cloud-deployment-network-considerations.md).
   - If your network plan groups all traffic (management, compute, and storage), create a virtual switch called `ConvergedSwitch(ManagementComputeStorage)` on each node.  

     ```powershell
      # Example
      $networkIntentName = 'ManagementComputeStorage'
      New-VMSwitch -Name "ConvergedSwitch($networkIntentName)" -NetAdapterName "ethernet","ethernet 2"  
     ```
   
   - If you use VLANs make sure you set the network adapter VLAN
   
     ```powershell
     Set-NetAdapter -Name "ethernet 1" -VlanID 10
     ```

5. [Rename each node](/powershell/module/microsoft.powershell.management/rename-computer?view=powershell-7.4&preserve-view=true) according to your naming conventions. For example, azlocal-n1, azlocal-n2, and azlocal-n3.  

6. On each node, copy the root certificate public key. For more information, see [PKI for disconnected operations](disconnected-operations-pki.md). Modify the paths according to the location and method you use to export your public key for creating certificates.  

    ```powershell
    $applianceConfigBasePath = "C:\AzureLocalDisconnectedOperations\"
    $applianceRootCertFile = "C:\AzureLocalDisconnectedOperations\applianceRoot.cer"
    
    New-Item -ItemType Directory $applianceConfigBasePath
    Copy-Item \\fileserver\share\azurelocalcerts\publicroot.cer $applianceRootCertFile
 
7. Copy to the **APPData/Azure** Local folder and name it **azureLocalRootCert**. Use this information during the Arc appliance deployment.  

    ```powershell
    Copy-Item \\fileserver\share\azurelocalcerts\publicroot.cer $($env:APPDATA)\AzureLocal\AzureLocalRootCert.cer
    ```

8. On each node, import the public key into the local store:

    ```powershell
    Import-Certificate -FilePath $applianceRootCertFile -CertStoreLocation Cert:\LocalMachine\Root -Confirm:$false
    ```

    > [!NOTE]
    > If you use a different root for the management certificate, repeat the process and import this key on each node.

9. Find the first machine from the list of node names and specify it as the `seednode` you want to use in the cluster.

    ```powershell
    $seednode = @(‘azlocal-1, ‘azlocal-2,’ azlocal-3’)|Sort|select –first 1
    $seednode
    ```

    > [!NOTE]
    > Make sure you deploy disconnected operations on this node.
   
## Deploy disconnected operations

Disconnected operations must be deployed on the seed node (first machine). To ensure the following steps are done on the first machine, see [Prepare Azure Local machines](#prepare-azure-local-machines).

To prepare the first machine for the disconnected operations appliance:

1. Copy the disconnected operations installation files (appliance and manifest) to the first machine. Save these files into the base folder you created earlier.  

    ```powershell  
    Copy-Item \\fileserver\share\azurelocalfiles\AzureLocal.DisconnectedOperations.zip $applianceConfigBasePath  
    Copy-Item \\fileserver\share\azurelocalfiles\AzureLocal.DisconnectedOperations.Appliance.manifest  $applianceConfigBasePath  
    ```  

2. Verify that you have these two files in your base folder using the following command:

    - AzureLocal.DisconnectedOperations.zip
    - AzureLocal.DisconnectedOperations.Appliance.manifest

      ```powershell  
      Get-ChildItem $applianceConfigBasePath  
      ```  

3. Extract the zip file in the same folder:  

    ```powershell  
    Expand-Archive "$($applianceConfigBasePath)\AzureLocal.DisconnectedOperations.zip" -DestinationPath $applianceConfigBasePath  
    ```  

4. Verify that you have these three files using the following command:

    - OperationsModule (PowerShell module for installation)
    - IRVM01.zip
    - AzureLocal.DisconnectedOperations.Appliance.manifest

      ```powershell  
      Get-ChildItem $applianceConfigBasePath   
      ```  

      > [!NOTE]  
      > At this point, you can remove the `AzureLocal.DisconnectedOperations.zip` file to save some space.

5. Copy the certificates root directory. Save these files into the base folder you created earlier.  

    ```powershell  
    $certsPath = "$($applianceConfigBasePath)\certs"  
    Copy-Item \\fileserver\share\azurelocalcerts $certspath -recurse  
    ```

6. Verify the certificates, public key, and management endpoint. You should have two folders: `ManagementEndpointCerts` and `IngressEndpointCerts` and at least 26 certificates.

    ```powershell  
    Get-ChildItem $certsPath 
    Get-Item $certsPath -recurse -filter *.cer  
    ```  

7. Install the BitLocker feature including the management tool.

    ```powershell
    Install-WindowsFeature BitLocker -IncludeAllSubFeature -IncludeManagementTools
    ```

8. Import the **Operations module**. Run the command as an administrator using PowerShell. Modify the path to match your folder structure:

    ```powershell  
    Import-Module "$applianceConfigBasePath \OperationsModule\Azure.Local.DisconnectedOperations.psd1" -Force
    $mgmntCertFolderPath = "$certspath\ManagementEndpointCerts"  
    $ingressCertFolderPath = "$certspath\IngressEndpointCerts"  
    ```

## Initialize the parameters

Populate the required parameters based on your deployment planning. Modify the examples to match your configuration.

1. Populate the management network configuration object.

    ```powershell  
    $CertPassword = "retracted"|ConvertTo-Securestring -AsPlainText -Force  
    $ManagementIngressIpAddress = "192.168.50.100"  
    $ManagementNICPrefixLength = 24  
    $mgmtNetworkConfigParams = @{  
        ManagementIpAddress = $ManagementIngressIpAddress  
        ManagementIpv4PrefixLength = $ManagementNICPrefixLength  
        TlsCertificatePath = "$mgmntCertFolderPath\ManagementEndpointSsl.pfx"  
        TlsCertificatePassword = $CertPassword  
        ClientCertificatePath = "$mgmntCertFolderPath\ManagementEndpointClientAuth.pfx"  
        ClientCertificatePassword = $CertPassword  
    }  
    $managementNetworkConfiguration = New-ApplianceManagementNetworkConfiguration @mgmtNetworkConfigParams  
    ```  

    > [!NOTE]  
    > The password for the certificates must be in the secure string format. For certificates pertaining to the management endpoint, see [PKI for disconnected operations](disconnected-operations-pki.md).

2. Populate the ingress network configuration object.

    ```powershell  
    $azureLocalDns = "192.168.0.150"  
    $NodeGw = "192.168.0.1"  
    $IngressIpAddress = "192.168.0.100"  
    $NICPrefixLength= 24  
    $ingressNetworkConfigurationParams = @{  
        DnsServer = $azureLocalDns  
        IngressNetworkGateway = $NodeGw  
        IngressIpAddress = $IngressIpAddress  
        IngressNetworkPrefixLength = $NICPrefixLength  
        ExternalDomainSuffix = "autonomous.cloud.private"
    }  
    $ingressNetworkConfiguration = New-ApplianceIngressNetworkConfiguration @ingressNetworkConfigurationParams  
    ```  

    For network configuration details, see [Networking for disconnected operations](disconnected-operations-network.md).

3. Populate the identity configuration object.

    ```powershell  
    $identityParams = @{  
        Authority = "https://adfs.azurestack.local/adfs"  
        ClientId = "7e7655c5-9bc4-45af-8345-afdf6bbe2ec1"  
        RootOperatorUserPrincipalName = "operator@azurestack.local"  
        LdapServer = "adfs.azurestack.local"  
        LdapCredential = New-Object PSCredential -ArgumentList @("ldap", $ldapPassword)  
        SyncGroupIdentifier = "7d67fcd5-c2f4-4948-916c-b77ea7c2712f"  
        LdapsCertChainInfo="MIIF......"  
        OidcCertChainInfo="MIID......"  
    }  
    $identityConfiguration = New-ApplianceExternalIdentityConfiguration @identityParams  
    ```  

    > [!NOTE]  
    > `LdapsCertChainInfo` and `OidcCertChain` can be omitted completely for debugging/demo purposes.

    For more information, see [Identity for disconnected operations](disconnected-operations-identity.md).  

4. Populate the external certificates configuration object.

    ```powershell  
    $ingressCertPassword = "retracted"|ConvertTo-Securestring -AsPlainText -Force  
    $certsParams = @{  
        certificatesFolder = $ingressCertFolderPath  
        certificatePassword = $ingressCertPassword  
    }  
    $CertificatesConfiguration = New-ApplianceCertificatesConfiguration @certsParams  
    ```  

    For more information, see [PKI for disconnected operations](disconnected-operations-pki.md).

5. Generate the appliance manifest file:

    ```powershell
    $stampId = (New-Guid).Guid
    $resourcename = "appliance1"
    $resourcegroupname= "rg"
    $subscriptionId= "subscriptionid"

    $applianceManifest = @{  
        resourceId = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Edge/azurelocaldisconnected/$resourceName"  
        resourceName = $resourceName  
        stampId = $stampId  
        location = "eastus"  
        billingModel = "model"  
        connectionIntent = "Disconnected"  
    }  
    $applianceManifestJsonPath = "$applianceConfigBasePath\AzureLocal.DisconnectedOperations.Appliance.manifest.json"  
    $applianceManifest | ConvertTo-JSON | Out-File $ApplianceManifestJsonPath | Out-Null  
    ```  

## Validate the management endpoint certificates

Before you install the appliance, validate the management endpoint certificates. Ensure that the certificate has a validated certificate chain, isn't expired, has the correct subject, the appropriate enhanced key usage (EKUs), and the supported cryptography.

Run the following script:

```powershell
function Test-SSLCertificateSAN {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$HostName,

        [Parameter(Mandatory = $true)]
        [System.Security.Cryptography.X509Certificates.X509Certificate2]$SslCertificate
    )

    $sanExtension = $SslCertificate.Extensions | Where-Object { $_.Oid.FriendlyName -ieq "Subject Alternative Name" }

    if (-not $sanExtension) {
        throw "Subject Alternative Name is not specified in the certificate. Please correct the certifcate and try again."
    }

    $sanExtensionContent = $sanExtension.Format(0)
    $sanList = $sanExtensionContent.Split(",") | ForEach-Object { $_.Trim() }
    
    if ($sanList -inotcontains "DNS Name=$HostName") {
        throw "Subject Alternative Name does not contain the hostname $HostName. It only has Subject Alternative Name: $sanExtensionContent. Please correct the certificate and try again."
    }
}

function Test-SSLCertificateChain {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.Security.Cryptography.X509Certificates.X509Certificate2]$SslCertificate
    )

    $chain = New-Object System.Security.Cryptography.X509Certificates.X509Chain
    $chain.ChainPolicy.RevocationMode = [System.Security.Cryptography.X509Certificates.X509RevocationMode]::NoCheck
    $chain.ChainPolicy.VerificationFlags = [System.Security.Cryptography.X509Certificates.X509VerificationFlags]::NoFlag

    $chain.Build($SslCertificate) | Out-Null

    if ($chain.ChainStatus.Count -ne 0) {
        throw "Certificate chain validation failed with error message: `r`n$(($chain.ChainStatus).StatusInformation -Join "`r`n")Please correct the certificate chain and try again."
    }
}

function Test-SslCertificateEnhancedKeyUsage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.Security.Cryptography.X509Certificates.X509Certificate2]$SslCertificate
    )

    $extensions = $SslCertificate.Extensions | Where-Object { $_ -is [System.Security.Cryptography.X509Certificates.X509EnhancedKeyUsageExtension] }
    $serverAuthenticationValue = "1.3.6.1.5.5.7.3.1"
    $serverAuth = $extensions.EnhancedKeyUsages | Where-Object { $_.Value -ieq $serverAuthenticationValue }

    if (-not $serverAuth) {
        throw "Certificate does not have Server Authentication Enhanced Key Usage. Please correct the certificate and try again."
    }
}

function Test-SslCertificateCrypto {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.Security.Cryptography.X509Certificates.X509Certificate2]$SslCertificate
    )

    if ($SslCertificate.PublicKey.Oid.FriendlyName -eq "RSA") {
        if ($SslCertificate.PublicKey.Key.KeySize -lt 2048) {
            throw "Weak RSA Key: Upgrade to at least 2048-bit"
        } else {
            Write-Verbose "RSA Key is secure ($($SslCertificate.PublicKey.Key.KeySize) bits)"
        }
    }

    if ($SslCertificate.PublicKey.Oid.FriendlyName -match "ECDSA") {
        $validCurves = @("ECDSA_P256", "ECDSA_P384", "ECDSA_P521")
        if ($validCurves -contains $SslCertificate.PublicKey.Oid.FriendlyName) {
            Write-Verbose "ECDSA with $($SslCertificate.PublicKey.Oid.FriendlyName) curve is secure"
        } else {
            throw "Weak ECDSA Curve: Use P-256, P-384, or P-521"
        }
    }

    if ($SslCertificate.SignatureAlgorithm.FriendlyName -match "sha1") {
        throw "Weak Signature Algorithm: Upgrade to SHA-256 or higher"
    }
}

# Test SSL Certificate for Management cert
$HostName = $ManagementNetworkConfiguration.ManagementIpAddress
$SslCertificate = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new(`
            $ManagementNetworkConfiguration.TlsCertificatePath,
            $ManagementNetworkConfiguration.TlsCertificatePassword)

$currentDate = Get-Date
if ($currentDate -lt $SslCertificate.NotBefore) {
    throw "Certificate is not yet valid (future start date). Please correct the certificate and try again."
} elseif ($currentDate -gt $SslCertificate.NotAfter) {
    throw "Certificate has expired. Please correct the certificate and try again."
}

Test-SSLCertificateSAN -HostName $HostName -SslCertificate $SslCertificate | Out-Null
Test-SSLCertificateChain -SslCertificate $SslCertificate | Out-Null
Test-SslCertificateEnhancedKeyUsage -SslCertificate $SslCertificate | Out-Null
Test-SslCertificateCrypto -SslCertificate $SslCertificate | Out-Null


```

## Install and configure the appliance  

To install and configure the appliance on the first machine (seed node), use the following command. Point the `AzureLocalInstallationFile` to a path that contains the **IRVM01.zip**.

```powershell
$azureLocalInstallationFile = "$($applianceConfigBasePath)"  

$installAzureLocalParams = @{  
    Path = $azureLocalInstallationFile  
    IngressNetworkConfiguration = $ingressNetworkConfiguration  
    ManagementNetworkConfiguration = $managementNetworkConfiguration  
    IngressSwitchName = "ConvergedSwitch($networkIntentName)"  
    ManagementSwitchName = "ConvergedSwitch($networkIntentName)"  
    ApplianceManifestFile = $applianceManifestJsonPath  
    IdentityConfiguration = $identityConfiguration  
    CertificatesConfiguration = $CertificatesConfiguration  
    TimeoutSec = 7200  
    DisableCheckSum = $false  
    AutoScaleVMToHostHW = $false  
}  
Install-Appliance @installAzureLocalParams -Verbose  
```

> [!NOTE]
> Install the appliance on the first machine (seed node) to ensure Azure Local deploys correctly. The setup takes a few hours and must finish successfully before you move on. Once it’s complete, you’ll have a local control plane running in your datacenter.

If the installation fails due to incorrect network, identity, or observability settings, update the configuration object and re-run the `Install-appliance` command

Here's an example via a configuration object:

1. Modify the configuration object.

  ```powershell
  $ingressNetworkConfiguration.IngressIpAddress = '192.168.200.115'
  ```

2. Set `$installAzureLocalParams` and Re-run the `Install-appliance` as shown in [Install and configure the appliance](#install-and-configure-the-appliance).


## Configure observability for diagnostics and support

We recommend that you configure observability to get telemetry and logs for support for your first deployment. This doesn't apply if you're planning to run air-gapped, as telemetry and diagnostics require connectivity.

The Azure resources needed:

- A resource group in Azure used for the appliance.
- A Service Principal Name (SPN) with contributor rights on the resource group.

To configure observability, follow these steps:

1. On a computer with Azure CLI (or using the Azure Cloud Shell in Azure portal) create the SPN. Run the following script:

    ```powershell
    $resourcegroup = ‘azure-disconnectedoperations’
    $appname = ‘azlocalobsapp’
    az login
    $g = (az group create -n $resourcegroup -l eastus)|ConvertFrom-Json
    az ad sp create-for-rbac -n $appname --role Owner --scopes $g.id
    
    # get the subscription id
    $j = (az account list|ConvertFrom-Json)|Where-object { $_.IsDefault}
    
    # SubscriptionID:
    $j.id
    ```

    Here's an example output:

    ```json
    {
      "appId": "f9c68c7b-0df2-4b3a-9833-3cfb41c6f829",
      "displayName": "azlocalobsapp",
      "password": "<RETRACTED>",
      "tenant": "<RETRACTED>"
    }
    <subscriptionID>
    ```

2. Set the observability configuration. Modify to match your environment details:

    ```powershell
    $observabilityConfiguration = New-ApplianceObservabilityConfiguration -ResourceGroupName "azure-disconnectedoperations" `
      -TenantId "<TenantID>" `
      -Location "<Location>" `
      -SubscriptionId "<subscriptionId>" `
      -ServicePrincipalId "<AppId>" `
      -ServicePrincipalSecret ("<Password>"|ConvertTo-SecureString -AsPlainText -Force)

    Set-ApplianceObservabilityConfiguration -ObservabilityConfiguration $observabilityConfiguration
    ```

3. Verify that observability is configured:

    ```powershell
    Get-ApplianceObservabilityConfiguration
    ```

## Deploy Azure Local

In this section, verify the installation and create local Azure resources.

1. Sign in with the root operator you defined during the deployment.
2. From a client with network access to your Ingress IP, open your browser and go to `https://portal.FQDN` (replace FQDN with your domain name)
    - You should be redirected to your identity provider to sign in.
3. Sign in to your identity provider using the credentials you configured during the deployment.
    - You should see a familiar Azure portal running in your network.

### Create resource group SPN for cluster  

Use the operator account to create an SPN for Arc initialization of each Azure Local node. To create the SPN, follow these steps:

1. Configure CLI on your client machine and run this command:

    ```azurecli  
    $resourcegroup = ‘azurelocal-disconnected-operations’  
    $appname = ‘azlocalclusapp’  
    az cloud set -n 'azure.local'
    az login  
    $g = (az group create -n $resourcegroup -l autonomous)|ConvertFrom-Json  
    az ad sp create-for-rbac -n $appname --role Owner --scopes $g.id  
    ```  

    Here's an example output:

    ```json  
    {  
      "appId": "f9c68c7b-0df2-4b3a-9833-3cfb41c6f829",  
      "displayName": "azlocalclusapp",  
      "password": "<RETRACTED>",  
      "tenant": "<RETRACTED>"  
    }  

2. Copy out the AppID and password for use in the next step.

    > [!NOTE]
    > Plan the subscription and resource group where you want to place your nodes and cluster. The resource move action isn't supported.
    >
    > The cluster resource created during deployment is used for workloads like VMs and Azure Kubernetes Services, so plan your role-based access controls accordingly.
    >
    > Don't place the cluster resource in the operator subscription, unless you plan to restrict this to only operators with full access to other operations. You can create more subscriptions or place it in the starter subscription.

### Initialize each node  

To initialize each node, follow these steps. Modify where necessary to match your environment details:

1. [Install and configure the CLI](disconnected-operations-cli.md) with your local endpoint on each node. Ensure that you run initialization on the first machine before moving on to other nodes.

2. Set the configuration variable. Define the resource group, cloud name, configuration path, application ID, client secret, and appliance FQDN.

    ```azurecli
    $resourcegroup = 'azurelocal-disconnected-operations' # Needs to match the cloud name your configured CLI with.
    $applianceCloudName = "azure.local"
    $applianceConfigBasePath = "C:\AzureLocalDisconnectedOperations\"
    $appId = 'guid'
    $clientSecret = 'retracted'
    $applianceFQDN = "autonomous.cloud.private"
    ```

3. Initialize each node.

    ```azurecli
    Write-Host "az login to Disconnected operations cloud"
    az cloud set -n $applianceCloudName --only-show-errors
    az login --service-principal --username $appId --password $clientSecret --tenant 98b8267d-e97f-426e-8b3f-7956511fd63f    
    Write-Host "Connected to Disconnected operations Cloud through az cli"
    ```

4. Get the access token, account ID, subscription ID, and tenant ID.

    ```azurecli
    $applianceAccessToken = ((az account get-access-token) | ConvertFrom-Json).accessToken
    $applianceAccountId = $(New-Guid).Guid
    $applianceSubscriptionId = ((az account show) | ConvertFrom-Json).id
    $applianceTenantId = ((az account show) | ConvertFrom-Json).tenantId
    ```

5. Get the cloud configuration details.

    ```azurecli
    $cloudConfig = (az cloud show --n $applianceCloudName | ConvertFrom-Json)
    ```

6. Set the environment parameters. Define the environment parameters using the retrieved cloud configuration.

    ```azurecli
    $applianceEnvironmentParams = @{
    Name                                      = $applianceCloudName
    ActiveDirectoryAuthority                  = $cloudConfig.endpoints.activeDirectory
    ActiveDirectoryServiceEndpointResourceId  = $cloudConfig.endpoints.activeDirectoryResourceId
    GraphEndpoint                             = $cloudConfig.endpoints.activeDirectoryGraphResourceId
    MicrosoftGraphEndpointResourceId          = $cloudConfig.endpoints.microsoftGraphResourceId
    ResourceManagerEndpoint                   = $cloudConfig.endpoints.resourceManager
    StorageEndpoint                           = $cloudConfig.suffixes.storageEndpoint
    AzureKeyVaultDnsSuffix                    = $cloudConfig.suffixes.keyvaultDns
    ContainerRegistryEndpointSuffix           = $cloudConfig.suffixes.acrLoginServerEndpoint
    }
    Add-AzEnvironment @applianceEnvironmentParams -ErrorAction Stop | Out-Null
    Write-Host "Added azure.local Environment"
    ```

7. Set the configuration hash.

    ```azurecli
    Write-Host "Setting azure.local configurations"
    $hash = @{
    AccountID        = $applianceAccountId
    ArmAccessToken   = $applianceAccessToken
    Cloud            = $applianceCloudName
    ErrorAction      = 'Stop'
    Region           = 'Autonomous'
    ResourceGroup    = $resourcegroup
    SubscriptionID   = $applianceSubscriptionId
    TenantID         = $applianceTenantId
    Force            = $true
    CloudFqdn        = $applianceFQDN
    }
    ```

8. Arc-enable each node and install extensions to prepare for cloud deployment and cluster creation.

    ```azurecli
    Invoke-AzStackHciArcInitialization @hash
    Write-Host -Subject 'ARC node configuration completed'
    ```
  
    > [!NOTE]  
    > These nodes appear in the local portal shortly after you run the steps, and the extensions appear on the nodes a few minutes after installation.  
    
### For Air-gapped/disconnected deployments 
You  need to do the following on each node, to enable Azure Local to be deployed fully disconnected. 

- Add the following environment variable, by running the following:
```powershell
 [Environment]::SetEnvironmentVariable("NUGET_CERT_REVOCATION_MODE", "offline", [System.EnvironmentVariableTarget]::Machine)
```
- Configure the timeserver to use e.g. your domain controller. Modify the script below and run from Powershell:
```powershell
w32tm /config /manualpeerlist:"dc.contoso.com" /syncfromflags:manual /reliable:yes /update
net stop w32time
net start w32time
w32tm /resync /rediscover
# Check your NTP settings
w32tm /query /peers
```
### Create the Azure Local instance (cluster)

Congratulations! You've completed all the prerequisites to deploy Azure Local with a fully air-gapped local control plane.

Follow these steps to create an Azure Local instance (cluster):

1. Access the local portal from a browser of your choice.
2. Navigate to `portal.FQDN`. For example, `https://portal.autonomous.cloud.private`
3. Select your nodes and complete the deployment steps outlined in [Deploy Azure Local using the Azure portal](../deploy/deploy-via-portal.md).  

  > [!NOTE]
  > If you create Azure Key Vault during deployment, wait about 20 minutes for RBAC permissions to take effect.
  > 
  > If you see a validation error, it’s a known issue. Permissions may still be propagating. Wait a bit, refresh your browser, and redeploy the cluster.

## Post-deployment tasks

Here are some tasks you can perform after deploying Azure Local with disconnected operations:

1. Back up the BitLocker keys. This encrypts your volumes and lets you recover the appliance if you ever need to restore the VM. For more information, see [Understand security controls with disconnected operations on Azure Local](disconnected-operations-security.md).
1. Assign extra operators. You can assign one or many operators by navigating to **Operator subscriptions**. Assign the **contributor** role at the subscription level.  
<!--1. Create more subscriptions. You can create more subscriptions by navigating to **Subscriptions** in the portal and selecting **Create**. You can also use the CLI to automate subscription creation.

    To create subscriptions using the CLI, use these commands:  

    ```azurecli  
    az config set core.instance_discovery=false  
    az extension add --name account  
    az account alias create --name "azlocalnewsub" --billing-scope null --display-name "Azure Local subscription 2" --workload "Production"  
    az account alias show --name "azlocalnewsub"  
    ```  

    To list subscriptions using the CLI, use this command:  

    ```azurecli  
    az account subscription list -o table 
    ```-->

## Troubleshoot and reconfigure using management endpoint

To use the management endpoint for troubleshooting and reconfiguration, you need the management IP address used during deployment, along with the client certificate and password used to secure the endpoint.

From a client with network access to the management endpoint, import the **OperationsModule** and set the context (modify the script to match your configuration):

```powershell  
Import-Module "C:\azurelocal\OperationsModule\Azure.Local.DisconnectedOperations.psd1" -Force  
$password = ConvertTo-SecureString “RETRACTED” -AsPlainText -Force  
$context = Set-DisconnectedOperationsClientContext -ManagementEndpointClientCertificatePath "${env:localappdata}\AzureLocalOpModuleDev\certs\ManagementEndpoint\ManagementEndpointClientAuth.pfx" -ManagementEndpointClientCertificatePassword $password -ManagementEndpointIpAddress "169.254.53.25"  
```  

After setting the context, you can use all the management cmdlets provided by the Operations module, like resetting identity configuration, checking health state, and more.

To get a full list of cmdlets provided, use the PowerShell `Get-Command -Module OperationsModule`. To get details around each cmdlet, use the `Get-Help <cmdletname>` command.

### Troubleshoot: System not configured

After you install the appliance, you might see this screen for a while. Let the configuration take 2-3 hours. After you wait an adequate time (2-3 hours), the screen should go away, and you should see the regular Azure portal. If the screen doesn't go away and you can't access the local Azure portal, you need to do some troubleshooting.

:::image type="content" source="./media/disconnected-operations/deployment/system-not-configured.png" alt-text="Screenshot showing the system isn't configured page." lightbox=" ./media/disconnected-operations/deployment/system-not-configured.png":::

- To find logs from the **OperationsModule** on the first machine, go to `C:\ProgramData\Microsoft\AzureLocalDisconnectedOperations\Logs`.

- To view the health state of your appliance, use the management endpoint `Get-ApplianceHealthState` cmdlet. If you see this screen and the cmdlet reports no errors and all services report 100, you need to open a support ticket from the Azure portal.

::: moniker-end

::: moniker range="<=azloc-24111"

This feature is available only in Azure Local 2411.2.

::: moniker-end
